`timescale 1ns / 1ps

// NOT: KOK_DIZIN projeyi olusturdugunuz dizine isaret etmeli
parameter KOK_DIZIN   = "C:\\Users\\hemre\\project_2"                               ;
// NOT: GORSEL .txt uzantisi olan on altilik tabanda metin olarak kaydedilmis gorseli iceren dosyanin ismi
parameter GORSEL      = "ordek"                                                 ;

module proje_tb();

  reg                               clk                                         ;
  reg                               rst                                         ;

  reg           [2:0]               islem                                       ;
  reg           [1:0]               boyut                                       ;
  reg                               basla                                       ;
  reg           [15:0]              oku_adres                                   ;
  reg           [31:0]              oku_veri_r                                  ;
  reg           [31:0]              yaz_veri                                    ;
  reg           [15:0]              yaz_adres                                   ;
  reg                               yaz_gecerli                                 ;

  reg           [31:0]              gorsel_girdi              [0:22499]         ;
  reg           [31:0]              gorsel_cikti              [0:22499]         ;

  reg           [15:0]              yaz_gecerli_sayaci                          ;           

  reg           [31:0]              oku_veri_ns                                 ;

  initial begin
    // NOT: farkli islem ve boyut girisleri kullanip devrenizi calistirin
    basla = 1;
    islem                   =       3'b010                                      ;
    boyut                   =       2'b00                                      ;
    
    // gorseli oku    
    $readmemh({KOK_DIZIN, "\\gorseller\\", GORSEL, ".txt"}, gorsel_girdi);
    
    clk                     =       1'b0                                        ;
    rst                     =       1'b1                                        ;
    yaz_gecerli_sayaci      =       16'b0                                       ;
    oku_veri_r              =       32'd0                                       ;
    #50.1; // 5 cevrim reset sinyali yuksek
    rst = 1'b0;

    while (yaz_gecerli_sayaci != 16'd22500) begin
      #0.1; // girdiyi geciktir
      oku_veri_ns           =       gorsel_girdi              [oku_adres]       ;

      if (yaz_gecerli) begin
        gorsel_cikti  [yaz_adres]     =     yaz_veri                            ;
        yaz_gecerli_sayaci            =     yaz_gecerli_sayaci + 1              ;
      end

      @(posedge clk);
    end

    $display("Simulasyon tamamlandi!");

    // simulasyon tamamlaninca devrenizin olusturdugu islenmis gorseli 
    // orijinal gorsel isminin sonuna '-islenmis' ekini ekleyerek ayni dizine kaydeder
    $writememh({KOK_DIZIN, "\\gorseller\\", GORSEL, "-islenmis.txt"}, gorsel_cikti);

    $finish();
  end

  always @(posedge clk) begin
    oku_veri_r <= oku_veri_ns;
  end

  // 100 MHz saat vurus sikligi
  always begin
    clk = ~clk;
    #5;
  end
  
  ornek_devre uut
  (
    .clk                            (clk)                                       ,
    .rst                            (rst)                                       ,
    .islem                          (islem)                                     ,
    .boyut                          (boyut)                                     ,
    .basla                          (basla)                                     ,
    .oku_veri           
                (oku_veri_r)                                ,
    .oku_adres                      (oku_adres)                                 ,
    .yaz_veri                       (yaz_veri)                                  ,
    .yaz_adres                      (yaz_adres)                                 ,
    .yaz_gecerli                    (yaz_gecerli)
  );

endmodule