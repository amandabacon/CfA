;+
;Name: siiv.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/06/20
;EDITED: 2018/07/12 --plot aspr, eps appearance
;EDITED: 2018/08/02 --plots aspr, eps appearance
;USING SI IV 1394 LINE, APPLY 4-PARAMTER SINGLE GAUSSIAN FIT (SGF) TO
;EACH SPECTRA OVER 400 STEP RASTER TO MAKE A SCATTER PLOT OF PEAK
;INTENSITY VS LINE WIDTH OF APPLY A CUT IN 4-D PARAMETER SPACE TO GET UVB POPULATION REGION

PRO siiv

;load the data

IRast = '/data/khnum/REU2018/abacon/data/20130924_050945/iris_l2_20130924_050945_4000254145_raster_t000_r00000.fits'

SJI1400 = '/data/khnum/REU2018/abacon/data/20130924_050945/iris_l2_20130924_050945_4000254145_SJI_1400_t000.fits'

;read the data

dataRast = IRIS_OBJ(IRast)

data1400 = IRIS_SJI(SJI1400)

;load images/profiles (WANT SI IV 1394)

dataRast->SHOW_LINES
spectraRast1394 = dataRast->GETVAR(4, /LOAD)

images1400 = data1400->GETVAR()

;get spectral information

lambda1394 = dataRast->GETLAM(4) ;1391-1395 wavelengths, inclusive
pxlslitRast = dataRast->GETNSLIT(4) ;1096 pixels along slit

ResX1400 = data1400->GETRESX()
ResY1400 = data1400->GETRESY()

;get exposure time in prep for normalization

exp_arrRast = dataRast->GETEXP()

;get every data point in each lambda, y-pos, and image

cube1394 = spectraRast1394[*,*,*] ;SIZE: 3D, 161,1096,400, float

;count the number of images of original cube

array1394 = spectraRast1394[0,0,*]

array1400 = images1400[0,0,*]

nImages1394 = N_ELEMENTS(array1394) ;400 images

;********GUIDANCE FROM CHAD********
;Takes the array image values and
;determines the size of the array
;in x/y through N_ELEMENTS.
;The array elements are integers, so
;DOUBLE() transforms them into decimals.

nx = DOUBLE(N_ELEMENTS(array1400[*,0]))
ny = DOUBLE(N_ELEMENTS(array1400[0,*]))
;**********************************

;number of elements in wavelength, ypos, and image of original cube

n_img1394 = N_ELEMENTS(spectraRast1394[0,0,*]) ;400 images
n_wav1394 = N_ELEMENTS(spectraRast1394[*,0,0]) ;161 wavelengths b/w 1391-1395
n_ypos1394 = N_ELEMENTS(spectraRast1394[0,*,0]) ;1096 y-positions

;remove overscan by making a tilt and applying a cut, then make a new array

cut = MEAN(MEAN(spectraRast1394, DIMENSION = 2), DIMENSION = 2) ;SIZE: 1D, 161, float

spectra1394 = cut[18:141] ;remove where tilt is located

nspectraRast1394 = spectraRast1394[18:141,*,*]

;number of elements in new array: wavelength, ypos, and image of cut cube

n_wav = N_ELEMENTS(nspectraRast1394[*,0,0]) ;124
n_ypos = N_ELEMENTS(nspectraRast1394[0,*,0]) ;1096
n_img = N_ELEMENTS(nspectraRast1394[0,0,*]) ;400

;loop for (new) exposure time normalization

FOR i = 0, nImages1394-1 DO BEGIN
nspectraRast1394[*,*,i] = nspectraRast1394[*,*,i]/exp_arrRast[i]
ENDFOR

;get average Si IV line profile of entire observation in order to get lambda0
;apply /NAN because if print array of exposure times, the last val is 0.
;last frame of obs. disappeared and set all to 0 s. Produces -Inf vals when
;doing below.

n_avg_prof = MEAN(MEAN(nspectraRast1394, DIMENSION = 2, /NAN), DIMENSION = 2, /NAN)

;PRINT, n_avg_prof

avg_fit = MPFITPEAK(lambda1394[18:141], n_avg_prof, coeff2)

wave0 = coeff2[1]

;PRINT, wave0 ;1393.7889

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
aspr = (ny*ResY1400)/(nx*ResX1400)
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

coeff_arr = DBLARR(4, n_img, n_ypos)

;FOR loop with cut array and coeff_arr above, nspectraRast1394 with exposure time = 0s in last frame

TIC
FOR i = 0, n_img-1 DO BEGIN
	FOR j = 0, n_ypos-1 DO BEGIN
		PLOT, lambda1394[18:141], nspectraRast1394[*,j,i], XRANGE = [1391.7, 1395.8], TITLE = 'Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
		CATCH, Error_status
		IF Error_status NE 0 THEN BEGIN
		PRINT, 'ERROR INDEX: ', Error_status
		PRINT, 'ERROR MSG: ', !ERROR_STATE.MSG
		ENDIF
;		PRINT, nspectraRast1394[*,j,i]
		YFIT = MPFITPEAK(lambda1394[18:141], nspectraRast1394[*,j,i], coeff, NTERMS = 4, STATUS = status, ERRMSG = errmsg)
		IF STATUS LE 0 THEN message, errmsg
;		MPFIT_RESET_RECURSION
;		PRINT, YFIT
;		PRINT, coeff
		OPLOT, lambda1394[18:141], YFIT, COLOR = 170, LINESTYLE = 2, THICK = 5
;		WAIT, 0.05 ;chance to see fits
		coeff_arr[*,i,j] = coeff
		CATCH, Error_status
		IF Error_status NE 0 THEN BEGIN
		PRINT, 'ERROR INDEX: ', Error_status
		PRINT, 'ERROR MSG: ', !ERROR_STATE.MSG
		ENDIF
	ENDFOR
ENDFOR
TOC ;Time elapsed: ~1 hr

;save parameters from nested FOR loop

sfname = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/coeff2.sav' 
SAVE, coeff, coeff_arr, nspectraRast1394, coeff2, wave0, FILENAME = sfname

;restore coeff_arr

rfname = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/coeff2.sav'
RESTORE, rfname, /VERBOSE

;velocity conversion

vel_width = (coeff_arr[2,*,*]/1393.7889) * 3e5 * sqrt(2)

;perform limits

coeff_arr_peak = coeff_arr[0,*,*]

;PRINT, lambda1394[18:141]

lam2 = ABS(1395.3492-wave0)
lam1 = ABS(1392.2201-wave0)

gamma = MAX(lam2,lam1)
;PRINT, gamma
;PRINT, (gamma/wave0)

velocity = ((coeff_arr[1,*,*]-wave0)/wave0) * 3e5 ; from param_maps

cut_ind = WHERE((coeff_arr_peak GE 7) AND (vel_width GE 53) AND (vel_width LE 1000) AND (ABS(velocity LE (gamma/wave0) * 3e5)), COMPLEMENT = not_cut_ind, count)

;PRINT, N_ELEMENTS(cut_ind)

WINDOW, XSIZE = 900, YSIZE = 700
TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

;intensity v width plot

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width, coeff_arr[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width', /XLOG, /YLOG, XRANGE = [10e-2,10e6], POSITION = [x0,y0,x0+dx,y0+dy]

;perform isolation of UV burst region

WINDOW, XSIZE = 900, YSIZE = 700
PLOT, psym = 3, vel_width[not_cut_ind], coeff_arr_peak[not_cut_ind], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width', /XLOG, /YLOG, XRANGE = [10e-2,10e6], POSITION = [x0,y0,x0+dx,y0+dy]
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width[cut_ind], coeff_arr_peak[cut_ind], COLOR = 255

;save as png

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0
PLOT, psym = 3, vel_width, coeff_arr[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width', /XLOG, /YLOG, XRANGE = [10e-2,10e6], COLOR = 0, POSITION = [x0,y0,x0+dx,y0+dy], XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/1394_SGF/intensity_plot.png', screenshot

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
TVLCT, [[255], [255], [255]], 0
PLOT, psym = 3, vel_width[not_cut_ind], coeff_arr_peak[not_cut_ind], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width', /XLOG, /YLOG, XRANGE = [10e-2,10e6], COLOR = 0, POSITION = [x0,y0,x0+dx,y0+dy], XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width[cut_ind], coeff_arr_peak[cut_ind], COLOR = 255
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/1394_SGF/cut_intensity_plot.png', screenshot

;save as ps

!P.FONT = 1

;TVLCT, [[0], [0], [0]], 1
;!P.BACKGROUND = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 0, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/intensity_plot.eps', /ENCAPSULATED

PLOT, psym = 3, vel_width, coeff_arr[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width', /XLOG, /YLOG, XRANGE = [10e-2,10e6], XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YCHARSIZE = 1.4, YTHICK = 10, XTHICK = 10

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/cut_intensity_plot.eps', /ENCAPSULATED

TVLCT, [[255], [255], [255]], 2
PLOT, psym = 3, vel_width[not_cut_ind], coeff_arr_peak[not_cut_ind], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width', /XLOG, /YLOG, XRANGE = [10e-2,10e6], COLOR = 2, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YCHARSIZE = 1.4, YTHICK = 10, XTHICK = 10
TVLCT, [[255], [0], [0]], 255
OPLOT, psym = 3, vel_width[cut_ind], coeff_arr_peak[cut_ind], COLOR = 255

DEVICE, /CLOSE

;save all variables

sfname2 = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/all_vars.sav'
SAVE, /VARIABLES, FILENAME = sfname2

OBJ_DESTROY, dataRast
OBJ_DESTROY, data1400

END
