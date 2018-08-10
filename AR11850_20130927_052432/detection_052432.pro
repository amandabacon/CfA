;+
;Name: detection_052432.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/20
;EDITED: 2018/08/02 --aspr, eps appearance
;USING SI IV 1394 LINE, APPLY 4-PARAMTER SINGLE GAUSSIAN FIT (SGF) TO
;EACH SPECTRA OVER 400 STEP RASTER TO MAKE A SCATTER PLOT OF PEAK
;INTENSITY VS LINE WIDTH OF APPLY A CUT IN 4-D PARAMETER SPACE TO GET UVB POPULATION REGION

PRO detection_052432

;load the data

IRast_052432 = '/data/khnum/REU2018/abacon/data/20130927_052432/iris_l2_20130927_052432_3800254046_raster_t000_r00000.fits'

SJI1400_052432 = '/data/khnum/REU2018/abacon/data/20130927_052432/iris_l2_20130927_052432_3800254046_SJI_1400_t000.fits'

;read the data

dataRast_052432 = IRIS_OBJ(IRast_052432)

data1400_052432 = IRIS_SJI(SJI1400_052432)

;load images/profiles (WANT SI IV 1394)

dataRast_052432->SHOW_LINES
spectraRast1394_052432 = dataRast_052432->GETVAR(2, /LOAD)

images1400_052432 = data1400_052432->GETVAR()

;get spectral information

lambda1394_052432 = dataRast_052432->GETLAM(2) ;1391.3551-1396.2650
pxlslitRast_052432 = dataRast_052432->GETNSLIT(2) ;1093

ResX1400_052432 = data1400_052432->GETRESX()
ResY1400_052432 = data1400_052432->GETRESY()

SolarX1400_052432 = data1400_052432->XSCALE()
SolarY1400_052432 = data1400_052432->YSCALE()

;get exposure time in prep for normalization

exp_arrRast_052432 = dataRast_052432->GETEXP() ;clean--no 0s exposures

;get every data point in each lambda, y-pos, and image

cube1394_052432 = spectraRast1394_052432[*,*,*] ;SIZE: 3D, 194,1093,400, float

;count the number of images of original cube

array1394_052432 = spectraRast1394_052432[0,0,*]

array1400_052432 = images1400_052432[0,0,*]

nImages1394_052432 = N_ELEMENTS(array1394_052432) ;400 images

;********GUIDANCE FROM CHAD********
;Takes the array image values and
;determines the size of the array
;in x/y through N_ELEMENTS.
;The array elements are integers, so
;DOUBLE() transforms them into decimals.

nx = DOUBLE(N_ELEMENTS(array1400_052432[*,0]))
ny = DOUBLE(N_ELEMENTS(array1400_052432[0,*]))
;**********************************

;number of elements in wavelength, ypos, and image of original cube

n_img1394_052432 = N_ELEMENTS(spectraRast1394_052432[0,0,*]) ;400 images
n_wav1394_052432 = N_ELEMENTS(spectraRast1394_052432[*,0,0]) ;194 wavelengths b/w 1391-1396
n_ypos1394_052432 = N_ELEMENTS(spectraRast1394_052432[0,*,0]) ;1093 y-positions

;remove overscan by making a tilt and applying a cut, then make a new array

cut_052432 = MEAN(MEAN(spectraRast1394_052432, DIMENSION = 2), DIMENSION = 2) ;SIZE: 1D, 194, float

;PLOT, cut_052432

spectra1394_052432 = cut_052432[19:173]

;PLOT, spectra1394_052432

nspectraRast1394_052432 = spectraRast1394_052432[19:173,*,*]

;number of elements in new array: wavelength, ypos, and image of cut cube

n_wav_052432 = N_ELEMENTS(nspectraRast1394_052432[*,0,0]) ;155
n_ypos_052432 = N_ELEMENTS(nspectraRast1394_052432[0,*,0]) ;1093
n_img_052432 = N_ELEMENTS(nspectraRast1394_052432[0,0,*]) ;400

;loop for (new) exposure time normalization

FOR i = 0, nImages1394_052432-1 DO BEGIN
nspectraRast1394_052432[*,*,i] = nspectraRast1394_052432[*,*,i]/exp_arrRast_052432[i]
ENDFOR

;get average Si IV line profile of entire observation in order to get lambda0

avg_prof_052432 = MEAN(MEAN(nspectraRast1394_052432, DIMENSION = 2), DIMENSION = 2)

avg_fit_052432 = MPFITPEAK(lambda1394_052432[19:173], avg_prof_052432, coeff_avg_052432)

wave0_052432 = coeff_avg_052432[1] ;1393.8022

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
aspr = (ny*ResY1400_052432)/(nx*ResX1400_052432)
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

;create array to hold coeff paramters from FOR loop, images, & y-pos

coeff_arr_052432 = DBLARR(4, n_img_052432, n_ypos_052432)

;FOR loop with cut array and coeff_arr_052432 above

TIC
FOR i = 0, n_img_052432-1 DO BEGIN
	FOR j = 0, n_ypos_052432-1 DO BEGIN
		PLOT, lambda1394_052432[19:173], nspectraRast1394_052432[*,j,i], XRANGE = [1391.7, 1396.3], TITLE = 'AR11850_052432 Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
		YFIT_052432 = MPFITPEAK(lambda1394_052432[19:173], nspectraRast1394_052432[*,j,i], coeff_052432, NTERMS = 4, STATUS = status, ERRMSG = errmsg)
		TVLCT, [[0],[127],[0]], 10
		OPLOT, lambda1394_052432[19:173], YFIT_052432, COLOR = 10, LINESTYLE = 2, THICK = 5
;		WAIT, 0.05 ;chance to see fits
		coeff_arr_052432[*,i,j] = coeff_052432
	ENDFOR
ENDFOR
TOC ;Time elapsed: ~35 min

;save parameters from nested FOR loop

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/coeff_arr_052432.sav'
SAVE, coeff_avg_052432, coeff_052432, spectraRast1394_052432, nspectraRast1394_052432, coeff_arr_052432, wave0_052432, FILENAME = sfname

;restore coeff_arr_052432

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/coeff_arr_052432.sav'
RESTORE, rfname

;velocity conversion

vel_width_052432 = (coeff_arr_052432[2,*,*]/wave0_052432) * 3e5 * sqrt(2)

;perform limits

coeff_arr_peak_052432 = coeff_arr_052432[0,*,*]

;PRINT, lambda1394_052432[19:173]

lam2_052432 = ABS(1395.7562-wave0_052432) ;1.9540637
lam1_052432 = ABS(1391.8385-wave0_052432) ;1.9636609

gamma_052432 = MAX(lam2_052432,lam1_052432)
;PRINT, gamma_052432
;PRINT, (gamma_052432/wave0_052432)

velocity_052432 = ((coeff_arr_052432[1,*,*]-wave0_052432)/wave0_052432) * 3e5 ; from param_maps

cut_ind_052432 = WHERE((coeff_arr_peak_052432 GE 23) AND (vel_width_052432 GE 42) AND (vel_width_052432 LE 1000) AND (ABS(velocity_052432 LE (gamma_052432/wave0_052432) * 3e5)), COMPLEMENT = not_cut_ind_052432, count)

;PRINT, N_ELEMENTS(cut_ind_052432) ;2595

WINDOW, XSIZE = 900, YSIZE = 700
TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

;intensity v width plot

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width_052432, coeff_arr_052432[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_052432', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy]

;perform isolation of UV burst region

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width_052432[not_cut_ind_052432], coeff_arr_peak_052432[not_cut_ind_052432], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_052432', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy]
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_052432[cut_ind_052432], coeff_arr_peak_052432[cut_ind_052432], COLOR = 255

;save as png

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1
WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0

PLOT, psym = 3, vel_width_052432, coeff_arr_052432[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_052432', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 0, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/intensity_plot_052432.png', screenshot

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0

PLOT, psym = 3, vel_width_052432[not_cut_ind_052432], coeff_arr_peak_052432[not_cut_ind_052432], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_052432', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 0, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_052432[cut_ind_052432], coeff_arr_peak_052432[cut_ind_052432], COLOR = 255
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/cut_intensity_plot_052432.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 0, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/intensity_plot_052432.eps', /ENCAPSULATED

PLOT, psym = 3, vel_width_052432, coeff_arr_052432[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_052432', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YCHARSIZE = 1.4, YTHICK = 10, XTHICK = 10

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/cut_intensity_plot_052432.eps', /ENCAPSULATED

TVLCT, [[255], [255], [255]], 2
PLOT, psym = 3, vel_width_052432[not_cut_ind_052432], coeff_arr_peak_052432[not_cut_ind_052432], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_052432', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 2, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YCHARSIZE = 1.4, YTHICK = 10, XTHICK = 10
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_052432[cut_ind_052432], coeff_arr_peak_052432[cut_ind_052432], COLOR = 255

DEVICE, /CLOSE

;save all variables

sfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/all_vars_052432.sav'
SAVE, /VARIABLES, FILENAME = sfname2

OBJ_DESTROY, dataRast_052432
OBJ_DESTROY, data1400_052432

END
