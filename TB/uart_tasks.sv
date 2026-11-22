// ============================================================================
// UART Test Tasks
// ============================================================================
// UART通信仕様:
//   ボーレート: 115200
//   パリティ: なし
//   データビット: 8bit
//   ストップビット: 1bit
//   フレーム: [Start(1) + Data(8) + Stop(1)]
//
// コマンド形式:
//   W: w + Address(2Hex) + Data(4Hex) + LF
//   R: r + Address(2Hex) + LF
// ============================================================================

// UART ボーレート定義
localparam integer BAUD_RATE  = 115200;
localparam integer BIT_PERIOD = 8680;  // 1e9 / 115200 ≈ 8680 ns

// ============================================================================
// UART 1バイト送信タスク
// ============================================================================
task automatic uart_send_byte(input [7:0] data);
    integer i;
    reg [9:0] frame;  // [Start(0) + Data(8) + Stop(1)]
    
    frame = {1'b1, data, 1'b0};  // Start bit (0) + 8bit data + Stop bit (1)
    
    $display($time, "ns : UART TX Byte: 0x%02h", data);
    //送出順序はLSBから
    for (i = 0; i < 10; i = i + 1) begin
        i_UART_RX = frame[i];
        #(BIT_PERIOD);
    end
    #(BIT_PERIOD);
    #(BIT_PERIOD);

endtask

// ============================================================================
// ASCII 16進数1桁を文字コードに変換 (0-15 -> '0'-'9','A'-'F')
// ============================================================================
function [7:0] hex_to_ascii(input [3:0] hex_val);
    if (hex_val < 4'd10) begin
        hex_to_ascii = 8'h30 + hex_val;  // '0' - '9'
    end else begin
        hex_to_ascii = 8'h41 + hex_val - 4'd10;  // 'A' - 'F'
    end
endfunction

// ============================================================================
// UART ライトコマンド送信タスク
// 引数: addr - 8bitアドレス, data - 32bitデータ
// 送信形式: w + addr(2Hex) + data(8Hex) + LF
// 例: w12ABCD1234\n
// ============================================================================
task automatic uart_write_cmd(input [7:0] addr, input [31:0] data);
    uart_send_byte(8'h77);  // 'w'
    
    // アドレスを2桁の16進ASCIIで送信
    // uart_send_byte(hex_to_ascii(addr[7:4]));  // 上位4bit
    // uart_send_byte(hex_to_ascii(addr[3:0]));  // 下位4bit
    uart_send_byte(addr);
    uart_send_byte(data[7:0]);  
    uart_send_byte(data[15:8]); 
    uart_send_byte(data[23:16]);
    uart_send_byte(data[31:24]);
    
    // // データを8桁の16進ASCIIで送信
    // uart_send_byte(hex_to_ascii(data[31:28]));  // 最上位4bit
    // uart_send_byte(hex_to_ascii(data[27:24]));
    // uart_send_byte(hex_to_ascii(data[23:20]));
    // uart_send_byte(hex_to_ascii(data[19:16]));
    // uart_send_byte(hex_to_ascii(data[15:12]));
    // uart_send_byte(hex_to_ascii(data[11:8]));
    // uart_send_byte(hex_to_ascii(data[7:4]));
    // uart_send_byte(hex_to_ascii(data[3:0]));   // 最下位4bit
    
    uart_send_byte(8'h0A);  // LF (Line Feed)
    
    $display($time, "ns : UART W-CMD: addr=0x%02h, data=0x%08h", addr, data);
endtask

// ============================================================================
// UART リードコマンド送信タスク
// 引数: addr - 8bitアドレス
// 送信形式: r + addr(2Hex) + LF
// 例: r12\n
// ============================================================================
task automatic uart_read_cmd(input [7:0] addr);
    uart_send_byte(8'h72);  // 'r'

    uart_send_byte(addr);

    // アドレスを2桁の16進ASCIIで送信
    // uart_send_byte(hex_to_ascii(addr[7:4]));  // 上位4bit
    // uart_send_byte(hex_to_ascii(addr[3:0]));  // 下位4bit
    
    uart_send_byte(8'h0A);  // LF (Line Feed)
    
    $display($time, "ns : UART R-CMD: addr=0x%02h", addr);
endtask

// ============================================================================
// UART ウェイトタスク (複数ビット期間待機)
// ============================================================================
task automatic uart_wait_bits(input integer num_bits);
    #(BIT_PERIOD * num_bits);
endtask
