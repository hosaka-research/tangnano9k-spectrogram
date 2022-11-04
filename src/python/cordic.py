
import matplotlib.pyplot as plt
import numpy as np
from numpy import pi
pi2 = pi*2

def cordic_z( theta, bits=20, unit='rad' ):
    if unit=='rad' or unit=='radian':
        atan_tbl = np.arctan( 2**(-np.linspace(-2, bits, bits+3)))
        th = np.array( np.mod( theta+pi, pi2 )-pi, dtype=np.float64 )
    elif unit=='angle01':
        atan_tbl = np.arctan( 2**(-np.linspace(-2, bits, bits+3)))/pi2
        th = np.array( np.mod(theta+0.5, 1.0)-0.5, dtype=np.float64 ) # [0->0.5)->[0->0.5), [0.5->1)->[-0.5->0) 
    else:
        raise( ValueError )

    z = np.full( theta.shape, 0.0658658286, dtype=np.complex128 )
    for i in range(bits+3):
        z  += np.where( np.signbit(th),-1,+1 )*1j*(2.0**(2-i))*z
        th -= np.where( np.signbit(th),-1,+1 )*atan_tbl[i]
    return z.real, z.imag

def cordic_f( a, bits=20, unit='rad' ):
    if unit=='rad' or unit=='radian':
        atan_tbl = np.array( np.arctan( np.power( 2, -np.linspace(-2, bits, bits+3))), dtype=np.float64 )
        th = np.array( np.mod( a+pi, pi2 )-pi, dtype=np.float64 )
    elif unit=='angle01':
        atan_tbl = np.array( np.arctan( np.power( 2, -np.linspace(-2, bits, bits+3)))/pi2, dtype=np.float64 )
        th = np.array( np.mod( a+0.5, 1.0 )-0.5, dtype=np.float64 ) # convert {0->0.5, 0.5->1} to {0->0.5, -0.5->0} 
    else:
        raise( ValueError )
        
    re = np.full(  a.shape, 0.0658658286, dtype=np.float64 )
    im = np.zeros( a.shape, dtype=np.float64 )
    for i in range(bits+3):
        imshift = (im>>(i-2) if 2<i else im<<(2-i))
        reshift = (re>>(i-2) if 2<i else re<<(2-i))
        re = re - np.where( np.signbit(th), -imshift, imshift ) # t<0, 0<=t 
        im = im + np.where( np.signbit(th), -reshift, reshift ) # t<0, 0<=t 
        th = th - np.where( np.signbit(th), -atan_tbl[i], atan_tbl[i] ) # t<0, 0<=t 
    return re, im

def cordic_i( theta, bits=20, dtype=np.int64 ):
    atan_tbl = np.array( (2**bits)*np.arctan(2.0**(-np.linspace(-2, bits, bits+3)))/pi2, dtype=dtype )
    re = np.full( theta.shape, ( (2**bits)*0.0658658286), dtype=dtype )
    im = np.zeros( theta.shape, dtype=dtype )
    th = np.array( np.mod(theta+(2**(bits-1)), (2**bits)) - (2**(bits-1)), dtype ) # convert {0->0.5, 0.5->1} to {0->0.5, -0.5->0} 
    for i in range(bits+3):
        imshift = (im>>(i-2) if 2<i else im<<(2-i))
        reshift = (re>>(i-2) if 2<i else re<<(2-i))
        re = re - np.where( np.signbit(th), -imshift, imshift ) # t<0, 0<=t 
        im = im + np.where( np.signbit(th), -reshift, reshift ) # t<0, 0<=t 
        th = th - np.where( np.signbit(th), -atan_tbl[i], atan_tbl[i] ) # t<0, 0<=t 
    return re, im

def hcordic_z( theta, bits=20 ):
    negate = np.logical_and( 0.5*pi <= np.mod( theta, pi2 ), np.mod( theta, pi2 ) < 1.5*pi )
    z = np.full( theta.shape, 0.6072529350, dtype=np.complex128 )
    th = np.array( np.mod( theta+0.5*pi, pi )-0.5*pi, dtype=np.float64 )
    for i in range(bits+1): # repeat bits
        z   = (1+np.where( np.signbit(th),-1,+1 )*1j*(2.0**(-i)))*z
        th -= np.where( np.signbit(th),-1,+1 )*np.arctan(2.0**(-i))
    z = np.where( negate, -z, z )
    return z.real, z.imag

def hcordic_f( theta, bits=20 ):
    negate = np.logical_and( 0.5*pi <= np.mod( theta, pi2 ), np.mod( theta, pi2 ) < 1.5*pi )
    re = np.full( theta.shape, 0.6072529350, dtype=np.float64 )
    im = np.zeros( theta.shape, dtype=np.float64 )
    th = np.array( np.mod( theta+0.5*pi, pi )-0.5*pi, dtype=np.float64 )
    for i in range(bits):
        reshift = re*(2.0**(-i))
        imshift = im*(2.0**(-i))
        re -= np.where( np.signbit(th), -1, +1 )*imshift
        im += np.where( np.signbit(th), -1, +1 )*reshift
        th -= np.where( np.signbit(th), -1, +1 )*np.arctan(2.0**(-i))
    return np.where( negate, -1, +1 )*re, np.where( negate, -1, +1 )*im

def bit_is_1( arr, bit ): return ((arr&(1<<bit))!=0)
def bit_is_0( arr, bit ): return ((arr&(1<<bit))==0)
def limit_signed_bits( arr, bit ):
    return np.where( np.signbit(arr), arr|(~((1<<(bit-1))-1)), arr&((1<<(bit-1))-1) ) # arr<0, 0<=arr
def limit_signdbits_test():
    print( limit_signed_bits( np.arange( -10, 10 ), 3 ) )
def sign_extend( arr, bit ):
    """ データの幅に足りない２の補数を符号拡張します """
    return np.where( bit_is_1( arr, bit-1 ), arr|(~((1<<(bit-1))-1)), arr&((1<<(bit-1))-1) )

def sign_extend_test():
    print( sign_extend( np.arange( 0, 20 ), 3 ) )
def _unused_20221002a_hcordic_i( theta, bits=20, dtype=np.int64 ):
    atan_tbl = np.array( 0.5+(2**bits)*np.arctan(2.0**(-np.arange(bits)))/pi2, dtype=dtype )
    negate = np.logical_and( (2**(bits-2)) <= np.mod( theta, (2**bits) ),
                            np.mod( theta, (2**bits) ) < ((2**(bits-2))+(2**(bits-1)))  )
    print( atan_tbl )
    for index, a in enumerate(atan_tbl):
        print( f'atan_tbl[{index}] = 22\'h{a:x}' ) 
    #re = np.full( theta.shape, ((2**bits)*0.6072529350), dtype=dtype )
    re = np.full( theta.shape, (((2**bits)-1)*0.6072529350), dtype=dtype )
    im = np.zeros( theta.shape, dtype=dtype )
    th = np.array( np.mod( theta+(2**(bits-2)), (2**(bits-1)) )-(2**(bits-2)), dtype=dtype )
    for i in range(bits):
        imshift = im>>i
        reshift = re>>i
        re -= np.where( np.signbit(th), -imshift, imshift ) # t<0, 0<=t 
        im += np.where( np.signbit(th), -reshift, reshift ) # t<0, 0<=t 
        th -= np.where( np.signbit(th), -atan_tbl[i], atan_tbl[i] ) # t<0, 0<=t 
    return np.where( negate, -re, +re ), np.where( negate, -im, +im )

def hcordic_i( theta, inpbits = 20, outbits = 18, dtype=np.int32 ):
    atan_tbl = np.array( 0.5+(1<<inpbits)*np.arctan(2.0**(-np.arange(inpbits)))/pi2, dtype=dtype )
    print( f'{np.min(atan_tbl)=}, {np.max(atan_tbl)=}')
    negate = bit_is_1( theta, 19 ) != bit_is_1( theta, 18 )
    re = np.full( theta.shape, (((1<<(outbits-1))-7)*0.6072529350), dtype=dtype )
    print( f're0 = 22\'h{re[0]:x};' )
    im = np.zeros( theta.shape, dtype=dtype )
    th = np.array( sign_extend( theta, inpbits-1 ), dtype=dtype )
    #ure = np.array( (re[0]&((1<<19)-1),), dtype=np.uint32 )
    #uim = np.array( (im[0]&((1<<19)-1),), dtype=np.uint32 )
    #uth = np.array( (th[0]&((1<<22)-1),), dtype=np.uint32 )
    #print( f'{0}, re={ure[0]:x},  im={uim[0]:x}, th={uth[0]:x}')
    for i, a in enumerate( atan_tbl ):
        # print( f'atan_tbl[{i}]=22\'h{a:x};')
        (re, im, th) = np.where( np.signbit(th), (re+(im>>i), im-(re>>i), th+a), # if th<0
                                                 (re-(im>>i), im+(re>>i), th-a)) # if 0=<th
        #ure = np.array( (re[0]&((1<<19)-1),), dtype=np.uint32 )
        #uim = np.array( (im[0]&((1<<19)-1),), dtype=np.uint32 )
        #uth = np.array( (th[0]&((1<<22)-1),), dtype=np.uint32 )
        # print( f'{i+1}, re={ure[0]:06x},  im={uim[0]:06x}, th={uth[0]:06x}')
    return np.where( negate, (-re, -im), (+re, +im) )

def hcordic_i3( theta, inpbits = 20, outbits = 18, dtype=np.int32 ):
    atan_tbl = np.array( 0.5+(1<<inpbits)*np.arctan(2.0**(-np.arange(inpbits)))/pi2, dtype=dtype )
    
    print( f'{np.min(atan_tbl)=}, {np.max(atan_tbl)=}')
    negate = bit_is_1( theta, 19 ) != bit_is_1( theta, 18 )
    re = np.full( theta.shape, (((1<<(outbits))-9)*0.6072529350/np.sqrt(2)), dtype=dtype )
    print( f're[0]=22\'h{re[0]:x};//  start at pi/4')
    #im = np.zeros( theta.shape, dtype=dtype )
    im = np.copy( re )
    th = np.array( sign_extend( theta, inpbits-1 ), dtype=dtype )
    for i, a in enumerate( atan_tbl ):
        (re, im, th) = np.where( np.signbit(th), (re+(im>>i), im-(re>>i), th+a), # if th<0
                                                 (re-(im>>i), im+(re>>i), th-a)) # if 0=<th
    return np.where( negate, (-re, -im), (+re, +im) )

def rms( arr ): return np.sqrt(np.mean(np.square( arr )))

def show_plot2( x, yarray, plot=['-r', ':b', '-g', ':k'] ):
    cosdiff, sindiff = yarray[3]-yarray[2], yarray[1]-yarray[0],
    print( f'{rms(cosdiff)=:.3e} ' f'{np.min(cosdiff)=:.3e}, {np.max(cosdiff)=:.3e} ' )
    print( f'{np.mean(cosdiff)=}, cos min-max = {np.min(yarray[3]), np.max(yarray[3])} ')
    print( f'{rms(sindiff)=:.3e} ' f'{np.min(sindiff)=:.3e}, {np.max(sindiff)=:.3e} ' )
    print( f'{np.mean(sindiff)=}, sin min-max = {np.min(yarray[1]), np.max(yarray[1])} ' )
    fig, axs = plt.subplots(nrows=2, ncols=1, sharex=True, figsize=(16,5))
    for (idx, y) in enumerate(yarray): axs[0].plot( x, y, plot[idx] )
    axs[1].plot( x, cosdiff, '-r' )
    axs[1].plot( x, sindiff, '-g' )

def test_float():
    bits = 20
    # rad = np.linspace( -pi, pi, 8+1 )
    rad = np.linspace( -pi, pi, (2**(bits)+1 ))
    angle01 = (np.mod( rad+pi2, pi2 )/pi2)
    intangle01 = np.array( angle01*(2**bits), dtype=np.int32 )
    cordic_cos, cordic_sin = hcordic_z( rad, bits )
    npsin, npcos = np.sin(rad), np.cos(rad)
    show_plot2( rad, (npsin, cordic_sin, npcos, cordic_cos) )
    plt.show()

def _unused_20221002a_test_int():
    bits = 20
    #rad = np.linspace( -pi, pi, 8+1 )
    rad = np.linspace( -pi, pi, (2**(bits)+1 ))
    angle01 = (np.mod( rad+pi2, pi2 )/pi2)
    intangle01 = np.array( angle01*(2**bits), dtype=np.int32 )
    cordic_cos, cordic_sin = _unused_20221002a_hcordic_i( intangle01, bits )
    cordic_cos = np.array( cordic_cos, dtype=np.float32 )/(2**bits)
    cordic_sin = np.array( cordic_sin, dtype=np.float32 )/(2**bits)
    npsin, npcos = np.sin(rad), np.cos(rad)
    show_plot2( rad, (npsin, cordic_sin, npcos, cordic_cos) )
    plt.show()

def test_int():
    inpbits = 20
    outbits = 18
    refcorrdigit = 8
    #rad = np.linspace( -pi, pi, 8+1 )
    refk = ((1<<(outbits-1))-refcorrdigit)/(1<<(outbits-1))
    rad = np.linspace( -pi, pi, (2**(inpbits)+1 ))
    angle01 = (np.mod( rad+pi2, pi2 )/pi2)
    intangle01 = np.array( angle01*(2**inpbits), dtype=np.int32 )
    cordic_cos, cordic_sin = hcordic_i( intangle01, inpbits=inpbits, outbits=outbits )
    cordic_cos = np.array( cordic_cos, dtype=np.float32 )/(2**(outbits-1))
    cordic_sin = np.array( cordic_sin, dtype=np.float32 )/(2**(outbits-1))
    npsin, npcos = np.sin(rad)*refk, np.cos(rad)*refk
    show_plot2( rad, (npsin, cordic_sin, npcos, cordic_cos) )
    plt.show()

def test_int2():
    inpbits = 20
    outbits = 18
    refcorrdigit = 12
    cordic_cos, cordic_sin = hcordic_i( np.array( (0x40000,), dtype=np.int32), inpbits=inpbits, outbits=outbits )

def test_int3():
    inpbits = 20
    outbits = 18
    refcorrdigit = 12
    #rad = np.linspace( -pi, pi, 8+1 )
    refk = ((1<<outbits)-refcorrdigit)/(1<<outbits)
    rad = np.linspace( -pi, pi, (2**(inpbits)+1 ))
    angle01 = (np.mod( rad+pi2, pi2 )/pi2)
    intangle01 = np.array( angle01*(2**inpbits), dtype=np.int32 )
    cordic_cos, cordic_sin = hcordic_i3( intangle01, inpbits=inpbits, outbits=outbits )
    cordic_cos = np.array( cordic_cos, dtype=np.float32 )/(2**outbits)
    cordic_sin = np.array( cordic_sin, dtype=np.float32 )/(2**outbits)
    npsin, npcos = np.sin(rad+pi/4)*refk, np.cos(rad+pi/4)*refk
    show_plot2( rad, (npsin, cordic_sin, npcos, cordic_cos) )
    plt.show()

if __name__ == "__main__":
    # limit_signdbits_test()
    # sign_extend_test()
    test_int() 

"""
#include <ap_int.h>
/**************************************************************
 * c=cos(a) s=sin(a)
 *   param range: (2+F) and (2+FA) should be comparable.FA<=30
 *   input range: -PI/2<=a<=PI/2
 *************************************************************/
template <int F,int FA>
void cordic_rot
    (ap_fixed<2+FA,2> a // (i) argument[radian]
    ,ap_fixed<2+F,2> *c // (o) cos
    ,ap_fixed<2+F,2> *s // (o) sin
    ) {
    /* atan table */
    ap_fixed<1+FA,1,AP_RND> atn[31];
    for(int i=0; i<=30; i++) atn[i] = atan(pow(2.0,-i);
    /* initial value x0 */
    ap_fixed<1+F,1,AP_RND> x0 = 0.6072529350;
    /* cordic - rotation mode
     * x[0] = x0
     * y[0] = 0
     * t[0] = a
     * x[i+1] = x[i] - sign(t[i])*y[i]*2**(-i)
     * y[i+1] = y[i] + sign(t[i])*x[i]*2**(-i)
     * t[i+1] = t[i] - sign(t[i])*atan(2**(-i))
     * where sign(t) = (t>=0)? +1 : -1
     */
    ap_fixed<2+F,2> x_tmp;
    ap_fixed<2+F,2> y_tmp;
    ap_fixed<2+F,2> x = x0;
    ap_fixed<2+F,2> y = 0.0;
    ap_fixed<2+FA,2> t = a;
    for(int i=0; i<FA; i++) {
        x_tmp = (x >> i);
        y_tmp = (y >> i);
        if(t[1+FA]) {
            x += y_tmp;
            y -= x_tmp;
            t += atn[i];
        } else {
            x -= y_tmp;
            y += x_tmp;
            t -= atn[i];
        }
    }
    *c = x;
    *s = y;
}


int main(int argc, char *argv[]) {
    const int F = 32;  // fractional part width of c,s
    const int FA = 30; // fractional part width of a (max 30)
    const double PI = 3.14159265358979;
    double a_val;
    double ec,ec_min=1.0,ec_max=-1.0,ec_min_a_val,ec_max_a_val;
    double es,es_min=1.0,es_max=-1.0,es_min_a_val,es_max_a_val;
    ap_fixed<2+FA,2> a; // (i) argument[radian]
    ap_fixed<2+F,2> c;  // (o) cos
    ap_fixed<2+F,2> s;  // (o) sin
    printf("-- F=%-d FA=%-d\n",F,FA);
    const int M = 6 * 1000;
    /* aをPI/2M刻みで振って,cos,sinの最大誤差を表示する */
    for(int i=-M; i<=M; i++) {
        a_val = PI / 2.0 * i / M;
        a = a_val;
        cordic_rot<F,FA>(a,&c,&s);
        ec = c.to_double()-cos(a_val);
        if(ec < ec_min) {ec_min = ec; ec_min_a_val = a_val;}
        if(ec > ec_max) {ec_max = ec; ec_max_a_val = a_val;}
        es = s.to_double()-sin(a_val);
        if(es < es_min) {es_min = es; es_min_a_val = a_val;}
        if(es > es_max) {es_max = es; es_max_a_val = a_val;}
    }
    printf("ec_min=%+3.1e at a=%6.3f\n",ec_min,ec_min_a_val/PI);
    printf("ec_max=%+3.1e at a=%6.3f\n",ec_max,ec_max_a_val/PI);
    printf("es_min=%+3.1e at a=%6.3f\n",es_min,es_min_a_val/PI);
    printf("es_max=%+3.1e at a=%6.3f\n",es_max,es_max_a_val/PI);
    return 0;
}


/*************************************************************
 * c=cos(a) s=sin(a)
 *   param range: (2+F) and (3+FA) should be comparable.FA<=30
 *   input range: -PI<=a<=PI
 ************************************************************/

template <int F,int FA>
void cordic_rot
    (ap_fixed<3+FA,3> a // (i) argument[radian]
    ,ap_fixed<2+F,2> *c // (o) cos
    ,ap_fixed<2+F,2> *s // (o) sin
    ) {
    /* atan table */
    ap_fixed<2+FA,2,AP_RND> atn[33];
    for(int i=-2; i<=30; i++) atn[i+2] = atan(pow(2.0,-i));
    /* initial value x0 */
    ap_fixed<1+F,1,AP_RND> x0 = 0.0658658286;
    /* cordic - rotation mode
     * x[0] = x0
     * y[0] = 0
     * t[0] = a
     * x[i+1] = x[i] - sign(t[i])*y[i]*2**(-i)
     * y[i+1] = y[i] + sign(t[i])*x[i]*2**(-i)
     * t[i+1] = t[i] - sign(t[i])*atan(2**(-i))
     * where sign(t) = (t>=0)? +1 : -1
     */
    ap_fixed<2+F,2>  x_tmp;
    ap_fixed<2+F,2>  y_tmp;
    ap_fixed<2+F,2>  x = x0;
    ap_fixed<2+F,2>  y = 0.0;
    ap_fixed<3+FA,3> t = a;
    for(int i=-2; i<=FA; i++) {
        x_tmp = (x >> i);
        y_tmp = (y >> i);
        if(t[2+FA]) {
            x += y_tmp;
            y -= x_tmp;
            t += atn[i+2];
        } else {
            x -= y_tmp;
            y += x_tmp;
            t -= atn[i+2];
        }
    }
    *c = x;
    *s = y;
}


int main(int argc, char *argv[]) {
    const int F = 32;  // fractional part width of c,s
    const int FA = 30; // fractional part width of a (max 30)
    const double PI = 3.14159265358979;
    double a_val;
    double ec,ec_min=1.0,ec_max=-1.0,ec_min_a_val,ec_max_a_val;
    double es,es_min=1.0,es_max=-1.0,es_min_a_val,es_max_a_val;
    ap_fixed<3+FA,3> a; // (i) argument[radian]
    ap_fixed<2+F,2> c;  // (o) cos
    ap_fixed<2+F,2> s;  // (o) sin
    printf("-- F=%-d FA=%-d\n",F,FA);
    const int M = 12 * 1000;
    /* aをPI/M刻みで振って,cos,sinの最大誤差を表示する */
    for(int i=-M; i<=M; i++) {
        a_val = PI * i / M;
        a = a_val;
        cordic_rot<F,FA>(a,&c,&s);
        ec = c.to_double()-cos(a_val);
        if(ec < ec_min) {ec_min = ec; ec_min_a_val = a_val;}
        if(ec > ec_max) {ec_max = ec; ec_max_a_val = a_val;}
        es = s.to_double()-sin(a_val);
        if(es < es_min) {es_min = es; es_min_a_val = a_val;}
        if(es > es_max) {es_max = es; es_max_a_val = a_val;}
    }
    printf("ec_min=%+3.1e at a=%6.3f\n",ec_min,ec_min_a_val/PI);
    printf("ec_max=%+3.1e at a=%6.3f\n",ec_max,ec_max_a_val/PI);
    printf("es_min=%+3.1e at a=%6.3f\n",es_min,es_min_a_val/PI);
    printf("es_max=%+3.1e at a=%6.3f\n",es_max,es_max_a_val/PI);
    return 0;
}

"""


"""

#include <ap_int.h>
/*************************************************************
 * a = atan2(s,c)
 *  param range: I+F and 2+FA should be comparable. FA<=30
 *  input range: 0<=c<=2**(I-2),-2**(I-2)<=s<=2**(I-2)
 *                 (c,s)!=(0,0)
 ************************************************************/
template <int I,int F,int FA>
void cordic_vec
    (ap_fixed<I+F,I> c   // (i) cos
    ,ap_fixed<I+F,I> s   // (i) sin
    ,ap_fixed<2+FA,2> *a // (o) argument[radian]
    ) {
    /* atan table */
    ap_fixed<1+FA,1,AP_RND> atn[31];
    for(int i=0; i<=30; i++) atn[i] = atan(pow(2.0,-i));
    /* cordic - vector mode
     * x[0] = c
     * y[0] = s
     * t[0] = 0
     * x[i+1] = x[i] + sign(y[i])*y[i]*2**(-i)
     * y[i+1] = y[i] - sign(y[i])*x[i]*2**(-i)
     * t[i+1] = t[i] + sign(y[i])*atan(2**(-i))
     * where sign(y) = (y>=0)? +1 : -1
     */
    ap_fixed<I+1+F,I+1> x_tmp;
    ap_fixed<I+1+F,I+1> y_tmp;
    ap_fixed<I+1+F,I+1> x = c;
    ap_fixed<I+1+F,I+1> y = s;
    ap_fixed<2+FA,2>    t = 0.0;
    for(int i=0; i<=FA; i++) {
        x_tmp = (x >> i);
        y_tmp = (y >> i);
        if(y[I+F]) {
            x -= y_tmp;
            y += x_tmp;
            t -= atn[i];
        } else {
            x += y_tmp;
            y -= x_tmp;
            t += atn[i];
        }
    }
    *a = t;

int main(int argc, char *argv[]) {
  const int I = 2;      // integer part width of c,s
  const int F = 28;     // fractional part width of c,s
  const int FA = 30;    // fractional part width of a (max 30)
  const double PI = 3.14159265358979;
  double a_val;
  double e,e_min=1.0,e_max=-1.0,e_min_c_val,e_min_s_val,e_max_c_val,e_max_s_val;
  ap_fixed<I+F,I> c;    // (i) cos
  ap_fixed<I+F,I> s;    // (i) sin
  ap_fixed<2+FA,2> a;   // (o) argument[radian]
  printf("-- I=%-d F=%-d FA=%-d\n",I,F,FA);
  const int M = 6 * 1000;
  for(int i=-M; i<=M; i++) {
    a_val = PI / 2.0 * i / M;
    c = pow(2.0,I-2) * sqrt(2) * cos(a_val);
    s = pow(2.0,I-2) * sqrt(2) * sin(a_val);
    cordic_vec<I,F,FA>(c,s,&a);
    e = a.to_double()-atan2(s.to_double(),c.to_double());
    if(e < e_min) {e_min=e; e_min_s_val=s.to_double(); e_min_c_val=c.to_double();}
    if(e > e_max) {e_max=e; e_max_s_val=s.to_double(); e_max_c_val=c.to_double();}
  }
  printf("e_min=%+3.1e at s=%+6.3f c=%+6.3f\n",e_min,e_min_s_val,e_min_c_val);
  printf("e_max=%+3.1e at s=%+6.3f c=%+6.3f\n",e_max,e_max_s_val,e_max_c_val);
  return 0;
}
#include <ap_int.h>

/**************************************************************
 * a = atan2(s,c)
 *  param range: I+F and 3+FA should be comparable. FA<=30
 *  input range: -2**(I-2)<=c<=2**(I-2),-2**(I-2)<=s<=2**(I-2)
 *                 (c,s)!=(0,0)
 **************************************************************/
template <int I,int F,int FA>
void cordic_vec
    (ap_fixed<I+F,I> c   // (i) cos
    ,ap_fixed<I+F,I> s   // (i) sin
    ,ap_fixed<3+FA,3> *a // (o) argument[radian]
    ) {
    /* atan table */
    ap_fixed<2+FA,2,AP_RND> atn[33];
    for(int i=-2; i<=30; i++) atn[i+2] = atan(pow(2.0,-i));
    /* cordic - vector mode
     * x[0] = c
     * y[0] = s
     * t[0] = 0
     * x[i+1] = x[i] + sign(y[i])*y[i]*2**(-i)
     * y[i+1] = y[i] - sign(y[i])*x[i]*2**(-i)
     * t[i+1] = t[i] + sign(y[i])*atan(2**(-i))
     * where sign(y) = (y>=0)? +1 : -1
     */
    ap_fixed<I+4+F,I+4> x_tmp;
    ap_fixed<I+4+F,I+4> y_tmp;
    ap_fixed<I+4+F,I+4> x = c;
    ap_fixed<I+4+F,I+4> y = s;
    ap_fixed<3+FA,3>    t = 0.0;
    for(int i=-2; i<=FA; i++) {
        x_tmp = (x >> i);
        y_tmp = (y >> i);
        if(y[I+3+F]) {
            x -= y_tmp;
            y += x_tmp;
            t -= atn[i+2];
        } else {
            x += y_tmp;
            y -= x_tmp;
            t += atn[i+2];
        }
   }
   *a = t;
}


int main(int argc, char *argv[]) {
  const int I = 2;      // integer part width of c,s
  const int F = 28;     // fractional part width of c,s
  const int FA = 30;    // fractional part width of a (max 30)
  const double PI = 3.14159265358979;
  double a_val;
  double e,e_min=1.0,e_max=-1.0,e_min_c_val,e_min_s_val,e_max_c_val,e_max_s_val;
  ap_fixed<I+F,I> c;    // (i) cos
  ap_fixed<I+F,I> s;    // (i) sin
  ap_fixed<3+FA,3> a;   // (o) argument[radian]
  printf("-- I=%-d F=%-d FA=%-d\n",I,F,FA);
  const int M = 12 * 1000;
  for(int i=-M; i<=M; i++) {
    a_val = PI * i / M;
    c = pow(2.0,I-2) * sqrt(2) * cos(a_val);
    s = pow(2.0,I-2) * sqrt(2) * sin(a_val);
    cordic_vec<I,F,FA>(c,s,&a);
    e = a.to_double()-atan2(s.to_double(),c.to_double());
    if(e < e_min) {e_min=e; e_min_s_val=s.to_double(); e_min_c_val=c.to_double();}
    if(e > e_max) {e_max=e; e_max_s_val=s.to_double(); e_max_c_val=c.to_double();}
  }
  printf("e_min=%+3.1e at s=%+6.3f c=%+6.3f\n",e_min,e_min_s_val,e_min_c_val);
  printf("e_max=%+3.1e at s=%+6.3f c=%+6.3f\n",e_max,e_max_s_val,e_max_c_val);
  return 0;
}
"""