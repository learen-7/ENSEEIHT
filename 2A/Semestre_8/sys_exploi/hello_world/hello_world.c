/**
 * @file hello_world.c
 *
 * @section desc File description
 *
 *
 * @section copyright Copyright
 *
 *
 * @section infos File informations
 *
 * $Date$ ven. 28 févr. 2025 16:27:40 CET
 * $Rev$
 * $Author$ lht1404
 * $URL$ /home/lht1404/hello_world
 */

#include "contiki.h"
#include "board-peripherals.h"
#include <stdio.h>
#include <stdint.h>
#include <sys/etimer.h>
#include "lib/sensors.h"


PROCESS(hello_world_process, "hello_world process");
PROCESS(pressure_process, "humidity process");
AUTOSTART_PROCESSES(&hello_world_process, &pressure_process);

PROCESS_THREAD(hello_world_process, ev, data) 
{
    PROCESS_BEGIN();
    static struct etimer timer;
    int temp;
    int humidity;

    SENSORS_ACTIVATE(hdc_1000_sensor);

    
    etimer_set(&timer, CLOCK_SECOND * 10);

    while(1){
        SENSORS_ACTIVATE(hdc_1000_sensor);
        
        PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&timer));
        etimer_reset(&timer);
        
        humidity = hdc_1000_sensor.value(HDC_1000_SENSOR_TYPE_HUMID);
        temp = hdc_1000_sensor.value(HDC_1000_SENSOR_TYPE_TEMP);

        printf("Temp: %d.%d \n", temp/100, temp%100);
        printf("Humidity: %d.%d \n", humidity/100, humidity%100);

    }
    

    PROCESS_END();
}

PROCESS_THREAD(pressure_process, ev, data) 
{
    PROCESS_BEGIN();
    static struct etimer timer;
    int pressure;

    SENSORS_ACTIVATE(bmp_280_sensor);

    
    etimer_set(&timer, CLOCK_SECOND * 4);

    while(1){
        SENSORS_ACTIVATE(bmp_280_sensor);
        
        PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&timer));
        etimer_reset(&timer);
        
        pressure = bmp_280_sensor.value(BMP_280_SENSOR_TYPE_PRESS);

        printf("Pressure: %d.%d \n", pressure/100, pressure%100);

    }
    

    PROCESS_END();
}