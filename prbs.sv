module PRBS (
    input bit CLK,
    input logic RSTn,
    input logic [7:0] in,
    input logic [7:0] n,
    output logic [7:0] out
);
    reg [15:0] LSFR;
    reg start;
    reg [7:0] inner_counter;
    reg [7:0] outer_counter;
    always @(posedge CLK or negedge RSTn ) begin
        if (!RSTn) begin
            LSFR <= 8'h11;
            start <= 1'b0;
            inner_counter <= 0;
            outer_counter <= 0;
        end
        else if (!start) begin

        end
        else begin
            LSFR <= {LSFR,(LSFR[14]^LSFR[15])};
        end
    end

    

endmodule