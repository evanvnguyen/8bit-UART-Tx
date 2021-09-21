`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 03:40:16 AM
// Design Name: 
// Module Name: clk_en
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


module clk_en(
    input clk_in,
    output slow_clk_en
    );
    
    reg[26:0] counter = 0;
    always @(posedge clk_in)
        begin
            counter <= (counter >= 249999) ? 0:counter + 1;
        end
        
    assign slow_clk_en = (counter == 249999) ? 1'b1: 1'b0;
        
endmodule
