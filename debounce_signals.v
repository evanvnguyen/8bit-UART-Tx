`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2021 03:22:36 PM
// Design Name: 
// Module Name: debounce_signals
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: this is defunct, dont use this
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce_signals #(parameter threshold = 1000000)(
        
    input clk,
    input btn, 
    output reg transmit 
    );
    
    reg button_ff1 = 0;     // FF's for synch, set to 0
    reg button_ff2 = 0; 
    reg [31:0] count = 0;   // 32 BIT DELAY INC/DEC WHEN BTN PRESSED/RELEASED
    
    //First use two FF to synchronize the button signal, "clk", clock domain
    
    always @(posedge clk)
        begin
            button_ff1 <= btn;
            button_ff2 <= button_ff1;
        end
    
    //WHEN PUSH BUTTON IS PRESSED/RELEASED, INCREMENT/DECREMENT COUNTER
   
    always @(posedge clk)
        begin
            if (button_ff2)                 // if button_ff2 is high
                begin
                    if (~&count)            // if it isn't at the count limit, make sure you won't count up at the limit. First AND all count and then not the AND
                    count <= count + 1000;     // when btn is pressed, count up
                end
            else 
                begin
                    if (|count)             // if count has at least 1 in it, making sure no subtract when count is 0
                        count <= count - 1000; // when btn is released, count down 
                end
            if (count > threshold)          // if the count is larger than the threshhold
                transmit <= 1;              // debounced signal is 1
            else
                transmit <= 0;              // debounced signal is 0
        end
 endmodule
    
