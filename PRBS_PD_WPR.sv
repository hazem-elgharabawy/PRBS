module PRBS_PD_WPR #(
    parameter PATTERN = 32'hAABBCCDD
) (
    input bit CLK,
    input logic RSTn,
    input logic [31:0] in,
    input logic [7:0] n,
    output logic [7:0] out,
    output logic pattern_detected
);
    
    PRBS PRBS (
        .CLK(CLK),
        .RSTn(RSTn),
        .in(in),
        .n(n),
        .out(out)
    );

    pattern_detector #(PATTERN) Patter_Detector (
        .CLK(CLK),
        .RSTn(RSTn),
        .in(out),
        .n(n),
        .pattern_detected(pattern_detected)
        );
endmodule