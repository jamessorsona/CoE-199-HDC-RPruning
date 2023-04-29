module rp_fsm(
    input  wire 		clk,
    input  wire 		nrst,
    input  wire 		en,
    input  wire 		bundling_features,
    input  wire 		comparing_query_hv_with_class_hv,
    output wire [1:0]	ctr
    );
       
    wire pruning_done;  
    
    typedef enum logic [1:0] {S_IDLE, S_PRUNE, S_PRUNE_DONE} STATE;
    STATE state;  
               
    // state transition
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            state <= S_IDLE;
        end
        else begin
            case(state) 
                S_IDLE: begin
                    if ((bundling_features || comparing_query_hv_with_class_hv) && en) begin
                        state <= S_PRUNE;
                    end
                    else begin
                        state <= S_IDLE;
                    end 
                end
                S_PRUNE: begin
                    if(pruning_done) begin         
                        state <= S_PRUNE_DONE;
                    end 
                    else begin
                        state <= S_PRUNE;
                    end        
                end  
                default: begin
                        state <= S_IDLE;
                end
            endcase
        end 
     end 
     
     always_comb begin
        case(state)    
            S_PRUNE: 	  pruning_hv = 1'b1;
            default: 	  pruning_hv = 1'b0
        endcase
    end
     
     // update ctr (select-bit of the encoding MUX) 
     always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
           ctr <= '0;
        end 
        else begin
            if((state == S_PRUNE) && en) begin                   
                ctr <= ctr + 1;
            end
            else begin                    
                ctr <= '0;
            end 
        end      
    end    
    
    // update bundling_done    
    assign pruning_done = (ctr == SEQ_CYCLE_COUNT-1) ? 1'b1 : 1'b0;
endmodule
