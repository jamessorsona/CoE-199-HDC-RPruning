module enc_fsm(
    input  wire 		clk,
    input  wire 		nrst,
    input  wire 		en,
    input  wire 		start_encoding,
    output logic [1:0] 	ctr,
	output logic 		bundling_features,
    output logic 		encoding_done
    );
       
    wire bundling_done;  
    
    typedef enum logic [1:0] {S_IDLE, S_BIND, S_BUNDLE, S_ENC_DONE} STATE;
    STATE state;  
               
    // state transition
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            state <= S_IDLE;
        end
        else begin
            case(state) 
                S_IDLE: begin
                    if(start_encoding && en) begin
                        state <= S_BIND;
                    end
                    else begin
                        state <= S_IDLE;
                    end 
                end
                
				S_BIND:   state <= S_BUNDLE;  
				
                S_BUNDLE: begin
                    if(bundling_done) begin         
                        state <= S_ENC_DONE;
                    end 
                    else begin
                        state <= S_BUNDLE;
                    end        
                end
                    
                default: begin
					if(start_encoding && en) begin
                        state <= S_BIND;
                    end
                    else begin
                        state <= S_IDLE;
                    end
                end
            endcase
        end 
     end 
     
     // output control signals (fully comb.)
     always_comb begin
        case(state) 
			S_BUNDLE:   {bundling_features, encoding_done} = {1'b1, 1'b0};     
            S_ENC_DONE: {bundling_features, encoding_done} = {1'b0, 1'b1};
            default:    {bundling_features, encoding_done} = {1'b0, 1'b0};
        endcase
     end
     
     // update ctr (select-bit of the encoding MUX) 
     always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
           ctr <= '0;
        end 
        else begin
            if((state == S_BUNDLE) && en) begin                   
                ctr <= ctr + 1;
            end
            else begin                    
                ctr <= '0;
            end 
        end      
    end    
    
    // update bundling_done    
    assign bundling_done = (ctr == SEQ_CYCLE_COUNT-1) ? 1'b1 : 1'b0;
    
endmodule

