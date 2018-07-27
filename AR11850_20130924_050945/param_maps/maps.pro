;+
;Name: maps.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/06/29

PRO maps

;load the data

IRast = '/data/khnum/REU2018/abacon/data/20130924_050945/iris_l2_20130924_050945_4000254145_raster_t000_r00000.fits'

SJI1330 = '/data/khnum/REU2018/abacon/data/20130924_050945/iris_l2_20130924_050945_4000254145_SJI_1330_t000.fits'

;read the data

dataRast = IRIS_OBJ(IRast)

data1330 = IRIS_SJI(SJI1330)

;load images/profiles

dataRast->SHOW_LINES
spectraRast1394 = dataRast->GETVAR(4, /LOAD)

images1330 = data1330->GETVAR()

;cubes

cube1394 = spectraRast1394[*,*,*]

;number of images

array1394 = spectraRast1394[0,0,*]

array1330 = images1330[0,0,*]

nImages1394 = N_ELEMENTS(array1394)

nImages1330 = N_ELEMENTS(array1330) ;SIZE->3D, 1874,1096,96, FLOAT

;exposure time norm.

exp_arrRast = dataRast->GETEXP()

exp_arr1330 = data1330->GETEXP()

;get spectral information and solar coords & res

lambda1394 = dataRast->GETLAM(4)
pxlslitRast = dataRast->GETNSLIT(4)

ResX1330 = data1330->GETRESX()
ResY1330 = data1330->GETRESY()

solarx1330 = data1330->XSCALE()
solary1330 = data1330->YSCALE()

;number of elements in array

n_ypos1330 = N_ELEMENTS(images1330[0,*,0])
n_img1330 = N_ELEMENTS(images1330[0,0,*])

;aspect-ratio normalization

;********GUIDANCE FROM CHAD********
;Takes the array image values and
;determines the size of the array
;in x/y through N_ELEMENTS.
;The array elements are integers, so
;DOUBLE() transforms them into decimals.

nx = DOUBLE(N_ELEMENTS(array1330[*,0]))
ny = DOUBLE(N_ELEMENTS(array1330[0,*]))
;**********************************

;restore variables from siiv.pro

rfname = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/coeff2.sav'
RESTORE, rfname, /VERBOSE

;exposure time norm.

FOR i = 0, nImages1330-1 DO BEGIN
images1330[*,*,i] = images1330[*,*,i]/exp_arr1330[i]
ENDFOR

;linear byte-scaling and saturation

sort_1330 = ALOG10(SORT(ALOG10(images1330)))
sort_1330 = sort_1330[WHERE(FINITE(sort_1330))]
n_sort_1330 = N_ELEMENTS(sort_1330)

;********GUIDANCE FROM CHAD********
;Instead of assigning hard-coded
;window size info, assign to vars.
;Again, tranform from integer to
;decimal by using 'D'
wsx = 1200D
wsy = 500D
;**********************************

WINDOW, XSIZE = wsx, YSIZE = wsy

;********GUIDANCE FROM CHAD********
;Aspect ratio (AR): ratio of w to h of img
;or screen. 
;AR uses the number of pixels and resolution
;of the plot.
aspr = (ny*ResY1330)/(nx*ResX1330)
aspw = wsy/wsx

;Number of rows and columns on plotting window
;(want in decimal form).
nr = 1.0
nc = 3.0

;Choose x0 and calc. y0, dx, and dy using:
x0 = 0.05
y0 = 0.5*(1.0-((aspr/aspw)*(nr/nc)*(1.0-(2.0*x0))))
dx = (1.0/nc)*(1.0-(2.0*x0))
dy = (1.0/nr)*(1.0-(2.0*y0))

;Print values
;PRINT, aspr, aspw, x0, y0, dx, dy

;STOP
;**********************************

;velocity calculation for doppler shift

velocity = ((coeff_arr[1,*,*]-wave0)/wave0) * 3e5

;velocity calc. for line width

vel_width = (coeff_arr[2,*,*]/1393.7889) * 3e5 * sqrt(2)

;REFORM Help

;HELP, REFORM(coeff_arr[0,*,*])
;PRINT, SIZE(REFORM(coeff_arr[0,*,*]))

;plot intensity

EIS_COLORS, /INTENSITY

PLOT_IMAGE, REFORM(coeff_arr[0,*,*]), ORIGIN = [solarx1330[0], solary1330[0]], SCALE = [ResX1330, ResY1330], MIN = 5, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL
COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.07,0.91,0.33,0.92], /TOP

;plot line width

EIS_COLORS, /WIDTH

PLOT_IMAGE, REFORM(vel_width), ORIGIN = [solarx1330[0], solary1330[0]], SCALE = [ResX1330, ResY1330], MIN = 7, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+dx,y0,x0+(2.0*dx),y0+dy], /CURRENT, /NORMAL, /NOERASE, YCHARSIZE = 0.001
COLORBAR, FORMAT = '(F0.2)', TITLE = "Exponential Line Width [km*s^-1]", RANGE = [7, 75], /YLOG, YTICKS = 10, POSITION = [0.37,0.91,0.63,0.92], /TOP

;plot doppler shift

EIS_COLORS, /VELOCITY

PLOT_IMAGE, REFORM(velocity), ORIGIN = [solarx1330[0], solary1330[0]], SCALE = [ResX1330, ResY1330], MIN = -35, MAX = 35, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+(2.0*dx),y0,x0+(3.0*dx),y0+dy], /CURRENT,/NORMAL,/NOERASE, YCHARSIZE = 0.001
COLORBAR, FORMAT = '(F0.2)', TITLE = "Doppler Shift [km*s^-1]", POSITION = [0.67,0.91,0.93,0.92], /TOP, /YLOG, YTICKS = 10, RANGE = [-35, 35]

;save as png

WINDOW, XSIZE = 1200, YSIZE = 500, RETAIN = 2

EIS_COLORS, /INTENSITY
PLOT_IMAGE, REFORM(coeff_arr[0,*,*]), ORIGIN = [solarx1330[0], solary1330[0]], SCALE = [ResX1330, ResY1330], MIN = 5, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.6, YCHARSIZE = 1.55, TITLECHARSIZE = 1.6
COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.07,0.91,0.33,0.92], /TOP, CHARSIZE = 1.3

EIS_COLORS, /WIDTH
PLOT_IMAGE, REFORM(vel_width), ORIGIN = [solarx1330[0], solary1330[0]], SCALE = [ResX1330, ResY1330], MIN = 7, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+dx,y0,x0+(2.0*dx),y0+dy], /CURRENT, /NORMAL, /NOERASE, YCHARSIZE = 0.001, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.6, TITLECHARSIZE = 1.6
COLORBAR, FORMAT = '(F0.2)', TITLE = "Exponential Line Width [km*s^-1]", RANGE = [7, 75], /YLOG, YTICKS = 10, POSITION = [0.37,0.91,0.63,0.92], /TOP, CHARSIZE = 1.3

EIS_COLORS, /VELOCITY, /DARK
PLOT_IMAGE, REFORM(velocity), ORIGIN = [solarx1330[0], solary1330[0]], SCALE = [ResX1330, ResY1330], MIN = -35, MAX = 35, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+(2.0*dx),y0,x0+(3.0*dx),y0+dy], /CURRENT,/NORMAL,/NOERASE, YCHARSIZE = 0.001, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.6, TITLECHARSIZE = 1.6
COLORBAR, FORMAT = '(F0.2)', TITLE = "Doppler Shift [km*s^-1]", POSITION = [0.67,0.91,0.93,0.92], /TOP, /YLOG, YTICKS = 10, RANGE = [-35, 35], CHARSIZE = 1.3

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/param_maps/param_plot.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 9, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/param_maps/param_plot.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY
PLOT_IMAGE, REFORM(coeff_arr[0,*,*]), ORIGIN = [solarx1330[0], solary1330[0]], SCALE = [ResX1330, ResY1330], MIN = 5, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.7, YCHARSIZE = 1.7
COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.07,0.91,0.33,0.92], /TOP, CHARSIZE = 1.4

EIS_COLORS, /WIDTH
PLOT_IMAGE, REFORM(vel_width), ORIGIN = [solarx1330[0], solary1330[0]], SCALE = [ResX1330, ResY1330], MIN = 7, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+dx,y0,x0+(2.0*dx),y0+dy], /CURRENT, /NORMAL, /NOERASE, YCHARSIZE = 0.001, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.7
COLORBAR, FORMAT = '(F0.2)', TITLE = "Exponential Line Width [km*s^-1]", RANGE = [7, 75], /YLOG, YTICKS = 10, POSITION = [0.37,0.91,0.63,0.92], /TOP, CHARSIZE = 1.4

EIS_COLORS, /VELOCITY, /DARK
PLOT_IMAGE, REFORM(velocity), ORIGIN = [solarx1330[0], solary1330[0]], SCALE = [ResX1330, ResY1330], MIN = -35, MAX = 35, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+(2.0*dx),y0,x0+(3.0*dx),y0+dy], /CURRENT,/NORMAL,/NOERASE, YCHARSIZE = 0.001, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.7
COLORBAR, FORMAT = '(F0.2)', TITLE = "Doppler Shift [km*s^-1]", POSITION = [0.67,0.91,0.93,0.92], /TOP, /YLOG, YTICKS = 10, RANGE = [-35, 35], CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast
OBJ_DESTROY, data1330

END
