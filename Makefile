#******************************************************************************
# Copyright (C) 2017 by Alex Fosdick - University of Colorado
#
# Redistribution, modification or use of this software in source or binary
# forms is permitted as long as the files maintain this copyright. Users are 
# permitted to modify this and use it to learn about the field of embedded
# software. Alex Fosdick and the University of Colorado are not liable for any
# misuse of this material. 
#
#*****************************************************************************

#------------------------------------------------------------------------------
# <Put a Description Here>
#
# Use: make [TARGET] [PLATFORM-OVERRIDES]
#
# Build Targets:
#     
#
# Platform Overrides:
#     Put a description of the supported Overrides here
#
#------------------------------------------------------------------------------
include sources.mk

# Platform Overrides

ifeq ($(PLATFORM),HOST)
	LINKER_FILE = msp432p401r.lds 
	CC = gcc
 	TARGET = c1m2
	LDFLAGS = -Wl,-Map=$(TARGET).map -T $(LINKER_FILE) 
	CFLAGS = -std=c99 -Werror -Wall -g -D$(PLATFORM)
	CPPFLAGs =          \
          	   -I./CMSIS \
	     	   -I./common \
	     	   -I./msp432
       # etc
else
	#Architectures Specific Flags
	CPU = cortex-m4
	ARCH = thumb
	SPECS = nosys.specs
	M_ARCH=armv7e-m
	ABI=hard
	FPU=fpv4-sp-d16
	LINKER_FILE = msp432p401r.lds 
        CC = arm-none-eabi-gcc
	LD = arm-none-eabi-ld
	TARGET = c1m2
	LDFLAGS = -Wl,-Map=$(TARGET).map -T $(LINKER_FILE) 
	CFLAGS = -std=c99 -Werror -mcpu=$(CPU) -m$(ARCH) --specs=$(SPECS) -march=$(M_ARCH) -mfloat-abi=$(ABI) -mfpu=$(FPU) -Wall -g -D$(PLATFORM)
	CPPFLAGs =          \
            	   -I./CMSIS \
	     	   -I./common \
	     	   -I./msp432

        # etc
endif 

# Compiler Flags and Defines

OBJS = $(SOURCES:.c=.o)

%.o : %.c
	$(CC) -c $< $(CPPFLAGs) $(CFLAGS) -o $@



.PHONY: build
build: $(TARGET).out
$(TARGET).out: $(OBJS)
	$(CC) $(OBJS) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $@
	

.PHONY: clean
clean:
	rm -f $(OBJS) $(TARGET).out $(TARGET).map $(TARGET).i $(TARGET).asm $(I) $(ASM)

