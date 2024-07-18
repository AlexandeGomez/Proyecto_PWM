module top_module #(parameter FRECUENCY_BITS = 7, parameter RESOLUTION_BITS = 8, parameter CONT_SPEED = 24, parameter SCAN_SPEED = 14)(
//inputs//                                                  // (7)FB -> 1.5K Hz ; RB -> 8(255) ; CS -> 3 Hz ; SS -> 3 KHz 
input clk_top, rst_top, sum_top, rest_top,

//outputs//
output enaGen, enaSel, enaSca, pwm_top, rdy_top,
output [RESOLUTION_BITS-1 : 0] valorReference,
output [RESOLUTION_BITS-1 : 0] valueGenerator,
output [3:0] fdig_top, sdig_top,	tdig_top,
output [7:0] seg_data1, seg_data2, seg_data3,
output [5:0] seg_sel_top,
output [7:0] seg_data_top,
output in1_top, in2_top
);


// --------------------------- Prescalers --------------------
prescaler #( .COUNTER_SIZE(FRECUENCY_BITS)) prescalerGenerador( 
//in
	.clk	(clk_top),
	.rst	(rst_top), 
//out
	.ena	(enaGen)
);

prescaler #( .COUNTER_SIZE(CONT_SPEED)) prescalerSelector( 
//in
	.clk	(clk_top),
	.rst	(rst_top), 
//out
	.ena	(enaSel)
);

prescaler #( .COUNTER_SIZE(SCAN_SPEED)) prescalerScanner( 
//in
	.clk	(clk_top),
	.rst	(rst_top), 
//out
	.ena	(enaSca)
);

//------------------------- Contador Selector-------------------
contadorSelector #(	.SIZE_COUNT(RESOLUTION_BITS)) sel(
//in
	.clk	(clk_top),
	.rst	(rst_top),
	.ena 	(enaSel),
	.sum	(sum_top),
	.rest	(rest_top),
//out
	.valor(valorReference)
);

//------------------------ Contador Generador ------------------
contadorGenerador #( .RESOLUTION_BITS(RESOLUTION_BITS)) gen(
//in
	.clk	(clk_top),
	.rst	(rst_top),
	.ena	(enaGen),
//out
	.value(valueGenerator)
);

// ---------------------- Comparador ----------------------------
comparador #( .RESOLUTION_BITS(RESOLUTION_BITS)) comp(
//in
	.clk				(clk_top),
	.value			(valueGenerator),
	.referencia		(valorReference),
//out
	.pwm_out			(pwm_top)
);


//----------------------- Convertidor -------------------------
BCDConvert conv(
//in
	.clk			(clk_top),
	.bin_d_in	(valorReference),
//out
	.fdig			(fdig_top),
	.sdig			(sdig_top),
	.tdig			(tdig_top),
	.rdy			(rdy_top)
);

//----------------------- Decodificadores -------------------
seg_decoder dec_first(
//in
	.clk			(clk_top),
	.bin_data	(fdig_top),
	.ena			(rdy_top),
//out
	.seg_data	(seg_data1)
);

seg_decoder dec_second(
//in
	.clk			(clk_top),
	.bin_data	(sdig_top),
	.ena			(rdy_top),
//out
	.seg_data	(seg_data2)
);

seg_decoder dec_thirt(
//in
	.clk			(clk_top),
	.bin_data	(tdig_top),
	.ena			(rdy_top),
//out
	.seg_data	(seg_data3)
);

// ------------------------------------- Scanner ------------------
seg_scan segscan(
//in
	.clk				(enaSca),
	.rst_n			(rst_top),
	.seg_data_0		(seg_data1),
	.seg_data_1		(seg_data2),
	.seg_data_2		(seg_data3),
//out	
	.seg_sel			(seg_sel_top),
	.seg_data		(seg_data_top)
);

// --------------------------------- Control direcciones ---------
controlDireccion contDir(
	.in1	(in1_top),
	.in2	(in2_top)
);

endmodule
