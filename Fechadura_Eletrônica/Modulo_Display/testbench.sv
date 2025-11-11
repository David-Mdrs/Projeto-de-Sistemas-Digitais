module tb;  
  bit [1] CLK, RST, ENABLE_O, ENABLE_S;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  
  bcdPac_t BCD_PACK_O, BCD_PACK_S; 
  bcdPac_t BCD_ATUAL;
  
  display Display_TB(.clk(CLK), .rst(RST), .enable_o(ENABLE_O), .enable_s(ENABLE_S), .bcd_packet_operacional(BCD_PACK_O), .bcd_packet_setup(BCD_PACK_S), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
  
  
  
  
  initial begin
    
    $display(" ");
    $display(" ");
	$display(" ================================================================================= ");
    $display(" ============================== INICIANDO TESTBENCH ============================== ");
    $display(" ================================================================================= ");
    $display(" ");
    $display(" ");
    
    CLK = 0;
    RST = 0;
    #2
        
    
    
    
    $display(" ------------------------------ TESTANDO O RESET --------------------------------- ");
    $display(" ");
    
    $display("DADOS DO SISTEMA ANTES DO RESET INICIAL");
    $display("Displays: %b - %b - %b - %b - %b - %b", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    $display("Enable operacional: %d", ENABLE_O);
    $display("Enable setup:       %d", ENABLE_S);
    $display("BCD atual:          %p", Display_TB.bcd_atual);
    $display("Tempo: %0t", $time);
    $display(" ");
    
    RST = 1;
    #2
    
    RST = 0;
    #2
    
    $display("DADOS DO SISTEMA APÓS O RESET INICIAL");
    $display("Displays: %b - %b - %b - %b - %b - %b", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    $display("Enable operacional: %d", ENABLE_O);
    $display("Enable setup:       %d", ENABLE_S);
    $display("BCD atual:          %p", Display_TB.bcd_atual);
    $display("Tempo: %0t", $time);
    $display(" ");
    
    $display(" --------------------------- TESTE RESET FINALIZADO ------------------------------ ");
    $display(" ");
    $display(" ");
    #2
    
    
    
    
    $display(" -------------------------- TESTE DO MODO OPERACIONAL ---------------------------- ");
    $display(" ");


    $display("SISTEMA NO MODO OPERACIONAL E COM OS VALORES 203");

    BCD_PACK_O.BCD0 = 4'h3;		// HEX0 - Valor Ox3
    BCD_PACK_O.BCD1 = 4'h0;		// HEX1 - Valor Ox0
    BCD_PACK_O.BCD2 = 4'h2;		// HEX2 - Valor Ox2
    BCD_PACK_O.BCD3 = 4'hB;		// HEX3 - Apagar display "OxB"
    BCD_PACK_O.BCD4 = 4'hB;		// HEX4 - Apagar display "OxB"
    BCD_PACK_O.BCD5 = 4'hB;		// HEX5 - Apagar display "OxB"
    #2
    
    ENABLE_O = 1;
    #2
    
    $display("SISTEMA COM OPERACIONAL AINDA ATIVO");
    $display("Displays: %b - %b - %b - %b - %b - %b", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    $display("Enable operacional: %d", ENABLE_O);
    $display("Enable setup:       %d", ENABLE_S);
    $display("BCD Operacional:    %p", BCD_PACK_O);
    $display("BCD setup:          %p", BCD_PACK_S);
    $display("BCD atual:          %p", Display_TB.bcd_atual);
    $display("Tempo: %0t", $time);
    $display(" ");
    
    ENABLE_O = 0;
    #2
    
    $display("SISTEMA APÓS DESATIVAR OPERACIONAL");
    $display("Displays: %b - %b - %b - %b - %b - %b", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    $display("Enable operacional: %d", ENABLE_O);
    $display("Enable setup:       %d", ENABLE_S);
    $display("BCD Operacional:    %p", BCD_PACK_O);
    $display("BCD setup:          %p", BCD_PACK_S);
    $display("BCD atual:          %p", Display_TB.bcd_atual);
    $display("Tempo: %0t", $time);
    $display(" ");
    
    $display(" ---------------------- TESTE DO MODO OPERACIONAL FINALIZADO ------------------------ ");
    $display(" ");
    $display(" ");

    
    
    
    $display(" ------------------------------- TESTE DO MODO SETUP --------------------------------- ");
    $display(" ");


    $display("SISTEMA NO MODO SETUP E COM OS VALORES 809");

    BCD_PACK_S.BCD0 = 4'h7;		// HEX0 - Valor Ox7
    BCD_PACK_S.BCD1 = 4'h8;		// HEX1 - Valor Ox9
    BCD_PACK_S.BCD2 = 4'h9;		// HEX2 - Valor Ox8
    BCD_PACK_S.BCD3 = 4'hB;		// HEX3 - Apagar display "OxB"
    BCD_PACK_S.BCD4 = 4'hB;		// HEX4 - Apagar display "OxB"
    BCD_PACK_S.BCD5 = 4'hB;		// HEX5 - Apagar display "OxB"
    #2
    
    ENABLE_S = 1;
    #2
    
    $display("SISTEMA COM SETUP AINDA ATIVO");
    $display("Displays: %b - %b - %b - %b - %b - %b", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    $display("Enable operacional: %d", ENABLE_O);
    $display("Enable setup:       %d", ENABLE_S);
    $display("BCD Operacional:    %p", BCD_PACK_O);
    $display("BCD setup:          %p", BCD_PACK_S);
    $display("BCD atual:          %p", Display_TB.bcd_atual);
    $display("Tempo: %0t", $time);
    $display(" ");
    
    ENABLE_S = 0;
    #2
    
    $display("SISTEMA APÓS DESATIVAR SETUP");
    $display("Displays: %b - %b - %b - %b - %b - %b", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    $display("Enable operacional: %d", ENABLE_O);
    $display("Enable setup:       %d", ENABLE_S);
    $display("BCD Operacional:    %p", BCD_PACK_O);
    $display("BCD setup:          %p", BCD_PACK_S);
    $display("BCD atual:          %p", Display_TB.bcd_atual);
    $display("Tempo: %0t", $time);
    $display(" ");
    
    $display(" -------------------------- TESTE DO MODO SETUP FINALIZADO --------------------------- ");
    $display(" ");
    $display(" ");
    
    
    
    
    $display(" ----------------------- PASSANDO O TEMPO SEM ENVIAR PACOTES ------------------------- ");
    $display(" ");
    #12
    
    $display(" ");
    $display("Displays: %b - %b - %b - %b - %b - %b", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    $display("Enable operacional: %d", ENABLE_O);
    $display("Enable setup:       %d", ENABLE_S);
    $display("BCD Operacional:    %p", BCD_PACK_O);
    $display("BCD setup:          %p", BCD_PACK_S);
    $display("BCD atual:          %p", Display_TB.bcd_atual);
    $display("Tempo: %0t", $time);
    $display(" ");

    
    
    
    $display(" ");
    $display(" ================================================================================= ");
    $display(" ============================== Testbench finalizado ============================= ");
    $display(" ================================================================================= ");
    $finish;
    
  end
  
  
  // Sinal de clock do sistema
  always begin
    #1 CLK = ~CLK;
  end
  
endmodule