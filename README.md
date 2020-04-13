# Introduction:
This is an implementation of the UART module using Verilog HDL, which enables the establishment of transmitter and reciever on the FPGA board which can be then used to communicate. Both the transmitter and recievers can function at the same time. And they are synchronised with their respective Receiver and Transmitters. 
# Components:
The main components are the Interface module (which manages the input and output signals to the UART module and synchronizes them), the Baud rate generator (which genertes the clock at baud rate by dividing the original clk) and the reciever and transmitter modules.
# Transmitter module:
It functions at the baud rate and generates the signal to be transmitted at every negative edge of the clock (with baud rate frequency). This beginnig of any transmission cycle is controlled by the Ideal signal and then a High to low transition in the Tx signal. Then the signals can be sampled at the receiver at the negative edge of the clock.
# Receiver module:
The receiver samples the received signal 16 times in one clock cycle and then uses the majority of readings to decide the final value. This removes the chances of errors occuring due to short glitches.
# Interrupt control: 
The parity bit is assigned to every 8 bit data transferred and hence there is a provision for the receiver to generate an interrupt in case a wrong value is transmitted which does not satisfy the parity condition. This interrupt causes the previous sample to be resent.
# Future plans:
The project is under construction. 
