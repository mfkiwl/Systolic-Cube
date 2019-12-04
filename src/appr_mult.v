module appr_mult (
  input  wire        iClk,
  input  wire        iRst,
  input  wire [7:0]  iData1,
  input  wire [7:0]  iData2,
  output reg  [19:0] oResult
);

wire [19:0] result;
wire [8:0]  partial_result   [0:3];
wire [2:0]  appr_mult_result [0:15];

always @(posedge iClk) begin
  if (iRst) begin
    oResult <= 'd0;
  end else begin
    oResult <= result;
  end
end

assign result = partial_result[0] + (partial_result[1] << 2) + (partial_result[2] << 4) + (partial_result[3] << 6);

generate
  genvar i, j;
  for (j = 0; j < 4; j = j + 1) begin
    for (i = 0; i < 4; i = i + 1) begin
      appr_mult_basic_unit appr_mult_basic_unit_i (
        .iData1(iData1[2*(i+1)-1:2*i]),
        .iData2(iData2[2*(j+1)-1:2*j]),
        .oResult(appr_mult_result[4*j+i])
      );
    end
  end

  for (i = 0; i < 4; i = i + 1) begin
  	assign partial_result[i] = appr_mult_result[4*i] + (appr_mult_result[4*i+1] << 2) + (appr_mult_result[4*i+2] << 4) + (appr_mult_result[4*i+3] << 6);
  end
endgenerate

endmodule