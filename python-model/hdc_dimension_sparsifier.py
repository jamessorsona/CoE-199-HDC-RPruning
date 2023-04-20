import numpy as np

# 04/18/2023 optimized sparsifier
# def dimension_sparsifier(non_bin_reg, dimensionality, sparsity):
#     remove_num = int(sparsity * dimensionality)
    
#     max_list = np.max(non_bin_reg, axis=0)
#     min_list = np.min(non_bin_reg, axis=0)
    
#     var_list = np.subtract(max_list, min_list)
#     var_list_sorted = np.argsort(var_list)
#     remove_list = var_list_sorted[:remove_num]
    
#     non_bin_reg_sparse = np.delete(non_bin_reg, remove_list, axis=1)
    
#     return non_bin_reg_sparse, remove_list

# 04/20 dimension sparsifier
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