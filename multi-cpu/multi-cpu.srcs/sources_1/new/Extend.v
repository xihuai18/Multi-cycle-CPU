module Extend(
	input ExtSel, 
	input [15:0] OriData,
	output reg [31:0] ExtData
	);

always @(ExtSel or OriData) begin
	if(0 == ExtSel)
		ExtData <= {16'b0, OriData};
	 else if(1 == OriData[15])
	 	ExtData <= {16'hffff, OriData};
	 else ExtData <= {16'h0000, OriData}; 
end

endmodule