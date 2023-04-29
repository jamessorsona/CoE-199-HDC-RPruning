`define HV_DIM 4096
`define FEATURES_PER_CC 155
`define FEATURE_COUNT 617

module qtz_reg_out(
	input  wire 					clk,
	input  wire 					nrst,
	input  wire 					mapping_hv_segment,
	input  wire 	[1:0]         	ctr,
	input  wire 	[`HV_DIM-1:0]  	im_fetch_outputs        [0:`FEATURES_PER_CC-1],
	output logic	[`HV_DIM-1:0]	level_hvs      			[0:`FEATURE_COUNT-1] 
    ); 
   	
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            for(int i = 0; i < FEATURE_COUNT; i++) begin
                level_hvs[i] <= '0;
            end        
        end else if (mapping_hv_segment) begin
            case(ctr)
                2'd0: 	 level_hvs[0:154]   <= im_fetch_outputs;                       
                2'd1: 	 level_hvs[155:309] <= im_fetch_outputs; 
                2'd2: 	 level_hvs[310:464] <= im_fetch_outputs;       
                default: level_hvs[465:616] <= im_fetch_outputs[0:151];                        
            endcase
        end else begin
        	level_hvs <= level_hvs;
        end
    end

endmodule
