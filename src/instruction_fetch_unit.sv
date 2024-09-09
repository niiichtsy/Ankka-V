module instruction_fetch_unit (
    output logic [31:0] program_counter,
    output logic [31:0] instruction_out,
    output logic done,
    input [31:0] instruction_in,
    input read,
    input clk,
    input resetn
);

  // Clock the incoming instruction in
  always_ff @(posedge clk) begin
    if (!resetn) begin
      instruction_out <= 'h00;
      program_counter <= 'h00;
      done <= 1'b0;
    end else begin
      if (read) begin
        instruction_out <= instruction_in;
        program_counter <= program_counter + 1'b1;
        done <= 1'b1;
      end else begin
        instruction_out <= 'h00;
        program_counter <= program_counter;
        done <= 1'b0;
      end
    end
  end

endmodule
