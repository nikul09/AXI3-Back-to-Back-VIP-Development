
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul
////date          : 24/02/2024
////Description   : Master side agent class
////////////////////////////////////////////////////////////////////////

`ifndef axi_m_age
`define axi_m_age

class axi_m_age extends uvm_agent;

    axi_m_drv m_drv;
    axi_m_sqr m_sqr;
    axi_m_mon m_mon;

    `uvm_component_utils(axi_m_age)

    function new(string name = "axi_m_age",uvm_component parent);
        super.new(name,parent);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"build phase",UVM_LOW)
        m_drv = axi_m_drv::type_id::create("m_drv",this);
        m_sqr = axi_m_sqr::type_id::create("m_sqr",this);
        m_mon = axi_m_mon::type_id::create("m_mon",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(),"connect phase",UVM_LOW)
        m_drv.seq_item_port.connect(m_sqr.seq_item_export);
    endfunction
 
endclass

`endif
