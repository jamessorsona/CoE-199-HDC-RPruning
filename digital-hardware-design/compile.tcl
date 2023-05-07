set search_path "$search_path mapped lib cons rtl"
set link_library "* /cad/tools/libraries/dwc_logic_in_gf22fdx_sc7p5t_116cpp_base_csc20l/GF22FDX_SC7P5T_116CPP_BASE_CSC20L_FDK_RELV02R80/model/timing/db/GF22FDX_SC7P5T_116CPP_BASE_CSC20L_TT_0P80V_0P00V_0P00V_0P00V_25C.db"

read_verilog updown.v
current_design updown
link
check_design > logs/check_design.log
source timing.con
compile
report_constraint -all_violators > logs/constraint_report.log
report_area > logs/area_report.log
report_timing > logs/timing_report.log
report_power > logs/power_report.log
write_file -format verilog -hierarchy -output mapped/updown_mapped.v
write_file -format ddc -hierarchy -output mapped/updown_mapped.ddc
write_sdf mapped/updown_mapped.sdf
write_sdc mapped/updown_mapped.sdc
quit