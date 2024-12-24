%{
#include<iostream>
#include<sstream>
#include<string>
#include<vector>
using namespace std;

// Funciones para cada módulo
#include "nombres.h"
#include "telefonos.h"
#include "dni.h"
#include "correos.h"
#include "cuentas.h"

%}

%option noyywrap

/* Reglas globales */
NUMERO          [0-9]
LETRA           [a-zA-Z]
NUM_LET         {NUMERO}|{LETRA}
SEPARADOR       (\.|-|" ")

/* Nombres */
ARTICULO        (del?|los?|las?|el|todos)
NOMBRE          [a-zA-ZáéíóúñÁÉÍÓÚÑ]+
NOM_COMPUESTO   ({ARTICULO}" "+({ARTICULO}" "+)*{NOMBRE})

/* Teléfonos */
PREFIJO         \+" "*\(?" "*[0-9]{1,3}" "*\)?
TELEFONO        {PREFIJO}?{SEPARADOR}*({NUMERO}{SEPARADOR}*){9}

/* DNIs / NIEs */
DNI_NIE         ({NUMERO}|{LETRA}" "*){NUMERO}{7}" "*{LETRA}

/* Correos */
CORREO          {LETRA}({NUM_LET}|_)*@{LETRA}+(\.{LETRA}+)+\.?

/* Cuentas bancarias */
CUENTA          {LETRA}{2}" "*{NUMERO}{2}" "*({NUMERO}{4}" "*){5}

%%

\n  {
    confirmar_nombre();
}

({NOMBRE}|{NOM_COMPUESTO})   {
    anadir_nombre(yytext);
}

{TELEFONO} {
    confirmar_telefono(yytext);
}

{DNI_NIE}  {
    confirmar_dninie(yytext);
}

{CORREO}   {
    confirmar_correo(yytext);
}

{CUENTA}   {
    confirmar_cuenta(yytext);
}

.   {/* Ignora cualquier caracter no reconocido */}

%%

int main(){
    yylex();
    return 0;
}
