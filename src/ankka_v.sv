module ankka_v (
    input [31:0] instruction_in,
    input read,
    input clk,
    input resetn
);

  wire [31:0] instruction_s;
  wire [31:0] alu_out_s;
  wire done_s;

  instruction_fetch_unit ifu (
      .instruction_out(instruction_s),
      .done(done_s),
      .instruction_in(instruction_in),
      .read(read),
      .resetn(resetn),
      .clk(clk)
  );

  alu alu_core (
      .alu_out(alu_out_s),
      .instruction(instruction_s),
      .execute(done_s),
      .resetn(resetn),
      .clk(clk)
  );

endmodule

