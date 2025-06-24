interface busI(input bit clk);

timeunit 1ns;
timeprecision 100ps;


  logic read, write;
  logic [4:0] addr;
  logic [7:0] data_in;
  logic [7:0] data_out;

    task write_mem (input [4:0] address, input [7:0] data_input
    //input bit debug = 0
);
    @(negedge clk);
    addr     = address;
    data_in  = data_input;
    write    = 1;
    read     = 0;
    @(posedge clk); // wait 1 more cycle for proper write
    #1
    write    = 0;
    //if (debug) $display("WRITE: Addr = %0d, Data = 0x%0h", address, data_input);
endtask
  
  task read_mem (input  [4:0] address, output [7:0] data_output
    //input  bit debug = 0
);
    @(negedge clk);
    addr   = address;
    write  = 0;
    read   = 1;
    @(posedge clk);  // wait for output to stabilize
    #1;            // small delay to allow data_out to propagate
    data_output = data_out;
    read = 0;
    //if (debug) 
	//$display("READ: Addr = %0d, Data = 0x%0h", address, data_output);
endtask

  modport master ( input read,write,addr,data_in, clk, output data_out );
  modport slave (output read, write, addr, data_in, input data_out, clk, import write_mem, read_mem);

endinterface : busI
