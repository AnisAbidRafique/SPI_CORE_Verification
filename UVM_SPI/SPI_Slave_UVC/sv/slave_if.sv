interface slave_if (input bit sck_o);
  logic mosi_o;
  logic miso_i;
  bit [7:0] in_value;
endinterface