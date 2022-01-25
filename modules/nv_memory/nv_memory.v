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


module nv_memory #(
    parameter integer DATA_WIDTH =  32,
    parameter integer ADDR_WIDTH =   8,
    parameter integer MEM_SIZE   = 256
)(
    input                                   clk,
    input                                 mem_w,
    input  reg     [ADDR_WIDTH-1:0] mem_addr_in,
    input  reg     [DATA_WIDTH-1:0] mem_data_in,
    output reg     [DATA_WIDTH-1:0] mem_data_out   
);

reg [DATA_WIDTH-1:0] memory[MEM_SIZE-1:0];

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


