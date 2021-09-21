`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Evan Nguyen
// 
// Create Date: 09/20/2021 12:17:20 AM
// Design Name: 
// Module Name: debounce_btn
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


module debounce_btn(
    input clk,
    input btn, 
    output transmit
    );
    
    wire slow_clk_en;
    wire Q1, Q2, Q2_bar, Q0;
    
    clk_en clken1(.clk_in(clk), .slow_clk_en(slow_clk_en));
    
    // instead of creating a a new clock domain using clock divders,
    // we can generate the clock enable signal to drive the debonucing flip flops
    
    ff ff0(.clk(clk), .en(slow_clk_en), .D(btn), .Q(Q0));
    ff ff1(.clk(clk), .en(slow_clk_en), .D(Q0), .Q(Q1));
    ff ff2(.clk(clk), .en(slow_clk_en), .D(Q1), .Q(Q2));
    
    assign Q2_bar = ~Q2;
    assign transmit = Q1 & Q2_bar;
            
endmodule
