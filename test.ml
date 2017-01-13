open Functions

let lexbuf = Lexing.from_channel stdin

let verify c = print_string (if verify_commandes c then "\nOkay.\n" else "\nErreur.\n")

let my_exit c = exit ( if verify_commandes c then 0 else 1)
let _ =
    let ast = Parser.s (Lexer.token) lexbuf in
    verify ast;
	
    print_string(aggregated_versions_to_string(process_versions(ast)));
   
    print_string(list_to_string(quantite_commandes_real ast)); (* 2.2.1 Ex5 *)

    print_string("Facture:\n");

    print_string(print_facture ast);

    print_newline ();

    print_string("Inventaire:\n");

    print_string(inventaire ast);

    print_string("HTML:\n");
    
    print_string(print_cuisine ast);

    print_newline ();
    my_exit ast;


