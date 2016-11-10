module freqCounter(
							input CLOCK,
							input sample,
							input shiftRst,
							input shiftClk,
							input [3:0] settingPin,
							output valueOut
						);
						
	localparam divisorLength = 26;
	reg [25:0]clockDivisor;
	reg [divisorLength-1:0] secMaker;

	localparam counterLength = 32;
	localparam itrLength = 5;
	wire [counterLength-1:0] counterOut;
	reg [counterLength-1:0] fCounter;
	reg [counterLength-1:0] capturedfCounter;
	reg [itrLength-1:0] counterItr;
	reg counterReset;
	
	PosEdgeCounter#(.length(counterLength)) counterModule(.clock(sample), .reset(counterReset), .counter(counterOut));

	always begin
		case(~settingPin)
			4'b0000: clockDivisor = 26'd2; 			//0.00000005
			4'b0001: clockDivisor = 26'd4; 			//0.0000001
			4'b0010: clockDivisor = 26'd20; 			//0.0000005
			4'b0011: clockDivisor = 26'd40; 			//0.000001
			4'b0100: clockDivisor = 26'd200; 		//0.000005
			4'b0101: clockDivisor = 26'd400; 		//0.00001
			4'b0110: clockDivisor = 26'd2000; 		//0.00005
			4'b0111: clockDivisor = 26'd4000; 		//0.0001
			4'b1000: clockDivisor = 26'd20001; 		//0.0005
			4'b1001: clockDivisor = 26'd40001; 		//0.001
			4'b1010: clockDivisor = 26'd200001; 	//0.005
			4'b1011: clockDivisor = 26'd400001; 	//0.01
			4'b1100: clockDivisor = 26'd2000001; 	//0.05
			4'b1101: clockDivisor = 26'd4000001;	//0.1
			4'b1110: clockDivisor = 26'd20000001;	//0.5
			4'b1111: clockDivisor = 26'd40000001;	//1
			
			default: clockDivisor = 26'd40000001; //1
		endcase
	end

	always @(posedge CLOCK)begin
		if(secMaker == clockDivisor)begin
			secMaker <= 0;
			counterReset <= 1;
			fCounter <= counterOut;
		end
		else begin
			secMaker <= secMaker + 1;
			counterReset <= 0;
		end
	end
	
	always @(posedge shiftClk or posedge shiftRst)begin
		if(shiftRst == 1)begin
			capturedfCounter <= fCounter;
			counterItr <= 0;
		end
		else begin
			counterItr <= counterItr + 1;
		end
	end
	
	assign valueOut = capturedfCounter[counterItr];
	

endmodule

module PosEdgeCounter#(
							parameter length = 1
						)(
							input clock,
							input reset,
							output reg [length-1 : 0] counter
						);
						
	always@(negedge clock or posedge reset)begin
		if(reset == 1)begin
			counter <= 0;
		end
		else begin
			counter <= counter + 32'b1;
		end
	end
endmodule
