module spi_mux(clk, reset, spi_nCS, spi_sck, spi_mosi, spi_miso, out, status, buffer_oe, out_en);

// master clock (50MHz)
input				clk;
// active low reset line
input				reset;

// SPI chip select
input				spi_nCS;
// SPI clock
input				spi_sck;
// SPI master output
input				spi_mosi;

// SPI master input
output			spi_miso;
reg					spi_miso;

// output bus
output	[7:0]	out;
reg		[7:0] out;

// status LEDs
output	[2:0] status;
reg		[2:0] status;

// output enable for 3v3 -> 5v translator
output			buffer_oe;
reg				buffer_oe;

// output enable for differential driver
output	[3:0]	out_en;
reg		[3:0] out_en;


// state
parameter	STATE_IDLE	= 4'b0000;
parameter	STATE_SHIFT	= 4'b0001;
parameter	STATE_RESET	= 4'b1000;

reg		[3:0] state = STATE_IDLE;

// counter for pulses of SCK
reg		[2:0]	sck_counter;

// initial state
initial
begin
	spi_miso <= 1'bz;

	out <= 0;
	buffer_oe <= 0;
	out_en <= 0;

	status <= 0;

	// reset counter as well
	sck_counter <= 0;
end

// always @(posedge clk, posedge spi_sck)
always @(posedge clk)
begin
	// disable other status LEDs
	status[2:1] = 0;
	status[0] <= ~reset;

	// miso is always hi z
	spi_miso = 1'bz;

	// the bus voltage translator is always active
	buffer_oe <= 1;

	// is reset asserted?
	if(~reset) begin
		// clear the output data bus
		out <= 0;
		// disable differential drivers
		out_en <= 0;

		// clear the counter and state
		state <= STATE_RESET;
		sck_counter <= 0;

		// deassert MISO
		// spi_miso <= 1'bz;
	end else begin
		// reset is not asserted, do state machine-y stuff
		case (state)
			// reset state
			STATE_RESET: begin
				state <= STATE_IDLE;
			end

			// idle state, wait for CS to be asserted
			STATE_IDLE: begin
				// CS has gone low, shift data in
				if(!spi_nCS) begin
					state <= STATE_SHIFT;
				end
			end

			// shift bits in until CS goes high
			STATE_SHIFT: begin
				// is CS high now?
				if(!spi_nCS) begin
					// now, copy the value to the appropriate output
					// out[sck_counter - 1] = 1;
					out[sck_counter] = spi_mosi;

					// increment the bit counter
					sck_counter <= sck_counter + 1;

					// stay in this state
					state <= STATE_SHIFT;
				end else begin
					// otherwise, go back to the idle state
					state <= STATE_IDLE;

					// be sure to reset counter
					sck_counter <= 0;
				end
			end
		endcase
	end
end


endmodule
