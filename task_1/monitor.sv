timeunit 1ns;
timeprecision 1ns;

class monitor;

    virtual  mem_itf vif;
    mailbox mon2scb;
    transaction trans;

    function new(virtual mem_itf vif, mailbox mon2scb);
        this.vif = vif;
        this.mon2scb = mon2scb;
    endfunction
    
    task run();
        forever begin
            @(posedge vif.clk);
            #1ns;
                trans = new();
                trans.read = vif.read;
                trans.write = vif.write;
                trans.addr = vif.addr;
                trans.data_in = vif.data_in;
                trans.data_out = vif.data_out;
                mon2scb.put(trans);
                if (vif.read)
                    begin
                        $display("--------------------------------");
                        $display("Monitor");
                        $display("--------------------------------");
                        $display("Addr: %0d | Data_Out: %0d", trans.addr, trans.data_out);
                    end
            end
    endtask
endclass //Monitor