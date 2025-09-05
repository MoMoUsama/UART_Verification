# Clean previous compilation
#if {[file exists work]} { file delete -force work }

# Create a new work library
#vlib work

# Compile RTL and UVM files
vlog ./rtl/*.*v  #+cover
vlog ./uvm/uart_pkg.sv ./UVM/top.sv 

# Run simulation and load wave.do for waveform view
vsim work.top +UVM_VERBOSITY=UVM_LOW -l simulation.log -do {
    
    # Load waveform configuration
    # do wave.do

    # Run simulation
    run -all;

    # Save coverage DB and report it
    # coverage save coverage.ucdb;
    # coverage report -details -verbose -output coverage_report.txt;
# }
# Filter logs after simulation
exec findstr /I "uvm_error %Error ERROR" simulation.log > errors.log
exec findstr /I "uvm_warning %Warning WARNING" simulation.log > warnings.log
