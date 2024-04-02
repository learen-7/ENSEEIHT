with Ada.Text_IO;	     use Ada.Text_IO;
with Ada.Float_Text_IO;     use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body lecture_calcul_matrice_pleine is

   -- Fonctionne
   procedure Lire (NomFichier : in Unbounded_String ; Page : out T_Matrice) is
      Fichier_Graphe : Ada.Text_IO.File_Type;
      Curseur : Integer;
      CurseurRef : Integer;
   begin
      Open (Fichier_Graphe, In_File, To_String(NomFichier));
      Get (Fichier_Graphe, Curseur); -- NbPage -> Curseur
      
      -- Instanciation de Page vide
      for i in 1..NbPage loop
        for j in 1..NbPage loop
            Page (i, j) := 0.0;
        end loop;
      end loop;

      while not End_Of_File (Fichier_Graphe) loop
         Get (Fichier_Graphe, Curseur);
	 Get (Fichier_Graphe, CurseurRef);

         -- Les pages sont indicees a partir de 0
         Page(Curseur + 1, CurseurRef + 1) := 1.0;
        
      end loop;

      Close (Fichier_Graphe);
      

   end Lire;

   -- Fonctionne
   function Calculer_S (Page : in T_Matrice) return T_Matrice is
      S : T_Matrice;
      Ponderant : Float;
   begin
      -- Parcours des lignes
      for i in 1..NbPage loop
         Ponderant := 0.0;

         -- Parcours des colonnes
         -- Calculer le ponderant
         for j in 1..NbPage loop
            Ponderant := Ponderant + Page (i, j);
         end loop;
         
         -- Reajuster les coefficients de chaque ligne
         -- Si ponderant nul : coeff <- 1/NbPage, Sinon : les coeff egaux a 1 <- 1/Ponderant
         for j in 1..NbPage loop
            if Ponderant = 0.0 then               
               S(i, j) := 1.0 / Float(NbPage);            
            else
               if Page(i, j) = 1.0 then
                  S(i, j) := 1.0 / Ponderant;
               else
                  S(i, j) := 0.0;
               end if;
            end if;
         end loop;

      end loop;

      return S;
   end Calculer_S;

   -- Fonctionne
   function Calculer_G (S : in T_Matrice ; alpha : in Float) return T_Matrice is
      G : T_Matrice;
   begin
      -- Parcours des lignes
      for i in 1..NbPage loop
         -- Parcours des colonnes
	 for j in 1..NbPage loop
	    
	    G(i, j) := alpha*S(i, j) + (1.0 - alpha) / Float(NbPage);
	    
         end loop;
      end loop;
      
      
      return G;
   end Calculer_G;


   function Calculer_Pi (G : in T_Matrice ; NbIte : in Integer) return T_Vecteur is
      Pi : T_Vecteur;
      Terme : Float;
      PiTemp : T_Vecteur;
   begin
      -- Initialiser Pi
      for i in 1..NbPage loop
         Pi(i) := 1.0 / Float(NbPage);
      end loop;

      -- Chaque iteration du calcul de Pi
      for Compteur in 2..NbIte loop

         PiTemp := Pi;

         for j in 1..NbPage loop
            Terme := 0.0;

            for i in 1..NbPage loop
               Terme := Terme + G(i, j)*Pi(i);
            end loop;
            
            PiTemp(j) := Terme;
         end loop;

	 for i in 1..NbPage loop
	    Pi(i) := PiTemp(i);
	 end loop;
	 
      end loop;
      
      return Pi;
   end Calculer_Pi;


   procedure Classer (Pi : in out T_Vecteur ; Poids : out T_Vecteur ; Classement : out T_Vecteur) is
      Max : Float;
      IndiceMax : Integer;
   begin

      for Compteur in 1..NbPage loop
         Max := 0.0;

         for CompteurMax in 1..NbPage loop
            if Pi(CompteurMax) > Max then
               Max := Pi(CompteurMax);
               IndiceMax := CompteurMax;
            end if;
         end loop;

	 Pi(IndiceMax) := 0.0;
	 Poids(Compteur) := Max;
         -- les pages sont indicees a partir de 0
         Classement(Compteur) := Float(IndiceMax - 1);

      end loop;
   end Classer;
   
   
   procedure Ecrire_Poids (Prefixe : in Unbounded_String;
                           Poids : in T_Vecteur;
                           alpha : in Float;
                           NbIte : in Integer;
                           NbPage : in Integer;
                           Fichier_Poids : out Ada.Text_IO.File_Type) is
      PrefixePrw : Unbounded_String;
   begin
      PrefixePrw := Prefixe;
      Append (PrefixePrw, ".prw");
      Create (Fichier_Poids, Out_File, To_String (PrefixePrw));
      Put (Fichier_Poids, Integer'Image (NbPage));
      Put (Fichier_Poids, Float'Image (alpha));
      Put_Line (Fichier_Poids, Integer'Image (NbIte));

      for Compteur in 1..NbPage loop
         Put_Line (Fichier_Poids, Float'Image (Poids(Compteur)));
      end loop;

      Close (Fichier_Poids);
   end Ecrire_Poids;


   procedure Ecrire_Classement (Prefixe : in Unbounded_String;
                                Classement : in T_Vecteur;
                                NbPage : in Integer;
                                Fichier_Classement : out Ada.Text_IO.File_Type) is
      PrefixePr : Unbounded_String;
   begin
      PrefixePr := Prefixe;
      Append (PrefixePr, ".pr");
      Create (Fichier_Classement, Out_File, To_String (PrefixePr));

      for Compteur in 1..NbPage loop
         Put_Line (Fichier_Classement, Integer'Image(Integer(Classement(Compteur))));
      end loop;

      Close (Fichier_Classement);
   end Ecrire_Classement;


end lecture_calcul_matrice_pleine;
