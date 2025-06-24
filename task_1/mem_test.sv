//`include "transaction.sv"


module mem_test ( busI newBus);

// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;
transaction t1;
int error_status;
int test;

bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

//top t(.clk(clk), .read(read), .write(write), .data_in(data_in), .data_out(data_out), .addr(addr));


//covergroup cg1 @(posedge newBus.clk);

// covergroup cg;
//     c1: coverpoint newBus.addr;
    
    
//     c2: coverpoint newBus.data_in{
//         bins upper = {[8'h41:8'h5a]};
//         bins lower = {[8'h61:8'h7a]};
//         bins remaining = default;
//     }

//     c3: coverpoint newBus.data_out{
//         bins upper = {[8'h41:8'h5a]};
//         bins lower = {[8'h61:8'h7a]};
//         bins remaining = default;
//     }

// endgroup

// cg cover_inst = new();

//cg1 cover_inst = new();

// Monitor Results
initial begin
    $timeformat ( -9, 0, " ns", 9 );
    $monitor ("time=%t read=%h write=%h data_in=%0h data_out=%0h address=%b",
              $time, newBus.read, newBus.write, newBus.data_in, newBus.data_out, newBus.addr);
    #40000ns $display("MEMORY TEST TIMEOUT");
    $finish;
end


//----------------------------------------------------------------------------------------------------------//



initial begin: memtest

    t1 =new(1,2,3);
    // t1.constraint_mode(0);
    // t1.conditional.constraint_mode(1);
    error_status = 0;
    $display("Clear Memory Test");

    

    printstatus(error_status);
    // cover_inst.start();
    Random_test();
        //RAW();
        printstatus(error_status);
        //corner_cases();
        //printstatus(error_status);
     //end
    // cover_inst.stop();
    $finish;
end


function void printstatus(input int status);
    if (status == 0)
        $display("TEST PASSED");
    else
        $display("TEST FAILED with %0d errors", status);
endfunction

task RAW ();
 error_status = 0;
@(negedge newBus.clk);

for (int i = 0; i < 32; i++) begin
        newBus.write_mem(i, i);
        newBus.read_mem(i, rdata);

        if (rdata !== i) begin
            error_status++;
            $display("Error at Addr %0d: Expected 0x00, Got 0x%0h", i, rdata);
        end
end
endtask

// task corner_cases ();
// logic [7:0] random_data;
// //for (int i = 0; i < 32; i++) begin
//         int error_status = 0;
//         repeat(100) begin
//         random_data = $urandom_range(0,255);
//         newBus.write_mem('0, random_data);
//         newBus.read_mem(0, rdata);

//         if (rdata !== random_data) begin
//             error_status++;
//             $display("Error at Addr zero: Expected 0x00, Got 0x%0h", rdata);
//         end
// //end
// //for (int i = 0; i < 32; i++) begin
//         //int error_status = 0;
//         newBus.write_mem(5'b11111, random_data);
//         newBus.read_mem(5'b11111, rdata);

//         if (rdata !== random_data) begin
//             error_status++;
//             $display("Error at Addr thirty one: Expected 0x00, Got 0x%0h", rdata);
//         end
//         end
// //end

// endtask

task Random_test();


logic [7:0] mem_temp [0:31];
logic [7:0] data_temp;
logic [4:0] addr_rand;

int test;


for (int i = 0; i < 32; i++)
begin
    
    test = t1.randomize();

   // test = randomize(data_temp) with {data_temp inside { [8'h20:8'h7f]};};
  // test = randomize(data_temp) with {data_temp dist { [8'h41:8'h5a]:=8 , [8'h61:8'h7a]:=2};};
   // if(!test) $display("randomization failed");
        t1.cg.sample();
        mem_temp[t1.address] = t1.data;
        newBus.write_mem(t1.address, t1.data);
end

$display("Comparing data from memory and temporary data memory");

for (int i = 0; i<32 ; i++ ) begin
    newBus.read_mem(i, rdata);
           //t1.cg.sample();
    if(mem_temp[i] != rdata)
        begin
            error_status++;
            $display("Error");
        end
end

endtask
endmodule