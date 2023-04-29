`define DIMS_PER_CC 1024
`define BITWIDTH_PER_DIM 9

module class_bundler(
	input  wire												binarizing_class_hvs,
    input  wire 	[`DIMS_PER_CC-1:0] 						input_hv_chunk,
    input  wire 	[`DIMS_PER_CC-1:0][`BITWIDTH_PER_DIM-1:0] stored_hv_chunk,
    output wire 	[`DIMS_PER_CC-1:0][`BITWIDTH_PER_DIM-1:0] sum
    );
	/* 
	Binarizes Non-bin register HVs
	*/
	
	// If we're binarizing, the class_bundler is transparent; it lets input_hv_chunk pass through without adding.

	for (genvar i = 0; i < DIMS_PER_CC; i++ ) begin
		assign sum[i] = (!binarizing_class_hvs) ? stored_hv_chunk[i] + input_hv_chunk[i] : input_hv_chunk[i];
	end

endmodule
