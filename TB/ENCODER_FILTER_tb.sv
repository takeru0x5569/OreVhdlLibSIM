`timescale 1ns / 1ps
module ENCODER_FILTER_tb;

reg     i_CLK=0;
reg     i_RST_p=1;
reg[2:0]i_FILTER_FACT=3'b010;
reg     i_ENC_PULSE=0;
wire    o_ENC_PULSE;

ENCODER_FILTER 
ENCODER_FILTER(
.i_CLK          (i_CLK          ),
.i_RST_p        (i_RST_p        ),
.i_ENC_PULSE    (i_ENC_PULSE    ),
.o_ENC_PULSE    (o_ENC_PULSE    )
);

  // Clock generation
  initial begin
    i_CLK = 0;
    forever #10 i_CLK = ~i_CLK; // 50MHz clock
  end

  // Reset generation
  initial begin
    #1360;
    i_RST_p = 0;
  end
  //####################################################
  // Test sequence
  //####################################################
    
    initial begin
        #1245;
        i_ENC_PULSE<=~i_ENC_PULSE;#360;
        i_ENC_PULSE<=~i_ENC_PULSE;#3600;
        i_ENC_PULSE<=~i_ENC_PULSE;#15;
        i_ENC_PULSE<=~i_ENC_PULSE;#30;
        i_ENC_PULSE<=~i_ENC_PULSE;#55;
        i_ENC_PULSE<=~i_ENC_PULSE;#12;
        i_ENC_PULSE<=~i_ENC_PULSE;#800;

        i_ENC_PULSE<=~i_ENC_PULSE;#35;
        i_ENC_PULSE<=~i_ENC_PULSE;#26;
        i_ENC_PULSE<=~i_ENC_PULSE;#800;
        i_ENC_PULSE<=~i_ENC_PULSE;#800;
        i_ENC_PULSE<=~i_ENC_PULSE;#800;
    end
endmodule