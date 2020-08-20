/*Packet Class*/
class PacketClass;
	rand bit [31:0] Address_rand,Data_rand;
	constraint c {	Address_rand >  32'h00000000;
			Address_rand    <  32'h00000400;
	}
endclass

class PacketClass_notrand;
	bit [31:0] Address_rand,Data_rand;
endclass

class packet_burst_readwrite;
bit [31:0] addr;
int BEATS;
int busy;
bit [31:0] data_burst4[31:0];
bit[31:0] data4[31:0];
endclass

class generator;
mailbox gen2drv;
PacketClass pktCls;
PacketClass_notrand pktClsnr;
packet_burst_readwrite brd_wr;
string testname;
int rd,rd_wait;
logic wait_data;
virtual AHBInterface InterfaceInstance;
bit [31:0]data_burst_read[31:0];
//bit [31:0]data_burst[31:0] = '{32'd59, 32'd61, 32'd63, 32'd65};
bit [DATA_WIDTH-1:0] data_burst[31:0] = '{32'd59, 32'd61, 32'd63, 32'd65,32'd1,32'd2,32'd3,32'd4,32'd5,32'd6,32'd7,32'd8,32'd9,32'd10,32'd11,32'd12,32'd13,32'd14,32'd15,32'd16,32'd17,32'd18,32'd19,32'd20,32'd21,32'd22,32'd23,32'd24,32'd25,32'd26,32'd27,32'd28 } ;

function new(mailbox gen2drv,string testname);
this.gen2drv=gen2drv;
this.testname=testname;
$display("testname from gen: %0s",testname);
endfunction

task run();
$display("get run task executing");
case(testname)

		"test_basic_read_write":
		begin
        pktCls = new();
		assert(pktCls.randomize());
		gen2drv.put(pktCls);
		$display("get run task1 executing");
		$display("gen::pkt = %p", pktCls);
		end	

		"test_read_only_error_check":	
		begin
        pktClsnr = new();
		pktClsnr.Address_rand=32'h2;
		pktClsnr.Data_rand='1;
		gen2drv.put(pktClsnr);	
		$display("gen::pkt=%p",pktClsnr);
		$display("get run task2 executing");	
		end	
///////////////////////////////////////// TEST CASE FOR ZERO BUSY STATE ///////////////////////////////
		"test_burst1_busy0_beats4":	
		begin
        brd_wr = new();
		brd_wr.addr=32'd5;
		brd_wr.BEATS=4;
		brd_wr.busy=0;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task3 executing");	
		end

		"test_burst1_busy0_beats8":	 
		begin
        brd_wr = new();
		brd_wr.addr=32'd10;
		brd_wr.BEATS=8;
		brd_wr.busy=0;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task4 executing");
		end
		
		"test_burst1_busy0_beats16":	 
		begin
        brd_wr = new();
		brd_wr.addr=32'd25;
		brd_wr.BEATS=16;
		brd_wr.busy=0;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task5 executing");
		end
		
		//////////////////////////////////////// TEST CASE FOR SINGLE BUSY STATE ///////////////////////////////
		
		"test_burst1_busy1_beats4":	 
		begin
        brd_wr = new();
		brd_wr.addr=32'd5;
		brd_wr.BEATS=4;
		brd_wr.busy=1;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task6 executing");

		end
	
		"test_burst1_busy1_beats8":	 
		begin
        brd_wr = new();
		brd_wr.addr=32'd10;
		brd_wr.BEATS=8;
		brd_wr.busy=1;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task7 executing");
		end
		
		"test_burst1_busy1_beats16":	 
		begin
        brd_wr = new();
		brd_wr.addr=32'd25;
		brd_wr.BEATS=16;
		brd_wr.busy=1;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task8 executing");
		end
		
////////////////////////////////////////////// TEST CASE FOR DOUBLE BUSY STATES /////////////////////////////////////////////////
		
		"test_burst1_busy2_beats4":	 
		begin
        brd_wr = new();
		brd_wr.addr=32'd5;
		brd_wr.BEATS=4;
		brd_wr.busy=2;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task9 executing");
		end
		

		"test_burst1_busy2_beats8":	 
		begin
        brd_wr = new();
		brd_wr.addr=32'd10;
		brd_wr.BEATS=8;
		brd_wr.busy=2;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task10 executing");
		end
	
		"test_burst1_busy2_beats16":	 
		begin
        brd_wr = new();
		brd_wr.addr=32'd25;
		brd_wr.BEATS=16;
		brd_wr.busy=2;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task11 executing");
		end
		
////////////////////////////////////////////////////////WAIT STATES INITIATED BY THE SLAVE////////////////////////////////////////////////////////////			
"test_wait_state_byslave":	
	begin
		pktClsnr = new();
		pktClsnr.Address_rand=32'h00000004;
		pktClsnr.Data_rand=32'h1;
		gen2drv.put(pktClsnr);
		$display("gen::pkt=%p",pktClsnr);
		$display("get run wait executing");

		end


////////////////////////////////////////////BASIC READ AND WRITE - SLAVE 2///////////////////////////////////////////?/////
"test_basic2_readwrite":	
	begin
        pktClsnr = new();
		pktClsnr.Address_rand=32'h00000706;
		pktClsnr.Data_rand='1;
		gen2drv.put(pktClsnr);
		$display("gen::pkt=%p",pktClsnr);
		$display("get run basic slave2 executing");
end

		
	////////////////////////////////////////////BASIC 4 BEAT BURST READ AND WRITE - SLAVE 2///////////////////////////////////////////?/////		
"test_burst2_busy2_beats4":
	begin
        brd_wr = new();
		brd_wr.addr=32'h0700;
		brd_wr.BEATS=4;
		brd_wr.busy=2;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task12 executing");
		end
			
////////////////////////////////////////////BASIC 8 BEAT BEAT BURST READ AND WRITE - SLAVE 1//////////////////////////////////////////////
"test_burst2_busy2_beats8":
	begin
        brd_wr = new();
		brd_wr.addr=32'h0500;
		brd_wr.BEATS=8;
		brd_wr.busy=2;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task13 executing");
		end

////////////////////////////////////////////BASIC 16 BEAT 1 BUSY BURST READ AND WRITE - SLAVE 1//////////////////////////////////////////////
"test_burst2_busy0_beats4":
	begin
        brd_wr = new();
		brd_wr.addr=32'h0600;
		brd_wr.BEATS=4;
		brd_wr.busy=0;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task14 executing");
		end
	
	
////////////////////////////////////////////BASIC 16 BEAT 2 BUSY BURST READ AND WRITE - SLAVE 1//////////////////////////////////////////////
"test_burst2_busy2_beats16":
	begin
        brd_wr = new();
		brd_wr.addr=32'h580;
		brd_wr.BEATS=16;
		brd_wr.busy=2;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task15 executing");
		end
		
////////////////////////////////////////////BASIC 8 BEAT 1 BUSY BURST READ AND WRITE - SLAVE 1//////////////////////////////////////////////
"test_burst2_busy1_beats8":
	begin
        brd_wr = new();
		brd_wr.addr=32'h0680;
		brd_wr.BEATS=8;
		brd_wr.busy=1;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task16 executing");
		end
						
		
////////////////////////////////////////////BASIC 4 BEAT BURST READ AND WRITE - SLAVE 2///////////////////////////////////////////?/////		
"test_burst2_busy1_beats4":
	begin
        brd_wr = new();
		brd_wr.addr=32'h0730;
		brd_wr.BEATS=4;
		brd_wr.busy=1;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task17 executing");
		end

		
////////////////////////////////////////////BASIC 16 BEAT 1 BUSY BURST READ AND WRITE - SLAVE 2//////////////////////////////////////////////
"test_burst2_busy1_beats16":
	begin
        brd_wr = new();
		brd_wr.addr=32'h0780;
		brd_wr.BEATS=16;
		brd_wr.busy=1;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task18 executing");
		end
		
////////////////////////////////////////////BASIC 16 BEAT 0 BUSY BURST READ AND WRITE - SLAVE 2//////////////////////////////////////////////
"test_burst2_busy0_beats16":
	begin
        brd_wr = new();
		brd_wr.addr=32'h0725;
		brd_wr.BEATS=16;
		brd_wr.busy=0;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run task19 executing");
		end		

///////////////////////////////////////////OUT OF BOUNDS CHECK//////////////////////////////////////////////////
"test_outofbound":	
	begin
        brd_wr = new();
		brd_wr.addr=32'h0801;
		brd_wr.BEATS=4;
		brd_wr.busy=0;
		brd_wr.data4=data_burst;
		brd_wr.data_burst4=data_burst_read;
		gen2drv.put(brd_wr);
		$display("gen::pkt=%p",brd_wr);
		$display("get run out of bound executing");
		end		
endcase
endtask
endclass