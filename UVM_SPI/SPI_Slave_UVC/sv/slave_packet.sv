class slave_packet extends uvm_sequence_item;
    rand bit [7:0] in_val;
         bit [7:0] out_val;
    rand bit miso_i;
    rand bit [2:0] pos;
         bit mosi_o;

    `uvm_object_utils_begin(slave_packet)
        `uvm_field_int(mosi_o, UVM_ALL_ON) 
        `uvm_field_int(out_val, UVM_ALL_ON + UVM_BIN)
        `uvm_field_int(miso_i, UVM_ALL_ON)
        `uvm_field_int(in_val, UVM_ALL_ON + UVM_BIN)
    `uvm_object_utils_end

    constraint valid_addr {miso_i == in_val[pos];}

    function new (string name = "slave_packet");
        super.new(name);
    endfunction : new

endclass
