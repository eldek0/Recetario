@echo off
echo === Compilando Programa ===

set JFLEX_HOME=jflex

:: Crear carpeta target si no existe
if not exist target mkdir target

:: Generar lexer con JFlex
call jflex sandwich.flex

:: Generar parser con Cup
java -jar java-cup-11b.jar sandwich.cup

:: Compilar y colocar .class en target
javac -cp java-cup-11b-runtime.jar -d target *.java

echo === Corriendo Recetario ===
echo.

:: Ejecutar desde la carpeta target
java -cp target;java-cup-11b-runtime.jar Main sandwich.txt