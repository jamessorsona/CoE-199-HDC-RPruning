`define HV_DIM 4096
`define DIMS_PER_CC 1024
`define SEQ_CYCLE_COUNT 4

module rp_ctrl (
	input wire 								clk,
	input wire 								nrst,
	input wire 								pruning_hv,
	input wire 	 [25:0] 					rp_mux_out 				[0:`DIMS_PER_CC-1],
	output logic [`DIMS_PER_CC-1:0] 		enable_signal
	);
	
	always_ff @ (posedge clk or negedge nrst) begin
		if (!nrst) begin
			enable_signal <= '0;
		end else if (pruning_hv) begin
			for (int i = 0; i < DIMS_PER_CC; i++) begin
				if ((rp_mux_out[i] == 26'b11111111111111111111111111) || (rp_mux_out[i] == 26'b0)) begin
					enable_signal[i] <= 0;
				end
				else enable_signal[i] <= 1;
			end
	end	
endmodule
			
		
