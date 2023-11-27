### configuration for the generated code

##
source_tcl = "mpsoc_template.tcl"
source_verilog = "system_wrapper.v"
source_python = "interface_template.py"

#modules
source_axi_reg = "s_axil_reg.v"


mpsoc_clocks = {
        "use" : True,
        "frequency":[150, 100],
        "clock_region" : []
        }

#PL interfaces, PS master 
HPM0_FPD = {
        "use": True,
        "base_addr": 0xA0000000,
        "interconnect": "hpm0_intercon",    ##if None port is connected directly to the output
        "data_width":32,                    ##32,64,128
        "slaves":[
            {
            "size":32,      ##kB
            "type":"bram",   ##register, bram or none
            "bram_width":32,
            "bram_addr":10
            },
            {
            "size" :32,
            "type":"register",
            "reg_numbers":10
            }
        ],
        "clock":0,          
        "clock_intf": "maxihpm0_fpd_aclk",
        "tcl_index":0       ##index when creating the tcl command
    }


HPM1_FPD = {
        "use": True,
        "base_addr": 0xB0000000,
        "interconnect": "hpm1_intercon",    ##if None port is connected directly to the output
        "data_width":64,    
        "slaves":[
            {
            "size":32,  #kB
            "type":"bram",  ##register, bram or none
            "bram_width":32,
            "bram_addr":10
            },
            {
            "size" :32,
            "type":"register",
            "reg_numbers":10
            }
        ],
            "clock":0,
            "clock_intf": "maxihpm1_fpd_aclk",
            "tcl_index":1
    }

##to be implemented!
HPM0_LPD = {
        "use": False,
        "base_addr": 0xB0000000,
        "interconnect": "hpm1_intercon",    ##if None port is connected directly to the output
        "data_width":32,
        "slaves":[
            {
            "size":32*2**10,
            "type":"bram"   ##reg, bram or none
            },
            {
            "size" :32*2**10,
            "type":"reg"
            }
        ],
        "clock":0,
        "clock_intf": "maxihpm0_lpd_aclk",
        "tcl_index":2   
    }

##PS slave, TODO: make this!
HPC0={
        "use":False,
        "data_width":128,
        "dma":False         ##if true instantiate a DMA..not implemented
        }
HPC1={
        "use":False,
        "data_width":128
        }

HP0={
        "use":False,
        "data_width":128
        }
HP1={
        "use":False,
        "data_width":128
        }
HP2={
        "use":False,
        "data_width":128
        }

HP3={
        "use":False,
        "data_width":128
        }
S_LPD={
        "use":False,
        "data_width":128
        }



###Physical signals
physical_pins = {
        "leds":False,
        "push_buttons":False,
        "slide":False,
        "pmod0":{
            "use":False,
            "dir":8*[0]     #0:input, 1:output
            },
        "pmod1":{
            "use":False,
            "dir":8*[0]
            },
        "pmod01":{
            "use":False,
            "dir":6*[0]
            },
        "syzygy":{
            "use":False,
            "dir_d":8*[0],  ##this are the syzygy_D differntial, but also can be used in single ended
            "dir_s":12*[0]  ##this are the syzygy_S
            },
        "QSFO":False,
        "pps":False
        }




##this is the final object that contains the configuration
mpsoc = {
        "mpsoc_clocks": mpsoc_clocks,
        "HPM0_FPD": HPM0_FPD,
        "HPM1_FPD": HPM1_FPD,
        "HPM0_LPD":HPM0_LPD,
        "HPC0":HPC0,
        "HPC1":HPC1,
        "HP0":HP0,
        "HP1":HP1,
        "HP2":HP2,
        "HP3":HP3,
        "S_LPD":S_LPD,
        ##this signals are for the top module
        "physical_pins":physical_pins
        }

