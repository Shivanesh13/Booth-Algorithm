module testbench (
);
    wire Qm1;
    wire [2:0]Q0;
    reg clk,start;
    reg [14:0]dataM,dataQ;
    wire addsub,rst,ldM,shift,ldQ,done,ldA;
    wire [14:0]data_in;
    wire [1:0] Num;
    control C(clk,Q0,Qm1,start,zero,dataM,dataQ,addsub,rst,ldM,shift,ldQ,done,ldA,data_in,Num);
    data_path D(data_in,rst,clk,shift,addsub,ldQ,ldM,ldA,Num,Q0,zero,Qm1);
    reg [3*8:0]S;

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    always @(*) begin
        case(C.State)
            4'b0000: S = "S0";
            4'b0001: S = "S1";
            4'b0010: S = "S2";
            4'b0011: S = "S3";
            4'b0100: S = "S4";
            4'b0101: S = "S5";
            4'b0110: S = "S6";
            4'b0111: S = "S7";
            4'b1000: S = "S8";
            4'b1001: S = "S9";
            4'b1010: S = "S10";
            4'b1011: S = "S11";
            4'b1100: S = "S12";
        endcase
    end

    initial begin
        @(negedge clk) start = 1'b1;
        @(negedge clk) start = 1'b0;
        dataM = 4;
        dataQ = 5;
        while (done != 1) begin
            #10;
        end
        $finish;
    end


    always @(D.Q) begin
        #0;
        $display("State : %s",S);
        $display("Output = %b    %b", D.A, D.Q );
        $display("%b",{D.Q0,D.Qm1});
        $display("DONE = %b",done);
        $display("ZERO = %b",D.zero);
        $display("count = %0d",D.count);
        $display("Shift = %b",shift);

        
    end
endmodule