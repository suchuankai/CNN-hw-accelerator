#Read All Files
read_file -format verilog  Top.v
current_design Top
link

#Setting Clock Constraints
source -echo -verbose Top.sdc
check_design
set high_fanout_net_threshold 0
uniquify

#Synthesis all design
replace_clock_gates
compile -map_effort high -area_effort high
#compile -map_effort high -area_effort high -inc
#compile_ultra

write -format ddc     -hierarchy -output "Top_syn.ddc"
write_sdf -version 1.0  -load_delay net Top_syn.sdf
write -format verilog -hierarchy -output Top_syn.v
report_area > area.log
report_timing > timing.log
report_qor   >  Top_syn.qor
