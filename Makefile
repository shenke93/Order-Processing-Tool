all:
	ocamlc -c ast.ml
	ocamlc -c functions.ml
	ocamllex lexer.mll
	ocamlyacc -v parser.mly
	ocamlc -c parser.mli
	ocamlc -c lexer.ml
	ocamlc -c parser.ml
	ocamlc -c test.ml

	ocamlc -o out ast.cmo functions.cmo lexer.cmo parser.cmo test.cmo

clean:
	rm -rf out *.cmi *.cmo 

