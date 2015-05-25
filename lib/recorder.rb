require 'set'

class Recorder
   attr_accessor :id

   def initialize
      @dirty = {}
      @cleansed = {}
   end
   def add rule, data, result
      field = rule.field
      id = data[@id]
      if result
         @cleansed[field] ||= []
      else
         @dirty[field] ||= []
      end

      cleansed = @cleansed[field]
      dirty = @dirty[field]

      if result
         if dirty
            dirty.delete id
         end
         if not cleansed.include? id
            cleansed << id
         end
      else
         if (not cleansed or not cleansed.include? id) and not dirty.include? id
            dirty << id
         end
      end

   end

   def dirty
      @dirty
   end

   def cleansed
      @cleansed
   end
end
