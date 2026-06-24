module ahb_slave_interface(
input Hclk,
input Hresetn,
input Hwrite,
input Hreadyin,
input [1:0] Htrans,
input [31:0] Haddr,
input [31:0] Hwdata,
input [31:0] Prdata,

output reg valid,
output reg [31:0] Haddr1,
output reg [31:0] Haddr2,
output reg [31:0] Hwdata1,
output reg [31:0] Hwdata2,
output reg Hwritereg,
output reg Hwritereg1,
output reg [2:0] tempselx,

output [1:0] Hresp,
output [31:0] Hrdata
);

assign Hresp = 2'b00;
assign Hrdata = Prdata;

always @(posedge Hclk)
begin
    if(!Hresetn)
    begin
        Haddr1 <= 32'd0;
        Haddr2 <= 32'd0;
    end
    else
    begin
        Haddr1 <= Haddr;
        Haddr2 <= Haddr1;
    end
end

always @(posedge Hclk)
begin
    if(!Hresetn)
    begin
        Hwdata1 <= 32'd0;
        Hwdata2 <= 32'd0;
    end
    else
    begin
        Hwdata1 <= Hwdata;
        Hwdata2 <= Hwdata1;
    end
end

always @(posedge Hclk)
begin
    if(!Hresetn)
    begin
        Hwritereg <= 1'b0;
        Hwritereg1 <= 1'b0;
    end
    else
    begin
        Hwritereg <= Hwrite;
        Hwritereg1 <= Hwritereg;
    end
end

always @(*)
begin
    if(Haddr >= 32'h80000000 && Haddr < 32'h84000000)
        tempselx = 3'b001;
    else if(Haddr >= 32'h84000000 && Haddr < 32'h88000000)
        tempselx = 3'b010;
    else if(Haddr >= 32'h88000000 && Haddr < 32'h8C000000)
        tempselx = 3'b100;
    else
        tempselx = 3'b000;
end

always @(*)
begin
    if((Haddr >= 32'h80000000 &&
        Haddr < 32'h8C000000) &&
        (Hreadyin == 1'b1) &&
        ((Htrans == 2'b10) || (Htrans == 2'b11)))
        valid = 1'b1;
    else
        valid = 1'b0;
end

endmodule