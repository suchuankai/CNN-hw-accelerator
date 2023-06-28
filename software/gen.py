new_file_path = 'C:/Users/GIGABYTE/Desktop/AOC/addPadding.txt'
mem_path = 'C:/Users/GIGABYTE/Desktop/AOC/ifmap.txt'

with open(new_file_path, 'r') as file:
    content = file.readlines()



with open(mem_path, 'a') as new_file:
    padding = ''
    for i in range(len(content)):
        if(i%8==7):
            padding = str(content[i].strip()) + padding +'\n'

            new_file.writelines(padding)
            #print(padding)
            padding = ''
            
        else:
            padding = str(content[i].strip()) + padding 
            if(i==len(content)-1):
                new_file.writelines(padding)

