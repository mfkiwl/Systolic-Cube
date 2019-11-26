module pe_cube #(
  parameter CUBE_NUM  = 3,
  parameter BLOCK_NUM = 3,
  parameter ARRAY_NUM = 3
)(
  input  wire                    iClk,
  input  wire                    iRst,
  input  wire                    iClearAcc,
  input  wire [8*CUBE_NUM-1:0]   iWeight,

  // need to extend iDatax if CUBE_NUM is not 3!
  input  wire [8*ARRAY_NUM-1:0]  iData1,
  input  wire [8*ARRAY_NUM-1:0]  iData2,
  input  wire [3*ARRAY_NUM-1:0]  iCfsInputPattern,

  input  wire [ARRAY_NUM-2:0]    iCfsPassDataLeft,
  input  wire [4:0]              iCfsOutputLeftShift,
  output wire [8*ARRAY_NUM*BLOCK_NUM*CUBE_NUM-1:0] oResult
);

// iCfsInputPattern states
// need to extend if CUBE_NUM is not 3!
localparam PATTERN_1 = 3'd0,
           PATTERN_2 = 3'd1,
           PATTERN_3 = 3'd3,
           PATTERN_4 = 3'd2,
           PATTERN_5 = 3'd6;

wire [8*BLOCK_NUM-1:0]           data_after_mux [0:ARRAY_NUM-1];
wire [8*ARRAY_NUM*BLOCK_NUM-1:0] data_to_pe_block;

generate
  genvar i, j;

  for (i = 0; i < ARRAY_NUM; i = i + 1) begin
    for (j = 0; j < BLOCK_NUM; j = j + 1) begin
      assign data_to_pe_block[8*ARRAY_NUM*j+8*(i+1)-1:8*ARRAY_NUM*j+8*i] = data_after_mux[i][8*(j+1)-1:8*j];
    end
  end

  // need to extend if CUBE_NUM is not 3!
  for (i = 0; i < ARRAY_NUM; i = i + 1) begin
    assign data_after_mux[i] = iCfsInputPattern[3*(i+1)-1:3*i] == PATTERN_1 ? {iData2[8*(i+1)-1:8*i], iData2[8*(i+1)-1:8*i], iData1[8*(i+1)-1:8*i]} : 
                               iCfsInputPattern[3*(i+1)-1:3*i] == PATTERN_2 ? {iData2[8*(i+1)-1:8*i], iData1[8*(i+1)-1:8*i], iData1[8*(i+1)-1:8*i]} : 
                               iCfsInputPattern[3*(i+1)-1:3*i] == PATTERN_3 ? {iData1[8*(i+1)-1:8*i], iData1[8*(i+1)-1:8*i], iData1[8*(i+1)-1:8*i]} : 
                               iCfsInputPattern[3*(i+1)-1:3*i] == PATTERN_4 ? {iData1[8*(i+1)-1:8*i], iData1[8*(i+1)-1:8*i], iData2[8*(i+1)-1:8*i]} : 
                               iCfsInputPattern[3*(i+1)-1:3*i] == PATTERN_5 ? {iData1[8*(i+1)-1:8*i], iData2[8*(i+1)-1:8*i], iData2[8*(i+1)-1:8*i]} : 'd0;
  end

  for (i = 0; i < CUBE_NUM; i = i + 1) begin
    pe_block #(
      .ARRAY_NUM(ARRAY_NUM),
      .BLOCK_NUM(BLOCK_NUM)
    ) pe_block_i (
      .iClk(iClk),
      .iRst(iRst),
      .iClearAcc(iClearAcc),
      .iData(data_to_pe_block),
      .iWeight(iWeight[8*CUBE_NUM*(i+1)-1:8*CUBE_NUM*i]),
      .iCfsPassDataLeft(iCfsPassDataLeft),
      .iCfsOutputLeftShift(iCfsOutputLeftShift),
      .oResult(oResult)
    );
  end
endgenerate

endmodule