`timescale 1ns / 1ps

// giris cikis tanimlamasini modulunuzde kullanabilirsiniz
module ornek_devre(
  input                             clk                                         ,
  input                             rst                                         ,
                                                                                
  input         [2:0]               islem                                       ,
  input         [1:0]               boyut                                       ,
  input                             basla                                       ,
  output        reg[15:0]              oku_adres                                   ,
  input         [31:0]              oku_veri                                    ,
  output        reg[31:0]              yaz_veri                                    ,
  output        reg[15:0]              yaz_adres                                   ,
  output        reg                    yaz_gecerli                                 
);
    localparam satir_numarasi = 75;
    reg [7:0] resim [299:0][299:0];
    reg[31:0] yaz_veri_n = 0;  
    reg [7:0] out_resim [299:0][299:0];
    reg [7:0] filtre3[2:0][2:0];
    reg [15:0] yaz_adres_n = 0,oku_adres_n = 0;
    reg[2399:0]cevrim, cevrim_n;
    integer satir,satir_n,sutun,sutun_n,count,count_n;
    integer k,l,c;
    integer i,j;
    initial begin
        for(k=0; k<300; k=k+1) begin
            for(l=0; l<300; l=l+1) begin
                resim[k][l] = 8'b0000_0000; //her hucre bi piksel 
                out_resim[k][l] = 8'b0000_0000; //her hucre bi piksel 
            end
        end
        c=0;
        i=0;
        j=0; 
        yaz_adres = 0;
        yaz_veri = 0;
        yaz_gecerli = 0;
        oku_adres = 0;
        oku_adres_n = 0;
        cevrim = 0;
        sutun = 0;
        satir = 0;
        cevrim_n = 0;
        sutun_n = 0;
        satir_n = 0;
        count = 0;
        count_n = 0;
    end

    always @*begin

        if(basla) begin
            case (islem)
              3'b000  : begin //Asıl görsel
                $display("Elif"); 
              end 
              3'b001  : begin //Netleştirme
                if(oku_adres < 22501)begin
                    if(oku_adres != 0)begin
                    resim[i][j] = oku_veri[31-:8];
                    $display("sa %h",oku_veri[31-:8]);
                    resim[i][j+1] = oku_veri[23-:8];
                    resim[i][j+2] = oku_veri[15-:8];
                    resim[i][j+3] = oku_veri[7-:8];
                   $display("as %h",resim[1][0]); 
                        c = c + 1;
                        j = j + 4;
                    end
                    oku_adres_n = oku_adres + 1;
                    if(c % satir_numarasi == 0 && c != 0)begin
                        i = i+1;
                        j=0;
                    end           
                end
                else if (cevrim < 22500)begin
                    if(cevrim == 22499)
                         yaz_gecerli = 1;
                    if(boyut == 2'b00)begin
                        if(cevrim == 0)begin
                            satir = 1;
                            satir = 1;
                        end
                        if(cevrim % 76 == 0)begin
                            cevrim_n = cevrim + 1;
                        end
                        else if(cevrim % 75 == 0 && cevrim != 0)begin
                            satir = satir+1;
                            sutun = 1;
                            cevrim_n = cevrim + 1;
                        end
                        else begin
                        for(i=0; i<3; i=i+1) begin
                            for(j=0; j<3; j=j+1) begin
                                filtre3[i][j] = 8'b0000_0000; //her hucre bi piksel 
                                if(i==1)
                                    filtre3[i][j] = -1;
                            end
                        end
                        filtre3[0][1] = -1;
                        filtre3[1][1] = 5;
                        filtre3[2][1] = -1;
                        for(i=0; i<4; i=i+1) begin
                        $display("sayis satir $d",satir,"sayis sutun $d",sutun);
                        $display("sayi ",(resim[satir-1][sutun+i-1]*filtre3[0][0]+resim[satir-1][sutun+i]*filtre3[0][1]+resim[satir-1][sutun+1+i]*filtre3[0][2]+
                                                      resim[satir][sutun-1+i]*filtre3[1][0]+resim[satir][sutun+i]*filtre3[1][1]+resim[satir][sutun+1+i]*filtre3[1][2]+
                                                      resim[satir+1][sutun-1+i]*filtre3[2][0]+resim[satir+1][sutun+i]*filtre3[2][1]+resim[satir+1][sutun+1+i]*filtre3[2][2]));
                                                      
                        if((resim[satir-1][sutun+i-1]*filtre3[0][0]+resim[satir-1][sutun+i]*filtre3[0][1]+resim[satir-1][sutun+1+i]*filtre3[0][2]+
                                                      resim[satir][sutun-1+i]*filtre3[1][0]+resim[satir][sutun+i]*filtre3[1][1]+resim[satir][sutun+1+i]*filtre3[1][2]+
                                                      resim[satir+1][sutun-1+i]*filtre3[2][0]+resim[satir+1][sutun+i]*filtre3[2][1]+resim[satir+1][sutun+1+i]*filtre3[2][2]) > 8'd255)begin
                         out_resim[satir][sutun+i] = 8'd255;                
                         end             
                        else if((resim[satir-1][sutun+i-1]*filtre3[0][0]+resim[satir-1][sutun+i]*filtre3[0][1]+resim[satir-1][sutun+1+i]*filtre3[0][2]+
                                                      resim[satir][sutun-1+i]*filtre3[1][0]+resim[satir][sutun+i]*filtre3[1][1]+resim[satir][sutun+1+i]*filtre3[1][2]+
                                                      resim[satir+1][sutun-1+i]*filtre3[2][0]+resim[satir+1][sutun+i]*filtre3[2][1]+resim[satir+1][sutun+1+i]*filtre3[2][2])<8'd0)begin
                         out_resim[satir][sutun+i] = 8'd0;        
                         end                      
                         else
                            out_resim[satir][sutun+i] =(resim[satir-1][sutun+i-1]*filtre3[0][0]+resim[satir-1][sutun+i]*filtre3[0][1]+resim[satir-1][sutun+1+i]*filtre3[0][2]+
                                                      resim[satir][sutun-1+i]*filtre3[1][0]+resim[satir][sutun+i]*filtre3[1][1]+resim[satir][sutun+1+i]*filtre3[1][2]+
                                                      resim[satir+1][sutun-1+i]*filtre3[2][0]+resim[satir+1][sutun+i]*filtre3[2][1]+resim[satir+1][sutun+1+i]*filtre3[2][2]);
                        end
                    end

                    sutun = sutun + 4;
                    cevrim_n = cevrim+1;
                end 
                end
                else begin
                if(cevrim == 22500)begin
                    satir = 0;
                    sutun = 0;
                    
                end
                if(cevrim % satir_numarasi == 0 && cevrim != 22500)begin
                            satir = satir+1;
                            sutun = 0;
                end
                   
                    yaz_veri_n[31-:8] = resim[satir][sutun];

                    yaz_veri_n[23-:8] = resim[satir][sutun+1];
                    yaz_veri_n[15-:8] = resim[satir][sutun+2];
                    yaz_veri_n[7-:8] = resim[satir][sutun+3];
                    yaz_adres_n = yaz_adres + 1;
                    sutun = sutun + 4;
                    cevrim_n = cevrim+1;
                    
                end
               
              end 
              3'b010  : begin //Kenar Tespiti
                $display("H.Emre");
                
              end
              3'b011  : begin //Kutu bulanıklaştırma
                $display("Berkay"); 
              end
              3'b100  : begin //Gaussian bulanıklaştırma
                 $display("Berkay");
              end 
              3'b101  : begin //Siyah/Beyaz dönüşüm
                $display("Elif"); 
              end
              3'b110  : begin //Dikey eksene göre simetri
                $display("Murat"); 
              end
              3'b111  : begin //Yatay eksene göre simetri
                $display("Murat"); 
              end
            endcase

        end
    end
    
    always@(posedge clk) begin
         if(rst) begin
            yaz_adres <= 0;
            oku_adres <= 0;
            yaz_veri <= 0;
            i=0;
            j=0;
        end
        else begin
        yaz_veri <= yaz_veri_n;
        yaz_adres <= yaz_adres_n;
        oku_adres <= oku_adres_n;
        cevrim <= cevrim_n;
        end
    end

endmodule