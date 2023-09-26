Import sqluser

/// creator:	yunhaibao
/// createdate: 2018-10-24
/// description:已发药查询统计数据
Class web.DHCINPHA.DispQuery.Query Extends %RegisteredObject
{

/// description: 查询病区方法
/// DHC_PHAOperator:	配药人\第一发药人
/// DHC_PHACollectUser: 发药人\第二发药人
ClassMethod GetPHACollected(StartRow, EndRow, InputStr)
{
	q:InputStr="" ""
	s CS="|@|"
	s StartDate=$p(InputStr,CS,1)
	s EndDate=$p(InputStr,CS,2)
	s PhaLocId=$p(InputStr,CS,3)
	s WardId=$p(InputStr,CS,4)
	s OperUserId=$p(InputStr,CS,5) // 发药人
	s CatCodeStr=$p(InputStr,CS,6) // 传代码
	s StartTime=$p(InputStr,CS,7)
	s EndTime=$p(InputStr,CS,8)
	s DocLocId=$p(InputStr,CS,9)
	s PhacNo=$p(InputStr,CS,10)
	s PatNo=$p(InputStr,CS,11)
	s LongFlag=$p(InputStr,CS,12)
	s ShortFlag=$p(InputStr,CS,13)
	s HospId=$p($g(^CTLOC(PhaLocId)),"^",22)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime) 
	s PhacNo=$zcvt(PhacNo,"U")
	s CatCodeList=$lfs(CatCodeStr,",")
	q:PhaLocId="" ""
	d CollData
	q:'$d(GetPHACollectedData) ""
	s pid=..NewPid()
	k ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollected",pid)
	// 记录输出数据
	s count=0
	s sortIndex=""
	f  s sortIndex=$o(GetPHACollectedData(sortIndex)) q:sortIndex=""  d
	.s phacId=""
	.f  s phacId=$o(GetPHACollectedData(sortIndex,phacId)) q:phacId=""  d
	..s phacData=$g(^DHCPHAC(phacId))
	..q:phacData=""
	..s count=count+1
	..q:count<StartRow
	..q:count>EndRow
	..s wardId=$p(phacData,"^",4)
	..// 病区为空显示为医生科室
	..i wardId'="" s wardDesc=$p($g(^PAWARD(+wardId)),"^",2)
	..e  d
	...s phacDocLoc=$p($g(^DHCPHAC(phacId,1)),"^",10)
	...i phacDocLoc'="" d
	....s wardDesc=$p($g(^CTLOC(+phacDocLoc)),"^",2)
	...e  d
	....s tmpPhacItm=$o(^DHCPHAC(phacId,"I",0))
	....s tmpDspId=+$p(^DHCPHAC(phacId,"I",tmpPhacItm),"^",13)
	....s tmpOeori=$p($g(^DHCOEDISQTY(tmpDspId)),"^",1)
	....s wardDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriDocLoc(tmpOeori),"^",2)
	..s catCode=$p(phacData,"^",12)
	..s catDesc=##class(web.DHCINPHA.Disp.Print).GetTypeDescByCode(catCode,HospId)
	..s dataRange=""
	..s startDate=$p(phacData,"^",10)
	..s endDate=$p(phacData,"^",11)
	..s startDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(startDate)
	..s endDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(endDate)
	..s dataRange=startDateHtml_"至"_endDateHtml
	..s status=$p(phacData,"^",6)
	..s statusDesc=$s(status="Collect":"已发药",status="Print":"已打印",1:"")
	..s printDate=$p(phacData,"^",7)
	..s printTime=$p(phacData,"^",8)
	..s collDate=$p(phacData,"^",2)
	..s collTime=$p(phacData,"^",3)
	..s printDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(printDate)
	..s printTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(printTime)
	..s collDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(collDate)
	..s collTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(collTime)
	..s operUserId=$p(phacData,"^",5)
	..s collUserId=$p(phacData,"^",13)
	..s operUserName=$s(operUserId'="":$p($g(^SSU("SSUSR",operUserId)),"^",2),1:"")
	..s collUserName=$s(collUserId'="":$p($g(^SSU("SSUSR",collUserId)),"^",2),1:"")
	..s phacNo=$p(phacData,"^",14)
	..s sendAuto=$p(phacData,"^",15)
	..s printFlag=$p(phacData,"^",16)
	..s data1=phacId_"^"_wardDesc_"^"_catDesc_"^"_dataRange_"^"_statusDesc
	..s data2=printDateHtml_"^"_printTimeHtml_"^"_collDateHtml_"^"_collTimeHtml_"^"_operUserName
	..s data3=collUserName_"^"_phacNo_"^"_sendAuto_"^"_pid
	..s data=data1_"^"_data2_"^"_data3
	..s ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollected",pid,count)=data
	k GetPHACollectedData
	q pid_"^"_count
CollData
	s calcuDate=""
	f calcuDate=StartDate:1:EndDate d
	.s phacId=0
	.f  s phacId=$o(^DHCPHAC(0,"PHP",PhaLocId,"DATE",calcuDate,phacId)) q:phacId=""  d            ;
	..s phacData=$g(^DHCPHAC(phacId))
	..q:phacData=""
	..s printTime=$p(phacData,"^",8)
	..// 过滤条件-单号(模糊检索)
	..q:(PhacNo'="")&&(PhacNo'[$zcvt($p(phacData,"^",14),"U"))
	..// 过滤条件-时间
	..q:(calcuDate=StartDate)&&(StartTime'="")&&(printTime<StartTime)
	..q:(calcuDate=EndDate)&&(EndTime'="")&&(printTime>EndTime)
	..// 过滤条件-病区
	..q:(WardId'="")&&(WardId'=$p(phacData,"^",4))
	..// 过滤条件-发药类别
	..q:(CatCodeStr'="")&&($lf(CatCodeList,$p(phacData,"^",12))=0)
	..// 过滤条件-发药人
	..q:(OperUserId'="")&&(OperUserId'=$p(phacData,"^",5))
	..// 过滤条件-明细
	..q:..CheckPhacItm(phacId,PatNo,LongFlag,ShortFlag,DocLocId)'="Y"
	..s sortIndex="1"
	..s GetPHACollectedData(sortIndex,phacId)=""
	q
}

/// description: 根据入参,判断是否在对应发药单中存在
/// input:		 LongFlag(Y/N/"")
/// return:		 Y(存在)
ClassMethod CheckPhacItm(PhacId, PatNo = "", LongFlag = "", ShortFlag = "", DocLocId = "")
{
	q:PhacId="" ""
	q:(PatNo="")&&(LongFlag="")&&(ShortFlag="")&&(DocLocId="") "Y"
	s catCode=$p(^DHCPHAC(PhacId),"^",12)
	s chkRet=""
	s phacItm=""
	f  s phacItm=$o(^DHCPHAC(PhacId,"I",phacItm)) q:(phacItm="")||(chkRet="Y")  d
	.s phaItmData=$g(^DHCPHAC(PhacId,"I",phacItm))
	.q:phaItmData=""
	.s quitFlag=""
	.s dspId=+$p(phaItmData,"^",13)
	.s oeori=$p($g(^DHCOEDISQTY(dspId)),"^",1)
	.q:+oeori=0
	.i PatNo'="" d
	..s admId=$p($g(^OEORD(+oeori)),"^",1)
	..s patId=$p($g(^PAADM(+admId)),"^",1)
	..s patNo=$p($g(^PAPER(+patId,"PAT",1)),"^",1)
	..i PatNo'=patNo s quitFlag=1
	.q:quitFlag'=""
	.s priCode=$p(##class(web.DHCSTCOMMONORDER).OeoriPriority(oeori),"^",2)
	.q:(LongFlag="Y")&&(priCode'="S")
	.q:(ShortFlag="Y")&(priCode="S")
	.q:(ShortFlag="Y")&(priCode="OUT")
	.i DocLocId'="" d // 开单科室
	..s docLocId=$p(##class(web.DHCSTCOMMONORDER).OeoriDocLoc(oeori),"^",1)
	..i DocLocId'=docLocId s quitFlag=1
	.q:quitFlag'=""
	.s chkRet="Y"
	q chkRet
}

/// description: 查询发药单药品汇总
/// input:		 PhacIdStr(","分隔的主表Id),InputStr(其他条件)
/// w ##class(web.DHCINPHA.DispQuery.Query).GetPHACollTotal(1,1000,"300,301,302,303,304","")
ClassMethod GetPHACollTotal(StartRow, EndRow, PhacIdStr, InputStr)
{
	q:PhacIdStr="" ""
	s retData=..GetPHACollData(PhacIdStr,InputStr,"GetPHACollTotal")
	s pid=$p(retData,"^",1)
	q:pid="" ""
	s spTotalAmt=0
	s count=0
	s sortIndex=""
	f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollTotal",pid,sortIndex)) q:sortIndex=""  d
	.s incId=""
	.f  s incId=$o(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollTotal",pid,sortIndex,incId)) q:incId=""  d
	..s totalData=^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollTotal",pid,sortIndex,incId)
	..s spAmt=$p(totalData,"^",2)
	..s spTotalAmt=spTotalAmt+spAmt	
	..s count=count+1
	..q:count<StartRow
	..q:count>EndRow
	..s resData=""
	..s patId=""
	..f  s patId=$o(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollTotal",pid,sortIndex,incId,patId)) q:patId=""  d
	...s patResData=^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollTotal",pid,sortIndex,incId,patId)
	...s iResData=$p(patResData,"^",2)_"("_$p(patResData,"^",1)_")"
	...s resData=$s(resData="":iResData,1:resData_","_iResData)
    ..s incCode=$p(^INCI(incId,1),"^",1)
    ..s incDesc=$p(^INCI(incId,1),"^",2)
	..s qty=$fn($p(totalData,"^",1),"N")
	..s geneDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetGene(incId),"^",2)
	..s formDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetForm(incId),"^",2)
	..s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
	..s manfDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(incId),"^",3)
	..s bUomId=$p(^INCI(incId,1),"^",10)
	..s bUomDesc=$p($g(^CT("UOM",+bUomId)),"^",2)
	..s sp=$p(totalData,"^",3)
	..s spAmt=$fn(spAmt,"",2)
	..s resQty=$fn($p(totalData,"^",4),"N")
	..s sp=$fn(sp,"N")
	..s data1=incCode_"^"_incDesc_"^"_qty_"^"_spAmt_"^"_geneDesc
	..s data2=formDesc_"^"_spec_"^"_manfDesc_"^"_bUomDesc_"^"_sp
	..s data3=resQty_"^"_resData
	..s data=data1_"^"_data2_"^"_data3
	..s ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollTotal",pid,count)=data
	// 总计
	i $d(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollTotal",pid)) d
	.s data=""
	.s $p(data,"^",12)=""
	.s $p(data,"^",1)="总计"
	.s $p(data,"^",4)=spTotalAmt
	.s count=count+1
	.s ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollTotal",pid,count)=data
	k ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollData","GetPHACollTotal",pid)
	q pid_"^"_count
}

/// description: 查询发药单用药明细(按天)
/// w ##class(web.DHCINPHA.DispQuery.Query).GetPHACollDetail(1,100,"301,302,303","")
ClassMethod GetPHACollDetail(StartRow, EndRow, PhacIdStr, InputStr)
{
	q:PhacIdStr="" ""
	s PhaLocId=$p($g(^DHCPHAC(+PhacIdStr)),"^",1)
	s HospId=$p($g(^CTLOC(+PhaLocId)),"^",22)
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospId)
	s retData=..GetPHACollData(PhacIdStr,InputStr,"GetPHACollDetail")
	s pid=$p(retData,"^",1)
	q:pid="" ""
	s count=0
	s patIndex=""
	f  s patIndex=$o(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollData","GetPHACollDetail",pid,patIndex)) q:patIndex=""  d
	.s oeoriIndex=""
	.f  s oeoriIndex=$o(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex)) q:oeoriIndex=""  d
	..s incId=""
	..f  s incId=$o(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId)) q:incId=""  d
	...s count=count+1
	...q:count<StartRow
	...q:count>EndRow
	...s detailData=^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId)
	...s admId=$p(detailData,"^",1)
	...s oeori=$p(detailData,"^",2)
	...s qty=$p(detailData,"^",3)
	...s spAmt=$p(detailData,"^",4)
	...s sp=$p(detailData,"^",5)
	...s batNoStr=$p(detailData,"^",6)
	...s admLocDesc=$p(detailData,"^",7)
	...s bedNo=$p(detailData,"^",8)
	...s doseDate=$p(detailData,"^",9)
	...s doseDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(doseDate)
	...s doseTimes=$p(detailData,"^",10)
	...s doseTimesHtml=""
	...s doseTimeLen=$l(doseTimes,",")
	...s doseI=0
	...f doseI=1:1:doseTimeLen d
	....s doseTime=$p(doseTimes,",",doseI)
	....q:doseTime=""
	....s doseTimeHtml=$zt(doseTime,2)
	....i doseTimesHtml="" s doseTimesHtml=doseTimeHtml
	....e  s doseTimesHtml=doseTimesHtml_","_doseTimeHtml
	...s admData=$$GetAdmData(admId)
	...s patNo=$p(admData,"^",3)
	...s patName=$p(admData,"^",2)
	...s patAge=$p(admData,"^",5)
	...s diagDesc=$p(admData,"^",4)
	...s encryptLevel=$p(admData,"^",7)
	...s patLevel=$p(admData,"^",8)
    ...s oeoriData=$$GetOeoriData(oeori)
    ...s dosage=$p(oeoriData,"^",1)
    ...s freqDesc=$p(oeoriData,"^",2)
    ...s instrucDesc=$p(oeoriData,"^",3)
    ...s oeoriStat=$p(oeoriData,"^",4)
    ...s priDesc=$p(oeoriData,"^",5)
    ...s duraDesc=$p(oeoriData,"^",6)
    ...s prescNo=$p(oeoriData,"^",7)
    ...s docName=$p(oeoriData,"^",8)
	...s cookType=$p(oeoriData,"^",9)
	...s oeoriDateTime=$p(oeoriData,"^",10)
	...s oeoriDate=$p(oeoriDateTime," ",1)
	...s incData=$$GetIncData(incId)
	...s manfDesc=$p(incData,"^",1)
	...s incDesc=$p(incData,"^",2)
	...s uomDesc=$p(incData,"^",3)
	...s doseDate=""
	...s sp=$fn(sp,"N")
	...s spAmt=$fn(spAmt,"N")
	...s qtyUom=$fn(qty,"N")_uomDesc
	...s data1=admLocDesc_"^"_bedNo_"^"_patName_"^"_patNo_"^"_patAge
	...s data2=incDesc_"^"_qtyUom_"^"_sp_"^"_spAmt_"^"_priDesc
	...s data3=dosage_"^"_freqDesc_"^"_prescNo_"^"_instrucDesc_"^"_cookType
	...s data4=duraDesc_"^"_oeoriStat_"^"_batNoStr_"^"_diagDesc_"^"_docName
	...s data5=doseDateHtml_"^"_encryptLevel_"^"_patLevel_"^"_manfDesc_"^"_oeoriDate
	...s data6=doseTimesHtml
	...s data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5_"^"_data6
	...s ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollDetail",pid,count)=data
	/*
	// 总计-明细不需要显示
	i $d(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollDetail",pid))
	.s $p(data,"^",10)=""
	.s $p(data,"^",1)="总计"
	.s $p(data,"^",4)=spTotalAmt
	.s count=count+1
	.s ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollDetail",pid,count)=data
	.*/
	k ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","AdmData",pid)
	k ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","IncData",pid)
	k ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","OeoriData",pid)
	k ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","GetPHACollData","GetPHACollDetail",pid)
	q pid_"^"_count
GetAdmData(admId)
	q:$d(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","AdmData",pid,admId)) ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","AdmData",pid,admId)
	s patId=$p(^PAADM(admId),"^",1)
	s patName=$p(^PAPER(patId,"ALL"),"^",1) 
	s patNo=$p(^PAPER(patId,"PAT",1),"^",1) 
	s diagDesc=##class(web.DHCSTCOMMONORDER).MrDiagnose(admId,",")
	s patAge=##class(PHA.FACE.IN.Com).GetAge(patId,admId)
	s patSex=$p($g(^PAPER(patId,"ALL")),"^",7)
 	s patSex=$p($g(^CT("SEX",+patSex)),"^",2)
    i EncryptFlag=1 d
 	.s encryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patId,"")
 	.s encryptLevel=$p(encryptLevelInfo,"^",1)
 	.s patLevel=$p(encryptLevelInfo,"^",2)
 	e  s (encryptLevel,patLevel)=""
	s getAdmData1=patId_"^"_patName_"^"_patNo_"^"_diagDesc_"^"_patAge
	s getAdmData2=patSex_"^"_encryptLevel_"^"_patLevel
	s getAdmData=getAdmData1_"^"_getAdmData2
	s ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","AdmData",pid,admId)=getAdmData
	q getAdmData
GetOeoriData(oeori)
	q:$d(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","OeoriData",pid,oeori)) ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","OeoriData",pid,oeori)
	s ordId=+oeori
	s ordItm=+$p(oeori,"||",2)
	s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
	s freqDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(oeori),"^",3)
	s instrucDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(oeori),"^",2)
	s oeoriStat=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",2)
    s priDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriPriority(oeori),"^",3)
    s duraDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(oeori),"^",2)
    s prescNo=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",14)
    s docName=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(oeori),"^",2)
	s cookType=##class(web.DHCSTCOMMONORDER).PrescCookType(prescNo)
	s oeoriDateTime=##class(web.DHCSTCOMMONORDER).OeoriDateTime(oeori)
	s getOeoriData1=dosage_"^"_freqDesc_"^"_instrucDesc_"^"_oeoriStat_"^"_priDesc
	s getOeoriData2=duraDesc_"^"_prescNo_"^"_docName_"^"_cookType_"^"_oeoriDateTime
	s getOeoriData=getOeoriData1_"^"_getOeoriData2
	s ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","OeoriData",pid,oeori)=getOeoriData
	q getOeoriData
GetIncData(incId)
	q:$d(^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","IncData",pid,incId)) ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","IncData",pid,incId)
	s manfDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(incId),"^",3)
	s bUomId=$p(^INCI(incId,1),"^",10)
	s bUomDesc=$p($g(^CT("UOM",+bUomId)),"^",2)
	s incDesc=$p(^INCI(incId,1),"^",2)
	s getIncData1=manfDesc_"^"_incDesc_"^"_bUomDesc
	s getIncData=getIncData1
	s ^||TMP("DHCST","web.DHCINPHA.DispQuery.Query","IncData",pid,incId)=getIncData
	q getIncData
}

/// description: 查询明细与汇总
/// w ##class(web.DHCINPHA.DispQuery.Query).GetPHACollData("301,302,303","","GetPHACollDetail")
ClassMethod GetPHACollData(PhacIdStr, InputStr, QueryType)
{
	s mN="GetPHACollData"
	k GetPHACollDataDATA
	q:PhacIdStr="" ""
	s pid=..NewPid()
	s CS="|@|"
	s PatNo=$p(InputStr,CS,11)
	s LongFlag=$p(InputStr,CS,12)
	s ShortFlag=$p(InputStr,CS,13)
	s phacLen=$l(PhacIdStr,",")
	s count=0
	s phacI=0
	f phacI=1:1:phacLen d
	.s phacId=$p(PhacIdStr,",",phacI)
	.q:phacId=""
	.s phacItm=0
	.f  s phacItm=$o(^DHCPHAC(phacId,"I",phacItm)) q:phacItm=""  d
	..s phaItmData=$g(^DHCPHAC(phacId,"I",phacItm))
	..q:phaItmData=""
	..s quitFlag=""
	..s dspId=+$p(phaItmData,"^",13)
	..s oeori=$p($g(^DHCOEDISQTY(dspId)),"^",1)
	..s doseDate=$p($g(^DHCOEDISQTY(dspId)),"^",21)
	..s doseTime=$p($g(^DHCOEDISQTY(dspId)),"^",20)
	..q:+oeori=0
	..i (PatNo'="")||(QueryType="GetPHACollDetail") d
	...s admId=$p($g(^OEORD(+oeori)),"^",1)
	...s patId=$p($g(^PAADM(+admId)),"^",1)
	...s patNo=$p($g(^PAPER(+patId,"PAT",1)),"^",1)
	...i (PatNo'="")&&(PatNo'=patNo) s quitFlag=1
	..q:quitFlag'=""
	..s priCode=$p(##class(web.DHCSTCOMMONORDER).OeoriPriority(oeori),"^",2)
	..q:(LongFlag="Y")&&(priCode'="S")
	..q:(ShortFlag="Y")&(priCode="S")
	..q:(ShortFlag="Y")&(priCode="OUT")
	..i QueryType="GetPHACollDetail" d
	...s admLocId=$p(phaItmData,"^",11)
	...s admLocDesc=$p($g(^CTLOC(+admLocId)),"^",2)
	..s phacLb=""
	..f  s phacLb=$o(^DHCPHAC(phacId,"I",phacItm,"B",phacLb)) q:phacLb=""  d
	...s phacLbData=$g(^DHCPHAC(phacId,"I",phacItm,"B",phacLb))
	...q:phacLbData=""
	...s phacLbId=phacId_"||"_phacItm_"||"_phacLb
	...i QueryType="GetPHACollTotal" d CalcuTotal
	...e  i QueryType="GetPHACollDetail" d CalcuDetail
	q pid_"^"_count
CalcuTotal
	// 药品汇总
	s spAmt=$p(phacLbData,"^",6) 
	s sp=$p(phacLbData,"^",5) 
	s inclb=$p(phacLbData,"^",1) 
	s qty=$p(phacLbData,"^",2) 
	s resQty=$p(phacLbData,"^",8)
	s incId=+inclb
	s sortIndex="1"
	i '$d(^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId)) d
	.s ^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId)=qty_"^"_spAmt_"^"_sp_"^"_resQty
	.s count=count+1
	e  d
	.s $p(^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId),"^",1)=qty+$p(^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId),"^",1)
	.s $p(^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId),"^",2)=spAmt+$p(^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId),"^",2)
	.s $p(^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId),"^",4)=resQty+$p(^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId),"^",4)
	// 汇总冲减信息
	s resId=0
	f  s resId=$o(^DHCPRES(0,"TypePointer","P",phacLbId,resId)) q:resId=""  d
	.s resItm=0
	.f  s resItm=$o(^DHCPRES(0,"TypePointer","P",phacLbId,resId,resItm)) q:resItm=""  d
	..s resItmSub=0
	..f  s resItmSub=$o(^DHCPRES(resId,"DET",resItm,"SUB",resItmSub)) q:resItmSub=""  d
	...q:+resItmSub=0
	...s DHCPRESDETSUB=^DHCPRES(resId,"DET",resItm,"SUB",resItmSub)
	...s retItmLbId=$p(DHCPRESDETSUB,"^",1)
	...s resItmLbQty=$p(DHCPRESDETSUB,"^",2)
	...s admId=$p(^PHARET(+retItmLbId,"I",$p(retItmLbId,"||",2)),"^",8)
	...s patId=$p($g(^PAADM(+admId)),"^",1)
	...s bedId=$p(^PHARET(+retItmLbId,"I",$p(retItmLbId,"||",2)),"^",10)
	...s patName=$p(^PAPER(patId,"ALL"),"^",1) 
	...s patInfo=patName
	...i bedId'="" d
	....s bedNo=$p($g(^PAWARD(+$p(bedId,"||",1),"BED",+$p(bedId,"||",2))),"^",1)
	....i bedNo'="" s patInfo=bedNo_" "_patInfo
	...i $d(^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId,patId)) d
	....s $p(^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId,patId),"^",1)=resItmLbQty+$p(^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId,patId),"^",1)
	...e  d
	....s ^||TMP("DHCST",$ClassName(),mN,"GetPHACollTotal",pid,sortIndex,incId,patId)=resItmLbQty_"^"_patInfo
	q
CalcuDetail
	// 明细汇总,按每天用药汇总
	// sortIndex=docLocDesc^bedNo^admId,oeori^doseDate,incId
	// data=admId_"^"_oeori_"^"_qty_"^"_spAmt_"^"_sp_"^"_batNoStr(逗号分隔)
	s spAmt=$p(phacLbData,"^",6) 
	s sp=$p(phacLbData,"^",5) 
	s inclb=$p(phacLbData,"^",1) 
	s qty=$p(phacLbData,"^",2) 
	s incId=+inclb
	s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	s batNo=$p(^INCI(incId,"IB",+$p(incib,"||",2)),"^",1)
	s bedNo=$p(phaItmData,"^",8)	
	s patIndex=admLocDesc_"^"_bedNo_"^"_admId
	s oeoriIndex=oeori_"^"_doseDate
	i '$d(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId)) d
	.s data=admId_"^"_oeori_"^"_qty_"^"_spAmt_"^"_sp_"^"_batNo_"^"_admLocDesc_"^"_bedNo_"^"_doseDate_"^"_doseTime
	.s ^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId)=data
	.s count=count+1
	e  d
	.s $p(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId),"^",3)=qty+$p(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId),"^",3)
	.s $p(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId),"^",4)=spAmt+$p(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId),"^",4)
	.s batNoStr=$p(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId),"^",6)
	.i $lf($lfs(batNoStr,","),batNo)=0 d
	..s batNoStr=batNoStr_","_batNo
	..s $p(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId),"^",6)=batNoStr
	.s doseTimes=$p(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId),"^",10)
	.i $lf($lfs(doseTimes,","),doseTime)=0 d
	..s doseTimes=doseTimes_","_doseTime
	..s $p(^||TMP("DHCST",$ClassName(),"GetPHACollData","GetPHACollDetail",pid,patIndex,oeoriIndex,incId),"^",10)=doseTimes

	q
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

}
