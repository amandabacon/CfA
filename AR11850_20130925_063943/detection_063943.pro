;+
;Name: detection_063943.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/17
;EDITED: 2018/08/02 --aspr, eps appearance
;USING SI IV 1394 LINE, APPLY 4-PARAMTER SINGLE GAUSSIAN FIT (SGF) TO
;EACH SPECTRA OVER 400 STEP RASTER TO MAKE A SCATTER PLOT OF PEAK
;INTENSITY VS LINE WIDTH OF APPLY A CUT IN 4-D PARAMETER SPACE TO GET UVB POPULATION REGION

PRO detection_063943

;load the data

IRast_063943 = '/data/khnum/REU2018/abacon/data/20130925_063943/iris_l2_20130925_063943_4000254145_raster_t000_r00000.fits'

SJI1400_063943 = '/data/khnum/REU2018/abacon/data/20130925_063943/iris_l2_20130925_063943_4000254145_SJI_1400_t000.fits'

;read the data

dataRast_063943 = IRIS_OBJ(IRast_063943)

data1400_063943 = IRIS_SJI(SJI1400_063943)

;load images/profiles (WANT SI IV 1394)

dataRast_063943->SHOW_LINES
spectraRast1394_063943 = dataRast_063943->GETVAR(4, /LOAD)

images1400_063943 = data1400_063943->GETVAR()

;get spectral information

lambda1394_063943 = dataRast_063943->GETLAM(4) ;1391.7621-1395.8325
pxlslitRast_063943 = dataRast_063943->GETNSLIT(4) ;1096

ResX1400_063943 = data1400_063943->GETRESX()
ResY1400_063943 = data1400_063943->GETRESY()

SolarX1400_063943 = data1400_063943->XSCALE()
SolarY1400_063943 = data1400_063943->YSCALE()

;get exposure time in prep for normalization

exp_arrRast_063943 = dataRast_063943->GETEXP() ;One 0s exposure

;get every data point in each lambda, y-pos, and image

cube1394_063943 = spectraRast1394_063943[*,*,*] ;SIZE: 3D, 161,1096,400, float

;count the number of images of original cube

array1394_063943 = spectraRast1394_063943[0,0,*]

array1400_063943 = images1400_063943[0,0,*]

nImages1394_063943 = N_ELEMENTS(array1394_063943) ;400 images

;********GUIDANCE FROM CHAD********
;Takes the array image values and
;determines the size of the array
;in x/y through N_ELEMENTS.
;The array elements are integers, so
;DOUBLE() transforms them into decimals.

nx = DOUBLE(N_ELEMENTS(array1400_063943[*,0]))
ny = DOUBLE(N_ELEMENTS(array1400_063943[0,*]))
;**********************************

;number of elements in wavelength, ypos, and image of original cube

n_img1394_063943 = N_ELEMENTS(spectraRast1394_063943[0,0,*]) ;400 images
n_wav1394_063943 = N_ELEMENTS(spectraRast1394_063943[*,0,0]) ;161 wavelengths b/w 1391-1395
n_ypos1394_063943 = N_ELEMENTS(spectraRast1394_063943[0,*,0]) ;1096 y-positions

;remove overscan by making a tilt and applying a cut, then make a new array

cut_063943 = MEAN(MEAN(spectraRast1394_063943, DIMENSION = 2), DIMENSION = 2) ;SIZE: 1D, 161, float

;PLOT, cut_063943

spectra1394_063943 = cut_063943[19:141]

;PLOT, spectra1394_063943

nspectraRast1394_063943 = spectraRast1394_063943[19:141,*,*]

;number of elements in new array: wavelength, ypos, and image of cut cube

n_wav_063943 = N_ELEMENTS(nspectraRast1394_063943[*,0,0]) ;123
n_ypos_063943 = N_ELEMENTS(nspectraRast1394_063943[0,*,0]) ;1096
n_img_063943 = N_ELEMENTS(nspectraRast1394_063943[0,0,*]) ;400

;loop for (new) exposure time normalization

FOR i = 0, nImages1394_063943-1 DO BEGIN
nspectraRast1394_063943[*,*,i] = nspectraRast1394_063943[*,*,i]/exp_arrRast_063943[i]
ENDFOR

;get average Si IV line profile of entire observation in order to get lambda0

avg_prof_063943 = MEAN(MEAN(nspectraRast1394_063943, DIMENSION = 2, /NAN), DIMENSION = 2, /NAN)

avg_fit_063943 = MPFITPEAK(lambda1394_063943[19:141], avg_prof_063943, coeff_avg_063943)

wave0_063943 = coeff_avg_063943[1] ;1393.7973

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
aspr = (ny*ResY1400_063943)/(nx*ResX1400_063943)
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

coeff_arr_063943 = DBLARR(4, n_img_063943, n_ypos_063943)

;FOR loop with cut array and coeff_arr_063943 above

TIC
FOR i = 0, n_img_063943-1 DO BEGIN
	FOR j = 0, n_ypos_063943-1 DO BEGIN
		PLOT, lambda1394_063943[19:141], nspectraRast1394_063943[*,j,i], XRANGE = [1391.7, 1395.8], TITLE = 'AR11850_063943 Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
		CATCH, Error_status
		IF Error_status NE 0 THEN BEGIN
		PRINT, 'ERROR INDEX: ', Error_status
		PRINT, 'ERROR MSG: ', !ERROR_STATE.MSG
		ENDIF
		YFIT_063943 = MPFITPEAK(lambda1394_063943[19:141], nspectraRast1394_063943[*,j,i], coeff_063943, NTERMS = 4, STATUS = status, ERRMSG = errmsg)
		IF STATUS LE 0 THEN message, errmsg
		OPLOT, lambda1394_063943[19:141], YFIT_063943, COLOR = 170, LINESTYLE = 2, THICK = 5
;		WAIT, 0.05 ;chance to see fits
		coeff_arr_063943[*,i,j] = coeff_063943
		CATCH, Error_status
		IF Error_status NE 0 THEN BEGIN
		PRINT, 'ERROR INDEX: ', Error_status
		PRINT, 'ERROR MSG: ', !ERROR_STATE.MSG
		ENDIF
	ENDFOR
ENDFOR
TOC ;Time elapsed: ~56 min

;save parameters from nested FOR loop

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/coeff_arr_063943.sav'
SAVE, coeff_avg_063943, coeff_063943, spectraRast1394_063943, nspectraRast1394_063943, coeff_arr_063943, wave0_063943, FILENAME = sfname

;restore coeff_arr_153943

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/coeff_arr_063943.sav'
RESTORE, rfname, /VERBOSE

;velocity conversion

vel_width_063943 = (coeff_arr_063943[2,*,*]/wave0_063943) * 3e5 * sqrt(2)

;perform limits

coeff_arr_peak_063943 = coeff_arr_063943[0,*,*]

;PRINT, lambda1394_063943[19:141]

lam2_063943 = ABS(1395.3492-wave0_063943) ;1.5519162
lam1_063943 = ABS(1392.2455-wave0_063943) ;1.5518436

gamma_063943 = MAX(lam2_063943,lam1_063943)
;PRINT, gamma_063943
;PRINT, (gamma_063943/wave0_063943)

velocity_063943 = ((coeff_arr_063943[1,*,*]-wave0_063943)/wave0_063943) * 3e5 ; from param_maps

cut_ind_063943 = WHERE((coeff_arr_peak_063943 GE 10) AND (vel_width_063943 GE 43) AND (vel_width_063943 LE 1000) AND (ABS(velocity_063943 LE (gamma_063943/wave0_063943) * 3e5)), COMPLEMENT = not_cut_ind_063943, count)

;PRINT, N_ELEMENTS(cut_ind_063943) ;2450

WINDOW, XSIZE = 900, YSIZE = 700
TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

;intensity v width plot

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width_063943, coeff_arr_063943[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_063943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy]

;perform isolation of UV burst region

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width_063943[not_cut_ind_063943], coeff_arr_peak_063943[not_cut_ind_063943], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_063943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy]
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_063943[cut_ind_063943], coeff_arr_peak_063943[cut_ind_063943], COLOR = 255

;save as png

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1
WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0
PLOT, psym = 3, vel_width_063943, coeff_arr_063943[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_063943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 0, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/intensity_plot_063943.png', screenshot

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0
PLOT, psym = 3, vel_width_063943[not_cut_ind_063943], coeff_arr_peak_063943[not_cut_ind_063943], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_063943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 0, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_063943[cut_ind_063943], coeff_arr_peak_063943[cut_ind_063943], COLOR = 255
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/cut_intensity_plot_063943.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 0, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/intensity_plot_063943.eps', /ENCAPSULATED

PLOT, psym = 3, vel_width_063943, coeff_arr_063943[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_063943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YCHARSIZE = 1.4, YTHICK = 10, XTHICK = 10

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/cut_intensity_plot_063943.eps', /ENCAPSULATED

TVLCT, [[255], [255], [255]], 2
PLOT, psym = 3, vel_width_063943[not_cut_ind_063943], coeff_arr_peak_063943[not_cut_ind_063943], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_063943', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 2, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YCHARSIZE = 1.4, YTHICK = 10, XTHICK = 10
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_063943[cut_ind_063943], coeff_arr_peak_063943[cut_ind_063943], COLOR = 255

DEVICE, /CLOSE

;save all variables

sfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/all_vars_063943.sav'
SAVE, /VARIABLES, FILENAME = sfname2

OBJ_DESTROY, dataRast_063943
OBJ_DESTROY, data1400_063943

END
