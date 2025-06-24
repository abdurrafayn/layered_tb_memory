timeunit 1ns;
timeprecision 1ns;

class generator;

        transaction trans;
        mailbox gen2driver;
        mailbox gen2score;
        int repeat_count;
        event ended;
    //trans = new();
        bit ok;
        int gen_count;


    function new(mailbox gen2driver, mailbox gen2score, int repeat_count, event ended);
        this.gen2driver = gen2driver;
        this.gen2score = gen2score;
        this.repeat_count = repeat_count;
        this.ended= ended;
        //gen2driver = new();
        //gen2score = new();
    endfunction


task run();
    repeat(repeat_count) begin
        trans = new();
        ok = trans.randomize();

        if(!ok)
            $display("Unable to randomize the transaction");
        
        gen2driver.put(trans);
        gen2score.put(trans);
        $display("---------------------------------------------------");
        $display("Transaction # %0d Generated", gen_count + 1);
        $display("---------------------------------------------------");
        $display("Read: %b", trans.read);
        $display("Write: %0b", trans.write);
        $display("Address: %0d", trans.addr);
        $display("Data IN: %0d", trans.data_in);
        $display("Data OUT: %0d", trans.data_out);
        gen_count++;
        -> ended;
    end
endtask

endclass //transaction


