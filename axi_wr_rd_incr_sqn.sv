
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi write read increment sequence
////////////////////////////////////////////////////////////////////////

`ifndef axi_wr_rd_incr_sqn
`define axi_wr_rd_incr_sqn

class axi_wr_rd_incr_sqn extends base_sqn;

    `uvm_object_utils(axi_wr_rd_incr_sqn)
    bit[3:0]que_id[$];
    bit[31:0]que_addr[$];
    axi_trans rsp;
    int req_cnt;

    function new(string name = "axi_wr_rd_incr_sqn");
        super.new(name);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
         rsp = axi_trans::type_id::create("req");
    endfunction

    task body();
        super.body();

        repeat(5)begin
            req = axi_trans::type_id::create("req");

            start_item(req);
	  
            assert(req.randomize() with {
	        
                req.wburst_size == 2;
	            req.wburst_len == 1;
                req.wburst_type == INCR;
                req.tx_type == WRITE;
               });
               que_addr.push_back(req.waddr);
               que_id.push_back(req.wid);

            finish_item(req);

            req_cnt++;
            
            req = axi_trans::type_id::create("req");
            
            start_item(req);
	  
            assert(req.randomize() with {
	        
                req.rburst_size == 2;
	            req.rburst_len == 1;
                req.rburst_type == INCR;
                req.tx_type == READ;
                req.raddr == que_addr.pop_front();
                req.rid == que_id.pop_front();
               });

            finish_item(req);

            req_cnt++;
        end

        wait(req_cnt == rsp_cnt);
    endtask

endclass

`endif


