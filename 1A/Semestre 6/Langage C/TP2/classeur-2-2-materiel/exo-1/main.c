#include <stdio.h>
#include <stdlib.h>
#include "tab.h"

// Macros pour les options du programme

int main() {
    int choice;
    tab_t* tab = creer();
    float occupation;
    int elt;
    int boucle = 1;
    while(boucle){ // while true
        occupation = (taille(tab) / espace(tab))*100;
        afficher(tab);
        printf("Taux d'occupation : %f\n", occupation);
        printf("0. Quitter\n1. Ajouter un élément\n2. Supprimer un élément\n");
        printf("Choix : ");
        scanf("%d",&choice);
        switch (choice){
        case 1:
            printf("Elément à ajouter :");
            scanf("%d",&elt);
            ajouter(tab,elt);
            break;
        case 2:
            printf("Elément à supprimer : ");
            scanf("%d",&elt);
            supprimer(tab,elt);
            break;
        default:
            boucle = 0;
            break;
        }
    }
    return 0;
}


