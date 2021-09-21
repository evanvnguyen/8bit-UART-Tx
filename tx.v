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
    input [7:0] data,
    input transmit,
    input reset,
    output reg txd
    );
    
    //internal variables
    
    reg [3:0] bit_counter;      //Counter to count the 10 bits
    reg [13:0] br_counter;      //10,415, counter=clock(100 Mhz) / BR (9600)
    reg [9:0] shiftr_register;  //10 bits that will be serially transmitted through UART to the Nexys 4 

    reg state, next_state; 

    reg shift;  // SHIFT SIGNAL TO SHIFT BITS INTO UART
    reg load;   // LOAD SIGNAL TO START LOADING BITS INTO SHIFT REG + START/STOP
    reg clear;  // CLEARS BIT COUNTER
    
    //UART transmission
    
    always @(posedge clk)
        begin
            if (reset)
                begin
                    state <= 0; // IDLE
                    bit_counter <= 0; 
                    br_counter <= 0;
                end
            else
                begin
                    br_counter <= br_counter + 1;
                    if (br_counter == 10415)
                        begin
                            state<=next_state;  //IDLE TO TRANSMIT STATE
                            br_counter<=0;
                            if (load)           //IF LOAD ASSERTED, LOAD DATA INTO REGISTER INCLUDING STOP/START
                                shiftr_register <= {1'b1, data,1'b0};
                            if (clear)
                                bit_counter <= 0;
                            if (shift)
                                begin
                                    shiftr_register <= shiftr_register >> 1;    //START SHIFTING BIT BY BIT
                                    bit_counter <= bit_counter + 1;
                                end
                        end
                end
        end

    // mealy machine
    always @(posedge clk)
        begin
            load <= 0; 
            shift <= 0; 
            clear <= 0; 
            txd <= 1; //WHEN TXD = 1, NO TRANSMIT. WE ARE OUTPUTTING
    
            case(state) //IDLE
                0: begin
                    if (transmit) 
                        begin 
                            next_state <= 1;    //GO TO TRANSMIT
                            load <= 1;          //LOAD BITS
                            shift <= 0;         //DONT SHIFT
                            clear <= 0;         //DONT CLEAR
                        end

                    else
                        begin                   // IF NO TRANSMIT, STAY IDLE
                            next_state <= 0; 
                            txd <= 1;
                        end
                    end
    
                1: begin //TRANSMIT
                    if (bit_counter == 10)
                        begin
                            next_state <= 0; //GO TO IDLE
                            clear <= 1; 
                        end
                    else 
                        begin
                            next_state <= 1; // IF BITS INPUTTED != 10, STAY IN TRANSMIT
                            txd <= shiftr_register[0];
                            shift <= 1;      //CONTINUE TO SHIFT TO RIGHT
                        end
                    end
                default: next_state <= 0;
            endcase
        end
endmodule
