module display(
    input [1:0] SW_in,
    input [7:0] PC, [7:0] PCNext,
    input [7:0] RSAddr, [7:0] RSData,
    input [7:0] RTAddr, [7:0] RTData,
    input [7:0] ALUResult, [7:0] DB,
    output reg [7:0] out1, reg [7:0] out2
);
    
always @(SW_in)begin
    begin
        case(SW_in)
        2'b00: {out1,out2} = {PC,PCNext};
        2'b01: {out1,out2} = {RSAddr,RSData};
        2'b10: {out1,out2} = {RTAddr,RTData};
        2'b11: {out1,out2} = {ALUResult,DB};
        default: {out1,out2} = 16'b0000_0000_0000_0000;
        endcase
    end
end 
    

endmodule
