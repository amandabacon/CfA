;+
;Name: isolate_062443.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/20

PRO isolate_062443

;restore variables

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/all_vars_062443.sav'
RESTORE, rfname

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_062443 = N_ELEMENTS(nspectraRast1394_062443[0,0,*]) ;400
yposition_062443 = N_ELEMENTS(nspectraRast1394_062443[0,*,0]) ;1096

cut_ind_ry_062443 = ARRAY_INDICES([raster_062443,yposition_062443], cut_ind_062443, /DIMENSIONS)
;PRINT, SIZE(cut_ind_ry_062443) ;2D 2356, where 2 is [raster,ypos]

cut_ind_r_062443 = REFORM(cut_ind_ry_062443[0,*]) ;1D 2356
cut_ind_y_062443 = REFORM(cut_ind_ry_062443[1,*]) ;1D 2356

;pull out all red rectangle UVB pop. indices

cut_size_062443 = N_ELEMENTS(cut_ind_062443) ;2356
cut_ind_r_s_062443 = N_ELEMENTS(cut_ind_r_062443) ;2356
cut_ind_y_s_062443 = N_ELEMENTS(cut_ind_y_062443) ;2356

is_absorb_062443 = LONARR(cut_size_062443)

TIC
FOR i = 0, cut_size_062443-1 DO BEGIN
	WINDOW, XSIZE = 900, YSIZE = 700
	PLOT, lambda1394_062443[18:140], REFORM(nspectraRast1394_062443[*,cut_ind_y_062443[i],cut_ind_r_062443[i]]), XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy]
	ch = ''
	READ, ch, PROMPT = 'UVB?: '
		IF ch EQ 'y' THEN BEGIN
		is_absorb_062443[i] = 1
		ind_absorb_062443 = WHERE(is_absorb_062443 EQ 1)
		UVB_ind_062443 = cut_ind_062443[ind_absorb_062443]
	ENDIF
ENDFOR
TOC ;1.20hr

;save new params

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/iso_vars_062443.sav'
SAVE, UVB_ind_062443, is_absorb_062443, ind_absorb_062443, FILENAME = sfname

sfname_safe = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/iso_vars_safe_062443.sav'
SAVE, /VARIABLES, FILENAME = sfname_safe

rfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/iso_vars_safe_062443.sav'
RESTORE, rfname2

rfname3 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/iso_vars_062443.sav'
RESTORE, rfname3

;byte-scaling and saturation

sort_c_062443 = coeff_arr_062443[SORT(coeff_arr_062443)]
sort_c_062443 = sort_c_062443[WHERE(FINITE(sort_c_062443) OR (sort_c_062443 NE -200))]
n_sort_c_062443 = N_ELEMENTS(sort_c_062443)

;BYTSCL()

byte_scale_062443 = BYTSCL(coeff_arr_062443[0,*,*], MIN = 5, MAX = 75, TOP = 254)

;PRINT, SIZE(byte_scale_062443[UVB_ind_062443]) ;1D 284

byte_scale_062443[UVB_ind_062443] = 255

WINDOW, XSIZE = 900, YSIZE = 700

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

;PRINT, SIZE(REFORM(byte_scale_062443)) ;2D 400,1096

PLOT_IMAGE, REFORM(byte_scale_062443), ORIGIN = [SolarX1400_062443[0], SolarY1400_062443[0]], SCALE = [ResX1400_062443, ResY1400_062443], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE

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

PLOT_IMAGE, REFORM(byte_scale_062443), ORIGIN = [Solarx1400_062443[0], SolarY1400_062443[0]], SCALE = [resx1400_062443, resy1400_062443], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.7, YCHARSIZE = 1.7

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4, COLOR = 1

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/intensity_UVB_062443.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 8, YSIZE = 8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/intensity_UVB_062443.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale_062443), ORIGIN = [solarx1400_062443[0], solary1400_062443[0]], SCALE = [resx1400_062443, resy1400_062443], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 4, YTHICK = 4, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_062443
OBJ_DESTROY, data1400_062443

END
