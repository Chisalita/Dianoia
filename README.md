# Dianoia

A computer built from NAND gates upward — the chips, the instruction set, and
the toolchain that targets it.

*Dianoia* (διάνοια) is Aristotle's word for discursive reasoning: thought that
proceeds one step at a time toward a conclusion, as opposed to *noesis*, the
immediate grasp of a first principle. It is a fair description of what a
processor does.

## The toolchain

Named so far. None of it is built, and the names are the only thing decided.

| Name | Greek | Will be |
| --- | --- | --- |
| **Lexis** | λέξις, *wording* | Assembler. Mnemonics to opcodes — concerned with how things are said, not what they mean. |
| **Metaphrasis** | μετάφρασις, *word-for-word translation* | VM translator. Each stack command becomes a fixed sequence of assembly. |
| **Poiesis** | ποίησις, *bringing-forth* | Compiler. The high-level language becomes something that did not exist before. |
| **Koine** | κοινή, *the common tongue* | Standard library and OS layer. What every program can assume. |
| **Mimesis** | μίμησις, *imitation* | Emulator. Imitates the machine rather than being it. |
| **Elenchus** | ἔλεγχος, *cross-examination* | Debugger. Interrogate the program until it contradicts itself. |
| **Dokimasia** | δοκιμασία, *vetting before office* | Test runner. Nothing ships until it is examined. |

## Not decided yet

Deliberately open. Writing a specification before understanding the problem
produces a specification that has to be thrown away.

- word size, register count, instruction format
- memory model — Harvard or von Neumann
- whether Lexis is hand-written or generated from a declarative ISA description
- which logic simulator the chips are drawn in
- how much of the nand2tetris design to keep, and where to diverge from it

## Method

Following *The Elements of Computing Systems* (nand2tetris) to learn how the
layers fit together, then building Dianoia as its own machine rather than a
copy of the course's. Course work and original design stay in separate
directories so the two never quietly merge.
