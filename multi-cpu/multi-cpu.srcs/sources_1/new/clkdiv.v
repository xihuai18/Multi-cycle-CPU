`timescale 1ns / 1ps
module clkdiv(
	input wire reset,
	input wire mclk,
	output wire clk190,
	output wire clk1000
	);
reg [26:0] q;

always @(posedge mclk or posedge reset) begin
begin
	if (reset == 1)
		q <= 0;
	else
		q <= q + 1;		
	end
end
assign clk190 = q[18];
assign clk1000 = q[16];

endmodule