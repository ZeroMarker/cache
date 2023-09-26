Import sqluser

/// creator:	yunhaibao
/// createdate: 2018-10-19
/// description:住院发药统计数据 
Class web.DHCINPHA.Disp.Query Extends %RegisteredObject
{

/// description: 查询病区方法
ClassMethod GetDispWardCats(InputStr)
{
	s CellSplit="!!"
	s StartDate=$p(InputStr,CellSplit,1)
	s StartTime=$p(InputStr,CellSplit,2)
	s EndDate=$p(InputStr,CellSplit,3)
	s EndTime=$p(InputStr,CellSplit,4)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s PhaLocId=$p(InputStr,CellSplit,5)
	s WardId=$p(InputStr,CellSplit,6)
	s WardLocId = $s(WardId'="":$p(^PAWARD(WardId), "^", 5),1:"")
	s LocGrpId=$p(InputStr,CellSplit,7) 
	s LocalCon=$p(InputStr,CellSplit,8) 	// 客户端设置
	s DispTypeStr=$p(InputStr,CellSplit,9)
	i DispTypeStr'="" s DispTypeList=$lfs(DispTypeStr,"^")
	s DispWay = $p(InputStr,CellSplit,10)
	s IncludePreIP = $p(InputStr,CellSplit, 11)		// 仅预住院
	s PhaLocation=$o(^DHCPL(0,"Loc",PhaLocId,""))
	s DealOrdFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)
	s HospId=$p(^CTLOC(PhaLocId),"^",22)
	s pid=..NewPid()
	d ##class(web.DHCINPHA.Disp.Global).KillGetDispWardCats(pid)
	
	s diffFloorLoc = ##class(PHA.IP.COM.Method).GetDiffFloorLoc(HospId)
	d ..ReCheckOEDispCat(StartDate,EndDate,PhaLocId)
	s count=0
	s calcuDate=""
	f calcuDate=StartDate:1:EndDate d
	.s wardLocId=""
	.f  s wardLocId=$o(^DHCOEDISQTY(0,"REC",PhaLocId,calcuDate,"TC",wardLocId)) q:wardLocId=""  d
	..s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
	..// 过滤条件-病区
	..q:(WardLocId'="")&&(WardLocId'=wardLocId)
	..// 过滤条件-科室组
	..q:(LocGrpId '= "")&&(##class(PHA.COM.Method).IsInLocGrp(LocGrpId,wardLocId) '= "Y") 
	..s catCode=0
	..f  s catCode=$o(^DHCOEDISQTY(0,"REC",PhaLocId,calcuDate,"TC",wardLocId,catCode)) q:catCode=""  d
	...q:$d(GetDispWardCatsData("Exist",wardLocId,catCode))
	...q:(DispTypeStr'="")&&($lf(DispTypeList,catCode)=0)
	...s existFlag=""
	...s dspId=0
	...f  s dspId=$o(^DHCOEDISQTY(0,"REC",PhaLocId,calcuDate,"TC",wardLocId,catCode,dspId)) q:(dspId="")!(existFlag'="")  d
	....q:'$d(^DHCOEDISQTY(dspId,"I"))
	....s dspData=^DHCOEDISQTY(dspId)
	....// 过滤条件-用药时间
	....s oeori=$p(dspData,"^",1)    
	....s oeore=$p(dspData,"^",3) 
	....s ordId=+oeori
	....s ordItm=+$p(oeori,"||",2)
	....s admId=$p(^OEORD(ordId),"^",1)
	....s admType=$p($g(^PAADM(admId)),"^",2)
	....q:admType'="I" 
	....s visitStatus = $p($g(^PAADM(admId)), "^", 20)		// 在院状态
	....q:(IncludePreIP = "Y")&&(visitStatus '= "P")
	....q:(IncludePreIP '= "Y")&&(visitStatus = "P")
	....// 过滤-执行记录停止
	....q:##class(web.DHCSTCOMMONSRV).GetOrdState(oeore)=0 
	....s doseTime=$p(dspData,"^",20) 
	....// 过滤条件-用药时间
	....q:(StartTime'="")&&(calcuDate=StartDate)&&(doseTime'="")&&(doseTime<StartTime)
	....q:(EndTime'="")&&(calcuDate=EndDate)&&(doseTime'="")&&(doseTime>EndTime)
	....// 过滤-预停日期及时间小于要求执行记录时间
	....s tEndDate=$p($g(^OEORD(ordId,"I",ordItm,9)),"^",9)
 	....s tEndTime=$p($g(^OEORD(ordId,"I",ordItm,9)),"^",10)  
 	....q:(tEndDate=calcuDate)&&(tEndTime<doseTime)
	....// 过滤-病区发药\医生科室发药
	....q:($lg(##class(PHA.IP.COM.Method).GetOrderDispWay(oeori),1)'=DispWay)
	....s priorityId=$p(^OEORD(ordId,"I",ordItm,1),"^",8) 
	....q:priorityId=""
	....s priCode=$p($g(^OECPR(+priorityId)),"^",1)
	....// 过滤-自备         
	....q:priCode["OM" 
	....// 过滤-护士审核	MaYuqiang 20220526 基数药发药不判断领药审核		预住院的也不判断护士领药审核
	....q:((##class(web.DHCSTCOMMONSRV).IfAuditByPriority(dspId)=0)&&(DispWay '= "BASEDISP")&&(visitStatus '= "P")) 
	....// 过滤-医嘱处理	MaYuqiang 20220526 基数药发药不判断医嘱处理		预住院的也不判断处理医嘱
	....q:(DealOrdFlag="Y")&&(##class(web.DHCSTCOMMONSRV).IfOeoriNurSee(oeori)'="Y")&&(DispWay '= "BASEDISP")&&(visitStatus '= "P")
	....// 过滤-最终结算
	....s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
	....s arcItmCatId=$P($g(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1)),"^",10)
	....q:arcItmCatId="" 
	....s arcItmCatCode=$p($g(^ARC("IC",+arcItmCatId)),"^",1) 
	....i '$d(GetDispWardCatsData("AmtFlag",admId_"^"_arcItmCatId_"^"_priCode)) d
	.....s amtFlag=##Class(web.DHCSTCOMMONSRV).IfCollectDrugAllowed(admId,arcItmCatId_"^"_priCode)	
 	.....s GetDispWardCatsData("AmtFlag",admId_"^"_arcItmCatId_"^"_priCode)=amtFlag
 	....e  s amtFlag=GetDispWardCatsData("AmtFlag",admId_"^"_arcItmCatId_"^"_priCode)
 	....q:amtFlag=0
 	....// 过滤-拒绝发药
 	....q:..HaveBeenRefused(dspId)="Y" 
 	....// 过滤-客户端设置  
 	....i LocalCon'="" q:##Class(web.DHCSTPCHCOLLS5).CheckPrioDispCat(LocalCon,priCode_"#"_catCode)=0 
 	....// 过滤-医嘱审核
 	....q:##class(web.DHCSTKUTIL).GetOrdAuditResult(dspId)'="Y"
 	....s toLoc = ##class(PHA.IP.COM.Method).GetDspToLoc(dspId)
 	....// 楼层
	....i $lf(diffFloorLoc, toLoc)>0 d
 	.....s bed=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admId,toLoc),"^",1)
 	.....s floorStr = ##class(PHA.IP.COM.Method).GetBedFloor(bed)
 	.....s floor = $lg(floorStr,1)
 	.....i floor = "" s floor=0
 	.....s floorDesc = $lg(floorStr,2)
 	....e  s floor=0,floorDesc=""
 	....s sortIndex=$p(^CTLOC(toLoc),"^",43)_"#"_$p(^CTLOC(toLoc),"^",2)_"#"_floorDesc_"#"_floor
 	....s index = $lb(toLoc, floor)
 	....i '$d(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispWardCats",pid,sortIndex,index,catCode)) d
	.....s ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispWardCats",pid,sortIndex,index,catCode)=""
	....s ordSpecInfo="" 
 	....s notifyFlag=$p($g(^OEORD(ordId,"I",ordItm,11)),"^",55)
 	....i notifyFlag="Y" d
 	.....s $p(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispWardCats",pid,sortIndex,index,catCode),",",1)="急"
	....//涉及找加急,因此如下屏蔽
	....//s existFlag=1
	....//s GetDispWardCatsData("Exist",wardLocId,catCode)=""
	s count=99999	
	q pid_"^"_count
}

/// creator: 	 yunhaibao
/// createdate:	 2018-10-12
/// description: 获取待发汇总数据,为最终输出做数据准备
ClassMethod GetDispTotal(StartRow, EndRow, InputStr, Pid)
{
	q:(InputStr="")&&(Pid="") ""
	s PhaLocId=$p(InputStr,"!!",1)
	s HospId=$p(^CTLOC(PhaLocId),"^",22)
	// 在此涉及分页
	i Pid="" d
	.s retData=..CollDispData(InputStr,"GetDispTotal")
	.s newPid=retData
	e  s newPid=Pid
	q:newPid="" ""
	d ##class(web.DHCINPHA.Disp.Global).KillJqDispOutput(newPid)
	s count=0
	d CalcuTotal
	s sortIndex=""
	f  s sortIndex=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex)) q:sortIndex=""  d
	.s dspIncId=""
	.f  s dspIncId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId)) q:dspIncId=""  d
	..s count=count+1
	..q:count<StartRow
    ..q:count>EndRow
    ..s notifyOrd=$p($g(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId)),"^",1)
	..s incCh=$o(^INCI("IL_LOC",PhaLocId,dspIncId,"")) 
    ..s bedQtys=""
    ..s qty=0
    ..s spAmt=0
    ..s sp=0
    ..s bedIndex=""
    ..f  s bedIndex=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedIndex)) q:bedIndex=""  d
    ...s bedData=^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedIndex)
    ...s bedQty=$p(bedData,"^",1)
    ...s bedSpAmt=$p(bedData,"^",2)
    ...s sp=$p(bedData,"^",3)
    ...s bedNo=$p(bedData,"^",4)
    ...i bedNo="" s bedNo="*"
    ...s qty=qty+bedQty
    ...s spAmt=spAmt+bedSpAmt
    ...i $l($p(bedQty,".",2))>5 d
    ....s bedQty=##class(web.DHCST.Common.AppCommon).FormatSq(bedQty,HospId,1)
    ...i (bedQty<1)&&($p(bedQty,".",1)="") s bedQty=0_bedQty
    ...i bedQtys="" s bedQtys=$j(bedQty,5)_" / "_$j(bedNo,5)
    ...e  s bedQtys=bedQtys_"</br>"_$j(bedQty,5)_" / "_$j(bedNo,5)
    ..s arcItmId=$p(^INCI(dspIncId,1),"^",3)
    ..s incDesc=##class(PHA.COM.Data.Base).InciDesc(dspIncId)
    ..s incCode=##class(PHA.COM.Data.Base).InciCode(dspIncId)
    ..s bUomId=$p(^INCI(dspIncId,1),"^",10)
    ..s bUomDesc=##class(PHA.COM.Data.Base).UomDesc(bUomId)
    ..s spec=##class(PHA.COM.Drug).GetSpec(dspIncId)
    ..s phcForm=$lg(##class(PHA.COM.Drug).GetForm(dspIncId),3)
    ..s manfDesc=$lg(##class(PHA.COM.Drug).GetManf(dspIncId),3)
    ..i incCh'="" s stkBin=$p(##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(dspIncId_"||"_incCh,",","",""),":",2) 
    ..e  s stkBin=""
    ..s arcEndFlag=..CheckArcEnd(arcItmId)
    ..s oweFeeFlag="" // todo-欠费
    ..i incCh'="" s qtyFlag=##class(web.DHCSTSTKQTY).GetPhaQty(dspIncId_"||"_incCh,qty) // 库存不足
    ..e  s qtyFlag="0"
    ..s incOrdEndFlag=..CheckIncOrdEnd(dspIncId)
    ..s collStat=..MakeCollStatInfo(arcEndFlag,oweFeeFlag,qtyFlag,incOrdEndFlag,"",notifyOrd)
    ..i $l($p(qty,".",2))>5 d
    ...s qty=##class(web.DHCST.Common.AppCommon).FormatSq(qty,HospId,1)
    ..i (qty<1)&&($p(qty,".",1)="") s qty=0_qty
    ..i sp["." s sp=$fn(sp,"",$l($p(sp,".",2)))
    ..i spAmt["." s spAmt=$fn(spAmt,"",$l($p(spAmt,".",2)))
	..s insuCode = ##class(PHA.COM.Drug).GetInsuCode(dspIncId, HospId)
	..s insuDesc = ##class(PHA.COM.Drug).GetInsuDesc(dspIncId, HospId)	
	..s data1=newPid_"^"_collStat_"^"_incDesc_"^"_qty_"^"_bUomDesc
    ..s data2=sp_"^"_spAmt_"^"_phcForm_"^"_bedQtys_"^"_spec
    ..s data3=manfDesc_"^"_stkBin_"^"_insuCode_"^"_insuDesc
    ..s data=data1_"^"_data2_"^"_data3
    ..s ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","OutPut",newPid,count)=data
    k ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid)
    q newPid_"^"_count
CalcuTotal
	k GetDispTotalData
	s dspId=""
	f  s dspId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispTotal",newPid,dspId)) q:dspId=""  d
	.// 过滤-明细未选择
	.q:$d(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveToFilter",newPid,dspId))
	.s dspData=^DHCOEDISQTY(dspId)
	.s oeori=$p(dspData,"^",1)
	.s notifyOrd=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),11)),"^",55)
	.s admId=$p(dspData,"^",26)
	.s wardLocId=$p(dspData,"^",22)
	.i '$d(GetDispTotalData("PatInfo",admId)) d
	..s bedNo=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admId,wardLocId),"^",2)
	..s GetDispTotalData("PatInfo",admId)=bedNo
	.e  s bedNo=GetDispTotalData("PatInfo",admId)
	.s bedNoIndex=bedNo
	.i bedNoIndex="" s bedNoIndex="*"_admId
	.s sortIndex="1"
	.i $d(^DHCOEDISQTY(dspId,"I")) d	// 医嘱结构改造
	..s dspSub=0
	..f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	...s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	...s dspIncId=$p(dspSubData,"^",5)	// 肯定有
	...s dspInclb=$p(dspSubData,"^",1)	// 批次价有
	...s dspIncQty=$p(dspSubData,"^",2)
	...s dspSp=$p(dspSubData,"^",4)
	...s dspSpAmt=dspIncQty*dspSp
	...i '$d(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedNoIndex)) d
	....s ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedNoIndex)=dspIncQty_"^"_dspSpAmt_"^"_dspSp_"^"_bedNo
	...e  d
	....s $p(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedNoIndex),"^",1)=dspIncQty+$p(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedNoIndex),"^",1)
	....s $p(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedNoIndex),"^",2)=dspSpAmt+$p(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedNoIndex),"^",2)
	...i notifyOrd="Y" s $p(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId),"^",1)="Y"
	.e  d // 原始
	..q
	..s oeori=$p(dspData,"^",1)
	..s arcItmId=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2)
	..s dspIncId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	..s dspIncQty=$p(dspData,"^",5)
	..i '$d(^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedNoIndex)) d
	...s ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedNoIndex)=dspIncQty
	..e  s ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedNoIndex)=dspIncQty+^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispTotal","BedNoQtys",newPid,sortIndex,dspIncId,bedNoIndex)
	q
}

/// creator: 	 yunhaibao
/// createdate:	 2018-10-15
/// description: 获取待发明细数据,输出前汇总
/// w ##class(web.DHCINPHA.Disp.Query).GetDispDetail(1,50,"311!!5!!26/12/2018!!28/12/2018!!4638!!!!0!!0||NOEmOrd||!!0!!KF^ZJ##D20181227P717!!!!!!!!00:00!!23:59!!","")
ClassMethod GetDispDetail(StartRow, EndRow, InputStr, Pid)
{
	d ##class(web.DHCINPHA.Disp.Global).KillCollDispData()
	s PhaLocId=$p(InputStr,"!!",1)
	s HospId=$p($g(^CTLOC(+PhaLocId)),"^",22)
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospId)
	// 在此涉及分页
	i Pid="" d
	.s retData=..CollDispData(InputStr,"GetDispDetail")
	.s newPid=retData
	e  s newPid=Pid
	q:newPid="" ""
	d ##class(web.DHCINPHA.Disp.Global).KillJqDispOutput(newPid)
	s count=0,detailCnt=0
	d CalcuDetail
    q newPid_"^"_count
CalcuDetail
	// 明细不再涉及重新排序了,直接由此输出
	k GetDispDetailData
	// date+oeori_inci
	// sortIndex=wardIndex_"^"_catCode_"^"_admId_"^"_calcuDate_"^"_oeori
	s sortIndex=""
	f  s sortIndex=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispDetail",newPid,sortIndex)) q:sortIndex=""  d
	.s count=count+1
	.q:count<StartRow
    .q:count>EndRow
	.s oeori=$p(sortIndex,"^",5)
	.s ordId=+oeori
	.s ordItm=+$p(oeori,"||",2)
	.s admId=$p(^OEORD(ordId),"^",1)
    .s admData=$$GetAdmData(admId)
    .s oeoriData=$$GetOeoriData(oeori)
	.q:(admData="")||(oeoriData="")
    .// 就诊+患者基本信息
    .s patId=$p(admData,"^",1)
    .s patName=$p(admData,"^",2)
    .s patNo=$p(admData,"^",3)
    .s admLocDesc=$p(admData,"^",4)
    .s bedNo=$p(admData,"^",5)
    .s diagDesc=$p(admData,"^",6)
    .s patAge=$p(admData,"^",7)
    .s patSex=$p(admData,"^",8)
	.s encryptLevel=$p(admData,"^",9)
	.s patLevel=$p(admData,"^",10)
	.s oweFeeFlag=""
	.i $d(^TMP("DHCST","web.DHCINPHA.Disp.Query","AdmOweFee",newPid,admId)) s oweFeeFlag="Y" 
    .// 医嘱信息
    .s dosage=$p(oeoriData,"^",1)
    .s freqDesc=$p(oeoriData,"^",2)
    .s instrucDesc=$p(oeoriData,"^",3)
    .s insuTypeDesc=$p(oeoriData,"^",4)
    .s oeoriStat=$p(oeoriData,"^",5)
    .s priDesc=$p(oeoriData,"^",6)
    .s dosage=$p(oeoriData,"^",7)
    .s duraDesc=$p(oeoriData,"^",8)
    .s prescNo=$p(oeoriData,"^",9)
    .s docName=$p(oeoriData,"^",10)
    .s oeoriDateTime=$p(oeoriData,"^",11)
    .s oeoriRemark=$p(oeoriData,"^",12)
	.s urgentFlag=$p(oeoriData,"^",13)
	.s cookType=$p(oeoriData,"^",14)
	.s mOeori=$p(oeoriData,"^",15)
	.s skinTestValue=$p(oeoriData,"^",16)
	.s skinTestDesc=$p(oeoriData,"^",17)
	.s phaOrdStatDesc=$p(oeoriData,"^",18)
	.s oeoriSeqNo=$p(oeoriData,"^",19)
	.s nurSeeDesc=$p(oeoriData,"^",20)
	.s notifyOrd=$p(oeoriData,"^",21)
	.s diagDesc=$p(oeoriData,"^",22)
    .// 用药信息
    .k GetDispDetailData("OeoriInc")
    .s doseDateHtml=""
    .s doseTimesHtml=""
    .s nurseAuditHtml = ""
    .s dspIdStr=""
	.s dspId=""
	.f  s dspId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispDetail",newPid,sortIndex,dspId)) q:dspId=""  d
    ..s dspData=^DHCOEDISQTY(dspId)
    ..s doseDate=$p(dspData,"^",21)
    ..s doseTime=$p(dspData,"^",20)
    ..s doseDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(doseDate)
    ..//s doseTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(doseTime)
    ..s doseTimeHtml=$zt(doseTime,2)
    ..s doseTimesHtml=$s(doseTimesHtml="":doseTimeHtml,1:doseTimesHtml_","_doseTimeHtml)
    ..s nurseAuditDate = $p(dspData, "^", 18)
    ..s nurseAuditTime = $p(dspData, "^", 19)
    ..s nurseAuditDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(nurseAuditDate)
    ..s:nurseAuditTime'="" nurseAuditTime = $zt(nurseAuditTime)
    ..s nurseAuditInfo = ""
    ..s:nurseAuditDate'="" nurseAuditInfo = nurseAuditDate _" "_ nurseAuditTime
    ..s:nurseAuditInfo'="" nurseAuditHtml = $s(nurseAuditHtml="":nurseAuditInfo,1:nurseAuditHtml _"</br>"_ nurseAuditInfo)
    ..s dspIdStr=$s(dspIdStr="":dspId,1:dspIdStr_","_dspId)
 	..i $d(^DHCOEDISQTY(dspId,"I")) d	// 医嘱结构改造
	...s dspSub=0
	...f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	....s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	....s dspIncId=$p(dspSubData,"^",5)	// 肯定有
	....s dspInclb=$p(dspSubData,"^",1)	// 批次价有
	....s dspIncQty=$p(dspSubData,"^",2)
	....s dspSp=$p(dspSubData,"^",4)
	....s dspSpAmt=dspIncQty*dspSp
	....i '$d(GetDispDetailData("OeoriInc",dspIncId)) d
	.....s GetDispDetailData("OeoriInc",dspIncId)=dspIncQty_"^"_dspSpAmt_"^"_dspSp
	....e  d 
	.....s $p(GetDispDetailData("OeoriInc",dspIncId),"^",1)=dspIncQty+$p(GetDispDetailData("OeoriInc",dspIncId),"^",1)
	.....s $p(GetDispDetailData("OeoriInc",dspIncId),"^",2)=dspSpAmt+$p(GetDispDetailData("OeoriInc",dspIncId),"^",2)
	..e  d // 原始
	...s oeori=$p(dspData,"^",1)
	...s arcItmId=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2)
	...s dspIncId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	...s dspIncQty=$p(dspData,"^",5)
	...i '$d(GetDispDetailData("OeoriInc",dspIncId)) d
	....s GetDispDetailData("OeoriInc",dspIncId)=dspIncQty
	...e  d 
	....s GetDispDetailData("OeoriInc",dspIncId)=dspIncQty+GetDispDetailData("OeoriInc",dspIncId)
	.s packQty = $p($g(^OEORD(ordId, "I", ordItm, 9)), "^", 4)
	.s dispUom = $p($g(^OEORD(ordId, "I", ordItm, "DHC")),"^",13)
	.
	.s incId=""
	.f  s incId=$o(GetDispDetailData("OeoriInc",incId)) q:incId=""  d
	..s detailData=GetDispDetailData("OeoriInc",incId)
	..s bQty=$p(detailData,"^",1)
	..s spAmt=$p(detailData,"^",2)
	..s sp=$p(detailData,"^",3)
	..s arcItmId=##class(PHA.COM.Drug).GetArcim(incId)
	..s incDesc=##class(PHA.COM.Drug).GetInciDesc(incId)
	..i skinTestDesc'="" d
	...i skinTestDesc="(-)" d
	....s incDesc="<span style=color:#04AD6B;font-weight:bold>"_skinTestDesc_"</span>"_incDesc
	...e  i skinTestDesc="(+)" d
	....s incDesc="<span style=color:#FF694C;font-weight:bold>"_skinTestDesc_"</span>"_incDesc
	...e  d
	....i skinTestValue<0 d
	.....s incDesc="<span style=color:red;font-weight:bold>"_skinTestDesc_"</span>"_incDesc
	....e  s incDesc="<span style=font-weight:bold>"_skinTestDesc_"</span>"_incDesc
	..s bUom=$p(^INCI(incId,1),"^",10)
	..i (packQty'="")&&(dispUom'="") d
	...s uomId=dispUom
	...s fac = ##class(PHA.COM.Data.Base).UOMFac(dispUom, bUom)
	...s qty = bQty / fac
	..e  d
	...s qty = bQty
	...s uomId = bUom
	..s uomDesc=##class(PHA.COM.Data.Base).UomDesc(uomId)
	..s batNo="",nurseAudit="",infoStr="",seqNo=""	// 暂不用
	..s select="Y"
	..s tmpDspI=0
 	..f tmpDspI=1:1:$l(dspIdStr,",") q:select="N"  d
 	...s tmpDspId=$p(dspIdStr,",",tmpDspI)
 	...i $d(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveToFilter",newPid,tmpDspId)) s select="N"
 	..// 医嘱项截止-库存不足-欠费
    ..s arcEndFlag=..CheckArcEnd(arcItmId)
	..s incCh=$o(^INCI("IL_LOC",PhaLocId,incId,"")) 
	..i incCh'="" s qtyFlag=##class(web.DHCSTSTKQTY).GetPhaQty(incId_"||"_incCh,bQty) // 库存不足
	..e  s qtyFlag="0"
	..s incOrdEndFlag=..CheckIncOrdEnd(incId)
    ..s collStat=..MakeCollStatInfo(arcEndFlag,oweFeeFlag,qtyFlag,incOrdEndFlag,nurSeeDesc,notifyOrd)	
	..s incData=$$GetIncData(incId) 
	..s geneName=$p(incData,"^",1)
	..s formDesc=$p(incData,"^",2)
	..s spec=$p(incData,"^",3)
	..s manfDesc=$p(incData,"^",4)
	..s stkBin=$p(incData,"^",5)
    ..i $l($p(qty,".",2))>5 d
    ...s qty=##class(web.DHCST.Common.AppCommon).FormatSq(qty,HospId,1)
	..i (qty<1)&&($p(qty,".",1)="") s qty=0_qty
    ..i sp["." s sp=$fn(sp,"",$l($p(sp,".",2)))
    ..i spAmt["." s spAmt=$fn(spAmt,"",$l($p(spAmt,".",2)))
	..s colDataStr1=newPid_"^"_insuTypeDesc_"^"_admLocDesc_"^"_bedNo_"^"_patName_"^"_patNo_"^"_incDesc_"^"_qty_"^"_uomDesc_"^"_sp
	..s colDataStr2=oeoriStat_"^"_priDesc_"^"_dosage_"^"_freqDesc_"^"_instrucDesc_"^"_duraDesc_"^"_prescNo_"^"_batNo_"^"_oeori_"^"_phaOrdStatDesc
	..s colDataStr3=geneName_"^"_formDesc_"^"_spec_"^"_manfDesc_"^"_stkBin_"^"_spAmt_"^"_docName_"^"_doseDateHtml_"^"_diagDesc_"^"_patAge
	..s colDataStr4=oeoriRemark_"^"_patSex_"^"_infoStr_"^"_encryptLevel_"^"_patLevel_"^"_mOeori_"^"_doseTimesHtml_"^"_urgentFlag_"^"_cookType_"^"_seqNo
	..s colDataStr5=dspIdStr_"^"_select_"^"_collStat_"^"_oeoriSeqNo_"^"_nurseAuditHtml
	..s colDataStr=colDataStr1_"^"_colDataStr2_"^"_colDataStr3_"^"_colDataStr4_"^"_colDataStr5
	..s detailCnt=detailCnt+1
	..s ^TMP("DHCST","web.DHCINPHA.Disp.Query","GetDispDetail","OutPut",newPid,detailCnt)=colDataStr
	k ^TMP("DHCST","web.DHCINPHA.Disp.Query","AdmData",newPid)
	k ^TMP("DHCST","web.DHCINPHA.Disp.Query","OeoriData",newPid)
	k ^TMP("DHCST","web.DHCINPHA.Disp.Query","IncData",newPid)
	q
GetAdmData(admId)
	q:$d(%zGetAdmData(admId)) %zGetAdmData(admId)
	s patId=$p(^PAADM(admId),"^",1)
	s patName=$p(^PAPER(patId,"ALL"),"^",1) 
	s patNo=$p(^PAPER(patId,"PAT",1),"^",1) 
	s admLocId=$p(^PAADM(admId),"^",4)
	s admLocDesc=##class(PHA.COM.Data.Base).LocDesc(admLocId)
	s tmpDspId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispDetail",newPid,sortIndex,""))
	s tmpWardLocId=$p(^DHCOEDISQTY(tmpDspId),"^",22)
	s bedNo=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admId,tmpWardLocId),"^",2)
	s patAge=##class(PHA.FACE.IN.Com).GetAge(patId,admId)
	s patSex=$p($g(^PAPER(patId,"ALL")),"^",7)
 	s patSex=##class(PHA.COM.Data.Base).SexDesc(patSex)
    i EncryptFlag=1 d
 	.s encryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patId,"")
 	.s encryptLevel=$p(encryptLevelInfo,"^",1)
 	.s patLevel=$p(encryptLevelInfo,"^",2)
 	e  s (encryptLevel,patLevel)=""
 	s diagDesc=""
	s getAdmData1=patId_"^"_patName_"^"_patNo_"^"_admLocDesc_"^"_bedNo
	s getAdmData2=diagDesc_"^"_patAge_"^"_patSex_"^"_encryptLevel_"^"_patLevel
	s getAdmData=getAdmData1_"^"_getAdmData2
	s %zGetAdmData(admId)=getAdmData
	q getAdmData
GetOeoriData(oeori)
	q:$d(%zGetOeoriData(oeori)) %zGetOeoriData(oeori)
	s ordId=+oeori
	s ordItm=+$p(oeori,"||",2)
	s mOeori=##class(web.DHCSTCOMMONORDER).GetMainOeori(oeori)
	s dosage=##class(PHA.COM.Order).OeoriDosage(oeori)
	s freqDesc=$p(##class(PHA.COM.Order).OeoriFreq(oeori),"^",3)
	s instrucDesc=$p(##class(PHA.COM.Order).OeoriInstruc(oeori),"^",2)
	s insuTypeDesc=##class(PHA.COM.Order).OeoriInsuType(oeori)
	s oeoriStat=$p(##class(PHA.COM.Order).OeoriStat(oeori),"^",2)
	s priStr=##class(PHA.COM.Order).OeoriPriority(oeori)
    s priDesc=$p(priStr,"^",3)
    s duraDesc=$p(##class(PHA.COM.Order).OeoriDuration(oeori),"^",2)
    s prescNo=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",14)
    s docName=$p(##class(PHA.COM.Order).OeoriDoctor(oeori),"^",2)
    s oeoriDateTime=##class(PHA.COM.Order).OeoriDateTime(oeori)
    s oeoriRemark=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),2)),"^",8)
    i oeoriRemark="" s oeoriRemark=##class(PHA.COM.Order).OeoriRemark(oeori)
	s urgentFlag=$p($g(^OEORD(ordId,"I",ordItm,11)),"^",55)
	s cookType=##class(PHA.COM.Order).PrescCookType(prescNo)
	s skinTestStr=##class(PHA.COM.Order).OeoriSkinTest(oeori)
	s skinTestValue=$p(skinTestStr,"^",1)
	s skinTestDesc=$p(skinTestStr,"^",2)
	s passStr=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),7)),"^",3)
	s phaOrdStatDesc=""
	s passResult=$p(passStr,",",4)   
    i passResult="SHTG" s phaOrdStatDesc=" 通过"
    e  i passResult="SHJJ" s phaOrdStatDesc=" 拒绝"
    s oeoriSeqNo=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),3)),"^",4)
    s nurSeeStr=##class(web.DHCSTCOMMONSRV).GetNurseSeeType(oeori,PhaLocId)
    i $p(nurSeeStr,"^",2)="R" s nurSeeDesc=$p(nurSeeStr,"^",3)
    e  s nurSeeDesc=""
  	s notifyOrd=$p($g(^OEORD(ordId,"I",ordItm,11)),"^",55)
  	i (prescNo'="")&&('$d(tmpOeoriData("diag", prescNo)))  d
	.s tmpOeoriData("diag", prescNo)=##class(PHA.FACE.IN.Com).GetMRDiagnosDesc(prescNo,", ")
	s diagDesc=$s(prescNo'="":$g(tmpOeoriData("diag", prescNo)),1:"")
	s getOeoriData1=dosage_"^"_freqDesc_"^"_instrucDesc_"^"_insuTypeDesc_"^"_oeoriStat
	s getOeoriData2=priDesc_"^"_dosage_"^"_duraDesc_"^"_prescNo_"^"_docName
	s getOeoriData3=oeoriDateTime_"^"_oeoriRemark_"^"_urgentFlag_"^"_cookType_"^"_mOeori
	s getOeoriData4=skinTestValue_"^"_skinTestDesc_"^"_phaOrdStatDesc_"^"_oeoriSeqNo_"^"_nurSeeDesc
	s getOeoriData5=notifyOrd_"^"_diagDesc
	s getOeoriData=getOeoriData1_"^"_getOeoriData2_"^"_getOeoriData3_"^"_getOeoriData4_"^"_getOeoriData5
	s %zGetOeoriData(oeori)=getOeoriData
	q getOeoriData
GetIncData(incId)
	q:$d(%zGetIncData(incId)) %zGetIncData(incId)
	s geneName=$lg(##class(PHA.COM.Drug).GetGeneric(incId),3)
	s formDesc=$lg(##class(PHA.COM.Drug).GetForm(incId),3)
	s spec=##class(PHA.COM.Drug).GetSpec(incId)
	s manfDesc=$lg(##class(PHA.COM.Drug).GetManf(incId),3)
	s incCh=$o(^INCI("IL_LOC",PhaLocId,incId,"")) 
	i incCh'="" s stkBin=$p(##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incId_"||"_incCh,",","",""),":",2)
	e  s stkBin="" 
	s getIncData1=geneName_"^"_formDesc_"^"_spec_"^"_manfDesc_"^"_stkBin
	s getIncData=getIncData1
	s %zGetIncData(incId)=getIncData
	q getIncData
}

/// creator: 	 yunhaibao
/// createdate:	 2018-10-12
/// description: 获取待发数据,涉及排序
/// w ##class(web.DHCINPHA.Disp.Query).CollDispData("224!!144#0!!2021-12-15!!2021-12-17!!12179!!!!0!!0||NOEmOrd||!!0!!DM##D20211216P3250!!!!!!!!00:00:01!!23:59:57!!!!!!BASEDISP","GetDispDetail")
ClassMethod CollDispData(InputStr, QueryType)
{
	q:InputStr="" ""
	s CellSplit="!!"
	s PhaLocId=$p(InputStr,CellSplit,1)
	s ToLocStr=$p(InputStr,CellSplit,2)	// 病区1#楼层^病区2#楼层
	s StartDate=$p(InputStr,CellSplit,3)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(InputStr,CellSplit,4)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s UserId=$p(InputStr,CellSplit,5)
	s ByWardFlag=$p(InputStr,CellSplit,6)	// 是否住院发药
	s LongFlag=$p(InputStr,CellSplit,7)		// 长期医嘱(1)
	s LongFlag=$s(LongFlag=1:"Y",1:"N")
	s ShortStr=$p(InputStr,CellSplit,8)		// 临时医嘱(1)||草药急煎(EmOrd,NOEmOrd)||整散包装(ISPACK,NOPACK)
	s ShortFlag=$p(ShortStr,"||",1)
	s CyEmyFlag=$p(ShortStr,"||",2)
	s PackFlag=$p(ShortStr,"||",3)
	s ShortFlag=$s(ShortFlag=1:"Y",1:"N")	
	s CyEmyFlag=$s(CyEmyFlag="EmOrd":"Y",1:"N")	
	i PackFlag="ISPACK" s PackFlag="Y",NoPackFlag="N"
	e  i PackFlag="NOPACK" s PackFlag="N",NoPackFlag="Y"
	e  s PackFlag="",NoPackFlag=""
	s OutFlag=$p(InputStr,CellSplit,9)		// 出院带药(1)
	s OutFlag=$s(OutFlag=1:"Y",1:"N")	
	s DispCatsData=$p(InputStr,CellSplit,10)	// 发药类别#本地限发#pid(PF^OUT##971460)
	s DispCats=$p(DispCatsData,"#",1)
	s LonConfig=$p(DispCatsData,"#",2)
	s CatsPid=$p(DispCatsData,"#",3)
	s AdmId=$p(InputStr,CellSplit,11)
	s DocLocId=$p(InputStr,CellSplit,12)
	s NotAudit=$p(InputStr,CellSplit,13)	// 护士审核,不再使用,此处标识
   	s NotAudit=0
	s StartTime=$p(InputStr,CellSplit,14)
	s EndTime=$p(InputStr,CellSplit,15)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s IncId=$p(InputStr,CellSplit,16)
	s NotifyOrd=$p(InputStr,CellSplit,17)
	s DispWay=$p(InputStr,CellSplit,18)
	s IncludePreIP = $p(InputStr,CellSplit,19)	// 仅预住院医嘱
	s packCats=..GetPackCats()
	s packCatsList=$lfs(packCats,"^")
	s HospId=$p($g(^CTLOC(PhaLocId)),"^",22)
	s Params="^"_PhaLocId_"^^"_HospId
	s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","SKINTESTFLAG",Params) //皮试配置,为Y时需要判断,yunhaibao20160531
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospId)	// 进价规则
	s PhaLocation=$o(^DHCPL(0,"Loc",PhaLocId,""))
	s DealOrdFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)
	s DiffFloorLoc = ##class(PHA.IP.COM.Method).GetDiffFloorLoc(HospId)
	s pid=..NewPid()
	d ##class(web.DHCINPHA.Disp.Global).KillCollDispData(pid)
	i AdmId="" d
	.// 按病区
	.s toLocLen=$l(ToLocStr,"^")
	.s toLocI=0
	.f toLocI=1:1:toLocLen d
	..s toLocIndex=$p(ToLocStr,"^",toLocI)
	..q:toLocIndex=""
	..s toLocID=$p(toLocIndex, "#", 1)
	..s floor=$p(toLocIndex, "#", 2)
	..s wardLocId=toLocID
	..i CatsPid'="" s DispCats=$g(^TMP("DHCST","web.DHCINPHA.Disp.Query","SetTmpWardCats",CatsPid,toLocIndex))
	..q:DispCats=""
	..s catsLen=$l(DispCats,"^")
	..s catsI=0
	..f catsI=1:1:catsLen d
	...s catCode=$p(DispCats,"^",catsI)
	...q:catCode=""
	...s calcuDate=""
	...f calcuDate=StartDate:1:EndDate d
	....i DispWay="BASEDISP" d
	.....s tmpToLoc=""
	.....f  s tmpToLoc=$o(^DHCOEDISQTY(0,"REC",PhaLocId,calcuDate,"TC",tmpToLoc)) q:tmpToLoc=""  d
	......s dspId=0
	......f  s dspId=$o(^DHCOEDISQTY(0,"REC",PhaLocId,calcuDate,"TC",tmpToLoc,catCode,dspId)) q:dspId=""  d
	.......// 基数药, 遍历所有, 匹配取药科室
	.......q:##class(PHA.IP.COM.Method).GetDspToLoc(dspId)'=toLocID 
	.......d CollectDisp
	....e  d
	.....s dspId=0
	.....f  s dspId=$o(^DHCOEDISQTY(0,"REC",PhaLocId,calcuDate,"TC",toLocID,catCode,dspId)) q:dspId=""  d
	......// 病区发药
	......q:##class(PHA.IP.COM.Method).GetDspToLoc(dspId)'=toLocID 
	......d CollectDisp
	e  d
	.// 按就诊
	.s tmpDispCats=DispCats
	.s:tmpDispCats'="" tmpDispCats=$lfs(tmpDispCats,"^")
	.s floor=""
	.s calcuDate=""
	.f calcuDate=StartDate:1:EndDate d
	..s dspId=0
	..f  s dspId=$o(^DHCOEDISQTY(0,"ADM",PhaLocId,calcuDate,"TC",AdmId,dspId)) q:dspId=""  d
	...s dspData = ^DHCOEDISQTY(dspId)
	...s toLocID=##class(PHA.IP.COM.Method).GetDspToLoc(dspId)
	...
	...s catCode=$p(dspData,"^",27)
	...q:catCode=0
	...q:(tmpDispCats'="")&&($lf(tmpDispCats,catCode)=0)
	...d CollectDisp

	// 就诊欠费
	s admId=""
	f  s admId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","FeeData",pid,admId)) q:admId=""  d
	.s oeoreStr=^TMP("DHCST","web.DHCINPHA.Disp.Query","FeeData",pid,admId)
	.s amtRet=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew(pid,admId,oeoreStr,PhaLocId)
	.i amtRet="N" d
	..s ^TMP("DHCST","web.DHCINPHA.Disp.Query","AdmOweFee",pid,admId)=""
	q pid
CollectDisp
	
	q:'$d(^DHCOEDISQTY(dspId,"I"))
	s quitFlag=""
	s dspData=$g(^DHCOEDISQTY(dspId))
	q:(DispWay'=$lg(##class(PHA.IP.COM.Method).GetOrderDispWay($p(dspData,"^",1)),1))
	s oeori=$p(dspData,"^",1)
	s oeore=$p(dspData,"^",3)
	s ordId=+oeori
	s ordItm=+$p(oeori,"||",2)
	s admId=$p(^OEORD(ordId),"^",1)
	q:$p($g(^PAADM(admId)),"^",2)'="I"
	s visitStatus = $p($g(^PAADM(admId)), "^", 20)		// 在院状态
	q:(IncludePreIP = "Y")&&(visitStatus '= "P")
	q:(IncludePreIP '= "Y")&&(visitStatus = "P")
	// 过滤-医嘱处理	MaYuqiang 20220526 基数药发药不判断医嘱处理。 20220707 预住院医嘱也不判断医嘱处理
	q:(DealOrdFlag="Y")&&(##class(web.DHCSTCOMMONSRV).IfOeoriNurSee(oeori)'="Y")&&(DispWay '= "BASEDISP")&&(IncludePreIP '= "Y")
	// 过滤-执行记录停止
	q:##class(web.DHCSTCOMMONSRV).GetOrdState(oeore)=0 
	s doseTime=$p(dspData,"^",20) 
	// 过滤条件-用药时间
	q:(StartTime'="")&&(calcuDate=StartDate)&&(doseTime'="")&&(doseTime<StartTime)
	q:(EndTime'="")&&(calcuDate=EndDate)&&(doseTime'="")&&(doseTime>EndTime)
	// 过滤-预停日期及时间小于要求执行记录时间
	s tEndDate=$p($g(^OEORD(ordId,"I",ordItm,9)),"^",9)
 	s tEndTime=$p($g(^OEORD(ordId,"I",ordItm,9)),"^",10)  
 	q:(tEndDate=calcuDate)&&(tEndTime<doseTime)
	// 过滤-医生科室
	s docLocId=$p(^OEORD(ordId,"I",ordItm,7),"^",2)   	
	s priorityId=$p(^OEORD(ordId,"I",ordItm,1),"^",8) 
	q:priorityId=""
	s priCode=$p($g(^OECPR(+priorityId)),"^",1)
	// 过滤-自备         
	q:priCode["OM" 
	// 过滤-护士审核	MaYuqiang 20220526 基数药发药不判断护士审核。 20220707 预住院医嘱也不判断护士审核
	q:(##class(web.DHCSTCOMMONSRV).IfAuditByPriority(dspId)=0)&&(DispWay '= "BASEDISP")&&(IncludePreIP '= "Y") 
	// 过滤-最终结算
	s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
	s arcItmCatId=$P($g(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1)),"^",10)
	q:arcItmCatId="" 
	s arcItmCatCode=$p($g(^ARC("IC",+arcItmCatId)),"^",1) 
	i '$d(CollDispDataArr("AmtFlag",admId_"^"_arcItmCatId_"^"_priCode)) d
	.s amtFlag=##Class(web.DHCSTCOMMONSRV).IfCollectDrugAllowed(admId,arcItmCatId_"^"_priCode_"^"_oeori)
 	.s CollDispDataArr("AmtFlag",admId_"^"_arcItmCatId_"^"_priCode)=amtFlag
 	e  s amtFlag=CollDispDataArr("AmtFlag",admId_"^"_arcItmCatId_"^"_priCode)
 	q:amtFlag=0
 	// 过滤-拒绝发药
 	q:..HaveBeenRefused(dspId)="Y" 
 	// 过滤-客户端设置  
 	i LonConfig'="" q:##Class(web.DHCSTPCHCOLLS5).CheckPrioDispCat(LonConfig,priCode_"#"_catCode)=0 
 	// 过滤-医嘱审核
 	q:##class(web.DHCSTKUTIL).GetOrdAuditResult(dspId)'="Y" 
 	// 过滤-皮试结果(yunhiabao,皮试合不合格都给与显示)
 	// s skinTest=##class(web.DHCSTPCHCOLLS2).SkinTest(oeori)
 	// q:(NeedSkinTest="Y")&&(skinTest<0)&&(skinTest'=-5)
 	// 更多条件...针对详细数据
	// 过滤条件-客户端参数
	// 过滤条件-出院带药
	q:(OutFlag="Y")&&(priCode'="OUT")
	q:(OutFlag'="Y")&&(priCode="OUT")
	// 过滤条件-长期医嘱
	q:(LongFlag="Y")&&(priCode'="S")
	// 过滤条件-临时医嘱(非长期+出院带药)
	q:(ShortFlag="Y")&&((priCode="OUT")||(priCode="S"))
	// 过滤条件-草药急煎
	i CyEmyFlag="Y" d
	.s prescNo=$p(^OEORD(ordId,"I",ordItm,1),"^",14) 
	.s cyEmyFlag=..GetCyEmy(prescNo)
	.i cyEmyFlag'="Y" s quitFlag=1
	// 过滤条件-整包装,散包装
	i (PackFlag'="")||(NoPackFlag'="") d
	.s isPack=..IfBQtyIsPack(arcItmId,$p(dspData,"^",5))
	.i (PackFlag="Y")&&(isPack'="Y") s quitFlag=1
	.i (NoPackFlag="Y")&&(isPack'="N") s quitFlag=1
	// 过滤条件-药品	
	s incExist=""
	i IncId'="" d
	.i $d(^DHCOEDISQTY(dspId,"I")) d
	..s dspSub=0
	..f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:(dspSub="")||(incExist'="")  d
	...s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
	...s dspIncId=$p(dspSubData,"^",5)
	...i IncId=dspIncId s incExist=1
	.e  d
	..s oeori=$p(dspData,"^",1)
	..s arcItmId=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2)
	..s dspIncId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	..i IncId=dspIncId s incExist=1
	q:(IncId'="")&&(incExist="")
	q:quitFlag'=""
	// 过滤-加急
	q:(NotifyOrd="Y")&&($p($g(^OEORD(ordId,"I",ordItm,11)),"^",55)'="Y")
	// 过滤楼层
	i ($lf(DiffFloorLoc, toLocID)>0)&&(floor'="") d
 	.s bed=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admId,toLocID),"^",1)
 	.s bedFloor = $lg(##class(PHA.IP.COM.Method).GetBedFloor(bed),1)
 	.i bedFloor="" s bedFloor=0
 	.i floor'=bedFloor s quitFlag=1
 	e  s bedFloor=0
 	q:quitFlag'=""
 	// 排序用 病区^发药类别^就诊Id^用药日期^医嘱Id
	s wardIndex=$p(^CTLOC(toLocID),"^",43)_"||"_$p(^CTLOC(toLocID),"^",2)
 	s sortIndex=catCode_"^"_wardIndex_"^"_admId_"^"_calcuDate_"^"_oeori
 	// 明细与汇总的global同时记录,重新点击查询时K,分页不K
 	s ^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispTotal",pid,dspId)=""
 	s ^TMP("DHCST","web.DHCINPHA.Disp.Query","CollDispData","GetDispDetail",pid,sortIndex,dspId)=""
 	// 保存数据的global
 	s mDsp=##class(web.DHCSTCOMMONORDER).GetMainDspId(dspId)
 	s ^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",pid,toLocID_"#"_floor,catCode,mDsp,dspId)=sortIndex
    s feePoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(arcItmCatId_"^"_priCode_"^"_oeori) 
    // MaYuqiang 20220715 发药计费或者预住院患者需判断是否欠费
	i ((feePoint=1)||(visitStatus = "P")) d
	.// 用于判断欠费,判断发药计费
	.s dspQty=$p(dspData,"^",5)
	.s oeoreQtyData=oeore_$c(2)_dspQty
 	.i '$d(^TMP("DHCST","web.DHCINPHA.Disp.Query","FeeData",pid,admId)) d
 	.. s ^TMP("DHCST","web.DHCINPHA.Disp.Query","FeeData",pid,admId)=oeoreQtyData
 	.e   d
 	.. s ^TMP("DHCST","web.DHCINPHA.Disp.Query","FeeData",pid,admId)=^TMP("DHCST","web.DHCINPHA.Disp.Query","FeeData",pid,admId)_"^"_oeoreQtyData
 	q
}

/// description: 草药急煎标志
ClassMethod GetCyEmy(prescNo)
{
	s emyFlag=""
	q:prescNo="" ""
	s queId=""
	f  s queId=$o(^PAQUE1(0,"PrescNo",prescNo,queId)) q:queId=""  d
	.i $d(^PAQUE1(queId,"DHC")) d
	..s emyFlag=$p(^PAQUE1(queId,"DHC"),"^",22)
	q emyFlag
}

/// description: 获取需分整散包装发药的药品类别
/// w ##class(web.DHCINPHA.Disp.Query).GetPackCats()
/// 该需求一直不是很明确, 目前修改为是否整散直接按能够转换整数的入库单位数量, yunhaibao, 2022-01-24
ClassMethod GetPackCats()
{
	s result=""
	s rowId="0"
	f  s rowId=$o(^DHCSTDRUGGRP(rowId)) q:rowId=""  d
	.q:'$d(^DHCSTDRUGGRP(rowId))
	.s catCode=$p(^DHCSTDRUGGRP(rowId),"^",1)
	.s isPack=$p(^DHCSTDRUGGRP(rowId),"^",4)
	.i isPack="1" d
	..i result="" d
	...s result=catCode
	..e  d
	...s result=result_"^"_catCode 
	q result
}

/// description: 医嘱项截止
/// return:		 Y(已截止)
ClassMethod CheckArcEnd(arcItmId)
{
	q:+arcItmId=0 ""
	s arcItmEndDate=$p(^ARCIM(+arcItmId,$p(arcItmId,"||",2),7),"^",1)
	q:arcItmEndDate="" ""
	q:+arcItmEndDate<+$h "Y"
	q ""
}

/// description: 库存医嘱截止
/// return:		 Y(已截止)
ClassMethod CheckIncOrdEnd(IncId)
{
	q:+IncId=0 ""
	s itmAddId=$o(^DHCITMINFO(0,"INCI",IncId,""))
	q:itmAddId="" ""
	s incOrdEndDate=$p($g(^DHCITMINFO(itmAddId)),"^",113)
	q:incOrdEndDate="" ""
	q:+incOrdEndDate<+$h "Y"
	q ""
}

/// description: 拼接提示信息
ClassMethod MakeCollStatInfo(arcEndFlag, oweFeeFlag, qtyFlag, incOrdEndFlag, nurSeeDesc = "", notifyOrd = "")
{
	s sortNum=0
	i arcEndFlag="Y" s sortNum=sortNum+1,MakeCollStatInfoData(sortNum)="<span style='color:black;font-weight:bold;font-size:12px'>医嘱项截止</span>"
	i incOrdEndFlag="Y" s sortNum=sortNum+1,MakeCollStatInfoData(sortNum)="<span style='color:black;font-weight:bold;font-size:12px'>库存项医嘱截止</span>"
	i oweFeeFlag="Y" s sortNum=sortNum+1,MakeCollStatInfoData(sortNum)="<span style='color:black;font-weight:bold'>欠费</span>"
	i qtyFlag="0" s sortNum=sortNum+1,MakeCollStatInfoData(sortNum)="<span style='color:black;font-weight:bold'>库存不足</span>"
	i nurSeeDesc'="" s sortNum=sortNum+1,MakeCollStatInfoData(sortNum)="<span style='color:black;font-weight:bold'>"_nurSeeDesc_"</span>"
	i notifyOrd="Y" s sortNum=sortNum+1,MakeCollStatInfoData(sortNum)="<span style='color:red;font-weight:bold'>加急</span>"
	q:'$d(MakeCollStatInfoData) ""
	s collStr=""
	s sortNum=0
	f  s sortNum=$o(MakeCollStatInfoData(sortNum)) q:sortNum=""  d
	.s info=MakeCollStatInfoData(sortNum)
	.i collStr="" s collStr=info
	.e  s collStr=collStr_"</br>"_info
	q collStr
}

/// description: 按就诊记录所有医嘱信息,用于判断欠费
ClassMethod SetOrdDataForCheckFee(pid, admId, oeori, qty)
{
	 s oeoriQtyStr=oeori_$c(2)_qty
	 i '$d(^TMP("DHCST","web.DHCINPHA.Disp.Query","SetOrdDataForCheckFee",pid,admId)) d
	 . s ^TMP("DHCST","web.DHCINPHA.Disp.Query","SetOrdDataForCheckFee",pid,admId)=oeoriQtyStr
	 e   d
	 . s ^TMP("DHCST","web.DHCINPHA.Disp.Query","SetOrdDataForCheckFee",pid,admId)=^TMP("DHCST","web.DHCINPHA.Disp.Query","SetOrdDataForCheckFee",pid,admId)_"^"_oeoriQtyStr	
	 q ""
}

/// description: 控制勾选与发药,存在此global,则不予发药
/// ##class(web.DHCINPHA.Disp.Query).SaveToFilter
ClassMethod SaveToFilter(Pid, DspIdStr, Flag)
{
	q:Pid="" ""
	s dspLen=$l(DspIdStr,",")
	s dspI=0
	f dspI=1:1:dspLen d
	.s dspId=$p(DspIdStr,",",dspI)
	.q:dspId=""
	.i Flag="S" d
	..s ^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveToFilter",Pid,dspId)=""
	.e  i Flag="D" d 
	..k ^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveToFilter",Pid,dspId)
	q 0
}

/// description: 控制全选与全消,存在此global,则不予发药
/// ##class(web.DHCINPHA.Disp.Query).SaveToFilter
ClassMethod SaveToFilterMulti(Pid, DspStrData, Flag)
{
	q:Pid="" ""
	s dspStrLen=$l(DspStrData,"^")
	s dspStrI=0
	f dspStrI=1:1:dspStrLen d
	.s dspStr=$p(DspStrData,"^",dspStrI)
	.q:dspStr=""
	.d ..SaveToFilter(Pid,dspStr,Flag)
	q 0
}

/// description: 判断是否拒绝发药
/// return:		 Y(已拒绝发)
ClassMethod HaveBeenRefused(dspId) As %String
{
	q:dspId="" ""
	s stdfId=$o(^STDF("DODIS",dspId,""))
	q:stdfId="" ""
	q "Y"
}

/// description: 记录病区发药类别
ClassMethod SetTmpWardCats(WardId, CatCodeStr, Pid) As %String
{
	q:(WardId="")||(Pid="") ""
	s ^TMP("DHCST","web.DHCINPHA.Disp.Query","SetTmpWardCats",Pid,WardId)=CatCodeStr
	q 0
}

ClassMethod GetTmpWardCats(Pid, WardId)
{
	q:Pid="" ""
	q:WardId="" ""
	q $g(^TMP("DHCST","web.DHCINPHA.Disp.Query","SetTmpWardCats",Pid,WardId))
}

/// description: 按登记号发放前,获取病区
ClassMethod GetWardIdStrFromSaveSave(Pid)
{
	q:Pid="" ""
	s wardId="",wardIdStr=""
	f  s wardId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",Pid,wardId)) q:wardId=""  d
	.i wardIdStr="" s wardIdStr=wardId
	.e  s wardIdStr=wardIdStr_"^"_wardId
	q wardIdStr
}

/// description: 发药查询时验证是否存在发药类别QT,存在则重新匹配类别并更新
/// 			 Pid不为空记录到临时global
/// 不判断任何条件
ClassMethod ReCheckOEDispCat(StartDate, EndDate, PhaLocId, Pid = "")
{
	s calcuDate=""
	f calcuDate=StartDate:1:EndDate d
	.s wardLocId=""
	.f  s wardLocId=$o(^DHCOEDISQTY(0,"REC",PhaLocId,calcuDate,"TC",wardLocId)) q:wardLocId=""  d
	..s dspId=0
	..f  s dspId=$o(^DHCOEDISQTY(0,"REC",PhaLocId,calcuDate,"TC",wardLocId,"QT",dspId)) q:(dspId="")  d
	...s updRet=##class(web.DHCINPHA.Disp.Save).UpdateOEDispCat(dspId)
	...i Pid'="" d
	....s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
	....s ordId=+oeori
	....s ordItm=+$p(oeori,"||",2)
	....s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
	....s arcItmCatId=$P($g(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1)),"^",10)
	....q:arcItmCatId="" 
	....s arcItmCatDesc=$p($g(^ARC("IC",+arcItmCatId)),"^",2)
	....q:arcItmCatDesc=""
	....s ^TMP("DHCST",$ClassName(),"ReCheckOEDispCat",Pid,arcItmCatDesc) =""
	q 0
}

/// description: ReCheckOEDispCat记录的没发药类别的信息提示
ClassMethod GetReCheckOEDispCat(Pid)
{
	q:Pid="" ""
	s retStr=""
	s arcItmCat=""
	f  s arcItmCat=$o(^TMP("DHCST",$ClassName(),"ReCheckOEDispCat",Pid,arcItmCat)) q:arcItmCat=""  d
	.i retStr="" s retStr="以下医嘱子类尚未维护发药类别,将不能发药,请尽快核实维护</br>"_arcItmCat
	.e  s retStr=retStr_"</br>"_arcItmCat
	k ^TMP("DHCST",$ClassName(),"ReCheckOEDispCat",Pid)
	q retStr
}

/// Description: 验证是否整包装,可转换为整数倍的入库单位,即为整包装
/// 			 草药不起作用,目前也不在此类判断
/// Input:		 Arcim(医嘱项Id),Qty(库存基本单位数量)
/// Return:		 Y(是),N(不是),""(无法判断)
/// Debug:		 w ##class(web.DHCINPHA.Disp.Query).IfBQtyIsPack("2013||1",1)
ClassMethod IfBQtyIsPack(Arcim, Qty)
{
	s inci=$o(^INCI(0,"ARCIM_DR",+Arcim,""))
	q:inci="" ""
	s bUomId=$p(^INCI(inci,1),"^",10)
	s pUomId=$p(^INCI(inci,3),"^",6)
	s fac=+##class(web.DHCSTCOMMONSRV).UOMFac(pUomId,bUomId)
	q:fac=0 ""
	q:Qty/fac["." "N"
	q "Y"
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

}
