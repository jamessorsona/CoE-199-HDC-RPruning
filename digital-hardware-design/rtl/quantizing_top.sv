`define HV_DIM 4096
`define FEATURE_COUNT 617
`define M 2
`define FEATURES_PER_CC 155

module quantizing_top(
    input  wire               	clk,
    input  wire               	nrst,
    input  wire               	en,
    input  wire               	start_mapping,
    input  wire  [15:0]       	input_values 			[0:`FEATURE_COUNT-1],
    output wire               	mapping_done,
    output wire  [`HV_DIM-1:0]	level_hvs      			[0:`FEATURE_COUNT-1],
	output wire  [1:0]          ctr
 	//output wire	 [`HV_DIM-1:0] 	im_hvs					[0:M-1]
    );

    wire               			mapping_hv_segment;
    //wire 	[1:0]         		ctr;	
    wire  	[3:0]         		quantized_value_levels	[0:FEATURES_PER_CC-1];
    wire  	[HV_DIM-1:0]  		im_fetch_outputs        [0:FEATURES_PER_CC-1]; 
    wire 	[HV_DIM-1:0]		im_hvs                  [0:M-1]; 
    wire	[15:0]        		mux_out                 [0:FEATURES_PER_CC-1];    
	
    // FSM Controller
    qtz_fsm Q_FSM_0(
        .clk										(clk),
        .nrst										(nrst),
        .en											(en),
        .start_mapping								(start_mapping),
        .ctr										(ctr),
		.mapping_hv_segment							(mapping_hv_segment),
        .mapping_done								(mapping_done)
    ); 

	// Input MUX
	qtz_mux_in Q_MUX_IN_0(
		.ctr										(ctr),
		.input_values								(input_values),
		.mux_out									(mux_out)
	);
    
    // Quantizers  
    for (genvar i = 0; i < FEATURES_PER_CC; i++) 
		begin : qtzs
		    quantizer QTZ(
				.input_value						(mux_out[i]),
				.quantized_value_level				(quantized_value_levels[i])
		    );
    	end

      // Item Memory
     qtz_im IM_0(.mapping_hv_segment (mapping_hv_segment), .im_hvs(im_hvs));

      // IM Fetch
     for (genvar j = 0; j < FEATURES_PER_CC; j++) 
		begin : ims
			qtz_im_fetch Q_IM(
				.qlevel								(quantized_value_levels[j]),
				.im_hvs								(im_hvs),          
				.level_hv							(im_fetch_outputs[j])
			);
		end

	// Output mux into register
	qtz_reg_out Q_REG_OUT_0(
		.clk										(clk),
		.nrst										(nrst),
		.mapping_hv_segment							(mapping_hv_segment),
		.ctr										(ctr),
		.im_fetch_outputs							(im_fetch_outputs),
		.level_hvs									(level_hvs)
	);

endmodule
