`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 03:20:40 AM
// Design Name: 
// Module Name: clock_div
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


module clk_div(
    input clk_in,
    output reg clk_out
    );
    
    // this module divides the clk to a slower one
    reg[27:0] counter = 28'd0;
    parameter DIVISOR = 28'd2;
    
    always @(posedge clk_in)
        begin
            counter <= counter + 28'd1;
            if (counter >= (DIVISOR-1))
                counter <= 28'd0;
            clk_out <= (counter < DIVISOR / 2) ? 1'b1: 1'b0;
        end
endmodule
