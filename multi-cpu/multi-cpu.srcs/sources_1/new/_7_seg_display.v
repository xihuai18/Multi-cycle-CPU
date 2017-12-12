module _7_seg_display(
	input wire [3:0] BCD,
	output reg [7:0] code
	);

always @(BCD) 
begin
case(BCD)
    4'b0000: code = 8'b1100_0000;
    4'b0001: code = 8'b1111_1001;
    4'b0010: code = 8'b1010_0100;
    4'b0011: code = 8'b1011_0000;
    4'b0100: code = 8'b1001_1001;
    4'b0101: code = 8'b1001_0010;
    4'b0110: code = 8'b1000_0010;
    4'b0111: code = 8'b1101_1000;
    4'b1000: code = 8'b1000_0000;
    4'b1001: code = 8'b1001_0000;
    4'b1010: code = 8'b1000_1000;
    4'b1011: code = 8'b1000_0011;
    4'b1100: code = 8'b1100_0110;
    4'b1101: code = 8'b1010_0001;
    4'b1110: code = 8'b1000_0110;
    4'b1111: code = 8'b1000_1110;
    default: code = 8'b1111_1111;
    endcase
end

endmodule