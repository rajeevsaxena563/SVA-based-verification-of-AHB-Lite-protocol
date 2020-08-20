class environment;
virtual AHBInterface InterfaceInstance;
generator gen;
driver drv;
mailbox gen2drv;
string testname;
function new(string testname,virtual AHBInterface InterfaceInstance);
   gen2drv=new();
   this.testname=testname;
   this.InterfaceInstance= InterfaceInstance;
$display("testfrom env: 50s",testname);
endfunction

task build();
gen=new(gen2drv,testname);
drv=new(gen2drv,testname,InterfaceInstance);
$display("ENV:run task executing");
endtask

task run();
build;
fork
    gen.run();
    drv.run();
join
endtask
endclass