
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024
////Description   : axi environment class
////////////////////////////////////////////////////////////////////////

`ifndef axi_env
`define axi_env

class axi_env extends uvm_env;

    axi_m_age m_age;
    axi_s_age s_age;
    axi_sb sb;
    axi_checker ckr;

    `uvm_component_utils(axi_env)

    function new(string name = "axi_env",uvm_component parent);
        super.new(name,parent);
        `uvm_info(get_type_name(),"inside build phase",UVM_LOW)
        m_age = axi_m_age::type_id::create("m_age",this);
        s_age = axi_s_age::type_id::create("s_age",this);
        sb = axi_sb::type_id::create("sb",this);
        ckr = axi_checker::type_id::create("ckr",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(),"inside conect phase",UVM_LOW)
        m_age.m_mon.mmon_ap.connect(sb.mip);
        s_age.s_mon.smon_ap.connect(sb.sip);
        s_age.s_mon.smon_ap.connect(ckr.analysis_export);
    endfunction

endclass

`endif
