
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi slave sequence
////////////////////////////////////////////////////////////////////////

`ifndef s_sqn
`define s_sqn

class s_sqn extends base_sqn;

    axi_trans rx_trans;
    `uvm_object_utils(s_sqn)

    function new(string name = "s_sqn");
        super.new(name);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
        req = axi_trans::type_id::create("req");
    endfunction

    task body();
        forever begin
            axi_mem::mem2sqn.get(rx_trans);
            start_item(rx_trans);
            finish_item(rx_trans);
        end
    endtask
  
endclass

`endif

