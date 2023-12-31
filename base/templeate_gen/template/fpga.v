`default_nettype none

//Top template
module fpga (
 
	output wire [3:0] w_led,
	output wire [1:0] r_led, g_led, b_led,
	input wire syzygy_d0_p, syzygy_d0_n, syzygy_d1_p, syzygy_d1_n, syzygy_d2_p, syzygy_d2_n, syzygy_d3_p, syzygy_d3_n, syzygy_d4_p, syzygy_d4_n, syzygy_d5_p, syzygy_d5_n, syzygy_d6_p, syzygy_d6_n, syzygy_d7_p, syzygy_d7_n, 
	input wire syzygy_s16, syzygy_s17, syzygy_s18, syzygy_s19, syzygy_s20, syzygy_s21, syzygy_s22, syzygy_s23, syzygy_s24, syzygy_s25, syzygy_s26, syzygy_s27, 
	input wire syzygy_p2c_clk_p,
	input wire syzygy_p2c_clk_n,
	output wire syzygy_c2p_clk_p,
	output wire syzygy_c2p_clk_n
);



wire mpsoc_clk_100;
//HPM0_FPD signals
wire  [39:0] HPM0_FPD_M00_axil_araddr;
wire  [2:0] HPM0_FPD_M00_axil_arprot;
wire HPM0_FPD_M00_axil_arready;
wire HPM0_FPD_M00_axil_arvalid;
wire  [39:0] HPM0_FPD_M00_axil_awaddr;
wire  [2:0] HPM0_FPD_M00_axil_awprot;
wire HPM0_FPD_M00_axil_awready;
wire HPM0_FPD_M00_axil_awvalid;
wire HPM0_FPD_M00_axil_bready;
wire  [1:0] HPM0_FPD_M00_axil_bresp;
wire HPM0_FPD_M00_axil_bvalid;
wire  [31:0] HPM0_FPD_M00_axil_rdata;
wire HPM0_FPD_M00_axil_rready;
wire  [1:0] HPM0_FPD_M00_axil_rresp;
wire HPM0_FPD_M00_axil_rvalid;
wire  [31:0] HPM0_FPD_M00_axil_wdata;
wire HPM0_FPD_M00_axil_wready;
wire  [3:0] HPM0_FPD_M00_axil_wstrb;
wire HPM0_FPD_M00_axil_wvalid;
wire  [39:0] HPM0_FPD_M01_axil_araddr;
wire  [2:0] HPM0_FPD_M01_axil_arprot;
wire HPM0_FPD_M01_axil_arready;
wire HPM0_FPD_M01_axil_arvalid;
wire  [39:0] HPM0_FPD_M01_axil_awaddr;
wire  [2:0] HPM0_FPD_M01_axil_awprot;
wire HPM0_FPD_M01_axil_awready;
wire HPM0_FPD_M01_axil_awvalid;
wire HPM0_FPD_M01_axil_bready;
wire  [1:0] HPM0_FPD_M01_axil_bresp;
wire HPM0_FPD_M01_axil_bvalid;
wire  [31:0] HPM0_FPD_M01_axil_rdata;
wire HPM0_FPD_M01_axil_rready;
wire  [1:0] HPM0_FPD_M01_axil_rresp;
wire HPM0_FPD_M01_axil_rvalid;
wire  [31:0] HPM0_FPD_M01_axil_wdata;
wire HPM0_FPD_M01_axil_wready;
wire  [3:0] HPM0_FPD_M01_axil_wstrb;
wire HPM0_FPD_M01_axil_wvalid;
wire  [39:0] HPM0_FPD_M02_axil_araddr;
wire  [2:0] HPM0_FPD_M02_axil_arprot;
wire HPM0_FPD_M02_axil_arready;
wire HPM0_FPD_M02_axil_arvalid;
wire  [39:0] HPM0_FPD_M02_axil_awaddr;
wire  [2:0] HPM0_FPD_M02_axil_awprot;
wire HPM0_FPD_M02_axil_awready;
wire HPM0_FPD_M02_axil_awvalid;
wire HPM0_FPD_M02_axil_bready;
wire  [1:0] HPM0_FPD_M02_axil_bresp;
wire HPM0_FPD_M02_axil_bvalid;
wire  [31:0] HPM0_FPD_M02_axil_rdata;
wire HPM0_FPD_M02_axil_rready;
wire  [1:0] HPM0_FPD_M02_axil_rresp;
wire HPM0_FPD_M02_axil_rvalid;
wire  [31:0] HPM0_FPD_M02_axil_wdata;
wire HPM0_FPD_M02_axil_wready;
wire  [3:0] HPM0_FPD_M02_axil_wstrb;
wire HPM0_FPD_M02_axil_wvalid;
wire  [39:0] HPM0_FPD_M03_axil_araddr;
wire  [2:0] HPM0_FPD_M03_axil_arprot;
wire HPM0_FPD_M03_axil_arready;
wire HPM0_FPD_M03_axil_arvalid;
wire  [39:0] HPM0_FPD_M03_axil_awaddr;
wire  [2:0] HPM0_FPD_M03_axil_awprot;
wire HPM0_FPD_M03_axil_awready;
wire HPM0_FPD_M03_axil_awvalid;
wire HPM0_FPD_M03_axil_bready;
wire  [1:0] HPM0_FPD_M03_axil_bresp;
wire HPM0_FPD_M03_axil_bvalid;
wire  [31:0] HPM0_FPD_M03_axil_rdata;
wire HPM0_FPD_M03_axil_rready;
wire  [1:0] HPM0_FPD_M03_axil_rresp;
wire HPM0_FPD_M03_axil_rvalid;
wire  [31:0] HPM0_FPD_M03_axil_wdata;
wire HPM0_FPD_M03_axil_wready;
wire  [3:0] HPM0_FPD_M03_axil_wstrb;
wire HPM0_FPD_M03_axil_wvalid;
wire  [39:0] HPM0_FPD_M04_axil_araddr;
wire  [2:0] HPM0_FPD_M04_axil_arprot;
wire HPM0_FPD_M04_axil_arready;
wire HPM0_FPD_M04_axil_arvalid;
wire  [39:0] HPM0_FPD_M04_axil_awaddr;
wire  [2:0] HPM0_FPD_M04_axil_awprot;
wire HPM0_FPD_M04_axil_awready;
wire HPM0_FPD_M04_axil_awvalid;
wire HPM0_FPD_M04_axil_bready;
wire  [1:0] HPM0_FPD_M04_axil_bresp;
wire HPM0_FPD_M04_axil_bvalid;
wire  [31:0] HPM0_FPD_M04_axil_rdata;
wire HPM0_FPD_M04_axil_rready;
wire  [1:0] HPM0_FPD_M04_axil_rresp;
wire HPM0_FPD_M04_axil_rvalid;
wire  [31:0] HPM0_FPD_M04_axil_wdata;
wire HPM0_FPD_M04_axil_wready;
wire  [3:0] HPM0_FPD_M04_axil_wstrb;
wire HPM0_FPD_M04_axil_wvalid;
wire axil_arst_n, axil_rst;


system_wrapper system_wrapper_inst (
	.mpsoc_clk_100(mpsoc_clk_100),
	//HPM0_FPD signals
	.HPM0_FPD_M00_axil_araddr(HPM0_FPD_M00_axil_araddr),
	.HPM0_FPD_M00_axil_arprot(HPM0_FPD_M00_axil_arprot),
	.HPM0_FPD_M00_axil_arready(HPM0_FPD_M00_axil_arready),
	.HPM0_FPD_M00_axil_arvalid(HPM0_FPD_M00_axil_arvalid),
	.HPM0_FPD_M00_axil_awaddr(HPM0_FPD_M00_axil_awaddr),
	.HPM0_FPD_M00_axil_awprot(HPM0_FPD_M00_axil_awprot),
	.HPM0_FPD_M00_axil_awready(HPM0_FPD_M00_axil_awready),
	.HPM0_FPD_M00_axil_awvalid(HPM0_FPD_M00_axil_awvalid),
	.HPM0_FPD_M00_axil_bready(HPM0_FPD_M00_axil_bready),
	.HPM0_FPD_M00_axil_bresp(HPM0_FPD_M00_axil_bresp),
	.HPM0_FPD_M00_axil_bvalid(HPM0_FPD_M00_axil_bvalid),
	.HPM0_FPD_M00_axil_rdata(HPM0_FPD_M00_axil_rdata),
	.HPM0_FPD_M00_axil_rready(HPM0_FPD_M00_axil_rready),
	.HPM0_FPD_M00_axil_rresp(HPM0_FPD_M00_axil_rresp),
	.HPM0_FPD_M00_axil_rvalid(HPM0_FPD_M00_axil_rvalid),
	.HPM0_FPD_M00_axil_wdata(HPM0_FPD_M00_axil_wdata),
	.HPM0_FPD_M00_axil_wready(HPM0_FPD_M00_axil_wready),
	.HPM0_FPD_M00_axil_wstrb(HPM0_FPD_M00_axil_wstrb),
	.HPM0_FPD_M00_axil_wvalid(HPM0_FPD_M00_axil_wvalid),
	.HPM0_FPD_M01_axil_araddr(HPM0_FPD_M01_axil_araddr),
	.HPM0_FPD_M01_axil_arprot(HPM0_FPD_M01_axil_arprot),
	.HPM0_FPD_M01_axil_arready(HPM0_FPD_M01_axil_arready),
	.HPM0_FPD_M01_axil_arvalid(HPM0_FPD_M01_axil_arvalid),
	.HPM0_FPD_M01_axil_awaddr(HPM0_FPD_M01_axil_awaddr),
	.HPM0_FPD_M01_axil_awprot(HPM0_FPD_M01_axil_awprot),
	.HPM0_FPD_M01_axil_awready(HPM0_FPD_M01_axil_awready),
	.HPM0_FPD_M01_axil_awvalid(HPM0_FPD_M01_axil_awvalid),
	.HPM0_FPD_M01_axil_bready(HPM0_FPD_M01_axil_bready),
	.HPM0_FPD_M01_axil_bresp(HPM0_FPD_M01_axil_bresp),
	.HPM0_FPD_M01_axil_bvalid(HPM0_FPD_M01_axil_bvalid),
	.HPM0_FPD_M01_axil_rdata(HPM0_FPD_M01_axil_rdata),
	.HPM0_FPD_M01_axil_rready(HPM0_FPD_M01_axil_rready),
	.HPM0_FPD_M01_axil_rresp(HPM0_FPD_M01_axil_rresp),
	.HPM0_FPD_M01_axil_rvalid(HPM0_FPD_M01_axil_rvalid),
	.HPM0_FPD_M01_axil_wdata(HPM0_FPD_M01_axil_wdata),
	.HPM0_FPD_M01_axil_wready(HPM0_FPD_M01_axil_wready),
	.HPM0_FPD_M01_axil_wstrb(HPM0_FPD_M01_axil_wstrb),
	.HPM0_FPD_M01_axil_wvalid(HPM0_FPD_M01_axil_wvalid),
	.HPM0_FPD_M02_axil_araddr(HPM0_FPD_M02_axil_araddr),
	.HPM0_FPD_M02_axil_arprot(HPM0_FPD_M02_axil_arprot),
	.HPM0_FPD_M02_axil_arready(HPM0_FPD_M02_axil_arready),
	.HPM0_FPD_M02_axil_arvalid(HPM0_FPD_M02_axil_arvalid),
	.HPM0_FPD_M02_axil_awaddr(HPM0_FPD_M02_axil_awaddr),
	.HPM0_FPD_M02_axil_awprot(HPM0_FPD_M02_axil_awprot),
	.HPM0_FPD_M02_axil_awready(HPM0_FPD_M02_axil_awready),
	.HPM0_FPD_M02_axil_awvalid(HPM0_FPD_M02_axil_awvalid),
	.HPM0_FPD_M02_axil_bready(HPM0_FPD_M02_axil_bready),
	.HPM0_FPD_M02_axil_bresp(HPM0_FPD_M02_axil_bresp),
	.HPM0_FPD_M02_axil_bvalid(HPM0_FPD_M02_axil_bvalid),
	.HPM0_FPD_M02_axil_rdata(HPM0_FPD_M02_axil_rdata),
	.HPM0_FPD_M02_axil_rready(HPM0_FPD_M02_axil_rready),
	.HPM0_FPD_M02_axil_rresp(HPM0_FPD_M02_axil_rresp),
	.HPM0_FPD_M02_axil_rvalid(HPM0_FPD_M02_axil_rvalid),
	.HPM0_FPD_M02_axil_wdata(HPM0_FPD_M02_axil_wdata),
	.HPM0_FPD_M02_axil_wready(HPM0_FPD_M02_axil_wready),
	.HPM0_FPD_M02_axil_wstrb(HPM0_FPD_M02_axil_wstrb),
	.HPM0_FPD_M02_axil_wvalid(HPM0_FPD_M02_axil_wvalid),
	.HPM0_FPD_M03_axil_araddr(HPM0_FPD_M03_axil_araddr),
	.HPM0_FPD_M03_axil_arprot(HPM0_FPD_M03_axil_arprot),
	.HPM0_FPD_M03_axil_arready(HPM0_FPD_M03_axil_arready),
	.HPM0_FPD_M03_axil_arvalid(HPM0_FPD_M03_axil_arvalid),
	.HPM0_FPD_M03_axil_awaddr(HPM0_FPD_M03_axil_awaddr),
	.HPM0_FPD_M03_axil_awprot(HPM0_FPD_M03_axil_awprot),
	.HPM0_FPD_M03_axil_awready(HPM0_FPD_M03_axil_awready),
	.HPM0_FPD_M03_axil_awvalid(HPM0_FPD_M03_axil_awvalid),
	.HPM0_FPD_M03_axil_bready(HPM0_FPD_M03_axil_bready),
	.HPM0_FPD_M03_axil_bresp(HPM0_FPD_M03_axil_bresp),
	.HPM0_FPD_M03_axil_bvalid(HPM0_FPD_M03_axil_bvalid),
	.HPM0_FPD_M03_axil_rdata(HPM0_FPD_M03_axil_rdata),
	.HPM0_FPD_M03_axil_rready(HPM0_FPD_M03_axil_rready),
	.HPM0_FPD_M03_axil_rresp(HPM0_FPD_M03_axil_rresp),
	.HPM0_FPD_M03_axil_rvalid(HPM0_FPD_M03_axil_rvalid),
	.HPM0_FPD_M03_axil_wdata(HPM0_FPD_M03_axil_wdata),
	.HPM0_FPD_M03_axil_wready(HPM0_FPD_M03_axil_wready),
	.HPM0_FPD_M03_axil_wstrb(HPM0_FPD_M03_axil_wstrb),
	.HPM0_FPD_M03_axil_wvalid(HPM0_FPD_M03_axil_wvalid),
	.HPM0_FPD_M04_axil_araddr(HPM0_FPD_M04_axil_araddr),
	.HPM0_FPD_M04_axil_arprot(HPM0_FPD_M04_axil_arprot),
	.HPM0_FPD_M04_axil_arready(HPM0_FPD_M04_axil_arready),
	.HPM0_FPD_M04_axil_arvalid(HPM0_FPD_M04_axil_arvalid),
	.HPM0_FPD_M04_axil_awaddr(HPM0_FPD_M04_axil_awaddr),
	.HPM0_FPD_M04_axil_awprot(HPM0_FPD_M04_axil_awprot),
	.HPM0_FPD_M04_axil_awready(HPM0_FPD_M04_axil_awready),
	.HPM0_FPD_M04_axil_awvalid(HPM0_FPD_M04_axil_awvalid),
	.HPM0_FPD_M04_axil_bready(HPM0_FPD_M04_axil_bready),
	.HPM0_FPD_M04_axil_bresp(HPM0_FPD_M04_axil_bresp),
	.HPM0_FPD_M04_axil_bvalid(HPM0_FPD_M04_axil_bvalid),
	.HPM0_FPD_M04_axil_rdata(HPM0_FPD_M04_axil_rdata),
	.HPM0_FPD_M04_axil_rready(HPM0_FPD_M04_axil_rready),
	.HPM0_FPD_M04_axil_rresp(HPM0_FPD_M04_axil_rresp),
	.HPM0_FPD_M04_axil_rvalid(HPM0_FPD_M04_axil_rvalid),
	.HPM0_FPD_M04_axil_wdata(HPM0_FPD_M04_axil_wdata),
	.HPM0_FPD_M04_axil_wready(HPM0_FPD_M04_axil_wready),
	.HPM0_FPD_M04_axil_wstrb(HPM0_FPD_M04_axil_wstrb),
	.HPM0_FPD_M04_axil_wvalid(HPM0_FPD_M04_axil_wvalid),
	.axil_rst(axil_rst),
	.axil_arst_n(axil_arst_n)
);

 axil_bram_unbalanced #(
	.FPGA_DATA_WIDTH(32),
	.FPGA_ADDR_WIDTH(10),
	.AXI_DATA_WIDTH(32)
) axil_bram_inst0 (
	.fpga_clk(),
	.bram_din(),
	.bram_addr(),
	.bram_we(),
	.bram_dout(),
	.s_axil_araddr(HPM0_FPD_M00_axil_araddr),
	.s_axil_arprot(HPM0_FPD_M00_axil_arprot),
	.s_axil_arready(HPM0_FPD_M00_axil_arready),
	.s_axil_arvalid(HPM0_FPD_M00_axil_arvalid),
	.s_axil_awaddr(HPM0_FPD_M00_axil_awaddr),
	.s_axil_awprot(HPM0_FPD_M00_axil_awprot),
	.s_axil_awready(HPM0_FPD_M00_axil_awready),
	.s_axil_awvalid(HPM0_FPD_M00_axil_awvalid),
	.s_axil_bready(HPM0_FPD_M00_axil_bready),
	.s_axil_bresp(HPM0_FPD_M00_axil_bresp),
	.s_axil_bvalid(HPM0_FPD_M00_axil_bvalid),
	.s_axil_rdata(HPM0_FPD_M00_axil_rdata),
	.s_axil_rready(HPM0_FPD_M00_axil_rready),
	.s_axil_rresp(HPM0_FPD_M00_axil_rresp),
	.s_axil_rvalid(HPM0_FPD_M00_axil_rvalid),
	.s_axil_wdata(HPM0_FPD_M00_axil_wdata),
	.s_axil_wready(HPM0_FPD_M00_axil_wready),
	.s_axil_wstrb(HPM0_FPD_M00_axil_wstrb),
	.s_axil_wvalid(HPM0_FPD_M00_axil_wvalid),
	.axi_clock(mpsoc_clk_100),
	.rst(axil_rst)
);

s_axil_reg #(
	.DATA_WIDTH(32),
	.ADDR_WIDTH(4)
) s_axil_reg_inst0 (
//
//put user inputs outputs 
//
	.s_axil_araddr(HPM0_FPD_M01_axil_araddr),
	.s_axil_arprot(HPM0_FPD_M01_axil_arprot),
	.s_axil_arready(HPM0_FPD_M01_axil_arready),
	.s_axil_arvalid(HPM0_FPD_M01_axil_arvalid),
	.s_axil_awaddr(HPM0_FPD_M01_axil_awaddr),
	.s_axil_awprot(HPM0_FPD_M01_axil_awprot),
	.s_axil_awready(HPM0_FPD_M01_axil_awready),
	.s_axil_awvalid(HPM0_FPD_M01_axil_awvalid),
	.s_axil_bready(HPM0_FPD_M01_axil_bready),
	.s_axil_bresp(HPM0_FPD_M01_axil_bresp),
	.s_axil_bvalid(HPM0_FPD_M01_axil_bvalid),
	.s_axil_rdata(HPM0_FPD_M01_axil_rdata),
	.s_axil_rready(HPM0_FPD_M01_axil_rready),
	.s_axil_rresp(HPM0_FPD_M01_axil_rresp),
	.s_axil_rvalid(HPM0_FPD_M01_axil_rvalid),
	.s_axil_wdata(HPM0_FPD_M01_axil_wdata),
	.s_axil_wready(HPM0_FPD_M01_axil_wready),
	.s_axil_wstrb(HPM0_FPD_M01_axil_wstrb),
	.s_axil_wvalid(HPM0_FPD_M01_axil_wvalid),
	.axi_clock(mpsoc_clk_100),
	.rst(axil_rst)
);

 axil_bram_unbalanced #(
	.FPGA_DATA_WIDTH(32),
	.FPGA_ADDR_WIDTH(10),
	.AXI_DATA_WIDTH(32)
) axil_bram_inst1 (
	.fpga_clk(),
	.bram_din(),
	.bram_addr(),
	.bram_we(),
	.bram_dout(),
	.s_axil_araddr(HPM0_FPD_M02_axil_araddr),
	.s_axil_arprot(HPM0_FPD_M02_axil_arprot),
	.s_axil_arready(HPM0_FPD_M02_axil_arready),
	.s_axil_arvalid(HPM0_FPD_M02_axil_arvalid),
	.s_axil_awaddr(HPM0_FPD_M02_axil_awaddr),
	.s_axil_awprot(HPM0_FPD_M02_axil_awprot),
	.s_axil_awready(HPM0_FPD_M02_axil_awready),
	.s_axil_awvalid(HPM0_FPD_M02_axil_awvalid),
	.s_axil_bready(HPM0_FPD_M02_axil_bready),
	.s_axil_bresp(HPM0_FPD_M02_axil_bresp),
	.s_axil_bvalid(HPM0_FPD_M02_axil_bvalid),
	.s_axil_rdata(HPM0_FPD_M02_axil_rdata),
	.s_axil_rready(HPM0_FPD_M02_axil_rready),
	.s_axil_rresp(HPM0_FPD_M02_axil_rresp),
	.s_axil_rvalid(HPM0_FPD_M02_axil_rvalid),
	.s_axil_wdata(HPM0_FPD_M02_axil_wdata),
	.s_axil_wready(HPM0_FPD_M02_axil_wready),
	.s_axil_wstrb(HPM0_FPD_M02_axil_wstrb),
	.s_axil_wvalid(HPM0_FPD_M02_axil_wvalid),
	.axi_clock(mpsoc_clk_100),
	.rst(axil_rst)
);

 axil_bram_unbalanced #(
	.FPGA_DATA_WIDTH(32),
	.FPGA_ADDR_WIDTH(10),
	.AXI_DATA_WIDTH(32)
) axil_bram_inst2 (
	.fpga_clk(),
	.bram_din(),
	.bram_addr(),
	.bram_we(),
	.bram_dout(),
	.s_axil_araddr(HPM0_FPD_M03_axil_araddr),
	.s_axil_arprot(HPM0_FPD_M03_axil_arprot),
	.s_axil_arready(HPM0_FPD_M03_axil_arready),
	.s_axil_arvalid(HPM0_FPD_M03_axil_arvalid),
	.s_axil_awaddr(HPM0_FPD_M03_axil_awaddr),
	.s_axil_awprot(HPM0_FPD_M03_axil_awprot),
	.s_axil_awready(HPM0_FPD_M03_axil_awready),
	.s_axil_awvalid(HPM0_FPD_M03_axil_awvalid),
	.s_axil_bready(HPM0_FPD_M03_axil_bready),
	.s_axil_bresp(HPM0_FPD_M03_axil_bresp),
	.s_axil_bvalid(HPM0_FPD_M03_axil_bvalid),
	.s_axil_rdata(HPM0_FPD_M03_axil_rdata),
	.s_axil_rready(HPM0_FPD_M03_axil_rready),
	.s_axil_rresp(HPM0_FPD_M03_axil_rresp),
	.s_axil_rvalid(HPM0_FPD_M03_axil_rvalid),
	.s_axil_wdata(HPM0_FPD_M03_axil_wdata),
	.s_axil_wready(HPM0_FPD_M03_axil_wready),
	.s_axil_wstrb(HPM0_FPD_M03_axil_wstrb),
	.s_axil_wvalid(HPM0_FPD_M03_axil_wvalid),
	.axi_clock(mpsoc_clk_100),
	.rst(axil_rst)
);

 axil_bram_unbalanced #(
	.FPGA_DATA_WIDTH(32),
	.FPGA_ADDR_WIDTH(10),
	.AXI_DATA_WIDTH(32)
) axil_bram_inst3 (
	.fpga_clk(),
	.bram_din(),
	.bram_addr(),
	.bram_we(),
	.bram_dout(),
	.s_axil_araddr(HPM0_FPD_M04_axil_araddr),
	.s_axil_arprot(HPM0_FPD_M04_axil_arprot),
	.s_axil_arready(HPM0_FPD_M04_axil_arready),
	.s_axil_arvalid(HPM0_FPD_M04_axil_arvalid),
	.s_axil_awaddr(HPM0_FPD_M04_axil_awaddr),
	.s_axil_awprot(HPM0_FPD_M04_axil_awprot),
	.s_axil_awready(HPM0_FPD_M04_axil_awready),
	.s_axil_awvalid(HPM0_FPD_M04_axil_awvalid),
	.s_axil_bready(HPM0_FPD_M04_axil_bready),
	.s_axil_bresp(HPM0_FPD_M04_axil_bresp),
	.s_axil_bvalid(HPM0_FPD_M04_axil_bvalid),
	.s_axil_rdata(HPM0_FPD_M04_axil_rdata),
	.s_axil_rready(HPM0_FPD_M04_axil_rready),
	.s_axil_rresp(HPM0_FPD_M04_axil_rresp),
	.s_axil_rvalid(HPM0_FPD_M04_axil_rvalid),
	.s_axil_wdata(HPM0_FPD_M04_axil_wdata),
	.s_axil_wready(HPM0_FPD_M04_axil_wready),
	.s_axil_wstrb(HPM0_FPD_M04_axil_wstrb),
	.s_axil_wvalid(HPM0_FPD_M04_axil_wvalid),
	.axi_clock(mpsoc_clk_100),
	.rst(axil_rst)
);
endmodule
`resetall