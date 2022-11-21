
module nco_45(
    input CK,
    input START,
    input [8:0] v_pos,
    output reg signed [17:0] cos0, sin0, cos1, sin1
);
    reg [2:0] counter = 0;
    wire ce = ~counter[2];
    wire [10:0] addr = {v_pos, counter[1:0]};
    wire [17:0] dataout;
    nco_rom rom( .clock(CK),  .ce(ce), .oce(1'd1), .reset(1'b0), .addr(addr), .dataout(dataout));

    reg signed [17:0] cos0r = 0, sin0r = 0;
    reg signed [17:0] cos1r = 0;
    reg signed [17:0] sin1r = 0;
    // wire signed [34:0] cos0w, sin0w, cos1w, sin1w;
    reg signed [17:0] cosd;
    reg signed [17:0] sind;

    always @ (posedge CK) begin
        if( START ) begin
            counter <= 3'd0;
        end else if (counter != 5) begin
            counter <= counter+3'd1;
        end
    end
    wire signed [34:0] cos0w = (cos0*cosd - sin0*sind);
    wire signed [34:0] sin0w = (sin0*cosd + cos0*sind);
    wire signed [34:0] cos1w = (cos1*cosd - sin1*sind);
    wire signed [34:0] sin1w = (sin1*cosd + cos1*sind);
    always@(posedge CK) begin
        if ( counter == 0 ) begin
        end else if (counter == 1) begin
            cosd <= dataout; // rom[adr,0]
            cos0 <= 18'h1ffff; // fixedpoint nearly one
        end else if (counter == 2) begin
            sind <= dataout; // rom[adr,1]
            sin0 <= 18'h00000; // Zero
        end else if (counter == 3) begin
            cos1 <= dataout; // rom[adr,2]
        end else if (counter == 4) begin
            sin1 <= dataout; // rom[adr,3]
        end else begin
            cos0 <= cos0w>>>17;
            sin0 <= sin0w>>>17;
            cos1 <= cos1w>>>17;
            sin1 <= sin1w>>>17;
        end
    end
endmodule

/*
module nco_45_backup(
    input CK,
    input START,
    input [8:0] v_pos,
    output signed [17:0] cos0, sin0, cos1, sin1
);
    reg [2:0] counter = 0;
    wire ce = ~counter[2];
    wire [10:0] addr = {v_pos, counter[1:0]};
    wire [17:0] dataout;
    nco_rom rom( .clock(CK),  .ce(ce), .oce(1'd1), .reset(1'b0), .addr(addr), .dataout(dataout));
    reg signed [35:0] cos0r, sin0r, cos1r, sin1r;
    reg signed [17:0] cosd,  sind;
    always @ (posedge CK) begin
        if( START ) begin
            counter <= 3'd0;
        end else if (counter != 5) begin
            counter <= counter+3'd1;
        end
    end
    always@(posedge CK) begin
        if ( counter == 0 ) begin
        end else if (counter == 1) begin
            cosd <= dataout; // rom[adr,0]
            cos0r <= 36'h3ffffffff; // fixedpoint nearly one
        end else if (counter == 2) begin
            sind <= dataout; // rom[adr,1]
            sin0r <= 36'h000000000; // Zero
        end else if (counter == 3) begin
            cos1r <= {dataout[17],dataout,17'b0}; // rom[adr,2]
        end else if (counter == 4) begin
            sin1r <= {dataout[17],dataout,17'b0}; // rom[adr,3]
        end else begin
            cos0r <= cos0*cosd - sin0*sind;
            sin0r <= sin0*cosd + cos0*sind;
            cos1r <= cos1*cosd - sin1*sind;
            sin1r <= sin1*cosd + cos1*sind;
        end
    end
    assign cos0 = (cos0r>>>17);
    assign sin0 = (sin0r>>>17);
    assign cos1 = (cos1r>>>17);
    assign sin1 = (sin1r>>>17);
endmodule
*/

module nco_45_tb_main();
    reg CK = 0;
    always #4 CK = ~CK;

    localparam bits = 20;
    reg [19:0] theta = 0;
    reg [31:0] count = 0;
    wire signed [17:0] cos0;

    wire signed [17:0] sin0;
    wire signed [17:0] cos1;
    wire signed [17:0] sin1;
    reg signed [35:0] test0 = 0;
    reg signed [17:0] testd = 0;
    wire signed [17:0] test = {test0[35],test0[33:17]};
    wire start = (count<2); 
    always@(posedge CK) begin
        if( start ) begin
            test0 <= 36'h7_ffff_ffff;
            testd <= 18'h1_ffff;
        end else begin
            test0 <= test*testd;
        end
    end

    nco_45_new nco( .CK(CK), .START(start), .v_pos(9'd0),
         .cos0(cos0), .sin0(sin0), .cos1(cos1), .sin1(sin1) );
    always@(posedge CK) begin
        // $monitor ( (16'hff)*(16'hff) );
        count <= count+1;
        if ( 128*4 < count ) $finish;
    end
    initial begin
        $dumpfile( "nco_45.vcd" );
        $dumpvars( -1, CK, start, test, test0, testd, cos0, sin0, cos1, sin1, count,
            nco.dataout, nco.counter, nco.cos0, nco.sin0, nco.cos1, nco.sin1, nco.cosd, nco.sind );
    end
endmodule

