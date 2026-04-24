# Eight-Bit ALU

An 8-bit Arithmetic Logic Unit (ALU) implemented in Verilog and deployed on the **DE10-Lite FPGA board** (Intel MAX 10). The ALU supports **addition**, **subtraction**, **multiplication**, and **division** of two 8-bit operands, with the 16-bit result displayed on LEDs.
> **Note:** The `srt` branch — implementing the SRT (Sweeney-Robertson-Tocher) division algorithm — has been merged into `main`.
> **Note:** The `booth` branch — implementing the BOOTH Radix-8 multiplication algorithm — has been merged into `main`.

---

## Overview

The top-level module (`test`) reads one 16-bit and one 8-bit operand from on-board switches, loads them into registers W, X and Y via a button press, and then performs the selected arithmetic operation (ADD, SUB, MULT, or DIV) triggered by dedicated buttons. Button signals are debounced through synchronizer and positive-edge detector circuits before being passed to the ALU.

---

## Repository Structure

```
Eight-Bit-ALU/
├── modules/
│   ├── ALU.v               # Top-level ALU module (ADD, SUB, MULT, DIV)
│   ├── RCA_adder.v         # Ripple Carry Adder
│   ├── ac.v                # Adder/carry component
│   ├── add_sub_1.v         # Add/subtract by 1 unit
│   ├── adder.v             # General adder
│   ├── br4_8bits.v         # Booth radix-4 multiplier (8-bit) (legacy)
│   ├── br4_8bits_CU.v      # Control unit for Booth radix-4 multiplier
│   ├── br8_8bits.v         # Booth radix-8 multiplier (8-bit)
│   ├── br8_8bits_CU.v      # Control unit for Booth radix-8 multiplier
│   ├── cla_4b_adder.v      # Carry Lookahead Adder (4-bit)
│   ├── cla_4b_carry.v      # CLA carry generator
│   ├── counter.v           # Counter (used in multiplication FSM)
│   ├── d_ff.v              # D flip-flop
│   ├── fac.v               # Full adder cell
│   ├── hac.v               # Half adder cell
│   ├── lshiftReg.v         # Left shift register
│   ├── mux_1sel.v          # 2-to-1 multiplexer
│   ├── nrd8bits.v          # Non-restoring division / SRT division (8-bit)
│   ├── nrd8bits_CU.v       # Control unit for SRT division
│   ├── register.v          # General purpose register
│   ├── rshiftReg.v         # Right shift register
│   ├── test_load_w_x_y.v   # Module to load X and Y operands
|   ├── pos_edge.v          # Positive edge detector for button inputs
|   ├── synchronizer.v      # Button signal synchronizer (metastability)
|   └── test.v              # Top-level test module for DE10-Lite
├── testbench/              # Testbenches for each module
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

The ALU performs four operations, each triggered by a dedicated external button:

| Operation      | Button  | Pin  | Output Width |
|----------------|---------|------|--------------|
| Addition       | ADD_b   | AA2  | 16-bit (q)   |
| Subtraction    | SUB_b   | AB2  | 16-bit (q)   |
| Multiplication | MULT_b  | Y3   | 16-bit (q)   |
| Division       | DIV_b   | TBD  | 16-bit (q)   |

Multiplication is implemented using the **Booth Radix-8** algorithm (upgraded from Booth Radix-4). Division is implemented using the **SRT Radix-4 (Sweeney-Robertson-Tocher)** algorithm.

---

## I/O Pin Mapping

### Inputs

| Signal       | Description                          | Pin      |
|--------------|--------------------------------------|----------|
| `clk`        | 50 MHz system clock                  | P11      |
| `rst_b`      | Active-low reset (on-board button)   | A7       |
| `ld_w_x_y_b` | Load X/Y operands (on-board button)  | B8       |
| `ADD_b`      | Trigger addition (external button)   | W10      |
| `SUB_b`      | Trigger subtraction (ext. button)    | V10      |
| `MULT_b`     | Trigger multiplication (ext. button) | W9       |
| `DIV_b`      | Trigger multiplication (ext. button) | V9       |
| `data[7:0]`  | 8-bit data input via switches        | C10–A14  |

### Outputs

| Signal     | Description                           | Pins     |
|------------|---------------------------------------|----------|
| `q[15:0]`  | 16-bit ALU result displayed on LEDs   | AB5–AA20 |
| `DONE`     | Operation complete flag (on-board LED)| A8       |

---

## How It Works

1. **Load operands** — Set the desired 8-bit value on the switches, then press `ld_w_x_y_b`. The first press loads register **W**, the second press loads register **X**, and the last one register **Y**
2. **Select operation** — Press `ADD_b`, `SUB_b`, `MULT_b`, or `DIV_b` to trigger the desired operation.
3. **Read result** — The 16-bit result appears on the output LEDs (`q[15:0]`). The `DONE` LED lights up when the operation is complete (relevant for multiplication).

> **Note:** Buttons on the DE10-Lite are **active-low** (pulled HIGH). The `test` module inverts the signals internally. Each button signal passes through a **synchronizer** (to prevent metastability) and a **positive-edge detector** before reaching the ALU.

---

## Signal Flow

```
Switches (data[7:0])
        |
        v
  test_load_w_x_y  <-- ld_w_x_y (button, synced + edge-detected)
   /          \
  X            Y
   \          /
      ALU.v   <-- ADD / SUB / MULT / DIV (buttons, synced + edge-detected)
        |
     q[15:0]  -->  LEDs
     DONE     -->  LED
```

---

## Building the Project

### Manual setup

1. Clone the repository
2. Connect the pins of the fpga to leds and buttons (connections can be seen in the prj.tcl)
3. inside the folder, run quartus_pgm -l to check if the intel de10 lite is connected
4. execute quartus_sh -t prj.tcl, in orfer to compile the design
5. run quartus_pgm -m jtag -o "p;ALU.sof@1" to upload ALU.sof to the board 

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
