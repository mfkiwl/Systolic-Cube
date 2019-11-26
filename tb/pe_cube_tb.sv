`timescale 1ps/1ps
module pe_cube_tb;

`define DUMP_FSDB

`ifdef  DUMP_FSDB
initial begin
  $display("INFO(HW): Start Simulation");
  $fsdbDumpfile("pe_cube_tb.fsdb");
  $fsdbDumpvars(0, "+all", pe_cube_tb);
end
`endif

localparam ARRAY_NUM = 3,
           BLOCK_NUM = 3,
           CUBE_NUM  = 3; // dont change CUBE_NUM

localparam PATTERN_1 = 3'd0,
           PATTERN_2 = 3'd1,
           PATTERN_3 = 3'd3,
           PATTERN_4 = 3'd2,
           PATTERN_5 = 3'd6;

reg                    clk;
reg                    rst;
reg                    clear_acc;
reg  [ARRAY_NUM-2:0]   pass_data_left;

reg  [8*ARRAY_NUM-1:0] data1;
reg  [8*ARRAY_NUM-1:0] data2;
reg  [3*ARRAY_NUM-1:0] input_pattern;

reg  [8*CUBE_NUM-1:0]  weight;
reg  [4:0]             output_left_shift;
wire [8*ARRAY_NUM*BLOCK_NUM*CUBE_NUM-1:0] result;

initial begin
  clk = 'd0;
  rst = 'd1;
  clear_acc = 'd0;
  pass_data_left = 'd0;
  data1 = 'd0;
  data2 = 'd0;
  weight = 'd0;
  output_left_shift = 'd0;

  @(posedge clk) #1
  rst = 'd0;
  data1 = {8'd0, 8'd0, 8'd1};
  data2 = {8'd0, 8'd0, 8'd0};
  input_pattern = {PATTERN_3, PATTERN_3, PATTERN_1};
  weight = {8'd1, 8'd1, 8'd1};
  @(posedge clk) #1
  data1 = {8'd0, 8'd6, 8'd2};
  data2 = {8'd0, 8'd0, 8'd0};
  input_pattern = {PATTERN_3, PATTERN_1, PATTERN_2};
  weight = {8'd2, 8'd2, 8'd2};
  @(posedge clk) #1
  data1 = {8'd11, 8'd7, 8'd3};
  data2 = {8'd0, 8'd0, 8'd0};
  input_pattern = {PATTERN_1, PATTERN_2, PATTERN_3};
  weight = {8'd3, 8'd3, 8'd3};
  @(posedge clk) #1
  data1 = {8'd12, 8'd8, 8'd4};
  data2 = {8'd0, 8'd0, 8'd0};
  input_pattern = {PATTERN_2, PATTERN_3, PATTERN_4};
  weight = {8'd4, 8'd4, 8'd4};
  pass_data_left = 'b01;
  @(posedge clk) #1
  data1 = {8'd13, 8'd9, 8'd5};
  data2 = {8'd0, 8'd0, 8'd0};
  input_pattern = {PATTERN_3, PATTERN_4, PATTERN_5};
  weight = {8'd5, 8'd5, 8'd5};
  pass_data_left = 'b11;
  @(posedge clk) #1
  data1 = {8'd14, 8'd10, 8'd0};
  data2 = {8'd16, 8'd0, 8'd0};
  input_pattern = {PATTERN_4, PATTERN_5, PATTERN_3};
  weight = {8'd6, 8'd6, 8'd6};
  pass_data_left = 'b11;
  @(posedge clk) #1
  data1 = {8'd15, 8'd0, 8'd0};
  data2 = {8'd17, 8'd0, 8'd0};
  input_pattern = {PATTERN_5, PATTERN_3, PATTERN_3};
  weight = {8'd7, 8'd7, 8'd7};
  pass_data_left = 'b11;
  @(posedge clk) #1
  data1 = {8'd18, 8'd0, 8'd0};
  data2 = {8'd0, 8'd0, 8'd0};
  input_pattern = {PATTERN_3, PATTERN_3, PATTERN_3};
  weight = {8'd8, 8'd8, 8'd8};
  pass_data_left = 'b11;
  @(posedge clk) #1
  data1 = {8'd19, 8'd0, 8'd0};
  data2 = {8'd21, 8'd0, 8'd0};
  input_pattern = {PATTERN_4, PATTERN_3, PATTERN_3};
  weight = {8'd9, 8'd9, 8'd9};
  pass_data_left = 'b11;
  @(posedge clk) #1
  data1 = {8'd20, 8'd0, 8'd0};
  data2 = {8'd22, 8'd0, 8'd0};
  input_pattern = {PATTERN_5, PATTERN_3, PATTERN_3};
  pass_data_left = 'b10;
  @(posedge clk) #1
  data1 = {8'd23, 8'd0, 8'd0};
  data2 = {8'd0, 8'd0, 8'd0};
  input_pattern = {PATTERN_3, PATTERN_3, PATTERN_3};
  pass_data_left = 'b00;
  @(posedge clk) #1
  data1 = {8'd24, 8'd0, 8'd0};
  data2 = {8'd0, 8'd0, 8'd0};
  input_pattern = {PATTERN_4, PATTERN_3, PATTERN_3};
  pass_data_left = 'b00;
  @(posedge clk) #1
  data1 = {8'd25, 8'd0, 8'd0};
  data2 = {8'd0, 8'd0, 8'd0};
  input_pattern = {PATTERN_5, PATTERN_3, PATTERN_3};
  pass_data_left = 'b00;
  #1000
  $stop;
end

always #10 clk = ~clk;

pe_cube #(
  .ARRAY_NUM(ARRAY_NUM),
  .BLOCK_NUM(BLOCK_NUM),
  .CUBE_NUM(CUBE_NUM)
) uut (
  .iClk(clk),
  .iRst(rst),
  .iClearAcc(clear_acc),
  .iWeight(weight),
  .iData1(data1),
  .iData2(data2),
  .iCfsInputPattern(input_pattern),
  .iCfsPassDataLeft(pass_data_left),
  .iCfsOutputLeftShift(output_left_shift),
  .oResult(result)
);

endmodule
