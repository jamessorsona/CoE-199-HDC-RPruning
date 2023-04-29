import numpy as np

def dimension_sparsifier(bin_reg, remove_idx):
    comp = enumerate(np.where(bin_reg[0]==bin_reg[1], bin_reg[0], "False"))
    remove = [i for i in comp if i[1]!="False"]
    new_list = []
    
    for i in bin_reg[2::]:
        for j in remove:
            if int(j[1]) == int(i[int(j[0])]):
                new_list.append(j)
        remove = new_list
        new_list = []
    
    for i in remove:
        remove_idx.append(i[0])
    
    #delete the specified indices in all of the classes
    for i in range(len(bin_reg)):
        bin_reg[i] = np.delete(bin_reg[i], remove_idx)

