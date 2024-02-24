
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi package 
////////////////////////////////////////////////////////////////////////

`ifndef axi_pkg
`define axi_pkg

`include "axi_inf.sv"

package axi_pkg;

    import uvm_pkg::*;

    `include "uvm_macros.svh"

    `include "axi_inf.sv"
    `include "axi_trans.sv"
    `include "axi_mem.sv"

     // sequencer

     `include "axi_s_sqr.sv"
     `include "axi_m_sqr.sv"

     // sequences 
     
     `include "base_sqn.sv"
     `include "axi_s_sqn.sv"
     `include "axi_m_sqn.sv"

     `include "axi_wr_rd_fixed_sqn.sv"
    
     // inc sequences

     `include "axi_wr_rd_incr_sqn.sv"
     `include "axi_wr_rd_b2b_inc_sqn.sv"
     `include "axi_wr_more_rd_inc_sqn.sv"
     `include "axi_rd_more_wr_inc_sqn.sv"
     `include "axi_wr_rd_rand_inc_sqn.sv"

     // wrap sequences

     `include "axi_wr_rd_wrap_sqn.sv"
     `include "axi_wr_rd_b2b_wrap_sqn.sv"
     `include "axi_wr_more_rd_wrap_sqn.sv"
     `include "axi_rd_more_wr_wrap_sqn.sv"
     `include "axi_wr_rd_rand_wrap_sqn.sv"

     // agent componenrs

     `include "axi_m_drv.sv"
     `include "axi_s_drv.sv"
     `include "axi_s_mon.sv"
     `include "axi_m_mon.sv"
     `include "axi_m_age.sv"
     `include "axi_s_age.sv"
     `include "axi_sb.sv"
     `include "axi_checker.sv"
     `include "axi_env.sv"

     // test cases

     `include "axi_base_test.sv"
     `include "axi_wr_rd_test.sv"
     `include "axi_wr_rd_fixed_test.sv"
     `include "axi_wr_rd_incr_test.sv"
     `include "axi_wr_rd_wrap_test.sv"

 endpackage

`endif

