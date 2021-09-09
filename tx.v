`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2021 02:01:11 PM
// Design Name: 
// Module Name: tx
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


module tx(
    input clk,
    input reset,
    input [7:0] data,
    input transmit,
    output reg txd
    );
    
    // internals
    
    reg [3:0] bit_counter; // Counts the 10 bits 
    reg [13:0] br_counter;// 14 bits covers 10,415, counter=clock (100mhz) / BR (9600)
    reg [9:0] shiftr_reg; // 10 bits serially transmitted through UART to board
    
    reg state, next_state; // idle and transmit modes
    
    reg shift; // signal to shifts bits into UART
    reg load; // signal to load bits into shift register. also adds stop/start bits
    reg clear;  // clears bits for UART transmission
    
    // UART Transmission
    
    always @(posedge clk)
        begin
            if (reset)
                begin
                    state <= 0;                 // state is idle
                    bit_counter <= 0;           // counter for bit transmission reset to 0
                    br_counter <= 0;
                end 
             else 
                begin
                    br_counter <= br_counter + 1;
                end
                if (br_counter == 10415)
                    begin
                        state <= next_state;                    // state changes from idle to transmitting
                        br_counter <= 0;                        // reset counter when reaches 10415
                        if (load) 
                            shiftr_reg <= {1'b1, data, 1'b0};   // data is loaded with start, data, and end bits. 10 bits.
                        if (clear) 
                            bit_counter <= 0;
                        if  (shift)
                            shiftr_reg <= shiftr_reg >> 1;      // sttart shifting data And transmitting bit by bit
                            bit_counter<= bit_counter + 1;
                    end
        end     
       
       // State Machine Mealy
       
       always @(posedge clk)
        begin
            load <= 0; 
            shift <= 0;
            clear <= 0;
            txd <= 1;                           // when set to 1, no transmission in profress
            
            case(state) 
                0: begin                        // idle
                    if (transmit)
                        begin                   // if transmit button pressed, transmit data serially through txd
                            next_state <= 1;    // it switches to transmission state
                            load <= 1;          // start loading bits
                            shift <= 0;         // no shift
                            clear <= 0; 
                        end 
                    else    
                        begin
                            next_state <= 0;    // stays at idle mode
                            txd <= 1; 
                        end
                    end
                1: begin                        // transmitting data
                    if (bit_counter == 10)      //if all 10 bits have been transmitted, switch from transmit to idle
                        begin
                            next_state <= 0;    // switch back to idle
                            clear <= 1;         // clear counters
                        end 
                    else 
                        begin
                            next_state <= 1;
                            txd <= shiftr_reg[0]; 
                            shift <= 1; // continue shifting the data, new bit arrives at the RMB
                        end
                    end
                    
                default: next_state <= 0;
                endcase
             end
endmodule
