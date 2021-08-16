import pandas as pd

"""
   Importing json to try to read it with Python.
   it would generate a "trailing data" error. and before writing code for trying to fix it I will need to 
   open up this file with a json viewer to see details in syntax, and how is it written in general.
"""

#line below causes an error and that is why it is commented out
#df = pd.read_json("receipts.json")
#df

"""
   After some research about json's format and syntax I could execute the following changes
"""


# Current json format is a list of records in a row instead of an single json


# By changing the name of the file in the first open line it can fix the other jsons
jsonDefective = open("receipts.txt", "r")

line = jsonDefective.readline()
jsonArray = []


while len(line) > 0:
  line = line.replace("\n", "")
  jsonArray.append(line)
  line = jsonDefective.readline()

jsonDefective.close()



#list to string with commas for each line, then add the [ and ]
listToString = ",".join(jsonArray)
correctString = "[" + listToString + "]"

#write in a new file
jsonCorrected = open("receiptsCorrected.json" , "w")
jsonCorrected.write( correctString )
jsonCorrected.close()

