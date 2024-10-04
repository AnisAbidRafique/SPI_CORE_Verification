class SPI_tb extends uvm_env;
  `uvm_component_utils(SPI_tb)

  slave_env slave;
  wishbone_env wishbone;
  SPI_scorboard scoreboard;

  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    slave = slave_env::type_id::create("slave", this);
    wishbone = wishbone_env::type_id::create("wishbone", this);
    scoreboard = SPI_scorboard::type_id::create("scoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    wishbone.my_agent.monitor.item_collected_port.connect(scoreboard.wishbone_in_fifo.analysis_export);
    slave.agent.monitor.mon2scoreboard_port.connect(scoreboard.slave_out_fifo.analysis_export);
  endfunction


endclass

