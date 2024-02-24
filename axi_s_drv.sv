
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024
////Description   : axi slave driver
////////////////////////////////////////////////////////////////////////

`ifndef axi_s_drv
`define axi_s_drv

class axi_s_drv extends uvm_driver#(axi_trans);

    virtual axi_inf vinf;
    axi_trans write_rsp_tx_asso[bit[3:0]];
    axi_trans read_data_tx_asso[bit[3:0]];
    axi_trans ar_trans_h,r_trans_h;

    `uvm_component_utils(axi_s_drv)

    function new(string name = "axi_s_drv",uvm_component parent);
        super.new(name,parent);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"inside build phase",UVM_LOW)
        if(!uvm_config_db#(virtual axi_inf)::get(this,"*","vinf",vinf))
            `uvm_fatal(get_type_name(),"FAILD TO GET INF ")
    endfunction

    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"Inside run phase ",UVM_LOW)
        forever begin
            wait(!vinf.ARESET);

            fork
                get_req();
                hand_shake();
                drv_write_rsp();
                drv_read_data();
            join
        end
    endtask
  
  ////////////////////////////////////////////////////////////////////////
  ////Method name : get reqest from memory 
  ////Arguments   : NA
  ////Description : get request task fach request (memory) from sequencer using get method which is non blocking, and put request in queue
  ////////////////////////////////////////////////////////////////////////
  
  task get_req();
      `uvm_info(get_type_name(),"GET REQ, SLAVE DRV",UVM_NONE)
      forever begin
         seq_item_port.get(req);

         if(req.tx_type == WRITE)begin
             ar_trans_h = new req;
             write_rsp_tx_asso[ar_trans_h.wid] = ar_trans_h;
         end
         else begin
             r_trans_h = new req;
             read_data_tx_asso[r_trans_h.rid] = r_trans_h;
         end
     end
  endtask

  ////////////////////////////////////////////////////////////////////////
  ////Method name : hand shake signals
  ////Arguments   : NA
  ////Description : Provide handshaking
  ////////////////////////////////////////////////////////////////////////
  
  task hand_shake();
      `uvm_info(get_type_name(),"GET REQ, SLAVE DRV",UVM_NONE)
      vinf.sdrv_cb.AWREADY <= 1;
      vinf.sdrv_cb.WREADY <= 1;
      vinf.sdrv_cb.ARREADY <= 1;
  endtask

  ////////////////////////////////////////////////////////////////////////
  ////Method name : drvive write response
  ////Arguments   : NA
  ////Description : drive write response which is geting from memory
  ////////////////////////////////////////////////////////////////////////

  task drv_write_rsp();
      `uvm_info(get_type_name(),"DRV WRITE RSP, SLAVE DRV",UVM_NONE)
      forever begin
          @(vinf.sdrv_cb);
          wait(write_rsp_tx_asso.size() != 0);
          foreach(write_rsp_tx_asso[i])begin
              vinf.sdrv_cb.BID <= write_rsp_tx_asso[i].wid;
              vinf.sdrv_cb.BREP <= resp_t'(write_rsp_tx_asso[i].wresp);
              vinf.sdrv_cb.BVALID <= 1;
              @(vinf.sdrv_cb);
              wait(vinf.BREADY);
          end
          write_rsp_tx_asso.delete();
          vinf.sdrv_cb.BVALID <= 0;
      end
  endtask
  
  ////////////////////////////////////////////////////////////////////////
  ////Method name : drive read data 
  ////Arguments   : NA
  ////Description : drive read data from memory 
  ////////////////////////////////////////////////////////////////////////

  task drv_read_data();
      `uvm_info(get_type_name(),"DRV READ DATA, SLAVE DRV",UVM_NONE)
      forever begin
          @(vinf.sdrv_cb);
          wait(read_data_tx_asso.size() != 0);
          foreach(read_data_tx_asso[i])begin
              for(int j=0;j<=read_data_tx_asso[i].rburst_len;j++)begin
                  @(vinf.sdrv_cb);
                  vinf.sdrv_cb.RID <= read_data_tx_asso[i].rid;
                  vinf.sdrv_cb.RDATA <= read_data_tx_asso[i].rdata.pop_front();
                  vinf.sdrv_cb.RVALID <= 1;

                  if(read_data_tx_asso[i].rburst_len == j && vinf.sdrv_cb.RVALID == 1)begin
                      vinf.sdrv_cb.RLAST <= 1;
                      vinf.sdrv_cb.RRESP <= read_data_tx_asso[i].rresp;
                      @(vinf.sdrv_cb);
                      vinf.sdrv_cb.RVALID <= 0;
                      vinf.sdrv_cb.RLAST <= 0;
                  end
                  else vinf.sdrv_cb.RLAST <= 0;
                  
                  @(vinf.sdrv_cb);
                  wait(vinf.RREADY);
              end
              read_data_tx_asso.delete(i);
              vinf.sdrv_cb.RVALID <= 0;
          end
      end
  endtask
   
endclass

`endif
