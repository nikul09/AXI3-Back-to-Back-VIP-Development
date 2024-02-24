
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi scoreboard 
////////////////////////////////////////////////////////////////////////

`ifndef axi_sb
`define axi_sb

`uvm_analysis_imp_decl(_axi_master_monitor)
`uvm_analysis_imp_decl(_axi_slave_monitor)

class axi_sb extends uvm_scoreboard;

    axi_trans mrx[$];
    axi_trans srx[$];
    axi_trans mrx_temp,srx_temp;

    reg[31:0]refmem[*];

    bit[31:0]temp_data;

    uvm_analysis_imp_axi_master_monitor#(axi_trans,axi_sb)mip;
    uvm_analysis_imp_axi_slave_monitor#(axi_trans,axi_sb)sip;

    /*delecre analysis implication for capture transection
    from master monitor and slave monitor*/

   `uvm_component_utils(axi_sb);

   function new(string name = "axi_sb",uvm_component parent);
       super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       mip = new("mip",this);
       sip = new("sip",this);
   endfunction

   /*write method:write method are pure virtual function, must impliment otherwise throw error
    implimenet write method capture master monitor transection*/

   function void write_axi_master_monitor(axi_trans tx_pkt);
       mrx.push_back(tx_pkt);
   endfunction

   /*implimenet write method capture slave monitor transection */

   function void write_axi_slave_monitor(axi_trans tx_pkt);
       srx.push_back(tx_pkt);
   endfunction

   task run_phase(uvm_phase phase);
       fork
           sb_master();
           sb_slave();
       join
 endtask

 ////////////////////////////////////////////////////////////////////////
 ////Method name : scoreaboard task for master
 ////Arguments   : NA
 ////Description : these task collecet pkt which is comming from master monitor
 ////////////////////////////////////////////////////////////////////////

 task sb_master();
     forever begin
         wait(srx.size() > 0);
         srx_temp = srx.pop_front();
         if(srx_temp.tx_type == WRITE)begin
             refmodel(srx_temp);
        end
    end
 endtask

 ////////////////////////////////////////////////////////////////////////
 ////Method name : scorebaord task for slave  
 ////Arguments   : NA
 ////Description : these task collecet pkt which is comming from slave monitor
 ////////////////////////////////////////////////////////////////////////

 task sb_slave();
     forever begin
         wait(mrx.size() > 0);
         mrx_temp = mrx.pop_front();
         compare_logic(mrx_temp);
     end
 endtask

////////////////////////////////////////////////////////////////////////
////Method name : referenece model 
////Arguments   : axi_trans tx_h
////Description : refernece model to compare golden with actual transection
////////////////////////////////////////////////////////////////////////

 task refmodel(axi_trans tx_h);
     bit[31:0]temp_addr = tx_h.waddr;
     for(int i = 0;i<=tx_h.wburst_len;i++)begin
         refmem[temp_addr] = tx_h.wdata[i];
         temp_addr++;
     end
   //`uvm_info("SB",$sformatf("mem:{%0p}",refmem),UVM_NONE)
 endtask

 ////////////////////////////////////////////////////////////////////////
 ////Method name : compare logic 
 ////Arguments   : axi_trans tx_actual
 ////Description : compare logic which is compare tb ref model with actual
 ////////////////////////////////////////////////////////////////////////

 task compare_logic(axi_trans tx_actual);
     if(refmem.exists(tx_actual.raddr))begin
         for(int i = 0;i<=tx_actual.rburst_len;i++)begin
             temp_data = tx_actual.rdata[i];
             if(temp_data == refmem[tx_actual.raddr + i])begin
                 `uvm_info("SCOR",
                     $sformatf("MATCH ! EXPECTED:{%0h}, ACTUAL:{%0h}",refmem[tx_actual.raddr + i],temp_data),
                     UVM_NONE)
             end
             else begin
                 `uvm_fatal("SCOR",
                     $sformatf("MISMATCH ! EXPECTED:{%0h}, ACTUAL:{%0h}",refmem[tx_actual.raddr + i],temp_data))
             end
         end
     end
 endtask

endclass

`endif
