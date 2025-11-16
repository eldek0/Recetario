import java_cup.runtime.*;

%%

%class Lexer
%line
%column
%cup
%unicode

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

LineTerminator = \r|\n|\r\n
WhiteSpace     = [ \t\f]
Digit          = [0-9]
Letter         = [a-zA-ZáéíóúÁÉÍÓÚñÑ']

Number         = {Digit}+(\.{Digit}+)?
Fraction       = {Digit}+"/"{Digit}+

Identifier     = {Letter}({Letter}|{Digit}|[_-])*
String         = \"[^\"]*\"

UnidadPeso     = ("g"|"gramos"|"kg"|"kilogramos")
UnidadVolumen  = ("l"|"litros"|"ml"|"mililitros"|"cm3"|"taza"|"tazas")
UnidadCantidad = ("u"|"unidad"|"unidades")
UnidadCuchara  = ("cuchara"|"cucharas"|"cucharita"|"cucharitas")
UnidadGusto    = "gusto"

TiempoHora     = {Digit}+[ \t]?"h"
TiempoMin      = {Digit}+[ \t]?("min"|"m"|"'")

Categoria      = "Desayuno"|"Merienda"|"Principal"|"Entrada"|"Colacion"|"Postre"
Dificultad     = "FACIL"|"MEDIA"|"DIFICIL"|("MUY"[ ]+"FACIL")|("MUY"[ ]+"DIFICIL")|"EXPERTO"|"ALTA"|"BAJA"
Estrellas      = "*"+

%%

<YYINITIAL> {
    "Recetas relacionadas:" { return symbol(sym.RECETAS_REL); }
    "INGREDIENTES:"         { return symbol(sym.INGREDIENTES); }
    "Categorias:"           { return symbol(sym.CATEGORIAS); }
    "Categorías:"           { return symbol(sym.CATEGORIAS); }
    "Calorias:"             { return symbol(sym.CALORIAS); }
    "Calorías:"             { return symbol(sym.CALORIAS); }
    "Dificultad:"           { return symbol(sym.DIFICULTAD_LABEL); }
    "Porciones:"            { return symbol(sym.PORCIONES); }
    "RECETAS"               { return symbol(sym.RECETAS_KEYWORD); }
    "RECETA"                { return symbol(sym.RECETA); }
    "PASOS:"                { return symbol(sym.PASOS); }
    "Tiempo:"               { return symbol(sym.TIEMPO); }
    "Origen:"               { return symbol(sym.ORIGEN); }
    "CARRITO"               { return symbol(sym.CARRITO); }
    "Tipo:"                 { return symbol(sym.TIPO); }
    "MENU"                  { return symbol(sym.MENU); }
    "Obs:"                  { return symbol(sym.OBS); }
    "Kcal"                  { return symbol(sym.KCAL); }
    
    {Dificultad}            { return symbol(sym.DIFICULTAD, yytext()); }
    {Categoria}             { return symbol(sym.CATEGORIA, yytext()); }
    {Estrellas}             { return symbol(sym.ESTRELLAS, yytext()); }
    
    {TiempoHora}            { return symbol(sym.HORA, yytext().trim()); }
    {TiempoMin}             { return symbol(sym.MINUTO, yytext().trim()); }
    
    {UnidadPeso}            { return symbol(sym.UNIDAD, yytext()); }
    {UnidadVolumen}         { return symbol(sym.UNIDAD, yytext()); }
    {UnidadCantidad}        { return symbol(sym.UNIDAD, yytext()); }
    {UnidadCuchara}         { return symbol(sym.UNIDAD, yytext()); }
    {UnidadGusto}           { return symbol(sym.GUSTO); }
    
    ":"                     { return symbol(sym.COLON); }
    ","                     { return symbol(sym.COMMA); }
    "."                     { return symbol(sym.DOT); }
    "["                     { return symbol(sym.LBRACKET); }
    "]"                     { return symbol(sym.RBRACKET); }
    "="                     { return symbol(sym.EQUALS); }
    "a"                     { return symbol(sym.A); }
    
    {Fraction}              { return symbol(sym.FRACTION, yytext()); }
    {Number}                { return symbol(sym.NUMBER, Double.parseDouble(yytext())); }
    
    {String}                { return symbol(sym.STRING, yytext().substring(1, yytext().length()-1)); }
    {Identifier}            { return symbol(sym.ID, yytext()); }
    
    {LineTerminator}        { /* ignorar */ }
    {WhiteSpace}            { /* ignorar */ }
}

[^]                         { throw new Error("Caracter ilegal en linea " + (yyline+1) + ": '" + yytext() + "'"); }