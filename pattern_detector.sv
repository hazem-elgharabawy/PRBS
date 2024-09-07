module pattern_detector#(
    parameter PATTERN =32'hAABBCCDD
) (
    input bit CLK,
    input logic RSTn,
    input logic [7:0] in,
    input logic [7:0] n,
    output logic pattern_detected
);
    typedef enum {
        first_byte,
        second_byte,
        third_byte,
        fourth_byte
    } state_e;

    state_e current_state;
    state_e next_state;

    logic flag;
    logic [7:0] counter;

    //state transition
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            current_state <= first_byte;    
        end
        else begin
            current_state <= next_state;
        end
    end


    //next state logic
    always @(*) begin
        case (current_state)
            first_byte: begin
                if (in==PATTERN[31:24]) begin
                    next_state = second_byte;
                end
                else begin
                    next_state = first_byte;
                end
            end
            second_byte: begin
                if (in==PATTERN[23:16]) begin
                    next_state = third_byte;
                end
                else begin
                    next_state = first_byte;
                end
            end
            third_byte: begin
                if (in==PATTERN[15:8]) begin
                    next_state = fourth_byte;
                end
                else begin
                    next_state = first_byte;
                end
            end
            fourth_byte: begin
                next_state = first_byte;
            end
            default: begin
                next_state = first_byte;
            end
        endcase
    end

    //output logic
    always @(*) begin
        case (current_state)
            first_byte: begin
                flag = 0;
            end 
            second_byte: begin
                flag = 0;
            end 
            third_byte: begin
                flag = 0;
            end 
            fourth_byte:begin
                if (in == PATTERN[7:0]) begin
                    flag = 1;    
                end
                else begin
                    flag = 0;
                end
            end 
            default: begin
                flag = 0;
            end
        endcase
    end

    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            counter <= 0;
            pattern_detected <= 0;
        end
        else if(current_state==fourth_byte && !flag)begin
            counter <= 0;
        end
        else if (current_state==fourth_byte && flag) begin
            if (counter == (n-1)) begin
                counter <= 0;
                pattern_detected <= 1;
            end
            counter <= counter + 1;
        end
    end

    

endmodule