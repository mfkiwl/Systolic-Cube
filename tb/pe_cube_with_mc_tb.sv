`timescale 1ns/1ps
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

wire [$clog2(RAM_DEPTH)-1:0] addr_to_ram;
wire [31:0] data_from_data_ram;
wire [31:0] weight_from_weight_ram;
wire        result_ram_wr_en;
wire [$clog2(RAM_DEPTH)-1:0] addr_to_ram_wr;
wire [31:0] data_to_result_ram;

initial begin
    clk = 0;
    rst = 1;
    start = 0;
    @(posedge clk) #1
    rst = 0;
    start = 1;
    @(posedge clk) #1
    start = 0;
    @(posedge ready) #1
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

ram_simulation_model #(
    .INDEX(2)
) result_ram (
    .iClk(clk),
    .iWriteEn(result_ram_wr_en),
    .iAddr(addr_to_ram_wr),
    .iData(data_to_result_ram),
    .oData()
);

systolic_cube_with_mc #(
    .ARRAY_NUM(ARRAY_NUM),
    .BLOCK_NUM(BLOCK_NUM),
    .CUBE_NUM(CUBE_NUM),
    .RAM_DEPTH(RAM_DEPTH)
) uut (
    .iClk(clk),
    .iRst(rst),
    .iStart(start),
    .oReady(ready),
    .oAddrForDataWeightRam(addr_to_ram),
    .iDataFromDataRam(data_from_data_ram),
    .iWeightFromWeightRam(weight_from_weight_ram),
    .oWrEnForResultRam(result_ram_wr_en),
    .oAddrForResultRam(addr_to_ram_wr),
    .oDataToResultRam(data_to_result_ram)
);
endmodule
