/* UART通信仕様
baurate 115200,パリティなし、8N1,ストップ1bit
受信文字はAsciiで解釈し先頭から
・コマンド(1文字 w / r)
・アドレス(2文字 Hex)
・ライトデータ(4文字 Hex)

UARTタスクのAPI

UART_WR(8'h12,8'h34);
→ Asciiで w(0x77)+アドレス+データ+改行
UART_RD(8'h12);
→ Asciiで r(0x72)+アドレス+改行

*/


`timescale 1ns / 1ps

// typedef struct packed {
//     logic [31:0] Data;
//     logic [7:0]  Address;
//     logic        Rd_Ena;
//     logic        Wr_Ena;
// } bus_signal_t;



module UART_BUS_MASTER_tb();
    reg         i_CLK       =0  ;
    reg         i_RST_p     =1  ;
    reg         i_UART_RX   =1  ;
    wire        o_UART_TX;

    wire        o_BUS_Wr_Ena;
    wire        o_BUS_Rd_Ena;
    wire [7:0]  o_BUS_Address;
    wire [31:0] o_BUS_Data;

    //モジュールインスタンス
    UART_BUS_MASTER_wrapper DUT(
        .i_CLK          (i_CLK),
        .i_RST_p        (i_RST_p),
        .i_UART_RX      (i_UART_RX),
        .o_UART_TX      (o_UART_TX)
   );

    `include "uart_tasks.sv"
    // //always@(w_RD_ENA_p,w_ADDRESS)begin
    // always@(posedge i_CLK)begin
    //     if(w_RD_ENA_p)begin
    //         case(w_ADDRESS)
    //             8'h12   : i_ACK_DATA=16'h1234;
    //             8'h34   : i_ACK_DATA=16'h5678;
    //             default : i_ACK_DATA=16'hzzzz;
    //         endcase
    //     end else begin
    //         i_ACK_DATA=16'hzzzz;
    //     end
    // end
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
        // データ書き込みコマンド: アドレス=0x12, データ=0xABCD1234
        uart_write_cmd(8'hA0, 32'h12345678);

        #(BAUD_RATE * 20);  // コマンド終了後に待機
        // データ読み込みコマンド: アドレス=0x34
        uart_read_cmd(8'hA0);
//        #(BAUD_RATE * 100);  // コマンド終了後に待機
        
        // 別のデータ書き込みコマンド
//        uart_write_cmd(8'hAB, 32'h12345678);
//        #(BAUD_RATE * 100);
        
    end

endmodule
