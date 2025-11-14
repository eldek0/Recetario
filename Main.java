import java.io.*;
   
public class Main {
  static public void main(String argv[]) {    
    /* Start the parser */
    try {
      parser p = new parser(new Lexer(new FileReader(argv[0])));
      Object result = p.parse().value; 
      
      Integer sum = 0;
      for (Integer f : p.table.values()) {
          sum += f;
      }
      System.out.println("total pedidos: " + sum);
    } catch (Exception e) {
      /* do cleanup here -- possibly rethrow e */
      e.printStackTrace();
    }
  }
}


