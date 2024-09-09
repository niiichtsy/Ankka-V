`include "risc_v_opcodes.sv"

module instruction_decode_unit (
    input logic [31:0] instruction_in,
    output logic [31:0] instruction_out,
    input aresetn
);


  always_comb begin
    if (!aresetn) begin
      instruction_out = 'h00;
    end else begin
      instruction_out = instruction_in;
    end
  end

endmodule
