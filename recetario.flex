import java_cup.runtime.*;

%%

/* ------------Opciones y Declaraciones de JFlex----------- */

%class Lexer
%line                 // Habilita el contador de líneas (yyline)
%column               // Habilita el contador de columnas (yycolumn)
%cup                  // Genera código compatible con CUP (el parser)
%unicode              // Soporta caracteres Unicode (ñ, á, etc.)

%{
    // Método auxiliar para crear un Symbol sin valor
    // Se usa para terminales simples como ":", ",", etc.
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    // Método auxiliar para crear un Symbol con un valor asociado
    // Se usa para terminales que llevan datos: NUMBER, STRING, ID, etc.
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ------------Definiciones de Expresiones Regulares----------- */

// Caracteres básicos
LineTerminator = \r|\n|\r\n              // Saltos de linea
WhiteSpace     = [ \t\f]                 // Espacios en blanco y tabuladores
Digit          = [0-9]                   // Dígitos del 0 al 9
Letter         = [a-zA-ZáéíóúÁÉÍÓÚñÑ']  // Se incluye tildes

// Números y fracciones
Number         = {Digit}+([\.,]{Digit}+)?
Fraction       = {Digit}+[ \t]*"/"+[ \t]*{Digit}+

// Identificadores y strings
Identifier     = {Letter}({Letter}|{Digit}|[_-])*   // Ej: harina, aceite_oliva
String         = \"[^\"]*\"                          // Texto entre comillas

// Unidades de medida
UnidadPeso     = ("g"|"gramos"|"kg"|"kilogramos")
UnidadVolumen  = ("l"|"litros"|"ml"|"mililitros"|"cm3"|"taza"|"tazas")
UnidadCantidad = ("u"|"unidad"|"unidades")
UnidadCuchara  = ("cuchara"|"cucharas"|"cucharita"|"cucharitas")

// Tiempo
TiempoHora     = {Digit}+[ \t]*"h"        // Ej: 2h, 1 h
TiempoMin      = {Digit}+[ \t]*("min"|"m"|"'")  // Ej: 30min, 15m, 20'

// Categorías predefinidas (palabras clave)
Categoria      = "Desayuno"|"Merienda"|"Principal"|"Entrada"|"Colacion"|"Postre"

// Niveles de dificultad
Dificultad     = "FACIL"|"MEDIA"|"DIFICIL"|("MUY"[ \t]+"FACIL")|("MUY"[ \t]+"DIFICIL")|"EXPERTO"|"ALTA"|"BAJA"

// Tipos de receta
TipoReceta     = "VEGETARIANO"|"VEGANO"|"PROTEICO"|"BAJO EN CALORIAS"|"SIN GLUTEN"|"SIN LACTOSA"

// Estrellas para dificultad (*, **, ***)
Estrellas      = "*"+

%%

/* ------------------------Reglas Léxicas---------------------- */

<YYINITIAL> {    
    "Recetas relacionadas"  { return symbol(sym.RECETAS_REL); }
    "INGREDIENTES"          { return symbol(sym.INGREDIENTES); }
    
    // Distintas formas de escribir categorias
    "Categorias"            { return symbol(sym.CATEGORIAS); }
    "Categorías"            { return symbol(sym.CATEGORIAS); }
    "categorias"              { return symbol(sym.CALORIAS); }
    
    // Distintas formas de escribir calorias
    "Calorias"              { return symbol(sym.CALORIAS); }
    "Calorías"              { return symbol(sym.CALORIAS); }
    "CALORIAS"              { return symbol(sym.CALORIAS); }
    "calorias"              { return symbol(sym.CALORIAS); }
    
    "Dificultad"            { return symbol(sym.DIFICULTAD_LABEL); }
    "Porciones"             { return symbol(sym.PORCIONES); }
    "RECETAS"               { return symbol(sym.RECETAS_KEYWORD); }
    "RECETA"                { return symbol(sym.RECETA); }
    "PASOS"                 { return symbol(sym.PASOS); }
    "Tiempo"                { return symbol(sym.TIEMPO); }
    "Origen"                { return symbol(sym.ORIGEN); }
    "CARRITO"               { return symbol(sym.CARRITO); }
    "Tipo"                  { return symbol(sym.TIPO); }
    "MENU"                  { return symbol(sym.MENU); }
    "Obs"                   { return symbol(sym.OBS); }
    "Kcal"                  { return symbol(sym.KCAL); }
    "gusto"                 { return symbol(sym.GUSTO); }
    
    {TipoReceta}            { return symbol(sym.TIPO_RECETA, yytext()); }
    {Dificultad}            { return symbol(sym.DIFICULTAD, yytext()); }
    {Categoria}             { return symbol(sym.CATEGORIA, yytext()); }
    {Estrellas}             { return symbol(sym.ESTRELLAS, yytext()); }
    
    // Tiempo con formato especial
    {TiempoHora}            { return symbol(sym.HORA, yytext().trim()); }
    {TiempoMin}             { return symbol(sym.MINUTO, yytext().trim()); }
    
    // Todas las unidades de medida se mapean al mismo token UNIDAD
    {UnidadPeso}            { return symbol(sym.UNIDAD, yytext()); }
    {UnidadVolumen}         { return symbol(sym.UNIDAD, yytext()); }
    {UnidadCantidad}        { return symbol(sym.UNIDAD, yytext()); }
    {UnidadCuchara}         { return symbol(sym.UNIDAD, yytext()); }
    
    ":"                     { return symbol(sym.DOS_PUNTOS); }
    ","                     { return symbol(sym.COMMA); }
    "["                     { return symbol(sym.LBRACKET); }
    "]"                     { return symbol(sym.RBRACKET); }
    "="                     { return symbol(sym.EQUALS); }
    
    // a seguido de espacio (para "a gusto")
    "a"[ \t]+               { return symbol(sym.A); }
    
    // VALORES CON DATOS
    {Fraction}              { return symbol(sym.FRACTION, yytext()); }
    
    // Convertimos el string a Double (reemplazamos coma por punto)
    {Number}                { return new Symbol(sym.NUMBER, Double.valueOf(yytext().replace(',', '.'))); }
    
    // String sin las comillas (substring quita el primer y último carácter)
    {String}                { return symbol(sym.STRING, yytext().substring(1, yytext().length()-1)); }
    
    /* REGLA ESPECIAL PARA EL PUNTO DESPUÉS DE NÚMERO
     * Esta regla es importante para distinguir:
     * - "1. Mezclar..." (número de paso con punto)
     * - "1.5" (número decimal)
     * 
     * Si encontramos número + espacios opcionales + punto, devolvemos el número
     * y "devolvemos" el punto al stream con yypushback(1)
     */
    {Number}[ \t]*"."       { 
        String text = yytext().trim();
        String numPart = text.substring(0, text.length()-1);  // Sacamos el punto
        yypushback(1); // Devolvemos el punto al input para que se procese después
        return new Symbol(sym.NUMBER, Double.valueOf(numPart.replace(',', '.'))); 
    }
    
    // Punto solo
    "."                     { return symbol(sym.DOT); }
    
    // Identificador genérico (debe ir AL FINAL para que las keywords tengan prioridad)
    // Ej: harina, aceite, mezclado, etc.
    {Identifier}            { return symbol(sym.ID, yytext()); }
    
    // CARACTERES A IGNORAR
    {LineTerminator}        { /* ignorar saltos de línea */ }
    {WhiteSpace}            { /* ignorar espacios y tabs */ }
}

// [^] matchea cualquier carácter que no haya sido reconocido antes
[^]                         { 
    throw new Error("Caracter ilegal en linea " + (yyline+1) + ": '" + yytext() + "'"); 
}