;+
;Name: isolate_062443.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/20
;EDITED: 2018/08/02 --aspr, eps appearance
;USING INDICES FROM CUT IN 4-D PARAMETER SPACE TO GET UVB POPULATION
;REGION, MANUALLY ITERATE THROUGH SPECTRA LOOKING FOR SIGNS OF NI II
;ABSORPTION TO USE FOR ANALYSIS PART OF PROJECT.

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

;===============================================================================

;FINAL PRESENTATION

;prof = REFORM(nspectraRast1394_062443[*,cut_ind_y_062443[352],cut_ind_r_062443[352]])

;WINDOW, XSIZE = 900, YSIZE = 700
;PLOT, lambda1394_062443[18:140], prof, XTITLE = 'Wavelength ['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XTHICK = 4, YTHICK = 4, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, XSTYLE = 1, THICK = 4, XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy]

;save as ps

;!P.FONT = 1

;TVLCT, [[255],[255],[255]], 1
;SET_PLOT, 'ps'
;DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/no_Ni_II.eps', /ENCAPSULATED

;PLOT, lambda1394_062443[18:140], prof, XTITLE = 'Wavelength ['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, XSTYLE = 1, THICK = 4, XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 1, XTHICK = 10, YTHICK = 10

;DEVICE, /CLOSE

;===============================================================================

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

;===============================================================================

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_062443_UV = N_ELEMENTS(nspectraRast1394_062443[0,0,*]) ;400
yposition_062443_UV = N_ELEMENTS(nspectraRast1394_062443[0,*,0]) ;1096

UVB_ind_ry_062443_UV = ARRAY_INDICES([raster_062443_UV,yposition_062443_UV], UVB_ind_062443, /DIMENSIONS)
PRINT, SIZE(UVB_ind_ry_062443_UV)

UVB_ind_r_062443_UV = REFORM(UVB_ind_ry_062443_UV[0,*]) ;1D 284
UVB_ind_y_062443_UV = REFORM(UVB_ind_ry_062443_UV[1,*]) ;1D 284

;pull out all red rectangle UVB pop. indices

UVB_size_062443_UV = N_ELEMENTS(UVB_ind_062443) ;284
UVB_ind_r_s_062443_UV = N_ELEMENTS(UVB_ind_r_062443_UV) ;284
UVB_ind_y_s_062443_UV = N_ELEMENTS(UVB_ind_y_062443_UV) ;284

;calculate instrumental uncertainties to use in another SGF FOR loop

R = (1.75)^2 ;counts/pxl
g = 7.2 ;photons/count
dt = 2.0
inst_unc_Si_062443 = [ABS((REFORM(nspectraRast1394_062443[*,UVB_ind_y_062443_UV,UVB_ind_r_062443_UV]))/(g*dt))+R]^0.5

coeff_arr_062443_UV = DBLARR(4,UVB_size_062443_UV)
sigma_coeff_arr = DBLARR(4,UVB_size_062443_UV)

TIC
FOR i = 0, UVB_size_062443_UV-1 DO BEGIN
	PLOT, lambda1394_062443[18:140], REFORM(nspectraRast1394_062443[*,UVB_ind_y_062443_UV[i],UVB_ind_r_062443_UV[i]]), XRANGE = [1392.2,1395.3], TITLE = 'AR11850_062443_UV Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_062443_UV = MPFITPEAK(lambda1394_062443[18:140], REFORM(nspectraRast1394_062443[*,UVB_ind_y_062443_UV[i],UVB_ind_r_062443_UV[i]]), coeff_062443_UV, NTERMS = 4, PERROR = sigma_coeff, ERROR = inst_unc_Si_062443[*,i,i])
	OPLOT, lambda1394_062443[18:140], REFORM(YFIT_062443_UV), COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_062443_UV[*,i] = coeff_062443_UV
	sigma_coeff_arr[*,i] = sigma_coeff
ENDFOR
TOC ;Time elapsed: ~5 sec

PRINT, coeff_arr_062443_UV[1,*,*]

p_int = coeff_arr_062443_UV[0,*,*]
sig_lw = sigma_coeff_arr[2,*,*]
lw = coeff_arr_062443_UV[2,*,*]
sig_p_int = sigma_coeff_arr[0,*,*]

;calculate total integrated intensity (TII)

It_Si_062443 = (sqrt(2.0*!dpi)*p_int*lw) ;total integrated intensity
PRINT, It_Si_062443

PRINT, 'integrated intensity uncertainty'

;calculate integrated intensity uncertainty

int_int_unc_Si_062443 = [2.0*!dpi*((p_int)^2*(sig_lw)^2+(lw)^2*(sig_p_int)^2)]^0.5
PRINT, int_int_unc_Si_062443

;save parameters from FOR loop

sfname_UV = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/IT_062443_UV.sav'
SAVE, coeff_062443_UV, inst_unc_Si_062443, sigma_coeff, sigma_coeff_arr, coeff_arr_062443_UV, It_Si_062443, int_int_unc_Si_062443, FILENAME = sfname_UV

;===============================================================================

;FOR FINAL PRESENTATION

;raster_f = N_ELEMENTS(nspectraRast1394_062443[0,0,*]) ;400
;yposition_f = N_ELEMENTS(nspectraRast1394_062443[0,*,0]) ;1096

;cut_ind_ry_f = ARRAY_INDICES([raster_f,yposition_f], UVB_ind_062443, /DIMENSIONS)

;cut_ind_r_f = REFORM(cut_ind_ry_f[0,*])
;cut_ind_y_f = REFORM(cut_ind_ry_f[1,*])

;cut_size_f = N_ELEMENTS(UVB_ind_062443)
;cut_ind_r_s_f = N_ELEMENTS(cut_ind_r_f)
;cut_ind_y_s_f = N_ELEMENTS(cut_ind_y_f)

;prof_f = REFORM(nspectraRast1394_062443[*,cut_ind_y_f[130],cut_ind_r_f[130]])

;WINDOW, XSIZE = 900, YSIZE = 700
;PLOT, lambda1394_062443[18:140], prof_f, XTITLE = 'Wavelength ['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XTHICK = 4, YTHICK = 4, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, XSTYLE = 1, THICK = 4, XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy]

;save as ps

;!P.FONT = 1

;TVLCT, [[255],[255],[255]], 1
;SET_PLOT, 'ps'
;DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/Ni_II.eps', /ENCAPSULATED

;PLOT, lambda1394_062443[18:140], prof_f, XTITLE = 'Wavelength ['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, XSTYLE = 1, THICK = 4, XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 1, XTHICK = 10, YTHICK = 10

;DEVICE, /CLOSE

;===============================================================================

;byte-scaling and saturation

sort_c_062443 = coeff_arr_062443[SORT(coeff_arr_062443)]
sort_c_062443 = sort_c_062443[WHERE(FINITE(sort_c_062443) OR (sort_c_062443 NE -200))]
n_sort_c_062443 = N_ELEMENTS(sort_c_062443)

;despike

coeff_arr_062443_clean = IRIS_PREP_DESPIKE(REFORM(coeff_arr_062443[0,*,*]), sigmas = 2.5, niter = 1000, min_std = 2.8, mode = 'both')

;BYTSCL() TO SHOW UVB OVERPLOT IN RED

byte_scale_062443 = BYTSCL(coeff_arr_062443_clean, MIN = 5, MAX = 75, TOP = 254)

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
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/intensity_UVB_062443.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale_062443), ORIGIN = [solarx1400_062443[0], solary1400_062443[0]], SCALE = [resx1400_062443, resy1400_062443], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 10, YTHICK = 10, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5
COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_062443
OBJ_DESTROY, data1400_062443

END
