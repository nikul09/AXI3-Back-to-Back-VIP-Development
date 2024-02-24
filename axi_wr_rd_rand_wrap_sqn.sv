
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi write read random wrap based sequence
////////////////////////////////////////////////////////////////////////

`ifndef axi_wr_rd_rand_wrap_sqn
`define axi_wr_rd_rand_wrap_sqn

class axi_wr_rd_rand_wrap_sqn extends base_sqn;

    `uvm_object_utils(axi_wr_rd_rand_wrap_sqn)
    bit[3:0]que_id[$];
    bit[31:0]que_addr[$];

    function new(string name = "axi_wr_rd_rand_wrap_sqn");
        super.new(name);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction

    task body();

        ////////////////////////////////////////////////////////////////////////
        ////Method name : write or read randomly
        ////Arguments   : NA
        ////Description : sequence for write and read randomly with len and size are random
        ////////////////////////////////////////////////////////////////////////

        repeat(10)begin
            req = axi_trans::type_id::create("req");

            start_item(req);
	  
            assert(req.randomize() with {
                req.wburst_type == WRAP;
                req.tx_type == WRITE;
               });
            finish_item(req);

        end

        repeat(10)begin
            start_item(req);
	  
            assert(req.randomize() with {
	        
                req.rburst_type == WRAP;
                req.tx_type == READ;
               });

            finish_item(req);
        end

    endtask

endclass

`endif


