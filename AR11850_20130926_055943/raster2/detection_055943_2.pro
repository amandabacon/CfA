;+
;Name: detection_055943_2.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/21

PRO detection_055943_2

;load the data

IRast_055943_2 = '/data/khnum/REU2018/abacon/data/20130926_055943/iris_l2_20130926_055943_4000254145_raster_t000_r00002.fits'

SJI1400_055943_2 = '/data/khnum/REU2018/abacon/data/20130926_055943/iris_l2_20130926_055943_4000254145_SJI_1400_t000.fits'

;read the data

dataRast_055943_2 = IRIS_OBJ(IRast_055943_2)

data1400_055943_2 = IRIS_SJI(SJI1400_055943_2)

;load images/profiles

dataRast_055943_2->SHOW_LINES
spectraRast1394_055943_2 = dataRast_055943_2->GETVAR(4, /LOAD)

images1400_055943_2 = data1400_055943_2->GETVAR()

;get spectral information

lambda1394_055943_2 = dataRast_055943_2->GETLAM(4) ;1391.7621-1395.8580
pxlslitRast_055943_2 = dataRast_055943_2->GETNSLIT(4) ;1096

ResX1400_055943_2 = data1400_055943_2->GETRESX()
ResY1400_055943_2 = data1400_055943_2->GETRESY()

SolarX1400_055943_2 = data1400_055943_2->XSCALE()
SolarY1400_055943_2 = data1400_055943_2->YSCALE()

;get exposure time in prep for normalization

exp_arrRast_055943_2 = dataRast_055943_2->GETEXP() ;there is one 0s exposure

;get every data point in each lambda, y-pos, and image

cube1394_055943_2 = spectraRast1394_055943_2[*,*,*] ;SIZE: 3D, 162,1096,400, float

;count the number of images of original cube

array1394_055943_2 = spectraRast1394_055943_2[0,0,*]

array1400_055943_2 = images1400_055943_2[0,0,*]

nImages1394_055943_2 = N_ELEMENTS(array1394_055943_2) ;400 images

;********GUIDANCE FROM CHAD********
;Takes the array image values and
;determines the size of the array
;in x/y through N_ELEMENTS.
;The array elements are integers, so
;DOUBLE() transforms them into decimals.

nx = DOUBLE(N_ELEMENTS(array1400_055943_2[*,0]))
ny = DOUBLE(N_ELEMENTS(array1400_055943_2[0,*]))
;**********************************

;number of elements in wavelength, ypos, and image of original cube

n_img1394_055943_2 = N_ELEMENTS(spectraRast1394_055943_2[0,0,*]) ;400 images
n_wav1394_055943_2 = N_ELEMENTS(spectraRast1394_055943_2[*,0,0]) ;162 wavelengths b/w 1391-1395
n_ypos1394_055943_2 = N_ELEMENTS(spectraRast1394_055943_2[0,*,0]) ;1096 y-positions

;remove overscan by making a tilt and applying a cut, then make a new array

cut_055943_2 = MEAN(MEAN(spectraRast1394_055943_2, DIMENSION = 2), DIMENSION = 2) ;SIZE: 1D, 162, float

;PLOT, cut_055943_2

spectra1394_055943_2 = cut_055943_2[19:141]

;PLOT, spectra1394_055943_2

nspectraRast1394_055943_2 = spectraRast1394_055943_2[19:141,*,*]

;number of elements in new array: wavelength, ypos, and image of cut cube

n_wav_055943_2 = N_ELEMENTS(nspectraRast1394_055943_2[*,0,0]) ;123
n_ypos_055943_2 = N_ELEMENTS(nspectraRast1394_055943_2[0,*,0]) ;1096
n_img_055943_2 = N_ELEMENTS(nspectraRast1394_055943_2[0,0,*]) ;400

;loop for (new) exposure time normalization

FOR i = 0, nImages1394_055943_2-1 DO BEGIN
nspectraRast1394_055943_2[*,*,i] = nspectraRast1394_055943_2[*,*,i]/exp_arrRast_055943_2[i]
ENDFOR

;get average Si IV line profile of entire observation in order to get lambda0

avg_prof_055943_2 = MEAN(MEAN(nspectraRast1394_055943_2, DIMENSION = 2, /NAN), DIMENSION = 2, /NAN)

avg_fit_055943_2 = MPFITPEAK(lambda1394_055943_2[19:141], avg_prof_055943_2, coeff_avg_055943_2)

wave0_055943_2 = coeff_avg_055943_2[1] ;1393.8002

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
aspr = (ny*ResY1400_055943_2)/(nx*ResX1400_055943_2)
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

coeff_arr_055943_2 = DBLARR(4, n_img_055943_2, n_ypos_055943_2)

;FOR loop with cut array and coeff_arr_055943_2 above

TIC
FOR i = 0, n_img_055943_2-1 DO BEGIN
	FOR j = 0, n_ypos_055943_2-1 DO BEGIN
		PLOT, lambda1394_055943_2[19:141], nspectraRast1394_055943_2[*,j,i], XRANGE = [1391.7, 1395.8], TITLE = 'AR11850_055943_2 Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
		CATCH, Error_status
		IF Error_status NE 0 THEN BEGIN
		PRINT, 'ERROR INDEX: ', Error_status
		PRINT, 'ERROR MSG: ', !ERROR_STATE.MSG
		ENDIF
		YFIT_055943_2 = MPFITPEAK(lambda1394_055943_2[19:141], nspectraRast1394_055943_2[*,j,i], coeff_055943_2, NTERMS = 4, STATUS = status, ERRMSG = errmsg)
		IF STATUS LE 0 THEN message, errmsg
		OPLOT, lambda1394_055943_2[19:141], YFIT_055943_2, COLOR = 170, LINESTYLE = 2, THICK = 5
;		WAIT, 0.05 ;chance to see fits
		coeff_arr_055943_2[*,i,j] = coeff_055943_2
		CATCH, Error_status
		IF Error_status NE 0 THEN BEGIN
		PRINT, 'ERROR INDEX: ', Error_status
		PRINT, 'ERROR MSG: ', !ERROR_STATE.MSG
		ENDIF
	ENDFOR
ENDFOR
TOC ;Time elapsed: ~33 min

;save parameters from nested FOR loop

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/coeff_arr_055943_2.sav'
SAVE, coeff_avg_055943_2, coeff_055943_2, spectraRast1394_055943_2, nspectraRast1394_055943_2, coeff_arr_055943_2, wave0_055943_2, FILENAME = sfname

;restore coeff_arr_055943_2

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/coeff_arr_055943_2.sav'
RESTORE, rfname, /VERBOSE

;velocity conversion

vel_width_055943_2 = (coeff_arr_055943_2[2,*,*]/wave0_055943_2) * 3e5 * sqrt(2)

;perform limits

coeff_arr_peak_055943_2 = coeff_arr_055943_2[0,*,*]

;PRINT, lambda1394_055943_2[19:141]

lam2_055943_2 = ABS(1395.3492-wave0_055943_2) ;1.5490779
lam1_055943_2 = ABS(1392.2455-wave0_055943_2) ;1.5546819

gamma_055943_2 = MAX(lam2_055943_2,lam1_055943_2)
;PRINT, gamma_055943_2
;PRINT, (gamma_055943_2/wave0_055943_2)

velocity_055943_2 = ((coeff_arr_055943_2[1,*,*]-wave0_055943_2)/wave0_055943_2) * 3e5 ; from param_maps

cut_ind_055943_2 = WHERE((coeff_arr_peak_055943_2 GE 10) AND (vel_width_055943_2 GE 41) AND (vel_width_055943_2 LE 1000) AND (ABS(velocity_055943_2 LE (gamma_055943_2/wave0_055943_2) * 3e5)), COMPLEMENT = not_cut_ind_055943_2, count)

;PRINT, N_ELEMENTS(cut_ind_055943_2) ;2375

WINDOW, XSIZE = 900, YSIZE = 700
TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

;intensity v width plot

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width_055943_2, coeff_arr_055943_2[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943_2', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy]

;perform isolation of UV burst region

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width_055943_2[not_cut_ind_055943_2], coeff_arr_peak_055943_2[not_cut_ind_055943_2], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943_2', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy]
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_055943_2[cut_ind_055943_2], coeff_arr_peak_055943_2[cut_ind_055943_2], COLOR = 255

;save as png

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1
WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0

PLOT, psym = 3, vel_width_055943_2, coeff_arr_055943_2[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943_2', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 0, XCHARSIZE = 1.5, YCHARSIZE = 1.5, XTHICK = 3, YTHICK = 3, CHARSIZE = 1.6
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/intensity_plot_055943_2.png', screenshot

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0

PLOT, psym = 3, vel_width_055943_2[not_cut_ind_055943_2], coeff_arr_peak_055943_2[not_cut_ind_055943_2], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943_2', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 0, XCHARSIZE = 1.5, YCHARSIZE = 1.5, XTHICK = 3, YTHICK = 3, CHARSIZE = 1.6
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_055943_2[cut_ind_055943_2], coeff_arr_peak_055943_2[cut_ind_055943_2], COLOR = 255
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/cut_intensity_plot_055943_2.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 8, YSIZE = 8, /INCHES, COLOR = 0, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/intensity_plot_055943_2.eps', /ENCAPSULATED

PLOT, psym = 3, vel_width_055943_2, coeff_arr_055943_2[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943_2', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], XTHICK = 4, YTHICK = 4, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 8, YSIZE = 8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/cut_intensity_plot_055943_2.eps', /ENCAPSULATED

TVLCT, [[255], [255], [255]], 2
PLOT, psym = 3, vel_width_055943_2[not_cut_ind_055943_2], coeff_arr_peak_055943_2[not_cut_ind_055943_2], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_055943_2', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 2, XTHICK = 4, YTHICK = 4, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_055943_2[cut_ind_055943_2], coeff_arr_peak_055943_2[cut_ind_055943_2], COLOR = 255

DEVICE, /CLOSE

;save all variables

sfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/all_vars_055943_2.sav'
SAVE, /VARIABLES, FILENAME = sfname2

OBJ_DESTROY, dataRast_055943_2
OBJ_DESTROY, data1400_055943_2

END
