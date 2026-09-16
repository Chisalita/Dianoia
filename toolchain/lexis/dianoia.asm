; Lexis — the Dianoia-16 assembler, as a customasm ruledef.
;
;   customasm examples/count.asm -f hexdump
;   customasm examples/count.asm -f readmemh -o build/count.hex
;
; NEVER RUN. Written from docs/isa.md before customasm was installed, so every
; encoding here is a proposal. Running it is the first job.
;
; Encodings follow docs/isa.md. If the two disagree, the spec is authoritative
; and this file is the bug.

#once

; Program memory is 4096 words of 16 bits — the reach of a 12-bit PC.
#bankdef rom
{
    #bits 16
    #addr 0x000
    #size 0x1000
    #outp 0
}

#ruledef reg
{
    r0 => 0b00
    r1 => 0b01
    r2 => 0b10
    r3 => 0b11
}

#ruledef dianoia
{
    ; --- no operands -------------------------------------------------------
    nop                          => 0x0`4 @ 0`12
    hlt                          => 0xF`4 @ 0`12

    ; --- immediates --------------------------------------------------------
    ldi {d: reg}, {v: u8}        => 0x1`4 @ d @ 0b00 @ v
    ldh {d: reg}, {v: u8}        => 0x2`4 @ d @ 0b00 @ v

    ; Load a full 16-bit constant. customasm expands this to the two
    ; instructions the hardware actually has, so the assembly stays readable
    ; without the machine growing a wider immediate.
    ld16 {d: reg}, {v: u16}      => asm {
                                        ldi {d}, {v & 0xff}
                                        ldh {d}, {(v >> 8) & 0xff}
                                    }

    ; --- memory ------------------------------------------------------------
    ld {d: reg}, [{s: reg}]      => 0x3`4 @ d @ s @ 0`8
    st [{d: reg}], {s: reg}      => 0x4`4 @ d @ s @ 0`8

    ; --- register to register ----------------------------------------------
    mov {d: reg}, {s: reg}       => 0x5`4 @ d @ s @ 0`8
    add {d: reg}, {s: reg}       => 0x6`4 @ d @ s @ 0`8
    sub {d: reg}, {s: reg}       => 0x7`4 @ d @ s @ 0`8
    and {d: reg}, {s: reg}       => 0x8`4 @ d @ s @ 0`8
    or  {d: reg}, {s: reg}       => 0x9`4 @ d @ s @ 0`8
    cmp {d: reg}, {s: reg}       => 0xE`4 @ d @ s @ 0`8
    not {d: reg}                 => 0xA`4 @ d @ 0b00 @ 0`8

    ; --- control flow ------------------------------------------------------
    ; Labels carry a full address; u12 makes customasm reject a jump out of
    ; program memory rather than silently truncating it to something valid.
    jmp {a: u12}                 => 0xB`4 @ a
    jz  {a: u12}                 => 0xC`4 @ a
    jnz {a: u12}                 => 0xD`4 @ a
}
