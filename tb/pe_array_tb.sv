`timescale 1ps/1ps
module pe_array_tb;

`define DUMP_FSDB

`ifdef  DUMP_FSDB
initial begin
  $display("INFO(HW): Start Simulation");
  $fsdbDumpfile("pe_array_tb.fsdb");
  $fsdbDumpvars(0, "+all", pe_array_tb);
end
`endif

localparam ARRAY_NUM = 3;

reg                    clk;
reg                    rst;
reg                    clear_acc;
reg  [ARRAY_NUM-2:0]   pass_data_left;
reg  [8*ARRAY_NUM-1:0] data;
reg  [7:0]             weight;
reg  [4:0]             output_left_shift;
wire [8*ARRAY_NUM-1:0] result;

initial begin
  clk = 'd0;
  rst = 'd1;
  clear_acc = 'd0;
  pass_data_left = 'd0;
  data = 'd0;
  weight = 'd0;
  output_left_shift = 'd0;

  @(posedge clk) #1
  rst = 'd0;
  data = {8'd0, 8'd0, 8'd1};
  weight = 'd1;
  @(posedge clk) #1
  data = {8'd0, 8'd6, 8'd2};
  weight = 'd2;
  @(posedge clk) #1
  data = {8'd11, 8'd7, 8'd3};
  weight = 'd3;
  @(posedge clk) #1
  data = {8'd12, 8'd8, 8'd0};
  weight = 'd4;
  pass_data_left = 'b01;
  @(posedge clk) #1
  data = {8'd13, 8'd0, 8'd0};
  weight = 'd5;
  pass_data_left = 'b11;
  @(posedge clk) #1
  data = {8'd16, 8'd0, 8'd0};
  weight = 'd6;
  pass_data_left = 'b11;
  @(posedge clk) #1
  data = {8'd17, 8'd0, 8'd0};
  weight = 'd7;
  pass_data_left = 'b11;
  @(posedge clk) #1
  data = {8'd18, 8'd0, 8'd0};
  weight = 'd8;
  pass_data_left = 'b11;
  @(posedge clk) #1
  data = {8'd21, 8'd0, 8'd0};
  weight = 'd9;
  pass_data_left = 'b11;
  @(posedge clk) #1
  data = {8'd22, 8'd0, 8'd0};
  pass_data_left = 'b10;
  @(posedge clk) #1
  data = {8'd23, 8'd0, 8'd0};
  pass_data_left = 'b00;
  #1000
  $stop;
end

always #10 clk = ~clk;

pe_array #(
  .ARRAY_NUM(ARRAY_NUM)
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
