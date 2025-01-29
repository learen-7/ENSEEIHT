with lecture_calcul_matrice_pleine;
with lecture_calcul_matrice_creuse;
with analyse_ligne_commande;          use analyse_ligne_commande;
with Ada.Strings.Unbounded;           use Ada.Strings.Unbounded;
with Ada.Text_IO;		       use Ada.Text_IO;
with Ada.Float_Text_IO;               use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;             use Ada.Integer_Text_IO;
with Ada.Exceptions;                  use Ada.Exceptions;

procedure main is

   -- Declaration des variables
   alpha : Float;
   epsilon : Float;
   k : Integer;
   mat_creuse : Boolean;
   prefixe : Unbounded_String;
   fichier_source : Unbounded_String;

   Taille : Integer;

   Fichier_Poids : Ada.Text_IO.File_Type;
   Fichier_Classement : Ada.Text_IO.File_Type;
   Fichier_Graphe : Ada.Text_IO.File_Type;
   
   -- Instantiation de lecture calcul matrice pleine
   procedure matrice_pleine (alpha : in Float ; epsilon : in Float ; k : in Integer ; Taille : in Integer ; fichier_source : in Unbounded_String ; Fichier_Poids : in out Ada.Text_IO.File_Type ; Fichier_Classement : in out Ada.Text_IO.File_Type ) is
   
      package P is new lecture_calcul_matrice_pleine(NbPage=>Taille);
      use P;
      
      Page : T_Matrice;
      S : T_Matrice;
      G : T_Matrice;
      Pi : T_Vecteur;
      Poids : T_Vecteur;
      Classement : T_Vecteur;
      
   begin      

      Lire (fichier_source, Page);

      S := Calculer_S (Page);
      G := Calculer_G (S, alpha);
      Pi := Calculer_Pi (G, k);
      Classer (Pi, Poids, Classement);

      Ecrire_Poids (prefixe, Poids, alpha, k, Taille, Fichier_Poids);
      Ecrire_Classement (prefixe, Classement, Taille, Fichier_Classement);
   end matrice_pleine;
   
   procedure matrice_creuse (alpha : in Float ; epsilon : in Float ; k : in Integer ; Taille : in Integer ; fichier_source : in Unbounded_String ; Fichier_Poids : in out Ada.Text_IO.File_Type ; Fichier_Classement : in out Ada.Text_IO.File_Type ) is
   
      package C is new lecture_calcul_matrice_creuse(NbPage=>Taille);
      use C;
      
      Page : T_Matrice_Creuse;
      Vecteur_Colonne : T_Vecteur_Colonne;
      S : T_Matrice_Creuse;
      Pi : T_Vecteur;
      Poids : T_Vecteur;
      Classement : T_Vecteur;
      
   begin      

      Lire (fichier_source, Page, Vecteur_Colonne);

      S := Calculer_S (Page, Vecteur_Colonne);
      Pi := Calculer_Pi (S, alpha, k, Vecteur_Colonne);
      Classer (Pi, Poids, Classement);

      Ecrire_Poids (prefixe, Poids, alpha, k, Taille, Fichier_Poids);
      Ecrire_Classement (prefixe, Classement, Taille, Fichier_Classement);
   end matrice_creuse;
      
      
begin

   get_param (alpha, epsilon, k, mat_creuse, prefixe, fichier_source);
   
   Open (Fichier_Graphe, In_File, To_String(fichier_source));   
   Get (Fichier_Graphe, Taille);
   Close (Fichier_Graphe);
   
   if not mat_creuse then
      
      matrice_pleine (alpha, epsilon, k, Taille, fichier_source, Fichier_Poids, Fichier_Classement);
      Put ("Creation des fichiers Output");
      
   else

      matrice_creuse (alpha, epsilon, k, Taille, fichier_source, Fichier_Poids, Fichier_Classement);
      Put ("Creation des fichiers Output");

   end if;
   
exception
   when Name_Error =>
      Put ("Erreur, le nom du fichier ne correspond pas.");
   when Storage_Error =>
      Put ("Erreur de stockage, essayez avec le programme matrice creuse."); 
   when End_Error =>
      Put ("Erreur, la synthaxe du fichier ne correspond pas a celle attendue.");
   when Data_Error =>
      Put ("Erreur, la synthaxe du fichier ne correspond pas a celle attendue.");

end main;
