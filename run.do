vlib work
vlog -f source_files.list -mfcu
vsim -voptargs=+acc work.PRBS_PD_tb 
add wave *
run -all