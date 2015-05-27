$<.each do |line|
   case line
   when /auto_increment/
      puts line.sub(/int (.*) ((primary|key|auto_increment)\s*){3},/, 'integer \1 primary key autoincrement,')
   when /enum/
      puts line.sub(/enum\(.*?\)/, 'text')
   when /\bint\b/
      puts line.sub(/\bint\b/, 'integer')
   else
      puts line
   end
end
