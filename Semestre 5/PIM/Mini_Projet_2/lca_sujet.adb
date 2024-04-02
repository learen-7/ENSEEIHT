with Ada.Text_IO;  use Ada.Text_IO;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with LCA;



procedure lca_sujet is
   package  LCA1 is
     new LCA(T_Cle=> Unbounded_String ,T_Valeur=>Integer);
   use LCA1;
   Lca : T_LCA;

begin
   Initialiser(Lca);
   Enregistrer(Lca,To_Unbounded_String("un"),1);
   Enregistrer(Lca,To_Unbounded_String("deux"),2);
   if Cle_Presente(Lca, To_Unbounded_String("un")) then
      Put_Line("La clef un est bien presente dans la lca");
   end if;
   if La_Valeur(Lca, To_Unbounded_String("un")) = 1 then
      Put_Line("La valeur associée à la clef un est bien 1");
   end if;
end lca_sujet;

