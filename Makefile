# Assembling requires customasm:  cargo install customasm
ASM     := customasm
BUILD   := build
SOURCES := $(wildcard examples/*.asm)
TARGETS := $(patsubst examples/%.asm,$(BUILD)/%.hex,$(SOURCES))

.PHONY: all clean dump
all: $(TARGETS)

# readmemh is what Digital loads as ROM contents, and what an FPGA would take.
$(BUILD)/%.hex: examples/%.asm toolchain/lexis/dianoia.asm | $(BUILD)
	$(ASM) $< -f readmemh -o $@

# Annotated listing — source beside the bits it produced. The fastest way to
# see that an encoding is wrong.
dump: examples/count.asm
	$(ASM) $< -f annotated

$(BUILD):
	mkdir -p $(BUILD)

clean:
	rm -rf $(BUILD)
