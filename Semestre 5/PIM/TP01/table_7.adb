with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

-- Afficher la table de 7
--
-- Résultat attendu :
--
-- 1 x 7 =  7
-- 2 x 7 = 14
-- 3 x 7 = 21
-- 4 x 7 = 28
-- 5 x 7 = 35
-- 6 x 7 = 42
-- 7 x 7 = 49
-- 8 x 7 = 56
-- 9 x 7 = 63
--
procedure Table_7 is
	Resultat: Integer;
begin
	
	for indice in 1..10 loop
		Resultat := indice * 7;
		Put(indice, 1);
		Put("x 7 = ");
		Put(Resultat, 1);
		New_line;
	end loop;

end Table_7;
