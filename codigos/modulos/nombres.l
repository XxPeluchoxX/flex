%{
#include<iostream>
#include<sstream>
#include<string>
#include<vector>
using namespace std;

vector<string> buffer;
int longitud = 0;

void anadir_nombre(string cadena);
void confirmar_nombre();

%}

%option noyywrap

ARTICULO    (del?|los?|las?|el|todos)
NOMBRE     [a-zA-ZáéíóúñÁÉÍÓÚÑ]+
COMPUESTO   ({ARTICULO}" "+({ARTICULO}" "+)*{NOMBRE})

%%

\n  {
    confirmar_nombre();
}

{NOMBRE}|{COMPUESTO}   {
    anadir_nombre(yytext);
}

%%

// Capitaliza la ultima palabra
void capitalizar_ult(string& txt){
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

void anadir_nombre(string txt){
    minuscula(txt);
    capitalizar_ult(txt);
    buffer.push_back(txt);
    longitud++;
}

void confirmar_nombre(){

    if(longitud > 1){

        if(longitud == 2){
            cout << "Nombre: " << buffer[0] << " || " << buffer[1] << endl;
        }else{

            // Imprime los nombres
            cout << "Nombre: ";
            for(int i = 0; i < longitud-2; i++){
                cout << buffer[i];
                if(i < longitud-3)
                    cout << " | ";
            }

            // Imprime los apellidos
            cout << " || " << buffer[longitud-2] << " | " << buffer[longitud-1] << endl;
                
        }
    }

    longitud = 0;
    buffer.clear();
}

int main(){
    yylex();
    return 0;
}
