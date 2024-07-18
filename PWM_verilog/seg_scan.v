module seg_scan(
	input           clk,
	input           rst_n,
	output reg[5:0] seg_sel,      //digital led chip select
	output reg[7:0] seg_data,     //eight segment digital tube output,MSB is the decimal point
	input[7:0]      seg_data_0,
	input[7:0]      seg_data_1,
	input[7:0]      seg_data_2
);


reg[3:0] scan_sel;     //Scan select counter

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		scan_sel <= 4'd0;
	else
		begin
			if(scan_sel == 4'd2)
				scan_sel <= 4'd0;
			else
				scan_sel <= scan_sel + 1'b1;
		end
end


always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		seg_sel <= 6'b111111;
		seg_data <= 8'b11111111;
	end
	else
	begin
		case(scan_sel)
			//first digital led
			4'd0:
			begin
				seg_sel <= 6'b01_1111;
				seg_data <= seg_data_0;
			end
			//second digital led
			4'd1:
			begin
				seg_sel <= 6'b10_1111;
				seg_data <= seg_data_1;
			end
			//...
			4'd2:
			begin
				seg_sel <= 6'b11_0111;
				seg_data <= seg_data_2;
			end
			default:
			begin
				seg_sel <= 6'b11_1111;
				seg_data <= 8'b11111111;
			end
		endcase
	end
end

endmodule