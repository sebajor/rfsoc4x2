`default_nettype none

//Top template
module fpga (
 
	//rfdc signals, check if the signals are ok...
	input wire sysref_in_n, sysref_in_p,
	input wire adc0_clk_n, adc0_clk_p,
	input wire vin0_01_n, vin0_01_p,
	input wire vin0_23_n, vin0_23_p,
	input wire adc2_clk_n, adc2_clk_p,
	input wire vin2_01_n, vin2_01_p,
	input wire vin2_23_n, vin2_23_p
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
//rfdc signals
wire tile224_data_clk;
wire signed [15:0] tile224_adc0_0, tile224_adc0_1, tile224_adc0_2, 
				tile224_adc0_3, tile224_adc0_4, tile224_adc0_5, 
				tile224_adc0_6, tile224_adc0_7;
wire tile224_0_tvalid;
wire signed [15:0] tile224_adc1_0, tile224_adc1_1, tile224_adc1_2, 
				tile224_adc1_3, tile224_adc1_4, tile224_adc1_5, 
				tile224_adc1_6, tile224_adc1_7;
wire tile224_1_tvalid;

wire tile226_data_clk;
wire signed [15:0] tile226_adc0_0, tile226_adc0_1, tile226_adc0_2, 
				tile226_adc0_3, tile226_adc0_4, tile226_adc0_5, 
				tile226_adc0_6, tile226_adc0_7;
wire tile226_0_tvalid;
wire signed [15:0] tile226_adc1_0, tile226_adc1_1, tile226_adc1_2, 
				tile226_adc1_3, tile226_adc1_4, tile226_adc1_5, 
				tile226_adc1_6, tile226_adc1_7;
wire tile226_1_tvalid;

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
	//rfdc singals
	.rfdc_sysref_n(sysref_in_n),
	.rfdc_sysref_p(sysref_in_p),
	//tile224 signals
	.tile224_clk_n(),
	.tile224_clk_p(),
	.tile224_axis_input_clk(),
	.tile224_data_clk(tile224_data_clk),
	.vin0_01_n(vin0_01_n),
	.vin0_01_p(vin0_01_p),
	//axi-stream adc0 signals
	.tile224_0_tvalid(tile224_0_tvalid),
	.tile224_0_tready(1'b1),
	.tile224_0_tdata({	tile224_adc0_0, tile224_adc0_1, tile224_adc0_2, tile224_adc0_3, tile224_adc0_4, 
						tile224_adc0_5, tile224_adc0_6, tile224_adc0_7}),
	.vin0_23_n(vin0_23_n),
	.vin0_23_p(vin0_23_p),
	//axi-stream adc1 signals
	.tile224_1_tvalid(tile224_1_tvalid),
	.tile224_1_tready(1'b1),
	.tile224_1_tdata({	tile224_adc1_0, tile224_adc1_1, tile224_adc1_2, tile224_adc1_3, tile224_adc1_4, 
						tile224_adc1_5, tile224_adc1_6, tile224_adc1_7}),
	//tile226 signals
	.tile226_clk_n(),
	.tile226_clk_p(),
	.tile226_axis_input_clk(),
	.tile226_data_clk(tile226_data_clk),
	.vin2_01_n(vin2_01_n),
	.vin2_01_p(vin2_01_p),
	//axi-stream adc0 signals
	.tile226_0_tvalid(tile226_0_tvalid),
	.tile226_0_tready(1'b1),
	.tile226_0_tdata({	tile226_adc0_0, tile226_adc0_1, tile226_adc0_2, tile226_adc0_3, tile226_adc0_4, 
						tile226_adc0_5, tile226_adc0_6, tile226_adc0_7}),
	.vin2_23_n(vin2_23_n),
	.vin2_23_p(vin2_23_p),
	//axi-stream adc1 signals
	.tile226_1_tvalid(tile226_1_tvalid),
	.tile226_1_tready(1'b1),
	.tile226_1_tdata({	tile226_adc1_0, tile226_adc1_1, tile226_adc1_2, tile226_adc1_3, tile226_adc1_4, 
						tile226_adc1_5, tile226_adc1_6, tile226_adc1_7}),
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
	.axi_clock(mpsoc_clk_100),
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
	.axi_clock(mpsoc_clk_100),
	.rst(axil_rst)
);
endmodule
`resetall