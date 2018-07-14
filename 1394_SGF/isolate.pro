;+
;Name: isolate.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/05

PRO isolate

;restore variables

rfname = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/all_vars.sav'
RESTORE, rfname;, /VERBOSE

;ARRAY_INDICES to convert 1D index to 2D (ypos and raster)

raster = N_ELEMENTS(nspectraRast1394[0,0,*]) ;400
yposition = N_ELEMENTS(nspectraRast1394[0,*,0]) ;1096

cut_ind_ry = ARRAY_INDICES([raster,yposition], cut_ind, /DIMENSIONS)
;PRINT, SIZE(cut_ind_ry) ;2D 2,2514 where 2 is [raster,ypos]

cut_ind_r = REFORM(cut_ind_ry[0,*]) ;1D 2514
cut_ind_y = REFORM(cut_ind_ry[1,*]) ;1D 2514

;profile = REFORM(nspectraRast1394[*,cut_ind_y[750],cut_ind_r[750]])
;PRINT, profile
;PRINT, SIZE(profile) ;1D 124 (wavelength)

;pull out all red rectangle UVB pop. indices

cut_size = N_ELEMENTS(cut_ind) ;2514
cut_ind_r_s = N_ELEMENTS(cut_ind_r) ;2514
cut_ind_y_s = N_ELEMENTS(cut_ind_y) ;2514

is_absorb = LONARR(cut_size)

TIC
FOR i = 0, cut_size-1 DO BEGIN
	WINDOW, XSIZE = 900, YSIZE = 500
	PLOT, lambda1394[18:141], REFORM(nspectraRast1394[*,cut_ind_y[i],cut_ind_r[i]]), XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy]
	ch = ''
	READ, ch, PROMPT = 'UVB?: '
		IF ch EQ 'y' THEN BEGIN
		is_absorb[i] = 1
		ind_absorb = WHERE(is_absorb EQ 1)
		UVB_ind = cut_ind[ind_absorb]
		ENDIF
ENDFOR
TOC

;for mini_pres--extreme constraints

cut_ind = WHERE((coeff_arr_peak GE 40) AND (coeff_arr_peak LE 350) AND (vel_width GE 73) AND (vel_width LE 200) AND (ABS(velocity LE (gamma/wave0) * 3e5)), COMPLEMENT = not_cut_ind, count)

raster_mini = N_ELEMENTS(nspectraRast1394[0,0,*])
yposition_mini = N_ELEMENTS(nspectraRast1394[0,*,0])

this_cut = ARRAY_INDICES([raster_mini,yposition_mini], cut_ind, /DIMENSIONS)

this_cut_r = REFORM(this_cut[0,*])
this_cut_y = REFORM(this_cut[1,*])

;412,413*,414,415, 420?, 423

prof = REFORM(nspectraRast1394[*,this_cut_y[414],this_cut_r[414]])

WINDOW, XSIZE = 900, YSIZE = 500
PLOT, lambda1394[18:141], prof, XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy], XCHARSIZE = 1.8, YCHARSIZE = 1.8, XTHICK = 3, YTHICK = 3, XSTYLE = 1, THICK = 2

XYOUTS, 1392.9, 233, 'Fe II', CHARSIZE = 1.4
XYOUTS, 1393.4, 233, 'Ni II', CHARSIZE = 1.4
XYOUTS, 1393.76, 233, 'Si IV', CHARSIZE = 1.4

ANNOTATE, LOAD_FILE = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/annotate.dat'

TVLCT, [[255], [0], [0]], 255
OPLOT, lambda1394[18:141], n_avg_prof, COLOR = 255, THICK = 2

;save as png

TVLCT, [[255], [255], [255]], 2
WINDOW, XSIZE = 900, YSIZE = 500, RETAIN = 2
PLOT, lambda1394[18:141], prof, XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy], XCHARSIZE = 1.8, YCHARSIZE = 1.8, XTHICK = 3, YTHICK = 3, XSTYLE = 1, THICK = 2, COLOR = 2

XYOUTS, 1392.9, 233, 'Fe II', CHARSIZE = 1.4, COLOR = 2
XYOUTS, 1393.4, 233, 'Ni II', CHARSIZE = 1.4, COLOR = 2
XYOUTS, 1393.76, 233, 'Si IV', CHARSIZE = 1.4, COLOR = 2

ANNOTATE, LOAD_FILE = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/annotate_png.dat'

TVLCT, [[255], [0], [0]], 255
OPLOT, lambda1394[18:141], n_avg_prof, COLOR = 255, THICK = 2

screenshot = TVRD(TRUE = 1)
WRITE_PNG, '/data/khnum/REU2018/abacon/data/detection/1394_SGF/funky.png', screenshot

;save as ps

!P.FONT = 1 ;true font option

TVLCT, [[0], [0], [0]], 1
!P.BACKGROUND = 1

SET_PLOT, 'ps'
DEVICE, XSIZE = 9, YSIZE = 6, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/funky.eps', /ENCAPSULATED

TVLCT, [[255], [255], [255]], 2
PLOT, lambda1394[18:141], prof, XTITLE = 'Wavelength['+STRING("305B)+']', YTITLE = 'Instensity [Arb. Units]', XRANGE = [1392.2,1395.3], POSITION = [x0,y0,x0+dx,y0+dy], XCHARSIZE = 1.9, YCHARSIZE = 1.9, XSTYLE = 1, THICK = 4, COLOR = 2

XYOUTS, 1392.9, 233, 'Fe II', CHARSIZE = 1.5, COLOR = 2
XYOUTS, 1393.4, 233, 'Ni II', CHARSIZE = 1.5, COLOR = 2
XYOUTS, 1393.76, 233, 'Si IV', CHARSIZE = 1.5, COLOR = 2

TVLCT, [[255], [0], [0]], 255
OPLOT, lambda1394[18:141], n_avg_prof, COLOR = 255, THICK = 4

DEVICE, /CLOSE

;save new params

sfname = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/iso_vars.sav'
SAVE, UVB_ind, is_absorb, ind_absorb, FILENAME = sfname

sfname_safe = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/iso_vars_safe.sav'
SAVE, /VARIABLES, FILENAME = sfname_safe

OBJ_DESTROY, dataRast
OBJ_DESTROY, data1400

END
