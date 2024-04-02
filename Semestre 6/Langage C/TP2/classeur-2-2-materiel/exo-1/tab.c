#include "tab.h"
#include <stdlib.h>
#include <stdio.h>

static const int INIT_SIZE = 4;

/**
 * Type enregistrement tab_t, avec pour champs
 *  - un champ pour le contenu du tableau (tableau d'entiers dans le tas)
 *  - taille allouée du tableau
 *  - taille utilisée du tableau
 */
struct tab_t {
    int* tableau;
    int taille;
    int nbr_elem;
};
typedef struct tab_t tab_t;

/**
 * creer - crée un tab_t avec une taille allouée initiale de 4 et une taille utilisée de 0.
 * Le contenu du tab_t est un tableau alloué dans le tas (de taille 4 initialement)
 *
 * Post-condition : 
 *   - le champ contenu du tab_t est non-NULL et est dans le tas
 *   - taille(resultat) == 0
 *   - espace(resultat) == 4
 *
 * @return tab_t nouvellement créé
 */
tab_t* creer() {
    tab_t* tab = malloc(sizeof(tab_t));
    tab->tableau = malloc(INIT_SIZE * sizeof(int));
    tab->taille = INIT_SIZE;
    tab->nbr_elem = 0;
    return tab;
}

/**
 * detruire - détruit le tab_t, c'est-à-dire libère son contenu alloué dans le tas.
 *
 * Pré-conditions : tab != NULL, contenu de tab valide (non NULL et pas déjà libéré)
 * Post-conditions : contenu de tab == NULL, mémoire libérée
 *
 * @param tab [in,out] tab_t à détruire
 */
void detruire(tab_t** tab) {
    free((*tab)->tableau);
    free(*tab);
    return;
}

/**
 * ajouter - ajoute un élément à la fin du tab_t, en réallouant le contenu si besoin
 *
 * Pré-conditions : tab != NULL, tab non détruit
 * Post-conditions : 
 *   - element(tab, taille(tab) - 1) == elt
 *   - taille(tab) == \old(taille(tab)) + 1
 *   - si \old(taille(tab)) == \old(espace(tab)), alors espace(tab) == 2 * espace(tab)
 *
 * @param tab [in,out] tab_t dans lequel ajouter l'élément
 * @param elt élément à rajouter
 */
void ajouter(tab_t* tab, int elt) {
    if(tab->nbr_elem == tab->taille){
        int* tmp = realloc(tab->tableau, (tab->taille * 2));
        if(tmp != NULL){
            tab->tableau = tmp;
            tab->taille *= 2;
        } else {
            //error during realloc
            printf("error during ajouter");
            exit(-1);
        }
    }
    tab->tableau[tab->nbr_elem] = elt;
    tab->nbr_elem ++;
    return;
}

/**
 * supprimer - supprimer la première occurence d'un élément s'il existe, ou laisse le
 * tableau inchangé si l'élément n'existe pas.
 *
 * Pré-conditions : tab != NULL, tab non détruit
 * Post-conditions : 
 *   - si elt n'appartient pas à tab, taille(tab) == \old(taille(tab))
 *   - sinon, taille(tab) == \old(taille(tab)) - 1 et nombre d'occurrences de elt dans tab réduit de 1
 *   - espace(tab) == \old(espace(tab))
 *
 * @param tab [in,out] tab_t duquel supprimer l'élément
 * @param elt élément à supprimer
 */
void supprimer(tab_t* tab, int elt) {
    int iterrator = 0;
    while((iterrator < tab->nbr_elem)&&(tab->tableau[iterrator] != elt)){
        iterrator ++;
    }
    if(tab->tableau[iterrator] == elt){ // elt is in tab->tableau
        for(;iterrator< tab->nbr_elem-1; iterrator ++){
            int tmp = tab->tableau[iterrator];
            tab->tableau[iterrator] = tab->tableau[iterrator+1];
            tab->tableau[iterrator+1] = tmp;
        }
        tab->nbr_elem --;
    }
    return;
}

/**
 * element - récupère l'ième élément dans le tableau.
 *
 * Pré-conditions : tab non détruit, 0 <= id < tab.taille_utilisee
 *
 * @param tab [in] tab dans lequel chercher l'élément
 * @param id indice à récupérer
 */
int element(tab_t* tab, int id) {
    return tab->tableau[id];
}

/**
 * taille - récupère la taille (utilisée) du tableau.
 * 
 * Pré-conditions : tab non détruit
 * Post-conditions : resultat >= 0
 *
 * @return taille du tableau (nombre d'éléments)
 */
int taille(tab_t* tab) {
    return tab->nbr_elem;
}

/**
 * espace - récupère la taille (en mémoire) du tableau.
 *
 * Pré-conditions : tab non détruit
 * Post-conditions : resultat > 0
 *
 * @return espace occupé par le tableau
 */
int espace(tab_t* tab) {
    return tab->taille;
}

/**
 * serrer - réalloue le tableau de façon à ce que la taille allouée soit égale à
 * la taille utilisée.
 *
 * Pré-conditions : tab != NULL, tab non-détruit
 *  => /!\ taille(tab) peut être égale à 0
 * Post-conditions :
 *   - si taille(tab) > 0 alors taille(tab) == espace(tab)
 *   - sinon, espace(tab) == \old(espace(tab))
 *
 * @param tab [in,out] tab_t à réallouer
 */
void serrer(tab_t* tab) {
    if(tab->nbr_elem >0){
        int* tmp = realloc(tab->tableau, (tab->nbr_elem));
        if(tmp!=NULL){
            tab->tableau = tmp;
            tab->taille = tab->nbr_elem;
        } else {
            // error during realloc
            printf("error during serrer");
            exit(-1);
        }
    }
    return;
}

void afficher(tab_t* tab){
    int size = taille(tab);
    printf("Tableau : [");
    for (int i = 0; i < size; i++)
    {
        printf(" %d,", element(tab,i));
    }
    printf("]\n");
    
    return;
}

