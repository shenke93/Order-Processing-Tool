type sandwich = 
	| Fromage
	| Jambonbeurre
	| Panini
	| Belge
	| Dieppois

type ingredient =
        | Pain
	| Jambon 
	| Beurre 
	| Salade
	| Emmental
	| Ketchup
	| Moutarde 
	| Mayonnaise 
	| Frites 
	| Tomate
	| Steak
	| Thon 


type nbIngredient = Nb_ingredient of int * ingredient

type ingredients = 
| Sin_ingredient of nbIngredient
| Mult_ingredient of nbIngredient * ingredients

type option_avec_sans =
| Option_avec of ingredients
| Option_sans of ingredients

type option_simple = 
| Option_mais of option_avec_sans * option_avec_sans
| Option_avec of ingredients
| Option_sans of ingredients
| Option_vide

type option_complex =
| Option_dont_sin of int * option_simple
| Option_dont_mult of int * option_simple * option_complex

type order = Order of int * sandwich

type commande = 
| Commande_simple of order * option_simple
| Commande_complex of order * option_complex 

type commandes = 
| Sin_commande of commande
| Mult_commande of commande * commandes
