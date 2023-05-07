module class_fsm(
    input  wire 			clk,
    input  wire 			nrst,
    input  wire 			en,
    input  wire 			start_class_gen,
    input  wire 			training_dataset_finished,       // assert (6,238*12) CCs after start_class_gen == 1
	input  wire				start_binarizing,				 // asserted if we're switching class hv to train
	output logic	[1:0] 	class_ctr,
	output logic 	[1:0] 	bin_ctr,
    output logic	[1:0] 	nonbin_ctr,  
    output logic 			adjusting_nonbin_class_hvs,
    output logic 			binarizing_class_hvs,
    output logic 			class_gen_done
    );    
    
    typedef enum logic [1:0]	{S_IDLE, S_TRAIN_NONBIN, S_CLASS_DONE} STATE_N;		// state_nonbin
    STATE_N state_n;  

	typedef enum logic 			{S_INACTIVE, S_BINARIZE} STATE_B;					// state_bin
	STATE_B state_b;

	// FSM CONTROL FOR THE NONBINARY REGISTER  (state_n)
 
    // state transition
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            state_n <= S_IDLE;
        end
        else begin
	        case(state_n) 
	            S_IDLE:
	                if (start_class_gen && en) begin        
	                    state_n <= S_TRAIN_NONBIN;           
	                end
					else if (training_dataset_finished) begin
						state_n <= S_CLASS_DONE; 
					end
	                else begin
	                    state_n <= S_IDLE;
	                end           
	            S_TRAIN_NONBIN: 
	                if(nonbin_ctr == SEQ_CYCLE_COUNT-1) begin   
	                    state_n <= S_IDLE;
	                end 
	                else begin
	                    state_n <= S_TRAIN_NONBIN;
	                end                                           
	            default: state_n <= S_IDLE; 
	        endcase
        end 
    end 
        
    // output control signals (fully comb.)
    always_comb begin
        case(state_n)           
            S_TRAIN_NONBIN	: 	{adjusting_nonbin_class_hvs, class_gen_done} = {1'b1, 1'b0};
			S_CLASS_DONE	:   {adjusting_nonbin_class_hvs, class_gen_done} = {1'b0, 1'b1};
            default			:   {adjusting_nonbin_class_hvs, class_gen_done} = {1'b0, 1'b0};
        endcase
    end


	// FSM CONTROL FOR THE BINARY REGISTER	(state_b)

    // state transition
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            state_b <= S_INACTIVE;
        end
        else begin
	        case(state_b) 
	            S_INACTIVE:
	                if (start_binarizing && en) begin        
	                    state_b <= S_BINARIZE;           
	                end
	                else begin
	                    state_b <= S_INACTIVE;
	                end                            
	            default: 
					if (bin_ctr == SEQ_CYCLE_COUNT-1) begin         
	                    state_b <= S_INACTIVE;
	                end 
	                else begin
	                    state_b <= S_BINARIZE;
	                end                            
	        endcase
        end 
    end 
        
    // output control signals (fully comb.)
    always_comb begin
        case(state_b)   
 			S_BINARIZE:     binarizing_class_hvs = 1'b1;           
            default:        binarizing_class_hvs = 1'b0;
        endcase
    end

     
    // Update nonbin_ctr (select bit of the nonbinary class MUX and DEMUX) 
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
           nonbin_ctr <= '0;
        end      
        else if(state_n == S_TRAIN_NONBIN) begin 
            if (nonbin_ctr < SEQ_CYCLE_COUNT-1) begin
                nonbin_ctr <= nonbin_ctr + 1;               // count from 0 to 4                                 
            end 
            else begin
                nonbin_ctr <= '0;                           // reset counter to 0
            end
        end
        else begin
            nonbin_ctr <= '0;
        end    
    end  

	// Update nonbin_ctr (select bit of the nonbinary class DEMUX) 
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
           bin_ctr <= '0;
        end      
        else if(state_b == S_BINARIZE) begin 
            if (bin_ctr < SEQ_CYCLE_COUNT-1) begin
                bin_ctr <= bin_ctr + 1;                  // count from 0 to 4                                  
            end 
            else begin
                bin_ctr <= '0;                           // reset counter to 0
            end
        end
        else begin
            bin_ctr <= '0;
        end    
    end  

	// Update class_ctr (counts during training and during binarizing; select bit of the nonbinary class MUX)
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
           class_ctr <= '0;
        end      
        else if((state_n == S_TRAIN_NONBIN) || (state_b == S_BINARIZE)) begin 
            if (class_ctr < SEQ_CYCLE_COUNT-1) begin
                class_ctr <= class_ctr + 1;                  // count from 0 to 4                                
            end 
            else begin
                class_ctr <= '0;                            // reset counter to 0
            end
        end
        else begin
            class_ctr <= '0;
        end    
    end  

endmodule
