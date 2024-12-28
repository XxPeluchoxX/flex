%{
#include<iostream>
using namespace std;

void estandarizar(string txt);
%}

%option noyywrap

DIG     [0-9]
CAR     [a-zA-Z]
CUENTA  {CAR}{2}" "*{DIG}{2}" "*({DIG}{4}" "*){5}

%%

{CUENTA}        {
    estandarizar(yytext);
}

%%

// Calcula el resto entre 97
int mod97(string num){
    int resto = 0;

    for(char c : num){
        resto = (resto * 10 + (c - '0')) % 97;
    }

    return resto;
}

// Comprueba si el iban es correcto
bool iban_correcto(string iban){

    if(iban[0] != 'E' || iban[1] != 'S')
        return false;

    // Convierte las letras a numeros
    int a,b;
    a = 10 + (iban[0] - 'A');
    b = 10 + (iban[1] - 'A');
    
    // Le da la vuelta al IBAN
    string txt = iban.substr(4, 20);
    txt += to_string(a);
    txt += to_string(b);
    txt += iban[2];
    txt += iban[3];

    // Comprueba si el resto es 1
    return mod97(txt) == 1;
}

// Elimina espacios en blanco y cambia a mayuscula
void estandarizar(string txt){
    string iban = "                        ";
    const int NUM = 24;
    int contador = 0;

    for(int i = 0; i < txt.length() && contador < NUM; i++){
        if(isdigit(txt[i])){
            iban[contador] = txt[i];
            contador++;
        }else if(isalpha(txt[i])){
            iban[contador] = toupper(txt[i]);
            contador++;
        }
    }

    if(iban_correcto(iban))
        cout << "IBAN: " << iban << endl;
}

int main(){
    yylex();
    return 0;
}
