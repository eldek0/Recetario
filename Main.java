import java.io.*;

public class Main {
    public static void main(String[] args) {
        System.out.println("╔════════════════════════════════════════════╗");
        System.out.println("║   ANALIZADOR DE RECETARIO DIGITAL v1.0    ║");
        System.out.println("╚════════════════════════════════════════════╝");
        
        if (args.length == 0) {
            System.err.println("Uso: java Main <archivo.txt>");
            System.exit(1);
        }
        
        try {
            FileReader fileReader = new FileReader(args[0]);
            Lexer lexer = new Lexer(fileReader);
            parser parser = new parser(lexer);
            
            parser.parse();
            
            System.out.println("\n✓ Análisis completado exitosamente");
            
        } catch (Exception e) {
            System.err.println("\n✗ Error durante el análisis:");
            e.printStackTrace();
            System.exit(1);
        }
    }
}