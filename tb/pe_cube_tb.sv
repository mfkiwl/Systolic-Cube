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
           PATTERN_3 = 3'd2,
           PATTERN_4 = 3'd3,
           PATTERN_5 = 3'd4,
           NOT_CARE  = 3'd5;

reg                    clk;
reg                    rst;
reg                    clear_acc;
reg  [4:0]             output_left_shift;
wire [8*ARRAY_NUM*BLOCK_NUM*CUBE_NUM-1:0] result;

reg  [ARRAY_NUM-2:0]   pass_data_left;
reg  [8*ARRAY_NUM-1:0] data1;
reg  [8*ARRAY_NUM-1:0] data2;
reg  [3*ARRAY_NUM-1:0] input_pattern;
reg  [8*CUBE_NUM-1:0]  weight;

// 31 clock cycles per 3x3 conv block
reg  [ARRAY_NUM-2:0]   pass_data_left_mem [$:31];
reg  [8*ARRAY_NUM-1:0] data1_mem          [$:31];
reg  [8*ARRAY_NUM-1:0] data2_mem          [$:31];
reg  [3*ARRAY_NUM-1:0] input_pattern_mem  [$:31];
reg  [8*CUBE_NUM-1:0]  weight_mem         [$:31];

integer i;
reg [7:0] count;
initial begin
  // weight
  count = 8'd1;
  for (i = 0; i < 31; i = i + 1) begin
    weight_mem.push_back({count, count, count});
    count = count + 1;
  end

  // data1, data2
  data1_mem.push_back({8'd0, 8'd0, 8'd1});
  data1_mem.push_back({8'd0, 8'd6, 8'd2});
  data1_mem.push_back({8'd11, 8'd7, 8'd3});
  data1_mem.push_back({8'd12, 8'd8, 8'd4});
  data1_mem.push_back({8'd13, 8'd9, 8'd5});
  data1_mem.push_back({8'd14, 8'd10, 8'd0});
  data1_mem.push_back({8'd15, 8'd0, 8'd0});
  data1_mem.push_back({8'd18, 8'd0, 8'd0});
  data1_mem.push_back({8'd19, 8'd0, 8'd0});
  data1_mem.push_back({8'd20, 8'd0, 8'd26});
  data1_mem.push_back({8'd23, 8'd31, 8'd27});
  data1_mem.push_back({8'd24, 8'd32, 8'd28});
  data1_mem.push_back({8'd25, 8'd33, 8'd29});
  data1_mem.push_back({8'd38, 8'd34, 8'd30});
  data1_mem.push_back({8'd39, 8'd35, 8'd0});
  data1_mem.push_back({8'd40, 8'd0, 8'd0});
  data1_mem.push_back({8'd43, 8'd0, 8'd0});
  data1_mem.push_back({8'd44, 8'd0, 8'd0});
  data1_mem.push_back({8'd45, 8'd0, 8'd51});
  data1_mem.push_back({8'd48, 8'd56, 8'd52});
  data1_mem.push_back({8'd49, 8'd57, 8'd53});
  data1_mem.push_back({8'd50, 8'd58, 8'd54});
  data1_mem.push_back({8'd63, 8'd59, 8'd55});
  data1_mem.push_back({8'd64, 8'd60, 8'd0});
  data1_mem.push_back({8'd65, 8'd0, 8'd0});
  data1_mem.push_back({8'd68, 8'd0, 8'd0});
  data1_mem.push_back({8'd69, 8'd0, 8'd0});
  data1_mem.push_back({8'd70, 8'd0, 8'd0});
  data1_mem.push_back({8'd73, 8'd0, 8'd0});
  data1_mem.push_back({8'd74, 8'd0, 8'd0});
  data1_mem.push_back({8'd75, 8'd0, 8'd0});

  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd16, 8'd0, 8'd0});
  data2_mem.push_back({8'd17, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd21, 8'd0, 8'd0});
  data2_mem.push_back({8'd22, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd36, 8'd0, 8'd0});
  data2_mem.push_back({8'd37, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd41, 8'd0, 8'd0});
  data2_mem.push_back({8'd42, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd46, 8'd0, 8'd0});
  data2_mem.push_back({8'd47, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd61, 8'd0, 8'd0});
  data2_mem.push_back({8'd62, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd66, 8'd0, 8'd0});
  data2_mem.push_back({8'd67, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd71, 8'd0, 8'd0});
  data2_mem.push_back({8'd72, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});
  data2_mem.push_back({8'd0, 8'd0, 8'd0});

  // input_pattern
  input_pattern_mem.push_back({NOT_CARE, NOT_CARE, PATTERN_1});
  input_pattern_mem.push_back({NOT_CARE, PATTERN_1, PATTERN_2});
  input_pattern_mem.push_back({PATTERN_1, PATTERN_2, PATTERN_3});
  input_pattern_mem.push_back({PATTERN_2, PATTERN_3, PATTERN_4});
  input_pattern_mem.push_back({PATTERN_3, PATTERN_4, PATTERN_5});
  input_pattern_mem.push_back({PATTERN_4, PATTERN_5, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_5, NOT_CARE, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_3, NOT_CARE, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_4, NOT_CARE, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_5, NOT_CARE, PATTERN_1});
  input_pattern_mem.push_back({PATTERN_3, PATTERN_1, PATTERN_2});
  input_pattern_mem.push_back({PATTERN_4, PATTERN_2, PATTERN_3});
  input_pattern_mem.push_back({PATTERN_5, PATTERN_3, PATTERN_4});
  input_pattern_mem.push_back({PATTERN_3, PATTERN_4, PATTERN_5});
  input_pattern_mem.push_back({PATTERN_4, PATTERN_5, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_5, NOT_CARE, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_3, NOT_CARE, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_4, NOT_CARE, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_5, NOT_CARE, PATTERN_1});
  input_pattern_mem.push_back({PATTERN_3, PATTERN_1, PATTERN_2});
  input_pattern_mem.push_back({PATTERN_4, PATTERN_2, PATTERN_3});
  input_pattern_mem.push_back({PATTERN_5, PATTERN_3, PATTERN_4});
  input_pattern_mem.push_back({PATTERN_3, PATTERN_4, PATTERN_5});
  input_pattern_mem.push_back({PATTERN_4, PATTERN_5, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_5, NOT_CARE, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_3, NOT_CARE, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_4, NOT_CARE, NOT_CARE});
  input_pattern_mem.push_back({PATTERN_5, NOT_CARE, PATTERN_1});
  input_pattern_mem.push_back({PATTERN_3, PATTERN_1, PATTERN_2});
  input_pattern_mem.push_back({PATTERN_4, PATTERN_2, PATTERN_3});
  input_pattern_mem.push_back({PATTERN_5, PATTERN_3, PATTERN_4});

  // pass_data_left
  pass_data_left_mem.push_back(2'd0);
  pass_data_left_mem.push_back(2'd0);
  pass_data_left_mem.push_back(2'd0);
  pass_data_left_mem.push_back(2'd1);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd2);
  pass_data_left_mem.push_back(2'd0);
  pass_data_left_mem.push_back(2'd0);
  pass_data_left_mem.push_back(2'd1);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd2);
  pass_data_left_mem.push_back(2'd0);
  pass_data_left_mem.push_back(2'd0);
  pass_data_left_mem.push_back(2'd1);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd3);
  pass_data_left_mem.push_back(2'd2);
  pass_data_left_mem.push_back(2'd0);
  pass_data_left_mem.push_back(2'd0);
  pass_data_left_mem.push_back(2'd1);
end

event start_config;
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
  -> start_config;
end

always #10 clk = ~clk;

always @(start_config) begin
  while (data1_mem.size()          != 0 &&
         data2_mem.size()          != 0 &&
         weight_mem.size()         != 0 &&
         pass_data_left_mem.size() != 0 &&
         input_pattern_mem.size()  != 0) begin
    data1 = data1_mem.pop_front();
    data2 = data2_mem.pop_front();
    weight = weight_mem.pop_front();
    pass_data_left = pass_data_left_mem.pop_front();
    input_pattern = input_pattern_mem.pop_front();
    @(posedge clk) #1 ;
  end
  #1000
  $finish;
end

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
