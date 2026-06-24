module ahb_apb_bridge(

input Hclk,
input Hresetn,

input Hwrite,
input Hreadyin,
input [1:0] Htrans,

input [31:0] Haddr,
input [31:0] Hwdata,

input [31:0] Prdata,

output [1:0] Hresp,
output [31:0] Hrdata,
output Hreadyout,

output Pwrite,
output Penable,
output [2:0] Pselx,
output [31:0] Paddr,
output [31:0] Pwdata

);


wire valid;

wire [31:0] Haddr1;
wire [31:0] Haddr2;

wire [31:0] Hwdata1;
wire [31:0] Hwdata2;

wire Hwritereg;
wire Hwritereg1;

wire [2:0] tempselx;


ahb_slave_interface AHB_Slave(

.Hclk(Hclk),
.Hresetn(Hresetn),

.Hwrite(Hwrite),
.Hreadyin(Hreadyin),

.Htrans(Htrans),

.Haddr(Haddr),
.Hwdata(Hwdata),

.Prdata(Prdata),

.valid(valid),

.Haddr1(Haddr1),
.Haddr2(Haddr2),

.Hwdata1(Hwdata1),
.Hwdata2(Hwdata2),

.Hwritereg(Hwritereg),
.Hwritereg1(Hwritereg1),

.tempselx(tempselx),

.Hresp(Hresp),
.Hrdata(Hrdata)

);

apb_controller APB_Controller(

.hclk(Hclk),
.hresetn(Hresetn),

.valid(valid),

.hwrite(Hwrite),
.hwritereg(Hwritereg),

.haddr(Haddr),
.hwdata(Hwdata),

.haddr1(Haddr1),
.haddr2(Haddr2),

.hwdata1(Hwdata1),
.hwdata2(Hwdata2),

.tempselx(tempselx),

.pwrite(Pwrite),
.penable(Penable),

.psel(Pselx),

.hreadyout(Hreadyout),

.pwdata(Pwdata),
.paddr(Paddr)

);

endmodule
