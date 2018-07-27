;+
;Name: Oiv_isolate_062443.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/23

PRO Oiv_isolate_062443

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/iso_vars_062443.sav'
RESTORE, rfname

;load the data

IRast_062443_Oiv = '/data/khnum/REU2018/abacon/data/20130927_062443/iris_l2_20130927_062443_4000254145_raster_t000_r00000.fits'

SJI1400_062443_Oiv = '/data/khnum/REU2018/abacon/data/20130927_062443/iris_l2_20130927_062443_4000254145_SJI_1400_t000.fits'

;read the data

dataRast_062443_Oiv = IRIS_OBJ(IRast_062443_Oiv)

data1400_062443_Oiv = IRIS_SJI(SJI1400_062443_Oiv)

;load images/profiles

dataRast_062443_Oiv->SHOW_LINES
spectraRast1403_062443_Oiv = dataRast_062443_Oiv->GETVAR(5, /LOAD)

images1400_062443_Oiv = data1400_062443_Oiv->GETVAR()

;get spectral information

lambda1403_062443_Oiv = dataRast_062443_Oiv->GETLAM(5) ;1399.0634-1405.9831
pxlslitRast_062443_Oiv = dataRast_062443_Oiv->GETNSLIT(5) ;1096

ResX1400_062443_Oiv = data1400_062443_Oiv->GETRESX()
ResY1400_062443_Oiv = data1400_062443_Oiv->GETRESY()

SolarX1400_062443_Oiv = data1400_062443_Oiv->XSCALE()
SolarY1400_062443_Oiv = data1400_062443_Oiv->YSCALE()

;get exposure time in prep for normalization

exp_arrRast_062443_Oiv = dataRast_062443_Oiv->GETEXP() ;clean--no 0s exposures

;get every data point in each lambda, y-pos, and image

cube1403_062443_Oiv = spectraRast1403_062443_Oiv[*,*,*] ;SIZE: 3D, 273,1096,400, float

;count the number of images of original cube

array1403_062443_Oiv = spectraRast1403_062443_Oiv[0,0,*]

array1400_062443_Oiv = images1400_062443_Oiv[0,0,*]

nImages1403_062443_Oiv = N_ELEMENTS(array1403_062443_Oiv) ;400 images

;********GUIDANCE FROM CHAD********
;Takes the array image values and
;determines the size of the array
;in x/y through N_ELEMENTS.
;The array elements are integers, so
;DOUBLE() transforms them into decimals.

nx = DOUBLE(N_ELEMENTS(array1400_062443_Oiv[*,0]))
ny = DOUBLE(N_ELEMENTS(array1400_062443_Oiv[0,*]))
;**********************************

;number of elements in wavelength, ypos, and image of original cube

n_img1403_062443_Oiv = N_ELEMENTS(spectraRast1403_062443_Oiv[0,0,*]) ;400 images
n_wav1403_062443_Oiv = N_ELEMENTS(spectraRast1403_062443_Oiv[*,0,0]) ;273 wavelengths b/w 1399-1405
n_ypos1403_062443_Oiv = N_ELEMENTS(spectraRast1403_062443_Oiv[0,*,0]) ;1096 y-positions

;remove overscan by making a tilt and applying a cut, then make a new array

cut_062443_Oiv = MEAN(MEAN(spectraRast1403_062443_Oiv, DIMENSION = 2), DIMENSION = 2) ;SIZE: 1D, 273, float

;PLOT, cut_062443_Oiv

spectra1403_062443_Oiv = cut_062443_Oiv[19:105]

;PLOT, spectra1403_062443_Oiv
;PLOT, lambda1403_062443_Oiv[19:105], spectra1403_062443_Oiv

nspectraRast1403_062443_Oiv = spectraRast1403_062443_Oiv[19:105,*,*]

;number of elements in new array: wavelength, ypos, and image of cut cube

n_wav_062443_Oiv = N_ELEMENTS(nspectraRast1403_062443_Oiv[*,0,0]) ;87
n_ypos_062443_Oiv = N_ELEMENTS(nspectraRast1403_062443_Oiv[0,*,0]) ;1096
n_img_062443_Oiv = N_ELEMENTS(nspectraRast1403_062443_Oiv[0,0,*]) ;400

;loop for (new) exposure time normalization

FOR i = 0, nImages1403_062443_Oiv-1 DO BEGIN
nspectraRast1403_062443_Oiv[*,*,i] = nspectraRast1403_062443_Oiv[*,*,i]/exp_arrRast_062443_Oiv[i]
ENDFOR

;get average Si IV line profile of entire observation in order to get lambda0

avg_prof_062443_Oiv = MEAN(MEAN(nspectraRast1403_062443_Oiv, DIMENSION = 2), DIMENSION = 2)

avg_fit_062443_Oiv = MPFITPEAK(lambda1403_062443_Oiv[19:105], avg_prof_062443_Oiv, coeff_avg_062443_Oiv)

wave0_062443_Oiv = coeff_avg_062443_Oiv[1] ;1401.2066

;********GUIDANCE FROM CHAD********
;Instead of assigning hard-coded
;window size info, assign to vars.
;Again, tranform from integer to
;decimal by using 'D'
wsx = 900D
wsy = 700D
;**********************************

WINDOW, XSIZE = wsx, YSIZE = wsy

;********GUIDANCE FROM CHAD********
;Aspect ratio (AR): ratio of w to h of img
;or screen.
;AR uses the number of pixels and resolution
;of the plot.
aspr = (ny*ResY1400_062443_Oiv)/(nx*ResX1400_062443_Oiv)
aspw = wsy/wsx

;Number of rows and columns on plotting window
;(want in decimal form).
nr = 1.0
nc = 1.0

;Choose x0 and calc. y0, dx, and dy using:
x0 = 0.2
y0 = 0.5*(1.0-((aspr/aspw)*(nr/nc)*(1.0-(2.0*x0))))
dx = (1.0/nc)*(1.0-(2.0*x0))
dy = (1.0/nr)*(1.0-(2.0*y0))

;Print values
;PRINT, aspr, aspw, x0, y0, dx, dy

;STOP
;**********************************

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_062443_Oiv = N_ELEMENTS(nspectraRast1403_062443_Oiv[0,0,*]) ;400
yposition_062443_Oiv = N_ELEMENTS(nspectraRast1403_062443_Oiv[0,*,0]) ;1096

UVB_ind_ry_062443_Oiv = ARRAY_INDICES([raster_062443_Oiv,yposition_062443_Oiv], UVB_ind_062443, /DIMENSIONS)
;PRINT, SIZE(UVB_ind_ry_062443_Oiv) ;2D 2,284 where 2 is [raster,ypos]

UVB_ind_r_062443_Oiv = REFORM(UVB_ind_ry_062443_Oiv[0,*]) ;1D 284
UVB_ind_y_062443_Oiv = REFORM(UVB_ind_ry_062443_Oiv[1,*]) ;1D 284

;pull out all red rectangle UVB pop. indices

UVB_size_062443_Oiv = N_ELEMENTS(UVB_ind_062443) ;284
UVB_ind_r_s_062443_Oiv = N_ELEMENTS(UVB_ind_r_062443_Oiv) ;284
UVB_ind_y_s_062443_Oiv = N_ELEMENTS(UVB_ind_y_062443_Oiv) ;284

;create array to hold coeff paramters from FOR loop

coeff_arr_062443_Oiv = DBLARR(4,UVB_size_062443_Oiv)

;FOR loop with cut array and coeff_arr_062443_Oiv above

TIC
FOR i = 0, UVB_size_062443_Oiv-1 DO BEGIN
	PLOT, lambda1403_062443_Oiv[19:105], REFORM(nspectraRast1403_062443_Oiv[*,UVB_ind_y_062443_Oiv[i],UVB_ind_r_062443_Oiv[i]]), XRANGE = [1399.3, 1405.8], TITLE = 'AR11850_062443_Oiv Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_062443_Oiv = MPFITPEAK(lambda1403_062443_Oiv[19:105], REFORM(nspectraRast1403_062443_Oiv[*,UVB_ind_y_062443_Oiv[i],UVB_ind_r_062443_Oiv[i]]), coeff_062443_Oiv, NTERMS = 4, STATUS = status, ERRMSG = errmsg)
	OPLOT, lambda1403_062443_Oiv[19:105], YFIT_062443_Oiv, COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_062443_Oiv[*,i] = coeff_062443_Oiv
ENDFOR
TOC ;Time elapsed: ~3.5 sec 

;save parameters from nested FOR loop

sfname = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_062443/coeff_arr_062443_Oiv.sav'
SAVE, coeff_062443_Oiv, spectraRast1403_062443_Oiv, nspectraRast1403_062443_Oiv, coeff_arr_062443_Oiv, wave0_062443_Oiv, FILENAME = sfname

rfname2 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_062443/coeff_arr_062443_Oiv.sav'
RESTORE, rfname2

R = (1.75)^2 ;counts/pxl
g = 7.2 ;photons/count
dt = 2.0
inst_unc = [ABS((REFORM(nspectraRast1403_062443_Oiv[*,UVB_ind_y_062443_Oiv,UVB_ind_r_062443_Oiv]))/(g*dt))+R]^0.5
;PRINT, inst_unc

coeff_arr_062443_Oiv2 = DBLARR(4,UVB_size_062443_Oiv)
sigma_coeff_arr = DBLARR(4,UVB_size_062443_Oiv)

PRINT, SIZE(inst_unc)

TIC
FOR i = 0, UVB_size_062443_Oiv-1 DO BEGIN
	PLOT, lambda1403_062443_Oiv[19:105], REFORM(nspectraRast1403_062443_Oiv[*,UVB_ind_y_062443_Oiv[i],UVB_ind_r_062443_Oiv[i]]), XRANGE = [1399.3, 1405.8], TITLE = 'AR11850_062443_Oiv Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_062443_Oiv2 = MPFITPEAK(lambda1403_062443_Oiv[19:105], REFORM(nspectraRast1403_062443_Oiv[*,UVB_ind_y_062443_Oiv[i],UVB_ind_r_062443_Oiv[i]]), coeff_062443_Oiv2, NTERMS = 4, PERROR = sigma_coeff, ERROR = inst_unc[*,i,i], ESTIMATES = [5.0,1401.163,0.1,0.0])
        OPLOT, lambda1403_062443_Oiv[19:105], REFORM(YFIT_062443_Oiv2), COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_062443_Oiv2[*,i] = coeff_062443_Oiv2
	sigma_coeff_arr[*,i] = sigma_coeff 
ENDFOR
TOC ;Time elapsed: ~3.5 sec

;PRINT, coeff_arr_062443_Oiv2
;PRINT, sigma_coeff_arr

p_int = coeff_arr_062443_Oiv2[0,*,*]
sig_lw = sigma_coeff_arr[2,*,*]
lw = coeff_arr_062443_Oiv2[2,*,*]
sig_p_int = sigma_coeff_arr[0,*,*]

It = (sqrt(2.0*!dpi)*p_int*lw) ;total integrated intensity 

PRINT, 'integrated intensity uncertainty'

int_int_unc = [2.0*!dpi*((p_int)^2*(sig_lw)^2+(lw)^2*(sig_p_int)^2)]^0.5
PRINT, int_int_unc

PRINT, 'SNR by dividing total integrated intensity by uncertainty'

SNR_0 = It/int_int_unc
PRINT, SNR_0

PRINT, 'SNR rearrangement'

neg = -0.5
SNR = (((sig_p_int)^2/(p_int)^2)+((sig_lw)^2/(lw)^2))^neg
PRINT, SNR

PRINT, SIZE(SNR)
SNR2 = WHERE((SNR LT 15), count) ;remove infinity
PRINT, SIZE(SNR[SNR2])

PLOT, HISTOGRAM(SNR[SNR2], BINSIZE = 0.5), PSYM = 10, XTITLE = "Signal-to-Noise", YTITLE = "Frequency", TITLE = "Histogram of Signal-to-Noise of AR11850_20130927_062443"
OPLOT, HISTOGRAM(SNR[SNR2], BINSIZE = 0.5), COLOR = 150

;save as png

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
PLOT, HISTOGRAM(SNR[SNR2], BINSIZE = 0.5), PSYM = 10, XTITLE = "Signal-to-Noise", YTITLE = "Frequency", TITLE = "Histogram of Signal-to-Noise of AR11850_20130927_062443"
OPLOT, HISTOGRAM(SNR[SNR2], BINSIZE = 0.5), COLOR = 150
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_062443/histogram_062443.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 8, YSIZE = 8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_062443/histogram_062443.eps', /ENCAPSULATED

PLOT, HISTOGRAM(SNR[SNR2], BINSIZE = 0.5), PSYM = 10, XTITLE = "Signal-to-Noise", YTITLE = "Frequency", TITLE = "Histogram of Signal-to-Noise of AR11850_20130927_062443"
OPLOT, HISTOGRAM(SNR[SNR2], BINSIZE = 0.5), COLOR = 150

DEVICE, /CLOSE

PRINT, 'MIN: ', MIN(SNR[SNR2])
PRINT, 'MAX: ', MAX(SNR[SNR2])
PRINT, 'MODE: ', WHERE(SNR[SNR2] EQ MAX(SNR[SNR2]), count) + MIN(SNR[SNR2])
PRINT, 'MEDIAN: ', MEDIAN(SNR[SNR2])

MOM = MOMENT(SNR[SNR2])
PRINT, 'MEAN: ', MOM[0] & PRINT, 'VARIANCE: ', MOM[1] & PRINT, 'SKEWNESS: ', MOM[2] & PRINT, 'KURTOSIS: ', MOM[3]

;save parameters from FOR loop

sfname2 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_062443/sigma_coeff_arr_062443_Oiv.sav'
SAVE, coeff_062443_Oiv2, inst_unc, sigma_coeff, sigma_coeff_arr, coeff_arr_062443_Oiv2, It, int_int_unc, SNR_0, SNR, FILENAME = sfname2

OBJ_DESTROY, dataRast_062443_Oiv
OBJ_DESTROY, data1400_062443_Oiv

END
