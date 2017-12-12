module Instruction_Memory(
	input [31:0] IAddr, 
	input [31:0] IDataIn, 
	input wire InsMemRW,
	output reg [31:0] IDataOut 
	);

reg [7:0] Ins_mem[0:127];

initial begin
		$readmemb("../../../test.txt",Ins_mem);
	end

always @(IAddr or IDataIn or InsMemRW) begin
	
	if(1 == InsMemRW) begin
		IDataOut[31:24] <= Ins_mem[IAddr]; 
    IDataOut[23:16] <= Ins_mem[IAddr+1]; 
		IDataOut[15:8] <= Ins_mem[IAddr+2]; 
		IDataOut[7:0] <= Ins_mem[IAddr+3];
	end
end



endmodule