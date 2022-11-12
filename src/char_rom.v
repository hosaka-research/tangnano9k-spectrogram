

module char_rom
(
    input CK,
    input EN,
    input [3:0] chr,
    input [2:0] scany,
    output wire [5:0] out
);

    reg [5:0] dataout = 0;
    assign out = dataout;

    wire [6:0] addr = {1b0, chr, scany};
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
                7'b0000_000b: chrreg<= 4'h2; // position  0 '2200'
                7'b0000_001b: chrreg<= 4'h2;
                7'b0000_010b: chrreg<= 4'h0;
                7'b0000_011b: chrreg<= 4'h0;
                7'b0001_000b: chrreg<= 4'h2; // position  1 '2000'
                7'b0001_001b: chrreg<= 4'h0;
                7'b0001_010b: chrreg<= 4'h0;
                7'b0001_011b: chrreg<= 4'h0;
                7'b0010_000b: chrreg<= 4'h1; // position  2 '1800'
                7'b0010_001b: chrreg<= 4'h8;
                7'b0010_010b: chrreg<= 4'h0;
                7'b0010_011b: chrreg<= 4'h0;
                7'b0011_000b: chrreg<= 4'h1; // position  3 '1600'
                7'b0011_001b: chrreg<= 4'h6;
                7'b0011_010b: chrreg<= 4'h0;
                7'b0011_011b: chrreg<= 4'h0;

                7'b0100_000b: chrreg<= 4'h1; // position  4 '1400'
                7'b0100_001b: chrreg<= 4'h4;
                7'b0100_010b: chrreg<= 4'h0;
                7'b0100_011b: chrreg<= 4'h0;
                7'b0101_000b: chrreg<= 4'h1; // position  5 '1200'
                7'b0101_001b: chrreg<= 4'h2;
                7'b0101_010b: chrreg<= 4'h0;
                7'b0101_011b: chrreg<= 4'h0;
                7'b0110_000b: chrreg<= 4'h1; // position  6 '1000'
                7'b0110_001b: chrreg<= 4'h0;
                7'b0110_010b: chrreg<= 4'h0;
                7'b0110_011b: chrreg<= 4'h0;
                7'b0111_000b: chrreg<= 4'hf; // position  7 ' 800'
                7'b0111_001b: chrreg<= 4'h8;
                7'b0111_010b: chrreg<= 4'h0;
                7'b0111_011b: chrreg<= 4'h0;

                7'b1000_000b: chrreg<= 4'hf; // position  8 ' 600'
                7'b1000_001b: chrreg<= 4'h6;
                7'b1000_010b: chrreg<= 4'h0;
                7'b1000_011b: chrreg<= 4'h0;
                7'b1001_000b: chrreg<= 4'hf; // position  9 ' 400'
                7'b1001_001b: chrreg<= 4'h4;
                7'b1001_010b: chrreg<= 4'h0;
                7'b1001_011b: chrreg<= 4'h0;
                7'b1010_000b: chrreg<= 4'hf; // position 10 ' 200'
                7'b1010_001b: chrreg<= 4'h2;
                7'b1010_010b: chrreg<= 4'h0;
                7'b1010_011b: chrreg<= 4'h0;
                7'b1011_000b: chrreg<= 4'hf; // position 11 '   0'
                7'b1011_001b: chrreg<= 4'hf;
                7'b1011_010b: chrreg<= 4'hf;
                7'b1011_011b: chrreg<= 4'h0;
            endcase
        end
    end
endmodule

module char_darw
(
    input CK,
    input EN0,
    input EN1,
    input EN2,
    input EN3,
    input [8:0] ypix,
    input [9:0] xpix,
    output [3:0] d
);

wire [6:0] ychr_yline = calc_ychr_yline(ypix);
wire [2:0] yline = ychr_yline[2:0];
wire [3:0] ychr = ychr_yline[6:3]
assign {ypos, yline} = 
function [6:0] calc_ychr
    input wire [8:0] ypix;
    begin
        case(ypos)
            (480-(40*11)-3): calc_ychr = 7'b0000_000;
            (480-(40*11)-2): calc_ychr = 7'b0000_001;
            (480-(40*11)-1): calc_ychr = 7'b0000_010;
            (480-(40*11)-0): calc_ychr = 7'b0000_011;
            (480-(40*11)+1): calc_ychr = 7'b0000_100;
            (480-(40*11)+2): calc_ychr = 7'b0000_101;
            (480-(40*11)+3): calc_ychr = 7'b0000_110;
            (480-(40*10)-3): calc_ychr = 7'b0001_000;
            (480-(40*10)-2): calc_ychr = 7'b0001_001;
            (480-(40*10)-1): calc_ychr = 7'b0001_010;
            (480-(40*10)-0): calc_ychr = 7'b0001_011;
            (480-(40*10)+1): calc_ychr = 7'b0001_100;
            (480-(40*10)+2): calc_ychr = 7'b0001_101;
            (480-(40*10)+3): calc_ychr = 7'b0001_110;
            (480-(40*11)-3): calc_ychr = 7'b0010_000;
            (480-(40* 9)-2): calc_ychr = 7'b0010_001;
            (480-(40* 9)-1): calc_ychr = 7'b0010_010;
            (480-(40* 9)-0): calc_ychr = 7'b0010_011;
            (480-(40* 9)+1): calc_ychr = 7'b0010_100;
            (480-(40* 9)+2): calc_ychr = 7'b0010_101;
            (480-(40* 9)+3): calc_ychr = 7'b0010_110;
            (480-(40* 8)-3): calc_ychr = 7'b0011_000;
            (480-(40* 8)-2): calc_ychr = 7'b0011_001;
            (480-(40* 8)-1): calc_ychr = 7'b0011_010;
            (480-(40* 8)-0): calc_ychr = 7'b0011_011;
            (480-(40* 8)+1): calc_ychr = 7'b0011_100;
            (480-(40* 8)+2): calc_ychr = 7'b0011_101;
            (480-(40* 8)+3): calc_ychr = 7'b0011_110;
            (480-(40* 7)-3): calc_ychr = 7'b0100_000;
            (480-(40* 7)-2): calc_ychr = 7'b0100_001;
            (480-(40* 7)-1): calc_ychr = 7'b0100_010;
            (480-(40* 7)-0): calc_ychr = 7'b0100_011;
            (480-(40* 7)+1): calc_ychr = 7'b0100_100;
            (480-(40* 7)+2): calc_ychr = 7'b0100_101;
            (480-(40* 7)+3): calc_ychr = 7'b0100_110;
            (480-(40* 6)-3): calc_ychr = 7'b0101_000;
            (480-(40* 6)-2): calc_ychr = 7'b0101_001;
            (480-(40* 6)-1): calc_ychr = 7'b0101_010;
            (480-(40* 6)-0): calc_ychr = 7'b0101_011;
            (480-(40* 6)+1): calc_ychr = 7'b0101_100;
            (480-(40* 6)+2): calc_ychr = 7'b0101_101;
            (480-(40* 6)+3): calc_ychr = 7'b0101_110;
            (480-(40* 6)-3): calc_ychr = 7'b0110_000;
            (480-(40* 5)-2): calc_ychr = 7'b0110_001;
            (480-(40* 5)-1): calc_ychr = 7'b0110_010;
            (480-(40* 5)-0): calc_ychr = 7'b0110_011;
            (480-(40* 5)+1): calc_ychr = 7'b0110_100;
            (480-(40* 5)+2): calc_ychr = 7'b0110_101;
            (480-(40* 5)+3): calc_ychr = 7'b0110_110;
            (480-(40* 4)-3): calc_ychr = 7'b0111_000;
            (480-(40* 4)-2): calc_ychr = 7'b0111_001;
            (480-(40* 4)-1): calc_ychr = 7'b0111_010;
            (480-(40* 4)-0): calc_ychr = 7'b0111_011;
            (480-(40* 4)+1): calc_ychr = 7'b0111_100;
            (480-(40* 4)+2): calc_ychr = 7'b0111_101;
            (480-(40* 4)+3): calc_ychr = 7'b0111_110;
            (480-(40* 3)-3): calc_ychr = 7'b1000_000;
            (480-(40* 3)-2): calc_ychr = 7'b1000_001;
            (480-(40* 3)-1): calc_ychr = 7'b1000_010;
            (480-(40* 3)-0): calc_ychr = 7'b1000_011;
            (480-(40* 3)+1): calc_ychr = 7'b1000_100;
            (480-(40* 3)+2): calc_ychr = 7'b1000_101;
            (480-(40* 3)+3): calc_ychr = 7'b1000_110;
            (480-(40* 2)-3): calc_ychr = 7'b1001_000;
            (480-(40* 2)-2): calc_ychr = 7'b1001_001;
            (480-(40* 2)-1): calc_ychr = 7'b1001_010;
            (480-(40* 2)-0): calc_ychr = 7'b1001_011;
            (480-(40* 2)+1): calc_ychr = 7'b1001_100;
            (480-(40* 2)+2): calc_ychr = 7'b1001_101;
            (480-(40* 2)+3): calc_ychr = 7'b1001_110;
            (480-(40* 2)-3): calc_ychr = 7'b1010_000;
            (480-(40* 1)-2): calc_ychr = 7'b1010_001;
            (480-(40* 1)-1): calc_ychr = 7'b1010_010;
            (480-(40* 1)-0): calc_ychr = 7'b1010_011;
            (480-(40* 1)+1): calc_ychr = 7'b1010_100;
            (480-(40* 1)+2): calc_ychr = 7'b1010_101;
            (480-(40* 1)+3): calc_ychr = 7'b1010_110;
            (480-7): calc_ychr = 7'b1011_000;
            (480-6): calc_ychr = 7'b1011_001;
            (480-5): calc_ychr = 7'b1011_010;
            (480-4): calc_ychr = 7'b1011_011;
            (480-3): calc_ychr = 7'b1011_100;
            (480-2): calc_ychr = 7'b1011_101;
            (480-1): calc_ychr = 7'b1011_110;
            default: calc_ychr = 0;
        endcase
    end
endfunction


wire [2:0] xchr;
wire [3:0] chr;
wire chr_valid = (xpix < 24)
wire [2:0] scany;
wire [7:0] romout;

char_map m( .CK(CK), .EN(EN1), .ychr(), .xchr(), .chr(chr) ); 
char_rom r( .CK(CK), .EN(EN2), .chr(chr), .scany(scany), .out(romout)  );
wire [3:0] ychrpos;
wire [2:0] xchrpos; // if 3'd1xx no character
wire [2:0] ychrpix;
wire [2:0] xchrpix;

 


//   0, 250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250 




