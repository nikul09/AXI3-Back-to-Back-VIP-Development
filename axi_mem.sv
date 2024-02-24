
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : Memory commponet to hold data class 
////////////////////////////////////////////////////////////////////////

`ifndef axi_mem
`define axi_mem

class axi_mem extends uvm_component;

    uvm_analysis_imp#(axi_trans,axi_mem) mem_ip;

    static mailbox#(axi_trans) mem2sqn;
    axi_trans wtx_que[$];
    byte mem[int];
    bit[31:0]temp_wdata;
    bit[31:0]temp_rdata;
    bit[31:0]temp_waddr;
    bit[31:0]temp_raddr;
    int temp_inc;
    bit last_flag;

    uvm_queue#(axi_trans)my_que;

    axi_trans tx_temp,tx_drv;
    
    `uvm_component_utils(axi_mem)

    function new(string name = "axi_mem", uvm_component parent);
        super.new(name,parent);
	    `uvm_info(get_type_name(),"inside constructor",UVM_LOW)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"inside build phase",UVM_LOW)
	    mem_ip = new("mem_ip",this);
	    mem2sqn = new();
        my_que = uvm_queue#(axi_trans)::get_global_queue();
    endfunction

    function void write(axi_trans t);
        wtx_que.push_back(t);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            wait(wtx_que.size() > 0);
            tx_temp = wtx_que.pop_front();

            if(tx_temp.tx_type == WRITE)begin
                tx_temp.wrap_boundry_calculations(tx_temp.w_wrap_lower,
                                        tx_temp.w_wrap_upper,
                                        tx_temp.waddr,
                                        tx_temp.wburst_len,
                                        tx_temp.wburst_size);
                temp_waddr = tx_temp.waddr;
                case(tx_temp.wburst_type)

                // -- FIXED brust type when WRITE request --//

                FIXED:
                begin
                    for(int i = 0;i<=tx_temp.wburst_len;i++)begin
                        temp_wdata = tx_temp.wdata[i];
                        for(int k = 0;k< 2**tx_temp.wburst_size;k++)begin
                            mem[temp_waddr] = temp_wdata[8*k +: 8];
                        end
                        if(tx_temp.wburst_len == i)begin
                            tx_temp.wresp = OKAY;
                            mem2sqn.put(tx_temp);
                        end
                    end
                end

		       // -- INCR brust type when WRITE request --//
		      INCR:
              begin
                  for(int i = 0;i<=tx_temp.wburst_len;i++)begin
                      temp_wdata = tx_temp.wdata[i];

                      for(int k = 0;k< 2**tx_temp.wburst_size;k++)begin
                          mem[temp_waddr + k] = temp_wdata[8*k +: 8];
                          temp_inc = k;
                      end

                      temp_waddr = temp_waddr + temp_inc + 1;

                      if(tx_temp.wburst_len == i)begin
                          tx_temp.wresp = OKAY;
                          mem2sqn.put(tx_temp);
                      end
                  end
              end

             // -- WRAP brust type when WRITE request --//
		     WRAP:
             begin
                 int byte_per_tx = (2**tx_temp.wburst_size)*(tx_temp.wburst_len + 1);
                 bit[31:0]addr1 = (temp_waddr / byte_per_tx) * byte_per_tx;
                 int cnt;

                 for(int i = 0;i<=tx_temp.wburst_len;i++)begin
                     temp_wdata = tx_temp.wdata[i];
                     for(int k = 0;k<2**tx_temp.wburst_size;k++)begin
                         mem[addr1 + (temp_waddr + cnt)% byte_per_tx] = temp_wdata[8*k +: 8];
                         cnt++;
                     end
                     if(tx_temp.wburst_len == i)begin
                         tx_temp.wresp = OKAY;
                         mem2sqn.put(tx_temp);
                     end
                 end
             end
         endcase
     end
     else begin
         if(mem.exists(tx_temp.raddr))begin
             tx_temp.wrap_boundry_calculations(tx_temp.r_wrap_lower,
                                        tx_temp.r_wrap_upper,
                                        tx_temp.raddr,
                                        tx_temp.rburst_len,
                                        tx_temp.rburst_size);
             temp_raddr = tx_temp.raddr;
		     case(tx_temp.rburst_type)

		     // -- FIXED brust type when READ request --//
		     FIXED:
             begin
                 for(int i = 0;i<=tx_temp.rburst_len;i++)begin
                     for(int k = 0;k< 2**tx_temp.wburst_size;k++)begin
                         tx_temp.rdata[i][8*k +: 8] = mem[temp_raddr];
                     end
                     if(tx_temp.rburst_len == i)begin
                         tx_temp.rresp = OKAY;
                         mem2sqn.put(tx_temp);
                     end
                 end
             end

            // -- INCR brust type when READ request --//
            INCR: 
            begin
                for(int i = 0;i<=tx_temp.rburst_len;i++)begin
                    for(int j = 0;j< 2**tx_temp.rburst_size;j++)begin
                        tx_temp.rdata[i][8*j +: 8] = mem[temp_raddr + j];
				        temp_inc = j;
					end
                    temp_raddr = temp_raddr + temp_inc + 1;

                    if(tx_temp.rburst_len == i)begin
                        tx_temp.rresp = OKAY;
                        mem2sqn.put(tx_temp);
                    end
                end
            end

		   // -- WRAP brust type when READ request --//
           WRAP:
           begin
               int byte_per_tx = (2**tx_temp.rburst_size)*(tx_temp.rburst_len + 1);
               bit[31:0]addr1 = (temp_raddr / byte_per_tx) * byte_per_tx;
               int cnt;

               for(int i = 0;i<=tx_temp.rburst_len;i++)begin
                   for(int k = 0;k<2**tx_temp.rburst_size;k++)begin
                       tx_temp.rdata[i][8*k +: 8] = mem[addr1 + (temp_raddr + cnt)% byte_per_tx];
                       cnt++;
                   end
                   if(tx_temp.rburst_len == i)begin
                       tx_temp.rresp = OKAY;
                       mem2sqn.put(tx_temp);
                   end
               end
           end
       endcase
   end
   else begin
       `uvm_info("MEM","------  NOT EXIST ------",UVM_NONE)
        tx_temp.rresp = SLVERR;
        tx_temp.rburst_len = 0;
        tx_temp.rburst_len = 0;
        tx_temp.rdata.delete();
        mem2sqn.put(tx_temp);
    end
end
end
endtask

endclass

`endif
