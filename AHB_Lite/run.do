vlog +define+DEBUG list.svh
vsim top -l log_$1.txt -wlf wave_$1.wlf "+testname=$1"
do wave.do
run -all
exit