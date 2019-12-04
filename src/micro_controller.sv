module micro_controller #(
    parameter ARRAY_NUM     = 3,
    parameter BLOCK_NUM     = 3,
    parameter CUBE_NUM      = 3,
    parameter RAM_DEPTH     = 2048
) (
    input  wire                     iClk,
    input  wire                     iRst,
    input  wire                     iStart,
    output wire                     oReady,
    // config PE cube
    output reg                      oClearAcc,
    output reg  [3*ARRAY_NUM-1:0]   oInputPattern,
    output reg  [ARRAY_NUM-2:0]     oPassDataLeft,
    output reg                      oDataValid,
    output wire [$clog2(RAM_DEPTH)-1:0] oAddr
);

localparam IDLE   = 'd0,
           CONFIG = 'd1;

localparam PATTERN_1 = 3'd0,
           PATTERN_2 = 3'd1,
           PATTERN_3 = 3'd2,
           PATTERN_4 = 3'd3,
           PATTERN_5 = 3'd4,
           NOT_CARE  = 3'd5;

localparam CLEAR_ACC_LATENCY = 27,
           CLEAR_CNT_LATENCY = 30;

reg       state;
reg       nxt_state;
reg [4:0] counter;
wire      one_block_finish;
wire      addr_valid;

assign one_block_finish = (counter == CLEAR_CNT_LATENCY);
assign oAddr = counter;
assign oReady = (state == IDLE);
assign addr_valid = (state == CONFIG);

always @(posedge iClk) begin
    if (iRst) begin
        oDataValid <= 'd0;
    end else begin
        oDataValid <= addr_valid;
    end
end

always @(*) begin
    case (state)
        IDLE :
            nxt_state = iStart;
        CONFIG :
            nxt_state = ~one_block_finish;
    endcase
end

always @(posedge iClk) begin
    if (iRst) begin
        state <= IDLE;
    end else begin
        state <= nxt_state;
    end
end

always @(posedge iClk) begin
    if (iRst) begin
        counter <= 'd0;
    end else begin
        if (state == CONFIG) begin
            if (one_block_finish) begin
                counter <= 'd0;
            end else begin
                counter <= counter + 'd1;
            end
        end
    end
end

always @(posedge iClk) begin
    if (iRst) begin
        oClearAcc <= 'd0;
    end else begin
        oClearAcc <= (counter == CLEAR_ACC_LATENCY);
    end
end

always @(posedge iClk) begin 
    if (iRst) begin
        oInputPattern <= 'd0;
    end else begin
        case (counter)
            'd0 : oInputPattern <= {NOT_CARE, NOT_CARE, PATTERN_1};
            'd1 : oInputPattern <= {NOT_CARE, PATTERN_1, PATTERN_2};
            'd2 : oInputPattern <= {PATTERN_1, PATTERN_2, PATTERN_3};
            'd3 : oInputPattern <= {PATTERN_2, PATTERN_3, PATTERN_4};
            'd4 : oInputPattern <= {PATTERN_3, PATTERN_4, PATTERN_5};
            'd5 : oInputPattern <= {PATTERN_4, PATTERN_5, NOT_CARE};
            'd6 : oInputPattern <= {PATTERN_5, NOT_CARE, NOT_CARE};
            'd7 : oInputPattern <= {PATTERN_3, NOT_CARE, NOT_CARE};
            'd8 : oInputPattern <= {PATTERN_4, NOT_CARE, NOT_CARE};
            'd9 : oInputPattern <= {PATTERN_5, NOT_CARE, PATTERN_1};
            'd10 : oInputPattern <= {PATTERN_3, PATTERN_1, PATTERN_2};
            'd11 : oInputPattern <= {PATTERN_4, PATTERN_2, PATTERN_3};
            'd12 : oInputPattern <= {PATTERN_5, PATTERN_3, PATTERN_4};
            'd13 : oInputPattern <= {PATTERN_3, PATTERN_4, PATTERN_5};
            'd14 : oInputPattern <= {PATTERN_4, PATTERN_5, NOT_CARE};
            'd15 : oInputPattern <= {PATTERN_5, NOT_CARE, NOT_CARE};
            'd16 : oInputPattern <= {PATTERN_3, NOT_CARE, NOT_CARE};
            'd17 : oInputPattern <= {PATTERN_4, NOT_CARE, NOT_CARE};
            'd18 : oInputPattern <= {PATTERN_5, NOT_CARE, PATTERN_1};
            'd19 : oInputPattern <= {PATTERN_3, PATTERN_1, PATTERN_2};
            'd20 : oInputPattern <= {PATTERN_4, PATTERN_2, PATTERN_3};
            'd21 : oInputPattern <= {PATTERN_5, PATTERN_3, PATTERN_4};
            'd22 : oInputPattern <= {PATTERN_3, PATTERN_4, PATTERN_5};
            'd23 : oInputPattern <= {PATTERN_4, PATTERN_5, NOT_CARE};
            'd24 : oInputPattern <= {PATTERN_5, NOT_CARE, NOT_CARE};
            'd25 : oInputPattern <= {PATTERN_3, NOT_CARE, NOT_CARE};
            'd26 : oInputPattern <= {PATTERN_4, NOT_CARE, NOT_CARE};
            'd27 : oInputPattern <= {PATTERN_5, NOT_CARE, PATTERN_1};
            'd28 : oInputPattern <= {PATTERN_3, PATTERN_1, PATTERN_2};
            'd29 : oInputPattern <= {PATTERN_4, PATTERN_2, PATTERN_3};
            'd30 : oInputPattern <= {PATTERN_5, PATTERN_3, PATTERN_4};
            default : oInputPattern <= {NOT_CARE, NOT_CARE, NOT_CARE};
        endcase
    end
end

always @(posedge iClk) begin 
    if (iRst) begin
        oPassDataLeft <= 'd0;
    end else begin
        case (counter)
            'd0 : oPassDataLeft <= 2'd0;
            'd1 : oPassDataLeft <= 2'd0;
            'd2 : oPassDataLeft <= 2'd0;
            'd3 : oPassDataLeft <= 2'd1;
            'd4 : oPassDataLeft <= 2'd3;
            'd5 : oPassDataLeft <= 2'd3;
            'd6 : oPassDataLeft <= 2'd3;
            'd7 : oPassDataLeft <= 2'd3;
            'd8 : oPassDataLeft <= 2'd3;
            'd9 : oPassDataLeft <= 2'd2;
            'd10 : oPassDataLeft <= 2'd0;
            'd11 : oPassDataLeft <= 2'd0;
            'd12 : oPassDataLeft <= 2'd1;
            'd13 : oPassDataLeft <= 2'd3;
            'd14 : oPassDataLeft <= 2'd3;
            'd15 : oPassDataLeft <= 2'd3;
            'd16 : oPassDataLeft <= 2'd3;
            'd17 : oPassDataLeft <= 2'd3;
            'd18 : oPassDataLeft <= 2'd2;
            'd19 : oPassDataLeft <= 2'd0;
            'd20 : oPassDataLeft <= 2'd0;
            'd21 : oPassDataLeft <= 2'd1;
            'd22 : oPassDataLeft <= 2'd3;
            'd23 : oPassDataLeft <= 2'd3;
            'd24 : oPassDataLeft <= 2'd3;
            'd25 : oPassDataLeft <= 2'd3;
            'd26 : oPassDataLeft <= 2'd3;
            'd27 : oPassDataLeft <= 2'd2;
            'd28 : oPassDataLeft <= 2'd0;
            'd29 : oPassDataLeft <= 2'd0;
            'd30 : oPassDataLeft <= 2'd1;
            default : oPassDataLeft <= 2'd0;
        endcase
    end
end

endmodule