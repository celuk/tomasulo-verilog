`timescale 1ns / 1ps

module tb_yurutucu ();

// print fonksiyonu
function disp_op;
    input islem;
    input [1:0] ky1;
    input [1:0] ky2;
    input [1:0] hy;
    begin
        // e.g. ADD R2 <-- R0, R1
        if(islem)
            $display("ADD R%d <-- R%d, R%d", hy, ky1, ky2);
        else 
            $display("MUL R%d <-- R%d, R%d", hy, ky1, ky2);
            
        disp_op = 0;
    end
endfunction

function disp_vals;
    input [31:0] r0_deger;
    input [31:0] r1_deger;
    input [31:0] r2_deger;
    input [31:0] r3_deger;
    begin
        $display("r0: %d, r1: %d, r2: %d, r3: %d", r0_deger, r1_deger, r2_deger, r3_deger);
        
        disp_vals = 0;
    end
endfunction

function is_passed;
    input [31:0] r0_deger;
    input [31:0] r1_deger;
    input [31:0] r2_deger;
    input [31:0] r3_deger;
    input [31:0] r0_deger_istenen;
    input [31:0] r1_deger_istenen;
    input [31:0] r2_deger_istenen;
    input [31:0] r3_deger_istenen;
    begin
        if(r2_deger == r0_deger_istenen && r1_deger == r1_deger_istenen && r2_deger == r2_deger_istenen && r3_deger == r3_deger_istenen)
            $display("pass!");
        else 
            $display("FAIL!");
        is_passed = 0;
    end
endfunction

reg saat;
reg [1:0] ky1;
reg [1:0] ky2;
reg [1:0] hy;
reg islem;
reg bitir;
wire bitti;
//wire [127:0] yazmac_degerleri;
wire [31:0] r0_deger;
wire [31:0] r1_deger;
wire [31:0] r2_deger;
wire [31:0] r3_deger;

yurutucu uut(
            .saat(saat),
            .ky1(ky1),
            .ky2(ky2),
            .hy(hy),
            .islem(islem),
            .bitir(bitir),
            .bitti(bitti),
            .yazmac_degerleri({r0_deger, r1_deger, r2_deger, r3_deger})
);

always begin
    #5 saat = ~saat;
end

reg temp;

initial begin
    saat = 0;
    bitir = 0;

    // ADD R2 <-- R0, R1
    hy = 2; ky1 = 0; ky2 = 1; islem = 1;
    temp = disp_op(islem, ky1, ky2, hy);
    temp = disp_vals(r0_deger, r1_deger, r2_deger, r3_deger);
    #10;
    temp = is_passed(r0_deger, r1_deger, r2_deger, r3_deger, 1, 1, 1, 1);

    // MUL R0 <-- R2, R3
    hy = 0; ky1 = 2; ky2 = 3; islem = 0;
    temp = disp_op(islem, ky1, ky2, hy);
    temp = disp_vals(r0_deger, r1_deger, r2_deger, r3_deger);
    #10;
    bitir = 1;

    temp = is_passed(r0_deger, r1_deger, r2_deger, r3_deger, 1, 1, 2, 1);
    #10;
    
    temp = is_passed(r0_deger, r1_deger, r2_deger, r3_deger, 1, 1, 2, 1);
    #10;

    temp = is_passed(r0_deger, r1_deger, r2_deger, r3_deger, 2, 1, 2, 1);

    temp = disp_vals(r0_deger, r1_deger, r2_deger, r3_deger);

    if(bitti == 1)
        $display("pass!");
    else
        $display("FAIL!");
end

endmodule
