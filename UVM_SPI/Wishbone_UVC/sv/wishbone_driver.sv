class wishbone_driver extends uvm_driver#(wishbone_trans);

virtual wishbone_if vif;

`uvm_component_utils(wishbone_driver)

  wishbone_trans item;
  //port for CPOL and CPHA 
  uvm_analysis_port #(wishbone_trans) item_port_scb;

    function new (string name = "wishbone_driver",uvm_component parent);
        super.new(name,parent);
    `uvm_info(get_type_name(),"Inside wishbone_driver constructor",UVM_HIGH)
    item_port_scb = new("item_port_scb", this);
    endfunction

    //build phase
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if (!wishbone_if_config::get(this,"","vif", vif))
        `uvm_error("NOVIF","vif not set")  
    endfunction: build_phase


    task run_phase(uvm_phase phase);

        forever 
        begin
            item = wishbone_trans::type_id::create("item");
            seq_item_port.get_next_item(item);
            if(item.adr_i == 0 && item.we_i == 1)
              item_port_scb.write(item);
            send_to_dut(item);
            seq_item_port.item_done();
        end
    endtask

      task send_to_dut(wishbone_trans my_req);
        `uvm_info(get_type_name(),$sformatf("Packet is \n%s", my_req.sprint()),UVM_LOW)
        @(negedge vif.clock);
      vif.dat_i <=   item.dat_i;
      vif.cyc_i <= item.cyc_i;   
      vif.stb_i <= item.stb_i;   
      vif.adr_i <= item.adr_i;   
      vif.we_i  <= item.we_i; 
      vif.rst_i <= item.rst_i; 
      
    endtask

    // // UVM run_phase
    // task run_phase(uvm_phase phase);
    //     fork
    //     get_and_drive();
    //     reset_signals();
    //     join
    // endtask : run_phase

    // // Gets packets from the sequencer and passes them to the driver. 
    // task get_and_drive();
    //     @(posedge vif.reset);
    //     @(negedge vif.reset);
    //     `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
    //     forever begin
    //     // Get new item from the sequencer
    //     seq_item_port.get_next_item(req);
    //     // vif.set_srb_control(req.srb_control); // to control the monitor of yapp
    //     `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_LOW)
    //     // concurrent blocks for packet driving and transaction recording
    //     fork
    //         // send packet
    //         begin
    //         // for acceleration efficiency, write unsynthesizable dynamic payload array directly into 
    //         // interface static payload array
    //         foreach (req.payload[i])
    //             vif.payload_mem[i] = req.payload[i];
    //         // send rest of YAPP packet via individual arguments
    //         vif.send_to_dut(req.length, req.addr, req.parity, req.packet_delay);
    //         end
    //         // trigger transaction at start of packet (trigger signal from interface)
    //         @(posedge vif.drvstart) void'(begin_tr(req, "Driver_YAPP_Packet"));
    //     join
    //     // End transaction recording
    //     end_tr(req);
    //     num_sent++;
    //     // Communicate item done to the sequencer
    //     seq_item_port.item_done();
    //     end
    // endtask : get_and_drive

    // // Reset all TX signals
    // task reset_signals();
    //     forever 
    //     vif.yapp_reset();
    // endtask : reset_signals

    // // UVM report_phase
    // function void report_phase(uvm_phase phase);
    //     `uvm_info(get_type_name(), $sformatf("Report: YAPP TX driver sent %0d packets", num_sent), UVM_LOW)
    // endfunction : report_phase

  

    function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"I am here",UVM_HIGH)
    endfunction

endclass