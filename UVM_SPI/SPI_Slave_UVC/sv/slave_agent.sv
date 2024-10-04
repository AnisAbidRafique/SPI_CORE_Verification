class slave_agent extends uvm_agent;
    protected uvm_active_passive_enum is_active = UVM_ACTIVE;
    `uvm_component_utils(slave_agent)
    slave_driver driver;
    slave_monitor monitor;
    slave_sequencer sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = slave_monitor::type_id::create("monitor", this);
        
        if(is_active == UVM_ACTIVE) begin
            sequencer = slave_sequencer::type_id::create("sequencer", this);
            driver = slave_driver::type_id::create("driver", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end 
    endfunction
endclass