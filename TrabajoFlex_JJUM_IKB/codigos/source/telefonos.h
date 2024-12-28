// Imprime el teléfono, en caso de ser válido
void confirmar_telefono(string txt){

    // 1. Almacena los ultimos NUM digitos de txt en tlf
    string tlf = "         ";
    const int NUM = 9;
    int contador = 0;
    int i = txt.length()-1;

    while(contador != NUM && i >= 0){
        if(isdigit(txt[i])){
            tlf[NUM-contador-1] = txt[i];
            contador++;
        }

        i--;
    }

    // 2. En caso de haber prefijo, lo extrae
    string prefijo;
    bool hay_pref = false;;

    while(i >= 0){
        if(isdigit(txt[i])){
            hay_pref = true;
            prefijo = txt[i] + prefijo;
        }
        i--;
    }

    // 3. Imprime el teléfono
    cout << "Telefono: ";
    if(hay_pref){
        cout << "+" + prefijo + " | ";
    }else{
        cout << "+34" + prefijo + " | ";
    }

    cout << tlf << endl;
}

