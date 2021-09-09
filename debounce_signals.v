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
// Description: 
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
     
    // internals
    
    reg button_ff1 = 0;                             // button FF for synch, initially set to 0
    reg button_ff2 = 0;
    reg [30:0] count = 0;                           // 20 bits count for increment and decrement when button is pressed/released
    
    // use the 2 ff's to synchronize button signal, clk domain
    
    always @(posedge clk)
        begin
            button_ff1 <= btn;                      // push button is feeded to flip flop, and each cascaded
            button_ff2 <= button_ff1;
        end
        
    // when push button is pressed or released, we increment/decrement counter
        
    always @(posedge clk)
        begin
            if (button_ff2)                         // if button_ff2 is high
                begin
                    if (~&count)                    // if it isnt at the count limit, make sure we dont count up at limit. AND all count, then not the end
                        count <= count+1;           // when button pressed, count up
                 end
                 else
                    begin
                        if (|count)                 // if count has atleast  in it, make sure no subtraction when count is 0
                            count <=count-1;        //when button is released, count down
                    end
                        if (count > threshold)      // if count is larger than threshold
                            transmit <= 1;          // debounced signal is 1
                        else
                            transmit <= 0;          // debounced signal is 0
        end
endmodule
