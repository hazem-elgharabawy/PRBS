module PRBS_PD_tb ();

    bit CLK;
    logic RSTn;
    logic data_valid;
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

    PRBS_PD_WPR #(PATTERN) DUT (
    .CLK(CLK),
    .RSTn(RSTn),
    .data_valid(data_valid),
    .in(in),
    .n(n),
    .out(out),
    .pattern_detected(pattern_detected)
    );

    initial begin
        RST_CHECK();
        right_pattern_check(32'h AB_CD_EF_CD,3);
        @(negedge CLK);
        right_pattern_detection_check();
        
        @(negedge CLK);
        
        right_pattern_check(32'h AB_CD_EF_CD,2);
        @(negedge CLK);
        right_pattern_detection_check();
        
        @(negedge CLK);
        
        wrong_pattern_check(32'hAA_BB_CC_DD,1);
        @(negedge CLK);
        wrong_pattern_detection_check();
              
        @(negedge CLK);

        report();
        $stop;
    end

    


    task automatic RST_CHECK();
        RSTn = 0;
        in = PATTERN;
        n=0;
        data_valid =0;
        repeat(3) @(negedge CLK);
        if (out!=0 || pattern_detected!=0) begin
            $display("ERROR: RST_CHECK failed");
            error_counter = error_counter + 1;
        end
        else correct_counter = correct_counter + 1;
        @(negedge CLK);
        RSTn = 1;
    endtask //automatic

    task automatic right_pattern_check(input [31:0]IN , input [7:0] N);
        data_valid = 0;
        @(negedge CLK);
        data_valid = 1;
        n=N;
        in = IN;
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
        
        right_pattern_detection_check(); 

    endtask //automatic

    task automatic right_pattern_detection_check();
        if (!pattern_detected) begin
            $display("ERROR Pattern detection check failed");
            error_counter = error_counter + 1;
        end
        else correct_counter = correct_counter + 1;
        @(negedge CLK);
    endtask //automatic

    task automatic wrong_pattern_check(input [31:0]IN , input [7:0] N);
        data_valid =0;
        @(negedge CLK);
        data_valid = 1;
        in=IN;
        n=N;
        @(negedge CLK);
        for( integer j = 0; j < n ; j++) begin
            for ( integer i = 0; i < 4 ; i++ ) begin
                    if (i==0) begin
                        if(out==PATTERN[31:24]) begin
                            $display("ERROR PATTERN did not change");
                            error_counter = error_counter + 1;
                        end
                        else correct_counter = correct_counter + 1;    
                    end
                    if (i==1) begin
                        if(out==PATTERN[23:16]) begin
                            $display("ERROR PATTERN did not change");
                            error_counter = error_counter + 1;
                        end
                        else correct_counter = correct_counter + 1;
                    end
                    if (i==2) begin
                        if(out==PATTERN[15:8]) begin
                            $display("ERROR PATTERN did not change");
                            error_counter = error_counter + 1;
                        end
                        else correct_counter = correct_counter + 1;
                    end
                    if (i==3) begin
                        if(out===PATTERN[7:0]) begin
                            $display("ERROR PATTERN did not change");
                            error_counter = error_counter + 1;
                        end
                        else correct_counter = correct_counter + 1;
                    end
                    @(negedge CLK);
                end 
        end
        
        wrong_pattern_detection_check();
    endtask //automatic


    task automatic wrong_pattern_detection_check();
        if (pattern_detected) begin
            $display("ERROR wrong Pattern detect as right");
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