`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2021 03:44:29 PM
// Design Name: 
// Module Name: top
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


module top(
        input [7:0] data,
        input clk,
        input transmit,
        input reset,
        output txd,
        output txd_debug,
        output transmit_debug,
        output btn_debug, 
        output clk_debug
    );
    
    wire transmit_out;
    
    assign txd_debug = txd;
    assign transmit_debug = transmit_out;
    assign btn_debug = reset;
    assign clk_debug = clk;
    
    tx t1(.clk(clk), .reset(reset), .data(data), .transmit(transmit_out), .txd(txd));
    debounce_btn db(.clk(clk), .btn(transmit), .transmit(transmit_out));
    
endmodule
