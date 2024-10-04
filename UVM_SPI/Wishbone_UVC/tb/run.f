
/*-----------------------------------------------
 IUS release without embedded UVM library,
 using library supplied with lab files.
------------------------------------------------*/
-uvmhome /home/advancedresearch/cadence/installs/XCELIUM2309/tools.lnx86/methodology/UVM/CDNS-1.1d
-timescale 1ns/100ps

../../SPI_rtl/fifo4.v
../../SPI_rtl/simple_spi_top.v

// include directories, starting with UVM src directory
-incdir ../sv
//../sv/dummy_dut.sv

// uncomment for gui
//-gui
+access+rwc

// default timescale

// options
//+UVM_VERBOSITY=UVM_LOW
+UVM_VERBOSITY=UVM_MEDIUM
//+UVM_TESTNAME=demo_base_test
+UVM_TESTNAME=wishbone_basic_test
//+UVM_TESTNAME=hbus_master_topology

// compile files
../sv/wishbone_pkg.sv
../sv/wishbone_if.sv 
wishbone_top.sv
