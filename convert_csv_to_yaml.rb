#!/usr/bin/env ruby
require 'csv'
require 'psych'

lines = CSV.parse($<.read).map.each_with_index do |line, i|
   if i == 0
      next
   end
   if line.length == 4
      field = line[0]
      pos_weight = line[2]
      neg_weight = line[3]

      if pos_weight
         weight = pos_weight.to_i
      else
         weight = neg_weight.to_i * -1
      end
      if field != nil
         {'fields' => field.split(', ').map {|i| i.strip}, 'weight' => weight}
      end
   end
end

real_lines = lines.select {|i| i != nil}
open('table.yaml', 'w') do |io|
   Psych.dump real_lines, io
end
