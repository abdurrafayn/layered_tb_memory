module top;
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: logic and bit data types
bit         clk=0;
busI newBus(clk);

// wire       read;
// wire       write;
// wire [4:0] addr;

// wire [7:0] data_out;      // data_from_mem
// wire [7:0] data_in;       // data_to_mem

// SYSTEMVERILOG:: implicit .* port connections
mem_test test (newBus);

// SYSTEMVERILOG:: implicit .name port connections
mem memory (newBus
//.read(read), .write(write), .addr(addr),
  //            .data_in(data_in), .data_out(data_out)
            );

always #5 clk = ~clk;
endmodule
