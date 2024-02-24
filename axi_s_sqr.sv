
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi slave sequencer
////////////////////////////////////////////////////////////////////////

`ifndef axi_s_sqr
`define axi_s_sqr

class axi_s_sqr extends uvm_sequencer#(axi_trans);

    `uvm_component_utils(axi_s_sqr)

    function new(string name = "axi_s_sqn", uvm_component parent);
        super.new(name,parent);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction
endclass

`endif
