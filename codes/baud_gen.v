`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2020 13:24:25
// Design Name: 
// Module Name: baud_gen
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


module baud_gen(clk, br, dll, dlh);

input clk;
output reg br;
input [7:0]dll;
input [3:0]dlh;
reg [11:0]counter;

initial 
begin
    counter = 12'b0000_0000_0000;
    br = 1'b0;
end
always @(posedge clk)
begin
 counter <= counter + 12'b0000_0000_0001;
 if(counter>={dlh,dll-8'b0000_0001})
 begin
  counter <= 12'b0000_0000_0000;
  br = ~br;
 end
 if(counter == {1'b0,dlh,dll[6:0]})
    br = ~br;
end

endmodule
