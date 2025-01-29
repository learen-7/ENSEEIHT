#include <stdio.h>
#include <stdlib.h>
#include "affine.h"

int main() {
    double a = 0.4, b = 1.0;

    for (double x = -10.0; x <= 10.0; x += 1.0) {
        printf("f(%f) = %f\n", x, affine(a, b, x));
    }

    return 0;
}


