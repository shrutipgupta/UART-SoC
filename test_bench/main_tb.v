`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2020 15:24:05
// Design Name: 
// Module Name: main_tb
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


module main_tb();

reg clk, ideal, intt, ideal_rx, rx;
reg [7:0]lcr, dll, dlh;
wire tx;

always #5 clk = ~clk;

initial 
begin 
    //The reciever clock is derived from the main clock by dividing with 16. Thus an ideal pulse is given for 50 ns and then the rx bits are 
    //given as a pulse for 300 ns. (i.e. any value of rx is maintained for 300 ns)
    clk <= 0; ideal_rx <= 1'b1; ideal <= 1'b1; intt <= 1'b0; lcr <= 8'b1000_1011; dll <= 8'b0000_0010; dlh <= 8'b0000_0000; rx <= 1'b0;#50;
    //Initially no transmission or reception (No interrupt issues as nothing is transmitted)
    //For parity style (xx0 No parity bit, 001 Odd, 011 Even, 101 High stick parity, 111 Low stick parity
    //Tx is generated at negedge
    //Rx is sampled at negedge
    ideal_rx <= 1'b0; ideal <= 1'b0; rx <= 1'b1;#300;
    rx <= 1'b0;#300;
    rx <= 1'b0;#300;
    rx <= 1'b1;#300;
    rx <= 1'b0; intt <= 1'b1;#50;
    intt <= 1'b0;#300;
    rx <= 1'b1;#300;
    rx <= 1'b0;#300;
    rx <= 1'b1;#300;
    rx <= 1'b1;#300;
    rx <= 1'b0;#300;
    rx <= 1'b0;#300;
end

interface uut(.clk(clk), .ideal_rx(ideal_rx), .ideal(ideal), .intt(intt), .lcr(lcr), .dll(dll), .dlh(dlh), .rx(rx), .tx(tx));  
endmodule
