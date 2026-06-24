`timescale 1ns/1ps

module apb_controller_tb;

reg hclk;
reg hresetn;

reg valid;
reg hwrite;
reg hwritereg;

reg [31:0] haddr;
reg [31:0] hwdata;

reg [31:0] haddr1;
reg [31:0] haddr2;

reg [31:0] hwdata1;
reg [31:0] hwdata2;

reg [2:0] tempselx;

wire pwrite;
wire penable;
wire [2:0] psel;
wire hreadyout;

wire [31:0] pwdata;
wire [31:0] paddr;

apb_controller DUT(
    .hclk(hclk),
    .hresetn(hresetn),

    .valid(valid),
    .hwrite(hwrite),
    .hwritereg(hwritereg),

    .haddr(haddr),
    .hwdata(hwdata),

    .haddr1(haddr1),
    .haddr2(haddr2),

    .hwdata1(hwdata1),
    .hwdata2(hwdata2),

    .tempselx(tempselx),

    .pwrite(pwrite),
    .penable(penable),
    .psel(psel),
    .hreadyout(hreadyout),

    .pwdata(pwdata),
    .paddr(paddr)
);


always #5 hclk = ~hclk;



initial
begin


    hclk      = 0;
    hresetn   = 0;

    valid     = 0;
    hwrite    = 0;
    hwritereg = 0;

    haddr     = 0;
    hwdata    = 0;

    haddr1    = 0;
    haddr2    = 0;

    hwdata1   = 0;
    hwdata2   = 0;

    tempselx  = 3'b000;

  

    #20;
    hresetn = 1;

   
    #10;

    valid    = 1;
    hwrite   = 0;

    haddr    = 32'h80000010;
    tempselx = 3'b001;

    #20;

    valid = 0;

    #20;

    valid      = 1;
    hwrite     = 1;
    hwritereg  = 1;

    haddr1     = 32'h80000020;
    hwdata     = 32'h12345678;

    tempselx   = 3'b001;

    #20;

    valid = 0;

    #20;

    valid      = 1;
    hwrite     = 1;
    hwritereg  = 1;
    tempselx   = 3'b001;

    haddr1     = 32'h80000024;
    hwdata     = 32'hAAAAAAAA;

    #10;

    haddr1     = 32'h80000028;
    hwdata     = 32'hBBBBBBBB;

    #10;

    haddr1     = 32'h8000002C;
    hwdata     = 32'hCCCCCCCC;

    #10;

    haddr1     = 32'h80000030;
    hwdata     = 32'hDDDDDDDD;

    #20;

    valid = 0;


    #20;

    valid    = 1;
    hwrite   = 0;

    haddr    = 32'h84000010;
    tempselx = 3'b010;

    #20;

    valid = 0;


    #100;
    $stop;

end

endmodule
