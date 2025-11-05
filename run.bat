@echo off
echo === Compilando Programa ===

set JFLEX_HOME=jflex

java -jar java-cup-11b.jar sandwich.cup

javac -cp java-cup-11b-runtime.jar *.java

echo === Corriendo Recetario ===
echo.

java -cp .;java-cup-11b-runtime.jar Main sandwich.txt
