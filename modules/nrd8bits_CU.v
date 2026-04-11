module nrd8bits_CU (
    input  wire clk,
    input  wire rst_b,
    input  wire start,
    input  wire sign_A,        
    output reg  shift_AQ,
    output reg  sub_M,
    output reg  add_M,
    output reg  set_Q0_1,
    output reg  set_Q0_0,
    output reg  restore,
    output reg  done
);

    reg [3:0] state, next_state;
    reg [3:0] n_count;
    reg       sign_A_latch;

    
    always @(posedge clk or posedge rst_b) begin
        if (rst_b)
            state <= 4'd0;
        else
            state <= next_state;
    end

    
    always @(posedge clk or posedge rst_b) begin
        if (rst_b)
            n_count <= 4'd0;
        else begin
            if (state == 4'd1)          // LOAD
                n_count <= 4'd0;
            else if (state == 4'd5)     // increment la fiecare iteratie
                n_count <= n_count + 4'd1;
        end
    end

    
    always @(posedge clk or posedge rst_b) begin
        if (rst_b)
            sign_A_latch <= 1'b0;
        else if (state == 4'd3) // dupa operatie
            sign_A_latch <= sign_A;
    end

    
    always @(*) begin
        case (state)
            4'd0  : next_state = start ? 4'd1 : 4'd0;
            4'd1  : next_state = 4'd2;
            4'd2  : next_state = 4'd3;
            4'd3  : next_state = 4'd4;
            4'd4  : next_state = 4'd5;
            4'd5  : next_state = (n_count == 4'd7) ? 4'd6 : 4'd2;
            4'd6  : next_state = 4'd7;
            4'd7  : next_state = 4'd8;
            4'd8  : next_state = 4'd0;
            default : next_state = 4'd0;
        endcase
    end

    
    always @(posedge clk or posedge rst_b) begin
        if (rst_b) begin
            shift_AQ  <= 0;
            sub_M     <= 0;
            add_M     <= 0;
            set_Q0_1  <= 0;
            set_Q0_0  <= 0;
            restore   <= 0;
            done      <= 0;
        end else begin
            
            shift_AQ  <= 0;
            sub_M     <= 0;
            add_M     <= 0;
            set_Q0_1  <= 0;
            set_Q0_0  <= 0;
            restore   <= 0;
            done      <= 0;

            case (state)

                // 2: SHIFT (A,Q)
                4'd2: begin
                    shift_AQ <= 1;
                end

                // 3: ADD / SUB 
                4'd3: begin
                    if (sign_A == 0)
                        sub_M <= 1;   
                    else
                        add_M <= 1;   
                end

                // 4: SET Q0 
                4'd4: begin
                    if (sign_A_latch == 0)
                        set_Q0_1 <= 1; 
                    else
                        set_Q0_0 <= 1; 
                end

                // 6: RESTORE 
                4'd6: begin
                    if (sign_A_latch == 1)
                        restore <= 1;
                end

                // 8: DONE
                4'd8: begin
                    done <= 1;
                end

            endcase
        end
    end

endmodule