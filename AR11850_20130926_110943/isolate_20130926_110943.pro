;+
;Name: isolate_20130926_110943.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/20
;EDITED: 2018/08/02 --aspr, eps appearance
;USING INDICES FROM CUT IN 4-D PARAMETER SPACE TO GET UVB POPULATION
;REGION, MANUALLY ITERATE THROUGH SPECTRA LOOKING FOR SIGNS OF NI II
;ABSORPTION TO USE FOR ANALYSIS PART OF PROJECT.

PRO isolate_20130926_110943

;restore variables

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_110943/all_vars_20130926_110943.sav'
RESTORE, rfname

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_20130926_110943 = N_ELEMENTS(nspectraRast1394_20130926_110943[0,0,*]) ;400
yposition_20130926_110943 = N_ELEMENTS(nspectraRast1394_20130926_110943[0,*,0]) ;1096

cut_ind_ry_20130926_110943 = ARRAY_INDICES([raster_20130926_110943,yposition_20130926_110943], cut_ind_20130926_110943, /DIMENSIONS)
;PRINT, SIZE(cut_ind_ry_20130926_110943) ;2D 1489, where 2 is [raster,ypos]

cut_ind_r_20130926_110943 = REFORM(cut_ind_ry_20130926_110943[0,*]) ;1D 1489 
cut_ind_y_20130926_110943 = REFORM(cut_ind_ry_20130926_110943[1,*]) ;1D 1489

;pull out all red rectangle UVB pop. indices

cut_size_20130926_110943 = N_ELEMENTS(cut_ind_20130926_110943) ;1489
cut_ind_r_s_20130926_110943 = N_ELEMENTS(cut_ind_r_20130926_110943) ;1489
cut_ind_y_s_20130926_110943 = N_ELEMENTS(cut_ind_y_20130926_110943) ;1489

is_absorb_20130926_110943 = LONARR(cut_size_20130926_110943)

TIC
FOR i = 0, cut_size_20130926_110943-1 DO BEGIN
	WINDOW, XSIZE = 900, YSIZE = 700
	PLOT, lambda1394_20130926_110943[19:141], REFORM(nspectraRast1394_20130926_110943[*,cut_ind_y_20130926_110943[i],cut_ind_r_20130926_110943[i]]), XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy]
	ch = ''
	READ, ch, PROMPT = 'UVB?: '
		IF ch EQ 'y' THEN BEGIN
		is_absorb_20130926_110943[i] = 1
		ind_absorb_20130926_110943 = WHERE(is_absorb_20130926_110943 EQ 1)
		UVB_ind_20130926_110943 = cut_ind_20130926_110943[ind_absorb_20130926_110943]
	ENDIF
ENDFOR
TOC ;57min

;save new params

sfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_110943/iso_vars_20130926_110943.sav'
SAVE, UVB_ind_20130926_110943, is_absorb_20130926_110943, ind_absorb_20130926_110943, FILENAME = sfname

sfname_safe = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_110943/iso_vars_safe_20130926_110943.sav'
SAVE, /VARIABLES, FILENAME = sfname_safe

rfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_110943/iso_vars_safe_20130926_110943.sav'
RESTORE, rfname2

rfname3 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_110943/iso_vars_20130926_110943.sav'
RESTORE, rfname3

;===============================================================================

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_20130926_110943_UV = N_ELEMENTS(nspectraRast1394_20130926_110943[0,0,*]) ;400
yposition_20130926_110943_UV = N_ELEMENTS(nspectraRast1394_20130926_110943[0,*,0]) ;1096

UVB_ind_ry_20130926_110943_UV = ARRAY_INDICES([raster_20130926_110943_UV,yposition_20130926_110943_UV], UVB_ind_20130926_110943, /DIMENSIONS)
PRINT, SIZE(UVB_ind_ry_20130926_110943_UV)

UVB_ind_r_20130926_110943_UV = REFORM(UVB_ind_ry_20130926_110943_UV[0,*]) ;1D 125
UVB_ind_y_20130926_110943_UV = REFORM(UVB_ind_ry_20130926_110943_UV[1,*]) ;1D 125

;pull out all red rectangle UVB pop. indices

UVB_size_20130926_110943_UV = N_ELEMENTS(UVB_ind_20130926_110943) ;125
UVB_ind_r_s_20130926_110943_UV = N_ELEMENTS(UVB_ind_r_20130926_110943_UV) ;125
UVB_ind_y_s_20130926_110943_UV = N_ELEMENTS(UVB_ind_y_20130926_110943_UV) ;125

;calculate total integrated intensity (TII)

R = (1.75)^2 ;counts/pxl
g = 7.2 ;photons/count
dt = 2.0
inst_unc_Si_20130926_110943 = [ABS((REFORM(nspectraRast1394_20130926_110943[*,UVB_ind_y_20130926_110943_UV,UVB_ind_r_20130926_110943_UV]))/(g*dt))+R]^0.5

coeff_arr_20130926_110943_UV = DBLARR(4,UVB_size_20130926_110943_UV)
sigma_coeff_arr = DBLARR(4,UVB_size_20130926_110943_UV)

TIC
FOR i = 0, UVB_size_20130926_110943_UV-1 DO BEGIN
	PLOT, lambda1394_20130926_110943[19:141], REFORM(nspectraRast1394_20130926_110943[*,UVB_ind_y_20130926_110943_UV[i],UVB_ind_r_20130926_110943_UV[i]]), XRANGE = [1392.2,1395.3], TITLE = 'AR11850_20130926_110943_UV Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_20130926_110943_UV = MPFITPEAK(lambda1394_20130926_110943[19:141], REFORM(nspectraRast1394_20130926_110943[*,UVB_ind_y_20130926_110943_UV[i],UVB_ind_r_20130926_110943_UV[i]]), coeff_20130926_110943_UV, NTERMS = 4, PERROR = sigma_coeff, ERROR = inst_unc_Si_20130926_110943[*,i,i])
	OPLOT, lambda1394_20130926_110943[19:141], REFORM(YFIT_20130926_110943_UV), COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_20130926_110943_UV[*,i] = coeff_20130926_110943_UV
	sigma_coeff_arr[*,i] = sigma_coeff
ENDFOR
TOC ;Time elapsed: ~5 sec

PRINT, coeff_arr_20130926_110943_UV[1,*,*]

p_int = coeff_arr_20130926_110943_UV[0,*,*]
sig_lw = sigma_coeff_arr[2,*,*]
lw = coeff_arr_20130926_110943_UV[2,*,*]
sig_p_int = sigma_coeff_arr[0,*,*]

;calculate total integrated intensity

It_Si_20130926_110943 = (sqrt(2.0*!dpi)*p_int*lw) ;total integrated intensity
PRINT, It_Si_20130926_110943

PRINT, 'integrated intensity uncertainty'

;calculate integrated intensity uncertainty

int_int_unc_Si_20130926_110943 = [2.0*!dpi*((p_int)^2*(sig_lw)^2+(lw)^2*(sig_p_int)^2)]^0.5
PRINT, int_int_unc_Si_20130926_110943

;save parameters from FOR loop

sfname_UV = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_110943/IT_20130926_110943_UV.sav'
SAVE, coeff_20130926_110943_UV, inst_unc_Si_20130926_110943, sigma_coeff, sigma_coeff_arr, coeff_arr_20130926_110943_UV, It_Si_20130926_110943, int_int_unc_Si_20130926_110943, FILENAME = sfname_UV

;===============================================================================

;byte-scaling and saturation

sort_c_20130926_110943 = coeff_arr_20130926_110943[SORT(coeff_arr_20130926_110943)]
sort_c_20130926_110943 = sort_c_20130926_110943[WHERE(FINITE(sort_c_20130926_110943) OR (sort_c_20130926_110943 NE -200))]
n_sort_c_20130926_110943 = N_ELEMENTS(sort_c_20130926_110943)

;despike

coeff_arr_20130926_110943_clean = IRIS_PREP_DESPIKE(REFORM(coeff_arr_20130926_110943[0,*,*]), niter = 1000, min_std = 2.8, sigmas = 2.5, mode = 'both')

;BYTSCL() TO SHOW UVB OVERPLOT IN RED

byte_scale_20130926_110943 = BYTSCL(coeff_arr_20130926_110943_clean, MIN = 5, MAX = 75, TOP = 254)

;PRINT, SIZE(byte_scale_20130926_110943[UVB_ind_20130926_110943]) ;1D 125

byte_scale_20130926_110943[UVB_ind_20130926_110943] = 255

WINDOW, XSIZE = 900, YSIZE = 700

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

;PRINT, SIZE(REFORM(byte_scale_20130926_110943)) ;2D 400,1096

PLOT_IMAGE, REFORM(byte_scale_20130926_110943), ORIGIN = [SolarX1400_20130926_110943[0], SolarY1400_20130926_110943[0]], SCALE = [ResX1400_20130926_110943, ResY1400_20130926_110943], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE

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

PLOT_IMAGE, REFORM(byte_scale_20130926_110943), ORIGIN = [Solarx1400_20130926_110943[0], SolarY1400_20130926_110943[0]], SCALE = [resx1400_20130926_110943, resy1400_20130926_110943], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4, COLOR = 1

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_110943/intensity_UVB_20130926_110943.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_110943/intensity_UVB_20130926_110943.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale_20130926_110943), ORIGIN = [solarx1400_20130926_110943[0], solary1400_20130926_110943[0]], SCALE = [resx1400_20130926_110943, resy1400_20130926_110943], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 10, YTHICK = 10, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_20130926_110943
OBJ_DESTROY, data1400_20130926_110943

END
