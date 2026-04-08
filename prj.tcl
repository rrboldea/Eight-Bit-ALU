project_new ALU -overwrite
set_global_assignment -name FAMILY MAX10
set_global_assignment -name DEVICE 10M50DAF484C7G
set_global_assignment -name VERILOG_FILE modules/ac.v
set_global_assignment -name VERILOG_FILE modules/adder.v
set_global_assignment -name VERILOG_FILE modules/add_sub_1.v
set_global_assignment -name VERILOG_FILE modules/ALU.v
set_global_assignment -name VERILOG_FILE modules/br4_8bits_CU.v
set_global_assignment -name VERILOG_FILE modules/br4_8bits.v
set_global_assignment -name VERILOG_FILE modules/cla_4b_adder.v
set_global_assignment -name VERILOG_FILE modules/cla_4b_carry.v
set_global_assignment -name VERILOG_FILE modules/counter.v
set_global_assignment -name VERILOG_FILE modules/d_ff.v
set_global_assignment -name VERILOG_FILE modules/fac.v
set_global_assignment -name VERILOG_FILE modules/hac.v
set_global_assignment -name VERILOG_FILE modules/mux_1sel.v
set_global_assignment -name VERILOG_FILE modules/RCA_adder.v
set_global_assignment -name VERILOG_FILE modules/register.v
set_global_assignment -name VERILOG_FILE modules/rshiftReg.v

set_global_assignment -name VERILOG_FILE modules/test_load_x_y.v
set_global_assignment -name VERILOG_FILE pos_edge.v
set_global_assignment -name VERILOG_FILE synchronizer.v
set_global_assignment -name VERILOG_FILE test.v
set_global_assignment -name TOP_LEVEL_ENTITY test

# clock
set_location_assignment PIN_P11 -to clk

# on-board buttons
set_location_assignment PIN_B8 -to ld_x_y_b
set_location_assignment PIN_A7 -to rst_b

# added buttons
set_location_assignment -to ADD_b PIN_AA2
set_location_assignment -to SUB_b PIN_AB2

#set_location_assignment -to AND PIN_AB5
#set_location_assignment -to OR PIN_AB6
#set_location_assignment -to XOR PIN_AB7

# switches
set_location_assignment PIN_C10 -to data[0]
set_location_assignment PIN_C11 -to data[1]
set_location_assignment PIN_D12 -to data[2]
set_location_assignment PIN_C12 -to data[3]
set_location_assignment PIN_A12 -to data[4]
set_location_assignment PIN_B12 -to data[5]
set_location_assignment PIN_A13 -to data[6]
set_location_assignment PIN_A14 -to data[7]

# leds
set_location_assignment PIN_A8 -to q[0]
set_location_assignment PIN_A9 -to q[1]
set_location_assignment PIN_A10 -to q[2]
set_location_assignment PIN_B10 -to q[3]
set_location_assignment PIN_D13 -to q[4]
set_location_assignment PIN_C13 -to q[5]
set_location_assignment PIN_E14 -to q[6]
set_location_assignment PIN_D14 -to q[7]

set_location_assignment PIN_B11 -to DONE

load_package flow
execute_flow -compile

