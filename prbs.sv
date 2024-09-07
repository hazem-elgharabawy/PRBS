module PRBS (
    input bit CLK,
    input logic RSTn,
    input logic [7:0] n,
    input logic [31:0] in,
    output logic [7:0] out
);
    reg [15:0] LSFR;
    reg pattern_done;
    reg [7:0] inner_counter;
    reg [7:0] outer_counter;
    always @(posedge CLK or negedge RSTn ) begin
        if (!RSTn) begin
            out <= 0;
            LSFR <= in[15:0];
            pattern_done <= 1'b0;
            inner_counter <= 0;
            outer_counter <= 0;
        end
        else if (!pattern_done) begin
            case (inner_counter)
                0 : begin
                   out <= in[31:24];
                   inner_counter <= inner_counter +1;
                end
                1 : begin
                    out <= in[23:16];
                    inner_counter <= inner_counter +1;
                end 
                2 : begin
                    out <= in[15:8];
                    inner_counter <= inner_counter +1;
                end
                3 : begin
                   out <= in[7:0];
                   if (outer_counter == (n-1)) begin
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
            LSFR <= {LSFR[14:0],(LSFR[14]^LSFR[15])};
            out <= LSFR[7:0];   
        end
    end

    

endmodule