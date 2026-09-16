# Dianoia

A 16-bit computer built from NAND gates upward — the chips, the instruction set,
and the toolchain that targets it.

*Dianoia* (διάνοια) is Aristotle's word for discursive reasoning: thought that
proceeds one step at a time toward a conclusion, as opposed to *noesis*, the
immediate grasp of a first principle. It is a fair description of what a
processor does.

The project has two halves that stay deliberately separate:

- **`course/`** — work following *The Elements of Computing Systems*
  (nand2tetris). Its Hack architecture, its specification, its test files.
- **everything else** — Dianoia proper: my own instruction set, my own
  toolchain. It borrows the course's method and none of its design.

## The toolchain

Each stage is named for what it actually does, not for its position in a
pipeline.

| Name | Greek | Does |
| --- | --- | --- |
| **Lexis** | λέξις, *wording* | Assembler. Mnemonics to opcodes — concerned with how things are said, not what they mean. |
| **Metaphrasis** | μετάφρασις, *word-for-word translation* | VM translator. Each stack command becomes a fixed sequence of assembly. |
| **Poiesis** | ποίησις, *bringing-forth* | Compiler. The high-level language becomes something that did not exist before. |
| **Koine** | κοινή, *the common tongue* | Standard library and OS layer. What every program can assume. |
| **Mimesis** | μίμησις, *imitation* | Emulator. Imitates the machine rather than being it. |
| **Elenchus** | ἔλεγχος, *cross-examination* | Debugger. Interrogate the program until it contradicts itself. |
| **Dokimasia** | δοκιμασία, *vetting before office* | Test runner. Nothing ships until it is examined. |

Only **Lexis** exists so far, and only as a ruledef — see below.

## Tools this depends on

- **[Digital](https://github.com/hneemann/Digital)** — the logic simulator the
  chips are drawn in. Java, unzip and run, no install.
- **[customasm](https://github.com/hlorenzi/customasm)** — assembler generator.
  Lexis is a customasm ruledef rather than a hand-written assembler, because the
  interesting part of this project is the machine, not re-solving text parsing.
  It emits `readmemh`, Intel HEX, MIF and raw binary, all of which Digital loads
  as ROM contents — and all of which an FPGA would take later.

## Layout

    docs/isa.md              the instruction set, normative
    hardware/                Digital circuits (.dig) — the machine itself
    toolchain/lexis/         the customasm ruledef
    examples/                programs, in Dianoia assembly
    course/                  nand2tetris work, kept apart

## Status

Nothing is built yet. The ISA in `docs/isa.md` is a first sketch written before
any hardware exists, which means it is wrong in ways that will only show up once
the datapath does. Expect it to change; that is the point of writing it down
first.

**Immediate next step:** install customasm and run it over
`toolchain/lexis/dianoia.asm`. The ruledef has never been executed, so treat
every encoding in it as a proposal rather than a fact.
