module appr_mult_basic_unit (
  input  wire [1:0]  iData1,
  input  wire [1:0]  iData2,
  output wire [2:0]  oResult
);

assign oResult[0] = iData1[0] & iData2[0];
assign oResult[1] = (iData1[1] & iData2[0]) | (iData1[0] & iData2[1]);
assign oResult[2] = iData1[1] & iData2[1];

endmodule