module avoidShake(
	input clk1000,
	input key_in,
	output reg key_out
	);

reg [19:0] fifo;
reg [1:0] key_in_r;
wire change;

initial 
    key_out = 1'b1;

always @(posedge clk1000) begin
    key_in_r <= {key_in_r[0],key_in};
end

assign change = key_in_r[0] ^ key_in_r[1];

always @(posedge clk1000) begin 
    if(1 == change)
        fifo <= 20'b0;
    else fifo <= {fifo[18:0],1'b1};
end

always @(posedge clk1000)
begin
    if(20'hf_ffff == fifo)
        key_out <= key_in_r[0];
end

endmodule