`define FEATURE_COUNT 617

module enc_bundler(
	input wire 						bundling_features,
	//input wire 						enable_signal,
    input wire [`FEATURE_COUNT-1:0]	bits_to_bundle,
    output wire 					thresholded_bit
    );

	/*
	Adds all the bits in the same dimension of all encoded level hvs
	*/
	
    // Binary Tree Adder  
    logic [1:0] tree_add_lvl_0	[0:307];
    wire  [2:0] tree_add_lvl_1	[0:153];
    wire  [3:0] tree_add_lvl_2	[0:76];
    wire  [4:0] tree_add_lvl_3	[0:38];
    wire  [5:0] tree_add_lvl_4	[0:18];
    wire  [6:0] tree_add_lvl_5	[0:9];
    wire  [7:0] tree_add_lvl_6	[0:4];
    wire  [8:0] tree_add_lvl_7	[0:1];
    wire  [9:0] tree_add_lvl_8;
    wire  [9:0] accumulated_sum;

	//wire [FEATURE_COUNT-1:0] bits_to_bundle_w_en;

	
    // Tree adder level 0
	always_comb begin
		//if (enable_signal) begin
			for (int i = 0; i < 308; i++ ) begin
			  tree_add_lvl_0[i] = bits_to_bundle[2*i] + bits_to_bundle[(2*i)+1];
			end
		//end
	end
      

    // Tree adder level 1
    for (genvar i = 0; i < 154; i++ ) begin
      assign tree_add_lvl_1[i] = tree_add_lvl_0[2*i] + tree_add_lvl_0[(2*i)+1];
    end
    

    // Tree adder level 2
    for (genvar i = 0; i < 77; i++ ) begin
      assign tree_add_lvl_2[i] = tree_add_lvl_1[2*i] + tree_add_lvl_1[(2*i)+1];
    end
    

    // Tree adder level 3
    for (genvar i = 0; i < 38; i++ ) begin
      assign tree_add_lvl_3[i] = tree_add_lvl_2[2*i] + tree_add_lvl_2[(2*i)+1];
    end

    assign tree_add_lvl_3[38] = tree_add_lvl_2[76] + bits_to_bundle[616];


    // Tree adder level 4
    for (genvar i = 0; i < 19; i++ ) begin
      assign tree_add_lvl_4[i] = tree_add_lvl_3[2*i] + tree_add_lvl_3[(2*i)+1];
    end
    
  
    // Tree adder level 5
    for (genvar i = 0; i < 9; i++ ) begin
      assign tree_add_lvl_5[i] = tree_add_lvl_4[2*i] + tree_add_lvl_4[(2*i)+1];
    end

    assign tree_add_lvl_5[9] = tree_add_lvl_4[18] + tree_add_lvl_3[38];
    

    // Tree adder level 6
    for (genvar i = 0; i < 5; i++ ) begin
      assign tree_add_lvl_6[i] = tree_add_lvl_5[2*i] + tree_add_lvl_5[(2*i)+1];
    end

    // Tree adder level 7
    for (genvar i = 0; i < 2; i++ ) begin
      assign tree_add_lvl_7[i] = tree_add_lvl_6[2*i] + tree_add_lvl_6[(2*i)+1];
    end
  
 
    // Tree adder level 8
    assign tree_add_lvl_8 = tree_add_lvl_7[0] + tree_add_lvl_7[1];


    // Accumulated sum
    assign accumulated_sum = tree_add_lvl_8 + tree_add_lvl_6[4]; 
 
     
    // update thresholded_bit  
    assign thresholded_bit = (accumulated_sum > ENCODING_BIT_THR) ? 1'b1 : 1'b0;
  
                 
endmodule  
