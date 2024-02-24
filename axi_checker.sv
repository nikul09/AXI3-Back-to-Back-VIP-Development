
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul
////date          : 24/2/2024
////Description   : axi checkers class
////////////////////////////////////////////////////////////////////////

`ifndef axi_checker
`define axi_checker

class axi_checker extends uvm_subscriber#(axi_trans);

    axi_trans trans_h;
    virtual axi_inf vinf;

   `uvm_component_utils(axi_checker);

   function new(string name = "axi_checker",uvm_component parent);
       super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       if(!uvm_config_db#(virtual axi_inf)::get(this,"*","vinf",vinf))
            `uvm_fatal(get_type_name(),"FAILD TO GET INF ") 
   endfunction

   function void write(axi_trans t);
       ckecker_wrap_based_transection(t);
       handshaking_signals_ckecker(t);
       checker_wr_addr_data(t);
   endfunction

   //Argument name 'tx_pkt' for virtual method 'write' in sub class 'axi_checker' does not match the argument name 't' in superclass 'uvm_subscriber'
   
   ////////////////////////////////////////////////////////////////////////
   ////Method name : ckecker_wrap_based_transection
   ////Arguments   : NA
   ////Description : wrap based transcetion validating brust len and address must be aligned 
   ////////////////////////////////////////////////////////////////////////
   
   task ckecker_wrap_based_transection(axi_trans trans_h);
       if(trans_h.wburst_type == WRAP || trans_h.rburst_type == WRAP)begin
           if(trans_h.tx_type == WRITE)begin
               
               if(trans_h.waddr == int'(trans_h.waddr/2**trans_h.wburst_size)*(2**trans_h.wburst_size))begin
                   `uvm_info(get_name(),"PASS : AWADDR are Aligned ",UVM_NONE)
               end
               else `uvm_info(get_name(),"FAIL : AWADDR arn't Aligned ",UVM_NONE)

               if(trans_h.wburst_len inside {1,3,7,15})begin 
                   `uvm_info(get_name(),"PASS : wburst len is valid for WRAP transection ",UVM_NONE)
               end
               else `uvm_info(get_name(),"FAIL : wburst len is not valid for WRAP transection ",UVM_NONE)

           end
           else begin
               
               if(trans_h.raddr == int'(trans_h.raddr/2**trans_h.rburst_size)*(2**trans_h.rburst_size))begin
                   `uvm_info(get_name(),"PASS : ARADDR are Aligned ",UVM_NONE)
               end
               else `uvm_info(get_name(),"FAIL : ARADDR arn't Aligned ",UVM_NONE)

               if(trans_h.rburst_len inside {1,3,7,15})begin
                   `uvm_info(get_name(),"PASS : rburst len is valid for WRAP transection ",UVM_NONE)
               end
               else `uvm_info(get_name(),"FAIL : rburst len is not valid for WRAP transection ",UVM_NONE)

           end
       end
   endtask
   
   ////////////////////////////////////////////////////////////////////////
   ////Method name : checker_wr_addr_data
   ////Arguments   : NA 
   ////Description : validating write address and data 
   ////////////////////////////////////////////////////////////////////////
   
   task checker_wr_addr_data(axi_trans trans_h);

       if(trans_h.tx_type == WRITE)begin
       
           // write addr must be 32-bit 
    
           if($size(trans_h.waddr) == 32)begin
               `uvm_info(get_name(),"PASS : AWADDR aren valid -> 32-bit ",UVM_NONE)
           end
           else `uvm_fatal(get_name(),"FAIL ! : AWADDR are't valid !");

           // Bus size is 32- bit so for single transfer send only 4 byte 

           if(trans_h.wburst_size < 6)begin
               `uvm_info(get_name(),"PASS : AWBURST SIZE are valid ",UVM_NONE)
           end
           else `uvm_fatal(get_name(),"PASS : AWBURST SIZE are't valid !");
       
           // write data must bi 32 bit & transfer is burstlen + 1

           foreach(trans_h.wdata[i])begin
               if($size(trans_h.wdata[i]) == 32)begin
                   `uvm_info(get_name(),"PASS : WDATA are valid",UVM_NONE)
                   if(i == trans_h.wburst_len)
                       `uvm_info(get_name(),"PASS : AWBURST LEN is X then TRANSFER X + 1 ",UVM_NONE)
                   end
                   else `uvm_fatal(get_name(),"PASS : AWBURST LEN is X then TRANSFER X + 1 are Faild");
               end
               else `uvm_fatal(get_name(),"PASS : WDATA are't valid");
           end
   endtask

   ////////////////////////////////////////////////////////////////////////
   ////Method name : checker_rd_addr_data
   ////Arguments   : NA
   ////Description : validating read channle address and data
   ////////////////////////////////////////////////////////////////////////
   
   task checker_rd_addr_data(axi_trans trans_h);
       if(trans_h.tx_type == READ)begin

           // write addr must be 32-bit 

           if($size(trans_h.raddr) == 32)begin
               `uvm_info(get_name(),"PASS : ARADDR aren valid -> 32-bit ",UVM_NONE)
           end
           else `uvm_fatal(get_name(),"FAIL ! : ADDR are't valid !");

           // Bus size is 32- bit so for single transfer send only 4 byte 

           if(trans_h.rburst_size < 6)begin
               `uvm_info(get_name(),"PASS : BURST SIZE are valid ",UVM_NONE)
           end
           else `uvm_fatal(get_name(),"PASS : BURST SIZE are't valid !");
       end
   endtask

   ////////////////////////////////////////////////////////////////////////
   ////Method name : handshaking_signals_ckecker
   ////Arguments   : NA
   ////Description : Validating operation based on handshaking signals
   ////////////////////////////////////////////////////////////////////////

   task handshaking_signals_ckecker(axi_trans trans_h);
       for(int i = 0;i<=trans_h.wburst_len;i++)begin
           if(i == 1 && vinf.WLAST == 1)begin
               `uvm_info(get_name(),"PASS: WLAST triggered HIGH at Last data of id",UVM_NONE)
           end
           else `uvm_warning(get_name(),"FAIL: WLAST triggered HIGH at Last data of id")
       end
   endtask
endclass

`endif
