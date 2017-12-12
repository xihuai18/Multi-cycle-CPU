module IR(
    input wire [31:0] in,
    input wire CLK,
    input wire IRWre,
    output reg [31:0] out
);

always @(negedge CLK) begin
    if (1 == IRWre)
        out <= in;
    else out <= out;
end



endmodule