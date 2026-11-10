CROSS_COMPILE ?= gcc

TOOL_INSTALL=aarch64-none-linux-gnu-

all:
ifeq ($(CROSS_COMPILE), aarch64-none-linux-gnu-gcc)
	$(CROSS_COMPILE) -Wall -o writer writer.c
else
	$(CROSS_COMPILE) -Wall -o writer writer.c
endif


.PHONY : clean
clean:
	rm -rf *.o
	rm -rf *.txt
	rm -rf writer
