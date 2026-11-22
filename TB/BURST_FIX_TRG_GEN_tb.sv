`timescale 1ns / 1ps

module BURST_FIX_TRG_GEN_tb();
    reg         i_CLK       =0;
    reg         i_RST_p     =1;
    reg         i_SOURCE_p =0;
    wire        o_DELAY_p;
    //モジュールインスタンス
    BURST_FIX_TRG_GEN uBURST_FIX_TRG_GEN(
        .i_CLK          (i_CLK),
        .i_RST_p        (i_RST_p),
        .i_START_p      (i_SOURCE_p),
        .o_BUSY_h       (),
        .o_FINISH_p     ()
    );
    // クロック50MHz
    always #10 i_CLK = ~i_CLK;
    // リセット
    initial begin
        i_RST_p = 1;
        #130;
        i_RST_p = 0;
        #300;
        @(posedge i_CLK);   i_SOURCE_p = 1;
        @(posedge i_CLK);   i_SOURCE_p = 0;
        
        #300;
        @(posedge i_CLK);   i_SOURCE_p = 1;
        @(posedge i_CLK);   i_SOURCE_p = 0;
        #100;
        @(posedge i_CLK);   i_SOURCE_p = 1;
        @(posedge i_CLK);   i_SOURCE_p = 0;
        #60;
        @(posedge i_CLK);   i_SOURCE_p = 1;
        @(posedge i_CLK);   i_SOURCE_p = 0;
        #1000;
        @(posedge i_CLK);   i_SOURCE_p = 1;
        #100;
        @(posedge i_CLK);   i_SOURCE_p = 0;
    end
endmodule
