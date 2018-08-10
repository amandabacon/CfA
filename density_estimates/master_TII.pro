;+
;Name: master_TII.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/08/04
;FROM SI IV TII CALCULATIONS AND UNCERTAINTIES, AS WELL AS SNRs AND
;TIIs FROM O IV, TAKE THE RATIO B/W THE RESONANCE SI IV 1394 AND O IV
;1401 LINE TO GET THE ELECTRON DENSITIES OF THESE O IV EMISSION LINES
;IN UVB SPECTRA.

PRO master_TII

;SNR O IV vals

;restore O IV 114443 TIIs, SNRs, etc.

rfname_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_114443/sigma_coeff_arr_114443_Oiv.sav'
RESTORE, rfname_SNR

PRINT, SIZE(SNR_O_114443[SNR2_O_114443])
one = SNR_O_114443[SNR2_O_114443]

t_O_114443 = SNR_O_114443[SNR2_O_114443]
num_three = WHERE((t_O_114443 GT 3.0), count) ;157

O_114443_a = It_O_114443[SNR2_O_114443]
O_114443 = O_114443_a[num_three]

;restore O IV 153943 TIIs, SNRs, etc.

rfname2_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_153943/sigma_coeff_arr_153943_Oiv.sav'
RESTORE, rfname2_SNR

PRINT, SIZE(SNR_O_153943[SNR2_O_153943])
two = SNR_O_153943[SNR2_O_153943]

t_O_153943 = SNR_O_153943[SNR2_O_153943]
num2_three = WHERE((t_O_153943 GT 3.0), count) ;117

num2_three = WHERE((SNR_O_153943[SNR2_O_153943] GT 3.0), count) ;117

O_153943_a = It_O_153943[SNR2_O_153943]
O_153943 = O_153943_a[num2_three]

;restore O IV 050945 TIIs, SNRs, etc.

rfname3_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_050945/sigma_coeff_arr_050945_Oiv.sav'
RESTORE, rfname3_SNR

PRINT, SIZE(SNR_O_050945[SNR2_O_050945])
three = SNR_O_050945[SNR2_O_050945]

t = SNR_O_050945[SNR2_O_050945]
num3_three = WHERE((t GT 3.0), count) ;103

num3_three = WHERE((SNR_O_050945[SNR2_O_050945] GT 3.0), count) ;103

O_050945_a = It_O_050945[SNR2_O_050945]
O_050945 = O_050945_a[num3_three]

;restore O IV 063943 TIIs, SNRs, etc.

rfname4_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130925_063943/sigma_coeff_arr_063943_Oiv.sav'
RESTORE, rfname4_SNR

PRINT, SIZE(SNR_O_063943[SNR2_O_063943])
four = SNR_O_063943[SNR2_O_063943]

t = SNR_O_063943[SNR2_O_063943]
num4_three = WHERE((t GT 3.0), count) ;188

num4_three = WHERE((SNR_O_063943[SNR2_O_063943] GT 3.0), count) ;188

O_063943_a = It_O_063943[SNR2_O_063943]
O_063943 = O_063943_a[num4_three]

;restore O IV 110943 TIIs, SNRs, etc.

rfname5_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130925_110943/sigma_coeff_arr_110943_Oiv.sav'
RESTORE, rfname5_SNR

PRINT, SIZE(SNR_O_110943[SNR2_O_110943])
five = SNR_O_110943[SNR2_O_110943]

t = SNR_O_110943[SNR2_O_110943]
num5_three = WHERE((t GT 3.0), count) ;304

num5_three = WHERE((SNR_O_110943[SNR2_O_110943] GT 3.0), count) ;304

O_110943_a = It_O_110943[SNR2_O_110943]
O_110943 = O_110943_a[num5_three]

;restore O IV 055943 TIIs, SNRs, etc.

rfname6_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster/sigma_coeff_arr_055943_Oiv.sav'
RESTORE, rfname6_SNR

PRINT, SIZE(SNR_O_055943[SNR2_O_055943])
six = SNR_O_055943[SNR2_O_055943]

t = SNR_O_055943[SNR2_O_055943]
num6_three = WHERE((t GT 3.0), count) ;35

num6_three = WHERE((SNR_O_055943[SNR2_O_055943] GT 3.0), count) ;35

O_055943_a = It_O_055943[SNR2_O_055943]
O_055943 = O_055943_a[num6_three]

;restore O IV 055943_1 TIIs, SNRs, etc.

rfname7_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster1/sigma_coeff_arr_055943_1_Oiv.sav'
RESTORE, rfname7_SNR

PRINT, SIZE(SNR_O_055943_1[SNR2_O_055943_1])
seven = SNR_O_055943_1[SNR2_O_055943_1]

t = SNR_O_055943_1[SNR2_O_055943_1]
num7_three = WHERE((t GT 3.0), count) ;103

num7_three = WHERE((SNR_O_055943_1[SNR2_O_055943_1] GT 3.0), count) ;103

O_055943_1_a = It_O_055943_1[SNR2_O_055943_1]
O_055943_1 = O_055943_1_a[num7_three]

;restore O IV 055943_2 TIIs, SNRs, etc.

rfname8_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster2/sigma_coeff_arr_055943_2_Oiv.sav'
RESTORE, rfname8_SNR

PRINT, SIZE(SNR_O_055943_2[SNR2_O_055943_2])
eight = SNR_O_055943_2[SNR2_O_055943_2]

t = SNR_O_055943_2[SNR2_O_055943_2]
num8_three = WHERE((t GT 3.0), count) ;41

num8_three = WHERE((SNR_O_055943_2[SNR2_O_055943_2] GT 3.0), count) ;41

O_055943_2_a = It_O_055943_2[SNR2_O_055943_2]
O_055943_2 = O_055943_2_a[num8_three]

;restore O IV 20130926_110943 TIIs, SNRs, etc.

rfname9_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_110943/sigma_coeff_arr_20130926_110943_Oiv.sav'
RESTORE, rfname9_SNR

PRINT, SIZE(SNR_O_20130926_110943[SNR2_O_20130926_110943])
nine = SNR_O_20130926_110943[SNR2_O_20130926_110943]

t = SNR_O_20130926_110943[SNR2_O_20130926_110943]
num9_three = WHERE((t GT 3.0), count) ;10

num9_three = WHERE((SNR_O_20130926_110943[SNR2_O_20130926_110943] GT 3.0), count) ;10

O_20130926_110943_a = It_O_20130926_110943[SNR2_O_20130926_110943]
O_20130926_110943 = O_20130926_110943_a[num9_three]

;restore O IV 052432 TIIs, SNRs, etc.

rfname10_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_052432/sigma_coeff_arr_052432_Oiv.sav'
RESTORE, rfname10_SNR

PRINT, SIZE(SNR_O_052432[SNR2_O_052432])
ten = SNR_O_052432[SNR2_O_052432]

t = SNR_O_052432[SNR2_O_052432]
num10_three = WHERE((t GT 3.0), count) ;151

num10_three = WHERE((SNR_O_052432[SNR2_O_052432] GT 3.0), count) ;151

O_052432_a = It_O_052432[SNR2_O_052432]
O_052432 = O_052432_a[num10_three]

;restore O IV 062443 TIIs, SNRs, etc.

rfname11_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_062443/sigma_coeff_arr_062443_Oiv.sav'
RESTORE, rfname11_SNR

PRINT, SIZE(SNR_O_062443[SNR2_O_062443])
eleven = SNR_O_062443[SNR2_O_062443]

t = SNR_O_062443[SNR2_O_062443]
num11_three = WHERE((t GT 3.0), count) ;35

num11_three = WHERE((SNR_O_062443[SNR2_O_062443] GT 3.0), count) ;35

O_062443_a = It_O_062443[SNR2_O_062443]
O_062443 = O_062443_a[num11_three]

;concatenate arrays

total_SNR = [one,two,three,four,five,six,seven,eight,nine,ten,eleven]
PRINT, SIZE(total_SNR)

;===============================================================================
;TII: It, int_int_unc

;restore Si IV 114443 TIIs, SNRs, etc.

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/IT_UV_114443.sav'
RESTORE, rfname

PRINT, N_ELEMENTS(It_Si_114443[num_three])

Si_114443_a = It_Si_114443[SNR2_O_114443]
Si_114443 = Si_114443_a[num_three]

;restore Si IV 153943 TIIs, SNRs, etc.

rfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_153943/IT_153943_UV.sav'
RESTORE, rfname2

PRINT, N_ELEMENTS(It_Si_153943[num2_three])

Si_153943_a = It_Si_153943[SNR2_O_153943]
Si_153943 = Si_153943_a[num2_three]

;restore Si IV 063943 TIIs, SNRs, etc.

rfname3 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/IT_063943_UV.sav'
RESTORE, rfname3

PRINT, N_ELEMENTS(It_Si_063943[num4_three])

Si_063943_a = It_Si_063943[SNR2_O_063943]
Si_063943 = Si_063943_a[num4_three]

;restore Si IV 110943 TIIs, SNRs, etc.

rfname4 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_110943/IT_110943_UV.sav'
RESTORE, rfname4

PRINT, N_ELEMENTS(It_Si_110943[num5_three])

Si_110943_a = It_Si_110943[SNR2_O_110943]
Si_110943 = Si_110943_a[num5_three]

;restore Si IV 055943 TIIs, SNRs, etc.

rfname5 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster/IT_055943_UV.sav'
RESTORE, rfname5

PRINT, N_ELEMENTS(It_Si_055943[num6_three])

Si_055943_a = It_Si_055943[SNR2_O_055943]
Si_055943 = Si_055943_a[num6_three]

;restore Si IV 055943_1 TIIs, SNRs, etc.

rfname6 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/IT_055943_1_UV.sav'
RESTORE, rfname6

PRINT, N_ELEMENTS(It_Si_055943_1[num7_three])

Si_055943_1_a = It_Si_055943_1[SNR2_O_055943_1]
Si_055943_1 = Si_055943_1_a[num7_three]

;restore Si IV 055943_2 TIIs, SNRs, etc.

rfname7 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/IT_055943_2_UV.sav'
RESTORE, rfname7

PRINT, N_ELEMENTS(It_Si_055943_2[num8_three])

Si_055943_2_a = It_Si_055943_2[SNR2_O_055943_2]
Si_055943_2 = Si_055943_2_a[num8_three]

;restore Si IV 20130926_110943 TIIs, SNRs, etc.

rfname8 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_110943/IT_20130926_110943_UV.sav'
RESTORE, rfname8

PRINT, N_ELEMENTS(It_Si_20130926_110943[num9_three])

Si_20130926_110943_a = It_Si_20130926_110943[SNR2_O_20130926_110943]
Si_20130926_110943 = Si_20130926_110943_a[num9_three]

;restore Si IV 052432 TIIs, SNRs, etc.

rfname9 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/IT_052432_UV.sav'
RESTORE, rfname9

PRINT, N_ELEMENTS(It_Si_052432[num10_three])

Si_052432_a = It_Si_052432[SNR2_O_052432]
Si_052432 = Si_052432_a[num10_three]

;restore Si IV 062443 TIIs, SNRs, etc.

rfname10 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/IT_062443_UV.sav'
RESTORE, rfname10

PRINT, N_ELEMENTS(It_Si_062443[num11_three])

Si_062443_a = It_Si_062443[SNR2_O_062443]
Si_062443 = Si_062443_a[num11_three]

;restore Si IV 050945 TIIs, SNRs, etc.

rfname11 = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/IT_UV_050945.sav'
RESTORE, rfname11

PRINT, N_ELEMENTS(It_Si_050945[num3_three])

Si_050945_a = It_Si_050945[SNR2_O_050945]
Si_050945 = Si_050945_a[num3_three]

;===============================================================================
;retrieve ratios

ratio_114443 = (Si_114443/O_114443)
ratio_153943 = (Si_153943/O_153943)
ratio_063943 = (Si_063943/O_063943)
ratio_110943 = (Si_110943/O_110943)
ratio_055943 = (Si_055943/O_055943)
ratio_055943_1 = (Si_055943_1/O_055943_1)
ratio_055943_2 = (Si_055943_2/O_055943_2)
ratio_20130926_110943 = (Si_20130926_110943/O_20130926_110943)
ratio_052432 = (Si_052432/O_052432)
ratio_062443 = (Si_062443/O_062443)
ratio_050945 = (Si_050945/O_050945)

;===============================================================================
;load diagnostic model

rfname_dens = '/data/khnum/REU2018/abacon/data/detection/density_estimates/si4_o4_dens_diagnostic.sav'
RESTORE, rfname_dens

;get size of ratios over each observation

TII_114443_s = N_ELEMENTS(ratio_114443)
TII_153943_s = N_ELEMENTS(ratio_153943)
TII_063943_s = N_ELEMENTS(ratio_063943)
TII_110943_s = N_ELEMENTS(ratio_110943)
TII_055943_s = N_ELEMENTS(ratio_055943)
TII_055943_1_s = N_ELEMENTS(ratio_055943_1)
TII_055943_2_s = N_ELEMENTS(ratio_055943_2)
TII_20130926_110943_s = N_ELEMENTS(ratio_20130926_110943)
TII_052432_s = N_ELEMENTS(ratio_052432)
TII_062443_s = N_ELEMENTS(ratio_062443)
TII_050945_s = N_ELEMENTS(ratio_050945)

;FOR loops for electron density info

electron_dens_arr_114443 = DBLARR(TII_114443_s)

FOR i = 0, TII_114443_s-1 DO BEGIN
   difference_arr_114443 = ABS(si_o_ratio-ratio_114443[i])
   electron_dens_114443 = WHERE(difference_arr_114443 EQ MIN(difference_arr_114443), /NULL)
   electron_dens_arr_114443[i] = electron_dens_114443[0]
ENDFOR

;PRINT, electron_dens_arr_114443 ;few zeros

;PRINT, e_density[electron_dens_arr_114443]

e_dens_114443 = e_density[electron_dens_arr_114443]

;===============================================================================

electron_dens_arr_153943 = DBLARR(TII_153943_s)

FOR i = 0, TII_153943_s-1 DO BEGIN
   difference_arr_153943 = ABS(si_o_ratio-ratio_153943[i])
   electron_dens_153943 = WHERE(difference_arr_153943 EQ MIN(difference_arr_153943), /NULL)
   electron_dens_arr_153943[i] = electron_dens_153943[0]
ENDFOR

;PRINT, electron_dens_arr_153943 ;few zeros

;PRINT, e_density[electron_dens_arr_153943]

e_dens_153943 = e_density[electron_dens_arr_153943]

;===============================================================================

electron_dens_arr_063943 = DBLARR(TII_063943_s)

FOR i = 0, TII_063943_s-1 DO BEGIN
   difference_arr_063943 = ABS(si_o_ratio-ratio_063943[i])
   electron_dens_063943 = WHERE(difference_arr_063943 EQ MIN(difference_arr_063943), /NULL)
   electron_dens_arr_063943[i] = electron_dens_063943[0]
ENDFOR

;PRINT, electron_dens_arr_063943 ;few zeros

;PRINT, e_density[electron_dens_arr_063943]

e_dens_063943 = e_density[electron_dens_arr_063943]

;===============================================================================

electron_dens_arr_110943 = DBLARR(TII_110943_s)

FOR i = 0, TII_110943_s-1 DO BEGIN
   difference_arr_110943 = ABS(si_o_ratio-ratio_110943[i])
   electron_dens_110943 = WHERE(difference_arr_110943 EQ MIN(difference_arr_110943))
   electron_dens_arr_110943[i] = electron_dens_110943[0]
ENDFOR

;PRINT, electron_dens_arr_110943 ;few zeros

;PRINT, e_density[electron_dens_arr_110943]

e_dens_110943 = e_density[electron_dens_arr_110943]

;===============================================================================

electron_dens_arr_055943 = DBLARR(TII_055943_s)

FOR i = 0, TII_055943_s-1 DO BEGIN
   difference_arr_055943 = ABS(si_o_ratio-ratio_055943[i])
   electron_dens_055943 = WHERE(difference_arr_055943 EQ MIN(difference_arr_055943), /NULL) ;remove -1
   electron_dens_arr_055943[i] = electron_dens_055943[0] ;0 to choose the first min value if more than one
ENDFOR

;PRINT, electron_dens_arr_055943 ;few zeros

;PRINT, e_density[electron_dens_arr_055943]

e_dens_055943 = e_density[electron_dens_arr_055943]

;===============================================================================

electron_dens_arr_055943_1 = DBLARR(TII_055943_1_s)

FOR i = 0, TII_055943_1_s-1 DO BEGIN
   difference_arr_055943_1 = ABS(si_o_ratio-ratio_055943_1[i])
   electron_dens_055943_1 = WHERE(difference_arr_055943_1 EQ MIN(difference_arr_055943_1), /NULL)
   electron_dens_arr_055943_1[i] = electron_dens_055943_1[0]
ENDFOR

;PRINT, electron_dens_arr_055943_1 ;few zeros

;PRINT, e_density[electron_dens_arr_055943_1]

e_dens_055943_1 = e_density[electron_dens_arr_055943_1]

;===============================================================================

electron_dens_arr_055943_2 = DBLARR(TII_055943_2_s)

FOR i = 0, TII_055943_2_s-1 DO BEGIN
   difference_arr_055943_2 = ABS(si_o_ratio-ratio_055943_2[i])
   electron_dens_055943_2 = WHERE(difference_arr_055943_2 EQ MIN(difference_arr_055943_2), /NULL)
   electron_dens_arr_055943_2[i] = electron_dens_055943_2[0]
ENDFOR

;PRINT, electron_dens_arr_055943_2

;PRINT, e_density[electron_dens_arr_055943_2]

e_dens_055943_2 = e_density[electron_dens_arr_055943_2]

;===============================================================================

electron_dens_arr_20130926_110943 = DBLARR(TII_20130926_110943_s)

FOR i = 0, TII_20130926_110943_s-1 DO BEGIN
   difference_arr_20130926_110943 = ABS(si_o_ratio-ratio_20130926_110943[i])
   electron_dens_20130926_110943 = WHERE(difference_arr_20130926_110943 EQ MIN(difference_arr_20130926_110943), /NULL)
   electron_dens_arr_20130926_110943[i] = electron_dens_20130926_110943[0]
ENDFOR

;PRINT, electron_dens_arr_20130926_110943

;PRINT, e_density[electron_dens_arr_20130926_110943]

e_dens_20130926_110943 = e_density[electron_dens_arr_20130926_110943]

;===============================================================================

electron_dens_arr_052432 = DBLARR(TII_052432_s)

FOR i = 0, TII_052432_s-1 DO BEGIN
   difference_arr_052432 = ABS(si_o_ratio-ratio_052432[i])
   electron_dens_052432 = WHERE(difference_arr_052432 EQ MIN(difference_arr_052432), /NULL)
   electron_dens_arr_052432[i] = electron_dens_052432[0]
ENDFOR

;PRINT, electron_dens_arr_052432 ;few zeros

;PRINT, e_density[electron_dens_arr_052432]

e_dens_052432 = e_density[electron_dens_arr_052432]

;===============================================================================

electron_dens_arr_062443 = DBLARR(TII_062443_s)

FOR i = 0, TII_062443_s-1 DO BEGIN
   difference_arr_062443 = ABS(si_o_ratio-ratio_062443[i])
   electron_dens_062443 = WHERE(difference_arr_062443 EQ MIN(difference_arr_062443), /NULL)
   electron_dens_arr_062443[i] = electron_dens_062443[0]
ENDFOR

;PRINT, electron_dens_arr_062443 ;few zeros

;PRINT, e_density[electron_dens_arr_062443]

e_dens_062443 = e_density[electron_dens_arr_062443]

;===============================================================================

electron_dens_arr_050945 = DBLARR(TII_050945_s)

FOR i = 0, TII_050945_s-1 DO BEGIN
   difference_arr_050945 = ABS(si_o_ratio-ratio_050945[i])
   electron_dens_050945 = WHERE(difference_arr_050945 EQ MIN(difference_arr_050945), /NULL)
   electron_dens_arr_050945[i] = electron_dens_050945[0]
ENDFOR

;PRINT, electron_dens_arr_050945 ;few zeros

;PRINT, e_density[electron_dens_arr_050945]

e_dens_050945 = e_density[electron_dens_arr_050945]

sfname_e_dens = '/data/khnum/REU2018/abacon/data/detection/density_estimates/e_dens.sav'
SAVE, electron_dens_arr_20130926_110943, electron_dens_arr_050945, electron_dens_arr_062443, electron_dens_arr_052432, electron_dens_arr_055943_2, electron_dens_arr_055943_1, electron_dens_arr_055943, electron_dens_arr_110943, electron_dens_arr_063943, electron_dens_arr_153943, electron_dens_arr_114443, FILENAME = sfname_e_dens

;restore to get aspr info.

rfname_aspr = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/all_vars.sav'
RESTORE, rfname_aspr

;concatenate arrays

total_D = [e_dens_20130926_110943, e_dens_062443, e_dens_052432, e_dens_055943_2, e_dens_055943_1, e_dens_055943, e_dens_110943, e_dens_063943, e_dens_153943, e_dens_114443, e_dens_050945]

;large data, so take log base 10

total_D = ALOG10(total_D)

;make histogram of all densities and frequencies

D_hist = HISTOGRAM(total_D, BINSIZE = 0.2, LOCATIONS = x_hist)

PLOT, x_hist, D_hist, PSYM = 10, XTITLE = "Estimated Densities", YTITLE = "Frequency", TITLE = "Histogram of Estimated Densities of AR11850"

;save as ps

!P.FONT = 1

TVLCT, [[255],[255],[255]], 1
SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/density_estimates/dens_est_histogram.eps', /ENCAPSULATED

PLOT, x_hist, D_hist, PSYM = 10, XTITLE = "Estimated Densities", YTITLE = "Frequency", TITLE = "Histogram of Estimated Densities of AR11850", POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 1, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, XSTYLE = 1, THICK = 4, XTHICK = 10, YTHICK = 10

DEVICE, /CLOSE

END
