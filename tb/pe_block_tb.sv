`timescale 1ps/1ps
module pe_block_tb;

`define DUMP_FSDB

`ifdef  DUMP_FSDB
initial begin
  $display("INFO(HW): Start Simulation");
  $fsdbDumpfile("pe_block_tb.fsdb");
  $fsdbDumpvars(0, "+all", pe_block_tb);
end
`endif

localparam ARRAY_NUM = 3,
           BLOCK_NUM = 3;

reg                    clk;
reg                    rst;
reg                    clear_acc;
reg  [ARRAY_NUM-2:0]   pass_data_left;

wire [8*ARRAY_NUM*BLOCK_NUM-1:0] data;
reg  [8*ARRAY_NUM-1:0] data1;
reg  [8*ARRAY_NUM-1:0] data2;
reg  [8*ARRAY_NUM-1:0] data3;
assign data = {data3, data2, data1};

reg  [7:0]             weight;
reg  [4:0]             output_left_shift;
wire [8*ARRAY_NUM*BLOCK_NUM-1:0] result;

initial begin
  clk = 'd0;
  rst = 'd1;
  clear_acc = 'd0;
  pass_data_left = 'd0;
  data1 = 'd0;
  data2 = 'd0;
  data3 = 'd0;
  weight = 'd0;
  output_left_shift = 'd0;

  @(posedge clk) #1
  rst = 'd0;
  data1 = {8'd0, 8'd0, 8'd1};
  data2 = {8'd0, 8'd0, 8'd0};
  data3 = {8'd0, 8'd0, 8'd0};
  weight = 'd1;
  @(posedge clk) #1
  data1 = {8'd0, 8'd6, 8'd2};
  data2 = {8'd0, 8'd0, 8'd2};
  data3 = {8'd0, 8'd0, 8'd0};
  weight = 'd2;
  @(posedge clk) #1
  data1 = {8'd11, 8'd7, 8'd3};
  data2 = {8'd0, 8'd7, 8'd3};
  data3 = {8'd0, 8'd0, 8'd3};
  weight = 'd3;
  @(posedge clk) #1
  data1 = {8'd12, 8'd8, 8'd0};
  data2 = {8'd12, 8'd8, 8'd4};
  data3 = {8'd0, 8'd8, 8'd4};
  weight = 'd4;
  pass_data_left = 'b01;
  @(posedge clk) #1
  data1 = {8'd13, 8'd0, 8'd0};
  data2 = {8'd13, 8'd9, 8'd0};
  data3 = {8'd13, 8'd9, 8'd5};
  weight = 'd5;
  pass_data_left = 'b11;
  @(posedge clk) #1
  data1 = {8'd16, 8'd0, 8'd0};
  data2 = {8'd14, 8'd0, 8'd0};
  data3 = {8'd14, 8'd10, 8'd0};
  weight = 'd6;
  pass_data_left = 'b11;
  @(posedge clk) #1
  data1 = {8'd17, 8'd0, 8'd0};
  data2 = {8'd17, 8'd0, 8'd0};
  data3 = {8'd15, 8'd0, 8'd0};
  weight = 'd7;
  pass_data_left = 'b11;
  @(posedge clk) #1
  data1 = {8'd18, 8'd0, 8'd0};
  data2 = {8'd18, 8'd0, 8'd0};
  data3 = {8'd18, 8'd0, 8'd0};
  weight = 'd8;
  pass_data_left = 'b11;
  @(posedge clk) #1
  data1 = {8'd21, 8'd0, 8'd0};
  data2 = {8'd19, 8'd0, 8'd0};
  data3 = {8'd19, 8'd0, 8'd0};
  weight = 'd9;
  pass_data_left = 'b11;
  @(posedge clk) #1
  data1 = {8'd22, 8'd0, 8'd0};
  data2 = {8'd22, 8'd0, 8'd0};
  data3 = {8'd10, 8'd0, 8'd0};
  pass_data_left = 'b10;
  @(posedge clk) #1
  data1 = {8'd23, 8'd0, 8'd0};
  data2 = {8'd23, 8'd0, 8'd0};
  data3 = {8'd23, 8'd0, 8'd0};
  pass_data_left = 'b00;
  @(posedge clk) #1
  data1 = {8'd0, 8'd0, 8'd0};
  data2 = {8'd24, 8'd0, 8'd0};
  data3 = {8'd24, 8'd0, 8'd0};
  pass_data_left = 'b00;
  @(posedge clk) #1
  data1 = {8'd0, 8'd0, 8'd0};
  data2 = {8'd0, 8'd0, 8'd0};
  data3 = {8'd25, 8'd0, 8'd0};
  pass_data_left = 'b00;
  #1000
  $stop;
end

always #10 clk = ~clk;

pe_block #(
  .ARRAY_NUM(ARRAY_NUM)，
  .BLOCK_NUM(BLOCK_NUM)
) uut (
  .iClk(clk),
  .iRst(rst),
  .iClearAcc(clear_acc),
  .iCfsPassDataLeft(pass_data_left),
  .iData(data),
  .iWeight(weight),
  .iCfsOutputLeftShift(output_left_shift),
  .oResult(result)
);

endmodule
