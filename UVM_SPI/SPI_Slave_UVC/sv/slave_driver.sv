class slave_driver extends uvm_driver #(slave_packet);
    `uvm_component_utils(slave_driver)
    virtual interface slave_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(!(uvm_config_db#(virtual slave_if)::get(this, "*", "vif", vif)))
        `uvm_error(get_type_name(), "Failed to get VIF from config DB!")
    endfunction

    task run_phase(uvm_phase phase);
        drive_slave();
    endtask

    task drive_slave();
        forever begin
            seq_item_port.get_next_item(req);
            @(posedge vif.sck_o);
            vif.in_value<= req.in_val;
            vif.miso_i<= req.miso_i;
            `uvm_info(get_type_name(), $sformatf("Packet sent:\n%s", req.sprint()), UVM_NONE)
            seq_item_port.item_done();
        end
    endtask

    // TODO INTGERATE  
    // function void report_phase(uvm_phase phase);
    //     `uvm_info(get_type_name(), $sformatf("Report: YAPP TX driver sent %0d packets", num_sent), UVM_LOW)
    // endfunction : report_phase
endclass