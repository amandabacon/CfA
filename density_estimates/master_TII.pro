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

rfname_114443 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_114443/iso_vars_114443.sav'
RESTORE, rfname_114443

rfname_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_114443/sigma_coeff_arr_114443_Oiv.sav'
RESTORE, rfname_SNR

one = SNR_O_114443[SNR2_O_114443]

num_three = WHERE((SNR_O_114443 GE 3.0) AND FINITE(SNR_O_114443), count) ;remove both the nonfinite SNRs and SNRs < 3 in one shot
PRINT, SIZE(num_three) ;157
PRINT, 'SNR_O_114443[num_three]'
PRINT, SNR_O_114443[num_three]

O_114443 = It_O_114443[num_three]
PRINT, 'O_114443'
PRINT, O_114443

;restore O IV 153943 TIIs, SNRs, etc.

rfname2_153943 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_153943/iso_vars_153943.sav'
RESTORE, rfname2_153943

rfname2_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_153943/sigma_coeff_arr_153943_Oiv.sav'
RESTORE, rfname2_SNR

two = SNR_O_153943[SNR2_O_153943]

num2_three = WHERE((SNR_O_153943 GE 3.0) AND FINITE(SNR_O_153943), count)
PRINT, SIZE(num2_three) ;117
PRINT, 'SNR_O_153943[num2_three]'
PRINT, SNR_O_153943[num2_three]

O_153943 = It_O_153943[num2_three]
PRINT, 'O_153943'
PRINT, O_153943

;restore O IV 050945 TIIs, SNRs, etc.

rfname3_050945 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_050945/iso_vars_safe_clean.sav'
RESTORE, rfname3_050945

rfname3_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130924_050945/sigma_coeff_arr_050945_Oiv.sav'
RESTORE, rfname3_SNR

three = SNR_O_050945[SNR2_O_050945]

num3_three = WHERE((SNR_O_050945 GE 3.0) AND FINITE(SNR_O_050945), count)
PRINT, SIZE(num3_three) ;103
PRINT, 'SNR_O_050945[num3_three]'
PRINT, SNR_O_050945[num3_three]

O_050945 = It_O_050945[num3_three]
PRINT, 'O_050945'
PRINT, O_050945

;restore O IV 063943 TIIs, SNRs, etc.

rfname4_063943 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130925_063943/iso_vars_063943.sav'
RESTORE, rfname4_063943

rfname4_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130925_063943/sigma_coeff_arr_063943_Oiv.sav'
RESTORE, rfname4_SNR

four = SNR_O_063943[SNR2_O_063943]

num4_three = WHERE((SNR_O_063943 GE 3.0) AND FINITE(SNR_O_063943), count)
PRINT, SIZE(num4_three) ;188
PRINT, 'SNR_O_063943[num4_three]'
PRINT, SNR_O_063943[num4_three]

O_063943 = It_O_063943[num4_three]
PRINT, 'O_063943'
PRINT, O_063943

;restore O IV 110943 TIIs, SNRs, etc.

rfname5_110943 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130925_110943/iso_vars_110943.sav'
RESTORE, rfname5_110943

rfname5_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130925_110943/sigma_coeff_arr_110943_Oiv.sav'
RESTORE, rfname5_SNR

five = SNR_O_110943[SNR2_O_110943]

num5_three = WHERE((SNR_O_110943 GE 3.0) AND FINITE(SNR_O_110943), count)
PRINT, SIZE(num5_three) ;304
PRINT, 'SNR_O_110943[num5_three]'
PRINT, SNR_O_110943[num5_three]

O_110943 = It_O_110943[num5_three]
PRINT, 'O_110943'
PRINT, O_110943

;restore O IV 055943 TIIs, SNRs, etc.

rfname6_055943 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster/iso_vars_055943.sav'
RESTORE, rfname6_055943

rfname6_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster/sigma_coeff_arr_055943_Oiv.sav'
RESTORE, rfname6_SNR

six = SNR_O_055943[SNR2_O_055943]

num6_three = WHERE((SNR_O_055943 GE 3.0) AND FINITE(SNR_O_055943), count)
PRINT, SIZE(num6_three) ;35
PRINT, 'SNR_O_055943[num6_three]'
PRINT, SNR_O_055943[num6_three]

O_055943 = It_O_055943[num6_three]
PRINT, 'O_055943'
PRINT, O_055943

;restore O IV 055943_1 TIIs, SNRs, etc.

rfname7_055943_1 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster1/iso_vars_055943_1.sav'
RESTORE, rfname7_055943_1

rfname7_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster1/sigma_coeff_arr_055943_1_Oiv.sav'
RESTORE, rfname7_SNR

seven = SNR_O_055943_1[SNR2_O_055943_1]

num7_three = WHERE((SNR_O_055943_1 GE 3.0) AND FINITE(SNR_O_055943_1), count)
PRINT, SIZE(num7_three) ;103
PRINT, 'SNR_O_055943_1[num7_three]'
PRINT, SNR_O_055943_1[num7_three]

O_055943_1 = It_O_055943_1[num7_three]
PRINT, 'O_055943_1'
PRINT, O_055943_1

;restore O IV 055943_2 TIIs, SNRs, etc.

rfname8_055943_2 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster2/iso_vars_055943_2.sav'
RESTORE, rfname8_055943_2

rfname8_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_055943/raster2/sigma_coeff_arr_055943_2_Oiv.sav'
RESTORE, rfname8_SNR

eight = SNR_O_055943_2[SNR2_O_055943_2]

num8_three = WHERE((SNR_O_055943_2 GE 3.0) AND FINITE(SNR_O_055943_2), count)
PRINT, SIZE(num8_three) ;41
PRINT, 'SNR_O_055943_2[num8_three]'
PRINT, SNR_O_055943_2[num8_three]

O_055943_2 = It_O_055943_2[num8_three]
PRINT, 'O_055943_2'
PRINT, O_055943_2

;restore O IV 20130926_110943 TIIs, SNRs, etc.

rfname9_20130926_110943 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_110943/iso_vars_20130926_110943.sav'
RESTORE, rfname9_20130926_110943

rfname9_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130926_110943/sigma_coeff_arr_20130926_110943_Oiv.sav'
RESTORE, rfname9_SNR

nine = SNR_O_20130926_110943[SNR2_O_20130926_110943]

num9_three = WHERE((SNR_O_20130926_110943 GE 3.0) AND FINITE(SNR_O_20130926_110943), count)
PRINT, SIZE(num9_three) ;10
PRINT, 'SNR_O_20130926_110943[num9_three]'
PRINT, SNR_O_20130926_110943[num9_three]

O_20130926_110943 = It_O_20130926_110943[num9_three]
PRINT, 'O_20130926_110943'
PRINT, O_20130926_110943

;restore O IV 052432 TIIs, SNRs, etc.

rfname10_052432 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_052432/iso_vars_052432.sav'
RESTORE, rfname10_052432

rfname10_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_052432/sigma_coeff_arr_052432_Oiv.sav'
RESTORE, rfname10_SNR

ten = SNR_O_052432[SNR2_O_052432]

num10_three = WHERE((SNR_O_052432 GE 3.0) AND FINITE(SNR_O_052432), count)
PRINT, SIZE(num10_three) ;151
PRINT, 'SNR_O_052432[num10_three]'
PRINT, SNR_O_052432[num10_three]

O_052432 = It_O_052432[num10_three]
PRINT, 'O_052432'
PRINT, O_052432

;restore O IV 062443 TIIs, SNRs, etc.

rfname11_062443 = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_062443/iso_vars_062443.sav'
RESTORE, rfname11_062443

rfname11_SNR = '/data/khnum/REU2018/abacon/data/detection/Oiv_1401_SGF/20130927_062443/sigma_coeff_arr_062443_Oiv.sav'
RESTORE, rfname11_SNR

eleven = SNR_O_062443[SNR2_O_062443]

num11_three = WHERE((SNR_O_062443 GE 3.0) AND FINITE(SNR_O_062443), count)
PRINT, SIZE(num11_three) ;35
PRINT, 'SNR_O_062443[num11_three]'
PRINT, SNR_O_062443[num11_three]

O_062443 = It_O_062443[num11_three]
PRINT, 'O_062443'
PRINT, O_062443

;concatenate arrays

total_SNR = [one,two,three,four,five,six,seven,eight,nine,ten,eleven]
PRINT, SIZE(total_SNR) ;3700

;===============================================================================
;TII: It, int_int_unc

;restore Si IV 114443 TIIs, SNRs, etc.

rfname = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_114443/IT_UV_114443.sav'
RESTORE, rfname

UVB_ind_Oiv_three_114443 = UVB_ind_Oiv_114443[num_three]
PRINT, 'UVB_ind_Oiv_three_114443'
PRINT, UVB_ind_Oiv_three_114443

var_Si_three = WHERE(UVB_ind_114443 EQ UVB_ind_Oiv_three_114443)
MATCH,UVB_ind_114443,UVB_ind_Oiv_three_114443,var_Si_three,dum
Si_114443 = It_Si_114443[var_Si_three]
PRINT, N_ELEMENTS(Si_114443) ;157
PRINT, 'Si_114443'
PRINT, Si_114443

;restore Si IV 153943 TIIs, SNRs, etc.

rfname2 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130924_153943/IT_153943_UV.sav'
RESTORE, rfname2

UVB_ind_Oiv_three_153943 = UVB_ind_Oiv_153943[num2_three]
PRINT, 'UVB_ind_Oiv_three_153943'
PRINT, UVB_ind_Oiv_three_153943

var_Si_three_2 = WHERE(UVB_ind_153943 EQ UVB_ind_Oiv_three_153943)
MATCH,UVB_ind_153943,UVB_ind_Oiv_three_153943,var_Si_three_2,dum
Si_153943 = It_Si_153943[var_Si_three_2]
PRINT, N_ELEMENTS(Si_153943) ;117
PRINT, 'Si_153943'
PRINT, Si_153943

;restore Si IV 063943 TIIs, SNRs, etc.

rfname3 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_063943/IT_063943_UV.sav'
RESTORE, rfname3

UVB_ind_Oiv_three_063943 = UVB_ind_Oiv_063943[num4_three]
PRINT, 'UVB_ind_Oiv_three_063943'
PRINT, UVB_ind_Oiv_three_063943

var_Si_three_3 = WHERE(UVB_ind_063943 EQ UVB_ind_Oiv_three_063943)
MATCH,UVB_ind_063943,UVB_ind_Oiv_three_063943,var_Si_three_3,dum
Si_063943 = It_Si_063943[var_Si_three_3]
PRINT, N_ELEMENTS(Si_063943) ;188
PRINT, 'Si_063943'
PRINT, Si_063943

;restore Si IV 110943 TIIs, SNRs, etc.

rfname4 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130925_110943/IT_110943_UV.sav'
RESTORE, rfname4

UVB_ind_Oiv_three_110943 = UVB_ind_Oiv_110943[num5_three]
PRINT, 'UVB_ind_Oiv_three_110943'
PRINT, UVB_ind_Oiv_three_110943

var_Si_three_4 = WHERE(UVB_ind_110943 EQ UVB_ind_Oiv_three_110943)
MATCH,UVB_ind_110943,UVB_ind_Oiv_three_110943,var_Si_three_4,dum
Si_110943 = It_Si_110943[var_Si_three_4]
PRINT, N_ELEMENTS(Si_110943) ;304
PRINT, 'Si_110943'
PRINT, Si_110943

;restore Si IV 055943 TIIs, SNRs, etc.

rfname5 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster/IT_055943_UV.sav'
RESTORE, rfname5

UVB_ind_Oiv_three_055943 = UVB_ind_Oiv_055943[num6_three]
PRINT, 'UVB_ind_Oiv_three_055943'
PRINT, UVB_ind_Oiv_three_055943

var_Si_three_5 = WHERE(UVB_ind_055943 EQ UVB_ind_Oiv_three_055943)
MATCH,UVB_ind_055943,UVB_ind_Oiv_three_055943,var_Si_three_5,dum
Si_055943 = It_Si_055943[var_Si_three_5]
PRINT, N_ELEMENTS(Si_055943) ;35
PRINT, 'Si_055943'
PRINT, Si_055943

;restore Si IV 055943_1 TIIs, SNRs, etc.

rfname6 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster1/IT_055943_1_UV.sav'
RESTORE, rfname6

UVB_ind_Oiv_three_055943_1 = UVB_ind_Oiv_055943_1[num7_three]
PRINT, 'UVB_ind_Oiv_three_055943_1'
PRINT, UVB_ind_Oiv_three_055943_1

var_Si_three_6 = WHERE(UVB_ind_055943_1 EQ UVB_ind_Oiv_three_055943_1)
MATCH,UVB_ind_055943_1,UVB_ind_Oiv_three_055943_1,var_Si_three_6,dum
Si_055943_1 = It_Si_055943_1[var_Si_three_6]
PRINT, N_ELEMENTS(Si_055943_1) ;103
PRINT, 'Si_055943_1'
PRINT, Si_055943_1

;restore Si IV 055943_2 TIIs, SNRs, etc.

rfname7 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_055943/raster2/IT_055943_2_UV.sav'
RESTORE, rfname7

UVB_ind_Oiv_three_055943_2 = UVB_ind_Oiv_055943_2[num8_three]
PRINT, 'UVB_ind_Oiv_three_055943_2'
PRINT, UVB_ind_Oiv_three_055943_2

var_Si_three_7 = WHERE(UVB_ind_055943_2 EQ UVB_ind_Oiv_three_055943_2)
MATCH,UVB_ind_055943_2,UVB_ind_Oiv_three_055943_2,var_Si_three_7,dum
Si_055943_2 = It_Si_055943_2[var_Si_three_7]
PRINT, N_ELEMENTS(Si_055943_2) ;41
PRINT, 'Si_055943_2'
PRINT, Si_055943_2

;restore Si IV 20130926_110943 TIIs, SNRs, etc.

rfname8 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130926_110943/IT_20130926_110943_UV.sav'
RESTORE, rfname8

UVB_ind_Oiv_three_20130926_110943 = UVB_ind_Oiv_20130926_110943[num9_three]
PRINT, 'UVB_ind_Oiv_three_20130926_110943'
PRINT, UVB_ind_Oiv_three_20130926_110943

var_Si_three_8 = WHERE(UVB_ind_20130926_110943 EQ UVB_ind_Oiv_three_20130926_110943)
MATCH,UVB_ind_20130926_110943,UVB_ind_Oiv_three_20130926_110943,var_Si_three_8,dum
Si_20130926_110943 = It_Si_20130926_110943[var_Si_three_8]
PRINT, N_ELEMENTS(Si_20130926_110943) ;10
PRINT, 'Si_20130926_110943'
PRINT, Si_20130926_110943

;restore Si IV 052432 TIIs, SNRs, etc.

rfname9 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_052432/IT_052432_UV.sav'
RESTORE, rfname9

UVB_ind_Oiv_three_052432 = UVB_ind_Oiv_052432[num10_three]
PRINT, 'UVB_ind_Oiv_three_052432'
PRINT, UVB_ind_Oiv_three_052432

var_Si_three_9 = WHERE(UVB_ind_052432 EQ UVB_ind_Oiv_three_052432)
MATCH,UVB_ind_052432,UVB_ind_Oiv_three_052432,var_Si_three_9,dum
Si_052432 = It_Si_052432[var_Si_three_9]
PRINT, N_ELEMENTS(Si_052432) ;151
PRINT, 'Si_052432'
PRINT, Si_052432

;restore Si IV 062443 TIIs, SNRs, etc.

rfname10 = '/data/khnum/REU2018/abacon/data/detection/AR11850_20130927_062443/IT_062443_UV.sav'
RESTORE, rfname10

UVB_ind_Oiv_three_062443 = UVB_ind_Oiv_062443[num11_three]
PRINT, 'UVB_ind_Oiv_three_062443'
PRINT, UVB_ind_Oiv_three_062443

var_Si_three_10 = WHERE(UVB_ind_062443 EQ UVB_ind_Oiv_three_062443)
MATCH,UVB_ind_062443,UVB_ind_Oiv_three_062443,var_Si_three_10,dum
Si_062443 = It_Si_062443[var_Si_three_10]
PRINT, N_ELEMENTS(Si_062443) ;35
PRINT, 'Si_062443'
PRINT, Si_062443

;restore Si IV 050945 TIIs, SNRs, etc.

rfname11 = '/data/khnum/REU2018/abacon/data/detection/1394_SGF/IT_UV_050945.sav'
RESTORE, rfname11

UVB_ind_Oiv_three_050945 = UVB_ind_Oiv_050945[num3_three]
PRINT, 'UVB_ind_Oiv_three_050945'
PRINT, UVB_ind_Oiv_three_050945

var_Si_three_11 = WHERE(UVB_ind_clean EQ UVB_ind_Oiv_three_050945)
MATCH,UVB_ind_clean,UVB_ind_Oiv_three_050945,var_Si_three_11,dum
Si_050945 = It_Si_050945[var_Si_three_11]
PRINT, N_ELEMENTS(Si_050945) ;103
PRINT, 'Si_050945'
PRINT, Si_050945

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

TVLCT, [[0],[0],[0]], 1
SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 10, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '/data/khnum/REU2018/abacon/data/detection/density_estimates/dens_est_histogram.eps', /ENCAPSULATED

PLOT, x_hist, D_hist, PSYM = 10, XTITLE = "Electron Density (cm^-3)", YTITLE = "Frequency", POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 1, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, XSTYLE = 1, THICK = 10, XTHICK = 10, YTHICK = 10, CHARTHICK = 5

DEVICE, /CLOSE

END
