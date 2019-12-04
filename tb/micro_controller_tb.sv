module micro_controller_tb;

`define DUMP_FSDB

`ifdef  DUMP_FSDB
initial begin
  $display("INFO(HW): Start Simulation");
  $fsdbDumpfile("micro_controller_tb.fsdb");
  $fsdbDumpvars(0, "+all", micro_controller_tb);
end
`endif

localparam ARRAY_NUM     = 3;
localparam BLOCK_NUM     = 3;
localparam CUBE_NUM      = 3;
localparam RAM_DEPTH     = 2048;

reg clk;
reg rst;
reg start;

wire                         ready;
wire                         clearacc;
wire [(8*ARRAY_NUM+8)-1:0]   inputpattern;
wire [ARRAY_NUM-2:0]         passdataleft;
wire                         addrvalid;
wire [$clog2(RAM_DEPTH)-1:0] addr;

initial begin
    clk = 0;
    rst = 1;
    start = 0;
    @(posedge clk) #1
    rst = 0;
    start = 1;
    @(posedge clk) #1
    start = 0;
    #1000
    $finish;
end

always #10 clk = ~clk;

micro_controller #(
    .ARRAY_NUM(ARRAY_NUM),
    .BLOCK_NUM(BLOCK_NUM),
    .CUBE_NUM(CUBE_NUM),
    .RAM_DEPTH(RAM_DEPTH)
) uut (
    .iClk(clk),
    .iRst(rst),
    .iStart(start),
    .oReady(ready),
    .oClearAcc(clearacc),
    .oInputPattern(inputpattern),
    .oPassDataLeft(passdataleft),
    .oAddrValid(addrvalid),
    .oAddr(addr)
);

endmodule