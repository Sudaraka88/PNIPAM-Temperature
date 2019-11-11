If you use our data or code, please cite:
@Article{Mallawaarachchi2019Machine,
author ="Mallawaarachchi, Sudaraka and Liu, Yiyi and Thang, San H. and Cheng, Wenlong and Premaratne, Malin",
title  ="Machine learning based temperature prediction of poly(N-isopropylacrylamide)-capped plasmonic nanoparticle solutions",
journal  ="Phys. Chem. Chem. Phys.",
year  ="2019",
pages  ="-",
publisher  ="The Royal Society of Chemistry",
doi  ="10.1039/C9CP04544A",
url  ="http://dx.doi.org/10.1039/C9CP04544A"}

## PNIPAM-Temperature ##
UV-Vis spectroscopic absorption data for PNIPAM-capped gold nanorod and nano bi-pyramid particles are available from the RAW folder. Additional Matlab/Python code are provided for replication. 

Following instructions are provided as a guide to run the code.
# Run: RAW2MAT
This converts the RAW CSV data to formatted MAT files. Outputs are saved to Data/. Requires wl.mat and RAW folder in the same path. Does not require to be run more than once (unless you wish to regenerate or modify).

# Run: GenerateAccuracyData.m
Generates testing and training data by calling MAT2CSV(). Conducts multiple training/testing cycles by calling rf.py. Generated outputs are saved to Output/. Requires Python and sklearn (Anaconda is recommended). 

# Run: loadResTable.m
Generates the output specified by the header information. Possible alternatives are shows as comments. Previous steps must be completed before calling this method.

# Run: loadErrTable.m
Generates the output specified by the header information. Possible alternatives are shows as comments. Previous steps must be completed before calling this method.

All other code are called by the methods/functions listed above. Please refer to the comments within the code files for more information.

The entire setup was coded and tested on a Linux machine. If you are using windows, you will need to replace '/' with '\'.
If you run into any issues, you can reach me at smallawaarachchi@gmail.com
