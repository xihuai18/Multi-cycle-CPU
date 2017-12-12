module ControlUnit(
	input wire Reset, sign, zero, CLK,
	input wire [5:0] opcode,
	output reg PCWre, ALUSrcA, ALUSrcB, DBDataSrc, RegWre, 
		WrRegDSrc, InsMemRW, RD, WR, IRWre, ExtSel,
	output reg [1:0] PCSrc, RegDst,
	output reg [2:0] ALUOp
	);

parameter [3:0] sIF = 4'b0000,
								sID = 4'b0001,
								EAL = 4'b0001,
								EBR = 4'b0001,
								ELS = 4'b0001,
								MLD = 4'b0001,
								MST = 4'b0001,
								WAL = 4'b0001,
								WLD = 4'b0001;

reg [3:0] state_now, state_next;

wire addop, subop, addiop, orop, andop, oriop, sllop,
	sltop, sltiop, swop, lwop, beqop, bneop, bgtzop, jop, jrop,
	jalop, haltop;
assign addop = (opcode == 6'b000000);
assign subop = (opcode == 6'b000001);
assign addiop = (opcode == 6'b000010);
assign orop = (opcode == 6'b010000);
assign andop = (opcode == 6'b010001);
assign oriop = (opcode == 6'b010010);
assign sllop = (opcode == 6'b011000);
assign sltop = (opcode == 6'b100110);
assign sltiop = (opcode == 6'b100111);
assign swop = (opcode == 6'b110000);
assign lwop = (opcode == 6'b110001);
assign beqop = (opcode == 6'b110100);
assign bneop = (opcode == 6'b110101);
assign bgtzop = (opcode == 6'b110110);
assign jop = (opcode == 6'b111000);
assign jrop = (opcode == 6'b111001);
assign jalop = (opcode == 6'b111010);
assign haltop = (opcode == 6'b111111);

always @(posedge CLK or posedge Reset) begin
	if(1 == Reset)
		state_now = sIF;
	else 
		state_now = state_next;
end


always @(state_now or opcode) begin
	case(state_now)
		sIF: state_next = sID;
		sID: begin
			if (jop || jalop || jrop) begin
				state_next = sIF;
			end
			else if (addop || addiop || orop || oriop || subop ||
				sltop || sllop || sltiop || andop) begin
				state_next = EAL;	
			end
			else if (beqop || bneop || bgtzop) begin
				state_next = EBR;
			end
			else begin
				state_next = ELS;
			end
		end
		EAL: begin
			state_next = WAL;
		end
		EBR: begin
			state_next = sIF;
		end
		ELS: begin
			if (lwop) begin
				state_next = MLD;
			end
			else begin
				state_next = MST;
			end
		end
		MLD: begin
			state_next = WLD;
		end
		MST: begin
			state_next = sIF;
		end
		WLD: begin
			state_next = sIF;
		end
		WAL: begin
			state_next = sIF;
		end
		default: begin
			state_next = sIF;
		end
	endcase
end

always @(state_now or opcode) begin
//choose each signal respectively
	//PCWre
	if ((state_now == sID && !haltop) || state_now == EBR ||
		state_now == MST || state_now == WLD || 
		state_now == WAL)
		PCWre = 1;
	else 
		PCWre = 0;
	//ALUSrcA
	if (state_now == EAL && sllop)
		ALUSrcA = 1;
	else 
		ALUSrcA = 0;
	//ALUSrcB
	if ((state_now == EAL && (addiop || oriop || sltiop)) ||
		state_now == ELS && (swop || lwop))
		ALUSrcB = 1;
	else 
		ALUSrcB = 0;
	//DBDataSrc
	if (state_now == MLD && lwop)
		DBDataSrc = 1;
	else 
		DBDataSrc = 0;
	//RegWre
	if ((state_now == sID && jalop) || state_now == WLD ||
		state_now == WAL)
		RegWre = 1;
	else 
		RegWre = 0;
	//WrRegDSrc
	if (state_now == WLD || state_now == WAL)
		WrRegDSrc = 1;
	else 
		WrRegDSrc = 0;
	//InsMemRW
	if (state_now == sIF)
		InsMemRW = 1;
	else 
		InsMemRW = 0;
	//RD
	RD = 0;
	//WR
	if (state_now == MST)
		WR = 0;
	else 
		WR = 1;
	//IRWre
	if (state_now == sIF)
		IRWre = 1;
	else 
		IRWre = 0;
	//ExtSel
	if (state_now == EAL && (addiop || sltiop) ||
		state_now == ELS || state_now == EBR)
		ExtSel = 1;
	else 
		ExtSel = 0;
	//PCSrc
	if (state_now == sID) begin
		if (jop || jalop)
			PCSrc = 2'b11;
		else if (jrop)
			PCSrc = 2'b10;
		else 
			PCSrc = 2'b00;
	end
	else if (state_now == EBR) begin
		if ((beqop && zero == 1) || (bneop && zero == 0) || (bgtzop && zero==0 && sign == 0))
			PCSrc = 2'b01;
		else PCSrc = 2'b00;
	end
	//RegDst
	if (state_now == sID && jalop)
		RegDst = 2'b00;
	else if (state_now == WLD)
		RegDst = 2'b01;
	else if (state_now == WAL) begin
		if (addiop || oriop || sltiop)
			RegDst = 2'b01;
		else 
			RegDst = 2'b10;
	end
	else 
		RegDst = 2'b00;
	//ALUOp
	if (state_now == EAL) begin
		if (addiop) ALUOp = 3'b000;
		else if (subop) ALUOp = 3'b001;
		else if (addiop) ALUOp = 3'b000;
		else if (orop) ALUOp = 3'b101;
		else if (andop) ALUOp = 3'b110;
		else if (oriop) ALUOp = 3'b101;
		else if (sllop) ALUOp = 3'b100;
		else ALUOp = 3'b011;
	end
	else if (state_now == ELS)
		ALUOp = 3'b000;
	else if (state_now == EBR)
		ALUOp = 3'b001;
	else ALUOp = 3'b000;
end