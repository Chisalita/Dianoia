# Hardware

Digital circuit files (`.dig`) for the Dianoia-16.

Build order, smallest first — each one is testable on its own before the next
depends on it:

1. `nand.dig` is given; everything else comes from it
2. gates — not, and, or, xor
3. mux, demux, and their 16-bit forms
4. adder — half, full, 16-bit ripple carry
5. `alu.dig` — the operations in docs/isa.md, plus the Z and N flags
6. register, then the 4-register file
7. RAM
8. `control.dig` — opcode to control lines
9. `cpu.dig` — datapath plus control
10. `dianoia.dig` — CPU, RAM, and the ROM that Lexis fills

Load a program by pointing the ROM component at a `readmemh` file from
`make all`.
