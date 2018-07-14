;+
;Name: isolate_clean.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/12
;NOTE: DOESN'T LIKE RESTORING AFTER FOR LOOP

PRO isolate_clean

;restore variables

rfname = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/iso_vars_safe.sav'
RESTORE, rfname

UVB_ind_ry = ARRAY_INDICES([raster,yposition], UVB_ind, /DIMENSIONS)
;PRINT, SIZE(UVB_ind_ry) ;2D 2,446

UVB_ind_r = REFORM(UVB_ind_ry[0,*]) ;1D 446
UVB_ind_y = REFORM(UVB_ind_ry[1,*]) ;1D 446

UVB_cut_size = N_ELEMENTS(UVB_ind) ;446

is_absorb_clean = LONARR(UVB_cut_size)

TIC
FOR i = 0, UVB_cut_size-1 DO BEGIN
	WINDOW, XSIZE = 900, YSIZE = 500
	PLOT, lambda1394[18:141], REFORM(nspectraRast1394[*,UVB_ind_y[i],UVB_ind_r[i]]), XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy]
	ch = ''
	READ, ch, PROMPT = 'UVB?: '
		IF ch EQ 'y' THEN BEGIN
		is_absorb_clean[i] = 1
		ind_absorb_clean = WHERE(is_absorb_clean EQ 1)
		UVB_ind_clean = UVB_ind[ind_absorb_clean]
		ENDIF
ENDFOR
TOC

;save new params

sfname_safe_clean = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/iso_vars_safe_clean.sav'
SAVE, /VARIABLES, FILENAME = sfname_safe_clean

;load data

SJI1330 = '/data/khnum/REU2018/abacon/data/20130924_050945/iris_l2_20130924_050945_4000254145_SJI_1330_t000.fits'

;read data

data1330 = IRIS_SJI(SJI1330)

;load images/profiles

images1330 = data1330->GETVAR()

;number of images

array1330 = images1330[0,0,*]

;restore variables

rfname2 = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/iso_vars_safe_clean.sav'
RESTORE, rfname2

rfname3 = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/coeff_arr_clean.sav'
RESTORE, rfname3

;byte-scaling and saturation

sort_c = coeff_arr_clean[SORT(coeff_arr_clean)]
sort_c = sort_c[WHERE(FINITE(sort_c) OR (sort_c NE -200))]
n_sort_c = N_ELEMENTS(sort_c)

;BYTSCL()

byte_scale = BYTSCL(coeff_arr_clean[0,*,*], MIN = 5, MAX = 75, TOP = 254)

;PRINT, SIZE(byte_scale[UVB_ind_clean]) ;1D 272

;byte_scale[cut_ind] = 255
;byte_scale[UVB_ind] = 255
byte_scale[UVB_ind_clean] = 255

WINDOW, XSIZE = 1200, YSIZE = 600

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

;PRINT, SIZE(REFORM(byte_scale)) ;2D 400,1096

PLOT_IMAGE, REFORM(byte_scale), ORIGIN = [solar_x_clean[0], solar_y_clean[0]], SCALE = [resx_clean, resy_clean], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, COLOR = 1

;save as png

WINDOW, XSIZE = 1200, YSIZE = 600, RETAIN = 2

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale), ORIGIN = [solar_x_clean[0], solar_y_clean[0]], SCALE = [resx_clean, resy_clean], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.7, YCHARSIZE = 1.7

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4, COLOR = 1

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/1394_SGF/intensity_UVB.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 10, YSIZE = 8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/intensity_UVB.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale), ORIGIN = [solar_x_clean[0], solar_y_clean[0]], SCALE = [resx_clean, resy_clean], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XCHARSIZE = 1.6, YCHARSIZE = 1.6, CHARSIZE = 1.6

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast
OBJ_DESTROY, data1400
OBJ_DESTROY, data1330

END
