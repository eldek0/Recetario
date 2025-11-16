@echo off
echo === Compilando Programa ===

set JFLEX_HOME=jflex
set NAME=recetario

if not exist target mkdir target

call jflex %NAME%.flex

java -jar jflex/lib/java-cup-11b.jar %NAME%.cup

javac -cp jflex/lib/java-cup-11b-runtime.jar -d target *.java

echo === Corriendo %NAME% ===
echo.

java -cp target;jflex/lib/java-cup-11b-runtime.jar Main %NAME%.txt

pause