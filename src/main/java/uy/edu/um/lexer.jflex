import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* Expresiones regulares */
ID = [a-zA-ZáéíóúÁÉÍÓÚüÜñÑ_]+
NUM = [0-9]+(\.[0-9]+)?
STRING = \"[^\"]*\"
UNIDAD = (g|kg|l|ml|u|taza|tazas|cuchara|cucharita|cucharas|cucharitas|pizca|"a gusto")
WHITESPACE = [ \t\r\n]+
COMMENT = "//".*

%%

/* Palabras clave */
"RECETA"             { return symbol(ParserSym.RECETA); }
"INGREDIENTES:"      { return symbol(ParserSym.INGREDIENTES); }
"PASOS:"             { return symbol(ParserSym.PASOS); }
"Tiempo:"            { return symbol(ParserSym.TIEMPO); }
"Porciones:"         { return symbol(ParserSym.PORCIONES); }
"Calorías:"          { return symbol(ParserSym.CALORIAS); }
"Categorías:"        { return symbol(ParserSym.CATEGORIAS); }
"Origen:"            { return symbol(ParserSym.ORIGEN); }
"Dificultad:"        { return symbol(ParserSym.DIFICULTAD); }
"Tipo:"              { return symbol(ParserSym.TIPO); }
"Recetas"            { return symbol(ParserSym.RECETAS); }
"RECETAS"            { return symbol(ParserSym.RECETAS); }
"Obs:"               { return symbol(ParserSym.OBS); }
"OBS:"               { return symbol(ParserSym.OBS); }
"CARRITO:"           { return symbol(ParserSym.CARRITO); }
"MENU"               { return symbol(ParserSym.MENU); }
"CALORIAS="          { return symbol(ParserSym.CALORIAS_EQ); }

/* Símbolos */
":"                  { return symbol(ParserSym.COL); }
","                  { return symbol(ParserSym.CM); }
"["                  { return symbol(ParserSym.SO); }
"]"                  { return symbol(ParserSym.SC); }
"="                  { return symbol(ParserSym.EQ); }
"."                  { return symbol(ParserSym.PTO); }

/* Tokens generales - orden importante: más específico primero */
{STRING}             { return symbol(ParserSym.STRING, yytext().substring(1, yytext().length()-1)); }
{NUM}                { return symbol(ParserSym.NUM, Double.parseDouble(yytext())); }
{UNIDAD}             { return symbol(ParserSym.UNIDAD, yytext()); }
{ID}                 { return symbol(ParserSym.ID, yytext()); }

/* Ignorar espacios y comentarios */
{WHITESPACE}         { /* ignorar */ }
{COMMENT}            { /* ignorar */ }

/* Error léxico */
.                    { System.err.println("Carácter no reconocido: '" + yytext() + "' en línea " + (yyline+1) + ", columna " + (yycolumn+1)); }