#

specialcase = {}

specialcase['Doctor Test MD']			= ['Dr, MD','','','Test'] # 
specialcase['Test Doctor Test Doctor']	= ['Dr','','','Test'] # 
specialcase['NOAH GILSON M D MD']		= ['MD','Noah','','GILSON'] # M D ambiguous and should be handled manually
specialcase['MD Brian Steingo M D Dr']	= ['Dr, MD','Brian','','Steingo'] # M D ambiguous and should be handled manually
specialcase['MD Jeffrey M D Sponsler']	= ['MD','Jeffrey','','Sponsler'] # M D ambiguous and should be handled manually
specialcase['Miodrag 914 962 - 8267 Velickovic'] = ['MD, PC','Miodrag','','Velickovic'] # http://www.hipaaspace.com/Medical_Billing/Coding/National_Provider_Identifier/Codes/NPI_1750554705.txt : 914 962-8267 is fax number
specialcase['B.v. Chandramouli']		= ['','B','V','Chandramouli'] # http://www.healthgrades.com/physician/dr-b-chandramouli-yxdc6
specialcase['THOMAS ERIC PA MOOSE RPA-C'] = ['PA, RPA-C','Thomas','Eric','Moose'] # title should be outside other name fields
specialcase['RAJGURU DO']				= ['DO','Shailesh','U','Rajguru'] # http://www.healthgrades.com/physician/dr-shailesh-rajguru-x82b9
##############################################
## INCOMPLETE!!! - - Charles H Bell MHA LLL ##
##############################################
specialcase['Rena Holzer MS APRN BC FNP'] = ['ARPN, MS, FNP-BC','Rena','','Holzer'] # typo that title parsing would not catch
specialcase['PSYCHOLOGIST John W Lewis'] = ['PHD','John','W','Lewis'] # http://johnlewisphd.com/
specialcase['Leah Gaedeke - Bc FNP'] 	= ['FNP-BC','Leah','','Gaedeke'] #
#############################################
## INCOMPLETE!!! - - Richard Hamer M D P A ##
#############################################


replace = {}

replace['- -'] 					= '-'
replace[' - '] 					= '-'
replace['(NP)'] 				= 'NP'
replace['(ASCP)'] 			= 'ASCP'
replace['A-SLP'] 				= 'SLP-A'
replace['APN-CPNP'] 		= 'APN CPNP'
replace['APN/NP']				= 'APN NP'
replace['ARRT-RT(R)'] 	= 'ARRT(R) RT'
replace['ARRT (R)(CT)'] = 'AART(R)(CT)'
replace['BC FMP'] 			= 'FMP-BC'
replace['BSC (PHARM);RPH'] = 'BSPHARM RPH'
replace['CCC SLP'] 			= 'CCC-SLP'
replace['CCC/SLP'] 			= 'CCC-SLP'
#replace['LCPC'] 				= 'LPC'
replace['LM&FT'] 				= 'LMFT'
replace['M;BB;S'] 			= 'MBBS'
replace['MACCC/SLP'] 		= 'MA CCC-SLP'
replace['MDFAAP'] 			= 'MD FAAP'
replace['MT(ASCP)'] 		= 'MT ASCP'
replace['NMD'] 					= 'ND'			# ND and NMD are interchangeable
replace['NP/CNS']				= 'NP CNS'
replace['PHARM-D'] 			= 'PHARMD'
replace['PHARM D'] 			= 'PHARMD'
replace['RN-SA-C'] 			= 'RN SA-C'

# MAY CAUSE ISSUES WITHOUT REGEX
#replace['DR'] 					= 'Dr'
#replace['DM D'] 				= 'DMD'
#replace['M D'] 				= 'MD'
#replace['RP'] 					= 'RCP'

replace['(OPTOMETRIST)']        = ''
replace['ACUPUNCTURE'] 	        = ''
replace['ACUPUNCTURIST']        = ''
replace['BACHELOR IN PSYCHOLO']	= 'BSP'
replace['CHIROPRACTOR']         = 'DC'
replace['CLINICAL PSYCHOLO'] 	  = ''
replace['DENTIST'] 			        = 'DDS'
replace['DIPL PSYCH'] 	        = ''
replace['DIPLOMATE'] 		        = ''
replace['DISPENSING OPTICIAN'] 	= ''
replace['DOCTOR'] 				      = 'Dr'
replace['DOCTOR OF OPTOMETRY'] 	= 'OD'
replace['DOCTOR OF PSYCH'] 		  = 'PSYD'
replace['DOCTORATE'] 			      = 'MD'
replace['FAMILY NURSE PRACTIT']	= ''
replace['HEARING AID DISPENSE'] = 'HAD'
replace['HEARING AID SPECIAL'] 	= 'HIS'
replace['HEARING SPECIALIST'] 	= 'HIS'
replace['HOSPITALIST'] 			    = 'HOS'
replace['LAC DIPL OF AC'] 		  = ''
replace['LAC DIPL OM'] 		    	= ''
replace['LAC DIPLOM'] 			    = ''
replace['LICENSE PSYCHOLOGIST'] = ''
replace['MCP LPC CANDIDATE'] 	  = ''
replace['MEDICAL DOCTOR'] 		  = 'MD'
replace['MEDICAL STUDENT'] 		  = 'MS'
replace['Nurse'] 				        = ''
replace['NURSE PRACTITIONER'] 	= 'NP'
replace['NURSE PRACTITIONER FAM'] = ''
replace['ORTHODONTIST'] 		    = ''
replace['ORTHOTIST'] 			      = ''
replace['OPTICAL DISPENSER'] 	  = ''
replace['OPTICAL SUPPLIERS'] 	  = ''
replace['OPTICIAN'] 			      = ''
replace['OPTOMETRIST'] 		    	= ''
replace['PARAMEDIC'] 			      = ''
replace['Pediatric'] 			      = ''
replace['Pediatric MD'] 		    = ''
replace['PHARMACIST'] 			    = 'PHARMD'
replace['PHARMACY TECHNICIAN '] = 'CPHT'
replace['PHYSICIAN ASSISTANT'] 	= 'PA'
replace['PHYSICIANS ASSISTANT'] = 'PA'
replace['PHYSICAL THERAPIST'] 	= 'PT'
replace['PSYCHIATRY'] 			    = ''
replace['PSYCHOLOGY'] 			    = ''
replace['REGISTER NURSE'] 		  = 'RN'
replace['REGISTERED NURSE'] 	  = 'RN'
replace['REGISTERED OPTICIAN'] 	= ''
replace['SPCH LANGUAGE PATH'] 	= ''
replace['STUDENT'] 				      = 'MS'


titles = [
   'AAHIVS','ABFP','ABO','ABPP','ACNP','ACNP-BC','ACNP-C','AGACNP','AGACNP-C',
      'AGACNP-BC','ANP', 'ANP-BC','ANP-C','AOCNP','APN','APRN','APRN-BC',
	  'APRN-C','ARNP','ARNP-BC','ARNP-C','ARRT(R)','ARRT(R)(CT)','ASCP','ASN',
	  'AT','ATC','ATR','ATR-BC','ATR-C','AU','AUD',
   'BA','BC-ADM','BCNSP','BCPS','BOCO','BOCOP','BPHARM','BSPHARM','BS','BSN',
      'BSP','BSRS','BSW',
   'CATC','CANP','CBE','CCC-A','CCC-SLP','CCM','CCRN','CD','CDA','CDE','CDTC',
      'CEN','CFNP','CF-SLP','CGC','CHN','CHP','CHPA','CHPE','CHPSE','CHSE',
	  'CHSS','CHT','CLE','CLT','CM','CMA','CMA-A','CMA-C','CMCN','CMT','CNA',
	  'CNM','CNM-BC','CNP','CNS','CNS-BC','CNS-LS','CNSC','CNSD','COMT',
	  'COTA/L','CP','CPHT','CPM','CPN','CPNP','CPNP-PC','CPT','CRNA','CRNP',
	  'CRNP-BC','CRNP-PMH','CRT','CRTT','CS','CSCS','CSFA','CSO','CSSD',
	  'CTBS','CVA',
   'DA','DC','DDS','DHSC','DMD','DMIN','DMSC','DN','DNP','DNP-C','DO','DP',
      'DPH','DPM','DPT','Dr','DRNP','DS','DTM&H','DVM',
   'EDD','EMD','EMT-B','EMT-I/85','EMT-I/99','EMT-P',
   'F','FAAEM','FAAFP','FAAN','FAAP','FACC','FACD','FACE','FACEP','FACG',
      'FACFAS','FACOFP','FACOG','FACOS','FACP','FACCP','FACS','FASHP',
	  'FASPEN','FASPS','FCCP','FHM','FICS','FNP','FNP-BC','FNP-C','FP',
	  'FPA','FRCS','FSCAI','FSTS',
   'GNP','GNP-BC',
   'HAD','HOS',
   'IBCLC','IV',
   'LAC','LAT','LCDC','LCPC','LCSW','LCSW-R','LD','LE','LICSW','LISW-S','LLC',
      'LLL','LM','LMCT','LMFT','LMHC','LMHP','LMSW','LMSW-IPR','LMT','LP',
	  'LPC','LPC-S','LPN','LVN','LVT',
   'MA','MAC','MACP','MBA','MBBS','MD','ME','MED','MFT','MHA','MHRS','MHS',
      'MLS','MLT','MMS','MMSC','MOT','MOTR/L','MPA','MPAS','MPH','MPHARM',
	  'MPSYNCH','MPT','MRCP(UK)','MS','MSBCBA','MSC','MSE','MSN','MSN(R)',
	  'MSPAS','MSPC','MSPT','MSN','MSW','MT',
   'NBCCH','NBCCH-PS','NBCDCH','NBCDCH-PS','NBCFCH','NBCFCH-PS','NCC','ND',
      'NNP','NNP-BC','NP','NP-BC','NP-C','NRAEMT','NREMR','NREMT','NRP',
   'OD','OCN','OCS','ONC','ONP','ONP-C','OPA-C','OT/L','OTD','OTR','OTR/L',
   'PA','PA-C','PA-S','PC','PD','PT','PTA','PHD','PHARMD','PHN','PLPC',
      'PMHCNS','PMHCNS-BC','PMHCNS-C','PMHNP','PMHNP-BC','PMHNP-C','PNP',
	  'PNP-BC','PSYCH','PSYD','PSYNP','PSYNP-BC','PSYNP-C','PT','PTA',
   'QCSW','QMHA','QMHP',
   'RAS','RAS-CA','RCP','RD','RDA','RDH','RMA','RN','RNA','RNC','RNFA','RPA-C',
      'RPH','RPT','RRT','RRT-ACCS','RRT-NPS','RRT-SDS','RT','RT(T)','RVT',
   'SA-C','SCS','SLP-A','ST',
   'WHNP','WHNP-BC','WHNP-C'
]


def parseTitle(splitname)
   title = ""
   for s in titles
      if splitname[0] == s or splitname[-1] == s
         title = s
	  end
   end
   return title
end
   

def formatName(name)
   # check for special cases
   for item in specialcase
      if name == item
	     return specialcase[name]
      end
   end
		 
   # remove commas and periods for formatting
   name = name.replace(',','').replace('.','')
   
   # replace problem substrings
   for instance in replace
      if name.include? instance
	     name = name.replace(instance, replace[instance])
      end
   end
   
   # divide name on whitespace into list of substrings
   splitname = name.split()   
   fulltitle = []

   # parse list of substrings for titles
   while len(splitname) > 2
      title = parseTitle(splitname)
      if title == ""
         break
	  end
      fulltitle.append(title)
      splitname.remove(title)
   end

   # parse first and middle name
   firstname = splitname.pop(0)
   len(splitname) > 1 ? middlename = splitname.pop(0) : '';
   
   # return [ <titles>, <firstname>, <middlename>, <lastname> ]
   fullname = [
      fulltitle ? ', '.join(sorted(fulltitle)) : '',
      firstname.capitalize(),
	  middlename.capitalize(),
	  ' '.join(splitname).title() 
   ]
   return fullname
end
   
