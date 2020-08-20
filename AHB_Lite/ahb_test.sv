

/////////////PROGRAM BLOCK/////////////////

program test(AHBInterface InterfaceInstance);
	string testname;
	string test1;
    event e;
	environment env;
  	//user test case input
	initial 
begin
       @(e);
    env=new(testname,InterfaceInstance);
    $display("env class running");
    env.run;
end
initial
begin
    test1=string'($value$plusargs("testname=%s",testname));
    $display("testcase selected : %0s",testname);
    ->e;
    
end
/*
	initial begin
	env=new(testname,InterfaceInstance);
	env.run();
	end
	*/
endprogram