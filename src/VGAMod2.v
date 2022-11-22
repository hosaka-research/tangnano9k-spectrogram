
module VGAMod2
(
    input CLK,
    input nRST,

    output PixelClk,
    output LCD_DE,
    output LCD_HSYNC,
    output LCD_VSYNC,
    output [15:0] LCD_RGB565, 
    input signed [17:0] ADATA0,
    input        ADATARDY

);

/////////////////////////////
// C counter, One hot state machine
/////////////////////////////
localparam c_stop = 4; // 90MHz/22.5MHz, MUST BE EVEN 
reg[c_stop-1:0] c_S = 4'b0;
always@(posedge CLK) c_S <= (c_S[c_stop-2:0]==0)?(4'b1):(c_S<<1); 
wire c_isend = c_S[3]; // Check if counter is at end count  
wire c_stopM3 = c_S[1]; // A pixel changes at 3rd posedge of CLK
// 5,0,1 -> PixelClk goes 1 // 2,3,4->PixelClk goes 0
reg PCLK = 0;
always@(posedge CLK) PCLK <= (c_S[0]|c_S[3]);
assign PixelClk = PCLK;

/////////////////////////////
// H counter
/////////////////////////////
localparam h_blank  =  11'd46;
localparam h_pulse  =   1; 
localparam h_disp   = h_blank + 800;
localparam h_noinp  = h_disp + 128;
localparam h_stop   = h_disp + 210;

reg[10:0] h_count   = 0; // Count pixel clock to generate vertical clock
wire h_isend = (c_isend&&(h_count==h_stop-1));
wire h_isdispend =  (c_isend&&(h_count==h_disp-1));
wire h_isnoinp   =   ((h_disp <= h_count)&&(h_count < h_noinp));
wire h_isnoinpend =  (c_isend&&(h_count==h_noinp-1));
always@(posedge CLK) if(c_isend) h_count <= h_count==h_stop-1'h1 ? 1'h0 : h_count+1'h1;
wire [9:0] h_pos=(h_count-h_blank);
reg h_sync = 1;
always@(posedge CLK) if(c_isend) h_sync <= (((h_pulse-1'h1)<=h_count)&&(h_count<=(h_disp-1'h1)));
assign LCD_HSYNC = h_sync;
wire h_enable = ((h_blank-1<=h_count)&&(h_count <= h_disp-1'h1));
wire h_validdata = ((h_count<=(h_disp-1'h1)));

/////////////////////////////
// V counter
/////////////////////////////
localparam v_blank =   0;
localparam v_pulse =   5; 
localparam v_disp  = 480;
localparam v_stop  = v_disp + 45;

reg[ 9:0] v_count   = 0; // Count vertical clock to generate frame clock
wire v_isend = (h_isend&&(v_count==v_stop-1));
always@(posedge CLK) if(h_isend) v_count <= v_isend ? 1'h0 : v_count+1'h1;
reg v_sync = 0;
always@(posedge CLK) if(h_isend) v_sync <= ((v_pulse<=v_count)&&(v_count<=v_stop));

wire v_enable = ((v_blank<=v_count)&&(v_count <= v_disp-1));
wire [9:0] v_pos=v_count-v_blank;
reg hv_enable = 0;
always@(posedge CLK) if(c_isend) hv_enable <= h_enable && v_enable;
assign LCD_VSYNC = v_sync;
assign LCD_DE = hv_enable;

/////////////////////////////
// audio buffer write
/////////////////////////////
localparam adata0buf_bit = 12;
localparam adata0buf_size = 2**adata0buf_bit;
reg signed [17:0] adata0buf0[0:adata0buf_size-1];
reg signed [17:0] adata0buf1[0:adata0buf_size-1];
reg [adata0buf_bit:0] adata0wadr = 0;
always@(posedge CLK) if(ADATARDY && adata0wadr[0]==0) adata0buf0[adata0wadr[adata0buf_bit:1]] <= $signed(ADATA0);
always@(posedge CLK) if(ADATARDY && adata0wadr[0]==1) adata0buf1[adata0wadr[adata0buf_bit:1]] <= $signed(ADATA0);
always@(posedge CLK) if(ADATARDY) adata0wadr <= adata0wadr+1'h1;

////////////////////////////////
// calc theta for every clock
////////////////////////////////
/*
wire [35:0] dtheta;
fctheta_rom deltatheta( .clock(CLK),.ce(1'b1),.oce(1'b1), .reset(1'b0),
                        .addr(v_pos), .dataout(dtheta));
reg [35:0] theta0 = 0;
reg [35:0] theta1 = 0; // EVEN NUMBER ALWAYS
//always@(posedge CLK) theta <= (h_isend) ? 0 : theta + dtheta;
always@(posedge CLK) theta0 <= theta1 + dtheta;
always@(posedge CLK) theta1 <= theta1 + dtheta*2;
*/
////////////////////////////////
// cos(theta) & sin(theta) to be detected
////////////////////////////////
wire signed [17:0] cos0, sin0, cos1, sin1;
//cordic cscordic0( .CLK(CLK), .theta(theta0[35:16]), .cosout(cos0), .sinout(sin0));
//cordic cscordic1( .CLK(CLK), .theta(theta1[35:16]), .cosout(cos1), .sinout(sin1)); 

////////////////////////////////
// sin() and cos() from rotation based NCO 'nco_45' 
////////////////////////////////
nco_45 nco(.CK(CLK), .START(h_count==0), .v_pos(v_pos[8:0]), .cos0(cos0), .sin0(sin0), .cos1(cos1), .sin1(sin1)); 

/////////////////////////////////
// audio buffer read
/////////////////////////////////
reg [adata0buf_bit-1:0] adata_adr_crnt = 0;
//always@(posedge CLK) adata_adr_crnt <= h_isnoinpend ? adata0wadr+2+1350 : adata_adr_crnt+1;
//always@(posedge CLK) adata_adr_crnt <= h_isnoinpend ? adata0wadr+2+650 : adata_adr_crnt+1;
always@(posedge CLK) adata_adr_crnt <= h_isnoinpend ? adata0wadr[adata0buf_bit:1]+2'd2+9'd400: adata_adr_crnt+1'd1;
reg signed [17:0] adata0_crnt0, adata0_crnt1;
always@(posedge CLK) adata0_crnt0 <= 0 ? 0: adata0buf0[adata_adr_crnt]; // check
always@(posedge CLK) adata0_crnt1 <= 0 ? 0: adata0buf1[adata_adr_crnt]; // check

/////////////////////////////////////////////////////////////
// complex CIC summator
/////////////////////////////////////////////////////////////
localparam B_abit = 5;
localparam B_dbit = 54; // 36+3+B_abit;

reg signed [B_dbit-1:0] real_I0=0;
reg signed [B_dbit-1:0] real_I1=0, real_I2=0;

always@(posedge CLK) real_I0 <= ((($signed(cos0)*$signed(adata0_crnt0))
                                 +($signed(cos1)*$signed(adata0_crnt1))) );
always@(posedge CLK) real_I1 <= $signed($signed(real_I1)+$signed(real_I0));
// always@(posedge CLK) real_I2 <= $signed($signed(real_I2)+$signed(real_I1));

reg signed [B_dbit-1:0] imag_I0=0;
reg signed [B_dbit-1:0] imag_I1=0, imag_I2=0;

always@(posedge CLK) imag_I0 <= ((($signed(sin0)*$signed(adata0_crnt0))
                                 +($signed(sin1)*$signed(adata0_crnt1))) );
always@(posedge CLK) imag_I1 <= $signed($signed(imag_I1)+$signed(imag_I0));
// always@(posedge CLK) imag_I2 <= $signed($signed(imag_I2)+$signed(imag_I1));

/////////////////////////////////////////////////////////////
// complex CIC differencer --- moving average ----
/////////////////////////////////////////////////////////////

reg signed [B_dbit*2-1:0] B1[0:2**B_abit-1]; // B[0'b0xxxxxx] real, B[0'b1xxxxxx] imag
reg signed [B_dbit-1:0] real_B1=0, real_D1=0, real_D0=0, imag_B1=0, imag_D1=0, imag_D0=0;
always@(posedge CLK) if(c_S[0]) {real_B1, imag_B1} <= B1[h_count[B_abit-1:0]];
always@(posedge CLK) if(c_S[0]) {real_D1, imag_D1} <= {real_I1, imag_I1}; // take care, vary on every CLOCK
//always@(posedge CLK) if(c_S[0]) real_D1 <= real_I1; // take care, vary on every CLOCK
//always@(posedge CLK) if(c_S[0]) imag_D1 <= imag_I1; // take care, vary on every CLOCK
always@(posedge CLK) if(c_S[1]) {real_D0, imag_D0} <= {$signed(real_D1-real_B1),$signed(imag_D1-imag_B1)};
always@(posedge CLK) if(c_S[1]) B1[h_count[B_abit-1:0]] <= {real_D1, imag_D1};

/////////////////////////////////////////////////////////////
// complex CIC differencer --- moving average ----
/////////////////////////////////////////////////////////////
/*
reg signed [B_dbit*2-1:0] B1[0:2**B_abit-1]; // B[0'b0xxxxxx] real, B[0'b1xxxxxx] imag
reg signed [B_dbit-1:0] real_B1=0, real_D1=0, real_D0=0, imag_B1=0, imag_D1=0, imag_D0=0;
always@(posedge CLK) begin
    if(c_S[0]) begin
        {real_B1, imag_B1} <= B1[h_count[B_abit-1:0]];
        {real_D1, imag_D1} <= {real_I1, imag_I1}; // take care, vary on every CLOCK
    end else if(c_S[1]) begin
        {real_D0, imag_D0} <= {(real_D1-real_B1),(imag_D1-imag_B1)};
        B1[h_count[B_abit-1:0]] <= {real_D1, imag_D1};
    end
end
*/

/*
/////////////////////////////////////////////////////////////
// complex CIC differencer --- Linear ---- timing does not met
/////////////////////////////////////////////////////////////
//reg signed [B_dbit*2-1:0] B[0:2**(B_abit+2)-1]; // B[0'b0xxxxxx] real, B[0'b1xxxxxx] imag
reg signed [B_dbit*2-1:0] B2[0:2**B_abit-1];
reg signed [B_dbit*2-1:0] D1[0:2**B_abit-1];
reg signed [B_dbit*2-1:0] B1[0:2**B_abit-1];
// triangle filter, timing not met
reg signed [B_dbit-1:0] real_B2=0, imag_B2=0;
reg signed [B_dbit-1:0] real_B1=0, imag_B1=0;
reg signed [B_dbit-1:0] real_D1=0, imag_D1=0;
reg signed [B_dbit-1:0] real_D0=0, imag_D0=0;

wire [B_abit-1:0] hc = h_count[B_abit-1:0];

always@(posedge CLK) begin
    if(c_S[0]) begin
        {real_D1, imag_D1} <= D1[hc];
        {real_B1, imag_B1} <= B1[hc];
    end else if (c_S[1]) begin
        {real_D0, imag_D0} <= {(real_D1-real_B1),(imag_D1-imag_B1)};        
        B1[hc] <= {real_D1, imag_D1};
    end else if (c_S[2]) begin
        {real_B2, imag_B2} <= B2[hc];
    end else if (c_S[3]) begin 
        D1[hc] <= {(real_I2-real_B2),(imag_I2-imag_B2)};       
        B2[hc] <= {real_I2, imag_I2};
    end
end
*/
/*
/////////////////////////////////////////////////////////////
// complex CIC differencer --- Linear ----
/////////////////////////////////////////////////////////////
//reg signed [B_dbit*2-1:0] B[0:2**(B_abit+2)-1]; // B[0'b0xxxxxx] real, B[0'b1xxxxxx] imag
reg signed [B_dbit*2-1:0] B2[0:(2**B_abit)-1];
reg signed [B_dbit*2-1:0] D1[0:(2**B_abit)-1];
reg signed [B_dbit*2-1:0] B1[0:(2**B_abit)-1];
// triangle filter, timing not met
reg signed [B_dbit-1:0] real_B1=0, imag_B1=0, real_D1=0, imag_D1=0, real_D0=0, imag_D0=0;
reg signed [B_dbit-1:0] real_B2=0, imag_B2=0, real_D2=0, imag_D2=0;

wire signed [B_dbit-1:0] realD1_B1 = $signed(real_D1-real_B1);
wire signed [B_dbit-1:0] imagD1_B1 = $signed(imag_D1-imag_B1);
wire signed [B_dbit-1:0] realD2_B2 = $signed(real_D2-real_B2);
wire signed [B_dbit-1:0] imagD2_B2 = $signed(imag_D2-imag_B2);    
wire [B_abit-1:0] hc = h_count[B_abit-1:0];

always@(posedge CLK) begin
    if(c_S[0]) begin
        {real_D1, imag_D1} <= D1[hc];
    end else if (c_S[1]) begin
        real_D2 <= real_I2;
        imag_D2 <= imag_I2;
        {real_B1, imag_B1} <= B1[hc];
        B1[hc] <= {real_D1, imag_D1};
    end else if (c_S[2]) begin
        //real_D0 <= $signed($signed(real_D1)-$signed(real_B1));
        //imag_D0 <= $signed($signed(imag_D1)-$signed(imag_B1));
        real_D0 <= realD1_B1;
        imag_D0 <= imagD1_B1;    
        //{real_D0, imag_D0} <= {realD1_B1, imagD1_B1}; // don't do this; slower
        {real_B2, imag_B2} <= B2[hc];
        B2[hc] <= {real_D2, imag_D2};
    end else if(c_S[3]) begin 
        //D1[hc] <= {$signed($signed(real_D2)-$signed(real_B2)),
        //            $signed($signed(imag_D2)-$signed(imag_B2))};       
        D1[hc] <= {realD2_B2, imagD2_B2};
    end
end
*/
/////////////////////////////////////////////////////////////
// abs(signal power)^2 = real*real+imag*imag 
/////////////////////////////////////////////////////////////
localparam df_hib = 41; //41
localparam df_lob = df_hib-18+1;
localparam sq_bit = 36;
wire signed [17:0] realD0_r = $signed(real_D0[df_hib:df_lob]);
wire signed [17:0] imagD0_r = $signed(imag_D0[df_hib:df_lob]);
reg [sq_bit-1:0] sumsq = 0;
always@(posedge CLK) if(c_S[3]) sumsq <= realD0_r*realD0_r + imagD0_r*imagD0_r;

/////////////////////////
// log image out
/////////////////////////
localparam sq_hib = 34;
reg [5:0] blog;
always@(posedge CLK) if(c_isend) begin
    if ( sumsq[sq_hib] ) begin blog = 62;
    end else if( sumsq[sq_hib- 1]) begin blog <= 58;
    end else if( sumsq[sq_hib- 2]) begin blog <= 54;
    end else if( sumsq[sq_hib- 3]) begin blog <= 50;
    end else if( sumsq[sq_hib- 4]) begin blog <= 46;
    end else if( sumsq[sq_hib- 5]) begin blog <= 42;
    end else if( sumsq[sq_hib- 6]) begin blog <= 38;
    end else if( sumsq[sq_hib- 7]) begin blog <= 34;
    end else if( sumsq[sq_hib- 8]) begin blog <= 30;
    end else if( sumsq[sq_hib- 9]) begin blog <= 26;
    end else if( sumsq[sq_hib-10]) begin blog <= 22;
    end else if( sumsq[sq_hib-11]) begin blog <= 18;
    end else if( sumsq[sq_hib-12]) begin blog <= 14;
    end else if( sumsq[sq_hib-13]) begin blog <= 10;
    end else if( sumsq[sq_hib-14]) begin blog <= 6;
    end else if( sumsq[sq_hib-15]) begin blog <= 2;
    end else begin blog <= 0;
    end
end

reg gridenout = 0;
reg gridpixout = 0;
grid_pixgen gp( .CK(CLK), .EN(c_S), .v_pos(v_pos), .h_pos(h_pos), .enout(gridenout), .pixout(gridpixout) );

reg [15:0] LCD_RGB565_r = 0;
assign LCD_RGB565=LCD_RGB565_r;

//always@(posedge CLK) if(c_S[3]) LCD_RGB565_r <= (v_count[7:0] != adata0_crnt0[17:10]) ? 16'h0000 : 16'hffff;
//always@(posedge CLK) if(c_S[3]) LCD_RGB565_r <= (v_count[7:0] != adata0_crnt0[17:10]) ? {5'b0, blog[5:0], 5'b0}: 16'hffff;
//always@(posedge CLK) if(c_S[3])LCD_RGB565_r <= (v_count[7:0] != adata0_crnt0[17:10]) ? {blog[5:1], blog[5:0], blog[5:1]}: 16'hffff;
//always@(posedge CLK) if(c_S[3]) LCD_RGB565_r <= {blog[5:1], blog[5:0], blog[5:1]}; 
// always@(posedge CLK) if(c_S[3]) LCD_RGB565_r <= gridpixout ? 16'hffff : gridenout ? {blog[5:1], blog[5:0], blog[5:1]} : 16'b0; 
always@(posedge CLK) if(c_S[3]) LCD_RGB565_r <= gridpixout ? 16'h7bef : {blog[5:1], blog[5:0], blog[5:1]}; 
endmodule



