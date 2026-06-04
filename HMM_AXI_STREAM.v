`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.01.2026 12:21:06
// Design Name: 
// Module Name: HMM_AXI_STREAM
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


module HMM_AXI_STREAM #
(
    parameter FRAME_LEN = 16
)
(
    input  wire        aclk,
    input  wire        aresetn,

    // AXI-Stream Slave (Input from DMA MM2S)
    input  wire [31:0]  s_axis_tdata,
    input  wire        s_axis_tvalid,
    input  wire        s_axis_tlast,
    output wire        s_axis_tready,
    
// AXI-Stream Master (Output to DMA S2MM)
output reg  [7:0]  m_axis_tdata,   // FIXED (8-bit)
output reg         m_axis_tvalid,
output reg         m_axis_tlast,
input  wire        m_axis_tready
);

    //-------------------------------
    // HMM State Encoding
    //-------------------------------
    localparam A = 2'b00,
               T = 2'b01,
               C = 2'b10,
               G = 2'b11;

    //-------------------------------
    // Probability Memories
    //-------------------------------
    reg [7:0] trans_prob [0:3][0:3];
    reg [7:0] emit_prob  [0:3][0:255];
    reg [7:0] prob       [0:3];
    reg [7:0] new_prob   [0:3];
    reg [7:0] max_prob;
    reg [1:0] state;

    integer i;

    //-------------------------------
    // Ready Always High
    //-------------------------------
    assign s_axis_tready = 1'b1;

    //-------------------------------
    // Initialization
    //-------------------------------
    initial begin
        trans_prob[A][A]=8'h99; trans_prob[A][T]=8'h4D; trans_prob[A][C]=8'h0D; trans_prob[A][G]=8'h0D;
        trans_prob[T][A]=8'h4D; trans_prob[T][T]=8'h99; trans_prob[T][C]=8'h0D; trans_prob[T][G]=8'h0D;
        trans_prob[C][A]=8'h0D; trans_prob[C][T]=8'h0D; trans_prob[C][C]=8'hB3; trans_prob[C][G]=8'h33;
        trans_prob[G][A]=8'h0D; trans_prob[G][T]=8'h0D; trans_prob[G][C]=8'h33; trans_prob[G][G]=8'hB3;

        for (i=0;i<256;i=i+1) begin
            emit_prob[A][i]=8'h10 + i%32;
            emit_prob[T][i]=8'h20 + i%32;
            emit_prob[C][i]=8'h30 + i%32;
            emit_prob[G][i]=8'h40 + i%32;
        end
    end

    //-------------------------------
    // AXI-Stream HMM Processing
    //-------------------------------
    always @(posedge aclk) begin
        if (!aresetn) begin
            prob[0] <= 0; prob[1] <= 0; prob[2] <= 0; prob[3] <= 0;
            state <= A;
            m_axis_tvalid <= 0;
            m_axis_tlast  <= 0;
        end
        else if (s_axis_tvalid) begin

            // Max probability
            max_prob = prob[0];
            if (prob[1] > max_prob) max_prob = prob[1];
            if (prob[2] > max_prob) max_prob = prob[2];
            if (prob[3] > max_prob) max_prob = prob[3];

            // Update probabilities
            new_prob[A] <= prob[A] + emit_prob[A][s_axis_tdata] - max_prob;
            new_prob[T] <= prob[T] + emit_prob[T][s_axis_tdata] - max_prob;
            new_prob[C] <= prob[C] + emit_prob[C][s_axis_tdata] - max_prob;
            new_prob[G] <= prob[G] + emit_prob[G][s_axis_tdata] - max_prob;

            prob[A] <= new_prob[A];
            prob[T] <= new_prob[T];
            prob[C] <= new_prob[C];
            prob[G] <= new_prob[G];

            // State decision
            if (new_prob[T] > new_prob[A]) state <= T;
            else if (new_prob[C] > new_prob[A]) state <= C;
            else if (new_prob[G] > new_prob[A]) state <= G;
            else state <= A;

            // Output only at TLAST
           if (s_axis_tlast && m_axis_tready) begin
    m_axis_tdata  <= {6'b0, state}; // pack 2-bit state
    m_axis_tvalid <= 1'b1;
    m_axis_tlast  <= 1'b1;
end else begin
    m_axis_tvalid <= 1'b0;
    m_axis_tlast  <= 1'b0;
end
        end
    end
endmodule
