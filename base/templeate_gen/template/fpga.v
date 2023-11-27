`default_nettype none

//Top template
module fpga (

);



wire mpsoc_clk_150;
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
//HPM1_FPD signals
wire  [39:0] HPM1_FPD_M00_axil_araddr;
wire  [2:0] HPM1_FPD_M00_axil_arprot;
wire HPM1_FPD_M00_axil_arready;
wire HPM1_FPD_M00_axil_arvalid;
wire  [39:0] HPM1_FPD_M00_axil_awaddr;
wire  [2:0] HPM1_FPD_M00_axil_awprot;
wire HPM1_FPD_M00_axil_awready;
wire HPM1_FPD_M00_axil_awvalid;
wire HPM1_FPD_M00_axil_bready;
wire  [1:0] HPM1_FPD_M00_axil_bresp;
wire HPM1_FPD_M00_axil_bvalid;
wire  [31:0] HPM1_FPD_M00_axil_rdata;
wire HPM1_FPD_M00_axil_rready;
wire  [1:0] HPM1_FPD_M00_axil_rresp;
wire HPM1_FPD_M00_axil_rvalid;
wire  [31:0] HPM1_FPD_M00_axil_wdata;
wire HPM1_FPD_M00_axil_wready;
wire  [3:0] HPM1_FPD_M00_axil_wstrb;
wire HPM1_FPD_M00_axil_wvalid;
wire  [39:0] HPM1_FPD_M01_axil_araddr;
wire  [2:0] HPM1_FPD_M01_axil_arprot;
wire HPM1_FPD_M01_axil_arready;
wire HPM1_FPD_M01_axil_arvalid;
wire  [39:0] HPM1_FPD_M01_axil_awaddr;
wire  [2:0] HPM1_FPD_M01_axil_awprot;
wire HPM1_FPD_M01_axil_awready;
wire HPM1_FPD_M01_axil_awvalid;
wire HPM1_FPD_M01_axil_bready;
wire  [1:0] HPM1_FPD_M01_axil_bresp;
wire HPM1_FPD_M01_axil_bvalid;
wire  [31:0] HPM1_FPD_M01_axil_rdata;
wire HPM1_FPD_M01_axil_rready;
wire  [1:0] HPM1_FPD_M01_axil_rresp;
wire HPM1_FPD_M01_axil_rvalid;
wire  [31:0] HPM1_FPD_M01_axil_wdata;
wire HPM1_FPD_M01_axil_wready;
wire  [3:0] HPM1_FPD_M01_axil_wstrb;
wire HPM1_FPD_M01_axil_wvalid;
wire axil_arst_n, axil_rst;


system_wrapper system_wrapper_inst (
	.mpsoc_clk_150(mpsoc_clk_150),
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
	//HPM1_FPD signals
	.HPM1_FPD_M00_axil_araddr(HPM1_FPD_M00_axil_araddr),
	.HPM1_FPD_M00_axil_arprot(HPM1_FPD_M00_axil_arprot),
	.HPM1_FPD_M00_axil_arready(HPM1_FPD_M00_axil_arready),
	.HPM1_FPD_M00_axil_arvalid(HPM1_FPD_M00_axil_arvalid),
	.HPM1_FPD_M00_axil_awaddr(HPM1_FPD_M00_axil_awaddr),
	.HPM1_FPD_M00_axil_awprot(HPM1_FPD_M00_axil_awprot),
	.HPM1_FPD_M00_axil_awready(HPM1_FPD_M00_axil_awready),
	.HPM1_FPD_M00_axil_awvalid(HPM1_FPD_M00_axil_awvalid),
	.HPM1_FPD_M00_axil_bready(HPM1_FPD_M00_axil_bready),
	.HPM1_FPD_M00_axil_bresp(HPM1_FPD_M00_axil_bresp),
	.HPM1_FPD_M00_axil_bvalid(HPM1_FPD_M00_axil_bvalid),
	.HPM1_FPD_M00_axil_rdata(HPM1_FPD_M00_axil_rdata),
	.HPM1_FPD_M00_axil_rready(HPM1_FPD_M00_axil_rready),
	.HPM1_FPD_M00_axil_rresp(HPM1_FPD_M00_axil_rresp),
	.HPM1_FPD_M00_axil_rvalid(HPM1_FPD_M00_axil_rvalid),
	.HPM1_FPD_M00_axil_wdata(HPM1_FPD_M00_axil_wdata),
	.HPM1_FPD_M00_axil_wready(HPM1_FPD_M00_axil_wready),
	.HPM1_FPD_M00_axil_wstrb(HPM1_FPD_M00_axil_wstrb),
	.HPM1_FPD_M00_axil_wvalid(HPM1_FPD_M00_axil_wvalid),
	.HPM1_FPD_M01_axil_araddr(HPM1_FPD_M01_axil_araddr),
	.HPM1_FPD_M01_axil_arprot(HPM1_FPD_M01_axil_arprot),
	.HPM1_FPD_M01_axil_arready(HPM1_FPD_M01_axil_arready),
	.HPM1_FPD_M01_axil_arvalid(HPM1_FPD_M01_axil_arvalid),
	.HPM1_FPD_M01_axil_awaddr(HPM1_FPD_M01_axil_awaddr),
	.HPM1_FPD_M01_axil_awprot(HPM1_FPD_M01_axil_awprot),
	.HPM1_FPD_M01_axil_awready(HPM1_FPD_M01_axil_awready),
	.HPM1_FPD_M01_axil_awvalid(HPM1_FPD_M01_axil_awvalid),
	.HPM1_FPD_M01_axil_bready(HPM1_FPD_M01_axil_bready),
	.HPM1_FPD_M01_axil_bresp(HPM1_FPD_M01_axil_bresp),
	.HPM1_FPD_M01_axil_bvalid(HPM1_FPD_M01_axil_bvalid),
	.HPM1_FPD_M01_axil_rdata(HPM1_FPD_M01_axil_rdata),
	.HPM1_FPD_M01_axil_rready(HPM1_FPD_M01_axil_rready),
	.HPM1_FPD_M01_axil_rresp(HPM1_FPD_M01_axil_rresp),
	.HPM1_FPD_M01_axil_rvalid(HPM1_FPD_M01_axil_rvalid),
	.HPM1_FPD_M01_axil_wdata(HPM1_FPD_M01_axil_wdata),
	.HPM1_FPD_M01_axil_wready(HPM1_FPD_M01_axil_wready),
	.HPM1_FPD_M01_axil_wstrb(HPM1_FPD_M01_axil_wstrb),
	.HPM1_FPD_M01_axil_wvalid(HPM1_FPD_M01_axil_wvalid),
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
	.axi_clock(mpsoc_clk_150),
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
	.axi_clock(mpsoc_clk_150),
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
	.s_axil_araddr(HPM1_FPD_M00_axil_araddr),
	.s_axil_arprot(HPM1_FPD_M00_axil_arprot),
	.s_axil_arready(HPM1_FPD_M00_axil_arready),
	.s_axil_arvalid(HPM1_FPD_M00_axil_arvalid),
	.s_axil_awaddr(HPM1_FPD_M00_axil_awaddr),
	.s_axil_awprot(HPM1_FPD_M00_axil_awprot),
	.s_axil_awready(HPM1_FPD_M00_axil_awready),
	.s_axil_awvalid(HPM1_FPD_M00_axil_awvalid),
	.s_axil_bready(HPM1_FPD_M00_axil_bready),
	.s_axil_bresp(HPM1_FPD_M00_axil_bresp),
	.s_axil_bvalid(HPM1_FPD_M00_axil_bvalid),
	.s_axil_rdata(HPM1_FPD_M00_axil_rdata),
	.s_axil_rready(HPM1_FPD_M00_axil_rready),
	.s_axil_rresp(HPM1_FPD_M00_axil_rresp),
	.s_axil_rvalid(HPM1_FPD_M00_axil_rvalid),
	.s_axil_wdata(HPM1_FPD_M00_axil_wdata),
	.s_axil_wready(HPM1_FPD_M00_axil_wready),
	.s_axil_wstrb(HPM1_FPD_M00_axil_wstrb),
	.s_axil_wvalid(HPM1_FPD_M00_axil_wvalid),
	.axi_clock(mpsoc_clk_150),
	.rst(axil_rst)
);

s_axil_reg #(
	.DATA_WIDTH(32),
	.ADDR_WIDTH(4)
) s_axil_reg_inst1 (
//
//put user inputs outputs 
//
	.s_axil_araddr(HPM1_FPD_M01_axil_araddr),
	.s_axil_arprot(HPM1_FPD_M01_axil_arprot),
	.s_axil_arready(HPM1_FPD_M01_axil_arready),
	.s_axil_arvalid(HPM1_FPD_M01_axil_arvalid),
	.s_axil_awaddr(HPM1_FPD_M01_axil_awaddr),
	.s_axil_awprot(HPM1_FPD_M01_axil_awprot),
	.s_axil_awready(HPM1_FPD_M01_axil_awready),
	.s_axil_awvalid(HPM1_FPD_M01_axil_awvalid),
	.s_axil_bready(HPM1_FPD_M01_axil_bready),
	.s_axil_bresp(HPM1_FPD_M01_axil_bresp),
	.s_axil_bvalid(HPM1_FPD_M01_axil_bvalid),
	.s_axil_rdata(HPM1_FPD_M01_axil_rdata),
	.s_axil_rready(HPM1_FPD_M01_axil_rready),
	.s_axil_rresp(HPM1_FPD_M01_axil_rresp),
	.s_axil_rvalid(HPM1_FPD_M01_axil_rvalid),
	.s_axil_wdata(HPM1_FPD_M01_axil_wdata),
	.s_axil_wready(HPM1_FPD_M01_axil_wready),
	.s_axil_wstrb(HPM1_FPD_M01_axil_wstrb),
	.s_axil_wvalid(HPM1_FPD_M01_axil_wvalid),
	.axi_clock(mpsoc_clk_150),
	.rst(axil_rst)
);
endmodule
`resetall