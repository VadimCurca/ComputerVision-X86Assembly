In this project I implement Sobel edge detection algorithm in C and X86 assembly.  
  
Build and run:
``` bash
nasm -f elf32 sobel.asm -o sobel.o
gcc -m32 -Wall sobel.c sobel.o -o sobel -lm -O3
./sobel
```

### Demo input

![playground_1920x1080_P400](https://user-images.githubusercontent.com/80581374/173312417-54e82665-0ad6-4517-b1ea-e8c19dd924d6.png)

### Demo output

![expected_output_playground_1920x1080_P400](https://user-images.githubusercontent.com/80581374/173312515-53d814ca-efb1-40c9-ac08-cdc3037656a1.png)

