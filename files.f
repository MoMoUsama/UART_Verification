# ============================================================
# Filelist for UART UVM Environment
# Compile with:
#   vlog -f files.f
# ============================================================

# ---------------------------
# Include directories
# ---------------------------
+incdir+../REPO/uvm
+incdir+../REPO/uvm/wb_agent
+incdir+../REPO/uvm/uart_agent
+incdir+../REPO/uvm/ral
+incdir+../REPO/uvm/sequences
+incdir+../REPO/uvm/Configs


# ---------------------------
# Configs
# ---------------------------
../REPO/uvm/Configs/Env_Config_pkg.svh


# ---------------------------
# WB Agent
# ---------------------------
../REPO/uvm/wb_agent/uart_wb_agent_pkg.svh

# ---------------------------
# UART Agent (rx/tx)
# ---------------------------
../REPO/uvm/uart_agent/uart_agent_pkg.svh

# ---------------------------
# Register Model
# ---------------------------
../REPO/uvm/ral/uart_ral_pkg.svh

# ---------------------------
# Sequences
# ---------------------------
../REPO/uvm/sequences/uart_sequences_pkg.svh

# ---------------------------
# Top-Level UART Env Package
# ---------------------------
../REPO/uvm/uart_pkg.sv
