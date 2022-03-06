module testbench (
);
    wire Q0,Qm1;
    reg clk,start;
    reg [15:0]dataM,dataQ;
    wire addsub,rst,ldM,shift,ldQ,done,ldA;
    wire [15:0]data_in;
    control C(clk,Q0,Qm1,start,zero,dataM,dataQ,addsub,rst,ldM,shift,ldQ,done,ldA,data_in);
    data_path D(data_in,rst,clk,shift,addsub,ldQ,ldM,ldA,Q0,zero,Qm1);
    reg [2*8:0]S;

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    always @(*) begin
        case(C.State)
            3'b000: S = "S0";
            3'b001: S = "S1";
            3'b010: S = "S2";
            3'b011: S = "S3";
            3'b100: S = "S4";
            3'b101: S = "S5";
            3'b110: S = "S6";
        endcase
    end

    initial begin
        @(negedge clk) start = 1'b1;
        @(negedge clk) start = 1'b0;
        dataM = 4;
        dataQ = 8;
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
        $display("count = %0d",C.count);
        $display("Shift = %b",shift);

        
    end
endmodule