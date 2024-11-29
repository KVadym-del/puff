PROJECT_NAME := bootloader
VERSION := 0.1.0

ASM ?= fasm
C ?= clang
RM ?= rm
MKDIR ?= mkdir

SRC_DIR ?= src
BUILD_DIR ?= build

ASM_SRC := $(SRC_DIR)/bootloader.asm
IMG_OUTPUT := $(BUILD_DIR)/$(PROJECT_NAME).img
BIN_OUTPUT := $(BUILD_DIR)/$(PROJECT_NAME).bin

.PHONY: all build clean help

all: build

$(BIN_OUTPUT): $(ASM_SRC)
	$(MKDIR) -p $(BUILD_DIR)
	@echo "Assembling boot loader..."
	$(ASM) $(ASM_SRC) $(BIN_OUTPUT)
	@echo "Boot loader assembled successfully."

$(IMG_OUTPUT): $(BIN_OUTPUT) 
	@echo "Creating disk image..."
	@truncate -s 1440K $(IMG_OUTPUT)
	@dd if=$(BIN_OUTPUT) of=$(IMG_OUTPUT) conv=notrunc bs=512 count=1
	@echo "Disk image created successfully."

build: $(IMG_OUTPUT)

clean:
	@echo "Cleaning up build files..."
	@$(RM) -rf $(BUILD_DIR)

help:
	@echo "Available targets:"
	@echo "  all     : Build the boot loader (default)"
	@echo "  build   : Compile the boot loader"
	@echo "  clean   : Remove all build artifacts"
	@echo "  help    : Show this help message"
	@echo ""
	@echo "Environment Variables:"
	@echo "  ASM     : Assembler (default: fasm)"
