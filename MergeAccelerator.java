import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.util.HashMap;

public class MergeAccelerator {
   static final Logger l = LogManager.getLogger();
   public int edit_dist(Object val1, Object val2) {
      if (val1.equals(val2)) {
         return 1;
      } else {
         return 0;
      }
   }

   public int edit_dist(int val1, int val2) {
      if (val1 == val2) {
         return 1;
      } else {
         return 0;
      }
   }

   private int rule_resolve(int score, int weight) {
      if (weight > 0) {
         return score * weight;
      } else {
         return (1 - score) * weight;
      }
   }


   public Integer rule_total(Object[] fields, int weight, HashMap record, HashMap other) {
      int total = 0;
      l.trace(fields);
      l.trace(weight);
      for (Object field : fields) {
         l.trace(field);
         Object val1 = record.get(field);
         Object val2 = other.get(field);
         l.trace(val1);
         l.trace(val2);

         if (val1 == null || val2 == null) {
            return null;
         }

         int dist = edit_dist(val1, val2);
         l.trace(dist);
         total += rule_resolve(dist, weight);
      }

      l.trace(total);
      l.trace("Finished rule_total");
      return total;
   }

   public double score_records(HashMap[] rules, HashMap record, HashMap other) {
      double points_possible = 0;
      double total_points = 0;

      l.trace("Start matching");
      l.trace(record);
      l.trace(other);
      for (HashMap rule : rules) {
         l.trace("Start rule");
         l.trace(rule);
         long weight = (Long) rule.get("weight");

         Object field_info = rule.get("fields");
         Object[] fields;
         Integer rule_total;
         if (field_info.getClass() == String.class) {
            fields = record.keySet().toArray();
            rule_total = 0;
            Integer partial_total;
            for (Object key : record.keySet()) {
               Object[] field = {key};
               partial_total = rule_total(field, (int) weight, record, other);
               if (partial_total != null) {
                  if (weight > 0) {
                     points_possible += weight;
                  }
                  total_points += partial_total;
               }
            }
         } else {
            fields = (Object[]) rule.get("fields");
            rule_total = rule_total(fields, (int) weight, record, other);

            if (rule_total != null) {
               if (weight > 0) {
                  points_possible += weight;
               }
               total_points += rule_total/((float) fields.length);
            }
         }

         l.trace("Total points/points possible");
         l.trace(total_points);
         l.trace(points_possible);
      }

      l.trace("Score result");
      l.trace(total_points);
      l.trace(points_possible);
      l.trace(record);
      l.trace(other);
      l.trace("Done with score_records");
      if (points_possible > 0) {
         return total_points/points_possible;
      } else {
         return -1;
      }
   }
}
