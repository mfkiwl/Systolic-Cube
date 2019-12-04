module ram_simulation_model #(
    parameter BITWIDTH = 32,
    parameter DEPTH    = 2048,
    parameter LATENCY  = 1,
    parameter INDEX    = 0
) (
    input  wire                     iClk,
    input  wire                     iWriteEn,
    input  wire [$clog2(DEPTH)-1:0] iAddr,
    input  wire [BITWIDTH-1:0]      iData,
    output wire [BITWIDTH-1:0]      oData
);

reg [BITWIDTH-1:0] mem [0:DEPTH-1];
reg [BITWIDTH-1:0] data_dly [0:LATENCY-1];

assign oData = data_dly[LATENCY-1];

initial begin
    if (INDEX == 0) begin
        $readmemh("/home/jbgao/FPGA-course-lab/systolic_cube/mem/data.txt", mem);
    end
    if (INDEX == 1) begin
        $readmemh("/home/jbgao/FPGA-course-lab/systolic_cube/mem/weight.txt", mem);
    end
end

always @(posedge iClk) begin
    if (iWriteEn) begin
        mem[iAddr] <= iData;
        data_dly[0] <= iData;
    end else begin
        data_dly[0] <= mem[iAddr];
    end
end

endmodule