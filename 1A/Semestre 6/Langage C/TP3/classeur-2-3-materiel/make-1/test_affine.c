#include <stdio.h>
#include <stdlib.h>
#include "tests.h"
#include "affine.h"

int main() {
    INITIALIZE_TESTS();

    BEGIN_SECTION("affine")
        BEGIN_TESTI("affine/test")
            ASSERT_EQ_F(0.0, affine(0.0, 0.0, 100.0), 0.00001);
        END_TEST

        REPORT_TO_STDOUT;
    END_SECTION()

    return 0;
}


