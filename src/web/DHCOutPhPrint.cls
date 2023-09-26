Import sqluser

Class web.DHCOutPhPrint Extends %RegisteredObject [ ProcedureBlock ]
{

/// Description:门诊药房发药后打印
/// Creator:Liang Qiang
/// CreatDate:2011-02-25
/// Input:发药主表rowid
/// Output:打印所需内容
/// w ##class(web.DHCOutPhPrint).PrintPrescByPhd("284","")
ClassMethod PrintPrescByPhd(phd As %String, IfPresc As %String = "")
{
	s ^TMPDHCSTPARAMS("web.DHCOutPhPrint","PrintPrescByPhd")=$lb(phd,IfPresc)
	s PrescNo=$p(^DHCPHDISP(phd,2),"^",1)
	s phdphl=$p(^DHCPHDISP(phd,1),"^",1)
	s PhdPrtId=+$p(^DHCPHDISP(phd),"^",2)
	q:(IfPresc=1) ..GetOrdInfoByPresc(PrescNo,PhdPrtId,phdphl)
	s ret=..GetPrtPrescInfo(PrescNo,phdphl)
	q ret
}

/// 	草药审方预览界面调用的方法   	(信息输出与处方打印输出一致)
/// w ##class(web.DHCOutPhPrint).GetCYOrdInfoByPresc("O181227000004","228026")
ClassMethod GetCYOrdInfoByPresc(prescno)
{
	q:prescno="" ""	
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	q:ord="" ""
	s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
	q:itm="" ""
	s adm=$p(^OEORD(ord),"^",1)
	s PatInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPatInfo(adm)
	s patno=$p(PatInfo,"^",1)
	s cardNo=$p(PatInfo,"^",2)
	s patname=$p(PatInfo,"^",3)
	s patsex=$p(PatInfo,"^",4)
	s patage=$p(PatInfo,"^",5)
	s ptel=$p(PatInfo,"^",6)
	s paddress=$p(PatInfo,"^",7)

	s company=$p(PatInfo,"^",8)
	s patW=$p(PatInfo,"^",10)
	s mrno=$p(PatInfo,"^",11)			//病历号
	s patNation=$p(PatInfo,"^",14)
	s deplocdr=$p(^PAADM(adm),"^",4)
	s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
	i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
	s admdate=$p(^PAADM(adm),"^",6)
	i admdate'="" s admdate=$zd(admdate,3)
	s orddate=+$p($g(^OEORD(ord,"I",itm,3)),"^",7)
    s:orddate'="" orddate=$zd(orddate,3)
    ;先取处方的关联诊断，如果取空了再取该患者的中医诊断！
    s diagnodesc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescDiagnos(prescno)
    s:diagnodesc="" diagnodesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",","GC")
    s mbDiagnos=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescMBDiagnos(prescno)	//psc 2018-09-27
    s retstr=##class(web.DHCINPHA.MTCommon.PublicCallMethod).Getpaque(prescno)
    s queinst=$p(retstr,"^",1)
    s quefac=$p(retstr,"^",2) 
    s queqty=$p(retstr,"^",3) 
    s quedate=$p(retstr,"^",4)
    s quexdate=$p(retstr,"^",5)
    s prescnote=$p(retstr,"^",6)
    s quecook=$p(retstr,"^",7)
    s queform=$p(retstr,"^",8)
    s queFreq=$p(retstr,"^",9)
    s PrescConfig=$p(retstr,"^",10)					//处方配置
    s PrescOrderQtyDesc=$p(retstr,"^",11)
    s DrugInfo=$p(retstr,"^",12)
    s DurationDesc=$p(retstr,"^",14)
    s docctloc=$p(retstr,"^",17)
    s doctor=$p(retstr,"^",18)
    s PrescCount=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescNoCount(prescno)	//处方味数
    s:PrescCount=0 PrescCount=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescNoUnCount(prescno)
    s presctype=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetCYPrescTitle(prescno)
    s auditname=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhaomInfo(prescno),"^",3)
    s paytype=##class(web.DHCOutPhCommon).GetPrescFeeType(prescno)
    s sumamt=0
    s (pyname,pydate,fyname,fydate,phwindesc)=""  
	s phdispid=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1)
   	i phdispid'="" d
    .s pyuserdr=$p(^DHCPHDISP(phdispid,1),"^",3)
    .i pyuserdr'="" s pyname=$p(^DHCPHPER(pyuserdr),"^",2)
    .s fyuserdr=$p(^DHCPHDISP(phdispid,1),"^",2)
    .i fyuserdr'="" s fyname=$p(^DHCPHPER(fyuserdr),"^",2)	 
    .s phwin=$p(^DHCPHDISP(phdispid,1),"^",4) 
    .i phwin'="" s phwindesc=$p(^DHCPHWIN(phwin),"^",2)	 
    .
    s sysdate=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
 	s reclocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
 	s recloc=""
 	i reclocdr'="" s recloc=$p(^CTLOC(reclocdr),"^",2)
	i recloc["-" s recloc=$p(recloc,"-",2)
    s hospital=$p($g(^CTLOC(reclocdr)),"^",22)
    i hospital'="" s hospital=$p($g(^CT("HOSP",hospital)),"^",2)
	s patstring1=patno_"^"_patname_"^"_patage_"^"_patsex_"^"_diagnodesc
	s patstring2=patW_"^"_pyname_"^"_fyname_"^"_pydate_"^"_fydate   
	s patstring3=sysdate_"^"_company_"^"_recloc_"^"_admdate_"^"_cardNo
	s patstring4=prescno_"^"_deplocdesc_"^"_phwindesc_"^"_ptel_"^"_paddress
	s patstring5=quecook_"^"_queqty_"^"_presctype_"^"_docctloc_"^"_doctor
	s patstring6=queinst_"^"_quefac_"^"_queqty_"^"_quedate_"^"_quexdate
	s patstring7=prescnote_"^"_orddate_"^"_hospital_"^"_mrno_"^"_sumamt
	s patstring8=paytype_"^"_PrescCount_"^"_DrugInfo_"^"_PrescConfig_"^"_auditname
	s patstring9=patNation_"^"_queFreq _"^"_mbDiagnos

    s patstring=patstring1_"^"_patstring2_"^"_patstring3_"^"_patstring4_"^"_patstring5_"^"_patstring6_"^"_patstring7_"^"_patstring8_"^"_patstring9
    ;以下为处方明细
    s ComFlag=##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckCMXDPTCom(prescno)
    s ord="",medstring=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm))  q:itm=""  d
	..s oeori=ord_"||"_itm
	..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:prescno'=OEPrescNo
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""),-1)
	..q:dsp="" 
    ..s MoneyStr=##class(web.DHCOutPhCommon).GetOrdItmMoney(oeori)
    ..s totalprice=$p(MoneyStr,"^",2)
    ..s sumamt=sumamt+totalprice
    ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)
    ..s CheckPartyAgr=##class(web.DHCDocOrderEntryCM).IsPrecompoundedARCIM(arcimid)	;判断是否是协定方 
    ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"")) 
    ..q:(inci="")&&(CheckPartyAgr'="1")
    ..s fontflag=""
    ..i ComFlag="1"  d
    ...;协定处方和普通草药组合
    ...s OrdUserID=$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	...s OrdUserName=$p($g(^SSU("SSUSR",OrdUserID)),"^",2)
	...s DepId=0 
	...f  s DepId=$O(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId)) q:DepId=""  d
	....s depdatefrom=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",1)
	....q:(depdatefrom'="")&&(depdatefrom>+$h)
	....s depdateto=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",2)
	....q:(depdateto'="")&&(depdateto<+$h)
	....s deparcimdr=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",3)
	....q:deparcimdr=""
	....s arcimdesc=$p(^ARCIM(+deparcimdr,$p(deparcimdr,"||",2),1),"^",2)
	....s DoseQtyCM=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",7)
	....s DoseUOM=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",8)
	....s CTUOMDesc=$s(DoseUOM'="":$p(^CT("UOM",DoseUOM),"^",2),1:"") //剂量单位
	....;限量 极量判断
	....s XLQty=0,JLQty=0,PhSpecInstr=""
	....s DHCItmMastRowID=$o(^DHCItmMast("0","ARCIM",deparcimdr,0))
	....i DHCItmMastRowID'="" d
	.....s XLQty=+$p($g(^DHCItmMast(DHCItmMastRowID)),"^",3)
	.....s JLQty=+$p($g(^DHCItmMast(DHCItmMastRowID)),"^",10)
	....s:((XLQty'=0)&&(DoseQtyCM>XLQty))||((JLQty'=0)&&(DoseQtyCM>JLQty)) PhSpecInstr=OrdUserName
	....;十八反判断
	....s LimitFlag=##class(web.UDHCPrescriptQueryCM).CheckCMPrescLimitInfo(oeori)
	....s:PhSpecInstr="" PhSpecInstr=$s(LimitFlag="Y":OrdUserName,1:"")
	....;毒性判断
	....s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimid)  
 	....s PoisonDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(Phcdf),"^",2)
 	....s:PoisonDesc["毒性" fontflag=1
 	....s:PhSpecInstr="" PhSpecInstr=$s(PoisonDesc["毒性":OrdUserName,1:"")
	....s (dosage,inst,freq,phdur,price,skintest,genedesc,packprice,ordremark)=""  //针对草药，不需要字段  占用位置
	....s price=totalprice/DoseQtyCM
	....s price=$fn(price,"",2)
	....s tmpsting1=arcimdesc_"^"_DoseQtyCM_"^"_CTUOMDesc_"^"_ dosage_"^"_inst_"^"_freq_"^"_phdur_"^"_price_"^"_totalprice_"^"_skintest_"^"_ordremark_"^"_genedesc_"^"_packprice
	....s tmpsting2=PhSpecInstr_"^"_fontflag
    ....s tmpsting=tmpsting1_"^"_tmpsting2
    ....i medstring="" d
    .....s medstring=tmpsting
    ....e  d
    .....s medstring=medstring_"@"_tmpsting
    ....
    ...
    ..e  d
    ...s arcimdesc=$p($g(^ARCIM(+arcimid,1,1)),"^",2)
    ...s ordremark=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
    ...s OrdUserID=$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	...s OrdUserName=$p($g(^SSU("SSUSR",OrdUserID)),"^",2)
	...s DoseUOM=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	...s CTUOMDesc=$s(DoseUOM'="":$p(^CT("UOM",DoseUOM),"^",2),1:"") //剂量单位
	...s DoseQty=$p($g(^OEORD(ord,"I",itm,1)),"^",12) 				 //数量
	...s DoseQtyCM=DoseQty/quefac
	...;限量 极量判断
	...s XLQty=0,JLQty=0,PhSpecInstr=""
	...s DHCItmMastRowID=$o(^DHCItmMast("0","ARCIM",arcimid,0))
	...i DHCItmMastRowID'="" d
	....s XLQty=+$p($g(^DHCItmMast(DHCItmMastRowID)),"^",3)
	....s JLQty=+$p($g(^DHCItmMast(DHCItmMastRowID)),"^",10)
	...s:((XLQty'=0)&&(DoseQtyCM>XLQty))||((JLQty'=0)&&(DoseQtyCM>JLQty)) PhSpecInstr=OrdUserName
	...;十八反判断
	...s LimitFlag=##class(web.UDHCPrescriptQueryCM).CheckCMPrescLimitInfo(oeori)
	...s:PhSpecInstr="" PhSpecInstr=$s(LimitFlag="Y":OrdUserName,1:"")
	...;毒性判断
	...s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimid)  
 	...s PoisonDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(Phcdf),"^",2)
 	...s:PoisonDesc["毒性" fontflag=1
 	...s:PhSpecInstr="" PhSpecInstr=$s(PoisonDesc["毒性":OrdUserName,1:"")
	...s (dosage,inst,freq,phdur,price,skintest,genedesc,packprice)=""  //针对草药，不需要字段  占用位置
	...s price=totalprice/DoseQtyCM
	...s price=##Class(web.DHCSTCOMMPARA).GetNumbDec(price,"","FmtSP",1)
    ...i (price>0)&&(price<1) s price="0"_price
    ...s totalprice=##Class(web.DHCSTCOMMPARA).GetNumbDec(totalprice,"","FmtSP",1)
    ...i (totalprice>0)&&(totalprice<1) s totalprice="0"_totalprice
    ...s tmpsting1=arcimdesc_"^"_DoseQtyCM_"^"_CTUOMDesc_"^"_ dosage_"^"_inst_"^"_freq_"^"_phdur_"^"_price_"^"_ totalprice_"^"_skintest_"^"_ordremark_"^"_genedesc_"^"_packprice
    ...s tmpsting2=PhSpecInstr_"^"_fontflag
    ...s tmpsting=tmpsting1_"^"_tmpsting2
    ...i medstring="" d
    ....s medstring=tmpsting
    ...e  d
    ....s medstring=medstring_"@"_tmpsting
    ...
    ..
    .
    s:$p(sumamt,".",1)="" sumamt=0_sumamt
    s $p(patstring,"^",35)=sumamt   //处方总金额
    q patstring_"!!"_medstring
}

/// Description:门诊药房打印统一方法调用,适用于配药,发药,直接发药,查询等界面打印处方,摆药单
/// Creator:Liang Qiang
/// CreatDate:2011-01-11
/// Input:处方号,科室
/// Output:打印所需内容
/// w ##class(web.DHCOutPhPrint).GetPrtPrescInfo("O181019000026","14")
ClassMethod GetPrtPrescInfo(PrescNo As %String, phdphl As %String)
{
   s patstring=""  //处方信息(含患者基本信息)
   s medstring=""  //医嘱信息
   
	s cypresc=""
	i $d(^PAQUE1(0,"PrescNo",PrescNo)) d
	.s queid=$o(^PAQUE1(0,"PrescNo",PrescNo,""))
	.i $d(^PAQUE1(queid,"DHC")) s cypresc=1

   s phdrow="" 
   f  s phdrow=$o(^DHCPHDISPi("PRESCNO",PrescNo,phdrow)) q:phdrow=""  d
   .s tmpphdphl=$p(^DHCPHDISP(phdrow,1),"^",1)
   .q:tmpphdphl'=phdphl
   .s papmi=""
   .s papmi=+$p(^DHCPHDISP(phdrow),"^",7)
   .s perno=$p(^PAPER(papmi,"PAT",1),"^",2)
   .s pname=$p(^PAPER(papmi,"ALL"),"^",1)
   .s ptel=$p(^PAPER(papmi,"PER",1),"^",11)
   .s paddress=$p($g(^PAPER(papmi,"PER",4)),"^",18)
   .s getage=##class(web.DHCOutPhCommon).GetAge(papmi) 
   .s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
   .s sex=$p(^CT("SEX",sexdr),"^",2)
   .s company=$p(^PAPER(papmi,"PER",4),"^",18) //工作单位
   .s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""),-1)
   .i cfRowId'="" s cardNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
   .e  s cardNo=""
   .s admord=$o(^OEORD(0,"PrescNo",PrescNo,""))
   .s adm=$p(^OEORD(admord),"^",1)
   .s admdate=""
   .s admdate=$p(^PAADM(adm),"^",6)
   .i admdate'="" s admdate=$zd(admdate,3)
   .s diagnodesc="" 
   .s patW=##class(web.DHCOutPhCommon).GetPatWeight(adm)
   .s deplocdr=$p(^PAADM(adm),"^",4)
   .s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
   .i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
   .s warddesc=""
   .s currwarddr=$p(^PAADM(adm),"^",70)
   .i currwarddr'="" d
   ..s ctlocdr=$p($g(^PAWARD(currwarddr)),"^",5)
   ..s warddesc=$p(^CTLOC(ctlocdr),"^",2)
   ..i warddesc["-" s warddesc=$p(warddesc,"-",2)
   ..s deplocdesc=deplocdesc_"["_warddesc_"]"
   .s pyname=""
   .s pyuserdr=$p(^DHCPHDISP(phdrow,1),"^",3)
   .i pyuserdr'="" s pyname=$p(^DHCPHPER(pyuserdr),"^",2)
   .s fyname=""
   .s fyuserdr=$p(^DHCPHDISP(phdrow,1),"^",2)
   .i fyuserdr'="" s fyname=$p(^DHCPHPER(fyuserdr),"^",2)
   .;
   .s pydate=$p(^DHCPHDISP(phdrow,1),"^",5)
   .i pydate'="" s pydate=$zd(pydate,3)
   .s pytime=$p(^DHCPHDISP(phdrow,1),"^",7)
   .i pytime'="" s pytime=$zt(pytime,1)
   .s pydate=pydate_"  "_pytime
   .; 
   .s fydate=$p(^DHCPHDISP(phdrow),"^",3)
   .i fydate'="" s fydate=$zd(fydate,3)
   .s fytime=$p(^DHCPHDISP(phdrow),"^",5)
   .i fytime'="" s fytime=$zt(fytime,1)
   .s fydate=fydate_" "_fytime
   .s sysdate=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
   .;
   .s phl=$p(^DHCPHDISP(phdrow,1),"^",1)
   .s phlocdr=$p(^DHCPHLOC(phl),"^",1)
   .s recloc=$p(^CTLOC(phlocdr),"^",2) 
   .i $F(recloc,"-") s recloc=$p(recloc,"-",2)
   .s phwindesc=""
   .s phwdr=$p(^DHCPHDISP(phdrow,1),"^",4)
   .i phwdr'="" d 
   ..i $D(^DHCPHWIN(phwdr)) s phwindesc=$p(^DHCPHWIN(phwdr),"^",1)
   .s presctitle=##class(web.DHCOutPhTQDisp).GetPrescTitle(PrescNo)
   .;
   .s retstr=..Getpaque(PrescNo)
   .s queinst=$p(retstr,"^",1)
   .s quefac=$p(retstr,"^",2) 
   .s queqty=$p(retstr,"^",3)
   .s quedate=$p(retstr,"^",4)
   .s quexdate=$p(retstr,"^",5)
   .s quenote=$p(retstr,"^",6)  
   .s quecook=$p(retstr,"^",7)
   .s queFreq=$p(retstr,"^",9)
   .s docstr=##class(web.DHCOutPhCommon).GetOrdDoc(PrescNo,phlocdr)
   .s docctloc=$p(docstr,"^",1)
   .s doctor=$p(docstr,"^",2)
   .s orddate=$p(docstr,"^",3)
   .s hospital=$p($g(^CTLOC(phlocdr)),"^",22)
   .i hospital'="" s hospital=$p($g(^CT("HOSP",hospital)),"^",2)
   .s admtype=$p(^PAADM(adm),"^",2)
   .s mrno=##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(adm,admtype) //病历号
   .s sumamt=0
   .s (paytype,PrescCount,DrugInfo,PrescConfig,auditname,patNation,queFreq,mbDiagnos)=""
   .s patNation=$s(($D(^PAPER(papmi,"PER",2)))&&($p(^PAPER(papmi,"PER",2),"^",1)'=""):$p(^CT("NAT",$p(^PAPER(papmi,"PER",2),"^",1)),"^",2),1:"") //民族
   .s paytype=##class(web.DHCOutPhCommon).GetPrescFeeType(PrescNo)
   .s auditname=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhaomInfo(PrescNo),"^",3)
   .s patstring=perno_"^"_pname_"^"_getage_"^"_sex_"^"_diagnodesc_"^"_patW_"^"_pyname_"^"_fyname_"^"_pydate_"^"_fydate_"^"_sysdate_"^"_recloc_"^"_company_"^"_admdate_"^"_cardNo_"^"_PrescNo_"^"_deplocdesc_"^"_phwindesc_"^"_ptel_"^"_paddress_"^"_quecook_"^"_queqty_"^"_presctitle_"^"_docctloc_"^"_doctor
   .s patstring=patstring_"^"_queinst_"^"_quefac_"^"_queqty_"^"_quedate_"^"_quexdate_"^"_quenote_"^"_orddate_"^"_hospital_"^"_mrno_"^"_sumamt_"^"_paytype_"^"_PrescCount_"^"_DrugInfo_"^"_PrescConfig_"^"_auditname_"^"_patNation_"^"_queFreq_"^"_mbDiagnos
   .s prescScgSet="",tmpPrescScgSet=""
   .i cypresc=1 s prescScgSet="GC"
   .e  s prescScgSet="GX"
   .s phdi=""
   .f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:phdi=""  d
   ..s qty=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",4 )
   ..s oeori=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5)
   ..s ord=+oeori
   ..s itm=$p(oeori,"||",2)
   ..s freq=""
   ..s freqdr=+$p(^OEORD(ord,"I",itm,2),"^",4)
   ..i (freqdr'=0)&&$d(^PHCFR(freqdr)) d
   ...s freq=$p(^PHCFR(freqdr),"^",1)  										//用药频率
   ..s inst=""
   ..s instdr=+$p(^OEORD(ord,"I",itm,2),"^",7)
   ..i $d(^PHCIN(instdr)) s inst=$p(^PHCIN(instdr),"^",2)  					//用法 
   ..s phdur="" 
   ..s phdurdr=+$p(^OEORD(ord,"I",itm,2),"^",6)
   ..i $d(^PHCDU(phdurdr))&&(phdurdr>0) s phdur=$p(^PHCDU(phdurdr),"^",1) 	//用药疗程
   ..//s dosage=$p(^OEORD(ord,"I",itm,2),"^",1) 								//用药剂量
   ..s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
   ..s dosageuomdr=$p(^OEORD(ord,"I",itm,2),"^",3)
   ..s dosageuom=""
   ..s:dosageuomdr'="" dosageuom=$p(^CT("UOM",dosageuomdr),"^",2)   		//剂量单位 
   ..
   ..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
   ..q:dsp=""
   ..s bpfac=1
   ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) 
   ..s qty=$p(^DHCOEDISQTY(dsp),"^",2) 
   ..s inciflag=##class(web.DHCOutPhCommon).GetIncFlagByArc(arcimid)		//依据医嘱项获取库存项是否唯一
   ..s MoneyStr=##class(web.DHCOutPhCommon).GetOrdItmMoney(oeori)			//医嘱金额
   ..s totalprice=$p(MoneyStr,"^",2)
   ..i (cypresc'=1)&&(inciflag=1) d
   ...s inci=$o(^INCI(0,"ARCIM_DR",+arcimid,""))
   ...q:+inci=0
   ...s buom=$p(^INCI(inci,1),"^",10)
   ...s puom=$p(^INCI(inci,3),"^",6) 
   ...s bpfac=##Class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
   ...s price=totalprice*bpfac/qty
   ...s packprice=price
   ...s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(inci,qty)
   ...s qty=$p(qtyinfo,"^",1)
   ...s unit=$p(qtyinfo,"^",2)
   ...s incidesc=$p(^INCI(inci,1),"^",2) 
   ...s genedesc=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 				//处方通用名
   ...i genedesc="" s genedesc=incidesc
   ..e  d
   ...s UomStr=##class(web.DHCOutPhCommon).GetPhcDrgUom(arcimid)				//药学项单位
   ...s Buom=$p(UomStr,"^",1)
   ...s BuomDesc=$p(UomStr,"^",2)
   ...s price=totalprice/qty
	...s unit=BuomDesc
	...s incidesc=$p($g(^ARCIM(+arcimid,$p(arcimid,"||",2),1)),"^",2) 
	...s phcdf=$p($g(^ARCIM(+arcimid,$p(arcimid,"||",2),1)),"^",12) 
	...i +phcdf'=0  d
	....s gene=$p($g(^PHCD(+phcdf,4)),"^",1) 
	....q:gene=""
	....s genedesc=$p($g(^PHCGE("GE",gene)),"^",2)
	...i genedesc="" s genedesc=incidesc
   ..s price=##Class(web.DHCSTCOMMPARA).GetNumbDec(price,"","FmtSP",1)
   ..i (price>0)&&(price<1) s price="0"_price
   ..s totalprice=##Class(web.DHCSTCOMMPARA).GetNumbDec(totalprice,"","FmtSP",1)
   ..i (totalprice>0)&&(totalprice<1) s totalprice="0"_totalprice
   ..s packprice=price
   ..s skintest=""
   ..s skinresult=##class(web.DHCSTCOMMONORDER).OeoriSkinTest(ord_"||"_itm)
   ..s skintest=$p(skinresult,"^",2)
   ..s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(ord_"||"_itm)
   ..i ordremark=""  s ordremark=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
   ..i dosageuom="" s dosage=""
   ..s (PhSpecInstr,fontflag)=""
   ..s tmpsting=incidesc_skintest_"^"_qty_"^"_unit_"^"_dosage_"^"_inst_"^"_freq_"^"_phdur_"^"_price_"^"_totalprice_"^"_skintest_"^"_ordremark_"^"_genedesc_skintest_"^"_packprice_"^"_PhSpecInstr_"^"_fontflag
   ..i medstring="" d
   ...s medstring=tmpsting
   ..e  d
   ...s medstring=medstring_"@"_tmpsting
   ..s sumamt=sumamt+totalprice
   .s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",","")
   .s $p(patstring,"^",35)=sumamt
   .s $p(patstring,"^",5)=diagnodesc
   q patstring_"!!"_medstring
}

/// creator:yunhaibao
/// createdate:20160616
/// description:根据处方号获取处方信息,用于发药界面处方预览,2,
/// others:顺序与w ##class(web.DHCOutPhPrint).PrintPrescByPhd方法保持一致
/// 	   
/// w ##class(web.DHCOutPhPrint).GetOrdInfoByPresc("O181109000010","228277","13")
ClassMethod GetOrdInfoByPresc(prescno, prt, phl = "")
{
	s ^TMPDHCSTPARAMS("web.DHCOutPhPrint","GetOrdInfoByPresc")=$lb(prescno, prt, phl)
	q:prescno="" ""	
	i phl="" d
	.s tmpOrd=$o(^OEORD(0,"PrescNo",prescno,""))
	.s tmpOrdItm=$o(^OEORD(0,"PrescNo",prescno,tmpOrd,""))
	.s recLocId=$p(^OEORD(tmpOrd,"I",tmpOrdItm,3),"^",6)
	.s phl=$o(^DHCPHLOCi("LOC",recLocId,""),-1)
	q:phl="" ""
	s PID=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()	
	s locdr=$p(^DHCPHLOC(phl),"^",1)
	s loginloc=locdr
	s leadlocdr=##class(web.DHCOutPhDisp).GetLeadLoc(locdr)
	s cyflag=""
	s cyflag=$p(^DHCPHLOC(phl),"^",6)
	s yprescno=$g(prescno)	  
	s reclocdr=""
	s reclocdr=+$p(^DHCPHLOC(phl),"^",1)
    s sysdate=$zd(+$h,3)
	s systime=$zt($p($h,",",2),1)
	s sysdate=sysdate_" "_systime
	s fyflag=##class(web.DHCOutPhDisp).CheckOrdPay(prescno,phl)				//发药标志 
	s cypresc=""
	i $d(^PAQUE1(0,"PrescNo",prescno)) d
	.s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
	.i $d(^PAQUE1(queid,"DHC")) s cypresc=1
	s t=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d 
	.s patadm=$p(^OEORD(ord),"^",1)	  
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
	..s recplocdr=+$p(^OEORD(ord,"I",itm,3),"^",6)
	..q:recplocdr=""	  
	..s billflag=+$p(^OEORD(ord,"I",itm,3),"^",5)						//收费标志
	..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)                                  
	..q:(fyflag'=1)&&(billflag'="P")&&(oeflag'="V")&&(oeflag'="E")		//未发-未收费--非医嘱核实的  去掉
	..q:recplocdr'=reclocdr 
	..s priority=$p(^OEORD(ord,"I",itm,1),"^",8)     ;????
	..s priordesc=""
	..i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	..q:priordesc["自备"
	..s prescnox=$p($g(^OEORD(ord,"I",itm,1)),"^",14)
	..q:prescnox'=prescno									
	..s orditm=ord_"||"_itm
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	..q:dsp=""
	..s index="0"
	..s prescnox=reclocdr_"||"_prescno
	..s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
	..i $d(^DHCOEDISQTY(dsp,"I")) d
	...s dspSub=0
	...f  s dspSub=$o(^DHCOEDISQTY(dsp,"I",dspSub)) q:dspSub=""  d
	....s dspbat=dsp_"||"_dspSub
	....s Inci=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",5) 
	....s Buom=$p(^INCI(Inci,1),"^",10)
	....s qty=$p(^DHCOEDISQTY(dsp,"I",dspSub),"^",2)
	....s MoneyStr=##class(web.DHCOutPhCommon).GetOrdItmMoney(orditm,dspbat)
	....s pmoney=$p(MoneyStr,"^",2)
	....s index=Inci
	....i $d(^TMP("DHCST","web.DHCOutPhPrint","GetOrdInfoByPresc",PID,"PRESCNO",prescnox,itm,index))  d
	.....s data=^TMP("DHCST","web.DHCOutPhPrint","GetOrdInfoByPresc",PID,"PRESCNO",prescnox,itm,index)
	.....s $p(data,"^",2)=$p(data,"^",2)+qty
	.....s $p(data,"^",3)=$p(data,"^",3)+pmoney
	.....s ^TMP("DHCST","web.DHCOutPhPrint","GetOrdInfoByPresc",PID,"PRESCNO",prescnox,itm,index)=data
	....e  d
	.....s ^TMP("DHCST","web.DHCOutPhPrint","GetOrdInfoByPresc",PID,"PRESCNO",prescnox,itm,index)=orditm_"^"_qty_"^"_pmoney_"^"_Buom_"^"_""_"^"_Inci
 
	q:+patadm="0" ""
	s adm=patadm
	s papmi=$p(^PAADM(adm),"^",1)	  
	s perno=$p(^PAPER(papmi,"PAT",1),"^",2)
	s pname=$p(^PAPER(papmi,"ALL"),"^",1)
	s ptel=$p(^PAPER(papmi,"PER",1),"^",11)
	s paddress=$g(^PAPER(papmi,"PER","ADD",1))
	s company=$p(^PAPER(papmi,"PER",4),"^",18) //工作单位
	s presctype=""

	s getage=##class(web.DHCOutPhCommon).GetAge(papmi) 
	s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
	s sex=$p(^CT("SEX",sexdr),"^",2)
	s cardNo=""
	s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""),-1)
	s:cfRowId'="" cardNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
	s credno=$p(^PAPER(papmi,"ALL"),"^",9)      
	s admdate=""
	s admdate=$p(^PAADM(adm),"^",6)
	i admdate'="" s admdate=$zd(admdate,3)
	s diagnodesc=""
	s patW=##class(web.DHCOutPhCommon).GetPatWeight(adm)
	s deplocdr=$p(^PAADM(adm),"^",4)
	s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
	i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
	s warddesc=""
    s currwarddr=$p(^PAADM(adm),"^",70)
    i currwarddr'="" d
    .s ctlocdr=$p($g(^PAWARD(currwarddr)),"^",5)
    .s warddesc=$p(^CTLOC(ctlocdr),"^",2)
    .i warddesc["-" s warddesc=$p(warddesc,"-",2)
    .s deplocdesc=deplocdesc_"["_warddesc_"]"
	s (pyname,pydate,pytime,fyname,fydate,fytime)=""  
	s phdispid=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1)
   	i phdispid'="" d
    .s pyuserdr=$p(^DHCPHDISP(phdispid,1),"^",3)
    .i pyuserdr'="" s pyname=$p(^DHCPHPER(pyuserdr),"^",2)
    .s fyuserdr=$p(^DHCPHDISP(phdispid,1),"^",2)
    .i fyuserdr'="" s fyname=$p(^DHCPHPER(fyuserdr),"^",2)	    
	s phlocdr=$p(^DHCPHLOC(phl),"^",1)
	s recloc=$p(^CTLOC(phlocdr),"^",2) 
	i $F(recloc,"-") s recloc=$p(recloc,"-",2)
	s docstr=##class(web.DHCOutPhCommon).GetOrdDoc(prescno,phlocdr)
	s docctloc=$p(docstr,"^",1)
	s doctor=$p(docstr,"^",2)
	s orddate=$p(docstr,"^",3)
    s hospital=$p($g(^CTLOC(phlocdr)),"^",22)
    i hospital'="" s hospital=$p($g(^CT("HOSP",hospital)),"^",2)
    s admtype=$p(^PAADM(adm),"^",2)
    s mrno=##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(adm,admtype) //病历号
	s presctitle=##class(web.DHCOutPhTQDisp).GetPrescTitle(prescno)
	//草药
	s retstr=##class(web.DHCOutPhPrint).Getpaque(prescno)
	s queinst=$p(retstr,"^",1)
	s quefac=$p(retstr,"^",2) 
	s queqty=$p(retstr,"^",3)
	s quedate=$p(retstr,"^",4)
	s quexdate=$p(retstr,"^",5)
	s quenote=$p(retstr,"^",6)  
	s quecook=$p(retstr,"^",7)
	s queFreq=$p(retstr,"^",9)
	s sumamt=0
	s (paytype,PrescCount,DrugInfo,PrescConfig,auditname,patNation,mbDiagnos)=""			//医嘱改造后 草药处方用到的一些字段
	s patNation=$s(($D(^PAPER(papmi,"PER",2)))&&($p(^PAPER(papmi,"PER",2),"^",1)'=""):$p(^CT("NAT",$p(^PAPER(papmi,"PER",2),"^",1)),"^",2),1:"") //民族
	s paytype=##class(web.DHCOutPhCommon).GetPrescFeeType(prescno)
    s auditname=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhaomInfo(prescno),"^",3)
	s patstring=perno_"^"_pname_"^"_getage_"^"_sex_"^"_diagnodesc
	s patstring=patstring_"^"_patW_"^"_pyname_"^"_fyname_"^"_pydate_"^"_fydate
	s patstring=patstring_"^"_sysdate_"^"_recloc_"^"_company_"^"_admdate_"^"_cardNo
	s patstring=patstring_"^"_prescno_"^"_deplocdesc_"^"_""_"^"_ptel_"^"_paddress
	s patstring=patstring_"^"_quecook_"^"_queqty_"^"_presctitle_"^"_docctloc_"^"_doctor
    s patstring=patstring_"^"_queinst_"^"_quefac_"^"_queqty_"^"_quedate_"^"_quexdate
    s patstring=patstring_"^"_quenote_"^"_orddate_"^"_hospital_"^"_mrno _"^"_sumamt
    s patstring=patstring_"^"_paytype_"^"_PrescCount_"^"_DrugInfo_"^"_PrescConfig_"^"_auditname
    s patstring=patstring_"^"_patNation_"^"_queFreq_"^"_mbDiagnos
	s prescScgSet="",tmpPrescScgSet=""
	s sumamt=0
	s yprescno=reclocdr_"||"_yprescno
	s medstring="" 
	
	s psub=0  
	f  s psub=$o(^TMP("DHCST","web.DHCOutPhPrint","GetOrdInfoByPresc",PID,"PRESCNO",yprescno,psub)) q:(psub="")!(psub=0)  d
	.s index=0
	.f  s index=$o(^TMP("DHCST","web.DHCOutPhPrint","GetOrdInfoByPresc",PID,"PRESCNO",yprescno,psub,index)) q:(index="")!(index=0)  d
	..s data=^TMP("DHCST","web.DHCOutPhPrint","GetOrdInfoByPresc",PID,"PRESCNO",yprescno,psub,index)
	..s orditem=$p(data,"^",1)
	..s dispqty=$p(data,"^",2)
	..s dispmoney=$p(data,"^",3)
	..s buom=$p(data,"^",4)
	..s arcitm=$p(data,"^",5)
	..s inci=$p(data,"^",6)
	..s price=+dispmoney/dispqty			//平均价格
	..s price=$fn(price,"",4)
	..s qty=dispqty 
	..s totalprice=dispmoney
	..s sumamt=sumamt+dispmoney
	..s itm=$p(orditem,"||",2)
	..s ord=$p(orditem,"||",1)
	..s priority=$p(^OEORD(ord,"I",itm,1),"^",8)     ;????
	..s priordesc=""
	..i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	..q:priordesc["自备"
	..s freq=""
	..s freqdr=+$p(^OEORD(ord,"I",itm,2),"^",4)
	..i (freqdr'=0)&&($d(^PHCFR(freqdr))) d
	...s freq=$p(^PHCFR(freqdr),"^",1)  ;用药频率
	...s freqCY=$p(^PHCFR(freqdr),"^",3)
	..s inst=$p(^OEORD(ord,"I",itm,2),"^",7)
	..i inst'="" s inst=$p($g(^PHCIN(inst)),"^",2)  ;用法 
	..s phdur=$p(^OEORD(ord,"I",itm,2),"^",6)
	..i phdur'="" s phdur=$p($g(^PHCDU(phdur)),"^",1) ;用药疗程  	
	..//s dosage=$p(^OEORD(ord,"I",itm,2),"^",1) ;用药剂量
	..s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(orditem)
	..s dosageuomdr=$p(^OEORD(ord,"I",itm,2),"^",3)
	..s dosageuom=""
	..s:dosageuomdr'="" dosageuom=$p(^CT("UOM",dosageuomdr),"^",2)   ;剂量单位 	
	..i +dosage=0 s dosageuom="",dosage="" 
	..s genedesc=""		//通用名
	..s (Spec)=""
	..i arcitm'=""  d
	...s inciflag=##class(web.DHCOutPhCommon).GetIncFlagByArc(arcitm)		//依据医嘱项获取库存项是否唯一
	...i (cypresc'=1)&&(inciflag=1) d
	....s inci=$o(^INCI(0,"ARCIM_DR",+arcitm,""))
	....s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	....s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(inci,qty)
	....s qty=$p(qtyinfo,"^",1)
	....s unit=$p(qtyinfo,"^",2)
	...e  d
	....s qty=qty
  	....s unit=$p(^CT("UOM",buom),"^",2)
	...s phcdf=$p($g(^ARCIM(+arcitm,$p(arcitm,"||",2),1)),"^",12) 
  	...i +phcdf'=0  d
  	....s gene=$p($g(^PHCD(+phcdf,4)),"^",1) 
  	....q:gene=""
  	....s genedesc=$p($g(^PHCGE("GE",gene)),"^",2)
  	...s incidesc=$p($g(^ARCIM(+arcitm,$p(arcitm,"||",2),1)),"^",2) 
  	..e  d
  	...s gene=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inci)
	...s genedesc=$p(gene,"^",2) ;通用名
	...s incidesc=$p(^INCI(inci,1),"^",2)
	...s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	...s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(inci,qty)
	...s qty=$p(qtyinfo,"^",1)
	...s unit=$p(qtyinfo,"^",2) 
	..s skintest=""
    ..s skinresult=##class(web.DHCSTCOMMONORDER).OeoriSkinTest(ord_"||"_itm)
    ..s skintest=$p(skinresult,"^",2)
	..s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(ord_"||"_itm)
	..i ordremark=""  s ordremark=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
	..s specinstr=$p(^OEORD(ord,"I",itm,2),"^",8) 
	..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) 
	..s GrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetOrderCategoryByArcim(arcimid)
	..s scgSet=$p(GrpInfo,"^",2)
	..i scgSet="" s scgSet="Mix"
	..i scgSet["草药" s scgSet="GC"
	..i tmpPrescScgSet="" s prescScgSet=scgSet
	..e  i tmpPrescScgSet'=scgSet s prescScgSet="Mix"
	..s tmpPrescScgSet=scgSet
	..s (PhSpecInstr,fontflag)=""
	..s price=##Class(web.DHCSTCOMMPARA).GetNumbDec(price,"","FmtSP",1)
    ..i (price>0)&&(price<1) s price="0"_price
    ..s totalprice=##Class(web.DHCSTCOMMPARA).GetNumbDec(totalprice,"","FmtSP",1)
    ..i (totalprice>0)&&(totalprice<1) s totalprice="0"_totalprice
    ..s tmpsting=incidesc_skintest_"^"_qty_"^"_unit_"^"_dosage_"^"_inst_"^"_freq_"^"_phdur_"^"_price_"^"_totalprice_"^"_skintest_"^"_ordremark_"^"_genedesc_skintest_"^"_PhSpecInstr_"^"_fontflag
	..i medstring="" d
	...s medstring=tmpsting
	..e  d
	...s medstring=medstring_"@"_tmpsting
	k ^TMP("DHCST","web.DHCOutPhPrint","GetOrdInfoByPresc",PID,"PRESCNO")
	s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",","")
    s $p(patstring,"^",5)=diagnodesc
	s $p(patstring,"^",35)=sumamt   //处方总金额
	q patstring_"!!"_medstring
}

ClassMethod Getpaque(prescno As %String) As %String
{
   ;获得中草药信息 PA_Que1 
    
   q:prescno="" ""
   s queid=""
   s questr=""
   f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
   .q:'$d(^PAQUE1(queid,"DHC"))
   .s insdr=$p(^PAQUE1(queid,"DHC"),"^",11)
   .s Instruc=""
   .s:insdr'="" Instruc=$p(^PHCIN(insdr),"^",2) ;用法
   .s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
   .s facotor=1
   .s:durdr'="" facotor=$p(^PHCDU(durdr),"^",2) ;剂数
   .s orderqty=$p(^PAQUE1(queid,"DHC"),"^",13) ;用量
   .s quedate=$p(^PAQUE1(queid,"DHC"),"^",6) ;开始时间
   .s quexdate=quedate+facotor-1
   .i $g(quedate)'="" s quedate=$zd(quedate,3)
   .i $g(quexdate)'="" s quexdate=$zd(quexdate,3)
   .s preno=$p(^PAQUE1(queid),"^",14) ;处方号
   .s type=$p(^PAQUE1(queid,"DHC"),"^",15) ;方式
   .s notes=$p(^PAQUE1(queid,"DHC"),"^",21) ;备注
   .;频次
   .s FreqDr=$P(^PAQUE1(queid,"DHC"),"^",9)
   .s FreqDesc=$s(FreqDr'="":$p(^PHCFR(FreqDr),"^",3),1:"")	
   .s FreqFac=$s(FreqDr'="":$p(^PHCFR(FreqDr),"^",2),1:1)	
   .s questr=Instruc_"^"_facotor_"^"_orderqty_"^"_$g(quedate)_"^"_$g(quexdate)_"^"_notes_"^"_type_"^"_FreqFac_"^"_FreqDesc
   .
   q $g(questr)
}

/// Description:门诊药房打印欠药单
/// Creator:Liang Qiang
/// CreatDate:2011-07-28
/// Input:发药单Rowid
/// Output:打印所需内容
/// w ##class(web.DHCOutPhPrint).GetOweListInfo(978)
ClassMethod GetOweListInfo(owe As %String) As %String
{
    s oweretdate=$p(^DHCPHOW(owe),"^",10)
    i oweretdate'="" s oweretdate=$zd(oweretdate,3)
    s owerettime=$p(^DHCPHOW(owe),"^",11)
    i owerettime'="" s owerettime=$zt(owerettime,1)
    s oweretuser=""
    s oweretuser=$p(^DHCPHOW(owe),"^",12)
    i oweretuser'="" s oweretuser=$p(^DHCPHPER(oweretuser) ,"^",2)
	s owedate=$p(^DHCPHOW(owe),"^",3)
	i owedate'="" s owedate=$zd(owedate,3)
	s papmi=$p(^DHCPHOW(owe),"^",9)
	s patname=$p(^PAPER(papmi,"ALL"),"^",1) 
	s patId=$p(^PAPER(papmi,"PAT",1),"^",2)
	s patsex=$p(^PAPER(papmi,"ALL"),"^",7)
    s:patsex'="" patsex=$p($g(^CT("SEX",patsex)),"^",2)
	s patage=##class(web.DHCOutPhCommon).GetAge(papmi) 
	s diagnose=""
	s prescno=$p(^DHCPHOW(owe),"^",6)
	s locid=$p(^DHCPHOW(owe),"^",2)
	s locdesc=$p(^CTLOC(locid),"^",2)
	i locdesc["-" s locdesc=$p(locdesc,"-",2)
    s admord=$o(^OEORD(0,"PrescNo",prescno,""))
    s adm=$p(^OEORD(admord),"^",1)
    s admdate=""
    s admdate=$p(^PAADM(adm),"^",6)
    i admdate'="" s admdate=$zd(admdate,3)
    s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",")
    s deplocdr=$p(^PAADM(adm),"^",4)
    s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
    i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)  
    s docstr=##class(web.DHCOutPhCommon).GetOrdDoc(prescno,locid)
    s docctloc=$p(docstr,"^",1)
    s doctor=$p(docstr,"^",2) 
    s printdate=$zd(+$h,3)                        
	s maininfo=patname_"^"_owedate_"^"_oweretdate_"^"_oweretuser_"^"_patId 
	s maininfo=maininfo_"^"_patsex_"^"_patage_"^"_prescno_"^"_deplocdesc_"^"_diagnose
	s maininfo=maininfo_"^"_locdesc_"^"_doctor_"^"_printdate
	s detailinfo=""
	k GetOweListInfoData
	s phoi=""
	f  s phoi=$o(^DHCPHOW(owe,"I",phoi)) q:phoi=""  d
	.q:+phoi=0
	.s oeori=$p(^DHCPHOW(owe,"I",phoi),"^",1)
	.s qty=$p(^DHCPHOW(owe,"I",phoi),"^",2)
	.s sp=$p(^DHCPHOW(owe,"I",phoi),"^",3)
	.s inci=$p(^DHCPHOW(owe,"I",phoi),"^",5)  
	.s spamt=qty*sp
	.s uniqueIndex=oeori_"^"_inci
	.i '$d(GetOweListInfoData(uniqueIndex)) d
	..s GetOweListInfoData(uniqueIndex)=oeori_"^"_qty_"^"_sp_"^"_spamt_"^"_inci
	.e  d
	..s $p(GetOweListInfoData(uniqueIndex),"^",2)=qty+$p(GetOweListInfoData(uniqueIndex),"^",2)
	..s $p(GetOweListInfoData(uniqueIndex),"^",4)=spamt+$p(GetOweListInfoData(uniqueIndex),"^",4)
	s uniqueIndex=""
	f  s uniqueIndex=$o(GetOweListInfoData(uniqueIndex)) q:uniqueIndex=""  d
	.s uniqueData=GetOweListInfoData(uniqueIndex)
	.s oeori=$p(uniqueData,"^",1)
	.s qty=$p(uniqueData,"^",2)
	.s price=$p(uniqueData,"^",3)
	.s money=$p(uniqueData,"^",4)
	.s inci=$p(uniqueData,"^",5)
	.s ord=+oeori
	.s itm=$p(oeori,"||",2)
	.s itmmast=$p(^OEORD(+ord,"I",itm,1),"^",2)  
	.s desc=$p(^INCI(inci,1),"^",2)
	.s dispuomid=$p($g(^OEORD(+ord,"I",+itm,"DHC")),"^",13)
	.i dispuomid'="" d
	..s qtyuomstr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(inci,qty,dispuomid)
	.e  d
	..s qtyuomstr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(inci,qty)
    .s qty=$p(qtyuomstr,"^",1)
    .s uomid=$p(qtyuomstr,"^",2)
    .s confac=$p(qtyuomstr,"^",3)
	.s price=price*confac
	.s price=$fn(price,"",4)
	.s money=$fn(money,"",2)
	.s uomdesc=$p($g(^CT("UOM",uomid)),"^",2)
   	.s freq=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(oeori),"^",3)
   	.s inst=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(oeori),"^",2)
	.s phdur=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(oeori),"^",2)
	.s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
	.s str=desc_"^"_uomdesc_"^"_qty_"^"_price_"^"_money_"^"_freq_"^"_inst_"^"_dosage
	.i detailinfo="" d
	..s detailinfo=str
	.e  d
	..s detailinfo=detailinfo_$c(2)_str
	s retvalue=maininfo_$c(1)_detailinfo
	q retvalue
}

/// 返回最新的欠药单ID liangqiang
ClassMethod GetOwe(phdrowid As %String) As %String
{
	s prescno=$p(^DHCPHDISP(phdrowid,2),"^",1)
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	s adm=$p(^OEORD(ord),"^",1)
	s papmi=$p(^PAADM(adm),"^",1) 
	s owe=$o(^DHCPHOWi(0,"PAPMI",papmi,prescno,""),-1)
	q owe
}

/// 获取补给单数据准备打印
/// w ##class(web.DHCOutPhPrint).GetSuppData("1")
ClassMethod GetSuppData(supp) As %String
{
 
    s i=0
    s pid=##CLASS(web.DHCSTKUTIL).GetOutDispCounter()
    s type=$p(^DHCPHSUPP(supp),"^",8)
    s ward=""
    s warddr=$p(^DHCPHSUPP(supp),"^",5)
    s:warddr'="" ward=$p(^CTLOC(warddr),"^",2)  
    s docloc=""
    s doclocdr=$p(^DHCPHSUPP(supp),"^",6)
    s:doclocdr'="" docloc=$p( ^CTLOC(doclocdr) ,"^",2)
    s chl=""
    f  s chl=$o(^DHCPHSUPPI(supp,"I",chl)) q:chl=""  d
    .s pointer=$p(^DHCPHSUPPI(supp,"I",chl),"^",1)
    .i type="P" d
    ..s phac=$p(pointer,"||",1)
    ..s sub=$p(pointer,"||",2)
    ..s oeori=$p(^DHCPHAC(phac,"I",sub),"^",7)
	..s qty=$p(^DHCPHAC(phac,"I",sub),"^",6) 
	..s resqty=+$p(^DHCPHAC(phac,"I",sub),"^",12)
    .i type="F" d
    ..s pha=$p(pointer,"||",1)
    ..s sub=$p(pointer,"||",2)
    ..s oeori=$p(^DHCPHDI(pha,"PHDI",sub),"^",5)
    ..s phaclb=""
    ..f  s phaclb=$o(^DHCPHDI(pha,"PHDI",sub,"INCLB",phaclb)) q:phaclb=""  d
    ...s qty=$p(^DHCPHDI(pha,"PHDI",sub,"INCLB",phaclb),"^",1)
    ...s resqty=0
	..//s qty=$p(^DHCPHDI(pha,"PHDI",sub),"^",4) 
	..//s resqty=0
    .s arcimid=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
    .s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))
    .s incicode=$p(^INCI(inci,1),"^",1)
	.s incidesc=$p(^INCI(inci,1),"^",2)
    .s qty=qty-resqty
    .q:qty=0
	.s spec=##class(web.DHCSTKUTIL).GetSpec(inci)
	.s phalocdr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",6)
	.s phaloc=$p( ^CTLOC(phalocdr) ,"^",2)
	.s i=i+1
	.s sysdate=$zd(+$h,3)
	.s systime=$zt($p($h,",",2),1)
	.s sysdate=sysdate_" "_systime
	.s info=incicode_"^"_incidesc_"^"_qty_"^"_spec_"^"_ward_"^"_docloc_"^"_phaloc_"^"_sysdate
	.i '$d(^TMP("DHCOutPh","SUPP","ITM",pid,inci)) d
	..s ^TMP("DHCOutPh","SUPP","ITM",pid,inci)=info
	.e  d
	..s $p(^TMP("DHCOutPh","SUPP","ITM",pid,inci),"^",3)=$p(^TMP("DHCOutPh","SUPP","ITM",pid,inci),"^",3)+qty
	
	s h=0
	s inci=""
    f  s inci=$o(^TMP("DHCOutPh","SUPP","ITM",pid,inci)) q:inci=""  d
    .s h=h+1
    .s info=^TMP("DHCOutPh","SUPP","ITM",pid,inci)
    .s qty=$p(info,"^",3)
    .s qty=##class(web.DHCSTPCHCOLLPRN).getPackQty(inci,qty)
    .s $p(info,"^",3)=qty
    .s ^TMP("DHCOutPh","SUPP","PRTITM",pid,h)=info
    k ^TMP("DHCOutPh","SUPP","ITM",pid)
    q pid_"^"_h
}

ClassMethod ListSuppData(pid, i) As %String
{
 
   s str=^TMP("DHCOutPh","SUPP","PRTITM",pid,i)
   k ^TMP("DHCOutPh","SUPP","PRTITM",pid,i)
   q str
}

/// 获取关联医嘱打印序号
ClassMethod GetOrdItmSeqNo(mord, pid)
{
 
   s seqno=1
   s lchl=""
   s moeori=""
   f  s moeori=$O(^OEORDi(0,"OEORI",mord,moeori))	q:moeori=""  d
   .s mchl=$p(moeori,"||",2)
   .q:'$d(^OEORD(mord,"I",mchl,1))
   .;s prescno=$p(^OEORD(mord,"I",mchl,1),"^",14)
   .;q:prescno=""  //过滤非药品
   .s ArcimRowid=$p(^OEORD(mord,"I",mchl,1),"^",2)
   .s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
   .s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
   .q:OrderType'="R"
   .s dsp=$o(^DHCOEDISQTY(0,"OEORI",moeori,"")) 
   .s qty=""
   .s:dsp'="" qty=$p(^DHCOEDISQTY(dsp),"^",2)
   .s retqty=##class(web.DHCOutPhReturn).GetRetOrdQty(moeori,"")
   .s qty=qty-retqty
   .q:qty'>0
   .s ^TMP("DHCOutPh","web.DHCOutPhPrint","GetOrdItmSeqNo",pid,"OrdItem",mord_"||"_mchl)=seqno
   .s h=0
   .s lchl=""
   .f  s lchl=$O(^OEORDi(0,"OEORI",mord,moeori,lchl))	q:lchl=""  d
   ..;s prescno=$p(^OEORD(mord,"I",lchl,1),"^",14)
   ..;q:prescno=""
   ..s ArcimRowid=$p(^OEORD(mord,"I",lchl,1),"^",2)
   ..s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
   ..s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
   ..q:OrderType'="R"
   ..s loeori=mord_"||"_lchl
   ..s dsp=$o(^DHCOEDISQTY(0,"OEORI",loeori,"")) 
   ..s qty=""
   ..s:dsp'="" qty=$p(^DHCOEDISQTY(dsp),"^",2)
   ..s retqty=##class(web.DHCOutPhReturn).GetRetOrdQty(loeori,"")
   ..s qty=qty-retqty
   ..q:qty'>0
   ..s h=h+1
   ..s ^TMP("DHCOutPh","web.DHCOutPhPrint","GetOrdItmSeqNo",pid,"OrdItem",mord_"||"_lchl)=seqno_"."_h
   .
   .s seqno=seqno+1
   .
   
   q 0
}

/// creator:yunhaibao
/// createdate:20160627
/// description:打印标签统一调用,方法中调用原方法,以便与原版本兼容
/// w ##class(web.DHCOutPhPrint).GetPrintRow(ctloc,prt,prescno)
ClassMethod GetPrintRow(ctloc, prt, prescno)
{
	q:ctloc="" ""
	q:'$d(^DHCPHLOCi("LOC",ctloc)) ""
	s phloc=$o(^DHCPHLOCi("LOC",ctloc,""))
	s printrow=##class(web.DHCOutPhAdd).GetPrintRow(phloc,prt,prescno)
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	s adm=$p(^OEORD(ord),"^",1)
	s papmi=$p(^PAADM(adm),"^",1)	  
	s patno=$p(^PAPER(papmi,"PAT",1),"^",2)
	s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	s sysdate=$zd(+$h,3)
	s patinfo=patno_"^"_patname_"^"_sysdate
	q patinfo_"!!"_printrow
}

/// creator:yunhaibao
/// createdate:20161121
/// description:根据发药id获取欠药单id,用于直接发药以及欠药后打印,发药后对应的最后一条即是
/// w ##class(web.DHCOutPhPrint).GetPhOweByPhd(492)
ClassMethod GetPhOweByPhd(phdrowid)
{
	
	Q:phdrowid="" ""
	s prescno=$p($g(^DHCPHDISP(phdrowid,2)),"^",1)
	q:prescno="" ""
	s papmi=$p($g(^DHCPHDISP(phdrowid)),"^",7)
	q:papmi="" ""
	s phowe=""
	s phoweid=""
	f  s phoweid=$o(^DHCPHOWi(0,"PAPMI",papmi,prescno,phoweid)) q:(phoweid="")||(phowe'="")  d
	.s phowestatus=$p(^DHCPHOW(phoweid),"^",8)
	.q:phowestatus'=""
	.s phowe=phoweid
	q phowe
}

}
