// Variables globales
const int dias_meses[13] = {-1, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
const int centena_actual = 2000;
const int liminf = 1800; 
const int limsup = 2200;

string dia_semana, fecha_simple, dia, mes, anio;


// Funcion para comprobar si un anio es bisiesto
bool esBisiesto(int anio){
    return (anio % 4 == 0 && anio % 100 != 0) || (anio % 400 == 0);
}

// Dada la fecha completa comprueba si el dia de la semana es correcto
bool diaSemanaOK(int dia, int mes, int anio, int dia_semana){
    chrono::year_month_day fecha = chrono::year{anio} / mes / dia;
    int diaCorrecto = chrono::weekday(fecha).c_encoding(); // 0 domingo, 1 lunes ...
    return dia_semana == diaCorrecto;
}

// Devuelve el dia de la semana en numero
int diaSemanaNum(string dia){
    if (dia.length() == 0) return -1;
    switch(toupper(dia[0])){
        case 'D':
            return 0;
            break;
        case 'L':
            return 1;
            break;
        case 'M':
            if (dia.length() > 1 && tolower(dia[1]) == 'i'){
                return 3;
            }else{
                return 2;
            }
            break;
        case 'X':
            return 3;
            break;
        case 'J':
            return 4;
            break;
        case 'V':
            return 5;
            break;
        case 'S':
            return 6;
            break;
        default:
            return -1;
    }
}
 
// Funcion que devuelve el numero de mes
int conversor_mes_numero(string mes){
    if(tolower(mes[0]) == 'e')
        return 1;
    if(tolower(mes[0]) == 'f')
        return 2;
    if (tolower(mes[0]) == 'm' && tolower(mes[2]) == 'r')
        return 3;
    if (tolower(mes[0]) == 'a' && tolower(mes[1]) == 'b')
        return 4;
    if (tolower(mes[0]) == 'm' && tolower(mes[2]) == 'y')
        return 5;
    if (tolower(mes[0]) == 'j' && tolower(mes[2]) == 'n')
        return 6;
    if (tolower(mes[0]) == 'j' && tolower(mes[2]) == 'l')
        return 7;
    if (tolower(mes[0]) == 'a' && tolower(mes[1]) == 'g')
        return 8;
    if (tolower(mes[0]) == 's')
        return 9;
    if (tolower(mes[0]) == 'o')
        return 10;
    if (tolower(mes[0]) == 'n')
        return 11;
    if (tolower(mes[0]) == 'd')
        return 12;
    return -1;
}

// Funcion que dada una fecha simple comprueba si es correcta o no
/* Se permiten los siguientes formatos
    DD-MM-YYYY Este por defecto si hay confusion
    MM-DD-YYYY
    YYYY-MM-DD

    DD-MM-YY Este por defecto si hay confusion
    MM-DD-YY

    En este último formato se cosiderara 20YY si 20YY <= año actual 
                                         19YY si 20YY > año actual

    Las fechas aceptadas iran en el intervalo de 1800-2200
*/ 
bool fecha_simple_ok(int num1, int num2, int num3, int &Dia, int &Mes, int &Anio){
    if (num1 < 100 && num2 < 100 && num3 < 100){
        auto now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
        int anio_actual = (localtime(&now)->tm_year + 1900) % 100;
        if (anio_actual < num3){
            Anio = centena_actual - 100 + num3;
        }else {
            Anio = centena_actual + num3;
        }
    }else { 
        if (num1 >= 1800 && num1 <= 2200){ // Caso que se toma aparte
            Anio = num1;
            if (num2 > 12 || num2 <= 0){
                return false;
            }
            Mes = num2;
            if (num3 <= 0 || num3 > dias_meses[Mes]){
                if (num3 == 29 && esBisiesto(Anio)){
                    Dia = num3;
                }else {
                    return false;
                }
            }
            Dia = num3;
            return true;
        } else if (num3 < liminf || num3 > limsup){
            return false;
        } else {
            Anio = num3;
        }
    } 

    // Comprobamos para los otros 4 casos si cuadra el mes y el anio

    // Caso por defecto (ambos numeros podrian ser un mes y el 
    // comportamiento por defecto es tomar dd/mm)
    if (num1 > 0 && num1 <= 12 && num2 > 0 && num2 <= 12){
        Dia = num1; Mes = num2;
        return true;
    }
    // caso mm/dd
    if (num1 > 0 && num1 <= 12){
        Mes = num1;
        if (num2 <= 0 || num2 > dias_meses[Mes]){
            if (num2 == 29 && esBisiesto(Anio)){
                Dia = num1;
            } else {
                return false;
            }
        }
        Dia = num2;
        return true;
    }
    // caso dd/mm
    if (num2 > 0 && num2 <= 12){
        Mes = num2;
        if (num1 <= 0 || num1 > dias_meses[Mes]){
            if (num1 == 29 && esBisiesto(Anio)){
                Dia = num1;
            } else {
                return false;
            }
        }
        Dia = num1;
        return true;
    }
    
    return false;
}

bool procesaFechaSimple(int &Dia, int &Mes, int &Anio){
    string cad = fecha_simple;
    
    // Saco los numeros que me interesan
    stringstream ss(cad);
    int num1, num2, num3;
    char c;
    ss >> num1;
    // Leo los primeros separadores
    do{
        ss.get(c);
    }while (!isdigit(c));    
    ss.unget();
    ss >> num2;
    
    // Leo los segundos separadores
    do{
        ss >> c;
    }while (!isdigit(c));    
    ss.unget();
    ss >> num3;


    bool output = fecha_simple_ok(num1,num2, num3, Dia, Mes, Anio);


    return output;
}



// Funcion que dice si una fecha completa es correcta
bool procesaFechaMes(int &Dia, int &Mes, int &Anio){
    Dia = stoi(dia);
    Anio = stoi(anio);

    Mes = conversor_mes_numero(mes);

    // Compruebo que la fecha sea coherente
    if (Dia <= 0 || Dia > dias_meses[Mes]){
        if (Dia != 29 || !esBisiesto(Anio)){
            return false;
        }
    }
    if (Anio < liminf || Anio > limsup){
        return false;
    }

    return true;
}


// Funcion que deja los campos globales vacios
void limpiarCamposGlobales(){
    dia_semana = fecha_simple = dia = mes = anio = "";
}


// Funcion que procesa la fecha la forma en la que este 
// e imprime por pantalla si es correcta
void confirmar_fecha(){
    int Dia, Mes, Anio;
    
    bool fecha_correcta;

    // Primero miro si es fecha simple
    if (fecha_simple.length() != 0){
        fecha_correcta = procesaFechaSimple(Dia, Mes, Anio);
    } else {
        fecha_correcta = procesaFechaMes(Dia, Mes, Anio);
    }

    if (fecha_correcta && dia_semana.length() != 0){
        int num_dia = diaSemanaNum(dia_semana);
        fecha_correcta = diaSemanaOK(Dia, Mes, Anio, num_dia);
    }

    // Si sigue todo correcto imprimimos la fecha
    if (fecha_correcta){
        string cad;
        if (to_string(Dia).length() == 1)
            cad += '0';
        cad += to_string(Dia) + '/';
        if (to_string(Mes).length() == 1)
            cad += '0';
        cad += to_string(Mes) + '/';
        cad += to_string(Anio);

        // Imprimo la fecha
        cout << "Fecha: " << cad << endl;
    }
    
    limpiarCamposGlobales();
}
