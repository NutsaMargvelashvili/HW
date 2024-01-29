module instructionMemory( 

   input [31:0] PCOut, 

   output [31:0] out 

); 

  

  logic [31:0] dataMemory [15:0]; 

  assign dataMemory[8] = 30; 

  assign out = dataMemory[PCOut]; 

  

endmodule 