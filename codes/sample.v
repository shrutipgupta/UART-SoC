`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2020 15:14:53
// Design Name: 
// Module Name: sample
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


module sample(clk, sample_clk);

input clk;
output reg sample_clk;

reg [3:0]counter;

initial
begin
    counter = 4'b0000;
    sample_clk = 1'b0;
end
always @(posedge clk)
    if(counter==4'b1110)
    begin
        counter = 4'b0000;
        sample_clk = ~sample_clk;
    end
    else
        counter = counter + 4'b0001; 
endmodule
