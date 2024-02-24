
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi reset sequence 
////////////////////////////////////////////////////////////////////////

`ifndef axi_rst_sqn
`define axi_rst_sqn

class axi_rst_sqn extends base_sqn;

    `uvm_object_utils(axi_rst_sqn)
    function new(string name = "axi_rst_sqn");
        super.new(name);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction

    task body();

        req = axi_trans::type_id::create("req");

        // ------ rst write channels -----//

        start_item(req);

        assert(req.randomize() with {

            req.rburst_size == 0;
            req.rburst_len == 0;
            req.rburst_type == FIXED;
            req.tx_type == WRITE;
            req.wdata == {0};
            req.rid == 0;
            req.raddr == 0;

        });

       finish_item(req);

       // ----- rst read channels -----//

       start_item(req);

         assert(req.randomize() with {

            req.rburst_size == 0;
            req.rburst_len == 0;
            req.rburst_type == FIXED;
            req.tx_type == READ;
            req.rid == 0;
            req.raddr == 0;
            req.rdata == {0};

        });

       finish_item(req);


    endtask
  
endclass

`endif


