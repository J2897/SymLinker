import sys
import os

source = sys.argv[1]
dest = sys.argv[2]
file_list = sys.argv[3]

file_list_head = os.path.dirname(file_list)
SH = os.path.dirname(source)
SH_lengh = len(SH)

print 'Generating File Structure from File List . . .'
with open(file_list) as file_0:
	for line in file_0:
		with open(file_list_head + '\\' + 'file_structure.tmp', 'a') as file_1:
			file_1.write('"' + dest + line[SH_lengh:].strip('\r\n') + '"' + ' ' + '"' + line.strip('\r\n') + '"' + '\n')

print 'File Structure: ' + file_list_head + '\\' + 'file_structure.tmp'
print 'Passing the file structure to Windows . . .'
