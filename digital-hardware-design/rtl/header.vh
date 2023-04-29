// General params
parameter integer HV_DIM = 4096;
parameter integer FEATURE_COUNT = 617;
parameter integer FEATURES_PER_CC = 155;
parameter integer SEQ_CYCLE_COUNT = 4;    
parameter integer DIMS_PER_CC = 1024;                                                         
parameter integer M = 2;

// Encoding params
parameter integer ENCODING_BIT_THR = 6;

// Class HV gen params
parameter integer CLASS_BIT_THR = 90; //1
parameter integer BITWIDTH_PER_DIM = 9;                           // 2^9 = 512 max value per dimension per class hv

// Testbench
parameter integer TRAINING_DATAPOINTS_COUNT = 6238;  // 52
parameter integer TESTING_DATAPOINTS_COUNT  = 1559;  // 52
