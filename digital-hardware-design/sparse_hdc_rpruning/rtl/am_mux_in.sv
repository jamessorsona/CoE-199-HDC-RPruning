`define HV_DIM 4096
`define DIMS_PER_CC 1024

module am_mux_in(
	input  	wire							testing_hdc_model,
	input 	wire 	[1:0] 				 	query_ctr,
	input   wire 	[`HV_DIM-1:0] 			encoded_hv,
	output 	logic 	[`DIMS_PER_CC-1:0] 		query_hv_segment
	);   

	wire [HV_DIM-1:0] query_hv;

	assign query_hv = (testing_hdc_model) ? encoded_hv : '0;

    always_comb begin
	    case(query_ctr)	//chooses what segment of the query hv is to be used for similarity check
			4'd0:    query_hv_segment = query_hv[1023:0];
	        4'd1:    query_hv_segment = query_hv[2047:1024];
	        4'd2:    query_hv_segment = query_hv[3071:2048];
	        4'd3:    query_hv_segment = query_hv[4095:3072];
	    endcase
    end  

endmodule
