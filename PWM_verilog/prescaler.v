// MODULO PRESCALER //
// // Parametrizado para poder escoger la frecuancia en la que activara ena//
// 50KHz preterminado que son 2 bits del contador del prescaler

module prescaler #(parameter COUNTER_SIZE)( 
input		clk, rst, 
output reg ena
);

parameter MAX_COUNTER = (2**COUNTER_SIZE)-1;

reg [COUNTER_SIZE-1 : 0] count;

always@(posedge clk or negedge rst)
begin
	if(!rst)
		count <= {COUNTER_SIZE{1'b0}};
	else
		begin
			if(count==MAX_COUNTER)
				begin
					count <= {COUNTER_SIZE{1'b0}};
					ena <= 1'b1;
				end
			else
				begin
					count <= count + 1'b1;
					ena <= 1'b0;
				end
		end
end

endmodule
