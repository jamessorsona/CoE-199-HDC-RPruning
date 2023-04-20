import numpy as np                
import pickle
import multiprocessing
import time
import pandas as pd
import csv

import hdc
    
if __name__ == '__main__':

    print()
    ##################### HDC Parameters #####################
    #Set Parameters
    # D = 4096
    # d = 0.02
    D = int(input())
    d = float(input())
    
    # encoding_threshold = 15
    # training_threshold = 30
    encoding_threshold = int(input())
    training_threshold = int(input())

    # quantization parameters
    Q_range = int(input())
    Q_sweeps = [i for i in range(2, Q_range+1)]

    print("------------------HDC Parameters---------------------")
    print(f"Dimension: \t\t\t{D}")
    print(f"Density: \t\t\t{d}")
    print(f"Encoding Threshold: \t\t{encoding_threshold}")
    print(f"Training Threshold: \t\t{training_threshold}")
    print(f"Q Sweep: \t\t\t{Q_sweeps[0]} to  {Q_sweeps[-1]}")
    ##########################################################
    

    ##################### Simulation Parameters #####################
    print(f"--------------Simulation Parameters------------------")
    # trials = 10
    trials = int(input())
    print(f"Trials: {trials}")
    #################################################################
    
    remove_list = []
    #Import ISOLET Dataset 
    with open('isolet.pkl', 'rb') as f:
        isolet = pickle.load(f)
    trainData, trainLabels, testData, testLabels = isolet
    trainData = np.array(trainData)
    testData = np.array(testData)

    Accuracies = []

    ##################### Simulation #####################
    print("-----------------Starting Simulation-----------------")

    for trial in range(trials):
        print(f"Trial: {trial}")
        # create first and last random hyper-vectors
        first = hdc.u_gen_rand_hv(D,d)
        last = hdc.u_gen_rand_hv(D,d)

        for Q in Q_sweeps:
            print(f"Testing with Q: {Q} | ", end="")

            accuracy_line = []

            # create constant item memory
            voice_im = hdc.create_item_mem(Q, D, d, first, last)
            # save item memory to a csv file
            im = pd.DataFrame(voice_im.values())
            im.to_csv(f"{str(D)[0]}k_{int(d*100)}/IM_Dimension_{D}_density_{int(d*100)}_Q_{Q}.csv", index=False)

            keys = range(26)
            voice_am = dict()
            cores = multiprocessing.cpu_count()

            non_bin_reg = np.zeros((26,D))

            enc_start = time.time()
            with multiprocessing.Pool(cores) as pool:
                args = [(trainData[i], voice_im, D, d, Q, encoding_threshold) for i in range(len(trainLabels))]
                results = pool.starmap(hdc.hdc_encode, args)

            for i in range(len(trainLabels)):
                non_bin_reg[trainLabels[i]] = np.add(non_bin_reg[trainLabels[i]], results[i])
            
            for i in range(len(keys)):
                voice_am[keys[i]] = np.where(non_bin_reg[i] > training_threshold, 1, 0)

            test_data = testData
            correct_values = testLabels     
            print_flag = False
            score = 0
            test_len = len(test_data)

            with multiprocessing.Pool(cores) as pool:
                arg = [(test_data[i],voice_im,voice_am,D,d,Q,encoding_threshold,remove_list) for i in range(test_len)]
                result = pool.map(hdc.search,arg)

            enc_t = 0
            s_t = 0
            for i in range(test_len):
                sim_letter, sim_score = result[i][0],result[i][1]
                enc_t += result[i][2]
                s_t += result[i][3]
                if sim_letter == correct_values[i]:
                    score += 1
                    if(print_flag):
                        print("CORRECT prediction! sim_letter: ", sim_letter, " sim_score: ", str(sim_score))
                else:
                    if(print_flag):
                        print("WRONG prediction! sim_letter: " , sim_letter, " sim_score: ", str(sim_score))
            accuracy = (score*100/test_len)
            print('Accuracy:',accuracy)

            accuracy_line.append(accuracy)
        
        print()
        # store accuracy_line as a row to a csv file
        with open(f"{str(D)[0]}k_{int(d*100)}/Accuracy_Dimension_{D}_density_{int(d*100)}_EncTHR_{encoding_threshold}_TrainTHR_{training_threshold}Q_{Q_sweeps[0]}_{Q_sweeps[-1]}_trials_{trials}.csv", "a") as f:
            writer = csv.writer(f, lineterminator='\n')
            writer.writerow(accuracy_line)