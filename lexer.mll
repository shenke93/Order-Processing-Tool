{
  open Parser
}

rule token = parse
| [' ' '\t']+ { token lexbuf }		(* Ignore espace character. *)
| '\n' { EOL }
| (['0']*'1') { ONE(1) }
| (['0']*(['2'-'9']|['1'-'9']['0'-'9']+)) as plur { CTE(int_of_string plur) }
| "fromage" { FROMAGE }
| "jambon-beurre" { JAMBONBEURRE } 
| "panini" { PANINI } 
| "belge" { BELGE }
| "dieppois" { DIEPPOIS }
| "paninis" { PANINIS } 
| "belges" { BELGES }
| "fromages" { FROMAGES }		(* Sandwiches. *)
| "pain" { PAIN }
| "jambon" { JAMBON }
| "beurre" { BEURRE }
| "salade" { SALADE }
| "emmental" { EMMENTAL }
| "ketchup" { KETCHUP }
| "moutarde" { MOUTARDE }
| "mayonnaise" { MAYONNAISE }
| "frites" { FRITES }
| "tomate" { TOMATE}
| "steak" { STEAK }
| "thon" { THON }			(* Ingredients. *)
| "avec" { AVEC }
| "sans" { SANS }
| "mais" { MAIS }
| "dont" { DONT }
| "ni" { NI }
| "et" { ET }
| "et "['0'-'9']+ as id { DONT_CTE(int_of_string (String.sub id 3 (String.length(id)-3)))}
| "double" { DOUBLE }
| "," { COMMA }				(* Key words. *)
| eof { EOF }				(* End of file. *)
