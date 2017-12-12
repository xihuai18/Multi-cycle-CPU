`timescale 1ns / 1ps


module top(
    input wire CLK_BUTN,
    input wire mclk,
    input wire Reset,
    input wire [1:0] SW_in,
    output wire [7:0] code,
    output wire [3:0] place
    );
//signals
wire PCWre;
wire ALUSrcA;
wire ALUSrcB;
wire DBDataSrc;
wire RegWre;
wire WrRegDSrc;
wire InsMemRW;
wire RD;
wire WR;
wire IRWre;
wire ExtSel;
wire [1:0] RegDst;
wire [1:0] PCSrc;
wire [2:0] ALUOp;


wire [31:0] IAddrIn; //From PCSel
wire [31:0] IAddrOut;
wire [31:0] IDataIn;
wire [31:0] IDataOut_IM;
wire [31:0] IDataOut;
    
PC pc_inst(
    .CLK(CLK),
    .Reset(Reset),
    .PCWre(PCWre),
    .IAddrIn(IAddrIn),
    .IAddrOut(IAddrOut)
);

wire [31:0] PCAddedFour;
assign PCAddedFour = IAddrOut + 4;

Instruction_Memory Ins_Mem_inst(
	.IAddr(IAddrOut),
	.IDataIn(IDataIn),
	.InsMemRW(InsMemRW),
	.IDataOut(IDataOut_IM)
	);

IR ir_inst(
    .in(IDataOut_IM),
    .CLK(CLK),
    .IRWre(IRWre),
    .out(IDataOut)
);

//Decode
wire [5:0] op;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] sa;
wire [31:0] Ext_sa;
wire [15:0] immediate;
wire [31:0] Ext_immediate;
wire [25:0] address;

assign op = IDataOut[31:26]; 
assign rs = IDataOut[25:21]; 
assign rt = IDataOut[20:16]; 
assign rd = IDataOut[15:11];
assign sa = IDataOut[10:6]; 
assign Ext_sa = {27'b0000_0000_0000_0000_0000_0000_000,sa}; 
assign immediate = IDataOut[15:0]; 
assign address = IDataOut[25:0];

Extend ext_imm(
	.ExtSel(ExtSel),
	.OriData(immediate),
	.ExtData(Ext_immediate)
	);

wire [4:0] Write_reg;

parameter [4:0] thirty_one = 5'b11111;


Selector_Dst select_write_reg(
    .In0(thirty_one),
    .In1(rt),
    .In2(rd),
    .Selector(RegDst),
    .Out(Write_reg)
);

wire [31:0] Read_data1;
wire [31:0] Read_data2;
wire [31:0] Read_data1_Reg;
wire [31:0] Read_data2_Reg;
wire [31:0] DBData; //from the two_way_sel behind RAM 
wire [31:0] DBData_ram;
wire [31:0] Write_Data;

assign Write_Data = (WrRegDSrc == 0? PCAddedFour:DBData);

RegisterFile regFile(
    .Reset(Reset),
	.Read_reg1(rs),
	.Read_reg2(rt),
	.WE(RegWre),
	.CLK(CLK),
	.Write_reg(Write_reg),
	.Write_data(Write_Data),
	.Read_data1(Read_data1_Reg),
	.Read_data2(Read_data2_Reg)
	);

D_latch ADR(
    .CLK(CLK),
    .in(Read_data1_Reg),
    .out(Read_data1)
);

D_latch BDR(
    .CLK(CLK),
    .in(Read_data2_Reg),
    .out(Read_data2)
);

wire [31:0] result_alu; //from ALU32
wire [31:0] result;
wire [31:0] DataOutFromRAM;

D_latch ALUoutDR(
    .CLK(CLK),
    .in(result_alu),
    .out(result)
);

RAM ram_inst(
	.Daddr(result),
	.DataIn(Read_data2),
	.RD(RD),
	.WR(WR),
	.DataOut(DataOutFromRAM)
	);

assign DBData_ram = (0 == DBDataSrc)? result_alu:DataOutFromRAM;

D_latch DBDR(
    .CLK(CLK),
    .in(DBData_ram),
    .out(DBData)
);

wire [31:0] InALU_A;
wire [31:0] InALU_B;

assign InALU_A = (0 == ALUSrcA)? Read_data1:Ext_sa;
assign InALU_B = (0 == ALUSrcB)? Read_data2:Ext_immediate;

wire zero;
wire sign;

ALU32 alu32(
	.ALUopcode(ALUOp),
	.rega(InALU_A),
	.regb(InALU_B),
	.zero(zero),
	.sign(sign),
	.result(result_alu)
	);

ControlUnit control_unit(
    .CLK(CLK),
    .Reset(Reset),
	.opcode(op),
	.zero(zero),
	.sign(sign),
	.PCWre(PCWre),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.DBDataSrc(DBDataSrc),
	.RegWre(RegWre),
	.WrRegDSrc(WrRegDSrc),
	.InsMemRW(InsMemRW),
	.RD(RD),
	.WR(WR),
	.IRWre(IRWre),
	.ExtSel(ExtSel),
	.RegDst(RegDst),
	.PCSrc(PCSrc),
	.ALUOp(ALUOp)
	);

//PCSel
wire [31:0] PCFromJIns;
wire [31:0] PCFromBranch;
//PCFromJrIns is Read_data1

assign PCFromBranch = (Ext_immediate << 2) + PCAddedFour;
assign PCFromJIns = {PCAddedFour[31:28], address, 1'b0, 1'b0};

Four_Way_Selector PCSel(
	.In0(PCAddedFour),
	.In1(PCFromBranch),
	.In2(Read_data1),
	.In3(PCFromJIns),
	.Selector(PCSrc),
	.Out(IAddrIn)
	);
	
wire clk1000, clk190;
        
clkdiv clk(
    .reset(Reset),
    .mclk(mclk),
    .clk190(clk190),
    .clk1000(clk1000)
);	

wire [7:0]out1;
wire [7:0]out2;

display dis(
    .SW_in(SW_in),
    .PC(IAddrOut[7:0]),
    .PCNext(IAddrIn[7:0]),
    .RSAddr({3'b000,rs}),
    .RSData(Read_data1[7:0]),
    .RTAddr({3'b000,rt}),
    .RTData(Read_data2[7:0]),
    .ALUResult(result[7:0]),
    .DB(DBData[7:0]),
    .out1(out1),
    .out2(out2)
);

Show show(
    .Reset(Reset),
    .CLK(clk190),
    .in1(out1),
    .in2(out2),
    .place(place),
    .code(code)
);

avoidShake avshake(
	.clk1000(clk1000),
	.key_in(CLK_BUTN),
	.key_out(CLK)
	);

endmodule
