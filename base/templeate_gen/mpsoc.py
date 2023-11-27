from config import mpsoc
import os
import numpy as np

class tcl_generator():

    def __init__(self, config_obj, dest_folder='./template'):
        os.makedirs(dest_folder, exist_ok=True)
        #standard intialization
        self.config = config_obj
        self.file = open(os.path.join(dest_folder, 'mpsoc.tcl'), 'w')
        self.standard_intialization()
        ##the create_clocks create a clk net called mpsoc_clk%i 
        ##the output ports are called mpsoc_clk_%f with f the freq in mhz
        self.create_clocks()
        
        ##reset system, create the nets: pl_rstn, axil_rst and axil_rstn (uses the mpsoc_clk0 net)
        ##the output ports are axil_rst, axil_arestn 
        self.reset_system()
        ##
        self.hp_master_ports('HPM0_FPD')
        self.hp_master_ports('HPM1_FPD')
        self.hp_master_ports('HPM0_LPD')

        self.hp_slaves("HPC0")
        self.hp_slaves("HPC1")
        self.hp_slaves("HP0")
        self.hp_slaves("HP1")
        self.hp_slaves("HP2")
        self.hp_slaves("HP3")
        self.hp_slaves("S_LPD")

        self.file.write("\n##set clock of the axi-lite interfaces\n")
        #set the clock region of the axil ports
        for i, clk_region in enumerate(self.config['mpsoc_clocks']['clock_region']):
            clk_msg = ""
            for intf in clk_region:
                clk_msg += intf+":"
            pin_clk = 'mpsoc_clk_%i'%self.config['mpsoc_clocks']['frequency'][i]
            if(clk_msg!=""):
                self.file.write("set_property CONFIG.ASSOCIATED_BUSIF {%s} [get_bd_ports /%s]\n"%(clk_msg[:-1], pin_clk))
        
        ##generate the wrapper
        self.file.write("make_wrapper -files [get_files $bd_dir/system.bd] -top\n")
        self.file.write("import_files -force -norecurse $bd_dir/hdl/system_wrapper.v\n")
        self.file.write("write_bd_tcl -force $cur_dir/rev/system.tcl\n")
        self.file.close()




    def standard_intialization(self):
        self.file.write("set cur_dir [pwd]\n")
        self.file.write("puts $cur_dir\n")
        self.file.write("set bd_dir $cur_dir/fpga.srcs/sources_1/bd/system\n")
        self.file.write("exec mkdir -p $cur_dir/rev\n\n")
        self.file.write("create_bd_design system\n")
        self.file.write("#instantiate ps\n")
        self.file.write("create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:* mpsoc\n")
        self.file.write("create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:* proc_sys_reset\n")
        self.file.write("#source the standard configuration\n")
        self.file.write("source ../ip/rfsoc4x2_mpsoc.tcl\n")

        

    def create_clocks(self):
        if(self.config['mpsoc_clocks']['use']):
            self.file.write("\n\n#mpsoc clocks generation\n") 
            for i, freq in enumerate(self.config['mpsoc_clocks']['frequency']):
                self.file.write("#creating clock %i \n"%i) 
                self.file.write("set_property -dict [list CONFIG.PSU__FPGA_PL%i_ENABLE {1}] [get_bd_cells mpsoc]\n"%i)
                self.file.write("set_property -dict [list CONFIG.PSU__CRL_APB__PL%i_REF_CTRL__FREQMHZ {%f}] [get_bd_cells mpsoc]\n"%(i,freq))
                #create clock output port
                self.file.write("create_bd_net mpsoc_clk%i\n"%i)
                self.file.write("connect_bd_net -net mpsoc_clk%i [get_bd_pins mpsoc/pl_clk%i]\n"%(i,i))
                self.file.write("create_bd_port -dir O -type clk mpsoc_clk_%i\n"%freq)
                self.file.write("connect_bd_net -net mpsoc_clk%i [get_bd_ports mpsoc_clk_%i]\n"%(i,freq))
                #set the frequency of the port accordingly
                self.file.write("set_property -dict [list CONFIG.FREQ_HZ {%i}] [get_bd_ports mpsoc_clk_%i]\n"%(freq*1e6, freq))
                self.config['mpsoc_clocks']['clock_region'].append([])


    def reset_system(self):
        self.file.write("\n\n##reseting system")
        self.file.write("create_bd_net pl_resetn\n")
        self.file.write("connect_bd_net -net pl_resetn [get_bd_pins mpsoc/pl_resetn0]\n")
        self.file.write("create_bd_net axil_rst\n")
        self.file.write("create_bd_net axil_arst_n\n")
        ##connect the clock to the proc_sys_rst
        self.file.write("connect_bd_net -net mpsoc_clk0 [get_bd_pins proc_sys_reset/slowest_sync_clk]\n")
        ##make the resets external
        self.file.write("connect_bd_net -net pl_resetn [get_bd_pins proc_sys_reset/ext_reset_in]\n")
        self.file.write("connect_bd_net -net axil_rst [get_bd_pins proc_sys_reset/peripheral_reset]\n")
        self.file.write("connect_bd_net -net axil_arst_n [get_bd_pins proc_sys_reset/peripheral_aresetn]\n")
        self.file.write("create_bd_port -dir O -type rst axil_rst\n")
        self.file.write("create_bd_port -dir O -type rst axil_arst_n\n")
        self.file.write("connect_bd_net -net axil_rst [get_bd_ports axil_rst]\n")
        self.file.write("connect_bd_net -net axil_arst_n [get_bd_ports axil_arst_n]\n")


    def hp_master_ports(self, port):
        hp = self.config[port] 
        self.file.write("\n\n##configuration for %s\n"%port)
        if(hp['use']):
            self.file.write("set_property -dict [list CONFIG.PSU__USE__M_AXI_GP%i {1}] [get_bd_cells mpsoc] \n"%hp['tcl_index'])
            self.file.write("set_property -dict [list CONFIG.PSU__MAXIGP%i__DATA_WIDTH {%i}] [get_bd_cells mpsoc] \n"%(hp['tcl_index'],hp["data_width"]))
            ##connect the clock
            self.file.write("##connect the clock\n")
            self.file.write("connect_bd_net -net mpsoc_clk%i [get_bd_pins mpsoc/%s]\n"%(hp['clock'], hp['clock_intf']))
            ##instantiate the interconnect
            if(hp['interconnect'] is not None):
                self.file.write("##creating interconnect\n")
                self.file.write("create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* %s \n"%hp['interconnect'])
                self.file.write("set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {%i}] [get_bd_cells %s]\n"%(len(hp['slaves']), hp['interconnect']))
                ##connect the clock and rst of the interconnect
                self.file.write("connect_bd_net -net axil_arst_n [get_bd_pins %s/ARESETN] \n"%hp['interconnect'])
                self.file.write("connect_bd_net -net mpsoc_clk%i [get_bd_pins %s/ACLK] \n"%(hp['clock'],hp['interconnect']))
                
                self.file.write("connect_bd_net -net axil_arst_n [get_bd_pins %s/S00_ARESETN] \n"%hp['interconnect'])
                self.file.write("connect_bd_net -net mpsoc_clk%i [get_bd_pins %s/S00_ACLK] \n"%(hp['clock'],hp['interconnect']))

                ##set the PS as the master of the interconect
                self.file.write("connect_bd_intf_net [get_bd_intf_pins mpsoc/M_AXI_%s] -boundary_type upper [get_bd_intf_pins %s/S00_AXI]\n"%(port, hp['interconnect']))
                #create axil ports
                axil_addr = hp['base_addr']
                acc = 0
                #axil_boundary = axil_addr+4*2**10   ##4kB boundary
                for i, slave in enumerate(hp['slaves']):
                    self.file.write("make_bd_intf_pins_external  [get_bd_intf_pins {:}/M{:02d}_AXI]\n".format(hp['interconnect'], i))
                    #change name of the port
                    axil_name = port+"_M{:02d}_axil".format(i)
                    slave['port_name'] = axil_name
                    self.file.write("set_property name {:} [get_bd_intf_ports M{:02d}_AXI_0]\n".format(axil_name,i))
                    ##set the protocol of the port
                    self.file.write("set_property CONFIG.PROTOCOL AXI4LITE [get_bd_intf_ports /{:}]\n".format(axil_name))
                    ## add this interface to the clock region that it belongs
                    self.config['mpsoc_clocks']['clock_region'][hp['clock']].append(axil_name)
                    #connect the master clocks of the interconnect
                    self.file.write("connect_bd_net -net axil_arst_n [get_bd_pins {:}/M{:02d}_ARESETN] \n".format(hp['interconnect'], i))
                    self.file.write("connect_bd_net -net mpsoc_clk{:} [get_bd_pins {:}/M{:02d}_ACLK] \n".format(hp['clock'],hp['interconnect'], i))
                    ##now we set the addresses :O
                    self.file.write("assign_bd_address [get_bd_addr_segs {%s/Reg }]\n"%axil_name)
                    #calculate the last addr that should take to check if cross the boundary
                    warning = (axil_addr)%(2*32*2**10)   ##detect when the current address is in the middle of a 4kB zone
                    #print(hex(axil_addr)+"  %i    salve_size:%i"%(warning, slave['size']*2**10))
                    if((warning!=0) and (warning<(slave['size']*2**10))):
                        ##the current address is in the middle of a 4kb zone and the size of the slave is bigger
                        axil_addr = axil_addr+warning
                    self.file.write("set_property range %iK [get_bd_addr_segs {mpsoc/Data/SEG_%s_Reg}]\n"%(slave['size'], axil_name))
                    self.file.write("set_property offset 0x%X [get_bd_addr_segs {mpsoc/Data/SEG_%s_Reg}]\n"%(axil_addr, axil_name))
                    axil_addr = axil_addr+slave['size']*2**10

        else:
            self.file.write("set_property -dict [list CONFIG.PSU__USE__M_AXI_GP%i {0}] [get_bd_cells mpsoc] \n"%hp['tcl_index'])


    def hp_slaves(self, port):
        ##TODO
        return 1



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
                    port_name = slave['port_name']
                    for axi_name, axi_item in self.axi_lite_signals.items():
                        msg = '\t'+axi_item['dir']+' wire '
                        if(axi_item['size']>1):
                            msg+= " [%i:0] "%(axi_item['size']-1)
                        msg += port_name+axi_name+",\n"
                        self.wrapper_file.write(msg)
        #TODO:add the rfdc signals!
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
                    port_name = slave['port_name']
                    for axi_name, axi_item in self.axi_lite_signals.items():
                        msg = 'wire '
                        if(axi_item['size']>1):
                            msg+= " [%i:0] "%(axi_item['size']-1)
                        msg += port_name+axi_name+";\n"
                        self.top_file.write(msg)
        ##TODO: add the rfdc signals
        ##create bd_design wrapper
        self.top_file.write("\n\nsystem_wrapper system_wrapper_inst (\n")
        if(self.config['mpsoc_clocks']['use']):
            for freq in self.config['mpsoc_clocks']['frequency']:
                self.top_file.write("\t.mpsoc_clk_%i(mpsoc_clk_%i),\n"%(freq, freq))
        
        for hp_port in hp_master_ports:
            if(self.config[hp_port]['use']):
                self.top_file.write("\t//%s signals\n"%hp_port)
                for slave in self.config[hp_port]['slaves']:
                    port_name = slave['port_name']
                    for axi_name, axi_item in self.axi_lite_signals.items():
                        msg = "\t."+port_name+axi_name+"("+port_name+axi_name+'),\n'
                        self.top_file.write(msg)
        ##TODO: rfdc signals
        cur_pos = self.top_file.tell()
        self.top_file.seek(cur_pos-2,0)
        self.top_file.write("\n")
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
         
    

          

    
        
                         

                        
                     
                 


        
         

if __name__ == '__main__':
    tcl_gen = tcl_generator(mpsoc)
    config_obj = tcl_gen.config
    verilog_generator(config_obj)
    
    
