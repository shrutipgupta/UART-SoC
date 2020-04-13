`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2020 13:21:37
// Design Name: 
// Module Name: interface
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


module interface(clk, ideal_rx, ideal, intt, lcr, dll, dlh, rx, tx);

input clk, ideal, intt;
input [7:0]lcr, dll, dlh;
output tx;
input rx, ideal_rx;

reg [7:0]conf_mod[7:0];
wire br;
wire [7:0]thr_out;
reg [3:0]counter;

initial
begin
    conf_mod[0] = 8'b0000_0000;//THR
    conf_mod[1] = 8'b0000_0000;//RHR
    conf_mod[2] = 8'b0000_0000;//FIFO Reg - not used as FIFO is not used - NOT USED
    conf_mod[3] = 8'b0000_0000;//LCR Reg - Set to the default Star bit, 8 bit data, Stop bit, Parity (Parity variations allowed)
    conf_mod[4] = 8'b0000_0000;//LSR - Data available,Parity error,Stop,_,_,put_parity,parity_curr,Start
    conf_mod[5] = 8'b0000_0000;//Interrupt reg - NOT USED (As other options like Modem are unavailable)
    conf_mod[6] = 8'b0000_0000;//DLL
    conf_mod[7] = 8'b0000_0000;//DLH - for baud rate generation
    counter = 4'b0000;
end

always @(negedge clk)
begin 
    if(ideal==1'b1) //Write stage - transmission not started, the rules (data width and format) are determined here
    begin
        conf_mod[3] = lcr;
        conf_mod[6] = dll;
        conf_mod[7] = dlh;
    end
end

reg [3:0]d_count;
reg [7:0]data[15:0];
reg [7:0]prev;

initial 
begin
    d_count = 4'b0000; 
    data[0] = 8'b1011_1000;
    data[1] = 8'b0010_1111;
    data[2] = 8'b0101_1101;
    data[3] = 8'b1101_0101;
    data[4] = 8'b0101_0101;
    data[5] = 8'b1010_1010;
    data[6] = 8'b0101_0101;
    data[7] = 8'b0100_0010;
    data[8] = 8'b0111_1010;
    data[9] = 8'b0101_0111;
    data[10] = 8'b0101_0110;
    data[11] = 8'b0101_0100;
    data[12] = 8'b0111_1001;
    data[13] = 8'b0000_0010;
    data[14] = 8'b0101_0101;
    data[15] = 8'b1010_1110;
end

always @(posedge br)
if(ideal==1'b0)
begin
    if(conf_mod[4][0]==1'b1)
    begin
        if(d_count==4'b0000)
            prev = data[4'b0000];
        else
            prev = data[d_count-4'b0001];
        conf_mod[0] = data[d_count];
        if(d_count==4'b1111)
            d_count = 4'b0000;
        else
            d_count = d_count + 4'b0001;
    end
    else
        conf_mod[0] = thr_out;
    case(lcr[3])
    1'b0:
    begin
        if(counter==4'b1001)
            counter = 4'b0000;
        else
            counter = counter + 4'b0001;   
    end
    1'b1:
    begin
        if(counter==4'b1010)
            counter = 4'b0000;
        else
            counter = counter + 4'b0001;
    end
    endcase
    if(counter[3:1] == 3'b000)
        conf_mod[4][1] = 1'b0;
    else
        if(tx==1'b1)
            conf_mod[4][1] = ~conf_mod[4][1];
end

always @(negedge br)
if(ideal==1'b0)
begin
    if(intt==1'b1)
        d_count = d_count-4'b0001;
    case(lcr[3])
    1'b0:
    begin
    conf_mod[4][2] = 1'b0;
    if(counter==4'b1001)
    begin
        conf_mod[4][5] = 1'b0;
        conf_mod[4][0] = 1'b1;
    end
    if(counter==4'b0000)
        conf_mod[4][0] = 1'b0;
    if(counter==4'b1000)
        conf_mod[4][5] = 1'b1;
    end
    1'b1:
    begin
    if(counter==4'b1010)
    begin
        conf_mod[4][0] = 1'b1;
        conf_mod[4][6] = 1'b0;
        conf_mod[4][2] = 1'b0;
    end
    if(counter==4'b1001)
        conf_mod[4][5] = 1'b0;
    if(counter==4'b0000)
        conf_mod[4][0] = 1'b0;
    if(counter==4'b1000)
        conf_mod[4][5] = 1'b1;
    if(counter==4'b1001)
    begin
        case(lcr[5:3])
        3'b001: conf_mod[4][6] = ~conf_mod[4][1];
        3'b011: conf_mod[4][6] = conf_mod[4][1];
        3'b101: conf_mod[4][6] = 1'b1;
        3'b111: conf_mod[4][6] = 1'b0;
        endcase
        conf_mod[4][2] = 1'b1;
    end
    end
    endcase
end

baud_gen brg(.clk(clk), .br(br), .dll(conf_mod[6]), .dlh(conf_mod[7][3:0]));
transmit tx_blk(.br(br), .start(conf_mod[4][0]), .stop(conf_mod[4][5]), .parity({conf_mod[4][6],conf_mod[4][2]}), .intt(intt), .thr(conf_mod[0]), .prev(prev), .thr_out(thr_out), .tx(tx));

reg [7:0]rec_data[7:0];
wire sample_clk;
wire [7:0]rv_data;
reg [2:0]d_count2, rx_count;
initial
begin 
    d_count2 = 3'b000;
    rx_count = 3'b000;
    rec_data[0] = 8'b0000_0000;
    rec_data[1] = 8'b0000_0000;
    rec_data[2] = 8'b0000_0000;
    rec_data[3] = 8'b0000_0000;
    rec_data[4] = 8'b0000_0000;
    rec_data[5] = 8'b0000_0000;
    rec_data[6] = 8'b0000_0000;
    rec_data[7] = 8'b0000_0000;
end
   
always @(negedge sample_clk)
if(ideal_rx==1'b0)
begin
    if(rx_count == 3'b000)
    begin
        rec_data[d_count2] = rv_data;
        if(d_count2 == 3'b111)
            d_count2 = 3'b000;
        else
            d_count2 = d_count2 + 3'b001;
    end 
    rx_count = rx_count + 3'b001;
end  

sample sc(.clk(clk), .sample_clk(sample_clk));
recv rv(.clk(clk), .sample_clk(sample_clk), .rx(rx), .ideal_rx(ideal_rx), .rv_data(rv_data));
endmodule
