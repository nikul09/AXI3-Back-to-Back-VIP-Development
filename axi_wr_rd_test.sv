
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi basic write read test
////////////////////////////////////////////////////////////////////////

`ifndef axi_wr_rd_test
`define axi_wr_rd_test

class axi_wr_rd_test extends axi_base_test;

  m_sqn msqn;
  s_sqn ssqn;

  `uvm_component_utils(axi_wr_rd_test)

  function new(string name = "axi_wr_rd_test",uvm_component parent);
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
      msqn = m_sqn::type_id::create("msqn");

      phase.raise_objection(this);
      
      fork
          ssqn.start(env.s_age.s_sqr);
      join_none

      msqn.start(env.m_age.m_sqr);
      
      phase.phase_done.set_drain_time(this,300);

      phase.drop_objection(this);
  endtask

endclass 

`endif

