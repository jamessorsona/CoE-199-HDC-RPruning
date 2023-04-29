`define HV_DIM 4096
`define FEATURE_COUNT 617
`define SEQ_CYCLE_COUNT 4

module encoding_top(
    input  wire 													clk, 
    input  wire 													nrst, 
    input  wire 		            								en, 
    input  wire 													start_encoding,
    input  wire														testing_hdc_model,
    input  wire   	[`HV_DIM-1:0] 									level_hvs 				[0:`FEATURE_COUNT-1],
    output wire 													encoding_done,
    output wire		[`HV_DIM-1:0] 									encoded_hv,
	output wire [1:0] ctr
    );
    
	wire 						 	bundling_features;
    //wire 	[1:0] 				 	ctr;
    wire 	[HV_DIM-1:0] 		 	shifted_hvs 			[0:FEATURE_COUNT-1];
    wire 	[FEATURE_COUNT-1:0] 	bits_to_bundle_arr		[HV_DIM-1:0];
    
    // for mux & demux 
    wire 	[FEATURE_COUNT-1:0] 	mux_out 				[DIMS_PER_CC-1:0];
    wire 	[DIMS_PER_CC-1:0] 		thresholded_bits;
    
    // for redunancy pruning
    //wire 	[DIMS_PER_CC-1:0]		enable_signal;
	
    
    // FSM Controller
    enc_fsm ENC_FSM_0(
        .clk									(clk),
        .nrst									(nrst),
        .en										(en),
        .start_encoding							(start_encoding),
        .ctr									(ctr),
		.bundling_features						(bundling_features),
        .encoding_done							(encoding_done)
    );  
         
    // FEATURE_COUNT=617 binders 
    for (genvar i = 0; i < FEATURE_COUNT; i++) 
		begin : binders
			enc_binder #(.SHIFT(i+1))	// changed the random shift values
			ENC_BINDER(
			    .clk							(clk),
			    .nrst							(nrst),
			    .start_binding					(start_encoding),
			    .level_hv						(level_hvs[i]),
			    .shifted_hv						(shifted_hvs[i])
			);
    	end   

	// Nets (for bundler input assignment)
	enc_nets ENC_NETS_0(
		.shifted_hvs							(shifted_hvs),
		.bits_to_bundle_arr						(bits_to_bundle_arr)
	);

	// Input MUX for bundlers
	enc_mux_in ENC_MUX_IN_0(
		.ctr									(ctr),
		.bits_to_bundle_arr						(bits_to_bundle_arr),
		.mux_out								(mux_out)
	);
	
	/*
	rp_top RP_TOP_0(
		.ctr									(ctr),
		.testing_hdc_model						(testing_hdc_model),
		.class_hvs								(class_hvs),
		.enable_signal							(enable_signal)
		);
		*/
		
             
    // DIMS_PER_CC=500 bundlers   
    for (genvar j = 0; j < DIMS_PER_CC; j++) 
    	begin : bundlers
			enc_bundler ENC_BUNDLER(
			   .bundling_features				(bundling_features),
			   //.enable_signal					(enable_signal[j]),
			   .bits_to_bundle					(mux_out[j]), 
			   .thresholded_bit					(thresholded_bits[j])
			); 
    	end
    
    // Encoding Output Reg (contains the encoded hv)
	enc_reg_out ENC_OUT_REG_0(
		.clk									(clk),
		.nrst									(nrst),
		.bundling_features						(bundling_features),
		.ctr									(ctr),
		.thresholded_bits						(thresholded_bits),
		.encoded_hv								(encoded_hv)
	);

              
endmodule
