`timescale 1ns / 1ps

module UART_RX_tb();
    localparam integer BIT_PERIOD = 8680; // baudrate115200=8680[ns] 
    //UARTの送信状態を波形で見やすいようにENUM定義する
    typedef enum logic [3:0] {
        IDLE, START, D0, D1, D2, D3, D4, D5, D6, D7, STOP
    } uart_state_t;

    reg         i_CLK = 0;
    reg         i_RST_p = 1;
    reg         i_UART_RX = 1;
    uart_state_t uart_state = IDLE;
    //テスト対象
    UART_RX #(.BIT_WIDTH(8)) u_UART_RX (
        .i_CLK(i_CLK),
        .i_RST_p(i_RST_p),
        .i_UART_RX(i_UART_RX),
        .o_DATA(),
        .o_ENABLE_p()
    );
    //50MHzクロック
    always #10 i_CLK = ~i_CLK;
    //------------------------------------------
    //UART送信タスク
    //------------------------------------------
    task automatic uart_send_byte(input [7:0] data);
        integer bit_index;
        begin
            //スタートビット
            uart_state = START;
            i_UART_RX = 0;
            #(BIT_PERIOD);
            //データビット(LSBファースト)
            for (bit_index = 0; bit_index < 8; bit_index = bit_index + 1) begin
                case (bit_index)
                    0: uart_state = D0;
                    1: uart_state = D1;
                    2: uart_state = D2;
                    3: uart_state = D3;
                    4: uart_state = D4;
                    5: uart_state = D5;
                    6: uart_state = D6;
                    7: uart_state = D7;
                endcase
                i_UART_RX = data[bit_index];
                #(BIT_PERIOD);
            end
            //ストップビット
            uart_state = STOP;
            i_UART_RX = 1;
            #(BIT_PERIOD);
            //アイドルに戻す
            uart_state = IDLE;
        end
    endtask
    //------------------------------------------
    //テストシナリオ
    //------------------------------------------
    initial begin
        #40 i_RST_p = 0;
        #(BIT_PERIOD);
        uart_send_byte(8'hC9);
        #(BIT_PERIOD*5);
        uart_send_byte(8'h65);
        #(BIT_PERIOD);
        $stop;
    end
endmodule
