typedef struct packed {
	logic [19:0] [3:0] digits;
} senhaPac_t;

module decodificador_de_teclado (
	input 		logic		clk,
	input		logic		rst,
	input		logic 		enable,
	input 		logic [3:0] 	col_matriz,
	output 		logic [3:0] 	lin_matriz,
	output 		senhaPac_t	digitos_value,
	output		logic 		digitos_valid
);

    logic [3:0] linha;
  	logic [3:0] leitura_teclado;
  	logic [9:0] tp;
 	logic [12:0] contador;

  	enum logic [3:0] {INICIO, AGUARDANDO, DEBOUNCE, INCREMENTO, DECODIFICAR, EXPIRADO, LIMPAR, REINICIAR, CONFIRMAR} estado;

	always_ff @(posedge clk or posedge rst) begin
    	if (rst || !enable) begin
        	tp <= 0;
		  	linha <= 0;
          	leitura_teclado <= 4'hF;
            contador <= 0;
          	estado <= INICIO;
      	end
      	else begin
          	case (estado)
              
          		INICIO: begin
                	tp <= 0;
                  	contador <= 0;
                  	if (enable) begin
                    	estado <= AGUARDANDO;
                  	end
                end
              
              	AGUARDANDO: begin
                	tp <= 0;
                  	contador <= contador + 1;
                 	if (contador >= 500) begin
                      	estado <= EXPIRADO;
                    end
                  
                	if (col_matriz != 4'b1111) begin // Tecla pressionada
                  		estado <= DEBOUNCE;
                	end
                
                	else begin                       // Fazendo varredura das linhas
                  		if (linha < 3)
                    		linha <= (linha + 1);
                  		else
                    		linha <= 0;
                	end
                end
              
              	EXPIRADO: begin
                 	contador <= 0;
                 	if (clk)
                      	estado <= REINICIAR;
                end
              
              	REINICIAR: begin
                  	leitura_teclado <= 4'hF;
                  	if (clk)
                      	estado <= AGUARDANDO;
                end
              	
              	DEBOUNCE: begin
                  	leitura_teclado <= 4'hF;
                  	contador <= 0;
                	tp <= tp + 1;
                	if (col_matriz == 4'b1111) begin  // Botao solto antes de estabilizar
                  		tp <= 0;
                  		estado <= AGUARDANDO;
                	end
                	else if (tp >= 100) begin		  // Tempo de estabilizacao concluido
                  		estado <= DECODIFICAR;
                	end
              	end
              
              
                DECODIFICAR: begin
                	tp <= 0;
                 	if (leitura_teclado == 4'hF) begin		// Fazendo leitura
                      	if (linha == 0) begin
                	   		case (col_matriz)
            	       			4'b0111: leitura_teclado <= 4'h1;
        	              		4'b1011: leitura_teclado <= 4'h2;
								4'b1101: leitura_teclado <= 4'h3;
								//4'b1110: leitura_teclado <= 4'hC;
								default: leitura_teclado <= 4'hF;
                   			endcase
                      	end
                     	else if (linha == 1) begin
                   			case (col_matriz)
                   				4'b0111: leitura_teclado <= 4'h4;
                      			4'b1011: leitura_teclado <= 4'h5;
								4'b1101: leitura_teclado <= 4'h6;
								//4'b1110: leitura_teclado <= 4'hD;
								default: leitura_teclado <= 4'hF;
        	           		endcase
                    	end
                      	else if (linha == 2) begin
	                   		case (col_matriz)
                   				4'b0111: leitura_teclado <= 4'h7;
                       			4'b1011: leitura_teclado <= 4'h8;
								4'b1101: leitura_teclado <= 4'h9;
								//4'b1110: leitura_teclado <= 4'hE;
								default: leitura_teclado <= 4'hF;
        	           		endcase
                    	end
                      	else if (linha == 3) begin
	                   		case (col_matriz)
					   			4'b0111: leitura_teclado <= 4'hA;
								4'b1011: leitura_teclado <= 4'h0;
								4'b1101: leitura_teclado <= 4'hB;
								//4'b1110: leitura_teclado <= 4'hF;
								default: leitura_teclado <= 4'hF;                	   
                            endcase
            	     	end
                	end
              		else begin	// Leitura feita
                      	if (leitura_teclado < 4'hA)
                        	estado <= INCREMENTO;
                        else if (leitura_teclado == 4'hA)
                          	estado <= CONFIRMAR;
                        else if (leitura_teclado == 4'hB)
                          	estado <= LIMPAR;
                	end
              	end
              
              	LIMPAR: begin
                  	if (clk)
                      	estado <= REINICIAR;
                end
              
              	CONFIRMAR: begin
                  	if (clk)
                    	estado <= REINICIAR;
                end
              
              	INCREMENTO: begin
                  	if (clk)
                      	estado <= AGUARDANDO;
                end
              
          	endcase
        end
    end
    
  	always_comb begin
      	if (rst || !enable) begin
    		digitos_valid <= 0;
          	digitos_value.digits <= {20{4'hF}};
      	end
		else begin
			case (estado)
            	INICIO: begin
                 	digitos_valid <= 0;
          			digitos_value.digits <= {20{4'hF}};
                end
              
              	AGUARDANDO: begin
                  	digitos_valid <= 0;
                end
              
              	EXPIRADO: begin
                    digitos_valid <= 1;
                  	digitos_value.digits <= {20{4'hE}};
                end
              
              	REINICIAR:  begin
                 	digitos_valid <= 0;
          			digitos_value.digits <= {20{4'hF}};
                end
              
              	DEBOUNCE: begin
                  	digitos_valid <= 0;
            	end
              
              	DECODIFICAR: begin
                  	digitos_valid <= 0;
                end
                  
              	LIMPAR: begin
                    digitos_valid <= 1;
                  	digitos_value.digits <= {20{4'hB}};
                end
              
              	CONFIRMAR: begin
                  	digitos_valid <= 1;
                end
              
              	INCREMENTO: begin
                	digitos_value.digits[0] = digitos_value.digits[1];
                	digitos_value.digits[1] = digitos_value.digits[2];
                	digitos_value.digits[2]= digitos_value.digits[3];
                	digitos_value.digits[3] = digitos_value.digits[4];
                	digitos_value.digits[4] = digitos_value.digits[5];
                	digitos_value.digits[5] = digitos_value.digits[6];
                	digitos_value.digits[6] = digitos_value.digits[7];
                	digitos_value.digits[7] = digitos_value.digits[8];
                	digitos_value.digits[8] = digitos_value.digits[9];
                	digitos_value.digits[9] = digitos_value.digits[10];
                	digitos_value.digits[10] = digitos_value.digits[11];
                	digitos_value.digits[11] = digitos_value.digits[12];
                	digitos_value.digits[12] = digitos_value.digits[13];
                	digitos_value.digits[13] = digitos_value.digits[14];
                	digitos_value.digits[14] = digitos_value.digits[15];
                	digitos_value.digits[15] = digitos_value.digits[16];
                	digitos_value.digits[16] = digitos_value.digits[17];
                	digitos_value.digits[17] = digitos_value.digits[18];
                	digitos_value.digits[18] = digitos_value.digits[19];

                  	digitos_value.digits[19] = leitura_teclado;
                	digitos_valid = 0;
                  	leitura_teclado = 4'hF;
                end
         	endcase
      	end
    end
endmodule
