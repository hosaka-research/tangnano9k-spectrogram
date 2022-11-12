

module char_rom
(
    input ck,
    input [3:0] chr,
    input [2:0] scany,
    output wire [5:0] out
);

    reg [5:0] dataout = 0;
    assign out = dataout;

    wire [6:0] addr = {1b0, chr, scany};
    always @(posedge ck) begin
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
            7'b0001_000: dataout <= 6'b000110;
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
            7'b0110_000: dataout <= 6'b001111;
            7'b0110_001: dataout <= 6'b010000;
            7'b0110_010: dataout <= 6'b010000;
            7'b0110_011: dataout <= 6'b011110;
            7'b0110_100: dataout <= 6'b010001;
            7'b0110_101: dataout <= 6'b010001;
            7'b0110_110: dataout <= 6'b001110;
            7'b0110_111: dataout <= 6'b000000;
////////// code =7, character 7
            7'b0111_000: dataout <= 6'b011111;
            7'b0111_001: dataout <= 6'b010001;
            7'b0111_010: dataout <= 6'b000001;
            7'b0111_011: dataout <= 6'b000010;
            7'b0111_100: dataout <= 6'b000100;
            7'b0111_101: dataout <= 6'b001000;
            7'b0111_110: dataout <= 6'b010000;
            7'b0111_111: dataout <= 6'b000000;
//////////// code = 8, character 6
            7'b1000_000: dataout <= 6'b001110;
            7'b1000_001: dataout <= 6'b010001;
            7'b1000_010: dataout <= 6'b010001;
            7'b1000_011: dataout <= 6'b011110;
            7'b1000_100: dataout <= 6'b010001;
            7'b1000_101: dataout <= 6'b010001;
            7'b1000_110: dataout <= 6'b001110;
            7'b1000_111: dataout <= 6'b000000;
//////////// code = 9, character ' '
            7'b1001_000: dataout <= 6'b001110;
            7'b1001_001: dataout <= 6'b010001;
            7'b1001_010: dataout <= 6'b010001;
            7'b1001_011: dataout <= 6'b001111;
            7'b1001_100: dataout <= 6'b000010;
            7'b1001_101: dataout <= 6'b000100;
            7'b1001_110: dataout <= 6'b011000;
            7'b1001_111: dataout <= 6'b000000;
//////////// code = 11, character ' '
            7'b0101_000: dataout <= 6'b000000;
            7'b0101_001: dataout <= 6'b000000;
            7'b0101_010: dataout <= 6'b000000;
            7'b0101_011: dataout <= 6'b000000;
            7'b0101_100: dataout <= 6'b000000;
            7'b0101_101: dataout <= 6'b000000;
            7'b0101_110: dataout <= 6'b000000;
            7'b0101_111: dataout <= 6'b000000;
//////////// code = 12, character 'k'
            7'b0101_000: dataout <= 6'b010000;
            7'b0101_001: dataout <= 6'b010000;
            7'b0101_010: dataout <= 6'b010011;
            7'b0101_011: dataout <= 6'b010100;
            7'b0101_100: dataout <= 6'b011000;
            7'b0101_101: dataout <= 6'b010100;
            7'b0101_110: dataout <= 6'b010011;
            7'b0101_111: dataout <= 6'b000000;
//////////// code = 14, character '.'
            7'b0110_000: dataout <= 6'b000000;
            7'b0110_001: dataout <= 6'b000000;
            7'b0110_010: dataout <= 6'b000000;
            7'b0110_011: dataout <= 6'b000000;
            7'b0110_100: dataout <= 6'b000000;
            7'b0110_101: dataout <= 6'b000110;
            7'b0110_110: dataout <= 6'b000110;
            7'b0110_111: dataout <= 6'b000000;
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
endmodule

module char_map
(
    input ck,
    input [3:0] ychr,
    input [2:0] xchr,
    output [3:0] chr
);
reg [3:0] chrreg;
assign chr = chrreg;
wire [6:0] addr = {ychr, xchr};
    char_rom r( ck, chr, yline, data )
    always @(posedge ck) begin
        case( addr)
            case 7'b0000_000b chrreg <= 4'h2; // position  0 '2200'
            case 7'b0000_001b chrreg <= 4'h2;
            case 7'b0000_010b chrreg <= 4'h0;
            case 7'b0000_011b chrreg <= 4'h0;
            case 7'b0001_000b chrreg <= 4'h2; // position  1 '2000'
            case 7'b0001_001b chrreg <= 4'h0;
            case 7'b0001_010b chrreg <= 4'h0;
            case 7'b0001_011b chrreg <= 4'h0;
            case 7'b0010_000b chrreg <= 4'h1; // position  2 '1800'
            case 7'b0010_001b chrreg <= 4'h8;
            case 7'b0010_010b chrreg <= 4'h0;
            case 7'b0010_011b chrreg <= 4'h0;
            case 7'b0011_000b chrreg <= 4'h1; // position  3 '1600'
            case 7'b0011_001b chrreg <= 4'h6;
            case 7'b0011_010b chrreg <= 4'h0;
            case 7'b0011_011b chrreg <= 4'h0;

            case 7'b0100_000b chrreg <= 4'h1; // position  4 '1400'
            case 7'b0100_001b chrreg <= 4'h4;
            case 7'b0100_010b chrreg <= 4'h0;
            case 7'b0100_011b chrreg <= 4'h0;
            case 7'b0101_000b chrreg <= 4'h1; // position  5 '1200'
            case 7'b0101_001b chrreg <= 4'h2;
            case 7'b0101_010b chrreg <= 4'h0;
            case 7'b0101_011b chrreg <= 4'h0;
            case 7'b0110_000b chrreg <= 4'h1; // position  6 '1000'
            case 7'b0110_001b chrreg <= 4'h0;
            case 7'b0110_010b chrreg <= 4'h0;
            case 7'b0110_011b chrreg <= 4'h0;
            case 7'b0111_000b chrreg <= 4'hf; // position  7 ' 800'
            case 7'b0111_001b chrreg <= 4'h8;
            case 7'b0111_010b chrreg <= 4'h0;
            case 7'b0111_011b chrreg <= 4'h0;

            case 7'b1000_000b chrreg <= 4'hf; // position  8 ' 600'
            case 7'b1000_001b chrreg <= 4'h6;
            case 7'b1000_010b chrreg <= 4'h0;
            case 7'b1000_011b chrreg <= 4'h0;
            case 7'b1001_000b chrreg <= 4'hf; // position  9 ' 400'
            case 7'b1001_001b chrreg <= 4'h4;
            case 7'b1001_010b chrreg <= 4'h0;
            case 7'b1001_011b chrreg <= 4'h0;
            case 7'b1010_000b chrreg <= 4'hf; // position 10 ' 200'
            case 7'b1010_001b chrreg <= 4'h2;
            case 7'b1010_010b chrreg <= 4'h0;
            case 7'b1010_011b chrreg <= 4'h0;
            case 7'b1011_000b chrreg <= 4'hf; // position 11 '   0'
            case 7'b1011_001b chrreg <= 4'hf;
            case 7'b1011_010b chrreg <= 4'hf;
            case 7'b1011_011b chrreg <= 4'h0;
        endcase
    end
endmodule

module char_darw
(
    input ck,
    input [8:0] ypix,
    input [9:0] xpix,
    output [3:0] d
);

wire [3:0] ychrpos;
wire [2:0] xchrpos; // if 3'd1xx no character
wire [2:0] ychrpix;
wire [2:0] xchrpix;

char_map m(ck, ychrpos, xchrpos);
 


//   0, 250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250 




