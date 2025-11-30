typedef struct packed {
    logic [19:0] [3:0] digits;
} senhaPac_t;

typedef struct packed {
    logic [3:0] BCD0;
    logic [3:0] BCD1;
    logic [3:0] BCD2;
    logic [3:0] BCD3;
    logic [3:0] BCD4;
    logic [3:0] BCD5;
} bcdPac_t;

typedef struct packed {
    logic       bip_status;
    logic [5:0] bip_time;
    logic [5:0] tranca_aut_time;
    senhaPac_t  senha_master;
    senhaPac_t  senha_1;
    senhaPac_t  senha_2;
    senhaPac_t  senha_3;
    senhaPac_t  senha_4;
} setupPac_t;

module operacional (
    input  logic        clk,
    input  logic        rst,
    input  logic        sensor_contato,
    input  logic        botao_interno,
    input  logic        botao_bloqueio,
    input  logic        botao_config,
    input  setupPac_t   data_setup_new,
    input  logic        data_setup_ok,
    input  senhaPac_t   digitos_value,
    input  logic        digitos_valid,
    output bcdPac_t     bcd_pac,
    output logic        teclado_en,
    output logic        display_en,
    output logic        setup_on,
    output logic        tranca,
    output logic        bip
);

    setupPac_t   config_ativa;
  
  	wire [3:0] codigo = digitos_value.digits[0];
    
    logic [31:0] contador_bip;
    logic [31:0] contador_tranca;
    logic [31:0] contador_nao_perturbe;
    logic [31:0] contador_bloqueado;
    
    logic [31:0] db_botao_config;
    logic [31:0] db_botao_interno;
    
    logic [3:0]  estado_anterior;
    logic [2:0]  tentativas;

    enum logic [3:0] {
        AGUARDANDO,
        PORTA_FECHADA,
        PORTA_ENCOSTADA,
        PORTA_ABERTA,
        PORTA_BIP,
        EXPIRADO,
        VALIDAR_SENHA,
        CONTAR_TENTATIVAS,
        BLOQUEADO,
        DB_BOTAO_INTERNO,
        DB_BOTAO_BLOQUEIO,
        DB_BOTAO_CONFIG,
        NAO_PERTURBE,
        SENHA_MASTER,
        SETUP
    } estado, estado_anterior;

    always_ff @(posedge clk or posedge rst) begin
      	if (rst) begin
            contador_bip          <= 0;
            contador_tranca       <= 0;
            contador_nao_perturbe <= 0;
            contador_bloqueado    <= 0;
            db_botao_config       <= 0;
            db_botao_interno      <= 0;
            tentativas            <= 0;
            estado <= AGUARDANDO;
            estado_anterior <= AGUARDANDO;
     	end
     	else begin
            case (estado)
              
                AGUARDANDO: begin
                  if (!sensor_contato) estado <= PORTA_FECHADA;
                end
              
                PORTA_FECHADA: begin
                    db_botao_interno <= 0;
					contador_nao_perturbe <= 0;
					estado_anterior <= PORTA_FECHADA;
                  	if (botao_bloqueio) estado <= DB_BOTAO_BLOQUEIO;
                  	else if (botao_interno) estado <= DB_BOTAO_INTERNO;
                  	else if (digitos_valid && codigo == 4'hE) estado <= EXPIRADO;
                  	else if (digitos_valid && codigo != 4'hE && codigo != 4'hF && codigo != 4'hB) estado <= VALIDAR_SENHA;
                end
              
              	DB_BOTAO_BLOQUEIO: begin
                  	contador_nao_perturbe <= contador_nao_perturbe + 1;
                  	if (!botao_bloqueio) estado <= PORTA_FECHADA;
                  	else if (contador_nao_perturbe >= 3000) estado <= NAO_PERTURBE;
                end
              
              	NAO_PERTURBE: begin
                  	db_botao_interno <= 0;
                  	contador_nao_perturbe <= 0;
                  	estado_anterior <= NAO_PERTURBE;
                  	if (botao_interno) <= estado <= DB_BOTAO_INTERNO;
                end
              	
              	DB_BOTAO_INTERNO: begin
                 	db_botao_interno <= db_botao_interno + 1;
                  	if (!botao_interno && estado_anterior == NAO_PERTURBE) estado <= NAO_PERTURBE;
                  	else if (!botao_interno && estado_anterior == PORTA_FECHADA) estado <= PORTA_FECHADA;
                  	else if (!botao_interno && estado_anterior == PORTA_ENCOSTADA) estado <= PORTA_ENCOSTADA;
                  	else if (db_botao_interno >= 100 && estado_anterior != PORTA_ENCOSTADA) estado <= PORTA_ENCOSTADA;
                  	else if (db_botao_interno >= 100 && estado_anterior == PORTA_ENCOSTADA) estado <= PORTA_FECHADA;
                end
              
              	PORTA_ENCOSTADA: begin
                	contador_tranca <= contador_tranca + 1;
					estado_anterior <= PORTA_ENCOSTADA;
                  	if (botao_interno) estado <= DB_BOTAO_INTERNO;
                  	else if (contador_tranca >= data_setup_new.tranc_out_time) estado <= PORTA_FECHADA;
                  	else if (sensor_contato) estodo <= PORTA_ABERTA;
                end
              
              	EXPIRADO: begin
                  	estado <= PORTA_FECHADA;
                end
              
              	PORTA_ABERTA: begin
                  	contador_bip <= contador_bip + 1;
					db_botao_config <= 0;
					estado_anterior <= PORTA_ABERTA;
                  	if (contador_bip >= data_setup_new.time_bip) estado <= PORTA_BIP;
                  	else if (botao_config) estado <= DB_BOTAO_CONFIG;
                end
              
              	PORTA_BIP: begin
                  	db_botao_config <= 0;
					estado_anterior <= PORTA_BIP;
                  	if (!sensor_contato) estado <= PORTA_ENCOSTADA;
                  	if (botao_config) estado <= DB_BOTAO_CONFIG;
                end
              	
              	DB_BOTAO_CONFIG: begin
               		db_botao_config <= db_botao_config + 1;
                  	if (!botao_config && estado_anterior == PORTA_ABERTA) estado <= PORTA_ABERTA;
                  	else if (!botao_config && estado_anterior == PORTA_BIP) estado <= PORTA_BIP;
                  	else if (db_botao_config >= 100) estado <= SENHA_MASTER;
                end
              
              	CONTAR_TENTATIVAS: begin
                  	contador_bloqueado <= 0;
                  	tentativas <= tentativas + 1;
                  	if (tentativas < 5) estado <= PORTA_FECHADA;
                  	else estado <= estado <= BLOQUEADO;
                end
              
              	BLOQUEADO: begin
                  	contador <= contador + 1;
                  	if (contador >= 30000) estado <= PORTA_FECHADA;
                end
              
              	SETUP: begin
                  	if (data_setup_ok) estado <= PORTA_ABERTA;
             	end
              
            endcase
        end
      
      
    end

    always_comb begin
    
    end

endmodule