`define DIMS_PER_CC 1024
`define SEQ_CYCLE_COUNT 4

module class_reg_bin(
    input  wire 											clk,
    input  wire 											nrst,
    input  wire 											binarizing_class_hvs,
    input  wire 	[4:0] 									class_select_bits,
    input  wire 	[1:0] 									bin_ctr,    
    input  wire 	[`DIMS_PER_CC-1:0] 						bin_class_reg_in,    
    output logic 	[`SEQ_CYCLE_COUNT-1:0][`DIMS_PER_CC-1:0] 	bin_class_hvs 			[0:25]
    );    
  	
  	/*
  	A multiplexer to choose the segment in which the bin HV is to be stored
  	*/
  	
    // Note: This is equal to "output logic [4095:0] bin_class_hvs [0:25]"
         
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            for(int i = 0; i < 26; i++) begin
                bin_class_hvs[i] <= '0;
            end
        end    
        else if (binarizing_class_hvs) begin
            case(class_select_bits)
                5'd0: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[0][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[0][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[0][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[0][3] <= bin_class_reg_in;
                    endcase
                end
                5'd1: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[1][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[1][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[1][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[1][3] <= bin_class_reg_in;
                    endcase
                end
                5'd2: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[2][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[2][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[2][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[2][3] <= bin_class_reg_in;
                    endcase
                end
                5'd3: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[3][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[3][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[3][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[3][3] <= bin_class_reg_in;
                    endcase
                end
                5'd4: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[4][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[4][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[4][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[4][3] <= bin_class_reg_in;
                    endcase
                end
                5'd5: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[5][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[5][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[5][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[5][3] <= bin_class_reg_in;
                    endcase
                end
                5'd6: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[6][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[6][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[6][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[6][3] <= bin_class_reg_in;
                    endcase
                end
                5'd7: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[7][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[7][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[7][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[7][3] <= bin_class_reg_in;
                    endcase
                end
                5'd8: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[8][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[8][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[8][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[8][3] <= bin_class_reg_in;
                    endcase
                end
                5'd9: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[9][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[9][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[9][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[9][3] <= bin_class_reg_in;
                    endcase
                end
                5'd10: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[10][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[10][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[10][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[10][3] <= bin_class_reg_in;
                    endcase
                end
                5'd11: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[11][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[11][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[11][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[11][3] <= bin_class_reg_in;
                    endcase
                end
                5'd12: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[12][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[12][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[12][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[12][3] <= bin_class_reg_in;
                    endcase
                end
                5'd13: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[13][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[13][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[13][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[13][3] <= bin_class_reg_in;
                    endcase
                end
                5'd14: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[14][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[14][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[14][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[14][3] <= bin_class_reg_in;
                    endcase
                end
                5'd15: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[15][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[15][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[15][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[15][3] <= bin_class_reg_in;
                    endcase
                end
                5'd16: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[16][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[16][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[16][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[16][3] <= bin_class_reg_in;
                    endcase
                end
                5'd17: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[17][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[17][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[17][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[17][3] <= bin_class_reg_in;
                    endcase
                end
                5'd18: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[18][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[18][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[18][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[18][3] <= bin_class_reg_in;
                    endcase
                end
                5'd19: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[19][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[19][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[19][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[19][3] <= bin_class_reg_in;
                    endcase
                end
                5'd20: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[20][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[20][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[20][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[20][3] <= bin_class_reg_in;
                    endcase
                end
                5'd21: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[21][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[21][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[21][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[21][3] <= bin_class_reg_in;
                    endcase
                end
                5'd22: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[22][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[22][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[22][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[22][3] <= bin_class_reg_in;
                    endcase
                end
                5'd23: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[23][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[23][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[23][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[23][3] <= bin_class_reg_in;
                    endcase
                end
                5'd24: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[24][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[24][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[24][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[24][3] <= bin_class_reg_in;
                    endcase
                end
                default: begin
                    case(bin_ctr)
                        5'd0	: bin_class_hvs[25][0] <= bin_class_reg_in;
                        5'd1	: bin_class_hvs[25][1] <= bin_class_reg_in;
                        5'd2	: bin_class_hvs[25][2] <= bin_class_reg_in;
                        default	: bin_class_hvs[25][3] <= bin_class_reg_in;
                    endcase
                end     
            endcase
        end 
        else begin
            bin_class_hvs <= bin_class_hvs;
        end
    end 
  
endmodule
