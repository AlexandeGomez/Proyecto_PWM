module comparador #(parameter RESOLUTION_BITS)( //8 bits ideal
input clk,
input [RESOLUTION_BITS-1 : 0] value,
input [RESOLUTION_BITS-1 : 0] referencia,

output reg pwm_out
);

always@(posedge clk)
begin
	if(value < referencia)
		pwm_out <= 1'b1;
	else
		pwm_out <= 1'b0;
end

endmodule