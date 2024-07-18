//Convertidor de una entrada de 8 bits a una salida de

module BCDConvert(
input 	clk,
input 	[7:0] bin_d_in,

//output 	[11:0] bcd_d_out,
output [3:0] fdig,
output [3:0] sdig,
output [3:0] tdig,

output 	rdy
);

//Variables de estado
parameter IDLE = 3'b000;
parameter SETUP = 3'b001;
parameter ADD = 3'b010;
parameter SHIFT = 3'b011;
parameter DONE = 3'b100;

//Registro de apoyo
reg [19:0] bcd_data = 0;
reg [2:0] state = IDLE;
reg [3:0] sh_counter = 0;
reg busy = 0;
reg result_rdy = 0;

reg [7:0] pass_state = 0;

always@(posedge clk)
begin
	if(!busy)
		begin
			pass_state <= bin_d_in;
			bcd_data <= {12'b0, bin_d_in};
			state <= SETUP;
		end

	case(state)
		IDLE: 
		begin
			result_rdy <= 0;
			busy <= 0;
			sh_counter <= 4'b0;
		end
		
		SETUP:
		begin
			if(pass_state != bin_d_in)
				begin
					state <= IDLE;
				end
			else
				begin
					busy <= 1;
					state <= ADD;
				end
		end
		
		ADD:
		begin
			if(pass_state != bin_d_in)
				begin
					state <= IDLE;
				end
			else
				begin
					if(bcd_data[11:8] > 4)
					begin
						bcd_data[19:8] <= bcd_data[19:8] + 12'b0000_0000_0011;
					end
					if(bcd_data[15:12] > 4)
					begin
						bcd_data[19:12] <= bcd_data[19:12] + 8'b0000_0011;
					end
					if(bcd_data[19:16] > 4)
					begin
						bcd_data[19:16] <= bcd_data[19:16] + 4'b0011;
					end
					state <= SHIFT;
				end
		end
		
		SHIFT:
		begin
			if(pass_state != bin_d_in)
				begin
					state <= IDLE;
				end
			else
				begin
					sh_counter <= sh_counter + 1'b1;
					bcd_data <= bcd_data << 1;
					
					if(sh_counter==7)
						begin
							sh_counter <= 4'b0;
							state <= DONE;
						end
					else
						begin
							state <= ADD;
						end
				end
		end
	
		DONE:
		begin
			if(pass_state != bin_d_in)
				begin
					state <= IDLE;
				end
			else
				begin
					result_rdy <= 1'b1;
					state <= IDLE;
				end
		end
		
		default:
			state <= IDLE;
		endcase
end

//assign bcd_d_out = bcd_data[19:8];
assign fdig = bcd_data[11:8];
assign sdig = bcd_data[15:12];
assign tdig = bcd_data[19:16];
assign rdy = result_rdy;

endmodule

