`timescale 1ns / 1ps

module UART_TX_tb();
    reg         i_CLK       =0;
    reg         i_RST_p     =1;
    reg         i_DATA_SET_p=0;
    reg [31:0] i_DATA = 32'hZZZZZZZZ;
    wire        o_UART_TX;
    wire        o_BUSY_h;
    //モジュールインスタンス
    UART_TX uUART_TX(
        .i_CLK          (i_CLK),
        .i_RST_p        (i_RST_p),
        .i_DATA_SET_p   (i_DATA_SET_p),
        .i_DATA         (i_DATA),
        .o_BUSY_h       (o_BUSY_h),
        .o_UART_TX      (o_UART_TX)
    );
    // クロック50MHz
    always #10 i_CLK = ~i_CLK;
    // リセット
    initial begin
        i_RST_p = 1;
        #200;
        i_RST_p = 0;
        // UART通信タスクのサンプル使用方法
        // リセット解除後、少し待機
        #5000;
        @(posedge i_CLK);
        i_DATA_SET_p = 1;
        i_DATA = 32'h81CCF05A;
        @(posedge i_CLK);
        i_DATA_SET_p = 0;
        i_DATA = 32'hZZZZZZZZ;
        
        #500;
        @(posedge i_CLK);
        i_DATA_SET_p = 1;
        @(posedge i_CLK);
        i_DATA_SET_p = 0;

    end

endmodule
