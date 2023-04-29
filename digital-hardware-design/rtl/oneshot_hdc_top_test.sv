`define FEATURE_COUNT 617

module oneshot_hdc_top(
    input  wire 		clk,
    input  wire 		nrst,
    input  wire 		en,
	input  wire			start_hdc,
    input  wire 		start_mapping,	
    input  wire [15:0] 	input_values [0:`FEATURE_COUNT-1],
    input  wire [4:0] 	class_select_bits,
	input  wire			start_binarizing,
    input  wire 		training_dataset_finished,
    input  wire 		testing_dataset_finished,
	input  wire [`SEQ_CYCLE_COUNT-1:0][`DIMS_PER_CC-1:0] bin_class_hvs	[0:25],
    output wire [4:0] 	class_inference,
	output wire 		checking_inference,
	output wire			start_querying,
	output wire 				mapping_done,
    output wire 				encoding_done,
	output wire				start_class_gen,
    output wire 				class_gen_done,
    output wire 				training_hdc_model,
	output wire 				testing_hdc_model,
    output wire 		oneshot_hdc_done,
    output wire [`HV_DIM-1:0] encoded_hv,
    output wire [`HV_DIM-1:0] level_hvs [`FEATURE_COUNT-1:0],
	output wire [1:0] qtz_ctr,
	output wire [1:0] enc_ctr
    );

	// Note: outputs tallying_accuracy/checking_inference is only added for inference checking. We can remove this.
    
    // FSM Control Signals
    
        
    // Outputs Per Submodule
    //wire [HV_DIM-1:0]   						level_hvs 		[0:FEATURE_COUNT-1]; 
    //wire [HV_DIM-1:0]   						encoded_hv;   
    //wire [SEQ_CYCLE_COUNT-1:0][DIMS_PER_CC-1:0] bin_class_hvs	[0:25];

   
    // Main FSM Controller  
    oneshot_fsm FSM_TOP_0(
        .clk							(clk),
        .nrst							(nrst),
        .en								(en),
        .start_hdc						(start_hdc),
		.encoding_done					(encoding_done),
		.class_gen_done					(class_gen_done),
        .testing_dataset_finished		(testing_dataset_finished),
		.start_class_gen				(start_class_gen),
		.start_querying					(start_querying),
        .training_hdc_model				(training_hdc_model),
        .testing_hdc_model				(testing_hdc_model),
        .oneshot_hdc_done				(oneshot_hdc_done)      
    );
    
    // Quantizer & Item Memory
    quantizing_top QTZ_TOP_0(
        .clk							(clk),
        .nrst							(nrst),
        .en								(en),
        .start_mapping					(start_mapping),  
        .input_values					(input_values),
        .mapping_done					(mapping_done),
        .level_hvs						(level_hvs),
        .ctr (qtz_ctr)   
    );
      
    // Binders & Bundlers
    encoding_top ENC_TOP_0(
        .clk							(clk),
        .nrst							(nrst),
        .en								(en),
        .start_encoding					(mapping_done),
        .testing_hdc_model				(testing_hdc_model),
        .level_hvs						(level_hvs),
        .encoding_done					(encoding_done),    
        .encoded_hv						(encoded_hv),
        .ctr (enc_ctr) 
    ); 

    // Class HV Generator
    class_hv_gen_top CLASS_TOP_0(
        .clk							(clk),
        .nrst							(nrst),
        .en								(en),      
		.training_hdc_model				(training_hdc_model),
		.start_class_gen				(start_class_gen),
		.start_binarizing				(start_binarizing),
        .training_dataset_finished		(training_dataset_finished),	
        .encoded_hv						(encoded_hv),
        .class_select_bits				(class_select_bits),
        .bin_class_hvs					(bin_class_hvs),
        .class_gen_done					(class_gen_done)
    );
   
    // Associative Memory
    am_top AM_TOP_0(
        .clk							(clk),
        .nrst							(nrst),
        .en								(en),
        .start_querying					(start_querying),
        .testing_hdc_model				(testing_hdc_model),
        .testing_dataset_finished		(testing_dataset_finished),
        .encoded_hv						(encoded_hv),
        .binary_class_hvs				(bin_class_hvs),
		.tallying_accuracy				(checking_inference),
        .class_inference				(class_inference)
    );
	

endmodule
