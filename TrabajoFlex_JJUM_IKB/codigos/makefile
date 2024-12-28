all: formateador.l
	flex formateador.l
	g++ --std=c++20 lex.yy.c -o formateador
	rm lex.yy.c

clean: formateador
	rm formateador

test: prueba.txt formateador
	cat prueba.txt | ./formateador
