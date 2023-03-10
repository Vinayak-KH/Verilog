module fifo_flag_tb;
reg wr, rd, rst, clk;
reg [7:0] d_in;
wire full, empty;
wire [7:0] d_out;

fifo_flag DUT(d_out, empty, full, d_in, wr, rd, rst, clk);

initial
begin
   clk = 1'b0;
   forever #10 clk = ~clk;
end

task reset;
begin
   @(negedge clk) rst = 1'b1;
   @(negedge clk) rst = 1'b0;
end
endtask

task fifo_write(input [7:0] d);
begin
   @(negedge clk);
   wr = 1'b1;
   d_in = d;
   @(posedge clk);
   #2 wr = 1'b0;
end
endtask

task fifo_read;
begin
   @(negedge clk);
   rd = 1'b1;
   @(posedge clk);
   #2 rd = 1'b0;
end
endtask

initial
begin
   reset;
   repeat(17)
      fifo_write({$random} % 8);
   repeat(10)
      fifo_read;
   repeat(6)
   begin
      fifo_write({$random} % 8);
      fifo_read;
   end
   repeat(7)
      fifo_read;
   #150 $finish;
 end

 initial
    $monitor($time," rst = %b, wr = %b, rd = %b, wr_ptr = %d, rd_ptr = %d, d_in = %d, d_out = %d, empty = %b, full = %b", rst, wr, rd, DUT.wr_ptr, DUT.rd_ptr, d_in, d_out, empty, full);

endmodule 
