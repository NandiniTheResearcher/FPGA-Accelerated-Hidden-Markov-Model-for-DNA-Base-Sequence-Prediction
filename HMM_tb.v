`timescale 1ns / 1ps

module HMM_State_Machine_tb;
    // Inputs
    reg clk;
    reg reset;
    reg [7:0] observation;

    // Outputs
    wire [1:0] output_state;

    // Instantiate the HMM State Machine
    HMM_State_Machine uut (
        .clk(clk),
        .reset(reset),
        .observation(observation),
        .output_state(output_state)
    );

    // Clock Generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        observation = 8'd2; // Initial observation

        // Apply Reset
        #20 reset = 0;

        // Observations to test all states
        repeat (6) begin
            // Test observations for state A
            observation = 8'd2;  #10;
            $display("Observation: %d, State: %b", observation, output_state);

            // Test observations for state T
            observation = 8'd42; #10;
            $display("Observation: %d, State: %b", observation, output_state);

            // Test observations for state C
            observation = 8'd150; #10;
            $display("Observation: %d, State: %b", observation, output_state);

            // Test observations for state G
            observation = 8'd250; #10;
            $display("Observation: %d, State: %b", observation, output_state);

            // Additional state checks for 1 and 3
            observation = 8'd1; #10;
            $display("Observation: %d, State: %b", observation, output_state);

            observation = 8'd3; #10;
            $display("Observation: %d, State: %b", observation, output_state);

            observation = 8'd99; #10;
            $display("Observation: %d, State: %b", observation, output_state);

            observation = 8'd180; #10;
            $display("Observation: %d, State: %b", observation, output_state);

            observation = 8'd75; #10;
            $display("Observation: %d, State: %b", observation, output_state);
        end

        // Finish simulation
        #20 $finish;
    end
endmodule
