;+
;Name: isolate_clean.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/12
;NOTE: DOESN'T LIKE RESTORING AFTER FOR LOOP
;USING INDICES FROM CUT IN 4-D PARAMETER SPACE TO GET UVB POPULATION
;REGION, MANUALLY ITERATE THROUGH SPECTRA LOOKING FOR SIGNS OF NI II
;ABSORPTION TO USE FOR ANALYSIS PART OF PROJECT.
;I ITERATE THROUGH THE 'isolate.pro' UVB INDICES TO FINE-TUNE MY UVB
;SAMPLE TO ONLY INCLUDE SPECTRA WITH NI II ABSORPTION

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

;===============================================================================

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster_050945_UV = N_ELEMENTS(nspectraRast1394[0,0,*]) ;400
yposition_050945_UV = N_ELEMENTS(nspectraRast1394[0,*,0]) ;1096

UVB_ind_ry_050945_UV = ARRAY_INDICES([raster_050945_UV,yposition_050945_UV], UVB_ind_clean, /DIMENSIONS)
;PRINT, SIZE(UVB_ind_ry_050945_UV) ;2D 318, where 2 is [raster,ypos]

UVB_ind_r_050945_UV = REFORM(UVB_ind_ry_050945_UV[0,*]) ;1D 318
UVB_ind_y_050945_UV = REFORM(UVB_ind_ry_050945_UV[1,*]) ;1D 318

;pull out all red rectangle UVB pop. indices

UVB_size_050945_UV = N_ELEMENTS(UVB_ind_clean) ;318
UVB_ind_r_s_050945_UV = N_ELEMENTS(UVB_ind_r_050945_UV) ;318
UVB_ind_y_s_050945_UV = N_ELEMENTS(UVB_ind_y_050945_UV) ;318

;calculate instrumental uncertainties

R = (1.75)^2 ;counts/pxl
g = 7.2 ;photons/count
dt = 2.0
inst_unc_Si_050945 = [ABS((REFORM(nspectraRast1394[*,UVB_ind_y_050945_UV,UVB_ind_r_050945_UV]))/(g*dt))+R]^0.5

coeff_arr_050945_UV = DBLARR(4,UVB_size_050945_UV)
sigma_coeff_arr = DBLARR(4,UVB_size_050945_UV)

TIC
FOR i = 0, UVB_size_050945_UV-1 DO BEGIN
	PLOT, lambda1394[18:141], REFORM(nspectraRast1394[*,UVB_ind_y_050945_UV[i],UVB_ind_r_050945_UV[i]]), XRANGE = [1392.2,1395.3], TITLE = 'AR11850_050945_UV Gaussian Fit', XTITLE = 'Wavelength', YTITLE = 'Intensity'
	YFIT_050945_UV = MPFITPEAK(lambda1394[18:141], REFORM(nspectraRast1394[*,UVB_ind_y_050945_UV[i],UVB_ind_r_050945_UV[i]]), coeff_050945_UV, NTERMS = 4, PERROR = sigma_coeff, ERROR = inst_unc_Si_050945[*,i,i])
	OPLOT, lambda1394[18:141], REFORM(YFIT_050945_UV), COLOR = 170, LINESTYLE = 2, THICK = 5
	coeff_arr_050945_UV[*,i] = coeff_050945_UV
	sigma_coeff_arr[*,i] = sigma_coeff 
ENDFOR
TOC ;Time elapsed: ~2.5 sec

PRINT, coeff_arr_050945_UV[1,*,*]

p_int = coeff_arr_050945_UV[0,*,*]
sig_lw = sigma_coeff_arr[2,*,*]
lw = coeff_arr_050945_UV[2,*,*]
sig_p_int = sigma_coeff_arr[0,*,*]

;calculate total integrated intensity

It_Si_050945 = (sqrt(2.0*!dpi)*p_int*lw) ;total integrated intensity 
PRINT, It_Si_050945

PRINT, 'integrated intensity uncertainty'

;calculate integrated intensity uncertainty

int_int_unc_Si_050945 = [2.0*!dpi*((p_int)^2*(sig_lw)^2+(lw)^2*(sig_p_int)^2)]^0.5
PRINT, int_int_unc_Si_050945

;save parameters from FOR loop

sfname_UV = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/IT_UV_050945.sav'
SAVE, coeff_050945_UV, inst_unc_Si_050945, sigma_coeff, sigma_coeff_arr, coeff_arr_050945_UV, It_Si_050945, int_int_unc_Si_050945, FILENAME = sfname_UV

;===============================================================================

;byte-scaling and saturation

sort_c = coeff_arr_clean[SORT(coeff_arr_clean)]
sort_c = sort_c[WHERE(FINITE(sort_c) OR (sort_c NE -200))]
n_sort_c = N_ELEMENTS(sort_c)

;BYTSCL() TO SHOW UVB OVERPLOT IN RED

byte_scale = BYTSCL(coeff_arr_clean[0,*,*], MIN = 5, MAX = 75, TOP = 254)

;PRINT, SIZE(byte_scale[UVB_ind_clean]) ;1D 318

;byte_scale[cut_ind] = 255
;byte_scale[UVB_ind] = 255
byte_scale[UVB_ind_clean] = 255

WINDOW, XSIZE = 900, YSIZE = 700

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

WINDOW, XSIZE = 900, YSIZE = 700, RETAIN = 2

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale), ORIGIN = [solar_x_clean[0], solar_y_clean[0]], SCALE = [resx_clean, resy_clean], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 4, YTHICK = 4, XSTYLE = 1, THICK = 4, CHARSIZE = 1.8, XCHARSIZE = 1.45, YCHARSIZE = 1.45

TVLCT, [[255], [255], [255]], 1

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.32,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4, COLOR = 1

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/1394_SGF/intensity_UVB.png', screenshot

;save as ps

!P.FONT = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/intensity_UVB.eps', /ENCAPSULATED

EIS_COLORS, /INTENSITY

TVLCT, rv, gv, bv, /GET
rv[255] = 255
gv[255] = 0
bv[255] = 0

TVLCT, rv, gv, bv

PLOT_IMAGE, REFORM(byte_scale), ORIGIN = [solar_x_clean[0], solar_y_clean[0]], SCALE = [resx_clean, resy_clean], XTITLE = 'Solar X [arcsec]', YTITLE = 'Solar Y [arcsec]', POSITION = [x0,y0,x0+dx,y0+dy], /NORMAL, /NOSCALE, XTHICK = 10, YTHICK = 10, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5

COLORBAR, FORMAT = '(F0.2)', TITLE = "Intensity [Arbitrary Units]", RANGE = [5,75], /YLOG, YTICKS = 10, POSITION = [0.35,0.91,0.70,0.92], /TOP, CHARSIZE = 1.4

DEVICE, /CLOSE

OBJ_DESTROY, dataRast
OBJ_DESTROY, data1400
OBJ_DESTROY, data1330

END
