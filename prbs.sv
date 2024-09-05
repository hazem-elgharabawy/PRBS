module PRBS (
    input bit CLK,
    input logic RSTn,
    input logic [7:0] in,
    input logic [7:0] n,
    input logic [31:0] pattern,
    output logic [7:0] out
);
    reg [15:0] LSFR;
    reg pattern_done;
    reg [7:0] inner_counter;
    reg [7:0] outer_counter;
    always @(posedge CLK or negedge RSTn ) begin
        if (!RSTn) begin
            LSFR <= 8'h11;
            pattern_done <= 1'b0;
            inner_counter <= 0;
            outer_counter <= 0;
        end
        else if (!pattern_done) begin
            case (inner_counter)
                0 : begin
                   out <= pattern[7:0];
                   inner_counter <= inner_counter +1;
                end
                1 : begin
                    out <= pattern[15:8];
                    inner_counter <= inner_counter +1;
                end 
                2 : begin
                    out <= pattern[23:16];
                    inner_counter <= inner_counter +1;
                end
                3 : begin
                   out <= pattern[31:24];
                   if (outer_counter==n) begin
                        outer_counter <= 0;
                        inner_counter <= 0;
                        pattern_done <= 1'b1;
                   end
                   else begin
                        outer_counter <= outer_counter +1;
                        inner_counter <= 0; 
                   end 
                end
                default: begin
                    out <= 8'h00;
                    inner_counter <= 0;
                    outer_counter <= 0;
                    pattern_done <= 1'b0;
                end 
            endcase
        end
        else begin
            LSFR <= {LSFR,(LSFR[14]^LSFR[15])};
            out <= LSFR[7:0];   
        end
    end

    

endmodule