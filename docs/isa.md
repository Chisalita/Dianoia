# The Dianoia-16 instruction set

A first sketch. Written before the datapath exists, so it is certainly wrong
somewhere — the value is in having something concrete to be wrong about.

## Machine

- **Word**: 16 bits. Everything is one word: instructions, data, addresses.
- **Registers**: `r0`–`r3`, general purpose, 16 bits each.
- **PC**: 12 bits, so 4096 words of program memory.
- **Flags**: `Z` (last ALU result was zero), `N` (last ALU result was negative).
- **Memory**: one flat 16-bit address space, shared by data and program
  (von Neumann). The course machine separates them; this does not, so that
  self-modifying code and a loader are both possible later.

Two design choices worth naming, because they are the ones most likely to be
regretted:

1. **Four registers, not two.** The course's Hack machine has `A` and `D`, which
   makes the hardware tiny and the assembly painful. Four registers cost two
   more bits per instruction and several multiplexers. The bet is that the
   toolchain above is more pleasant to write than the hardware below is to
   build.
2. **8-bit immediates only.** Loading a full 16-bit constant takes two
   instructions (`ldi` then `ldh`). The alternative — a two-word instruction
   format — complicates the fetch unit more than it is worth at this size.

## Encoding

Two formats, distinguished by opcode.

**Register/immediate form** — opcodes `0x0`–`0xA`, `0xE`, `0xF`

    15  12 11 10 9  8 7            0
    +------+-----+-----+------------+
    | op   | rd  | rs  | imm8       |
    +------+-----+-----+------------+

**Jump form** — opcodes `0xB`–`0xD`

    15  12 11                     0
    +------+-----------------------+
    | op   | addr12                |
    +------+-----------------------+

## Instructions

| Op | Mnemonic | Effect | Flags |
| --- | --- | --- | --- |
| `0x0` | `nop` | nothing | — |
| `0x1` | `ldi rd, imm8` | `rd ← imm8` (zero-extended) | — |
| `0x2` | `ldh rd, imm8` | `rd[15:8] ← imm8`, low byte kept | — |
| `0x3` | `ld rd, [rs]` | `rd ← mem[rs]` | — |
| `0x4` | `st [rd], rs` | `mem[rd] ← rs` | — |
| `0x5` | `mov rd, rs` | `rd ← rs` | — |
| `0x6` | `add rd, rs` | `rd ← rd + rs` | Z N |
| `0x7` | `sub rd, rs` | `rd ← rd - rs` | Z N |
| `0x8` | `and rd, rs` | `rd ← rd & rs` | Z N |
| `0x9` | `or rd, rs` | `rd ← rd \| rs` | Z N |
| `0xA` | `not rd` | `rd ← ~rd` | Z N |
| `0xB` | `jmp addr` | `PC ← addr` | — |
| `0xC` | `jz addr` | `PC ← addr` if `Z` | — |
| `0xD` | `jnz addr` | `PC ← addr` if not `Z` | — |
| `0xE` | `cmp rd, rs` | flags from `rd - rs`, result discarded | Z N |
| `0xF` | `hlt` | stop the clock | — |

`not` and `hlt` ignore the `rs` and `imm8` fields; they are encoded as zero so
that the bit pattern is unambiguous if the encoding is ever extended.

## Open questions

- No shift instructions. An ALU with a barrel shifter is a lot of gates; a
  `shl` that only shifts by one is cheap and enough for multiplication by
  repeated addition. Decide after building the ALU.
- No call/return, so no subroutines yet. That needs a stack pointer, which
  means either a dedicated register or a convention that `r3` is SP. The latter
  is free in hardware and costs a register.
- Nothing about I/O. The course maps a screen and keyboard into the address
  space; something similar is the obvious move, but the addresses should be
  chosen once memory exists rather than now.
