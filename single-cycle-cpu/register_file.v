module register_file(read_out1, read_out2, read1, read2, write_reg, write_data, reg_write, clk, reset_n); 
    output [15:0] read_out1;
    output [15:0] read_out2;
    input [1:0] read1;
    input [1:0] read2;
    input [1:0] write_reg;
    input [15:0] write_data;
    input reg_write;
    input clk;
    input reset_n;

	reg [15:0] registers[3:0];

	assign read_out1 = registers[read1];
	assign read_out2 = registers[read2];
    
	integer i;
	always @(posedge clk) begin
    	if(reg_write == 1) begin
            registers[write_reg] <= write_data;
    	end
        if (reset_n == 0) begin
            for (i = 0; i < 3; i=i+1) begin
                registers[i] <= 0;
            end
        end
    end

endmodule
