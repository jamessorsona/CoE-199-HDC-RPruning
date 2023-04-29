`define HV_DIM 4096
`define SEQ_CYCLE_COUNT 4
`define DIMS_PER_CC 1024

module class_hv_gen_top(
    input  wire  										clk,
    input  wire  										nrst,
    input  wire  										en,   
	input  wire  										training_hdc_model,
	input  wire  										start_class_gen,  
	input  wire											start_binarizing,
	input  wire  										training_dataset_finished,
    input  wire [`HV_DIM-1:0] 							encoded_hv,
    input  wire [4:0] 									class_select_bits,
    output wire [`SEQ_CYCLE_COUNT-1:0][`DIMS_PER_CC-1:0] 	bin_class_hvs 				[0:25],
    output wire 										class_gen_done
    );
    
    // FSM internal signals
	wire [1:0] 	class_ctr;
    wire [1:0] 	nonbin_ctr;
    wire [1:0] 	bin_ctr;
    wire 		adjusting_nonbin_class_hvs;
    wire 		binarizing_class_hvs;
    
    // Bundler input signals
    wire [DIMS_PER_CC-1:0] 							input_hv_chunk;
    
    // nonbinary_class_reg input signals
	wire [DIMS_PER_CC-1:0][BITWIDTH_PER_DIM-1:0] 	nonbin_class_reg_out;
    wire [DIMS_PER_CC-1:0][BITWIDTH_PER_DIM-1:0] 	nonbin_class_reg_in;

    // binary_class_reg input signal
    wire [DIMS_PER_CC-1:0] 							bin_class_reg_in;

    
    // FSM Controller
    class_fsm C_FSM_0(
        .clk							(clk),
        .nrst							(nrst),
        .en								(en),
        .start_class_gen				(start_class_gen),
        .training_dataset_finished		(training_dataset_finished),
		.start_binarizing				(start_binarizing),
		.class_ctr						(class_ctr),
		.bin_ctr						(bin_ctr),
        .nonbin_ctr						(nonbin_ctr),        
        .adjusting_nonbin_class_hvs		(adjusting_nonbin_class_hvs),
        .binarizing_class_hvs			(binarizing_class_hvs),
        .class_gen_done					(class_gen_done)
    );

	// Class Mux In
    class_mux_in C_MUX_IN_0(
		.training_hdc_model				(training_hdc_model),
		.nonbin_ctr						(nonbin_ctr),
		.encoded_hv						(encoded_hv),
		.input_hv_chunk					(input_hv_chunk)
	);

    // Class Bundler
    class_bundler C_BUNDLE_0(
		.binarizing_class_hvs			(binarizing_class_hvs),
        .input_hv_chunk					(input_hv_chunk),
        .stored_hv_chunk				(nonbin_class_reg_out),
        .sum							(nonbin_class_reg_in)
    );	
    
    // Class Thresholder
    class_thresholder C_THR_0(
		.binarizing_class_hvs			(binarizing_class_hvs),
        .class_thresholder_in			(nonbin_class_reg_out),
        .thresholded_hv					(bin_class_reg_in)
    );
 	
    // Nonbinary Class Registers
    class_reg_nonbin C_REG_NONBIN_0(
        .clk							(clk),
        .nrst							(nrst),
        .adjusting_nonbin_class_hvs		(adjusting_nonbin_class_hvs),
		.class_ctr						(class_ctr),
        .nonbin_ctr						(nonbin_ctr),
        .nonbin_class_reg_in			(nonbin_class_reg_in),
        .nonbin_class_reg_out			(nonbin_class_reg_out)
    );
    
    // Binary Class Registers
    class_reg_bin C_REG_BIN_0(
        .clk							(clk),
        .nrst							(nrst),
        .binarizing_class_hvs			(binarizing_class_hvs),
		.class_select_bits				(class_select_bits),
        .bin_ctr						(bin_ctr),
        .bin_class_reg_in				(bin_class_reg_in),
        .bin_class_hvs					(bin_class_hvs)
    );
    
endmodule
