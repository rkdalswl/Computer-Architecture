`include "vending_machine_def.v"

	

module check_time_and_coin(i_input_coin,i_select_item,clk,reset_n,wait_time,current_total,o_return_coin, i_trigger_return);
	input clk;
	input reset_n;
	input [`kNumCoins-1:0] i_input_coin;
	input [`kNumItems-1:0]	i_select_item;
	input [`kTotalBits-1:0] current_total;
	input i_trigger_return;
	output reg  [`kNumCoins-1:0] o_return_coin;
	output reg [31:0] wait_time;
	
	reg isTimerReset;

	// initiate values
	initial begin
		// TODO: initiate values
		o_return_coin = 0;
		wait_time = `kWaitTime;
		isTimerReset = 0;
	end


	// update coin return time
	always @(i_input_coin, i_select_item, i_trigger_return) begin
		// TODO: update coin return time
		if (i_input_coin == 0 && i_select_item == 0)
			isTimerReset = 0;
		else if (i_trigger_return == 1) begin
			isTimerReset = 0; 
			wait_time = 0;
		end
		else
			isTimerReset = 1;
	end

	always @(*) begin
		// TODO: o_return_coin
		if(wait_time <= 0) begin
			if(current_total >= 1000)
				o_return_coin = 3'b100;
			else if(current_total >= 500)
				o_return_coin = 3'b010;
			else if(current_total >= 100)
				o_return_coin = 3'b001;
			else
				o_return_coin = 0;
		end
		else
			o_return_coin = 0;
	end

	always @(posedge clk ) begin
		if (!reset_n) begin
		// TODO: reset all states.
			wait_time <= `kWaitTime;
			isTimerReset <= 0;
			o_return_coin <= 0;
		end
		else begin
		// TODO: update all states.
			if(!isTimerReset && (wait_time > 0))
				wait_time <= wait_time-1;
			else if(!isTimerReset && (wait_time == 0))
				wait_time <= 0;
			else
				wait_time <= `kWaitTime;
		end
	end
endmodule 