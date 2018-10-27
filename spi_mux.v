module spi_mux(clk, reset, spi_nCS, spi_sck, spi_mosi, spi_miso, out, status, buffer_oe, out_en);

// declare inputs
input				clk;
input				reset;

input				spi_nCS;
input				spi_sck;
input				spi_mosi;

// declare outputs
output			spi_miso;

output	[7:0]	out;
reg		[7:0] out;

output	[2:0] status;

output			buffer_oe;

output	[3:0]	out_en;

// when asserted, shift reg data is latched to outputs
wire				latch_out;
// output bus of shift register
wire		[7:0] shift_q;
//reg		[7:0]	shift_q;

// resets shift register
wire				shift_reset;
// shift register clock (gated SCLK)
wire				shift_clk;

// counter for pulses of SCK
reg		[4:0]	sck_counter;


// shift register's clock is SCK but ANded with CS
assign shift_clk = spi_sck & !spi_nCS;

// copy shift register data bus when latch is asserted
always @ (latch_out, shift_q)
begin
	if (latch_out == 1) begin
		out = shift_q;
	end
end

// count the number of pulses on the clock; when 8 assert the latch
always @ (spi_sck, spi_nCS, reset)
begin
	// is reset asserted?
	if (reset == 0) begin
		// reset counter
		sck_counter <= 0;
	end
	// it isn't, handle normal
	else
		// latch deasserted if CS goes deasserted
		if (spi_nCS == 1) begin
			// not selected so unlatch
			latch_out <= 0;
			
			// clear counter
			sck_counter <= 0;
		end
		else
			// otherwise, count SCK pulses
			if (posedge spi_sck) begin				
				// if it's 8, assert latch
				if(sck_counter = 8) begin
					latch_out <= 1;
					
					// reset counter
					sck_counter <= 0;
				else
					// reset latch tho
					latch_out <= 0;
				
					// otherwise, just increment the counter
					sck_counter <= sck_counter + 1;
				end
			end
		end
	end
end



// instantiate shift register
shiftreg shiftyboi (
	.aset			(shift_reset),
	.clock		(shift_clk),
	// shift input is SPI MOSI
	.shiftin		(spi_mosi),
	// connect output bus
	.q				(shift_q)
);

endmodule