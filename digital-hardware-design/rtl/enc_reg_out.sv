`define HV_DIM 4096
`define DIMS_PER_CC 1024

module enc_reg_out(
	input  wire 						clk,
	input  wire 						nrst,
	input  wire 						bundling_features,
	input  wire 	[1:0]         		ctr,
	input  wire 	[`DIMS_PER_CC-1:0] 	thresholded_bits,
	output logic	[`HV_DIM-1:0]		encoded_hv
	);

	/*
	Multiplexer to choose which segment of the encoded hv is outputted
	*/
	
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            encoded_hv <= '0;
        end    
        else if (bundling_features) begin			
            case(ctr) 
                4'd0:    encoded_hv[1023:0]    <= thresholded_bits;
                4'd1:    encoded_hv[2047:1024] <= thresholded_bits;
                4'd2:    encoded_hv[3071:2048] <= thresholded_bits;
                4'd3:    encoded_hv[4095:3072] <= thresholded_bits;
                default: encoded_hv <= encoded_hv;    
            endcase
        end 
        else begin
            encoded_hv <= encoded_hv;
        end
    end 

endmodule
