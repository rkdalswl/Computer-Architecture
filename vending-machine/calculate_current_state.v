
`include "vending_machine_def.v"
	

module calculate_current_state(i_input_coin,i_select_item,item_price,coin_value,current_total,
input_total, output_total, return_total,current_total_nxt,wait_time,o_return_coin,o_available_item,o_output_item);


	
	input [`kNumCoins-1:0] i_input_coin,o_return_coin;
	input [`kNumItems-1:0]	i_select_item;			
	input [31:0] item_price [`kNumItems-1:0];
	input [31:0] coin_value [`kNumCoins-1:0];	
	input [`kTotalBits-1:0] current_total;
	input [31:0] wait_time; ///
	output reg [`kNumItems-1:0] o_available_item,o_output_item;
	output reg  [`kTotalBits-1:0] input_total, output_total, return_total,current_total_nxt;
	integer i;	

	
	// Combinational logic for the next states
	always @(*) begin
		// TODO: current_total_nxt
		// You don't have to worry about concurrent activations in each input vector (or array).
		// Calculate the next current_total state.
		input_total = coin_value[0] * i_input_coin[0] + coin_value[1] * i_input_coin[1] + coin_value[2] * i_input_coin[2];
		return_total = coin_value[0] * o_return_coin[0] + coin_value[1] * o_return_coin[1] + coin_value[2] * o_return_coin[2];
		output_total =  item_price[0] * i_select_item[0] + item_price[1] * i_select_item[1] + item_price[2] * i_select_item[2] + item_price[3] * i_select_item[3];
		current_total_nxt = current_total + input_total - (output_total + return_total);
	end

	// Combinational logic for the outputs
	always @(*) begin
		// TODO: o_available_item
		for( i=0; i<4; i=i+1) begin
			if (current_total >= item_price[i])
				o_available_item[i] = 1;
			else
				o_available_item[i] = 0;
		end
		// TODO: o_output_item
		o_output_item = o_available_item & i_select_item;
	end
 
	


endmodule 