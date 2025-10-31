package uy.edu.um;

import java.io.FileReader;
import java_cup.runtime.*;

public class Main {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Uso: java Main <archivo_recetario.txt>");
            return;
        }

        try {
            // Crear el lexer y el parser
            Lexer lexer = new Lexer(new FileReader(args[0]));
            parser p = new parser(lexer);

            System.out.println("🍳 Iniciando análisis del recetario...\n");

            // Parsear el archivo
            p.parse();

            // Mostrar resumen final
            System.out.println("\n=== 📊 RESUMEN FINAL ===");
            System.out.println("Total de recetas: " + p.cantRecetas);

            if (p.cantRecetas > 0) {
                System.out.println("Promedio de calorías: " +
                        String.format("%.2f", p.totalCalorias / p.cantRecetas));
                System.out.println("Por dificultad: " + p.resumenDificultad);
            }

            System.out.println("=========================");

        } catch (Exception e) {
            System.err.println("❌ Error durante el análisis: " + e.getMessage());
            e.printStackTrace();
        }
    }
}