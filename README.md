# EEE199-HDC-RPruning

Project Title: **Redundancy Pruning for Associative Memories in Sparse Hyperdimensional Computing for Energy-Efficient Speech Recognition**

Members:
1. [Kim Isaac Buelagala](https://mail.google.com/mail/?view=cm&source=mailto&to=kim.buelagala@eee.upd.edu.ph)
2. [Ginzy Javier](https://mail.google.com/mail/?view=cm&source=mailto&to=ginzy.javier@eee.upd.edu.ph)
3. [Sean Alfred Lipardo](https://mail.google.com/mail/?view=cm&source=mailto&to=sean.lipardo@eee.upd.edu.ph)
4. [James Carlo Sorsona](https://mail.google.com/mail/?view=cm&source=mailto&to=james.sorsona@eee.upd.edu.ph)

Project Advisers:
1. [Fredrick Angelo R. Galapon](https://mail.google.com/mail/?view=cm&source=mailto&to=fredrick.galapon@eee.upd.edu.ph)
2. [Anastacia B. Alvarez](https://mail.google.com/mail/?view=cm&source=mailto&to=anastacia.alvarez@eee.upd.edu.ph)
3. [Ryan Albert G. Antonio](https://mail.google.com/mail/?view=cm&source=mailto&to=ryan.albert.antonio@eee.upd.edu.ph)
4. [Sherry Joy Alvionne S. Baquiran](https://mail.google.com/mail/?view=cm&source=mailto&to=alvionne.baquiran@eee.upd.edu.ph)
5. [Lawrence Roman A. Quizon](https://mail.google.com/mail/?view=cm&source=mailto&to=lawrence.quizon@eee.upd.edu.ph)
6. [Allen Jason Tan](https://mail.google.com/mail/?view=cm&source=mailto&to=allen.jason.tan@eee.upd.edu.ph)

# isolet
This folder contains the ISOLET dataset as a `pickle` object.


# python-model
This folder contains all the files for the Python model.

Requirements: (Installation: `pip3 install -r requirements.txt`)
* numpy
* pandas

`hdc.py` is the main Python file which contains all the necessary modules for the general HDC algorithm. \
`hdc_dimension_sparsifier.py` contains the implementation of the redundancy pruning. \
`sparseSpeech.ipynb` is the Jupyter notebook used for testing the entire the model. 

The `encoding_training_threshold` folder contains the script for finding an optimal encoding and training threshold. Using a constant quantization level of `Q=16`, the encoding and training thresholds are swept with specific intervals for each respective hypervector density.

The `sweep_q_constant_im` folder contains the necessary scripts and results in finding the quantization level `Q` that yields the highest accuracy. For each density, a constant training and encoding threshold is used. The accuracy results were averaged over 10 trials (20 trials for `D=4096`). Each trial per quantization level for the dimensionality being tested, the item memory is preserved using approximate linear mapping.
The encoding and training thresholds used for each density is listed below.
|Item Memory Density|Encoding Threshold|Training Threshold|
|:---:|:---:|:---:|
|1%|6|50|
|2%|12|35|
|5%|30|40|
|10%|65|45|


# digital-hardware-design
This folder contains all the files for the digital hardware design.
* `set_synopsys.sh` is the shell script for setting the necessary environment variables needed to run Synopsys tools.
## sparse_hdc_rpruning
This folder is the main project folder for the project.
### cons
This folder contains all the constraints scripts.
### libs
This folder contains the libraries. GlobalFoundries 22nm FDX is used for this project. 
### logs
This folder contains all the log files.
### mapped
### rtl
This folder contains the register-transfer-level codes.
### sim
This folder contains the output log files from the synthesis process.

# python-helper-scripts
This folder contains helper scripts for automating simulation, compilation, synthesis, and generating reports.

# software-test-reports

# post-synthesis_sim_tb_netlists

# rtl-simulation


# synthesis-results

