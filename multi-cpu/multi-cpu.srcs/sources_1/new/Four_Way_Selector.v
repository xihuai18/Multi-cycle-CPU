module Four_Way_Selector(
	input [31:0] In0,
	input [31:0] In1,
	input [31:0] In2,
	input [31:0] In3,
	input [1:0] Selector,
	output reg [31:0] Out
	);

always @(Selector or In0 or In1 or In2 or In3) begin
	case(Selector)
	2'b00: Out <= In0;	
	2'b01: Out <= In1;	
	2'b10: Out <= In2;	
	2'b11: Out <= In3;	
	default: Out <= 32'b0;
	endcase
end

endmodule