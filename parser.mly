%{ 
  open Ast
%}
%token EOL EOF
%token DONT MAIS AVEC SANS NI ET DOUBLE COMMA 
%token FROMAGE JAMBONBEURRE PANINI BELGE DIEPPOIS FROMAGES PANINIS BELGES
%token PAIN JAMBON BEURRE SALADE EMMENTAL KETCHUP MOUTARDE MAYONNAISE FRITES TOMATE STEAK THON
%token <int> ONE
%token <int> CTE
%token <int> DONT_CTE
%start s
%type <Ast.commandes> s
%%
s:
 | expr EOL s { Mult_commande($1, $3) } 
 | expr EOF { Sin_commande($1) }

/* Commandes */
expr:
 | order option_simple { Commande_simple($1, $2) }
 | order DONT option_complex { Commande_complex($1, $3) }
 | order { Commande_simple($1, Option_vide) }

option_complex:
 | CTE option_simple { Option_dont_sin($1, $2)  }
 | ONE option_simple { Option_dont_sin(1, $2) }
 | option_complex DONT_CTE option_simple { Option_dont_mult($2, $3, $1) }

option_simple:
 | option_avec MAIS option_sans { Option_mais(Option_avec($1), Option_sans($3)) }
 | option_sans MAIS option_avec { Option_mais(Option_sans($1), Option_avec($3)) }
 | option_avec { Option_avec($1) }
 | option_sans { Option_sans($1) }

sandwich:
 | FROMAGE { Fromage }
 | JAMBONBEURRE { Jambonbeurre }
 | PANINI { Panini }
 | BELGE { Belge }
 | DIEPPOIS { Dieppois }

sandwichs:
 | FROMAGES { Fromage }
 | PANINIS { Panini }
 | BELGES { Belge }

order:
 | ONE sandwich { Order(1, $2) }
 | CTE sandwichs { Order($1, $2) }

ingredient:
  | PAIN { Pain }
  | JAMBON { Jambon }
  | BEURRE { Beurre }
  | SALADE { Salade }
  | EMMENTAL { Emmental }
  | KETCHUP { Ketchup }
  | MOUTARDE { Moutarde }
  | MAYONNAISE { Mayonnaise }
  | FRITES { Frites }
  | TOMATE { Tomate }
  | STEAK { Steak }
  | THON { Thon }
    
/* Ingredients */
ingredients: DOUBLE ingredient { Nb_ingredient(2, $2) }
 | ingredient { Nb_ingredient(1, $1) }

/* Avec */
option_avec: AVEC option_avec_et { $2 }
 | AVEC ingredients { Sin_ingredient($2) }

option_avec_et: ingredients COMMA option_avec_et { Mult_ingredient($1, $3) }
 | ingredients ET ingredients { Mult_ingredient($1, Sin_ingredient($3)) }

/* Sans */
option_sans: SANS option_sans_ni { $2 }
 | SANS ingredients { Sin_ingredient($2) }

option_sans_ni: ingredients COMMA option_sans_ni  { Mult_ingredient($1, $3) }
 | ingredients NI ingredients { Mult_ingredient($1, Sin_ingredient($3)) }

