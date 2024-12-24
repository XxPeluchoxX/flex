%{
#include<iostream>
#include<sstream>
#include<string>
#include<vector>
using namespace std;

vector<string> buffer;
int longitud = 0;

void anadir(string cadena);
void commit();

%}

%option noyywrap

ARTICULO    (del?|los?|las?|el)
PALABRA     [a-zA-ZáéíóúñÁÉÍÓÚÑ]+
COMPUESTO   ({ARTICULO}" "+({ARTICULO}" "+)?{PALABRA})

%%

\n  {
    commit();
}

{PALABRA}|{COMPUESTO}   {
    anadir(yytext);
}

%%

//
// Capitaliza la ultima palabra
void capitalizar(string& txt){
    string ultima_palabra, palabra;
    
    stringstream ss(txt);

    while(ss >> ultima_palabra){
        if(!ss.eof())
        palabra += ultima_palabra + " ";
    }

    ultima_palabra[0] = toupper(ultima_palabra[0]);
    txt = palabra + ultima_palabra;
}

void minuscula(string& txt){
    for(int i = 0; i < txt.length(); i++){
        txt[i] = tolower(txt[i]);
    }
}

void anadir(string txt){
    minuscula(txt);
    capitalizar(txt);
    buffer.push_back(txt);
    longitud++;
}

void commit(){

    if(longitud > 1){
        cout << "Nombre: ";
        for(int i = 0; i < longitud; i++){
            cout << buffer[i];
            if(i != longitud-1)
                cout << " | ";
        }
        cout << endl;
    }

    longitud = 0;
    buffer.clear();
}

int main(){
    yylex();
    return 0;
}
