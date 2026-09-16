; Count down from 10, writing each value to memory at 0x0100, then halt.
;
; Small enough to trace by hand in Digital, which is the point: if the machine
; runs this correctly the fetch, the ALU, the flags and a conditional jump are
; all working.

#include "../toolchain/lexis/dianoia.asm"

#bank rom

    ldi   r0, 10          ; counter
    ld16  r1, 0x0100      ; where to write
    ldi   r2, 1           ; the amount we step by

loop:
    st    [r1], r0        ; store the counter
    add   r1, r2          ; next slot
    sub   r0, r2          ; counter -= 1, sets Z when it reaches zero
    jnz   loop

    hlt
