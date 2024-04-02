with Text_Io;              use Text_Io;
with Ada.Integer_Text_Io;  use Ada.Integer_Text_Io;

-- Auteur : Léa HOUOT
--
-- 
procedure Jeu_Devin_Exo2 is
	Min : Integer; -- borne minimale du jeu
	Max : Integer; -- borne maximale du jeu
	Nb_essais : Integer; -- nombre d'essais que prend l'ordinateur
						 -- pour trouver le nombre
	Nombre : Integer; -- Nombre que propose l'ordinateur
	Trouve : Boolean; -- état si l'ordinateur a trouvé le nombre 
					  -- ou non
	Triche_indication : Boolean; -- état si l'ordianteur sais si l'utilisateur
					  			 -- triche ou non avec notre indication
	Triche_nombre : Boolean;  --état si l'ordianteur sais si l'utilisateur
					  		  -- triche en car il ne valide pas son nombre alors
							  -- qu'il n'y a qu'une seule possibilité
	Indication : Character; -- Indication que donne l'utilisateur à 
						 -- l'ordinateur sur le nombre proposé
	Indication_comprise : Boolean; -- état si l'ordinateur a compris
								   -- l'indication de l'utilisateur 
								   -- ou non
	Reponse : Character; -- Réponse de l'utilisteur pour indiquer si il
					  -- a son nombre ou non
	Nombre_precedent : Integer; -- Nombre proposé à l'essai précedent
begin
	-- initialiser  la borne minimale et la borne maximale du nombre à trouver
	Min := 1;
	Max := 1000;

	-- initialiser le nombre d’essais
	Nb_essais := 0;

	-- demander à l’utilisateur pour commencer le jeu
	loop
		Put("Avez-vous choisi un nombre compris entre 1 et 999 (o/n) ?");
		Get(Reponse);
		if not (Reponse = 'o' or Reponse = 'O') then
			Put("J'attends...");
		else
			null;
		end if;
		exit when Reponse = 'o' or Reponse = 'O';
	end loop;

	Nombre_precedent := 0;

	-- deviner le nombre
	loop
		--Proposer un nombre par dichotomie
		Nb_essais := Nb_essais + 1;
		Nombre := (Max + Min) / 2;
		Put("Proposition ");
		Put(Nb_essais, 1);
		Put(" : ");
		Put(Nombre, 1);
		New_Line;
		Triche_nombre := Nombre = Nombre_precedent;
		loop
			-- Demander une indication à l’utilisateur
			Put("Trop (g)rand, trop (p)etit ou (t)rouvé ?");
			Get(Indication);

			--Traiter l’indication de l’utilisateur
			case Indication is
				when 'G' | 'g' =>
					Max := Nombre;
				when 'P' | 'p' =>
					Min := Nombre;
				when 'T' | 't' =>
					Trouve := True;
				when others =>
					-- écrire les indications que l’utilisateur peut donner
					Put("Je n'ai pas compris merci de répondre :");
					New_Line;
					Put("g si ma proposition est trop grande");
					New_Line;
					Put("p si ma proposition est trop petite");
					New_Line;
					Put("t si j'ai trouvé le nombre");
					New_Line;
			end case;

			-- Déterminer la compréhension de l’indication
			Indication_comprise := Indication = 'G' OR Indication ='g' OR Indication ='P' OR Indication ='p' OR Indication ='T' OR Indication ='t';

			-- Chercher une tricherie
			if Nombre = Min then
				Triche_indication := Indication = 'G' OR Indication ='g';
			elsif Nombre = Max - 1 then 
				Triche_indication := Indication = 'P' OR Indication ='p';
			else
				Triche_indication := False;
			end if;

			exit when Indication_comprise;
		end loop;

		Nombre_precedent := Nombre;

		exit when Trouve OR Triche_indication OR Triche_nombre;
	end loop;

	-- écrire le résultat du jeu
	If Triche_nombre OR Triche_indication then
		Put("Vous trichez. J'arrête cette partie.");
	else
		Put("J'ai trouvé ");
		Put(Nombre, 1);
		Put(" en ");
		Put(Nb_essais, 1);
		Put(" essais.");
	end if;

end Jeu_Devin_Exo2;