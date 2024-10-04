// 64 bit option for AWS labs
-64
-access
+rwc
//-gui
-sv 
-timescale 1ns/1ns
+SVSEED=random
-uvmhome /home/advancedresearch/cadence/installs/XCELIUM2309/tools.lnx86/methodology/UVM/CDNS-1.1d
+UVM_TESTNAME=base_test
+UVM_VERBOSITY=UVM_NONE

../../SPI_rtl/fifo4.v
../../SPI_rtl/simple_spi_top.v

// include directories
//*** add incdir include directories here
-incdir ../../Wishbone_UVC/sv/
-incdir ../../SPI_Slave_UVC/sv/
-incdir ../../SPI_rtl/
-incdir ../sv/




// compile files
//*** add compile files here
../../Wishbone_UVC/sv/wishbone_pkg.sv
../../Wishbone_UVC/sv/wishbone_if.sv
../../SPI_Slave_UVC/sv/slave_pkg.sv
../../SPI_Slave_UVC/sv/slave_if.sv



hw_top.sv
SPI_top.sv
