// Numeros binarios de 4 bits de cada display
typedef struct packed {
  	logic [3:0] BCD0;
	logic [3:0] BCD1;
	logic [3:0] BCD2;
	logic [3:0] BCD3;
  	logic [3:0] BCD4;
  	logic [3:0] BCD5;
} bcdPac_t;

module display (
	input 		logic 		clk,
	input 		logic 		rst,
	input 		logic 		enable_o, enable_s,
	input 		bcdPac_t 	bcd_packet_operacional, bcd_packet_setup, 
	output 		logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

  	bcdPac_t bcd_atual;
  
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			bcd_atual <= '{default: 4'hB};
        end else if (enable_o == 1) begin
			bcd_atual <= bcd_packet_operacional;
        end else if (enable_s == 1) begin
			bcd_atual <= bcd_packet_setup;
        end
	end

	always_comb begin
		case (bcd_atual.BCD0)
    		4'h0: HEX0 = 7'b0111111; // 0
    		4'h1: HEX0 = 7'b0000110; // 1
    		4'h2: HEX0 = 7'b1011011; // 2
    		4'h3: HEX0 = 7'b1001111; // 3
    		4'h4: HEX0 = 7'b1100110; // 4
    		4'h5: HEX0 = 7'b1101101; // 5
    		4'h6: HEX0 = 7'b1111101; // 6
    		4'h7: HEX0 = 7'b0000111; // 7
    		4'h8: HEX0 = 7'b1111111; // 8
    		4'h9: HEX0 = 7'b1101111; // 9
    		4'hA: HEX0 = 7'b1000000; // "Traco"
    		4'hB: HEX0 = 7'b0000000; // "Apagar"
    		default: HEX0 = 7'b0000000;
		endcase
  		case (bcd_atual.BCD1)
    		4'h0: HEX1 = 7'b0111111;
    		4'h1: HEX1 = 7'b0000110;
    		4'h2: HEX1 = 7'b1011011;
    		4'h3: HEX1 = 7'b1001111;
    		4'h4: HEX1 = 7'b1100110;
    		4'h5: HEX1 = 7'b1101101;
    		4'h6: HEX1 = 7'b1111101;
    		4'h7: HEX1 = 7'b0000111;
    		4'h8: HEX1 = 7'b1111111;
    		4'h9: HEX1 = 7'b1101111;
    		4'hA: HEX1 = 7'b1000000;
    		4'hB: HEX1 = 7'b0000000;
    		default: HEX1 = 7'b0000000;
		endcase
  		case (bcd_atual.BCD2)
    		4'h0: HEX2 = 7'b0111111;
    		4'h1: HEX2 = 7'b0000110;
    		4'h2: HEX2 = 7'b1011011;
    		4'h3: HEX2 = 7'b1001111;
    		4'h4: HEX2 = 7'b1100110;
    		4'h5: HEX2 = 7'b1101101;
    		4'h6: HEX2 = 7'b1111101;
    		4'h7: HEX2 = 7'b0000111;
    		4'h8: HEX2 = 7'b1111111;
    		4'h9: HEX2 = 7'b1101111;
    		4'hA: HEX2 = 7'b1000000;
    		4'hB: HEX2 = 7'b0000000;
    		default: HEX2 = 7'b0000000;
		endcase
  		case (bcd_atual.BCD3)
    		4'h0: HEX3 = 7'b0111111;
    		4'h1: HEX3 = 7'b0000110;
    		4'h2: HEX3 = 7'b1011011;
    		4'h3: HEX3 = 7'b1001111;
    		4'h4: HEX3 = 7'b1100110;
    		4'h5: HEX3 = 7'b1101101;
    		4'h6: HEX3 = 7'b1111101;
    		4'h7: HEX3 = 7'b0000111;
    		4'h8: HEX3 = 7'b1111111;
    		4'h9: HEX3 = 7'b1101111;
    		4'hA: HEX3 = 7'b1000000;
    		4'hB: HEX3 = 7'b0000000;
    		default: HEX3 = 7'b0000000;
		endcase
  		case (bcd_atual.BCD4)
    		4'h0: HEX4 = 7'b0111111;
    		4'h1: HEX4 = 7'b0000110;
    		4'h2: HEX4 = 7'b1011011;
    		4'h3: HEX4 = 7'b1001111;
          	4'h4: HEX4 = 7'b1100110;
    		4'h5: HEX4 = 7'b1101101;
    		4'h6: HEX4 = 7'b1111101;
    		4'h7: HEX4 = 7'b0000111;
    		4'h8: HEX4 = 7'b1111111;
    		4'h9: HEX4 = 7'b1101111;
    		4'hA: HEX4 = 7'b1000000;
    		4'hB: HEX4 = 7'b0000000;
    		default: HEX4 = 7'b0000000;
		endcase
  		case (bcd_atual.BCD5)
    		4'h0: HEX5 = 7'b0111111;
    		4'h1: HEX5 = 7'b0000110;
    		4'h2: HEX5 = 7'b1011011;
    		4'h3: HEX5 = 7'b1001111;
    		4'h4: HEX5 = 7'b1100110;
    		4'h5: HEX5 = 7'b1101101;
    		4'h6: HEX5 = 7'b1111101;
    		4'h7: HEX5 = 7'b0000111;
    		4'h8: HEX5 = 7'b1111111;
    		4'h9: HEX5 = 7'b1101111;
    		4'hA: HEX5 = 7'b1000000;
    		4'hB: HEX5 = 7'b0000000;
    		default: HEX5 = 7'b0000000;
		endcase
	end
endmodule