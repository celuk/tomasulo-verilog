`timescale 1ns / 1ps

module yurutucu (
    input saat, // saat girisi
    input [1:0] ky1, // islem icin kullanilacak ilk kaynak yazmaci
    input [1:0] ky2, // islem icin kullanilacak ikinci kaynak yazmaci
    input [1:0] hy, // islem sonucunun yazilacagi hedef yazmaci
    input islem, // 1'b0 ise carpma, 1'b1 ise toplama
    input bitir, // sistemin calismasini durduracak sinyal
    output bitti, //sistemin islemlerini bitirdigini belirten cikis sinyali
    output [127:0] yazmac_degerleri // {r0,r1,r2,r3} yazmaclarinin sirayla yerlestirerek degerini disari veren sinyal
);

reg beklemeler_bitti;
assign bitti = bitir & beklemeler_bitti; //bitir && beklemeler_bitti;

reg [31:0] r0_deger;
reg [31:0] r1_deger;
reg [31:0] r2_deger;
reg [31:0] r3_deger;

assign yazmac_degerleri = {r0_deger, r1_deger, r2_deger, r3_deger};

reg YAT_gecerli [3:0];
reg [3:0] YAT_etiket [3:0];
reg [31:0] YAT_deger [3:0];

reg tbba_satir_sayac [7:0];

reg tbba_satir_dolu [7:0];

reg tbba_gecerli_ky1 [7:0];
reg [3:0] tbba_etiket_ky1 [7:0];
reg [31:0] tbba_deger_ky1 [7:0];

reg tbba_gecerli_ky2 [7:0];
reg [3:0] tbba_etiket_ky2 [7:0];
reg [31:0] tbba_deger_ky2 [7:0];

reg [1:0] cbba_satir_sayac [7:0];

reg cbba_satir_dolu [7:0];

reg cbba_gecerli_ky1 [7:0];
reg [3:0] cbba_etiket_ky1 [7:0];
reg [31:0] cbba_deger_ky1 [7:0];

reg cbba_gecerli_ky2 [7:0];
reg [3:0] cbba_etiket_ky2 [7:0];
reg [31:0] cbba_deger_ky2 [7:0];

integer i = 0;
integer j = 0;

integer bos_satir_no = 0;

initial begin
    beklemeler_bitti = 1;

    r0_deger = 1;
    r1_deger = 1;
    r2_deger = 1;
    r3_deger = 1;

    YAT_gecerli[0] = 1;
    YAT_gecerli[1] = 1;
    YAT_gecerli[2] = 1;
    YAT_gecerli[3] = 1;

    YAT_etiket[0] = 0;
    YAT_etiket[1] = 0;
    YAT_etiket[2] = 0;
    YAT_etiket[3] = 0;

    YAT_deger[0] = 1;
    YAT_deger[1] = 1;
    YAT_deger[2] = 1;
    YAT_deger[3] = 1;

    for(i = 0; i < 8; i = i + 1) begin
        tbba_satir_sayac[i] = 0;

        tbba_satir_dolu[i] = 0;
        
        tbba_gecerli_ky1[i] = 0;
        tbba_etiket_ky1[i] = 0;
        tbba_deger_ky1[i] = 0;
        tbba_gecerli_ky2[i] = 0;
        tbba_etiket_ky2[i] = 0;
        tbba_deger_ky2[i] = 0;

        cbba_satir_sayac[i] = 0;

        cbba_satir_dolu[i] = 0;
        
        cbba_gecerli_ky1[i] = 0;
        cbba_etiket_ky1[i] = 0;
        cbba_deger_ky1[i] = 0;
        cbba_gecerli_ky2[i] = 0;
        cbba_etiket_ky2[i] = 0;
        cbba_deger_ky2[i] = 0;
    end
end



always @* begin

    if(!bitti) begin
        // ETIKETLER
        for(i = 0; i < 8; i = i + 1) begin
            // TBBA ETIKETLER
            if(tbba_satir_dolu[i] && tbba_satir_sayac[i] && tbba_gecerli_ky1[i] && tbba_gecerli_ky2[i]) begin
                for(j = 0; j < 8; j = j + 1) begin
                    if(tbba_satir_dolu[j] == 1 && tbba_gecerli_ky1[j] == 0 && tbba_etiket_ky1[j] == i) begin
                        tbba_deger_ky1[j] = tbba_deger_ky1[i] + tbba_deger_ky2[i];
                        tbba_gecerli_ky1[j] = 1;
                    end
                    if(tbba_satir_dolu[j] == 1 && tbba_gecerli_ky2[j] == 0 && tbba_etiket_ky2[j] == i) begin
                        tbba_deger_ky2[j] = tbba_deger_ky1[i] + tbba_deger_ky2[i];
                        tbba_gecerli_ky2[j] = 1;
                    end
                    if(cbba_satir_dolu[j] == 1 && cbba_gecerli_ky1[j] == 0 && cbba_etiket_ky1[j] == i) begin
                        cbba_deger_ky1[j] = tbba_deger_ky1[i] + tbba_deger_ky2[i];
                        cbba_gecerli_ky1[j] = 1;
                    end
                    if(cbba_satir_dolu[j] == 1 && cbba_gecerli_ky2[j] == 0 && cbba_etiket_ky2[j] == i) begin
                        cbba_deger_ky2[j] = tbba_deger_ky1[i] + tbba_deger_ky2[i];
                        cbba_gecerli_ky2[j] = 1;
                    end
                end

                for (j = 0; j < 4; j = j + 1) begin
                    if(!YAT_gecerli[j] && YAT_etiket[j] == i) begin
                        YAT_deger[j] = tbba_deger_ky1[i] + tbba_deger_ky2[i];
                        YAT_gecerli[j] = 1;
                        
                        if(YAT_gecerli[0] == 1) r0_deger = YAT_deger[0];
                        if(YAT_gecerli[1] == 1) r1_deger = YAT_deger[1];
                        if(YAT_gecerli[2] == 1) r2_deger = YAT_deger[2];
                        if(YAT_gecerli[3] == 1) r3_deger = YAT_deger[3];
                    end
                end

                tbba_satir_dolu[i] = 0;
                tbba_gecerli_ky1[i] = 0;
                tbba_gecerli_ky2[i] = 0;
                tbba_satir_sayac[i] = 0;
            end

            // CBBA ETIKETLER
            if(cbba_satir_dolu[i] && cbba_satir_sayac[i] == 2 && cbba_gecerli_ky1[i] && cbba_gecerli_ky2[i]) begin
                for(j = 0; j < 8; j = j + 1) begin
                    if(tbba_satir_dolu[j] == 1 && tbba_gecerli_ky1[j] == 0 && tbba_etiket_ky1[j] == i + 8) begin
                        tbba_deger_ky1[j] = cbba_deger_ky1[i] * cbba_deger_ky2[i];
                        tbba_gecerli_ky1[j] = 1;
                    end
                    if(tbba_satir_dolu[j] == 1 && tbba_gecerli_ky2[j] == 0 && tbba_etiket_ky2[j] == i + 8) begin
                        tbba_deger_ky2[j] = cbba_deger_ky1[i] * cbba_deger_ky2[i];
                        tbba_gecerli_ky2[j] = 1;
                    end
                    if(cbba_satir_dolu[j] == 1 && cbba_gecerli_ky1[j] == 0 && cbba_etiket_ky1[j] == i + 8) begin
                        cbba_deger_ky1[j] = cbba_deger_ky1[i] * cbba_deger_ky2[i];
                        cbba_gecerli_ky1[j] = 1;
                    end
                    if(cbba_satir_dolu[j] == 1 && cbba_gecerli_ky2[j] == 0 && cbba_etiket_ky2[j] == i + 8) begin
                        cbba_deger_ky2[j] = cbba_deger_ky1[i] * cbba_deger_ky2[i];
                        cbba_gecerli_ky2[j] = 1;
                    end
                end

                for (j = 0; j < 4; j = j + 1) begin
                    if(!YAT_gecerli[j] && YAT_etiket[j] == i + 8) begin
                        YAT_deger[j] = cbba_deger_ky1[i] * cbba_deger_ky2[i];
                        YAT_gecerli[j] = 1;
                        
                        if(YAT_gecerli[0] == 1) r0_deger = YAT_deger[0];
                        if(YAT_gecerli[1] == 1) r1_deger = YAT_deger[1];
                        if(YAT_gecerli[2] == 1) r2_deger = YAT_deger[2];
                        if(YAT_gecerli[3] == 1) r3_deger = YAT_deger[3];
                    end
                end

                cbba_satir_dolu[i] = 0;
                cbba_gecerli_ky1[i] = 0;
                cbba_gecerli_ky2[i] = 0;
                cbba_satir_sayac[i] = 0;
            end
        end

        i = 0;
    end
end

always @(posedge saat) begin
    i = 0;

    // BEKLEMELER BITTI FLAGI
    if(!tbba_satir_dolu[0] && !tbba_satir_dolu[1] && !tbba_satir_dolu[2] && !tbba_satir_dolu[3]
    && !tbba_satir_dolu[4] && !tbba_satir_dolu[5] && !tbba_satir_dolu[6] && !tbba_satir_dolu[7]
    && !cbba_satir_dolu[0] && !cbba_satir_dolu[1] && !cbba_satir_dolu[2] && !cbba_satir_dolu[3]
    && !cbba_satir_dolu[4] && !cbba_satir_dolu[5] && !cbba_satir_dolu[6] && !cbba_satir_dolu[7])
        beklemeler_bitti = 1;
    else
        beklemeler_bitti = 0;

    if(!bitti) begin
        // TBBAlarin atanmasi
        if(islem) begin
            while(tbba_satir_dolu[i]) begin
                i = i + 1;
            end
            bos_satir_no = i;
            i = 0;

            if(bos_satir_no < 8) begin // elsei yok
                // tbba KY1
                if(YAT_gecerli[ky1]) begin
                    tbba_deger_ky1[bos_satir_no] = YAT_deger[ky1];
                    tbba_gecerli_ky1[bos_satir_no] = 1;
                end
                else begin
                    tbba_etiket_ky1[bos_satir_no] = YAT_etiket[ky1];
                    tbba_gecerli_ky1[bos_satir_no] = 0;
                end

                // tbba KY2
                if(YAT_gecerli[ky2]) begin
                    tbba_deger_ky2[bos_satir_no] = YAT_deger[ky2];
                    tbba_gecerli_ky2[bos_satir_no] = 1;
                end
                else begin
                    tbba_etiket_ky2[bos_satir_no] = YAT_etiket[ky2];
                    tbba_gecerli_ky2[bos_satir_no] = 0;
                end

                tbba_satir_dolu[bos_satir_no] = 1;
            end
        end
        // CBBAlarin atanmasi
        else begin
            while(cbba_satir_dolu[i]) begin
                i = i + 1;
            end
            bos_satir_no = i;

            if(bos_satir_no < 8) begin // elsei yok
                // cbba KY1
                if(YAT_gecerli[ky1]) begin
                    cbba_deger_ky1[bos_satir_no] = YAT_deger[ky1];
                    cbba_gecerli_ky1[bos_satir_no] = 1;
                end
                else begin
                    cbba_etiket_ky1[bos_satir_no] = YAT_etiket[ky1];
                    cbba_gecerli_ky1[bos_satir_no] = 0;
                end

                // cbba KY2
                if(YAT_gecerli[ky2]) begin
                    cbba_deger_ky2[bos_satir_no] = YAT_deger[ky2];
                    cbba_gecerli_ky2[bos_satir_no] = 1;
                end
                else begin
                    cbba_etiket_ky2[bos_satir_no] = YAT_etiket[ky2];
                    cbba_gecerli_ky2[bos_satir_no] = 0;
                end

                cbba_satir_dolu[bos_satir_no] = 1;
            end
        end

        if(YAT_gecerli[hy]) begin // elsei yok // bu isleme gore ayrılabilir
            YAT_gecerli[hy] = 0;
            YAT_etiket[hy] = bos_satir_no;
            if(!islem) YAT_etiket[hy] = bos_satir_no + 8;
        end

        // SAYACLARIN ARTTIRILMASI
        for(i = 0; i < 8; i = i + 1) begin
            if(tbba_satir_dolu[i]) begin
                if(tbba_satir_sayac[i] < 1) begin
                    tbba_satir_sayac[i] = tbba_satir_sayac[i] + 1;
                end
            end

            if(cbba_satir_dolu[i]) begin
                if(cbba_satir_sayac[i] < 2) begin
                    cbba_satir_sayac[i] = cbba_satir_sayac[i] + 1;
                end
            end
        end
    end
end

endmodule
