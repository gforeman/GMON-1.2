10 	! see line 8332 brk
20 	! bug in mikro abs,y mode thinks
30 	! it's ok in zero page !!!
40 	!
100 	*               =	$c000
110 	!
130 	chrin           =	$ffcf
140 	buffer          =	$0200
150 	kerload         =	$ffd5
160 	kersave         =	$ffd8
190 	temp            =	$f7
200 	temp1           =	$f9
210 	stopkey         =	$ffe1
220 	getkey          =	$ffe4
230 	upclock         =	$ffea
240 	byte            =	$19
250 	numbytes        =	$1a
260 	mode            =	$1b
270 	regs            =	$0240
280 	warmstart       =	$a002
290 	breakvec        =	$0316
300 	regs1           =	regs+2
310 	temp2           =	$14
320 	hbuffer         =	$0228
330 	ysave           =	$1e
340 	optemp          =	$20
350 	caltemp         =	$1f
360 	astemp          =	$26
370 	astemp1         =	$28
380 	ntemp           =	$248
390 	overtop         =	$1c
400 	nat             =	$247
410 	ciout           =	$ffa8
420 	listen          =	$ffb1
430 	close           =	$ffc3
440 	sendchr         =	$ffd2
450 	chkout          =	$ffc9
460 	open            =	$ffc0
470 	clrchn          =	$ffcc
480 	linnum          =	$bdcd
490 	second          =	$ff93
500 	clall           =	$ffe7
510 	shift           =	$028d
520 	st              =	$90
530 	setnam          =	$ffbd
540 	setlfs          =	$ffba
550 	chkin           =	$ffc6
560 	talk            =	$ffb4
570 	unlsn           =	$ffae
580 	tksa            =	$ff96
590 	acptr           =	$ffa5
600 	untlk           =	$ffab
610 	tracknum        =	optemp
620 	secnum          =	optemp+1
630 	track           =	$0207
640 	sector          =	$020a
650 	eos             =	$f642
660 	storeof1        =	$249
990 	!
1000 	                lda breaklo
1010 	                sta breakvec
1020 	                lda breakhi
1030 	                sta breakvec+1
1040 	                lda #$80
1050 	                sta $9d
1060 	break1          brk
1070 	break           cld
1080 	                pla
1090 	                sta regs+5
1100 	                pla
1110 	                sta regs+4
1120 	                pla
1130 	                sta regs+3
1140 	                pla
1150 	                sta regs+2
1160 	                pla
1170 	                adc #$ff
1180 	                sta regs+1
1190 	                pla
1200 	                adc #$ff
1210 	                sta regs
1220 	!
1230 	                lda $01
1240 	                sta storeof1
1250 	                lda #$37
1260 	                sta $01
1270 	                tsx
1280 	                stx regs+6
1290 	                ldx #0
1300 	ll0             lda title,x 
1310 	                beq ll1
1320 	                jsr chrout
1330 	                inx
1340 	                bne ll0
1350 	ll1             lda #$52 
1360 	                bne command
1370 	start           ldx #$0d 
1380 	                lda #$2e
1390 	                jsr prxta
1392 	                lda #60
1394 	                sta $dc05
1396 	                lda $08
1398 	                sta $07
1400 	                jsr inputline
1410 	assmore         jsr scandot 
1420 	                jsr scanspaces
1430 	                lda buffer,x
1440 	command         ldy #caddr-clist 
1450 	ll2             cmp clist,y 
1460 	                beq foundcmd
1470 	                dey
1480 	                bpl ll2
1490 	                jmp question
1500 	foundcmd        inx
1510 	                tya
1520 	                asl a
1530 	                tay
1540 	                lda caddr+1,y
1550 	                pha
1560 	                lda caddr,y
1570 	                pha
1580 	                rts
1590 	!
1592 	regaddr         lda #>regs1 
1594 	                sta temp
1596 	                lda #<regs1
1598 	                sta temp+1
1600 	                lda #5
1601 	                bcc reghere
1602 	                byt $2c
1604 	pr8bytes        lda #8 
1610 	prbytes         sta numbytes 
1620 	                ldy #0
1630 	ll3             jsr space 
1640 	                jsr peek
1650 	                jsr prbyte
1660 	                jsr inctemp
1670 	                dec numbytes
1680 	                bne ll3
1690 	reghere         rts
1700 	!
1710 	question        ldx regs+6 
1720 	                txs
1730 	                ldx #$20
1740 	                lda #$3f
1750 	                jsr prxta
1760 	                jmp start
1770 	!
1772 	inctemp2        jsr inctemp 
1780 	inctemp         inc temp 
1790 	                bne ll4
1800 	                inc temp+1
1802 	                bne ll4
1804 	                inc overtop
1810 	ll4             rts
1820 	!
1830 	inputline       ldy #0 
1840 	inline          jsr chrin 
1850 	assin           cmp #13 
1860 	                beq retchar
1870 	                sta buffer,y
1880 	                iny
1890 	                cpy #64
1900 	                bne inline
1910 	retchar         lda #0 
1920 	                sta buffer,y
1922 	                sta overtop
1930 	                rts
1940 	!
1950 	scandot         ldx #0 
1960 	                lda buffer,x
1970 	                cmp #$2e
1980 	                bne nodot
1990 	                inx
2000 	nodot           rts
2010 	!
2092 	hexaddr         lda temp+1 
2094 	                jsr prbyte
2096 	                lda temp
2098 	!
2100 	prbyte          pha
2110 	                lsr a
2120 	                lsr a
2130 	                lsr a
2140 	                lsr a
2150 	                jsr prby
2160 	                pla
2170 	                and #15
2180 	prby            tax
2190 	                lda hexT,x
2200 	                jmp chrout
2210 	!
2220 	gbyte           lda buffer,x 
2230 	                ldy #0
2240 	ll5             cmp hexT,y 
2250 	                beq gbout
2260 	                iny
2270 	                cpy #16
2280 	                bne ll5
2290 	                jmp question
2300 	gbout           tya
2310 	                rts
2320 	!
2330 	getbyte         jsr scanspaces 
2332 	getbyte1        jsr gbyte 
2340 	                asl a
2350 	                asl a
2360 	                asl a
2370 	                asl a
2380 	                sta byte
2390 	                inx
2400 	                jsr gbyte
2410 	                ora byte
2412 	                inx
2420 	                rts
2430 	!
2440 	getaddr         jsr getbyte 
2450 	                sta temp+1
2460 	                jsr getbyte
2470 	                sta temp
2472 	scanspaces      lda buffer,x 
2474 	                cmp #$20
2476 	                bne nospace
2478 	                inx
2480 	                cpx #64
2482 	                bne scanspaces
2484 	nospace         rts
2490 	!
2500 	prtdty          tya
2510 	                pha
2520 	                jsr ret
2530 	                pla
2540 	                ldx #$2e
2550 	prxta           pha
2560 	                txa
2570 	                jsr chrout
2580 	                pla
2590 	                jmp chrout
2600 	!
2610 	!
2620 	registers       ldx #0 
2630 	ll6             lda regchars,x 
2640 	                beq ll7
2650 	                jsr chrout
2660 	                inx
2670 	                bne ll6
2680 	ll7             ldy #$3b 
2690 	                jsr prtdty
2700 	                lda regs+0
2710 	                jsr prbyte
2720 	                lda regs+1
2730 	                jsr prbyte
2740 	                sec
2750 	                jsr regaddr
2760 	                jmp start
2770 	!
2960 	memory          jsr get2addrs 
3120 	mem3            jsr showbytes 
3130 	!
3140 	                jsr getkey
3150 	                beq ll10
3160 	ll11            jsr getkey 
3170 	                beq ll11
3180 	ll10            jsr upclock 
3190 	                jsr stopkey
3200 	                beq memout
3210 	                jsr checkless
3250 	                bcs mem3
3252 	memout          lda #0 
3260 	                sta 212
3262 	!
3264 	                jsr crsrup
3266 	                jmp start
3268 	!
3270 	showbytes       ldy #$3a 
3280 	                jsr prtdty
3290 	                jsr copytemp
3300 	                jsr hexaddr
3310 	                jsr pr8bytes
3320 	                lda #$27
3330 	                jsr chrout
3340 	                ldy #0
3350 	ll8             jsr peek2 
3360 	                and #$7f
3370 	                cmp #$20
3380 	                bcs ll9
3390 	                ora #$40
3400 	ll9             jsr chrout 
3410 	                iny
3420 	                cpy #8
3430 	                bne ll8
3440 	                rts
3500 	!
3510 	swaptemps       txa
3512 	                pha
3514 	                ldx #1
3520 	swap1           lda temp,x 
3530 	                pha
3540 	                lda temp1,x
3550 	                sta temp,x
3560 	                pla
3570 	                sta temp1,x
3580 	                dex
3590 	                bpl swap1
3592 	                pla
3594 	                tax
3600 	                rts
3610 	!
3620 	copytemp        lda temp 
3630 	                sta temp2
3640 	                lda temp+1
3650 	                sta temp2+1
3660 	                rts
3670 	!
3680 	exit            ldx regs+6 
3690 	                txs
3700 	                lda #$37
3710 	                sta $01
3720 	                jmp (warmstart)
3730 	!
3740 	modregs         jsr getaddr 
3750 	                jsr setregs
3752 	                clc
3760 	                jsr regaddr
3770 	                bne mbyte1
3780 	modify          jsr getaddr 
3790 	                lda #8
3800 	mbyte1          sta numbytes 
3810 	                sta mode
3812 	                jsr copytemp
3814 	domod           jsr enterbytes 
3816 	                lda mode
3820 	                cmp #5
3830 	                beq exitmod
3850 	                jsr crsrup
3852 	                jsr tempcopy
3860 	                jsr showbytes
3870 	exitmod         jmp start 
3880 	!
3890 	enterbytes      jsr getbyte 
3910 	                ldy #0
3920 	                jsr poke
3930 	                jsr inctemp
3940 	                dec numbytes
3950 	                bne enterbytes
3960 	                rts
3970 	!
3980 	setregs         lda temp 
3990 	                sta regs+1
4000 	                lda temp+1
4010 	                sta regs
4020 	                rts
4030 	!
4040 	tempcopy        lda temp2 
4050 	                sta temp
4060 	                lda temp2+1
4070 	                sta temp+1
4080 	                rts
4090 	!
4092 	jay             lda #$00 
4094 	                byt $2c
4096 	go              lda #$ff 
4098 	                sta caltemp
4100 	                jsr scanspaces
4110 	                lda buffer,x
4120 	                beq go1
4130 	                jsr getaddr
4140 	                jsr setregs
4150 	go1             ldx regs+6 
4152 	                txs
4154 	                lda caltemp
4156 	                bmi go2
4160 	                lda breakhi1
4162 	                pha
4164 	                lda breaklo1
4166 	                pha
4170 	go2             sei
4180 	                lda regs
4190 	                pha
4200 	                lda regs+1
4210 	                pha
4220 	                lda regs+2
4230 	                pha
4232 	                lda storeof1
4234 	                sta $01
4240 	                lda regs+3
4250 	                ldx regs+4
4260 	                ldy regs+5
4270 	                rti
4280 	!
4300 	transfer        jsr get2addrs 
4310 	                jsr swaptemps
4350 	                jsr copytemp
4370 	                jsr getaddr
4380 	                jsr swaptemps
4386 	!
4390 	                ldy #0
4400 	tran            jsr peek 
4410 	                jsr poke1
4420 	                lda temp2+1
4430 	                cmp temp+1
4432 	                bne there
4440 	                lda temp2
4450 	                cmp temp
4460 	                beq trout
4470 	there           jsr inctemp 
4480 	                jsr inctemp1
4490 	                bcs tran
4492 	trout           jmp start 
4500 	!
4510 	inctemp1        inc temp1 
4520 	                bne temp1ret
4530 	                inc temp1+1
4540 	temp1ret        rts
4550 	!
4560 	fill            jsr get2addrs 
4630 	                jsr getbyte
4640 	                sta mode
4660 	                ldy #0
4670 	loopfill        lda mode 
4680 	                jsr poke
4690 	                jsr checkfin
4730 	                beq trout
4740 	                jsr inctemp
4750 	                bcs loopfill
4760 	!
4770 	checkfin        lda temp1+1 
4772 	                cmp temp+1
4774 	                bne cout
4776 	                lda temp1
4778 	                cmp temp
4780 	cout            rts
4782 	!
4790 	checkless       lda temp1 
4792 	                cmp temp
4794 	                lda temp1+1
4796 	                sbc temp+1
4798 	                rts
4820 	!
4830 	hunt            jsr get2addrs 
4910 	                cmp #$27
4920 	                bne huntbytes
4930 	                inx
4940 	                ldy #0
4950 	ll12            lda buffer,x 
4960 	beq             ll16 ! ll13 
4970 	                sta hbuffer,y
4980 	                inx
4990 	                iny
5000 	                cpy #20
5010 	                bne ll12
5020 	                beq ll16
5030 	huntbytes       ldy #0 
5040 	ll14            sty ysave 
5050 	                jsr getbyte
5060 	                ldy ysave
5070 	                sta hbuffer,y
5090 	                lda buffer,x
5100 	                beq ll13
5120 	                iny
5130 	                cpy #20
5140 	                bne ll14
5150 	ll16            dey
5160 	!
5170 	ll13            sty numbytes 
5200 	                jsr ret
5210 	hloop           ldx #0 
5220 	                ldy #0
5230 	match           jsr peek 
5240 	                cmp hbuffer,x
5250 	                bne ll15
5260 	                cpx numbytes
5262 	                beq haddr
5270 	                iny
5280 	                inx
5290 	                bne match
5292 	                beq hout
5300 	haddr           jsr hsaddr 
5320 	ll15            jsr checkfin 
5330 	                beq hout
5340 	                jsr inctemp
5342 	                bne hloop
5350 	hout            jmp start 
5360 	!
5370 	get2addrs       jsr getaddr 
5390 	                jsr swaptemps
5392 	                lda buffer,x
5394 	                bne adr1
5396 	                lda #$ff
5398 	                sta temp
5400 	                sta temp+1
5402 	                bne adr2
5410 	adr1            jsr getaddr 
5420 	adr2            jsr swaptemps 
5430 	                jmp scanspaces
5440 	!
5500 	propcode        tay
5510 	                lda opcodeb,y
5520 	                sta optemp
5530 	                lda opcodea,y
5540 	                sta optemp+1
5550 	prop1           lda #0 
5560 	                ldy #5
5570 	prop2           asl optemp+1 
5500 	                rol optemp
5590 	                rol a
5600 	                dey
5610 	                bne prop2
5620 	                adc #$3f
5630 	                jsr chrout
5640 	                dex
5650 	                bne prop1
5660 	space           lda #$20 
5670 	                byt $2c
5680 	ret             lda #$0d 
5682 	                byt $2c
5684 	crsrup          lda #$91 
5690 	                jmp chrout
5700 	!
5710 	decodeop        pha
5720 	                pha
5730 	                and #$f0
5740 	                lsr a
5750 	                lsr a
5760 	                lsr a
5770 	                tax
5780 	                lda modep,x
5790 	                sta optemp
5792 	                inx
5800 	                lda modep,x
5810 	                sta optemp+1
5820 	                pla
5830 	                and #15
5840 	                tay
5850 	                lda (optemp),y
5860 	                sta mode
5870 	                and #3
5880 	                sta numbytes
5890 	                pla
5900 	                tay
5910 	                lda opnum,y
5912 	                ldy #0
5920 	pran2           rts
5930 	!
5940 	pran28          cmp optemp 
5950 	                beq pran2
5960 	                jmp chrout
5970 	!
5980 	!
6000 	disaline        ldy #$2c 
6010 	disline         jsr prtdty 
6020 	                jsr space
6030 	                jsr hsaddr
6050 	                ldy #0
6060 	                jsr peek
6070 	                jsr decodeop
6080 	                pha
6090 	                jsr disbytes
6100 	                pla
6110 	                jsr propcode
6120 	                ldx #6
6130 	dis1            cpx #3 
6140 	                bne dis3
6150 	                ldy numbytes
6160 	                beq dis3
6170 	dis2            lda mode 
6180 	                cmp #$e8
6190 	                jsr peek
6200 	                bcs calcaddr
6210 	                jsr calcad2
6220 	                dey
6230 	                bne dis2
6240 	dis3            asl mode 
6250 	                bcc dis4
6260 	                lda moreinfa,x
6270 	                jsr pran28
6280 	                lda moreinfb,x
6290 	                beq dis4
6300 	                jsr pran28
6310 	dis4            dex
6320 	                bne dis1
6322 	!
6324 	                ldx $d3
6326 	dis5            cpx #39 
6328 	                beq disexit
6330 	                jsr space
6332 	                inx
6334 	                bne dis5
6336 	disexit         rts
6340 	!
6350 	calcaddr        jsr calcad3 
6360 	                tax
6370 	                inx
6380 	                bne calcad1
6390 	                iny
6400 	calcad1         tya
6410 	                jsr calcad2
6420 	                txa
6430 	calcad2         stx caltemp 
6440 	                jsr prbyte
6450 	                ldx caltemp
6460 	                rts
6470 	calcad5         lda numbytes 
6480 	                sec
6490 	calcad3         ldy temp+1 
6500 	                tax
6510 	                bpl calcad4
6520 	                dey
6530 	calcad4         adc temp 
6540 	                bcc calcad6
6550 	                iny
6560 	calcad6         rts
6570 	!
6630 	disbytes        jsr peek 
6640 	                jsr prbyte
6650 	                ldx #1
6660 	db1             jsr space 
6662 	                dex
6664 	                bne db1
6670 	                cpy numbytes
6680 	                iny
6690 	                bcc disbytes
6700 	                ldx #3
6710 	                cpy #4
6720 	                bcc db1
6730 	                rts
6740 	!
6750 	disassemble     jsr get2addrs 
6760 	                ldx #0
6770 	                stx caltemp
6780 	dli             jsr disaline 
6790 	                jsr calcad5
6800 	                sta temp
6810 	                sty temp+1
6820 	                jsr getkey
6830 	                beq dli1
6840 	dli2            jsr getkey 
6850 	                beq dli2
6860 	dli1            jsr upclock 
6870 	                jsr stopkey
6880 	                beq dlout
6890 	                jsr checkless
6900 	                bcs dli
6910 	dlout           jmp start 
6920 	!
7000 	moddis          jsr dismod 
7160 	                jsr crsrup
7170 	                jsr disaline
7180 	                jmp start
7190 	!
7200 	assemble        jsr dismod 
7210 	                jsr swaptemps
7220 	                lda #0
7230 	                sta hbuffer+1
7240 	                jsr scanspaces
7250 	                ldy #3
7260 	ass1            lda buffer,x 
7270 	                pha
7272 	                inx
7280 	                dey
7290 	                bne ass1
7300 	                stx ysave
7310 	                ldx #3
7320 	ass2            pla
7330 	                sec
7340 	                sbc #$3f
7350 	                ldy #5
7360 	ass3            lsr a 
7370 	                ror hbuffer+1
7380 	                ror hbuffer
7390 	                dey
7400 	                bne ass3
7410 	                dex
7420 	                bne ass2
7430 	!
7432 	                ldx ysave
7440 	                ldy #2
7442 	                jsr scanspaces
7444 	                dex
7445 	                sec
7446 	                php
7448 	ass4            plp
7450 	                bcc ass41
7452 	ass40           inx
7454 	ass41           lda buffer,x 
7460 	                beq ass6
7462 	                cmp #$3a
7464 	                beq ass6
7470 	                cmp #$20
7480 	                beq ass40
7510 	                jsr checkrange
7512 	                php
7520 	                bcs ass5
7530 	                sty ysave
7540 	                jsr getbyte1
7550 	                ldy temp
7560 	                sty temp+1
7570 	                sta temp
7580 	                ldy ysave
7590 	                lda #$30
7600 	                sta hbuffer,y
7610 	                iny
7620 	ass5            sta hbuffer,y 
7630 	                iny
7640 	                bne ass4
7650 	!
7660 	ass6            sty temp2+1 
7670 	                lda #0
7672 	                sta hbuffer,y
7680 	                sta temp2
7690 	                beq ass7
7700 	ass8            inc temp2 
7710 	                beq aserror
7720 	ass7            ldx #0 
7730 	                stx astemp+1
7740 	                lda temp2
7750 	                jsr decodeop
7760 	                ldx mode
7770 	                stx astemp
7780 	                tax
7790 	                ldy opcodeb,x
7800 	                lda opcodea,x
7810 	                jsr chvalid1
7820 	                bne ass8
7830 	                ldx #6
7840 	ass14           cpx #3 
7850 	                bne ass10
7860 	                ldy numbytes
7870 	                beq ass10
7880 	ass12           lda mode 
7890 	                cmp #$e8
7900 	                lda #$30
7910 	                bcs ass11
7920 	                jsr chvalid2
7930 	                bne ass8
7940 	                jsr chvalid3
7950 	                bne ass8
7960 	                dey
7970 	                bne ass12
7980 	ass10           asl mode 
7990 	                bcc ass13
8000 	                ldy moreinfb,x
8010 	                lda moreinfa,x
8020 	                jsr chvalid1
8030 	                bne ass8
8040 	ass13           dex
8050 	                bne ass14
8060 	                beq ass15
8070 	ass11           jsr chvalid 
8080 	                bne ass8
8090 	                jsr chvalid
8100 	                bne ass8
8110 	ass15           lda temp2+1 
8120 	                cmp astemp+1
8130 	                bne ass8
8140 	                jsr swaptemps
8150 	                ldy numbytes
8160 	                beq ass16
8170 	                lda astemp
8180 	                cmp #$9d
8190 	                bne ass17
8200 	                jsr asaddr
8210 	                bcc ass18
8220 	                tya
8230 	                bne aserror
8240 	                lda astemp1
8250 	                bpl ass19
8260 	aserror         jmp question 
8270 	ass18           iny
8280 	                bne aserror
8290 	                lda astemp1
8300 	                bpl aserror
8310 	ass19           ldy numbytes 
8320 	                bne ass20
8330 	ass17           lda temp+1,y 
8332 	                brk
8340 	ass20           jsr poke 
8350 	                dey
8360 	                bne ass17
8370 	ass16           lda temp2 
8380 	                jsr poke
8382 	                jsr copytemp
8390 	                jsr calcad5
8400 	                pha
8410 	                tya
8412 	                pha
8416 	                jsr crsrup
8417 	                ldy #$41
8418 	                jsr disline
8420 	                pla
8422 	                sta temp+1
8424 	                pla
8426 	                sta temp
8428 	                ldy #$41
8430 	                sty buffer
8432 	                jsr prtdty
8434 	                jsr space
8436 	                jsr hsaddr
8438 	                lda temp+1
8440 	                jsr assval
8442 	                stx buffer+2
8444 	                sta buffer+3
8446 	                lda temp
8448 	                jsr assval
8450 	                stx buffer+4
8452 	                sta buffer+5
8454 	                lda #$20
8456 	                sta buffer+1
8458 	                sta buffer+6
8460 	                jsr chrin
8461 	                cmp #$2e
8462 	                bne assok
8463 	                ldy #0
8464 	                byt $2c
8465 	assok           ldy #7 
8466 	                jsr assin
8467 	                jmp assmore
8468 	assval          pha
8470 	                lsr a
8472 	                lsr a
8474 	                lsr a
8476 	                lsr a
8478 	                jsr asval1
8480 	                tax
8482 	                pla
8484 	                and #15
8486 	asval1          clc
8488 	                adc #$f6
8490 	                bcc asval2
8492 	                adc #6
8494 	asval2          adc #$3a 
8496 	                rts
8498 	!
8500 	chvalid         tay
8502 	chvalid1        jsr chvalid2 
8510 	                bne chvalid4
8520 	                tya
8530 	chvalid2        beq chvalid4 
8540 	chvalid3        stx astemp1+1 
8550 	                ldx astemp+1
8560 	                cmp hbuffer,x
8570 	                php
8580 	                inx
8590 	                stx astemp+1
8600 	                ldx astemp1+1
8610 	                plp
8620 	chvalid4        rts
8630 	!
8640 	checkrange      cmp #$30 
8650 	                bcc chranout
8660 	                cmp #$47
8670 	                rts
8680 	chranout        sec
8690 	                rts
8700 	!
8710 	asaddr          lda temp1 
8720 	                ldy temp1+1
8730 	                sec
8740 	                sbc #2
8750 	                bcs asad1
8760 	                dey
8770 	asad1           sec
8780 	                sbc temp
8790 	                sta astemp1
8800 	                tya
8810 	                sbc temp+1
8820 	                tay
8830 	                ora astemp1
8840 	                rts
8850 	!
8860 	dismod          jsr getaddr 
8870 	                ldy #0
8880 	dm1             sty temp2 
8890 	                lda buffer,x
8900 	                jsr checkrange
8910 	                bcs dm2
8912 	                lda buffer+2,x
8914 	                cmp #$20
8916 	                bne dm2
8920 	                jsr getbyte
8930 	                ldy temp2
8940 	                jsr poke
8950 	                inx
8960 	                lda buffer,x
8970 	                iny
8980 	                cpy #3
8990 	                beq dm2
9000 	                cmp #$20
9010 	                bne dm1
9020 	dm2             rts
9030 	!
9040 	ioparams        ldy #1 
9050 	                sty $ba
9060 	                sty $b9
9070 	                dey
9080 	                sty $b7
9090 	                lda #>hbuffer
9100 	                sta $bb
9110 	                lda #<hbuffer
9120 	                sta $bc
9130 	                jsr scanspaces
9140 	                lda buffer,x
9150 	                beq noname
9160 	                cmp #$22
9170 	                bne ioerror
9180 	iolbl1          inx
9190 	                lda buffer,x
9200 	                beq iofinname
9210 	                cmp #$22
9220 	                beq iofin1
9230 	                sta ($bb),y
9240 	                iny
9250 	                cpy #16
9260 	                bne iolbl1
9270 	ioerror         jmp question 
9272 	iofin1          inx
9280 	iofinname       sty $b7 
9290 	                jsr scanspaces
9300 	                jsr crange
9340 	                jsr getbyte
9350 	                and #15
9360 	                cmp #3
9370 	                beq ioerror
9380 	                sta $ba
9390 	                lda buffer,x
9400 	noname          rts
9410 	!
9412 	verify          lda #1 
9414 	                byt $2c
9416 	load            lda #0 
9418 	                sta $93
9420 	                jsr ioparams
9430 	                beq defload
9432 	                dec $b9
9460 	                inx
9470 	                jsr getaddr
9480 	defload         lda $ba 
9482 	                cmp #1
9484 	                bne defl1
9486 	                jmp tload
9488 	defl1           ldx temp 
9490 	                ldy temp+1
9500 	                lda $93
9510 	                jsr kerload
9520 	tload1          lda st 
9530 	                and #16
9540 	                bne ioerror
9542 	                jsr ret
9544 	                ldx #$4f
9546 	                lda #$4b
9548 	                jsr prxta
9550 	                jmp start
9560 	!
9570 	save            jsr ioparams 
9580 	save0           beq ioerror 
9610 	                jsr crange
9620 	                jsr getaddr
9630 	                jsr crange
9670 	                jsr swaptemps
9680 	                jsr getaddr
9690 	                lda buffer,x
9700 	                beq specnorm
9710 	                jsr crange
9740 	                lda $ba
9742 	                beq save0
9750 	                cmp #3
9760 	                bcc normalsave
9762 	                jsr copytemp
9764 	                jsr getaddr
9766 	                jsr swaptemps
9768 	                jsr scheck
9770 	                bcc specsave
9772 	                jsr ssave
9774 	firstblood      jmp start 
9776 	!
9778 	specnorm        jsr swaptemps 
9780 	                jsr scheck
9782 	                bcs nsave1
9784 	                jsr swaptemps
9786 	                jsr copytemp
9788 	                jsr rambo
9790 	!
9792 	!
9794 	specsave        jsr stortemps 
9796 	                jsr swapmem1
9798 	                jsr resttemps
9800 	                jsr snsubr
9802 	!
9804 	                jsr swapmem2
9806 	                bne firstblood
9808 	!
9810 	snsubr          sec
9812 	                lda temp+1
9814 	                sbc #$a0
9816 	                sta temp+1
9818 	                sec
9820 	                lda temp2+1
9822 	                sbc #$a0
9824 	                sta temp2+1
9826 	!
9850 	ssave           lda #$61 
9852 	                sta $b9
9854 	                ldy $b7
9856 	                beq save0
9858 	                jsr $f3d5
9860 	                jsr $f68f
9862 	                lda $ba
9870 	                jsr listen
9880 	                lda $b9
9890 	                jsr second
9892 	                lda temp2
9894 	                sta $ae
9896 	                lda temp2+1
9898 	                sta $af
9900 	                lda temp
9902 	                sta $ac
9904 	                lda temp+1
9906 	                sta $ad
9910 	                lda temp1
9920 	                jsr ciout
9930 	                lda temp1+1
9950 	                ldy #0
9960 	                jmp $f621
9970 	!
9980 	nsave1          jsr swaptemps 
9982 	normalsave      jsr ret 
9984 	                ldx temp
9986 	                ldy temp+1
9988 	                lda #>temp1
9989 	                dec $01
9990 	                jsr kersave
9991 	                inc $01
9992 	                jmp start
9994 	!
10000 	rambo           lda temp1 
10002 	                sta temp
10004 	                lda temp1+1
10006 	                sta temp+1
10008 	!rts
10010 	crange          jsr checkrange 
10012 	                bcc cran1
10014 	                inx
10016 	cran1           rts
10030 	!
10032 	stortemps       lda temp 
10033 	                sta buffer
10034 	                lda temp+1
10035 	                sta buffer+1
10036 	                lda temp1
10037 	                sta buffer+2
10038 	                lda temp1+1
10039 	                sta buffer+3
10040 	                rts
10041 	resttemps       lda buffer 
10042 	                sta temp
10043 	                lda buffer+1
10044 	                sta temp+1
10045 	                lda buffer+2
10046 	                sta temp1
10047 	                lda buffer+3
10048 	                sta temp1+1
10049 	                rts
10050 	swaptemp1       txa
10060 	                pha
10070 	                ldx #3
10080 	swap2           lda temp,x 
10090 	                pha
10100 	                lda astemp,x
10110 	                sta temp,x
10120 	                pla
10130 	                sta astemp,x
10140 	                dex
10150 	                bpl swap2
10160 	                pla
10170 	                tax
10180 	                rts
10182 	!
10190 	scheck          lda #$ff 
10192 	                cmp temp
10194 	                lda #$cf
10196 	                sbc temp+1
10198 	                rts
10200 	!
10210 	checknrange     pha
10212 	                sta nat
10220 	                sec
10230 	                sbc astemp
10240 	                txa
10250 	                sbc astemp+1
10260 	                bcc cnr1
10270 	                lda astemp1
10280 	                sbc nat
10290 	                stx nat
10300 	                lda astemp1+1
10310 	                sbc nat
10320 	cnr1            pla
10330 	                rts
10340 	!
10350 	locate1         clc
10360 	                jsr peek
10370 	                pha
10380 	                jsr inctemp2
10390 	                ldx temp+1
10400 	                pla
10410 	                bpl loct1
10420 	                dex
10430 	loct1           adc temp 
10440 	                bcc loct2
10450 	                inx
10460 	loct2           jsr checknrange 
10470 	                jsr locate4
10480 	                ldx temp+1
10490 	                rts
10500 	locate2         sec
10510 	                jsr peek
10520 	                sbc temp2
10530 	                jsr locate6
10540 	                sbc temp2+1
10550 	                jmp locate5
10560 	locate3         clc
10570 	                jsr peek
10580 	                adc temp2
10590 	                jsr locate6
10600 	                adc temp2+1
10610 	locate5         beq loct3 
10620 	                cmp #$ff
10630 	                bne loct4
10640 	                txa
10650 	                bpl loct4
10660 	loct5           jsr poke 
10670 	                rts
10680 	loct3           txa
10690 	                bpl loct5
10700 	loct4           txa
10710 	                jsr poke
10720 	hsaddr          jsr hexaddr 
10730 	                jmp space
10740 	locate6         tax
10742 	                jsr peek
10750 	                bmi loct6
10760 	                lda #0
10770 	                byt $2c
10780 	loct6           lda #$ff 
10790 	                rts
10800 	locate4         jsr locate41 
10810 	locate41        lda temp 
10820 	                bne loct7
10830 	                lda temp+1
10840 	                bne loct8
10850 	                inc overtop
10860 	loct8           dec temp+1 
10870 	loct7           dec temp 
10880 	                rts
10890 	!
10900 	checknless      lda temp1 
10910 	                ldy temp1+1
10920 	                sec
10930 	                sbc temp
10940 	                sta nat
10950 	                tya
10960 	                sbc temp+1
10970 	                tay
10980 	                ora nat
10990 	                rts
10998 	!
11000 	newlocate       jsr get2addrs 
11010 	                jsr swaptemp1
11020 	                jsr getaddr
11030 	                jsr copytemp
11040 	                jsr get2addrs
11050 	                jsr swaptemp1
11060 	                lda buffer,x
11070 	                ldx #1
11080 	                cmp #$57
11090 	                beq nl1
11100 	                dex
11110 	nl1             stx ntemp 
11130 	                jsr ret
11140 	nl2             ldx overtop 
11150 	                bne nres
11160 	                jsr checknless
11170 	                bcc nres
11180 	                ldy ntemp
11190 	                bne nword
11200 	                jsr peek
11210 	                jsr decodeop
11220 	                cmp #$48
11230 	                bne nl3
11240 	                jsr disaline
11250 	nres            jmp start 
11260 	nl3             ldy numbytes 
11270 	                cpy #2
11280 	                beq nword1
11290 	                lda mode
11300 	                cmp #$9d
11310 	                bne nl4
11320 	                lda temp
11330 	                ldx temp+1
11340 	                jsr checknrange
11350 	                bcc nl5
11360 	                jsr locate1
11370 	                bcs nl4
11380 	                jsr locate2
11390 	                jmp nl4
11400 	nl5             jsr locate1 
11410 	                bcc nl4
11420 	                jsr locate3
11430 	                jmp nl4
11440 	nword           sty numbytes 
11450 	nword1          jsr peek 
11460 	                tax
11470 	                dey
11480 	                jsr peek
11490 	                jsr checknrange
11500 	                iny
11510 	                bcc nl4
11520 	                dey
11530 	                clc
11540 	                adc temp2
11550 	                jsr poke
11560 	                iny
11570 	                txa
11580 	                adc temp2+1
11590 	                jsr poke
11600 	nl4             jsr inctemp 
11610 	                dey
11620 	                bpl nl4
11630 	                bmi nl2
11640 	!
12000 	dollar          jsr getaddr 
12050 	                ldy #$23
12060 	                jsr prtdty
12062 	                jsr space
12070 	                lda temp+1
12080 	                ldx temp
12090 	                jsr linnum
12120 	                jsr crsrup
12130 	                jmp start
12140 	!
12200 	hash            lda #0 
12210 	                sta temp
12220 	                sta temp+1
12230 	                jsr scanspaces
12240 	dhok            lda buffer,x 
12250 	                beq dhout
12260 	                cmp #$30
12270 	                bcc dherr
12280 	                cmp #$3a
12290 	                bcs dherr
12300 	                and #15
12310 	                pha
12320 	                jsr mult10
12330 	                pla
12340 	                clc
12350 	                adc temp
12360 	                sta temp
12370 	                bcc dhok1
12380 	                inc temp+1
12390 	dhok1           inx
12400 	                bne dhok
12410 	dherr           jmp question 
12420 	dhout           ldy #$24 
12430 	                jsr prtdty
12432 	                jsr space
12440 	                jsr hexaddr
12442 	                jsr crsrup
12450 	                jmp start
12460 	!
12470 	mult10          asl temp 
12480 	                rol temp+1
12490 	                lda temp+1
12500 	                pha
12510 	                lda temp
12520 	                asl a
12530 	                rol temp+1
12540 	                asl a
12550 	                rol temp+1
12560 	                clc
12570 	                adc temp
12580 	                sta temp
12590 	                pla
12600 	                adc temp+1
12610 	                sta temp+1
12620 	                rts
12630 	!
12700 	chrout          pha
12710 	                lda $9a
12720 	                cmp #4
12730 	                bne prhere
12740 	                txa
12750 	                pha
12760 	                jsr clrchn
12770 	                pla
12780 	                tax
12790 	                pla
12800 	                jsr sendchr
12810 	                pha
12820 	                txa
12830 	                pha
12840 	                ldx #4
12850 	                jsr chkout
12860 	                pla
12870 	                tax
12880 	prhere          pla
12890 	                jmp sendchr
12900 	!
12910 	prinon          lda #4 
12920 	                cmp $9a
12930 	                beq phere
12940 	                sta $b8
12950 	                sta $ba
12960 	                lda #0
12970 	                sta $b7
12980 	                sta $b9
12990 	                jsr open
12992 	                ldx #4
13000 	                jsr chkout
13010 	phere           jmp start 
13020 	!
13030 	prinoff         lda $9a 
13040 	                cmp #4
13050 	                bne ohere
13060 	                lda #13
13070 	                jsr sendchr
13080 	                jsr clrchn
13090 	                sta $c6
13100 	                lda #4
13110 	                jsr close
13120 	                jmp start
13130 	ohere           jsr clrchn 
13140 	                sta $c6
13150 	                jmp start
13160 	!
13200 	disk            stx astemp+1 
13240 	                jsr dodisk
13270 	                jmp start
13280 	!
13290 	dodisk          tsx
13300 	                stx astemp
13310 	                jmp dstart
13320 	!
13330 	level42         lda #13 
13340 	                byt $2c
13350 	level43         lda #$23 
13360 	                jsr ciout
13370 	                jmp unlsn
13380 	!
13400 	terror          jmp $f704 
13410 	tl2             jmp start 
13420 	tload           jsr $f7d0 
13430 	                bcs tl1
13440 	                jmp $f713
13450 	tl1             jsr $f817 
13460 	                bcs tl2
13470 	                jsr $f5af
13480 	tl6             lda $b7 
13490 	                beq tl3
13500 	                jsr $f7ea
13510 	                bcc tl4
13520 	                beq tl2
13530 	                bcs terror
13540 	tl3             jsr $f72c 
13550 	                beq tl2
13560 	                bcs terror
13570 	tl4             lda st 
13580 	                and #16
13590 	                sec
13600 	                bne tl2
13610 	                lda $b9
13620 	                bne tburp
13650 	                lda temp
13660 	                sta $c3
13670 	                lda temp+1
13680 	                sta $c4
13690 	                jsr $f57d
13700 	                jmp tload1
13710 	tburp           jsr $f56c 
13720 	!
13730 	                jmp tload1
13740 	!
14000 	!
14020 	setdev          sta $b9 
14030 	                lda #8
14040 	                sta $ba
14050 	setst           ldx #0 
14060 	                stx st
14070 	                rts
14080 	!
14090 	dotalk          jsr talk 
14100 	                lda $b9
14110 	                jsr tksa
14120 	dotalk1         lda st 
14130 	                bne restart
14140 	                rts
14150 	restart         ldx astemp 
14152 	                txs
14160 	restart1        rts
14170 	!
14180 	gchar           ldx astemp+1 
14182 	                inc astemp+1
14190 	                lda buffer,x
14200 	                rts
14210 	!
14220 	recit           lda #$6f 
14230 	                jsr setdev
14240 	                jsr dotalk
14250 	                jmp acptr
14260 	!
14270 	addit           clc
14280 	                adc temp
14290 	                sta temp
14300 	                bcc add1
14310 	                inc temp+1
14320 	add1            rts
14330 	!
14340 	convert         ldx #$30 
14350 	                sec
14360 	num1            sbc #10 
14370 	                bcc num2
14380 	                inx
14390 	                bcs num1
14400 	num2            adc #$3a 
14410 	                rts
14420 	!
14430 	sendit          sta temp1 
14440 	                sty temp1+1
14450 	                stx byte
14460 	                lda $ba
14470 	                jsr listen
14480 	                lda #$6f
14490 	                sta $b9
14500 	                jsr second
14510 	                ldy #0
14520 	send1           lda (temp1),y 
14530 	                jsr ciout
14540 	                iny
14550 	                cpy byte
14560 	                bne send1
14570 	                jmp unlsn
14580 	!
14590 	sendu1          lda tracknum 
14600 	                jsr convert
14610 	                stx track
14620 	                sta track+1
14630 	                lda secnum
14640 	                jsr convert
14650 	                stx sector
14660 	                sta sector+1
14670 	                ldx #13
14680 	                lda #>buffer
14690 	                ldy #<buffer
14700 	                jsr sendit
14710 	                ldx #8
14720 	                lda #>dtr4
14730 	                ldy howie+1
14740 	                jsr sendit
14750 	                lda #$62
14760 	                jsr setdev
14770 	                jsr dotalk
14780 	                jsr acptr
14790 	                sta tracknum
14800 	                jsr acptr
14810 	                sta secnum
14820 	                rts
14830 	!
14840 	lissec          pha
14850 	                lda $ba
14860 	                jsr listen
14870 	                pla
14880 	                sta $b9
14890 	                jmp second
14900 	!
14910 	swoff           jsr lissec 
14920 	                jmp unlsn
14930 	!
14940 	dstart          jsr gchar 
14950 	                beq derror
14960 	                cmp #$20
14970 	                beq dstart
14980 	                sta ysave
14990 	                cmp #$24
15000 	                beq ddir
15010 	                cmp #$27
15020 	                beq dlen1
15030 	                cmp #$23
15040 	                bne dlen
15050 	dlen1           jsr gchar 
15060 	                ldx #0
15070 	                byt $2c
15080 	dlen            ldx #$40 
15090 	                byt $2c
15100 	ddir            ldx #$80 
15110 	                stx mode
15120 	                pha
15130 	                bit mode
15140 	                bvc disk1
15150 	                lda #$6f
15160 	                byt $2c
15170 	disk1           lda #$60 
15180 	                jsr setdev
15190 	                jsr listen
15200 	                lda $b9
15210 	                ora #$f0
15220 	                jsr second
15230 	                jsr dotalk1
15240 	                pla
15250 	                bne disk2
15252 	                beq disk31
15260 	disk4           jsr gchar 
15270 	                beq disk3
15280 	disk2           jsr ciout 
15290 	                bne disk4
15300 	disk3           jsr level42 
15304 	disk31          jsr unlsn 
15310 	!
15320 	                bit mode
15330 	                bvc disk5
15340 	derror          jsr ret 
15350 	                lda #$6f
15360 	                jsr setdev
15370 	                jsr dotalk
15380 	disk6           jsr acptr 
15390 	                cmp #13
15400 	                beq dfin
15410 	                jsr chrout
15420 	                bne disk6
15430 	disk5           lda $ba 
15440 	                jsr dotalk
15450 	                jsr acptr
15460 	                ldx st
15470 	                bne derror
15480 	                sta temp
15490 	                jsr acptr
15500 	                sta temp+1
15510 	                bit mode
15520 	                bpl disk7
15530 	disk8           jsr ret 
15540 	                jsr acptr
15550 	                jsr acptr
15560 	                beq dfin
15570 	                jsr acptr
15580 	                tax
15590 	                jsr acptr
15600 	                jsr linnum
15610 	                jsr space
15620 	dhere           jsr acptr 
15630 	                beq disk8
15640 	                jsr chrout
15650 	diskkey         lda shift 
15660 	                bne diskkey
15670 	                jsr stopkey
15680 	                bne dhere
15690 	dfin            jsr untlk 
15700 	dhere1          jsr eos 
15710 	                jmp restart
15720 	!
15730 	disk7           jsr ret 
15740 	                jsr hsaddr
15750 	                lda ysave
15760 	                cmp #$27
15770 	                beq dfin
15780 	!
15782 	                ldx #12
15784 	fttran          lda dtr3,x 
15786 	                sta buffer,x
15788 	                dex
15790 	                bpl fttran
15792 	!
15798 	ftrak           lda #>dtr1 
15800 	                ldy howie+1
15810 	                ldx #6
15820 	                jsr sendit
15830 	!
15840 	                jsr recit
15850 	                sta tracknum
15860 	!
15870 	                lda #>dtr2
15880 	                ldy howie+1
15890 	                ldx #6
15900 	                jsr sendit
15910 	!
15920 	                jsr recit
15930 	                sta secnum
15940 	!
15950 	                lda #$f2
15960 	                jsr lissec
15970 	                jsr level43
16000 	!
16010 	                jsr sendu1
16020 	!
16030 	                sec
16040 	                lda temp
16050 	                sbc #3
16060 	                sta temp
16070 	                lda temp+1
16080 	                sbc #0
16090 	                sta temp+1
16100 	!
16110 	                lda tracknum
16120 	                beq finmain
16130 	!
16140 	main            lda #254 
16150 	                jsr addit
16160 	                jsr sendu1
16170 	                lda tracknum
16180 	                bne main
16190 	!
16200 	finmain         lda secnum 
16210 	                jsr addit
16230 	                jsr hexaddr
16240 	                lda #$e2
16250 	                jsr swoff
16260 	                lda #$6f
16270 	                jsr swoff
16280 	                lda #$60
16290 	                jsr swoff
16300 	!
16310 	                jmp dhere1
16320 	!
16400 	swapsetup       lda #$30 
16410 	                tax
16420 	                sta temp+1
16430 	                lda #$d0
16440 	                sta temp1+1
16450 	                ldy #0
16460 	                sty temp
16470 	                sty temp1
16480 	                rts
16490 	!
16492 	swapmem1        sei
16494 	                jsr swapsetup
16496 	sloop1          lda (temp),y 
16498 	                pha
16500 	                lda storeof1
16502 	                sta $01
16504 	                lda (temp1),y
16506 	                sta (temp),y
16508 	                lda #$30
16510 	                sta $01
16512 	                pla
16514 	                sta (temp1),y
16516 	                dey
16518 	                bne sloop1
16520 	                inc temp+1
16522 	                inc temp1+1
16524 	                dex
16526 	                bne sloop1
16528 	swapback        lda #$37 
16530 	                sta $01
16532 	                cli
16534 	                rts
16536 	!
16538 	swapmem2        sei
16540 	                jsr swapsetup
16542 	sloop2          lda (temp),y 
16544 	                pha
16546 	                lda #$30
16548 	                sta $01
16550 	                lda (temp1),y
16552 	                sta (temp),y
16554 	                lda storeof1
16556 	                sta $01
16558 	                pla
16560 	                sta (temp1),y
16562 	                dey
16564 	                bne sloop2
16566 	                inc temp+1
16568 	                inc temp1+1
16570 	                dex
16572 	                bne sloop2
16574 	                beq swapback
16576 	!
16700 	peeka           sei
16710 	                stx byte
16720 	                lda storeof1
16730 	                sta $01
16740 	                rts
16750 	!
16760 	peekb           tax
16770 	                lda #$37
16780 	                sta $01
16790 	                cli
16800 	                txa
16810 	                ldx byte
16820 	                rts
16830 	!
16840 	peek            jsr peeka 
16850 	                lda (temp),y
16860 	                jmp peekb
16870 	!
16880 	peek2           jsr peeka 
16890 	                lda (temp2),y
16900 	                jmp peekb
16910 	!
16920 	pokeb           tax
16930 	                lda $01
16940 	                sta storeof1
16950 	                txa
16960 	                jmp peekb
16970 	!
16980 	poke            pha
16982 	                jsr peeka
16984 	                pla
16990 	                sta (temp),y
17000 	                jmp pokeb
17010 	!
17020 	poke1           pha
17022 	                jsr peeka
17024 	                pla
17030 	                sta (temp1),y
17040 	                jmp pokeb
17050 	!
17060 	poke2           pha
17062 	                jsr peeka
17064 	                pla
17070 	                sta (temp2),y
17080 	                jmp pokeb
17090 	!
17210 	!
49999 	!
50000 	title           byt 13,"gmon 1.2 (c) 1985",13,0 
50010 	regchars        byt 13,"   pc  sr ac xr yr sp",0 
50020 	clist           byt 0,"rix;:gtfhd,avlsjn$#op_" 
50030 	caddr           wor start-1 
50040 	                wor registers-1
50050 	                wor memory-1
50060 	                wor exit-1
50070 	                wor modregs-1
50080 	                wor modify-1
50090 	                wor go-1
50100 	                wor transfer-1
50110 	                wor fill-1
50120 	                wor hunt-1
50130 	                wor disassemble-1
50140 	                wor moddis-1
50150 	                wor assemble-1 
50160 	                wor verify-1
50170 	                wor load-1
50180 	                wor save-1
50190 	                wor jay-1
50200 	                wor newlocate-1
50210 	                wor dollar-1
50220 	                wor hash-1
50230 	                wor prinoff-1
50240 	                wor prinon-1
50250 	                wor disk-1
50490 	!
50500 	breaklo         byt >break 
50502 	breakhi         byt <break 
50510 	breaklo1        byt >break1-1 
50512 	breakhi1        byt <break1 
50514 	howie           wor dtr1 
50600 	modep           wor mo0 
50610 	                wor mo1
50620 	                wor mo2
50630 	                wor mo1
50640 	                wor mo0
50650 	                wor mo1
50660 	                wor mo6
50670 	                wor mo1
50680 	                wor mo8
50690 	                wor mo9
50700 	                wor moa
50710 	                wor mob
50720 	                wor moc
50730 	                wor mo1
50740 	                wor moe
50750 	                wor mo1
50760 	!
51000 	hexT            byt "0123456789abcdef" 
51010 	moreinfa        byt $9d,",),#(" 
51020 	moreinfb        byt "$y",0,"x$$",0 
51030 	!
51040 	dtr1            byt "m-r",126,0,13 
51050 	dtr2            byt "m-r",111,2,13 
51060 	dtr3            byt "u1:2 0 00 00",13 
51070 	dtr4            byt "b-p:2 0",13 
51080 	!
52000 	opcodeb         byt $11,$13,$15,$19,$19,$19,$1a,$1b,$1b,$1c,$1c 
52010 	                byt $1d,$1d,$23,$23,$23,$23,$23,$24,$24,$29,$29,$29,$34
52020 	                byt $53,$53,$53,$5b,$5d,$69,$69,$69,$6d,$7c,$84,$8a,$8a
52030 	                byt $8b,$8b,$9c,$9c,$9d,$9d,$a0,$a1,$a1,$a1,$a5,$a5,$a5
52040 	                byt $a8,$a8,$ad,$ae,$ae,$ae
52050 	!
52060 	                byt $15,$9c,$16,$68,$9b,$6d,$29,$53,$13,$14,$c8,$80,$a0,$a3,$a3,$1e,$00
52070 	!
52080 	opcodea         byt $48,$ca,$1a,$08,$28,$a4,$aa,$94,$cc,$5a,$d8 
52090 	                byt $c8,$e8,$48,$4a,$54,$6e,$a2,$72,$74,$88,$b2,$b4,$26
52100 	                byt $c8,$f2,$f4,$a2,$26,$44,$72,$74,$26,$22,$c4,$44,$62
52110 	                byt $44,$62,$1a,$26,$54,$68,$c8,$88,$8a,$94,$44,$72,$74
52120 	                byt $b2,$b4,$32,$44,$68,$84
52130 	!
52140 	                byt $20,$c4,$68,$b2,$44,$0c,$1c,$e8,$66,$e6,$84,$9a,$b2,$06,$30,$aa,$00
52150 	!
53000 	mo0             byt $00,$59,$00,$59,$81,$81,$81,$81,$00,$21,$00,$21,$82,$82,$82,$82 
53010 	mo1             byt $9d,$4d,$00,$4d,$81,$91,$91,$91,$00,$86,$00,$86,$82,$92,$92,$92 
53020 	mo2             byt $82,$59,$00,$59,$81,$81,$81,$81,$00,$21,$00,$21,$82,$82,$82,$82 
53030 	mo6             byt $00,$59,$00,$59,$81,$81,$81,$81,$00,$21,$00,$21,$4a,$82,$82,$82 
53040 	mo8             byt $81,$59,$81,$59,$81,$81,$81,$81,$00,$81,$00,$21,$82,$82,$82,$82 
53050 	mo9             byt $9d,$4d,$00,$00,$91,$91,$85,$85,$00,$86,$00,$00,$82,$92,$00,$00 
53060 	moa             byt $21,$59,$21,$59,$81,$81,$81,$81,$00,$21,$00,$21,$82,$82,$82,$82 
53070 	mob             byt $9d,$4d,$00,$4d,$91,$91,$85,$91,$00,$86,$00,$00,$92,$92,$86,$86 
53080 	moc             byt $21,$59,$81,$59,$81,$81,$81,$81,$00,$21,$00,$21,$82,$82,$82,$82 
53090 	moe             byt $21,$59,$81,$59,$81,$81,$81,$81,$00,$21,$00,$00,$82,$82,$82,$82 
53100 	!
53160 	!
54000 	opnum           byt $0a,$22,$48,$38,$45,$22,$02,$38,$24,$22,$02,$38,$46,$22,$02,$38 
54010 	                byt $09,$22,$48,$38,$45,$22,$02,$38,$0d,$22,$21,$38,$46,$22,$02,$38
54020 	                byt $1c,$01,$48,$3c,$06,$01,$27,$3c,$26,$01,$27,$3c,$06,$01,$27,$3c
54030 	                byt $07,$01,$48,$3c,$45,$01,$27,$3c,$2c,$01,$21,$3c,$46,$01,$27,$3c
54040 	                byt $29,$17,$48,$3d,$45,$17,$20,$3d,$23,$17,$20,$40,$1b,$17,$20,$3d
54050 	                byt $0b,$17,$48,$3d,$45,$17,$20,$3d,$0f,$17,$21,$3d,$46,$17,$20,$3d
54060 	                byt $2a,$00,$48,$39,$45,$00,$28,$39,$25,$00,$28,$41,$1b,$00,$28,$39
54070 	                byt $0c,$00,$48,$39,$45,$00,$28,$39,$2e,$00,$21,$39,$46,$00,$28,$39
54080 	                byt $45,$2f,$45,$3a,$31,$2f,$30,$3a,$16,$45,$35,$42,$31,$2f,$30,$3a
54090 	                byt $03,$2f,$48,$47,$31,$2f,$30,$3a,$37,$2f,$36,$47,$46,$2f,$47,$47
54100 	                byt $1f,$1d,$1e,$3b,$1f,$1d,$1e,$3b,$33,$1d,$32,$43,$1f,$1d,$1e,$3b
54110 	                byt $04,$1d,$48,$3b,$1f,$1d,$1e,$3b,$10,$1d,$34,$47,$1f,$1d,$1e,$3b
54120 	                byt $13,$11,$45,$3e,$13,$11,$14,$3e,$1a,$11,$15,$44,$13,$11,$14,$3e
54130 	                byt $08,$11,$48,$3e,$45,$11,$14,$3e,$0e,$11,$21,$3e,$46,$11,$14,$3e
54140 	                byt $12,$2b,$45,$3f,$12,$2b,$18,$3f,$19,$2b,$21,$47,$12,$2b,$18,$3f
54150 	                byt $05,$2b,$48,$3f,$45,$2b,$18,$3f,$2d,$2b,$21,$3f,$46,$2b,$18,$3f
54160 	!
59000 	                byt 0,0,0,0,0,0,0,0
59010                   byt "(c) 1985gary j. foreman "
59020                   byt 0,0,0,0,0,0,0,0
59030	!