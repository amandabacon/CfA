;+
;Name: Oiv_isolate_050945.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/23
;USING THE O IV LINE AND THE UVB INDICES AFTER MANUALLY INSPECTING
;SPECTRA FOR NI II ABSORPTION, APPLY TWO ROUNDS OF SGFs TO O IV LINE
;TO GET 4 PARAMETERS, INSTRUMENTAL UNCERTAINTIES, POISSON NOISE, TIIs,
;SNRs, THEN CREATE A HISTOGRAM OF SNR VALUE FREQUENCY. 

PRO Oiv_isolate_050945

;restore Si IV UVB indices and other variables

rfname = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/iso_vars_safe_clean.sav'
RESTORE, rfname

;load the data

IRast_050945_Oiv = '/data/khnum/REU2018/abacon/data/20130924_050945/iris_l2_20130924_050945_4000254145_raster_t000_r00000.fits'

SJI1400_050945_Oiv = '/data/khnum/REU2018/abacon/data/20130924_050945/iris_l2_20130924_050945_4000254145_SJI_1400_t000.fits'

;read the data

dataRast_050945_Oiv = IRIS_OBJ(IRast_050945_Oiv)

data1400_050945_Oiv = IRIS_SJI(SJI1400_050945_Oiv)

;load images/profiles (WANT Si IV 1403 THIS TIME)

dataRast_050945_Oiv->SHOW_LINES
spectraRast1403_050945_Oiv = dataRast_050945_Oiv->GETVAR(5, /LOAD)

images1400_050945_Oiv = data1400_050945_Oiv->GETVAR()

;get spectral information

lambda1403_050945_Oiv = dataRast_050945_Oiv->GETLAM(5) ;1399.0889-1405.9831
pxlslitRast_050945_Oiv = dataRast_050945_Oiv->GETNSLIT(5) ;1096

ResX1400_050945_Oiv = data1400_050945_Oiv->GETRESX()
ResY1400_050945_Oiv = data1400_050945_Oiv->GETRESY()

SolarX1400_050945_Oiv = data1400_050945_Oiv->XSCALE()
SolarY1400_050945_Oiv = data1400_050945_Oiv->YSCALE()

;get exposure time in prep for normalization

exp_arrRast_050945_Oiv = dataRast_050945_Oiv->GETEXP() ;one 0s exposures

;get every data point in each lambda, y-pos, and image

cube1403_050945_Oiv = spectraRast1403_050945_Oiv[*,*,*] ;SIZE: 3D, 272,1096,400, float

;count the number of images of original cube

array1403_050945_Oiv = spectraRast1403_050945_Oiv[0,0,*]

array1400_050945_Oiv = images1400_050945_Oiv[0,0,*]

nImages1403_050945_Oiv = N_ELEMENTS(array1403_050945_Oiv) ;400 images

;********GUIDANCE FROM CHAD********
;Takes the array image values and
;determines the size of the array
;in x/y through N_ELEMENTS.
;The array elements are integers, so
;DOUBLE() transforms them into decimals.

nx = DOUBLE(N_ELEMENTS(array1400_050945_Oiv[*,0]))
ny = DOUBLE(N_ELEMENTS(array1400_050945_Oiv[0,*]))
;**********************************

;number of elements in wavelength, ypos, and image of original cube

n_img1403_050945_Oiv = N_ELEMENTS(spectraRast1403_050945_Oiv[0,0,*]) ;400 images
n_wav1403_050945_Oiv = N_ELEMENTS(spectraRast1403_050945_Oiv[*,0,0]) ;272 wavelengths b/w 1399-1405
n_ypos1403_050945_Oiv = N_ELEMENTS(spectraRast1403_050945_Oiv[0,*,0]) ;1096 y-positions

;remove overscan by making a tilt and applying a cut, then make a new
;array (cut to include only O IV line)

cut_050945_Oiv = MEAN(MEAN(spectraRast1403_050945_Oiv, DIMENSION = 2), DIMENSION = 2) ;SIZE: 1D, 272, float

;PLOT, cut_050945_Oiv

spectra1403_050945_Oiv = cut_050945_Oiv[18:102]

;PLOT, spectra1403_050945_Oiv
;PLOT, lambda1403_050945_Oiv[18:102], spectra1403_050945_Oiv

nspectraRast1403_050945_Oiv = spectraRast1403_050945_Oiv[18:102,*,*]

;number of elements in new array: wavelength, ypos, and image of cut cube

n_wav_050945_Oiv = N_ELEMENTS(nspectraRast1403_050945_Oiv[*,0,0]) ;85
n_ypos_050945_Oiv = N_ELEMENTS(nspectraRast1403_050945_Oiv[0,*,0]) ;1096
n_img_050945_Oiv = N_ELEMENTS(nspectraRast1403_050945_Oiv[0,0,*]) ;400

;loop for (new) exposure time normalization

FOR i = 0, nImages1403_050945_Oiv-1 DO BEGIN
nspectraRast1403_050945_Oiv[*,*,i] = nspectraRast1403_050945_Oiv[*,*,i]/exp_arrRast_050945_Oiv[i]
ENDFOR

;get average Si IV line profile of entire observation in order to get lambda0

avg_prof_050945_Oiv = MEAN(MEAN(nspectraRast1403_050945_Oiv, DIMENSION = 2, /NAN), DIMENSION = 2, /NAN)

avg_fit_050945_Oiv = MPFITPEAK(lambda1403_050945_Oiv[18:102], avg_prof_050945_Oiv, coeff_avg_050945_Oiv)

wave0_050945_Oiv = coeff_avg_050945_Oiv[1] ;1401.1953

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
aspr = (ny*ResY1400_050945_Oiv)/(nx*ResX1400_050945_Oiv)
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

raster_050945_Oiv = N_ELEMENTS(nspectraRast1403_050945_Oiv[0,0,*]) ;400
yposition_050945_Oiv = N_ELEMENTS(nspectraRast1403_050945_Oiv[0,*,0]) ;1096

UVB_ind_ry_050945_Oiv = ARRAY_INDICES([raster_050945_Oiv,yposition_050945_Oiv], UVB_ind_clean, /DIMENSIONS)
;PRINT, SIZE(UVB_ind_ry_050945_Oiv) ;2D 2,318 where 2 is [raster,ypos]

UVB_ind_r_050945_Oiv = REFORM(UVB_ind_ry_050945_Oiv[0,*]) ;1D 318
UVB_ind_y_050945_Oiv = REFORM(UVB_ind_ry_050945_Oiv[1,*]) ;1D 318

;pull out all red rectangle UVB pop. indices

UVB_size_050945_Oiv = N_ELEMENTS(UVB_ind_clean) ;318
UVB_ind_r_s_050945_Oiv = N_ELEMENTS(UVB_ind_r_050945_Oiv) ;318
UVB_ind_y_s_050945_Oiv = N_ELEMENTS(UVB_ind_y_050945_Oiv) ;318

;create array to hold coeff paramters from FOR loop

coeff_arr_050945_Oiv = DBLARR(4,UVB_size_050945_Oiv)

;FOR loop with cut array and coeff_arr_050945_Oiv above

TIC
FOR i = 0, UVB_size_050945_Oiv-1 DO BEGIN
	PLOT, lambda1403_050945_Oiv[18:102], REFORM(nspectraRast1403_050945_Oiv[*,UVB_ind_y_050945_Oiv[i],UVB_ind_r_050945_Oiv[i]]), XRANGE = [1399.3, 1405.8], TITLE = 'AR11850_050945_Oiv Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_050945_Oiv = MPFITPEAK(lambda1403_050945_Oiv[18:102], REFORM(nspectraRast1403_050945_Oiv[*,UVB_ind_y_050945_Oiv[i],UVB_ind_r_050945_Oiv[i]]), coeff_050945_Oiv, NTERMS = 4, STATUS = status, ERRMSG = errmsg)
	OPLOT, lambda1403_050945_Oiv[18:102], YFIT_050945_Oiv, COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_050945_Oiv[*,i] = coeff_050945_Oiv
ENDFOR
TOC ;Time elapsed: ~4 sec

;save parameters from nested FOR loop

sfname = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_050945/coeff_arr_050945_Oiv.sav'
SAVE, coeff_050945_Oiv, spectraRast1403_050945_Oiv, nspectraRast1403_050945_Oiv, coeff_arr_050945_Oiv, wave0_050945_Oiv, FILENAME = sfname

rfname2 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_050945/coeff_arr_050945_Oiv.sav'
RESTORE, rfname2

;calculate instrumental uncertainties to use in another SGF FOR loop

R = (1.75)^2 ;counts/pxl
g = 7.2 ;photons/count
dt = 2.0
inst_unc_O_050945 = [ABS((REFORM(nspectraRast1403_050945_Oiv[*,UVB_ind_y_050945_Oiv,UVB_ind_r_050945_Oiv]))/(g*dt))+R]^0.5
;PRINT, inst_unc
;PRINT, SIZE(inst_unc)
;PRINT, exp_arrRast_050945_Oiv ;one 0

coeff_arr_050945_Oiv2 = DBLARR(4,UVB_size_050945_Oiv)
sigma_coeff_arr = DBLARR(4,UVB_size_050945_Oiv)

;PRINT, SIZE(inst_unc) ;3D 85,318,318
;PRINT, inst_unc[*,10,10]
;PRINT, inst_unc[*,UVB_ind_y_050945_Oiv[10],UVB_ind_r_050945_Oiv[10]]
;PRINT, SIZE(REFORM(nspectraRast1403_050945_Oiv[*,UVB_ind_y_050945_Oiv,UVB_ind_r_050945_Oiv])) ;3D 85,318,318
;PRINT, SIZE(lambda1403_050945_Oiv[18:102]) ;1D 

TIC
FOR i = 0, UVB_size_050945_Oiv-1 DO BEGIN
	PLOT, lambda1403_050945_Oiv[18:102], REFORM(nspectraRast1403_050945_Oiv[*,UVB_ind_y_050945_Oiv[i],UVB_ind_r_050945_Oiv[i]]), XRANGE = [1399.3, 1405.8], TITLE = 'AR11850_050945_Oiv Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_050945_Oiv2 = MPFITPEAK(lambda1403_050945_Oiv[18:102], REFORM(nspectraRast1403_050945_Oiv[*,UVB_ind_y_050945_Oiv[i],UVB_ind_r_050945_Oiv[i]]), coeff_050945_Oiv2, NTERMS = 4, ERROR = inst_unc_O_050945[*,i,i], PERROR = sigma_coeff, ESTIMATES = [5.0,1401.163,0.1,0.0])
	OPLOT, lambda1403_050945_Oiv[18:102], REFORM(YFIT_050945_Oiv2), COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_050945_Oiv2[*,i] = coeff_050945_Oiv2
	sigma_coeff_arr[*,i] = sigma_coeff
ENDFOR
TOC ;Time elapsed: ~4 sec

;PRINT, coeff_arr_050945_Oiv2
;PRINT, SIZE(sigma_coeff_arr) ;2D 4,318
;PRINT, sigma_coeff_arr

;remove any erroneous fits to Si IV 1403 line

PRINT, SIZE(coeff_arr_050945_Oiv2)

one = coeff_arr_050945_Oiv2[1,*,*]
coeff_arr_050945_Oiv2_clean = WHERE((one GT 1400.6) AND (one LT 1401.6), count, COMPLEMENT = non)

PRINT, SIZE(coeff_arr_050945_Oiv2_clean)

zero = coeff_arr_050945_Oiv2[0,*,*]
sig2 = sigma_coeff_arr[2,*,*]
two = coeff_arr_050945_Oiv2[2,*,*]
sig0 = sigma_coeff_arr[0,*,*]

p_int = zero[coeff_arr_050945_Oiv2_clean]
sig_lw = sig2[coeff_arr_050945_Oiv2_clean]
lw = two[coeff_arr_050945_Oiv2_clean]
sig_p_int = sig0[coeff_arr_050945_Oiv2_clean]

;calculate total integrated intensity (TII)

It_O_050945 = (sqrt(2.0*!dpi)*p_int*lw) ;total integrated intensity 

PRINT, 'integrated intensity uncertainty'

;calculate integrated intensity uncertainty

int_int_unc_O_050945 = [2.0*!dpi*((p_int)^2*(sig_lw)^2+(lw)^2*(sig_p_int)^2)]^0.5
PRINT, int_int_unc_O_050945

PRINT, 'SNR by dividing total integrated intensity by uncertainty'

;calculate SNR

SNR_0_O_050945 = (It_O_050945/int_int_unc_O_050945)
PRINT, SNR_0_O_050945

PRINT, 'SNR rearrangement'

;calculate SNR after rearrangement

neg = -0.5
SNR_O_050945 = (((sig_p_int)^2/(p_int)^2)+((sig_lw)^2/(lw)^2))^neg
PRINT, SNR_O_050945

PRINT, SIZE(SNR_O_050945) ;305
SNR2_O_050945 = WHERE((SNR_O_050945 LT 15), count) ;remove infinity
PRINT, SIZE(SNR_O_050945[SNR2_O_050945]) ;304

;make histogram of SNRs and frequencies at which they occur

SNR_hist = HISTOGRAM(SNR_O_050945[SNR2_O_050945], BINSIZE = 0.5, LOCATION = x_hist)
PLOT, x_hist, SNR_hist, PSYM = 10, XTITLE = "Signal-to-Noise", YTITLE = "Frequency", TITLE = "Histogram of Signal-to-Noise of AR11850_20130924_050945"
OPLOT, HISTOGRAM(SNR_O_050945[SNR2_O_050945], BINSIZE = 0.5), COLOR = 150

;save as png

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
SNR_hist = HISTOGRAM(SNR_O_050945[SNR2_O_050945], BINSIZE = 0.5, LOCATION = x_hist)
PLOT, x_hist, SNR_hist, PSYM = 10, XTITLE = "Signal-to-Noise", YTITLE = "Frequency", TITLE = "Histogram of Signal-to-Noise of AR11850_20130924_050945", XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_050945/histogram_050945.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_050945/histogram_050945.eps', /ENCAPSULATED

SNR_hist = HISTOGRAM(SNR_O_050945[SNR2_O_050945], BINSIZE = 0.5, LOCATION = x_hist)
PLOT, x_hist, SNR_hist, PSYM = 10, XTITLE = "Signal-to-Noise", YTITLE = "Frequency", TITLE = "Histogram of Signal-to-Noise of AR11850_20130924_050945", XTHICK = 10, YTHICK = 10, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, THICK = 4

DEVICE, /CLOSE

;other useful information from the SNR calculations

PRINT, 'MIN: ', MIN(SNR_O_050945[SNR2_O_050945])
PRINT, 'MAX: ', MAX(SNR_O_050945[SNR2_O_050945])
PRINT, 'MODE: ', WHERE(SNR_O_050945[SNR2_O_050945] EQ MAX(SNR_O_050945[SNR2_O_050945]), count) + MIN(SNR_O_050945[SNR2_O_050945])
PRINT, 'MEDIAN: ', MEDIAN(SNR_O_050945[SNR2_O_050945])

MOM = MOMENT(SNR_O_050945[SNR2_O_050945])
PRINT, 'MEAN: ', MOM[0] & PRINT, 'VARIANCE: ', MOM[1] & PRINT, 'SKEWNESS: ', MOM[2] & PRINT, 'KURTOSIS: ', MOM[3]

;save parameters from FOR loop

sfname2 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_050945/sigma_coeff_arr_050945_Oiv.sav'
SAVE, coeff_050945_Oiv2, inst_unc_O_050945, sigma_coeff, sigma_coeff_arr, coeff_arr_050945_Oiv2, It_O_050945, SNR_0_O_050945, SNR_O_050945, int_int_unc_O_050945, SNR2_O_050945, FILENAME = sfname2

OBJ_DESTROY, dataRast_050945_Oiv
OBJ_DESTROY, data1400_050945_Oiv

END
