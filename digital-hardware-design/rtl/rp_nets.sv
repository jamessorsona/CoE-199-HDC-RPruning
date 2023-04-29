`define HV_DIM 4096
`define SEQ_CYCLE_COUNT 4
`define DIMS_PER_CC 1024

module rp_nets(
	input wire [`SEQ_CYCLE_COUNT-1:0][`DIMS_PER_CC-1:0] class_hvs [0:25],
	output logic [25:0] arr_per_dim_class_hv [`SEQ_CYCLE_COUNT-1:0][`DIMS_PER_CC-1:0]
	);

	always_comb begin
			for (int i = 0; i < SEQ_CYCLE_COUNT; i++) begin 
				for (int j = 0; j < DIMS_PER_CC; j++) begin
					arr_per_dim_class_hv[i][j] = {class_hvs[0][i][j], class_hvs[1][i][j], class_hvs[2][i][j], class_hvs[3][i][j], class_hvs[4][i][j], class_hvs[5][i][j], class_hvs[6][i][j], class_hvs[7][i][j], class_hvs[8][i][j], class_hvs[9][i][j], class_hvs[10][i][j], class_hvs[11][i][j], class_hvs[12][i][j], class_hvs[13][i][j], class_hvs[14][i][j], class_hvs[15][i][j], class_hvs[16][i][j], class_hvs[17][i][j], class_hvs[18][i][j], class_hvs[19][i][j], class_hvs[20][i][j], class_hvs[21][i][j], class_hvs[22][i][j], class_hvs[23][i][j], class_hvs[24][i][j], class_hvs[25][i][j]};                
				end
			end
		end
	end
endmodule
	





