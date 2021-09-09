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
        input reset,
        input transmit,
        output txd,
        output txd_debug,
        output btn_debug,
        output clk_debug
    );
    
    wire transmit_out;
    
    tx t1(clk, reset, data, transmit, txd);
    debounce_signals db(clk, btn, transmit_out);
    
    assign txd_debug = txd;
    assign transmit_debug = transmit_out;
    assign btn_debug = reset;
    assign clk_debug = clk;
endmodule
