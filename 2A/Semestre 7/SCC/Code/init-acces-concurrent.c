/**
 * @file usr/init.c
 * @brief L'init du monde utilisateur
 * 
 * Attention, ici les include sont dans usr/include !!!
 */
#include <manux/types.h>
#include <stdio.h>
#include <manux/errno.h>
#include <unistd.h>   // creerNouvelleTache
#include <manux/string.h>

/**
 * @brief Taille du buffer utilisé en lecture
 */ 
#define TAILLE_BUFFER 16

/**
 * @brief Nombres de lecteurs et écrivains
 */ 
#define NB_LECTEURS  10
#define NB_ECRIVAINS 10

int fd[2];  // Le tube

void lecteur()
{
   int r, c=0;
   char b[TAILLE_BUFFER];
   
   printf("[%d] Je suis un lecteur !\n", identifiantTache());
   fermer(fd[1]); // comme on est un lecteur on ferme l'accès à l'écriture du tube
   
   do {
      r = lire(fd[0], b, TAILLE_BUFFER - 1);
      printf("[%d] lecture %d\n", identifiantTache(), r);
      if (r > 0) {
         b[r] = 0;
         printf(b);
         c += r;
      } else if (r < 0){
	printf("[%d] Erreur lecture\n", identifiantTache());
      }

      basculerTache(); // On bascule de tache pour plus d'équité
   } while (r > 0);

   printf("\n[%d] Fini ... En tout, j'ai lu %d !\n", identifiantTache(), c);
   fermer(fd[0]); // On a finit notre tâche, on ferme l'accès à la lecture du tube
}

void ecrivain()
{
   int r, c  = 0;
   int cpt =10; // On initialise un compteur
   
   char * b = "Bonjour les jeunes ! ";

   printf("[%d] Je suis un ecrivain !\n", identifiantTache());
   fermer(fd[0]); // on est un écrivain donc on ferme l'accès lecture du tube

   do {
   cpt--; // on décrémente le compteur
     printf("[%d] Je vais ecrire %d\n", identifiantTache(), strlen(b));
      r = ecrire(fd[1], b, strlen(b));
      printf("[%d] Voila j'ai ecrit %d\n", identifiantTache(), r);
      if (r >= 0) {
         c += r;
      } else {
         printf("[%d] Erreur ecriture\n", identifiantTache());
      }
   } while (r > 0); // while(cpt>0) -> on écrit jusqu'à ce que le compteur soit à 0, on écrit donc cpt-fois dans le tube

   printf("[%d] En tout, j'ai ecrit %d !\n", identifiantTache(), c);
   fermer(fd[1]); // on ferme l'accès à l'écriture du tube
}

void init()
{
  int r, l, e;

   printf("Bonjour le mode utilisateur !\n");

   r = tube(fd);

   if ( r != ESUCCES) {
      printf("r = %d : casse la pipe !?\n", r);
   } else {
      for (e = 0; e < NB_ECRIVAINS; e++) {
         r = creerNouvelleTache(ecrivain, FALSE);
      }
      for (l = 0; l < NB_LECTEURS; l++) {
         r = creerNouvelleTache(lecteur, FALSE);
      }
   }

   fermer(fd[0]);
   fermer(fd[1]);
   printf("Voila voila !\n");
   while(1){};
}
