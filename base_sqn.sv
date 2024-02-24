
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi base sequence
////////////////////////////////////////////////////////////////////////

`ifndef base_sqn
`define base_sqn

class base_sqn extends uvm_sequence#(axi_trans); 
 
  `uvm_object_utils(base_sqn)
  
  int rsp_cnt;
  
  function new(string name = "base_sqn");
    super.new(name);
  endfunction

  virtual task body();
    use_response_handler(1);
  endtask

  function void response_handler(uvm_sequence_item response);
      rsp_cnt++;
      $display("rsp_cnt:{%0d}",rsp_cnt);
  endfunction
  

endclass

`endif

