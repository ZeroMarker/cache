/// Description: 病区批次汇总,病区交接单公共raq
Class web.DHCSTPIVAS.Report.WardBat Extends %RegisteredObject
{

/// Description: 病区交接单,传单号时grpIndex为单号,且报表按单号分组
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.WardBat","WardBat","89^25/10/2020^30/11/2020^^^^SHTG^^^^^^^^^25/10/2020^30/11/2020^^^^S10P20201124001^^^^^^^")
Query WardBat(inputStr As %Text = "") As websys.Query(ROWSPEC = "grpIndex,wardDesc,ordCntStr,sumOrdCnt,pogsNo") [ SqlProc ]
{
}

ClassMethod WardBatExecute(ByRef qHandle As %Binary, inputStr As %Text = "") As %Status
{
	//tro
	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Report.WardBat","WardBat")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s collRet=..CollWardBat(inputStr,"WardBat")
	s pid=$p(collRet,"^",1)
	s POGSNoStr=$p(inputStr,"^",21)
	// 按排序好的输出
	q:pid="" $$$OK
	s grpIndex=""
	f  s grpIndex=$o(^||TMP("DHCST",$ClassName(),"WardBat",pid,grpIndex)) q:grpIndex=""  d
	.s wardId=""
	.f  s wardId=$o(^||TMP("DHCST",$ClassName(),"WardBat",pid,grpIndex,wardId)) q:wardId=""  d
	..q:+wardId=0
	..q:'$d(^PAWARD(wardId))
	..s wardDesc=$p(^PAWARD(wardId),"^",2)
	..s ordCntStr="",sumOrdCnt=0
	..s batNo=""
	..f  s batNo=$o(^||TMP("DHCST",$ClassName(),"WardBat",pid,grpIndex,wardId,batNo)) q:batNo=""  d
	...s data=^||TMP("DHCST",$ClassName(),"WardBat",pid,grpIndex,wardId,batNo)
	...s batNoCnt=$p(data,"^",1)
	...s ordCnt=batNo_" 批: "_$p(data,"^",1)
	...s ordCntStr=$s(ordCntStr="":ordCnt,1:ordCntStr_"     "_ordCnt)
	...s sumOrdCnt=sumOrdCnt+batNoCnt
	..s pogsNo=""
	..i POGSNoStr'="" s pogsNo=grpIndex
	..d outputRow
	k ^||TMP("DHCST",$ClassName(),"WardBat",pid)
	Quit $$$OK
outputRow  
	s Data=$lb(grpIndex,wardDesc,ordCntStr,sumOrdCnt,pogsNo)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// Description: 病区批次汇总,不涉及单号,wardIndex就是病区的排序
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.WardBat","WardBatStat","101^24/09/2018^26/09/2018^^^^^")
Query WardBatStat(inputStr As %Text = "") As websys.Query(ROWSPEC = "wardIndex,wardDesc,batNo,batNoCnt:%Integer,POGSNo") [ SqlProc ]
{
}

ClassMethod WardBatStatExecute(ByRef qHandle As %Binary, inputStr As %Text = "") As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Report.WardBat","WardBatStat")=inputStr
	k WardBatStatDATA
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:inputStr="" $$$OK
	s collRet=..CollWardBat(inputStr,"WardBatStat")
	s pid=$p(collRet,"^",1)
	s PivaLocId=$p(inputStr,"^",1)
	s POGSNo=$p(inputStr,"^",21)
	s batNo=""
	f  s batNo=$o(^PIVABT(0,"BatNo",PivaLocId,batNo)) q:batNo=""  d
	.s WardBatStatDATA(batNo)="" // 批,输出所有
	s wardIndex=""
	f  s wardIndex=$o(^||TMP("DHCST",$ClassName(),"WardBatStat",pid,wardIndex)) q:wardIndex=""  d
	.s wardId=""
	.f  s wardId=$o(^||TMP("DHCST",$ClassName(),"WardBatStat",pid,wardIndex,wardId)) q:wardId=""  d
	..q:+wardId=0
	..q:'$d(^PAWARD(wardId))
	..s wardDesc=$p(^PAWARD(wardId),"^",2)
	..s batNo=""
	..f  s batNo=$o(WardBatStatDATA(batNo)) q:batNo=""  d
	...s data=$g(^||TMP("DHCST",$ClassName(),"WardBatStat",pid,wardIndex,wardId,batNo))
	...s batNoCnt=+$p(data,"^",1)
	...s Data=$lb(wardId,wardDesc,batNo,batNoCnt,POGSNo)
	...s ^CacheTemp(repid,ind)=Data    
	...s ind=ind+1
	k ^||TMP("DHCST",$ClassName(),"WardBatStat",pid)
	Quit $$$OK
}

/// description: 病区批次药品汇总,主要用于打包,也会涉及扫描,因此传入单号时,grpIndex为单号
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.WardBat","WardBatDetail","101^2018-05-29^2018-05-31^^^^^^^^^^^^^2018-05-29^2018-05-30^^^^^^^^^^^")
Query WardBatDetail(inputStr As %Text = "") As websys.Query(ROWSPEC = "grpIndex,wardDesc,incIndex,incDesc,qty:%Double,uomDesc,incSpec,phManfDesc,stkBinStr,pogsNo") [ SqlProc ]
{
}

ClassMethod WardBatDetailExecute(ByRef qHandle As %Binary, inputStr As %Text = "") As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCSTPIVAS.Report.WardBat","WardBatDetail")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:inputStr="" $$$OK

	s collRet=..CollWardBat(inputStr,"WardBatDetail")
	s POGSNoStr=$p(inputStr,"^",21)
	s pid=$p(collRet,"^",1)
	s PivaLocId=$p(inputStr,"^",1)
	s grpIndex=""
	f  s grpIndex=$o(^||TMP("DHCST",$ClassName(),"WardBatDetail",pid,grpIndex)) q:grpIndex=""  d
	.s wardId=""
	.f  s wardId=$o(^||TMP("DHCST",$ClassName(),"WardBatDetail",pid,grpIndex,wardId)) q:wardId=""  d
	..q:+wardId=0
	..q:'$d(^PAWARD(wardId))
	..s wardDesc=$p(^PAWARD(wardId),"^",2)
	..s incIndex=""
	..f  s incIndex=$o(^||TMP("DHCST",$ClassName(),"WardBatDetail",pid,grpIndex,wardId,incIndex)) q:incIndex=""  d
	...s qty=^||TMP("DHCST",$ClassName(),"WardBatDetail",pid,grpIndex,wardId,incIndex)
	...s incId=$p(incIndex,"^",2)
	...s incDesc=$p(^INCI(incId,1),"^",2)
	...s bUomId=$p(^INCI(incId,1),"^",10)
	...s bUomDesc=$p($g(^CT("UOM",+bUomId)),"^",2)
	...s incSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
	...s incil=incId_"||"_+$o(^INCI("IL_LOC",PivaLocId,incId,""))
	...s phManfStr=##class(web.DHCST.Common.DrugInfoCommon).GetManf(incId)
	...s phManfDesc=$p(phManfStr,"^",3)
	...s stkBinStr=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
    ...s stkBinStr=$p(stkBinStr,":",2)
    ...s pogsNo=""
    ...i POGSNoStr'="" s pogsNo=grpIndex
	...s Data=$lb(grpIndex,wardDesc,incIndex,incDesc,qty,bUomDesc,incSpec,phManfDesc,stkBinStr,pogsNo)
	...s ^CacheTemp(repid,ind)=Data    
	...s ind=ind+1
	k ^||TMP("DHCST",$ClassName(),"WardBatDetail",pid)
	Quit $$$OK
}

/// description: 病区医嘱明细汇总,需按顺序输出
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Report.WardBat","WardBatOrdDetail","101^2018-05-29^2018-05-31^^^^^^^^^^^^^2018-05-29^2018-05-30^^^^^^^^^^^")
Query WardBatOrdDetail(inputStr As %Text = "") As websys.Query(ROWSPEC = "patNo,bedNo,patName,incDesc,dosage,qty,uomDesc,batNo,doseDTHtml,mDsp,wardDesc,wardId,bedNoIndex,grpIndex,pogsNo,sortIndex") [ SqlProc ]
{
}

ClassMethod WardBatOrdDetailExecute(ByRef qHandle As %Binary, inputStr As %Text = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:inputStr="" $$$OK
	//s $p(inputStr,"^",21)="S10P058!!S10P20191106007!!S10P20190221001!!S80P20191106053"
	s collRet=..CollWardBat(inputStr,"WardBatOrdDetail")
	s pid=$p(collRet,"^",1)
	s sortIndex=""
	f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),"WardBatOrdDetail",pid,sortIndex)) q:sortIndex=""  d
	.s pogId=""
	.f  s pogId=$o(^||TMP("DHCST",$ClassName(),"WardBatOrdDetail",pid,sortIndex,pogId)) q:pogId=""  d
	..s pogItm=""
	..f  s pogItm=$o(^||TMP("DHCST",$ClassName(),"WardBatOrdDetail",pid,sortIndex,pogId,pogItm)) q:pogItm=""  d
	...q:+pogItm=0
	...s data=^||TMP("DHCST",$ClassName(),"WardBatOrdDetail",pid,sortIndex,pogId,pogItm)
	...s Data=$lfs(data,"^")
	...s ^CacheTemp(repid,ind)=Data    
	...s ind=ind+1
	k ^||TMP("DHCST",$ClassName(),"WardBatOrdDetail",pid)
	Quit $$$OK
}

/// description: 根据条件统计病区交接单详细信息
/// w ##class(web.DHCSTPIVAS.Report.WardBat).CollWardBat("","")
ClassMethod CollWardBat(inputStr As %Text = "", queryType = "")
{
	s PivaLocId=$p(inputStr,"^",1), 	OrdStartDate=$p(inputStr,"^",2),	OrdEndDate=$p(inputStr,"^",3)
	s WardIdStr=$p(inputStr,"^",4),    	LocGrpId=$p(inputStr,"^",5),    	PriorityId=$p(inputStr,"^",6)
	s PassResult=$p(inputStr,"^",7),	PivaStat=$p(inputStr,"^",8),    	OeoreStat=$p(inputStr,"^",9)
	s BatNoStr=$p(inputStr,"^",10),		PrintStop=$p(inputStr,"^",11),  	BarCode=$p(inputStr,"^",12)
	s InstructId=$p(inputStr,"^",13),	FreqId=$p(inputStr,"^",14),    		IncId=$p(inputStr,"^",15)
	s PrtStartDate=$p(inputStr,"^",16), PrtEndDate=$p(inputStr,"^",17),		PivaCatId=$p(inputStr,"^",18)
	s PrtStartTime=$p(inputStr,"^",19),	PrtEndTime=$p(inputStr,"^",20),		POGSNoStr=$p(inputStr,"^",21)
	s PivaRefuse=$p(inputStr,"^",22),	PatNo=$p(inputStr,"^",23),			PrtPNo=$p(inputStr,"^",24)
	s OrdStartTime=$p(inputStr,"^",25), OrdEndTime=$p(inputStr,"^",26),		WorkTypeId=$p(inputStr,"^",27)
	s PackFlag=$p(inputStr,"^",28),     Floor = $p(inputStr,"^",29)
	s OrdStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(OrdStartDate)
	s OrdEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(OrdEndDate)
	s PrtStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PrtStartDate)
	s PrtEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PrtEndDate)
	s PrtStartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(PrtStartTime)
	s PrtEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(PrtEndTime)
	s OrdStartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(OrdStartTime)
	s OrdEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(OrdEndTime)
	q:(OrdStartTime'="")&&(OrdEndTime'="")&&(OrdStartDate=OrdEndDate)&&(OrdStartTime>OrdEndTime) ""
    q:(PrtStartTime'="")&&(PrtEndTime'="")&&(PrtStartDate=PrtEndDate)&&(PrtStartTime>PrtEndTime) ""
	q:PivaLocId="" ""
	q:((POGSNoStr=""))&&((OrdStartDate="")||(OrdStartDate="")||(PrtStartDate="")||(PrtEndDate="")) ""
	s WardIdList=$lfs(WardIdStr,",")
	s pid=..NewPid()
	s psId10=##class(web.DHCSTPIVAS.Common).LocPsIdByPsNumber(PivaLocId,10)
	s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",PivaLocId,"OeAudit","AuditTimes")
	k CollWardBatData,CollWardBatArr
	i POGSNoStr'="" d
	.s pogsNoLen=$l(POGSNoStr,"!!")
	.f i=1:1:pogsNoLen d
	..s pogsNo=$p(POGSNoStr,"!!",i)
	..q:pogsNo=""
 	..s pogId=""
 	..f  s pogId=$o(^PIVA(0,"PogsNo",pogsNo,pogId)) q:pogId=""  d
 	...q:+pogId=0 
 	...s calcuDate = $p(^PIVA(pogId), "^", 4)
 	...d CollBatData
	e  d
	.s calcuDate=""
	.f calcuDate=OrdStartDate:1:OrdEndDate d
	..s psId=""
	..f  s psId=$o(^PIVA(0,"LOCSTATE",PivaLocId,calcuDate,psId)) q:psId=""  d
	...s psNumber=$p(^PIVAS(psId),"^",1)
	...q:(PivaStat'="")&&(PivaStat'=psNumber)
	...s pogId=""
	...f  s pogId=$o(^PIVA(0,"LOCSTATE",PivaLocId,calcuDate,psId,pogId)) q:pogId=""  d
	....q:+pogId=0
	....d CollBatData
	q pid
CollBatData	
	s quitFlag=""
	s mDsp=$p(^PIVA(pogId),"^",1)
	s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
	q:wardId=""
	s mOeori=$P(^DHCOEDISQTY(mDsp),"^",1)
	s mOeore=$P(^DHCOEDISQTY(mDsp),"^",3)
	// 过滤条件-配液拒绝
	s pogOper=$p(^PIVA(pogId),"^",8)
 	q:(PivaRefuse="Y")&&(pogOper'="R")
 	q:(PivaRefuse="N")&&(pogOper="R")
	// 过滤条件-配伍审核
	i PassResult'="" d
	.s passResult=$p(##class(web.DHCSTPIVAS.Common).GetOrdPassState(mOeori,calcuDate,auditTimes),"^",1)
	.i passResult'=PassResult s quitFlag=1
	q:quitFlag'=""
	// 过滤条件-停止签
	s cPrintId=$P(^PIVA(+pogId),"^",15)
	q:cPrintId'=""
	// 过滤条件-病区
	q:(WardIdStr'="")&($lf(WardIdList,wardId)=0)
	// 过滤条件-科室组
	i LocGrpId'="" d
	.i $d(CollWardBatData("LocGrp",LocGrpId,wardId)) s chkLocGrp=$g(CollWardBatData("LocGrp",LocGrpId,wardId))
	.e  d
	..s chkLocGrp=##class(web.DHCSTPIVAS.Common).CheckLocGrp(LocGrpId,wardId)
	..s CollWardBatData("LocGrp",LocGrpId,wardId)=chkLocGrp
	q:(LocGrpId'="")&&(CollWardBatData("LocGrp",LocGrpId,wardId)'=1)
	// 过滤条件-批次
	s batNo=$P(^PIVA(+pogId),"^",3)
	q:(BatNoStr'="")&&(##class(web.DHCSTPIVAS.Common).CheckBatNoList(BatNoStr, batNo, ",")'=1) 
	// 过滤条件-用药时间
	i POGSNoStr="" d
	.i (OrdStartTime'="")||(OrdEndTime'="") d
	..s doseTime=$p(^DHCOEDISQTY(mDsp),"^",20)
	..i (calcuDate=OrdStartDate)&&(doseTime<OrdStartTime) s quitFlag=1 q
	..i (calcuDate=OrdEndDate)&&(doseTime>OrdEndTime) s quitFlag=1 q
	e  s calcuDate=$p(^DHCOEDISQTY(mDsp),"^",21)
	q:quitFlag'="" 
    s mOrd=+mOeori
    s mOrdItm=$p(mOeori,"||",2)
	s admId=$P(^OEORD(mOrd),"^",1)
	s patId=$p(^PAADM(admId),"^",1)
	s patNo=$P(^PAPER(patId,"PAT",1),"^",1)
	// 过滤条件-打签日期\打签时间
 	s pogsId10=$o(^PIVA(0,"PS",psId10,pogId,""))
 	q:pogsId10=""
 	s printDate=$P(^PIVA(pogId,"S",pogsId10),"^",4)
 	s printTime=$P(^PIVA(pogId,"S",pogsId10),"^",5)
 	i POGSNoStr'="" d
 	.i (PrtStartDate'="")&&(printDate'="")&(printDate<PrtStartDate) s quitFlag=1 q
 	.i (PrtEndDate'="")&&(printDate'="")&(printDate>PrtEndDate) s quitFlag=1 q
 	.i (PrtStartTime'="")&&(PrtStartDate=printDate)&&(printTime<PrtStartTime) s quitFlag=1 q
 	.i (PrtEndTime'="")&&(PrtEndDate=printDate)&&(printTime>PrtEndTime) s quitFlag=1 q
 	q:quitFlag'=""
	// 过滤条件-登记号
	q:(PatNo'="")&&(PatNo'=patNo)
	// 过滤条件-工作组
	i WorkTypeId'="" d
	.s workTypeId=$P(^PIVA(+pogId),"^",24) 
	.i WorkTypeId'=workTypeId s quitFlag=1 q
	q:quitFlag'=""
	// 过滤条件-医嘱优先级
	i (PriorityId'="") d
	.s priorityId=$p(##class(web.DHCSTPIVAS.Common).OrdPriority(mOeori),"^",1)
	.i PriorityId'=priorityId s quitFlag=1
	q:quitFlag'=""
	// 过滤条件-药品
    i IncId'="" d		
    .i $d(CollWardBatData("mOeoriIncExist",mOeori)) s incExist=$g(CollWardBatData("mOeoriIncExist",mOeori))
    .e  d
    ..s incExist=##class(web.DHCSTPIVAS.Common).CheckOeoriIncExist(mOeori,IncId)
    .i incExist'=1 s quitFlag=1
    q:quitFlag'=""
	// 过滤条件-用法
    i (InstructId'="") d	
    .s instructId=$p(##class(web.DHCSTPIVAS.Common).OeoriInstruc(mOeori),"^",1)
    .i InstructId'=instructId s quitFlag=1
    q:quitFlag'=""
	// 过滤条件-打包
	q:(PackFlag'="")&&(##class(web.DHCSTPIVAS.Common).CheckDspPack(mDsp,PackFlag)'="Y")
	// 过滤条件-执行记录状态
	i OeoreStat'="" d
 	.s chkOeoreStat=##class(web.DHCSTPIVAS.Common).CheckOeoreStat(mOeore)
 	.i (OeoreStat=1)&&(chkOeoreStat'=1) s quitFlag=1 q
 	.i (OeoreStat=2)&&(chkOeoreStat=1) s quitFlag=1 q
 	q:quitFlag'=""
 	// 过滤条件-楼层
 	i Floor'="" d
 	.s bed=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admId, wardLocId),"^",1)
 	.s floorStr = ##class(web.DHCSTPIVAS.Common).GetBedFloor(bed)
 	.i Floor'=$lg(floorStr,1) s quitFlag=1
 	q:quitFlag'=""
	/* 排序-条件 */
	s wardDesc=$p(^PAWARD(wardId),"^",2)
	s sortIndex=wardId
	i queryType="WardBat" d
	.i POGSNoStr'="" s sortIndex=pogsNo
	.d ..MakeWardBatTmpData(queryType,pid,sortIndex,wardId,batNo,1)
	e  i queryType="WardBatStat" d ..MakeWardBatTmpData(queryType,pid,sortIndex,wardId,batNo,1)
	e  i queryType="WardBatDetail" d
	.i POGSNoStr'="" s sortIndex=pogsNo
	.s pogItm=""
	.f  s pogItm=$o(^PIVA(pogId,"I",pogItm)) q:pogItm=""  d
	..q:+pogItm=0
	..s dspId=$p(^PIVA(pogId,"I",pogItm),"^",1)
	..s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
	..s incStr=##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori)
	..s incId=$p(incStr,"^",1),incDesc=$p(incStr,"^",3)
	..s incIndex=incDesc_"^"_incId
	..s qty=$p(^DHCOEDISQTY(dspId),"^",5)
	..i '$d(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,wardId,incIndex)) d
	...s ^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,wardId,incIndex)=qty
	..e  d
	...s $p(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,wardId,incIndex),"^",1)=qty+$p(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,wardId,incIndex),"^",1)
	e  i queryType="WardBatOrdDetail" d	
	.// 按执行记录的明细
	.// 登记号^床号^姓名^药品^剂量^数量^单位^批次^用药时间^mDsp
	.s bedNo=""
	.s bedId=$p(^PAADM(admId),"^",73)
	.s bedNo="*"
 	.i bedId'="" s bedNo=$P($g(^PAWARD(+bedId,"BED",+$p(bedId,"||",2))),"^",1)
 	.s curWardId=+bedId
 	.i curWardId'=wardId s bedNo="*"
	.s patName=$p(^PAPER(patId,"ALL"),"^",1)
    .s doseDate=$p(^DHCOEDISQTY(mDsp),"^",21)
    .s doseTime=$p(^DHCOEDISQTY(mDsp),"^",20)
    .s doseDTHtml=##class(web.DHCSTPIVAS.Common).DateShortFormat(doseDate)_" "_##class(web.DHCSTPIVAS.Common).TimeShortFormat(doseTime)
	.s pogItm=""
	.f  s pogItm=$o(^PIVA(pogId,"I",pogItm)) q:pogItm=""  d
	..q:+pogItm=0
	..s dspId=$p(^PIVA(pogId,"I",pogItm),"^",1)
	..s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
	..s incStr=##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori)
	..s incId=$p(incStr,"^",1),incDesc=$p(incStr,"^",3)
	..s qty=$p(^DHCOEDISQTY(dspId),"^",5)
	..s qty=$fn(qty,"N")
	..s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
	..s bUomId=$p(^INCI(incId,1),"^",10)
	..s uomDesc=$p($g(^CT("UOM",+bUomId)),"^",2)
	..s bedNoIndex=bedNo_"||"_patNo
	..s grpIndex=pogId_"||"_pogItm
	..s sortIndex=wardId
	..s tmpPOGSNo=""
	..i POGSNoStr'="" s sortIndex=pogsNo,tmpPOGSNo=pogsNo
	..s data1=patNo_"^"_bedNo_"^"_patName_"^"_incDesc_"^"_dosage
	..s data2=qty_"^"_uomDesc_"^"_batNo_"^"_doseDTHtml_"^"_+grpIndex
	..s data3=wardDesc_"^"_wardId_"^"_bedNoIndex_"^"_grpIndex_"^"_tmpPOGSNo
	..s data4=sortIndex
	..s data=data1_"^"_data2_"^"_data3_"^"_data4

	..s ^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,pogId,pogItm)=data
	q
}

/// description: 汇总病区批次数据,配液状态执行也会调用
/// input:		 pid(进程),sortIndex(排序),wardId(病区Id),batNo(批次),ordCnt(数量)
ClassMethod MakeWardBatTmpData(queryType, pid, sortIndex, wardId, batNo, ordCnt)
{
	i '$d(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,wardId,batNo)) d
	.s ^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,wardId,batNo)=ordCnt
	e  d
	.s ^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,wardId,batNo)=ordCnt+$g(^||TMP("DHCST",$ClassName(),queryType,pid,sortIndex,wardId,batNo))
	q ""
}

/// description: 因调用来源不同,本类的Pid添加R,避免重复
/// w ##class(web.DHCSTPIVAS.Report.WardBat).NewPid()
ClassMethod NewPid()
{
	q "R"_##class(web.DHCSTKUTIL).NewPid($this,"PIVA")
}

}
