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
InputCharacter = [^\r\n]

// Acepta enteros y decimales
cantidad = [0-9]+(\.[0-9]+)?

unidad = "g" | "gramos" | "kg" | "kilo gramo" | "u" | "unidades"

// Agregada tilde en azúcar y sin acentos como alternativa
ingrediente = "tomate" | "lechuga" | "harina" | "azúcar" | "azucar" | "huevo"

%%
   
<YYINITIAL> {
	{ingrediente}	{ System.out.print(yytext()+" "); return symbol(sym.ING, yytext());}
	{cantidad}      { System.out.print(yytext()+" "); return symbol(sym.QUANTITY, Double.parseDouble(yytext()));} 
	{unidad}        { System.out.print(yytext()+" "); return symbol(sym.UNIT, yytext());}
	{LineTerminator} { System.out.println(); /* ignorar saltos de línea */ }
	{WhiteSpace}    { /* skip */ }   
}

[^]                    { throw new Error("Illegal character: '" + yytext() + "' (ASCII: " + (int)yytext().charAt(0) + ")"); }