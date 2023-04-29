module oneshot_fsm(
    input  wire  clk,
    input  wire  nrst,
    input  wire  en,
    input  wire  start_hdc,
	input  wire  encoding_done,
	input  wire  class_gen_done,
    input  wire  testing_dataset_finished,
	output wire  start_class_gen,
	output wire  start_querying,
    output logic training_hdc_model,
    output logic testing_hdc_model,
    output logic oneshot_hdc_done
    );
    
    typedef enum logic [1:0] {S_IDLE, S_TRAIN, S_TEST, S_HDC_DONE} STATE;
    STATE state;  
                
    // state transition
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            state <= S_IDLE;
        end
        else begin
            case(state) 
                S_IDLE:
                    if(start_hdc && en) begin
                        state <= S_TRAIN;
                    end
                    else begin
                        state <= S_IDLE;
                    end
				S_TRAIN: 
                    if(class_gen_done) begin         
                        state <= S_TEST;
                    end 
                    else begin
                        state <= S_TRAIN;
                    end 
                S_TEST:    
                    if(testing_dataset_finished) begin
                        state <= S_HDC_DONE;
                    end
                    else begin
                        state <= S_TEST;
                    end   
               default: state <= S_IDLE;          
            endcase
        end 
    end 
        
    // output control signals (fully comb.)
    always_comb begin
        case(state)    	
            S_TRAIN: 	{training_hdc_model, testing_hdc_model, oneshot_hdc_done} = {1'b1, 1'b0, 1'b0};
            S_TEST:  	{training_hdc_model, testing_hdc_model, oneshot_hdc_done} = {1'b0, 1'b1, 1'b0};
			S_HDC_DONE: {training_hdc_model, testing_hdc_model, oneshot_hdc_done} = {1'b0, 1'b0, 1'b1};
            default: 	{training_hdc_model, testing_hdc_model, oneshot_hdc_done} = {1'b0, 1'b0, 1'b0};
        endcase
    end   

	assign start_class_gen = encoding_done & training_hdc_model;
	assign start_querying  = encoding_done & testing_hdc_model; 

endmodule
