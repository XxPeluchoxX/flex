%{
#include<iostream>
using namespace std;

void confirmar_dninie(string txt);
%}

%option noyywrap

DIGITO      [0-9]
LETRA       [a-zA-Z]
DNI_NIE     ({DIGITO}|{LETRA}" "*){DIGITO}{7}" "*{LETRA}

%%

{DNI_NIE}       {
    confirmar_dninie(yytext);
}

%%

const string LETRAS = "TRWAGMYFPDXBNJZSQVHLCKE";
inline char obtenerLetraDNI(long dni){
    return LETRAS[dni % 23];
}

// Comprueba si un DNI es correcto
bool correcto_dni(string dni){
    long num = stol(dni.substr(0, dni.length()-1));
    return dni[dni.length()-1] == obtenerLetraDNI(num);
}

// Comprueba si un NIE es correcto
bool correcto_nie(string nie){
    if (nie[0] != 'X' && nie[0] != 'Y' && nie[0] != 'Z')
        return false;

    switch(nie[0]){
        case 'X':   nie[0] = '0'; break;
        case 'Y':   nie[0] = '1'; break;
        case 'Z':   nie[0] = '2'; break;
    }

    return correcto_dni(nie);
}

//

void confirmar_dninie(string txt){

    // Elimina espacios y convierte letras a mayuscula
    const int NUM = 9;
    int contador = 0;
    int i = 0;

    string dni_nie;

    while(contador < NUM && i < txt.length()){
        if(isdigit(txt[i])){
            dni_nie += txt[i];
            contador++;
        }else if(isalpha(txt[i])){
            dni_nie += toupper(txt[i]);
            contador++;
        }
        i++;
    }

    // Comprueba si es correcto y si lo es lo imprime
    if(isalpha(dni_nie[0])){
        if(correcto_nie(dni_nie))
            cout << "NIE: " << dni_nie << endl;
    }else{
        if(correcto_dni(dni_nie))
            cout << "DNI: " << dni_nie << endl;
    }
}

int main(){
    yylex();
    return 0;
}
