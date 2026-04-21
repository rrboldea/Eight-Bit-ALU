# Eight-Bit ALU

An 8-bit Arithmetic Logic Unit (ALU) implemented in Verilog and deployed on the **DE10-Lite FPGA board** (Intel MAX 10). The ALU supports **addition**, **subtraction**, and **multiplication** of two 8-bit operands, with the 16-bit result displayed on LEDs.

---

## Overview

The top-level module (`test`) reads two 8-bit operands from on-board switches, loads them into registers X and Y via a button press, and then performs the selected arithmetic operation (ADD, SUB, or MULT) triggered by dedicated buttons. Button signals are debounced through synchronizer and positive-edge detector circuits before being passed to the ALU.

---

## Repository Structure

```
Eight-Bit-ALU/
├── modules/
│   ├── ALU.v               # Top-level ALU module (ADD, SUB, MULT)
│   ├── RCA_adder.v         # Ripple Carry Adder
│   ├── ac.v                # Adder/carry component
│   ├── add_sub_1.v         # Add/subtract by 1 unit
│   ├── adder.v             # General adder
│   ├── br4_8bits.v         # Booth radix-4 multiplier (8-bit)
│   ├── br4_8bits_CU.v      # Control unit for Booth multiplier
│   ├── cla_4b_adder.v      # Carry Lookahead Adder (4-bit)
│   ├── cla_4b_carry.v      # CLA carry generator
│   ├── counter.v           # Counter (used in multiplication FSM)
│   ├── d_ff.v              # D flip-flop
│   ├── fac.v               # Full adder cell
│   ├── hac.v               # Half adder cell
│   ├── mux_1sel.v          # 2-to-1 multiplexer
│   ├── nrd8bits.v          # Non-restoring division (8-bit)
│   ├── nrd8bits_CU.v       # Control unit for division
│   ├── register.v          # General purpose register
│   ├── rshiftReg.v         # Right shift register
│   └── test_load_x_y.v     # Module to load X and Y operands
├── testbench/              # Testbenches for each module
├── test.v                  # Top-level test module for DE10-Lite
├── pos_edge.v              # Positive edge detector for button inputs
├── synchronizer.v          # Button signal synchronizer (metastability)
├── ALU.sdc                 # Timing constraints (50 MHz clock, Terasic)
└── prj.tcl                 # Quartus TCL project script
```

---

## Hardware

| Component  | Details                            |
|------------|------------------------------------|
| FPGA Board | DE10-Lite (Terasic)                |
| Device     | Intel MAX 10 — 10M50DAF484C7G      |
| Clock      | 50 MHz (PIN_P11)                   |
| Language   | Verilog                            |
| Toolchain  | Intel Quartus Prime                |

---

## Operations

The ALU performs three operations, each triggered by a dedicated external button:

| Operation      | Button  | Pin  | Output Width |
|----------------|---------|------|--------------|
| Addition       | ADD_b   | AA2  | 16-bit (q)   |
| Subtraction    | SUB_b   | AB2  | 16-bit (q)   |
| Multiplication | MULT_b  | Y3   | 16-bit (q)   |

Multiplication is implemented using the **Booth Radix-4** algorithm.

---

## I/O Pin Mapping

### Inputs

| Signal       | Description                          | Pin      |
|--------------|--------------------------------------|----------|
| `clk`        | 50 MHz system clock                  | P11      |
| `rst_b`      | Active-low reset (on-board button)   | A7       |
| `ld_x_y_b`   | Load X/Y operands (on-board button)  | B8       |
| `ADD_b`      | Trigger addition (external button)   | AA2      |
| `SUB_b`      | Trigger subtraction (ext. button)    | AB2      |
| `MULT_b`     | Trigger multiplication (ext. button) | Y3       |
| `data[7:0]`  | 8-bit data input via switches        | C10–A14  |

### Outputs

| Signal     | Description                           | Pins     |
|------------|---------------------------------------|----------|
| `q[15:0]`  | 16-bit ALU result displayed on LEDs   | AB5–AA20 |
| `DONE`     | Operation complete flag (on-board LED)| A8       |

---

## How It Works

1. **Load operands** — Set the desired 8-bit value on the switches, then press `ld_x_y_b`. The first press loads register **X**, the second press loads register **Y**.
2. **Select operation** — Press `ADD_b`, `SUB_b`, or `MULT_b` to trigger the desired operation.
3. **Read result** — The 16-bit result appears on the output LEDs (`q[15:0]`). The `DONE` LED lights up when the operation is complete (relevant for multiplication).

> **Note:** Buttons on the DE10-Lite are **active-low** (pulled HIGH). The `test` module inverts the signals internally. Each button signal passes through a **synchronizer** (to prevent metastability) and a **positive-edge detector** before reaching the ALU.

---

## Signal Flow

```
Switches (data[7:0])
        |
        v
  test_load_x_y  <-- ld_x_y (button, synced + edge-detected)
   /          \
  X            Y
   \          /
      ALU.v   <-- ADD / SUB / MULT (buttons, synced + edge-detected)
        |
     q[15:0]  -->  LEDs
     DONE     -->  LED
```

---

### Manual setup

1. Create a new Quartus project targeting device `10M50DAF484C7G`
2. Add all `.v` files from `modules/` and the root directory
3. Set `test` as the top-level entity
4. Import `ALU.sdc` for timing constraints
5. Compile and program the DE10-Lite board

---

## Simulation

Each module has a corresponding testbench in the `testbench/` folder. To simulate:

1. Use **ModelSim** (included with Quartus) or any Verilog-compatible simulator
2. Compile the target module alongside its testbench
3. Run the simulation and inspect the waveforms

---

## Authors

- Boldea Rares
- Teregovan David
- Coroban Vlad
- Tentiu Tudor
