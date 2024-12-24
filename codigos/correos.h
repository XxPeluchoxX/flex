// Imprime el correo
void confirmar_correo(string txt){
    // Pasa todos los caracteres a minuscula
    for(int i = 0; i < txt.length(); i++){
        txt[i] = tolower(txt[i]);
    }

    cout << "Correo: " << txt << endl;
}

