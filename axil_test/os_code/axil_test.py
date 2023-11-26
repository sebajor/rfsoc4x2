
import mmap
import os
import struct
import numpy as np

filename = '/home/casper/bitfiles/axil_test/pga.bin'

dev_mem_file = '/dev/mem'

reg_info = {
        'baseaddr'  :0xA1100000,
        'size'      :8*8
        }
bram_info = {
        'baseaddr'  :0xA0000000,
        'size'      :2**10*4*8
        }

##program the pl using the pcap
os.system('sudo fpgautil -b %s -f Force'%filename)
os.system('sudo chmod 777 %s' %dev_mem_file)

fpga_mem = open(dev_mem_file, 'r+b')

reg = mmap.mmap(fpga_mem, reg_info['size'], offset=reg_info['baseaddr'])
bram = mmap.mmap(fpga_mem, bram_info['size'], offset=bram_info['baseaddr'])


##write data into the bram using the register
reg[8:12] = struct.pack('I', 1)
data = np.random.randint(2**32-1, size=2**10).astype(np.int32)
for i in range(len(data)):
    reg[4:8] = struct.pack('I', i)
    reg[:4] = struct.pack('I', data[i])
reg[8:12] = struct.pack('I', 0)

##now read back the data from the bram
for i in range(len(data)):
    bram_dat = struct.unpack('I', bram[4*i:4*(i+1)])[0]
    print("addr:%i gold:%i bram:%i"%(i,data[i], bram_dat))
    assert(data[i]==bram_dat)


