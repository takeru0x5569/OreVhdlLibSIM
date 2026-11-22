`timescale 1ns / 1ps

module DESERIALIZER_tb();
    reg         i_CLK = 0;
    reg         i_RST_p = 1;
    reg         i_SERIAL = 0;
    reg         i_SHIFT_p = 0;
    reg         i_POP_p = 0;
    wire        o_ENA_p;
    wire [7:0]  o_PARALLEL;

    DESERIALIZER #(.BIT_WIDTH(8)) u_DESERIALIZER (
        .i_CLK(i_CLK),
        .i_RST_p(i_RST_p),
        .i_SERIAL(i_SERIAL),
        .i_SHIFT_p(i_SHIFT_p),
        .i_POP_p(i_POP_p),
        .o_ENA_p(o_ENA_p),
        .o_PARALLEL(o_PARALLEL)
    );

    always #10 i_CLK = ~i_CLK;
    //
    task shift_byte(input [7:0] data);
        integer i;
        begin
            for (i = 7; i >= 0; i=i-1) begin
                @(negedge i_CLK);
                i_SERIAL = data[i];
                i_SHIFT_p = 1;
            end
            @(negedge i_CLK);
            i_SHIFT_p = 0;
        end
    endtask

    initial begin
        #40 i_RST_p = 0;
        shift_byte(8'hA6);

        @(negedge i_CLK) i_POP_p = 1;
        @(negedge i_CLK) i_POP_p = 0;
        repeat (3) @(negedge i_CLK);

        shift_byte(8'h3D);
        @(negedge i_CLK) i_POP_p = 1;
        @(negedge i_CLK) i_POP_p = 0;

        #40 $finish;
    end
endmodule
