//`default_nettype none


// This wrapper is only to simulate, the one used when compiling is generated  by vivado
module system_wrapper (
	output wire mpsoc_clk_100,
	//HPM0_FPD signals
	output wire  [39:0] HPM0_FPD_M00_axil_araddr,
	output wire  [2:0] HPM0_FPD_M00_axil_arprot,
	input wire HPM0_FPD_M00_axil_arready,
	output wire HPM0_FPD_M00_axil_arvalid,
	output wire  [39:0] HPM0_FPD_M00_axil_awaddr,
	output wire  [2:0] HPM0_FPD_M00_axil_awprot,
	input wire HPM0_FPD_M00_axil_awready,
	output wire HPM0_FPD_M00_axil_awvalid,
	output wire HPM0_FPD_M00_axil_bready,
	input wire  [1:0] HPM0_FPD_M00_axil_bresp,
	input wire HPM0_FPD_M00_axil_bvalid,
	input wire  [31:0] HPM0_FPD_M00_axil_rdata,
	output wire HPM0_FPD_M00_axil_rready,
	input wire  [1:0] HPM0_FPD_M00_axil_rresp,
	input wire HPM0_FPD_M00_axil_rvalid,
	output wire  [31:0] HPM0_FPD_M00_axil_wdata,
	input wire HPM0_FPD_M00_axil_wready,
	output wire  [3:0] HPM0_FPD_M00_axil_wstrb,
	output wire HPM0_FPD_M00_axil_wvalid,
	output wire  [39:0] HPM0_FPD_M01_axil_araddr,
	output wire  [2:0] HPM0_FPD_M01_axil_arprot,
	input wire HPM0_FPD_M01_axil_arready,
	output wire HPM0_FPD_M01_axil_arvalid,
	output wire  [39:0] HPM0_FPD_M01_axil_awaddr,
	output wire  [2:0] HPM0_FPD_M01_axil_awprot,
	input wire HPM0_FPD_M01_axil_awready,
	output wire HPM0_FPD_M01_axil_awvalid,
	output wire HPM0_FPD_M01_axil_bready,
	input wire  [1:0] HPM0_FPD_M01_axil_bresp,
	input wire HPM0_FPD_M01_axil_bvalid,
	input wire  [31:0] HPM0_FPD_M01_axil_rdata,
	output wire HPM0_FPD_M01_axil_rready,
	input wire  [1:0] HPM0_FPD_M01_axil_rresp,
	input wire HPM0_FPD_M01_axil_rvalid,
	output wire  [31:0] HPM0_FPD_M01_axil_wdata,
	input wire HPM0_FPD_M01_axil_wready,
	output wire  [3:0] HPM0_FPD_M01_axil_wstrb,
	output wire HPM0_FPD_M01_axil_wvalid,
	//HPM1_FPD signals
	output wire  [39:0] HPM1_FPD_M00_axil_araddr,
	output wire  [2:0] HPM1_FPD_M00_axil_arprot,
	input wire HPM1_FPD_M00_axil_arready,
	output wire HPM1_FPD_M00_axil_arvalid,
	output wire  [39:0] HPM1_FPD_M00_axil_awaddr,
	output wire  [2:0] HPM1_FPD_M00_axil_awprot,
	input wire HPM1_FPD_M00_axil_awready,
	output wire HPM1_FPD_M00_axil_awvalid,
	output wire HPM1_FPD_M00_axil_bready,
	input wire  [1:0] HPM1_FPD_M00_axil_bresp,
	input wire HPM1_FPD_M00_axil_bvalid,
	input wire  [31:0] HPM1_FPD_M00_axil_rdata,
	output wire HPM1_FPD_M00_axil_rready,
	input wire  [1:0] HPM1_FPD_M00_axil_rresp,
	input wire HPM1_FPD_M00_axil_rvalid,
	output wire  [31:0] HPM1_FPD_M00_axil_wdata,
	input wire HPM1_FPD_M00_axil_wready,
	output wire  [3:0] HPM1_FPD_M00_axil_wstrb,
	output wire HPM1_FPD_M00_axil_wvalid,
	output wire  [39:0] HPM1_FPD_M01_axil_araddr,
	output wire  [2:0] HPM1_FPD_M01_axil_arprot,
	input wire HPM1_FPD_M01_axil_arready,
	output wire HPM1_FPD_M01_axil_arvalid,
	output wire  [39:0] HPM1_FPD_M01_axil_awaddr,
	output wire  [2:0] HPM1_FPD_M01_axil_awprot,
	input wire HPM1_FPD_M01_axil_awready,
	output wire HPM1_FPD_M01_axil_awvalid,
	output wire HPM1_FPD_M01_axil_bready,
	input wire  [1:0] HPM1_FPD_M01_axil_bresp,
	input wire HPM1_FPD_M01_axil_bvalid,
	input wire  [31:0] HPM1_FPD_M01_axil_rdata,
	output wire HPM1_FPD_M01_axil_rready,
	input wire  [1:0] HPM1_FPD_M01_axil_rresp,
	input wire HPM1_FPD_M01_axil_rvalid,
	output wire  [31:0] HPM1_FPD_M01_axil_wdata,
	input wire HPM1_FPD_M01_axil_wready,
	output wire  [3:0] HPM1_FPD_M01_axil_wstrb,
	output wire HPM1_FPD_M01_axil_wvalid,
	//RFDC signals
	input wire rfdc_sysref_n, rfdc_sysref_p,
	/*tile 224 signals
	*sampling_clk:1.311, refclk:491.520, output_clk:122.880 
	*/
	input wire tile224_clk_n, tile224_clk_p,
	input wire tile224_axis_input_clk,
	//adc physical inputs
	input wire vin0_01_n, vin0_01_p,
	output wire [127:0] tile224_0_tdata,
 	output wire tile224_0_tvalid,
 	input wire tile224_0_tready,
 	//adc physical inputs
	input wire vin0_23_n, vin0_23_p,
	output wire [127:0] tile224_1_tdata,
 	output wire tile224_1_tvalid,
 	input wire tile224_1_tready,
 	/*tile 226 signals
	*sampling_clk:3.932, refclk:491.520, output_clk:245.760 
	*/
	input wire tile226_clk_n, tile226_clk_p,
	input wire tile226_axis_input_clk,
	//adc physical inputs
	input wire vin2_01_n, vin2_01_p,
	output wire [127:0] tile226_0_tdata,
 	output wire tile226_0_tvalid,
 	input wire tile226_0_tready,
 	//adc physical inputs
	input wire vin2_23_n, vin2_23_p,
	output wire [127:0] tile226_1_tdata,
 	output wire tile226_1_tvalid,
 	input wire tile226_1_tready,
 	output wire axil_arst_n, axil_rst
);



endmodule
`resetall
