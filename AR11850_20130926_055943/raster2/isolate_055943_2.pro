;+
;Name: isolate_055943_2.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/22

PRO isolate_055943_2

;restore variables

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/all_vars_055943_2.sav'
RESTORE, rfname

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_055943_2 = N_ELEMENTS(nspectraRast1394_055943_2[0,0,*]) ;400
yposition_055943_2 = N_ELEMENTS(nspectraRast1394_055943_2[0,*,0]) ;1096

cut_ind_ry_055943_2 = ARRAY_INDICES([raster_055943_2,yposition_055943_2], cut_ind_055943_2, /DIMENSIONS)
;PRINT, SIZE(cut_ind_ry_055943_2) ;2D 2375, where 2 is [raster,ypos]

cut_ind_r_055943_2 = REFORM(cut_ind_ry_055943_2[0,*]) ;1D 2375
cut_ind_y_055943_2 = REFORM(cut_ind_ry_055943_2[1,*]) ;1D 2375

;pull out all red rectangle UVB pop. indices

cut_size_055943_2 = N_ELEMENTS(cut_ind_055943_2) ;2375
cut_ind_r_s_055943_2 = N_ELEMENTS(cut_ind_r_055943_2) ;2375
cut_ind_y_s_055943_2 = N_ELEMENTS(cut_ind_y_055943_2) ;2375

is_absorb_055943_2 = LONARR(cut_size_055943_2)

TIC
FOR i = 0, cut_size_055943_2-1 DO BEGIN
	WINDOW, XSIZE = 900, YSIZE = 700
	PLOT, lambda1394_055943_2[19:141], REFORM(nspectraRast1394_055943_2[*,cut_ind_y_055943_2[i],cut_ind_r_055943_2[i]]), XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy]
	ch = ''
	READ, ch, PROMPT = 'UVB?: '
		IF ch EQ 'y' THEN BEGIN
		is_absorb_055943_2[i] = 1
		ind_absorb_055943_2 = WHERE(is_absorb_055943_2 EQ 1)
		UVB_ind_055943_2 = cut_ind_055943_2[ind_absorb_055943_2]
	ENDIF
ENDFOR
TOC ;45 mins

;save new params

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/iso_vars_055943_2.sav'
SAVE, UVB_ind_055943_2, is_absorb_055943_2, ind_absorb_055943_2, FILENAME = sfname

sfname_safe = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/iso_vars_safe_055943_2.sav'
SAVE, /VARIABLES, FILENAME = sfname_safe

rfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/iso_vars_safe_055943_2.sav'
RESTORE, rfname2

rfname3 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/iso_vars_055943_2.sav'
RESTORE, rfname3

;byte-scaling and saturation

sort_c_055943_2 = coeff_arr_055943_2[SORT(coeff_arr_055943_2)]
sort_c_055943_2 = sort_c_055943_2[WHERE(FINITE(sort_c_055943_2) OR (sort_c_055943_2 NE -200))]
n_sort_c_055943_2 = N_ELEMENTS(sort_c_055943_2)

;BYTSCL()

byte_scale_055943_2 = BYTSCL(coeff_arr_055943_2[0,*,*], MIN = 5, MAX = 75, TOP = 254)

;PRINT, SIZE(byte_scale_055943_2[UVB_ind_055943_2]) ;1D 200

byte_scale_055943_2[UVB_ind_055943_2] = 255

WINDOW, XSIZE = 900, YSIZE = 700

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

;PRINT, SIZE(REFORM(byte_scale_055943_2)) ;2D 400,1096

PLOT_IMAGE, REFORM(byte_scale_055943_2), ORIGIN = [SolarX1400_055943_2[0], SolarY1400_055943_2[0]], SCALE = [ResX1400_055943_2, ResY1400_055943_2], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE

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

PLOT_IMAGE, REFORM(byte_scale_055943_2), ORIGIN = [Solarx1400_055943_2[0], SolarY1400_055943_2[0]], SCALE = [resx1400_055943_2, resy1400_055943_2], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.7, YCHARSIZE = 1.7

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4, COLOR = 1

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/intensity_UVB_055943_2.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 8, YSIZE = 8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/intensity_UVB_055943_2.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale_055943_2), ORIGIN = [solarx1400_055943_2[0], solary1400_055943_2[0]], SCALE = [resx1400_055943_2, resy1400_055943_2], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 4, YTHICK = 4, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_055943_2
OBJ_DESTROY, data1400_055943_2

END
