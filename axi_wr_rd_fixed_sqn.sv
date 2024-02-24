
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi write read fixed sequence
////////////////////////////////////////////////////////////////////////

`ifndef axi_wr_rd_fixed
`define axi_wr_rd_fixed

class axi_wr_rd_fixed extends base_sqn;

    `uvm_object_utils(axi_wr_rd_fixed)
    bit[3:0]que_id[$];
    bit[31:0]que_addr[$];

    function new(string name = "axi_wr_rd_fixed");
        super.new(name);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction

    task body();
    
        repeat(3)begin
            req = axi_trans::type_id::create("req");

            start_item(req);
	  
            assert(req.randomize() with {
	        
                req.wburst_size == 2;
	            req.wburst_len == 1;
                req.wburst_type == FIXED;
                req.tx_type == WRITE;
               });
               que_addr.push_back(req.waddr);
               que_id.push_back(req.wid);

            finish_item(req);
        end
        
        repeat(3)begin
            req = axi_trans::type_id::create("req");

            start_item(req);
	  
            assert(req.randomize() with {
	        
                req.rburst_size == 2;
	            req.rburst_len == 1;
                req.rburst_type == FIXED;
                req.tx_type == READ;
                req.raddr == que_addr.pop_front();
                req.rid == que_id.pop_front();
               });

            finish_item(req);
        end

    endtask
  
endclass

`endif


