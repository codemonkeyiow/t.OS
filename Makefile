# Makefile for two-stage bootloader

ASM      = nasm
QEMU     = qemu-system-i386
DD       = dd

BOOT_SRC   = boot.asm
STAGE2_SRC = stage2.asm
BOOT_BIN   = boot.bin
STAGE2_BIN = stage2.bin
IMG        = os.img
IMG_SIZE   = 16

# Files that stage2 depends on
STAGE2_DEPS = print_f.asm gdt.asm

.PHONY: all run clean

all: $(IMG)

$(BOOT_BIN): $(BOOT_SRC) print_f.asm
	$(ASM) -f bin $(BOOT_SRC) -o $(BOOT_BIN)

$(STAGE2_BIN): $(STAGE2_SRC) $(STAGE2_DEPS)
	$(ASM) -f bin $(STAGE2_SRC) -o $(STAGE2_BIN)

$(IMG): $(BOOT_BIN) $(STAGE2_BIN)
	@echo "Creating $(IMG_SIZE)MB disk image..."
	$(DD) if=/dev/zero of=$(IMG) bs=1M count=$(IMG_SIZE) status=none
	$(DD) if=$(BOOT_BIN) of=$(IMG) conv=notrunc status=none
	$(DD) if=$(STAGE2_BIN) of=$(IMG) bs=512 seek=1 conv=notrunc status=none
	@echo "Image ready: $(IMG)"

run: $(IMG)
	$(QEMU) -drive format=raw,file=$(IMG)

clean:
	rm -f $(BOOT_BIN) $(STAGE2_BIN) $(IMG)

help:
	@echo "make        - build os.img"
	@echo "make run    - build and run in QEMU"
	@echo "make clean  - remove generated files"
