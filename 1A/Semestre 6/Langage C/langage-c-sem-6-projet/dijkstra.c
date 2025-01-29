#include "dijkstra.h"
#include <stdlib.h>
#include <math.h>

/**
 * construire_chemin_vers - Construit le chemin depuis le noeud de départ donné vers le
 * noeud donné. On passe un chemin en entrée-sortie de la fonction, qui est mis à jour
 * par celle-ci.
 *
 * Le noeud de départ est caractérisé par un prédécesseur qui vaut `NO_ID`.
 *
 * Ce sous-programme fonctionne récursivement :
 *  1. Si le noeud a pour précédent `NO_ID`, on a fini (c'est le noeud de départ, le chemin de
 *     départ à départ se compose du simple noeud départ)
 *  2. Sinon, on construit le chemin du départ au noeud précédent (appel récursif)
 *  3. Dans tous les cas, on ajoute le noeud au chemin, avec les caractéristiques associées dans visites
 *
 * @param chemin [in/out] chemin dans lequel enregistrer les étapes depuis le départ vers noeud
 * @param visites [in] liste des noeuds visités créée par l'algorithme de Dijkstra
 * @param noeud noeud vers lequel on veut construire le chemin depuis le départ
 */

void construire_chemin_vers(liste_noeud_t* chemin, liste_noeud_t* visites, noeud_id_t noeud){
    noeud_id_t np = precedent_noeud_liste(visites, noeud);
    if (np != NO_ID){
        construire_chemin_vers(chemin, visites, np);
        inserer_noeud_liste(chemin, np, precedent_noeud_liste(visites, np), distance_noeud_liste(visites, np));
    }
} 


float dijkstra(
    const struct graphe_t* graphe, 
    noeud_id_t source, noeud_id_t destination, 
    liste_noeud_t** chemin) {
    
    liste_noeud_t * AVisiter = creer_liste();
    liste_noeud_t * Visite = creer_liste();
    float distance_chemin;

    inserer_noeud_liste(AVisiter, source, NO_ID, 0);

    while (!est_vide_liste(AVisiter)){
        noeud_id_t nc = min_noeud_liste(AVisiter);
        inserer_noeud_liste(Visite, nc, precedent_noeud_liste(AVisiter, nc), distance_noeud_liste(AVisiter, nc));
        supprimer_noeud_liste(AVisiter, nc);
        noeud_id_t * voisins = malloc(nombre_voisins(graphe,nc) * sizeof(noeud_id_t));
        if (voisins == NULL){
            perror("malloc noeud_id_t voisins dijkstra");
            exit(EXIT_FAILURE);
        }
        noeuds_voisins(graphe, nc, voisins);
        for (size_t i=0 ; i<nombre_voisins(graphe,nc); i++){
            noeud_id_t nv = voisins[i];
            if (!contient_noeud_liste(Visite, nv)){
                float delta_prime = distance_noeud_liste(Visite, nc) + noeud_distance(graphe, nc, nv);
                float delta = distance_noeud_liste(AVisiter, nv);
                if (delta_prime < delta){
                    changer_noeud_liste(AVisiter, nv, nc, delta_prime);
                }
            }
        }
        free(voisins);
    }
    detruire_liste(&AVisiter);
    
    if (chemin != NULL){
        *chemin = creer_liste();
        inserer_noeud_liste(*chemin,destination,precedent_noeud_liste(Visite,destination),distance_noeud_liste(Visite,destination));
        inserer_noeud_liste(*chemin,source,precedent_noeud_liste(Visite,source),distance_noeud_liste(Visite,source));
        construire_chemin_vers(*chemin, Visite, destination);
        distance_chemin = distance_noeud_liste(*chemin, destination);
    } else {
        distance_chemin = distance_noeud_liste(Visite,destination);// ça marche mais pk ???
    }

    detruire_liste(&Visite);
    return distance_chemin;
}