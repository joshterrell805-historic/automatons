import java.util.HashMap;
import java.util.ArrayList;

public class MergeAccelerator {
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
      for (Object field : fields) {
         Object val1 = record.get(field);
         Object val2 = other.get(field);

         if (val1 == null || val2 == null) {
            return null;
         }

         int dist = edit_dist(val1, val2);
         total += rule_resolve(dist, weight);
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
