
////////////////////////////////////////////////////////////////////////
////devloper name : Mevada Nikul 
////date          : 24/02/2024 
////Description   : axi base test
////////////////////////////////////////////////////////////////////////

`ifndef axi_base_test
`define axi_base_test

class axi_base_test extends uvm_test;

    axi_env env;

    `uvm_component_utils(axi_base_test)

    function new(string name = "axi_base_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi_env::type_id::create("env",this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    function void report_phase(uvm_phase phase);
        uvm_report_server svr_h;

        svr_h = uvm_report_server::get_server();

        if((svr_h.get_severity_count(UVM_WARNING) + svr_h.get_severity_count(UVM_FATAL) + svr_h.get_severity_count(UVM_ERROR)) == 0)begin
            `uvm_info("REPORT PHASE","TEST PASS !!",UVM_NONE)
            // method are get_severity return number of counts of uvm_fatal,warning,error
            $display("");
            $display("  ######  ######  ######  ###### ");
            $display("  #    #  #    #  #       #     ");
            $display("  #    #  #    #  #       #     ");
            $display("  #    #  #    #  #       #     ");
            $display("  ######  ######  ######  ###### ");
            $display("  #       #    #       #       # ");
            $display("  #       #    #       #       # ");
            $display("  #       #    #       #       # ");
            $display("  #       #    #  ######  ###### ");
            $display("");

        end
        else begin
            `uvm_info("REPORT PHASE","TEST FAIL !!",UVM_NONE)
            
            $display("");
            $display("  ######  ######  #######  #      ");
            $display("  #       #    #     #     #      ");
            $display("  #       #    #     #     #      ");
            $display("  #       #    #     #     #      ");
            $display("  ######  ######     #     #      ");
            $display("  #       #    #     #     #      ");
            $display("  #       #    #     #     #      ");
            $display("  #       #    #     #     #      ");
            $display("  #       #    #  #######  ####### ");
            $display("");
            

        end
    endfunction

endclass 

`endif

