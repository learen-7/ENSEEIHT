with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;

generic
      NbPage : Integer;

package lecture_calcul_matrice_pleine is
   
   type T_Vecteur is private;
   type T_Matrice is private;

   -- Ouvrir le fichier graphe et transcrire les données dans une matrice page
   procedure Lire (NomFichier : in Unbounded_String;
                   Page : out T_Matrice);


   function Calculer_S (Page : in T_Matrice) return T_Matrice;

   function Calculer_G (S : in T_Matrice ; alpha : in Float) return T_Matrice;

   -- Pre condition NbIte > 2
   function Calculer_Pi (G : in T_Matrice ; NbIte : Integer) return T_Vecteur;

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

private
   type T_Vecteur is array (1..NbPage) of Float;
   type T_Matrice is array (1..NbPage, 1..NbPage) of Float;

end lecture_calcul_matrice_pleine;
