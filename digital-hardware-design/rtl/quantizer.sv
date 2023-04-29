module quantizer( 
    input wire   [15:0] input_value, 
    output logic [3:0] 	quantized_value_level
    ); 
  
    always_comb begin
		if($signed(input_value) > 7778) begin
		    quantized_value_level = 4'd0;
		end          
		else if($signed(input_value) > 5556) begin
		    quantized_value_level = 4'd1;
		end 
		else if($signed(input_value) > 3333) begin
		    quantized_value_level = 4'd2;
		end
		else if($signed(input_value) > 1111) begin
		    quantized_value_level = 4'd3;
		end 
		else if($signed(input_value) > -1111) begin
		    quantized_value_level = 4'd4;
		end 
		else if($signed(input_value) > -3333) begin
		    quantized_value_level = 4'd5;
		end
		else if($signed(input_value) > -5556) begin
		    quantized_value_level = 4'd6;
		end
		else if($signed(input_value) > -7778) begin
		    quantized_value_level = 4'd7;
		end
		else if($signed(input_value) > -10001) begin
		    quantized_value_level = 4'd8;
		end
    end
endmodule
