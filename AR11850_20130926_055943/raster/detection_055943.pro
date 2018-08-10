;+
;Name: detection_055943.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/21
;EDITED: 2018/08/02 --aspr, eps appearance

PRO detection_055943

;load the data

IRast_055943 = '/data/khnum/REU2018/abacon/data/20130926_055943/iris_l2_20130926_055943_4000254145_raster_t000_r00000.fits'

SJI1400_055943 = '/data/khnum/REU2018/abacon/data/20130926_055943/iris_l2_20130926_055943_4000254145_SJI_1400_t000.fits'

;read the data

dataRast_055943 = IRIS_OBJ(IRast_055943)

data1400_055943 = IRIS_SJI(SJI1400_055943)

;load images/profiles

dataRast_055943->SHOW_LINES
spectraRast1394_055943 = dataRast_055943->GETVAR(4, /LOAD)

images1400_055943 = data1400_055943->GETVAR()

;get spectral information

lambda1394_055943 = dataRast_055943->GETLAM(4) ;1391.7621-1395.8580
pxlslitRast_055943 = dataRast_055943->GETNSLIT(4) ;1096

ResX1400_055943 = data1400_055943->GETRESX()
ResY1400_055943 = data1400_055943->GETRESY()

SolarX1400_055943 = data1400_055943->XSCALE()
SolarY1400_055943 = data1400_055943->YSCALE()

;get exposure time in prep for normalization

exp_arrRast_055943 = dataRast_055943->GETEXP() ;there are 0s exposures

;get every data point in each lambda, y-pos, and image

cube1394_055943 = spectraRast1394_055943[*,*,*] ;SIZE: 3D, 162,1096,400, float

;count the number of images of original cube

array1394_055943 = spectraRast1394_055943[0,0,*]

array1400_055943 = images1400_055943[0,0,*]

nImages1394_055943 = N_ELEMENTS(array1394_055943) ;400 images

;********GUIDANCE FROM CHAD********
;Takes the array image values and
;determines the size of the array
;in x/y through N_ELEMENTS.
;The array elements are integers, so
;DOUBLE() transforms them into decimals.

nx = DOUBLE(N_ELEMENTS(array1400_055943[*,0]))
ny = DOUBLE(N_ELEMENTS(array1400_055943[0,*]))
;**********************************

;number of elements in wavelength, ypos, and image of original cube

n_img1394_055943 = N_ELEMENTS(spectraRast1394_055943[0,0,*]) ;400 images
n_wav1394_055943 = N_ELEMENTS(spectraRast1394_055943[*,0,0]) ;162 wavelengths b/w 1391-1395
n_ypos1394_055943 = N_ELEMENTS(spectraRast1394_055943[0,*,0]) ;1096 y-positions

;remove overscan by making a tilt and applying a cut, then make a new array

cut_055943 = MEAN(MEAN(spectraRast1394_055943, DIMENSION = 2), DIMENSION = 2) ;SIZE: 1D, 162, float

;PLOT, cut_055943

spectra1394_055943 = cut_055943[18:141]

;PLOT, spectra1394_055943

nspectraRast1394_055943 = spectraRast1394_055943[18:141,*,*]

;number of elements in new array: wavelength, ypos, and image of cut cube

n_wav_055943 = N_ELEMENTS(nspectraRast1394_055943[*,0,0]) ;124
n_ypos_055943 = N_ELEMENTS(nspectraRast1394_055943[0,*,0]) ;1096
n_img_055943 = N_ELEMENTS(nspectraRast1394_055943[0,0,*]) ;400

;loop for (new) exposure time normalization

FOR i = 0, nImages1394_055943-1 DO BEGIN
nspectraRast1394_055943[*,*,i] = nspectraRast1394_055943[*,*,i]/exp_arrRast_055943[i]
ENDFOR

;get average Si IV line profile of entire observation in order to get lambda0

avg_prof_055943 = MEAN(MEAN(nspectraRast1394_055943, DIMENSION = 2, /NAN), DIMENSION = 2, /NAN)

avg_fit_055943 = MPFITPEAK(lambda1394_055943[18:141], avg_prof_055943, coeff_avg_055943)

wave0_055943 = coeff_avg_055943[1] ;1393.7982

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
aspr = (ny*ResY1400_055943)/(nx*ResX1400_055943)
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

coeff_arr_055943 = DBLARR(4, n_img_055943, n_ypos_055943)

;FOR loop with cut array and coeff_arr_055943 above

TIC
FOR i = 0, n_img_055943-1 DO BEGIN
	FOR j = 0, n_ypos_055943-1 DO BEGIN
		PLOT, lambda1394_055943[18:141], nspectraRast1394_055943[*,j,i], XRANGE = [1391.7, 1395.8], TITLE = 'AR11850_055943 Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
		CATCH, Error_status
		IF Error_status NE 0 THEN BEGIN
		PRINT, 'ERROR INDEX: ', Error_status
		PRINT, 'ERROR MSG: ', !ERROR_STATE.MSG
		ENDIF
		YFIT_055943 = MPFITPEAK(lambda1394_055943[18:141], nspectraRast1394_055943[*,j,i], coeff_055943, NTERMS = 4, STATUS = status, ERRMSG = errmsg)
		IF STATUS LE 0 THEN message, errmsg
		OPLOT, lambda1394_055943[18:141], YFIT_055943, COLOR = 170, LINESTYLE = 2, THICK = 5
;		WAIT, 0.05 ;chance to see fits
		coeff_arr_055943[*,i,j] = coeff_055943
		CATCH, Error_status
		IF Error_status NE 0 THEN BEGIN
		PRINT, 'ERROR INDEX: ', Error_status
		PRINT, 'ERROR MSG: ', !ERROR_STATE.MSG
		ENDIF
	ENDFOR
ENDFOR
TOC ;Time elapsed: ~3 min

;save parameters from nested FOR loop

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster/coeff_arr_055943.sav'
SAVE, coeff_avg_055943, coeff_055943, spectraRast1394_055943, nspectraRast1394_055943, coeff_arr_055943, wave0_055943, FILENAME = sfname

;restore coeff_arr_055943

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster/coeff_arr_055943.sav'
RESTORE, rfname, /VERBOSE

;velocity conversion

vel_width_055943 = (coeff_arr_055943[2,*,*]/wave0_055943) * 3e5 * sqrt(2)

;perform limits

coeff_arr_peak_055943 = coeff_arr_055943[0,*,*]

;PRINT, lambda1394_055943[18:141]

lam2_055943 = ABS(1395.3492-wave0_055943) ;1.5510802
lam1_055943 = ABS(1392.2201-wave0_055943) ;1.5780702

gamma_055943 = MAX(lam2_055943,lam1_055943)
;PRINT, gamma_055943
;PRINT, (gamma_055943/wave0_055943)

velocity_055943 = ((coeff_arr_055943[1,*,*]-wave0_055943)/wave0_055943) * 3e5 ; from param_maps

cut_ind_055943 = WHERE((coeff_arr_peak_055943 GE 7) AND (vel_width_055943 GE 40) AND (vel_width_055943 LE 1000) AND (ABS(velocity_055943 LE (gamma_055943/wave0_055943) * 3e5)), COMPLEMENT = not_cut_ind_055943, count)

;PRINT, N_ELEMENTS(cut_ind_055943) ;2076

WINDOW, XSIZE = 900, YSIZE = 700
TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

;intensity v width plot

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width_055943, coeff_arr_055943[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy]

;perform isolation of UV burst region

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width_055943[not_cut_ind_055943], coeff_arr_peak_055943[not_cut_ind_055943], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy]
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_055943[cut_ind_055943], coeff_arr_peak_055943[cut_ind_055943], COLOR = 255

;save as png

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1
WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0

PLOT, psym = 3, vel_width_055943, coeff_arr_055943[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 0,  XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster/intensity_plot_055943.png', screenshot

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0

PLOT, psym = 3, vel_width_055943[not_cut_ind_055943], coeff_arr_peak_055943[not_cut_ind_055943], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 0, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_055943[cut_ind_055943], coeff_arr_peak_055943[cut_ind_055943], COLOR = 255
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster/cut_intensity_plot_055943.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 0, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster/intensity_plot_055943.eps', /ENCAPSULATED

PLOT, psym = 3, vel_width_055943, coeff_arr_055943[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YCHARSIZE = 1.4, YTHICK = 10, XTHICK = 10

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster/cut_intensity_plot_055943.eps', /ENCAPSULATED

TVLCT, [[255], [255], [255]], 2
PLOT, psym = 3, vel_width_055943[not_cut_ind_055943], coeff_arr_peak_055943[not_cut_ind_055943], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 2, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YCHARSIZE = 1.4, YTHICK = 10, XTHICK = 10
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_055943[cut_ind_055943], coeff_arr_peak_055943[cut_ind_055943], COLOR = 255

DEVICE, /CLOSE

;save all variables

sfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster/all_vars_055943.sav'
SAVE, /VARIABLES, FILENAME = sfname2

OBJ_DESTROY, dataRast_055943
OBJ_DESTROY, data1400_055943

END
