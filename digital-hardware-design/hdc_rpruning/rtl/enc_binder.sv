`define HV_DIM 4096

module enc_binder(
    input  wire  					clk,
    input  wire  					nrst,
    input  wire  					start_binding,
    input  wire  	[`HV_DIM-1:0] 	level_hv,
    output logic	[`HV_DIM-1:0] 	shifted_hv
);

	/*
	Permutation implementation which right shifts the level hvs of each feature depending on the shift value parameter
	*/
	
	// default shift value (signature)
    parameter SHIFT = 1;  
                    
    always_ff @(posedge clk or negedge nrst) begin
		if (!nrst) begin
			shifted_hv <= '0;
		end else if (start_binding) begin
            shifted_hv <= {level_hv[SHIFT-1:0], level_hv[HV_DIM-1:SHIFT]};
        end else begin
        	shifted_hv <= shifted_hv;
        end
    end

endmodule
