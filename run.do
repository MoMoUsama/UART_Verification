# Clean previous compilation
#if {[file exists work]} { file delete -force work }

# Create a new work library
#vlib work

# Compile RTL and UVM files
vlog -work work -sv +acc=rnbc ../REPO/rtl/*.*v
vlog -sv -f files.f
vlog ../REPO/uvm/top.sv 

# Run simulation and load wave.do for waveform view
# +UVM_CONFIG_DB_TRACE
vsim work.top +acc=rnb +UVM_VERBOSITY=UVM_HIGH +UVM_SEQ_ARB_TRACE -l simulation.log -do {
    
    # Load waveform configuration
    do wave.do

    # Run simulation
    run -all;

    # Save coverage DB and report it
    # coverage save coverage.ucdb;
    # coverage report -details -verbose -output coverage_report.txt;
# }
# Filter logs after simulation
exec findstr /I "uvm_error %Error ERROR" simulation.log > errors.log
exec findstr /I "uvm_warning %Warning WARNING" simulation.log > warnings.log
