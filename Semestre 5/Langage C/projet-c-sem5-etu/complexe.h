#ifndef COMPLEX_H
#define COMPLEX_H

// Type utilisateur complexe_t
typedef struct complexe
{
    double reel;
    double imaginaire;
} complexe_t;


// Fonctions reelle et imaginaire
/**
 * reelle
 * fonction qui renvoie la partie réelle d'un nombre complexe
 *
 * pre-condition complexe not null
 * 
 * @param complexe [in] un nombre complexe
 */ double reelle (complexe_t complexe);

/**
 * imaginaire
 * fonction qui renvoie la partie imaginaire d'un nombre complexe
 *
 * pre-condition complexe not null
 * 
 * @param complexe [in] un nombre complexe
 */ double imaginaire (complexe_t complexe);

// Procédures set_reelle, set_imaginaire et init
/**
 * set_reelle
 * modifie la partie réelle d'un complexe
 * 
 * pre-condition complexe et reel not null
 * 
 * post-condition reelle(*complexe) == reel 
 * 
 * @param complexe [out] un pointeur sur le nombre à modifier
 * @param reel     [in] la nouvelle valeur de la partie réelle
 */
void set_reelle (complexe_t* complexe,  double reel);

/**
 * set_imaginaire
 * modifie la partie imaginaire d'un complexe
 * 
 * pre-condition complexe et imaginaire not null
 * 
 * post-condition imaginaire(*complexe) == imaginaire
 * 
 * @param complexe  [out] un pointeur sur le nombre à modifier
 * @param imaginaire [in] la nouvelle valeur de la partie imaginaire
 */
void set_imaginaire (complexe_t* complexe,  double imaginaire);

/**
 * init
 * modifie les parties réelle et imaginaire du complexe donné
 * 
 * pre-condition les paramètre ne sont pas null
 * post-condition reelle(*complexe) == reel && imaginaire(*complexe) == imaginaire
 * 
 * @param complexe [out] un pointeur sur le nombre à modifier
 * @param reel      [in] la nouvelle valeur de la partie réelle
 * @param imaginaire [in] la nouvelle valeur de la partie imaginaire
 */
void init (complexe_t* complexe, double reel, double imaginaire);

// Procédure copie
/**
 * copie
 * Copie les composantes du complexe donné en second argument dans celles du premier
 * argument
 *
 * Paramètres :
 *   resultat       [out] Complexe dans lequel copier les composantes
 *   autre          [in]  Complexe à copier
 *
 * Pré-conditions : resultat non null
 * Post-conditions : resultat et autre ont les mêmes composantes
 */
void copie(complexe_t* resultat, complexe_t autre);

// Algèbre des nombres complexes
/**
 * conjugue
 * Calcule le conjugué du nombre complexe op et le sotocke dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe dont on veut le conjugué
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : reelle(*resultat) = reelle(op), complexe(*resultat) = - complexe(op)
 */
void conjugue(complexe_t* resultat, complexe_t op);

/**
 * ajouter
 * Réalise l'addition des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche + droite
 */
void ajouter(complexe_t* resultat, complexe_t gauche, complexe_t droite);

/**
 * soustraire
 * Réalise la soustraction des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche - droite
 */
void soustraire(complexe_t* resultat, complexe_t gauche, complexe_t droite);

/**
 * multiplier
 * Réalise le produit des deux nombres complexes gauche et droite et stocke le résultat
 * dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   gauche         [in]  Opérande gauche
 *   droite         [in]  Opérande droite
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = gauche * droite
 */
void multiplier(complexe_t* resultat, complexe_t gauche, complexe_t droite);

/**
 * echelle
 * Calcule la mise à l'échelle d'un nombre complexe avec le nombre réel donné (multiplication
 * de op par le facteur réel facteur).
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe à mettre à l'échelle
 *   facteur        [in]  Nombre réel à multiplier
 *
 * Pré-conditions : resultat non-null
 * Post-conditions : *resultat = op * facteur
 */
void echelle(complexe_t* resultat, complexe_t op, double facteur);

/**
 * puissance
 * Calcule la puissance entière du complexe donné et stocke le résultat dans resultat.
 *
 * Paramètres :
 *   resultat       [out] Résultat de l'opération
 *   op             [in]  Complexe dont on veut la puissance
 *   exposant       [in]  Exposant de la puissance
 *
 * Pré-conditions : resultat non-null, exposant >= 0
 * Post-conditions : *resultat = op * op * ... * op
 *                                 { n fois }
 */
void puissance(complexe_t* resultat, complexe_t op, int exposant);

// Module et argument
/**
 * module_carre
 * retourne le carré du module de op
 * 
 * pre-condition op non null
 * post-condition result = op.reel**2 + op.imaginaire**2
 * 
 * @param op  [in] le nombre complexe dont on veut calculer le module_carre
 */
double module_carre (complexe_t op);

/**
 * module
 * retourne le module de op
 * 
 * pre-condition op non null
 * post-condition result = sqrt(module_carre(op))
 * 
 * @param op [in] le nombre complexe dont on veut calculer le module
 */
double module (complexe_t op);

/**
 * argument
 * retourne l'argument de op
 * 
 * pre-condition op non null
 * post-condition result = acos(reelle(op) / module(op))
 * 
 * @param op [in] le nombre complexe dont on veut calculer l'argument
 */
double argument (complexe_t op);


#endif // COMPLEXE_H



