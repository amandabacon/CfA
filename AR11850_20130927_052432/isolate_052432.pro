;+
;Name: isolate_052432.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/20
;EDITED: 2018/08/02 --aspr, eps appearance
;USING INDICES FROM CUT IN 4-D PARAMETER SPACE TO GET UVB POPULATION
;REGION, MANUALLY ITERATE THROUGH SPECTRA LOOKING FOR SIGNS OF NI II
;ABSORPTION TO USE FOR ANALYSIS PART OF PROJECT.

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

;===============================================================================

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_052432_UV = N_ELEMENTS(nspectraRast1394_052432[0,0,*]) ;400
yposition_052432_UV = N_ELEMENTS(nspectraRast1394_052432[0,*,0]) ;1096

UVB_ind_ry_052432_UV = ARRAY_INDICES([raster_052432_UV,yposition_052432_UV], UVB_ind_052432, /DIMENSIONS)
PRINT, SIZE(UVB_ind_ry_052432_UV)

UVB_ind_r_052432_UV = REFORM(UVB_ind_ry_052432_UV[0,*]) ;1D 378
UVB_ind_y_052432_UV = REFORM(UVB_ind_ry_052432_UV[1,*]) ;1D 378

;pull out all red rectangle UVB pop. indices

UVB_size_052432_UV = N_ELEMENTS(UVB_ind_052432) ;378
UVB_ind_r_s_052432_UV = N_ELEMENTS(UVB_ind_r_052432_UV) ;378
UVB_ind_y_s_052432_UV = N_ELEMENTS(UVB_ind_y_052432_UV) ;378

;calculate total integrated intensity (TII)

R = (1.75)^2 ;counts/pxl
g = 7.2 ;photons/count
dt = 2.0
inst_unc_Si_052432 = [ABS((REFORM(nspectraRast1394_052432[*,UVB_ind_y_052432_UV,UVB_ind_r_052432_UV]))/(g*dt))+R]^0.5

coeff_arr_052432_UV = DBLARR(4,UVB_size_052432_UV)
sigma_coeff_arr = DBLARR(4,UVB_size_052432_UV)

TIC
FOR i = 0, UVB_size_052432_UV-1 DO BEGIN
	PLOT, lambda1394_052432[19:173], REFORM(nspectraRast1394_052432[*,UVB_ind_y_052432_UV[i],UVB_ind_r_052432_UV[i]]), XRANGE = [1392.2,1395.3], TITLE = 'AR11850_052432_UV Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_052432_UV = MPFITPEAK(lambda1394_052432[19:173], REFORM(nspectraRast1394_052432[*,UVB_ind_y_052432_UV[i],UVB_ind_r_052432_UV[i]]), coeff_052432_UV, NTERMS = 4, PERROR = sigma_coeff, ERROR = inst_unc_Si_052432[*,i,i])
	TVLCT, [[0],[157],[0]], 10
	OPLOT, lambda1394_052432[19:173], REFORM(YFIT_052432_UV), COLOR = 10, LINESTYLE = 2, THICK = 5
	coeff_arr_052432_UV[*,i] = coeff_052432_UV
	sigma_coeff_arr[*,i] = sigma_coeff
ENDFOR
TOC ;Time elapsed: ~5 sec

PRINT, coeff_arr_052432_UV[1,*,*] ;1394.0354,0510,0406,0059,0148,0670,1194,0214

p_int = coeff_arr_052432_UV[0,*,*]
sig_lw = sigma_coeff_arr[2,*,*]
lw = coeff_arr_052432_UV[2,*,*]
sig_p_int = sigma_coeff_arr[0,*,*]

;calculate total integrated intensity

It_Si_052432 = (sqrt(2.0*!dpi)*p_int*lw) ;total integrated intensity
PRINT, It_Si_052432

PRINT, 'integrated intensity uncertainty'

;calculate integrated intensity uncertainty

int_int_unc_Si_052432 = [2.0*!dpi*((p_int)^2*(sig_lw)^2+(lw)^2*(sig_p_int)^2)]^0.5
PRINT, int_int_unc_Si_052432

;save parameters from FOR loop

sfname_UV = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/IT_052432_UV.sav'
SAVE, coeff_052432_UV, inst_unc_Si_052432, sigma_coeff, sigma_coeff_arr, coeff_arr_052432_UV, It_Si_052432, int_int_unc_Si_052432, FILENAME = sfname_UV

;===============================================================================

;byte-scaling and saturation

sort_c_052432 = coeff_arr_052432[SORT(coeff_arr_052432)]
sort_c_052432 = sort_c_052432[WHERE(FINITE(sort_c_052432) OR (sort_c_052432 NE -200))]
n_sort_c_052432 = N_ELEMENTS(sort_c_052432)

;BYTSCL() TO SHOW UVB OVERPLOT IN RED

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

PLOT_IMAGE, REFORM(byte_scale_052432), ORIGIN = [Solarx1400_052432[0], SolarY1400_052432[0]], SCALE = [resx1400_052432, resy1400_052432], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4, COLOR = 1

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/intensity_UVB_052432.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/intensity_UVB_052432.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale_052432), ORIGIN = [solarx1400_052432[0], solary1400_052432[0]], SCALE = [resx1400_052432, resy1400_052432], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 10, YTHICK = 10, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_052432
OBJ_DESTROY, data1400_052432

END
