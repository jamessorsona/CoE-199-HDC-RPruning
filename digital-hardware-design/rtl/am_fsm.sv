module am_fsm(
    input  wire  	   clk,
    input  wire        nrst,
    input  wire        en,
    input  wire        start_querying,
    input  wire        testing_dataset_finished,
    output logic [1:0] query_ctr, 
    output logic 	   comparing_query_hv_with_class_hv,
    output logic	   inferring_class,
    output logic 	   tallying_accuracy
    );
    
    wire querying_done;     
    
    typedef enum logic [1:0] {S_IDLE, S_QUERY, S_INFER, S_TALLY} STATE;
    STATE state;  
                
    // state transition
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            state <= S_IDLE;
        end
        else begin
	        case(state) 
	            S_IDLE:
	                if(start_querying && en) begin
	                    state <= S_QUERY;
	                end
	                else begin
	                    state <= S_IDLE;
	                end
	            S_QUERY: 
	                if(querying_done) begin         
	                    state <= S_INFER;
	                end 
	                else begin
	                    state <= S_QUERY;
	                end  
	            S_INFER: state <= S_TALLY;   
	            default:   
	                if(!testing_dataset_finished) begin
	                    state <= S_QUERY;
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
            S_IDLE:  {comparing_query_hv_with_class_hv, inferring_class, tallying_accuracy} = {1'b0, 1'b0, 1'b0};
            S_QUERY: {comparing_query_hv_with_class_hv, inferring_class, tallying_accuracy} = {1'b1, 1'b0, 1'b0};
            S_INFER: {comparing_query_hv_with_class_hv, inferring_class, tallying_accuracy} = {1'b0, 1'b1, 1'b0};
            default: {comparing_query_hv_with_class_hv, inferring_class, tallying_accuracy} = {1'b0, 1'b0, 1'b1};
        endcase
    end    
         
    // update query_ctr (select-bit of the 26 binary class DEMUX; to segment to HV to 4 parts) 
    always_ff @(posedge clk or negedge nrst) begin
        if (!nrst) begin
           query_ctr <= '0;
        end      
        else if((state == S_QUERY) && en) begin 
            if (query_ctr < SEQ_CYCLE_COUNT-1) begin
                query_ctr <= query_ctr + 1;    			// count from 0 to 3 (4 segments)                               
            end 
            else begin
                query_ctr <= '0;                 		// reset counter to 0
            end
        end
        else begin
            query_ctr <= '0;
        end    
    end    
    
    // update querying_done (after 4 iterations, all query segments have already been compared)  
    assign querying_done = ((query_ctr == SEQ_CYCLE_COUNT-1)) ? 1'b1 : 1'b0;
    
endmodule
