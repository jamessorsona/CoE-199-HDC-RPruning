import numpy as np                
import time

# performs logical AND on two hypervectors
def distance(A,B):
    return sum(np.logical_and(A,B))

# permute hypervector
def perm(A,N):
    """ 
    A: hypervector
    N: number of bits to shift
    """
    return np.roll(A,N)

# generate random hypervector
def u_gen_rand_hv(D,d):
    """ 
    D: dimension of hypervector
    d: density of hypervector
    """
    if D % 2 != 0:
        raise ValueError("Error - D must be an even number")
    
    chosen = np.random.choice(D, size=int(D*d), replace=False)
    rand_hv = np.zeros(D, dtype=bool)
    rand_hv[chosen] = True
    
    return rand_hv.astype(int)

# create item memory
def create_item_mem(N,D,d, first=None, last=None):
    """
    N: number of items
    D: dimension of hypervector
    d: density of hypervector
    """
    item_mem = {}

    if first is None:
        first = u_gen_rand_hv(D,d)
    if last is None:
        last = u_gen_rand_hv(D,d)

    item_mem.update({0:first})
    
    for i in range(1,N-1):
        temp_hv = np.concatenate((last[:int((D/(N-1))*(N-i-1))],first[int((D/(N-1))*(N-i-1)):])) 
        item_mem.update({i:temp_hv})

    item_mem.update({N-1:last})

    return item_mem

# encodes a voice sample
def hdc_encode(voice, voice_im, D, d, Q=10, t1=0, remove_list=[]):
    """
    voice: voice sample
    voice_im: item memory
    D: dimension of hypervector
    d: density of hypervector
    Q: quantization factor (default: 10)
    t1: first threshold (default: 0)
    remove_list: list of indices to remove from bundle (default: [])
    """
    voice = np.array(voice)
    voice_quantized = np.where(voice < 1, np.floor(voice * (Q / 2)) + (Q / 2), np.floor((voice - 0.0001) * (Q / 2)) + (Q / 2)).astype(int)
    feature_hv_list = np.array([voice_im[x] for x in voice_quantized])
    feature_hv_list = np.array([perm(feature_hv_list[x], x) for x in range(len(feature_hv_list))])

    threshold = t1  # first threshold
    bundle = np.einsum('ij->j', feature_hv_list)

    if remove_list:
        bundle = np.delete(bundle, remove_list)

    bndl = bundle > threshold
    return bndl.astype(int)

def hdc_enc(args):
    return hdc_encode(*args)

# def dimension_sparsifier(non_bin_reg, dimensionality, sparsity, remove_list):
#     remove_num = int(sparsity * dimensionality)
#     #print(remove_num)
#     max_list = non_bin_reg[0]
#     min_list = non_bin_reg[0]
    
#     for i in range(1,len(non_bin_reg)):
#         max_list = np.maximum(max_list, non_bin_reg[i])
#         min_list = np.where(np.logical_or(min_list>=non_bin_reg[i], min_list==0), non_bin_reg[i], min_list)

#     var_list = np.subtract(max_list, min_list)
#     var_list = sorted(enumerate(var_list), key=lambda x:x[1])
#     idx, value = map(list, zip(*var_list))
#     remove_list = idx[0:remove_num]

#     for i in range(len(non_bin_reg)):
#         np.delete(non_bin_reg[i], remove_list)
#     return non_bin_reg, remove_list

def similarity_search(voice,voice_im,voice_am,D,d,Q,t1, remove_list):
    start = time.time()
    sim_score = 0
    sim_letter = '0'
    test_hv = hdc_encode(voice,voice_im,D,d,Q,t1,remove_list)
    encoding_time = time.time() -start
    start = time.time()
    for each in voice_am.items():
        similarity = np.sum(np.logical_and(test_hv,each[1]))
        if (similarity>sim_score):
            sim_score,sim_letter = similarity, each[0]
  
    return (sim_letter,sim_score,encoding_time, time.time()-start)

def search(args):
    return similarity_search(*args)