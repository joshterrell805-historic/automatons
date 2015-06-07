require 'psych'

class FormatFullName
   data = Psych.load_file 'res/format_fullname_data.yaml'
   @@Specialcase = data['specialcase']
   @@Replace = data['replace']
   @@Prefixes = data['prefixes']
   @@Suffixes = data['suffixes']
   @@Credentials = data['credentials']

   # returns an prefix, suffix, or medical credential found in the split name
   def FormatFullName.parseSplitName(splitname, type)
      item = ""
      if type == 'prefix'
         t = @@Prefixes
      elsif type == 'suffix'
         t = @@Suffixes
      else
         t = @@Credentials
      end
      for s in t
         for n in splitname
            if n == s
               item = s
	    end
	 end
      end
      return item
   end
    
   #def FormatFullName.checkSpecialCases(name)
   #   @@Specialcase.each do |key, value|
   #   if name == key
   #	     return True
   #	  end
   #	        return False
   #		 end
   #   return True
   #end
   
   # returns full name string with problem sub-strings replaced and commas and periods removed
   def FormatFullName.cleanFullName(name)
      name = name.sub(',','').sub('.','')
      @@Replace.each do |key, value|
         if name.include? key
            name = name.sub(key, value)
         end
      end
      return name
   end
		 

   def FormatFullName.formatName(name)
      # begin by cleaning name for formatting
      name = cleanFullName(name)

      # split name on white space into list of sub strings
      splitname = name.split()
      fullcredentials = []

      # parse prefixes, suffixes, and prefixes from split name
      prefix = FormatFullName.parseSplitName(splitname, 'prefix')
      suffix = FormatFullName.parseSplitname(splitname, 'suffix')
      while (credential = FormatFullName.parseSplitName(splitname, 'credential')) != ''
         fullcredentials.push(credential)
         splitname.delete(credential)
      end

      # parse first and middle name from split name
      firstname = splitname.shift
      middlename = splitname.length > 1 ? splitname.shift : ''
      lastname = splitname.join(' ').gsub(/\w+/) do |word|
         word.capitalize
      end

      # combine formatted full name and return
      fullname =
         prefix.capitalize + "|" +
         firstname.capitalize + "|" +
         middlename.capitalize + "|" +
         lastname + "|" + 
         suffix.capitalize + "|" +
         (fullcredentials ? (fullcredentials.sort!).join(',') : '')
      return fullname
   end
   
end

#puts FormatFullName::formatName "Muhammad A Khan"
#puts FormatFullName::formatName "Negar FNP Khaefi"
#puts FormatFullName::formatName "Leah Gaedeke - Bc FNP"
