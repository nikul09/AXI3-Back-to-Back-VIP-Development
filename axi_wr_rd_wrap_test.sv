
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi write read wrap test case
////////////////////////////////////////////////////////////////////////

`ifndef axi_wr_rd_wrap_test
`define axi_wr_rd_wrap_test

class axi_wr_rd_wrap_test extends axi_base_test;

    axi_wr_rd_wrap_sqn wr_rd_wrap;
    
    axi_wr_rd_b2b_wrap_sqn wr_rd_b2b_wrap;
    
    axi_wr_more_rd_wrap_sqn wr_more_rd_wrap;
    axi_rd_more_wr_wrap_sqn rd_more_wr_wrap;
    
    axi_wr_rd_rand_wrap_sqn wr_rd_rand_wrap;
    
    s_sqn ssqn;

  `uvm_component_utils(axi_wr_rd_wrap_test)

  function new(string name = "axi_wr_rd_wrap_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

   function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_name(),"end_of_elaboration_phase ....",UVM_NONE)
  endfunction

  task run_phase(uvm_phase phase);
      
      ssqn = s_sqn::type_id::create("ssqn");
      wr_rd_wrap = axi_wr_rd_wrap_sqn::type_id::create("wr_rd_wrap");
      wr_rd_b2b_wrap = axi_wr_rd_b2b_wrap_sqn::type_id::create("wr_rd_b2b_wrap");
      
      wr_more_rd_wrap = axi_wr_more_rd_wrap_sqn::type_id::create("wr_more_rd_wrap");
      rd_more_wr_wrap = axi_rd_more_wr_wrap_sqn::type_id::create("rd_more_wr_wrap");
      
      wr_rd_rand_wrap = axi_wr_rd_rand_wrap_sqn::type_id::create("wr_rd_rand_wrap");

      phase.raise_objection(this);

      
      fork
          ssqn.start(env.s_age.s_sqr);
      join_none

      //wr_rd_wrap.start(env.m_age.m_sqr);
      wr_rd_b2b_wrap.start(env.m_age.m_sqr);
      //wr_more_rd_wrap.start(env.m_age.m_sqr);
      //rd_more_wr_wrap.start(env.m_age.m_sqr);
      //wr_rd_rand_wrap.start(env.m_age.m_sqr);
      
      phase.phase_done.set_drain_time(this,1000);

      phase.drop_objection(this);
  endtask

endclass 

`endif

