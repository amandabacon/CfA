;+
;Name: isolate_055943_1.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/22
;EDITED: 2018/08/02 --aspr, eps appearance

PRO isolate_055943_1

;restore variables

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/all_vars_055943_1.sav'
RESTORE, rfname

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_055943_1 = N_ELEMENTS(nspectraRast1394_055943_1[0,0,*]) ;400
yposition_055943_1 = N_ELEMENTS(nspectraRast1394_055943_1[0,*,0]) ;1096

cut_ind_ry_055943_1 = ARRAY_INDICES([raster_055943_1,yposition_055943_1], cut_ind_055943_1, /DIMENSIONS)
;PRINT, SIZE(cut_ind_ry_055943_1) ;2D 2465, where 2 is [raster,ypos]

cut_ind_r_055943_1 = REFORM(cut_ind_ry_055943_1[0,*]) ;1D 2465
cut_ind_y_055943_1 = REFORM(cut_ind_ry_055943_1[1,*]) ;1D 2465

;pull out all red rectangle UVB pop. indices

cut_size_055943_1 = N_ELEMENTS(cut_ind_055943_1) ;2465
cut_ind_r_s_055943_1 = N_ELEMENTS(cut_ind_r_055943_1) ;2465
cut_ind_y_s_055943_1 = N_ELEMENTS(cut_ind_y_055943_1) ;2465

is_absorb_055943_1 = LONARR(cut_size_055943_1)

TIC
FOR i = 0, cut_size_055943_1-1 DO BEGIN
	WINDOW, XSIZE = 900, YSIZE = 700
	PLOT, lambda1394_055943_1[19:141], REFORM(nspectraRast1394_055943_1[*,cut_ind_y_055943_1[i],cut_ind_r_055943_1[i]]), XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy]
	ch = ''
	READ, ch, PROMPT = 'UVB?: '
		IF ch EQ 'y' THEN BEGIN
		is_absorb_055943_1[i] = 1
		ind_absorb_055943_1 = WHERE(is_absorb_055943_1 EQ 1)
		UVB_ind_055943_1 = cut_ind_055943_1[ind_absorb_055943_1]
	ENDIF
ENDFOR
TOC ;1.35hr

;save new params

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/iso_vars_055943_1.sav'
SAVE, UVB_ind_055943_1, is_absorb_055943_1, ind_absorb_055943_1, FILENAME = sfname

sfname_safe = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/iso_vars_safe_055943_1.sav'
SAVE, /VARIABLES, FILENAME = sfname_safe

rfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/iso_vars_safe_055943_1.sav'
RESTORE, rfname2

rfname3 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/iso_vars_055943_1.sav'
RESTORE, rfname3

;===============================================================================

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_055943_1_UV = N_ELEMENTS(nspectraRast1394_055943_1[0,0,*]) ;400
yposition_055943_1_UV = N_ELEMENTS(nspectraRast1394_055943_1[0,*,0]) ;1096

UVB_ind_ry_055943_1_UV = ARRAY_INDICES([raster_055943_1_UV,yposition_055943_1_UV], UVB_ind_055943_1, /DIMENSIONS)
PRINT, SIZE(UVB_ind_ry_055943_1_UV)

UVB_ind_r_055943_1_UV = REFORM(UVB_ind_ry_055943_1_UV[0,*]) ;1D 360
UVB_ind_y_055943_1_UV = REFORM(UVB_ind_ry_055943_1_UV[1,*]) ;1D 360

;pull out all red rectangle UVB pop. indices

UVB_size_055943_1_UV = N_ELEMENTS(UVB_ind_055943_1) ;360
UVB_ind_r_s_055943_1_UV = N_ELEMENTS(UVB_ind_r_055943_1_UV) ;360
UVB_ind_y_s_055943_1_UV = N_ELEMENTS(UVB_ind_y_055943_1_UV) ;360

R = (1.75)^2 ;counts/pxl
g = 7.2 ;photons/count
dt = 2.0
inst_unc_Si_055943_1 = [ABS((REFORM(nspectraRast1394_055943_1[*,UVB_ind_y_055943_1_UV,UVB_ind_r_055943_1_UV]))/(g*dt))+R]^0.5

coeff_arr_055943_1_UV = DBLARR(4,UVB_size_055943_1_UV)
sigma_coeff_arr = DBLARR(4,UVB_size_055943_1_UV)

TIC
FOR i = 0, UVB_size_055943_1_UV-1 DO BEGIN
	PLOT, lambda1394_055943_1[19:141], REFORM(nspectraRast1394_055943_1[*,UVB_ind_y_055943_1_UV[i],UVB_ind_r_055943_1_UV[i]]), XRANGE = [1392.2,1395.3], TITLE = 'AR11850_055943_1_UV Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_055943_1_UV = MPFITPEAK(lambda1394_055943_1[19:141], REFORM(nspectraRast1394_055943_1[*,UVB_ind_y_055943_1_UV[i],UVB_ind_r_055943_1_UV[i]]), coeff_055943_1_UV, NTERMS = 4, PERROR = sigma_coeff, ERROR = inst_unc_Si_055943_1[*,i,i])
	OPLOT, lambda1394_055943_1[19:141], REFORM(YFIT_055943_1_UV), COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_055943_1_UV[*,i] = coeff_055943_1_UV
	sigma_coeff_arr[*,i] = sigma_coeff
ENDFOR
TOC ;Time elapsed: ~5 sec

PRINT, coeff_arr_055943_1_UV[1,*,*] ;1394.2367,1394.0543,1394.0172,1394.0756,1394.0850,1394.1126,1394.0772,1394.1845,1394.1776,1394.0657,1394.0325,1304.1550,1394.1015,1394.1309,1394.0715,1394.0855,1394.0273

p_int = coeff_arr_055943_1_UV[0,*,*]
sig_lw = sigma_coeff_arr[2,*,*]
lw = coeff_arr_055943_1_UV[2,*,*]
sig_p_int = sigma_coeff_arr[0,*,*]

It_Si_055943_1 = (sqrt(2.0*!dpi)*p_int*lw) ;total integrated intensity
PRINT, It_Si_055943_1

PRINT, 'integrated intensity uncertainty'

int_int_unc_Si_055943_1 = [2.0*!dpi*((p_int)^2*(sig_lw)^2+(lw)^2*(sig_p_int)^2)]^0.5
PRINT, int_int_unc_Si_055943_1

;save parameters from FOR loop

sfname_UV = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/IT_055943_1_UV.sav'
SAVE, coeff_055943_1_UV, inst_unc_Si_055943_1, sigma_coeff, sigma_coeff_arr, coeff_arr_055943_1_UV, It_Si_055943_1, int_int_unc_Si_055943_1, FILENAME = sfname_UV

;===============================================================================

;byte-scaling and saturation

sort_c_055943_1 = coeff_arr_055943_1[SORT(coeff_arr_055943_1)]
sort_c_055943_1 = sort_c_055943_1[WHERE(FINITE(sort_c_055943_1) OR (sort_c_055943_1 NE -200))]
n_sort_c_055943_1 = N_ELEMENTS(sort_c_055943_1)

;BYTSCL()

byte_scale_055943_1 = BYTSCL(coeff_arr_055943_1[0,*,*], MIN = 5, MAX = 75, TOP = 254)

PRINT, SIZE(byte_scale_055943_1[UVB_ind_055943_1]) ;1D 360

byte_scale_055943_1[UVB_ind_055943_1] = 255

WINDOW, XSIZE = 900, YSIZE = 700

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

;PRINT, SIZE(REFORM(byte_scale_055943_1)) ;2D 400,1096

PLOT_IMAGE, REFORM(byte_scale_055943_1), ORIGIN = [SolarX1400_055943_1[0], SolarY1400_055943_1[0]], SCALE = [ResX1400_055943_1, ResY1400_055943_1], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE

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

PLOT_IMAGE, REFORM(byte_scale_055943_1), ORIGIN = [Solarx1400_055943_1[0], SolarY1400_055943_1[0]], SCALE = [resx1400_055943_1, resy1400_055943_1], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4, COLOR = 1

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/intensity_UVB_055943_1.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/intensity_UVB_055943_1.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale_055943_1), ORIGIN = [solarx1400_055943_1[0], solary1400_055943_1[0]], SCALE = [resx1400_055943_1, resy1400_055943_1], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 10, YTHICK = 10, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_055943_1
OBJ_DESTROY, data1400_055943_1

END
