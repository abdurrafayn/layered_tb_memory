timeunit 1ns;
timeprecision 1ns;

class transaction;

  rand bit read, write;
  rand logic [4:0] addr;
  rand logic [7:0] data_in;
  logic [7:0] data_out;

constraint readwrite {  
                        read  == 1  -> write == 0;
                        read  == 0  -> write == 1;
                        write == 1  -> read  == 0;
                        write == 0  -> read  == 1;
                     }

  // Constructor with input arguments
function new();
    read    = 0;
    write   = 1;
    addr    = 1;
    data_in = 2;
    data_out = 0;

    // $display("read = %0b, write = %0b, address = %0d, data_input = %0d, data_output = %0d",
    //           read, write, addr, data_in, data_out);
endfunction

function void display();
 $display("=========== Transaction=============");
 $display("Read: %0b", read);
 $display("Write: %0b", write);
 $display("Address: %0d", addr);
 $display("Data IN: %0d", data_in);
$display("Data OUT: %0d", data_out);
endfunction

endclass: transaction
