`define HV_DIM 4096
`define DIMS_PER_CC 1024
`define SEQ_CYCLE_COUNT 4

module rp_mux_in(
	input wire 	 [1:0] 				ctr,
	input wire 	 [25:0] 			arr_per_dim_class_hv [0:`SEQ_CYCLE_COUNT-1][0:`DIMS_PER_CC-1],
	output logic [25:0] 			rp_mux_out [0:`DIMS_PER_CC-1]
	);
	
	wire [25:0] per_dim_class_hv [0:DIMS_PER_CC-1];
	
	/*
	assign per_dim_class_hv = (testing_hdc_model) ? arr_per_dim_class_hv[ctr] : per_dim_class_hv;
	assign rp_mux_out = per_dim_class_hv;
	*/
	
	
	always_comb begin
		case(ctr)
			2'd0:    rp_mux_out = arr_per_dim_class_hv[0];
			2'd1:    rp_mux_out = arr_per_dim_class_hv[1];
			2'd2:    rp_mux_out = arr_per_dim_class_hv[2];
			2'd3:    rp_mux_out = arr_per_dim_class_hv[3];
			default: rp_mux_out = {'DIMS_PER_CC{'0}};
		endcase
    end 
    

endmodule

	
