with Ada.Command_line;		use Ada.Command_line;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO;		use Ada.Text_IO;

package body analyse_ligne_commande is

    procedure get_param(alpha : OUT Float; epsilon : OUT Float;
        k : OUT Integer; mat_creuse : OUT Boolean ; prefixe : OUT Unbounded_String; fichier_source : OUT Unbounded_String) is

        No_Argument_Error : Exception;
        Alpha_Out_Bound : exception;
        K_data_error : exception;
        No_Data_Error : exception;
        No_File_Error : exception;
        index : Integer;
        reponse_comprise : boolean;
        reponse_utilisateur : Character;
        net : constant String := ".net";
        txt : constant String := ".txt";
        count_net : Integer;
        count_txt : Integer;
    begin
        -- on initialise les valeurs par défauts
        alpha := 0.85;
        k := 150;  -- Nombre d'itération
        epsilon := 0.0;
        mat_creuse := True;  -- est-ce qu'on utilise l'algorithme avec les matrice creuse ?
        prefixe := To_Unbounded_String("output");  -- nom du fichie résultat
        
        begin
        
        -- on vérifie qu'on a des arguments et donc qu'on ai un nom de fichier
        if Argument_Count = 0 then
            raise No_Argument_Error;
        else
            null;
        end if;

        -- On récupère le nom du fichier source
        -- on compte le nombre de "net" et de "txt" dans le dernier argument de la ligne de commande
        count_net := Ada.Strings.Fixed.Count(Source  => Argument(Argument_count),Pattern => net);
        count_txt := Ada.Strings.Fixed.Count(Source  => Argument(Argument_count),Pattern => txt);

        -- on vérifie que le nom du fichier source fini par un ".net" ou un ".txt"
        if count_net = 1 AND Ada.Strings.Fixed.Index(Source  => Argument(Argument_Count), Pattern => net, From => 1) = Argument(Argument_count)'Last - 3 then
            fichier_source := To_Unbounded_String(Argument(Argument_count)); 
        elsif count_txt = 1 AND Ada.Strings.Fixed.Index(Source => Argument(Argument_count), Pattern => txt, From => 1) = Argument(Argument_count)'Last - 3 then
            fichier_source := To_Unbounded_String(Argument(Argument_count)); 
        else
            raise No_File_Error;  -- on lève une exception si il n'y a pas de fichier source fournis
        end if;

        -- on traite les arguments de la ligne de commande
        index := 1;
        while index <= Argument_Count-1 loop  -- on parcoure la ligne de commande
            if Argument(index)(Argument(index)'First) = '-' then  -- on vérifie qu'il y a un tiret qui marque le début d'une option
                case Argument(index)(Argument(index)'First + 1) is
                    when 'A' =>  -- on modifie la valeur de alpha
                        if Float'Value(Argument(index + 1)) <= 1.0 AND Float'Value(Argument(index + 1)) >= 0.0 then
                            alpha := float'Value(Argument(index + 1));  
                            index := index + 2;
                        else
                            raise Alpha_Out_Bound;
                        end if;
                    when 'K' =>  -- on modifie l'indice k
                        if Integer'value(Argument(index + 1)) >= 0 then
                            k := Integer'value(Argument(index + 1));
                            index := index + 2;
                        else
                            raise K_data_error;
                        end if;
                    when 'E' =>  -- on modifie la valeur d'epsilon
                        epsilon := Float'Value(Argument(index + 1));
                        index := index + 2;
                    when 'P' =>  -- on choisi l'algorithme avec des matrice pleine
                        mat_creuse := false;
                        index := index + 1;
                    when 'C' =>  -- on choisi l'algorithme avec des matrice creuse
                        index := index + 1;
                    when 'R' =>  -- on choisi le nom du fichier en sortie
                        prefixe := To_Unbounded_String(Argument(index + 1));
                        index := index + 2;
                    when others =>  
                        reponse_comprise := True ;
                        Put("Je ne connais pas l'argument ");
                        Put(Argument(index));
                        New_line;
                        loop    
                            Put_Line("Est-ce-qu'on continue ? Si non, on executera le programe avec les valeurs par défaut. [o/n] ");
                            Get(reponse_utilisateur);
                            if reponse_utilisateur = 'o' OR reponse_utilisateur = 'O' then
                                index := index + 1;
                                reponse_comprise := True;
                            elsif reponse_utilisateur = 'n' OR reponse_utilisateur = 'N' then
                                index := Argument_Count; -- on va à la fin de la ligne de commande, on garde les valeur par défaut
                                reponse_comprise := True;
                            else
                                Put("Je n'ai pas comrpis la réponse.");
                                reponse_comprise := false;
                            end if;
                        exit when reponse_comprise;
                        end loop;
                end case;
            else
                index := index + 1;
            end if;
        end loop;
        exception
            when No_File_Error => Put_Line("Vous n'avez pas donné de fichier source.");
            when Alpha_Out_Bound => Put_Line("Alpha doit être compris entre 0 et 1.");
            when K_data_error => Put_Line("L'indice K doit être positif.");
            when No_Argument_Error => Put_Line("Il n'y a pas de fichier donné.");
            when No_Data_Error => Put_Line("Il faut une valeur après les arguments A, K, E et R");
        end;
    end get_param;

end analyse_ligne_commande;