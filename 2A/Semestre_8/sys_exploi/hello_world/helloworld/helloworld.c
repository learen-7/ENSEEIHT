/**
 * @file helloworld.c
 *
 * @section desc File description
 *
 *
 * @section copyright Copyright
 *
 *
 * @section infos File informations
 *
 * $Date$ ven. 07 mars 2025 16:46:18 CET
 * $Rev$
 * $Author$ lht1404
 * $URL$ /home/lht1404/Documents/ENSEEIHT/2A/Semestre_8/Système d'exploitation/hello_world/helloworld
 */

#include <stdio.h>
#include <stdlib.h>
#include <hdc1000.h>
#include <hdc1000_params.h>
#include <ztimer.h>
#include <opt3001.h>
#include <opt3001_params.h>

void thread_hdc1000(void*args){
    (void) args;

    hdc1000_t device;

    hdc1000_init(&device, hdc1000_params);
    int16_t temp, humid;

    while(1){
        hdc1000_read(&device, &temp, &humid);

        printf("Temp: %d.%d \n", temp/100, temp%100);
        printf("Humidity: %d.%d \n", humid/100, humid%100);

        ztimer_sleep(ZTIMER_SEC, 5);
    }
}
char stack_hdc(1024);

void thread_opt3001(void*args){
    (void) args;

    opt3001_t device;

    opt3001_init(&device, opt3001_params);
    int16_t lum;

    while(1){
        opt3001_read_lux(&device, &lum);

        printf("Lum: %i \n", lum);

        ztimer_sleep(ZTIMER_SEC, 5);
    }
}
char stack_opt(1024);

int main(void) {
    
    thread_create(stack_hdc, sizeof(stack_hdc), THREAD_PRIORITY_MAIN - 1, THREAD_CREATE_STACKTEST,thread_hdc1000, NULL, "hdc1000 thread");
    thread_create(stack_opt, sizeof(stack_opt), THREAD_PRIORITY_MAIN - 1, THREAD_CREATE_STACKTEST,thread_opt3001, NULL, "opt3001 thread");

    
    return EXIT_SUCCESS;
}

/* End of file helloworld.c */