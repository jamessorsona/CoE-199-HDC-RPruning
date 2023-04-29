import numpy as np

def redundancy_pruning(bin_reg):
    temp_list = []
    for i in bin_reg:
        temp_list.append(i)
        
    comp = enumerate(np.where(bin_reg[0]==bin_reg[1], bin_reg[0], "False"))
    remove = [i for i in comp if i[1]!="False"]
    temp_list = []
    return_rp = []
    
    for i in bin_reg[2::]:
        for j in remove:
        if int(j[1]) == int(i[int(j[0])]):
            temp_list.append(j)
        remove = temp_list
        temp_list = []
    
    for i in remove:
        return_rp.append(i[0])

    #delete the specified indices in all of the classes
    for i in range(len(bin_reg)):
        temp_list[i] = np.delete(bin_reg[i], return_rp)
    return_list = np.array(temp_list)
    
    return return_list, return_rp
