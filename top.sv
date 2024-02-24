
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi top module
////////////////////////////////////////////////////////////////////////

`include "uvm_macros.svh"

module top;

    import uvm_pkg::*;
    import axi_pkg::*;

    bit aclk;
    bit areset;

    //--- clock --//

    axi_inf pinf(aclk,areset);

    initial begin
        uvm_config_db#(virtual axi_inf)::set(null,"*","vinf",pinf);
    end

    initial begin
        forever #5 aclk = ~ aclk;
    end
   
    initial begin
        areset = 1;
        #7;
        areset = 0;
    end

    initial begin
        rst();
        run_test("");
    end

    function void rst();
        pinf.AWID = 0;
        pinf.AWADDR = 0;
        pinf.AWLEN = 0;
        pinf.AWSIZE = 0;
        pinf.AWVALID = 0;
        pinf.AWREADY = 0;
        pinf.WID = 0;
        pinf.WDATA = 0;
        pinf.WSTB = 0;
        pinf.WLAST = 0;
        pinf.WVALID = 0;
        pinf.WREADY = 0;
        pinf.BID = 0;
        pinf.BREP = 0;
        pinf.BVALID = 0;
        pinf.BREADY = 0;
        pinf.ARID = 0;
        pinf.ARADDR = 0;
        pinf.ARLEN = 0;
        pinf.ARSIZE = 0;
        pinf.ARBURST = 0;
        pinf.ARVALID = 0;
        pinf.ARREADY = 0;
        pinf.RID = 0;
        pinf.RDATA = 0;
        pinf.RRESP = 0;
        pinf.RLAST = 0;
        pinf.RVALID = 0;
        pinf.AWBURST = 0;
        pinf.RREADY = 0;
    endfunction

endmodule

