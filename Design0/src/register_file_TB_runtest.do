# Create and map work library
vlib work

# Compile source files based on your exact file names
vcom -2008 register.vhd
vcom -2008 register_file_TB.vhd

# Start simulation targeting the specific testbench entity
vsim register_file_TB

# Add all testbench signals to the waveform
add wave -noupdate -divider "Control & Clocks"
add wave -noupdate /register_file_TB/clock
add wave -noupdate /register_file_TB/reset
add wave -noupdate /register_file_TB/RdWEn

add wave -noupdate -divider "Addresses"
add wave -noupdate -radix unsigned /register_file_TB/Ra
add wave -noupdate -radix unsigned /register_file_TB/Rb
add wave -noupdate -radix unsigned /register_file_TB/Rd

add wave -noupdate -divider "Data Buses"
add wave -noupdate -radix hex /register_file_TB/RES
add wave -noupdate -radix hex /register_file_TB/SRCa
add wave -noupdate -radix hex /register_file_TB/SRCb

# Run the simulation for 300 ns
run 300 ns

# Zoom to fit the wave
wave zoom full