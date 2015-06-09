public class Levenshtein {
   private int[][] table;
   private final int length = 255;
   public Levenshtein () {
      table = new int[length][];

      for (int i = 0; i < length; i++) {
         table[i] = new int[length];
         table[i][0] = i;
      }

      for (int j = 0; j < length; j++) {
         table[0][j] = j;
      }
   }

   public double distance(String a, String b) {
      for (int i = 1; i < a.length(); i++) {
         for (int j = 1; j < b.length(); j++) {
            table[i][j] = Math.min(Math.min(table[i-1][j] + 1, table[i][j-1]+1), table[i-1][j-1]+(a.charAt(i) == b.charAt(j) ? 1 : 0));
         }
      }

      return (double) table[a.length()][b.length()];
   }
}
