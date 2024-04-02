with Ada.Text_IO;          use Ada.Text_IO;

-- afficher la classe à laquelle appartient un caractère lu au clavier
--
-- La classe d'un caractère peut-être 'C' pour Chiffre, 'L' pour Lettre, 'P'
-- pour Ponctuation ou 'A' pour Autre.
--
--  Exemples :
--
--  c    ->  classe
-- -------------------
-- '4'   ->  'C'
-- 'A'   ->  'L'
-- 'd'   ->  'L'
-- '!'   ->  'P'
-- '<'   ->  'A'
-- '='   ->  'A'
-- ','   ->  'P'
-- ';'   ->  'P'
-- '.'   ->  'P'
-- '?'   ->  'P'
-- 'z'   ->  'L'
-- 'Z'   ->  'L'
-- 'a'   ->  'L'
-- '0'   ->  'C'
-- '9'   ->  'C'
-- 'à'   ->  'A'
-- 'Ü'   ->  'A'
--
procedure Classer_Caractere is

	-- Constantes pour définir la classe des caractères
	--   Remarque : Dans la suite du cours nous verrons une meilleure
	--   façon de faire que de définir ces constantes.  Laquelle ?
	Chiffre     : constant Character := 'C';
	Lettre      : constant Character := 'L';
	Ponctuation : constant Character := 'P';
	Autre       : constant Character := 'A';

	C : Character;		-- le caractère à classer
	Classe: Character;  -- la classe du caractère C
	Code : Integer;	
begin
	-- Demander le caractère
	Put ("Caractère : ");
	Get (C);

	-- Déterminer la classe du caractère c
	Code := Character'Pos(C);
	if Code >= 48 and Code <= 57 then
		Classe := 'C';
	elsif Code >= 65 and Code <=90 then 
		Classe := 'L';
		elsif Code >= 97 and Code <= 122  then
		Classe := 'L';
	elsif Code = 33 or Code = 34 or Code = 39 or Code = 44 or Code = 46 or Code = 58 or Code = 59 or Code = 63 then
		Classe := 'P';
	else
		Classe := 'A';
	end if;
	

	-- Afficher la classe du caractère
	Put_Line ("Classe : " & Classe);

end Classer_Caractere;
