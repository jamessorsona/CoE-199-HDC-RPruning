import numpy as np                
import time

def distance(A,B):
    return sum(np.logical_and(A,B))

def perm(A,N):
    return np.roll(A,N)

# 04/18/2023 optimized generation of random hv
def u_gen_rand_hv(D,d):
    if D % 2 != 0:
        raise ValueError("Error - D must be an even number")
    
    chosen = np.random.choice(D, size=int(D*d), replace=False)
    rand_hv = np.zeros(D, dtype=bool)
    rand_hv[chosen] = True
    
    return rand_hv.astype(int)

# 04/18/2023 optimized generation of item memory
def create_item_mem(N, D, d):
    keys = np.arange(N)
    seed = u_gen_rand_hv(D, d) #Generate List of random 1 and 0 with probability d
    tracker = np.copy(seed) #Tracks already flipped bits
    bit_step = int(np.sum(seed) / (N-1))
    hvs = [seed]

    for i in range(1, N):
        next_hv = hvs[i-1].copy()

        # TURN OFF K bits
        turnoff_index = np.random.choice(np.flatnonzero(tracker), size=bit_step, replace=False)
        tracker[turnoff_index] = False #Update to already flipped
        next_hv[turnoff_index] = False #flip to 0

        # TURN ON K bits
        turnon_index = np.random.choice(np.flatnonzero(~tracker), size=bit_step, replace=False)
        tracker[turnon_index] = True #Update to already flipped
        next_hv[turnon_index] = True #Flip to 1

        hvs.append(next_hv)
       
    return dict(zip(keys, hvs))

# 04/18/2023 optimized encoding
def hdc_encode(voice, voice_im, D, d, Q=10, t1=0, remove_list=[]):
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

def similarity_search(voice, voice_im, voice_am, D, d, Q, t1, remove_list):
    # Convert voice to a quantized vector
    voice = np.array(voice) * (Q / 2)
    voice = np.floor(voice + (Q / 2)).astype(int)

    # Compute test HV
    start = time.time()
    test_hv = hdc_encode(voice, voice_im, D, d, remove_list=remove_list)
    encoding_time = time.time() - start

    # Compute similarities
    start = time.time()
    similarities = np.sum(test_hv & np.stack(list(voice_am.values()), axis=1), axis=0)
    max_similarity_index = np.argmax(similarities)
    sim_letter = list(voice_am.keys())[max_similarity_index]
    sim_score = similarities[max_similarity_index]

    return sim_letter, sim_score, encoding_time, time.time() - start

def search(args):
    return similarity_search(*args)