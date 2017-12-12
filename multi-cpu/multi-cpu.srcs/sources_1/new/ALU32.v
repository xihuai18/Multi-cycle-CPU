module ALU32(
	input wire [2:0] ALUopcode,
	input wire [31:0] rega,
	input wire [31:0] regb,
	output wire zero,
	output wire sign,
	output reg [31:0] result
	);

assign zero = (result==0)? 1:0;
assign sign = result[31];

always @(ALUopcode or rega or regb) begin
	case(ALUopcode)
		3'b000: result = rega + regb;
		3'b001: result = rega - regb;
		3'b010: result = (rega < regb)? 1:0;
        3'b011:begin
        if(rega < regb && (rega[31] == regb[31]))
            result = 1;
        else if(rega[31] == 1 && regb[31] == 0) result =  1;
        else result = 0;
        end
        3'b100: result = regb << rega;
		3'b101: result = rega | regb;
		3'b110: result = rega & regb;
		
		3'b111: result = (~rega & regb) | (rega & ~regb);
		default: begin
			result = 0;
		end
		endcase
end

endmodule