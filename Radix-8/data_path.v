module data_path (
    input [14:0]data_in,input rst,clk,shift,addsub,ldQ,ldM,ldA,input[1:0]Num, output [2:0]Q0,output zero,output reg Qm1
);
    reg [14:0]A,Q,M;
    integer count; 
    assign Q0 = Q[2:0];
    assign zero = ~|count;


    always @(posedge clk, posedge rst) begin
        if(rst) begin
            A <= 14'b0;
            Q <= 14'b0;
            M <= 14'b0;
            Qm1 <= 1'b0;
            count = 6;
        end
        else begin
            if(ldM) begin
                M <= data_in;
            end
            if(ldQ) Q = data_in;
            
            if(addsub == 1'b1 && ldA) begin
                if(Num == 2'b01) begin
                    A <= A + M;
                end
                if (Num == 2'b10) begin
                    A <= A + {M[13:0],1'b0};
                end
                if (Num == 2'b11) begin
                    A <= A + M + {M[13:0],1'b0};
                end
                if (Num == 2'b00) begin
                    A <= A + {M[12:0],2'b0};
                end
            end
            if(addsub == 1'b0 && ldA) begin
                if(Num == 2'b01) begin
                    A <= A - M;
                end
                if (Num == 2'b10) begin
                    A <= A - {M[13:0],1'b0};
                end
                if (Num == 2'b11) begin
                    A <= A - (M + {M[13:0],1'b0});
                end
                if (Num == 2'b00) begin
                    A <= A - {M[12:0],2'b0};
                end
            end
            if(shift && count != 0)begin 
                A <= {{3{A[14]}},A[14:3]};
                Q <= {A[2:0],Q[14:3]};
                Qm1 <= Q[2];  
                count <= count - 1;
        end
        end
    end
endmodule