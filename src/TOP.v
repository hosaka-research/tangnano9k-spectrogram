
module TOP
(
	input			Reset_Button,
    // input           User_Button,
    input           XTAL_IN,

	output			LCD_CLK,
	output			LCD_HSYNC,
	output			LCD_VSYNC,
	output			LCD_DENBL,
	output	[4:0]	LCD_R,
	output	[5:0]	LCD_G,
	output	[4:0]	LCD_B,

    output reg[5:0] LED,

    output wire         MIC_CLK,
    input  wire         MIC_SDATA01
    // output wire         SDATA_OUT
);

    assign SDATA_OUT = MIC_SDATA01; // avoid compiler warning

	wire		CLK;
    wire pll_lock;
    Gowin_rPLL_90M_L chip_pll (
        .clkout(CLK), //output CLKout // 90MHz
        .clkin(XTAL_IN), //input clkin
        .lock(pll_lock)
    );
    wire [17:0] adata0;
    wire        adata_rdy;
    wire        oscout_o;
    cic_digital_mic_90M_3M_6k mic
    (

        .CLK(CLK),
        .mic_clk(MIC_CLK), .mic_data(MIC_SDATA01),
        .o_data0(adata0), .o_vld(adata_rdy),
        .o_range_over( LED ), .RST(!pll_lock /*| !reset_button*/ )
    );

    wire [15:0] LCD_RGB565;
    assign { LCD_R, LCD_G, LCD_B } = LCD_RGB565;
	VGAMod2	D1
	(
		.CLK		(	CLK     ),
		.nRST		(	Reset_Button ),

		.PixelClk ( LCD_CLK ),
		.LCD_DE	 ( LCD_DENBL ),
		.LCD_HSYNC( LCD_HSYNC ), .LCD_VSYNC( LCD_VSYNC ),
        .LCD_RGB565( LCD_RGB565 ),
        .ADATA0(adata0), .ADATARDY(adata_rdy)
	);

endmodule

