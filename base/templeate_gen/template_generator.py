from config import mpsoc
from mpsoc_tcl import tcl_generator
from mpsoc_verilog import verilog_generator
import os
import numpy as np


if __name__ == '__main__':
    tcl_gen = tcl_generator(mpsoc)
    config_obj = tcl_gen.config
    verilog_generator(config_obj)
    
