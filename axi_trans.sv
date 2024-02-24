
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi transection class
////////////////////////////////////////////////////////////////////////

`ifndef axi_trans
`define axi_trans

typedef enum bit[1:0]{FIXED,INCR,WRAP}burst_t;
typedef enum bit[1:0]{OKAY,EXOKAY,SLVERR,DECERR }resp_t;
typedef enum bit[1:0]{WRITE,READ,WR_RD}tran_type;

class axi_trans extends uvm_sequence_item;

    // -- write addr trans ---//

    rand bit[3:0]wid;
    rand bit[31:0]waddr;
    rand bit [3:0]wburst_len;
    rand bit [1:0]wburst_size;
    rand burst_t wburst_type; 
    rand bit[31:0]wdata[$];
    rand bit[3:0]wstb[$];
    rand resp_t wresp;
    // -- read addr trans --//

    rand bit[3:0]rid;
    rand bit[31:0]raddr;
    rand bit [3:0]rburst_len;
    rand bit [1:0]rburst_size;
    rand burst_t rburst_type;
    rand bit[31:0]rdata[$];
    rand bit[3:0]rstb[$];
    rand resp_t rresp;

    // -- transection type --//
    
    rand tran_type tx_type;
  
    // -- wrap boundry calculation --//

    bit[31:0]w_wrap_lower,w_wrap_upper;
    bit[31:0]r_wrap_lower,r_wrap_upper;
    
    int wbyte_per_tx,wreminder;
    int rbyte_per_tx,rreminder;

    bit[3:0]wid_que[$];
    bit[31:0]waddr_que[$];
    bit[3:0]rid_que[$];
    bit[31:0]raddr_que[$];


    `uvm_object_utils_begin(axi_trans)

        `uvm_field_enum(tran_type,tx_type,UVM_ALL_ON)
         `uvm_field_int(wid,UVM_ALL_ON)
         `uvm_field_int(waddr,UVM_ALL_ON)
         `uvm_field_int(wburst_len,UVM_ALL_ON)
         `uvm_field_int(wburst_size,UVM_ALL_ON)
         `uvm_field_enum(burst_t,wburst_type,UVM_ALL_ON)
         `uvm_field_queue_int(wdata,UVM_ALL_ON)
         `uvm_field_queue_int(wstb,UVM_ALL_ON)
         `uvm_field_enum(resp_t,wresp,UVM_ALL_ON)
         
         `uvm_field_int(w_wrap_lower,UVM_ALL_ON)
         `uvm_field_int(w_wrap_upper,UVM_ALL_ON)
         
         `uvm_field_int(rid,UVM_ALL_ON)
         `uvm_field_int(raddr,UVM_ALL_ON)
         `uvm_field_int(rburst_len,UVM_ALL_ON)
         `uvm_field_int(rburst_size,UVM_ALL_ON)
         `uvm_field_enum(burst_t,rburst_type,UVM_ALL_ON)
         `uvm_field_queue_int(rdata,UVM_ALL_ON)
         `uvm_field_queue_int(rstb,UVM_ALL_ON)
         `uvm_field_int(r_wrap_lower,UVM_ALL_ON)
        
         `uvm_field_int(r_wrap_upper,UVM_ALL_ON)
         `uvm_field_enum(resp_t,rresp,UVM_ALL_ON)

    `uvm_object_utils_end


    constraint que_size{
        
        solve wburst_len before wdata; 
        solve wburst_size before wdata;

        solve rburst_len before rdata;
        solve rburst_size before rdata;
        
        wdata.size() == wburst_len + 1;
        rdata.size() == rburst_len + 1;
    }

    constraint burst_len_cons{
        solve wburst_type before wburst_len;
        solve rburst_type before rburst_len;

       if(wburst_type == WRAP || rburst_type == WRAP){
           wburst_len inside {1,3,7,15};
           rburst_len inside {1,3,7,15};
       }
    }

    constraint aligned_addr{
        solve wburst_type before waddr;
        solve rburst_type before raddr;
        solve wburst_size before waddr;
        solve rburst_size before raddr;
        
        if(wburst_type == WRAP || rburst_type == WRAP){
            waddr == int'(waddr/2**wburst_size) * (2**wburst_size);
            raddr == int'(raddr/2**rburst_size) * (2**rburst_size);
        }
    }

    constraint uni_id_addr{
        soft !(wid inside {wid_que});
        soft !(rid inside {rid_que});
	    soft !(waddr inside {waddr_que});
	    soft !(raddr inside {raddr_que});
	}

    function void post_randomize();
        wid_que.push_front(wid);
        rid_que.push_front(rid);
        waddr_que.push_front(waddr);
        raddr_que.push_front(raddr);

        if(wid_que.size() == $size(wid)) wid_que.delete();
        if(rid_que.size() == $size(rid)) rid_que.delete();
        if(waddr_que.size() == $size(waddr)) waddr_que.delete();
        if(raddr_que.size() == $size(raddr)) raddr_que.delete();
    endfunction

    task wrap_boundry_calculations(output bit [31:0]w_lower,bit[31:0]w_upper,input bit[31:0]addr,bit[3:0]len,bit[1:0]size);
        int byte_per_tx = (len + 1) * (2**size);
        int reminder = addr % byte_per_tx;
        w_lower = addr - reminder;
        w_upper = w_lower + (byte_per_tx - 1);
    endtask

    function new(string name = "axi_trans");
        super.new(name);
    endfunction

endclass



`endif


