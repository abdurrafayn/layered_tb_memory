timeunit 1ns;
timeprecision 1ns;

class driver;

transaction trans;
mailbox gen2driver;
virtual  mem_itf vif;
int drv_count = 0;


function new(virtual mem_itf vif, mailbox gen2driver);
    this.vif = vif;
    this.gen2driver = gen2driver;
    //gen2driver = new();
endfunction

task run();
    forever 
    begin
        @(negedge vif.clk);
        //trans = new();
        gen2driver.get(trans);
        // trans.display("THis is Driver");
            if(trans.write) begin
                vif.read <= 1'b0;
                vif.write <= 1;
                vif.addr <= trans.addr;
                vif.data_in <= trans.data_in;
                $display("\n");
                $display("--------------------------------------");
                $display("Driver -- Write Transaction");
                $display("--------------------------------------");
                $display("Addr: %0d | Data_In: %0d | Data_Out: %0d", trans.addr, trans.data_in, trans.data_out);
                $display("\n");
            end
             else begin
                vif.read <= 1;
                vif.write <= 0;
                vif.addr <= trans.addr;
                $display("\n");
                $display("--------------------------------------");
                $display("Driver -- Read Transaction");
                $display("--------------------------------------");
                $display("Addr: %0d", trans.addr);
                $display("\n");
            end
        drv_count++;
    end
endtask
endclass //transaction

