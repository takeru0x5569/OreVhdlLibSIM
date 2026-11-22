`timescale 1ns / 1ps

module FIX_DELAY_LINE_tb();
    reg         i_CLK       =0;
    reg         i_RST_p     =1;
    reg         i_SOURCE_p =0;
    wire        o_DELAY_p;
    wire        o_BUSY;
    //モジュールインスタンス
    FIX_DELAY_LINE uFIX_DELAY_LINE(
        .i_CLK          (i_CLK),
        .i_RST_p        (i_RST_p),
        .i_SOURCE_p     (i_SOURCE_p),
        .o_DELAY_p      (o_DELAY_p),
        .o_BUSY         (o_BUSY)
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
    end
endmodule
