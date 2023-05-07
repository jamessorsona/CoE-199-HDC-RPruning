`define FEATURE_COUNT 617
`define HV_DIM 4096
`define DIMS_PER_CC 1024

module enc_mux_in(
	input 	wire 	[1:0] 				 	ctr,
	input 	wire 	[`FEATURE_COUNT-1:0] 	bits_to_bundle_arr		[`HV_DIM-1:0],
	output 	logic 	[`FEATURE_COUNT-1:0] 	mux_out 				[`DIMS_PER_CC-1:0]
	);   
	
	/*
	Multiplexer to choose which segment (out of 4) of rearranged level hvs (from 617x4096 bits to 4096x617 bits) is to be outputted in order for it to be thresholded
	*/
	
    always_comb begin
        case(ctr)
			4'd0:    mux_out = bits_to_bundle_arr[1023:0];
            4'd1:    mux_out = bits_to_bundle_arr[2047:1024];
            4'd2:    mux_out = bits_to_bundle_arr[3071:2048];
            4'd3:    mux_out = bits_to_bundle_arr[4095:3072];
			default: mux_out = '{DIMS_PER_CC{'0}};
        endcase
    end 

endmodule
