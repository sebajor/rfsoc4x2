



        




class mpsoc():

    def __init__(self):
        self.name = "mpsoc"
        self.hpm0_fpd = {
                'use' : 0,
                'bitwidth':32,
                'base_addr':0xA000_0000,
                'intercon': False
                }
        


        self.hpm0_fpd_cmd ={ 
                'use_command': 'CONFIG.PSU__USE__M_AXI_GP0 {'+str(self.hpm0[])'}',
                ''
                }
        
        
