# HMM-Based Time Series to DNA Base Conversion on Zynq UltraScale+ MPSoC ZCU102

## Overview

This project presents a hardware implementation of a **Hidden Markov Model (HMM)** for converting time-series signal data into equivalent DNA base sequences (A, C, G, T) on the **Zynq UltraScale+ MPSoC ZCU102** platform.

The work targets accelerated genomic signal processing by mapping continuous or discrete signal observations to nucleotide sequences through probabilistic state estimation. The implementation leverages FPGA parallelism to achieve high-throughput and low-latency sequence decoding suitable for next-generation bioinformatics applications.

## Objectives

* Develop an HMM-based architecture for DNA base calling from time-series signals.
* Implement the algorithm using RTL design on FPGA.
* Accelerate probabilistic sequence decoding through hardware parallelism.
* Evaluate performance, resource utilization, and scalability on ZCU102.

## Key Features

* Hidden Markov Model (HMM) based decoding
* DNA base prediction (A, C, G, T)
* RTL-based hardware implementation
* FPGA acceleration on Zynq UltraScale+ MPSoC
* Parallel processing architecture
* Low-latency sequence generation
* Scalable and modular design

## Hardware Platform

* **Board:** Zynq UltraScale+ MPSoC ZCU102
* **FPGA Family:** Xilinx UltraScale+
* **Development Environment:** Xilinx Vivado
* **Language:** Verilog HDL

## Methodology

### Input

Time-series signal observations obtained from sequencing or biosensing systems.

### Processing

* Observation probability computation
* State transition evaluation
* Hidden state estimation using HMM
* Sequence decoding

### Output

Predicted DNA nucleotide sequence:

```text
A → G → T → C → A → G ...
```

## Design Flow

1. Algorithm Modeling
2. RTL Architecture Design
3. Functional Verification
4. FPGA Synthesis
5. Timing Analysis
6. Hardware Validation on ZCU102
7. Performance Evaluation

## Applications

* DNA Sequencing
* Genomic Signal Processing
* Bioinformatics Acceleration
* Real-Time Base Calling
* Computational Biology
* Hardware Accelerators for Life Sciences

## Repository Structure

```text
├── rtl/           # Verilog source files
├── sim/           # Testbenches and simulation scripts
├── constraints/   # XDC files
├── reports/       # Synthesis and implementation reports
├── docs/          # Design documentation
├── images/        # Architecture diagrams and results
└── datasets/      # Sample signal datasets
```

## Future Enhancements

* Viterbi-based sequence optimization
* FPGA-SoC software integration
* Multi-channel signal processing
* Hardware/software co-design
* ASIC implementation for genomic accelerators

## Author

**Nandini Kendre**
Senior Research Fellow
C2S (Chips to Startup) Program
Ministry of Electronics and Information Technology (MeitY), Government of India
