;+
;Name: maps_063943.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/22

;PRO maps_063943

;restore variables from isolate_063943.pro

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/iso_vars_safe_063943.sav'
RESTORE, rfname

;cube info

nImages1400_063943 = N_ELEMENTS(array1400_063943)

;exposure time norm.

exp_arr1400_063943 = data1400_063943->GETEXP()

;exposure time norm.

FOR i = 0, nImages1400_063943-1 DO BEGIN
images1400_063943[*,*,i] = images1400_063943[*,*,i]/exp_arr1400_063943[i]
ENDFOR

;linear byte-scaling and saturation

sort_1400_063943 = ALOG10(SORT(ALOG10(images1400_063943)))
sort_1400_063943 = sort_1400_063943[WHERE(FINITE(sort_1400_063943))]
n_sort_1400_063943 = N_ELEMENTS(sort_1400_063943)

;********GUIDANCE FROM CHAD********
;Instead of assigning hard-coded
;window size info, assign to vars.
;Again, tranform from integer to
;decimal by using 'D'
wsx = 1000D
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

coeff_arr_063943_clean = ARRAY_DESPIKE(coeff_arr_063943, sigma = 5, itmax = 10)

;velocity calculation for doppler shift

velocity_063943 = ((coeff_arr_063943[1,*,*]-wave0_063943)/wave0_063943) * 3e5

;velocity calc. for line width

vel_width_063943 = (coeff_arr_063943[2,*,*]/wave0_063943) * 3e5 * sqrt(2)

;plot intensity

EIS_COLORS, /INTENSITY

PLOT_IMAGE, REFORM(coeff_arr_063943[0,*,*]), ORIGIN = [solarx1400_063943[0], solary1400_063943[0]], SCALE = [ResX1400_063943, ResY1400_063943], MIN = 5, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL
COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.07,0.75,0.33,0.76], /TOP

;plot line width

EIS_COLORS, /WIDTH

PLOT_IMAGE, REFORM(vel_width_063943), ORIGIN = [solarx1400_063943[0], solary1400_063943[0]], SCALE = [ResX1400_063943, ResY1400_063943], MIN = 7, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+dx,y0,x0+(2.0*dx),y0+dy], /CURRENT, /NORMAL, /NOERASE, YCHARSIZE = 0.001
COLORBAR, FORMAT = '(F0.2)', TITLE = "Exponential Line Width [km*s^-1]", RANGE = [7, 75], /YLOG, YTICKS = 10, POSITION = [0.37,0.75,0.63,0.76], /TOP

;plot doppler shift

EIS_COLORS, /VELOCITY, /DARK

PLOT_IMAGE, REFORM(velocity_063943), ORIGIN = [solarx1400_063943[0], solary1400_063943[0]], SCALE = [ResX1400_063943, ResY1400_063943], MIN = -35, MAX = 35, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+(2.0*dx),y0,x0+(3.0*dx),y0+dy], /CURRENT,/NORMAL,/NOERASE, YCHARSIZE = 0.001, TOP = 254
COLORBAR, FORMAT = '(F0.2)', TITLE = "Doppler Shift [km*s^-1]", POSITION = [0.67,0.75,0.93,0.76], /TOP, /YLOG, YTICKS = 10, RANGE = [-35, 35]

;save as png

WINDOW, XSIZE = 1200, YSIZE = 600, RETAIN = 2

EIS_COLORS, /INTENSITY
PLOT_IMAGE, REFORM(coeff_arr_063943[0,*,*]), ORIGIN = [solarx1400_063943[0], solary1400_063943[0]], SCALE = [ResX1400_063943, ResY1400_063943], MIN = 5, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL
COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.07,0.75,0.33,0.76], /TOP

EIS_COLORS, /WIDTH
PLOT_IMAGE, REFORM(vel_width_063943), ORIGIN = [solarx1400_063943[0], solary1400_063943[0]], SCALE = [ResX1400_063943, ResY1400_063943], MIN = 7, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+dx,y0,x0+(2.0*dx),y0+dy], /CURRENT, /NORMAL, /NOERASE, YCHARSIZE = 0.001
COLORBAR, FORMAT = '(F0.2)', TITLE = "Exponential Line Width [km*s^-1]", RANGE = [7, 75], /YLOG, YTICKS = 10, POSITION = [0.37,0.75,0.63,0.76], /TOP

EIS_COLORS, /VELOCITY, /DARK
PLOT_IMAGE, REFORM(velocity_063943), ORIGIN = [solarx1400_063943[0], solary1400_063943[0]], SCALE = [ResX1400_063943, ResY1400_063943], MIN = -35, MAX = 35, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+(2.0*dx),y0,x0+(3.0*dx),y0+dy], /CURRENT,/NORMAL,/NOERASE, YCHARSIZE = 0.001, TOP = 254
COLORBAR, FORMAT = '(F0.2)', TITLE = "Doppler Shift [km*s^-1]", POSITION = [0.67,0.75,0.93,0.76], /TOP, /YLOG, YTICKS = 10, RANGE = [-35, 35]

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/param_maps/param_plot_063943.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 9, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/param_maps/param_plot_063943.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY
PLOT_IMAGE, REFORM(coeff_arr_063943[0,*,*]), ORIGIN = [solarx1400_063943[0], solary1400_063943[0]], SCALE = [ResX1400_063943, ResY1400_063943], MIN = 5, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL
COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.07,0.75,0.33,0.76], /TOP

EIS_COLORS, /WIDTH
PLOT_IMAGE, REFORM(vel_width_063943), ORIGIN = [solarx1400_063943[0], solary1400_063943[0]], SCALE = [ResX1400_063943, ResY1400_063943], MIN = 7, MAX = 75, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+dx,y0,x0+(2.0*dx),y0+dy], /CURRENT, /NORMAL, /NOERASE, YCHARSIZE = 0.001
COLORBAR, FORMAT = '(F0.2)', TITLE = "Exponential Line Width [km*s^-1]", RANGE = [7, 75], /YLOG, YTICKS = 10, POSITION = [0.37,0.75,0.63,0.76], /TOP

EIS_COLORS, /VELOCITY, /DARK
PLOT_IMAGE, REFORM(velocity_063943), ORIGIN = [solarx1400_063943[0], solary1400_063943[0]], SCALE = [ResX1400_063943, ResY1400_063943], MIN = -35, MAX = 35, XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0+(2.0*dx),y0,x0+(3.0*dx),y0+dy], /CURRENT,/NORMAL,/NOERASE, YCHARSIZE = 0.001, TOP = 254
COLORBAR, FORMAT = '(F0.2)', TITLE = "Doppler Shift [km*s^-1]", POSITION = [0.67,0.75,0.93,0.76], /TOP, /YLOG, YTICKS = 10, RANGE = [-35, 35]

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_063943
OBJ_DESTROY, data1400_063943

END