// 64 bit option for AWS labs
-64
-access
+rwc
//-gui
-sv 
-timescale 1ns/1ns
+SVSEED=random
-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d
+UVM_TESTNAME=demo_base_test
+UVM_VERBOSITY=UVM_MEDIUM


// include directories
//*** add incdir include directories here
-incdir ../sv/




// compile files
//*** add compile files here
../sv/slave_pkg.sv
../sv/slave_if.sv
slave_top.sv
