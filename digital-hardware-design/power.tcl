# Step 1: simulate your design as usual using VCS
# Step 2: invoke PrimeTime
# in command prompt: > pt_shell
# in pt_shell prompt, run the succeeding commands or source power.tcl

# Common commands
set power_enable_analysis true
set power_analysis_mode time_based
set search_path "$search_path mapped lib cons rtl sim"
set link_library "* /cad/tools/libraries/dwc_logic_in_gf22fdx_sc7p5t_116cpp_base_csc20l/GF22FDX_SC7P5T_116CPP_BASE_CSC20L_FDK_RELV02R80/model/timing/db/GF22FDX_SC7P5T_116CPP_BASE_CSC20L_TT_0P80V_0P00V_0P00V_0P00V_25C.db"
# Read the synthesized netlist
read_verilog updown_mapped.v
current_design updown
link_design
# Define simulation environment
set_units -time ps -resistance kOhm -capacitance fF -voltage V -current mA
create_clock -period 1000 -name CLK [get_ports clk]
read_vcd "updown.dump" -strip_path "tb_updown/UUT"
check_power
set_power_analysis_options -waveform_format fsdb -waveform_output vcd
update_power
report_power > updown_pt_power.rpt