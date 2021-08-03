///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module Name:     apb_v3_sram
// Author:          Farshad
// Email:           farshad112@gmail.com
// Date Created:    1-June-2018
// Description:     Synchronous RAM (SRAM) core with APB interface. 
//                  Address and data bus widths are configurable using ADDR_BUS_WIDTH and DATA_BUS_WIDTH parameters
//                  and RAM Size can also be configured using MEMSIZE, MEM_BLOCK_SIZE parameter. 
//
// Version:         0.1
// License:         This project is licensed under MIT opensource license 3.0 available @ https://opensource.org/licenses/MIT
/******************************************* LICENSE BEGIN **************************************
Copyright (c) 2018, Farshad

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

******************************************* LICENSE END **************************************/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module apb_v3_sram #(
                    // device parameters
                    parameter ADDR_BUS_WIDTH=4,        // Width of Address bus i.e. PADDR
                    parameter DATA_BUS_WIDTH=16,        // Width of Data bus (i.e. PWDATA and PRDATA)
                    parameter MEMSIZE=16,               // RAM memory Size
                    parameter MEM_BLOCK_SIZE=16,         // RAM memory block size
                    parameter RESET_VAL=0,              // Default Reset value of DUT
                    parameter EN_WAIT_DELAY_FUNC=0,     // Enable Random Delay Assertion in read or write operation 
                    parameter MIN_RAND_WAIT_CYC=0,      // Minimum cycle delay for read and write operation
                    parameter MAX_RAND_WAIT_CYC=1)(     // Maximum cycle delay for read and write operation
                    // IO ports
                    input  wire                         PRESETn,
                    input  wire                         PCLK,
                    input  wire                         PSEL,
                    input  wire                         PENABLE,
                    input  wire                         PWRITE,
                    input  wire [ADDR_BUS_WIDTH-1:0]    PADDR,
                    input  wire [DATA_BUS_WIDTH-1:0]    PWDATA,
                    output reg  [DATA_BUS_WIDTH-1:0]    PRDATA,
                    output reg                          PREADY,
                    output reg                          PSLVERR
                    );

    // RAM memory declaration
    reg [MEM_BLOCK_SIZE-1:0] memory[MEMSIZE-1:0];
    
    // APB State declaration
    localparam IDLE   =   0;
    localparam SETUP  =   1;
    localparam ACCESS =   2;
    localparam WAIT   =   3;
    
    // APB operation states
    localparam WRITE = 1;
    localparam READ  = 0;
    
    // State variable declaration
    reg [1:0] state;
    
    // wait state variable declaration
    integer wait_cyc_cntr=0;
    integer wait_cyc_limit;   
    
    ///////////////////////////////////////////////
    // Task Name: reset_ram
    // Parameter: none
    // Return type: none
    // Description: Write reset value in the RAM
    ///////////////////////////////////////////////
    task reset_ram;
        input integer reset_value;
        integer i;
        begin
            for(i=0; i< MEMSIZE; i=i+1) begin
                memory[i] = reset_value;
            end
        end
    endtask
    
   
    initial begin
        state = IDLE;
        // compute random wait delay
        wait_cyc_limit = $urandom_range(MIN_RAND_WAIT_CYC, MAX_RAND_WAIT_CYC);
        $display("wait_cyc_limit:%0h", wait_cyc_limit);
    end
 
    always @(posedge PCLK or PRESETn) begin
        if(!PRESETn) begin
            state = IDLE;
            PRDATA = 0;
            reset_ram(RESET_VAL);
        end
        else begin
            if(!PSEL && !PENABLE) begin
                state = IDLE;
                wait_cyc_cntr = 0;
            end
            else if(PSEL && !PENABLE) begin
                    state = SETUP;
            end
            else if(PSEL && PENABLE) begin
                       state = ACCESS;
            end
            else begin
                state = IDLE;
            end
        end
        
    end   
    always @(state) begin
        case(state)
            IDLE: begin
                PREADY = 0;
                PSLVERR = 0;
            end
            SETUP: begin
                PREADY = 1;
                PSLVERR = 0;                    
            end
            ACCESS: begin
                if(PWRITE == WRITE) begin
                    if(PADDR < MEMSIZE) begin
                        memory[PADDR] = PWDATA;
                        PSLVERR = 0;
                    end
                    else begin
                        PSLVERR = 1;
                    end
                end
                else if(PWRITE == READ) begin
                    if(PADDR < MEMSIZE) begin  // check if read memory is valid
                        PRDATA = memory[PADDR];
                        PSLVERR = 0;
                    end
                    else begin
                        PSLVERR = 1;
                    end
                end
                PREADY = 0;
            end
            WAIT: begin
                PREADY = 0;
                PSLVERR = 0;
            end
            default: begin
                PREADY = 0;
                PRDATA = 0;
                PSLVERR = 0;
            end
        endcase
    end
 
endmodule
