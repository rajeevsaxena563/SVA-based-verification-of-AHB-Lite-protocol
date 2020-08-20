class driver;
mailbox gen2drv;
PacketClass pktCls;
PacketClass_notrand pktClsnr;
packet_burst_readwrite brd_wr;
virtual AHBInterface InterfaceInstance;
string testname;
int rd,rd_wait;
logic wait_data;
bit [31:0]data_burst_read[31:0];
//bit [31:0]data_burst[31:0] = '{32'd59, 32'd61, 32'd63, 32'd65};
bit [DATA_WIDTH-1:0] data_burst[31:0] = '{32'd59, 32'd61, 32'd63, 32'd65,32'd1,32'd2,32'd3,32'd4,32'd5,32'd6,32'd7,32'd8,32'd9,32'd10,32'd11,32'd12,32'd13,32'd14,32'd15,32'd16,32'd17,32'd18,32'd19,32'd20,32'd21,32'd22,32'd23,32'd24,32'd25,32'd26,32'd27,32'd28 } ;

function new(mailbox gen2drv,string testname,virtual AHBInterface InterfaceInstance) ;
this.gen2drv=gen2drv;
this.testname=testname;
this.InterfaceInstance=InterfaceInstance;
$display("testname from drv: %0s",testname);
endfunction

task run();
$display("driver run task executing");
forever begin
case(testname)
"test_basic_read_write":
begin
        pktCls = new();
		gen2drv.get(pktCls);
		
		//InterfaceInstance.write (32'h00000004, '1);
		InterfaceInstance.write(pktCls.Address_rand,pktCls.Data_rand);
		#20;
		//InterfaceInstance.read (32'h00000004, rd); 
		InterfaceInstance.read (pktCls.Address_rand, rd);
			$display("DRV::pkt=%p",pktCls);
end	
"test_read_only_error_check":	
begin
        pktClsnr = new();
		gen2drv.get(pktClsnr);	
		/////////////////////////////////READ ONLY ERROR CHECK//////////////////////////////////////////
		//`ifdef ERROR_INJECT
			InterfaceInstance.write (pktClsnr.Address_rand,pktClsnr.Data_rand);
			#20;
			InterfaceInstance.read (pktClsnr.Address_rand, rd);
				$display("DRV::pkt=%p",pktClsnr);
			#20;
		//`endif
	end	
		
"test_burst1_busy0_beats4":	
	begin
        brd_wr = new();
		gen2drv.get(brd_wr);
		
		///////////////////////////////////////// TEST CASE FOR ZERO BUSY STATE ///////////////////////////////
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - BURST4  = %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3] );
		`endif
	end

"test_burst1_busy0_beats8":	 
	begin
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - BURST8  = %d, %d, %d, %d, %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7] );
		`endif
	end
		
"test_burst1_busy0_beats16":	 
	begin
		brd_wr = new();
		gen2drv.get(brd_wr);	
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - BURST16 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n",brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7],
									brd_wr.data_burst4[8], brd_wr.data_burst4[9], brd_wr.data_burst4[10], brd_wr.data_burst4[11], brd_wr.data_burst4[12], brd_wr.data_burst4[13], brd_wr.data_burst4[14], brd_wr.data_burst4[15]);
		`endif
	end	
		//////////////////////////////////////// TEST CASE FOR SINGLE BUSY STATE ///////////////////////////////
"test_burst1_busy1_beats4":	 
	begin
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - BURST4  = %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3] );
		`endif
	end
	
"test_burst1_busy1_beats8":	 
	begin
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - BURST8  = %d, %d, %d, %d, %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7] );
		`endif
	end
		
"test_burst1_busy1_beats16":	 
	begin
		brd_wr = new();
		gen2drv.get(brd_wr);	
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - BURST16 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7],
									brd_wr.data_burst4[8], brd_wr.data_burst4[9], brd_wr.data_burst4[10], brd_wr.data_burst4[11], brd_wr.data_burst4[12], brd_wr.data_burst4[13], brd_wr.data_burst4[14], brd_wr.data_burst4[15]);
		`endif
	end	
////////////////////////////////////////////// TEST CASE FOR DOUBLE BUSY STATES /////////////////////////////////////////////////
"test_burst1_busy2_beats4":	 
	begin
		brd_wr = new();
		gen2drv.get(brd_wr);
	InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - BURST4  = %d, %d, %d, %d\n",brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3]);
		`endif
	end
		
"test_burst1_busy2_beats8":	 
	begin
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - BURST8  = %d, %d, %d, %d, %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7] );
		`endif
	end
	
"test_burst1_busy2_beats16":	 
	begin
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - BURST16 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n",brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7],
									brd_wr.data_burst4[8], brd_wr.data_burst4[9], brd_wr.data_burst4[10], brd_wr.data_burst4[11], brd_wr.data_burst4[12], brd_wr.data_burst4[13], brd_wr.data_burst4[14], brd_wr.data_burst4[15]);
		`endif
	end

"test_wait_state_byslave":	
	begin
        pktClsnr = new();
		gen2drv.get(pktClsnr);
		
////////////////////////////////////////////////////////WAIT STATES INITIATED BY THE SLAVE////////////////////////////////////////////////////////////			
		
		fork
			begin
			wait_data = 1;
			`ifdef DEBUG
			$display ("wait data = %d\n", wait_data);
			`endif
			#60;
			wait_data = 0;
			#20;
			`ifdef DEBUG
			$display ("wait data = %d\n", wait_data);
			`endif
			end
			
			begin
			#20;
			InterfaceInstance.write(pktClsnr.Address_rand,pktClsnr.Data_rand);
			#20;
			#20;
			InterfaceInstance.read (pktClsnr.Address_rand,pktClsnr.Data_rand);
				$display("DRV::pkt=%p",pktClsnr);
			end
		join 
	
	
		
		`ifdef DEBUG
		$display ("DATA @ address 32'h00000004 with wait states installed by Slave = %h\n", pktClsnr.Data_rand);
		`endif
		
		end


"test_basic2_readwrite":	
	begin
        pktClsnr = new();
		gen2drv.get(pktClsnr);
////////////////////////////////////////////BASIC READ AND WRITE - SLAVE 2///////////////////////////////////////////?/////		
		
		//InterfaceInstance.write (32'h00000706, '1);
		InterfaceInstance.write(pktClsnr.Address_rand,pktClsnr.Data_rand);
		#20;
		InterfaceInstance.read (pktClsnr.Address_rand, rd); 

		`ifdef DEBUG
		$display ("DATA @ address 706h - SLAVE 2 = %h\n", rd);
		`endif
	end
"test_burst2_busy2_beats4":	
	begin
    	brd_wr = new();
		gen2drv.get(brd_wr);	
////////////////////////////////////////////BASIC 4 BEAT BURST READ AND WRITE - SLAVE 2///////////////////////////////////////////?/////		
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - 4 BEAT BURST - SLAVE 2  = %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3] );
		`endif
	end
////////////////////////////////////////////BASIC 8 BEAT BEAT BURST READ AND WRITE - SLAVE 2/////////////////////////////////////////////
"test_burst2_busy2_beats8":
	begin
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - 8 BEAT BURST - SLAVE 2 = %d, %d, %d, %d, %d, %d, %d, %d\n",brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7]);
		`endif
	end
////////////////////////////////////////////BASIC 16 BEAT 1 BUSY BURST READ AND WRITE - SLAVE 2//////////////////////////////////////////////
"test_burst2_busy0_beats4":
	begin		
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - 4 BEAT BURST - SLAVE 2= %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7], 
											brd_wr.data_burst4[8], brd_wr.data_burst4[9], brd_wr.data_burst4[10], brd_wr.data_burst4[11], brd_wr.data_burst4[12], brd_wr.data_burst4[13], brd_wr.data_burst4[14], brd_wr.data_burst4[15]);
		`endif
	end
	
////////////////////////////////////////////BASIC 16 BEAT 2 BUSY BURST READ AND WRITE - SLAVE 2/////////////////////////////////////////////
"test_burst2_busy2_beats16":
	begin		
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - 16 BEAT BURST - SLAVE 2 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7], 
											brd_wr.data_burst4[8], brd_wr.data_burst4[9], brd_wr.data_burst4[10], brd_wr.data_burst4[11], brd_wr.data_burst4[12], brd_wr.data_burst4[13], brd_wr.data_burst4[14], brd_wr.data_burst4[15] );
		`endif	
	end			
////////////////////////////////////////////BASIC 8 BEAT 1 BUSY BURST READ AND WRITE - SLAVE 2//////////////////////////////////////////////
"test_burst2_busy1_beats8":
	begin
		brd_wr = new();
		gen2drv.get(brd_wr);	
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - 8 BEAT BURST - SLAVE 2 = %d, %d, %d, %d, %d, %d, %d, %d\n",brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7] );
		`endif		
	end	
				
////////////////////////////////////////////BASIC 4 BEAT BURST READ AND WRITE - SLAVE 2///////////////////////////////////////////?/////		
"test_burst2_busy1_beats4":
	begin		
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - 4 BEAT BURST - SLAVE 2  = %d, %d, %d, %d\n",brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3]);
		`endif
	end	
		
////////////////////////////////////////////BASIC 16 BEAT 1 BUSY BURST READ AND WRITE - SLAVE 2//////////////////////////////////////////////
	"test_burst2_busy1_beats16":
	begin	
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - 16 BEAT BURST - SLAVE 2 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7], 
											brd_wr.data_burst4[8], brd_wr.data_burst4[9], brd_wr.data_burst4[10], brd_wr.data_burst4[11], brd_wr.data_burst4[12], brd_wr.data_burst4[13], brd_wr.data_burst4[14], brd_wr.data_burst4[15] );
		`endif	
	end	
		
		
////////////////////////////////////////////BASIC 16 BEAT 0 BUSY BURST READ AND WRITE - SLAVE 2//////////////////////////////////////////////
"test_burst2_busy0_beats16":
	begin		
		brd_wr = new();
		gen2drv.get(brd_wr);
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - 16 BEAT BURST - SLAVE 2 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", brd_wr.data_burst4[0], brd_wr.data_burst4[1], brd_wr.data_burst4[2], brd_wr.data_burst4[3], brd_wr.data_burst4[4], brd_wr.data_burst4[5], brd_wr.data_burst4[6], brd_wr.data_burst4[7], 
											brd_wr.data_burst4[8], brd_wr.data_burst4[9], brd_wr.data_burst4[10], brd_wr.data_burst4[11], brd_wr.data_burst4[12], brd_wr.data_burst4[13], brd_wr.data_burst4[14], brd_wr.data_burst4[15] );
		`endif			
		
	end	
		
"test_outofbound":	
	begin
        brd_wr = new();
		gen2drv.get(brd_wr);
///////////////////////////////////////////OUT OF BOUNDS CHECK//////////////////////////////////////////////////
		
		InterfaceInstance.burst_write (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data4);
		#20;
		InterfaceInstance.burst_read (brd_wr.addr,brd_wr.BEATS,brd_wr.busy, brd_wr.data_burst4);
		#20;
		$display("DRV::pkt=%p",brd_wr);
	end		
endcase
$stop;
end
endtask
endclass