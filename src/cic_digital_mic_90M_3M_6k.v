
// 0.5*((3MHz/6kHz)^3)

module cic_digital_mic_90M_3M_6k( input wire CLK, output mic_clk, input wire mic_data,
                                output wire [17:0] o_data0, output wire o_vld, output wire [5:0] o_range_over, input wire RST );
    //reg [31:0] fake_count = 0;
    reg signed [31:0] data0I1=0, data0D0=0, data0B1=0;
    reg signed [31:0] data0I2=0, data0D1=0, data0B2=0;
    reg signed [31:0] data0I3=0, data0D2=0, data0B3=0;
    reg [4:0] mic_count=0;
    localparam mic_count_stop = 5'd15; // 90MHz/6MHz
    wire mic_count_isend = (mic_count==mic_count_stop-1);
    reg [9:0] data_count=0;
    localparam data_count_stop = 10'd1000; // (6MHz/6kHz)
    wire data_count_isend = (data_count==data_count_stop-1);
    always@(posedge CLK) mic_count <= mic_count_isend ? 0 : mic_count+1;
    always@(posedge CLK) if(mic_count_isend) data_count <= data_count_isend ? 0 : data_count+1;
    assign mic_clk = data_count[0]; // flip 6MHz -> 3MHz, mic clock is 3MHz
    always@(posedge CLK) if(mic_count_isend&&mic_clk) begin
        data0I1 <= data0I1 + mic_data;
        //data0I1 <= data0I1 + (fake_count[0] == 0);
        //fake_count <= fake_count+1;
        data0I2 <= data0I2 + data0I1;
        data0I3 <= data0I3 + data0I2;
    end
    always@(posedge CLK) if(mic_count_isend&&data_count_isend) begin // (6MHz/6kHz)-1
        data0B3 <= data0I3; data0D2 <= data0I3 - data0B3;
        data0B2 <= data0D2; data0D1 <= data0D2 - data0B2;
        data0B1 <= data0D1; data0D0 <= data0D1 - data0B1;
    end
    reg o_vld0 = 0;
    always@(posedge CLK) o_vld0 <= (mic_count_isend&&data_count_isend);
    wire signed [31:0] o_low_cut;
    wire o_low_cut_vld;
    low_cut lc( .CLK(CLK), .i_vld( o_vld0 ), .i_data( data0D0 ), .o_vld( o_low_cut_vld ), .o_data( o_low_cut ));
    wire o_agc_valid;
    wire [17:0] o_agc_data;
    simple_AGC agc( .CLK(CLK), .i_vld(o_low_cut_vld), .i_data(o_low_cut), .o_vld(o_agc_vld), .o_data(o_agc_data), 
        .o_range_over(o_range_over), .RST(RST) );
    assign o_data0 = $signed(o_agc_data); // NEEDS AGC LATER
    assign o_vld = o_agc_vld;
 endmodule

module low_cut( input CLK, input i_vld, input [31:0] i_data, output o_vld, output [31:0] o_data );    
    reg signed [39:0] avr = 0;
    reg signed [31:0] o_reg = 0;
    always@(posedge CLK) if( i_vld ) o_reg <= $signed($signed(i_data)-$signed(avr[39:8]));
    reg vld1 = 0;
    always@(posedge CLK) vld1 <= i_vld;
    always@(posedge CLK) if( vld1 ) avr <= $signed(avr) + $signed(o_reg);
    assign o_data = o_reg;
    assign o_vld = vld1;
endmodule

module simple_AGC( input CLK, input i_vld, input signed [33:0] i_data,
                    output o_vld, output signed [17:0] o_data, output [5:0] o_range_over, input RST );

    reg [12:0] g_counter = 0;
    always@(posedge CLK) if(vld4) g_counter <= range_over ? 0 : g_counter+1;

    reg [3:0] shift = 4'h2;

    always@(posedge CLK) if(vld4) begin
        shift <= RST ? 0 : 
                 (range_over ? ( shift == 4'hf ? 4'hf : shift+1 ):
                    ((g_counter == 12'hfff)? (shift==4'h0 ? 4'h0 :shift-1 ) : shift));
    end

    localparam in_b = 34;
    localparam out_b = 18;
    localparam d0_b = out_b + 15 + 1; // outb + shift_bits + overflow
    localparam omit_b = 0; // lower bits to be negledted
    wire [d0_b-1:0] d0n = {i_data[in_b-1],&i_data[in_b-2:d0_b-2+omit_b],i_data[d0_b-3+omit_b:omit_b]};
    wire [d0_b-1:0] d0p = {i_data[in_b-1],|i_data[in_b-2:d0_b-2+omit_b],i_data[d0_b-3+omit_b:omit_b]};
    reg signed [d0_b-1:0] d0;
    always@(posedge CLK) if(i_vld) d0 <= i_data[in_b-1] ?
                {i_data[in_b-1],&i_data[in_b-2:d0_b-2+omit_b],i_data[d0_b-3+omit_b:omit_b]}:
                {i_data[in_b-1],|i_data[in_b-2:d0_b-2+omit_b],i_data[d0_b-3+omit_b:omit_b]};
    reg vld0 = 0;
    always@(posedge CLK) vld0 <= i_vld;

    localparam d1_b = out_b + 7 + 1;
    wire [d1_b-1:0] d1n = shift[3] ? { d0[d0_b-1], &d0[d0_b-2:d1_b-2+8], d0[d1_b-2-1+8:8]}:
                                     { d0[d0_b-1], &d0[d0_b-2:d1_b-2+0], d0[d1_b-2-1+0:0]};
    wire [d1_b-1:0] d1p = shift[3] ? { d0[d0_b-1], |d0[d0_b-2:d1_b-2+8], d0[d1_b-2-1+8:8]}:
                                     { d0[d0_b-1], |d0[d0_b-2:d1_b-2+0], d0[d1_b-2-1+0:0]};
    reg [d1_b-1:0] d1;
    always@(posedge CLK) if(vld0) d1 <= d0[d0_b-1] ? d1n : d1p;
    reg vld1 = 0;
    always@(posedge CLK) vld1 <= vld0;

    localparam d2_b = out_b + 3 + 1;
    wire [d2_b-1:0] d2n = shift[2] ? { d1[d1_b-1], &d1[d1_b-2:d2_b-2+4], d1[d2_b-2-1+4:4]}:
                                     { d1[d1_b-1], &d1[d1_b-2:d2_b-2+0], d1[d2_b-2-1+0:0]};
    wire [d2_b-1:0] d2p = shift[2] ? { d1[d1_b-1], |d1[d1_b-2:d2_b-2+4], d1[d2_b-2-1+4:4]}:
                                     { d1[d1_b-1], |d1[d1_b-2:d2_b-2+0], d1[d2_b-2-1+0:0]};
    reg [d2_b-1:0] d2;
    always@(posedge CLK) if(vld1) d2 <= d1[d1_b-1] ? d2n : d2p;
    reg vld2 = 0;
    always@(posedge CLK) vld2 <= vld1;

    localparam d3_b = out_b + 1 + 1;
    wire [d3_b-1:0] d3n = shift[1] ? { d2[d2_b-1], &d2[d2_b-2:d3_b-2+2], d2[d3_b-2-1+2:2]}:
                                     { d2[d2_b-1], &d2[d2_b-2:d3_b-2+0], d2[d3_b-2-1+0:0]};
    wire [d3_b-1:0] d3p = shift[1] ? { d2[d2_b-1], |d2[d2_b-2:d3_b-2+2], d2[d3_b-2-1+2:2]}:
                                     { d2[d2_b-1], |d2[d2_b-2:d3_b-2+0], d2[d3_b-2-1+0:0]};
    reg [d3_b-1:0] d3;
    always@(posedge CLK) if(vld2) d3 <= d2[d2_b-1] ? d3n : d3p;
    reg vld3 = 0;
    always@(posedge CLK) vld3 <= vld2;

    localparam d4_b = out_b + 0 + 1;
    wire [d4_b-1:0] d4n = shift[0] ? { d3[d3_b-1], &d3[d3_b-2:d4_b-2+1], d3[d4_b-2-1+1:1]}:
                                     { d3[d3_b-1], &d3[d3_b-2:d4_b-2+0], d3[d4_b-2-1+0:0]};
    wire [d4_b-1:0] d4p = shift[0] ? { d3[d3_b-1], |d3[d3_b-2:d4_b-2+1], d3[d4_b-2-1+1:1]}:
                                     { d3[d3_b-1], |d3[d3_b-2:d4_b-2+0], d3[d4_b-2-1+0:0]};
    reg [d4_b-1:0] d4;
    always@(posedge CLK) if(vld3) d4 <= d3[d3_b-1] ? d4n : d4p;
    reg vld4 = 0;
    always@(posedge CLK) vld4 <= vld3;

    assign o_data = {d4[d4_b-1], d4[d4_b-3:0]};
    wire range_over = (d4[d4_b-1] != d4[d4_b-2]);
    assign o_vld = vld4;
    assign o_range_over = { ~range_over, 1'h1, (~shift) }; // LED is ON when zero 
endmodule


module cic_digital_mic_90M_3M_6k_tb;
    reg ck = 0;
    wire mic_clk;
    reg mic_data = 0;
    wire [17:0] o_data0;
    wire o_vld = 0;
    cic_digital_mic_90M_3M_6k cic( .CLK(ck), .mic_clk(mic_clk), .mic_data(mic_data), .o_data0(o_data0), .o_vld(o_vld) );
    always #4 ck = ~ck;
    always @(posedge mic_clk) mic_data = ~mic_data;
    reg [19:0] count = 0;
    always @(posedge mic_clk) begin
        count <= count+1;
        if ( 10000 < count ) $finish;
    end
    initial begin
        $dumpfile("cic_digital_mic_90M_3M_6k_tb.vcd");
        $dumpvars(-1, mic_clk, mic_data, o_vld, o_data0 );
    end
endmodule

