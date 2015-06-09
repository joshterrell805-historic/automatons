import java.util.HashMap;
import java.util.ArrayList;

public class MergeAccelerator {
   private Levenshtein compare;

   public MergeAccelerator() {
      compare = new Levenshtein();
   }

   /** edit dist returns score 0.0-1.0, 1 being exact match **/
   public double edit_dist(String val1, String val2) {
      return (double) 1 - compare.distance(val1, val2)/Math.max(val1.length(), val2.length());
   }

   public double edit_dist(Object val1, Object val2) {
      if (val1.equals(val2)) {
         return 1.0;
      } else {
         return 0.0;
      }
   }

   public double edit_dist(int val1, int val2) {
      if (val1 == val2) {
         return 1.0;
      } else {
         return 0.0;
      }
   }

   /**
    * This runs the appropriate version of edit_dist on val1 and val2
    */
   public double dispatch(Object val1, Object val2) {
      Class klass = val1.getClass();
      if (klass == String.class) {
         return edit_dist((String) val1, (String) val2);
      } else if (klass == Integer.class) {
         return edit_dist((Integer) val1, (Integer) val2);
      } else {
         return edit_dist(val1, val2);
      }
   }

   private int rule_resolve(double score, int weight) {
      if (weight > 0) {
         return (int)Math.round(score * weight);
      } else {
         return (int)Math.round((1.0 - score) * weight);
      }
   }


   public Integer rule_total(Object[] fields, int weight, HashMap record, HashMap other) {
      int total = 0;
      for (Object field : fields) {
         Object val1 = record.get(field);
         Object val2 = other.get(field);

         if (val1 == null || val2 == null) {
            return null;
         }

         double score = dispatch(val1, val2);
         total += rule_resolve(score, weight);
      }

      return total;
   }

   public Object[] score_records(HashMap[] rules, HashMap record, HashMap other) {
      double points_possible = 0;
      double total_points = 0;

      HashMap rule;
      ArrayList active_rules = new ArrayList();
      ArrayList rule_scores = new ArrayList();
      for (int i = 0; i < rules.length; i++) {
         rule = rules[i];
         long weight = (Long) rule.get("weight");

         Object field_info = rule.get("fields");
         Object[] fields;
         Integer rule_total;
         if (field_info.getClass() == String.class) {
            fields = record.keySet().toArray();
            rule_total = 0;
            Integer partial_total;
            double rule_score = 0;
            boolean active = false;
            for (Object key : record.keySet()) {
               Object[] field = {key};
               partial_total = rule_total(field, (int) weight, record, other);
               if (partial_total != null) {
                  if (weight > 0) {
                     points_possible += weight;
                  }
                  rule_score += partial_total;
                  active = true;
               }
            }
            total_points += rule_score;
            if (active) {
               active_rules.add(i);
               rule_scores.add(rule_score);
            }
         } else {
            fields = (Object[]) rule.get("fields");
            rule_total = rule_total(fields, (int) weight, record, other);

            if (rule_total != null) {
               if (weight > 0) {
                  points_possible += weight;
               }
               double rule_score = rule_total/((float) fields.length);
               total_points += rule_score;
               active_rules.add(i);
               rule_scores.add(rule_score);
            }
         }
      }

      Double points;
      if (points_possible > 0) {
         points = total_points/points_possible;
      } else {
         points = -1.0;
      }
      Object [] ret = {points, active_rules, rule_scores};
      return ret;
   }
}
