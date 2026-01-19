module control_unit (
    input [6:0]instruction,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg MemToReg,
    output reg ALUSrc,
    output reg Branch,
    output reg [1:0] ALUOp
);
    always @(*) begin
        case (instruction)
            7'b0110011: begin // R-type
                RegWrite=1; MemRead=0; MemWrite=0;
                MemToReg=0; ALUSrc=0; Branch=0;
                ALUOp=2'b10;
            end
            7'b0000011: begin // LW
                RegWrite=1; MemRead=1; MemWrite=0;
                MemToReg=1; ALUSrc=1; Branch=0;
                ALUOp=2'b00;
            end
            7'b0100011: begin // SW
                RegWrite=0; MemRead=0; MemWrite=1;
                MemToReg=0; ALUSrc=1; Branch=0;
                ALUOp=2'b00;
            end
            7'b1100011: begin // BEQ
                RegWrite=0; MemRead=0; MemWrite=0;
                MemToReg=0; ALUSrc=0; Branch=1;
                ALUOp=2'b01;
            end
            default: begin
                RegWrite=0; MemRead=0; MemWrite=0;
                MemToReg=0; ALUSrc=0; Branch=0;
                ALUOp=2'b00;
            end
        endcase
    end
endmodule

