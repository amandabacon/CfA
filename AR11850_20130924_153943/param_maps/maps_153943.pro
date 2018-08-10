;+
;Name: maps_153943.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/22
;USE THREE OF THE FOUR PARAMETERS FROM THE SGFs TO CREATE PARAMETER MAPS.

PRO maps_114443

;restore variables from isolate_153943.pro

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_153943/iso_vars_safe_153943.sav'
RESTORE, rfname

;cube info

nImages1400_153943 = N_ELEMENTS(array1400_153943)

;exposure time norm.

exp_arr1400_153943 = data1400_153943->GETEXP()

;exposure time norm.

FOR i = 0, nImages1400_153943-1 DO BEGIN
images1400_153943[*,*,i] = images1400_153943[*,*,i]/exp_arr1400_153943[i]
ENDFOR

;linear byte-scaling and saturation

sort_1400_153943 = ALOG10(SORT(ALOG10(images1400_153943)))
sort_1400_153943 = sort_1400_153943[WHERE(FINITE(sort_1400_153943))]
n_sort_1400_153943 = N_ELEMENTS(sort_1400_153943)

;********GUIDANCE FROM CHAD********
;Instead of assigning hard-coded
;window size info, assign to vars.
;Again, tranform from integer to
;decimal by using 'D'
wsx = 2000D
wsy = 1300D
;**********************************

WINDOW, XSIZE = wsx, YSIZE = wsy

;********GUIDANCE FROM CHAD********
;Aspect ratio (AR): ratio of w to h of img
;or screen. 
;AR uses the number of pixels and resolution
;of the plot.
aspr = (ny*ResY1400_153943)/(nx*ResX1400_153943)
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

;despike

coeff_arr_153943_clean = IRIS_PREP_DESPIKE(REFORM(coeff_arr_153943[0,*,*]), niter = 1000, min_std = 2.8, sigmas = 2.5, mode = 'both')

;velocity calculation for doppler shift

velocity_153943 = ((coeff_arr_153943[1,*,*]-wave0_153943)/wave0_153943) * 3e5

velocity_153943_clean = IRIS_PREP_DESPIKE(REFORM(velocity_153943), niter = 1000, min_std = 2.8, sigmas = 2.5, mode = 'both')

;velocity calc. for line width

vel_width_153943 = (coeff_arr_153943[2,*,*]/wave0_153943) * 3e5 * sqrt(2)

vel_width_153943_clean = IRIS_PREP_DESPIKE(REFORM(vel_width_153943), niter = 1000, min_std = 2.8, sigmas = 2.5, mode = 'both')

;plot intensity

EIS_COLORS, /INTENSITY

PLOT_IMAGE, REFORM(coeff_arr_153943_clean), ORIGIN = [solarx1400_153943[0], solary1400_153943[0]], SCALE = [ResX1400_153943, ResY1400_153943], MIN = 5, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL
COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.07,0.75,0.33,0.76], /TOP

;plot line width

EIS_COLORS, /WIDTH

PLOT_IMAGE, REFORM(vel_width_153943_clean), ORIGIN = [solarx1400_153943[0], solary1400_153943[0]], SCALE = [ResX1400_153943, ResY1400_153943], MIN = 7, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+dx,y0,x0+(2.0*dx),y0+dy], /CURRENT, /NORMAL, /NOERASE, YCHARSIZE = 0.001
COLORBAR, FORMAT = '(F0.2)', TITLE = "Exponential Line Width [km*s^-1]", RANGE = [7, 75], /YLOG, YTICKS = 10, POSITION = [0.37,0.75,0.63,0.76], /TOP

;plot doppler shift

EIS_COLORS, /VELOCITY, /DARK

PLOT_IMAGE, REFORM(velocity_153943_clean), ORIGIN = [solarx1400_153943[0], solary1400_153943[0]], SCALE = [ResX1400_153943, ResY1400_153943], MIN = -35, MAX = 35, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+(2.0*dx),y0,x0+(3.0*dx),y0+dy], /CURRENT,/NORMAL,/NOERASE, YCHARSIZE = 0.001, TOP = 254
COLORBAR, FORMAT = '(F0.2)', TITLE = "Doppler Shift [km*s^-1]", POSITION = [0.67,0.75,0.93,0.76], /TOP, /YLOG, YTICKS = 10, RANGE = [-35, 35]

;save as png

WINDOW, XSIZE = 2000, YSIZE = 1300, RETAIN = 2

EIS_COLORS, /INTENSITY
PLOT_IMAGE, REFORM(coeff_arr_153943_clean), ORIGIN = [solarx1400_153943[0], solary1400_153943[0]], SCALE = [ResX1400_153943, ResY1400_153943], MIN = 5, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45
COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.07,0.75,0.33,0.76], /TOP, CHARSIZE = 1.4

EIS_COLORS, /WIDTH
PLOT_IMAGE, REFORM(vel_width_153943_clean), ORIGIN = [solarx1400_153943[0], solary1400_153943[0]], SCALE = [ResX1400_153943, ResY1400_153943], MIN = 7, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+dx,y0,x0+(2.0*dx),y0+dy], /CURRENT, /NORMAL, /NOERASE, YCHARSIZE = 0.001, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45
COLORBAR, FORMAT = '(F0.2)', TITLE = "Exponential Line Width [km*s^-1]", RANGE = [7, 75], /YLOG, YTICKS = 10, POSITION = [0.37,0.75,0.63,0.76], /TOP, CHARSIZE = 1.4

EIS_COLORS, /VELOCITY, /DARK
PLOT_IMAGE, REFORM(velocity_153943_clean), ORIGIN = [solarx1400_153943[0], solary1400_153943[0]], SCALE = [ResX1400_153943, ResY1400_153943], MIN = -35, MAX = 35, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+(2.0*dx),y0,x0+(3.0*dx),y0+dy], /CURRENT,/NORMAL,/NOERASE, YCHARSIZE = 0.001, TOP = 254, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45
COLORBAR, FORMAT = '(F0.2)', TITLE = "Doppler Shift [km*s^-1]", POSITION = [0.67,0.75,0.93,0.76], /TOP, /YLOG, YTICKS = 10, RANGE = [-35, 35], CHARSIZE = 1.4

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_153943/param_maps/param_plot_153943.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 25, YSIZE = 12, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_153943/param_maps/param_plot_153943.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY
PLOT_IMAGE, REFORM(coeff_arr_153943_clean), ORIGIN = [solarx1400_153943[0], solary1400_153943[0]], SCALE = [ResX1400_153943, ResY1400_153943], MIN = 5, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YCHARSIZE = 1.4, YTHICK = 10, XTHICK = 10
COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.07,0.75,0.33,0.76], /TOP, CHARSIZE = 1.4

EIS_COLORS, /WIDTH
PLOT_IMAGE, REFORM(vel_width_153943_clean), ORIGIN = [solarx1400_153943[0], solary1400_153943[0]], SCALE = [ResX1400_153943, ResY1400_153943], MIN = 7, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+dx,y0,x0+(2.0*dx),y0+dy], /CURRENT, /NORMAL, /NOERASE, YCHARSIZE = 0.001, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YTHICK = 10, XTHICK = 10
COLORBAR, FORMAT = '(F0.2)', TITLE = "Exponential Line Width [km*s^-1]", RANGE = [7, 75], /YLOG, YTICKS = 10, POSITION = [0.37,0.75,0.63,0.76], /TOP, CHARSIZE = 1.4

EIS_COLORS, /VELOCITY, /DARK
PLOT_IMAGE, REFORM(velocity_153943_clean), ORIGIN = [solarx1400_153943[0], solary1400_153943[0]], SCALE = [ResX1400_153943, ResY1400_153943], MIN = -35, MAX = 35, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+(2.0*dx),y0,x0+(3.0*dx),y0+dy], /CURRENT,/NORMAL,/NOERASE, YCHARSIZE = 0.001, TOP = 254, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YTHICK = 10, XTHICK = 10
COLORBAR, FORMAT = '(F0.2)', TITLE = "Doppler Shift [km*s^-1]", POSITION = [0.67,0.75,0.93,0.76], /TOP, /YLOG, YTICKS = 10, RANGE = [-35, 35], CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_153943
OBJ_DESTROY, data1400_153943

END
