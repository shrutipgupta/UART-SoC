`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2020 15:35:21
// Design Name: 
// Module Name: transmit
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


module transmit(br, start, stop, parity, intt, thr, prev, thr_out, tx);

input br;
input start, stop, intt;
input [1:0]parity;
input [7:0]thr, prev;
output reg [7:0]thr_out;
output reg tx;
reg mode;

always @(posedge br)
begin
    if({start,stop}==2'b10)
    begin
        tx = 1'b0;
        thr_out = thr;
        mode = 1'b1;
    end
    else 
        if({start,stop}==2'b01)
        begin
            tx = 1'b1;
            mode = 1'b1;
        end
        else
            if(parity[0]==1'b1)
            begin
                tx = parity[1];
                mode = 1'b1;
            end
            else
            begin
                mode = 1'b0;
                if(intt == 1'b1)
                    thr_out = prev;
                else
                    thr_out = thr;
            end
        
end

always @(negedge br)
begin
    if(mode == 1'b0)
    begin
    thr_out[7] <= 1'b0;
    thr_out[6] <= thr_out[7];
    thr_out[5] <= thr_out[6];
    thr_out[4] <= thr_out[5];
    thr_out[3] <= thr_out[4];
    thr_out[2] <= thr_out[3];
    thr_out[1] <= thr_out[2];
    thr_out[0] <= thr_out[1];
    tx <= thr_out[0];
    end
end             
endmodule
