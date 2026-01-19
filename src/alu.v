module alu (
    input [31:0] A, B,
    input [3:0] ALUCtrl,
    output reg [31:0] Result,
    output Zero
);
    always @(*) begin
        case (ALUCtrl)
            4'b0010: Result = A + B;
            4'b0110: Result = A - B;
            4'b0000: Result = A & B;
            4'b0001: Result = A | B;
            default: Result = 0;
        endcase
    end

    assign Zero = (Result == 0);
endmodule

