`include "risc_v_opcodes.sv"

module alu (
    output logic [31:0] alu_out,
    input [31:0] instruction,
    input execute,
    input resetn,
    input clk
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
  wire [ 4:0] rs1_id = instruction[19:15];
  wire [ 4:0] rs2_id = instruction[24:20];
  wire [ 4:0] rd_id = instruction[11:7];

  // Wires indicating operations
  wire [ 2:0] funct3 = instruction[14:12];
  wire [ 6:0] funct7 = instruction[31:25];

  // Immediates
  wire [31:0] Uimm = {instruction[31], instruction[30:12], {12{1'b0}}};
  wire [31:0] Iimm = {{21{instruction[31]}}, instruction[30:20]};
  wire [31:0] Simm = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]};
  wire [31:0] Bimm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
  wire [31:0] Jimm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};

  // Register bank
  reg  [31:0] register_bank                                                                                 [0:31];
  reg  [31:0] rs1;
  reg  [31:0] rs2;
  reg  [31:0] rd;

  wire [31:0] write_back_data;  // data to be written to rd
  wire        write_back_en;  // asserted if data should be written to rd


  // instruction decode unit 
  always_ff @(posedge clk) begin
    if (!resetn) begin
      foreach (register_bank[i]) begin
        register_bank[i] <= 'h00;
      end
    end else begin
      rs1 <= register_bank[rs1_id];
      rs2 <= register_bank[rs2_id];
      rd  <= register_bank[rd_id];
      if (execute) begin
        if (rd_id != 0) begin
          register_bank[rd_id] <= write_back_data;
        end
      end
    end
  end

  // To ALU
  wire [31:0] alu_in1 = rs1;
  wire [31:0] alu_in2 = instr_ALU_REG ? rs2 : Iimm;

  // Help wires
  wire [ 4:0] shamt = instr_ALU_REG ? rs2[4:0] : instruction[24:20];  // shift amount

  // Register write back
  assign write_back_data = alu_out;
  assign write_back_en   = instr_ALU_REG || instr_ALU_IMM;

  // ALU
  always_comb begin
    case (funct3)
      3'b000: alu_out = (funct7[5] & instruction[5]) ? (alu_in1 - alu_in2) : (alu_in1 + alu_in2);
      3'b001: alu_out = alu_in1 << shamt;
      3'b010: alu_out = ($signed(alu_in1) < $signed(alu_in2));
      3'b011: alu_out = (alu_in1 < alu_in2);
      3'b100: alu_out = (alu_in1 ^ alu_in2);
      3'b101: alu_out = funct7[5] ? ($signed(alu_in1) >>> shamt) : (alu_in1 >> shamt);
      3'b110: alu_out = (alu_in1 | alu_in2);
      3'b111: alu_out = (alu_in1 & alu_in2);
    endcase
  end

  initial begin
    $dumpvars(0, alu);
    $dumpfile("dump.vcd");
  end

endmodule
