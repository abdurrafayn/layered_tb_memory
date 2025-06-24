timeunit 1ns;
timeprecision 1ns;

class scoreboard;

  int error_count = 0;
  int scb_count = 0;

  mailbox gen2score, mon2score;

  int array[int]; // associative array modeling memory

  function new(mailbox gen2score, mailbox mon2score);
    this.gen2score = gen2score;
    this.mon2score = mon2score;
  endfunction

task run();
  transaction trans_gen;
  transaction trans_mon;

  forever
    begin
      gen2score.get(trans_gen);
      mon2score.get(trans_mon);
      
      if (trans_gen.write)
        begin
          array[trans_gen.addr] = trans_gen.data_in;
          $display("*Scoreboard*: Wrote to Golden Model -  Addr %0d Data %0d", trans_gen.addr, trans_gen.data_in);
        end

      if (trans_mon.read && array.exists(trans_mon.addr))
        begin
        if (array[trans_mon.addr] != trans_mon.data_out) 
          begin
            $display("---ERRORR: Data mismatch at addr %0d. Expected %0d, got %0d", 
            trans_mon.addr, array[trans_mon.addr], trans_mon.data_out);
            error_count++;
          end 
        else
          begin
            $display("---Scoreboard: Data matched at addr %0d", trans_mon.addr);
          end
        end

      scb_count++;
    end

endtask

endclass
