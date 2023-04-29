`define DIMS_PER_CC 1024
`define BITWIDTH_PER_DIM 9

module class_reg_nonbin(
    input  wire  											clk,
    input  wire  											nrst,
    input  wire  											adjusting_nonbin_class_hvs,
	input  wire  [1:0] 										class_ctr, 
    input  wire  [1:0] 										nonbin_ctr,    
    input  wire  [`DIMS_PER_CC-1:0][`BITWIDTH_PER_DIM-1:0] 	nonbin_class_reg_in,
    output logic [`DIMS_PER_CC-1:0][`BITWIDTH_PER_DIM-1:0] 	nonbin_class_reg_out
    );  
   
    // This register holds one nonbinary class hv for training. 4096 (dimension) x 9-bit wide (represent the accumulation of all features).
    // Equal to "logic [3:0][1023:0][8:0] nonbin_class_hvs ([4 segments][1024 dimension per segment][9-bit representation])"

    logic [SEQ_CYCLE_COUNT-1:0][DIMS_PER_CC-1:0][BITWIDTH_PER_DIM-1:0] nonbin_class_hvs;
  
    // class hvs & input nonbinary class demux
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            nonbin_class_hvs <= '0;
        end    
        else if (adjusting_nonbin_class_hvs) begin
            case(nonbin_ctr)
                5'd0	: nonbin_class_hvs[0] <= nonbin_class_reg_in;
                5'd1	: nonbin_class_hvs[1] <= nonbin_class_reg_in;
                5'd2	: nonbin_class_hvs[2] <= nonbin_class_reg_in;
                default	: nonbin_class_hvs[3] <= nonbin_class_reg_in;
            endcase            
        end 
        else begin
            nonbin_class_hvs <= nonbin_class_hvs;
        end
    end 
  
    // output nonbinary class mux 
    always_comb begin
        case(class_ctr) //class_ctr
            5'd0	: nonbin_class_reg_out = nonbin_class_hvs[0];
            5'd1	: nonbin_class_reg_out = nonbin_class_hvs[1];
            5'd2	: nonbin_class_reg_out = nonbin_class_hvs[2];
            default	: nonbin_class_reg_out = nonbin_class_hvs[3];
        endcase            
    end 

endmodule
