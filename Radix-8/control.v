module control (
    input clk,input [2:0]Q0,input Qm1,start,zero,input [14:0]dataM,dataQ,output reg addsub,rst,ldM,shift,ldQ,done,ldA, output reg [14:0] data_in, output reg [1:0]Num
);
    parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011,S4 = 4'b0100, S5 = 4'b0101,S6 = 4'b0110,S7 = 4'b0111,S8 = 4'b1000,S9 = 4'b1001,S10 = 4'b1010,S11 = 4'b1011,S12 = 4'b1100;
    reg [3:0]State,Next_State;
    
    always @(posedge clk) begin
        if(start) begin
            State <= S0;
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
            if({Q0,Qm1} == 4'b0001 || {Q0,Qm1} == 4'b0010 ) begin
                Next_State <= S3;
            end
            if({Q0,Qm1} == 4'b0011 || {Q0,Qm1} == 4'b0100) Next_State <= S4;
            if({Q0,Qm1} == 4'b0101 || {Q0,Qm1} == 4'b0110) Next_State <= S5;
            if({Q0,Qm1} == 4'b0111) Next_State <= S6;
            if({Q0,Qm1} == 4'b1000) Next_State <= S7;
            if({Q0,Qm1} == 4'b1001 || {Q0,Qm1} == 4'b1010) Next_State <= S8;
            if({Q0,Qm1} == 4'b1011 || {Q0,Qm1} == 4'b1100) Next_State <= S9;
            if({Q0,Qm1} == 4'b1101 || {Q0,Qm1} == 4'b1110) Next_State <= S10;
            if({Q0,Qm1} == 4'b0000 || {Q0,Qm1} == 4'b1111) Next_State <= S11;
        end
        S3: Next_State <= S11;
        S4: Next_State <= S11;
        S5: Next_State <= S11;
        S6: Next_State <= S11;
        S7: Next_State <= S11;
        S8: Next_State <= S11;
        S9: Next_State <= S11;
        S10: Next_State <= S11;
        S11: begin
            if({Q0,Qm1} == 4'b0001 || {Q0,Qm1} == 4'b0010 ) begin
                Next_State <= S3;
            end
            if(({Q0,Qm1} == 4'b0011 || {Q0,Qm1} == 4'b0100) && zero == 0) Next_State <= S4;
            if({Q0,Qm1} == 4'b0101 || {Q0,Qm1} == 4'b0110 && zero == 0) Next_State <= S5;
            if({Q0,Qm1} == 4'b0111 && zero == 0) Next_State <= S6;
            if({Q0,Qm1} == 4'b1000 && zero == 0) Next_State <= S7;
            if({Q0,Qm1} == 4'b1001 || {Q0,Qm1} == 4'b1010 && zero == 0) Next_State <= S8;
            if({Q0,Qm1} == 4'b1011 || {Q0,Qm1} == 4'b1100 && zero == 0) Next_State <= S9;
            if({Q0,Qm1} == 4'b1101 || {Q0,Qm1} == 4'b1110 && zero == 0) Next_State <= S10;
            if({Q0,Qm1} == 4'b0000 || {Q0,Qm1} == 4'b1111 && zero == 0) Next_State <= S11;
            if(zero == 1) Next_State <= S12;
        end
        S12: begin
            Next_State <= S12;
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
            Num = 2'b01;
            addsub = 1'b1;
            ldA = 1'b1;
            shift = 1'b0;
        end
        S4: begin
            rst = 1'b0;
            ldQ = 1'b0;
            ldM = 1'b0;
            Num = 2'b10;
            addsub = 1'b1;
            ldA = 1'b1;
            shift = 1'b0;
        end
        S5: begin
            rst = 1'b0;
            ldQ = 1'b0;
            ldM = 1'b0;
            Num = 2'b11;
            addsub = 1'b1;
            ldA = 1'b1;
            shift = 1'b0;
        end
        S6: begin
            rst = 1'b0;
            ldQ = 1'b0;
            ldM = 1'b0;
            Num = 2'b00;
            addsub = 1'b1;
            ldA = 1'b1;
            shift = 1'b0;
        end
        S7: begin
            rst = 1'b0;
            ldQ = 1'b0;
            addsub = 1'b0;
            ldA = 1'b1;
            Num = 2'b00;
            shift = 1'b0;
            ldM=  1'b0;
        end
        S8: begin
            rst = 1'b0;
            ldQ = 1'b0;
            addsub = 1'b0;
            ldA = 1'b1;
            Num = 2'b11;
            shift = 1'b0;
            ldM=  1'b0;
        end
        S9: begin
            rst = 1'b0;
            ldQ = 1'b0;
            addsub = 1'b0;
            ldA = 1'b1;
            Num = 2'b10;
            shift = 1'b0;
            ldM=  1'b0;
        end
        S10: begin
            rst = 1'b0;
            ldQ = 1'b0;
            addsub = 1'b0;
            ldA = 1'b1;
            Num = 2'b01;
            shift = 1'b0;
            ldM=  1'b0;
        end
        S11: begin
            rst = 1'b0;
            ldA = 1'b0;
            shift = 1'b1;
            ldM = 0;
            ldQ = 0;
        end
        S12: begin
            done = 1'b1;
            shift = 1'b0;
        end 

    endcase
    end

endmodule