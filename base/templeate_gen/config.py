### configuration for the generated code

##
source_tcl = "mpsoc_template.tcl"
source_verilog = "system_wrapper.v"
source_python = "interface_template.py"

#modules
source_axi_reg = "s_axil_reg.v"


mpsoc_clocks = {
        "use" : True,
        "frequency":[100],
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
            },
            {
            "size":256,
            "type":"rfdc"
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

###only for rfsoc, rfdc

"""
Some notes about the rfdc: 
    -when mixer is in coarse the valid values are: 
    output type
        iq:
            real-iq:fs/2, fs/4, -fs/4
            real-iq:0, fs/2, fs/4, fs/
        real:
            real-real: 0
    -mixer can be set to coarse only in iq output mode:
        -then you can set the frequency and the phase of the NCO

For some reason vivado just let me use real->iq in the mixer when selecting iq output

This template is a pain.. there are several options that dont work and its just try and error...

TODO: A good script to check the values before runing the shit in vivado
"""

rfdc = {
        "use":True,
        "axi_master":{"name":"HPM0_FPD",
                      "interconnect":True,
                      "clock":0,
                      "size":256
                      },
        "adc_tiles":[
            {   
                "number":224,
                "use":True,
                "pll":True,
                "sampling_rate":3.93216/3,    #in ghz
                "ref_clk":491.520,          #mhz
                "out_clk":245.760/2,          #mhz    
                "clock_dist":1,
                "clock_source":0,
                "adc0":{
                    "use":True,
                    "output":"real",    #real,complex
                    "decimation":1,     #1,2,3,4,5,6,8,10,12,16,20,24,40
                    "samples":8,        #4,5,6,7,8,9,10,11,12
                    ##when output is iq the mixer is set to fine
                    "mixer_mode":"real_iq", #only when output is complex, options: real_iq and iq_iq
                    "mixer_freq":1,         ##GHz
                    "mixer_phase":0
                    },
                "adc1":{
                    "use":True,
                    "output":"real",    #real,complex
                    "decimation":1,     #1,2,3,4,5,6,8,10,12,16,20,24,40
                    "samples":8,        #4,5,6,7,8,9,10,11,12
                    ##mixer type is always set to
                    "mixer_mode":"real_iq", #only when output is complex, options: real_iq and iq_iq
                    "mixer_freq":1,         ##GHz
                    "mixer_phase":0
                    }
                },
            {   "number":225,
                "use":False,
                "pll":True,
                "sampling_rate":3.93216,    #in ghz
                "ref_clk":491.520,          #mhz
                "out_clk":245.760,          #mhz    
                "clock_dist":1,             #0:off, 1:input_ref_clk, 2:pll output
                "clock_source":0,           #0:tile224, 1:225, 2:226, 3:227 (to be checkes)
                "adc0":{
                    "use":True,
                    "output":"real",    #real,complex
                    "decimation":1,     #1,2,3,4,5,6,8,10,12,16,20,24,40
                    "samples":8,        #4,5,6,7,8,9,10,11,12
                    ##mixer type is always set to
                    "mixer_mode":"real_iq", #only when output is complex, options: real_iq and iq_iq
                    "mixer_freq":1,         ##GHz
                    "mixer_phase":0
                    },
                "adc1":{
                    "use":True,
                    "output":"real",    #real,complex
                    "decimation":1,     #1,2,3,4,5,6,8,10,12,16,20,24,40
                    "samples":8,        #4,5,6,7,8,9,10,11,12
                    ##mixer type is always set to
                    "mixer_mode":"real_iq", #only when output is complex, options: real_iq and iq_iq
                    "mixer_freq":1,         ##GHz
                    "mixer_phase":0
                    },
                },

            {   "number":226,
                "use":True,
                "pll":True,
                "sampling_rate":3.93216,    #in ghz
                "ref_clk":491.520,          #mhz
                "out_clk":245.760,          #mhz    
                "clock_dist":1,             #
                "clock_source":2,           #the tile itself
                "adc0":{
                    "use":True,
                    "output":"real",    #real,complex
                    "decimation":1,     #1,2,3,4,5,6,8,10,12,16,20,24,40
                    "samples":8,        #4,5,6,7,8,9,10,11,12
                    ##mixer type is always set to
                    "mixer_mode":"real_iq", #only when output is complex, options: real_iq and iq_iq
                    "mixer_freq":1,         ##GHz
                    "mixer_phase":0,
                    },
                'adc1':{
                    "use":True,
                    "output":"real",    #real,complex
                    "decimation":1,     #1,2,3,4,5,6,8,10,12,16,20,24,40
                    "samples":8,        #4,5,6,7,8,9,10,11,12
                    ##mixer type is always set to
                    "mixer_mode":"real_iq", #only when output is complex, options: real_iq and iq_iq
                    "mixer_freq":1,         ##GHz
                    "mixer_phase":0
                    },
                },

            {   "number":227,
                "use":False,
                "pll":True,
                "sampling_rate":3.93216,    #in ghz
                "ref_clk":491.520,          #mhz
                "out_clk":245.760,          #mhz    
                "clock_dist":1,
                "clock_source":0,
                "adc0":{
                    "use":True,
                    "output":"real",    #real,complex
                    "decimation":1,     #1,2,3,4,5,6,8,10,12,16,20,24,40
                    "samples":8,        #4,5,6,7,8,9,10,11,12
                    ##mixer type is always set to
                    "mixer_mode":"real_iq", #only when output is complex, options: real_iq and iq_iq
                    "mixer_freq":1,         ##GHz
                    "mixer_phase":0
                    },
                "adc1":{
                    "use":True,
                    "output":"real",    #real,complex
                    "decimation":1,     #1,2,3,4,5,6,8,10,12,16,20,24,40
                    "samples":8,        #4,5,6,7,8,9,10,11,12
                    ##mixer type is always set to
                    "mixer_mode":"real_iq", #only when output is complex, options: real_iq and iq_iq
                    "mixer_freq":1,         ##GHz
                    "mixer_phase":0
                    },
                }
            ]
            }



          






###Physical signals only for the top.v
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
        ##for rfsoc
        "rfdc":rfdc,
        ##this signals are for the top module
        "physical_pins":physical_pins
        }

