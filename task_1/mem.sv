timeunit 1ns;
timeprecision 1ns;

module mem (
	 mem_itf newBus
);

	logic [7:0] mem_array [0:31];

	always_ff @(posedge newBus.clk) begin
		if(newBus.write == 1 && newBus.read == 0)begin
			mem_array[newBus.addr] <= newBus.data_in;
		end
		if(newBus.read == 1 && newBus.write == 0) begin
			newBus.data_out <= mem_array[newBus.addr];
		end
	end

endmodule
