`define DIMS_PER_CC 1024
`define SEQ_CYCLE_COUNT 4

module am_and_array( 
    input  wire  [1:0] 										query_ctr,
    input  wire	 [`DIMS_PER_CC-1:0] 						query_hv_segment,
    input  wire  [`SEQ_CYCLE_COUNT-1:0][`DIMS_PER_CC-1:0] 	binary_class_hvs 	[0:25],
    //input  wire  [`DIMS_PER_CC-1:0] 						enable_signal,
    output logic [`DIMS_PER_CC-1:0] 						and_array_out 		[0:25]     
    );
	
	//and_array_out[i][j] = binary_class_hvs[i][1][j] & query_hv_segment[j];
    always_comb begin
        case(query_ctr)
            4'd0: begin
            //EDIT
                for(int i = 0; i < 26; i++) begin
                	//for (int j = 0; j < DIMS_PER_CC; j++) begin
                		//if (enable_signal[j]) begin	//checks if dimension [j] has similar bit for all class_hvs, if so it is disabled
                			//and_array_out[i][j] = binary_class_hvs[i][0][j] & query_hv_segment[j];	// bitwise AND to check similarity
                			and_array_out[i] = binary_class_hvs[i][0] & query_hv_segment;
                		//end
                	//end
                end
            //END OF EDIT
            end
            4'd1: begin
                for(int i = 0; i < 26; i++) begin
                	//for (int j = 0; j < DIMS_PER_CC; j++) begin
                		//if (enable_signal[j]) begin
                			//and_array_out[i][j] = binary_class_hvs[i][1][j] & query_hv_segment[j];
                			and_array_out[i] = binary_class_hvs[i][1] & query_hv_segment;
                		//end
                	//end
                end
            end
            4'd2: begin
                for(int i = 0; i < 26; i++) begin
                	//for (int j = 0; j < DIMS_PER_CC; j++) begin
                		//if (enable_signal[j]) begin
                			//and_array_out[i][j] = binary_class_hvs[i][2][j] & query_hv_segment[j];
                			and_array_out[i] = binary_class_hvs[i][2] & query_hv_segment;
                		//end
                	//end
                end
            end               
            4'd3: begin
                for(int i = 0; i < 26; i++) begin
                	//for (int j = 0; j < DIMS_PER_CC; j++) begin
                		//if (enable_signal[j]) begin
                			//and_array_out[i][j] = binary_class_hvs[i][3][j] & query_hv_segment[j];
                			and_array_out[i] = binary_class_hvs[i][3] & query_hv_segment;
                		//end
                	//end
                end
            end                             
        endcase
    end

endmodule
