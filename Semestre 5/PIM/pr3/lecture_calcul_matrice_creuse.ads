with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;

generic
      NbPage : Integer;

package lecture_calcul_matrice_creuse is

   type T_Cellule;
   type T_Matrice_Creuse;
   type T_Matrice;
   type T_Vecteur;
   type T_Vecteur_Colonne;

   
   -- Initialiser la matrice creuse
   procedure Initialiser (M : out T_Matrice_Creuse);
   
   -- Detuire la matrice creuse
   procedure Detruire (M : in out T_Matrice_Creuse);
   
   -- Enregistrer une nouvelle cellule dans la matrice creuse
   procedure Enregistrer (M : in out T_Matrice_Creuse ; Valeur : in Float ; Nouvelle_Cellule : out T_Matrice_Creuse;
			  Ligne : in Integer ; Colonne : in Integer);

   -- Ouvrir le fichier graphe et transcrire les donnees dans une matrice page
   procedure Lire (NomFichier : in Unbounded_String;
		   Page : out T_Matrice_Creuse;
		   Vecteur_Colonne : out T_Vecteur_Colonne);

   function Calculer_S (Page : in out T_Matrice_Creuse ; Vecteur_Colonne : in out T_Vecteur_Colonne) return T_Matrice_Creuse;

   -- Pre condition NbIte > 2
   function Calculer_Pi (S : in T_Matrice_Creuse ; alpha : in Float ; NbIte : in Integer;
			 Vecteur_Colonne : in T_Vecteur_Colonne) return T_Vecteur;

   -- Classer Pi par ordre decroissant des poids
   procedure Classer (Pi : in out T_Vecteur ; Poids : out T_Vecteur ; Classement : out T_Vecteur);
   
      -- Ecrire le fichier prefixe.prw poids des noeuds selon la synthaxe
   procedure Ecrire_Poids (Prefixe : in Unbounded_String;
                           Poids : in T_Vecteur;
                           alpha : in Float;
                           NbIte : in Integer;
                           NbPage : in Integer;
                           Fichier_Poids : out Ada.Text_IO.File_Type);


   -- Ecrire le fichier prefixe.pr classement des noeuds selon la synthaxe
   procedure Ecrire_Classement (Prefixe : in Unbounded_String;
                                Classement : in T_Vecteur;
                                NbPage : in Integer;
				Fichier_Classement : out Ada.Text_IO.File_Type);
   
   type T_Matrice_Creuse is access T_Cellule;
   
   type T_Cellule is
       record
           Valeur : Float;
           Ligne : Integer;
           Colonne : Integer;
           Suivante : T_Matrice_Creuse;
      end record;
   
   type T_Matrice is array (1..NbPage, 1..NbPage) of Float;
   
   type T_Vecteur is array (1..NbPage) of Float;
   
   type T_Vecteur_Colonne is array (1..NbPage) of T_Matrice_Creuse;

end lecture_calcul_matrice_creuse;
