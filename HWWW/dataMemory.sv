module dataMemory(
  input [31:0] rdBaseOffset,
  input [31:0] memAddress,
  input wen,
  input clk,
  output [31:0] dataFromMem
);

  logic [31:0] memoryData [15:0];
  assign dataFromMem = memoryData[memAddress];

always @(posedge clk) begin
  if(wen) memoryData[memAddress] <= rdBaseOffset;
end

endmodule
