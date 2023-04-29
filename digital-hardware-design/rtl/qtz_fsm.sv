module qtz_fsm(
    input wire 				clk,
    input wire 				nrst,
    input wire 				en,
    input wire 				start_mapping,
    output logic 	[1:0] 	ctr,
	output logic			mapping_hv_segment,
    output logic 			mapping_done
    );
    
    wire hv_fetch_done;  
      
    typedef enum logic [1:0] {S_IDLE, S_MAP, S_BUFFER, S_MAP_DONE} STATE;
    STATE state; 
                
    // state transition
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            state <= S_IDLE;
        end
        else begin
            case(state) 
                S_IDLE:
                    if(start_mapping && en) begin
                        state <= S_MAP;
                    end
                    else begin
                        state <= S_IDLE;
                    end 
                S_MAP: 
                    if(hv_fetch_done) begin         
                        state <= S_BUFFER;		 // output buffering 
                    end 
				S_BUFFER:  state <= S_MAP_DONE;          
                default:   
					if(start_mapping && en) begin
                        state <= S_MAP;
                    end
                    else begin
                        state <= S_IDLE;
                    end
            endcase
        end 
     end 
          
     
	// output control signals (fully comb.)
	always_comb begin
		case(state)  		 
			S_MAP:      {mapping_hv_segment, mapping_done} = {1'b1, 1'b0}; 
			S_MAP_DONE: {mapping_hv_segment, mapping_done} = {1'b0, 1'b1};
			default:    {mapping_hv_segment, mapping_done} = {1'b0, 1'b0};    
		endcase
	end
     
    // update bundling_done    
    assign hv_fetch_done = (ctr == SEQ_CYCLE_COUNT-1) ? 1'b1 : 1'b0;

    // update ctr (select-bit of  MUX & DEMUX) 
	always_ff @(posedge clk or negedge nrst) begin
		if (!nrst) begin
		   ctr <= '0;
		end 
		else begin
			if((state == S_MAP) && en) begin                   
				ctr <= ctr + 1;
			end
			else begin                    
				ctr <= '0;
			end 
		end      
	end    
          
endmodule
