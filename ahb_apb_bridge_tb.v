`timescale 1ns/1ps

module ahb_apb_bridge_tb;

reg Hclk;
reg Hresetn;

reg Hwrite;
reg Hreadyin;

reg [1:0] Htrans;

reg [31:0] Haddr;
reg [31:0] Hwdata;

reg [31:0] Prdata;

wire [1:0] Hresp;
wire [31:0] Hrdata;

wire Hreadyout;

wire Pwrite;
wire Penable;

wire [2:0] Pselx;

wire [31:0] Paddr;
wire [31:0] Pwdata;


// DUT

ahb_apb_bridge DUT(

.Hclk(Hclk),
.Hresetn(Hresetn),

.Hwrite(Hwrite),
.Hreadyin(Hreadyin),

.Htrans(Htrans),

.Haddr(Haddr),
.Hwdata(Hwdata),

.Prdata(Prdata),

.Hresp(Hresp),
.Hrdata(Hrdata),

.Hreadyout(Hreadyout),

.Pwrite(Pwrite),
.Penable(Penable),

.Pselx(Pselx),

.Paddr(Paddr),
.Pwdata(Pwdata)

);


// Clock

always #5 Hclk = ~Hclk;


// Stimulus

initial
begin

Hclk = 0;
Hresetn = 0;

Hwrite = 0;
Hreadyin = 1;

Htrans = 2'b00;

Haddr = 0;
Hwdata = 0;

Prdata = 32'h12345678;

#20;
Hresetn = 1;


// READ

#10;

Haddr = 32'h80000010;
Hwrite = 0;
Htrans = 2'b10;

#20;


// WRITE

Haddr = 32'h80000020;
Hwdata = 32'hAAAAAAAA;

Hwrite = 1;
Htrans = 2'b10;

#20;


// BURST WRITE

Haddr = 32'h80000024;
Hwdata = 32'h11111111;

#10;

Haddr = 32'h80000028;
Hwdata = 32'h22222222;

#10;

Haddr = 32'h8000002C;
Hwdata = 32'h33333333;

#10;

Haddr = 32'h80000030;
Hwdata = 32'h44444444;

#50;

$stop;

end

endmodule