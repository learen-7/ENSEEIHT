#define _GNU_SOURCE
#include "liste_noeud.h"
#include <stdlib.h>
#include <math.h>


struct cellule_t {
    noeud_id_t noeud;
    float distance;
    noeud_id_t precedent;
    struct cellule_t* suivant; // cellule suivante dans la liste
};

struct liste_noeud_t {
    cellule_t* top;
    cellule_t* bottom;
};


liste_noeud_t* creer_liste(){
    liste_noeud_t * liste = malloc(sizeof(liste_noeud_t));
    if (liste == NULL) {
        perror("malloc liste_noeud_t creer_liste");
        exit(EXIT_FAILURE);
    }
    liste->top = NULL;
    liste->bottom = NULL;
    return liste;
}


void detruire_liste(liste_noeud_t** liste_ptr){
    cellule_t* curr = (*liste_ptr)->top;
    while (curr != (*liste_ptr)->bottom){
        cellule_t* to_free = curr;
        curr = curr->suivant;
        to_free->suivant = NULL;
        free(to_free);
    }
    free(curr);
    (*liste_ptr)->top = NULL; 
    (*liste_ptr)->bottom = NULL;
    free(*liste_ptr);
    *liste_ptr = NULL;
}


bool est_vide_liste(const liste_noeud_t* liste){
    return (liste == NULL || (liste->top==NULL && liste->bottom==NULL));
}


bool contient_noeud_liste(const liste_noeud_t* liste, noeud_id_t noeud){
    if (! est_vide_liste(liste)){
        cellule_t* curr = liste->top;
        while (curr != liste->bottom && curr->noeud != noeud){
            curr = curr->suivant;
        }
        if (curr->noeud == noeud){
            return true;
        }
    }
    return false;
}


bool contient_arrete_liste(const liste_noeud_t* liste, noeud_id_t source, noeud_id_t destination){
    return (contient_noeud_liste(liste, destination) 
        && (precedent_noeud_liste(liste, destination) == source));
}


float distance_noeud_liste(const liste_noeud_t* liste, noeud_id_t noeud){
    if (est_vide_liste(liste)){
        return INFINITY;
    }
    cellule_t* curr = liste->top;
    while (curr != liste->bottom && curr->noeud != noeud){
        curr = curr->suivant;
    }
    if (curr->noeud == noeud){
        return curr->distance;
    } else {
        return INFINITY;
    }
}

noeud_id_t precedent_noeud_liste(const liste_noeud_t* liste, noeud_id_t noeud){
    if (est_vide_liste(liste)){
        return NO_ID;
    }
    cellule_t* curr = liste->top;
    while (curr != liste->bottom && curr->noeud != noeud){
        curr = curr->suivant;
    }
    if (curr->noeud == noeud){
        return curr->precedent;
    } else {
        return NO_ID;
    }
}

noeud_id_t min_noeud_liste(const liste_noeud_t* liste){
    if (est_vide_liste(liste)){
        return NO_ID;
    }
    cellule_t* curr = liste->top;
    cellule_t* cell_min_dist = curr;
    while (curr != liste->bottom){
        curr = curr->suivant;
        if (curr->distance < cell_min_dist->distance){
            cell_min_dist = curr;
        }
    }
    return cell_min_dist->noeud;
}

void inserer_noeud_liste(liste_noeud_t* liste, noeud_id_t noeud, noeud_id_t precedent, float distance){
    cellule_t * new_cell = malloc(sizeof(cellule_t));
    if (new_cell == NULL){
        perror("malloc cellule_t inserer_noeud_liste");
        exit(EXIT_FAILURE);
    }
    new_cell->noeud = noeud;
    new_cell->precedent = precedent;
    new_cell->distance = distance;
    new_cell->suivant = NULL;

    if (est_vide_liste(liste)){ // à vérifier mais normalement c'est bon
        liste->top = new_cell;
        liste->bottom = new_cell;
    } else {
        liste->bottom->suivant = new_cell;
        liste->bottom = new_cell;
    }
}


void changer_noeud_liste(liste_noeud_t* liste, noeud_id_t noeud, noeud_id_t precedent, float distance){  
    cellule_t* curr = liste->top;
    // != NULL permet de ne pas ecrire un if est_vide_liste(liste) etc. au début
    while (curr != NULL && curr != liste->bottom && curr->noeud != noeud){
        curr = curr->suivant;
    }
    if (curr != NULL && curr->noeud == noeud){// le noeud est dans la liste
        curr->distance = distance;
        curr->precedent = precedent;
    } else { // noeud pas dans la liste
        inserer_noeud_liste(liste,noeud,precedent,distance);
    }
}

/**
 * detruire_cell : libère la mémoire d'une cellule
 * 
*/
void detruire_cell(cellule_t ** cellule){
    (*cellule)->suivant = NULL;
    free(*cellule);
    cellule = NULL;
}

void supprimer_noeud_liste(liste_noeud_t* liste, noeud_id_t noeud){
    if (! est_vide_liste(liste)){
        cellule_t * to_del = NULL;
        if (liste->top->noeud == noeud){
            to_del = liste->top;
            if (to_del == liste->bottom){ // un seul noeud dans liste
                liste->bottom = NULL;
                liste->top = NULL;
                detruire_cell(&to_del);
            } else {
                liste->top = to_del->suivant;
                detruire_cell(&to_del);
            }
        } else {
            cellule_t* curr = liste->top;
            // curr->suivant == NULL => curr == liste->bottom
            while ((curr->suivant != NULL) 
                && (curr->suivant != liste->bottom) 
                && (curr->suivant->noeud != noeud)){
                    curr = curr->suivant;
            }
            if (curr->suivant->noeud == noeud){
                to_del = curr->suivant;
                curr->suivant = to_del->suivant;
                if (liste->bottom == to_del){
                    liste->bottom = curr;
                }
                detruire_cell(&to_del);
            }
        }
    }
}





