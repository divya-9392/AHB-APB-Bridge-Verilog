module ahb_slave_interface_tb;

reg Hclk;
reg Hresetn;
reg Hwrite;
reg Hreadyin;
reg [1:0] Htrans;
reg [31:0] Haddr;
reg [31:0] Hwdata;
reg [31:0] Prdata;

wire valid;
wire [31:0] Haddr1;
wire [31:0] Haddr2;
wire [31:0] Hwdata1;
wire [31:0] Hwdata2;
wire Hwritereg;
wire Hwritereg1;
wire [2:0] tempselx;
wire [1:0] Hresp;
wire [31:0] Hrdata;

ahb_slave_interface DUT(
    Hclk,Hresetn,Hwrite,Hreadyin,Htrans,
    Haddr,Hwdata,Prdata,
    valid,Haddr1,Haddr2,
    Hwdata1,Hwdata2,
    Hwritereg,Hwritereg1,
    tempselx,Hresp,Hrdata
);

initial
begin
    Hclk = 0;
    forever #5 Hclk = ~Hclk;
end

initial
begin

    Hresetn = 0;
    Hwrite = 0;
    Hreadyin = 0;
    Htrans = 2'b00;
    Haddr = 0;
    Hwdata = 0;
    Prdata = 32'h12345678;

    #20;

    Hresetn = 1;

    Hreadyin = 1;
    Hwrite = 1;
    Htrans = 2'b10;

    Haddr = 32'h80000010;
    Hwdata = 32'hAAAAAAAA;

    #20;

    Haddr = 32'h84000020;
    Hwdata = 32'hBBBBBBBB;

    #20;

    Haddr = 32'h88000030;
    Hwdata = 32'hCCCCCCCC;

    #20;

    Hwrite = 0;

    #50;

    $stop;

end

endmodule