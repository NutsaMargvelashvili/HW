module registerFile( 

  input clk, 

  input wenARd, 

  input [31:0] PCNxt, 

  input [3:0] Ymux, 

  input [31:0] RdData, 

  input [3:0] AddressRn, 

  input [3:0] AddressRs, 

  input [3:0] AddressRm, 

  output [31:0]Rm, 

  output [31:0]Rs, 

  output [31:0]Rn, 

  output [31:0]Rd, 

  output [31:0]PCout 

); 

  

  logic [31:0] dataMemory [15:0]; 

   

  assign Rs = dataMemory[AddressRs]; 

  assign Rd = dataMemory[Ymux]; 

  assign Rm = dataMemory[AddressRm]; 

  assign Rn = dataMemory[AddressRn]; 

  assign PCout = dataMemory[15]; 

 

   always @(posedge clk) begin 

     dataMemory[15] <= PCNxt; 

    if(wenARd)  

      dataMemory[Ymux] <= RdData; 

  end 

  

endmodule 
