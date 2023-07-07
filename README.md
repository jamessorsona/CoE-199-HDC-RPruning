# EEE199-SparseHDC-RPruning

Project Title: **Redundancy Pruning for Associative Memories in Sparse Hyperdimensional Computing for Energy-Efficient Speech Recognition**

Laboratory: **Microelectronics and Microprocessors Laboratory**

Members:
1. [Kim Isaac I. Buelagala](https://mail.google.com/mail/?view=cm&source=mailto&to=kim.buelagala@eee.upd.edu.ph)
2. [Ginzy S. Javier](https://mail.google.com/mail/?view=cm&source=mailto&to=ginzy.javier@eee.upd.edu.ph)
3. [Sean Alfred A. Lipardo](https://mail.google.com/mail/?view=cm&source=mailto&to=sean.lipardo@eee.upd.edu.ph)
4. [James Carlo E. Sorsona](https://mail.google.com/mail/?view=cm&source=mailto&to=james.sorsona@eee.upd.edu.ph)

Project Advisers:
1. [Fredrick Angelo R. Galapon](https://mail.google.com/mail/?view=cm&source=mailto&to=fredrick.galapon@eee.upd.edu.ph)
2. [Anastacia B. Alvarez](https://mail.google.com/mail/?view=cm&source=mailto&to=anastacia.alvarez@eee.upd.edu.ph)
3. [Ryan Albert G. Antonio](https://mail.google.com/mail/?view=cm&source=mailto&to=ryan.albert.antonio@eee.upd.edu.ph)
4. [Sherry Joy Alvionne S. Baquiran](https://mail.google.com/mail/?view=cm&source=mailto&to=alvionne.baquiran@eee.upd.edu.ph)
5. [Lawrence Roman A. Quizon](https://mail.google.com/mail/?view=cm&source=mailto&to=lawrence.quizon@eee.upd.edu.ph)
6. [Allen Jason A. Tan](https://mail.google.com/mail/?view=cm&source=mailto&to=allen.jason.tan@eee.upd.edu.ph)

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
* `set_synopsys.sh` is a shell script for setting the necessary environment variables needed to run Synopsys tools.
* `.synopsys_dc.setup` is a script needed to setup the environment in Synopsys DC.
* `compile.tcl` is a sample tcl script for automating the compilation process.

## SparseHDC-RPruning
This folder is the main project folder for the project.
## post-synthesis_sim_tb_netlists
This folder contains the synthesized designs, netlists, testbenches, and post-synthesis simulations.
### sim_128_final_vcs
This folder contains the final design with 128 segments.
#### sim_oneshot_cg
This folder contains the synthesized clock-gated oneshot design with redundancy pruning (training + testing).
#### sim_oneshot_cg_training
This folder contains the synthesized clock-gated oneshot design with redundancy pruning (training only).
#### sim_oneshot_wo_cg
This folder contains the synthesized clock-gated oneshot design without redundancy pruning (training + testing).
#### sim_oneshot_wo_cg_training
This folder contains the synthesized clock-gated oneshot design without redundancy pruning (training only).
### sim_256_final_vcs
This folder contains the design with 256 segments.
## rtl_128_final
This folder contains the final SystemVerilog files of the HDC modules.

## item-memory
This folder contains the hypervectors used for the item memory. `hv0` is the level 0 hypervector and `hv1` is the level 1 hypervector.

## rtl-simulation
This folder contains the outputs of the RTL simulation in Synopsys VCS.

## hardware-metrics
This folder contains the area and energy measurements for the synthesized design.

# helper-scripts
This folder contains helper scripts for automating simulation, compilation, synthesis, and generating reports.

