
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi slave agent
////////////////////////////////////////////////////////////////////////

`ifndef axi_s_age
`define axi_s_age

class axi_s_age extends uvm_agent;

    axi_s_drv s_drv;
    axi_s_sqr s_sqr;
    axi_s_mon s_mon;
    axi_mem amem;

    `uvm_component_utils(axi_s_age)

    function new(string name = "axi_s_age",uvm_component parent);
        super.new(name,parent);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"inside build phase",UVM_LOW)
        s_drv = axi_s_drv::type_id::create("s_drv",this);
        s_sqr = axi_s_sqr::type_id::create("s_sqr",this);
        s_mon = axi_s_mon::type_id::create("s_mon",this);
        amem = axi_mem::type_id::create("amem",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"inside connect phase",UVM_LOW)
        super.connect_phase(phase);
        s_drv.seq_item_port.connect(s_sqr.seq_item_export);
        s_mon.smon_ap.connect(amem.mem_ip);
    endfunction

endclass

`endif

