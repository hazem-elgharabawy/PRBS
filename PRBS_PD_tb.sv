module PRBS_PD_tb ();

    bit CLK;
    logic RSTn;
    logic [7:0] n;
    logic [31:0] in;
    logic [7:0] out;
    logic pattern_detected;

    parameter PATTERN = 32'h AB_CD_EF_CD;

    integer error_counter = 0;
    integer correct_counter = 0;

    //CLK generation
    initial begin
        forever begin
            #1 CLK = ~CLK;
        end
    end

    initial begin
        RST_CHECK();
        PATTERN_CHECK();
        @(negedge CLK);
        pattern_detection_check();
        report();
        $stop;
    end

    PRBS_PD_WPR #(PATTERN) DUT (
    .CLK(CLK),
    .RSTn(RSTn),
    .in(in),
    .n(n),
    .out(out),
    .pattern_detected(pattern_detected)
    );


    task automatic RST_CHECK();
        RSTn = 0;
        in = PATTERN;
        @(negedge CLK);
        if (out!=0 || pattern_detected!=0) begin
            $display("ERROR: RST_CHECK failed");
            error_counter = error_counter + 1;
        end
        else correct_counter = correct_counter + 1;

    endtask //automatic

    task automatic PATTERN_CHECK();

        @(negedge CLK);
        RSTn = 1;
        n=2;
        @(negedge CLK);
        for( integer j = 0; j < n ; j++) begin
            for ( integer i = 0; i < 4 ; i++ ) begin
                    if (i==0) begin
                        if(out!=PATTERN[31:24]) begin
                            $display("ERROR PATTERN CHECK failed");
                            error_counter = error_counter + 1;
                        end
                        else correct_counter = correct_counter + 1;    
                    end
                    if (i==1) begin
                        if(out!=PATTERN[23:16]) begin
                            $display("ERROR PATTERN CHECK failed");
                            error_counter = error_counter + 1;
                        end
                        else correct_counter = correct_counter + 1;
                    end
                    if (i==2) begin
                        if(out!=PATTERN[15:8]) begin
                            $display("ERROR PATTERN CHECK failed");
                            error_counter = error_counter + 1;
                        end
                        else correct_counter = correct_counter + 1;
                    end
                    if (i==3) begin
                        if(out!=PATTERN[7:0]) begin
                            $display("ERROR PATTERN CHECK failed");
                            error_counter = error_counter + 1;
                        end
                        else correct_counter = correct_counter + 1;
                    end
                    @(negedge CLK);
                end 
        end
        
        pattern_detection_check(); 

    endtask //automatic

    task automatic pattern_detection_check();
        if (!pattern_detected) begin
            $display("ERROR Pattern detection check failed");
            error_counter = error_counter + 1;
        end
        else correct_counter = correct_counter + 1;
        @(negedge CLK);
    endtask //automatic

    ////////////////test report/////////////
    task automatic report();
        if (error_counter == 0 ) begin
            $display("Test is over DUT is working well");
        end
        else begin
            $display("Test is over DUT is NOT working well with %d errors",error_counter);
        end
        
    endtask //automatic
endmodule