@echo off
echo === Compilando Programa ===

set JFLEX_HOME=jflex
set NAME=recetario

:: Crear carpeta target si no existe
if not exist target mkdir target

:: Generar lexer con JFlex
call jflex %NAME%.flex

:: Generar parser con Cup
java -jar java-cup-11b.jar %NAME%.cup

:: Compilar y colocar .class en target
javac -cp java-cup-11b-runtime.jar -d target *.java

echo === Corriendo Recetario ===
echo.

:: Ejecutar desde la carpeta target
java -cp target;java-cup-11b-runtime.jar Main %NAME%.txt