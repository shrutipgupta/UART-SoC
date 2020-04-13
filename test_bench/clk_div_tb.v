`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2020 14:12:12
// Design Name: 
// Module Name: clk_div_tb
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


module clk_div_tb();
reg clk;
reg [7:0]dll,dlh;
wire br;
wire [15:0]counter;

always #5 clk = ~clk;
initial 
begin
clk <= 1; dll <= 8'b0000_0110; dlh <= 8'b0000_0000;
end

baud_gen uut(.clk(clk), .br(br), .dll(dll), .dlh(dlh[3:0]), .counter(counter));
endmodule
