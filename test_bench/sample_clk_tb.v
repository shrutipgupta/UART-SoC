`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2020 15:29:26
// Design Name: 
// Module Name: sample_clk_tb
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


module sample_clk_tb();
reg clk;
wire sample_clk;

always #5 clk = ~clk;
initial 
    clk <= 1'b0;
    
sample s_clk(.clk(clk), .sample_clk(sample_clk));
endmodule
