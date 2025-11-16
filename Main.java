import java.io.*;

public class Main {
    public static void main(String[] args) {
        System.out.println("╔════════════════════════════════════════════╗");
        System.out.println("║   ANALIZADOR DE RECETARIO DIGITAL v1.0    ║");
        System.out.println("╚════════════════════════════════════════════╝\n");
        
        if (args.length == 0) {
            System.err.println("Error: No se especificó archivo de entrada");
            System.err.println("Uso: java Main <archivo.txt>");
            System.err.println("\nEjemplo: java Main recetas.txt");
            System.exit(1);
        }
        
        String archivo = args[0];
        File file = new File(archivo);
        
        if (!file.exists()) {
            System.err.println("Error: El archivo '" + archivo + "' no existe");
            System.exit(1);
        }
        
        if (!file.canRead()) {
            System.err.println("Error: No se puede leer el archivo '" + archivo + "'");
            System.exit(1);
        }
        
        System.out.println("Procesando archivo: " + archivo);
        System.out.println("─────────────────────────────────────────────\n");
        
        FileReader fileReader = null;
        
        try {
            fileReader = new FileReader(file);
            Lexer lexer = new Lexer(fileReader);
            parser parser = new parser(lexer);
            
            parser.parse();
            
            System.out.println("─────────────────────────────────────────────");
            System.out.println("✓ Análisis completado exitosamente");
            
        } catch (FileNotFoundException e) {
            System.err.println("\n✗ Error: Archivo no encontrado");
            System.err.println("   " + e.getMessage());
            System.exit(1);
            
        } catch (IOException e) {
            System.err.println("\n✗ Error de lectura del archivo:");
            System.err.println("   " + e.getMessage());
            System.exit(1);
            
        } catch (Exception e) {
            System.err.println("\n✗ Error durante el análisis:");
            System.err.println("   " + e.getMessage());
            if (args.length > 1 && args[1].equals("--debug")) {
                e.printStackTrace();
            }
            System.exit(1);
            
        } finally {
            if (fileReader != null) {
                try {
                    fileReader.close();
                } catch (IOException e) {
                    System.err.println("Advertencia: No se pudo cerrar el archivo");
                }
            }
        }
    }
}