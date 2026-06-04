module HMM_State_Machine (
    input clk,
    input reset,
    input [7:0] observation,    // 8-bit Observation (0-255)
    output reg [1:0] output_state // 2-bit Output State (A=00, T=01, C=10, G=11)
);

    // State encoding
    parameter A = 2'b00;
    parameter T = 2'b01;
    parameter C = 2'b10;
    parameter G = 2'b11;

    // Transition, Emission, and Initial probabilities
    reg [7:0] trans_prob [0:3][0:3];
    reg [7:0] emit_prob [0:3][0:255];
    reg [7:0] init_prob [0:3];
    integer i;
     // Probabilities for current and next state
    reg [7:0] prob [0:3];
    reg [7:0] new_prob [0:3];
    reg [7:0] max_prob;
    reg [1:0] state;

    // Initialize probabilities
    initial begin
        // Transition Probabilities
        trans_prob[A][A] = 8'h99; trans_prob[A][T] = 8'h4D; trans_prob[A][C] = 8'h0D; trans_prob[A][G] = 8'h0D;
        trans_prob[T][A] = 8'h4D; trans_prob[T][T] = 8'h99; trans_prob[T][C] = 8'h0D; trans_prob[T][G] = 8'h0D;
        trans_prob[C][A] = 8'h0D; trans_prob[C][T] = 8'h0D; trans_prob[C][C] = 8'hB3; trans_prob[C][G] = 8'h33;
        trans_prob[G][A] = 8'h0D; trans_prob[G][T] = 8'h0D; trans_prob[G][C] = 8'h33; trans_prob[G][G] = 8'hB3;

        // Emission Probabilities (Initialize all observations)
  
        for (i = 0; i < 256; i = i + 1) begin
            emit_prob[A][i] = 8'h10 + i % 32; // Example pattern
            emit_prob[T][i] = 8'h20 + i % 32;
            emit_prob[C][i] = 8'h30 + i % 32;
            emit_prob[G][i] = 8'h40 + i % 32;
        end

        // Initial State Probabilities
        init_prob[A] = 8'h40;
        init_prob[T] = 8'h40;
        init_prob[C] = 8'h40;
        init_prob[G] = 8'h40;
    end

    // State machine logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset state to A and initialize probabilities
            state <= A;
            prob[0] <= init_prob[0] + emit_prob[0][observation];
            prob[1] <= init_prob[1] + emit_prob[1][observation];
            prob[2] <= init_prob[2] + emit_prob[2][observation];
            prob[3] <= init_prob[3] + emit_prob[3][observation];
        end else begin
            // Find max_prob
            max_prob = prob[0];
            if (prob[1] > max_prob) max_prob = prob[1];
            if (prob[2] > max_prob) max_prob = prob[2];
            if (prob[3] > max_prob) max_prob = prob[3];

            // Normalize and calculate new probabilities
            new_prob[0] <= (prob[0] + trans_prob[0][state] + emit_prob[0][observation]) - max_prob;
            new_prob[1] <= (prob[1] + trans_prob[1][state] + emit_prob[1][observation]) - max_prob;
            new_prob[2] <= (prob[2] + trans_prob[2][state] + emit_prob[2][observation]) - max_prob;
            new_prob[3] <= (prob[3] + trans_prob[3][state] + emit_prob[3][observation]) - max_prob;

            // Update probabilities
            prob[0] <= new_prob[0];
            prob[1] <= new_prob[1];
            prob[2] <= new_prob[2];
            prob[3] <= new_prob[3];

            // Determine the state with the highest probability
            if (new_prob[1] > new_prob[0] && new_prob[1] > new_prob[2] && new_prob[1] > new_prob[3])
                state <= T;
            else if (new_prob[2] > new_prob[0] && new_prob[2] > new_prob[1] && new_prob[2] > new_prob[3])
                state <= C;
            else if (new_prob[3] > new_prob[0] && new_prob[3] > new_prob[1] && new_prob[3] > new_prob[2])
                state <= G;  
            else
                state <= A;

            // Output the state
            output_state <= state;
            $display("Observation: %d, State: %b", observation, output_state);
        end
    end
endmodule
