#define _POSIX_C_SOURCE 200809L
#include <sys/file.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>

#define BUFSIZE 2048

int main(int argc, char const *argv[])
{
    if (argc != 3){
        fprintf(stderr, "Usage : %s source dest \n", argv[0]);
        exit(EXIT_FAILURE);
    }

    char tmp[BUFSIZE];
    int src, dest, tube[2], nb_lu;

    if(pipe(tube) == -1){
        perror("erreur création tube \n");
        exit(EXIT_FAILURE);
    }

    switch(fork()){
        case -1 :
            perror("erreur fork \n");
            exit(EXIT_FAILURE);
            break;

        case 0 :
            /* fils */
            close(tube[0]);
            if((src = open(argv[1], O_RDONLY))==-1){
                perror("erreur ouverture source \n");
                exit(EXIT_FAILURE);
            }
            
            while((nb_lu = read(src, tmp, sizeof(char)*BUFSIZE)) > 0){
                write(tube[1], tmp, nb_lu);
            }
            close(src);
            close(tube[1]);
            break;

        default:
            /* père */
            close(tube[1]);
            if ((dest = open(argv[2], O_WRONLY|O_CREAT, 0644))==-1){
                perror("erreur ouverture destination \n");
                exit(EXIT_FAILURE);
            }
            while((nb_lu = read(tube[0], tmp, sizeof(char)*BUFSIZE)) > 0){
                write(dest, tmp, nb_lu);
            }
            close(dest);
            close(tube[0]);
            break;       
    }
}
