module contadorSelector #(parameter SIZE_COUNT)( //8 bits ideal
input clk, rst, ena, sum, rest,

output reg [SIZE_COUNT-1 : 0] valor
);

parameter MAX_COUNT = (2**SIZE_COUNT)-1;

always@(posedge clk or negedge rst)
	begin
		if(!rst)
			valor <= {SIZE_COUNT{1'b0}};
		else
			begin
				if(ena)
					begin
						if(!sum)
							begin
								if(valor == MAX_COUNT)
									valor <= {SIZE_COUNT{1'b0}};
								else
									valor <= valor + 1'b1;
							end
						else if(!rest)
							begin
								if(valor=={SIZE_COUNT{1'b0}})
									valor <= MAX_COUNT;
								else
									valor <= valor - 1'b1;
							end
						else
							valor <= valor;
					end
				else
					valor <= valor;
			end
	end
endmodule
