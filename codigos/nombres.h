vector<string> buffer;
int longitud = 0;

// Capitaliza la primera letra de la última palabra de txt
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

// Pasa a minúscula txt
void minuscula(string& txt){
    for(int i = 0; i < txt.length(); i++){
        txt[i] = tolower(txt[i]);
    }
}

// Añade el nombre al buffer
void anadir_nombre(string txt){
    minuscula(txt);
    capitalizar_ult(txt);

    buffer.push_back(txt);
    longitud++;
}

// Imprime el nombre, en caso de ser válido
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
