#define _POSIX_C_SOURCE 200809L
#include <sys/file.h>
#include <stdio.h>
#include <stdlib.h>
#include "readcmd.h"
#include <stdbool.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>

void traitement(int sg){
    
    int wstatus;
    pid_t pid_retour = waitpid(-1, &wstatus, 0|WNOHANG|WCONTINUED|WUNTRACED);
    if (WIFEXITED(wstatus)){
        printf("Le processus %d est terminé avec le code %d. \n", pid_retour, wstatus);
    }
    if (WIFSTOPPED(wstatus)){
        printf("Le processus %d est suspendu avec le code %d. \n", pid_retour, wstatus);
    }
    if (WIFCONTINUED(wstatus)){
        printf("Le processus %d est repris avec le code %d. \n", pid_retour, wstatus);
    }
    if (WIFSIGNALED(wstatus)){
        printf("Le processus %d a envoyé un signal avec le code %d. \n", pid_retour, wstatus);
    }
   }

int main(void) {
    bool fini= false;
    pid_t pidfork;
    struct sigaction action;

    while (!fini) {
        signal(SIGINT, SIG_IGN);
        signal(SIGTSTP, SIG_IGN);

        printf("> ");
        struct cmdline *commande= readcmd();

        if (commande == NULL) {
            // commande == NULL -> erreur readcmd()
            perror("erreur lecture commande \n");
            exit(EXIT_FAILURE);
    
        } else {

            if (commande->err) {
                // commande->err != NULL -> commande->seq == NULL
                printf("erreur saisie de la commande : %s\n", commande->err);
        
            } else {
                int indexseq= 0;
                char **cmd;
                int fd;

                while ((cmd= commande->seq[indexseq])) {
                    if (cmd[0]) {
                        if (strcmp(cmd[0], "exit") == 0) {
                            fini= true;
                            printf("Au revoir ...\n");
                        }
                        else {
                            pidfork = fork();
                            switch(pidfork){
                                case -1:
                                    /* erreur */
                                    break;
                                case 0:
                                    /* fils */
                                    signal(SIGINT, SIG_DFL);
                                    signal(SIGTSTP, SIG_DFL);
                                    if (commande -> backgrounded != 0){
                                        setpgrp();
                                    }
                                    if(commande -> in != NULL){
                                        fd = open(commande->in, O_RDONLY);
                                        dup2(fd, 0);
                                        close(fd);
                                    }
                    
                                    if(commande -> out != NULL){
                                        fd = open(commande->out, O_WRONLY|O_CREAT, 0644);
                                        dup2(fd, 1);
                                        close(fd);
                                    }

                                    execvp(cmd[0], cmd);
                                    exit(EXIT_FAILURE);
                                default:
                                    /* père */
                                    action.sa_handler = traitement;
                                    sigemptyset(&action.sa_mask);
                                    action.sa_flags = SA_RESTART;
                                    sigaction(SIGCHLD, &action, NULL);

                                    if (commande -> backgrounded == 0) {
                                        pause();
                                    }
                                    break; 
                            }
                        }
                        indexseq++;
                    }
                }
            }
        }
    }
    return EXIT_SUCCESS;

}
