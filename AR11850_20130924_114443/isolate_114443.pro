;+
;Name: isolate_114443.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/18

PRO isolate_114443

;restore variables

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/all_vars_114443.sav'
RESTORE, rfname

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_114443 = N_ELEMENTS(nspectraRast1394_114443[0,0,*]) ;400
yposition_114443 = N_ELEMENTS(nspectraRast1394_114443[0,*,0]) ;1096

cut_ind_ry_114443 = ARRAY_INDICES([raster_114443,yposition_114443], cut_ind_114443, /DIMENSIONS)
;PRINT, SIZE(cut_ind_ry_114443) ;2D 2,2425 where 2 is [raster,ypos]

cut_ind_r_114443 = REFORM(cut_ind_ry_114443[0,*]) ;1D 2425
cut_ind_y_114443 = REFORM(cut_ind_ry_114443[1,*]) ;1D 2425

;pull out all red rectangle UVB pop. indices

cut_size_114443 = N_ELEMENTS(cut_ind_114443) ;2425
cut_ind_r_s_114443 = N_ELEMENTS(cut_ind_r_114443) ;2425
cut_ind_y_s_114443 = N_ELEMENTS(cut_ind_y_114443) ;2425

is_absorb_114443 = LONARR(cut_size_114443)

TIC
FOR i = 0, cut_size_114443-1 DO BEGIN
	WINDOW, XSIZE = 900, YSIZE = 700
	PLOT, lambda1394_114443[18:141], REFORM(nspectraRast1394_114443[*,cut_ind_y_114443[i],cut_ind_r_114443[i]]), XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy]
	ch = ''
	READ, ch, PROMPT = 'UVB?: '
		IF ch EQ 'y' THEN BEGIN
		is_absorb_114443[i] = 1
		ind_absorb_114443 = WHERE(is_absorb_114443 EQ 1)
		UVB_ind_114443 = cut_ind_114443[ind_absorb_114443]
		ENDIF
ENDFOR
TOC ;2.24hrs

;save new params

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/iso_vars_114443.sav'
SAVE, UVB_ind_114443, is_absorb_114443, ind_absorb_114443, FILENAME = sfname

sfname_safe = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/iso_vars_safe_114443.sav'
SAVE, /VARIABLES, FILENAME = sfname_safe

rfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/iso_vars_safe_114443.sav'
RESTORE, rfname2

rfname3 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/iso_vars_114443.sav'
RESTORE, rfname3

;byte-scaling and saturation

sort_c_114443 = coeff_arr_114443[SORT(coeff_arr_114443)]
sort_c_114443 = sort_c_114443[WHERE(FINITE(sort_c_114443) OR (sort_c_114443 NE -200))]
n_sort_c_114443 = N_ELEMENTS(sort_c_114443)

;BYTSCL()

byte_scale_114443 = BYTSCL(coeff_arr_114443[0,*,*], MIN = 5, MAX = 75, TOP = 254)

;PRINT, SIZE(byte_scale_114443[UVB_ind_114443]) ;1D 657

byte_scale_114443[UVB_ind_114443] = 255

WINDOW, XSIZE = 900, YSIZE = 700

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

;PRINT, SIZE(REFORM(byte_scale_114443)) ;2D 400,1096

PLOT_IMAGE, REFORM(byte_scale_114443), ORIGIN = [SolarX1400_114443[0], SolarY1400_114443[0]], SCALE = [ResX1400_114443, ResY1400_114443], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE

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

PLOT_IMAGE, REFORM(byte_scale_114443), ORIGIN = [Solarx1400_114443[0], SolarY1400_114443[0]], SCALE = [resx1400_114443, resy1400_114443], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 3, YTHICK = 3, XCHARSIZE = 1.7, YCHARSIZE = 1.7

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4, COLOR = 1

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/intensity_UVB_114443.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 8, YSIZE = 8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/intensity_UVB_114443.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale_114443), ORIGIN = [solarx1400_114443[0], solary1400_114443[0]], SCALE = [resx1400_114443, resy1400_114443], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 4, YTHICK = 4, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_114443
OBJ_DESTROY, data1400_114443

END
