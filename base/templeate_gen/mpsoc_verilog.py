from config import mpsoc
import os
import numpy as np
 

class verilog_generator():
    
    def __init__(self, config_obj, dest_folder='./template'):
        print("verilog generator")
        os.makedirs(dest_folder, exist_ok=True)
        #standard intialization
        self.config = config_obj
        self.wrapper_file = open(os.path.join(dest_folder, 'system_wrapper.v'), 'w')
        self.top_file =  open(os.path.join(dest_folder, 'fpga.v'), 'w')
        self.get_axilite_signals()  ##creates the self.axi_signals obj
        self.generate_system_wrapper()
        self.wrapper_file.close()
        self.generate_top_template()
        self.top_file.close()

    def get_axilite_signals(self, addr_size=40):
        self.axi_lite_signals = {
                '_araddr':{
                    'dir':'output',
                    'size': addr_size
                    },
                '_arprot':{
                    'dir':'output',
                    'size':3
                    },
                '_arready':{
                    'dir':'input',
                    'size':1
                    },
                '_arvalid':{
                    'dir':'output',
                    'size':1
                    },
                '_awaddr':{
                    'dir':'output',
                    'size': addr_size
                    },
                '_awprot':{
                    'dir':'output',
                    'size':3
                    },
                '_awready':{
                    'dir':'input',
                    'size':1
                    },
                '_awvalid':{
                    'dir':'output',
                    'size':1
                    },
                '_bready':{
                    'dir':'output',
                    'size':1
                    },
                '_bresp':{
                    'dir':'input',
                    'size':2
                    },
                '_bvalid':{
                    'dir':'input',
                    'size':1
                    },
                '_rdata':{
                    'dir':'input',
                    'size':32
                    },
                '_rready':{
                    'dir':'output',
                    'size':1
                    },
                '_rresp':{
                    'dir':'input',
                    'size':2
                    },
                '_rvalid':{
                    'dir':'input',
                    'size':1
                    },
                '_wdata':{
                    'dir':'output',
                    'size':32
                    },
                '_wready':{
                    'dir':'input',
                    'size':1
                    },
                '_wstrb':{
                    'dir':'output',
                    'size':4
                    },
                '_wvalid':{
                    'dir':'output',
                    'size':1
                        }
                }


    def generate_system_wrapper(self):
        print("Generating system wrapper")
        #standard initalization
        self.wrapper_file.write("`default_nettype none\n\n\n")
        self.wrapper_file.write("// This wrapper is only to simulate, the one used when compiling is generated  by vivado\n")
        self.wrapper_file.write("module system_wrapper (\n")
        #create clocks interface
        if(self.config['mpsoc_clocks']['use']):
            for freq in self.config['mpsoc_clocks']['frequency']:
                self.wrapper_file.write("\toutput wire mpsoc_clk_%i,\n"%freq)
        hp_master_ports = ['HPM0_FPD','HPM1_FPD', 'HPM0_LPD']
        for hp_port in hp_master_ports:
            if(self.config[hp_port]['use']):
                self.wrapper_file.write("\t//%s signals\n"%hp_port)
                for slave in self.config[hp_port]['slaves']:
                    if(slave['type']!='rfdc'):
                        port_name = slave['port_name']
                        for axi_name, axi_item in self.axi_lite_signals.items():
                            msg = '\t'+axi_item['dir']+' wire '
                            if(axi_item['size']>1):
                                msg+= " [%i:0] "%(axi_item['size']-1)
                            msg += port_name+axi_name+",\n"
                            self.wrapper_file.write(msg)
        #TODO:add the rfdc signals!
        if(self.config['rfdc']['use']):
            self.wrapper_file.write("\t//RFDC signals\n")
            self.wrapper_file.write("\tinput wire rfdc_sysref_n, rfdc_sysref_p,\n")
            for i, tile in enumerate(self.config['rfdc']['adc_tiles']):
                if(not tile['use']):
                    continue
                self.wrapper_file.write("\t/*tile %i signals\n"%tile['number'])
                self.wrapper_file.write("\t*sampling_clk:%.3f, refclk:%.3f, output_clk:%.3f \n\t*/\n"%(tile['sampling_rate'], tile['ref_clk'], tile['out_clk']))
                self.wrapper_file.write("\tinput wire tile%i_clk_n, tile%i_clk_p,\n"%(tile['number'], tile['number']))
                self.wrapper_file.write("\tinput wire tile%i_axis_input_clk,\n"%tile['number'])
                if(tile['adc0']['use']):
                    self.wrapper_file.write("\t//adc physical inputs\n")
                    self.wrapper_file.write("\tinput wire vin%i_01_n, vin%i_01_p,\n"%(i,i))
                    self.wrapper_file.write("\toutput wire [%i:0] tile%i_0_tdata,\n "%(tile['adc0']['samples']*16-1, tile['number']))
                    self.wrapper_file.write("\toutput wire tile%i_0_tvalid,\n "%tile['number'])
                    self.wrapper_file.write("\tinput wire tile%i_0_tready,\n "%tile['number'])
                if(tile['adc1']['use']):
                    self.wrapper_file.write("\t//adc physical inputs\n")
                    self.wrapper_file.write("\tinput wire vin%i_23_n, vin%i_23_p,\n"%(i,i))
                    self.wrapper_file.write("\toutput wire [%i:0] tile%i_1_tdata,\n "%(tile['adc1']['samples']*16-1, tile['number']))
                    self.wrapper_file.write("\toutput wire tile%i_1_tvalid,\n "%tile['number'])
                    self.wrapper_file.write("\tinput wire tile%i_1_tready,\n "%tile['number'])



        #reset signals
        self.wrapper_file.write("\toutput wire axil_arst_n, axil_rst\n")
        self.wrapper_file.write(");\n")
        self.wrapper_file.write("\n\n\n")
        self.wrapper_file.write("endmodule\n")
        self.wrapper_file.write("`resetall")
    
    ###
    ### For the top verilog code
    ###
    def generate_top_template(self):
        print("Generating top template")
        self.top_file.write("`default_nettype none\n\n") 
        self.top_file.write("//Top template\n")
        self.top_file.write("module fpga (\n")
        self.top_physical_interface() 
        self.create_mpsoc_wires()
        ##just for the naming of the instances
        self.axil_reg_count = 0
        self.axil_bram_count = 0
        self.create_axil_slaves()
        self.top_file.write("endmodule\n")
        self.top_file.write("`resetall")

    def top_physical_interface(self):
        ##leds
        self.top_file.write(" \n")
        pins = self.config['physical_pins']
        if(pins['leds']):
            self.top_file.write("\toutput wire [3:0] w_led,\n")
            self.top_file.write("\toutput wire [1:0] r_led, g_led, b_led,\n")
        if(pins['push_buttons']):
            self.top_file.write("\tinput wire [4:0] push_button,\n")
        if(pins['slide']):
            self.top_file.write("\tinput wire [3:0] slide_switch\n")
        if(pins['pmod0']['use']):
            ##check if the number of directions match the amount of pins
            if(len(pins['pmod0']['dir'])!=8):
                raise Exception("pmod0 number of pins in config file is not 8!")

            if(all(pins['pmod0']['dir'])):
                self.top_file.write("\toutput wire [7:0] pmod0,\n")
            elif(all( x==0 for x in pins['pmod0']['dir'])):
                self.top_file.write("\tinput wire [7:0] pmod0,\n")
            else:
                out_msg = ''
                in_msg = ''
                for i, direction in enumerate(pins['pmod0']['dir']):
                    if(direction):
                        out_msg+= 'pmod0[%i], '%i
                    else:
                        in_msg+= 'pmod0[%i], '%i
            self.top_file.write('\toutput wire %s \n'%out_msg)
            self.top_file.write("\tinput wire %s \n"%in_msg)
                    
        if(pins['pmod1']['use']):
            ##check if the number of directions match the amount of pins
            if(len(pins['pmod1']['dir'])!=8):
                raise Exception("pmod1 number of pins in config file is not 8!")

            if(all(pins['pmod1']['dir'])):
                self.top_file.write("\toutput wire [7:0] pmod1,\n")
            elif(all( x==0 for x in pins['pmod1']['dir'])):
                self.top_file.write("\tinput wire [7:0] pmod1,\n")
            else:
                out_msg = ''
                in_msg = ''
                for i, direction in enumerate(pins['pmod1']['dir']):
                    if(direction):
                        out_msg+= 'pmod1[%i], '%i
                    else:
                        in_msg+= 'pmod1[%i], '%i
            self.top_file.write('\toutput wire %s \n'%out_msg)
            self.top_file.write("\tinput wire %s \n"%in_msg)

        if(pins['pmod01']['use']):
            ##check if the number of directions match the amount of pins
            if(len(pins['pmod01']['dir'])!=6):
                raise Exception("pmod01 number of pins in config file is not 6!")

            if(all(pins['pmod01']['dir'])):
                self.top_file.write("\toutput wire [5:0] pmod01,\n")
            elif(all( x==0 for x in pins['pmod01']['dir'])):
                self.top_file.write("\tinput wire [5:0] pmod01,\n")
            else:
                out_msg = ''
                in_msg = ''
                for i, direction in enumerate(pins['pmod01']['dir']):
                    if(direction):
                        out_msg+= 'pmod01[%i], '%i
                    else:
                        in_msg+= 'pmod01[%i], '%i
            self.top_file.write('\toutput wire %s \n'%out_msg)
            self.top_file.write("\tinput wire %s \n"%in_msg)

        if(pins['syzygy']['use']):
            ##d ports
            d_port = ["syzygy_d%i"%x for x in range(8)]
            aux = {0:"_p", 1:"_n"} 
            if(len(pins['syzygy']['dir_d'])!=16):
                raise Exception("syzygy pin d number in the config file is not 16!")

            out_msg = ""
            in_msg = ""
            for i, direction in enumerate(pins['syzygy']['dir_d']):
                if(direction):
                    out_msg += d_port[i//2]+aux[i%2]+', '
                else:
                    in_msg += d_port[i//2]+aux[i%2]+', '
            if(len(out_msg)>0):
                self.top_file.write("\toutput wire %s\n"%out_msg)
            if(len(in_msg)>0):
                self.top_file.write("\tinput wire %s\n"%in_msg)
            ##s ports
            s_port = ['syzygy_s%i'%x for x in range(16,28)]
            if(len(pins['syzygy']['dir_s'])!=12):
                raise Exception("syzygy pin s number in the config file is not 12!")
            out_msg = ""
            in_msg = ""
            for i, direction in enumerate(pins['syzygy']['dir_s']):
                if(direction):
                    out_msg += s_port[i]+", "
                else:
                    in_msg += s_port[i]+", "
            if(len(out_msg)>0):
                self.top_file.write("\toutput wire %s\n"%out_msg)
            if(len(in_msg)>0):
                self.top_file.write("\tinput wire %s\n"%in_msg)
            ##TODO add the syzygy clock signals
        #TODO
        ###Check the signals!!!
        if(self.config['rfdc']['use']):
            self.top_file.write("\t//rfdc signals, check if the signals are ok...\n")
            self.top_file.write("\tinput wire sysref_in_n, sysref_in_p,\n")
            for i, tile in enumerate(self.config['rfdc']['adc_tiles']):
                if(not tile['use']):
                    continue
                self.top_file.write("\tinput wire adc%i_clk_n, adc%i_clk_p,\n"%(i,i))

                if(tile['adc0']['use']):
                    self.top_file.write("\tinput wire vin%i_01_n, vin%i_01_p,\n"%(i,i))
                
                if(tile['adc1']['use']):
                    self.top_file.write("\tinput wire vin%i_23_n, vin%i_23_p,\n"%(i,i))

        #if(pins['qsfp']):
        #if(pins['pps'])

        cur_pos = self.top_file.tell()
        self.top_file.seek(cur_pos-2,0)
        self.top_file.write("\n")
        self.top_file.write(");\n")
        self.top_file.write("\n\n\n")
    
    def create_mpsoc_wires(self):
        if(self.config['mpsoc_clocks']['use']):
            for freq in self.config['mpsoc_clocks']['frequency']:
                self.top_file.write("wire mpsoc_clk_%i;\n"%freq)
        hp_master_ports = ['HPM0_FPD','HPM1_FPD', 'HPM0_LPD']
        for hp_port in hp_master_ports:
            if(self.config[hp_port]['use']):
                self.top_file.write("//%s signals\n"%hp_port)
                for slave in self.config[hp_port]['slaves']:
                    if(slave['type']!='rfdc'):
                        port_name = slave['port_name']
                        for axi_name, axi_item in self.axi_lite_signals.items():
                            msg = 'wire '
                            if(axi_item['size']>1):
                                msg+= " [%i:0] "%(axi_item['size']-1)
                            msg += port_name+axi_name+";\n"
                            self.top_file.write(msg)
        ##TODO: add the rfdc signals
        if(self.config['rfdc']['use']):
            self.top_file.write("//rfdc signals\n")
            for i, tile in enumerate(self.config['rfdc']['adc_tiles']):
                if(not tile['use']):
                    continue
                if(tile['adc0']['use']):
                    ##check the order!
                    self.top_file.write("wire signed [15:0] ")
                    for j in range(tile['adc0']['samples']):
                        self.top_file.write("tile%i_adc0_%i"%(tile['number'], j))
                        if(j!=tile['adc1']['samples']-1):
                            self.top_file.write(", ")
                        if(j%3==2):
                            self.top_file.write("\n\t\t\t\t")
                    self.top_file.write(";\n")
                    self.top_file.write("wire tile%i_0_tvalid;\n"%tile['number'])
                if(tile['adc1']['use']):
                    ##check the order!
                    self.top_file.write("wire signed [15:0] ")
                    for j in range(tile['adc1']['samples']):
                        self.top_file.write("tile%i_adc1_%i"%(tile['number'], j))
                        if(j!=tile['adc1']['samples']-1):
                            self.top_file.write(", ")
                        if(j%3==2):
                            self.top_file.write("\n\t\t\t\t")
                    self.top_file.write(";\n")
                    self.top_file.write("wire tile%i_1_tvalid;\n"%tile['number'])
                    self.top_file.write("\n")
        ##TODO:add the DAC signals!



        self.top_file.write("wire axil_arst_n, axil_rst;\n")
        ##create bd_design wrapper
        self.top_file.write("\n\nsystem_wrapper system_wrapper_inst (\n")
        if(self.config['mpsoc_clocks']['use']):
            for freq in self.config['mpsoc_clocks']['frequency']:
                self.top_file.write("\t.mpsoc_clk_%i(mpsoc_clk_%i),\n"%(freq, freq))
        
        for hp_port in hp_master_ports:
            if(self.config[hp_port]['use']):
                self.top_file.write("\t//%s signals\n"%hp_port)
                for slave in self.config[hp_port]['slaves']:
                    if(slave['type']!='rfdc'):
                        port_name = slave['port_name']
                        for axi_name, axi_item in self.axi_lite_signals.items():
                            msg = "\t."+port_name+axi_name+"("+port_name+axi_name+'),\n'
                            self.top_file.write(msg)
        ##TODO: rfdc signals
        if(self.config['rfdc']['use']):
            self.top_file.write("\t//rfdc singals\n")
            self.top_file.write("\t.rfdc_sysref_n(sysref_in_n),\n")
            self.top_file.write("\t.rfdc_sysref_p(sysref_in_p),\n")
            for i, tile in enumerate(self.config['rfdc']['adc_tiles']):
                if(tile['use']):
                    self.top_file.write("\t//tile%i signals\n"%tile['number'])
                    self.top_file.write("\t.tile%i_clk_n(),\n"%tile['number'])
                    self.top_file.write("\t.tile%i_clk_p(),\n"%tile['number'])
                    self.top_file.write("\t.tile%i_axis_input_clk(),\n"%tile['number'])
                    if(tile['adc0']['use']):
                        self.top_file.write("\t.vin%i_01_n(vin%i_01_n),\n"%(i,i))
                        self.top_file.write("\t.vin%i_01_p(vin%i_01_p),\n"%(i,i))
                        self.top_file.write("\t//axi-stream adc0 signals\n")
                        self.top_file.write("\t.tile%i_0_tvalid(tile%i_0_tvalid),\n"%(tile['number'], tile['number'])) 
                        self.top_file.write("\t.tile%i_0_tready(1'b1),\n"%tile['number'])
                        self.top_file.write("\t.tile%i_0_tdata({\t"%tile['number'])
                        for j in range(tile['adc0']['samples']):
                            self.top_file.write("tile%i_adc0_%i"%(tile['number'], j))
                            if(j!=tile['adc0']['samples']-1):
                                self.top_file.write(", ")
                            if(j==tile['adc0']['samples']//2):
                                self.top_file.write("\n\t\t\t\t\t\t")
                        self.top_file.write("}),\n")
                    if(tile['adc1']['use']):
                        self.top_file.write("\t.vin%i_23_n(vin%i_23_n),\n"%(i,i))
                        self.top_file.write("\t.vin%i_23_p(vin%i_23_p),\n"%(i,i))
                        self.top_file.write("\t//axi-stream adc1 signals\n")
                        self.top_file.write("\t.tile%i_1_tvalid(tile%i_1_tvalid),\n"%(tile['number'], tile['number'])) 
                        self.top_file.write("\t.tile%i_1_tready(1'b1),\n"%tile['number'])
                        self.top_file.write("\t.tile%i_1_tdata({\t"%tile['number'])
                        for j in range(tile['adc1']['samples']):
                            self.top_file.write("tile%i_adc1_%i"%(tile['number'], j))
                            if(j!=tile['adc0']['samples']-1):
                                self.top_file.write(", ")
                            if(j==tile['adc1']['samples']//2):
                                self.top_file.write("\n\t\t\t\t\t\t")
                        self.top_file.write("}),\n")


        
        self.top_file.write("\t.axil_rst(axil_rst),\n")
        self.top_file.write("\t.axil_arst_n(axil_arst_n)\n")
        self.top_file.write(");\n")
        

        
         
    def create_axil_slaves(self):
        hp_master_ports = ['HPM0_FPD','HPM1_FPD', 'HPM0_LPD']
        for hp_port in hp_master_ports:
            if(self.config[hp_port]['use']):
                for slave in self.config[hp_port]['slaves']:
                    intf_clock = 'mpsoc_clk_%i'%(self.config['mpsoc_clocks']['frequency'][self.config[hp_port]['clock']])
                    #print(slave['type'])
                    if(slave['type']=='register'):
                        self.register_verilog(slave, intf_clock)
                    elif(slave['type']=='bram'):
                        self.bram_verilog(slave, intf_clock)

    
    def register_verilog(self, slave, clock):
        """
        This uses the s_axil_reg.v as templatate
        """
        self.top_file.write("\ns_axil_reg #(\n")
        self.top_file.write("\t.DATA_WIDTH(32),\n")
        self.top_file.write("\t.ADDR_WIDTH(%i)\n"%(np.ceil(np.log2(slave['reg_numbers']))))
        self.top_file.write(") s_axil_reg_inst%i (\n"%self.axil_reg_count)
        self.axil_reg_count+=1
        self.top_file.write("//\n//put user inputs outputs \n//\n")
        for axi_name, axi_item in self.axi_lite_signals.items():
            s_port = '\t.s_axil'+axi_name+'('
            mpsoc_wire = slave['port_name']+axi_name+'),\n'
            self.top_file.write(s_port+mpsoc_wire)
        self.top_file.write("\t.axi_clock(%s),\n"%(clock))
        self.top_file.write("\t.rst(axil_rst)\n")
        self.top_file.write(");\n")
         


    def bram_verilog(self, slave, clock):
        """
        This uses the axil_bram_unbalanced as template and leaves the fpga interface without connections
        """
        self.top_file.write("\n axil_bram_unbalanced #(\n")
        self.top_file.write("\t.FPGA_DATA_WIDTH(%i),\n"%slave['bram_width']),
        self.top_file.write("\t.FPGA_ADDR_WIDTH(%i),\n"%slave['bram_addr']),
        self.top_file.write("\t.AXI_DATA_WIDTH(32)\n")
        self.top_file.write(") axil_bram_inst%i (\n"%self.axil_bram_count)
        self.axil_bram_count +=1 
        self.top_file.write("\t.fpga_clk(),\n")
        self.top_file.write("\t.bram_din(),\n")
        self.top_file.write("\t.bram_addr(),\n")
        self.top_file.write("\t.bram_we(),\n")
        self.top_file.write("\t.bram_dout(),\n")
        for axi_name, axi_item in self.axi_lite_signals.items():
            s_port = '\t.s_axil'+axi_name+'('
            mpsoc_wire = slave['port_name']+axi_name+'),\n'
            self.top_file.write(s_port+mpsoc_wire)
        self.top_file.write("\t.axi_clock(%s),\n"%(clock))
        self.top_file.write("\t.rst(axil_rst)\n")
        self.top_file.write(");\n")
        
        return 0
         
    

          

    
        
                         

                        
                     
                 


        
         

    
