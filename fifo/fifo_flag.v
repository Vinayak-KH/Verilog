module fifo_flag
    #(parameter FIFO_WIDTH = 8,
                FIFO_DEPTH = 4,
                ADDR_SIZE = 2)
    (
    output reg [FIFO_WIDTH-1:0] d_out,
    output empty, full,
    input [FIFO_WIDTH-1:0] d_in,
    input wr, rd, rst, clk
    );

reg [FIFO_WIDTH-1:0] fifo_mem [FIFO_DEPTH-1:0];
reg [ADDR_SIZE-1:0] wr_ptr, rd_ptr;
reg flag;
integer i;

assign full = (flag && (wr_ptr == rd_ptr)) ? 1'b1 : 1'b0;
assign empty = (!flag && (rd_ptr == wr_ptr)) ? 1'b1 : 1'b0;

always @(posedge clk)
begin
    if(rst)
    begin
        wr_ptr <= 1'b0;
        rd_ptr <= 1'b0;
        flag <= 1'b0;
        for(i = 0; i < FIFO_DEPTH; i = i + 1)
            fifo_mem[i] <= 1'b0;
    end
    else
    begin
        if(wr && !full)
        begin
            fifo_mem[wr_ptr] <= d_in;
            wr_ptr <= wr_ptr + 1'b1;
            flag <= 1'b1;
        end
	else
	    wr_ptr <= wr_ptr;
        if(rd && !empty)
        begin
            d_out <= fifo_mem[rd_ptr];
            rd_ptr <= rd_ptr + 1'b1;
            flag <= 1'b0;
        end
	else
            rd_ptr <= rd_ptr;
    end
end
endmodule 
