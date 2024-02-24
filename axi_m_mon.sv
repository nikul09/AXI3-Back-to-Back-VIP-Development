
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : Master Monitor class 
////////////////////////////////////////////////////////////////////////

`ifndef axi_m_mon
`define axi_m_mon

class axi_m_mon extends uvm_monitor;

    virtual axi_inf vinf;
    axi_trans tx_h;
    axi_trans tx_asso[int];
    int cnt;

    `uvm_component_utils(axi_m_mon)

    uvm_analysis_port #(axi_trans) mmon_ap;

    function new(string name = "axi_m_mon",uvm_component parent);
        super.new(name,parent);
        `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"inside build phase",UVM_LOW)
        mmon_ap = new("mmon_ap",this);
        tx_h = axi_trans::type_id::create("tx_h");

        if(!uvm_config_db#(virtual axi_inf)::get(this,"*","vinf",vinf))
            `uvm_fatal(get_type_name(),"FAILD TO GET INF ")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            sample_addr();
        end
  endtask

  task sample_addr();
      @(vinf.mmon_cb);
      if(vinf.mmon_cb.ARVALID && vinf.mmon_cb.ARREADY)begin
          tx_h = new();
          tx_h.rid = vinf.mmon_cb.ARID;
          tx_h.raddr = vinf.mmon_cb.ARADDR;
          tx_h.rburst_len = vinf.mmon_cb.ARLEN;
          tx_h.rburst_size = vinf.mmon_cb.ARSIZE;
          tx_h.rburst_type = burst_t'(vinf.mmon_cb.ARBURST);
          tx_asso[cnt] = tx_h;
          cnt++;
      end

      if(vinf.mmon_cb.RVALID && vinf.mmon_cb.RREADY)begin
          foreach(tx_asso[i])begin
              if(tx_asso[i].rid == vinf.mmon_cb.RID)begin
                  tx_asso[i].rdata.push_back(vinf.mmon_cb.RDATA);
                  if(vinf.mmon_cb.RLAST)begin
                      mmon_ap.write(tx_asso[i]);
                      tx_asso.delete(i);
                  end
              end
          end
      end
  endtask

endclass

`endif
