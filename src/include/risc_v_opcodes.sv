`ifndef _risc_v_opcodes_
`define _risc_v_opcodes_
/* verilog_format: off */
parameter LUI       = 7'b0110111;
parameter AUIPC     = 7'b0010111;
parameter JAL       = 7'b1101111;
parameter JALR      = 7'b1100111;
parameter BRANCH    = 7'b1100011;
parameter LOAD      = 7'b0000011;
parameter STORE     = 7'b0100011;
parameter ALU_IMM   = 7'b0010011;
parameter ALU_REG   = 7'b0110011;
parameter SYSTEM    = 7'b1110011;
/* verilog_format: on */
`endif
