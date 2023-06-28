# Specify the file paths
file_path = 'C:/Users/GIGABYTE/Desktop/AOC/output.txt'
new_file_path = 'C:/Users/GIGABYTE/Desktop/AOC/addPadding.txt'

# Open the existing file
with open(file_path, 'r') as file:
    content = file.readlines()

# Open the new file for writing
with open(new_file_path, 'a') as new_file:
    # Insert the 30 lines at the beginning
    padding = "00000000\n"

    # Add zero to first row
    for i in range(30):
        new_file.writelines(padding)

    for i in range(len(content)):
        if( i%28==0 ):  # padding -> data
            new_file.writelines(padding)
            new_file.writelines(content[i])
        elif( i%28==27 ):  # data -> padding
            new_file.writelines(content[i])
            new_file.writelines(padding)
        else:
            new_file.writelines(content[i])
    # Write the content of the existing file
    new_file.writelines('\n')
    for i in range(30):
        new_file.writelines(padding)



