module control (
    input clk,Q0,Qm1,start,zero,input [15:0]dataM,dataQ,output reg addsub,rst,ldM,shift,ldQ,done,ldA, output reg [15:0] data_in
);
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011,S4 = 3'b100, S5 = 3'b101,S6 = 3'b110;
    reg [2:0]State,Next_State;
    integer count;
    
    always @(posedge clk) begin
        if(start) begin
            State <= S0;
            count <= 15;
            done <= 1'b0;
        end
        else begin
            State <= Next_State;
        end
    end

    always @(*) begin
        case(State)
        S0:begin
                Next_State <= S1;
            end
        S1: Next_State <= S2;
        S2: begin
            if({Q0,Qm1} == 2'b01) begin
                Next_State <= S3;
            end
            if({Q0,Qm1} == 2'b10) Next_State <= S4;
            if({Q0,Qm1} == 2'b11 || {Q0,Qm1} == 2'b00) Next_State <= S5;
        end
        S3: Next_State <= S5;
        S4: Next_State <= S5;
        S5: begin
            if({Q0,Qm1} == 2'b01 && zero == 0) begin
                Next_State <= S3;
            end
            if({Q0,Qm1} == 2'b10 && zero == 0) Next_State <= S4;
            if(zero == 1) Next_State <= S6;
        end
        S6: begin
            Next_State <= S6;
        end
        endcase
    end

    always @(State) begin
        case(State)
        S0: begin
            rst = 1'b1;
        end
        S1: begin
            rst = 1'b0;
            ldM = 1'b1;
            shift = 1'b0;
            data_in = dataM;
            ldQ = 1'b0;
        end
        S2: begin
            rst = 1'b0;
            ldM = 1'b0;
            ldQ = 1'b1;
            data_in = dataQ;
            shift = 1'b0;
        end
        S3: begin
            rst = 1'b0;
            ldQ = 1'b0;
            ldM = 1'b0;
            addsub = 1'b1;
            ldA = 1'b1;
            shift = 1'b0;
        end
        S4: begin
            rst = 1'b0;
            ldQ = 1'b0;
            addsub = 1'b0;
            ldA = 1'b1;
            shift = 1'b0;
            ldM=  1'b0;
        end
        S5: begin
            rst = 1'b0;
            ldA = 1'b0;
            shift = 1'b1;
            count = count - 1;
            ldM = 0;
            ldQ = 0;
        end
        S6: done = 1'b1;

    endcase
    end

endmodule