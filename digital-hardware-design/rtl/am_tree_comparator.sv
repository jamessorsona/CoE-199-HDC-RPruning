module am_tree_comparator( 
    input  wire  		clk,
    input  wire 		nrst,
    input  wire  		inferring_class,
    input  wire  [12:0] 	similarity_values [0:25],          // 13 bits to represent 5k-dim hvs
    output logic [4:0] 		class_inference   
    );
    
    logic [12:0] tree_compare_0 [13];
    wire  [12:0] tree_compare_1 [6];
    wire  [12:0] tree_compare_2 [3];
    wire  [12:0] tree_compare_3 [2]; 
    
    logic [4:0] winning_class_0 [13];
    wire  [4:0] winning_class_1 [6];
    wire  [4:0] winning_class_2 [3];
    wire  [4:0] winning_class_3 [2]; 
    
	/* 
	Compares all of the similarity values from the (query hv & bin_hv[i]) to check which has the largest value leading to the inferred 		  	class
	*/
	
	
    // Level 0 (Note: if !inferring_class, all levels will default to 0. No switching activity.)
    always_comb begin
        for (int i = 0; i < 13; i++ ) begin
          tree_compare_0[i]  = similarity_values[2*i] >= similarity_values[(2*i)+1] ? similarity_values[2*i]:similarity_values[(2*i)+1];
          winning_class_0[i] = similarity_values[2*i] >= similarity_values[(2*i)+1] ? (2*i):((2*i)+1);
        end
    end

    // Level 1
    for (genvar i = 0; i < 6; i++ ) begin
      assign tree_compare_1[i]  = tree_compare_0[2*i] >= tree_compare_0[(2*i)+1] ? tree_compare_0[2*i]:tree_compare_0[(2*i)+1];
      assign winning_class_1[i] = tree_compare_0[2*i] >= tree_compare_0[(2*i)+1] ? winning_class_0[2*i]:winning_class_0[(2*i)+1];
    end

    // Level 2
    for (genvar i = 0; i < 3; i++ ) begin
      assign tree_compare_2[i]  = tree_compare_1[2*i] >= tree_compare_1[(2*i)+1] ? tree_compare_1[2*i]:tree_compare_1[(2*i)+1];
      assign winning_class_2[i] = tree_compare_1[2*i] >= tree_compare_1[(2*i)+1] ? winning_class_1[2*i]:winning_class_1[(2*i)+1];
    end
    
    // Level 3
    assign tree_compare_3[0]  = tree_compare_2[0] >= tree_compare_2[1] ? tree_compare_2[0]:tree_compare_2[1];
    assign winning_class_3[0] = tree_compare_2[0] >= tree_compare_2[1] ? winning_class_2[0]:winning_class_2[1];
    
    assign tree_compare_3[1]  = tree_compare_2[2] >= tree_compare_0[12] ? tree_compare_2[2]:tree_compare_0[12];    // for the outlier
    assign winning_class_3[1] = tree_compare_2[2] >= tree_compare_0[12] ? winning_class_2[2]:winning_class_0[12];
    
    // Class inference
    always_ff @(posedge clk or negedge nrst) begin
        if(!nrst) begin
            class_inference <= '0;
        end
        else if(inferring_class) begin						
            class_inference <= (tree_compare_3[0] >= tree_compare_3[1]) ? winning_class_3[0]:winning_class_3[1];
        end 
        else begin
            class_inference <= class_inference;
        end
    end


endmodule
