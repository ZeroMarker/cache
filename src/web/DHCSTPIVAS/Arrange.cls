/// Description: 排药统计
Class web.DHCSTPIVAS.Arrange Extends %RegisteredObject
{

/// Description: 排药统计查询\打印
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Arrange","QueryArrange","248^^^^^^^^1^^^^^^^^^^^^S60P20191015030^N^^^^^^^Y","")
Query QueryArrange(inputStr = "", pid = "") As websys.Query(ROWSPEC = "pid,incDesc,incSpec,phManfDesc,qty,bUomDesc,stkBin,batNoQty") [ SqlProc ]
{
}

ClassMethod QueryArrangeExecute(ByRef qHandle As %Binary, inputStr = "", pid = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s pid=""
	q:inputStr="" $$$OK
	s collRet=..CollArrange(inputStr)
	s pid=$p(collRet,"^",1)
	q:pid="" $$$OK
	s sortIndex=""
	f  s sortIndex=$o(^||TMP("DHCST","web.DHCSTPIVAS.Arrange","QueryArrange",pid,sortIndex)) q:sortIndex=""  d
	.s incId=""
	.f  s incId=$o(^||TMP("DHCST","web.DHCSTPIVAS.Arrange","QueryArrange",pid,sortIndex,incId)) q:incId=""  d
	..s outputData=^||TMP("DHCST","web.DHCSTPIVAS.Arrange","QueryArrange",pid,sortIndex,incId)
	..s batNo="",batNoQtyStr=""
	..f  s batNo=$o(^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncBatQty",pid,incId,batNo)) q:batNo=""  d
	...s qty=^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncBatQty",pid,incId,batNo)
	...s batNoQty=batNo_" : "_$fn(qty,"N")
	...s batNoQtyStr=$s(batNoQtyStr="":batNoQty,1:batNoQtyStr_"；"_batNoQty)
	..s $p(outputData, "^", 5) = $fn($p(outputData, "^", 5), "N")
	..s Data=$lfs(outputData_"^"_batNoQtyStr,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	d ..KillQueryArrange(pid)
	Quit $$$OK
}

/// Description: 根据条件统计排药数据
/// others:		 PivaStat(当为单独执行时,此为预执行状态,否则为当前状态)
/// 排药标识:	 30
/// w ##class(web.DHCSTPIVAS.Report.WardBat).CollWardBat("","")
ClassMethod CollArrange(inputStr)
{
	s PivaLocId=$p(inputStr,"^",1), 	OrdStartDate=$p(inputStr,"^",2),	OrdEndDate=$p(inputStr,"^",3)
	s WardIdStr=$p(inputStr,"^",4),    	LocGrpId=$p(inputStr,"^",5),    	PriorityId=$p(inputStr,"^",6)
	s PassResult=$p(inputStr,"^",7),	PsNumber=$p(inputStr,"^",8),    	OeoreStat=$p(inputStr,"^",9)
	s BatNoStr=$p(inputStr,"^",10),		PrintStop=$p(inputStr,"^",11),  	BarCode=$p(inputStr,"^",12)
	s InstructId=$p(inputStr,"^",13),	FreqId=$p(inputStr,"^",14),    		IncId=$p(inputStr,"^",15)
	s PrtStartDate=$p(inputStr,"^",16), PrtEndDate=$p(inputStr,"^",17),		PivaCatId=$p(inputStr,"^",18)
	s PrtStartTime=$p(inputStr,"^",19),	PrtEndTime=$p(inputStr,"^",20),		PrtNo=$p(inputStr,"^",21)
	s PivaRefuse=$p(inputStr,"^",22),	PatNo=$p(inputStr,"^",23),			PrtPNo=$p(inputStr,"^",24)
	s OrdStartTime=$p(inputStr,"^",25), OrdEndTime=$p(inputStr,"^",26),		WorkTypeId=$p(inputStr,"^",27)
	s PackFlag=$p(inputStr,"^",28), 	Arranged=$p(inputStr,"^",29),  		ArrStartTime=$p(inputStr,"^",30)
	s ArrEndTime=$p(inputStr,"^",31)
	s OrdStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(OrdStartDate)
	s OrdEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(OrdEndDate)
	s PrtStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PrtStartDate)
	s PrtEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PrtEndDate)
	s PrtStartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(PrtStartTime)
	s PrtEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(PrtEndTime)
	s OrdStartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(OrdStartTime)
	s OrdEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(OrdEndTime)
	s ArrStartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(ArrStartTime)
	s ArrEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(ArrEndTime)
    q:(OrdStartTime'="")&&(OrdEndTime'="")&&(OrdStartDate=OrdEndDate)&&(OrdStartTime>OrdEndTime) ""
    q:(PrtStartTime'="")&&(PrtEndTime'="")&&(PrtStartDate=PrtEndDate)&&(PrtStartTime>PrtEndTime) ""
	q:PivaLocId="" $$$OK
	q:(PrtNo="")&&((OrdStartDate="")||(OrdStartDate="")||(PrtStartDate="")||(PrtEndDate="")) ""
	s WardIdList=$lfs(WardIdStr,",")
	s ps10StateId=$o(^PIVAS(0,"LOCTYPENUMBER",PivaLocId,"I",10,""))  // 该配液中心打签流程对应Id
	q:ps10StateId="" ""
	s ps30StateId=$o(^PIVAS(0,"LOCTYPENUMBER",PivaLocId,"I",30,""))  // 该配液中心排药流程对应Id
	// 配伍审核需审核天数
	s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",PivaLocId,"OeAudit","AuditTimes")
	// 是否需要护士审核
	s needNurAudit=##class(web.DHCSTPIVAS.Settings).GetNeedNurseAudit(PivaLocId)
	s pid=..NewPid()
	k ^TMP("DHCST","web.DHCSTPIVAS.Arrange","QueryArrange",pid)
	d ..MakePsStateDict(pid,PivaLocId)
	s singleFlag=$p($g(^||TMPPIVAS("Arrange","Dict","State",pid,30)),"^",3) // 单独执行
	k CollArrangeData,CollArrangeArr
	i PrtNo'="" d
 	.// 按打印单号查,每个流程单号规则不一样
 	.s pogId=""
 	.f  s pogId=$o(^PIVA(0,"PogsNo",PrtNo,pogId)) q:pogId=""  d
 	..q:+pogId=0
 	..s calcuDate = $p(^PIVA(pogId), "^", 4)
 	..d CollArrangeData
	e  d
	.s calcuDate=""
	.f calcuDate=OrdStartDate:1:OrdEndDate d
	..s pogId=""
	..f  s pogId=$o(^PIVA(0,"LOCORDDATE",PivaLocId,calcuDate,pogId)) q:pogId=""  d
	...q:+pogId=0
	...d CollArrangeData
	q pid
CollArrangeData
	s quitFlag=""
	s pogOper=$p(^PIVA(pogId),"^",8)
	// 过滤-配液拒绝
	q:(pogOper="R") //||(pogOper="C") // C配也取消,不考虑此状态
	// 过滤-停止签
	s cPrintId=$P(^PIVA(+pogId),"^",15)
	q:cPrintId'=""
	s mDsp=$p(^PIVA(pogId),"^",1)
	s mOeori=$P(^DHCOEDISQTY(mDsp),"^",1)
	s mOeore=$P(^DHCOEDISQTY(mDsp),"^",3)
    // 配置条件-护士审核
	q:(needNurAudit="Y")&&(##class(web.DHCSTPIVAS.Common).NurAuditFlagByMDsp(mDsp)'="Y")
	// 配置条件-护士处理
	s nurSeeTypeStr=##class(web.DHCSTPIVAS.Common).GetNurseSeeType(mOeori,PivaLocId)
	q:$p(nurSeeTypeStr,"^",1)="N" "-1^"_$p(nurSeeTypeStr,"^",3)
	//q:$p($g(^DHCOEDISQTY(mDsp)),"^",7)'="TC"
	s psId=$p(^PIVA(pogId),"^",6)
	q:psId=""
	s psNumber=$p(^PIVAS(psId),"^",1)
	s packFlag=##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
	i packFlag="P" d	// 打包下一流程
	.s nextPsNumber=$o(^||TMPPIVAS("Arrange","Dict","PackState",pid,psNumber))
	e  s nextPsNumber=$o(^||TMPPIVAS("Arrange","Dict","State",pid,psNumber))
	q:(singleFlag="Y")&&(nextPsNumber="")	// 单独执行才考虑下一状态
	// 过滤条件-流程-是否排药(不勾选单独执行,则在配液状态执行执行)
	i singleFlag'="Y" d
	.i Arranged="Y" d
	..i psNumber<30 s quitFlag=1 q
	..i (PsNumber'="")&&(PsNumber'=psNumber) s quitFlag=1
	.e  d
	..i (PsNumber'="")&&(PsNumber'=psNumber) s quitFlag=1
	e  i singleFlag="Y" d
	.i Arranged="Y" d
	..i psNumber<30 s quitFlag=1 q
	..i (PsNumber'="")&&(PsNumber'=psNumber) s quitFlag=1
	.e  d
	..i (PsNumber'="")&&(PsNumber'=nextPsNumber) s quitFlag=1
	q:quitFlag'=""
	// 过滤条件-打包
	q:(PackFlag'="")&&(##class(web.DHCSTPIVAS.Common).CheckDspPack(mDsp,PackFlag)'="Y")
    s mOrd=+mOeori
	s admId=$P(^OEORD(mOrd),"^",1)
	i '$d(CollArrangeData("arcItmCat",mOeori)) d
	.s arcItmCatStr=##class(web.DHCSTPIVAS.Common).GetArcItmCatByOeori(mOeori)
	.s CollArrangeData("arcItmCat",mOeori)=arcItmCatStr
	e  s arcItmCatStr=CollArrangeData("arcItmCat",mOeori)
	s arcItmCatType=$p(arcItmCatStr,"^",4)
	s arcItmCatId=$p(arcItmCatStr,"^",1)
	q:arcItmCatType'="R"
	/// 过滤-出院结算判断计费点
    i '$d(CollArrangeData("adm","collAllow",admId,arcItmCatId)) d
    .s collAllow=##Class(web.DHCSTCOMMONSRV).IfCollectDrugAllowed(admId,arcItmCatId)
    .s CollArrangeData("adm","collAllow",admId,arcItmCatId)=collAllow
    q:$g(CollArrangeData("adm","collAllow",admId,arcItmCatId))'=1
	// 过滤条件-配伍审核
	s passResult=$p(##class(web.DHCSTPIVAS.Common).GetOrdPassState(mOeori,calcuDate,auditTimes,PivaLocId),"^",1)
	i PassResult'="" d
	.i passResult'=PassResult s quitFlag=1
	q:quitFlag'=""
	q:(singleFlag="Y")&&(Arranged'="Y")&&(passResult'="SHTG")
	s wardLocId=$p(^DHCOEDISQTY(mDsp),"^",22)
	s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
	// 过滤条件-科室组
	i LocGrpId'="" d
	.i $d(CollArrangeData("LocGrp",LocGrpId,wardId)) s chkLocGrp=$g(CollArrangeData("LocGrp",LocGrpId,wardId))
	.e  d
	..s chkLocGrp=##class(web.DHCSTPIVAS.Common).CheckLocGrp(LocGrpId,wardId)
	..s CollArrangeData("LocGrp",LocGrpId,wardId)=chkLocGrp
	.i chkLocGrp'=1 s quitFlag=1
	q:quitFlag'=""
	// 过滤条件-病区
	q:(WardIdStr'="")&($lf(WardIdList,wardId)=0)
	// 过滤条件-用药时间
	i (PrtNo'="")&&(OrdStartTime'="")||(OrdEndTime'="") d
	.s doseTime=$p(^DHCOEDISQTY(mDsp),"^",20)
	.i PrtNo'="" s calcuDate=$p(^DHCOEDISQTY(mDsp),"^",21)
	.i (calcuDate=OrdStartDate)&&(doseTime<OrdStartTime) s quitFlag=1 q
	.i (calcuDate=OrdEndDate)&&(doseTime>OrdEndTime) s quitFlag=1 q
	q:quitFlag'="" 
	// 过滤条件-医嘱优先级
	i (PriorityId'="") d
	.s priorityId=$p(##class(web.DHCSTPIVAS.Common).OrdPriority(mOeori),"^",1)
	.i PriorityId'=priorityId s quitFlag=1
	q:quitFlag'=""
	// 过滤条件-用法
    i (InstructId'="") d	
    .s instructId=$p(##class(web.DHCSTPIVAS.Common).OeoriInstruc(mOeori),"^",1)
    .i InstructId'=instructId s quitFlag=1
    q:quitFlag'=""
	// 过滤条件-打签日期\打签时间
 	s pogsId10=$o(^PIVA(0,"PS",ps10StateId,pogId,""))
 	q:pogsId10=""
 	s printDate=$P(^PIVA(pogId,"S",pogsId10),"^",4)
 	s printTime=$P(^PIVA(pogId,"S",pogsId10),"^",5)
 	i (PrtNo'="")&&(PrtStartDate'="")&&(printDate'="")&(printDate<PrtStartDate) q
 	i (PrtNo'="")&&(PrtEndDate'="")&&(printDate'="")&(printDate>PrtEndDate) q
 	i (PrtNo'="")&&(PrtStartTime'="")&&(PrtStartDate=printDate)&&(printTime<PrtStartTime) q
 	i (PrtNo'="")&&(PrtEndTime'="")&&(PrtEndDate=printDate)&&(printTime>PrtEndTime) q
 	// 过滤条件-排药时间
 	i (ArrStartTime'="")||(ArrEndTime'="") d
 	.s pogsId30=$o(^PIVA(0,"PS",ps30StateId,pogId,""))
 	.i pogsId30'="" d
 	..s arrTime=$P(^PIVA(pogId,"S",pogsId30),"^",5)
 	..i arrTime<ArrStartTime s quitFlag=1 q
 	..i arrTime>ArrEndTime s quitFlag=1 q
	// 过滤条件-工作组
	i WorkTypeId'="" d
	.s workTypeId=$P(^PIVA(+pogId),"^",24) 
	.i WorkTypeId'=workTypeId s quitFlag=1 q
	q:quitFlag'=""
	// 过滤条件-批次
	s batNo=$P(^PIVA(+pogId),"^",3)
	q:(BatNoStr'="")&&(##class(web.DHCSTPIVAS.Common).CheckBatNoList(BatNoStr, batNo, ",")'=1) 
	s patId=$p(^PAADM(admId),"^",1)
	s patNo=$P(^PAPER(patId,"PAT",1),"^",1)
	// 过滤条件-登记号
	q:(PatNo'="")&&(PatNo'=patNo)
	// 过滤-执行记录停止
	q:##class(web.DHCSTPIVAS.Common).CheckOeoreStat(mOeore)'=1
	d ..SetPogData(pid,pogId)
	i PsNumber'="" s ^TMPPIVAS("Arrange","SaveData",pid,pogId)=""
	q
}

/// description: 按配液主表Id获取查询\打印数据公用
ClassMethod SetPogData(pid, pogId)
{
	s batNo=$p(^PIVA(pogId),"^",3)
	s pogItm=""
	f  s pogItm=$o(^PIVA(pogId,"I",pogItm)) q:pogItm=""  d
	.q:+pogItm=0
	.s dspId=$p(^PIVA(pogId,"I",pogItm),"^",1)
	.s recLocId=$p(^DHCOEDISQTY(dspId),"^",24) 
	.s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
	.s oeore=$p(^DHCOEDISQTY(dspId),"^",3)
	.s priCode=$p(##class(web.DHCSTPIVAS.Common).OeoriPriority(oeori),"^",2)
	.// 过滤-自备药
	.q:priCode["OM"
	.// 过滤-执行记录停止
	.q:##class(web.DHCSTPIVAS.Common).CheckOeoreStat(oeore)'=1
 	.s incStr=##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori)
 	.s incId=$P(incStr,"^",1)
 	.q:incId=""
	.s qty=$P(^DHCOEDISQTY(dspId),"^",11)
	.s incCh=$o(^INCI("IL_LOC",recLocId,incId,""))
	.q:incCh=""
	.i '$d(^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncId",pid,incId)) d
	..s incil=incId_"||"_incCh
	..s incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
	..s incSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incId)
	..s phManfDesc=$lg(##class(PHA.COM.Drug).GetManf(incId),3)
	..s bUomId=$p(^INCI(incId,1),"^",10)
	..s bUomDesc=##class(PHA.COM.Data.Base).UomDesc(bUomId)
	..s stkBin=$p(##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","",""),":",2)
	..s sortIndex=0_"||"_stkBin
	..i stkBin="" s sortIndex="1||Z"
	..s data=pid_"^"_incDesc_"^"_incSpec_"^"_phManfDesc_"^"_qty_"^"_bUomDesc_"^"_stkBin
	..s ^||TMP("DHCST","web.DHCSTPIVAS.Arrange","QueryArrange",pid,sortIndex,incId)=data
	..s ^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncId",pid,incId)=data
	.e  d
	..s incData=$g(^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncId",pid,incId))
	..s stkBin=$p(incData,"^",7)
	..s sortIndex=0_"||"_stkBin
	..i stkBin="" s sortIndex="1||Z"
	..s $p(^||TMP("DHCST","web.DHCSTPIVAS.Arrange","QueryArrange",pid,sortIndex,incId),"^",5)=qty+$p(^||TMP("DHCST","web.DHCSTPIVAS.Arrange","QueryArrange",pid,sortIndex,incId),"^",5)
	..s $p(^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncId",pid,incId),"^",5)=qty+$p(^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncId",pid,incId),"^",5)
	.// 汇总各批次合计数
	.i '$d(^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncBatQty",pid,incId,batNo)) d
	..s ^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncBatQty",pid,incId,batNo)=qty
	.e  d
	..s ^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncBatQty",pid,incId,batNo)=qty+^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncBatQty",pid,incId,batNo)
	q pid
}

/// Description: 保存状态执行,如非单独执行则仅记录打印的PogId
/// Input:		 pid(进程Id),userId(用户Id),locId(配液中心Id),arranged(Y/N已排药)
ClassMethod SaveData(pid, userId, locId, arranged)
{
	q:pid="" "-1^pid为空"
	i arranged="Y" d
	.merge ^TMPPIVAS("Arrange","Print",pid)=^TMPPIVAS("Arrange","SaveData",pid)
	.k ^TMPPIVAS("Arrange","SaveData",pid)
	q:arranged="Y" pid
	s ps30Id=$o(^PIVAS(0,"LOCTYPENUMBER",locId,"I",30,""))
	s singleFlag=""
	i ps30Id'="" d
	.s psSingle=$p(^PIVAS(ps30Id),"^",8)
	i psSingle="Y" d
	.s pogsNo=##class(web.DHCSTPIVAS.Common).GetAppNo(30,locId)
	.i $p(pogsNo,"^",1)="-1"  q // 生成单号加锁失败
	.s pogId=""
	.f  s pogId=$o(^TMPPIVAS("Arrange","SaveData",pid,pogId)) q:pogId=""  d
	..s exeRet=##class(web.DHCSTPIVAS.DataHandler).Execute(pogId,30,userId,locId,pogsNo)
	..i $p(exeRet,"^",1)=0 s ^TMPPIVAS("Arrange","Print",pid,pogId)=^TMPPIVAS("Arrange","SaveData",pid,pogId)
	..k ^TMPPIVAS("Arrange","SaveData",pid,pogId)
	e  d
	.merge ^TMPPIVAS("Arrange","Print",pid)=^TMPPIVAS("Arrange","SaveData",pid)
	.k ^TMPPIVAS("Arrange","SaveData",pid)
	q pid
}

/// description: 建立流程字典
/// w ##class(web.DHCSTPIVAS.Arrange).MakePsStateDict(101,101)
ClassMethod MakePsStateDict(pid, locId)
{
	s psNumber=""
	f  s psNumber=$o(^PIVAS(0,"LOCTYPENUMBER",locId,"I",psNumber)) q:psNumber=""  d
	.s psId=""
	.f  s psId=$o(^PIVAS(0,"LOCTYPENUMBER",locId,"I",psNumber,psId)) q:psId=""  d
	..s psUse=$p(^PIVAS(psId),"^",3)
	..q:psUse'="Y"
	..s psRet=$p(^PIVAS(psId),"^",5)
	..q:psRet="Y"
	..s psIgnore=$p(^PIVAS(psId),"^",10)
	..s psSingle=$p(^PIVAS(psId),"^",8)
	..s ^||TMPPIVAS("Arrange","Dict","State",pid,psNumber)=psId_"^"_psIgnore_"^"_psSingle
	..i psIgnore'="Y" d /// 打包不忽略
	...s ^||TMPPIVAS("Arrange","Dict","PackState",pid,psNumber)=psId_"^"_psIgnore_"^"_psSingle
	q 0
}

/// description: 清除建立的字典
ClassMethod KillArrangeDict(pid)
{
	q:pid="" ""
	k ^||TMPPIVAS("Arrange","Dict","State",pid)
	k ^||TMPPIVAS("Arrange","Dict","PackState",pid)
	q ""
}

/// description: 清除查询产生的临时global
ClassMethod KillQueryArrange(pid)
{
	q:pid="" ""
	k ^||TMP("DHCST","web.DHCSTPIVAS.Arrange","QueryArrange",pid)
	k ^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncId",pid)
	k ^||TMP("DHCST","web.DHCSTPIVAS.Arrange","IncBatQty",pid)
	q ""
}

/// description: 清除保存数据用的临时global
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($this,"PIVA")
}

/// Description: 用于排药单打印,传什么参数就怎么汇总打印
/// Input:		 POGSNo(排药单号)
/// 			 POGIdStr(pogId串)
/// 			 Pid(Pid仅在排药统计界面打印时不为空)
/// Return:		 对应XML模板的JSON String
/// Xml:		 PHAPIVASARRANGE
/// w ##class(web.DHCSTPIVAS.Arrange).GetPrtJson("","41","")
ClassMethod GetPrtJson(POGSNo = "", POGIdStr = "", Pid = "")
{
	k GetPrtJsonDATA
	s newPid=..NewPid()
	s fPogId="",ps30StateId="",ps10StateId=""
	i Pid'="" d
	.s pogId=""
	.f  s pogId=$o(^TMPPIVAS("Arrange","Print",Pid,pogId)) q:pogId=""  d
	..q:+pogId=0
	..i fPogId="" s fPogId=pogId
	..d ..SetPogData(newPid,pogId)
	..d GetTitleData
	e  i POGIdStr'="" d
	.s pogIdLen=$l(POGIdStr,"^")
	.f i=1:1:pogIdLen d
	..s pogId=$p(POGIdStr,"^",i)
	..q:+pogId=0
	..i fPogId="" s fPogId=pogId
	..d ..SetPogData(newPid,pogId)
	..d GetTitleData
	e  i POGSNo'="" d
 	.s pogId=""
 	.f  s pogId=$o(^PIVA(0,"PogsNo",POGSNo,pogId)) q:pogId=""  d
 	..q:+pogId=0
 	..i fPogId="" s fPogId=pogId
 	..d ..SetPogData(newPid,pogId)
	..d GetTitleData
 	i Pid'="" k ^TMPPIVAS("Arrange","Print",Pid)
 	q:'$d(^||TMP("DHCST",$ClassName(),"QueryArrange",newPid)) {}.%ToJSON()
 	s retJson={}
 	s retList=[]
 	s retPara={}
 	s locId=$p(^PIVA(fPogId),"^",7)
 	s locDesc=$p(^CTLOC(locId),"^",2)
 	s hospId=$p(^CTLOC(locId),"^",22)
 	s hospDesc=$p($g(^CT("HOSP",+hospId)),"^",2)
 	s retPara.hospDesc=hospDesc_locDesc_"排药单"
 	s retPara.prtDateTime=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h)_" "_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p($h,",",2))
 	i POGSNo'="" d
 	.s retPara.pogsNo=POGSNo
 	.s retPara.pogsNoQRCode=POGSNo
 	e  d
 	.s fPOGSNo=$o(GetPrtJsonDATA("POGSNo",""))
 	.s lPOGSNo=$o(GetPrtJsonDATA("POGSNo",""),-1)
 	.i fPOGSNo=lPOGSNo d
 	..s retPara.pogsNo=fPOGSNo
 	..s retPara.pogsNoQRCode=fPOGSNo
 	i retPara.pogsNo = "" d
 	.s retPara.pogsNo="　"
 	.s retPara.pogsNoQRCode="　"
 	
 	s doseStDate=$o(GetPrtJsonDATA("DoseDate",""))
 	s doseEdDate=$o(GetPrtJsonDATA("DoseDate",""),-1)
 	s doseDateRange=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(doseStDate)_"至"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(doseEdDate)
 	s prtStDate=$o(GetPrtJsonDATA("PrtDate",""))
 	s prtEdDate=$o(GetPrtJsonDATA("PrtDate",""),-1)
 	s prtDateRange=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prtStDate)_"至"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prtEdDate)
 	s batNoStr=""
 	s batNo=""
 	f  s batNo=$o(GetPrtJsonDATA("BatNo",batNo)) q:batNo=""  d
 	.s batNoStr=$s(batNoStr="":batNo,1:batNoStr_","_batNo)
 	s title1="用药日期:"_doseDateRange_"  打签日期:"_prtDateRange_" 批次:"_batNoStr
 	s retPara.title1=title1
 	s sortIndex=""
 	f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),"QueryArrange",newPid,sortIndex)) q:sortIndex=""  d
 	.s incId=""
 	.f  s incId=$o(^||TMP("DHCST",$ClassName(),"QueryArrange",newPid,sortIndex,incId)) q:incId=""  d
 	..s data=^||TMP("DHCST",$ClassName(),"IncId",newPid,incId)
 	..s retListObj={}
 	..s retListObj.stkBin=$p(data,"^",7)
 	..s retListObj.inciDesc=$p(data,"^",2)
 	..s retListObj.spec=$p(data,"^",3)
 	..s retListObj.manfDesc=$p(data,"^",4)
 	..s retListObj.qty=$fn($p(data,"^",5), "N")
 	..s retListObj.uomDesc=$p(data,"^",6)
 	..d retList.%Push(retListObj)
 	s retJson.List=retList
 	s retJson.Para=retPara
 	q retJson.%ToJSON()
GetTitleData
 	s PIVA=^PIVA(pogId)
 	s mDsp = $p(PIVA,"^",1)
 	s adm =$p($g(^DHCOEDISQTY(mDsp)),"^",26)
 	s admType = $p(^PAADM(adm),"^",2)
 	// 需统计的抬头
 	i ps10StateId="" d
 	.s locId=$p(^PIVA(pogId),"^",7)
 	.s psType = $s(admType = "I" : "I" , 1 : "O")
 	.s ps10StateId=$o(^PIVAS(0,"LOCTYPENUMBER",locId,psType,10,""))
 	.s ps30StateId=$o(^PIVAS(0,"LOCTYPENUMBER",locId,psType,30,"")) 	
 	s batNo=$p(PIVA,"^",3)
 	s doseDate=$p(PIVA,"^",4)
 	i ps30StateId'="" d
 	.s pogsSub=$o(^PIVA(0,"PS",ps30StateId,pogId,""))
 	.i pogsSub'="" d
 	..s pogsNo=$p(^PIVA(pogId,"S",pogsSub),"^",7)
 	..q:pogsNo=""
 	..s GetPrtJsonDATA("POGSNo",pogsNo)=""
 	i ps10StateId'="" d
 	.s pogsSub=$o(^PIVA(0,"PS",ps10StateId,pogId,""))
 	.i pogsSub'="" d
 	..s ps10Date=$p(^PIVA(pogId,"S",pogsSub),"^",4)
 	..i ps10Date'="" s GetPrtJsonDATA("PrtDate",ps10Date)=""
 	s GetPrtJsonDATA("BatNo",batNo)=""
 	s GetPrtJsonDATA("DoseDate",doseDate)=""
 	q
}

ClassMethod SetTmpData4Mob(pid)
{
    q:(pid = "") $$$OK
    merge ^web.DHCSTPIVAS.ArrangeD("SetTmpData4Mob", pid) = ^TMPPIVAS("Arrange", "SaveData", pid)
    q $$$OK
}

ClassMethod KillTmpData4Mob(pid)
{
    if (pid '= ""){
        k ^web.DHCSTPIVAS.ArrangeD("SetTmpData4Mob", pid)
    }
    s pid = ""
    for {
        s pid = $o(^web.DHCSTPIVAS.ArrangeD("SetTmpData4Mob", pid)) q:(pid = "")
        if ($zdh($e(pid,2,9), 8) < +$h){
            k ^web.DHCSTPIVAS.ArrangeD("SetTmpData4Mob", pid)
        }
    }
    q $$$OK
}

}
