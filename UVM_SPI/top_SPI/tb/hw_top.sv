module hw_top;
    bit clock;
    bit sck_o;
    bit ss_o;

    wishbone_if wish_vif(clock);
    slave_if slave_vif(sck_o);


    simple_spi #(.SS_WIDTH()) 
    dut
    (
    .dat_i(wish_vif.dat_i),
    .cyc_i(wish_vif.cyc_i),
    .stb_i(wish_vif.stb_i),
    .adr_i(wish_vif.adr_i),
    .we_i (wish_vif.we_i),
    
    .inta_o(wish_vif.inta_o),
    .dat_o(wish_vif.dat_o),
    .ack_o(wish_vif.ack_o),

    .clk_i(wish_vif.clock),         // clock
    .rst_i(wish_vif.rst_i),         // reset (synchronous active high)

    .sck_o(sck_o),         // serial clock output
    .mosi_o(slave_vif.mosi_o),        // MasterOut SlaveIN
    .ss_o(ss_o),
    .miso_i(slave_vif.miso_i)         // MasterIn SlaveOut
    );

    always
        #5 clock = ~clock;

endmodule
