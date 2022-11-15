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

  // buradan sonraki kodu kesinlikle degistirmelisiniz
    reg signed [8:0] cerceveli_resim [305:0][305:0]; //her hucre bi piksel 306x306 image  
    reg [7:0] output_resim [299:0][299:0];
    reg [15:0] oku_adres_n=0, yaz_adres_n=0;
    reg [31:0] yaz_veri_n=0; 
    reg baslat = 0;
    reg [15:0] okunan_adres = 16'd0, okunacak_adres = 16'd0 ;
    reg [7:0] yardimci_piksel=8'b0 , yardimci_piksel2=8'b0;
    integer l=22425 , m =74,k=0;
    integer i,j;
    initial begin
        for(i=0; i<306; i=i+1) begin
            for(j=0; j<306; j=j+1) begin
                cerceveli_resim[i][j] = 8'b0000_0000; //her hucre bi piksel 
            end
        end
        i=3;
        j=3; 
    end

    always @*begin

        if(basla) baslat = 1; 
        if(baslat) begin
            case (islem)
                3'b000  : begin //Asýl görsel
                    if(oku_adres !=0)begin
                    yaz_gecerli=1;
                    yaz_veri=oku_veri;
                    yaz_adres_n=yaz_adres+1;
                    end
                    oku_adres_n = oku_adres+1;
                end 
                3'b001  : begin //Netleþtirme
                    if(oku_adres < 22501)begin
                        oku_adres_n = oku_adres + 1;
                        if(oku_adres != 0) begin
                            cerceveli_resim[i][j] = oku_veri[7-:8];
                            cerceveli_resim[i][j+1] = oku_veri[15-:8];
                            cerceveli_resim[i][j+2] = oku_veri[23-:8];
                            cerceveli_resim[i][j+3] = oku_veri[31-:8];
                            j = j + 4;
                            if(oku_adres % 75 == 0) begin
                                i = i + 1;
                                j = 3;
                            end
                        end
                        
                    end
                    else if(yaz_adres < 22500) begin
                        if(yaz_adres < 1) begin
                        for(i=0; i<300; i=i+1) begin
                            for(j=0; j<300; j=j+1) begin
                                if(boyut == 2'b00 || boyut == 2'b11)  begin
                                if ((-cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0-
                                                          cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*5 - cerceveli_resim[i+3][j+4] -
                                                          cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 ) > 255)
                                    output_resim[i][j] = 255;
                                    else if((-cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0-
                                                          cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*5 - cerceveli_resim[i+3][j+4] -
                                                          cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 ) < 0)
                                                          output_resim[i][j] =0;
                                    else output_resim[i][j] = (-cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0-
                                                          cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*5 - cerceveli_resim[i+3][j+4] -
                                                          cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 );
                                                          
                                end
                                
                                else if(boyut == 2'b01)  begin
                                    if ((-cerceveli_resim[i+1][j+1]*0 - cerceveli_resim[i+1][j+2]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 -
                                                          cerceveli_resim[i+2][j+1]*0 - cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 -                                                         
                                                          cerceveli_resim[i+3][j+1] - cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*9 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] -
                                                          cerceveli_resim[i+4][j+1]*0 - cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 -
                                                          cerceveli_resim[i+5][j+1]*0 - cerceveli_resim[i+5][j+2]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0) > 255)
                                    output_resim[i][j] = 255;
                                    else if((-cerceveli_resim[i+1][j+1]*0 - cerceveli_resim[i+1][j+2]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 -
                                                          cerceveli_resim[i+2][j+1]*0 - cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 -                                                         
                                                          cerceveli_resim[i+3][j+1] - cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*9 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] -
                                                          cerceveli_resim[i+4][j+1]*0 - cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 -
                                                          cerceveli_resim[i+5][j+1]*0 - cerceveli_resim[i+5][j+2]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0) < 0)
                                                          output_resim[i][j] =0;
                                    else
                                    output_resim[i][j] = (-cerceveli_resim[i+1][j+1]*0 - cerceveli_resim[i+1][j+2]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 -
                                                          cerceveli_resim[i+2][j+1]*0 - cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 -                                                         
                                                          cerceveli_resim[i+3][j+1] - cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*9 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] -
                                                          cerceveli_resim[i+4][j+1]*0 - cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 -
                                                          cerceveli_resim[i+5][j+1]*0 - cerceveli_resim[i+5][j+2]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0);
                                end                         
                                
                                else if(boyut == 2'b10)  begin
                                    if ((-cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+2]*0 - cerceveli_resim[i][j+3] - cerceveli_resim[i][j+4]*0 - cerceveli_resim[i][j+5]*0 - cerceveli_resim[i][j+6]*0 -
                                                         cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 - cerceveli_resim[i+1][j+6]*0 -                                                         
                                                         cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 - cerceveli_resim[i+2][j+6]*0 -
                                                         cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+3]*13 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] - cerceveli_resim[i+3][j+6] -
                                                         cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 - cerceveli_resim[i+4][j+6]*0 -
                                                         cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0 - cerceveli_resim[i+5][j+6]*0 -
                                                         cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3] - cerceveli_resim[i+6][j+4]*0 - cerceveli_resim[i+6][j+5]*0 - cerceveli_resim[i+6][j+6]*0) > 255)
                                        output_resim[i][j] = 255;
                                    else if((-cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+2]*0 - cerceveli_resim[i][j+3] - cerceveli_resim[i][j+4]*0 - cerceveli_resim[i][j+5]*0 - cerceveli_resim[i][j+6]*0 -
                                                         cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 - cerceveli_resim[i+1][j+6]*0 -                                                         
                                                         cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 - cerceveli_resim[i+2][j+6]*0 -
                                                         cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+3]*13 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] - cerceveli_resim[i+3][j+6] -
                                                         cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 - cerceveli_resim[i+4][j+6]*0 -
                                                         cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0 - cerceveli_resim[i+5][j+6]*0 -
                                                         cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3] - cerceveli_resim[i+6][j+4]*0 - cerceveli_resim[i+6][j+5]*0 - cerceveli_resim[i+6][j+6]*0)< 0)
                                                          output_resim[i][j] =0;
                                    else
                                        output_resim[i][j] =(-cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+2]*0 - cerceveli_resim[i][j+3] - cerceveli_resim[i][j+4]*0 - cerceveli_resim[i][j+5]*0 - cerceveli_resim[i][j+6]*0 -
                                                         cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 - cerceveli_resim[i+1][j+6]*0 -                                                         
                                                         cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 - cerceveli_resim[i+2][j+6]*0 -
                                                         cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+3]*13 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] - cerceveli_resim[i+3][j+6] -
                                                         cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 - cerceveli_resim[i+4][j+6]*0 -
                                                         cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0 - cerceveli_resim[i+5][j+6]*0 -
                                                         cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3] - cerceveli_resim[i+6][j+4]*0 - cerceveli_resim[i+6][j+5]*0 - cerceveli_resim[i+6][j+6]*0);
                                end 
                            end
                        end                       
                        i=0;
                        j=0;
                        end

                        
                        yaz_gecerli = 1;
                        
                        yaz_veri[7-:8] = output_resim[i][j];
                        yaz_veri[15-:8] = output_resim[i][j+1];
                        yaz_veri[23-:8] = output_resim[i][j+2];
                        yaz_veri[31-:8] = output_resim[i][j+3];
                        
                        j=j+4;
                        yaz_adres_n = yaz_adres + 1;
                        if(yaz_adres_n % 75 == 0) begin
                            i = i + 1;
                            j = 0;
                        end
                    end
                    else yaz_gecerli = 0;
                
                end 
                3'b010  : begin //Kenar Tespiti
                    if(oku_adres < 22501)begin
                        oku_adres_n = oku_adres + 1;
                        if(oku_adres != 0) begin
                            cerceveli_resim[i][j] = oku_veri[7-:8];
                            cerceveli_resim[i][j+1] = oku_veri[15-:8];
                            cerceveli_resim[i][j+2] = oku_veri[23-:8];
                            cerceveli_resim[i][j+3] = oku_veri[31-:8];
                            j = j + 4;
                            if(oku_adres % 75 == 0) begin
                                i = i + 1;
                                j = 3;
                            end
                        end
                        
                    end
                    else if(yaz_adres < 22500) begin
                        if(yaz_adres < 1) begin
                        for(i=0; i<300; i=i+1) begin
                            for(j=0; j<300; j=j+1) begin
                               if(boyut == 2'b00 || boyut == 2'b11)  begin
                                if ((-cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0-
                                                          cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*4 - cerceveli_resim[i+3][j+4] -
                                                          cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 ) > 255)
                                    output_resim[i][j] = 255;
                                    else if((-cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0-
                                                          cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*4 - cerceveli_resim[i+3][j+4] -
                                                          cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 ) < 0)
                                                          output_resim[i][j] =0;
                                    else output_resim[i][j] = (-cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0-
                                                          cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*4 - cerceveli_resim[i+3][j+4] -
                                                          cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 );
                                                          
                                end
                                
                                else if(boyut == 2'b01)  begin
                                    if ((-cerceveli_resim[i+1][j+1]*0 - cerceveli_resim[i+1][j+2]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 -
                                                          cerceveli_resim[i+2][j+1]*0 - cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 -                                                         
                                                          cerceveli_resim[i+3][j+1] - cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*8 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] -
                                                          cerceveli_resim[i+4][j+1]*0 - cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 -
                                                          cerceveli_resim[i+5][j+1]*0 - cerceveli_resim[i+5][j+2]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0) > 255)
                                    output_resim[i][j] = 255;
                                    else if((-cerceveli_resim[i+1][j+1]*0 - cerceveli_resim[i+1][j+2]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 -
                                                          cerceveli_resim[i+2][j+1]*0 - cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 -                                                         
                                                          cerceveli_resim[i+3][j+1] - cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*8 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] -
                                                          cerceveli_resim[i+4][j+1]*0 - cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 -
                                                          cerceveli_resim[i+5][j+1]*0 - cerceveli_resim[i+5][j+2]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0) < 0)
                                                          output_resim[i][j] =0;
                                    else
                                    output_resim[i][j] = (-cerceveli_resim[i+1][j+1]*0 - cerceveli_resim[i+1][j+2]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 -
                                                          cerceveli_resim[i+2][j+1]*0 - cerceveli_resim[i+2][j+2]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 -                                                         
                                                          cerceveli_resim[i+3][j+1] - cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3]*8 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] -
                                                          cerceveli_resim[i+4][j+1]*0 - cerceveli_resim[i+4][j+2]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 -
                                                          cerceveli_resim[i+5][j+1]*0 - cerceveli_resim[i+5][j+2]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0);
                                end                         
                                
                                else if(boyut == 2'b10)  begin
                                    if ((-cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+2]*0 - cerceveli_resim[i][j+3] - cerceveli_resim[i][j+4]*0 - cerceveli_resim[i][j+5]*0 - cerceveli_resim[i][j+6]*0 -
                                                         cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 - cerceveli_resim[i+1][j+6]*0 -                                                         
                                                         cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 - cerceveli_resim[i+2][j+6]*0 -
                                                         cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+3]*12 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] - cerceveli_resim[i+3][j+6] -
                                                         cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 - cerceveli_resim[i+4][j+6]*0 -
                                                         cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0 - cerceveli_resim[i+5][j+6]*0 -
                                                         cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3] - cerceveli_resim[i+6][j+4]*0 - cerceveli_resim[i+6][j+5]*0 - cerceveli_resim[i+6][j+6]*0) > 255)
                                        output_resim[i][j] = 255;
                                    else if((-cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+2]*0 - cerceveli_resim[i][j+3] - cerceveli_resim[i][j+4]*0 - cerceveli_resim[i][j+5]*0 - cerceveli_resim[i][j+6]*0 -
                                                         cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 - cerceveli_resim[i+1][j+6]*0 -                                                         
                                                         cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 - cerceveli_resim[i+2][j+6]*0 -
                                                         cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+3]*12 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] - cerceveli_resim[i+3][j+6] -
                                                         cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 - cerceveli_resim[i+4][j+6]*0 -
                                                         cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0 - cerceveli_resim[i+5][j+6]*0 -
                                                         cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3] - cerceveli_resim[i+6][j+4]*0 - cerceveli_resim[i+6][j+5]*0 - cerceveli_resim[i+6][j+6]*0)< 0)
                                                          output_resim[i][j] =0;
                                    else
                                        output_resim[i][j] =(-cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+3]*0 - cerceveli_resim[i][j+2]*0 - cerceveli_resim[i][j+3] - cerceveli_resim[i][j+4]*0 - cerceveli_resim[i][j+5]*0 - cerceveli_resim[i][j+6]*0 -
                                                         cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3]*0 - cerceveli_resim[i+1][j+3] - cerceveli_resim[i+1][j+4]*0 - cerceveli_resim[i+1][j+5]*0 - cerceveli_resim[i+1][j+6]*0 -                                                         
                                                         cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3]*0 - cerceveli_resim[i+2][j+3] - cerceveli_resim[i+2][j+4]*0 - cerceveli_resim[i+2][j+5]*0 - cerceveli_resim[i+2][j+6]*0 -
                                                         cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] - cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+3]*12 - cerceveli_resim[i+3][j+4] - cerceveli_resim[i+3][j+5] - cerceveli_resim[i+3][j+6] -
                                                         cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3]*0 - cerceveli_resim[i+4][j+3] - cerceveli_resim[i+4][j+4]*0 - cerceveli_resim[i+4][j+5]*0 - cerceveli_resim[i+4][j+6]*0 -
                                                         cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3]*0 - cerceveli_resim[i+5][j+3] - cerceveli_resim[i+5][j+4]*0 - cerceveli_resim[i+5][j+5]*0 - cerceveli_resim[i+5][j+6]*0 -
                                                         cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3]*0 - cerceveli_resim[i+6][j+3] - cerceveli_resim[i+6][j+4]*0 - cerceveli_resim[i+6][j+5]*0 - cerceveli_resim[i+6][j+6]*0);
                                end 
                            end
                        end                       
                        i=0;
                        j=0;
                        end

                        
                        yaz_gecerli = 1;
                        
                        yaz_veri[7-:8] = output_resim[i][j];
                        yaz_veri[15-:8] = output_resim[i][j+1];
                        yaz_veri[23-:8] = output_resim[i][j+2];
                        yaz_veri[31-:8] = output_resim[i][j+3];
                        
                        j=j+4;
                        yaz_adres_n = yaz_adres + 1;
                        if(yaz_adres_n % 75 == 0) begin
                            i = i + 1;
                            j = 0;
                        end
                    end
                    else yaz_gecerli = 0;
                
                end
                3'b011  : begin //Kutu bulanýklaþtýrma
                    if(oku_adres < 22501)begin
                        oku_adres_n = oku_adres + 1;
                        if(oku_adres != 0) begin
                            cerceveli_resim[i][j] = oku_veri[7-:8];
                            cerceveli_resim[i][j+1] = oku_veri[15-:8];
                            cerceveli_resim[i][j+2] = oku_veri[23-:8];
                            cerceveli_resim[i][j+3] = oku_veri[31-:8];
                            j = j + 4;
                            if(oku_adres % 75 == 0) begin
                                i = i + 1;
                                j = 3;
                            end
                        end
                        
                    end
                    else if(yaz_adres < 22500) begin
                        if(yaz_adres < 1) begin
                        for(i=0; i<300; i=i+1) begin
                            for(j=0; j<300; j=j+1) begin
                                if(boyut == 2'b00 || boyut == 2'b11)  begin
                                    output_resim[i][j] = (cerceveli_resim[i+2][j+2] + cerceveli_resim[i+2][j+3] + cerceveli_resim[i+2][j+4] +
                                                          cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+4] +
                                                          cerceveli_resim[i+4][j+2] + cerceveli_resim[i+4][j+3] + cerceveli_resim[i+4][j+4])/9;
                                                          
                                end
                                
                                else if(boyut == 2'b01)  begin
                                    output_resim[i][j] = (cerceveli_resim[i+1][j+1] + cerceveli_resim[i+1][j+2] + cerceveli_resim[i+1][j+3] + cerceveli_resim[i+1][j+4] + cerceveli_resim[i+1][j+5] +
                                                          cerceveli_resim[i+2][j+1] + cerceveli_resim[i+2][j+2] + cerceveli_resim[i+2][j+3] + cerceveli_resim[i+2][j+4] + cerceveli_resim[i+2][j+5] +                                                         
                                                          cerceveli_resim[i+3][j+1] + cerceveli_resim[i+3][j+2] + cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+4] + cerceveli_resim[i+3][j+5] +
                                                          cerceveli_resim[i+4][j+1] + cerceveli_resim[i+4][j+2] + cerceveli_resim[i+4][j+3] + cerceveli_resim[i+4][j+4] + cerceveli_resim[i+4][j+5] +
                                                          cerceveli_resim[i+5][j+1] + cerceveli_resim[i+5][j+2] + cerceveli_resim[i+5][j+3] + cerceveli_resim[i+5][j+4] + cerceveli_resim[i+5][j+5])/25;
                                end                         
                                
                                else if(boyut == 2'b10)  begin
                                    output_resim[i][j] =(cerceveli_resim[i][j+3] + cerceveli_resim[i][j+3] + cerceveli_resim[i][j+2] + cerceveli_resim[i][j+3] + cerceveli_resim[i][j+4] + cerceveli_resim[i][j+5] + cerceveli_resim[i][j+6] +
                                                         cerceveli_resim[i+1][j+3] + cerceveli_resim[i+1][j+3] + cerceveli_resim[i+1][j+3] + cerceveli_resim[i+1][j+3] + cerceveli_resim[i+1][j+4] + cerceveli_resim[i+1][j+5] + cerceveli_resim[i+1][j+6] +                                                         
                                                         cerceveli_resim[i+2][j+3] + cerceveli_resim[i+2][j+3] + cerceveli_resim[i+2][j+3] + cerceveli_resim[i+2][j+3] + cerceveli_resim[i+2][j+4] + cerceveli_resim[i+2][j+5] + cerceveli_resim[i+2][j+6] +
                                                         cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+3] + cerceveli_resim[i+3][j+4] + cerceveli_resim[i+3][j+5] + cerceveli_resim[i+3][j+6] +
                                                         cerceveli_resim[i+4][j+3] + cerceveli_resim[i+4][j+3] + cerceveli_resim[i+4][j+3] + cerceveli_resim[i+4][j+3] + cerceveli_resim[i+4][j+4] + cerceveli_resim[i+4][j+5] + cerceveli_resim[i+4][j+6] +
                                                         cerceveli_resim[i+5][j+3] + cerceveli_resim[i+5][j+3] + cerceveli_resim[i+5][j+3] + cerceveli_resim[i+5][j+3] + cerceveli_resim[i+5][j+4] + cerceveli_resim[i+5][j+5] + cerceveli_resim[i+5][j+6] +
                                                         cerceveli_resim[i+6][j+3] + cerceveli_resim[i+6][j+3] + cerceveli_resim[i+6][j+3] + cerceveli_resim[i+6][j+3] + cerceveli_resim[i+6][j+4] + cerceveli_resim[i+6][j+5] + cerceveli_resim[i+6][j+6])/49;
                                end 
                            end
                        end                       
                        i=0;
                        j=0;
                        end

                        
                        yaz_gecerli = 1;
                        
                        yaz_veri[7-:8] = output_resim[i][j];
                        yaz_veri[15-:8] = output_resim[i][j+1];
                        yaz_veri[23-:8] = output_resim[i][j+2];
                        yaz_veri[31-:8] = output_resim[i][j+3];
                        
                        j=j+4;
                        yaz_adres_n = yaz_adres + 1;
                        if(yaz_adres_n % 75 == 0) begin
                            i = i + 1;
                            j = 0;
                        end
                    end
                    else yaz_gecerli = 0;
                end
                3'b100  : begin //Gaussian bulanýklaþtýrma
                   if(oku_adres < 22501)begin
                        oku_adres_n = oku_adres + 1;
                        if(oku_adres != 0) begin
                            cerceveli_resim[i][j] = oku_veri[7-:8];
                            cerceveli_resim[i][j+1] = oku_veri[15-:8];
                            cerceveli_resim[i][j+2] = oku_veri[23-:8];
                            cerceveli_resim[i][j+3] = oku_veri[31-:8];
                        j = j + 4;
                        if(oku_adres % 75 == 0) begin
                            i = i + 1;
                            j = 3;
                        end
                        end
                    end
                    else if(yaz_adres < 22500) begin
                        if(yaz_adres < 1) begin
                        for(i=0; i<300; i=i+1) begin
                            for(j=0; j<300; j=j+1) begin
                                if(boyut == 2'b00 || boyut == 2'b11)  begin
                                    output_resim[i][j] = (cerceveli_resim[i+2][j+2] + cerceveli_resim[i+2][j+3]*2 + cerceveli_resim[i+2][j+4] +
                                                          cerceveli_resim[i+3][j+2]*2 + cerceveli_resim[i+3][j+3]*4 + cerceveli_resim[i+3][j+4]*2 +
                                                          cerceveli_resim[i+4][j+2] + cerceveli_resim[i+4][j+3]*2 + cerceveli_resim[i+4][j+4])/16;
                                end
                                
                                else if(boyut == 2'b01)  begin
                                    output_resim[i][j] = (cerceveli_resim[i+1][j+1] + cerceveli_resim[i+1][j+2]*4 + cerceveli_resim[i+1][j+3]*7 + cerceveli_resim[i+1][j+4]*4 + cerceveli_resim[i+1][j+5] +
                                                          cerceveli_resim[i+2][j+1]*4 + cerceveli_resim[i+2][j+2]*16 + cerceveli_resim[i+2][j+3]*26 + cerceveli_resim[i+2][j+4]*16 + cerceveli_resim[i+2][j+5]*4 +                                                         
                                                          cerceveli_resim[i+3][j+1]*7 + cerceveli_resim[i+3][j+2]*26 + cerceveli_resim[i+3][j+3]*41 + cerceveli_resim[i+3][j+4]*26 + cerceveli_resim[i+3][j+5]*7 +
                                                          cerceveli_resim[i+4][j+1]*4 + cerceveli_resim[i+4][j+2]*16 + cerceveli_resim[i+4][j+3]*26 + cerceveli_resim[i+4][j+4]*16 + cerceveli_resim[i+4][j+5]*4 +
                                                          cerceveli_resim[i+5][j+1] + cerceveli_resim[i+5][j+2]*4 + cerceveli_resim[i+5][j+3]*7 + cerceveli_resim[i+5][j+4]*4 + cerceveli_resim[i+5][j+5])/273;
                                end                         
                                
                                else if(boyut == 2'b10)  begin
                                    output_resim[i][j] =(cerceveli_resim[i][j]*0 + cerceveli_resim[i][j+1]*0 + cerceveli_resim[i][j+2] + cerceveli_resim[i][j+3]*2 + cerceveli_resim[i][j+4] + cerceveli_resim[i][j+5]*0 + cerceveli_resim[i][j+6]*0 +
                                                         cerceveli_resim[i+1][j]*0 + cerceveli_resim[i+1][j+1]*3 + cerceveli_resim[i+1][j+2]*13 + cerceveli_resim[i+1][j+3]*22 + cerceveli_resim[i+1][j+4]*13 + cerceveli_resim[i+1][j+5]*3 + cerceveli_resim[i+1][j+6]*0 +                                                         
                                                         cerceveli_resim[i+2][j] + cerceveli_resim[i+2][j+1]*13 + cerceveli_resim[i+2][j+2]*59 + cerceveli_resim[i+2][j+3]*97 + cerceveli_resim[i+2][j+4]*59 + cerceveli_resim[i+2][j+5]*13 + cerceveli_resim[i+2][j+6] +
                                                         cerceveli_resim[i+3][j]*2 + cerceveli_resim[i+3][j+1]*22 + cerceveli_resim[i+3][j+2]*97 + cerceveli_resim[i+3][j+3]*159 + cerceveli_resim[i+3][j+4]*97 + cerceveli_resim[i+3][j+5]*22 + cerceveli_resim[i+3][j+6]*2 +
                                                         cerceveli_resim[i+4][j] + cerceveli_resim[i+4][j+1]*13 + cerceveli_resim[i+4][j+2]*59 + cerceveli_resim[i+4][j+3]*97 + cerceveli_resim[i+4][j+4]*59 + cerceveli_resim[i+4][j+5]*13 + cerceveli_resim[i+4][j+6] +
                                                         cerceveli_resim[i+5][j]*0 + cerceveli_resim[i+5][j+1]*3 + cerceveli_resim[i+5][j+2]*13 + cerceveli_resim[i+5][j+3]*22 + cerceveli_resim[i+5][j+4]*13 + cerceveli_resim[i+5][j+5]*3 + cerceveli_resim[i+5][j+6]*0 +
                                                         cerceveli_resim[i+6][j]*0 + cerceveli_resim[i+6][j+1]*0 + cerceveli_resim[i+6][j+2] + cerceveli_resim[i+6][j+3]*2 + cerceveli_resim[i+6][j+4] + cerceveli_resim[i+6][j+5]*0 + cerceveli_resim[i+6][j+6]*0)/1003;
                                end 
                            end
                        end
                        i=0;
                        j=0;
                        end
                        
                        yaz_gecerli = 1;

                        yaz_veri[7-:8] = output_resim[i][j];
                        yaz_veri[15-:8] = output_resim[i][j+1];
                        yaz_veri[23-:8] = output_resim[i][j+2];
                        yaz_veri[31-:8] = output_resim[i][j+3];
                        j=j+4;
                        yaz_adres_n = yaz_adres + 1;
                        if(yaz_adres_n % 75 == 0) begin
                            i = i + 1;
                            j = 0;
                        end
                    end
                    else yaz_gecerli = 0;
                end 
                 3'b101  : begin //Siyah/Beyaz dönüþüm
                    $display("Elif"); 
                    if(oku_adres !=0)begin     
                        yaz_gecerli=1;
                        yaz_adres_n=yaz_adres+1;
                        if(oku_veri[31-:8] < 125) begin
                            yaz_veri[31-:8]=0;                       
                        end else begin
                            yaz_veri[31-:8]=255;
                        end
                        if(oku_veri[23-:8] < 125) begin
                            yaz_veri[23-:8]=0;                       
                        end else begin
                            yaz_veri[23-:8]=255;
                        end
                        if(oku_veri[15-:8] < 125) begin
                            yaz_veri[15-:8]=0;                       
                        end else begin
                            yaz_veri[15-:8]=255;
                        end
                        if(oku_veri[7-:8] < 125) begin
                            yaz_veri[7-:8]=0;                       
                        end else begin
                            yaz_veri[7-:8]=255;
                        end 
                    end
                    oku_adres_n = oku_adres+1;
              end
              3'b110  : begin //Dikey eksene göre simetri
                yardimci_piksel=oku_veri[31:24];
                yaz_veri[31:24]=oku_veri[7:0];
                yaz_veri[7:0]=yardimci_piksel;
                
                yardimci_piksel2=oku_veri[15:8];
                yaz_veri[15:8]=oku_veri[23:16];
                yaz_veri[23:16]=yardimci_piksel2;
                yaz_adres = m - (okunan_adres-1 );
                okunacak_adres=okunan_adres + 1;
                if((okunan_adres) % 75 ==0 && okunan_adres !=0 )
                    m=m+150;
                if(okunan_adres == 0)
                    yaz_gecerli=0;
                else
                    yaz_gecerli=1;  
              end
              3'b111  : begin //Yatay eksene göre simetri
                yaz_veri=oku_veri;
                yaz_adres = l + ((okunan_adres-1) - k*75); 
                if((okunan_adres) % 75 == 0 && okunan_adres !=0 )begin
                    l=l-75;
                    k=k+1;
                end
                okunacak_adres=okunan_adres + 1;
                if(okunan_adres == 0)
                    yaz_gecerli=0;
                else
                    yaz_gecerli=1;   
              end
            endcase
        end
    end
    
    always@(posedge clk) begin
        if(rst) begin
            okunan_adres<=16'd0;
            okunacak_adres<=16'd0;
            yaz_adres <= 0;
            oku_adres <= 0;
            yaz_veri <= 0;
            yaz_gecerli <= 0;
            i=3;
            j=3;
        end
        else begin
            okunan_adres<=okunacak_adres;
            oku_adres<=okunacak_adres;
            if(islem != 3'b110 && islem != 3'b111)begin
            yaz_adres <= yaz_adres_n;
            oku_adres <= oku_adres_n;
            end

        end
    end
  
endmodule