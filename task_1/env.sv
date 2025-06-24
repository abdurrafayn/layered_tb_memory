timeunit 1ns;
timeprecision 1ns;

class environment;

    generator gen;
    driver driv;
    monitor mon;
    scoreboard scb;

    //Mailboxes
    mailbox gen2driver, gen2scb, mon2scb;

    //virtual interface
    virtual  mem_itf vif;

    event gen_ended;
    int count;
    //constructor

    function new(virtual mem_itf vif, int count);
    this.vif = vif;
    this.count = count;
    //creating instance of mailboxes
    gen2driver  = new();
    gen2scb     = new();
    mon2scb     = new();

    //creating object of generator, driver, monitor, scoreboard
    gen = new( gen2driver, gen2scb , count, gen_ended);
    driv = new(vif,gen2driver);
    mon = new(vif,mon2scb);
    scb = new(gen2scb, mon2scb);
    endfunction
    task test();

    fork
        gen.run();
        driv.run();
        mon.run();
        scb.run();
join_none

    endtask

    task post_test();
        @(gen_ended);
        wait(count == driv.drv_count);
        wait(count == scb.scb_count);

        // wait(driv.drv_count >= count);
        // wait(scb.scb_count >= count);

        $display("\n");
        $display("===========================================================================================");
        $display("TEST COMPLETED - RESULTS");
        $display("===========================================================================================");
        $display("Scoreboard Count: %0d | Scoreboard Errors: %0d", scb.scb_count, scb.error_count);

        if(scb.error_count) 
        $display("ERROR: please check your design");
        else
        $display("Task Completed");
    endtask

    task run();
        test();
        post_test();
    $finish;
    endtask

endclass //environment