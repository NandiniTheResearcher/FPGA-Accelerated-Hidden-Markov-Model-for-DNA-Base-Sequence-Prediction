`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2025 13:11:52
// Design Name: 
// Module Name: TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module HMM_Top_AXI_Stream (
    input wire aclk,
    input wire aresetn,

    // AXI Stream Slave Interface (Input Observations)
    input wire [7:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,

    // AXI Stream Master Interface (Output States)
    output wire [7:0] m_axis_tdata,  // <-- FIXED WIDTH TO 8 BITS
    output wire m_axis_tvalid,
    input wire m_axis_tready
);

     // Internal signals
    reg [7:0] observation;
    wire [1:0] state;
    reg valid_reg;
    reg ready_reg;

    assign s_axis_tready = ready_reg;
    assign m_axis_tdata = {6'b000000, state};  // padded to 8 bits
    assign m_axis_tvalid = valid_reg;

    HMM_State_Machine hmm_inst (
        .clk(aclk),
        .reset(~aresetn),
        .observation(observation),
        .output_state(state)
    );

    always @(posedge aclk) begin
        if (!aresetn) begin
            observation <= 0;
            valid_reg <= 0;
            ready_reg <= 1;
        end else begin
            if (s_axis_tvalid && s_axis_tready) begin
                observation <= s_axis_tdata;
                valid_reg <= 1;
            end
            if (m_axis_tvalid && m_axis_tready) begin
                valid_reg <= 0;
            end
        end
    end
endmodule

