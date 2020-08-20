`include "definesPkg.sv"
import definesPkg::* ;				// Wildcard Import

module top;
logic HCLK;
logic HRESETn, wait_data;
//string test1;
//string testname;
//event e;
//environment env;
///////////////INSTANCIATION///////////////
AHBInterface AHBBUS (.HCLK(HCLK), .HRESETn(1'b1));
AHBSlaveTop SlaveTop(.SlaveInterface(AHBBUS.Slave), .wait_slave_to_master(wait_data));
test T1(AHBBUS);
monitor m1(.Bus(AHBBUS),.reset());
//virtual AHBInterface InterfaceInstance;
always #10 HCLK = ~HCLK;
/*
initial 
begin
       @(e);
    env=new(testname,AHBBUS);
    $display("env class running");
    env.run;
end
initial
begin
    test1=string'($value$plusargs("testname=%s",testname));
    $display("testcase selected : %0s",testname);
    ->e;
    
end
*/
initial 
begin
HCLK=1'b1;
end
//initial begin 
//InterfaceInstance = AHBBUS;
//end


endmodule 