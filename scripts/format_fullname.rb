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
      result = ""
      if type == 'prefix'
         data = @@Prefixes
      elsif type == 'suffix'
         data = @@Suffixes
      else
         data = @@Credentials
      end
      for item in data
         for name in splitname
            if name == item
               result = name
	        end
	     end
      end
      return result
   end
    
   # returns fully formatted name in case of specific documented issue
   def FormatFullName.checkSpecialCases(name)
      @@Specialcase.each do |key, value|
         if name == key
            name = value
         end
	   end
	   return name
   end
   
   # returns full name string with problem sub-strings replaced and commas and periods removed
   def FormatFullName.cleanFullName(name)
      name = name.sub(',','').sub('.','').upcase
      @@Replace.each do |key, value|
         if name.include? key
            name = name.sub(key, value)
         end
      end
      return name
   end
		 
		 
   def FormatFullName.formatName(name) 
	  # check for special problem cases
	  if FormatFullName.checkSpecialCases(name) != name
	     return FormatFullName.checkSpecialCases(name)
	  end
	  
      # begin by cleaning name for formatting
      name = cleanFullName(name)

      # split name on white space into list of sub strings
      splitname = name.split()
      fullcredentials = []

      # parse prefixes, suffixes, and prefixes from split name
      if (prefix = FormatFullName.parseSplitName(splitname, 'prefix')) != ''
	     splitname.delete(prefix)
	  end
      if (suffix = FormatFullName.parseSplitName(splitname, 'suffix')) != ''
	     splitname.delete(suffix)
      end
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
         prefix + "|" +
         firstname.capitalize + "|" +
         middlename.capitalize + "|" +
         lastname + "|" + 
         suffix + "|" +
         (fullcredentials ? (fullcredentials.sort!).join(',') : '')
      return fullname
   end
   
end

#puts FormatFullName::formatName "Test Doctor Test Doctor"
#puts FormatFullName::formatName ""
#puts FormatFullName::formatName "Bob Jones"
#puts FormatFullName::formatName "Muhammad A Khan"
#puts FormatFullName::formatName "Negar FNP Khaefi"
#puts FormatFullName::formatName "Leah Gaedeke - Bc FNP"
#puts FormatFullName::formatName "DocTOR John 'APPLETINI' PHD Dorian III md bs"
