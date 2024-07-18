module contadorGenerador #(parameter RESOLUTION_BITS)( // 8 bits ideal
input clk, rst, ena,
output reg [RESOLUTION_BITS-1 :0] value
);

parameter MAX_VALUE = (2**RESOLUTION_BITS)-1;

always@(posedge clk or negedge rst)
begin
	if(!rst)
		value <= 0;
	else if(ena)
		begin
			if(value == MAX_VALUE)
				value <= 0;
			else
				value <= value + 1'b1;
		end
	else
		value <= value;
end

endmodule
