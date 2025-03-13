# Clean previous compilation
if {[file exists work]} { file delete -force work }

# Create a new work library
vlib work

vlog ./RTL/*/*.v ./RTL/*.*v ./UVM/pck.sv ./UVM/Top.sv +cover
# Start simulation
vsim -batch Top -l simulation.log -coverage

# Run simulation
run -all

# Generate coverage report
coverage report -details -verbose

