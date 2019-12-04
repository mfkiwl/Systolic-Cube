`timescale 1ps/1ps
module pe_cube_with_mc_tb;

`define DUMP_FSDB

`ifdef  DUMP_FSDB
initial begin
  $display("INFO(HW): Start Simulation");
  $fsdbDumpfile("pe_cube_with_mc_tb.fsdb");
  $fsdbDumpvars(0, "+all", pe_cube_with_mc_tb);
end
`endif

localparam ARRAY_NUM = 3,
           BLOCK_NUM = 3,
           CUBE_NUM  = 3, // dont change CUBE_NUM
           RAM_DEPTH = 2048;

reg                    clk;
reg                    rst;
reg                    start;
wire                   ready;
wire                   clear_acc;
wire [ARRAY_NUM-2:0]   pass_data_left;
wire [3*ARRAY_NUM-1:0] input_pattern;
wire [8*CUBE_NUM-1:0]  weight;
wire [8*ARRAY_NUM*BLOCK_NUM*CUBE_NUM-1:0] result;
wire [ARRAY_NUM*BLOCK_NUM*CUBE_NUM-1:0] result_valid;

wire [$clog2(RAM_DEPTH)-1:0] addr_to_ram;
wire        data_from_ram_valid;
wire [31:0] data_from_data_ram;
wire [31:0] weight_from_weight_ram;

initial begin
    clk = 0;
    rst = 1;
    @(posedge clk) #1
    rst = 0;
    start = 1;
    @(posedge clk) #1
    start = 0;
    #1000
    $finish;
end

always #10 clk = ~clk;

ram_simulation_model #(
    .INDEX(0)
) data_ram (
    .iClk(clk),
    .iWriteEn(1'd0),
    .iAddr(addr_to_ram),
    .iData('d0),
    .oData(data_from_data_ram)
);

ram_simulation_model #(
    .INDEX(1)
) weight_ram (
    .iClk(clk),
    .iWriteEn(1'd0),
    .iAddr(addr_to_ram),
    .iData('d0),
    .oData(weight_from_weight_ram)
);

micro_controller #(
    .ARRAY_NUM(ARRAY_NUM),
    .BLOCK_NUM(BLOCK_NUM),
    .CUBE_NUM(CUBE_NUM),
    .RAM_DEPTH(RAM_DEPTH)
) micro_controller_i (
    .iClk(clk),
    .iRst(rst),
    .iStart(start),
    .oReady(ready),
    .oClearAcc(clear_acc),
    .oInputPattern(input_pattern),
    .oPassDataLeft(pass_data_left),
    .oDataValid(data_from_ram_valid),
    .oAddr(addr_to_ram)
);

pe_cube #(
  .ARRAY_NUM(ARRAY_NUM),
  .BLOCK_NUM(BLOCK_NUM),
  .CUBE_NUM(CUBE_NUM)
) pe_cube_i (
  .iClk(clk),
  .iRst(rst),
  .iClearAcc(clear_acc),
  .iWeight(data_from_ram_valid ? weight_from_weight_ram[23:0] : 24'd0),
  .iData1(data_from_ram_valid ? data_from_data_ram[23:0] : 24'd0),
  .iData2(data_from_ram_valid ? data_from_data_ram[31:24] : 8'd0),
  .iCfsInputPattern(input_pattern),
  .iCfsPassDataLeft(pass_data_left),
  .iCfsOutputLeftShift(data_from_ram_valid ? weight_from_weight_ram[28:24] : 5'd0),
  .oResult(result),
  .oResultValid(result_valid)
);

endmodule
