;+
;Name: Oiv_isolate_055943_1.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/23
;USING THE O IV LINE AND THE UVB INDICES AFTER MANUALLY INSPECTING
;SPECTRA FOR NI II ABSORPTION, APPLY TWO ROUNDS OF SGFs TO O IV LINE
;TO GET 4 PARAMETERS, INSTRUMENTAL UNCERTAINTIES, POISSON NOISE, TIIs,
;SNRs, THEN CREATE A HISTOGRAM OF SNR VALUE FREQUENCY.

PRO Oiv_isolate_055943_1

;restore Si IV UVB indices and other variables

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/iso_vars_055943_1.sav'
RESTORE, rfname

;load the data

IRast_055943_1_Oiv = '/data/khnum/REU2018/abacon/data/20130926_055943/iris_l2_20130926_055943_4000254145_raster_t000_r00001.fits'

SJI1400_055943_1_Oiv = '/data/khnum/REU2018/abacon/data/20130926_055943/iris_l2_20130926_055943_4000254145_SJI_1400_t000.fits'

;read the data

dataRast_055943_1_Oiv = IRIS_OBJ(IRast_055943_1_Oiv)

data1400_055943_1_Oiv = IRIS_SJI(SJI1400_055943_1_Oiv)

;load images/profiles (WANT Si IV 1403 THIS TIME)

dataRast_055943_1_Oiv->SHOW_LINES
spectraRast1403_055943_1_Oiv = dataRast_055943_1_Oiv->GETVAR(5, /LOAD)

images1400_055943_1_Oiv = data1400_055943_1_Oiv->GETVAR()

;get spectral information

lambda1403_055943_1_Oiv = dataRast_055943_1_Oiv->GETLAM(5) ;1399.0634-1406.0085
pxlslitRast_055943_1_Oiv = dataRast_055943_1_Oiv->GETNSLIT(5) ;1096

ResX1400_055943_1_Oiv = data1400_055943_1_Oiv->GETRESX()
ResY1400_055943_1_Oiv = data1400_055943_1_Oiv->GETRESY()

SolarX1400_055943_1_Oiv = data1400_055943_1_Oiv->XSCALE()
SolarY1400_055943_1_Oiv = data1400_055943_1_Oiv->YSCALE()

;get exposure time in prep for normalization

exp_arrRast_055943_1_Oiv = dataRast_055943_1_Oiv->GETEXP() ;some 0s exposures

;get every data point in each lambda, y-pos, and image

cube1403_055943_1_Oiv = spectraRast1403_055943_1_Oiv[*,*,*] ;SIZE: 3D, 274,1096,400, float

;count the number of images of original cube

array1403_055943_1_Oiv = spectraRast1403_055943_1_Oiv[0,0,*]

array1400_055943_1_Oiv = images1400_055943_1_Oiv[0,0,*]

nImages1403_055943_1_Oiv = N_ELEMENTS(array1403_055943_1_Oiv) ;400 images

;********GUIDANCE FROM CHAD********
;Takes the array image values and
;determines the size of the array
;in x/y through N_ELEMENTS.
;The array elements are integers, so
;DOUBLE() transforms them into decimals.

nx = DOUBLE(N_ELEMENTS(array1400_055943_1_Oiv[*,0]))
ny = DOUBLE(N_ELEMENTS(array1400_055943_1_Oiv[0,*]))
;**********************************

;number of elements in wavelength, ypos, and image of original cube

n_img1403_055943_1_Oiv = N_ELEMENTS(spectraRast1403_055943_1_Oiv[0,0,*]) ;400 images
n_wav1403_055943_1_Oiv = N_ELEMENTS(spectraRast1403_055943_1_Oiv[*,0,0]) ;274 wavelengths b/w 1399-1405
n_ypos1403_055943_1_Oiv = N_ELEMENTS(spectraRast1403_055943_1_Oiv[0,*,0]) ;1096 y-positions

;remove overscan by making a tilt and applying a cut, then make a new
;array (cut to include only O IV line)

cut_055943_1_Oiv = MEAN(MEAN(spectraRast1403_055943_1_Oiv, DIMENSION = 2), DIMENSION = 2) ;SIZE: 1D, 274, float

;PLOT, cut_055943_1_Oiv

spectra1403_055943_1_Oiv = cut_055943_1_Oiv[19:99]

;PLOT, spectra1403_055943_1_Oiv
;PLOT, lambda1403_055943_1_Oiv[19:99], spectra1403_055943_1_Oiv

nspectraRast1403_055943_1_Oiv = spectraRast1403_055943_1_Oiv[19:99,*,*]

;number of elements in new array: wavelength, ypos, and image of cut cube

n_wav_055943_1_Oiv = N_ELEMENTS(nspectraRast1403_055943_1_Oiv[*,0,0]) ;81
n_ypos_055943_1_Oiv = N_ELEMENTS(nspectraRast1403_055943_1_Oiv[0,*,0]) ;1096
n_img_055943_1_Oiv = N_ELEMENTS(nspectraRast1403_055943_1_Oiv[0,0,*]) ;400

;loop for (new) exposure time normalization

FOR i = 0, nImages1403_055943_1_Oiv-1 DO BEGIN
nspectraRast1403_055943_1_Oiv[*,*,i] = nspectraRast1403_055943_1_Oiv[*,*,i]/exp_arrRast_055943_1_Oiv[i]
ENDFOR

;get average Si IV line profile of entire observation in order to get lambda0

avg_prof_055943_1_Oiv = MEAN(MEAN(nspectraRast1403_055943_1_Oiv, DIMENSION = 2, /NAN), DIMENSION = 2, /NAN)

avg_fit_055943_1_Oiv = MPFITPEAK(lambda1403_055943_1_Oiv[19:99], avg_prof_055943_1_Oiv, coeff_avg_055943_1_Oiv)

wave0_055943_1_Oiv = coeff_avg_055943_1_Oiv[1] ;1401.2026

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
aspr = (ny*ResY1400_055943_1_Oiv)/(nx*ResX1400_055943_1_Oiv)
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

;===============================================================================

;FINAL PRESENTATION

;WINDOW, XSIZE = 900, YSIZE = 700
;PLOT, lambda1403_055943_1_Oiv[20:167], cut_055943_1_Oiv[20:167], XSTYLE = 1

;save as ps

;!P.FONT = 1

;TVLCT, [[255],[255],[255]], 1
;SET_PLOT, 'ps'
;DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster1/profile_OIV.eps', /ENCAPSULATED

;PLOT, lambda1403_055943_1_Oiv[20:167], cut_055943_1_Oiv[20:167], XTITLE = "Wavelength", YTITLE = "Intensity [Arb. Units]", TITLE = "Master Histogram of Signal-to-Noise of AR11850", XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, XSTYLE = 1, THICK = 4, POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 1, XTHICK = 10, YTHICK = 10

;DEVICE, /CLOSE

;===============================================================================

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_055943_1_Oiv = N_ELEMENTS(nspectraRast1403_055943_1_Oiv[0,0,*]) ;400
yposition_055943_1_Oiv = N_ELEMENTS(nspectraRast1403_055943_1_Oiv[0,*,0]) ;1096

UVB_ind_ry_055943_1_Oiv = ARRAY_INDICES([raster_055943_1_Oiv,yposition_055943_1_Oiv], UVB_ind_055943_1, /DIMENSIONS)
;PRINT, SIZE(UVB_ind_ry_055943_1_Oiv) ;2D 2,360 where 2 is [raster,ypos]

UVB_ind_r_055943_1_Oiv = REFORM(UVB_ind_ry_055943_1_Oiv[0,*]) ;1D 360
UVB_ind_y_055943_1_Oiv = REFORM(UVB_ind_ry_055943_1_Oiv[1,*]) ;1D 360

;pull out all red rectangle UVB pop. indices

UVB_size_055943_1_Oiv = N_ELEMENTS(UVB_ind_055943_1) ;360
UVB_ind_r_s_055943_1_Oiv = N_ELEMENTS(UVB_ind_r_055943_1_Oiv) ;360
UVB_ind_y_s_055943_1_Oiv = N_ELEMENTS(UVB_ind_y_055943_1_Oiv) ;360

;create array to hold coeff paramters from FOR loop

coeff_arr_055943_1_Oiv = DBLARR(4,UVB_size_055943_1_Oiv)

;FOR loop with cut array and coeff_arr_055943_1_Oiv above

TIC
FOR i = 0, UVB_size_055943_1_Oiv-1 DO BEGIN
	PLOT, lambda1403_055943_1_Oiv[19:99], REFORM(nspectraRast1403_055943_1_Oiv[*,UVB_ind_y_055943_1_Oiv[i],UVB_ind_r_055943_1_Oiv[i]]), XRANGE = [1399.3, 1405.8], TITLE = 'AR11850_055943_1_Oiv Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_055943_1_Oiv = MPFITPEAK(lambda1403_055943_1_Oiv[19:99], REFORM(nspectraRast1403_055943_1_Oiv[*,UVB_ind_y_055943_1_Oiv[i],UVB_ind_r_055943_1_Oiv[i]]), coeff_055943_1_Oiv, NTERMS = 4, STATUS = status, ERRMSG = errmsg)
	OPLOT, lambda1403_055943_1_Oiv[19:99], YFIT_055943_1_Oiv, COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_055943_1_Oiv[*,i] = coeff_055943_1_Oiv
ENDFOR
TOC ;Time elapsed: ~4.9 sec

;save parameters from nested FOR loop

sfname = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster1/coeff_arr_055943_1_Oiv.sav'
SAVE, coeff_055943_1_Oiv, spectraRast1403_055943_1_Oiv, nspectraRast1403_055943_1_Oiv, coeff_arr_055943_1_Oiv, wave0_055943_1_Oiv, FILENAME = sfname

rfname2 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster1/coeff_arr_055943_1_Oiv.sav'
RESTORE, rfname2

;calculate instrumental uncertainties to use in another SGF FOR loop

R = (1.75)^2 ;counts/pxl
g = 7.2 ;photons/count
dt = 2.0
inst_unc_O_055943_1 = [ABS((REFORM(nspectraRast1403_055943_1_Oiv[*,UVB_ind_y_055943_1_Oiv,UVB_ind_r_055943_1_Oiv]))/(g*dt))+R]^0.5
;PRINT, inst_unc_O_055943_1

coeff_arr_055943_1_Oiv2 = DBLARR(4,UVB_size_055943_1_Oiv)
sigma_coeff_arr = DBLARR(4,UVB_size_055943_1_Oiv)

PRINT, SIZE(inst_unc_O_055943_1)

TIC
FOR i = 0, UVB_size_055943_1_Oiv-1 DO BEGIN
	PLOT, lambda1403_055943_1_Oiv[19:99], REFORM(nspectraRast1403_055943_1_Oiv[*,UVB_ind_y_055943_1_Oiv[i],UVB_ind_r_055943_1_Oiv[i]]), XRANGE = [1399.3, 1405.8], TITLE = 'AR11850_055943_1_Oiv Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_055943_1_Oiv2 = MPFITPEAK(lambda1403_055943_1_Oiv[19:99], REFORM(nspectraRast1403_055943_1_Oiv[*,UVB_ind_y_055943_1_Oiv[i],UVB_ind_r_055943_1_Oiv[i]]), coeff_055943_1_Oiv2, NTERMS = 4, PERROR = sigma_coeff, ERROR = inst_unc_O_055943_1[*,i,i], ESTIMATES = [5.0,1401.163,0.1,0.0])
        OPLOT, lambda1403_055943_1_Oiv[19:99], REFORM(YFIT_055943_1_Oiv2), COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_055943_1_Oiv2[*,i] = coeff_055943_1_Oiv2
	sigma_coeff_arr[*,i] = sigma_coeff 
ENDFOR
TOC ;Time elapsed: ~4.9 sec

;remove any erroneous fits to Si IV 1403 line

PRINT, SIZE(coeff_arr_055943_1_Oiv2)

one = coeff_arr_055943_1_Oiv2[1,*,*]
coeff_arr_055943_1_Oiv2_clean = WHERE((one GT 1400.6) AND (one LT 1401.6), count, COMPLEMENT = non)

PRINT, SIZE(coeff_arr_055943_1_Oiv2_clean)

zero = coeff_arr_055943_1_Oiv2[0,*,*]
sig2 = sigma_coeff_arr[2,*,*]
two = coeff_arr_055943_1_Oiv2[2,*,*]
sig0 = sigma_coeff_arr[0,*,*]

p_int = zero[coeff_arr_055943_1_Oiv2_clean]
sig_lw = sig2[coeff_arr_055943_1_Oiv2_clean]
lw = two[coeff_arr_055943_1_Oiv2_clean]
sig_p_int = sig0[coeff_arr_055943_1_Oiv2_clean]

;calculate total integrated intensity (TII)

It_O_055943_1 = (sqrt(2.0*!dpi)*p_int*lw) ;total integrated intensity

PRINT, 'integrated intensity uncertainty'

;calculate integrated intensity uncertainty

int_int_unc_O_055943_1 = [2.0*!dpi*((p_int)^2*(sig_lw)^2+(lw)^2*(sig_p_int)^2)]^0.5
PRINT, int_int_unc_O_055943_1

PRINT, 'SNR by dividing total integrated intensity by uncertainty'

;calculate SNR

SNR_0_O_055943_1 = It_O_055943_1/int_int_unc_O_055943_1
PRINT, SNR_0_O_055943_1

PRINT, 'SNR rearrangement'

;calculate SNR after rearrangement

neg = -0.5
SNR_O_055943_1 = (((sig_p_int)^2/(p_int)^2)+((sig_lw)^2/(lw)^2))^neg
PRINT, SNR_O_055943_1

PRINT, SIZE(SNR_O_055943_1) ;330
SNR2_O_055943_1 = WHERE((SNR_O_055943_1 LT 27), count)
PRINT, SIZE(SNR_O_055943_1[SNR2_O_055943_1]) ;330

;make histogram of SNRs and frequencies at which they occur

SNR_hist = HISTOGRAM(SNR_O_055943_1[SNR2_O_055943_1], BINSIZE = 0.5, LOCATION = x_hist)
PLOT, x_hist, SNR_hist, PSYM = 10, XTITLE = "Signal-to-Noise", YTITLE = "Frequency", TITLE = "Histogram of Signal-to-Noise of AR11850_20130926_055943_1"
OPLOT, HISTOGRAM(SNR_O_055943_1[SNR2_O_055943_1], BINSIZE = 1.0), COLOR = 150

;save as png

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
SNR_hist = HISTOGRAM(SNR_O_055943_1[SNR2_O_055943_1], BINSIZE = 0.5, LOCATION = x_hist)
PLOT, x_hist, SNR_hist, PSYM = 10, XTITLE = "Signal-to-Noise", YTITLE = "Frequency", TITLE = "Histogram of Signal-to-Noise of AR11850_20130926_055943_1", XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster1/histogram_055943_1.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster1/histogram_055943_1.eps', /ENCAPSULATED

SNR_hist = HISTOGRAM(SNR_O_055943_1[SNR2_O_055943_1], BINSIZE = 0.5, LOCATION = x_hist)
PLOT, x_hist, SNR_hist, PSYM = 10, XTITLE = "Signal-to-Noise", YTITLE = "Frequency", TITLE = "Histogram of Signal-to-Noise of AR11850_20130926_055943_1", XTHICK = 10, YTHICK = 10, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, THICK = 4

DEVICE, /CLOSE

;other useful information from the SNR calculations

PRINT, 'MIN: ', MIN(SNR_O_055943_1[SNR2_O_055943_1])
PRINT, 'MAX: ', MAX(SNR_O_055943_1[SNR2_O_055943_1])
PRINT, 'MODE: ', WHERE(SNR_O_055943_1[SNR2_O_055943_1] EQ MAX(SNR_O_055943_1[SNR2_O_055943_1]), count) + MIN(SNR_O_055943_1[SNR2_O_055943_1])
PRINT, 'MEDIAN: ', MEDIAN(SNR_O_055943_1[SNR2_O_055943_1])

MOM = MOMENT(SNR_O_055943_1[SNR2_O_055943_1])
PRINT, 'MEAN: ', MOM[0] & PRINT, 'VARIANCE: ', MOM[1] & PRINT, 'SKEWNESS: ', MOM[2] & PRINT, 'KURTOSIS: ', MOM[3]

;save parameters from FOR loop

sfname2 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster1/sigma_coeff_arr_055943_1_Oiv.sav'
SAVE, coeff_055943_1_Oiv2, inst_unc_O_055943_1, sigma_coeff, sigma_coeff_arr, coeff_arr_055943_1_Oiv2, It_O_055943_1, int_int_unc_O_055943_1, SNR_0_O_055943_1, SNR_O_055943_1, SNR2_O_055943_1, FILENAME = sfname2

OBJ_DESTROY, dataRast_055943_1_Oiv
OBJ_DESTROY, data1400_055943_1_Oiv

END
