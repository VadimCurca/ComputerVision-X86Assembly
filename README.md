how to run:
nasm -f elf32 sobel.asm -o sobel.o
gcc -m32 -Wall sobel.c sobel.o -o sobel -lm -O3
./sobel
