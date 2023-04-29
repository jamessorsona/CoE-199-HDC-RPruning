`define DIMS_PER_CC 1024
`define BITWIDTH_PER_DIM 9

module class_thresholder(
	input  wire													binarizing_class_hvs,
    input  wire 	[`DIMS_PER_CC-1:0][`BITWIDTH_PER_DIM-1:0] 	class_thresholder_in,
    output logic 	[`DIMS_PER_CC-1:0] 							thresholded_hv
    );

	/*
	Thresholds the stored non-bin hv of each class depending on the specified class threshold
	*/
	
	wire [DIMS_PER_CC-1:0][BITWIDTH_PER_DIM-1:0] class_hv_to_threshold;

	assign class_hv_to_threshold = (binarizing_class_hvs) ? class_thresholder_in : '0;

	always_comb begin
        for(int i = 0; i < DIMS_PER_CC; i++) begin
		    thresholded_hv[i] = (class_hv_to_threshold[i] > CLASS_BIT_THR) ? 1'b1 : 1'b0;
        end
	end
 
endmodule
