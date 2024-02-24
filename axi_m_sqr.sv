
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : Master sequencer class 
////////////////////////////////////////////////////////////////////////

`ifndef axi_m_sqr
`define axi_m_sqr

class axi_m_sqr extends uvm_sequencer#(axi_trans);

    `uvm_component_utils(axi_m_sqr)

    function new(string name = "axi_m_sqr",uvm_component parent);
        super.new(name,parent);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction
  
endclass

`endif
