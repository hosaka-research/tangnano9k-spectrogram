
import numpy as np
import matplotlib.pyplot as plt
import genverilog

A4_Hz=440.0
MIDINO_A4=69

def MIDINO_Hz( midino ):
    return (A4_Hz*pow(2.0,((midino-MIDINO_A4)/12.0)))

def _unused_nco_float( fc_Hz, fs_Hz=12000, outsize=128 ):
    out = np.zeros((len(fc_Hz), outsize, 4), dtype=np.float64 )
    for fi in range(len(fc_Hz)):
        deltarad = 2.0*np.pi*fc_Hz[fi]/fs_Hz
        cosd, sind = np.cos(deltarad*2), np.sin(deltarad*2)
        cos0, sin0 = np.cos(0), np.sin(0)
        cos1, sin1 = np.cos(deltarad), np.sin(deltarad)
        out[fi, 0, :] = [cos0, sin0, cos1, sin1]
        for di in range(1, outsize):
            cos0, sin0 = cos0*cosd-sin0*sind, sin0*cosd+cos0*sind
            cos1, sin1 = cos1*cosd-sin1*sind, sin1*cosd+cos1*sind # take care, updated simultaniosly
            out[fi,di,:] = [cos0, sin0, cos1, sin1]
    return out

def _unused_nco_tblf( fc_Hz, fs_Hz=12000, outsize=128 ):
    nco_init_tblf = np.zeros( (len(fc_Hz), 4), dtype=np.float64)
    for fi in range(len(fc_Hz)):
        deltarad = 2.0*np.pi*fc_Hz[fi]/fs_Hz
        nco_init_tblf[fi,:] = (np.cos(deltarad*2), np.sin(deltarad*2), np.cos(deltarad), np.sin(deltarad)) 
    out = np.zeros((len(fc_Hz), outsize, 4), dtype=np.float64 )
    for fi in range(len(fc_Hz)):
        cosd, sind = nco_init_tblf[fi,0], nco_init_tblf[fi,1]
        cos0, sin0 = 1.0, 0.0
        cos1, sin1 = nco_init_tblf[fi,2], nco_init_tblf[fi,3]
        out[fi, 0, :] = [cos0, sin0, cos1, sin1]
        for di in range(1, outsize):
            cos0, sin0 = cos0*cosd-sin0*sind, sin0*cosd+cos0*sind
            cos1, sin1 = cos1*cosd-sin1*sind, sin1*cosd+cos1*sind # take care, updated simultaniosly
            out[fi,di,:] = [cos0, sin0, cos1, sin1]
    return out

def _unused_nco_tblint( fc_Hz, fs_Hz=12000, outsize=128, dbits=18 ):
    nco_init_tblf = np.zeros( (len(fc_Hz), 4), dtype=np.float64)
    for fi in range(len(fc_Hz)):
        deltarad = 2.0*np.pi*fc_Hz[fi]/fs_Hz
        nco_init_tblf[fi,:] = (np.cos(deltarad*2), np.sin(deltarad*2), np.cos(deltarad), np.sin(deltarad)) 
    nco_init_tbli = np.array( nco_init_tblf * (2**(dbits-1)-1), dtype=np.int64 ) # signed 18bits
    genverilog.rom_write( './nco_rom.v', 'nco_rom', nco_init_tbli.ravel() )
    out = np.zeros((len(fc_Hz), outsize, 4), dtype=np.float64 )
    for fi in range(len(fc_Hz)):
        cosd, sind = nco_init_tbli[fi,0]/(2**(dbits-1)), nco_init_tbli[fi,1]/(2**(dbits-1))
        cos0, sin0 = 1.0, 0.0
        cos1, sin1 = nco_init_tbli[fi,2]/(2**(dbits-1)), nco_init_tbli[fi,3]/(2**(dbits-1))
        out[fi, 0, :] = [cos0, sin0, cos1, sin1]
        for di in range(1, outsize):
            cos0, sin0 = cos0*cosd-sin0*sind, sin0*cosd+cos0*sind
            cos1, sin1 = cos1*cosd-sin1*sind, sin1*cosd+cos1*sind # take care, updated simultaniosly
            out[fi,di,:] = [cos0, sin0, cos1, sin1]
    return out

def _unused_nco_int( fc_Hz, fs_Hz=12000, outsize=128, dbits=18, modulename='nco_rom' ):
    dscale = (2**(dbits-1))
    nco_init_tbli = np.zeros( (len(fc_Hz), 4), dtype=np.int64)
    for fi in range(len(fc_Hz)):
        deltarad = 2.0*np.pi*fc_Hz[fi]/fs_Hz
        nco_init_tbli[fi,:] = (np.cos(deltarad*2)*dscale, np.sin(deltarad*2)*dscale,
                                np.cos(deltarad)*dscale,   np.sin(deltarad)*dscale)
    converted_to_positive = np.where( nco_init_tbli < 0, (2**dbits)+nco_init_tbli, nco_init_tbli )
    genverilog.rom_write( f'./{modulename}.v', modulename, converted_to_positive.ravel(), mode='hex' )
    out = np.zeros((len(fc_Hz), outsize, 4), dtype=np.float64 )
    for fi in range(len(fc_Hz)):
        cosd, sind = nco_init_tbli[fi,0], nco_init_tbli[fi,1]
        cos0, sin0 = dscale, 0
        cos1, sin1 = nco_init_tbli[fi,2], nco_init_tbli[fi,3]
        out[fi, 0, :] = [cos0/dscale, sin0/dscale, cos1/dscale, sin1/dscale]
        for di in range(1, outsize):
            cos0, sin0 = (cos0*cosd-sin0*sind)>>(dbits-2), (sin0*cosd+cos0*sind)>>(dbits-2)
            cos1, sin1 = (cos1*cosd-sin1*sind)>>(dbits-2), (sin1*cosd+cos1*sind)>>(dbits-2)
            out[fi,di,:] = [cos0/dscale, sin0/dscale, cos1/dscale, sin1/dscale]
    return out

def nco_int( fc_Hz, fs_Hz=12000, outsize=128, dbits=18, modulename='nco_rom' ):
    dscale = (2**(dbits-1)-1)
    nco_init_tbli = np.zeros( (len(fc_Hz), 4), dtype=np.int64)
    for fi in range(len(fc_Hz)):
        deltarad = 2.0*np.pi*fc_Hz[fi]/fs_Hz
        nco_init_tbli[fi,:] = (np.cos(deltarad*2)*dscale, np.sin(deltarad*2)*dscale,
                                np.cos(deltarad*1)*dscale,   np.sin(deltarad*1)*dscale)
    converted_positive = np.where( nco_init_tbli<0, (2**dbits)+nco_init_tbli, nco_init_tbli ) 
    genverilog.rom_write( f'./{modulename}.v', modulename, converted_positive.ravel(), dbit=18, abit=11, mode='hex' )
    out = np.zeros((len(fc_Hz), outsize, 4), dtype=np.float64 )
    for fi in range(len(fc_Hz)):
        cosd, sind = nco_init_tbli[fi,0], nco_init_tbli[fi,1]
        cos0, sin0 = dscale, 0
        cos1, sin1 = nco_init_tbli[fi,2], nco_init_tbli[fi,3]
        out[fi, 0, :] = [cos0/dscale, sin0/dscale, cos1/dscale, sin1/dscale]
        for di in range(1, outsize):
            cos0, sin0 = (cos0*cosd-sin0*sind)>>(dbits-1), (sin0*cosd+cos0*sind)>>(dbits-1)
            cos1, sin1 = (cos1*cosd-sin1*sind)>>(dbits-1), (sin1*cosd+cos1*sind)>>(dbits-1)
            out[fi,di,:] = [cos0/dscale, sin0/dscale, cos1/dscale, sin1/dscale]
    return out


def plot_nco( data, fs_Hz=12000, filename='./nco_float.png' ):
    plotsize = min( 13, data.shape[0] )
    fig, axs = plt.subplots( plotsize, 1, sharex='all', figsize=(16,9) )
    time_s0 = 2.0*np.arange(data.shape[1])/fs_Hz
    time_s1 = 2.0*np.arange(0.5,data.shape[1]+0.5)/fs_Hz
    for fi in range(plotsize):
        axs[fi].plot( time_s0, data[fi,:,0], "-r" )
        axs[fi].plot( time_s0, data[fi,:,1], '-g' )
        axs[fi].plot( time_s1, data[fi,:,2], '--b' )
        axs[fi].plot( time_s1, data[fi,:,3], '--k' )
    plt.savefig( filename )
    plt.show()

def equivalent_bit_positive( value, bits ):
    """
    bits 幅の符号付き整数の配列を、ビットパターンが同じbits幅の符号なし整数の配列に変換します
    """
    np.where( value < 0, (2**bits)-value, value )

A4_Hz=440.0
MIDINO_A4=69
def MIDINO_Hz( midino ):
    return (A4_Hz*pow(2.0,((midino-MIDINO_A4)/12.0)))

if __name__ == "__main__":
    #print( fc_test_Hz )
    #plot_nco( nco_float( fc_Hz ) )
    #fc_test_Hz = (MIDINO_Hz(60),MIDINO_Hz(61),MIDINO_Hz(62))
    #plot_nco( nco_int( fc_test_Hz ) )
    fc_Hz =  np.flip(np.concatenate((np.array([10]),np.linspace(10,2390,479))))
    plot_nco( nco_int( fc_Hz ) )