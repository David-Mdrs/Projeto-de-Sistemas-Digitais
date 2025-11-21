typedef struct packed {
	logic [19:0] [3:0] digits;
} senhaPac_t;

module decodificador_de_teclado (
    input logic clk,
	input logic rst,
	input logic enable,
 	input logic [3:0] col_matriz,
  	output logic [3:0] lin_matriz,
	output senhaPac_t digitos_value,
	output logic digitos_valid
);

    // Variáveis auxiliares
    logic [3:0] linha;
    logic [3:0] leitura_teclado;
  	logic [9:0] tp;
    logic [12:0] contador;
    logic [19:0][3:0] buffer_interno;

    enum logic [3:0] {INICIO, AGUARDANDO, DEBOUNCE, INCREMENTO, DECODIFICAR, EXPIRADO, LIMPAR, REINICIAR, CONFIRMAR} estado;

	always_ff @(posedge clk or posedge rst) begin
		if (rst || !enable) begin
			tp <= 0;
		 	linha <= 0;
            leitura_teclado <= 4'hF;
            contador <= 0;
            buffer_interno <= '{default: 4'hF};
            estado <= INICIO;
     	end
     	else begin
            case (estado)
                INICIO: begin
                    tp <= 0;
                    contador <= 0;
                 	if (enable) estado <= AGUARDANDO;
                end
              
                AGUARDANDO: begin
                    tp <= 0;
                    if (contador >= 5000) begin
                        estado <= EXPIRADO;
                        contador <= 0;
                    end else begin
                        contador <= contador + 1;
                    end
                    if (col_matriz != 4'b1111) estado <= DEBOUNCE;
                    else begin
                        if (linha < 3) linha <= linha + 1;
                        else           linha <= 0;
                    end
                end
              
                EXPIRADO: begin
                    contador <= 0;
                    estado <= REINICIAR;
                end
              
                REINICIAR: begin
                    leitura_teclado <= 4'hF;
                    buffer_interno <= '{default: 4'hF};
                    estado <= AGUARDANDO;
                end
              
                DEBOUNCE: begin
                    leitura_teclado <= 4'hF;
                    contador <= 0;
                    if (col_matriz == 4'b1111) begin 
                        tp <= 0;
                        estado <= AGUARDANDO;
                    end else if (tp >= 100) begin
                        estado <= DECODIFICAR;
                    end else tp <= tp + 1;
                end
              
                DECODIFICAR: begin
                    tp <= 0;
                    if (leitura_teclado == 4'hF) begin
                        if (linha == 0) begin
                            case (col_matriz)
                                4'b0111: leitura_teclado <= 4'h1;
                                4'b1011: leitura_teclado <= 4'h2;
                                4'b1101: leitura_teclado <= 4'h3;
                              	// 4'b1110: leitura_teclado <= 4'hC;
                                default: leitura_teclado <= 4'hF;
                            endcase
                        end
                        else if (linha == 1) begin
                            case (col_matriz)
                                4'b0111: leitura_teclado <= 4'h4;
                                4'b1011: leitura_teclado <= 4'h5;
                                4'b1101: leitura_teclado <= 4'h6;
                              	// 4'b1110: leitura_teclado <= 4'hD;
                                default: leitura_teclado <= 4'hF;
                            endcase
                        end
                        else if (linha == 2) begin
                            case (col_matriz)
                                4'b0111: leitura_teclado <= 4'h7;
                                4'b1011: leitura_teclado <= 4'h8;
                                4'b1101: leitura_teclado <= 4'h9;
                              	// 4'b1110: leitura_teclado <= 4'hE;
                                default: leitura_teclado <= 4'hF;
                            endcase
                        end
                        else if (linha == 3) begin
                            case (col_matriz)
                                4'b0111: leitura_teclado <= 4'hA;
                                4'b1011: leitura_teclado <= 4'h0;
                                4'b1101: leitura_teclado <= 4'hB;
                              	// 4'b1110: leitura_teclado <= 4'hF;
                                default: leitura_teclado <= 4'hF;                   
                            endcase
                        end
                    end
                    else begin 
                     	if (leitura_teclado < 4'hA)       estado <= INCREMENTO;
                        else if (leitura_teclado == 4'hA) estado <= CONFIRMAR;
                        else if (leitura_teclado == 4'hB) estado <= LIMPAR;
                    end
                end
              
                LIMPAR: begin
                  	estado <= REINICIAR;
                end
              
                CONFIRMAR: begin
                  	estado <= REINICIAR;
                end
              
                INCREMENTO: begin
                    buffer_interno[19:1] <= buffer_interno[18:0];
                    buffer_interno[0]    <= leitura_teclado;
                    leitura_teclado <= 4'hF;
                    estado <= AGUARDANDO;
                end
            endcase
        end
    end
   
    always_comb begin
        digitos_valid = 0;
        digitos_value.digits = buffer_interno;
        lin_matriz = 4'b1111;

        case (estado)
         	INICIO: begin
                lin_matriz = 4'b0000;
            end
          
            AGUARDANDO: begin
                case (linha)
                    0: lin_matriz = 4'b0111;
                    1: lin_matriz = 4'b1011;
                    2: lin_matriz = 4'b1101;
                    3: lin_matriz = 4'b1110;
                    default: lin_matriz = 4'b0000;
                endcase
            end
            
            DEBOUNCE, DECODIFICAR: begin
                 case (linha)
                    0: lin_matriz = 4'b0111;
                    1: lin_matriz = 4'b1011;
                    2: lin_matriz = 4'b1101;
                    3: lin_matriz = 4'b1110;
                endcase               
            end

            EXPIRADO: begin
                digitos_valid = 1;
                digitos_value.digits = {20{4'hE}};
            end

            REINICIAR: begin
                digitos_valid = 0;
                digitos_value.digits = {20{4'hF}};
            end

            LIMPAR: begin
                digitos_valid = 1;
                digitos_value.digits = {20{4'hB}};
            end

            CONFIRMAR: begin
                digitos_valid = 1;
            end
        endcase
    end
endmodule