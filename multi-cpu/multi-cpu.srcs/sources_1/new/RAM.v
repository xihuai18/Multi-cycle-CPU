
module RAM(
	input [31:0] Daddr,
	input [31:0] DataIn,
	input RD,    //0, read; 1, output Z
	input WR,    //0, write; 1, nothing
	output [31:0] DataOut 
	);

reg [7:0] memory [0:63];

assign DataOut[31:24] = (RD==1)? 8'bz: memory[Daddr];
assign DataOut[23:16] = (RD==1)? 8'bz:memory[Daddr+1];
assign DataOut[15:8] = (RD==1)? 8'bz:memory[Daddr+2];
assign DataOut[7:0] = (RD==1)? 8'bz:memory[Daddr+3];

always @(Daddr or DataIn or RD or WR) begin
	if(0 == WR) begin
		memory[Daddr] <= DataIn[31:24];
		memory[Daddr+1] <= DataIn[23:16];
		memory[Daddr+2] <= DataIn[15:8];
		memory[Daddr+3] <= DataIn[7:0];
	end
end
endmodule