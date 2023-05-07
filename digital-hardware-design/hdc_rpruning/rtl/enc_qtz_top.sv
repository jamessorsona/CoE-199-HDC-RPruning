`timescale 1ns/1ps
`define HV_DIM 4096
`define FEATURE_COUNT 617
`include "../rtl/quantizing_top.sv"
`include "../rtl/encoding_top.sv"

module enc_qtz_top(
    input  wire               		clk,
    input  wire               		nrst,
    input  wire               		en,
    input  wire               		start_mapping,
    input  wire  	[15:0]       	input_values 			[0:`FEATURE_COUNT-1],
    output wire 					encoding_done,
    output wire		[`HV_DIM-1:0] 	encoded_hv
    );
    
    wire mapping_done;
    wire [HV_DIM-1:0] level_hvs [0:FEATURE_COUNT-1];
    
    quantizing_top QTZ_TOP_0(
        .clk							(clk),
        .nrst							(nrst),
        .en								(en),
        .start_mapping					(start_mapping),  
        .input_values					(input_values),
        .mapping_done					(mapping_done),
        .level_hvs						(level_hvs)     
    );
      
    // Binders & Bundlers
    encoding_top ENC_TOP_0(
        .clk							(clk),
        .nrst							(nrst),
        .en								(en),
        .start_encoding					(mapping_done),
        .level_hvs						(level_hvs),
        .encoding_done					(encoding_done),    
        .encoded_hv						(encoded_hv)   
    ); 
    	
endmodule
    
