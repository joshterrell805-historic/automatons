import java.util.HashMap;

public class MergeAccelerator {
   public String test(HashMap<String, String> things) {
      for(Object o:things.keySet()) {
         System.out.println(o.getClass());
      }
      System.out.println(things.get("type"));
      return "done";
   }

   public static int edit_dist(int weight, Object val1, Object val2) {
      int happy;
      int sad;

      if (weight > 0) {
         happy = weight;
         sad = 0;
      } else {
         happy = 0;
         sad = weight;
      }

      if (val1.equals(val2)) {
         return happy;
      } else {
         return sad;
      }
   }

   public static int edit_dist(int weight, int val1, int val2) {
      if (val1 == val2) {
         return weight;
      } else {
         return 0;
      }
   }

   public static Integer rule_total(Object[] fields, int weight, HashMap record, HashMap other) {
      int total = 0;
      for (Object field : fields) {
         Object val1 = record.get(field);
         Object val2 = other.get(field);

         if (val1 == null || val2 == null) {
            return null;
         }

         total += MergeAccelerator.edit_dist(weight, val1, val2);
      }

      return total;
   }

   public static Integer score_records(HashMap[] rules, HashMap record, HashMap other) {
      int points_possible = 0;
      int total_points = 0;

      for (HashMap rule : rules) {
         long weight = (Long) rule.get("weight");
         Object[] fields = (Object[]) rule.get("fields");
         Integer rule_total = MergeAccelerator.rule_total(fields, (int) weight, record, other);
         if (rule_total != null) {
            if (weight > 0) {
               points_possible += weight;
            }
            total_points += rule_total/((float) fields.length);
         }
      }

      if (points_possible > 0) {
         return total_points/points_possible;
      } else {
         return -1;
      }
   }
}
