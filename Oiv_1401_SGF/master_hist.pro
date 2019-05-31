;+
;Name: master_hist.pro
;Written by: Amanda Bacon (amanda.bacon@cfa.harvard.edu)
;Date: 2018/07/28
;RESTORE ALL SAVE FILES FROM EACH OBSERVATION IN 'Oiv_1401_SGF' IN
;ORDER TO CREATE ONE MASTER HISTOGRAM OF ALL SNRs AND THE FREQUENCY OF
;APPEARANCE OF O IV EMISSION LINE IN UVB SPECTRA.

;PRO master_hist

;restore 114443 TIIs, SNRs, etc.

rfname = '~/Desktop/amandabacon/11850/sigma_coeff_arr_114443_Oiv.sav'
RESTORE, rfname

PRINT, SIZE(SNR_O_114443[SNR2_O_114443]) ;620
one = SNR_O_114443[SNR2_O_114443]

num_three = WHERE((SNR_O_114443[SNR2_O_114443] GT 3.0), count) ;157
PRINT, SIZE(num_three)
num_five = WHERE((SNR_O_114443[SNR2_O_114443] GT 5.0), count) ;75
PRINT, SIZE(num_five)
num_ten = WHERE((SNR_O_114443[SNR2_O_114443] GT 10.0), count) ;22
PRINT, SIZE(num_ten)
num_twenty = WHERE((SNR_O_114443[SNR2_O_114443] GT 20.0), count) ;0
PRINT, SIZE(num_twenty)
num_forty = WHERE((SNR_O_114443[SNR2_O_114443] GT 40.0), count) ;0
PRINT, SIZE(num_forty)

;restore 153943 TIIs, SNRs, etc.

rfname2 = '~/Desktop/amandabacon/11850/sigma_coeff_arr_153943_Oiv.sav'
RESTORE, rfname2

PRINT, SIZE(SNR_O_153943[SNR2_O_153943])
two = SNR_O_153943[SNR2_O_153943] ;163

num2_three = WHERE((SNR_O_153943[SNR2_O_153943] GT 3.0), count) ;117
PRINT, SIZE(num2_three)
num2_five = WHERE((SNR_O_153943[SNR2_O_153943] GT 5.0), count) ;87
PRINT, SIZE(num2_five)
num2_ten = WHERE((SNR_O_153943[SNR2_O_153943] GT 10.0), count) ;25
PRINT, SIZE(num2_ten)
num2_twenty = WHERE((SNR_O_153943[SNR2_O_153943] GT 20.0), count) ;0
PRINT, SIZE(num2_twenty)
num2_forty = WHERE((SNR_O_153943[SNR2_O_153943] GT 40.0), count) ;0
PRINT, SIZE(num2_forty)

;restore 050945 TIIs, SNRs, etc.

rfname3 = '~/Desktop/amandabacon/11850/sigma_coeff_arr_050945_Oiv.sav'
RESTORE, rfname3

PRINT, SIZE(SNR_O_050945[SNR2_O_050945])
three = SNR_O_050945[SNR2_O_050945] ;304

num3_three = WHERE((SNR_O_050945[SNR2_O_050945] GT 3.0), count) ;103
PRINT, SIZE(num3_three)
num3_five = WHERE((SNR_O_050945[SNR2_O_050945] GT 5.0), count) ;37
PRINT, SIZE(num3_five)
num3_ten = WHERE((SNR_O_050945[SNR2_O_050945] GT 10.0), count) ;3
PRINT, SIZE(num3_ten)
num3_twenty = WHERE((SNR_O_050945[SNR2_O_050945] GT 20.0), count) ;0
PRINT, SIZE(num3_twenty)
num3_forty = WHERE((SNR_O_050945[SNR2_O_050945] GT 40.0), count) ;0
PRINT, SIZE(num3_forty)

;restore 063943 TIIs, SNRs, etc.

rfname4 = '~/Desktop/amandabacon/11850/sigma_coeff_arr_063943_Oiv.sav'
RESTORE, rfname4

PRINT, SIZE(SNR_O_063943[SNR2_O_063943]) ;354
four = SNR_O_063943[SNR2_O_063943]

num4_three = WHERE((SNR_O_063943[SNR2_O_063943] GT 3.0), count) ;188
PRINT, SIZE(num4_three)
num4_five = WHERE((SNR_O_063943[SNR2_O_063943] GT 5.0), count) ;117
PRINT, SIZE(num4_five)
num4_ten = WHERE((SNR_O_063943[SNR2_O_063943] GT 10.0), count) ;62
PRINT, SIZE(num4_ten)
num4_twenty = WHERE((SNR_O_063943[SNR2_O_063943] GT 20.0), count) ;3
PRINT, SIZE(num4_twenty)
num4_forty = WHERE((SNR_O_063943[SNR2_O_063943] GT 40.0), count) ;0
PRINT, SIZE(num4_forty)

;restore 110943 TIIs, SNRs, etc.

rfname5 = '~/Desktop/amandabacon/11850/sigma_coeff_arr_110943_Oiv.sav'
RESTORE, rfname5

PRINT, SIZE(SNR_O_110943[SNR2_O_110943]) ;776
five = SNR_O_110943[SNR2_O_110943]

num5_three = WHERE((SNR_O_110943[SNR2_O_110943] GT 3.0), count) ;304
PRINT, SIZE(num5_three)
num5_five = WHERE((SNR_O_110943[SNR2_O_110943] GT 5.0), count) ;89
PRINT, SIZE(num5_five)
num5_ten = WHERE((SNR_O_110943[SNR2_O_110943] GT 10.0), count) ;1
PRINT, SIZE(num5_ten)
num5_twenty = WHERE((SNR_O_110943[SNR2_O_110943] GT 20.0), count) ;0
PRINT, SIZE(num5_twenty)
num5_forty = WHERE((SNR_O_110943[SNR2_O_110943] GT 40.0), count) ;0
PRINT, SIZE(num5_forty)

;restore 055943 TIIs, SNRs, etc.

rfname6 = '~/Desktop/amandabacon/11850/sigma_coeff_arr_055943_Oiv.sav'
RESTORE, rfname6

PRINT, SIZE(SNR_O_055943[SNR2_O_055943]) ;198
six = SNR_O_055943[SNR2_O_055943]

num6_three = WHERE((SNR_O_055943[SNR2_O_055943] GT 3.0), count) ;35
PRINT, SIZE(num6_three)
num6_five = WHERE((SNR_O_055943[SNR2_O_055943] GT 5.0), count) ;16
PRINT, SIZE(num6_five)
num6_ten = WHERE((SNR_O_055943[SNR2_O_055943] GT 10.0), count) ;6
PRINT, SIZE(num6_ten)
num6_twenty = WHERE((SNR_O_055943[SNR2_O_055943] GT 20.0), count) ;0
PRINT, SIZE(num6_twenty)
num6_forty = WHERE((SNR_O_055943[SNR2_O_055943] GT 40.0), count) ;0
PRINT, SIZE(num6_forty)

;restore 055943_1 TIIs, SNRs, etc.

rfname7 = '~/Desktop/amandabacon/11850/sigma_coeff_arr_055943_1_Oiv.sav'
RESTORE, rfname7

PRINT, SIZE(SNR_O_055943_1[SNR2_O_055943_1]) ;330
seven = SNR_O_055943_1[SNR2_O_055943_1]

num7_three = WHERE((SNR_O_055943_1[SNR2_O_055943_1] GT 3.0), count) ;103
PRINT, SIZE(num7_three)
num7_five = WHERE((SNR_O_055943_1[SNR2_O_055943_1] GT 5.0), count) ;53
PRINT, SIZE(num7_five)
num7_ten = WHERE((SNR_O_055943_1[SNR2_O_055943_1] GT 10.0), count) ;24
PRINT, SIZE(num7_ten)
num7_twenty = WHERE((SNR_O_055943_1[SNR2_O_055943_1] GT 20.0), count) ;4
PRINT, SIZE(num7_twenty)
num7_forty = WHERE((SNR_O_055943_1[SNR2_O_055943_1] GT 40.0), count) ;0
PRINT, SIZE(num7_forty)

;restore 055943_2 TIIs, SNRs, etc.

rfname8 = '~/Desktop/amandabacon/11850/sigma_coeff_arr_055943_2_Oiv.sav'
RESTORE, rfname8

PRINT, SIZE(SNR_O_055943_2[SNR2_O_055943_2]) ;195
eight = SNR_O_055943_2[SNR2_O_055943_2]

num8_three = WHERE((SNR_O_055943_2[SNR2_O_055943_2] GT 3.0), count) ;41
PRINT, SIZE(num8_three)
num8_five = WHERE((SNR_O_055943_2[SNR2_O_055943_2] GT 5.0), count) ;7
PRINT, SIZE(num8_five)
num8_ten = WHERE((SNR_O_055943_2[SNR2_O_055943_2] GT 10.0), count) ;0
PRINT, SIZE(num8_ten)
num8_twenty = WHERE((SNR_O_055943_2[SNR2_O_055943_2] GT 20.0), count) ;0
PRINT, SIZE(num8_twenty)
num8_forty = WHERE((SNR_O_055943_2[SNR2_O_055943_2] GT 40.0), count) ;0
PRINT, SIZE(num8_forty)

;restore 20130926_110943 TIIs, SNRs, etc.

rfname9 = '~/Desktop/amandabacon/11850/sigma_coeff_arr_20130926_110943_Oiv.sav'
RESTORE, rfname9

PRINT, SIZE(SNR_O_20130926_110943[SNR2_O_20130926_110943]) ;123
nine = SNR_O_20130926_110943[SNR2_O_20130926_110943]

num9_three = WHERE((SNR_O_20130926_110943[SNR2_O_20130926_110943] GT 3.0), count) ;10
PRINT, SIZE(num9_three)
num9_five = WHERE((SNR_O_20130926_110943[SNR2_O_20130926_110943] GT 5.0), count) ;1
PRINT, SIZE(num9_five)
num9_ten = WHERE((SNR_O_20130926_110943[SNR2_O_20130926_110943] GT 10.0), count) ;0
PRINT, SIZE(num9_ten)
num9_twenty = WHERE((SNR_O_20130926_110943[SNR2_O_20130926_110943] GT 20.0), count) ;0
PRINT, SIZE(num9_twenty)
num9_forty = WHERE((SNR_O_20130926_110943[SNR2_O_20130926_110943] GT 40.0), count) ;0
PRINT, SIZE(num9_forty)

;restore 052432 TIIs, SNRs, etc.

rfname10 = '~/Desktop/amandabacon/11850/sigma_coeff_arr_052432_Oiv.sav'
RESTORE, rfname10

PRINT, SIZE(SNR_O_052432[SNR2_O_052432]) ;362
ten = SNR_O_052432[SNR2_O_052432]

num10_three = WHERE((SNR_O_052432[SNR2_O_052432] GT 3.0), count) ;151
PRINT, SIZE(num10_three)
num10_five = WHERE((SNR_O_052432[SNR2_O_052432] GT 5.0), count) ;85
PRINT, SIZE(num10_five)
num10_ten = WHERE((SNR_O_052432[SNR2_O_052432] GT 10.0), count) ;21
PRINT, SIZE(num10_ten)
num10_twenty = WHERE((SNR_O_052432[SNR2_O_052432] GT 20.0), count) ;4
PRINT, SIZE(num10_twenty)
num10_forty = WHERE((SNR_O_052432[SNR2_O_052432] GT 40.0), count) ;0
PRINT, SIZE(num10_forty)

;restore 062443 TIIs, SNRs, etc.

rfname11 = '~/Desktop/amandabacon/11850/sigma_coeff_arr_062443_Oiv.sav'
RESTORE, rfname11

PRINT, SIZE(SNR_O_062443[SNR2_O_062443]) ;275
eleven = SNR_O_062443[SNR2_O_062443]

num11_three = WHERE((SNR_O_062443[SNR2_O_062443] GT 3.0), count) ;35
PRINT, SIZE(num11_three)
num11_five = WHERE((SNR_O_062443[SNR2_O_062443] GT 5.0), count) ;4
PRINT, SIZE(num11_five)
num11_ten = WHERE((SNR_O_062443[SNR2_O_062443] GT 10.0), count) ;0
PRINT, SIZE(num11_ten)
num11_twenty = WHERE((SNR_O_062443[SNR2_O_062443] GT 20.0), count) ;0
PRINT, SIZE(num11_twenty)
num11_forty = WHERE((SNR_O_062443[SNR2_O_062443] GT 40.0), count) ;0
PRINT, SIZE(num11_forty)

total_SNR = [one,two,three,four,five,six,seven,eight,nine,ten,eleven]
PRINT, SIZE(total_SNR) ;3700

PRINT, N_ELEMENTS(WHERE((total_SNR GT 3.00), count)) ;1244
;t = WHERE((total_SNR GT 3.00), count)
;PRINT, total_SNR[t]
;PRINT, 'sep'
PRINT, N_ELEMENTS(WHERE((total_SNR GT 5.00), count)) ;571
PRINT, N_ELEMENTS(WHERE((total_SNR GT 10.00), count)) ;164
PRINT, N_ELEMENTS(WHERE((total_SNR GT 20.00), count)) ;11
;t2 = WHERE((total_SNR GT 20.00), count)
;PRINT, total_SNR[t2]
PRINT, N_ELEMENTS(WHERE((total_SNR GT 40.00), count, /NULL)) ;0

rfnamee = '~/Desktop/amandabacon/11850/all_vars.sav'
RESTORE, rfnamee

;master histogram log

SNR_hist = HISTOGRAM(total_SNR, BINSIZE = 0.5, LOCATIONS = x_hist)

;save as ps

!P.FONT = 1

TVLCT, [[0],[0],[0]], 1
SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 8.8, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '~/Desktop/amandabacon/11850/master_histogram.eps', /ENCAPSULATED

SNR_hist = HISTOGRAM(total_SNR, BINSIZE = 0.5, LOCATIONS = x_hist)
PLOT, x_hist, SNR_hist, PSYM = 10, XTITLE = "Signal-to-Noise", YTITLE = "Frequency", TITLE = "Master Histogram of Signal-to-Noise of AR11850", /YLOG, YRANGE = [1.0e-1,1.0e4], POSITION = [x0,y0,x0+dx,y0+dy], COLOR = 1, XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, XSTYLE = 1, THICK = 10, XTHICK = 10, YTHICK = 10

DEVICE, /CLOSE

;percentage frequency of SNRs

cumul_arr = DBLARR(61)

snr_val = -0.5

FOR i = 0, 60 DO BEGIN
	snr_val = snr_val + 0.5
	nsnr_arr = WHERE((total_SNR GE snr_val), count)
	cumul_arr[i] = count
ENDFOR

percent_arr = cumul_arr/N_ELEMENTS(total_SNR)*100

x_arr = DINDGEN(60)*0.5

PLOT, x_arr, percent_arr

;save as ps

!P.FONT = 1

TVLCT, [[0],[0],[0]], 1
SET_PLOT, 'ps'
DEVICE, XSIZE = 15, YSIZE = 10, /INCHES, COLOR = 1, BITS_PER_PIXEL = 8, SET_FONT = 'TIMES', /TT_FONT, FILENAME = '~/Desktop/amandabacon/11850/freq_histogram.eps', /ENCAPSULATED

PLOT, x_arr, percent_arr, XTITLE = "Minimum Signal-to-Noise", YTITLE = "Frequency of SNR greater than or equal to Minimum", COLOR = 1, POSITION = [x0,y0,x0+dx,y0+dy], XCHARSIZE = 1.5, YCHARSIZE = 1.5, CHARSIZE = 1.5, XSTYLE = 1, THICK = 10, XTHICK = 10, YTHICK = 10, CHARTHICK = 5
TVLCT, r, g, b, /GET
tvlct, r[0], g[0], b[255]
PLOTS, [3.0,3.0], !Y.CRANGE, THICK = 10, LINESTYLE = 0

DEVICE, /CLOSE

;destroy all evidence

OBJ_DESTROY, dataRast
OBJ_DESTROY, data1400

END
