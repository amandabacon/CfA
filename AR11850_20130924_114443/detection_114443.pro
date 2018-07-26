;+
;Name: detection_114443.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/16

PRO detection_114443

;load the data

IRast_114443 = '/data/khnum/REU2018/abacon/data/20130924_114443/iris_l2_20130924_114443_4000254145_raster_t000_r00000.fits'

SJI1400_114443 = '/data/khnum/REU2018/abacon/data/20130924_114443/iris_l2_20130924_114443_4000254145_SJI_1400_t000.fits'

;read the data

dataRast_114443 = IRIS_OBJ(IRast_114443)

data1400_114443 = IRIS_SJI(SJI1400_114443)

;load images/profiles

dataRast_114443->SHOW_LINES
spectraRast1394_114443 = dataRast_114443->GETVAR(4, /LOAD)

images1400_114443 = data1400_114443->GETVAR()

;get spectral information

lambda1394_114443 = dataRast_114443->GETLAM(4) ;1391.7621-1395.8325
pxlslitRast_114443 = dataRast_114443->GETNSLIT(4) ;1096

ResX1400_114443 = data1400_114443->GETRESX()
ResY1400_114443 = data1400_114443->GETRESY()

SolarX1400_114443 = data1400_114443->XSCALE()
SolarY1400_114443 = data1400_114443->YSCALE()

;get exposure time in prep for normalization

exp_arrRast_114443 = dataRast_114443->GETEXP() ;clean--no 0s exposures

;get every data point in each lambda, y-pos, and image

cube1394_114443 = spectraRast1394_114443[*,*,*] ;SIZE: 3D, 161,1096,400, float

;count the number of images of original cube

array1394_114443 = spectraRast1394_114443[0,0,*]

array1400_114443 = images1400_114443[0,0,*]

nImages1394_114443 = N_ELEMENTS(array1394_114443) ;400 images

;********GUIDANCE FROM CHAD********
;Takes the array image values and
;determines the size of the array
;in x/y through N_ELEMENTS.
;The array elements are integers, so
;DOUBLE() transforms them into decimals.

nx = DOUBLE(N_ELEMENTS(array1400_114443[*,0]))
ny = DOUBLE(N_ELEMENTS(array1400_114443[0,*]))
;**********************************

;number of elements in wavelength, ypos, and image of original cube

n_img1394_114443 = N_ELEMENTS(spectraRast1394_114443[0,0,*]) ;400 images
n_wav1394_114443 = N_ELEMENTS(spectraRast1394_114443[*,0,0]) ;161 wavelengths b/w 1391-1395
n_ypos1394_114443 = N_ELEMENTS(spectraRast1394_114443[0,*,0]) ;1096 y-positions

;remove overscan by making a tilt and applying a cut, then make a new array

cut_114443 = MEAN(MEAN(spectraRast1394_114443, DIMENSION = 2), DIMENSION = 2) ;SIZE: 1D, 161, float

;PLOT, cut_114443

spectra1394_114443 = cut_114443[18:141]

;PLOT, spectra1394_114443

nspectraRast1394_114443 = spectraRast1394_114443[18:141,*,*]

;number of elements in new array: wavelength, ypos, and image of cut cube

n_wav_114443 = N_ELEMENTS(nspectraRast1394_114443[*,0,0]) ;124
n_ypos_114443 = N_ELEMENTS(nspectraRast1394_114443[0,*,0]) ;1096
n_img_114443 = N_ELEMENTS(nspectraRast1394_114443[0,0,*]) ;400

;loop for (new) exposure time normalization

FOR i = 0, nImages1394_114443-1 DO BEGIN
nspectraRast1394_114443[*,*,i] = nspectraRast1394_114443[*,*,i]/exp_arrRast_114443[i]
ENDFOR

;get average Si IV line profile of entire observation in order to get lambda0

avg_prof_114443 = MEAN(MEAN(nspectraRast1394_114443, DIMENSION = 2), DIMENSION = 2)

avg_fit_114443 = MPFITPEAK(lambda1394_114443[18:141], avg_prof_114443, coeff_avg)

wave0_114443 = coeff_avg[1] ;1393.7889

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
aspr = (ny*ResY1400_114443)/(nx*ResX1400_114443)
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

coeff_arr_114443 = DBLARR(4, n_img_114443, n_ypos_114443)

;FOR loop with cut array and coeff_arr_114443 above

TIC
FOR i = 0, n_img_114443-1 DO BEGIN
	FOR j = 0, n_ypos_114443-1 DO BEGIN
		PLOT, lambda1394_114443[18:141], nspectraRast1394_114443[*,j,i], XRANGE = [1391.7, 1395.8], TITLE = 'AR11850_114443 Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
		YFIT_114443 = MPFITPEAK(lambda1394_114443[18:141], nspectraRast1394_114443[*,j,i], coeff_114443, NTERMS = 4, STATUS = status, ERRMSG = errmsg)
		OPLOT, lambda1394_114443[18:141], YFIT_114443, COLOR = 170, LINESTYLE = 2, THICK = 5
;		WAIT, 0.05 ;chance to see fits
		coeff_arr_114443[*,i,j] = coeff_114443
	ENDFOR
ENDFOR
TOC ;Time elapsed: ~36 min

;save parameters from nested FOR loop

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/coeff_arr_114443.sav'
SAVE, coeff_avg, coeff_114443, spectraRast1394_114443, nspectraRast1394_114443, coeff_arr_114443, wave0_114443, FILENAME = sfname

;restore coeff_arr_114443

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/coeff_arr_114443.sav'
RESTORE, rfname, /VERBOSE

;velocity conversion

vel_width_114443 = (coeff_arr_114443[2,*,*]/wave0_114443) * 3e5 * sqrt(2)

;perform limits

coeff_arr_peak_114443 = coeff_arr_114443[0,*,*]

;PRINT, lambda1394_114443[18:141]

lam2_114443 = ABS(1395.3492-wave0_114443) ;1.5603923
lam1_114443 = ABS(1392.2201-wave0_114443) ;1.5687581

gamma_114443 = MAX(lam2_114443,lam1_114443)
;PRINT, gamma_114443
;PRINT, (gamma_114443/wave0_114443)

velocity_114443 = ((coeff_arr_114443[1,*,*]-wave0_114443)/wave0_114443) * 3e5 ; from param_maps

cut_ind_114443 = WHERE((coeff_arr_peak_114443 GE 12) AND (vel_width_114443 GE 40) AND (vel_width_114443 LE 1000) AND (ABS(velocity_114443 LE (gamma_114443/wave0_114443) * 3e5)), COMPLEMENT = not_cut_ind_114443, count)

;PRINT, N_ELEMENTS(cut_ind_114443) ;2425

WINDOW, XSIZE = 900, YSIZE = 700
TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

;intensity v width plot

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width_114443, coeff_arr_114443[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_114443', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy]

;perform isolation of UV burst region

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width_114443[not_cut_ind_114443], coeff_arr_peak_114443[not_cut_ind_114443], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_114443', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy]
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_114443[cut_ind_114443], coeff_arr_peak_114443[cut_ind_114443], COLOR = 255

;save as png

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1
WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0
PLOT, psym = 3, vel_width_114443, coeff_arr_114443[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_114443', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 0, XCHARSIZE = 1.5, YCHARSIZE = 1.5, XTHICK = 3, YTHICK = 3, CHARSIZE = 1.6
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/intensity_plot_114443.png', screenshot

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0
PLOT, psym = 3, vel_width_114443[not_cut_ind_114443], coeff_arr_peak_114443[not_cut_ind_114443], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_114443', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 0, XCHARSIZE = 1.5, YCHARSIZE = 1.5, XTHICK = 3, YTHICK = 3, CHARSIZE = 1.6
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_114443[cut_ind_114443], coeff_arr_peak_114443[cut_ind_114443], COLOR = 255
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/cut_intensity_plot_114443.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 8, YSIZE = 8, /INCHES, COLOR = 0, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/intensity_plot_114443.eps', /ENCAPSULATED

PLOT, psym = 3, vel_width_114443, coeff_arr_114443[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_114443', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], XTHICK = 4, YTHICK = 4, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 8, YSIZE = 8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/cut_intensity_plot_114443.eps', /ENCAPSULATED

TVLCT, [[255], [255], [255]], 2
PLOT, psym = 3, vel_width_114443[not_cut_ind_114443], coeff_arr_peak_114443[not_cut_ind_114443], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width AR11850_114443', /XLOG, /YLOG, XRANGE = [10e-3,10e6], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 2, XTHICK = 4, YTHICK = 4, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width_114443[cut_ind_114443], coeff_arr_peak_114443[cut_ind_114443], COLOR = 255

DEVICE, /CLOSE

;save all variables

sfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/all_vars_114443.sav'
SAVE, /VARIABLES, FILENAME = sfname2

OBJ_DESTROY, dataRast_114443
OBJ_DESTROY, data1400_114443

END
