
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024
////Description   : Master Driver class
////////////////////////////////////////////////////////////////////////

`ifndef axi_m_drv
`define axi_m_drv

class axi_m_drv extends uvm_driver#(axi_trans);

    virtual axi_inf vinf;
    axi_trans aw_trans_h,w_trans_h,ar_trans_h,trans_h;
    
    axi_trans write_addr_tx_asso[bit[3:0]];
    axi_trans write_data_tx_asso[bit[3:0]];
    axi_trans read_addr_tx_asso[bit[3:0]];
    `uvm_component_utils(axi_m_drv)

    function new(string name = "axi_m_drv",uvm_component parent);
        super.new(name,parent);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rsp = axi_trans::type_id::create("rsp");
        `uvm_info(get_type_name(),"inside build phase",UVM_LOW)
        if(!uvm_config_db#(virtual axi_inf)::get(this,"*","vinf",vinf))
            `uvm_fatal(get_type_name(),"FAILD TO GET INF ")
    endfunction

    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"inside run phase",UVM_LOW)

        wait(!vinf.ARESET);

        fork
            get_req();
            hand_shake();
            drv_write_addr();
            drv_write_data();
            drv_read_addr();
            wait_for_rsp();
        join

    endtask

 ////////////////////////////////////////////////////////////////////////
 ////Method name : get request
 ////Arguments   : NA
 ////Description : get request task fach request (sequence) from sequencer using get method which is non blocking, and put request in queue
 ////////////////////////////////////////////////////////////////////////

 task get_req();
     `uvm_info(get_type_name(),"GET REQ, MASTER DRV",UVM_NONE)
     forever begin
         seq_item_port.get(req);
         if(req.tx_type == WRITE)begin
             aw_trans_h = new req;
             w_trans_h = new req;
             write_addr_tx_asso[aw_trans_h.wid] = aw_trans_h;
             write_data_tx_asso[w_trans_h.wid] = w_trans_h;
         end
         else begin
             ar_trans_h = new req;
             read_addr_tx_asso [ar_trans_h.rid] = ar_trans_h;
         end

        wait(write_data_tx_asso.size() + read_addr_tx_asso.size() < 1);
                  
     end
 endtask

 ////////////////////////////////////////////////////////////////////////
 ////Method name : wait for response
 ////Arguments   : NA
 ////Description : put res from slave driver drive which is bres and rres
 ////////////////////////////////////////////////////////////////////////

 task wait_for_rsp();
     fork
         forever begin
             @(vinf.mdrv_cb);
             if(vinf.mdrv_cb.BVALID && vinf.mdrv_cb.BREADY)begin
                 rsp.set_id_info(req);
                 rsp.wresp = resp_t'(vinf.mdrv_cb.BREP);
                 seq_item_port.put(rsp);
             end
         end

         forever begin
             @(vinf.mdrv_cb);
             if(vinf.mdrv_cb.RVALID && vinf.mdrv_cb.RLAST && vinf.mdrv_cb.RVALID)begin
                 rsp.set_id_info(ar_trans_h);
                 rsp.rresp = resp_t'(vinf.mdrv_cb.RRESP);
                 seq_item_port.put(rsp);
             end
         end
     join
 endtask 

 ////////////////////////////////////////////////////////////////////////
 ////Method name : Hand shake signals 
 ////Arguments   : NA
 ////Description : provide handshaking
 ////////////////////////////////////////////////////////////////////////

 task hand_shake();
     `uvm_info(get_type_name(),"HAND SHAKE SIGNALS , MASTER DRV",UVM_NONE)
     vinf.mdrv_cb.BREADY <= 1;
     vinf.mdrv_cb.RREADY <= 1;
 endtask
 
 ////////////////////////////////////////////////////////////////////////
 ////Method name : drive write address (aw channel) 
 ////Arguments   : NA
 ////Description : drive write request which is from write_addr_tx_asso
 ////////////////////////////////////////////////////////////////////////

 task drv_write_addr();
     `uvm_info(get_type_name(),"DRV WRITE ADDR, MASTER DRV",UVM_NONE)
     forever begin
         @(vinf.mdrv_cb);
         wait(write_addr_tx_asso.size() != 0);
         foreach(write_addr_tx_asso[i])begin
             vinf.mdrv_cb.AWID <= write_addr_tx_asso[i].wid;
             vinf.mdrv_cb.AWADDR <= write_addr_tx_asso[i].waddr;
             vinf.mdrv_cb.AWLEN <= write_addr_tx_asso[i].wburst_len;
             vinf.mdrv_cb.AWSIZE <= write_addr_tx_asso[i].wburst_size;
             vinf.mdrv_cb.AWBURST <= burst_t'(write_addr_tx_asso[i].wburst_type);
             vinf.mdrv_cb.AWVALID <= 1;
             @(vinf.mdrv_cb);
             wait(vinf.AWREADY);
         end
         write_addr_tx_asso.delete();
         vinf.mdrv_cb.AWVALID <= 0;
     end
 endtask

 ////////////////////////////////////////////////////////////////////////
 ////Method name : drive write data (W channel)
 ////Arguments   : NA
 ////Description : drive write data request which is from write_data_tx_asso
 ////////////////////////////////////////////////////////////////////////
 
 task drv_write_data();
     `uvm_info(get_type_name(),"DRV WRITE DATA, MASTER DRV",UVM_NONE)
     forever begin
         @(vinf.mdrv_cb);
         wait(write_data_tx_asso.size() != 0);
         foreach(write_data_tx_asso[i])begin
             for(int j = 0;j<=write_data_tx_asso[i].wburst_len;j++)begin
                 vinf.mdrv_cb.WID <= write_data_tx_asso[i].wid;
                 vinf.mdrv_cb.WDATA <= write_data_tx_asso[i].wdata.pop_front();
                 vinf.mdrv_cb.WSTB <= 4'b1111;
                 vinf.mdrv_cb.WVALID <= 1;
                 if(write_data_tx_asso[i].wburst_len == j && vinf.mdrv_cb.WVALID == 1)begin
                     vinf.mdrv_cb.WLAST <= 1;
                     @(vinf.mdrv_cb);
                     vinf.mdrv_cb.WVALID <= 0;
                     vinf.mdrv_cb.WLAST <= 0;
                 end
                 else vinf.mdrv_cb.WLAST <= 0;
                 @(vinf.mdrv_cb);
                 wait(vinf.WREADY);
             end
            write_data_tx_asso.delete(i);
            vinf.mdrv_cb.WVALID <= 0;
         end
     end
 endtask

 ////////////////////////////////////////////////////////////////////////
 ////Method name : drive read address (AR channel)
 ////Arguments   : NA
 ////Description : drive write data request which is from read_addr_tx_asso
 ////////////////////////////////////////////////////////////////////////

 task drv_read_addr();
     `uvm_info(get_type_name(),"DRV READ ADDR, MASTER",UVM_NONE)
     forever begin
         @(vinf.mdrv_cb);
         wait(read_addr_tx_asso.size() != 0);
         foreach(read_addr_tx_asso[i])begin
             vinf.mdrv_cb.ARID <= read_addr_tx_asso[i].rid;
             vinf.mdrv_cb.ARADDR <= read_addr_tx_asso[i].raddr;
             vinf.mdrv_cb.ARLEN <= read_addr_tx_asso[i].rburst_len;
             vinf.mdrv_cb.ARSIZE <= read_addr_tx_asso[i].rburst_size;
             vinf.mdrv_cb.ARBURST <= burst_t'(read_addr_tx_asso[i].rburst_type);
             vinf.mdrv_cb.ARVALID <= 1;
             @(vinf.mdrv_cb);
             wait(vinf.ARREADY);
         end
         read_addr_tx_asso.delete();
        vinf.mdrv_cb.ARVALID <= 0;
     end
 endtask

endclass

`endif


