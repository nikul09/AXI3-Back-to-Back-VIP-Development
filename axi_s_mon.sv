
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi slave monitor
////////////////////////////////////////////////////////////////////////

`ifndef axi_s_mon
`define axi_s_mon

class axi_s_mon extends uvm_monitor;

    virtual axi_inf vinf;
    axi_trans wtx_h,rtx_h;
    axi_trans tx_asso[int];
    int cnt;

    uvm_analysis_port #(axi_trans) smon_ap;

    `uvm_component_utils(axi_s_mon)

    function new(string name = "axi_s_mon",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"inside build phase",UVM_LOW)
        smon_ap = new("smon_ap",this);
        wtx_h = axi_trans::type_id::create("wtx_h");
        rtx_h = axi_trans::type_id::create("rtx_h");
        if(!uvm_config_db#(virtual axi_inf)::get(this,"*","vinf",vinf))
            `uvm_fatal(get_type_name(),"FAILD TO GET INF ")
    endfunction

    task run_phase(uvm_phase phase);
        fork
            addr_data_phase_sample();
            read_addr_phase_sample();
        join
    endtask


    ////////////////////////////////////////////////////////////////////////
    ////Method name : address and data of write transection sample 
    ////Arguments   : NA
    ////Description : for pkt of write need to collect write address and write data
    ////////////////////////////////////////////////////////////////////////

    task addr_data_phase_sample();
        forever begin
            @(vinf.smon_cb);
            if(vinf.smon_cb.AWVALID && vinf.smon_cb.AWREADY)begin
                wtx_h = new;
                wtx_h.wid = vinf.smon_cb.AWID;
                wtx_h.waddr = vinf.smon_cb.AWADDR;
                wtx_h.wburst_len = vinf.smon_cb.AWLEN;
                wtx_h.wburst_size = vinf.smon_cb.AWSIZE;
                wtx_h.wburst_type = burst_t'(vinf.smon_cb.AWBURST);
                tx_asso[cnt] = wtx_h;
                cnt++;
            end

            
            ////////////////////////////////////////////////////////////////////////
            ////Method name : WRITE DATA PHASE
            ////Arguments   : NA
            ////Description : Need to collect data address and data in single pkt.
            ////////////////////////////////////////////////////////////////////////

            if(vinf.smon_cb.WVALID && vinf.smon_cb.WREADY)begin
                foreach(tx_asso[i])begin
                    if(tx_asso[i].wid ==vinf.smon_cb.WID)begin
                        tx_asso[i].wdata.push_back(vinf.smon_cb.WDATA);

                        if(vinf.smon_cb.WLAST)begin
                            wtx_h.tx_type = WRITE;
                            smon_ap.write(tx_asso[i]);
                            tx_asso.delete(i);
                        end
                    end
                end
            end
        end
    endtask


    ////////////////////////////////////////////////////////////////////////
    ////Method name : read address sample
    ////Arguments   : NA
    ////Description : for read operation need to sample addresses
    ////////////////////////////////////////////////////////////////////////

    task read_addr_phase_sample();
        forever begin
            @(vinf.smon_cb);
            if(vinf.smon_cb.ARVALID && vinf.smon_cb.ARREADY)begin
                rtx_h.tx_type = READ;
                rtx_h.rid = vinf.smon_cb.ARID;
                rtx_h.raddr = vinf.smon_cb.ARADDR;
                rtx_h.rburst_len = vinf.smon_cb.ARLEN;
                rtx_h.rburst_size = vinf.smon_cb.ARSIZE;
                rtx_h.rburst_type = burst_t'(vinf.smon_cb.ARBURST);
                smon_ap.write(rtx_h);
            end
        end
    endtask

 endclass

 `endif
