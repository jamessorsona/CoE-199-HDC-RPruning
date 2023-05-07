`timescale 1ns/1ps

`define HV_DIM 4096
`define SEQ_CYCLE_COUNT 4
`define DIMS_PER_CC 1024

`include "../rtl/rp_nets.sv"
`include "../rtl/rp_mux_in.sv"
`include "../rtl/rp_ctrl.sv"

module rp_top(
	input wire 					   clk,
	input wire 					   nrst,
	input wire 					   en,
	input wire 					   bundling_features,
	input wire 					   comparing_query_hv_with_class_hv,
	input wire 	[`HV_DIM-1:0] 	   class_hvs [0:25],
	output wire [`DIMS_PER_CC-1:0] enable_signal
	);
	
	wire [1:0]	ctr;
	wire 		pruning_hv;
	wire 		prune_done;
	
	wire [25:0] arr_per_dim_class_hv [0:SEQ_CYCLE_COUNT-1][0:DIMS_PER_CC-1];
	wire [25:0] rp_mux_out [0:DIMS_PER_CC-1];
	
	rp_fsm RP_FSM(
		.clk								(clk),
		.nrst								(nrst),
		.en									(en),
		.bundling_features					(bundling_features),
		.comparing_query_hv_with_class_hv	(comparing_query_hv_with_class_hv),
		.ctr								(ctr),
		.pruning_hv							(pruning_hv),
		.prune_done							(prune_done)
	);

	rp_nets RP_NETS(
		.class_hvs					(class_hvs),
		.arr_per_dim_class_hv		(arr_per_dim_class_hv)
	);

	rp_mux_in RP_MUX_IN(
		.ctr 						(ctr),
		.arr_per_dim_class_hv 		(arr_per_dim_class_hv),
		.rp_mux_out 				(rp_mux_out)
		);
		
	rp_ctrl RP_CTRL_0(
		.clk						(clk),
		.nrst						(nrst),
		.pruning_hv					(pruning_hv),
		.rp_mux_out					(rp_mux_out),
		.enable_signal				(enable_signal)
	);

endmodule
