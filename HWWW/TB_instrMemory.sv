module TB_instrMemory(); 

  logic [31:0]pcOutput = 8; 

  logic [31:0]Output; 

   

  instructionMemory instructionMemory_instance(pcOutput, Output); 

  initial begin 

    $dumpfile("dump.vcd");  

    $dumpvars(1); 

    #10 

    $display ("The input ---> %d", pcOutput); 

    #10 

    $display("The output --- > %d", Output); 

  end 

endmodule 