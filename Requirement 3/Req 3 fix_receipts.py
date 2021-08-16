import pandas as pd

"""
   Importing json to try to read it with Python.
   it would generate a "trailing data" error. and before writing code for trying to fix it I will need to 
   open up this file with a json viewer to see details in syntax, and how is it written in general.
"""

#line below causes an error and that is why it is commented out
#df = pd.read_json("receipts.json")


"""
   After some research about json's format and syntax I could execute the following changes
"""


# Current json format is a list of records in a row instead of an single json


# By changing the name of the file in the first open line it can fix the other jsons
json_defective = open("receipts.txt", "r")

line = json_defective.readline()
json_array = []


while len(line) > 0:
  line = line.replace("\n", "")
  json_array.append(line)
  line = json_defective.readline()

json_defective.close()



#list to string with commas for each line, then add the [ and ]
list_to_string = ",".join(json_array)
correct_string = "[" + list_to_string + "]"

#write in a new file
json_corrected = open("receipts_corrected.json" , "w")
json_corrected.write( correct_string )
json_corrected.close()

