module Selector_Dst(
    input wire [4:0] In0,
    input wire [4:0] In1,
    input wire [4:0] In2,
    input wire [1:0] Selector,
    output reg [4:0] Out
    );
 
always @(Selector or In0 or In1 or In2) begin
        case(Selector)
        2'b00: Out <= In0;    
        2'b01: Out <= In1;    
        2'b10: Out <= In2;    
        default: Out <= 32'b0;
        endcase
    end   
 
endmodule
