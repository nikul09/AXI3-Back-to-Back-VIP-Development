
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : read more then write wrap based
////////////////////////////////////////////////////////////////////////

`ifndef axi_rd_more_wr_wrap_sqn
`define axi_rd_more_wr_wrap_sqn

class axi_rd_more_wr_wrap_sqn extends base_sqn;

    `uvm_object_utils(axi_rd_more_wr_wrap_sqn)
    bit[3:0]que_id[$];
    bit[31:0]que_addr[$];

    function new(string name = "axi_rd_more_wr_wrap_sqn");
        super.new(name);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction

    task body();
    
        // back to back write and read sequence 

        repeat(5)begin
            req = axi_trans::type_id::create("req");

            start_item(req);
	  
            assert(req.randomize() with {
	        
                req.wburst_size == 2;
	            req.wburst_len == 3;
                req.wburst_type == WRAP;
                req.tx_type == WRITE;
               });
               que_addr.push_back(req.waddr);
               que_id.push_back(req.wid);

            finish_item(req);

        end

        repeat(10)begin
            start_item(req);
	  
            assert(req.randomize() with {
	        
                req.rburst_size == 2;
	            req.rburst_len == 3;
                req.rburst_type == WRAP;
                req.tx_type == READ;
                req.raddr == que_addr.pop_front();
                req.rid == que_id.pop_front();
               });

            finish_item(req);
        end

    endtask

endclass

`endif


