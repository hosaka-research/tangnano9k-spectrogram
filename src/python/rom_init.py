
import math
import numpy as np
from numpy import pi
pi2=pi*2
import genverilog

def sqrt_init( abit=12, dbit=18 ):
	return np.array( np.sqrt(np.linspace( 0, (2**abit)-1, (2**abit) ))*(2**(dbit-abit//2)), dtype=np.uint32 )
	
def theta_init( fc, fs, dbit=36 ):
	return np.flip(           # lower frequency upper index
		np.array( (2**dbit)*np.fmod( fc/fs, 1 ), dtype=np.uint64 )  
	)
def sin_rom_init( abit=10, dbit=18 ):
	theta = np.linspace( pi/(2**(2+abit)), pi*((2**(1+abit))-1)/(2**(2+abit)), 2**abit )
	return np.array( (2**(dbit-1)-1)*np.sin( theta ), dtype=np.uint32 )

if __name__ == '__main__':
	#sqrt_rom_str = genverilog.rom( 'sqrt_rom', sqrt_init() )
	#with open( 'sqrt_rom.v', 'w' ) as fp: fp.write( sqrt_rom_str )
	#sin_rom_str = genverilog.rom( 'sin_rom', sin_rom_init(), dbit=18 )
	#with open('sin_rom.v', 'w' ) as fp: fp.write(sin_rom_str)
	fc = np.concatenate( (np.array([10]), np.linspace(10,2390,479)) )
	fs = 6000
	theta_rom_str = genverilog.rom( 'fctheta_rom', theta_init( fc, fs ), abit=10, dbit=36 )
	with open('theta_rom.v', 'w' ) as fp: fp.write(theta_rom_str)
