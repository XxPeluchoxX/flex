%{
#include<iostream>
#include<sstream>
#include<string>
#include<vector>
#include<chrono>
using namespace std;

// Funciones para cada módulo
#include "nombres.h"
#include "telefonos.h"
#include "dni.h"
#include "correos.h"
#include "cuentas.h"
#include "fechas.h"

%}

%option noyywrap

/* Reglas globales */
NUMERO          [0-9]
LETRA           [a-zA-Z]
NUM_LET         {NUMERO}|{LETRA}
SEPARADOR       (\.|-|" "|\/)

/* Nombres */
ARTICULO        (del?|los?|las?|el|todos|DEL?|LOS?|LAS?|EL|TODOS)
NOMBRE          [a-zA-ZáéíóúñÁÉÍÓÚÑ]+
NOM_COMPUESTO   ({ARTICULO}" "+({ARTICULO}" "+)*{NOMBRE})

/* Teléfonos */
PREFIJO         \+" "*\(?" "*[0-9]{1,3}" "*\)?
TELEFONO        {PREFIJO}?{SEPARADOR}*({NUMERO}{SEPARADOR}*){9}

/* DNIs / NIEs */
DNI_NIE         ({NUMERO}|{LETRA}" "*){NUMERO}{7}" "*{LETRA}

/* Correos */
CORREO          {LETRA}({NUM_LET}|_)*@{LETRA}+(\.{LETRA}+)+\.?

/* Cuentas bancarias */
CUENTA          {LETRA}{2}" "*{NUMERO}{2}" "*({NUMERO}{4}" "*){5}

/* Fechas */
PARTICULAS      " "+del?" "+
SEPARADOR_EXT   {SEPARADOR}|{PARTICULAS}

FECHA_SIMPLE        {NUMERO}{1,4}{SEPARADOR_EXT}+{NUMERO}{1,4}{SEPARADOR_EXT}+{NUMERO}{1,4}

/* Fechas con mes escrito */
meses               ene|feb|mar|abr|may|jun|jul|ago|sep|oct|nov|dic
MESES               ENE|FEB|MAR|ABR|MAY|JUN|JUL|AGO|SEP|OCT|NOV|DIC
Meses               Ene|Feb|Mar|Abr|May|Jun|Jul|Ago|Sep|Oct|Nov|Dic
Nombres_Meses       Enero|Febrero|Marzo|Abril|Mayo|Junio|Julio|Agosto|Septiembre|Octubre|Noviembre|Diciembre
Nombres_meses       enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre
Nombres_MESES       ENERO|FEBRERO|MARZO|ABRIL|MAYO|JUNIO|JULIO|AGOSTO|SEPTIEMBRE|OCTUBRE|NOVIEMBRE|DICIEMBRE
MES                 {meses}|{Meses}|{MESES}
Nombre_Mes          {Nombres_Meses}|{Nombres_meses}|{Nombres_MESES}

FECHA_MES           {NUMERO}{2}({SEPARADOR}+|{PARTICULAS})({MES}|{Nombre_Mes})({SEPARADOR}+|{PARTICULAS}){NUMERO}{4}

/* Fechas con día de la semana */
Dias                Lunes|Martes|Miercoles|Miércoles|Jueves|Viernes|Sábado|Sabado|Domingo
dias                lunes|martes|miercoles|miércoles|jueves|viernes|sábado|sabado|domingo
D                   [LMXJVSDlmxjvsd]
Dia                 {Dias}|{dias}|{D}

Fecha_Completa      {Dia},?{SEPARADOR}+{FECHA_MES}
Fecha_Dia_Semana    {Dia},?{SEPARADOR}+{FECHA_SIMPLE}

%x DIA MES ANIO DIA_SEPARADOR MES_SEPARADOR ANIO_SEPARADOR

%%

{Dia}   { BEGIN(DIA); dia_semana = yytext; }

({NOMBRE}|{NOM_COMPUESTO})   {
    anadir_nombre(yytext);
}

{TELEFONO} {
    confirmar_telefono(yytext);
}

{DNI_NIE}  {
    confirmar_dninie(yytext);
}

{CORREO}   {
    confirmar_correo(yytext);
}

{CUENTA}   {
    confirmar_cuenta(yytext);
}




{FECHA_SIMPLE}  { BEGIN(INITIAL); fecha_simple = yytext; confirmar_fecha(); }

{NUMERO}{2}     { BEGIN(MES); dia = yytext; }

<DIA>,?{SEPARADOR}+     { BEGIN(DIA_SEPARADOR); }

<DIA_SEPARADOR>{FECHA_SIMPLE}     { BEGIN(INITIAL); fecha_simple = yytext; confirmar_fecha(); }

<DIA_SEPARADOR>{NUMERO}{1,2}    { BEGIN(MES); dia = yytext; }

<MES>{SEPARADOR}+|{PARTICULAS}  { BEGIN(MES_SEPARADOR); }

<MES_SEPARADOR>{MES}|{Nombre_Mes}   { BEGIN(ANIO); mes = yytext; }

<ANIO>{SEPARADOR}+|{PARTICULAS}     { BEGIN(ANIO_SEPARADOR); }

<ANIO_SEPARADOR>{NUMERO}{4}     { BEGIN(INITIAL); anio = yytext; confirmar_fecha(); }

<INITIAL,DIA,MES,ANIO,DIA_SEPARADOR,MES_SEPARADOR,ANIO_SEPARADOR>\n     { BEGIN(INITIAL); limpiarCamposGlobales(); confirmar_nombre(); }



.   {/* Ignora cualquier caracter no reconocido */}

%%

int main(){
    yylex();
    return 0;
}
