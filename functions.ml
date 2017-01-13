open Ast

(* Test if an ingredient is meat. *)
let is_meat i = match i with
  | Jambon -> true
  | Steak -> true
  | Thon -> true
  | _ -> false

(* Rule: There is only one meat. *)
(* Number of meat in a list. *)
let rec nb_meat l nb = match l with
  | [] -> nb
  | (a, b)::r -> if (is_meat a) then nb_meat r (nb+b) else nb_meat r nb

let verify_meat l =
  (nb_meat l 0) < 2

(* Test if a list is valid. *)
let rec verify_ingredients_list l = match l with
  | [] -> true
  | (a, b)::r -> if(b==0 || b==1 || b==2) then verify_ingredients_list r else false

(* Rule: nb_commandes >= cte_option_dont. Contre-exemple 26-27. *)
(* Number of options in an option_complex. *)
let rec nb_options option_complex nb = match option_complex with
  | Option_dont_sin(n, _) -> nb+n
  | Option_dont_mult(n, _, s) -> nb_options s (nb+n)

let nb_options_opt_complex option_complex =
  nb_options option_complex 0

(* Test of the rule above. *)
let verify_nb_options order option_complex = match order with
  | Order(a, _) -> (nb_options_opt_complex option_complex) <= a

(* Evaluate "ingredients". Update the list of ingredients. *)
let rec update_list l k v = match l with
  | [] -> [(k, v)]
  | (a, b)::r -> if (a==k) then (a, b+v)::r else (a, b)::(update_list r k v)

let rec update_ingredients l ingr f = match ingr with
  | Sin_ingredient(Nb_ingredient(v, k)) -> update_list l k (f*v)
  | Mult_ingredient(Nb_ingredient(v, k), others) -> 
    let l2 = update_list l k (f*v) in
    update_ingredients l2 others f

(* Get a list of initial ingredients of a sandwich. *)
let get_ingredients_sand sand = match sand with
  | Fromage -> [(Pain, 1); (Beurre, 1); (Emmental, 1)]
  | Jambonbeurre -> [(Pain, 1); (Jambon, 1); (Beurre, 1); (Salade,1) ]
  | Panini -> [(Pain, 1); (Jambon, 1); (Emmental, 1); (Tomate, 1); (Salade,1) ]
  | Belge -> [(Pain, 1); (Steak, 1); (Frites, 1); (Mayonnaise, 1); (Salade,1) ]
  | Dieppois -> [(Pain, 1); (Thon, 1); (Mayonnaise, 1); (Salade, 1)]

(* Return a list of ingredients of a commande_simple. *)
let list_ingredients_cmd_simple order option_simple = match order with
  | Order(nb, sand) -> match option_simple with
    | Option_mais(Option_avec(ingr1), Option_sans(ingr2)) -> let l1 = get_ingredients_sand sand in
							     let l2 = (update_ingredients l1 ingr1 1) in
							     let l3 = (update_ingredients l2 ingr2 (-1)) in l3
    | Option_mais(Option_sans(ingr1), Option_avec(ingr2)) -> let l1 = get_ingredients_sand sand in
							     let l2 = (update_ingredients l1 ingr1 (-1)) in
							     let l3 = (update_ingredients l2 ingr2 1) in l3
    | Option_avec(ingr) -> let l1 = get_ingredients_sand sand in
			   let l2 = update_ingredients l1 ingr 1 in l2
    | Option_sans(ingr) -> let l1 = get_ingredients_sand sand in
			   let l2 = (update_ingredients l1 ingr (-1)) in l2
    | Option_vide ->  let l1 = get_ingredients_sand sand in l1

(* Verify a commande_simple is correct. *)
(* The list form is correct and the number of meat is correct. *)
let verify_cmd_simple order option_simple = 
  let list_ingredients = list_ingredients_cmd_simple order option_simple in
  (verify_ingredients_list list_ingredients) && (verify_meat list_ingredients)

(* Verify a commande_complex is correct. *)
(* The numbers of options are right. *)
let rec verify_option_complex order option_complex = match option_complex with
  | Option_dont_sin(nb, op_s) -> verify_cmd_simple order op_s 
  | Option_dont_mult(nb, op_s, op_c) -> if ((verify_cmd_simple order op_s) == false) then false else verify_option_complex order op_c

let verify_cmd_complex order option_complex = 
  (verify_option_complex order option_complex) && (verify_nb_options order option_complex)

(* 2.1.2 Ex4 *)
let verify_commande commande = match commande with
  | Commande_simple(ord, opt_s) -> verify_cmd_simple ord opt_s
  | Commande_complex(ord, opt_c) -> verify_cmd_complex ord opt_c

let rec verify_commandes commandes = match commandes with
  | Sin_commande(a) -> verify_commande a
  | Mult_commande(a, b) -> if (verify_commande a) then (verify_commandes b) else false



(* Change a list of ingredients to a list of detailed ingredients. *)
let rec quantite_ingredient l = match l with
    | (Pain, quantite)::r ->  (Pain, (float_of_int quantite))::(quantite_ingredient r)
    | (Jambon, quantite)::r -> (Jambon, (float_of_int quantite))::(quantite_ingredient r)
    | (Beurre, quantite)::r -> (Beurre, (float_of_int quantite) *. 10.0)::(quantite_ingredient r)
    | (Salade, quantite)::r -> (Salade, (float_of_int quantite) *. 10.0)::(quantite_ingredient r)
    | (Emmental, quantite)::r -> (Emmental, (float_of_int quantite) *. 2.0)::(quantite_ingredient r)
    | (Ketchup, quantite)::r -> (Ketchup, (float_of_int quantite) *. 10.0)::(quantite_ingredient r)
    | (Moutarde, quantite)::r -> (Moutarde, (float_of_int quantite) *. 10.0)::(quantite_ingredient r)
    | (Mayonnaise, quantite)::r -> (Mayonnaise, (float_of_int quantite) *. 20.0)::(quantite_ingredient r)
    | (Frites, quantite)::r -> (Frites, (float_of_int quantite) *. 50.0)::(quantite_ingredient r)
    | (Tomate, quantite)::r -> (Tomate, (float_of_int quantite) *. 0.5)::(quantite_ingredient r)
    | (Steak, quantite)::r -> (Steak, (float_of_int quantite))::(quantite_ingredient r)
    | (Thon, quantite)::r -> (Thon, (float_of_int quantite) *. 50.0)::(quantite_ingredient r)
    | [] -> []

(* Combine the list of commandes. *)
let rec combine_list l1 l2 = match l1 with
  | [] -> l2
  | (k, v)::r -> combine_list r (update_list l2 k v)

let rec multiply_list l a = match l with
  | [] -> []
  | (b, c)::r -> (b, c*a)::multiply_list r a

(* Return the quantity of a simple command. *)
let rec quantite_option_complex order option_complex = match option_complex with
  | Option_dont_sin(nb, op_s) -> multiply_list (list_ingredients_cmd_simple order op_s) nb
  | Option_dont_mult(nb, op_s, op_c) -> combine_list (multiply_list (list_ingredients_cmd_simple order op_s) nb) (quantite_option_complex order op_c)

(* Return the quantity of a complex command. It is a list.*)
let quantite_commande_complex order option_complex = match order with
  | Order(nb, sand) -> combine_list (quantite_option_complex order option_complex) (multiply_list (get_ingredients_sand sand) (nb-(nb_options_opt_complex option_complex)))

let quantite_commande c = match c with
  | Commande_complex(ord, opt_c) -> quantite_commande_complex ord opt_c  
  | Commande_simple(ord, opt_s) -> match ord with
    | Order(nb, _) -> multiply_list (list_ingredients_cmd_simple ord opt_s) nb
  

let rec quantite_commandes c = match c with
  | Sin_commande(a) -> quantite_commande a
  | Mult_commande(a, b) -> combine_list (quantite_commande a) (quantite_commandes b)


(* 2.2.1 Ex5 *)
(* Return a list of the details of ingredients. *)
let rec quantite_commandes_real c = quantite_ingredient(quantite_commandes c)


(* 2.2.2 The very same process as the functions above.*)
let construct_version order option_simple = match order with
  | Order(nb, sand) -> match option_simple with
    | Option_mais(Option_avec(ingr1), Option_sans(ingr2)) -> let l1 = [] in
							     let l2 = (update_ingredients l1 ingr1 1) in
							     let l3 = (update_ingredients l2 ingr2 (-1)) in l3
    | Option_mais(Option_sans(ingr1), Option_avec(ingr2)) -> let l1 = [] in
							     let l2 = (update_ingredients l1 ingr1 (-1)) in
							     let l3 = (update_ingredients l2 ingr2 1) in l3
    | Option_avec(ingr) -> let l1 = [] in
			   let l2 = update_ingredients l1 ingr 1 in l2
    | Option_sans(ingr) -> let l1 = [] in
			   let l2 = (update_ingredients l1 ingr (-1)) in l2
    | Option_vide -> []

let rec merge_array a b = match a with
        | [] -> b
        | c::r -> merge_array r (c::b)

let version_option_simple order option_simple = 
  let liste_ingredients = construct_version order option_simple in
  liste_ingredients
  
let rec version_option_complex order option_complex = match order with Order(nb, sandwich) -> match option_complex with
        | Option_dont_sin(c,op_s) -> [(sandwich, version_option_simple order op_s, c)]
        | Option_dont_mult(c,op_s, op_c) -> ((sandwich, version_option_simple order op_s, c))::(version_option_complex order op_c)

let version_commande_complexe order option_complex = match order with
        | Order(a,b) -> (b, [],(a-(nb_options_opt_complex option_complex)))::(version_option_complex order option_complex)

let version_commande c = match c with
        | Commande_complex(a, b) -> version_commande_complexe a b
        | Commande_simple(a, b) -> match a with Order(c,d) -> [(d, version_option_simple a b, c)]

let rec version_commandes c = match c with
        | Sin_commande(a) -> version_commande a
        | Mult_commande(a,b) -> merge_array(version_commande a) (version_commandes b)

let ingredient_compare (x,y) (x',y') = compare x x'
     
let rec set_assoc l k v = match l with 
    | [] -> [(k,v)]
    | (a,b)::r -> if (a=k) then (a,v)::r else (a,b)::(set_assoc r k v)

let rec aggregate_sandwich liste nouvelle_liste = match liste with
        | [] -> nouvelle_liste
        | (sandwich, liste_ingredients, n)::r -> aggregate_sandwich r (set_assoc nouvelle_liste sandwich ((List.sort ingredient_compare  liste_ingredients, n)::(try(List.assoc sandwich nouvelle_liste) with _->[])))

let rec merge_liste_version liste nouvelle_liste = match liste with
        | [] -> nouvelle_liste
        | (liste_versions, n)::r -> merge_liste_version r (set_assoc nouvelle_liste liste_versions (n+(try(List.assoc liste_versions nouvelle_liste)with _->0))) 

let process_versions ast = let rec merge l = match l with
        | [] -> []
        | (a,b)::r -> (a, merge_liste_version b [])::merge r
        in merge(aggregate_sandwich(version_commandes ast) [])
        

let print_ingredient ing = match ing with
    | Pain              -> "pain"
    | Jambon            -> "jambon"
    | Beurre            -> "beurre"
    | Salade            -> "salade"
    | Emmental          -> "emmental"
    | Ketchup           -> "ketchup"
    | Moutarde          -> "moutarde"
    | Mayonnaise        -> "mayonnaise"
    | Frites            -> "frites"
    | Tomate            -> "tomate"
    | Steak             -> "steak"
    | Thon              -> "thon"

let print_sandwich sandwich = match sandwich with
    | Fromage           -> "Fromage(s)"
    | Jambonbeurre     -> "Jambon-beurre"
    | Panini            -> "Panini(s)"
    | Belge             -> "Belge(s)"
    | Dieppois          -> "Dieppois"
        
let rec print_liste_ingredient l = match l with
        | [] -> ""
        | (ingr, nb)::r -> (string_of_int nb) ^ " " ^ print_ingredient(ingr) ^ " " ^ print_liste_ingredient r
        
let rec versions_to_string versions = match versions with
        | [] -> ""
        | (sandwich, liste_ingredients,n)::r -> (print_sandwich sandwich) ^ " " ^ (string_of_int n) ^ print_liste_ingredient(liste_ingredients) ^ "\n" ^ (versions_to_string r)
        
let rec version_list_to_string versions_list = match versions_list with 
        | [] -> ""
        | (liste_ingredients, n)::r -> (string_of_int n) ^ ": " ^ print_liste_ingredient(liste_ingredients) ^ "\n" ^ (version_list_to_string r)
        
let rec aggregated_versions_to_string versions = match versions with
        | [] -> ""
        | (sandwich, versions_list)::r -> (print_sandwich sandwich) ^ " " ^ (version_list_to_string versions_list) ^ "\n" ^ aggregated_versions_to_string r


let rec list_to_string l = match l with
        | [] -> ""
        | (a,b)::r -> (string_of_float b) ^ " " ^ (print_ingredient a) ^ "\n" ^ list_to_string r

(* Back-end *)
let price_sandwich sand = match sand with
        | Fromage -> 3.0
        | Jambonbeurre -> 4.0
        | Panini -> 5.0
        | Belge -> 5.0
        | Dieppois -> 4.5

(* The facture of each version. *)
let rec facture_version version = match version with
    | [] -> 0.0
    | _::r -> 0.5 +. facture_version r
    
let rec facture_liste_version sandwich liste =  match liste with
    | (version, n)::r -> float_of_int (n)*. (facture_version version +. price_sandwich sandwich) +. facture_liste_version sandwich r
    | [] -> 0.0
        
let rec facture_commandes versions = match versions with
    | [] -> 0.0
    | (sandwich, liste_ingredients)::r  -> facture_liste_version sandwich liste_ingredients +. facture_commandes r

let rec facture ast = 
    facture_commandes (process_versions ast)

let adapt_for_facture liste =
    let rec adapt_for_facture_aux3 n versions l = match versions with
        | [] -> l
        | (a,ingredient)::r -> adapt_for_facture_aux3 n r (set_assoc l (a,ingredient) ((try(List.assoc ((a,ingredient)) l) with _->0)+n)) 
    in let rec adapt_for_facture_aux2 liste_versions new_list = match liste_versions with
        | [] -> new_list
        | (version, n)::r -> adapt_for_facture_aux2 r (adapt_for_facture_aux3 n version new_list)
    in adapt_for_facture_aux2 liste []
    
let print_with_without v = match v with
    | (-1) -> "sans"
    | 1 -> "avec"
    | _ -> "avec double"
    
let print_facture ast = 
    let rec nb_versions versions = match versions with
        | [] -> 0
        | (_,n)::r -> n + nb_versions r
    in let rec print_versions versions = match versions with
        | [] -> ""
        | ((ingredient, a), n)::r -> "\t" ^ string_of_int n ^ " " ^ print_with_without a ^ " " ^ print_ingredient ingredient ^ "\t" ^ string_of_float (0.5 *. float_of_int(n)) ^ "\n" ^ (print_versions r)
    in let rec print_facture_aux liste = match liste with
        | [] -> "\n"
        | (sandwich, versions)::r -> string_of_int (nb_versions versions) ^ " " ^ (print_sandwich sandwich) ^ "\t" ^ string_of_float(float_of_int(nb_versions versions) *. (price_sandwich sandwich)) ^ "\n" ^ print_versions (adapt_for_facture versions) ^ "\n" ^ (print_facture_aux r)
    in print_facture_aux (process_versions ast) ^ "TOTAL : " ^ (string_of_float (facture ast))
    
let inventaire ast = 
    let rec print_list l = match l with
        | [] -> "\n"
        | (ingredient, n)::r -> (print_ingredient ingredient) ^ "," ^ string_of_float(n) ^ "\n" ^ (print_list r)
    in print_list(quantite_commandes_real ast )
    
    
let print_cuisine ast =
    let rec print_ingredients ingredients term = let print_double_ingredient (a,b) = (if b==2 then "double " else "") ^ print_ingredient a
        in match ingredients with
        | [] -> ""
        | a::[] -> (print_double_ingredient a)
        | a::b::[] -> (print_double_ingredient a) ^ " " ^ term ^ " " ^ (print_double_ingredient b)
        | a::b::r  -> (print_double_ingredient a) ^ ", " ^ (print_double_ingredient b) ^ (print_ingredients r term)
    in let rec listWith liste = match liste with
        | [] -> []
        | (a,1)::r -> (a,1)::(listWith r)
        | (a,2)::r -> (a,2)::(listWith r)
        | (a,_)::r -> (listWith r)
    in let rec listWithout liste = match liste with
        | [] -> []
        | (a,-1)::r -> (a,-1)::(listWithout r)
        | (a,_)::r -> (listWithout r)
    in let print_version (liste, n) = let print_couple couple = match couple with
        | ([],[]) -> " normaux"
        | (ingrWith,[]) -> " avec " ^ (print_ingredients ingrWith "et")
        | ([],ingrWithout) -> " sans " ^ (print_ingredients ingrWithout "ni")
        | (ingrWith,ingrWithout) -> " avec " ^ (print_ingredients ingrWith "et") ^ " mais sans " ^ (print_ingredients ingrWithout "ni")
        in string_of_int(n) ^ print_couple(listWith(liste), listWithout(liste))
    in let rec print_versions versions = match versions with
        | [] -> ""
        | (a,n)::r -> (if n>0 then "<li>" ^ (print_version (a,n)) ^ "</li>" else "") ^ (print_versions r)
    in let print_sandwich (sandwich, versions) = "\t\t<h1>" ^ (print_sandwich sandwich) ^ "</h1><ul>" ^ (print_versions versions) ^ "</ul>\n"
    in let rec print_sandwiches liste = match liste with
        | [] -> ""
        | a::r -> (print_sandwich a) ^ (print_sandwiches r)
    in "<html>\n\t<head>\n\t\t<title>Cuisine</title>\n\t</head>\n\t<body>" ^ print_sandwiches(process_versions ast) ^ "\t</body>\n</html>"
