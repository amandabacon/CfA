;+
;Name: siiv.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/06/20

PRO siiv

;load the data

IRast = '/data/khnum/REU2018/abacon/data/20130924_050945/iris_l2_20130924_050945_4000254145_raster_t000_r00000.fits'

SJI1400 = '/data/khnum/REU2018/abacon/data/20130924_050945/iris_l2_20130924_050945_4000254145_SJI_1400_t000.fits'

;read the data

dataRast = IRIS_OBJ(IRast)

data1400 = IRIS_SJI(SJI1400)

;load images

dataRast->SHOW_LINES
spectraRast1394 = dataRast->GETVAR(4, /LOAD)

images1400 = data1400->GETVAR()

;get spectral information

lambda1394 = dataRast->GETLAM(4) ;1391-1395 wavelengths, inclusive
pxlslitRast = dataRast->GETNSLIT(4) ;1096 pixels along slit

ResX1400 = data1400->GETRESX()
ResY1400 = data1400->GETRESY()

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

;********GUIDANCE FROM CHAD********
;Instead of assigning hard-coded
;window size info, assign to vars.
;Again, tranform from integer to
;decimal by using 'D'
wsx = 900D
wsy = 500D
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
y0 = 0.5*(1.0-((aspr/aspw)*(nr/nc)*(1.0-(3.0*x0))))
dx = (1.0/nc)*(1.0-(2.0*x0))
dy = (1.0/nr)*(1.0-(2.0*y0))

;Print values
;PRINT, aspr, aspw, x0, y0, dx, dy

;STOP
;**********************************

;create array to hold coeff paramters from FOR loop, images, & y-pos

coeff_arr = DBLARR(4, n_img, n_ypos)

;FOR loop with cut array and coeff_arr above

TIC
FOR i = 0, n_img-1 DO BEGIN
	FOR j = 0, n_ypos-1 DO BEGIN
		PLOT, lambda1394[18:141], nspectraRast1394[*,j,i], XRANGE = [1391.7, 1395.8], TITLE = 'Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
;		PRINT, nspectraRast1394[*,j,i]
		YFIT = MPFITPEAK(lambda1394[18:141], nspectraRast1394[*,j,i], coeff, NTERMS = 4, STATUS = status, ERRMSG = errmsg)
		IF STATUS LE 0 THEN message, errmsg
;		MPFIT_RESET_RECURSION
;		PRINT, YFIT
;		PRINT, coeff
		OPLOT, lambda1394[18:141], YFIT, COLOR = 170, LINESTYLE = 2, THICK = 5
		IF STATUS LE 0 THEN message, errmsg
;		WAIT, 0.05 ;chance to see fits
		coeff_arr[*,i,j] = coeff
	ENDFOR
ENDFOR
TOC ;Time elapsed: 8676.6433 seconds 2hrs 41 min

;save parameters from coeff and coeff_arr

sfname = '/data/khnum/REU2018/abacon/data/gaussian/coeff.sav' 
SAVE, coeff, coeff_arr, FILENAME = sfname

;restore coeff_arr

rfname = '/data/khnum/REU2018/abacon/data/gaussian/coeff.sav'
RESTORE, rfname, /VERBOSE

;intensity v width plot

WINDOW, XSIZE = 900, YSIZE = 500
PLOT, psym = 3, coeff_arr[2,*,*], coeff_arr[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width', /XLOG, /YLOG

;save as png

WINDOW, XSIZE = 900, YSIZE = 500, RETAIN = 2
PLOT, psym = 3, coeff_arr[2,*,*], coeff_arr[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width', /XLOG, /YLOG
screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/gaussian/intensity_plot.png', screenshot

;save as ps

SET_PLOT, 'ps'
DEVICE, COLOR = 0, BITS_PER_PIXEL = 8, FILENAME = '/data/khnum/REU2018/abacon/data/gaussian/intensity_plot.eps', /ENCAPSULATED

PLOT, psym = 3, coeff_arr[2,*,*], coeff_arr[0,*,*], XTITLE = 'Line Width [km*s^-1]', YTITLE = 'Peak Instensity [Arb. Units]', TITLE = 'Scatter Plot of Intensity vs Width', /XLOG, /YLOG

DEVICE, /CLOSE

OBJ_DESTROY, dataRast
OBJ_DESTROY, data1400

END
