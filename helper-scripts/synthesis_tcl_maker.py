import sys
import os
import time

""" 
Run this file inside the parent project folder: sparse_hdc_rpruning
Usage: python3 synthesis_automation_maker.py [file.sv]
"""

################### ERROR HANDLING ###################

if len(sys.argv) < 2:
	print("ERROR! Missing file name. Please run the script as follows:")
	print("python3 synthesis_automation_maker.py [file.sv]")
	sys.exit(1)

if sys.argv[1][-3:] != ".sv":
	print("ERROR! File must be a .sv file.")
	sys.exit(1)

# obtain .sv file from command line argument
raw_filename = sys.argv[1]
filename = raw_filename[:-3]

# create logs folder if it doesn't exist
if not os.path.exists("logs"):
	os.mkdir("logs")

# create folder for this file if it doesn't exist
if not os.path.exists(f"logs/{filename}"):
	os.mkdir(f"logs/{filename}")
# make a warning if it exists
else:
	print(f"WARNING! logs/{filename} folder already exists. Overwriting files...")
	# remove all files inside the folder
	for file in os.listdir(f"logs/{filename}"):
		os.remove(f"logs/{filename}/{file}")
print(f"Created logs/{filename} folder")
#####################################################

tcl_file = f"synthesize_{filename}.tcl"

with open(tcl_file, "a") as fh:

	fh.write("set search_path \"$search_path mapped lib cons rtl\"")
	fh.write("set link_library */cad/tools/libraries/dwc_logic_in_gf22fdx_sc7p5t_116cpp_base_csc20l/GF22FDX_SC7P5T_116CPP_BASE_CSC20L_FDK_RELV02R80/model/timing/db/GF22FDX_SC7P5T_116CPP_BASE_CSC20L_TT_0P80V_0P00V_0P00V_0P00V_25C.db")

	fh.write(f"read_sverilog {raw_filename} > logs/{filename}/{filename}-read_sverilog.log\n")

	fh.write(f"current_design {filename}\n")
	fh.write("link\n")

	fh.write(f"check_design > logs/{filename}/{filename}-check_design.log\n")
	# fh.write(f"source timing.con")

	fh.write(f"compile > logs/{filename}/{filename}-compile.log\n")
	
	fh.write(f"report_constraint -all_violators > logs/{filename}/{filename}-report_constraint.log\n")
	fh.write(f"report_area > logs/{filename}/{filename}-report_area.log\n")
	fh.write(f"report_timing > logs/{filename}/{filename}-report_timing.log\n")
	fh.write(f"report_power > logs/{filename}/{filename}-report_power.log\n")

	# fh.write(f"write_file -format sverilog -hierarchy -output mapped/{filename}/{filename}_mapped.sv\n")
	# fh.write(f"write_file -format ddc -hierarchy -output mapped/{filename}/{filename}_mapped.ddc\n")

	# fh.write(f"write_sdf mapped/{filename}/{filename}_mapped.sdf\n")
	# fh.write(f"write_sdc mapped/{filename}/{filename}_mapped.sdc\n")

	fh.write("quit\n")

# print success message
print(f"Success! Created {tcl_file}")

# record the execution time
start_time = time.time()
print("-----------------------------------------------")
# execute the tcl file
print(f"Executing {tcl_file}...")
os.system(f"dc_shell -f {tcl_file} -output_log_file logs/{filename}/{filename}-compile.log")
# DONE
print("-----------------------------------------------")
print("DONE!")
# print execution time
print(f"Execution time: {time.time() - start_time} seconds")

# count files inside the logs folder
logs_count = len(os.listdir(f"logs/{filename}"))
# print number of files created
print(f"Created {logs_count} files in logs/{filename} folder")