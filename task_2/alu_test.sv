// package with opcode_t declaration
//import typedefs::*;

module alu_test;
// SystemVerilog: time unit and time precision specification
timeunit 1ns;
timeprecision 100ps;

// SystemVerilog: logic and enumeration and user-defined data types
logic  [7:0] accum, data, out;
logic  zero;

opcode_t       opcode  = HLT;

// ---- clock generator code begin------
`define PERIOD 10
logic clk = 1'b1;

always
    #(`PERIOD/2)clk = ~clk;

// ---- clock generator code end------

alu      alu1  (.out(out), .zero(zero), .clk(clk), .accum(accum), .data(data), .opcode(opcode));


covergroup cvg@(posedge clk);
op: coverpoint opcode;
acc: coverpoint accum {
        bins upper = {[128:$]};
        bins lower = {[0:127]};
    }
data_new: coverpoint data {
        bins upper = {[128:$]};
        bins lower = {[0:127]};
    } 
// accxdata: cross opcode,accum,data {

//cross op x acc x data
op_accum: cross op,acc,data_new {
ignore_bins x3 = binsof(op) intersect {HLT,SKZ,STO,JMP} && (binsof(data_new) intersect {[0:$]} || binsof(acc) intersect {[0:$]});
}

//ignore_bins x1 = binsof(op) intersect {LDA} && binsof(acc) intersect {[0:$]}; // if opcode is LDA, ignore all values of accum
//ignore_bins x2 = binsof(op) intersect {HLT,SKZ,STO,JMP} && binsof(data_new) intersect {[0:$]};
// //cross op x data
// op_data: cross op,data_new{
// ignore_bins x2 = binsof(op) intersect {HLT,SKZ,STO,JMP} && binsof(data_new) intersect {[0:$]}; // if opcode is HLT,SKZ,ETC , ignore all values of accum
// }

// //cross op x data x accum
// op_data_accum: cross op,acc,data_new{
// ignore_bins x3 = binsof(op) intersect {HLT,SKZ,STO,JMP} && binsof(data_new) intersect {[0:$]} || binsof(acc) intersect {[0:$]}; 
// }

//ignore_bins x1 = binsof(opcode) intersect {LDA} && binsof(accum) intersect {[0:$]}; // if opcode is LDA, ignore all values of accum


// ignore_bins x1 = binsof(opcode) intersect {[HLT:SKZ], [LDA:JMP]};
// ignore_bins x2 = binsof(opcode) intersect {[]}
//}

endgroup
cvg cov;

  // Verify Response
  task checkit (input [8:0] expects ) ;
    begin
      $display ( "%t opcode=%s data=%h accum=%h | zero=%b out=%h",
	        $time, opcode.name(), data, accum, zero, out);
      if ({zero, out} !== expects )
        begin
          $display ( "zero:%b  out:%b  s/b:%b_%b", zero, out,
                      expects[8], expects[7:0] );
          $display ( "ALU TEST FAILED" );
          $finish;
        end
    end
  endtask

  // Applying Directed Stimulus
  initial
    begin
      cov = new();
      @(posedge clk)
      { opcode, data, accum } = 19'h0_37_DA; @(posedge clk) checkit('h0_da);
      { opcode, data, accum } = 19'h1_37_DA; @(posedge clk) checkit('h0_da);
      { opcode, data, accum } = 19'h2_37_DA; @(posedge clk) checkit('h0_11);
      { opcode, data, accum } = 19'h3_37_DA; @(posedge clk) checkit('h0_12);
      { opcode, data, accum } = 19'h4_37_DA; @(posedge clk) checkit('h0_ed);
      { opcode, data, accum } = 19'h5_37_DA; @(posedge clk) checkit('h0_37);
      { opcode, data, accum } = 19'h6_37_DA; @(posedge clk) checkit('h0_da);
      { opcode, data, accum } = 19'h7_37_00; @(posedge clk) checkit('h1_00);
      { opcode, data, accum } = 19'h2_07_12; @(posedge clk) checkit('h0_19);
      { opcode, data, accum } = 19'h3_1F_35; @(posedge clk) checkit('h0_15);
      { opcode, data, accum } = 19'h4_1E_1D; @(posedge clk) checkit('h0_03);
      { opcode, data, accum } = 19'h5_72_00; @(posedge clk) checkit('h1_72);
      { opcode, data, accum } = 19'h6_00_10; @(posedge clk) checkit('h0_10);
      $display ( "ALU TEST PASSED" );
      $finish;
    end

  initial
    begin
      $timeformat ( -9, 1, " ns", 9 );
      // SystemVerilog: enhanced literal notation
      #2000ns 
         $display ( "ALU TEST TIMEOUT" );
      $finish;
    end
endmodule
