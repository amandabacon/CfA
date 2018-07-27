;+
;Name: isolate_052432.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/20

PRO isolate_052432

;restore variables

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/all_vars_052432.sav'
RESTORE, rfname

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_052432 = N_ELEMENTS(nspectraRast1394_052432[0,0,*]) ;400
yposition_052432 = N_ELEMENTS(nspectraRast1394_052432[0,*,0]) ;1093

cut_ind_ry_052432 = ARRAY_INDICES([raster_052432,yposition_052432], cut_ind_052432, /DIMENSIONS)
;PRINT, SIZE(cut_ind_ry_052432) ;2D 2595, where 2 is [raster,ypos]

cut_ind_r_052432 = REFORM(cut_ind_ry_052432[0,*]) ;1D 2595
cut_ind_y_052432 = REFORM(cut_ind_ry_052432[1,*]) ;1D 2595

;pull out all red rectangle UVB pop. indices

cut_size_052432 = N_ELEMENTS(cut_ind_052432) ;2595
cut_ind_r_s_052432 = N_ELEMENTS(cut_ind_r_052432) ;2595
cut_ind_y_s_052432 = N_ELEMENTS(cut_ind_y_052432) ;2595

is_absorb_052432 = LONARR(cut_size_052432)

TIC
FOR i = 0, cut_size_052432-1 DO BEGIN
	WINDOW, XSIZE = 900, YSIZE = 700
	PLOT, lambda1394_052432[19:173], REFORM(nspectraRast1394_052432[*,cut_ind_y_052432[i],cut_ind_r_052432[i]]), XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy]
	ch = ''
	READ, ch, PROMPT = 'UVB?: '
		IF ch EQ 'y' THEN BEGIN
		is_absorb_052432[i] = 1
		ind_absorb_052432 = WHERE(is_absorb_052432 EQ 1)
		UVB_ind_052432 = cut_ind_052432[ind_absorb_052432]
	ENDIF
ENDFOR
TOC ;1.73hrs

;save new params

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/iso_vars_052432.sav'
SAVE, UVB_ind_052432, is_absorb_052432, ind_absorb_052432, FILENAME = sfname

sfname_safe = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/iso_vars_safe_052432.sav'
SAVE, /VARIABLES, FILENAME = sfname_safe

rfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/iso_vars_safe_052432.sav'
RESTORE, rfname2

rfname3 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/iso_vars_052432.sav'
RESTORE, rfname3

;byte-scaling and saturation

sort_c_052432 = coeff_arr_052432[SORT(coeff_arr_052432)]
sort_c_052432 = sort_c_052432[WHERE(FINITE(sort_c_052432) OR (sort_c_052432 NE -200))]
n_sort_c_052432 = N_ELEMENTS(sort_c_052432)

;BYTSCL()

byte_scale_052432 = BYTSCL(coeff_arr_052432[0,*,*], MIN = 5, MAX = 75, TOP = 254)

;PRINT, SIZE(byte_scale_052432[UVB_ind_052432]) ;1D 378

byte_scale_052432[UVB_ind_052432] = 255

WINDOW, XSIZE = 900, YSIZE = 700

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

;PRINT, SIZE(REFORM(byte_scale_052432)) ;2D 400,1093

PLOT_IMAGE, REFORM(byte_scale_052432), ORIGIN = [SolarX1400_052432[0], SolarY1400_052432[0]], SCALE = [ResX1400_052432, ResY1400_052432], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, COLOR = 1

;save as png

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale_052432), ORIGIN = [Solarx1400_052432[0], SolarY1400_052432[0]], SCALE = [resx1400_052432, resy1400_052432], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.7, YCHARSIZE = 1.7

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4, COLOR = 1

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/intensity_UVB_052432.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 8, YSIZE = 8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/intensity_UVB_052432.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale_052432), ORIGIN = [solarx1400_052432[0], solary1400_052432[0]], SCALE = [resx1400_052432, resy1400_052432], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 4, YTHICK = 4, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_052432
OBJ_DESTROY, data1400_052432

END
