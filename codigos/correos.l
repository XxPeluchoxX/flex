%{
#include<iostream>
using namespace std;

void estandarizar_correo(string txt);
%}

%option noyywrap

DIGITO      [0-9]
CARACTER    [a-zA-Z]
DIG_CAR     {DIGITO}|{CARACTER}
CORREO      {DIG_CAR}+({DIG_CAR}|_)*@{CARACTER}+(\.{CARACTER}+)+\.?

%%

{CORREO}        {
    estandarizar_correo(yytext);
}

%%

// Pasa todo a minuscula
void estandarizar_correo(string txt){
    for(int i = 0; i < txt.length(); i++){
        txt[i] = tolower(txt[i]);
    }

    cout << "Correo: " << txt << endl;
}

int main(){
    yylex();
    return 0;
}
