pad_file_path = 'C:/Users/GIGABYTE/Desktop/Team9_FP/software/addPadding.txt'
ifmap_path = 'C:/Users/GIGABYTE/Desktop/Team9_FP/software/ifmap.txt'

with open(pad_file_path, 'r') as file:
    content = file.readlines()

with open(ifmap_path, 'a') as new_file:
    padding = ''
    for i in range(len(content)):
        if( i%8==7 ):
            padding = str(content[i].strip()) + padding +'\n'
            new_file.writelines(padding)
            padding = ''
        else:
            padding = str(content[i].strip()) + padding 
            if( i==len(content)-1 ):
                new_file.writelines(padding)

