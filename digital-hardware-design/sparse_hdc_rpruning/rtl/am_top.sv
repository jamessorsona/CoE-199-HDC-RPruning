`define HV_DIM 4096
`define SEQ_CYCLE_COUNT 4
`define DIMS_PER_CC 1024

module am_top(
    input  wire 											clk,
    input  wire 											nrst,
    input  wire 											en,
    input  wire 											start_querying,
    input  wire 											testing_hdc_model,
    input  wire 											testing_dataset_finished,
    input  wire [`HV_DIM-1:0] 								encoded_hv,
    input  wire [`SEQ_CYCLE_COUNT-1:0][`DIMS_PER_CC-1:0] 	binary_class_hvs 				[0:25],
	output wire 											tallying_accuracy,
    output wire [4:0] 										class_inference
    );
    
    // FSM signals
    wire 	[1:0] 				query_ctr;
    wire 						comparing_query_hv_with_class_hv;
    wire 						inferring_class;
    
    // AND array output
    wire 	[DIMS_PER_CC-1:0] 	query_hv_segment;
    wire  	[DIMS_PER_CC-1:0] 	and_array_out 						[0:25];
    
    // Tree adder outputs (13 bits to represent 5k dim)
    wire 	[12:0] 				similarity_values 					[0:25];
    
    // Redundancy Pruning
    //wire 	[DIMS_PER_CC-1:0] 	enable_signal;

    
    // FSM
    am_fsm AM_FSM_0(
        .clk									(clk),
        .nrst									(nrst),
        .en										(en),
        .start_querying							(start_querying),
        .testing_dataset_finished				(testing_dataset_finished),
        .query_ctr								(query_ctr),
        .comparing_query_hv_with_class_hv		(comparing_query_hv_with_class_hv),
        .inferring_class						(inferring_class),
        .tallying_accuracy						(tallying_accuracy)
    );

	// AM Input MUX
	am_mux_in AM_MUX_IN_0(
		.testing_hdc_model						(testing_hdc_model),
		.query_ctr								(query_ctr),
		.encoded_hv								(encoded_hv),
		.query_hv_segment						(query_hv_segment)
	);
	
	/*
	//REDUNDANCY PRUNING
	rp_top RP_TOP_0(
		.ctr									(query_ctr),
		.testing_hdc_model						(testing_hdc_model),
		.class_hvs								(binary_class_hvs),
		.enable_signal							(enable_signal)
	);
	*/
    
    // AND array
    am_and_array AM_AND_0(
        .query_ctr								(query_ctr),
		.query_hv_segment						(query_hv_segment),
        .binary_class_hvs						(binary_class_hvs),
        //.enable_signal							(enable_signal),
        .and_array_out							(and_array_out)
    );
    
    // Tree Adders
    for (genvar i = 0; i < 26; i++) begin
        am_tree_adder AM_TREE_ADD_0(
            .clk								(clk),
            .nrst								(nrst),
            .comparing_query_hv_with_class_hv	(comparing_query_hv_with_class_hv),
            .inferring_class					(inferring_class),
            .and_array_out						(and_array_out[i]),
            //.enable_signal						(enable_signal),
            .similarity_value					(similarity_values[i])
        );
    end

    // Tree Comparator
    am_tree_comparator AM_COMP_0(
        .clk									(clk),
        .nrst									(nrst),
        .inferring_class						(inferring_class),
        .similarity_values						(similarity_values),
        .class_inference						(class_inference)
    );
    
endmodule
