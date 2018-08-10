;+
;Name: isolate_114443.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/18
;EDITED: 2018/08/02 --aspr, eps appearance
;USING INDICES FROM CUT IN 4-D PARAMETER SPACE TO GET UVB POPULATION
;REGION, MANUALLY ITERATE THROUGH SPECTRA LOOKING FOR SIGNS OF NI II
;ABSORPTION TO USE FOR ANALYSIS PART OF PROJECT.

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

;===============================================================================

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_114443_UV = N_ELEMENTS(nspectraRast1394_114443[0,0,*]) ;400
yposition_114443_UV = N_ELEMENTS(nspectraRast1394_114443[0,*,0]) ;1096

UVB_ind_ry_114443_UV = ARRAY_INDICES([raster_114443_UV,yposition_114443_UV], UVB_ind_114443, /DIMENSIONS)
;PRINT, SIZE(UVB_ind_ry_114443_Oiv) ;2D 2,657 where 2 is [raster,ypos]

UVB_ind_r_114443_UV = REFORM(UVB_ind_ry_114443_UV[0,*]) ;1D 657
UVB_ind_y_114443_UV = REFORM(UVB_ind_ry_114443_UV[1,*]) ;1D 657

;pull out all red rectangle UVB pop. indices

UVB_size_114443_UV = N_ELEMENTS(UVB_ind_114443) ;657
UVB_ind_r_s_114443_UV = N_ELEMENTS(UVB_ind_r_114443_UV) ;657
UVB_ind_y_s_114443_UV = N_ELEMENTS(UVB_ind_y_114443_UV) ;657

;calculate total integrated intensity

R = (1.75)^2 ;counts/pxl
g = 7.2 ;photons/count
dt = 2.0
inst_unc_Si_114443 = [ABS((REFORM(nspectraRast1394_114443[*,UVB_ind_y_114443_UV,UVB_ind_r_114443_UV]))/(g*dt))+R]^0.5

coeff_arr_114443_UV = DBLARR(4,UVB_size_114443_UV)
sigma_coeff_arr = DBLARR(4,UVB_size_114443_UV)

TIC
FOR i = 0, UVB_size_114443_UV-1 DO BEGIN
	PLOT, lambda1394_114443[18:141], REFORM(nspectraRast1394_114443[*,UVB_ind_y_114443_UV[i],UVB_ind_r_114443_UV[i]]), XRANGE = [1392.2,1395.3], TITLE = 'AR11850_114443_UV Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_114443_UV = MPFITPEAK(lambda1394_114443[18:141], REFORM(nspectraRast1394_114443[*,UVB_ind_y_114443_UV[i],UVB_ind_r_114443_UV[i]]), coeff_114443_UV, NTERMS = 4, PERROR = sigma_coeff, ERROR = inst_unc_Si_114443[*,i,i])
	OPLOT, lambda1394_114443[18:141], REFORM(YFIT_114443_UV), COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_114443_UV[*,i] = coeff_114443_UV
	sigma_coeff_arr[*,i] = sigma_coeff 
ENDFOR
TOC ;Time elapsed: ~2.5 sec

p_int = coeff_arr_114443_UV[0,*,*]
sig_lw = sigma_coeff_arr[2,*,*]
lw = coeff_arr_114443_UV[2,*,*]
sig_p_int = sigma_coeff_arr[0,*,*]

;calculate total integrated intensity

It_Si_114443 = (sqrt(2.0*!dpi)*p_int*lw) ;total integrated intensity 
PRINT, It_Si_114443

PRINT, 'integrated intensity uncertainty'

;calculate integrated intensity uncertainty

int_int_unc_Si_114443 = [2.0*!dpi*((p_int)^2*(sig_lw)^2+(lw)^2*(sig_p_int)^2)]^0.5
PRINT, int_int_unc_Si_114443

;save parameters from FOR loop

sfname_UV = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/IT_UV_114443.sav'
SAVE, coeff_114443_UV, inst_unc_Si_114443, sigma_coeff, sigma_coeff_arr, coeff_arr_114443_UV, It_Si_114443, int_int_unc_Si_114443, FILENAME = sfname_UV

;===============================================================================

;for pres

;raster_pres = N_ELEMENTS(nspectraRast1394_114443[0,0,*])
;yposition_pres = N_ELEMENTS(nspectraRast1394_114443[0,*,0])

;pres = ARRAY_INDICES([raster_pres,yposition_pres], UVB_ind_114443, /DIMENSIONS)

;pres_r = REFORM(pres[0,*])
;pres_y = REFORM(pres[1,*])

;420, 424, 429, 430, 431
;prof = REFORM(nspectraRast1394_114443[*,pres_y[431],pres_r[431]])

;WINDOW, XSIZE = 900, YSIZE = 700
;PLOT, lambda1394_114443[18:141], prof, TITLE = 'AR11850_114443 Emission Line Profile', XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395], POSITION = [x0,y0,x0+dx,y0+dy], XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45

;XYOUTS, 1392.5, 360, 'Fe II', CHARSIZE = 1.8
;XYOUTS, 1393.05, 360, 'Ni II', CHARSIZE = 1.8
;XYOUTS, 1393.50, 360, 'Si IV', CHARSIZE = 1.8

;ANNOTATE, LOAD_FILE = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/annotate_114443.dat'

;TVLCT, [[255], [0], [0]], 255
;OPLOT, lambda1394_114443[18:141], avg_fit_114443, COLOR = 255, THICK = 4

;save as png

;TVLCT, [[255], [255], [255]], 2
;WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2
;PLOT, lambda1394_114443[18:141], prof, TITLE = 'AR11850_114443 Emission Line Profile', XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395], POSITION = [x0,y0,x0+dx,y0+dy], XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45, COLOR = 2

;XYOUTS, 1392.5, 360, 'Fe II', CHARSIZE = 1.8, COLOR = 2
;XYOUTS, 1393.05, 360, 'Ni II', CHARSIZE = 1.8, COLOR = 2
;XYOUTS, 1393.50, 360, 'Si IV', CHARSIZE = 1.8, COLOR = 2

;ANNOTATE, LOAD_FILE = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/annotate_114443.dat'

;TVLCT, [[255], [0], [0]], 255
;OPLOT, lambda1394_114443[18:141], avg_fit_114443, COLOR = 255, THICK = 4

;screenshot = TVRD(TRUE = 1)
;WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/funky_114443.png', screenshot

;save as ps

;!P.FONT = 1 ;true font option

;TVLCT, [[0], [0], [0]], 1
;!P.BACKGROUND = 1

;SET_PLOT, 'ps'
;DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/funky_114443.eps', /ENCAPSULATED

;TVLCT, [[255], [255], [255]], 2
;PLOT, lambda1394_114443[18:141], prof, TITLE = 'AR11850_114443 Si IV 1393.8 '+STRING("305B)+' Emission Line Profile', XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395], POSITION = [x0,y0,x0+dx,y0+dy], XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.35, YCHARSIZE = 1.4, COLOR = 2, XTHICK = 10, YTHICK = 10

;XYOUTS, 1392.5, 360, 'Fe II', CHARSIZE = 1.8, COLOR = 2
;XYOUTS, 1393.05, 360, 'Ni II', CHARSIZE = 1.8, COLOR = 2
;XYOUTS, 1393.50, 360, 'Si IV', CHARSIZE = 1.8, COLOR = 2

;TVLCT, [[255], [0], [0]], 255
;OPLOT, lambda1394_114443[18:141], avg_fit_114443, COLOR = 255, THICK = 4

;DEVICE, /CLOSE

;===============================================================================

;byte-scaling and saturation

sort_c_114443 = coeff_arr_114443[SORT(coeff_arr_114443)]
sort_c_114443 = sort_c_114443[WHERE(FINITE(sort_c_114443) OR (sort_c_114443 NE -200))]
n_sort_c_114443 = N_ELEMENTS(sort_c_114443)

;BYTSCL() TO SHOW UVB OVERPLOT IN RED

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

PLOT_IMAGE, REFORM(byte_scale_114443), ORIGIN = [Solarx1400_114443[0], SolarY1400_114443[0]], SCALE = [resx1400_114443, resy1400_114443], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4, COLOR = 1

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/intensity_UVB_114443.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/intensity_UVB_114443.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale_114443), ORIGIN = [solarx1400_114443[0], solary1400_114443[0]], SCALE = [resx1400_114443, resy1400_114443], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 10, YTHICK = 10, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast_114443
OBJ_DESTROY, data1400_114443

END
