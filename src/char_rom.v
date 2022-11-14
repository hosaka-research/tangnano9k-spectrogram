

module char_rom
(
    input CK,
    input EN,
    input [3:0] chr,
    input [2:0] scany,
    output wire [5:0] out
);

    reg [5:0] dataout = 0;
    assign out = {dataout[0],dataout[1],dataout[2],dataout[3],dataout[4],dataout[5]};

    wire [6:0] addr = {1'b0, chr, scany};
    always @(posedge CK) begin
        if( EN) begin
            case( addr)
    //////////// code 0, character 0
                7'b0000_000: dataout <= 6'b001110;
                7'b0000_001: dataout <= 6'b010001;
                7'b0000_010: dataout <= 6'b010011;
                7'b0000_011: dataout <= 6'b010101;
                7'b0000_100: dataout <= 6'b011001;
                7'b0000_101: dataout <= 6'b010001;
                7'b0000_110: dataout <= 6'b001110;
                7'b0000_111: dataout <= 6'b000000;
    ///////////// code 1, character 1
                7'b0001_000: dataout <= 6'b000100;
                7'b0001_001: dataout <= 6'b001100;
                7'b0001_010: dataout <= 6'b000100;
                7'b0001_011: dataout <= 6'b000100;
                7'b0001_100: dataout <= 6'b000100;
                7'b0001_101: dataout <= 6'b000100;
                7'b0001_110: dataout <= 6'b001110;
                7'b0001_111: dataout <= 6'b000000;
    //////////// code = 2, character 2
                7'b0010_000: dataout <= 6'b001110;
                7'b0010_001: dataout <= 6'b010001;
                7'b0010_010: dataout <= 6'b000001;
                7'b0010_011: dataout <= 6'b000010;
                7'b0010_100: dataout <= 6'b000100;
                7'b0010_101: dataout <= 6'b001000;
                7'b0010_110: dataout <= 6'b011111;
                7'b0010_111: dataout <= 6'b000000;
    //////////// code = 3, character 3
                7'b0011_000: dataout <= 6'b001110;
                7'b0011_001: dataout <= 6'b010001;
                7'b0011_010: dataout <= 6'b000001;
                7'b0011_011: dataout <= 6'b000110;
                7'b0011_100: dataout <= 6'b000001;
                7'b0011_101: dataout <= 6'b011001;
                7'b0011_110: dataout <= 6'b001111;
                7'b0011_111: dataout <= 6'b000000;

    //////////// code =4, character 4
                7'b0100_000: dataout <= 6'b000010;
                7'b0100_001: dataout <= 6'b000110;
                7'b0100_010: dataout <= 6'b001010;
                7'b0100_011: dataout <= 6'b010010;
                7'b0100_100: dataout <= 6'b011111;
                7'b0100_101: dataout <= 6'b000010;
                7'b0100_110: dataout <= 6'b000010;
                7'b0100_111: dataout <= 6'b000000;
    //////////// code = 5, character 5
                7'b0101_000: dataout <= 6'b011111;
                7'b0101_001: dataout <= 6'b010000;
                7'b0101_010: dataout <= 6'b010000;
                7'b0101_011: dataout <= 6'b011110;
                7'b0101_100: dataout <= 6'b000001;
                7'b0101_101: dataout <= 6'b000001;
                7'b0101_110: dataout <= 6'b011110;
                7'b0101_111: dataout <= 6'b000000;
    //////////// code = 6, character 6
                7'b0110_000: dataout <= 6'b000011;
                7'b0110_001: dataout <= 6'b000100;
                7'b0110_010: dataout <= 6'b001000;
                7'b0110_011: dataout <= 6'b011110;
                7'b0110_100: dataout <= 6'b010001;
                7'b0110_101: dataout <= 6'b010001;
                7'b0110_110: dataout <= 6'b001110;
                7'b0110_111: dataout <= 6'b000000;
    ////////// code = 7, character 7
                7'b0111_000: dataout <= 6'b011111;
                7'b0111_001: dataout <= 6'b010001;
                7'b0111_010: dataout <= 6'b000001;
                7'b0111_011: dataout <= 6'b000010;
                7'b0111_100: dataout <= 6'b000100;
                7'b0111_101: dataout <= 6'b001000;
                7'b0111_110: dataout <= 6'b010000;
                7'b0111_111: dataout <= 6'b000000;
    //////////// code = 8, character 8
                7'b1000_000: dataout <= 6'b001110;
                7'b1000_001: dataout <= 6'b010001;
                7'b1000_010: dataout <= 6'b010001;
                7'b1000_011: dataout <= 6'b011110;
                7'b1000_100: dataout <= 6'b010001;
                7'b1000_101: dataout <= 6'b010001;
                7'b1000_110: dataout <= 6'b001110;
                7'b1000_111: dataout <= 6'b000000;
    //////////// code = 9, character '9'
                7'b1001_000: dataout <= 6'b001110;
                7'b1001_001: dataout <= 6'b010001;
                7'b1001_010: dataout <= 6'b010001;
                7'b1001_011: dataout <= 6'b001111;
                7'b1001_100: dataout <= 6'b000010;
                7'b1001_101: dataout <= 6'b000100;
                7'b1001_110: dataout <= 6'b011000;
                7'b1001_111: dataout <= 6'b000000;
    //////////// code = 10, character 'H'
                7'b1010_000: dataout <= 6'b010001;
                7'b1010_001: dataout <= 6'b010001;
                7'b1010_010: dataout <= 6'b010001;
                7'b1010_011: dataout <= 6'b011111;
                7'b1010_100: dataout <= 6'b010000;
                7'b1010_101: dataout <= 6'b010001;
                7'b1010_110: dataout <= 6'b010001;
                7'b1010_111: dataout <= 6'b010000;
    //////////// code = 11, character 'z'
                7'b1011_000: dataout <= 6'b000000;
                7'b1011_001: dataout <= 6'b000000;
                7'b1011_010: dataout <= 6'b000000;
                7'b1011_011: dataout <= 6'b011111;
                7'b1011_100: dataout <= 6'b000010;
                7'b1011_101: dataout <= 6'b000100;
                7'b1011_110: dataout <= 6'b001000;
                7'b1011_111: dataout <= 6'b011111;
    //////////// code = 12, character 'k'
                7'b1101_000: dataout <= 6'b010000;
                7'b1101_001: dataout <= 6'b010000;
                7'b1101_010: dataout <= 6'b010011;
                7'b1101_011: dataout <= 6'b010100;
                7'b1101_100: dataout <= 6'b011000;
                7'b1101_101: dataout <= 6'b010100;
                7'b1101_110: dataout <= 6'b010011;
                7'b1101_111: dataout <= 6'b000000;
    //////////// code = 14, character '.'
                7'b1110_000: dataout <= 6'b000000;
                7'b1110_001: dataout <= 6'b000000;
                7'b1110_010: dataout <= 6'b000000;
                7'b1110_011: dataout <= 6'b000000;
                7'b1110_100: dataout <= 6'b000000;
                7'b1110_101: dataout <= 6'b000110;
                7'b1110_110: dataout <= 6'b000110;
                7'b1110_111: dataout <= 6'b000000;
    //////////// code = 15, character ' '
                7'b1111_000: dataout <= 6'b000000;
                7'b1111_001: dataout <= 6'b000000;
                7'b1111_010: dataout <= 6'b000000;
                7'b1111_011: dataout <= 6'b000000;
                7'b1111_100: dataout <= 6'b000000;
                7'b1111_101: dataout <= 6'b000000;
                7'b1111_110: dataout <= 6'b000000;
                7'b1111_111: dataout <= 6'b000000;
            endcase
        end
    end
endmodule

module char_map
(
    input CK, input EN,
    input [3:0] ychr, input [2:0] xchr,
    output [3:0] chr
);
reg [3:0] chrreg;
assign chr = chrreg;
wire [6:0] addr = {ychr, xchr};

    always @(posedge CK) begin
        if (EN) begin
            case( addr)
                7'b0000_000: chrreg<= 4'h2; // position  0 '2200'
                7'b0000_001: chrreg<= 4'h2;
                7'b0000_010: chrreg<= 4'h0;
                7'b0000_011: chrreg<= 4'h0;
                7'b0001_000: chrreg<= 4'h2; // position  1 '2000'
                7'b0001_001: chrreg<= 4'h0;
                7'b0001_010: chrreg<= 4'h0;
                7'b0001_011: chrreg<= 4'h0;
                7'b0010_000: chrreg<= 4'h1; // position  2 '1800'
                7'b0010_001: chrreg<= 4'h8;
                7'b0010_010: chrreg<= 4'h0;
                7'b0010_011: chrreg<= 4'h0;
                7'b0011_000: chrreg<= 4'h1; // position  3 '1600'
                7'b0011_001: chrreg<= 4'h6;
                7'b0011_010: chrreg<= 4'h0;
                7'b0011_011: chrreg<= 4'h0;

                7'b0100_000: chrreg<= 4'h1; // position  4 '1400'
                7'b0100_001: chrreg<= 4'h4;
                7'b0100_010: chrreg<= 4'h0;
                7'b0100_011: chrreg<= 4'h0;
                7'b0101_000: chrreg<= 4'h1; // position  5 '1200'
                7'b0101_001: chrreg<= 4'h2;
                7'b0101_010: chrreg<= 4'h0;
                7'b0101_011: chrreg<= 4'h0;
                7'b0110_000: chrreg<= 4'h1; // position  6 '1000'
                7'b0110_001: chrreg<= 4'h0;
                7'b0110_010: chrreg<= 4'h0;
                7'b0110_011: chrreg<= 4'h0;
                7'b0111_000: chrreg<= 4'hf; // position  7 ' 800'
                7'b0111_001: chrreg<= 4'h8;
                7'b0111_010: chrreg<= 4'h0;
                7'b0111_011: chrreg<= 4'h0;

                7'b1000_000: chrreg<= 4'hf; // position  8 ' 600'
                7'b1000_001: chrreg<= 4'h6;
                7'b1000_010: chrreg<= 4'h0;
                7'b1000_011: chrreg<= 4'h0;
                7'b1001_000: chrreg<= 4'hf; // position  9 ' 400'
                7'b1001_001: chrreg<= 4'h4;
                7'b1001_010: chrreg<= 4'h0;
                7'b1001_011: chrreg<= 4'h0;
                7'b1010_000: chrreg<= 4'hf; // position 10 ' 200'
                7'b1010_001: chrreg<= 4'h2;
                7'b1010_010: chrreg<= 4'h0;
                7'b1010_011: chrreg<= 4'h0;
                7'b1011_000: chrreg<= 4'hf; // position 11 '   0'
                7'b1011_001: chrreg<= 4'hf;
                7'b1011_010: chrreg<= 4'hf;
                7'b1011_011: chrreg<= 4'h0;
                default: chrreg <= 4'hf;  // ' ' 
            endcase
        end
    end
endmodule

module char_pixgen
(
    input CK,
    input EN,
    input [8:0] y_pos,
    output [3:0] ycharpos,
    output [2:0] yline
);

reg [6:0] calc_ychr = 0;
assign yline = calc_ychr[2:0];
assign ycharpos = calc_ychr[6:3];

always @(posedge CK) begin
    if (EN) begin
        case(y_pos) 
            (480-(40*11)-9): calc_ychr <= 7'b0000_000;
            (480-(40*11)-8): calc_ychr <= 7'b0000_001;
            (480-(40*11)-7): calc_ychr <= 7'b0000_010;
            (480-(40*11)-6): calc_ychr <= 7'b0000_011;
            (480-(40*11)-5): calc_ychr <= 7'b0000_100;
            (480-(40*11)-4): calc_ychr <= 7'b0000_101;
            (480-(40*11)-3): calc_ychr <= 7'b0000_110;
            (480-(40*10)-9): calc_ychr <= 7'b0001_000;
            (480-(40*10)-8): calc_ychr <= 7'b0001_001;
            (480-(40*10)-7): calc_ychr <= 7'b0001_010;
            (480-(40*10)-6): calc_ychr <= 7'b0001_011;
            (480-(40*10)-5): calc_ychr <= 7'b0001_100;
            (480-(40*10)-4): calc_ychr <= 7'b0001_101;
            (480-(40*10)-3): calc_ychr <= 7'b0001_110;
            (480-(40* 9)-9): calc_ychr <= 7'b0010_000;
            (480-(40* 9)-8): calc_ychr <= 7'b0010_001;
            (480-(40* 9)-7): calc_ychr <= 7'b0010_010;
            (480-(40* 9)-6): calc_ychr <= 7'b0010_011;
            (480-(40* 9)-5): calc_ychr <= 7'b0010_100;
            (480-(40* 9)-4): calc_ychr <= 7'b0010_101;
            (480-(40* 9)-3): calc_ychr <= 7'b0010_110;
            (480-(40* 8)-9): calc_ychr <= 7'b0011_000;
            (480-(40* 8)-8): calc_ychr <= 7'b0011_001;
            (480-(40* 8)-7): calc_ychr <= 7'b0011_010;
            (480-(40* 8)-6): calc_ychr <= 7'b0011_011;
            (480-(40* 8)-5): calc_ychr <= 7'b0011_100;
            (480-(40* 8)-4): calc_ychr <= 7'b0011_101;
            (480-(40* 8)-3): calc_ychr <= 7'b0011_110;
            (480-(40* 7)-9): calc_ychr <= 7'b0100_000;
            (480-(40* 7)-8): calc_ychr <= 7'b0100_001;
            (480-(40* 7)-7): calc_ychr <= 7'b0100_010;
            (480-(40* 7)-6): calc_ychr <= 7'b0100_011;
            (480-(40* 7)-5): calc_ychr <= 7'b0100_100;
            (480-(40* 7)-4): calc_ychr <= 7'b0100_101;
            (480-(40* 7)-3): calc_ychr <= 7'b0100_110;
            (480-(40* 6)-9): calc_ychr <= 7'b0101_000;
            (480-(40* 6)-8): calc_ychr <= 7'b0101_001;
            (480-(40* 6)-7): calc_ychr <= 7'b0101_010;
            (480-(40* 6)-6): calc_ychr <= 7'b0101_011;
            (480-(40* 6)-5): calc_ychr <= 7'b0101_100;
            (480-(40* 6)-4): calc_ychr <= 7'b0101_101;
            (480-(40* 6)-3): calc_ychr <= 7'b0101_110;
            (480-(40* 5)-9): calc_ychr <= 7'b0110_000;
            (480-(40* 5)-8): calc_ychr <= 7'b0110_001;
            (480-(40* 5)-7): calc_ychr <= 7'b0110_010;
            (480-(40* 5)-6): calc_ychr <= 7'b0110_011;
            (480-(40* 5)-5): calc_ychr <= 7'b0110_100;
            (480-(40* 5)-4): calc_ychr <= 7'b0110_101;
            (480-(40* 5)-3): calc_ychr <= 7'b0110_110;
            (480-(40* 4)-9): calc_ychr <= 7'b0111_000;
            (480-(40* 4)-8): calc_ychr <= 7'b0111_001;
            (480-(40* 4)-7): calc_ychr <= 7'b0111_010;
            (480-(40* 4)-6): calc_ychr <= 7'b0111_011;
            (480-(40* 4)-5): calc_ychr <= 7'b0111_100;
            (480-(40* 4)-4): calc_ychr <= 7'b0111_101;
            (480-(40* 4)-3): calc_ychr <= 7'b0111_110;
            (480-(40* 3)-9): calc_ychr <= 7'b1000_000;
            (480-(40* 3)-8): calc_ychr <= 7'b1000_001;
            (480-(40* 3)-7): calc_ychr <= 7'b1000_010;
            (480-(40* 3)-6): calc_ychr <= 7'b1000_011;
            (480-(40* 3)-5): calc_ychr <= 7'b1000_100;
            (480-(40* 3)-4): calc_ychr <= 7'b1000_101;
            (480-(40* 3)-3): calc_ychr <= 7'b1000_110;
            (480-(40* 2)-9): calc_ychr <= 7'b1001_000;
            (480-(40* 2)-8): calc_ychr <= 7'b1001_001;
            (480-(40* 2)-7): calc_ychr <= 7'b1001_010;
            (480-(40* 2)-6): calc_ychr <= 7'b1001_011;
            (480-(40* 2)-5): calc_ychr <= 7'b1001_100;
            (480-(40* 2)-4): calc_ychr <= 7'b1001_101;
            (480-(40* 2)-3): calc_ychr <= 7'b1001_110;
            (480-(40* 1)-9): calc_ychr <= 7'b1010_000;
            (480-(40* 1)-8): calc_ychr <= 7'b1010_001;
            (480-(40* 1)-7): calc_ychr <= 7'b1010_010;
            (480-(40* 1)-6): calc_ychr <= 7'b1010_011;
            (480-(40* 1)-5): calc_ychr <= 7'b1010_100;
            (480-(40* 1)-4): calc_ychr <= 7'b1010_101;
            (480-(40* 1)-3): calc_ychr <= 7'b1010_110;
            (480-9): calc_ychr <= 7'b1011_000;
            (480-8): calc_ychr <= 7'b1011_001;
            (480-7): calc_ychr <= 7'b1011_010;
            (480-6): calc_ychr <= 7'b1011_011;
            (480-5): calc_ychr <= 7'b1011_100;
            (480-4): calc_ychr <= 7'b1011_101;
            (480-3): calc_ychr <= 7'b1011_110;
            default: calc_ychr <= 7'b0000_111; // blank
        endcase
    end
end
endmodule

module char_pixgen2
(
    input CK,
    input EN,
    input [9:0] y_pos,
    output [3:0] ycharpos,
    output [2:0] yline
);

reg [6:0] calc_ychr = 0;
assign yline = calc_ychr[2:0];
assign ycharpos = calc_ychr[6:3];

always @(posedge CK) begin
    if (EN) begin
        case(y_pos) 
            (480-(40*11)-16): calc_ychr <= 7'b0000_000;
            (480-(40*11)-15): calc_ychr <= 7'b0000_000;
            (480-(40*11)-14): calc_ychr <= 7'b0000_001;
            (480-(40*11)-13): calc_ychr <= 7'b0000_001;
            (480-(40*11)-12): calc_ychr <= 7'b0000_010;
            (480-(40*11)-11): calc_ychr <= 7'b0000_010;
            (480-(40*11)-10): calc_ychr <= 7'b0000_011;
            (480-(40*11)- 9): calc_ychr <= 7'b0000_011;
            (480-(40*11)- 8): calc_ychr <= 7'b0000_100;
            (480-(40*11)- 7): calc_ychr <= 7'b0000_100;
            (480-(40*11)- 6): calc_ychr <= 7'b0000_101;
            (480-(40*11)- 5): calc_ychr <= 7'b0000_101;
            (480-(40*11)- 4): calc_ychr <= 7'b0000_110;
            (480-(40*11)- 3): calc_ychr <= 7'b0000_110;

            (480-(40*10)-16): calc_ychr <= 7'b0001_000;
            (480-(40*10)-15): calc_ychr <= 7'b0001_000;
            (480-(40*10)-14): calc_ychr <= 7'b0001_001;
            (480-(40*10)-13): calc_ychr <= 7'b0001_001;
            (480-(40*10)-12): calc_ychr <= 7'b0001_010;
            (480-(40*10)-11): calc_ychr <= 7'b0001_010;
            (480-(40*10)-10): calc_ychr <= 7'b0001_011;
            (480-(40*10)- 9): calc_ychr <= 7'b0001_011;
            (480-(40*10)- 8): calc_ychr <= 7'b0001_100;
            (480-(40*10)- 7): calc_ychr <= 7'b0001_100;
            (480-(40*10)- 6): calc_ychr <= 7'b0001_101;
            (480-(40*10)- 5): calc_ychr <= 7'b0001_101;
            (480-(40*10)- 4): calc_ychr <= 7'b0001_110;
            (480-(40*10)- 3): calc_ychr <= 7'b0001_110;

            (480-(40* 9)-16): calc_ychr <= 7'b0010_000;
            (480-(40* 9)-15): calc_ychr <= 7'b0010_000;
            (480-(40* 9)-14): calc_ychr <= 7'b0010_001;
            (480-(40* 9)-13): calc_ychr <= 7'b0010_001;
            (480-(40* 9)-12): calc_ychr <= 7'b0010_010;
            (480-(40* 9)-11): calc_ychr <= 7'b0010_010;
            (480-(40* 9)-10): calc_ychr <= 7'b0010_011;
            (480-(40* 9)- 9): calc_ychr <= 7'b0010_011;
            (480-(40* 9)- 8): calc_ychr <= 7'b0010_100;
            (480-(40* 9)- 7): calc_ychr <= 7'b0010_100;
            (480-(40* 9)- 6): calc_ychr <= 7'b0010_101;
            (480-(40* 9)- 5): calc_ychr <= 7'b0010_101;
            (480-(40* 9)- 4): calc_ychr <= 7'b0010_110;
            (480-(40* 9)- 3): calc_ychr <= 7'b0010_110;

            (480-(40* 8)-16): calc_ychr <= 7'b0011_000;
            (480-(40* 8)-15): calc_ychr <= 7'b0011_000;
            (480-(40* 8)-14): calc_ychr <= 7'b0011_001;
            (480-(40* 8)-13): calc_ychr <= 7'b0011_001;
            (480-(40* 8)-12): calc_ychr <= 7'b0011_010;
            (480-(40* 8)-11): calc_ychr <= 7'b0011_010;
            (480-(40* 8)-10): calc_ychr <= 7'b0011_011;
            (480-(40* 8)- 9): calc_ychr <= 7'b0011_011;
            (480-(40* 8)- 8): calc_ychr <= 7'b0011_100;
            (480-(40* 8)- 7): calc_ychr <= 7'b0011_100;
            (480-(40* 8)- 6): calc_ychr <= 7'b0011_101;
            (480-(40* 8)- 5): calc_ychr <= 7'b0011_101;
            (480-(40* 8)- 4): calc_ychr <= 7'b0011_110;
            (480-(40* 8)- 3): calc_ychr <= 7'b0011_110;

            (480-(40* 7)-16): calc_ychr <= 7'b0100_000;
            (480-(40* 7)-15): calc_ychr <= 7'b0100_000;
            (480-(40* 7)-14): calc_ychr <= 7'b0100_001;
            (480-(40* 7)-13): calc_ychr <= 7'b0100_001;
            (480-(40* 7)-12): calc_ychr <= 7'b0100_010;
            (480-(40* 7)-11): calc_ychr <= 7'b0100_010;
            (480-(40* 7)-10): calc_ychr <= 7'b0100_011;
            (480-(40* 7)- 9): calc_ychr <= 7'b0100_011;
            (480-(40* 7)- 8): calc_ychr <= 7'b0100_100;
            (480-(40* 7)- 7): calc_ychr <= 7'b0100_100;
            (480-(40* 7)- 6): calc_ychr <= 7'b0100_101;
            (480-(40* 7)- 5): calc_ychr <= 7'b0100_101;
            (480-(40* 7)- 4): calc_ychr <= 7'b0100_110;
            (480-(40* 7)- 3): calc_ychr <= 7'b0100_110;

            (480-(40* 6)-16): calc_ychr <= 7'b0101_000;
            (480-(40* 6)-15): calc_ychr <= 7'b0101_000;
            (480-(40* 6)-14): calc_ychr <= 7'b0101_001;
            (480-(40* 6)-13): calc_ychr <= 7'b0101_001;
            (480-(40* 6)-12): calc_ychr <= 7'b0101_010;
            (480-(40* 6)-11): calc_ychr <= 7'b0101_010;
            (480-(40* 6)-10): calc_ychr <= 7'b0101_011;
            (480-(40* 6)- 9): calc_ychr <= 7'b0101_011;
            (480-(40* 6)- 8): calc_ychr <= 7'b0101_100;
            (480-(40* 6)- 7): calc_ychr <= 7'b0101_100;
            (480-(40* 6)- 6): calc_ychr <= 7'b0101_101;
            (480-(40* 6)- 5): calc_ychr <= 7'b0101_101;
            (480-(40* 6)- 4): calc_ychr <= 7'b0101_110;
            (480-(40* 6)- 3): calc_ychr <= 7'b0101_110;

            (480-(40* 5)-16): calc_ychr <= 7'b0110_000;
            (480-(40* 5)-15): calc_ychr <= 7'b0110_000;
            (480-(40* 5)-14): calc_ychr <= 7'b0110_001;
            (480-(40* 5)-13): calc_ychr <= 7'b0110_001;
            (480-(40* 5)-12): calc_ychr <= 7'b0110_010;
            (480-(40* 5)-11): calc_ychr <= 7'b0110_010;
            (480-(40* 5)-10): calc_ychr <= 7'b0110_011;
            (480-(40* 5)- 9): calc_ychr <= 7'b0110_011;
            (480-(40* 5)- 8): calc_ychr <= 7'b0110_100;
            (480-(40* 5)- 7): calc_ychr <= 7'b0110_100;
            (480-(40* 5)- 6): calc_ychr <= 7'b0110_101;
            (480-(40* 5)- 5): calc_ychr <= 7'b0110_101;
            (480-(40* 5)- 4): calc_ychr <= 7'b0110_110;
            (480-(40* 5)- 3): calc_ychr <= 7'b0110_110;

            (480-(40* 4)-16): calc_ychr <= 7'b0111_000;
            (480-(40* 4)-15): calc_ychr <= 7'b0111_000;
            (480-(40* 4)-14): calc_ychr <= 7'b0111_001;
            (480-(40* 4)-13): calc_ychr <= 7'b0111_001;
            (480-(40* 4)-12): calc_ychr <= 7'b0111_010;
            (480-(40* 4)-11): calc_ychr <= 7'b0111_010;
            (480-(40* 4)-10): calc_ychr <= 7'b0111_011;
            (480-(40* 4)- 9): calc_ychr <= 7'b0111_011;
            (480-(40* 4)- 8): calc_ychr <= 7'b0111_100;
            (480-(40* 4)- 7): calc_ychr <= 7'b0111_100;
            (480-(40* 4)- 6): calc_ychr <= 7'b0111_101;
            (480-(40* 4)- 5): calc_ychr <= 7'b0111_101;
            (480-(40* 4)- 4): calc_ychr <= 7'b0111_110;
            (480-(40* 4)- 3): calc_ychr <= 7'b0111_110;

            (480-(40* 3)-16): calc_ychr <= 7'b1000_000;
            (480-(40* 3)-15): calc_ychr <= 7'b1000_000;
            (480-(40* 3)-14): calc_ychr <= 7'b1000_001;
            (480-(40* 3)-13): calc_ychr <= 7'b1000_001;
            (480-(40* 3)-12): calc_ychr <= 7'b1000_010;
            (480-(40* 3)-11): calc_ychr <= 7'b1000_010;
            (480-(40* 3)-10): calc_ychr <= 7'b1000_011;
            (480-(40* 3)- 9): calc_ychr <= 7'b1000_011;
            (480-(40* 3)- 8): calc_ychr <= 7'b1000_100;
            (480-(40* 3)- 7): calc_ychr <= 7'b1000_100;
            (480-(40* 3)- 6): calc_ychr <= 7'b1000_101;
            (480-(40* 3)- 5): calc_ychr <= 7'b1000_101;
            (480-(40* 3)- 4): calc_ychr <= 7'b1000_110;
            (480-(40* 3)- 3): calc_ychr <= 7'b1000_110;

            (480-(40* 2)-16): calc_ychr <= 7'b1001_000;
            (480-(40* 2)-15): calc_ychr <= 7'b1001_000;
            (480-(40* 2)-14): calc_ychr <= 7'b1001_001;
            (480-(40* 2)-13): calc_ychr <= 7'b1001_001;
            (480-(40* 2)-12): calc_ychr <= 7'b1001_010;
            (480-(40* 2)-11): calc_ychr <= 7'b1001_010;
            (480-(40* 2)-10): calc_ychr <= 7'b1001_011;
            (480-(40* 2)- 9): calc_ychr <= 7'b1001_011;
            (480-(40* 2)- 8): calc_ychr <= 7'b1001_100;
            (480-(40* 2)- 7): calc_ychr <= 7'b1001_100;
            (480-(40* 2)- 6): calc_ychr <= 7'b1001_101;
            (480-(40* 2)- 5): calc_ychr <= 7'b1001_101;
            (480-(40* 2)- 4): calc_ychr <= 7'b1001_110;
            (480-(40* 2)- 3): calc_ychr <= 7'b1001_110;

            (480-(40* 1)-16): calc_ychr <= 7'b1010_000;
            (480-(40* 1)-15): calc_ychr <= 7'b1010_000;
            (480-(40* 1)-14): calc_ychr <= 7'b1010_001;
            (480-(40* 1)-13): calc_ychr <= 7'b1010_001;
            (480-(40* 1)-12): calc_ychr <= 7'b1010_010;
            (480-(40* 1)-11): calc_ychr <= 7'b1010_010;
            (480-(40* 1)-10): calc_ychr <= 7'b1010_011;
            (480-(40* 1)- 9): calc_ychr <= 7'b1010_011;
            (480-(40* 1)- 8): calc_ychr <= 7'b1010_100;
            (480-(40* 1)- 7): calc_ychr <= 7'b1010_100;
            (480-(40* 1)- 6): calc_ychr <= 7'b1010_101;
            (480-(40* 1)- 5): calc_ychr <= 7'b1010_101;
            (480-(40* 1)- 4): calc_ychr <= 7'b1010_110;
            (480-(40* 1)- 3): calc_ychr <= 7'b1010_110;

            (480-(40* 0)-16): calc_ychr <= 7'b1011_000;
            (480-(40* 0)-15): calc_ychr <= 7'b1011_000;
            (480-(40* 0)-14): calc_ychr <= 7'b1011_001;
            (480-(40* 0)-13): calc_ychr <= 7'b1011_001;
            (480-(40* 0)-12): calc_ychr <= 7'b1011_010;
            (480-(40* 0)-11): calc_ychr <= 7'b1011_010;
            (480-(40* 0)-10): calc_ychr <= 7'b1011_011;
            (480-(40* 0)- 9): calc_ychr <= 7'b1011_011;
            (480-(40* 0)- 8): calc_ychr <= 7'b1011_100;
            (480-(40* 0)- 7): calc_ychr <= 7'b1011_100;
            (480-(40* 0)- 6): calc_ychr <= 7'b1011_101;
            (480-(40* 0)- 5): calc_ychr <= 7'b1011_101;
            (480-(40* 0)- 4): calc_ychr <= 7'b1011_110;
            (480-(40* 0)- 3): calc_ychr <= 7'b1011_110;

            default: calc_ychr <= 7'b0000_111; // blank
        endcase
    end
end
endmodule


module char_xpixgen
(
    input CK,
    input EN,
    input [9:0] x_pos,
    output [1:0] xcharpos,
    output [2:0] xline
);
reg [4:0] calc_chr;
assign xline = calc_chr[2:0];
assign xcharpos = calc_chr[4:3];

always @(posedge CK) begin
    if (EN) begin
        case(x_pos) 
             0: calc_chr <= 5'b00_000;
             1: calc_chr <= 5'b00_001;
             2: calc_chr <= 5'b00_010;
             3: calc_chr <= 5'b00_011;
             4: calc_chr <= 5'b00_100;
             5: calc_chr <= 5'b00_101;

             6: calc_chr <= 5'b01_000;
             7: calc_chr <= 5'b01_001;
             8: calc_chr <= 5'b01_010;
             9: calc_chr <= 5'b01_011;
            10: calc_chr <= 5'b01_100;
            11: calc_chr <= 5'b01_101;

            12: calc_chr <= 5'b10_000;
            13: calc_chr <= 5'b10_001;
            14: calc_chr <= 5'b10_010;
            15: calc_chr <= 5'b10_011;
            16: calc_chr <= 5'b10_100;
            17: calc_chr <= 5'b10_101;

            18: calc_chr <= 5'b11_000;
            19: calc_chr <= 5'b11_001;
            20: calc_chr <= 5'b11_010;
            21: calc_chr <= 5'b11_011;
            22: calc_chr <= 5'b11_100;
            23: calc_chr <= 5'b11_101;

            default: calc_chr <= 5'b00_000; // blank 
        endcase
    end
end
endmodule

module grid_pixgen
(
    input CK,
    input [3:0] EN,
    input [9:0] v_pos,
    input [9:0] h_pos,
    output enout,
    output pixout
);

    reg henable = 0;
    reg hborder = 0;
    reg hliney = 0;
    reg hpix = 0;
    reg hlinedot = 0;
    reg venable = 0;
    reg [3:0] ycharpos = 0;
    reg [2:0] yline = 0;
    //char_pixgen cp1( .CK(CK), .EN(EN[0]), .y_pos(v_pos), .ycharpos(ycharpos), .yline(yline) );
    char_pixgen2 cp1( .CK(CK), .EN(EN[0]), .y_pos(v_pos), .ycharpos(ycharpos), .yline(yline) );
    reg [1:0] xcharpos = 0;
    reg [2:0] xline = 0;
    //char_xpixgen cxp( .CK(CK), .EN(EN[0]), .x_pos(h_pos), .xcharpos(xcharpos), .xline(xline) );
    char_xpixgen cxp( .CK(CK), .EN(EN[0]), .x_pos({1'b0,h_pos[9:1]}), .xcharpos(xcharpos), .xline(xline) );
    always @(posedge CK) begin
        if( EN[0]) begin
            henable <= (32 <= (h_pos-1)) ? (((h_pos-1) < 800) ? 1'b1 : 1'b0 ) : 1'b0;
            hborder <= (28 <= (h_pos-1)) && ((h_pos-1) < 32);
            hliney <= (v_pos==(480-(40*11))) || (v_pos==(480-(40*10))) || (v_pos==(480-(40*9))) || (v_pos==(480-(40*8))) ||
                        (v_pos==(480-(40*7))) || (v_pos==(480-(40*6))) || (v_pos==(480-(40*5))) || (v_pos==(480-(40*4))) ||
                        (v_pos==(480-(40*3))) || (v_pos==(480-(40*2))) || (v_pos==(480-(40*1))) || (v_pos==(480-1));
            hlinedot <=  h_pos[2];
            venable <= ((0 <= v_pos) && (v_pos < 480));
        end
    end
    reg [3:0] chr = 0;
    char_map cm( .CK(CK), .EN(EN[1]), .ychr(ycharpos), .xchr({1'h0,xcharpos}), .chr(chr) );
    reg [5:0] cgenout = 0;
    char_rom cr( .CK(CK), .EN(EN[2]), .chr(chr), .scany(yline), .out(cgenout) );
    
    assign pixout = hliney && hlinedot || cgenout[xline];
    assign enout = venable && henable;

endmodule


//   0, 250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250 




