
module cordic(
        input CLK,
        input [19:0] theta, // 0x00000=0rad, 0x80000=pirad, 0xfffff=nearly 2pirad
        output wire [17:0] cosout,
        output wire [17:0] sinout // {sign[1],fraction[17], 2's complement
    ); 
    reg signed [18:0] re [0:19];
    reg signed [18:0] im [0:19];
    reg signed [21:0] th [0:19];
    reg negate [0:20];
    reg signed [21:0] atan_tbl [0:19];
    initial begin
        atan_tbl[ 0]=22'h20000; atan_tbl[ 1]=22'h12e40; atan_tbl[ 2]=22'h9fb4; atan_tbl[ 3]=22'h5111;
        atan_tbl[ 4]= 22'h28b1; atan_tbl[ 5]= 22'h145d; atan_tbl[ 6]= 22'ha2f; atan_tbl[ 7]= 22'h518;
        atan_tbl[ 8]=  22'h28c; atan_tbl[ 9]=  22'h146; atan_tbl[10]=  22'ha3; atan_tbl[11]=  22'h51;
        atan_tbl[12]=   22'h29; atan_tbl[13]=   22'h14; atan_tbl[14]=   22'ha; atan_tbl[15]=   22'h5;
        atan_tbl[16]=    22'h3; atan_tbl[17]=    22'h1; atan_tbl[18]=   22'h1; atan_tbl[19]=   22'h0;
    end
    always@(posedge CLK) begin
        re[0] <= 20'h136e5; //  re[0]=20'h1b7ae;//  start at pi/4
        im[0] <= 20'd0;                   // im[0]=20'h1b7ae;// 
        th[0] <= $signed(theta[18:0]);
        negate[0] <= (theta[19]!=theta[18]);
    end
    genvar i;
    localparam loop_stop = 15;
    for( i = 0; i < loop_stop; i=i+1 ) begin: cordic_parallel_for
        always@(posedge CLK) begin // USE >>> arithmetic shift
            re[i+1] <= $signed(re[i]) - $signed((th[i][21]!=0) ? -(im[i]>>>i)  :(im[i]>>>i));
            im[i+1] <= $signed(im[i]) + $signed((th[i][21]!=0) ? -(re[i]>>>i)  :(re[i]>>>i));
            th[i+1] <= $signed(th[i]) - $signed((th[i][21]!=0) ? -(atan_tbl[i]):(atan_tbl[i]));
            negate[i+1] <= negate[i];
        end
    end
    reg signed [19:0] costmp=0, sintmp=0; 
    always@(posedge CLK) costmp <= negate[loop_stop] ? -re[loop_stop] : re[loop_stop];
    always@(posedge CLK) sintmp <= negate[loop_stop] ? -im[loop_stop] : im[loop_stop];
    assign cosout = { costmp[18], costmp[16:0] };
    assign sinout = { sintmp[18], sintmp[16:0] };
endmodule


module cordic_tb_main();
    reg CLK = 0;
    always #4 CLK = ~CLK;
    localparam bits = 20;
    reg [19:0] theta = 0;
    reg [bits+2-1:0] count = 0;
    wire signed [17:0] cosout;
    wire signed [17:0] sinout;
    cordic co( .CLK(CLK), .theta(theta), .cosout(cosout), .sinout(sinout) );
    always@(posedge CLK) begin
        theta <= theta + (1<<(bits-12));
        // theta <= 22'h40000;
        count <= count + 1;
        if ( (1<<12)+64 < count ) $finish;
    end
    initial begin
        $dumpfile( "cordic.vcd" );
        $dumpvars( -1, CLK, count, theta, cosout, sinout,
            co.th[0], co.th[1], co.th[2], co.th[3], co.th[4], co.th[5], co.th[6], co.th[7],
            co.re[0], co.re[1], co.re[2], co.re[3], co.re[4], co.re[5], co.re[6], co.re[7],
            co.im[0], co.im[1], co.im[2], co.im[3], co.im[4], co.im[5], co.im[6], co.im[7],
            co.negate[0], co.negate[1], co.negate[2], co.negate[3],
            co.negate[4], co.negate[5], co.negate[6], co.negate[7] );
    end
endmodule

