`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/08 00:23:47
// Design Name: 
// Module Name: multi_Cpu_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multi_Cpu_sim();
reg CLK;
reg Reset;
initial begin
    CLK = 0;
    Reset = 1;
    
    #100 Reset = 0;
    
    #2080 Reset = 1;
    #100 Reset = 0;
end

always #50 CLK = ~CLK;

top uut(.CLK(CLK), .Reset(Reset));

endmodule
