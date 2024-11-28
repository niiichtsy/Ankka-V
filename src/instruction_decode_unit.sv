`include "risc_v_opcodes.sv"

module instruction_decode_unit (
    input logic [31:0] instruction,
    input aresetn
);

  // Wires indicating decoded instructions
  wire        instr_LUI = (instruction[6:0] == LUI);
  wire        instr_AUIPC = (instruction[6:0] == AUIPC);
  wire        instr_JAL = (instruction[6:0] == JAL);
  wire        instr_JALR = (instruction[6:0] == JALR);
  wire        instr_BRANCH = (instruction[6:0] == BRANCH);
  wire        instr_LOAD = (instruction[6:0] == LOAD);
  wire        instr_STORE = (instruction[6:0] == STORE);
  wire        instr_ALU_IMM = (instruction[6:0] == ALU_IMM);
  wire        instr_ALU_REG = (instruction[6:0] == ALU_REG);
  wire        instr_SYSTEM = (instruction[6:0] == SYSTEM);

  // Wires indicating operands
  wire [ 4:0] rs1                                                                                           [19:15];
  wire [ 4:0] rs2                                                                                           [24:20];
  wire [ 4:0] rd                                                                                            [ 11:7];

  wire [ 2:0] funct3 = instruction[14:12];
  wire [ 6:0] funct7 = instruction[31:25];

  // Immediates
  wire [31:0] Uimm = {instruction[31], instruction[30:12], {12{1'b0}}};
  wire [31:0] Iimm = {{21{instruction[31]}}, instruction[30:20]};
  wire [31:0] Simm = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]};
  wire [31:0] Bimm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
  wire [31:0] Jimm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};

  always_comb begin
    if (!aresetn) begin
    end else begin
    end
  end

endmodule
