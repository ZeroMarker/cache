Import sqluser

/// creator: 	 yunhaibao
/// createdate:	 2018-11-19
/// description: 处方集中打印
Class web.DHCOUTPHA.PrescQuery.Query Extends %RegisteredObject
{

/// description: 获取处方
/// startdate+tmpSplit+enddate+tmpSplit+ctloc+tmpSplit+pmino+tmpSplit+starttime+tmpSplit+endtime+tmpSplit+admloc+tmpSplit+presctype;
ClassMethod CollPresc(InputStr)
{
	s CS="|@|"
	s StartDate=$p(InputStr,CS,1)
	s EndDate=$p(InputStr,CS,2)
	s PhaLocId=$p(InputStr,CS,3)
	s PatNo=$p(InputStr,CS,4)
	s StartTime=$p(InputStr,CS,5)
	s EndTime=$p(InputStr,CS,6)
	s DocLocId=$p(InputStr,CS,7)
	s PrescType=$p(InputStr,CS,8)
	q:PhaLocId="" ""
	i (StartTime="00:00")||(StartTime="00:00:00") s StartTime=""
	i (EndTime="23:59")||(EndTime="23:59:59") s EndTime=""
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s pid=..NewPid()
	s PatId=""
	i PatNo'="" &SQL(SELECT PAPMI_RowId1 into :PatId FROM PA_PatMas WHERE PAPMI_No=:PatNo)
	i PatId="" d
	.s calcuDate=""
	.f calcuDate=StartDate:1:EndDate d
	..s ordId=""
	..f  s ordId=$o(^OEORDi(0,"LocStDtArr",PhaLocId,0,calcuDate,ordId)) q:ordId=""  d
	...q:+ordId=0
	...s admId=$p(^OEORD(ordId),"^",1)
	...s admType=$p(^PAADM(admId),"^",2)
	...q:admType="I"
	...s ordItm=""
	...f  s ordItm=$o(^OEORDi(0,"LocStDtArr",PhaLocId,0,calcuDate,ordId,ordItm)) q:ordItm=""  d
	....q:+ordItm=0
	....d CalcuPrescData
	e  d
	.s admType=""
	.f  s admType=$o(^PAPERdr(PatId,"ADM",admType)) q:admType=""  d
	..q:admType="I"
	..s admId=""
	..f  s admId=$o(^PAPERdr(PatId,"ADM",admType,admId)) q:admId=""  d
	...q:+admId=0
	...s ordId=""
	...f  s ordId=$o(^OEORD(0,"Adm",admId,ordId)) q:ordId=""  d
	....q:+ordId=0
	....s ordItm=0
	....f  s ordItm=$o(^OEORD(ordId,"I",ordItm)) q:ordItm=""  d
	.....q:+ordItm=0
	.....q:PhaLocId'=$p(^OEORD(ordId,"I",ordItm,3),"^",6)
	.....s date=$p(^OEORD(ordId,"I",ordItm,3),"^",7)
	.....s ordDate=$p(^OEORD(ordId,"I",ordItm,3),"^",7)
	.....q:((ordDate<StartDate)||(ordDate>EndDate))
	.....d CalcuPrescData
	q pid
CalcuPrescData
	s quitFlag=""
	s oeori=ordId_"||"_ordItm
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId=""
	s arcItmId=$P(^OEORD(ordId,"I",ordItm,1),"^",2)
	q:+arcItmId=0
	s arcItmCatId=$p(^ARCIM(+arcItmId,1,1),"^",10)
 	q:arcItmCatId=""
 	s dspStatus=$p(^DHCOEDISQTY(dspId),"^",7)
 	s billFlag=$p($g(^OEORD(ordId,"I",ordItm,3)),"^",5)
 	s oeoriStatCode=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",1)
	q:(dspStatus'="C")&&(billFlag'="P")&&((oeoriStatCode'="V")&&(oeoriStatCode'="E"))	
 	// 过滤-非药品
 	q:$p($g(^ARC("IC",arcItmCatId)),"^",7)'="R"
 	s prescNo=$P(^OEORD(ordId,"I",ordItm,1),"^",14)
 	q:$d(CollPrescArr("PrescNo",prescNo))
	q:$d(^TMP("DHCST",$ClassName(),"CollPresc",pid,admId,prescNo))
	// 过滤条件-开单科室
	i DocLocId'="" d
	.s docLocId=$p(##class(web.DHCSTCOMMONORDER).OeoriDocLoc(oeori),"^",1)
	.i docLocId'=DocLocId s CollPrescArr("PrescNo",prescNo)="",quitFlag=1
	q:quitFlag'=""
	// 过滤条件-处方类别
	i PrescType'="" d
	.s prescTypeDesc=##class(web.DHCOutPhCommon).GetPrescTitle(prescNo)
	.i PrescType'=prescTypeDesc s CollPrescArr("PrescNo",prescNo)="",quitFlag=1
	q:quitFlag'=""
	// 过滤条件-登记号的开始结束日期
	// 过滤条件-时间
	s ^TMP("DHCST",$ClassName(),"CollPresc",pid,admId,prescNo)=oeori
	q
}

/// description: 获取处方列表
/// w ##class(web.DHCOUTPHA.PrescQuery.Query).GetPrescMain("1","100","14/11/2018|@|14/11/2018|@|310|@|0000000008|@|11:26|@|23:59|@||@|","1")
ClassMethod GetPrescMain(StartRow, EndRow, InputStr, Pid = "")
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.PrescQuery.Query","GetPrescMain")=$lb(StartRow, EndRow, InputStr, Pid = "")
	i Pid'="" s pid=Pid
	e  s pid=..CollPresc(InputStr)
	q:pid="" ""
	s PhaLocId=$p(InputStr,"|@|",3)
	s HospId=$p(^CTLOC(PhaLocId),"^",22)
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospId)
	s count=0
	s admId=""
	f  s admId=$o(^TMP("DHCST",$ClassName(),"CollPresc",pid,admId)) q:admId=""  d
	.s prescNo=""
	.f  s prescNo=$o(^TMP("DHCST",$ClassName(),"CollPresc",pid,admId,prescNo)) q:prescNo=""  d
	..s count=count+1
	..q:count<StartRow
    ..q:count>EndRow
	..s tmpOeori=^TMP("DHCST",$ClassName(),"CollPresc",pid,admId,prescNo)
	..s tmpOrd=+tmpOeori
	..s tmpOrdItm=+$p(tmpOeori,"||",2)
	..s admId=$p(^OEORD(tmpOrd),"^",1) 
	..s patId=$p(^PAADM(admId),"^",1)
	..s patName=$p(^PAPER(patId,"ALL"),"^",1)
	..s patNo=$p(^PAPER(patId,"PAT",1),"^",2)
    ..i EncryptFlag=1 d
 	...s encryptLevelInfo=##class(web.DHCSTInterfaceFromElse).GetPatEncryptLevel(patId)
 	...s encryptLevel=$p(encryptLevelInfo,"^",1)
 	...s patLevel=$p(encryptLevelInfo,"^",2)
 	..e  s (encryptLevel,patLevel)=""
	..s docLocDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriDocLoc(tmpOeori),"^",2)
	..s oeoriDateTime=##class(web.DHCSTCOMMONORDER).OeoriDateTime(tmpOeori)
	..s diagDesc=##class(web.DHCSTCOMMONORDER).MrDiagnose(admId,",")
	..s admReasonDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriAdmReason(tmpOeori),"^",2)
	..s curWardId=$p(^PAADM(admId),"^",70)
	..i curWardId'="" d
	...s curWardLocId=$p(^PAWARD(curWardId),"^",5)
	...s wardDesc=$p(^CTLOC(curWardLocId),"^",2)
	...i wardDesc["-" s wardDesc=$p(wardDesc,"-",2)
	...s docLocDesc=docLocDesc_"["_wardDesc_"]"
	..s prescRemark=""
	..i $d(^PAQUE1(0,"PrescNo",prescNo)) d
	...s queId=$o(^PAQUE1(0,"PrescNo",prescNo,""))
	...s prescRemark=$P($g(^PAQUE1(+queId,"DHC")),"^",21)
	..s (pyUserName,fyUserName,fyDate,fyTime,winDesc)=""
	..s phdId=$o(^DHCPHDISPi("PRESCNO",prescNo,"")) // 以第一次发药作为发药数据显示
	..i phdId'="" d
	...s fyPersonId=$p(^DHCPHDISP(phdId,1),"^",2)
	...s pyPersonId=$p(^DHCPHDISP(phdId,1),"^",3)
	...s fyDate=$p(^DHCPHDISP(phdId),"^",3)
	...s fyTime=$p(^DHCPHDISP(phdId),"^",5)
	...s fyUserName=$p($g(^DHCPHPER(+fyPersonId)),"^",2)
	...s pyUserName=$p($g(^DHCPHPER(+pyPersonId)),"^",2)
	...s fyDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(fyDate)
	...s fyTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(fyTime)
	...s winId=$p(^DHCPHDISP(phdId,1),"^",4)
	...s winDesc=$p($g(^DHCPHWIN(+winId)),"^",1)
	..// 处方集中打印的药费为发减退
	..s spAmt=##class(web.DHCOutPhCommon).GetPrescAmt(prescNo)
	..s retSpAmt=##class(web.DHCOutPhCommon).GetPrescRetAmt(prescNo)
	..s spAmt=spAmt-retSpAmt
	..s pharId=$o(^DHCPHARi("PRESCNO",prescNo,""),-1)
	..s (prtTime,prtDate)=""
	..i pharId'="" d
	...s prtDate=$p(^DHCPHARW(pharId),"^",2)
	...s prtTime=$p(^DHCPHARW(pharId),"^",5)
	...s prtDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prtDate)
	...s prtTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(prtTime)
	..s prescType=##class(web.DHCOutPhCommon).GetPrescTitle(prescNo)
	..s prescStat=""
	..s data1=prescNo_"^"_patNo_"^"_patName_"^"_spAmt_"^"_pyUserName
	..s data2=fyUserName_"^"_admReasonDesc_"^"_docLocDesc_"^"_prescRemark_"^"_diagDesc
	..s data3=oeoriDateTime_"^"_prtDate_"^"_fyDate_"^"_prtTime_"^"_fyTime
	..s data4=pid_"^"_encryptLevel_"^"_patLevel_"^"_prescType_"^"_winDesc
	..s data5=prescStat
	..s data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5	
	..s ^TMP("DHCST",$ClassName(),"GetPrescMain",pid,count)=data
	q pid_"^"_count
}

/// description: 获取处方明细
ClassMethod GetPrescItm(InputStr)
{
	s PrescNo=$p(InputStr,"|@|",1)
	q:PrescNo="" ""
	s pid=..NewPid()
	s count=0
	s ordId=0
	f  s ordId=$o(^OEORD(0,"PrescNo",PrescNo,ordId))  q:ordId=""  d 
	.s admId=$p(^OEORD(ordId),"^",1)
	.s admType=$p(^PAADM(admId),"^",2)
	.s ordItm=0
	.f  s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,ordItm)) q:ordItm=""  d
	..s oeori=ordId_"||"_ordItm
	..s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	..q:dspId=""
	..s billFlag=$p(^OEORD(ordId,"I",ordItm,3),"^",5)  		// P已缴费
	..s quitFlag=""
	..s priStr=##class(web.DHCSTCOMMONORDER).OeoriPriority(oeori)
	..// 过滤-自备
	..q:priStr["OM"
	..s oeoriStatCode=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",1)
	..// 过滤-未发药未交费停医嘱
 	..s dspStatus=$p(^DHCOEDISQTY(dspId),"^",7)
	..q:(dspStatus'="C")&&(billFlag'="P")&&((oeoriStatCode'="V")&&(oeoriStatCode'="E"))
	..s spAmt=0
	..s dspSub=0
	..f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	...s dspSubId=dspId_"||"_dspSub
	...s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	...s inclb=$p(dspSubData,"^",1)
	...s incId=$p(dspSubData,"^",5)
	...s qty=$p(dspSubData,"^",2)
	...i (billFlag="P")&&(admType'="H") d
	....s prtPriceStr=##class(web.DHCOutPhCommon).GetBasePriceByOe(oeori,dspSubId)
	....s sp=$p(prtPriceStr,"^",1)
	....s dspSpAmt=$p(prtPriceStr,"^",2)
	...e  d
	....s getSpInc=incId
	....i inclb'="" s getSpInc=inclb
	....s recLocId=$p(^OEORD(ordId,"I",ordItm,3),"^",6) 
	....s hospId=$p(^CTLOC(recLocId),"^",22)
	....s spDate=$p($g(^OEORD(ordId,"I",ordItm,3)),"^",7)
	....s sp=##class(web.DHCSTPRICE).GetSp(getSpInc,+spDate,"",hospId,"","")
	....s dspSpAmt=sp*qty
	....s perv="^^^^"_hospId_"^DHC"
	....s dspSpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(dspSpAmt,perv,"FmtSA",1)
	...s spAmt=spAmt+dspSpAmt
	..s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
	..s arcItmDesc=$p(^ARCIM(+arcItmId,1,1),"^",2)
	..s freqDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(oeori),"^",4)
	..s oeoriStatDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",2)
	..s instrucDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(oeori),"^",2)
	..s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
	..s duraDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(oeori),"^",2)
	..s oeoriRemark=$p($g(^OEORD(ordId,"I",ordItm,2)),"^",8)
	..i oeoriRemark="" s oeoriRemark=##class(web.DHCSTCOMMONORDER).OeoriRemark(oeori)
	..s docName=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(oeori),"^",2)
	..s qtyData=..GetOeoriQtyData(oeori)	
	..s dispQty=$p(qtyData,"^",1)
	..s retQty=$p(qtyData,"^",2)
	..s oeoriQty=$p(^DHCOEDISQTY(dspId),"^",5)
	..s tmpIncId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
 	..s stkGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(tmpIncId)
 	..q:$p(stkGrpStr,"^",3)'="G" 
 	..s struModeFlag=$p(stkGrpStr,"^",7)
 	..i struModeFlag="Y" d
 	...s phcdfId=$p(^ARCIM(+arcItmId,1,1),"^",12)
    ...s uomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
    ...s sp=spAmt/oeoriQty
    ..e  d
    ...s dispUomId=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",13)
    ...i dispUomId'="" d
    ....s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,oeoriQty,dispUomId)
    ...e  d
    ....s fmtQtyUom=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(tmpIncId,oeoriQty)
	...s oeoriQty=$p(fmtQtyUom,"^",1)
	...s uomId=$p(fmtQtyUom,"^",2)
	...s fac=$p(fmtQtyUom,"^",3)
    ...s dispQty=dispQty/fac
    ...s retQty=retQty/fac
    ...s sp=spAmt/oeoriQty
    ..s uomDesc=$p(^CT("UOM",uomId),"^",2)
    ..s data1=arcItmDesc_"^"_oeoriQty_"^"_uomDesc_"^"_spAmt_"^"_retQty
	..s data2=freqDesc_"^"_instrucDesc_"^"_duraDesc_"^"_dosage_"^"_oeoriStatDesc
	..s data3=oeoriRemark_"^"_docName_"^"_dispQty_"^"_sp
	..s data=data1_"^"_data2_"^"_data3
	..s count=count+1
	..s ^TMP("DHCST",$ClassName(),"GetPrescItm",pid,count)=data
	q pid_"^"_count
}

/// description: 获取医嘱的实发数量^已退数量(与打包表数量对应单位一致)
/// w ##class(web.DHCOUTPHA.PrescQuery.Query).GetOeoriQtyData("957||2")
ClassMethod GetOeoriQtyData(Oeori)
{
	k GetOeoriQtyData
	q:Oeori="" ""
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	q:dspId="" ""
	s dspSub=0
	f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	.s dspSubId=dspId_"||"_dspSub
	.s phdId=""
	.f  s phdId=$o(^DHCPHDIi("DSPB",dspSubId,phdId))  q:(phdId="")  d
	..s phdItm=""
	..f  s phdItm=$o(^DHCPHDIi("DSPB",dspSubId,phdId,phdItm))  q:(phdItm="")  d
	...s phdItmLb=""
	...f  s phdItmLb=$o(^DHCPHDIi("DSPB",dspSubId,phdId,phdItm,phdItmLb))  q:(phdItmLb="")  d
	....q:'$d(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb)) 
	....s phdItmLbData=^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb)
	....s dispQty=+$p(phdItmLbData,"^",1)
	....s retQty=+$p(phdItmLbData,"^",2)
	....s incId=+$p(phdItmLbData,"^",3)
	....i '$d(GetOeoriQtyDataData(incId)) d
	.....s GetOeoriQtyDataData(incId)=dispQty_"^"_retQty
	....e  d
	.....s $p(GetOeoriQtyDataData(incId),"^",1)=$p(GetOeoriQtyDataData(incId),"^",1)+dispQty
	.....s $p(GetOeoriQtyDataData(incId),"^",2)=$p(GetOeoriQtyDataData(incId),"^",2)+retQty
	/// 做数量转换,一对多转为药学基本单位
	q:'$d(GetOeoriQtyDataData) ""
	s arcItmId=$p(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1),"^",2)
    s phcdfId=$p(^ARCIM(+arcItmId,1,1),"^",12)
    s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	s tmpIncId=$o(GetOeoriQtyDataData(""))
 	s stkGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(tmpIncId)
 	q:$p(stkGrpStr,"^",3)'="G" ""
 	s struModeFlag=$p(stkGrpStr,"^",7)
 	s oeoriDispQty=0,oeoriRetQty=0
 	s incId=""
 	f  s incId=$o(GetOeoriQtyDataData(incId)) q:incId=""  d
 	.s dispQty=$p(GetOeoriQtyDataData(incId),"^",1)
 	.s retQty=$p(GetOeoriQtyDataData(incId),"^",2)
 	.s bUomId=$p(^INCI(incId,1),"^",10)
 	.// 均转换为药学基本单位,一对多的药学单位为库存单位
 	.s fac=##class(web.DHCSTCOMMONSRV).UOMFac(bUomId,phcUomId)
 	.s dispQty=dispQty*fac
 	.s retQty=retQty*fac
 	.s oeoriDispQty=oeoriDispQty+dispQty
 	.s oeoriRetQty=oeoriRetQty+retQty
 	k GetOeoriQtyDataData
 	q oeoriDispQty_"^"_oeoriRetQty
}

/// description: 判断处方是否可打印-todo
/// 未发,已发部分退,已发全退,未发部分停,未发全停
ClassMethod GetPrescStat(PrescNo)
{
	f  s ordId=$o(^OEORD(0,"PrescNo",PrescNo,ordId))  q:ordId=""  d 
	.s ordItm=0
	.f  s ordItm=$o(^OEORD(0,"PrescNo",PrescNo,ordId,ordItm)) q:ordItm=""  d
	..s oeori=ordId_"||"_ordItm
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"OP")
}

}
