@echo off
echo === Compilando Programa ===

set JFLEX_HOME=jflex
%JFLEX_HOME%\bin\jflex sandwich.flex

java -jar java-cup-11b.jar sandwich.cup

javac -cp java-cup-11b-runtime.jar *.java

echo === Corriendo Recetario ===

set JFLEX_HOME=jflex
%JFLEX_HOME%\bin\jflex ingredientes.flex

java -jar java-cup-11b.jar ingredientes.cup

javac -cp java-cup-11b-runtime.jar *.java

echo.

java -cp .;java-cup-11b-runtime.jar Main sandwich.txt
