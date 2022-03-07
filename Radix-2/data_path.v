module data_path (
    input [15:0]data_in,input rst,clk,shift,addsub,ldQ,ldM,ldA,output Q0,zero,output reg Qm1
);
    reg [15:0]A,Q,M;
    integer count; 

    assign Q0 = Q[0];
    assign zero = ~|count;


    always @(posedge clk, posedge rst) begin
        if(rst) begin
            A <= 15'b0;
            Q <= 15'b0;
            M <= 15'b0;
            Qm1 <= 1'b0;
            count = 16;
        end
        else begin
            if(ldM) begin
                M <= data_in;
            end
            if(ldQ) Q = data_in;
            if(addsub == 1'b1 && ldA) begin
                A <= A + M;
            end
            if(addsub == 1'b0 && ldA) begin
                A <= A - M;
            end
            if(shift)begin 
                A <= {A[15],A[15:1]};
                Q <= {A[0],Q[15:1]};
                Qm1 <= Q[0];  
                count <= count - 1;
        end
        end
    end
endmodule