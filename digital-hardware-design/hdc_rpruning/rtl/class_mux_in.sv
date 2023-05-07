`define HV_DIM 4096
`define DIMS_PER_CC 1024

module class_mux_in(
	input  wire							training_hdc_model,
	input  wire   	[1:0] 				nonbin_ctr,
	input  wire   	[`HV_DIM-1:0] 		encoded_hv,
	output logic	[`DIMS_PER_CC-1:0] 	input_hv_chunk
	);

	/* 
	A multiplexer to output which segment of the training encoded hv is to be used for class hv generation
	*/
	
	wire [HV_DIM-1:0] training_hv;

	assign training_hv = (training_hdc_model) ? encoded_hv : '0;

    always_comb begin
	    case(nonbin_ctr)
			4'd0:    input_hv_chunk = training_hv[1023:0];
	        4'd1:    input_hv_chunk = training_hv[2047:1024];
	        4'd2:    input_hv_chunk = training_hv[3071:2048];
	        default: input_hv_chunk = training_hv[4095:3072];
	    endcase
    end 

endmodule
