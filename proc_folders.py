# http://www.tutorialspoint.com/python/python_command_line_arguments.htm
import sys
import os

source = sys.argv[1]
dest = sys.argv[2]
folder_list = sys.argv[3]

print "Source: " + source
print "Destination: " + dest
print "Folder List: " + folder_list

folder_list_head = os.path.dirname(folder_list)
SH = os.path.dirname(source)
SH_lengh = len(SH)

print 'Generating Folder Structure from Folder List . . .'
with open(folder_list) as file_0:
	for line in file_0:
		with open(folder_list_head + '\\' + 'folder_structure.tmp', 'a') as file_1:
			file_1.write(dest + line[SH_lengh:])

print 'Folder Structure: ' + folder_list_head + '\\' + 'folder_structure.tmp'
print 'Passing the folder structure to Windows . . .'
