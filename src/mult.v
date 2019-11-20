module mult (
  input  wire        iClk,
  input  wire        iRst,
  input  wire [7:0]  iData1,
  input  wire [7:0]  iData2,
  output reg  [19:0] oResult
);

always @(posedge iClk) begin
  if (iRst) begin
    oResult <= 'd0;
  end else begin
    oResult <= iData1 * iData2;
  end
end

endmodule