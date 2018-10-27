module spi_mux_test;
  reg clk, reset, spi_nCS, spi_sck, spi_mosi;

  wire  spi_miso;
  wire [7:0] out;
  wire [2:0] status;
  wire buffer_oe;
  wire [3:0] out_en;

  spi_mux U0 (
    .clk      (clk),
    .reset    (reset),
    .spi_nCS  (spi_nCS),
    .spi_sck  (spi_sck),
    .spi_mosi (spi_mosi),
    .spi_miso (spi_miso),
    .out      (out),
    .status   (status),
    .buffer_oe  (buffer_oe),
    .out_en   (out_en)
  );

  // initial state
  initial begin
    clk = 0;
    reset = 0;

    spi_nCS = 1;
    spi_sck = 0;
    spi_mosi = 0;

    $dumpfile("spi_mux.vcd");
    $dumpvars;

    $display("\t\ttime,\tclk,\treset,\tspi_nCS,\tspi_sck,\tspi_mosi\tout");
    $monitor("%d,\t%b,\t%b,\t%b,\t\t%b,\t\t%b,\t\t%d",$time, clk,reset,spi_nCS,spi_sck,spi_mosi,out);

    // assert reset
    #3 begin reset = 1; end

    // timings and shit
    #1 begin spi_nCS = 0; end
    #1 begin spi_mosi = 1; end
    #2 begin spi_mosi = 0; end
    #14 begin spi_nCS = 1; end


    #1 begin $finish; end
  end

  // overall kerjigger
  // always begin
  // end

  // actions
  always begin
    #1 begin clk = !clk; spi_sck = !spi_sck; end

    // #1 begin spi_nCS = 0; spi_sck = 0; spi_mosi = 1; end
    // #2 begin spi_nCS = 0; spi_sck = 1; spi_mosi = 1; end
    // #3 begin spi_nCS = 0; spi_sck = 0; spi_mosi = 0; end
    // #4 begin spi_nCS = 0; spi_sck = 1; spi_mosi = 0; end
    // #5 begin spi_nCS = 0; spi_sck = 0; spi_mosi = 1; end
    // #6 begin spi_nCS = 0; spi_sck = 1; spi_mosi = 1; end
    // #7 begin spi_nCS = 0; spi_sck = 0; spi_mosi = 0; end
    // #8 begin spi_nCS = 0; spi_sck = 1; spi_mosi = 0; end
    // #9 begin spi_nCS = 0; spi_sck = 0; spi_mosi = 1; end
    // #10 begin spi_nCS = 0; spi_sck = 1; spi_mosi = 1; end
    // #11 begin spi_nCS = 0; spi_sck = 0; spi_mosi = 0; end
    // #12 begin spi_nCS = 0; spi_sck = 1; spi_mosi = 0; end
    // #13 begin spi_nCS = 0; spi_sck = 0; spi_mosi = 1; end
    // #14 begin spi_nCS = 0; spi_sck = 1; spi_mosi = 1; end
    // #15 begin spi_nCS = 0; spi_sck = 0; spi_mosi = 0; end
    // #16 begin spi_nCS = 0; spi_sck = 1; spi_mosi = 0; end
    // #17 begin spi_nCS = 1; spi_sck = 0; spi_mosi = 0; end

    // #20 $finish;
  end

  // rest of testbench

endmodule
