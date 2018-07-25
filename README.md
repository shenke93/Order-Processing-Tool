# Order-Processing-Tool

A fastfood seller offers 5 sandwiches with the following composition:

	Fromage 3€
	— 1 pain
	— 10g de beurre
	— 2 tranches d’emmental
	
	Jambon-beurre 4€
	— 1 pain
	— 1 tranche de jambon
	— 10g de beurre
	— 10g de salade
	
	Panini 5€
	— 1 pain
	— 1 tranche de jambon
	— 2 tranches d’emmental
	— 1/2tomate
	— 10g de salade
	
	Belge 5€
	— 1 pain
	— 1 steak
	— 50g de frites
	— 20g de mayonnaise
	— 10g de salade
	
	Dieppois 4,50€
	— 1 pain
	— 50g de thon
	— 20g de mayonnaise
	— 10g de salade

You can ask to double an ingredient already present in a sandwich.

You can add ingredients: bread, ham (1 slice), Butter (10g), salad (10g), emmental (2 slices), ketchup (10g), mustard(20g), fries (50g), tomato (12), Steak, tuna (50g). However, any sandwich contains at most one meat(ham, steak, tuna).

You can also require to delete an ingredient.

The addition, doubling or deletion of an ingredient is billed 0.5€.

We want to write a program which takes the order of sandwiches as input, for example:
	
	1 belge
	3 paninis dont 2 avec frites mais sans jambon et 1 sans tomate
	3 belges dont 1 sans steak mais avec double frites

After running the program, the client will receive a facture:

	1 belge 5.00
	3 paninis 15.00
	2 avec frites 1.00
	2 sans jambon 1.00
	1 sans tomate 0.50
	3 belges 15.00
	1 sans steak 0.50
	1 avec double frites 0.50
	Total : 38.50
	
The seller will receive an inventory of ingredients required in CSV format:
	
	pain,7
	jambon,1
	beurre,0
	salade,70
	emmental,6
	ketchup,0
	moutarde,0
	mayonnaise,80
	frites,250
	tomate,1
	steak,3
	thon,0
	
The kitchen will receive a HTML page of which sandwich to prepare:

	<html>
		<head>
			<title>Cuisine</title>
	 	</head>
	 	<body>
	  		<h1>Panini</h1>
	   			<ul>
		 			<li>1 sans tomate</li>
		 			<li>2 avec frites mais sans jambon</li>
	   			</ul>
	  		<h1>Belge</h1>
	   			<ul>
		 			<li>3 normaux</li>
		 			<li>1 sans steak mais avec double frites</li>
	   			</ul>
	 	</body>
    </html>
