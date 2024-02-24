
vlog +acc ../TOP/axi_pkg.sv ../TOP/top.sv +incdir+../ENV +incdir+../TEST


#   ---------------------------  axi wrap based test -------------------------------------------#

#vsim -vopt top -sv_lib C:/questasim64_2021.1/uvm-1.1d/win64/uvm_dpi +UVM_TESTNAME=axi_wr_rd_wrap_test



# ----------------------------- axi incr based test --------------------------------------------#

vsim -vopt top -sv_lib C:/questasim64_2021.1/uvm-1.1d/win64/uvm_dpi +UVM_TESTNAME=axi_wr_rd_incr_test



# ----------------------------- axi fixed based test --------------------------------------------#

#vsim -vopt top -sv_lib C:/questasim64_2021.1/uvm-1.1d/win64/uvm_dpi +UVM_TESTNAME=axi_wr_rd_fixed_test


# ------------------------------------------------------------------------------------------------#

#vsim -vopt top -sv_lib C:/questasim64_2021.1/uvm-1.1d/win64/uvm_dpi +UVM_TESTNAME=axi_wrap_based_test

#vsim -vopt top -sv_lib C:/questasim64_2021.1/uvm-1.1d/win64/uvm_dpi +UVM_TESTNAME=axi_wr_test

add wave -position insertpoint sim:/top/pinf/*

#do wave.do

run -all

#vlog -coveropt 3 +cover +acc  ../RTL/ram_16x8.v ../TEST/ram_pkg.sv ../TOP/ram_tb_top.sv +incdir+../ENV +incdir+../TEST

#vsim -coverage -vopt ram_tb_top -c -do "coverage save -onexit -directive -cvg -codeall wr_rd_cov.ucdb; run -all; exit" +WR_RD_TEST

#-suppress 13276
#-suppress 12110 