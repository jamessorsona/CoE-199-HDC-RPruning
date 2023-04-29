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

`hdc.py` is the main Python file which contains all the necessary modules for the general HDC algorithm. \
`hdc_dimension_sparsifier.py` contains the implementation of the redundancy pruning. \
`sparseSpeech.ipynb` is the Jupyter notebook used for testing the entire the model. 

The `sweep_q_constant_im` contains the necessary scripts and results in finding the quantization level `Q` that yields the highest accuracy. For each density, a constant training and encoding threshold is used. The accuracy results were averaged over 10 trials (20 trials for the `D=4096`). Each trial per quantization level for the dimensionality being tested, the item memory is preserved using approximate linear mapping.
The encoding and training thresholds used for each density is listed below.
|Item Memory Density|Encoding Threshold|Training Threshold|
|:---:|:---:|:---:|
|1%|6|50|
|2%|12|35|
|5%|30|40|
|10%|65|45|


# digital-hardware-design
This folder contains all the files for the digital hardware design.

