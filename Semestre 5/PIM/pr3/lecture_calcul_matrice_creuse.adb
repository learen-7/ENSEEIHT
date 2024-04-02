with Ada.Text_IO;	     use Ada.Text_IO;
with Ada.Float_Text_IO;     use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;

package body lecture_calcul_matrice_creuse is


   procedure Free is
     new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Matrice_Creuse);

   procedure Initialiser(M : out T_Matrice_Creuse) is
   begin
      M := null;
   end Initialiser;


   procedure Detruire (M : in out T_Matrice_Creuse) is
   begin
      if M /= Null then
	 Detruire (M.all.Suivante);
	 Free (M);
      else
	 null;
      end if;									 
   end Detruire;
   
   
   procedure Enregistrer (M : in out T_Matrice_Creuse ; Valeur : in Float;
			  Nouvelle_Cellule : out T_Matrice_Creuse ; Ligne : in Integer; 
			  Colonne : in Integer) is
   begin
      if M = Null then
	 Nouvelle_Cellule := new T_Cellule;
	 Nouvelle_Cellule.all.Valeur := Valeur;
	 Nouvelle_Cellule.all.Ligne := Ligne;
	 Nouvelle_Cellule.all.Colonne := Colonne;
	 M := Nouvelle_Cellule;
      end if;
      
      if M.all.Suivante = Null then
	 Nouvelle_Cellule := new T_Cellule;
	 Nouvelle_Cellule.all.Valeur := Valeur;
	 Nouvelle_Cellule.all.Ligne := Ligne;
	 Nouvelle_Cellule.all.Colonne := Colonne;
	 Nouvelle_Cellule.all.Suivante := Null;
	 M.all.Suivante := Nouvelle_Cellule;
      else
	 Enregistrer (M.all.Suivante, Valeur, Nouvelle_Cellule, Ligne, Colonne);
      end if;
   end Enregistrer;  
   
   -- fonctionne
   procedure Lire (NomFichier : in Unbounded_String ; Page : out T_Matrice_Creuse ; Vecteur_Colonne : out T_Vecteur_Colonne) is
      Fichier_Graphe : Ada.Text_IO.File_Type;
      Tab : T_Matrice;
      Curseur : Integer;
      CurseurRef : Integer;
      Nouvelle_Cellule : T_Matrice_Creuse;
      estPremierDeLaLigne : Boolean;
   begin
      Open (Fichier_Graphe, In_File, To_String(NomFichier));
      Get (Fichier_Graphe, Curseur); -- NbPage -> Curseur
      
      -- Instanciation de Tab vide
      for i in 1..NbPage loop
	 for j in 1..NbPage loop
	    Tab(i, j) := 0.0;
	 end loop;
      end loop;

      while not End_Of_File (Fichier_Graphe) loop
	 Get (Fichier_Graphe, Curseur);
	 Get (Fichier_Graphe, CurseurRef);

	 -- Les pages sont indicees a partir de 0
	 Tab(Curseur + 1, CurseurRef + 1) := 1.0;
      end loop;
      
      -- Les cases non nulles enregistrées dans la matrice creuse dans l'ordre croissant des lignes puis des colonnes
      for i in 1..NbPage loop
	 estPremierDeLaLigne := True;
	 for j in 1..NbPage loop
	    
	    if Tab(i, j) = 1.0 then
	       Enregistrer (Page, 1.0, Nouvelle_Cellule, i, j);
	       if estPremierDeLaLigne then
		  Vecteur_Colonne(i) := Nouvelle_Cellule;
	       end if;
	       
	       estPremierDeLaLigne := False;
	    end if;
	    
	 end loop;
      end loop;
      
      Close (Fichier_Graphe);

   end Lire;


   function Calculer_S (Page : in out T_Matrice_Creuse ; Vecteur_Colonne : in out T_Vecteur_Colonne) return T_Matrice_Creuse is
      S : T_Matrice_Creuse;
      Ponderant : Float;
      Debut_Ligne : T_Matrice_Creuse;
      Debut_Page : T_Matrice_Creuse := Page;
      Nouvelle_Cellule :T_Matrice_Creuse;
      estPremierDeLaLigne : Boolean;
      Affiche_S : T_Matrice_Creuse;
   begin
      
      Initialiser (S);
      
      -- Parcours des lignes
      for i in 1..NbPage loop
	 Ponderant := 0.0;

	 -- Parcours des colonnes
	 -- Calculer le ponderant
	 if Page.all.Ligne = i then
	    
	    Debut_Ligne := Page;

	    -- A la fin de cette boucle le ponderant vaut le nombre de case non vide a une ligne donnee
	    loop
	       Ponderant := Ponderant + 1.0;
	       Page := Page.all.Suivante;
	       exit when Page = Null;
	       
	       if Page.all.Suivante /= Null then
		  exit when Page.all.Suivante.Ligne /= i;
	       end if;
	    end loop;

	    -- On va enregistrer 1/Ponderant pour dans S pour chaque colonne de Page
	    Page := Debut_Ligne;
	    loop
	       Enregistrer (S, 1.0/Ponderant, Nouvelle_Cellule, Page.all.Ligne, Page.all.Colonne);
	       Page := Page.all.Suivante;
	       exit when Page = Null;
	       if Page.all.Suivante /= Null then
		  exit when Page.all.Suivante.Ligne /= i;
	       end if;
	    end loop;
	 
	 -- Si la ligne est nulle, alors tous les elements de la ligne valent 1/NbPage
	 else
	    estPremierDeLaLigne := True;
	    for j in 1..NbPage loop
	       Enregistrer (S, 1.0/Float(NbPage), Nouvelle_Cellule, i, j);
	       
	       if estPremierDeLaLigne then
		  Vecteur_Colonne(i) := Nouvelle_Cellule;
		  estPremierDeLaLigne := False;
	       end if;
	       
	    end loop;
	 end if;
	 
	 if Page /= Null then
	    Page := Page.all.Suivante;      
	 end if;
	 
	 end loop;

      -- On libere la memoire
      Detruire (Debut_Page);     
      
      Put("affiche S");
      Affiche_S := S;
      while Affiche_S /= Null loop
	 Put("Ligne :");
	 Put (Affiche_S.all.Ligne);
	 Put("Colonne :");
	 Put (Affiche_S.all.Colonne);
	 Put ("Valeur : ");
	 Put (Affiche_S.all.Valeur);
	 New_Line;
	 Affiche_S := Affiche_S.all.Suivante;
      end loop;
      
      return S;
      
      end Calculer_S;


   function Calculer_Pi (S : in T_Matrice_Creuse ; alpha : in Float ; NbIte : in Integer;
			  Vecteur_Colonne : in T_Vecteur_Colonne) return T_Vecteur is
      Pi : T_Vecteur;
      Terme : Float;
      PiTemp : T_Vecteur;
      Gij : T_Matrice_Creuse;
      DF : Float := (1.0 - alpha) / Float(NbPage);
   begin

      for i in 1..NbPage loop
         Pi(i) := 1.0 / Float(NbPage);
      end loop;

      -- Chaque iteration du calcul de Pi
      for Compteur in 2..NbIte loop

         PiTemp := Pi;

	 for j in 1..NbPage loop
	    
            Terme := 0.0;
	    
	    for i in 1..NbPage loop
	       
	       Gij := Vecteur_Colonne(i); -- le premier terme de la i-eme ligne
	       
	       while Gij.all.Colonne < j loop
		  if Gij /= Null then
		     Gij := Gij.all.Suivante;
		  end if;
		  exit when Gij = Null;
	       end loop;
	       
	       if Gij /= Null and then Gij.all.Colonne = j then	
		  Terme := Terme + Pi(j)*alpha*Gij.all.Valeur;
	       end if;
	       Terme := Terme + DF;
			    
            end loop;
            
	    PiTemp(j) := Terme;
	    
         end loop;

         Pi := PiTemp;

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


end lecture_calcul_matrice_creuse;
