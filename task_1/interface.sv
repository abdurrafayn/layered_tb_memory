timeunit 1ns;
timeprecision 1ns;

interface mem_itf(input logic clk);
    bit read;
    bit write;
    logic [4:0] addr;
    logic [7:0] data_in;
    logic [7:0] data_out;
endinterface: mem_itf