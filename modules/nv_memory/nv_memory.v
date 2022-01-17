// ┌───────────────────────────────────────────────────┐
// │  File Name :  nv_memory.v                         │
// │                                                   │
// │  Author    :  Allen Boston                        │
// │                                                   │
// │  Date      :  December 28, 2021                   │
// │                                                   │
// ├───────────────────────────────────────────────────┤
// │  Breif     :  Non-Volatile Memory for PMU memory  │
// │               interface testing and verification. │
// │                                                   │
// │                                                   │
// │                                                   │
// │                                                   │
// └───────────────────────────────────────────────────┘


module nv_memory_1Kb #(
    parameter integer DATA_WIDTH = 32,
    parameter integer ADDR_WIDTH =  8
)(
    input                                   clk,
    input                                 mem_w,
    input  reg     [ADDR_WIDTH-1:0] mem_addr_in,
    input  reg     [DATA_WIDTH-1:0] mem_data_in,
    output reg     [DATA_WIDTH-1:0] mem_data_out   
);

reg [DATA_WIDTH-1:0] memory[255:0];

initial
    begin

        mem_data_out= 0;
    end
    
always @(posedge clk)
    begin
        if(mem_w)
            memory[mem_addr_in] <= mem_data_in;
        else
            mem_data_out <= memory[mem_addr_in];
    end
    
endmodule

module nv_memory_10Kb #(
    parameter integer DATA_WIDTH = 32,
    parameter integer ADDR_WIDTH =  8
)(
    input                                   clk,
    input                                 mem_w,
    input  reg     [ADDR_WIDTH-1:0] mem_addr_in,
    input  reg     [DATA_WIDTH-1:0] mem_data_in,
    output reg     [DATA_WIDTH-1:0] mem_data_out   
);

reg [DATA_WIDTH-1:0] memory[2559:0];

initial
    begin

        mem_data_out= 0;
    end
    
always @(posedge clk)
    begin
        if(mem_w)
            memory[mem_addr_in] <= mem_data_in;
        else
            mem_data_out <= memory[mem_addr_in];
    end
    
endmodule


module nv_memory_100Kb #(
    parameter integer DATA_WIDTH = 32,
    parameter integer ADDR_WIDTH =  8
)(
    input                                   clk,
    input                                 mem_w,
    input  reg     [ADDR_WIDTH-1:0] mem_addr_in,
    input  reg     [DATA_WIDTH-1:0] mem_data_in,
    output reg     [DATA_WIDTH-1:0] mem_data_out   
);

reg [DATA_WIDTH-1:0] memory[25599:0];

initial
    begin

        mem_data_out= 0;
    end
    
always @(posedge clk)
    begin
        if(mem_w)
            memory[mem_addr_in] <= mem_data_in;
        else
            mem_data_out <= memory[mem_addr_in];
    end
    
endmodule

module nv_memory_1Mb #(
    parameter integer DATA_WIDTH = 32,
    parameter integer ADDR_WIDTH =  8
)(
    input                                   clk,
    input                                 mem_w,
    input  reg     [ADDR_WIDTH-1:0] mem_addr_in,
    input  reg     [DATA_WIDTH-1:0] mem_data_in,
    output reg     [DATA_WIDTH-1:0] mem_data_out   
);

reg [DATA_WIDTH-1:0] memory[262143:0];

initial
    begin

        mem_data_out= 0;
    end
    
always @(posedge clk)
    begin
        if(mem_w)
            memory[mem_addr_in] <= mem_data_in;
        else
            mem_data_out <= memory[mem_addr_in];
    end
    
endmodule
