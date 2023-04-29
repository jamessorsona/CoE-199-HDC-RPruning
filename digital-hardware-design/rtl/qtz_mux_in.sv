`define FEATURE_COUNT 617
`define FEATURES_PER_CC 155

module qtz_mux_in(
	input  wire  [1:0]		ctr,
	input  wire  [15:0]     input_values 	[0:`FEATURE_COUNT-1],
	output logic [15:0]		mux_out         [0:`FEATURES_PER_CC-1]
    );  

	always_comb begin
        case(ctr)
            2'd0:    mux_out = input_values[0:154];
            2'd1:    mux_out = input_values[155:309];
            2'd2:    mux_out = input_values[310:464];
            default: begin
		     		 mux_out[0:151] = input_values[465:616];
		             mux_out[152:154]   = '{0,0,0};
          	end
        endcase
    end 

endmodule
