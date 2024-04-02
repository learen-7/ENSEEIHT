#include "complexe.h"
#include <math.h>           // Pour certaines fonctions trigo notamment

// Implantations de reelle et imaginaire
double reelle (complexe_t complexe){
    return complexe.reel;
}
double imaginaire (complexe_t complexe){
    return complexe.imaginaire;
}

// Implantations de set_reelle et set_imaginaire
void set_reelle(complexe_t* complexe, double reel){
    complexe->reel = reel;
}

void set_imaginaire(complexe_t* complexe, double imaginaire){
    complexe->imaginaire = imaginaire;
}

void init (complexe_t* complexe, double reel, double imaginaire){
    set_reelle(complexe,reel);
    set_imaginaire(complexe, imaginaire);
}

// Implantation de copie
void copie(complexe_t* resultat, complexe_t autre){
    set_reelle(resultat, reelle(autre));
    set_imaginaire(resultat, imaginaire(autre));

}

// Implantations des fonctions algébriques sur les complexes
void conjugue(complexe_t* resultat, complexe_t op){
    set_reelle(resultat, reelle(op));
    set_imaginaire(resultat, -imaginaire(op));
}

void ajouter(complexe_t* resultat, complexe_t gauche, complexe_t droite){
    set_reelle(resultat, reelle(gauche) + reelle(droite));
    set_imaginaire(resultat, imaginaire(gauche) + imaginaire(droite));
}

void soustraire(complexe_t* resultat, complexe_t gauche, complexe_t droite){
    set_reelle(resultat, reelle(gauche) - reelle(droite));
    set_imaginaire(resultat, imaginaire(gauche) - imaginaire(droite));
}

void multiplier(complexe_t* resultat, complexe_t gauche, complexe_t droite){
    set_reelle(resultat, reelle(gauche) * reelle(droite) - imaginaire(gauche) * imaginaire(droite));
    set_imaginaire(resultat, imaginaire(gauche) * reelle(droite) + reelle(gauche) * imaginaire(droite));
}

void echelle(complexe_t* resultat, complexe_t op, double facteur){
    set_reelle(resultat, facteur * reelle(op));
    set_imaginaire(resultat, facteur * imaginaire(op));
}

void puissance(complexe_t* resultat, complexe_t op, int exposant){
    if (exposant == 0){
        init(resultat, 1,0);
    } else {
        copie(resultat, op);
        for (int i=1; i<exposant; i++){
            multiplier(resultat, *resultat, op);
    }   }
}


// Implantations du module et de l'argument
double module_carre (complexe_t op){
    return reelle(op)*reelle(op) + imaginaire(op)*imaginaire(op);
}

double module (complexe_t op){
    return sqrt(module_carre(op));
}

double argument (complexe_t op){
    return acos(reelle(op) / module(op));   
}


