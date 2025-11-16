import java.io.*;
import java_cup.runtime.*;

public class Main {
    public static void main(String[] args) {
        try {
            // Leer con UTF-8
            FileInputStream fis = new FileInputStream(args[0]);
            InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
            
            Lexer lexer = new Lexer(isr);
            parser parser = new parser(lexer);
            parser.parse();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}