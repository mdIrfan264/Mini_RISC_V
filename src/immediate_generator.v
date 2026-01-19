module immediate_generator(
    input [31:0] instruction,
    output reg [31:0] imm
);
    always @(*) begin
        case (instruction[6:0])
            7'b0000011: // LW
                imm = {{20{instruction[31]}}, instruction[31:20]};
            7'b0100011: // SW
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            7'b1100011: // BEQ
                imm = {{19{instruction[31]}}, instruction[31], instruction[7],
                       instruction[30:25], instruction[11:8], 1'b0};
            default:
                imm = 32'b0;
        endcase
    end
endmodule
