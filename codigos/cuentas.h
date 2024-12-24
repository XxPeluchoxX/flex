// Calcula el resto de num entre 97
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

// Imprime el IBAN, en caso de ser correcto
void confirmar_cuenta(string txt){
    // 1. Elimina los espacios y pasa los caracteres a mayuscula
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

    // 2. Imprime el IBAN, en caso de ser correcto
    if(iban_correcto(iban))
        cout << "IBAN: " << iban << endl;
}

