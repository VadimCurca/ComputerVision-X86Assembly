#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <time.h>
#include <stdint.h>
#include <math.h>

#define WIDTH 1920
#define HEIGTH 1080
#define inImgName   "playground_1920x1080_P400.yuv"
#define outImgName  "output_playground_1920x1080_P400.yuv"

#define imgSize (WIDTH*HEIGTH)

//input bufferul este putin mai mare pentru a nu verifica daca se iese din marginile imaginii
uint8_t inImg[imgSize + (WIDTH*2)];
uint8_t outImg[imgSize];

void sobel(uint8_t* in, uint8_t* out, uint32_t width){
#define CLAMP(x) ((x) < 255 ? (x) : 255);

    const int xSobel[3][3] = {{-1, 0, 1},
                            {-2, 0, 2},
                            {-1, 0, 1}};

    const int ySobel[3][3] = {{-1, -2, -1},
                            { 0, 0,  0},
                            { 1, 2,  1}};

    int i;
    uint8_t *lines[3];

    int vx = 0, vy = 0;

    lines[0] = (uint8_t *)in;
    lines[1] = (uint8_t *)(in+WIDTH);
    lines[2] = (uint8_t *)(in+2*WIDTH);

    for(i = 0; i < width; i++){
        vx = xSobel[0][0] * lines[0][i-1] + xSobel[0][1] * lines[0][i] + xSobel[0][2] * lines[0][i+1] +
             xSobel[1][0] * lines[1][i-1] + xSobel[1][1] * lines[1][i] + xSobel[1][2] * lines[1][i+1] +
             xSobel[2][0] * lines[2][i-1] + xSobel[2][1] * lines[2][i] + xSobel[2][2] * lines[2][i+1];

        vy = ySobel[0][0] * lines[0][i-1] + ySobel[0][1] * lines[0][i] + ySobel[0][2] * lines[0][i+1] +
             ySobel[1][0] * lines[1][i-1] + ySobel[1][1] * lines[1][i] + ySobel[1][2] * lines[1][i+1] +
             ySobel[2][0] * lines[2][i-1] + ySobel[2][1] * lines[2][i] + ySobel[2][2] * lines[2][i+1];

        out[i] = (uint8_t)CLAMP(sqrt(vx*vx + vy*vy));
    }
}

void readImg(uint8_t* buffer){
    FILE * File;

    File = fopen(inImgName, "rb");
    int size;
    size = fread(buffer, sizeof(inImg[0]), imgSize, File);
    if(size != imgSize){
        printf("An error accured while reading the image\n");
        exit(1);
    }

    fclose(File);
}

void writeImg(uint8_t* buffer){
    FILE * File;

    File = fopen(outImgName, "wb");
    int size;
    size = fwrite(buffer, sizeof(outImg[0]), imgSize, File);
    if(size != imgSize){
        printf("An error accured while writing the image");
        exit(1);
    }
    fclose(File);
}

int main(){
    readImg(inImg);
    sobel(inImg, outImg, imgSize);
    writeImg(outImg);
}
