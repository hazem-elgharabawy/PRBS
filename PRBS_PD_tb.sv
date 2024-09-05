module PRBS_PD_tb ();

    bit CLK;
    logic RSTn;
    logic [7:0] n;
    logic [31:0] in;
    logic [7:0] out;
    logic pattern_detected;

    parameter PATTERN = 32'h AB_CD_EF_CD;
    integer error_counter;
    integer correct_counter;

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
    end

    PRBS_PD_WPR #(PATTERN) DUT (.*);


    task automatic RST_CHECK();
        RSTn = 0;
        in = PATTERN;
        @(negedge CLK);
        if (out!=0 || pattern_detected!=0) begin
            $display("ERROR: RST_CHECK failed");
            error_counter++;
        end
        else correct_counter++;

    endtask //automatic

    task automatic PATTERN_CHECK();

        @(negedge clk);
        RSTn = 1;
        for ( integer i = 3; i >= 0 ; i-- ) begin
            if(out!=PATTERN[((8*i)+7):(8*i)]) begin
                $display("ERROR PATTERN CHECK failed");
                error_counter++;
            end
            else correct_counter++;
        end 
        pattern_detection_check();       
    endtask //automatic

    task automatic pattern_detection_check(arguments);
        if (!pattern_detected) begin
            $display("ERROR Pattern detection check failed");
            error_counter++;
        end
        else correct_counter++;
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