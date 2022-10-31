# CS 218 Assignment #11
# Simple make file for asst #11

OBJS_SM	= makeThumb.o a11procsSM.o
OBJS_LG	= makeThumb.o a11procsLG.o
ASM	= yasm -g dwarf2 -f elf64
CC	= g++ -g -std=c++11

all:	sed makeThumbLG	makeThumbSM

sed:
	@sed -e "s/BUFF_SIZE\tequ\t750000/BUFF_SIZE\tequ\t3/" \
					a11procs.asm > a11procsSM.asm

makeThumb.o: makeThumb.cpp
	$(CC) -c makeThumb.cpp

a11procsSM.o: a11procsSM.asm
	$(ASM) a11procsSM.asm -l a11procsSM.lst -o a11procsSM.o

a11procsLG.o: a11procs.asm
	$(ASM) a11procs.asm -l a11procs.lst -o a11procsLG.o

makeThumbSM: $(OBJS_SM)
	$(CC) -no-pie -o makeThumbSM $(OBJS_SM)

makeThumbLG: $(OBJS_LG)
	$(CC) -no-pie -o makeThumbLG $(OBJS_LG)

# -----
# clean by removing object files and list files.

clean:
	@rm  -f $(OBJS_LG)
	@rm  -f $(OBJS_SM)
	@rm  -f a11procs.lst
	@rm  -f a11procsSM.lst
