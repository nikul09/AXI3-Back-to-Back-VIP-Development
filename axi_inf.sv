
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul
////date          : 24/02/2024
////Description   : axi Interface class which is conatian signals of 5 channel of axi
////////////////////////////////////////////////////////////////////////

`ifndef axi_inf
`define axi_inf

interface axi_inf(input bit ACLK,ARESET);

    //------- write address channel -------//
    
    logic [3:0]AWID; //unique to each transection
    logic [31:0]AWADDR;
    logic [3:0]AWLEN; // 1 to 16 
    logic [2:0] AWSIZE;  //1,2,3..16..128 byte 
    logic [1:0] AWBURST;  // fixed, incr,wrap 
    logic AWVALID;
    logic AWREADY;

    //------- write data channel -------//
  
    logic [3:0]WID;
    logic [31:0]WDATA;
    logic [3:0]WSTB;
    logic WVALID;
    logic WREADY;
    logic WLAST;

    //------- write respons channel -------
   
    logic [3:0]BID;
    logic [1:0]BREP;
    logic BVALID;
    logic BREADY;

    //------- read address channel -------//

    logic [3:0]ARID;
    logic [31:0]ARADDR;
    logic [3:0]ARLEN; 
    logic [2:0]ARSIZE;  
    logic [1:0]ARBURST;
    logic ARVALID;
    logic ARREADY;

    //------- read data + respons channel -------//

    logic [3:0]RID;
    logic [31:0]RDATA;
    logic [1:0]RRESP;
    logic RLAST;
    logic RVALID;
    logic RREADY;

   //------- clocking bock for mster drv ------//

    clocking mdrv_cb@(posedge ACLK);
        default output #(1);
        default input #(1);

        output AWID, AWADDR, AWLEN, AWSIZE, AWBURST,AWVALID;
	    output WID, WDATA, WSTB, WLAST, WVALID;
	    inout BREADY;
	    output ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID;
	    output RREADY;

        input BVALID;
        input RLAST;
        input RVALID;
        input BREP;
        input RRESP;
    endclocking

    //------- clocking bock for master mon ------//

    clocking mmon_cb@(posedge ACLK);
        default input #(1);

        input AWREADY,AWVALID;
        input WREADY,WVALID;
        input BID, BREP, BVALID,BREADY;
        input ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARREADY,ARVALID;
        input RID, RDATA, RRESP, RLAST, RVALID,RREADY;

    endclocking

   //------- clocking bock for slave drv ------//

    clocking sdrv_cb@(posedge ACLK);
        default output #(1);
  
	    output AWREADY;
	    output WREADY;
	    output BID, BREP, BVALID;
	    output ARREADY;
        output RID,RDATA,RRESP,RLAST,RVALID;

    endclocking

   //------- clocking bock for slave mon ------//

   clocking smon_cb@(posedge ACLK);
       default input #(1);

       input AWID, AWADDR, AWLEN, AWSIZE, AWBURST,AWVALID,AWREADY;
	   input WID, WDATA, WSTB, WLAST, WVALID,WREADY;
	   input BREADY,BVALID;
	   input ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID,ARREADY;
 	   input RREADY,RVALID;
   endclocking

endinterface

`endif
