module alu_control (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct730,
    output reg [3:0] ALUCtrl
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUCtrl = 4'b0010; // ADD
            2'b01: ALUCtrl = 4'b0110; // SUB
            2'b10: begin
                case (funct3)
                    3'b000: ALUCtrl = funct730 ? 4'b0110 : 4'b0010;
                    3'b111: ALUCtrl = 4'b0000; // AND
                    3'b110: ALUCtrl = 4'b0001; // OR
                    default: ALUCtrl = 4'b0010;
                endcase
            end
            default: ALUCtrl = 4'b0010;
        endcase
    end
endmodule
