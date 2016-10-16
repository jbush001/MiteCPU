module testbench;
    reg clk = 0;
    wire[7:0] result;

    tinyproc t(clk, result);

    initial
    begin
        repeat(300)
            #5 clk = !clk;

        $display("result = %02x", result);
    end
endmodule
