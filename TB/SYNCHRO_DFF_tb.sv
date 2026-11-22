`timescale 1ns/ 1ps
module SYNCHRO_DFF_tb();

reg i_CLK  =0;
reg i_RST_p=1;
reg i_PORT =0;
wire o_SYNCHRO;
wire o_RISE_p;
wire o_FALL_p;

SYNCHRO_DFF SYNCHRO_DFF(
.i_CLK    (i_CLK    ),
.i_RST_p  (i_RST_p  ),
.i_PORT   (i_PORT   ),
.o_SYNCHRO(o_SYNCHRO),
.o_RISE_p (o_RISE_p ),
.o_FALL_p (o_FALL_p )
);
//クロック50MHz
initial begin
   i_CLK = 0;
  forever #10 i_CLK = ~i_CLK;
end
//リセット
initial begin
  i_RST_p=1;
  #1360;
  i_RST_p=0;
end

initial begin
    #1023;
    i_PORT=~i_PORT;
    #503;
    i_PORT=~i_PORT;
    #600;
    i_PORT=~i_PORT;
end

endmodule