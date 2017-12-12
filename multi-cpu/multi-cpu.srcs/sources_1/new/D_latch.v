module D_latch(
    input wire CLK,
    input wire [31:0] in,
    output reg [31:0] out
);

always @(negedge CLK) begin
    out <= in;
end 

endmodule 