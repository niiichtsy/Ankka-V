module instruction_fetch_unit (
    input [31:0] instruction,
    input clk,
    input reset_n
);

  reg [31:0] instr_i;

  // Decode instructions on separate wires
  wire LUI = (instr_i[6:0] == 0110111);

  // Clock the incoming instruction in
  always @(posedge clk) begin
    if (!reset_n) begin
      instr_i <= 'h00;
    end else begin
      instr_i <= instruction;
    end
  end

endmodule
