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

        self.rfdc()

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
                ##first we need to get the actual freq that the mpsoc output
                self.file.write("set freq%i_mhz [get_property CONFIG.PSU__CRL_APB__PL%i_REF_CTRL__ACT_FREQMHZ [get_bd_cells mpsoc]]\n"%(i,i))
                self.file.write("set freq%i_hz [expr $freq%i_mhz*1e6]\n"%(i,i))
                self.file.write("set_property -dict [list CONFIG.FREQ_HZ $freq%i_hz] [get_bd_ports mpsoc_clk_%i]\n"%(i, freq))
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
                
                ##check if one of the slaves is a rfdc, to give it space
                slaves_rfdc = [(x['type']=='rfdc' )for x in hp['slaves']]
                if(any(slaves_rfdc)):
                    axil_addr += 256*2**10
                for i, slave in enumerate(hp['slaves']):
                    if(slave['type']!='rfdc'):
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
                        ##add the base address to the config object
                        self.config[port]['slaves'][i]['base_addr'] = axil_addr
                        axil_addr = axil_addr+slave['size']*2**10

        else:
            self.file.write("set_property -dict [list CONFIG.PSU__USE__M_AXI_GP%i {0}] [get_bd_cells mpsoc] \n"%hp['tcl_index'])


    def hp_slaves(self, port):
        ##TODO
        return 1

    def rfdc(self):
        if(not self.config['rfdc']['use']):
            return 0
        self.file.write("\n\n###RFDC part\n")
        self.file.write("create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter:* rfdc\n")
        master = self.config['rfdc']['axi_master']
        intf = self.config[master['name']]
        if(master['interconnect']):
            ##search the port of the rfdc in the interconnect
            slaves_rfdc = [(x['type']=='rfdc' )for x in intf['slaves']]
            rfdc_intercon_n = np.arange(len(slaves_rfdc))[slaves_rfdc][0]
            ##connect again the restets and clocks
            self.file.write("connect_bd_net -net axil_arst_n [get_bd_pins {:}/M{:02d}_ARESETN] \n".format(intf['interconnect'], rfdc_intercon_n))
            self.file.write("connect_bd_net -net mpsoc_clk{:} [get_bd_pins {:}/M{:02d}_ACLK] \n".format(intf['clock'],intf['interconnect'], rfdc_intercon_n))
            self.file.write("connect_bd_net -net mpsoc_clk{:} [get_bd_pins rfdc/s_axi_aclk]\n".format(intf['clock']))
            self.file.write("connect_bd_net -net axil_arst_n [get_bd_pins rfdc/s_axi_aresetn] \n")
            #connect the master interconnect
            self.file.write("connect_bd_intf_net [get_bd_intf_pins {:}/M{:02d}_AXI] -boundary_type upper [get_bd_intf_pins rfdc/s_axi]\n".format(intf['interconnect'], rfdc_intercon_n))
            ##get last addr
            axil_addr = intf['base_addr']
            rfdc_size = 256 #k  
            self.file.write("assign_bd_address [get_bd_addr_segs {rfdc/s_axi/Reg }]\n")
            self.file.write("set_property range %iK [get_bd_addr_segs {mpsoc/Data/SEG_rfdc_Reg}]\n"%(rfdc_size))
            self.file.write("set_property offset 0x%X [get_bd_addr_segs {mpsoc/Data/SEG_rfdc_Reg}]\n"%(axil_addr))
        else:
            ##TODO
            raise Exception("RFDC without inmterconnect not yet implemented!")
    
        
        ##start to configure the ADCs
        for i, tile in enumerate(self.config['rfdc']['adc_tiles']):
            self.file.write("\n##configure tile %i\n"%tile['number'])
            self.file.write("set_property CONFIG.ADC%i_En {%s} [get_bd_cells rfdc] \n"%(tile['number'],str(tile['use']).lower() ))
            self.file.write("set_property CONFIG.ADC%i_Enable {%i} [get_bd_cells rfdc] \n"%(i,int(tile['use'])))
            if(not tile['use']):
                continue
            dtype_aux = {'real':0, 'complex':1}
            mixer_mode_aux = {'real_iq':0, 'iq_iq':1}
            adcs = ['adc0', 'adc1']
            ##adc0  
            for j, adc in enumerate(adcs):
                self.file.write("##configure %s from tile %i\n"%(adc, tile['number']))
                self.file.write("set_property CONFIG.ADC_Slice%i%i_Enable {%s} [get_bd_cells rfdc]\n"%(i, 2*j,str(tile['adc0']['use']).lower()))
                self.file.write("set_property CONFIG.ADC_Data_Type%i%i {%i} [get_bd_cells rfdc]\n"%(i,2*j, dtype_aux[tile['adc0']['output']]))
                self.file.write("set_property CONFIG.ADC_Decimation_Mode%i%i {%i} [get_bd_cells rfdc]\n"%(i,2*j, tile['adc0']['decimation']))
                self.file.write("set_property CONFIG.ADC_Data_Width%i%i {%i} [get_bd_cells rfdc]\n"%(i,2*j, tile['adc0']['samples']))
                ### 
                if(tile['adc0']['output']=='complex'):
                    self.file("##configure mixer for %s from tile %i\n"%(adc, tile['number']))
                    ##mixer type: 1=coarse, 2=fine
                    self.file.write("set_property CONFIG.ADC_Mixer_Type%i%i {2} [get_bd_cells rfdc]\n"%(i,2*j))
                    ##output mixer: real-iq=0 and iq-iq=1
                    self.file.write("set_property CONFIG.ADC_Mixer_Mode%i%i {0} [get_bd_cells rfdc]\n"%(i,2*j, tile['adc0']['mixer_mode']))
                    ##just in case here i put how to set the coarse one, 0:fs/2, 1:fs/4, 2:-fs/4
                    ##set_param CONFIG.ADC_Coarse_Mixer_Freq00 {i} [get_bd_cells rfdc] 
                    self.file.write("set_property CONFIG.ADC_NCO_Freq%i%i {%f} [get_bd_cells rfdc]\n"%(i,2*j, tile['adc0']['mixer_freq']))
                self.file.write("set_property CONFIG.ADC_CalOpt_Mode%i%i {1} [get_bd_cells rfdc]\n"%(i,2*j))
            ##create clocks 
            self.file.write("\n##create rfdc adc clocks\n")
            self.file.write("create_bd_port -dir I -type clk -freq_hz %i tile%i_clk_p\n"%(int(tile['ref_clk']*10e6), tile['number']))
            self.file.write("create_bd_port -dir I -type clk -freq_hz %i tile%i_clk_n\n"%(int(tile['ref_clk']*10e6), tile['number']))
            self.file.write("connect_bd_net [get_bd_pins rfdc/adc%i_clk_p] [get_bd_ports tile%i_clk_p] \n"%(i,tile['number']))
            self.file.write("connect_bd_net [get_bd_pins rfdc/adc%i_clk_n] [get_bd_ports tile%i_clk_n] \n"%(i,tile['number']))
            ##axis clock
            self.file.write("create_bd_port -dir I -type clk -freq_hz %i tile%i_axis_input_clk\n"%(int(tile['out_clk']*10e6), tile['number']))
            self.file.write("connect_bd_net [get_bd_pins rfdc/m%i_axis_aclk] [get_bd_ports tile%i_axis_input_clk]\n"%(i,tile['number']))
            ##data clocks
            self.file.write("create_bd_port -dir O -type clk tile%i_data_clk\n"%tile['number'])
            self.file.write("connect_bd_net [get_bd_pins rfdc/clk_adc%i] [get_bd_ports tile%i_data_clk]\n"%(i,tile['number']))

            self.file.write("set_property CONFIG.ADC%i_Sampling_Rate {%f} [get_bd_cells rfdc]\n"%(i,tile['sampling_rate']))
            self.file.write("set_property CONFIG.ADC%i_PLL_Enable {%s} [get_bd_cells rfdc]\n"%(i,str(tile['pll']).lower()))
            self.file.write("set_property CONFIG.ADC%i_Refclk_Freq {%.3f} [get_bd_cells rfdc]\n"%(i,tile['ref_clk']))
            self.file.write("set_property CONFIG.ADC%i_Outclk_Freq {%.3f} [get_bd_cells rfdc]\n"%(i,tile['out_clk']))
            self.file.write("set_property CONFIG.ADC%i_Fabric_Freq {%.3f} [get_bd_cells rfdc]\n"%(i,tile['out_clk']))
            self.file.write("set_property CONFIG.ADC%i_Multi_Tile_Sync {false} [get_bd_cells rfdc]\n"%(i))
            self.file.write("set_property CONFIG.ADC%i_Clock_Dist {%i} [get_bd_cells rfdc]\n"%(i, tile['clock_dist']))
            self.file.write("set_property CONFIG.ADC%i_Clock_Source {%i} [get_bd_cells rfdc]\n"%(i, tile['clock_source']))

            ##physical pins
            self.file.write("\n##create physical pins\n")
            if(tile['adc0']['use']):
                ##input signal
                self.file.write("create_bd_port -dir I vin%i_01_n\n"%i)
                self.file.write("create_bd_port -dir I vin%i_01_p\n"%i)
                self.file.write("connect_bd_net [get_bd_pins rfdc/vin%i_01_n] [get_bd_ports vin%i_01_n]\n"%(i,i))
                self.file.write("connect_bd_net [get_bd_pins rfdc/vin%i_01_p] [get_bd_ports vin%i_01_p]\n"%(i,i))
                #output signal
                self.file.write("create_bd_port -dir O -from %i -to 0 tile%i_0_tdata\n" %(int(tile['adc0']['samples']*16-1), tile['number']))
                self.file.write("create_bd_port -dir O tile%i_0_tvalid\n" %tile['number'])
                self.file.write("create_bd_port -dir I tile%i_0_tready\n" %tile['number'])
                self.file.write("connect_bd_net [get_bd_pins rfdc/m%i0_axis_tdata] [get_bd_ports tile%i_0_tdata]\n"%(i,tile['number']))
                self.file.write("connect_bd_net [get_bd_pins rfdc/m%i0_axis_tvalid] [get_bd_ports tile%i_0_tvalid]\n"%(i,tile['number']))
                self.file.write("connect_bd_net [get_bd_pins rfdc/m%i0_axis_tready] [get_bd_ports tile%i_0_tready]\n"%(i,tile['number']))
                 
            if(tile['adc1']['use']):
                ##input signal
                self.file.write("create_bd_port -dir I vin%i_23_n\n"%i)
                self.file.write("create_bd_port -dir I vin%i_23_p\n"%i)
                self.file.write("connect_bd_net [get_bd_pins rfdc/vin%i_23_n] [get_bd_ports vin%i_23_n]\n"%(i,i))
                self.file.write("connect_bd_net [get_bd_pins rfdc/vin%i_23_p] [get_bd_ports vin%i_23_p]\n"%(i,i))
                #output signal
                self.file.write("create_bd_port -dir O -from %i -to 0 tile%i_1_tdata\n" %(int(tile['adc1']['samples']*16-1), tile['number']))
                self.file.write("create_bd_port -dir O tile%i_1_tvalid\n" %tile['number'])
                self.file.write("create_bd_port -dir I tile%i_1_tready\n" %tile['number'])
                self.file.write("connect_bd_net [get_bd_pins rfdc/m%i2_axis_tdata] [get_bd_ports tile%i_1_tdata]\n"%(i,tile['number']))
                self.file.write("connect_bd_net [get_bd_pins rfdc/m%i2_axis_tvalid] [get_bd_ports tile%i_1_tvalid]\n"%(i,tile['number']))
                self.file.write("connect_bd_net [get_bd_pins rfdc/m%i2_axis_tready] [get_bd_ports tile%i_1_tready]\n"%(i,tile['number']))
        ##rfdc sysref clk
        self.file.write("\n##rfdc sysref clk\n")
        self.file.write("create_bd_port -dir I rfdc_sysref_p\n")
        self.file.write("create_bd_port -dir I rfdc_sysref_n\n")
        self.file.write("connect_bd_net [get_bd_pins rfdc/sysref_in_p] [get_bd_ports rfdc_sysref_p]\n")
        self.file.write("connect_bd_net [get_bd_pins rfdc/sysref_in_n] [get_bd_ports rfdc_sysref_n]\n")
        


