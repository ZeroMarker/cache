Import SQLUser

Class web.DHCANOPStat Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：        yy
/// CreatDate：      2015-02-05
/// Description：    初始化查询参数。将一些需要的初始化数据写入global中以提高查询效率
/// w ##class(web.DHCANOPStat).InitANCInquiryParam()
ClassMethod InitANCInquiryParam() As %String
{
    //d ..SetOPArrangeIndex()    //旧DHCANOPArrange表
    d ..SetOPArrangeIndexNew() //新DHCANOPArrange表
    d ..SetANIIndex()
    
    //w ##class(web.DHCANOPStat).SetInquiryCtpcpCount("ANDoctor","AN^EMAN^OUTAN")
    //设置麻醉医生数量
    
    q ""
}

/// Creator：        yy
/// CreatDate：      2014-06-22
/// Description：    手术排班统计。
/// Table：          DHC_AN_OPArrange..
/// Input：          科室Id字符串,查询策略rowid,开始日期,结束日期,日期类型(手术:"OP",入院:"Adm",出院:"Discharge")
/// Output：        输出筛选出的手术排班表Id等信息至^DHCANInquiry(anciId,"FI")节点下
/// Return：         "ok"(暂时未返回有效信息)
/// w ##class(web.DHCANOPStat).FindANOPInquiry("",1,"2011-01-1","2015-11-22","OP")
ClassMethod FindANOPInquiry(ctlocIdStr, anciId, startDate, endDate, dateType = "OP") As %String
{
    s timerStt=$h
    q:'$d(^DHCANCInquiry(+anciId)) "-2:无查询表单Id"
    s pos=0,titleStr=""
    s startTime=""
    s endTime=""
    i $l(startDate," ")>1 s startTime=$p(startDate," ",2),startDate=$p(startDate," ",1)
    i $l(endDate," ")>1 s endTime=$p(endDate," ",2),endDate=$p(endDate," ",1)
    i startTime'="" s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
    e  s startTime=0
    i endTime'="" s endTime=##class(web.DHCANOPCom).ConvertToTimeH(endTime)
    e  s endTime=86399
    s duration=endDate-startDate+1
    s startDate = ##class(web.DHCANOPCom).ConvertToDateH(startDate)
    s endDate = ##class(web.DHCANOPCom).ConvertToDateH(endDate)
    i endDate<startDate  q "-3:开始日期小于结束日期"

    k searchList,displayList,summaryTypeList,treeList,ancoTypeList,CalculateValueList,displayCodeList
    k displayOpaInfoList,CalculateRowList
    k opDateStatList,resultSearchList,NightShiftList
    k resultDataList
    
    //开关：是否按树查询处理未关联项目,是否显示科室短名称("-"后),是否为旧版手麻(2014年前上线)程序
    s ifQueryNoRelateItemByTree=1,ifShowShortLocDesc=1,ifOldAN=0
    //设置基础查询科室是按申请科室查询，还是按术者科室查询
    s locCheckType="AppLoc"
    
    ///安贞
    //s ifShowShortLocDesc=0
    //s locCheckType="SurgonLoc"
    ///
    
    s isDebug=0
    
    s ifStartStoreTimeLine=+$g(^DHCANInquiry("StartStoreTimeLine",anciId))
    
    s ancoTypeList("D")="",ancoTypeList("V")="",ancoTypeList("E")="",ancoTypeList("T")="",ancoTypeList("L")=""
    s CalculateValueList("ANDoctor")=+$g(^DHCANInquiry("CtpcpCount","ANDoctor"))
    s CalculateValueList("Days")=duration
    
    s anciDataType=$lg(^DHCANCInquiry(anciId),10)
    s anciiSub=0
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    .s anciiCode=$lg(^DHCANCInquiry(anciId,"I",anciiSub),1)
    .s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    .s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    .s anciiIsSingle=$lg(^DHCANCInquiry(anciId,"I",anciiSub),7)
    .s anciiMultipleValue=$lg(^DHCANCInquiry(anciId,"I",anciiSub),11)
    .s anciiRelateAnciiSub=$lg(^DHCANCInquiry(anciId,"I",anciiSub),26)
    .s anciiRefValue=$lg(^DHCANCInquiry(anciId,"I",anciiSub),19)
    .s anciiIsResultSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),28)
    .i anciiIsResultSearch d
    ..i anciiRelateAnciiSub'="" d
    ...s resultSearchList($lg(^DHCANCInquiry(anciId,"I",anciiRelateAnciiSub),21))=anciiRelateAnciiSub
    ...s resultSearchList($lg(^DHCANCInquiry(anciId,"I",anciiRelateAnciiSub),21),searchLevel)=anciiSub
    .e  i anciiIsSearch d
    ..s searchList(+searchLevel)=$g(searchList(+searchLevel))+1
    ..s searchList(+searchLevel,searchList(+searchLevel))=anciiSub
    ..s anciiSummaryType=$lg(^DHCANCInquiry(anciId,"I",anciiSub),24)
    ..i anciiRefValue'="" s summaryTypeList("LevelSub",searchLevel,anciiSub)="",summaryTypeList("CalculateExpression",searchLevel)=anciiRefValue
    ..i anciiSummaryType'="" d
    ...f i=1:1:$l(anciiSummaryType,",") d
    ....s summaryType=$p(anciiSummaryType,",",i)
    ....s summaryTypeList(searchLevel,summaryType)=""
    ....i anciiRefValue'="" s summaryTypeList("CalculateExpression",searchLevel,summaryType)=anciiRefValue
    ....s summaryTypeList("SumType",summaryType)=""
    ..i (anciDataType'="S")&&(anciiRefValue'="") s summaryTypeList("CalculateExpression",anciiSub)=anciiRefValue
    ..i +anciiRelateAnciiSub>0 s treeList("Branch",anciiSub)=anciiRelateAnciiSub
    ..e  i ifQueryNoRelateItemByTree s treeList("OriginNode",anciiSub)=""
    ..s treeList("NodeDisplay",anciiSub)=(anciiIsDisplay&&(anciDataType="S"))
    .e  i ((anciDataType="S")&&(anciiIsDisplay)) d
    ..s displayList(searchLevel,anciiSub)=""
    ..s displayList(searchLevel)=$g(displayList(searchLevel))+1
    ..i '$d(displayCodeList(searchLevel,anciiCode)) s displayCodeList(searchLevel)=$g(displayCodeList(searchLevel))+1
    ..s displayCodeList(searchLevel,anciiCode)=""
    .i (anciDataType'="S")&&(anciiIsDisplay) d
    ..s displayList(0,anciiSub)=""
    
    
    s anciiSub="",ifHaveOriginNode=0
    f  s anciiSub=$o(treeList("Branch",anciiSub)) q:anciiSub=""  d
    .//当某条分支的父节点没有父节点时，认为是根节点
    .i '$d(treeList("Branch",treeList("Branch",anciiSub))) s treeList("OriginNode",treeList("Branch",anciiSub))=""
    .s treeList(treeList("Branch",anciiSub),"ChildNode",anciiSub)=""

    //生成所有关联路径，按照最后端点对应的筛选层设置对应行
    i +$o(treeList("OriginNode",""))>0  d
    .s ifHaveOriginNode=1
    .s treeAnciiSub=""
    .f  s treeAnciiSub=$o(treeList("OriginNode",treeAnciiSub)) q:treeAnciiSub=""  d
    ..//递归遍历所有节点，如果不满足条件，线路的递归将中止，最终结果存入 treeList("PassPath",parentNode)
    ..//b //start recursion
    ..d InquiryRelateTreeNode(treeAnciiSub,0,"",0,"")
    ..//b //end recursion
    .m treeList("AllPath")=treeList("PassPath")
    .//根据path生成level序列
    .s treeAnciiSub=""
    .f  s treeAnciiSub=$o(treeList("AllPath",treeAnciiSub)) q:treeAnciiSub=""  d
    ..s searchLevel=+$lg(^DHCANCInquiry(anciId,"I",treeAnciiSub),21)
    ..s treeList("SearchLevel",treeAnciiSub)=searchLevel
    ..s treeNodeSeq=0
    ..f i=1:1:$l(treeList("AllPath",treeAnciiSub),"->") d
    ...//生成类似level形式序列
    ...s treeNodeSeq=treeNodeSeq+1
    ...s treeList("SearchList",searchLevel,treeNodeSeq)=+$p(treeList("AllPath",treeAnciiSub),"->",i)
    ..k searchList
    ..m searchList=treeList("SearchList")
    
    
    s wardIdStr=""
    f i=1:1:$l(ctlocIdStr,",") d
    .s ctlocId=$p(ctlocIdStr,",",i)
    .q:ctlocId=""
    .s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
    .q:wardId=""
    .i wardIdStr'="" s wardIdStr=wardIdStr_"^"
    .s wardIdStr=wardIdStr_wardId
    s opaId="",count=0,anopStr="",opaSeq=0,searchLevel="",totalOpaCount=0
    
    //参数,依次为:时间刻度,时间单位,值保留小数位,字符串信息结果中长度限制
    s timeScale=3600,timeUom="h",decimalDigits=2,stringLengthLimit=40,standardCountScale=1.5
    //夜班(昆医一院) 计算首次夜班的开始时间、结束时间  计算末次夜班的开始时间、结束时间
    s nightFirstShiftStartTime=$zth("0:00:00"),nightFirstShiftEndTime=$zth("7:59:59")
    s nightLastShiftStartTime=$zth("17:00:01"),nightLastShiftEndTime=$zth("23:59:59")
    
    s colCount=1,baseStartDate=0,baseEndDate=0
    s ret=##class(web.DHCANCInquiry).UpdateANCInquiryStatus(anciId,"S")
    k ^tmpAN("ANIquiry",anciId)
    k ^DHCANInquiry(anciId)
    s ^DHCANInquiry(anciId,"StartDate")=startDate
    s ^DHCANInquiry(anciId,"StartTime")=startTime
    s ^DHCANInquiry(anciId,"EndDate")=endDate
    s ^DHCANInquiry(anciId,"EndTime")=endTime
    s ^DHCANInquiry(anciId,"AppLoc")=ctlocIdStr
    s ^DHCANInquiry(anciId,"DateType")=dateType
    s ^DHCANInquiry(anciId,"opaCount")=0
    m ^DHCANInquiry(anciId,"AllPath")=treeList("AllPath")
    m ^DHCANInquiry(anciId,"SumType")=summaryTypeList("SumType")
    s ^DHCANInquiry(anciId,"FI","OpaInfo","0 ^",0)=""
    s displayOpaInfoList(0)="0 ^"
    s displaySortList("Sort","0",0)=""
    s operSumDate=""
    s timeLineSumList("Para","总计","0 ^")="总计"
    d InquiryOPArrange
    s timerAfterInquiry=$h
    s CalculateValueList("OpaCount")=totalOpaCount
    d SetInquiryResult
    s timerEnd=$h
    s timerDuration=$p(timerEnd,",",2)-$p(timerStt,",",2)
    s result="ok,StartTime"_timerStt_"  EndTime:"_timerEnd_"  Inquiry Duration:"_($p(timerAfterInquiry,",",2)-$p(timerStt,",",2))_"  Duration:"_timerDuration_"  ,count:"_count_" ,OpaCount:"_totalOpaCount
    s ^DHCANInquiry(anciId,"Debug")=result
    //s ^DHCANInquiry(anciId,"Process")="200^完成"
    q result
    
InquiryOPArrange
	i anciDataType'="S" d SetMutiPatResultIndex
    f date=startDate:1:endDate  d
    .k timeLineSumList,timeLineSumExistList
    .d InquirySingleDate(date)
    .d SetTimeLineData(date)
    s ^DHCANInquiry(+anciId,"opaCount")=totalOpaCount
    m ^DHCANInquiry=resultDataList
    q
    
InquirySingleDate(date)
	s sttDateQueryTime=$p($ZTIMESTAMP,",",2)
	i isDebug s ^DHCANInquiry(anciId,"Debug","CurrentDate")=$zd(date,3)
	//s ^DHCANInquiry(anciId,"Process")=$num((date-startDate+1)/(endDate-startDate+1),decimalDigits)_"^"_$zd(date,3)_"("_(date-startDate+1)_"/"_(endDate-startDate+1)_")"
	/*s i=0,dateQuerySttTime=$h //手工延迟
    while i<1
    {
	    s i=0
	    i ($p($h,",",2)-$p(dateQuerySttTime,",",2))>5 s i=5
    }*/
	s singleDateOpaCount=0
	s passOpaCount=0
	s totalPassOpaNeedTime=0
	s totalSetPatInfoTime=0
	s totalSetDisplayRowTime=0
	s totalMatchConditionTime=0
	i dateType="Adm" d InquiryAdmDate(date)
    e  i dateType="Discharge" d InquiryDischargeDate(date)
    e  d InquiryOperStartDate(date)
    s totalDateQueryTime=$p($ZTIMESTAMP,",",2)-sttDateQueryTime
    i isDebug s ^DHCANInquiry(anciId,"Debug","Date",date)=$zd(date,3)_"  设置病人信息用时:"_totalSetPatInfoTime_"  计算对应行用时:"_totalSetDisplayRowTime_"  匹配条件项目用时:"_totalMatchConditionTime_"  [日手术数:"_singleDateOpaCount_",通过条件手术数:"_passOpaCount_"]  [总用时:"_totalDateQueryTime_",通过条件手术总用时:"_totalPassOpaNeedTime_"]  [平均用时:"_$s(singleDateOpaCount>0:$num((totalDateQueryTime/singleDateOpaCount),6),1:0)_",通过条件手术平均用时:"_$s(passOpaCount>0:$num((totalPassOpaNeedTime/passOpaCount),6),1:0)_"]"
    q
    
InquiryAdmDate(date)
	s paadmId=""
	f  s paadmId=$o(^PAADMi("PAADM_AdmDate",date,paadmId)) q:paadmId=""  d
	.s opaId=""
	.f  s opaId=$o(^DHCANOPArrange(0,"Adm",paadmId,opaId)) q:opaId=""  d
	..d InquirySingleArrange(opaId)
	q
	
InquiryDischargeDate(date)
	s paadmId=""
	f  s paadmId=$o(^PAADMi("DischDate",date,paadmId)) q:paadmId=""  d
	.s opaId=""
	.f  s opaId=$o(^DHCANOPArrange(0,"Adm",paadmId,opaId)) q:opaId=""  d
	..d InquirySingleArrange(opaId)
	q
	
InquiryOperStartDate(date)
	s opaId=""
    f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
    .d InquirySingleArrange(opaId)
    q
    
SetInquiryResult
    i anciDataType="S" d SetSummaryResult2
    s resultCount=+$g(^DHCANInquiry(+anciId,"count"))
    s opaCount=+$g(^DHCANInquiry(+anciId,"opaCount"))
    s ret=##class(web.DHCANCInquiry).UpdateANCInquiryStatus(anciId,"F",opaCount,resultCount)
    q
    
SetMutiPatResultIndex
    s resultList=""
    k PLIST,codeIndexList
    s colCount=1
    s PLIST(colCount)="displayId"
    s codeIndexList("displayId")=colCount
    
    s anciiSub=""
    f  s anciiSub=$o(displayList(0,anciiSub)) q:anciiSub=""  d
    .s colCount=colCount+1
    .s PLIST(colCount)="D-"_anciiSub
    .s codeIndexList("D-"_anciiSub)=colCount
    
    f i=1:1:colCount  d
    .s resultList=resultList_$lb(PLIST(i))
    s ^DHCANInquiry(anciId)=resultList
    q
    
InquirySingleArrange(opaId)
	s singleDateOpaCount=singleDateOpaCount+1
	s singleOpaStartTime=$p($ZTIMESTAMP,",",2)
	s singleOpaOriginTime=singleOpaStartTime
	s totalQueryNode=0
	s singleOpaDebug=""
	s anciiSub=0
    q:'$$CheckPatientBaseInfo(opaId)
    d SetPatientBaseInfo(opaId)
    k oeoOrdList,oeoOrdStatList,anoDataList,opaInfoFlagList,colStatFlagList
    k currentOEOrderList,curOpaInfoList,flagIndexList,InOutSummaryList,itemQtyStatList
    k inquiryInfoList,operationList
    d SetFlagIndexList
    s opaCount=0,displayId=0,displayIdStr=""
    s singleOpaEndTime=$p($ZTIMESTAMP,",",2)
    s totalSetPatInfoTime=totalSetPatInfoTime+(singleOpaEndTime-singleOpaStartTime)
    s singleOpaDebug=singleOpaDebug_"设置病人基础数据用时:"_(singleOpaEndTime-singleOpaStartTime)
    s singleOpaStartTime=singleOpaEndTime
    i anciDataType="S" s displayIdStr=$$SetDisplayList(opaId)
    s singleOpaEndTime=$p($ZTIMESTAMP,",",2)
    s totalSetDisplayRowTime=totalSetDisplayRowTime+(singleOpaEndTime-singleOpaStartTime)
    s singleOpaDebug=singleOpaDebug_"   计算手术对应行用时:"_(singleOpaEndTime-singleOpaStartTime)
    s singleOpaStartTime=singleOpaEndTime
    i displayIdStr="" s displayIdStr="0"
    //e  s displayIdStr=displayIdStr_"^0"
    i ifHaveOriginNode d InquiryTree
    e  d InquiryLevel
    s totalOpaCount=totalOpaCount+opaCount
    s singleOpaEndTime=$p($ZTIMESTAMP,",",2)
    s totalMatchConditionTime=totalMatchConditionTime+(singleOpaEndTime-singleOpaStartTime)
    s singleOpaDebug=singleOpaDebug_"   匹配列条件总用时:"_(singleOpaEndTime-singleOpaStartTime)
    s singleOpaStartTime=singleOpaEndTime
    s singleOpaDuration=($p($ZTIMESTAMP,",",2)-singleOpaOriginTime)
    i isDebug s ^DHCANInquiry(anciId,"Debug","Date",date,"Opa",opaId)=singleOpaDebug_"  总用时:"_singleOpaDuration_"   查询节点数:"_totalQueryNode_"   平均单节点查询用时:"_$s(totalQueryNode>0:$num((singleOpaDuration/totalQueryNode),8),1:0)
    i isDebug m ^DHCANInquiry(anciId,"Debug","Date",date,"Opa",opaId,"PassPath")=treeList("PassPath")
    i $d(treeList("PassPath")) d
    .s passOpaCount=passOpaCount+1
    .s totalPassOpaNeedTime=totalPassOpaNeedTime+($p($ZTIMESTAMP,",",2)-singleOpaOriginTime)
    q

CheckPatientBaseInfo(opaId)
    s patWardId=$p($g(^DHCANOPArrange(opaId)),"^",32)
    q:(wardIdStr'="")&(("^"_wardIdStr_"^")'[("^"_(+patWardId)_"^")) 0
    s locId=""
    i locCheckType="AppLoc" s locId=$p($g(^DHCANOPArrange(opaId)),"^",54)
    e  i locCheckType="SurgonLoc" s locId=$p($g(^DHCANOPArrange(opaId)),"^",86)
    q:(ctlocIdStr'="")&&((","_ctlocIdStr_",")'[(","_(+locId)_",")) 0
    s EpisodeID=$p(^DHCANOPArrange(opaId),"^",1) //就诊号
    q:'+EpisodeID 0
    //s anaId=$p($g(^DHCANOPArrange(opaId)),"^",2)
    //s anaSub=$p(anaId,"||",2)
    //时间匹配范围,日期没有的话可能就匹配不到了
    //s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    //s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    //s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    //s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    
    
    //北京航空总院 按手术登记操作时间判断
    //s operRegTime=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.FirstRegUpdateTime")
    //s operRegDate=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.FirstRegUpdateDate")
    //s operRegTime=$p(operRegTime,$c(3),1)
    //s operRegDate=$p(operRegDate,$c(3),1)
    //s operRegTime=##class(web.DHCClinicCom).ConvertToTimeH(operRegTime)
    //s operRegDate=##class(web.DHCClinicCom).ConvertToDateH(operRegDate)
   	//s anopStartDate=operRegDate,anopEndDate=operRegDate
   	//s anopStartTime=operRegTime,anopEndTime=operRegTime
   	
    //q ((anopStartDate+(anopStartTime*0.00001))<=(endDate+(endTime*0.00001)))&&((anopEndDate+(anopEndTime*0.00001))>=(startDate+(startTime*0.00001))) //时间范围匹配
    
    q 1
    
SetPatientBaseInfo(opaId)
    s EpisodeID=$p(^DHCANOPArrange(opaId),"^",1) //就诊号
    s anaId=$p($g(^DHCANOPArrange(opaId)),"^",2)
    s anaSub=$p(anaId,"||",2)
    s OPDate=$p(^DHCANOPArrange(opaId),"^",14)
    s OPNurseShiftTimeStr=""
    //特殊 安徽省立获取护士交接班信息
    //s OPNurseShiftTimeStr=##class(web.UDHCANOPArrange).GetOperNurseDT(EpisodeID,$zd(OPDate,3))
    s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
    q
    
SetFlagIndexList()
    s flagIndexList("OPDoc","OPDoc")=""
    s flagIndexList("OPAss","AssI")=""
    s flagIndexList("OPAss","AssII")=""
    s flagIndexList("OPAss","AssIII")=""
    s flagIndexList("OPAss","AssIV")=""
    s flagIndexList("OPAss","AssV")=""
    s flagIndexList("OPAss","AssO")=""
    s flagIndexList("AssI","AssI")=""
    s flagIndexList("AssII","AssII")=""
    s flagIndexList("AssIII","AssIII")=""
    s flagIndexList("AssIV","AssIV")=""
    s flagIndexList("AssV","AssV")=""
    s flagIndexList("AssO","AssO")=""
    s flagIndexList("OPIntern","OPIntern")=""
    s flagIndexList("ANDoc","ANDoc")=""
    s flagIndexList("ANSuper","ANSuper")=""
    s flagIndexList("ANAss","ANAss")=""
    s flagIndexList("ANIntern","ANIntern")=""
    s flagIndexList("SCN","SCN")=""
    s flagIndexList("CIRN","CIRN")=""
    s flagIndexList("ShiftSCN","ShiftSCN")=""
    s flagIndexList("ShiftCIRN","ShiftCIRN")=""
    q
    
SetDisplayList(opaId)
    //统计查询时匹配非条件项目生成行索引
    s displayId="",anciiSub="",opaInfoStr="",displayIdStr=""
    k displayOpaInfo,lastSchLevelList,opaInfoList,reLastSchLevelList
    s searchLevel="" f  s searchLevel=$o(displayList(searchLevel)) q:searchLevel=""  d
    .s anciiSub="",displayCount=0,lastAnciiSub=0
    .k displayOpaInfo("Display")
    .f  s anciiSub=$o(displayList(searchLevel,anciiSub)) q:anciiSub=""  d
    ..s opaInfo=$$CheckInquiryItem(opaId,anciiSub,lastAnciiSub)
    ..s paraDesc=$g(^DHCANInquiry("QueryItem",anciiCode))
    ..s:paraDesc="" paraDesc=anciiDesc
    ..s paraOpaInfo=""
    ..s lastAnciiSub=anciiSub
    ..i +anciiIsSingle d
    ...k opaInfoList
    ...i opaInfo s opaInfoList(1)="^"
    ..q:'$d(opaInfoList)
    ..s infoCount=""
    ..f  s infoCount=$o(opaInfoList(infoCount)) q:infoCount=""  d
    ...s opaInfo=opaInfoList(infoCount)
    ...s opaInfoId=$p(opaInfo,"^",1)
    ...i +anciiIsSingle s opaInfoId=anciiDesc
    ...s sortCode=""
    ...i opaInfoId'="" d
    ....s sortCode=$g(^DHCANInquiry("Sort","ItemCode",anciiCode,opaInfoId))
    ...i (sortCode="")&&($p(opaInfo,"^",2)'="") d
    ....s sortCode=$g(^DHCANInquiry("Sort","ItemCode",anciiCode,$p(opaInfo,"^",2)))
    ...i '$d(^DHCANInquiry("Sort","ItemCode",anciiCode)) s sortCode="N"_$S($l(anciiSub)<2:"0",1:"")_anciiSub_opaInfoId
    ...i sortCode="" s sortCode="99999"
    ...s sortCode=sortCode
    ...i $d(lastSchLevelList) d
    ....s listId=""
    ....f  s listId=$o(lastSchLevelList(listId)) q:listId=""  d
    .....s displayCount=displayCount+1
    .....s displayOpaInfo("Display",searchLevel_"-"_displayCount)=lastSchLevelList(listId)_$c(3)_anciiSub_" "_opaInfo
    .....m displayOpaInfo("Display",searchLevel_"-"_displayCount,"Item")=lastSchLevelList(listId,"Item")
    .....s displayOpaInfo("Display",searchLevel_"-"_displayCount,"Item",searchLevel,anciiSub)=opaInfo
    .....s displayOpaInfo("Display",searchLevel_"-"_displayCount,"Para")=lastSchLevelList(listId,"Para")_":"_lastSchLevelList(listId,"ParaOpaInfo")_","_paraDesc
    .....s paraOpaInfo=$p(opaInfoList(infoCount),"^",2)
    .....i +anciiIsSingle s paraOpaInfo=anciiDesc
    .....s displayOpaInfo("Display",searchLevel_"-"_displayCount,"ParaOpaInfo")=paraOpaInfo
    .....m displayOpaInfo("Display",searchLevel_"-"_displayCount,"Flag")=lastSchLevelList(listId,"Flag")
    .....m displayOpaInfo("Display",searchLevel_"-"_displayCount,"Flag")=opaInfoList(infoCount,"Flag")
    .....s displayOpaInfo("Display",searchLevel_"-"_displayCount,"Sort")=$g(lastSchLevelList(listId,"Sort"))_"_"_sortCode
    .....s lastSchLevelList(listId,"CalculateRow",searchLevel_"-"_displayCount)=""
    ...e  d
    ....s displayCount=displayCount+1
    ....s displayOpaInfo("Display",searchLevel_"-"_displayCount)=anciiSub_" "_opaInfo
    ....s displayOpaInfo("Display",searchLevel_"-"_displayCount,"Item",searchLevel,anciiSub)=opaInfo
    ....m displayOpaInfo("Display",searchLevel_"-"_displayCount,"Flag")=opaInfoList(infoCount,"Flag")
    ....s displayOpaInfo("Display",searchLevel_"-"_displayCount,"Para")=paraDesc
    ....s paraOpaInfo=$p(opaInfoList(infoCount),"^",2)
    ....i +anciiIsSingle s paraOpaInfo=anciiDesc
    ....s displayOpaInfo("Display",searchLevel_"-"_displayCount,"ParaOpaInfo")=paraOpaInfo
    ....s displayOpaInfo("Display",searchLevel_"-"_displayCount,"Sort")=sortCode
    .//记录每一级显示层汇总项
    .i $d(lastSchLevelList) d
    ..s listId=""
    ..f  s listId=$o(lastSchLevelList(listId)) q:listId=""  d
    ...m reLastSchLevelList(listId)=lastSchLevelList(listId)
    ...s reLastSchLevelList(listId,"IsCalculateRow")=1
    .
    .k lastSchLevelList
    .m lastSchLevelList=displayOpaInfo("Display")
    m displayOpaInfo("Display")=reLastSchLevelList
    
    s displayCount=0
    f  s displayCount=$o(displayOpaInfo("Display",displayCount)) q:displayCount=""  d
    .s opaInfoStr=displayOpaInfo("Display",displayCount)
    .s displayId=$o(^DHCANInquiry(anciId,"FI","OpaInfo",opaInfoStr,0))
    .i +displayId=0 d
    ..i '$d(^DHCANInquiry(anciId,"FI","Display")) s displayId=1
    ..e  s displayId=+$o(^DHCANInquiry(anciId,"FI","Display",""),-1)+1
    ..s ^DHCANInquiry(anciId,"FI","OpaInfo",opaInfoStr,displayId)=""
    ..m ^DHCANInquiry(anciId,"FI","Display",displayId,"Item")=displayOpaInfo("Display",displayCount,"Item")
    ..s searchLevel="" f  s searchLevel=$o(displayOpaInfo("Display",displayCount,"Item",searchLevel)) q:searchLevel=""  d
    ...s anciiSub="" f  s anciiSub=$o(displayOpaInfo("Display",displayCount,"Item",searchLevel,anciiSub)) q:anciiSub=""  d
    ....s ^DHCANInquiry(anciId,"FI","Item",searchLevel,anciiSub,displayOpaInfo("Display",displayCount,"Item",searchLevel,anciiSub),displayId)=""
    .s displayOpaInfo("Display",displayCount,"DisplayId")=displayId
    .k opaInfoFlagList(displayId)
    .m opaInfoFlagList(displayId)=displayOpaInfo("Display",displayCount,"Flag")
    .s displaySortList("Sort",displayOpaInfo("Display",displayCount,"Sort")_"_"_opaInfoStr,displayId)=""
    .i displayOpaInfo("Display",displayCount,"ParaOpaInfo")="" s timeLineSumList("Para",displayOpaInfo("Display",displayCount,"Para"),opaInfoStr)="无"
    .e  s timeLineSumList("Para",displayOpaInfo("Display",displayCount,"Para"),opaInfoStr)=displayOpaInfo("Display",displayCount,"ParaOpaInfo")
    .s displayOpaInfoList(displayId)=opaInfoStr
    .q:("^"_displayIdStr_"^")[("^"_displayId_"^") //当信息重复时不加入
    .q:$g(displayOpaInfo("Display",displayCount,"IsCalculateRow"))  //计算值行
    .i displayIdStr'="" s displayIdStr=displayIdStr_"^"
    .s displayIdStr=displayIdStr_displayId
    
    s displayCount=0
    f  s displayCount=$o(displayOpaInfo("Display",displayCount)) q:displayCount=""  d
    .i $g(displayOpaInfo("Display",displayCount,"IsCalculateRow")) d
    ..s searchLevel=$p(displayCount,"-",1)
    ..s sumRowDisplayId=displayOpaInfo("Display",displayCount,"DisplayId")
    ..s CalculateRowList("Level",searchLevel,sumRowDisplayId)=""
    ..s rowDisplayCount=""
    ..f  s rowDisplayCount=$o(displayOpaInfo("Display",displayCount,"CalculateRow",rowDisplayCount)) q:rowDisplayCount=""  d
    ...s CalculateRowList("Level",searchLevel,sumRowDisplayId,"Row",displayOpaInfo("Display",rowDisplayCount,"DisplayId"))=""
    
    //b //in get display Id
    q displayIdStr
    
SetTimeLineData(date)
    //时间序列数据存储删除为0数据项目
    s opaInfoStr=""
    f  s opaInfoStr=$o(timeLineSumList("Data",date,opaInfoStr)) q:opaInfoStr=""  d
    .//当此项目无对应数据时删除,主要用于多医院共用库时不保存其他医院的相关数据(为0)
    .i '+$g(timeLineSumExistList(date,opaInfoStr)) k timeLineSumList("Data",date,opaInfoStr)
    s timeLinePara=""
    f  s timeLinePara=$o(timeLineSumList("Para",timeLinePara)) q:timeLinePara=""  d
    .s opaInfoStr=""
    .f  s opaInfoStr=$o(timeLineSumList("Para",timeLinePara,opaInfoStr)) q:opaInfoStr=""  d
    ..//当此项目无对应数据时删除,主要用于多医院共用库时不保存其他医院的相关数据(为0)
    ..i '+$g(timeLineSumExistList(date,opaInfoStr)) k timeLineSumList("Para",timeLinePara,opaInfoStr)
    i ifStartStoreTimeLine m ^DHCANInquiry("TimeLine",anciId)=timeLineSumList
    q
    
    //------------------------------------------以下是按关联关系处理
InquiryTree()
    s treeAnciiSub=""
    s totalQueryNode=0
    //b //start recursion
    k treeList("PassPath")
    s searchOpaInfo="",ifQuit=0
    f  s treeAnciiSub=$o(treeList("OriginNode",treeAnciiSub)) q:treeAnciiSub=""  d
    .q:'$$CheckInquiryItem(opaId,treeAnciiSub,0)
    .s searchOpaInfo=""
    .s totalQueryNode=totalQueryNode+1
    .//递归遍历所有节点，如果不满足条件，线路的递归将中止，最终结果存入 treeList("PassPath",parentNode)
    .d InquiryRelateTreeNode(treeAnciiSub,0,"",1,searchOpaInfo)
    .//b //end recursion
    q
    
InquiryRelateTreeNode(parentNode,recursionLevel,recursionPath,ifQueryItem,searchOpaInfo)
    s childNode="",ifChildQuit=0
    i recursionPath="" s recursionPath=parentNode
    e  s recursionPath=recursionPath_"->"_parentNode
    i ifQueryItem s searchOpaInfo=searchOpaInfo_anciiDesc_":"_($$GetOpaInfoStr(parentNode))_$c(13)
    //当不存在子节点时,或者根节点需要展示,将此路径记录至结果序列
    i (+$o(treeList(parentNode,"ChildNode",childNode))=0) || ((treeList("NodeDisplay",parentNode)) && (anciDataType="S")) d
    .s treeList("PassPath",parentNode)=recursionPath
    .i (+$o(treeList(parentNode,"ChildNode",childNode))=0) s ifChildQuit=1
    .i ifQueryItem d
    ..s opaCount=1
    ..s searchLevel=+treeList("SearchLevel",parentNode)
    ..d UpdateResultItem(searchOpaInfo)
    .//b //find a passive path
    .//w "in result ",opaId," ",parentNode,"  ",recursionLevel,"  ",recursionPath,!
    q:ifChildQuit
    s recursionLevel=+recursionLevel
    //w parentNode,"  ",recursionLevel,"  ",recursionPath,!
    //b //in recursion
    //将不同递归层级的数据存储在list,避免在递归中改变了参数值导致死循环
    s recursionRecorder(recursionLevel,"parentNode")=parentNode
    s recursionRecorder(recursionLevel,"path")=recursionPath
    s recursionRecorder(recursionLevel,"searchOpaInfo")=searchOpaInfo
    f  s childNode=$o(treeList(parentNode,"ChildNode",childNode)) q:childNode=""  d
    .s recursionRecorder(recursionLevel,"childNode")=childNode
    .s recursionPath=recursionRecorder(recursionLevel,"path")
    .s searchOpaInfo=recursionRecorder(recursionLevel,"searchOpaInfo")
    .s ifChildQuit=0
    .i ifQueryItem d
    ..s ifChildQuit='$$CheckInquiryItem(opaId,childNode,parentNode)
    ..s totalQueryNode=totalQueryNode+1
    .//w "in loop ",opaId," parent:",parentNode,"  level:",recursionLevel,"  path:",recursionPath,"  quit:",ifChildQuit,!
    .i 'ifChildQuit d
    ..d InquiryRelateTreeNode(childNode,recursionLevel+1,recursionPath,ifQueryItem,searchOpaInfo)
    ..//s recursionLevel=recursionLevel-1
    .s childNode=recursionRecorder(recursionLevel,"childNode")
    .s parentNode=recursionRecorder(recursionLevel,"parentNode")
    q
    
    //------------------------------------------以下是按筛选层关系处理
InquiryLevel()
    s searchPrecondition=1
    s searchLevel=0
    //设置筛选层值为0的为前提条件项,即与所有查询条件的逻辑关系为与关系,比如设置查询的手术状态==
    i $d(searchList(searchLevel)) d
    .s anciiSubSeq=0,lastAnciiSub=0
    .f  s anciiSubSeq=$o(searchList(searchLevel,anciiSubSeq)) q:anciiSubSeq=""  d
    ..s anciiSub=searchList(searchLevel,anciiSubSeq)
    ..q:'searchPrecondition  //当有一条前提条件不满足即退出遍历查询条件
    ..s searchPrecondition=$$CheckInquiryItem(opaId,anciiSub,lastAnciiSub)
    ..s lastAnciiSub=anciiSub
    q:'searchPrecondition  //当前提条件不满足时退出遍历搜索
    f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    .s ifQuit=0,anciiSub=0,searchOpaInfo="",anciiSubSeq=0,lastAnciiSub=0
    .k currentOEOrderList
    .f  s anciiSubSeq=$o(searchList(searchLevel,anciiSubSeq)) q:anciiSubSeq=""  d
    ..s anciiSub=searchList(searchLevel,anciiSubSeq)
    ..q:ifQuit  //当有一条查询条件不满足即退出遍历查询条件
    ..s ifQuit=ifQuit!('$$CheckInquiryItem(opaId,anciiSub,lastAnciiSub))
    ..i 'ifQuit s searchOpaInfo=searchOpaInfo_anciiDesc_":"_($$GetOpaInfoStr(anciiSub))_$c(13)
    ..s lastAnciiSub=anciiSub
    .q:ifQuit
    .s opaCount=1
    .d UpdateResultItem(searchOpaInfo)
    q

CheckInquiryItem(opaId,anciiSub,lastAnciiSub)
    s ifFind=0
    k opaInfoList
    d SetAnciiInfo(anciiSub)
    i anciiRelateAnciiSub>0 s lastAnciiSub=anciiRelateAnciiSub
    s ifFind=$$JudgeOpaInfo(opaId)
    q ifFind
    
GetOpaInfoStr(anciiSub)
    i '$d(curOpaInfoList(anciiSub)) q ""
    s infoCount="",opaInfo="",ifOverLength=0
    f  s infoCount=$o(curOpaInfoList(anciiSub,infoCount)) q:((infoCount="")||ifOverLength)  d
    .i ($l(opaInfo)+$l($p(curOpaInfoList(anciiSub,infoCount),"^",2)))>stringLengthLimit d
    ..m ^DHCANInquiry(anciId,"OpaInfo",opaId,anciiSub)=curOpaInfoList(anciiSub)
    ..s ifOverLength=1
    ..s opaInfo=opaInfo_"<a id='a_"_anciId_"_"_searchLevel_"_"_anciiSub_"_"_opaId_"' href='javascript:void(0)' onclick='ShowOpaInfo("_anciId_","_searchLevel_","_anciiSub_","_opaId_")' title='更多'>...</a>"
    .e  d
    ..i opaInfo'="" s opaInfo=opaInfo_$c(13)
    ..s opaInfo=opaInfo_$p(curOpaInfoList(anciiSub,infoCount),"^",2)
    q opaInfo
    
UpdateResultItem(searchOpaInfo)
    s ^DHCANInquiry(anciId,"FI","SearchOpaInfo",searchLevel,opaId)=searchOpaInfo
    //s resultDataList(anciId,"FI","SearchOpaInfo",searchLevel,opaId)=searchOpaInfo
    f disSeq=1:1:$l(displayIdStr,"^") d
    .s displayId=+$p(displayIdStr,"^",disSeq)
    .s opaSeq=+$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,""),-1)
    .//s opaSeq=+$o(resultDataList(anciId,"FI","Display",displayId,"Level",searchLevel,""),-1)
    .s opaSeq=opaSeq+1
    .s opaSeqInfo=$lb(opaId)
    .//直接完成查询病人信息结果
    .i anciDataType'="S" d SetMutiPatResult
    .q:'$$MatchCellFlag(displayId,searchLevel)
    .//计算总统计数据
    .s summaryType=""
    .f  s summaryType=$o(summaryTypeList(searchLevel,summaryType)) q:summaryType=""  d
    ..s summaryInfo=$$GetStatInfo(opaId,searchLevel,summaryType,displayId)
    ..s opaSeqInfo=opaSeqInfo_$lb(summaryType_"^"_summaryInfo)
    ..s summaryUom=$p(summaryInfo,"^",2)
    ..i summaryUom="" s summaryUom="-"
    ..s ^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",summaryUom)=$g(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",summaryUom))+summaryInfo
    ..//s resultDataList(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",summaryUom)=$g(resultDataList(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",summaryUom))+summaryInfo
    ..s timeLineSumList("Data",date,displayOpaInfoList(displayId),searchLevel,"SumType",summaryType,"Uom",summaryUom)=$g(timeLineSumList("Data",date,displayOpaInfoList(displayId),searchLevel,"SumType",summaryType,"Uom",summaryUom))+summaryInfo
    ..i +summaryInfo s timeLineSumExistList(date,displayOpaInfoList(displayId))=1
    .s ^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,opaSeq)=opaSeqInfo
    .//s resultDataList(anciId,"FI","Display",displayId,"Level",searchLevel,opaSeq)=opaSeqInfo
    k colStatFlagList //递归中无法明确获取Level标识,这里用完之后就销毁,避免下一个Level统计Flag变多
    q

SetMutiPatResult
    //当结果中存在此手术对应结果,不生成
    q:+$o(^DHCANInquiry(anciId,"FI","OpaId",opaId,""))>0
    k PLIST
    s count = +$g(^DHCANInquiry(anciId,"count"))
    s count = count+1
    s lastAnciiSub=0
    s anciiSub=0
    f  s anciiSub=$o(displayList(0,anciiSub)) q:anciiSub=""  d
    .s resultValue=""
    .//b //before set display item
    .i '$d(curOpaInfoList(anciiSub)) s ifFind=$$CheckInquiryItem(opaId,anciiSub,lastAnciiSub)
    .//b //after set display item
    .//s lastAnciiSub=anciiSub
    .s resultValue=$$GetOpaInfoStr(anciiSub)
    .i $lg(^DHCANCInquiry(anciId,"I",anciiSub),1)="PatName" s resultValue="<a target='view_window' href='dhcanrecord.csp?opaId="_opaId_"&documentType=AN' title='打开麻醉监护'>"_resultValue_"</a>"
    .s PLIST(codeIndexList("D-"_anciiSub))=resultValue
    .s PLIST("Level",anciiSub)=+resultValue
    //数据行计算有表达式的显示列项目
    //start calculate expression------------
    s anciiSub=""
    f  s anciiSub=$o(summaryTypeList("CalculateExpression",anciiSub)) q:anciiSub=""  d
    .k expArgList
    .m expArgList=PLIST("Level")
    .m expArgList=CalculateValueList
    .s anciiDataField=$lg(^DHCANCInquiry(anciId,"I",anciiSub),6)
    .s singleSumUom=""
    .s singleCount=..CalculateExpression(summaryTypeList("CalculateExpression",anciiSub),.expArgList)
    .i anciiDataField="Percentage" s singleCount=singleCount*100,singleSumUom="%"
    .e  i anciiDataField="Permillage" s singleCount=singleCount*1000,singleSumUom="‰"
    .s PLIST(+codeIndexList("D-"_anciiSub))=singleCount_singleSumUom
    //end calculate expression-------------
    s PLIST(codeIndexList("displayId"))=opaId
    s resultList=""
    f i=1:1:colCount  d
    .s resultList=resultList_$lb(PLIST(i))
    s ^DHCANInquiry(anciId,"Result",count)=resultList
    s ^DHCANInquiry(anciId,"FI","OpaId",opaId,count)=""
    s ^DHCANInquiry(anciId,"count")=count
    q
    
MatchCellFlag(displayId,searchLevel)
    s ifExistColFlag=($o(colStatFlagList(searchLevel,""))'="")
    s ifExistDisplayFlag=($o(opaInfoFlagList(displayId,""))'="")
    s ifMatchCellFlag=1
    i (ifExistColFlag)&&(ifExistDisplayFlag) d
    .s ifMatchCellFlag=0
    .s displayFlag=""
    .f  s displayFlag=$o(colStatFlagList(searchLevel,displayFlag)) q:displayFlag=""  d
    ..s displaySubFlag=""
    ..f  s displaySubFlag=$o(flagIndexList(displayFlag,displaySubFlag)) q:displaySubFlag=""  d
    ...i $d(opaInfoFlagList(displayId,displaySubFlag)) s ifMatchCellFlag=1
    q ifMatchCellFlag
    
GetStatInfo(opaId,searchLevel,summaryType,displayId)
    k statInfoList
    s statInfo=0
    s statUom=""
    i summaryType="OPACount" d   //手术病人例数
    .s statInfo=1
    .s statInfoList=1
    i summaryType="AdmCount"  d   //就诊例数
    .s statInfo=1
    .i $$CheckRepeatOperOnceAdm() s statInfo=0
    .s statInfoList=statInfo
    e  i (summaryType="TheatreInOutTime")||(summaryType="ZAverageTIOTime") d  //入离室时间间隔
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    .//d SetAHSLOperDT //特殊 安徽省立
    .s statInfo=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime)
    .s statInfoList=statInfo
    .s statUom=timeUom
    .d SetANShiftStatDT
    e  i (summaryType="OPStartEndTime")||(summaryType="ZAverageOPSETime") d  //手术开始结束时间间隔
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",19)   //手术开始时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",20)   //手术结束时间
    .i ifOldAN d SetOldANOPStartEndDT("OperStart","OperEnd")
    .i anopStartTime="" d
    ..s anopStartDate=$p(^DHCANOPArrange(opaId),"^",14)   //术后登记手术开始日期
    ..s anopStartTime=$p(^DHCANOPArrange(opaId),"^",15)   //术后登记手术开始时间
    .i anopEndTime="" d
    ..s anopEndDate=$p(^DHCANOPArrange(opaId),"^",16)   //术后登记手术结束日期
    ..s anopEndTime=$p(^DHCANOPArrange(opaId),"^",17)   //术后登记手术结束时间
    .s statInfo=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime)
    .s statInfoList=statInfo
    .s statUom=timeUom
    .d SetANShiftStatDT
    e  i (summaryType="ANAStartEndTime")||(summaryType="ZAverageANASETime") d  //麻醉开始结束时间间隔
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)   //麻醉开始日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",3)   //麻醉开始时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",29)   //麻醉结束日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",4)   //麻醉结束时间
    .i ifOldAN d SetOldANOPStartEndDT("AnaStart","AnaEnd")
    .i 'anopEndDate s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .i 'anopEndTime s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    .s statInfo=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime)
    .s statInfoList=statInfo
    .s statUom=timeUom
    .d SetANShiftStatDT
    e  i (summaryType="PACUInOutTime")||(summaryType="ZAveragePACUIOTime") d  //PACU时间间隔
    .s anopStartDate=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",6)   //入PACU日期
    .s anopStartTime=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",7)   //入PACU时间
    .s anopEndDate=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",8)   //出PACU日期
    .s anopEndTime=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",9)   //入PACU时间
    .s statInfo=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime)
    .s statInfoList=statInfo
    .s statUom=timeUom
    .d SetANShiftStatDT
    e  i (summaryType="ANAPrepareTime")||(summaryType="ZAverageANAPTime") d  //术前麻醉准备时间
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)   //麻醉开始日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",3)   //麻醉开始时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",19)   //手术开始时间
    .i ifOldAN d SetOldANOPStartEndDT("AnaStart","OperStart")
    .s statInfo=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime)
    .s statInfoList=statInfo
    .s statUom=timeUom
    e  i (summaryType="BeforeANPrepareTime")||(summaryType="ZAverageBANPTime") d  //麻醉前准备时间
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)   //麻醉开始日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",3)   //麻醉开始时间
    .i ifOldAN d SetOldANOPStartEndDT("","AnaStart")
    .s statInfo=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime)
    .s statInfoList=statInfo
    .s statUom=timeUom
    e  i (summaryType="BeforeOPPrepareTime")||(summaryType="ZAverageBOPPTime") d  //术前准备时间
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",19)   //手术开始时间
    .i ifOldAN d SetOldANOPStartEndDT("","OperStart")
    .s statInfo=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime)
    .s statInfoList=statInfo
    .s statUom=timeUom
    e  i summaryType="OPDate" d
    .s statInfo=1
    .i $d(opDateStatList(displayId,searchLevel,date)) s statInfo=0
    .s opDateStatList(displayId,searchLevel,date)=""
    .s statInfoList=statInfo
    e  i summaryType="OPStandardCount" d
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    .s statInfo=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime)
    .s statInfo=statInfo/standardCountScale
    .s statInfo=$p(statInfo,".",1)
    .s statInfoList=statInfo
    .s statUom="台"
    e  i summaryType="NightShiftCount" d
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    .s statInfo=0
    .s statInfo=statInfo+$$GetNightShiftMatch(anopStartDate,nightFirstShiftStartTime,anopStartDate,nightFirstShiftEndTime)
    .s statInfo=statInfo+$$GetNightShiftMatch(anopEndDate,nightFirstShiftStartTime,anopEndDate,nightFirstShiftEndTime)
    .s statInfo=statInfo+$$GetNightShiftMatch(anopStartDate,nightLastShiftStartTime,anopStartDate,nightLastShiftEndTime)
    .s statInfo=statInfo+$$GetNightShiftMatch(anopEndDate,nightLastShiftStartTime,anopEndDate,nightLastShiftEndTime)
    .s statInfoList=statInfo
    .s statUom="个"
    e  i summaryType="EmergencySpan" d
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    .s statInfo=0
    .i (anopStartTime>64800)||(anopStartTime<28800) s statInfo=2  //大于18点或小于8点，按每台2小时计算
    .e  d //8点到18点，按人数平分工作时间
    ..s totalSpan=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime)
    ..s scNurseCount=0,cirNurseCount=0
    ..s nurSub=0
    ..f  s nurSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub)) q:((nurSub="")||(nurSub>20))  d
    ...s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub),"^",1)
    ...i opaInfoId'="" s scNurseCount=scNurseCount+1
    ..s nurSub=0
    ..f  s nurSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub)) q:((nurSub="")||(nurSub>20))  d
    ...s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub),"^",1)
    ...i opaInfoId'="" s cirNurseCount=cirNurseCount+1
    ..i (scNurseCount>0)&&(cirNurseCount>0) s totalSpan=totalSpan*2
    ..i (scNurseCount>0)||(cirNurseCount>0) s statInfo=totalSpan/(scNurseCount+cirNurseCount)
    .s statUom="h"
    e  i summaryType="ItemQty"  d
    .s statUom=""
    .s statInfo=$$GetItemQtyStatInfo()
    .s statInfoList=statInfo
    e  i summaryType="OEOrdBill" d
    .s statUom="元"
    .s statInfo=$$GetOEOrderStatInfo("Bill","")
    .s statInfoList=statInfo
    e  i summaryType="OEOrdQty" d
    .s statUom=""
    .s statInfo=$$GetOEOrderStatInfo("Qty","BaseUom")
    .s statInfoList=statInfo
    e  i summaryType="OrderQty" d
    .i $d(anoDataList(opaId,searchLevel,"ML")) s statInfo=anoDataList(opaId,searchLevel,"ML"),statUom="ml"
    .e  i $d(anoDataList(opaId,searchLevel,"MG")) s statInfo=anoDataList(opaId,searchLevel,"MG"),statUom="mg"
    .e  i $d(anoDataList(opaId,searchLevel,"U")) s statInfo=anoDataList(opaId,searchLevel,"U"),statUom="u"
    .e  i $d(anoDataList(opaId,searchLevel,"-")) s statInfo=anoDataList(opaId,searchLevel,"-"),statUom=""
    .s statInfoList=statInfo
    .//分为3种单位总计 ml,mg,u
    .//统计单位主要包括L、ml、g、mg、ug、ku、u，别的单位暂时不考虑
    .//统计常用医嘱数量时不添加对应字段
    .//这里不考虑多种药物分别统计的情况，情况太复杂，取第二种药物的总计的话，请另设置项目
    
    //i displayId=1 b //3
    //i (displayId=1)&&(searchLevel=4) b //3
    //获取统计标志,用于区别同一手术不同行的不同统计值
    s ifExistColFlag=($o(colStatFlagList(searchLevel,""))'="")
    s ifExistDisplayFlag=($o(opaInfoFlagList(displayId,""))'="")
    i ifExistColFlag d
    .s statInfo=0
    .s displayFlag=""
    .f  s displayFlag=$o(colStatFlagList(searchLevel,displayFlag)) q:displayFlag=""  d
    ..s displaySubFlag=""
    ..f  s displaySubFlag=$o(flagIndexList(displayFlag,displaySubFlag)) q:displaySubFlag=""  d
    ...q:(ifExistDisplayFlag)&&('$d(opaInfoFlagList(displayId,displaySubFlag)))
    ...i $d(statInfoList(displaySubFlag)) s statInfo=statInfo+$g(statInfoList(displaySubFlag))
    ...e  s statInfo=statInfo+$g(statInfoList)
    e  i ifExistDisplayFlag d
    .s statInfo=0
    .s displayFlag=""
    .f  s displayFlag=$o(opaInfoFlagList(displayId,displayFlag)) q:displayFlag=""  d
    ..i $d(statInfoList(displayFlag)) s statInfo=statInfo+$g(statInfoList(displayFlag))
    ..e  s statInfo=statInfo+$g(statInfoList)
    
    s statInfo=$num(statInfo,decimalDigits)
    //i (displayId=1)&&(searchLevel=4) b  //in GetStatInfo
    q statInfo_"^"_statUom
    
CheckRepeatOperOnceAdm()
	s cellInd=0,ifRepeat=0
	f  s cellInd=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,cellInd)) q:(cellInd="")||(ifRepeat)  d
	.s cellOpaId=$lg(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,cellInd),1)
	.s cellEpisodeID=$p(^DHCANOPArrange(cellOpaId),"^",1)
	.i EpisodeID=cellEpisodeID s ifRepeat=1
	q ifRepeat
    
GetNightShiftMatch(anciiStartDate,anciiStartTime,anciiEndDate,anciiEndTime)
    s nightshift=0
    i ($$MatchDateTimeInterval()) d
    .i '$d(NightShiftList(displayId,searchLevel,anciiStartDate,anciiStartTime,anciiEndDate,anciiEndTime)) s nightshift=1
    .s NightShiftList(displayId,searchLevel,anciiStartDate,anciiStartTime,anciiEndDate,anciiEndTime)=""
    q nightshift
    
SetOldANOPStartEndDT(startEvent,endEvent)
    i startEvent'="" d
    .s anopStartDateTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,startEvent,-1,"Y","","")
    .s anopStartDate=##class(web.DHCANOPCom).ConvertToDateH($p(anopStartDateTime," ",1))
    .s anopStartTime=##class(web.DHCANOPCom).ConvertToTimeH($p(anopStartDateTime," ",2))
    i endEvent'="" d
    .s anopEndDateTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,endEvent,-1,"Y","","")
    .s anopEndDate=##class(web.DHCANOPCom).ConvertToDateH($p(anopEndDateTime," ",1))
    .s anopEndTime=##class(web.DHCANOPCom).ConvertToTimeH($p(anopEndDateTime," ",2))
    q

SetAHSLOperDT()
    //特殊 安徽省立
    s anopStartDate=OPDate   //入室日期
    s anopStartTime=$p(OPNurseShiftTimeStr,"^",1)   //入室时间
    i anopStartTime'="" s anopStartTime=$zth(anopStartTime,2)
    e  s anopStartTime=+$p(^DHCANOPArrange(opaId),"^",15)
    s anopEndDate=$p(OPNurseShiftTimeStr,"^",2)   //出室日期
    i anopEndDate'="" s anopEndDate=$zdh(anopEndDate,3)
    s anopEndTime=$p(OPNurseShiftTimeStr,"^",3)   //出室时间
    i anopEndTime'="" s anopEndTime=$zth(anopEndTime,2)
    q
    
CaculateDateTimeStatInfo(statStartDate,statStartTime,statEndDate,statEndTime,specialTimeScale = 0)
    s DateTimeStatInfo=(statEndDate-statStartDate)*24*3600+statEndTime-statStartTime
    i DateTimeStatInfo<0 s DateTimeStatInfo=0
    i specialTimeScale>0 s DateTimeStatInfo=DateTimeStatInfo/specialTimeScale
    e  s DateTimeStatInfo=DateTimeStatInfo/timeScale
    q DateTimeStatInfo
    
SetANShiftStatDT()
    s ANSCareProvType="",lastShiftStartDate=anopStartDate,lastShiftStartTime=anopStartTime
    f  s ANSCareProvType=$o(ANShiftList(opaId,ANSCareProvType)) q:ANSCareProvType=""  d
    .s ANSCareProvSeqNo=0
    .f  s ANSCareProvSeqNo=$o(ANShiftList(opaId,ANSCareProvType,"Seq",ANSCareProvSeqNo)) q:ANSCareProvSeqNo=""  d
    ..s ANSDate=$p(ANShiftList(opaId,ANSCareProvType,"Seq",ANSCareProvSeqNo),"^",6)
    ..s ANSTime=$p(ANShiftList(opaId,ANSCareProvType,"Seq",ANSCareProvSeqNo),"^",7)
    ..s Flag="ANS_"_ANSCareProvType_"_"_ANSCareProvSeqNo
    ..s statInfoList(Flag)=$$CaculateDateTimeStatInfo(lastShiftStartDate,lastShiftStartTime,ANSDate,ANSTime)
    ..s lastShiftStartDate=ANSDate
    ..s lastShiftStartTime=ANSTime
    .s ANSCareProvSeqNo=$o(ANShiftList(opaId,ANSCareProvType,"Seq",""),-1)
    .s Flag="ANS_"_ANSCareProvType_"_"_(ANSCareProvSeqNo+1)
    .s statInfoList(Flag)=$$CaculateDateTimeStatInfo(lastShiftStartDate,lastShiftStartTime,anopEndDate,anopEndTime)
    q
    
GetOEOrderStatInfo(statDataField,statUomField)
    s statLevel="",itemStatInfo=0,ifHaveOrderSub=0
    f  s statLevel=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",statLevel)) q:statLevel=""  d
    .s statAnciiSub=0
    .f  s statAnciiSub=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",statLevel,statAnciiSub)) q:statAnciiSub=""  d
    ..s anciiType=$lg(^DHCANCInquiry(anciId,"I",statAnciiSub),3)
    ..q:anciiType'="O"
    ..s anciiCode=$lg(^DHCANCInquiry(anciId,"I",statAnciiSub),1)
    ..i $d(oeoOrdStatList(anciiCode)) s ifHaveOrderSub=1
    ..q:'$d(oeoOrdStatList(anciiCode))
    ..s opaInfo=^DHCANInquiry(anciId,"FI","Display",displayId,"Item",statLevel,statAnciiSub)
    ..s opaInfoId=$p(opaInfo,"^",1)
    ..i opaInfoId'="" d
    ...s itemStatInfo=itemStatInfo+$g(oeoOrdStatList(anciiCode,opaInfoId,statDataField))
    ...i statUomField'="" s statUom=$p($g(oeoOrdStatList(anciiCode,opaInfoId,statUomField)),"^",2)
    
    i 'ifHaveOrderSub s itemStatInfo=+$g(oeoOrdStatList("Total",statDataField))
    
    q itemStatInfo
    
GetItemQtyStatInfo()
    s statLevel="",itemStatInfo=0,ifHaveOrderSub=0
    f  s statLevel=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",statLevel)) q:statLevel=""  d
    .s statAnciiSub=0
    .f  s statAnciiSub=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",statLevel,statAnciiSub)) q:statAnciiSub=""  d
    ..s anciiCode=$lg(^DHCANCInquiry(anciId,"I",statAnciiSub),1)
    ..i $d(itemQtyStatList(anciiCode)) s ifHaveOrderSub=1
    ..q:'$d(itemQtyStatList(anciiCode))
    ..s opaInfo=^DHCANInquiry(anciId,"FI","Display",displayId,"Item",statLevel,statAnciiSub)
    ..s opaInfoId=$p(opaInfo,"^",1)
    ..i opaInfoId'="" d
    ...s itemStatInfo=itemStatInfo+$g(itemQtyStatList(anciiCode,opaInfoId))
    ...s statUom=$p($g(itemQtyStatList(anciiCode,opaInfoId)),"^",2)
    
    i 'ifHaveOrderSub s itemStatInfo=+$g(itemQtyStatList(searchLevel)),statUom=$p($g(itemQtyStatList(searchLevel)),"^",2)
    
    q itemStatInfo
    
	//获取两段时间相交的部分
GetCoincidedSpan(d1,t1,d2,t2,d3,t3,d4,t4) //d2t2>d1t1,d4t4>d3t3
	s span=0
	s hasSpan=((d2+(t2*0.00001))>(d3+(t3*0.00001)))&&((d4+(t4*0.00001))>(d1+(t1*0.00001)))
	i hasSpan d
	.s spanStartDate=d1,spanStartTime=t1,spanEndDate=d2,spanEndTime=t2
	.i (d1+(t1*0.00001))>(d3+(t3*0.00001)) s spanStartDate=d1,spanStartTime=t1
	.e  s spanStartDate=d3,spanStartTime=t3
	.i (d4+(t4*0.00001))>(d2+(t2*0.00001)) s spanEndDate=d2,spanEndTime=t2
	.e  s spanEndDate=d2,spanEndTime=t2
	.s span=$$CaculateDateTimeStatInfo(spanStartDate,spanStartTime,spanEndDate,spanEndTime)
	
	q span
SetSummaryResult
    //将最后结果生成List,储存在后台,不用字符串的方式,避免出现字符串超长的情况
    s resultList=""
    k PLIST,codeIndexList,averageList
    s colCount=1,displayColCount=0
    s PLIST(colCount)="displayId"
    s codeIndexList("displayId")=colCount
    
    s searchLevel=""
    f  s searchLevel=$o(displayList(searchLevel)) q:searchLevel=""  d
    .s colCount=colCount+1
    .s PLIST(colCount)="D-"_searchLevel
    .s codeIndexList("D-"_searchLevel)=colCount
    s displayColCount=colCount
    s searchLevel=""
    f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    .s colCount=colCount+1
    .s PLIST(colCount)="S-"_searchLevel
    .s codeIndexList("S-"_searchLevel)=colCount
    .s resultSearchLevel=""
    .f  s resultSearchLevel=$o(resultSearchList(searchLevel,resultSearchLevel)) q:resultSearchLevel=""  d
    ..s colCount=colCount+1
    ..s PLIST(colCount)="R-"_resultSearchLevel
    ..s codeIndexList("R-"_resultSearchLevel)=colCount
    
    f i=1:1:colCount  d
    .s resultList=resultList_$lb(PLIST(i))
    //执行生成List
    s ^DHCANInquiry(anciId)=resultList
    
    //s opaInfoStr=""
    //f  s opaInfoStr=$o(^DHCANInquiry(anciId,"FI","OpaInfo",opaInfoStr)) q:opaInfoStr=""  d
    //.s displayId=""
    //.f  s displayId=$o(^DHCANInquiry(anciId,"FI","OpaInfo",opaInfoStr,displayId)) q:displayId=""  d
    
    //s ^DHCANInquiry(anciId,"Debug","Sort")=displaySortList("Sort")
    
    s sortCode=""
    f  s sortCode=$o(displaySortList("Sort",sortCode)) q:sortCode=""  d
    .s displayId=""
    .f  s displayId=$o(displaySortList("Sort",sortCode,displayId)) q:displayId=""  d
    ..k PLIST
    ..s searchLevel=""
    ..f  s searchLevel=$o(displayList(searchLevel)) q:searchLevel=""  d
    ...s anciiSub="",opaInfo="",opstatRowCode="D-"_searchLevel,levelInfo=""
    ...i '$d(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel)) d
    ....s PLIST(+codeIndexList(opstatRowCode))="总计"
    ...q:'$d(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel))
    ...s anciiSub=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel,anciiSub))
    ...s anciiCode=$lg(^DHCANCInquiry(anciId,"I",anciiSub),1)
    ...s anciiIsSingle=$lg(^DHCANCInquiry(anciId,"I",anciiSub),7)
    ...s anciiOpaInfo=$g(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel,anciiSub))
    ...s opaInfo=$p(anciiOpaInfo,"^",2)
    ...s opaInfoId=$p(anciiOpaInfo,"^",1)
    ...s sortExtraDesc=""
    ...i opaInfoId'="" s sortExtraDesc=$g(^DHCANInquiry("Sort","ItemCode",anciiCode,opaInfoId,"Extra"))
    ...i (opaInfo'="")&&(sortExtraDesc="") s sortExtraDesc=$g(^DHCANInquiry("Sort","ItemCode",anciiCode,opaInfo,"Extra"))
    ...//i displayId=11 b //
    ...s levelInfo=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    ...i opaInfo'="" s levelInfo=levelInfo_":"_opaInfo
    ...i ($g(displayCodeList(searchLevel))=1)&&('anciiIsSingle) s levelInfo=sortExtraDesc_opaInfo
    ...s PLIST(+codeIndexList(opstatRowCode))=levelInfo
    ..s ifHasData=0
    ..s searchLevel="",displayCountSum=0
    ..f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    ...s sumcount="",opstatRowCode="S-"_searchLevel
    ...i $d(summaryTypeList(searchLevel)) d
    ....s summaryType=""
    ....f  s summaryType=$o(summaryTypeList(searchLevel,summaryType)) q:summaryType=""  d
    .....i sumcount'="" s sumcount=sumcount_"//"
    .....s sumDivisor=1
    .....i $find(summaryType,"Average") s sumDivisor=+$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,""),-1)
    .....i '$g(sumDivisor) s sumDivisor=1
    .....s sumUom="",sumUomCount=""
    .....f  s sumUom=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",sumUom)) q:sumUom=""  d
    ......i sumUomCount'="" s sumUomCount=sumUomCount_","
    ......s singleSumUomCount=+$g(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",sumUom))
    ......s PLIST("SumType",summaryType,"Uom",sumUom,"Level",searchLevel)=+singleSumUomCount
    ......s singleSumUomCount=$num((+singleSumUomCount/sumDivisor),decimalDigits)
    ......s averageList(displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",sumUom)=singleSumUomCount
    ......s sumUomCount=sumUomCount_singleSumUomCount
    ......i sumUom'="-" s sumUomCount=sumUomCount_sumUom
    .....s PLIST(+codeIndexList(opstatRowCode),"SumType",summaryType)=sumUomCount
    .....s sumcount=sumcount_sumUomCount
    ...e  d
    ....s sumcount=+$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,""),-1)
    ....s PLIST(+codeIndexList(opstatRowCode),"SumType","OPACount")=sumcount
    ....s PLIST("SumType","OPACount","Uom","-","Level",searchLevel)=+sumcount
    ...i sumcount s ifHasData=1
    ...s PLIST(+codeIndexList(opstatRowCode))=sumcount
    ...s PLIST("SumType","Default",searchLevel)=+sumcount
    ..d SetCalculateValue
    ..s ifResultSearchQuit=$$InquiryResultData()
    ..q:ifResultSearchQuit
    ..s PLIST(+codeIndexList("displayId"))=displayId
    ..//如果统计项数据全为0 则不显示
    ..s resultList=""
    ..i ifHasData d
    ...s count=count+1
    ...f i=1:1:colCount  d
    ....s resultList=resultList_$lb(PLIST(i))
    ...s ^DHCANInquiry(anciId,"Result",count)=resultList
    ...s summaryType=""
    ...f  s summaryType=$o(summaryTypeList("SumType",summaryType)) q:summaryType=""  d
    ....s resultList=""
    ....f i=1:1:colCount d
    .....i i>displayColCount s resultList=resultList_$lb($g(PLIST(i,"SumType",summaryType)))
    .....e  s resultList=resultList_$lb($g(PLIST(i)))
    ....s ^DHCANInquiry(anciId,"Result",count,"SumType",summaryType)=resultList
    //start sync average value------------
    m ^DHCANInquiry(anciId,"FI","Display")=averageList
    //end sync average value-------------
    s ^DHCANInquiry(+anciId,"count")=count
    q
    
SetSummaryResult2
    //先生成数值矩阵，行ID为displayId，列ID为searchLevel
    //计算列汇总
    //生成计算值列
    //写入结果
    
    k preResultTextMatrix,preResultValueMatrix,recursionRecorder
    s displayId=""
    f  s displayId=$o(^DHCANInquiry(anciId,"FI","Display",displayId)) q:displayId=""  d
    ./////--生成行头部矩阵--//////
    .s searchLevel=""
    .f  s searchLevel=$o(displayList(searchLevel)) q:searchLevel=""  d
    ..s anciiSub="",opaInfo="",levelInfo=""
    ..i '$d(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel)) d
    ...s preResultTextMatrix(displayId,searchLevel)="总计"
    ..q:'$d(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel))
    ..s anciiSub=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel,anciiSub))
    ..s anciiCode=$lg(^DHCANCInquiry(anciId,"I",anciiSub),1)
    ..s anciiIsSingle=$lg(^DHCANCInquiry(anciId,"I",anciiSub),7)
    ..s anciiOpaInfo=$g(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel,anciiSub))
    ..s opaInfo=$p(anciiOpaInfo,"^",2)
    ..s opaInfoId=$p(anciiOpaInfo,"^",1)
    ..s sortExtraDesc=""
    ..i opaInfoId'="" s sortExtraDesc=$g(^DHCANInquiry("Sort","ItemCode",anciiCode,opaInfoId,"Extra"))
    ..i (opaInfo'="")&&(sortExtraDesc="") s sortExtraDesc=$g(^DHCANInquiry("Sort","ItemCode",anciiCode,opaInfo,"Extra"))
    ..//i displayId=11 b //
    ..s levelInfo=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    ..i opaInfo'="" s levelInfo=levelInfo_":"_opaInfo
    ..i ($g(displayCodeList(searchLevel))=1)&&('anciiIsSingle) s levelInfo=sortExtraDesc_opaInfo
    ..s preResultTextMatrix(displayId,searchLevel)=levelInfo
    .///////--生成值矩阵--/////////
    .s searchLevel="",displayCountSum=0
    .f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    ..s sumcount="",opstatRowCode="S-"_searchLevel
    ..i $d(summaryTypeList(searchLevel)) d
    ...s summaryType=""
    ...f  s summaryType=$o(summaryTypeList(searchLevel,summaryType)) q:summaryType=""  d
    ....i sumcount'="" s sumcount=sumcount_"//"
    ....s sumDivisor=1
    ....i $find(summaryType,"Average") s sumDivisor=+$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,""),-1)
    ....i '$g(sumDivisor) s sumDivisor=1
    ....s sumUom="",sumUomCount=""
    ....f  s sumUom=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",sumUom)) q:sumUom=""  d
    .....i sumUomCount'="" s sumUomCount=sumUomCount_","
    .....s singleSumUomCount=+$g(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",sumUom))
    .....s singleSumUomCount=$num((+singleSumUomCount/sumDivisor),decimalDigits)
    .....s averageList(displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",sumUom)=singleSumUomCount
    .....s sumUomCount=sumUomCount_singleSumUomCount
    .....i sumUom'="-" s sumUomCount=sumUomCount_sumUom
    ....s sumcount=sumcount_sumUomCount
    ..e  d
    ...s sumcount=+$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,""),-1)
    ..s preResultValueMatrix(displayId,searchLevel)=sumcount
    .s ifResultSearchQuit=$$InquiryResultData()
    .i ifResultSearchQuit d
    ..k preResultValueMatrix(displayId)
    ..k preResultTextMatrix(displayId)
    
    //b // in set result
    
    s level=""
    f  s level=$o(CalculateRowList("Level",level),-1) q:level=""  d
    .s rowId=""
    .f  s rowId=$o(CalculateRowList("Level",level,rowId)) q:rowId=""  d
    ..i $o(CalculateRowList("Level",level,rowId,"Row",""))>0 d RecurCalculateRows(rowId,1)
    ..s colId=""
    ..f  s colId=$o(preResultValueMatrix(rowId,colId)) q:colId=""  d
    ...s preResultValueMatrix(0,colId)=$g(preResultValueMatrix(0,colId))+preResultValueMatrix(rowId,colId)
    
    i '$d(CalculateRowList) d
    .s rowId=0
    .f  s rowId=$o(preResultValueMatrix(rowId)) q:rowId=""  d
    ..s colId=""
    ..f  s colId=$o(preResultValueMatrix(rowId,colId)) q:colId=""  d
    ...s preResultValueMatrix(0,colId)=$g(preResultValueMatrix(0,colId))+preResultValueMatrix(rowId,colId)
    
    
    s preResultTextMatrix(0,+$o(displayList("")))="总计"
    
    //b //set summary row text
    
    s searchLevel=""
    f  s searchLevel=$o(summaryTypeList("CalculateExpression",searchLevel)) q:searchLevel=""  d
    .s anciiSub=+$o(summaryTypeList("LevelSub",searchLevel,""))
    .s anciiDataField=$lg(^DHCANCInquiry(anciId,"I",anciiSub),6)
    .s displayId=""
    .f  s displayId=$o(preResultValueMatrix(displayId)) q:displayId=""  d
    ..k expArgList
    ..m expArgList=preResultValueMatrix(displayId)
    ..s singleSumUom="",sumDivisor=1
    ..s singleSumUomCount=..CalculateExpression(summaryTypeList("CalculateExpression",searchLevel),.expArgList)
    ..i anciiDataField="Percentage" s singleSumUomCount=singleSumUomCount*100,singleSumUom="%"
    ..e  i anciiDataField="Permillage" s singleSumUomCount=singleSumUomCount*1000,singleSumUom="‰"
    ..s singleSumUomCount=$num((singleSumUomCount/sumDivisor),decimalDigits)
    ..s sumcount=singleSumUomCount_singleSumUom
    ..s preResultValueMatrix(displayId,searchLevel)=sumcount
    
    s resultList=""
    k PLIST,codeIndexList,averageList
    s colCount=1,displayColCount=0
    s PLIST(colCount)="displayId"
    s codeIndexList("displayId")=colCount
    
    s searchLevel=""
    f  s searchLevel=$o(displayList(searchLevel)) q:searchLevel=""  d
    .s colCount=colCount+1
    .s PLIST(colCount)="D-"_searchLevel
    .s codeIndexList("D-"_searchLevel)=colCount
    s displayColCount=colCount
    s searchLevel=""
    f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    .s colCount=colCount+1
    .s PLIST(colCount)="S-"_searchLevel
    .s codeIndexList("S-"_searchLevel)=colCount
    .s resultSearchLevel=""
    .f  s resultSearchLevel=$o(resultSearchList(searchLevel,resultSearchLevel)) q:resultSearchLevel=""  d
    ..s colCount=colCount+1
    ..s PLIST(colCount)="R-"_resultSearchLevel
    ..s codeIndexList("R-"_resultSearchLevel)=colCount
    
    f i=1:1:colCount  d
    .s resultList=resultList_$lb(PLIST(i))
    //执行生成List
    s ^DHCANInquiry(anciId)=resultList
    
    //b //before generate result
    
    s sortCode="",count=0
    f  s sortCode=$o(displaySortList("Sort",sortCode)) q:sortCode=""  d
    .s displayId=""
    .f  s displayId=$o(displaySortList("Sort",sortCode,displayId)) q:displayId=""  d
    ..k PLIST
    ..s PLIST(1)=displayId
    ..s searchLevel=""
    ..f  s searchLevel=$o(displayList(searchLevel)) q:searchLevel=""  d
    ...s PLIST(+codeIndexList("D-"_searchLevel))=$g(preResultTextMatrix(displayId,searchLevel))
    ..
    ..s searchLevel="",ifHasData=0
    ..f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    ...s PLIST(+codeIndexList("S-"_searchLevel))=$g(preResultValueMatrix(displayId,searchLevel))
    ...s:PLIST(+codeIndexList("S-"_searchLevel))>0 ifHasData=1
    ...s resultSearchLevel=""
    ...f  s resultSearchLevel=$o(resultSearchList(searchLevel,resultSearchLevel)) q:resultSearchLevel=""  d
    ....s PLIST(+codeIndexList("R-"_resultSearchLevel))=preResultValueMatrix(displayId,resultSearchLevel)
    ..
    ..s resultList=""
    ..i ifHasData d
    ...s count=count+1
    ...f i=1:1:colCount  d
    ....s resultList=resultList_$lb(PLIST(i))
    ...s ^DHCANInquiry(anciId,"Result",count)=resultList
    
    //end sync average value-------------
    s ^DHCANInquiry(+anciId,"count")=count
    
RecurCalculateRows(parentNode,recursionLevel)
    s nextNodeId=""
    k preResultValueMatrix(parentNode)
    s recursionRecorder(recursionLevel,"parentNode")=parentNode
    f  s childNode=$o(CalculateRowList("Level",level,parentNode,"Row",childNode)) q:childNode=""  d
    .s recursionRecorder(recursionLevel,"childNode")=childNode
    .i $o(CalculateRowList(childNode,""))>0 d RecurCalculateRows(childNode,recursionLevel+1)
    .s colId=""
    .f  s colId=$o(preResultValueMatrix(childNode,colId)) q:colId=""  d
    ..s preResultValueMatrix(parentNode,colId)=$g(preResultValueMatrix(parentNode,colId))+preResultValueMatrix(childNode,colId)
    .s childNode=recursionRecorder(recursionLevel,"childNode")
    .s parentNode=recursionRecorder(recursionLevel,"parentNode")
   	q
    
SetCalculateValue()
    s searchLevel=""
    f  s searchLevel=$o(summaryTypeList("CalculateExpression",searchLevel)) q:searchLevel=""  d
    .s summaryType="",sumcount="",opstatRowCode="S-"_searchLevel
    .s anciiSub=+$o(summaryTypeList("LevelSub",searchLevel,""))
    .s anciiDataField=$lg(^DHCANCInquiry(anciId,"I",anciiSub),6)
    .//---计算项未选择汇总类型时按对应列的默认第一个值计算
    .i $o(summaryTypeList("CalculateExpression",searchLevel,""))="" d
    ..i $g(summaryTypeList("CalculateExpression",searchLevel))'="" d
    ...k expArgList
    ...m expArgList=PLIST("SumType","Default")
    ...s singleSumUom="",sumDivisor=1
    ...s singleSumUomCount=..CalculateExpression(summaryTypeList("CalculateExpression",searchLevel),.expArgList)
    ...i anciiDataField="Percentage" s singleSumUomCount=singleSumUomCount*100,singleSumUom="%"
    ...e  i anciiDataField="Permillage" s singleSumUomCount=singleSumUomCount*1000,singleSumUom="‰"
    ...s singleSumUomCount=$num((singleSumUomCount/sumDivisor),decimalDigits)
    ...s sumcount=singleSumUomCount_singleSumUom
    .f  s summaryType=$o(summaryTypeList("CalculateExpression",searchLevel,summaryType)) q:summaryType=""  d
    ..s sumUom="",sumUomCount=""
    ..s sumDivisor=1
    ..i $find(summaryType,"Average") s sumDivisor=+$g(PLIST(+codeIndexList(opstatRowCode),"SumType","OPACount"))
    ..i '$g(sumDivisor) s sumDivisor=1
    ..f  s sumUom=$o(PLIST("SumType",summaryType,"Uom",sumUom)) q:sumUom=""  d
    ...k expArgList
    ...m expArgList=PLIST("SumType",summaryType,"Uom",sumUom,"Level")
    ...s listsearchLevel=""
    ...f  s listsearchLevel=$o(searchList(listsearchLevel)) q:listsearchLevel=""  d
    ....i '$d(expArgList(listsearchLevel)) s expArgList(listsearchLevel)=0
    ...m expArgList=CalculateValueList
    ...//w displayId,!
    ...//b //before calculate
    ...s singleSumUom=sumUom
    ...s singleSumUomCount=..CalculateExpression(summaryTypeList("CalculateExpression",searchLevel,summaryType),.expArgList)
    ...i anciiDataField="Percentage" s singleSumUomCount=singleSumUomCount*100,singleSumUom="%"
    ...e  i anciiDataField="Permillage" s singleSumUomCount=singleSumUomCount*1000,singleSumUom="‰"
    ...s singleSumUomCount=$num((singleSumUomCount/sumDivisor),decimalDigits)
    ...//w singleSumUomCount,!
    ...//b //after calculate
    ...s ^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",singleSumUom)=singleSumUomCount
    ...i sumUomCount'="" s sumUomCount=sumUomCount_","
    ...s sumUomCount=sumUomCount_singleSumUomCount
    ...i singleSumUom'="-" s sumUomCount=sumUomCount_singleSumUom
    ...s PLIST("SumType",summaryType,"Uom",sumUom,"Level",searchLevel)=singleSumUomCount
    ..s PLIST(+codeIndexList(opstatRowCode),"SumType",summaryType)=sumUomCount
    ..i sumcount'="" s sumcount=sumcount_"//"
    ..s sumcount=sumcount_sumUomCount
    .s PLIST(+codeIndexList(opstatRowCode))=sumcount
    q
    
InquiryResultData()
    s ifResultSearchQuit=0
    s statSearchLevel=""
    s TimeIntervalItemCodeStr="^TheatreOutInInterval^"
    s FirstToLastTimeDurationCode="^InOutDayDuration^"
    s TimeSpanItemCode="^TimeSpan1^TimeSpan2^TimeSpan3^TimeSpan4^"
    //b //in InquiryResultData
    f  s statSearchLevel=$o(resultSearchList(statSearchLevel)) q:statSearchLevel=""  d
    .s resultSearchLevel=""
    .s lastAnciiSub=resultSearchList(statSearchLevel)
    .f  s resultSearchLevel=$o(resultSearchList(statSearchLevel,resultSearchLevel)) q:resultSearchLevel=""  d
    ..s anciiSub=resultSearchList(statSearchLevel,resultSearchLevel)
    ..k resultSeqList,resultDateTimeList,timeSpanDateList
    ..s opaInfoId="",opaInfo=""
    ..d SetAnciiInfo(anciiSub)
    ..i anciiType'="" d
    ...s opaSeqNo=0,totalOpaInfo=""
    ...f  s opaSeqNo=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",statSearchLevel,opaSeqNo)) q:opaSeqNo=""  d
    ....s opaId=$lg(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",statSearchLevel,opaSeqNo),1)
    ....d SetPatientBaseInfo(opaId)
    ....s anopStartDate=""
    ....s ifFind=$$JudgeOpaInfo(opaId)
    ....//i totalOpaInfo'="" s totalOpaInfo=totalOpaInfo_$c(13)
    ....//s totalOpaInfo=totalOpaInfo_$$GetOpaInfoStr(anciiSub)
    ....i anopStartDate'="" d
    .....s resultDateTimeList("StartDT",anopStartDate,+anopStartTime)=anopEndDate_"^"_anopEndTime_"^"_opaSeqNo
    .....s resultDateTimeList("EndDT",anopStartDate,+anopEndDate,+anopEndTime)=anopStartDate_"^"_anopStartTime_"^"_opaSeqNo
    .....s timeSpanDateList("Date",anopStartDate)=$g(timeSpanDateList("Date",anopStartDate))+itemQtyStatList(resultSearchLevel)
    ....s opaInfoId="",opaInfoSeq=""
    ....f  s opaInfoSeq=$o(opaInfoList(opaInfoSeq)) q:opaInfoSeq=""  d
    .....s opaInfoId=$p(opaInfoList(opaInfoSeq),"^",1)
    .....i opaInfoId="" s opaInfoId=0
    .....s resultSeqList(opaInfoId,opaSeqNo)=opaInfoList(opaInfoSeq)
    ...i (TimeIntervalItemCodeStr[("^"_anciiCode_"^"))&&($d(resultDateTimeList)) d ResetTimeIntervalInfo
    ...i (FirstToLastTimeDurationCode[("^"_anciiCode_"^"))&&($d(resultDateTimeList)) d ResetDayDuration
    ...s opaInfoId="",opaInfo="",resultSeqId=""
    ...s ifFind=0
    ...i $d(resultSeqList) d
    ....i anciiDataField="Sum" d
    .....s resultSum="",resultSeqId=""
    .....f  s resultSeqId=$o(resultSeqList(resultSeqId)) q:resultSeqId=""  d
    ......s opaSeqNo=""
    ......f  s opaSeqNo=$o(resultSeqList(resultSeqId,opaSeqNo)) q:opaSeqNo=""  d
    .......s opaInfoId=$p(resultSeqList(resultSeqId,opaSeqNo),"^",1)
    .......s resultSum=resultSum+opaInfoId
    .......m ^DHCANInquiry(anciId,"FI","Display",displayId,"Level",resultSearchLevel,opaSeqNo)=^DHCANInquiry(anciId,"FI","Display",displayId,"Level",statSearchLevel,opaSeqNo)
    .....s opaInfoId=resultSum
    .....s opaInfo=opaInfoId
    .....s ^DHCANInquiry(anciId,"FI","Display",displayId,"Level",resultSearchLevel)=opaInfoId_"^"_opaInfo
    ....e  i anciiDataField="Min" d
    .....s resultSeqId=$o(resultSeqList(""))
    .....s opaSeqNo=$o(resultSeqList(resultSeqId,""))
    .....s opaInfoId=$p(resultSeqList(resultSeqId,opaSeqNo),"^",1)
    .....s opaInfo=$p(resultSeqList(resultSeqId,opaSeqNo),"^",2)
    .....s ^DHCANInquiry(anciId,"FI","Display",displayId,"Level",resultSearchLevel)=opaInfoId_"^"_opaInfo
    .....s opaSeqNo=""
    .....f  s opaSeqNo=$o(resultSeqList(resultSeqId,opaSeqNo)) q:opaSeqNo=""  d
    ......m ^DHCANInquiry(anciId,"FI","Display",displayId,"Level",resultSearchLevel,opaSeqNo)=^DHCANInquiry(anciId,"FI","Display",displayId,"Level",statSearchLevel,opaSeqNo)
    ....e  i anciiDataField="Max" d
    .....s resultSeqId=$o(resultSeqList(""),-1)
    .....s opaSeqNo=$o(resultSeqList(resultSeqId,""))
    .....s opaInfoId=$p(resultSeqList(resultSeqId,opaSeqNo),"^",1)
    .....s opaInfo=$p(resultSeqList(resultSeqId,opaSeqNo),"^",2)
    .....s ^DHCANInquiry(anciId,"FI","Display",displayId,"Level",resultSearchLevel)=opaInfoId_"^"_opaInfo
    .....s opaSeqNo=""
    .....f  s opaSeqNo=$o(resultSeqList(resultSeqId,opaSeqNo)) q:opaSeqNo=""  d
    ......m ^DHCANInquiry(anciId,"FI","Display",displayId,"Level",resultSearchLevel,opaSeqNo)=^DHCANInquiry(anciId,"FI","Display",displayId,"Level",statSearchLevel,opaSeqNo)
    ....e  i anciiDataField="AverageMinTime" d
    .....s anopStartDate="",sumTime="",days=0
    .....f  s anopStartDate=$o(resultDateTimeList("StartDT",anopStartDate)) q:anopStartDate=""  d
    ......s anopStartTime=$o(resultDateTimeList("StartDT",anopStartDate,""))
    ......s sumTime=sumTime+anopStartTime
    ......s days=days+1
    .....s:days>0 opaInfoId=sumTime\days
    .....s:opaInfoId<86400 opaInfo=$zt(opaInfoId,2)
    ....e  i anciiDataField="AverageMaxTime" d
    .....s anopStartDate="",anopEndDate="",anopEndTime="",sumTime="",days=0
    .....f  s anopStartDate=$o(resultDateTimeList("EndDT",anopStartDate)) q:anopStartDate=""  d
    ......s anopEndDate=$o(resultDateTimeList("EndDT",anopStartDate,""),-1)
    ......s anopEndTime=$o(resultDateTimeList("EndDT",anopStartDate,anopEndDate,""),-1)
    ......s:anopEndDate>anopStartDate anopEndTime=86400
    ......s sumTime=sumTime+anopEndTime
    ......s days=days+1
    .....s:days>0 opaInfoId=sumTime\days
    .....s:opaInfoId<86400 opaInfo=$zt(opaInfoId,2)
    ....e  i anciiDataField="" d
    .....i anciiSummaryType'="" d
    ......s opaInfoId=$$GetResultDataStat()
    .....e  d
    ......s opaInfoId=totalOpaInfo
    .....s opaInfo=opaInfoId
    ..e  d
    ...s ifFind=0
    ...i anciiSummaryType'="" d
    ....s summaryType=$p(anciiSummaryType,",",1)
    ....s opaInfoId=0
    ....s sumUom=$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",statSearchLevel,0,"SumType",summaryType,"Uom",""))
    ....i sumUom'="" s opaInfoId=+$g(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",statSearchLevel,0,"SumType",summaryType,"Uom",sumUom))
    ....s opaInfo=opaInfoId
    ....m ^DHCANInquiry(anciId,"FI","Display",displayId,"Level",resultSearchLevel)=^DHCANInquiry(anciId,"FI","Display",displayId,"Level",statSearchLevel)
    ..//s PLIST(+codeIndexList("R-"_resultSearchLevel))=opaInfo
    ..//s PLIST("SumType","Default",resultSearchLevel)=opaInfoId
    ..i (TimeSpanItemCode[("^"_anciiCode_"^"))&&($d(resultDateTimeList)) d ResetTimeSpanStat
    ..s preResultValueMatrix(displayId,resultSearchLevel)=opaInfo
    ..i anciiIsSearch d
    ...s ifFind=ifFind||$$MatchMultipleValue()
    ...s ifFind=ifFind||$$MatchMinMaxValue()
    ...s ifResultSearchQuit=(ifResultSearchQuit)||('ifFind)
    
    q ifResultSearchQuit
    
ResetTimeSpanStat
	s spanDate="",opaInfoId="",opaInfo=""
	s times=$s(anciiCode="TimeSpan1":1,anciiCode="TimeSpan2":2,anciiCode="TimeSpan3":3,anciiCode="TimeSpan4":4,1:1)
	f  s spanDate=$o(timeSpanDateList(spanDate)) q:spanDate=""  d
	.s opaInfoId=timeSpanDateList(spanDate)
	.s opaInfo=opaInfo+(times*(opaInfoId\1)+(opaInfoId-(opaInfoId\1)))
	s opaInfoId=opaInfo
	q
	
ResetTimeIntervalInfo
    k resultSeqList
    s anopStartDate="",anopEndDate="",anopEndTime="",ifCalculateInterval=0
    f  s anopStartDate=$o(resultDateTimeList("StartDT",anopStartDate)) q:anopStartDate=""  d
    .s anopStartTime="",ifCalculateInterval=0
    .f  s anopStartTime=$o(resultDateTimeList("StartDT",anopStartDate,anopStartTime)) q:anopStartTime=""  d
    ..s anopInterval=0
    ..i anopEndDate>=anopStartDate d
    ...s anopInterval=$$CaculateDateTimeStatInfo(anopEndDate,anopEndTime,anopStartDate,anopStartTime)
    ...s anopInterval=$num(anopInterval,decimalDigits)
    ..i ifCalculateInterval s resultSeqList(anopInterval,opaSeqNo)=anopInterval_"^"_anopInterval_timeUom
    ..s anopEndDate=$p(resultDateTimeList("StartDT",anopStartDate,anopStartTime),"^",1)
    ..s anopEndTime=$p(resultDateTimeList("StartDT",anopStartDate,anopStartTime),"^",2)
    ..s opaSeqNo=$p(resultDateTimeList("StartDT",anopStartDate,anopStartTime),"^",3)
    ..i ifCalculateInterval s resultSeqList(anopInterval,opaSeqNo)=0_"^"_anopInterval_timeUom
    ..s ifCalculateInterval=1
    
ResetDayDuration
    k resultSeqList
    //b //before reset day duration
    s anopStartDate="",anopEndDate="",anopEndTime="",ifCalculateInterval=0
    f  s anopStartDate=$o(resultDateTimeList("StartDT",anopStartDate)) q:anopStartDate=""  d
    .s anopStartTime=$o(resultDateTimeList("StartDT",anopStartDate,""))
    .s anopEndDate=$o(resultDateTimeList("EndDT",anopStartDate,""),-1)
    .s anopEndTime=$o(resultDateTimeList("EndDT",anopStartDate,anopEndDate,""),-1)
    .s anopInterval=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime)
    .s anopInterval=$num(anopInterval,decimalDigits)
    .//b  //in date loop after get interval
    .s anopStartTime=""
    .f  s anopStartTime=$o(resultDateTimeList("StartDT",anopStartDate,anopStartTime)) q:anopStartTime=""  d
    ..s opaSeqNo=$p(resultDateTimeList("StartDT",anopStartDate,anopStartTime),"^",3)
    ..i $p(resultDateTimeList("EndDT",anopStartDate,anopEndDate,anopEndTime),"^",3)=opaSeqNo d
    ...s resultSeqList(anopInterval,opaSeqNo)=anopInterval_"^"_anopInterval_timeUom
    ..e  s resultSeqList(anopInterval,opaSeqNo)=0_"^"_0_timeUom
    //b //after reset day duration
    
GetResultDataStat()
	s ifFind=0
	s resultSeqId="",opaInfoId="",opaInfo="",result=""
	f  s resultSeqId=$o(resultSeqList(resultSeqId)) q:resultSeqId=""  d
	.s opaSeqNo="",opaInfoIdCount=0
	.f  s opaSeqNo=$o(resultSeqList(resultSeqId,opaSeqNo)) q:opaSeqNo=""  d
	..s opaInfoIdCount=opaInfoIdCount+1
	..s opaInfoId=$p(resultSeqList(resultSeqId,opaSeqNo),"^",1)
	..s opaInfo=$p(resultSeqList(resultSeqId,opaSeqNo),"^",2)
	..s ifFind=ifFind||$$MatchMultipleValue()
	..s ifFind=ifFind||$$MatchMinMaxValue()
	.i result'="" s result=result_$c(13)
	.s result=result_opaInfo_":"_opaInfoIdCount
	q result
    
    
SetAnciiInfo(anciiSub)
    s anciiCode=$lg(^DHCANCInquiry(anciId,"I",anciiSub),1)
    s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    s anciiDataField=$lg(^DHCANCInquiry(anciId,"I",anciiSub),6)
    s anciiIsSingle=$lg(^DHCANCInquiry(anciId,"I",anciiSub),7)
    s anciiMinValue=$lg(^DHCANCInquiry(anciId,"I",anciiSub),8)
    s anciiMaxValue=$lg(^DHCANCInquiry(anciId,"I",anciiSub),9)
    s anciiSummaryType=$lg(^DHCANCInquiry(anciId,"I",anciiSub),24)
    s anciiMultipleValue=$lg(^DHCANCInquiry(anciId,"I",anciiSub),11)
    s anciiStartDateTime=$lg(^DHCANCInquiry(anciId,"I",anciiSub),12)
    s anciiStartDate=date,anciiEndDate=date
    s anciiStartTime=0,anciiEndTime=$zth("23:59:59")
    s anciiDurationHour=$lg(^DHCANCInquiry(anciId,"I",anciiSub),13)
    s anciiFromDate=$lg(^DHCANCInquiry(anciId,"I",anciiSub),29)
    s anciiFromTime=$lg(^DHCANCInquiry(anciId,"I",anciiSub),15)
    s anciiExactTime=$lg(^DHCANCInquiry(anciId,"I",anciiSub),17)
    s anciiToDate=$lg(^DHCANCInquiry(anciId,"I",anciiSub),30)
    s anciiToTime=$lg(^DHCANCInquiry(anciId,"I",anciiSub),16)
    s anciiRefAncoId=$lg(^DHCANCInquiry(anciId,"I",anciiSub),18)
    s anciiFromAncoId=$lg(^DHCANCInquiry(anciId,"I",anciiSub),22)
    s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    s anciiToAncoId=$lg(^DHCANCInquiry(anciId,"I",anciiSub),23)
    s anciiRefValue=$lg(^DHCANCInquiry(anciId,"I",anciiSub),19)
    s anciiType=$lg(^DHCANCInquiry(anciId,"I",anciiSub),3)
    s anciiOeoriNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),14)
    s anciiRelateAnciiSub=$lg(^DHCANCInquiry(anciId,"I",anciiSub),26)
    s anciiIsNegative=$lg(^DHCANCInquiry(anciId,"I",anciiSub),31)
    d SetAnciiDateTime(opaId)
    q
    
SetAnciiDateTime(opaId)
    //获取基准时间
    i anciiStartDateTime="OperAppTime" d
    .s anciiStartDate=$p(^DHCANOPArrange(opaId),"^",3)
    .s anciiStartTime=$p(^DHCANOPArrange(opaId),"^",5)
    e  i anciiStartDateTime="OperStartDate" d
    .s anciiStartDate=$p(^DHCANOPArrange(opaId),"^",14)
    .s anciiStartTime=0
    e  i anciiStartDateTime="TheatreInTime" d
    .s anciiStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)
    .s anciiStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)
    e  i anciiStartDateTime="AnaStartTime" d
    .s anciiStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)
    .s anciiStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",3)
    e  i anciiStartDateTime="AnaEndTime" d
    .s anciiStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)
    .s anciiStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",4)
    e  i anciiStartDateTime="TheatreOutTime" d
    .s anciiStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)
    .s anciiStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)
    
    //基准时间对应持续小时处理
    i +anciiStartDate>0 d
    .i +anciiDurationHour>0 d
    ..s anciiEndDate=anciiStartDate+(anciiDurationHour\24)
    ..s anciiEndTime=anciiStartTime+((anciiDurationHour#24)*3600)
    .e  d
    ..s anciiEndDate=anciiStartDate
    ..s anciiEndTime=anciiStartTime
    ..s anciiStartDate=anciiEndDate+(anciiDurationHour\24)
    ..s anciiStartTime=anciiEndTime+((anciiDurationHour#24)*3600)
    
    //开始日期、结束日期处理
    i anciiFromDate>0 s anciiStartDate=anciiFromDate,anciiStartTime=0
    i anciiToDate>0 s anciiEndDate=anciiToDate,anciiEndTime=0
    
    //开始时间、结束时间、准确时间处理
    s anciiStartTime=anciiStartTime+anciiFromTime
    s anciiEndTime=anciiEndTime+anciiToTime
    i anciiExactTime>0 d
    .s anciiEndTime=anciiStartTime=anciiStartTime+anciiExactTime
    .s anciiEndDate=anciiStartDate
    //查询开始日期时间、结束日期时间标准化
    i anciiStartTime>86399 d
    .s anciiStartTime=anciiStartTime-86400
    .s anciiStartDate=anciiStartDate+1
    i anciiStartTime<0 d
    .s anciiStartTime=86400+anciiStartTime
    .s anciiStartDate=anciiStartDate-1
    i anciiStartDate<0 s anciiStartDate=0
    i anciiEndTime>86399 d
    .s anciiEndTime=anciiEndTime-86400
    .s anciiEndDate=anciiEndDate+1
    
    q
    
JudgeOpaInfo(opaId)
    s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
    i anciiType="P"  d
    .//Patient 指病人相关就诊信息
    .s ifFind=$$JudgePatInfo(opaId)
    e  i anciiType="B"  d
    .//Baseline 病人手术麻醉相关信息
    .s ifFind=$$JudgeOPArrangeInfo(opaId)
    e  i anciiType="I"  d
    .//ICD  病人手术名称、诊断等具有ICD编码的信息
    .s ifFind=$$JudgeICDInfo(opaId)
    e  i anciiType="OL"  d
    .//手术信息
    .s ifFind=$$JudgeOperationList(opaId)
    e  i anciiType="D"  d
    .//Doctor  病人手术麻醉医生
    .d SetANShift(opaId)
    .s ifFind=$$JudgeDocInfo(opaId)
    e  i anciiType="O"  d
    .//Order  病人手术麻醉医嘱
    .s ifFind=$$JudgeOEOrderInfo(opaId)
    e  i anciiType="R"  d
    .//Record  病人麻醉监护记录内容
    .s ifFind=$$JudgeANOrderInfo(opaId)
    e  i anciiType="L"  d
    .//Lab 病人检验检查相关项目
    .s ifFind=$$JudgeLabInfo(opaId)
    m curOpaInfoList(anciiSub)=opaInfoList
    i '$d(inquiryInfoList(opaId,anciiCode)) m inquiryInfoList(opaId,anciiCode)=opaInfoList
    //s:anciiIsNegative ifFind='ifFind
    q ifFind
    
SetANShift(opaId)
    s ANShiftSub=0
    q:$d(ANShiftList(opaId))
    k ANShiftList
    f  s ANShiftSub=$o(^DHCANOPArrange(opaId,"Shift",ANShiftSub)) q:ANShiftSub=""  d
    .s ANShift=^DHCANOPArrange(opaId,"Shift",ANShiftSub)
    .s ANSShiftCtcpId=$p(ANShift,"^",16)
    .s ANSShiftCtcpName=##class(web.DHCANOPCom).GetNameById(ANSShiftCtcpId)
    .s ANSReliefCtcpId=$p(ANShift,"^",17)
    .s ANSReliefCtcpName=##class(web.DHCANOPCom).GetNameById(ANSReliefCtcpId)
    .q:(ANSShiftCtcpId<=0)&&(ANSReliefCtcpId<=0)
    .s ANSDate=+$p(ANShift,"^",18)
    .q:ANSDate<=0
    .s ANSTime=+$p(ANShift,"^",19)
    .s ANSType=$p(ANShift,"^",1)
    .s ANSCareProvType=$p(ANShift,"^",39)
    .i ANSCareProvType="" s ANSCareProvType="A"
    .s ANShiftList(opaId,ANSCareProvType,"DateTime",ANSDate,ANSTime)=ANSType_"^"_ANSShiftCtcpId_"^"_ANSShiftCtcpName_"^"_ANSReliefCtcpId_"^"_ANSReliefCtcpName
    
    //d SetAHSLShift //特殊 安徽省立
    s ANSCareProvType=""
    f  s ANSCareProvType=$o(ANShiftList(opaId,ANSCareProvType)) q:ANSCareProvType=""  d
    .s ANSCareProvSeqNo=0
    .s ANSDate=""
    .f  s ANSDate=$o(ANShiftList(opaId,ANSCareProvType,"DateTime",ANSDate)) q:ANSDate=""  d
    ..s ANSTime=""
    ..f  s ANSTime=$o(ANShiftList(opaId,ANSCareProvType,"DateTime",ANSDate,ANSTime)) q:ANSTime=""  d
    ...s ANSCareProvSeqNo=ANSCareProvSeqNo+1
    ...s ANShiftList(opaId,ANSCareProvType,"Seq",ANSCareProvSeqNo)=ANShiftList(opaId,ANSCareProvType,"DateTime",ANSDate,ANSTime)_"^"_ANSDate_"^"_ANSTime
    
    q
    
SetAHSLShift()
    d SetAHSLOperDT
    s ANSCareProvType="SN"
    s ANSShiftCtcpId=$p(OPNurseShiftTimeStr,"^",9)
    s ANSShiftCtcpName=##class(web.UDHCANOPArrange).GetNurseById(ANSShiftCtcpId)
    s ANSType="T"
    s ANSReliefCtcpId=$p(OPNurseShiftTimeStr,"^",4)
    s ANSReliefCtcpName=##class(web.UDHCANOPArrange).GetNurseById(ANSReliefCtcpId)
    s ANSDate=OPDate
    s ANSTime=$p(OPNurseShiftTimeStr,"^",5)
    i ANSTime'="" s ANSTime=$zth(ANSTime,2)
    i ANSTime<anopStartTime s ANSDate=ANSDate+1
    s ANShiftList(opaId,ANSCareProvType,"DateTime",ANSDate,ANSTime)=ANSType_"^^"_ANSShiftCtcpName_"^^"_ANSReliefCtcpName
    
    s ANSCareProvType="CN"
    s ANSShiftCtcpId=$p(OPNurseShiftTimeStr,"^",8)
    s ANSShiftCtcpName=##class(web.UDHCANOPArrange).GetNurseById(ANSShiftCtcpId)
    s ANSType="T"
    s ANSReliefCtcpId=$p(OPNurseShiftTimeStr,"^",6)
    s ANSReliefCtcpName=##class(web.UDHCANOPArrange).GetNurseById(ANSReliefCtcpId)
    s ANSDate=OPDate
    s ANSTime=$p(OPNurseShiftTimeStr,"^",7)
    i ANSTime'="" s ANSTime=$zth(ANSTime,2)
    i ANSTime<anopStartTime s ANSDate=ANSDate+1
    s ANShiftList(opaId,ANSCareProvType,"DateTime",ANSDate,ANSTime)=ANSType_"^^"_ANSShiftCtcpName_"^^"_ANSReliefCtcpName
    q
    
    //匹配多选值,多选包含匹配
MatchMultipleValue()
    i (($$MatchNoCondition())&&((opaInfoId'="")||(opaInfo'="")))||((anciiMultipleValue'="")&&(("|"_anciiMultipleValue_"|")[("|"_opaInfoId_"|"))) q 1
    q 0
    
    //匹配未设置条件值，未设置条件值时，不为空就不退出
MatchNoCondition()
    q $$MatchNoValueCondition()&&$$MatchNoTimeConditon()
    
MatchNoValueCondition()
    q (anciiMultipleValue="")&&(anciiMinValue="")&&(anciiMaxValue="")
    
MatchNoMinMaxCondition()
    q (anciiMinValue="")&&(anciiMaxValue="")
    
MatchNoTimeConditon()
    q (anciiStartDateTime="")&&(anciiFromDate="")&&(anciiToDate="")&&(anciiFromTime="")&&(anciiToTime="")&&(anciiExactTime="")
    
    //匹配最大值最小值,有最值时按最值匹配,无不匹配
MatchMinMaxValue()
    i ((anciiMinValue="")||(+opaInfoId>=anciiMinValue))&&((anciiMaxValue="")||(+opaInfoId<=anciiMaxValue))&&((anciiMinValue'="")||(anciiMaxValue'="")) q 1
    q 0
    
    //匹配时间间隔是否和判定时间区域有交集
MatchDateTimeInterval()
    i ((anopStartDate+(anopStartTime*0.00001))<=(anciiEndDate+(anciiEndTime*0.00001)))&&((anopEndDate+(anopEndTime*0.00001))>=(anciiStartDate+(anciiStartTime*0.00001))) q 1
    q 0
    
    //判定时间区域末值小于起始值时,匹配一天中额外时间区域
MatchDateTimeExtra()
    i ((anciiEndDate+(anciiEndTime*0.00001))<(anciiStartDate+(anciiStartTime*0.00001)))&&(((anopStartDate+(anopStartTime*0.00001))>=(anciiStartDate+(anciiStartTime*0.00001)))||((anopEndDate+(anopEndTime*0.00001))<=(anciiEndDate+(anciiEndTime*0.00001)))) q 1
    q 0
    
    //模糊匹配
FuzzyMatch()
    i ((anciiMultipleValue="")&&((opaInfoId'="")||(opaInfo'="")))||((anciiMultipleValue'="")&&(opaInfo[anciiMultipleValue)) q 1
    q 0
    
    //首部匹配
HeaderMatch()
    i (anciiMultipleValue'="")&&(("^"_opaInfoId)[("^"_anciiMultipleValue)) q 1
    q 0
    
MatchANOPDateTime()
    s opaInfoId=$S($l(anopStartTime)=1:"0000",$l(anopStartTime)=2:"000",$l(anopStartTime)=3:"00",$l(anopStartTime)=4:"0",1:"")_anopStartTime
    s opaInfoId=anopStartDate_","_opaInfoId
    s opaInfo=$zd(anopStartDate,3)_" "_$zt(anopStartTime,2)
    i anopStartDate<=0 s opaInfo=""
    s ifFind=ifFind||$$MatchDateTimeInterval()
    s ifFind=ifFind||$$MatchDateTimeExtra()
    q ifFind
    
MatchANOPTimeInterval(specialTimeScale = 0,timeUom = "h")
    s opaInfoId=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime,specialTimeScale)
    s opaInfoId=$num(opaInfoId,decimalDigits)
    s opaInfo=opaInfoId_timeUom
    s ifFind=ifFind||$$MatchMinMaxValue()
    s ifFind=ifFind||$$MatchDateTimeInterval()
    s ifFind=ifFind||$$MatchDateTimeExtra()
    s ifFind=ifFind||$$MatchMultipleValue()
    q ifFind
    
JudgePatInfo(opaId)
    //判断病人基本数据
    s ifFind=0,opaInfoId="",opaInfo="",ErrMsg=""
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
    i anciiCode="RegNo" d    //登记号
    .s opaInfoId=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="EpisodeID" d   //就诊号
    .s opaInfoId=EpisodeID
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=1
    e  i anciiCode="InPatNo" d   //住院号(病案号)
    .;s opaInfoId=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	.s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	.s opaInfoId=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="MedCareNo" d   //病案号(住院号) 一般是相等的
    .//s opaInfoId=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)  旧版获取病案号
	.s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	.s opaInfoId=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
    .;s opaInfoId=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID,.ErrMsg)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="PersonID" d   //病人Id
    .s opaInfoId=$p($g(^PAPER(papmiId,"ALL")),"^",9)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="PatName" d   //姓名
    .s opaInfoId=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="personLX" d   //联系人
    .s opaInfoId=$p($g(^PAPER(papmiId,"PER",2)),"^",13)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="personLXDH" d   //联系人电话
    .s opaInfoId=$p($g(^PAPER(papmiId,"ALL")),"^",4)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="birth" d   //生日
    .s opaInfoId=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="sex" d   //性别
    .s opaInfoId=$p($g(^PAPER(papmiId,"ALL")),"^",7)
    .s opaInfo=$p($g(^CT("SEX",+opaInfoId)),"^",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="age" d   //年龄
    .s opsttDate=$p(^DHCANOPArrange(opaId),"^",14)
    .s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    .s opaInfo=##class(web.DHCClinicCom).CalAge(birth,opsttDate,1)
    .s opaAgeYear=+$p(opaInfo,"岁",1)
    .s opaAgeMouth=$p(opaInfo,"岁",2)
    .s opaAgeDay=$p(opaAgeMouth,"月",2)
    .s opaAgeMouth=+opaAgeMouth
    .s opaAgeDay=+opaAgeDay
    .s opaInfoId=opsttDate-birth
    .i (anciiDataField="Year")||(anciiDataField="") d
    ..s opaInfoId=+opaAgeYear
    .e  i anciiDataField="Mouth" d
    ..s opaInfoId=opaAgeYear*12+opaAgeMouth
    .e  i anciiDataField="Day" d
    ..s opaInfoId=+opaInfoId
    .s opaInfo=##class(web.DHCClinicCom).CalAge(birth,opsttDate)
    .s ifFind=ifFind||$$MatchMinMaxValue()
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="AdmDateTime" d   //就诊时间
    .s anopStartDate=$p($g(^PAADM(EpisodeID)),"^",6)
    .s anopStartTime=$p($g(^PAADM(EpisodeID)),"^",7)
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="AdmOPDateDuration"  d    //患者就诊到手术的时间间隔
    .s anopStartDate=$p($g(^PAADM(EpisodeID)),"^",6)
    .s anopStartTime=0
    .s anopEndDate=$p(^DHCANOPArrange(opaId),"^",14)
    .s anopEndTime=0
    .s ifFind=ifFind||$$MatchANOPTimeInterval(3600*24,"天")
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="VisitStatus" d   //就诊状态
    .s opaInfoId=$p($g(^PAADM(EpisodeID)),"^",20)
    .s opaInfo=$s(opaInfoId="A":"在院",opaInfoId="C":"取消住院",opaInfoId="D":"出院",opaInfoId="P":"预约",1:"无")
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="DischgDateTime" d   //出院时间
    .s anopStartDate=$p($g(^PAADM(EpisodeID)),"^",17)
    .s anopStartTime=$p($g(^PAADM(EpisodeID)),"^",18)
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="DoctorInCharge" d   //主管医生
    .s opaInfoId=$p($g(^PAADM(EpisodeID)),"^",9)
    .s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="AdmType" d   //就诊类型
    .s opaInfoId=$p($g(^PAADM(EpisodeID)),"^",2)
    .s opaInfo=$s(opaInfoId="I":"住院",opaInfoId="O":"门诊",opaInfoId="E":"急诊",opaInfoId="N":"新生",opaInfoId="H":"体检",1:"无")
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="AdmOutPatLoc" d  //住院前门诊科室
    .s IPBookid=$o(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeID,""))
    .s opaInfoId=$p($g(^DHCDocIPBK(+IPBookid)),"^",11)
    .s opaInfo=$p($g(^CTLOC(+opaInfoId)),"^",2)
    .i (ifShowShortLocDesc)&&($l(opaInfo,"-")>1) s opaInfo=$p(opaInfo,"-",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="DischargeLoc" d  //出院科室
    .s opaInfoId=$p($g(^PAADM(EpisodeID)),"^",4)
    .s opaInfo=$p($g(^CTLOC(+opaInfoId)),"^",2)
    .i (ifShowShortLocDesc)&&($l(opaInfo,"-")>1) s opaInfo=$p(opaInfo,"-",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="IsDaySurgery" d  //是否日间手术
    .s treatedPrincipleId=$p(^PAADM(EpisodeID,"DHC"),"^",49)
    .s code=$p($g(^DHCDocIPBDIC(+treatedPrincipleId)),"^",1)
    .s opaInfoId=$s((code="DaySurg"):"Y",1:"N")
    .s opaInfo=$s(opaInfoId="Y":"是",1:"否")
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="IsDelayDischarge" d  //是否延迟出院（日间手术）
    .s anopStartDate=$p($g(^PAADM(EpisodeID)),"^",6)
    .s anopStartTime=$p($g(^PAADM(EpisodeID)),"^",7)
    .s anopEndDate=$p($g(^PAADM(EpisodeID)),"^",17)
    .s anopEndTime=$p($g(^PAADM(EpisodeID)),"^",18)
    .i anopEndDate="" s anopEndDate=+$h,anopEndTime=$p($h,",",2)
    .s opaInfoId=$s((anopEndDate=anopStartDate):"N",(anopEndDate=(anopStartDate+1))&&(anopEndTime<anopStartTime):"N",1:"Y")
    .s opaInfo=$s(opaInfoId="Y":"是",1:"否")
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="DischargeType" d  //出院状态(北京安贞医院)
    .i $d(inquiryInfoList(opaId,anciiCode,1)) d
    ..s opaInfoId=$p(inquiryInfoList(opaId,anciiCode,1),"^",1)
    ..s opaInfo=$p(inquiryInfoList(opaId,anciiCode,1),"^",2)
    .e  d
    ..i ((+$h)>(+$g(^DHCANInquiry("ItemData",anciiCode,EpisodeID,"DateTime"))))  d
    ...zn "epr"
    ...s opaInfoId=##Class(DHC.EPR.ExportUtil).getDisStu(EpisodeID)
    ...zn "DHC-APP"
    ...s ^DHCANInquiry("ItemData",anciiCode,EpisodeID)=opaInfoId
    ...i opaInfoId="" s ^DHCANInquiry("ItemData",anciiCode,EpisodeID,"DateTime")=$h
    ...e  s ^DHCANInquiry("ItemData",anciiCode,EpisodeID,"DateTime")="999999,999999"
    ..e  d
    ...s opaInfoId=^DHCANInquiry("ItemData",anciiCode,EpisodeID)
    ..s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    q ifFind
JudgeOPArrangeInfo(opaId)
    //判断病人手术安排数据?
    s ifFind=0,ifAllMatch=1,opaInfoId="",opaInfo=""
    i anciiCode="opaId" d
    .s opaInfoId=opaId
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="Isolated" d   //是否隔离
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",10)
    .s opaInfo=..ConvertYNToStr(opaInfoId)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="PrepareBlood" d   //是否备血
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",33)
    .s opaInfo=..ConvertYNToStr(opaInfoId)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="UseSelfBlood" d   //是否自体血回输
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",34)
    .s opaInfo=..ConvertYNToStr(opaInfoId)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="ExCirculation" d   //是否体外循环
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",36)
    .s opaInfo=..ConvertYNToStr(opaInfoId)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="NeedAnaesthetist" d   //是否麻醉
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",44)
    .s opaInfo=..ConvertYNToStr(opaInfoId)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="MiniInvasive" d   //是否微创手术
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",13)
    .s opaInfo=..ConvertYNToStr(opaInfoId)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="NeedNavigation" d   //是否导航
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",55)
    .s opaInfo=..ConvertYNToStr(opaInfoId)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="UnPlanedOp" d   //是否非计划再次手术
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",46)
    .s opaInfo=..ConvertYNToStr(opaInfoId)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="majorSurgery" d   //是否重大手术
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",30)
    .s opaInfo=..ConvertYNToStr(opaInfoId)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="AHSLOperCat" d   //安徽省立护理病历中的手术类型
    .s opaInfoId=$p(OPNurseShiftTimeStr,"^",10)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="DeceasedTime" d  //死亡时间
    .s anopStartDate=$p($g(^PAPER(papmiId,"ALL")),"^",13)
    .s anopStartTime=$p($g(^PAPER(papmiId,"ALL")),"^",8)
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="IsDeceased" d  //是否死亡
    .s anopStartDate=$p($g(^PAPER(papmiId,"ALL")),"^",13)
    .s anopStartTime=$p($g(^PAPER(papmiId,"ALL")),"^",8)
    .s opaInfoId=$s((anopStartDate>0)&&(anopStartTime>0):"Y",1:"N")
    .s opaInfo=$s(opaInfoId="Y":"是",1:"否")
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OPAppDateTime" d   //手术申请时间
    .s anopStartDate=$p(^DHCANOPArrange(opaId),"^",3)
    .s anopStartTime=$p(^DHCANOPArrange(opaId),"^",5)
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OPAuditDateTime" d   //手术审核时间
    .s anopStartDate=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",15)
    .s anopStartTime=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",16)
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OPStartMouth" d   //手术开始月  用于直接生成月统计等
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",14)   //手术开始日期
    .s opaInfo=$zd(opaInfoId,3)
    .s opaInfoId=$p(opaInfo,"-",1)_"-"_$p(opaInfo,"-",2)
    .s opaInfo=$p(opaInfo,"-",1)_"年"_$p(opaInfo,"-",2)_"月"
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OPDate"  d   //手术日期
    .s anopStartDate=$p(^DHCANOPArrange(opaId),"^",14)
    .s anopStartTime=0
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfo=$zd(opaInfoId,3)
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OperStartDateTime"  d   //手术开始时间
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",19)   //手术开始时间
    .i anopStartTime="" d
    ..s anopStartDate=$p(^DHCANOPArrange(opaId),"^",14)   //术后登记手术开始日期
    ..s anopStartTime=$p(^DHCANOPArrange(opaId),"^",15)   //术后登记手术开始时间
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OperEndDateTime"  d   //手术结束时间
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",20)   //手术结束时间
    .i anopStartTime="" d
    ..s anopStartDate=$p(^DHCANOPArrange(opaId),"^",16)   //术后登记手术结束日期
    ..s anopStartTime=$p(^DHCANOPArrange(opaId),"^",17)   //术后登记手术结束时间
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OperStartEndDuration"  d   //手术开始结束时间间隔
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",19)   //手术开始时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",20)   //手术结束时间
    .i anopStartTime="" d
    ..s anopStartDate=$p(^DHCANOPArrange(opaId),"^",14)   //术后登记手术开始日期
    ..s anopStartTime=$p(^DHCANOPArrange(opaId),"^",15)   //术后登记手术开始时间
    .i anopEndTime="" d
    ..s anopEndDate=$p(^DHCANOPArrange(opaId),"^",16)   //术后登记手术结束日期
    ..s anopEndTime=$p(^DHCANOPArrange(opaId),"^",17)   //术后登记手术结束时间
    .//特殊 安徽省立
    .//d SetAHSLOperDT
    .s ifFind=ifFind||$$MatchANOPTimeInterval()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="ANAPrepareDuration"  d   //麻醉准备时间间隔  麻醉开始到手术开始
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)   //麻醉开始日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",3)   //麻醉开始时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",19)   //手术开始时间
    .s ifFind=ifFind||$$MatchANOPTimeInterval()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="ANAStartDateTime"  d   //麻醉开始时间
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)   //麻醉开始日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",3)   //麻醉开始时间
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="ANAEndDateTime"  d   //麻醉结束时间
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",29)   //麻醉结束日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",4)   //麻醉结束时间
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="ANAStartEndDuration"  d   //麻醉开始结束时间间隔
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)   //麻醉开始日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",3)   //麻醉开始时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",29)   //麻醉结束日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",4)   //麻醉结束时间
    .s ifFind=ifFind||$$MatchANOPTimeInterval()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="BeforeANPrepareDuration"  d   //麻醉前(入室)准备时间间隔  入室到麻醉开始
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)   //麻醉开始日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",3)   //麻醉开始时间
    .s ifFind=ifFind||$$MatchANOPTimeInterval()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="BeforeOPPrepareDuration"  d   //术前准备时间间隔  入室到手术开始
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",19)   //手术开始时间
    .s ifFind=ifFind||$$MatchANOPTimeInterval()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="TheatreInDateTime"  d   //入室时间
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s:anopStartDate="" anopStartDate=$p(^DHCANOPArrange(opaId),"^",14)  //手术开始日期
    .s:anopStartTime="" anopStartTime=$p(^DHCANOPArrange(opaId),"^",15)  //手术开始时间
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="TheatreOutDateTime"  d   //出室时间
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i (anciiCode="TheatreInOutDuration")||(anciiCode="TheatreOutInInterval")||(anciiCode="InOutDayDuration")  d   //入离室时间间隔
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)     //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)     //出室时间
    .s ifFind=ifFind||$$MatchANOPTimeInterval()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="AfterOPOutDuration"  d
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",20)   //手术结束时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)     //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)     //出室时间
    .s ifFind=ifFind||$$MatchANOPTimeInterval()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="AfterANOutDuration"  d
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",29)   //麻醉结束日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",4)   //麻醉结束时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)     //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)     //出室时间
    .s ifFind=ifFind||$$MatchANOPTimeInterval()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="AfterOPANDuration"  d
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",20)   //手术结束时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",29)   //麻醉结束日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",4)   //麻醉结束时间
    .s ifFind=ifFind||$$MatchANOPTimeInterval()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="PACUInDateTime"  d   //入PACU时间
    .s anopStartDate=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",6)   //入PACU日期
    .s anopStartTime=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",7)   //入PACU时间
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="PACUOutDateTime"  d   //出PACU时间
    .s anopStartDate=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",8)   //出PACU日期
    .s anopStartTime=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",9)   //出PACU时间
    .s anopEndDate=anopStartDate,anopEndTime=anopStartTime
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="PACUInOutDuration"  d   //PACU用时
    .s anopStartDate=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",6)   //入PACU日期
    .s anopStartTime=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",7)   //入PACU时间
    .s anopEndDate=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",8)   //出PACU日期
    .s anopEndTime=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",9)   //出PACU时间
    .s ifFind=ifFind||$$MatchANOPTimeInterval()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="OPCancelAfterAN"  d    //麻醉开始后取消手术
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)   //麻醉开始日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",3)   //麻醉开始时间
    .s anopOperStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",19)   //手术开始时间
    .s opaInfoId=0
    .i (anopStartTime>0)&&(anopOperStartTime=0) s opaInfoId=1
    .s opaInfo=$s(opaInfoId:"是",1:"否")
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="NightShift" d  //夜班
	.s anopStartDate=$p(^DHCANOPArrange(opaId),"^",14)   //术后登记手术开始日期
	.s anopStartTime=$p(^DHCANOPArrange(opaId),"^",15)   //术后登记手术开始时间
	.s anopEndDate=$p(^DHCANOPArrange(opaId),"^",16)   //术后登记手术结束日期
    .s anopEndTime=$p(^DHCANOPArrange(opaId),"^",17)   //术后登记手术结束时间
	.s NightShiftStartTime=$zth("18:00"),NightShiftEndTime=$zth("8:00")  //夜班开始时间为18点，夜班结束时间为8点
	.s ifFind=(anopEndTime>NightShiftStartTime)||(anopStartTime<NightShiftEndTime)||(anopEndDate > anopStartDate)  //开始时间小于8点或结束时间大于18点，或者跨天，也就是说有交集的手术都取出来
	.s opaInfoId=$$CaculateDateTimeStatInfo(anopEndDate,NightShiftStartTime,anopEndDate,anopEndTime)
	.s opaInfoId=opaInfoId+$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopStartDate,NightShiftEndTime)
	.i (anopEndDate > anopStartDate) d
	..s opaInfoId=$$CaculateDateTimeStatInfo(anopStartDate,$s(anopStartTime<NightShiftStartTime:NightShiftStartTime,1:anopStartTime),anopEndDate,$s(anopEndTime>NightShiftEndTime:NightShiftEndTime,1:anopEndTime))
	.s opaInfo=opaInfoId
	.s opaInfoList(1)=opaInfoId_"^"_opaInfo
	.s itemQtyStatList(searchLevel)=opaInfoId
    e  i anciiCode="Status" d   //手术状态
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",27)
    .s opaInfo=opaInfoId
    .s opaPatStatus=$p(^DHCANOPArrange(opaId),"^",23)
    .i opaInfoId="A" s opaInfo="申请"
    .e  i opaInfoId="D" d
    ..i opaPatStatus="I" s opaInfo="撤销"
    ..e  s opaInfo="拒绝"
    .i opaInfoId="R" s opaInfo="安排"
    .i opaInfoId="N" s opaInfo="非预约"
    .i opaInfoId="I" s opaInfo="术中"
    .i opaInfoId="P" s opaInfo="恢复室"
    .i opaInfoId="L" s opaInfo="术毕"
    .i opaInfoId="F" s opaInfo="完成"
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="AddInstrument" d   //是否添加器械
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId)),"^",31)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="AppLoc" d   //申请科室
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId)),"^",54)
    .//特殊 安徽省立
    .//s opaInfoId=$P(^PAADM(EpisodeID),"^",4)
    .//s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .//s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .//d SetAHSLOperDT
	.//s transInfo=##Class(web.DHCClinicCom).GetTransInfoByTime(EpisodeID,anopStartDate,anopStartTime)
	.//i +transInfo s opaInfoId=+transInfo
    .s opaInfo=$p($g(^CTLOC(+opaInfoId)),"^",2)
    .i (ifShowShortLocDesc)&&($l(opaInfo,"-")>1) s opaInfo=$p(opaInfo,"-",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="SurgonLoc" d   //术者科室
    .i $d(inquiryInfoList(opaId,anciiCode,1)) d
    ..s opaInfoId=$p(inquiryInfoList(opaId,anciiCode,1),"^",1)
    ..s opaInfo=$p(inquiryInfoList(opaId,anciiCode,1),"^",2)
    .e  d
    ..s opaInfoId=$p($g(^DHCANOPArrange(opaId)),"^",86)
    ..s opaInfo=$p($g(^CTLOC(+opaInfoId)),"^",2)
    ..i (ifShowShortLocDesc)&&($l(opaInfo,"-")>1) s opaInfo=$p(opaInfo,"-",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="Ward" d  //术前病人所在病区
	.s opaInfoId=$p($g(^PAADM(EpisodeID)),"^",70)
	.s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .//d SetAHSLOperDT  //特殊  安徽省立
	.s transInfo=##Class(web.DHCClinicCom).GetTransInfoByTime(EpisodeID,anopStartDate,anopStartTime)
	.i +$p(transInfo,"^",2) s opaInfoId=+$p(transInfo,"^",2)
    .i opaInfoId'="" s opaInfo=$P(^PAWARD(opaInfoId),"^",1)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="Hospital" d   //医院
    .s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
    .s opaInfoId=$p($g(^CTLOC(+appLocId)),"^",22)
    .s opaInfo=$p($g(^CT("HOSP",+opaInfoId)),"^",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OperLoc" d   //手术科室
    .s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",+anaopSub)),"^",10)
    .s opaInfo=$p($g(^CTLOC(+opaInfoId)),"^",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OpLevel" d   //手术级别
    .s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",+anaopSub,"DHC")),"^",1)
    .//s opaInfoId=$p($g(^DHCANOPArrange(opaId)),"^",28)
    .//s opaInfo=$p($g(^DHCANC("OPLevel",+opaInfoId)),"^",2) //现在标准版不再使用
    .s opaInfo=$p($g(^ORC("CATEG",+opaInfoId)),"^",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="ANMethod"  d   //麻醉方法
    .s curANMethodIdStr=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",5)
    .f dNum=1:1:$l(curANMethodIdStr,"|")   d
    ..s opaInfoId=$p(curANMethodIdStr,"|",dNum)
    ..s opaInfo=$p($g(^ORC("ANMET",+opaInfoId)),"^",2)
    ..q:opaInfoId=""
    ..q:(dNum>1)&&(anciiDataField="First") //只取第一个
    ..i $p(opaInfo,"-",2)'="" s opaInfo=$p(opaInfo,"-",2)
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(dNum)=opaInfoId_"^"_opaInfo
    .i (curANMethodIdStr="") d
    ..s opaInfoId=""
    ..s opaInfo="无麻醉方法"
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="AnaestType"  d  //麻醉方法类型
    .s curANMethodIdStr=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",5)
    .f dNum=1:1:$l(curANMethodIdStr,"|")   d
    ..s anMethodId=$p(curANMethodIdStr,"|",dNum)
    ..q:anMethodId=""
    ..s anMethod=$p($g(^ORC("ANMET",+anMethodId)),"^",2)
    ..s opaInfoId=$p($g(^ORC("ANMET",+anMethodId)),"^",3)
    ..s opaInfo=$p($g(^ORC("ANTYPE",+opaInfoId)),"^",2)
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(+opaInfoId)=opaInfoId_"^"_opaInfo
    ..s opaInfoList(+opaInfoId_"_"_+anMethodId)=opaInfoId_"_"_anMethodId_"^"_opaInfo_"-"_anMethod
    .i (curANMethodIdStr="") s opaInfoList(1)="^"
    e  i anciiCode="SourceType"  d   //手术类型(急诊、择期)
    .s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",32)
    .i opaInfoId="E" s opaInfo="急诊"
    .e  s opaInfo="择期"
    .//特殊   安徽省立
    .//s opaInfoId=$P(^DHCANARRAGE("ch",opaId),"^",5)
    .//i opaInfoId="1" s opaInfo="急诊"
	.//e  s opaInfo="择期"
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OperNote" d   //手术备注
    .s anaopSub=""
    .f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:((anaopSub=""))  d
    ..s opaInfoId=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",1))
    ..s opaInfo=opaInfoId
    ..s ifMatch=$$MatchMultipleValue()||$$FuzzyMatch()
    ..s ifFind=ifFind||ifMatch
    ..s opaInfoList(anaopSub)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OpName"  d   //手术名称
    .s anaopSub=0,operQty=0,operIdStr="",operNameStr=""
    .f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:((anaopSub=""))  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)
    ..i opaInfoId'=""  d
    ...s opaInfo=$p($g(^ORC("OPER",+opaInfoId)),"^",2)   //手术名称
    ..e  d
    ...i $g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",1))'="" d
    ....s opaInfo=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",1)) //自定义手术名称
    ...i $g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2))'="" d
    ....s opaInfo=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)) //自定义手术名称
    ..s:operIdStr'="" operIdStr=operIdStr_"|",operNameStr=operNameStr_"+"
    ..s operNameStr=operNameStr_opaInfo
    ..s operIdStr=operIdStr_opaInfoId
    .i $p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)>0 d
    ..s operIdStr=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",1)),"^",6)
    ..s operNameStr=$g(^OR(EpisodeID,"ANA",anaSub,"OP",1,"REM",2)) //自定义手术名称
    .f k=1:1:$l(operIdStr,"|")  d
    ..s opaInfoId=$p(operIdStr,"|",k)
    ..s opaInfo=$p(operNameStr,"+",k)
    ..s ifMatch=$$MatchMultipleValue()||$$FuzzyMatch()
    ..s operQty=operQty+ifMatch
    ..s ifFind=ifFind||ifMatch
    ..s ifAllMatch=ifAllMatch&&ifMatch
    ..s opaInfoList(k)=opaInfoId_"^"_opaInfo
    .i anciiDataField="All" s ifFind=ifAllMatch
    .s itemQtyStatList(searchLevel)=operQty
    e  i anciiCode="PlanOpName"  d    //拟施手术
    .s anaopSub=""
    .f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:((anaopSub=""))  d
    ..s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC")),"^",2)
    ..s opaInfo=$p(^ORC("OPER",+opaInfoId),"^",2)
    ..i +opaInfoId=0 s opaInfo=opaInfoId
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s ifFind=ifFind||$$FuzzyMatch()
    ..s opaInfoList(anaopSub)=opaInfoId_"^"_opaInfo
   	e  i anciiCode="IfOPAccordPlan"  d    //是否手术与拟施手术保持一致
   	.s anaopSub="",operQty=0,opaInfoId=1
   	.f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:((anaopSub=""))  d
    ..s operId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)
    ..i operId'=""  d
    ...s operDesc=$p($g(^ORC("OPER",+operId)),"^",2)   //手术名称
    ..e  d
    ...i $g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2))'="" d
    ....s operDesc=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)) //自定义手术名称
    ...i $g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",1))'="" d
    ....s operDesc=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",1)) //自定义手术名称
    ..s planOperId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC")),"^",2)
    ..s planOperDesc=$p(^ORC("OPER",+planOperId),"^",2)
    ..i +planOperId=0 s planOperDesc=planOperId
    ..i '(((+planOperId=+operId)&&(+planOperId>0))||(planOperDesc=operDesc)) s opaInfoId=0
    .s opaInfo=$s(opaInfoId=0:"否",1:"是")
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OpCat"  d   //手术分类
    .s anaopSub=0
    .f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
    ..q:(anciiDataField="First")&&(anaopSub>1)
    ..s opdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)
    ..i opdr'=""  d
    ...s opaInfoId=$p($g(^ORC("OPER",+opdr)),"^",7)   //手术分类Id
    ...s opaInfo=$p($g(^ORC("CATEG",+opaInfoId)),"^",2)   //手术分类
    ...s ifFind=ifFind||$$MatchMultipleValue()
    ...s opaInfoList(anaopSub)=opaInfoId_"^"_opaInfo
    ..e  d
    ...s opaInfoList(anaopSub)="^"
    e  i anciiCode="OperPosition"  d   //手术体位
    .s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
    .i opaInfoId'="" s opaInfo=$p($g(^ORC("OPPOS",+opaInfoId)),"^",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OperBodySite"  d   //手术部位
    .s bodsIdList=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",24)
    .f bodsNum=1:1:$l(bodsIdList,"|") d
    ..s opaInfoId=$p(bodsIdList,"|",bodsNum)
    ..i opaInfoId'="" s opaInfo=$p($g(^OEC("BODS",+opaInfoId)),"^",2)
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(bodsNum)=opaInfoId_"^"_opaInfo
    e  i anciiCode="BladeType" d    //手术切口
    .s anaopSub=0
    .f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:((anaopSub=""))  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",9)
    ..s opaInfo=$p($g(^ORC("BLDTP",+opaInfoId)),"^",2)
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(anaopSub)=opaInfoId_"^"_opaInfo
    e  i anciiCode="NNIS" d     //NNIS手术风险评分
    .s anaopSub=0,bladeScore=0
    .f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:((anaopSub=""))  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",9)
    ..s bladeScoreSub=$s(opaInfoId<27:0,opaInfoId=27:1,1:0)
    ..i bladeScore<bladeScoreSub s bladeScore=bladeScoreSub
    .s asaScore=0
    .s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",26)
    .s asaScore= opaInfoId>2
    .s operTimeScore=0
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",19)   //手术开始时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",20)   //手术结束时间
    .s opaInfoId=$$CaculateDateTimeStatInfo(anopStartDate,anopStartTime,anopEndDate,anopEndTime,specialTimeScale)
    .s operTimeScore=opaInfoId>3
    .
    .s opaInfoId=bladeScore+asaScore+operTimeScore
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OpRoom"  d   //手术间
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",20)           //手术间
    .i opaInfoId'="" s opaInfo=$p($g(^DHCANC("OPRoom",+opaInfoId)),"^",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="Device"  d    //监护设备
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",20)           //手术间
    .i opaInfoId'="" s opaInfo=$p($g(^DHCANC("OPRoom",+opaInfoId)),"^",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)="01_"_opaInfoId_"^"_opaInfo_"监护仪"
    .s opaInfoList(2)="02_"_opaInfoId_"^"_opaInfo_"麻醉机"
    e  i anciiCode="PACUBed"  d   //恢复室床位
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",47)
    .i opaInfoId'="" s opaInfo=$p($g(^DHCANC("OPRoom",+opaInfoId)),"^",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="PreopDiag" d    //术前诊断
    .s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
    .q:+anaopSub=0
    .s preDiagdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",4)
    .s udfPreDiag=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",2)) //用户自定义术前诊断
    .f dNum=1:1:$l(preDiagdr,"|")  d
    ..s opaInfoId=$p(preDiagdr,"|",dNum)
    ..i opaInfoId=+opaInfoId s opaInfo=$p($g(^MRC("ID",+opaInfoId)),"^",2)
    ..e  s opaInfo=$p(udfPreDiag,"|",dNum)
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(dNum)=opaInfoId_"^"_opaInfo
    .s opaInfo=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",1))   //诊断备注
    .s opaInfoId=""
    .s opaInfoList("mem")=opaInfoId_"^"_opaInfo
    e  i anciiCode="PostopDiag" d   //术后诊断
    .s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
    .q:+anaopSub=0
    .s postDiagdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",5)
    .s udfPostDiag=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",3)) //用户自定义术后诊断
    .f dNum=1:1:$l(postDiagdr,"|")  d
    ..s opaInfoId=$p(postDiagdr,"|",dNum)
    ..i opaInfoId=+opaInfoId s opaInfo=$p($g(^MRC("ID",+opaInfoId)),"^",2)
    ..e  s opaInfo=$p(udfPostDiag,"|",dNum)
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(dNum)=opaInfoId_"^"_opaInfo
    e  i anciiCode="IfPostDiagAccordPre" d     //是否术前术后诊断一致
    .s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
    .q:+anaopSub=0
    .s preDiagdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",4)
    .s udfPreDiag=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",2)) //用户自定义术前诊断
    .s postDiagdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",5)
    .s udfPostDiag=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",3)) //用户自定义术后诊断
    .s opaInfoId=((preDiagdr=postDiagdr)&&(udfPreDiag=udfPostDiag))
    .s opaInfo=$s(opaInfoId=0:"否",1:"是")
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="ASA" d   //ASA分级
    .s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",26)
    .s opaInfo=$p(^ORC("ASA",+opaInfoId),"^",2)
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="OperEquip" d   //手术设备
    .s opaeSub=0
    .f  s opaeSub=$o(^DHCANOPArrangeEquip(0,"Arrange",opaId,opaeSub)) q:((opaeSub=""))  d
    ..s opaInfoId=$lg(^DHCANOPArrangeEquip(opaeSub),2) //OPAE_ANCEquip_Dr
    ..s opaInfo=$lg(^DHCANC("Equip",+opaInfoId),3)  //ANCE_Desc
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(opaeSub)=opaInfoId_"^"_opaInfo
    .i ('$d(opaInfoList)) s opaInfoList(1)="^" //无查询结果为空
    e  i (anciiCode="StockCat")||(anciiCode="StockItem") d    //耗材类型 || 耗材  安贞
    .s stockItemId="",stockTotalQty=0
    .k itemQtyStatList(anciiCode)
    .f  s stockItemId=$o(^DHCANOPArrangeStock(0,"OPArrStockItem",opaId,stockItemId)) q:stockItemId=""  d
    ..q:'$d(^DHCANC("StockItem",stockItemId))
    ..i anciiCode="StockCat" d
    ...s opaInfoId=$lg($g(^DHCANC("StockItem",stockItemId)),6)
    ...s opaInfo=$lg($g(^DHCANC("StockCat",+opaInfoId)),2)
    ..i anciiCode="StockItem" d
    ...s opaInfoId=stockItemId
    ...s opaInfo=$lg($g(^DHCANC("StockItem",stockItemId)),2)
    ..
    ..s opasId="",stockQty=0
    ..f  s opasId=$o(^DHCANOPArrangeStock(0,"OPArrStockItem",opaId,stockItemId,opasId)) q:opasId=""  d
    ...s stockQty=stockQty+$lg(^DHCANOPArrangeStock(opasId),3)
    ..s matchMultiple=$$MatchMultipleValue()
    ..i matchMultiple s stockTotalQty=stockTotalQty+stockQty
    ..s ifFind=ifFind||matchMultiple
    ..s opaInfoList(+opaInfoId)=opaInfoId_"^"_opaInfo
    ..s itemQtyStatList(anciiCode,+opaInfoId)=$g(itemQtyStatList(anciiCode,+opaInfoId))+stockQty
    .//手术设备费用|造影剂id!造影剂名称#造影剂数目,造影剂id!造影剂名称#造影剂数目|支架数目|球囊数目|userID|$h
    .s stockInfo=$g(^DHCANOPArrange("StockItem",opaId))
    .s stockInfo=$p(stockInfo,"|",2)
    .f stockNum=1:1:$l(stockInfo,",") d
    ..s stockItemStr=$p(stockInfo,",",stockNum)
    ..s stockItemId=+$p(stockItemStr,"!",1)
    ..s stockQty=+$p(stockItemStr,"#",2)
    ..i anciiCode="StockCat" d
    ...s opaInfoId=$lg($g(^DHCANC("StockItem",stockItemId)),6)
    ...s opaInfo=$lg($g(^DHCANC("StockCat",+opaInfoId)),2)
    ..i anciiCode="StockItem" d
    ...s opaInfoId=stockItemId
    ...s opaInfo=$lg($g(^DHCANC("StockItem",stockItemId)),2)
    ..s matchMultiple=$$MatchMultipleValue()
    ..i matchMultiple s stockTotalQty=stockTotalQty+stockQty
    ..s ifFind=ifFind||matchMultiple
    ..s opaInfoList(+opaInfoId)=opaInfoId_"^"_opaInfo
    ..s itemQtyStatList(anciiCode,+opaInfoId)=stockQty
    .s itemQtyStatList(searchLevel)=stockTotalQty
    .s opaInfoId=stockTotalQty
    .s opaInfo=opaInfoId
    .i (ifFind)&&('$$MatchNoMinMaxCondition()) s ifFind=$$MatchMinMaxValue()
    e  i anciiCode="AZOpEquipFee" d  //手术设备费用
    .s stockInfo=$g(^DHCANOPArrange("StockItem",opaId))
    .s opaInfoId=+$p(stockInfo,"|",1)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s ifFind=ifFind||$$MatchMinMaxValue()
    .s itemQtyStatList(searchLevel)=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="AZStentQty" d  //支架数目
    .s stockInfo=$g(^DHCANOPArrange("StockItem",opaId))
    .s opaInfoId=+$p(stockInfo,"|",3)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s ifFind=ifFind||$$MatchMinMaxValue()
    .s itemQtyStatList(searchLevel)=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="AZBalloonQty" d  //球囊数目
    .s stockInfo=$g(^DHCANOPArrange("StockItem",opaId))
    .s opaInfoId=+$p(stockInfo,"|",4)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s ifFind=ifFind||$$MatchMinMaxValue()
    .s itemQtyStatList(searchLevel)=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="TimeSpan1" d  //8点到16点，周六（8点到12点）
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    .s opaInfoId=0
    .s periodStartDate=anopStartDate,periodStartTime=28800
    .s periodEndDate=anopStartDate,periodEndTime=57600
    .s dayInWeek=$zd(anopStartDate,10)
    .i dayInWeek=6 s periodEndTime=43200
    .s opaInfoId=$$GetCoincidedSpan(anopStartDate,anopStartTime,anopEndDate,anopEndTime,periodStartDate,periodStartTime,periodEndDate,periodEndTime)
    .s ifFind=(opaInfoId>0)
    .s opaInfo=opaInfoId
    .s itemQtyStatList(searchLevel)=opaInfoId_"^h"
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="TimeSpan2" d //16点到21点，周六（12点到16点）
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    .s opaInfoId=0
    .s periodStartDate=anopStartDate,periodStartTime=57600
    .s periodEndDate=anopStartDate,periodEndTime=75600
    .s dayInWeek=$zd(anopStartDate,10)
    .i dayInWeek=6 s periodStartTime=43200,periodEndTime=57600
    .s statInfo=$$GetCoincidedSpan(anopStartDate,anopStartTime,anopEndDate,anopEndTime,periodStartDate,periodStartTime,periodEndDate,periodEndTime)
    .s ifFind=(opaInfoId>0)
    .s opaInfo=opaInfoId
    .s itemQtyStatList(searchLevel)=opaInfoId_"^h"
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="TimeSpan3" d //21点到0点，周六（16点到21点）
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    .s opaInfoId=0
    .s periodStartDate=anopStartDate,periodStartTime=75600
    .s periodEndDate=anopStartDate+1,periodEndTime=0
    .s dayInWeek=$zd(anopStartDate,10)
    .i dayInWeek=6 s periodStartTime=57600,periodEndTime=75600
    .s opaInfoId=$$GetCoincidedSpan(anopStartDate,anopStartTime,anopEndDate,anopEndTime,periodStartDate,periodStartTime,periodEndDate,periodEndTime)
    .s ifFind=(opaInfoId>0)
    .s opaInfo=opaInfoId
    .s itemQtyStatList(searchLevel)=opaInfoId_"^h"
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="TimeSpan4" d //0点到8点，周六（21点到8点）
    .s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    .s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    .s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    .s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)   //出室时间
    .s opaInfoId=0
    .//当天0~8点
    .s periodStartDate=anopStartDate,periodStartTime=0
    .s periodEndDate=anopStartDate,periodEndTime=28800
    .s opaInfoId=$$GetCoincidedSpan(anopStartDate,anopStartTime,anopEndDate,anopEndTime,periodStartDate,periodStartTime,periodEndDate,periodEndTime)
    .//后一天0~8点
    .s periodStartDate=anopStartDate+1,periodStartTime=0
    .s periodEndDate=anopStartDate+1,periodEndTime=28800
    .s dayInWeek=$zd(anopStartDate,10)
    .i dayInWeek=6 s periodStartDate=anopStartDate,periodStartTime=75600
    .s opaInfoId=opaInfoId+$$GetCoincidedSpan(anopStartDate,anopStartTime,anopEndDate,anopEndTime,periodStartDate,periodStartTime,periodEndDate,periodEndTime)
    .s ifFind=(opaInfoId>0)
    .s opaInfo=opaInfoId
    .s itemQtyStatList(searchLevel)=opaInfoId_"^h"
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="MedicalSafety" d   //麻醉非预期事件
    .s rowId=""
    .f  s rowId=$o(^DHCCLMedicalSafety(0,"OPA",opaId,rowId)) q:((rowId=""))  d
    ..s opaInfoId=$li(^DHCCLMedicalSafety(rowId),7)
    ..s opaInfo=$li(^DHCCLC("MedicalSafety",opaInfoId),2)
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(rowId)=opaInfoId_"^"_opaInfo
    e  i anciiCode="PickUpPrint" d   //安徽省立  是否已打印接病人单
	.s opaInfoId=+$g(^DHCANOPArrange("PickUpPrint",opaId))
	.s opaInfo=$s(opaInfoId:"已打印",1:"未打印")
	.s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="CASignUser" d    //CA签名人  温岭
    .s signId=$$GetLatestCASignId()
    .s opaInfoId=""
    .i signId>0 s opaInfoId=$lg(^DHCCLSignLog(signId),6)
    .s opaInfo=opaInfoId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="CASignTime" d    //CA签名时间  温岭
    .s signId=$$GetLatestCASignId()
    .s opaInfoId=""
    .i signId>0 d
    ..s anopStartDate=$lg(^DHCCLSignLog(signId),5)   //签名日期
    ..s anopStartTime=$lg(^DHCCLSignLog(signId),4)   //签名时间
    ..s anopEndDate=anopStartDate
    ..s anopEndTime=anopStartTime
    .s opaInfoId=anopStartDate_","_anopStartTime
    .s opaInfo=$zd(anopStartDate,3)_" "_$zt(anopStartTime)
    .s ifFind=ifFind||$$MatchANOPDateTime()
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="StatisticValue" d    //统计汇总值 仅供二次条件项筛选时调用
    .s opaInfo=$lg(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",statSearchLevel,opaSeqNo),2)
    .s opaInfoId=$p(opaInfo,"^",2)
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  d
    .i $d(^DHCCLSet("AnOp","ANCInquiry","OPA",anciiCode)) d   //其他非特殊DHCANOPArrange表数据直接通过字段名获取
    ..s Index = ^DHCCLSet("AnOp","ANCInquiry","OPA",anciiCode)
    ..i $l(Index,"^")=1 s opaInfoId = $p($g(^DHCANOPArrange(opaId)),"^",+Index)
    ..e  i $l(Index,"^")=2 s opaInfoId = $p($g(^DHCANOPArrange(opaId,$p(Index,"^",1))),"^",+$p(Index,"^",2))
    .i $d(^DHCCLSet("AnOp","ANCInquiry","ANI",anciiCode)) d   //其他非特殊DHCANAnestItem表数据直接通过字段名获取
    ..s Index = ^DHCCLSet("AnOp","ANCInquiry","ANI",anciiCode)
    ..s aniSubId = $o(^DHCANOPArrange(opaId,"ANI",""),-1)
    ..i $l(Index,"^")=1 s opaInfoId = $p($g(^DHCANOPArrange(opaId,"ANI",+aniSubId)),"^",+Index)
    .//使用新版手麻的话这里才有用
    .i $d(^DHCANOPArrangeExtend(0,"OPACode",opaId,anciiCode)) d   //DHCANOPArrangeExtend表数据直接通过配置代码获取
    ..s opaInfoId=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,anciiCode)
    ..s opaInfoId=$p(opaInfoId,$c(3),1)
    .s opaInfo=opaInfoId
    .s:anciiCode="OPA.AnMethodDetail1" opaInfo=$s(opaInfoId="11":"气管",opaInfoId="12":"喉罩",opaInfoId="13":"支气管",opaInfoId="14":"其他",1:"")
    .s:anciiCode="OPA.AnMethodDetail3" opaInfo=$s(opaInfoId="31":"腰硬联合麻醉",opaInfoId="32":"硬膜外麻醉",opaInfoId="33":"腰麻",opaInfoId="34":"其他",1:"")
    .s:anciiCode="OPA.AnMethodDetail4" opaInfo=$s(opaInfoId="41":"全麻+椎管内",opaInfoId="42":"全麻+神经阻滞",opaInfoId="43":"其他",1:"")
    .s:anciiCode="OPA.AnMethodDetail5" opaInfo=$s(opaInfoId="51":"神经阻滞",opaInfoId="52":"MAC",opaInfoId="53":"其他",1:"")
    .d SetInOutSummary
    .i $d(InOutSummaryList(anciiCode)) d
    ..s opaInfoId=$p(InOutSummaryList(anciiCode),"^",1)
    ..s opaInfo=opaInfoId_$p(InOutSummaryList(anciiCode),"^",2)
    ..s itemQtyStatList(searchLevel)=InOutSummaryList(anciiCode)
    .s ifFind=ifFind||$$MatchMinMaxValue()
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s ifFind=ifFind||$$HeaderMatch() //文字信息 匹配是否以参考值为起始字符 //特殊 //潍坊
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    q ifFind
    
GetLatestCASignId()
	s signId="",findSignId=""
	f  s signId=$o(^DHCCLSignLog(0,"Sign",opaId,signId),-1) q:((signId="")||(findSignId'=""))  d
	.s signDoc=$lg(^DHCCLSignLog(signId),2)
	.s signStatus=$lg(^DHCCLSignLog(signId),3)
	.i (signDoc="麻醉前访视单")&&(signStatus="签名成功") s findSignId=signId
	
	q findSignId
    
SetInOutSummary()
    i '$d(InOutSummaryList) d
    .s inOutId=""
    .f  s inOutId=$o(^DHCANOPArrange(opaId,"InOut",inOutId)) q:(inOutId="")  d
    ..s inOutCode=$p(^DHCANOPArrange(opaId,"InOut",inOutId),"^",1)
    ..s inOutDesc=$p(^DHCANOPArrange(opaId,"InOut",inOutId),"^",2)
    ..s inOutValue=$p(^DHCANOPArrange(opaId,"InOut",inOutId),"^",3)
    ..s inOutUom="ml"
    ..i "^RedBloodCell^BloodCoaplationFactor^"[("^"_inOutCode_"^") s inOutUom="单位"
    ..s InOutSummaryList(inOutCode)=inOutValue_"^"_inOutUom
    q
    
JudgeICDInfo(opaId)
    s ifFind=0,opaInfoId="",opaInfo=""
    i anciiCode="OperICD" d   //手术ICD
    .s anaopSub=""
    .f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:((anaopSub=""))  d
    ..s opdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)
    ..s opaInfoId=$p($g(^ORC("OPER",+opdr)),"^",14)  //ICD10
    ..s opaInfo=$p($g(^ORC("OPER",+opdr)),"^",2)
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="PreDiagICD"  d   //术前诊断ICD
    .s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
    .q:+anaopSub=0
    .s preDiagdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",4)
    .f dNum=1:1:$l(preDiagdr,"|")  d
    ..s opaInfoId=$p($g(^MRC("ID",+$p(preDiagdr,"|",dNum))),"^",4)  //MRCID_ICD9CM_Code
    ..s opaInfo=$p($g(^MRC("ID",+$p(preDiagdr,"|",dNum))),"^",2)
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(1)=opaInfoId_"^"_opaInfo
    e  i anciiCode="PostDiagICD"  d   //术后诊断ICD
    .s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
    .q:+anaopSub=0
    .s postDiagdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",5)
    .f dNum=1:1:$l(postDiagdr,"|")  d
    ..s opaInfoId=$p($g(^MRC("ID",+$p(postDiagdr,"|",dNum))),"^",4)  //MRCID_ICD9CM_Code
    ..s opaInfo=$p($g(^MRC("ID",+$p(postDiagdr,"|",dNum))),"^",2)
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s opaInfoList(1)=opaInfoId_"^"_opaInfo
    q ifFind
    
JudgeOperationList(opaId)
	s ifFind=0,opaInfoId="",opaInfo=""
	d GetOperationList
	q ifFind
	
GetOperationList
	s anaopSub=0
	i $d(operationList(lastAnciiSub)) d
	.f  s anaopSub=$o(operationList(lastAnciiSub,anaopSub)) q:anaopSub=""  d
	..i $$JudgeSingleOperation(anaopSub) s operationList(anciiSub,anaopSub)="",ifFind=1
	e  d
	.f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	..i $$JudgeSingleOperation(anaopSub) s operationList(anciiSub,anaopSub)="",ifFind=1
	q
	
JudgeSingleOperation(anaopSub)
	s isMatched=0
	i anciiCode="OperName"  d //手术名称
	.s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)
	.s opaInfo=$p(^ORC("OPER",+opaInfoId),"^",2)
	.s isMatched=isMatched||$$FuzzyMatch()
	e  i anciiCode="OperLevel"  d //手术级别
	.s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",+anaopSub,"DHC")),"^",1)
	.s opaInfo=$p($g(^DHCANC("OPLevel",+opaInfoId)),"^",2)
	e  i anciiCode="OperBlade"  d //安贞手术切口
	.s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",9)
    .s opaInfo=$p($g(^ORC("BLDTP",+opaInfoId)),"^",2)
	e  i anciiCode="SurgeonLocAZ"  d //安贞术者科室
	.s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",+anaopSub,"DHC")),"^",7)
	.s opaInfo=$p($g(^CTLOC(+opaInfoId)),"^",2)
	e  i anciiCode="PlanSurgeonAZ"  d //安贞拟施术者
	.s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",+anaopSub,"DHC")),"^",8)
	.s opaInfo=$p($g(^CTLOC(+opaInfoId)),"^",2)
	e  i anciiCode="OperTechAZ"  d //安贞手术技术
	.s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",+anaopSub,"DHC")),"^",9)
	.s opaInfo=$p($g(^CTLOC(+opaInfoId)),"^",2)
	e  i anciiCode="OperType"  d //手术操作类型
	.s operId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)
	.s opaInfoId=$p(^ORC("OPER",+opaInfoId,"DHC"),"^",11)
	.s opaInfo=$s(opaInfoId="N":"常规",opaInfoId="D":"诊断性操作",opaInfoId="T":"治疗性操作")
	e  i anciiCode="OperCatAZ"  d //安贞手术分类
	.s operId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)
	.s opaInfoId=$p(^ORC("OPER",+opaInfoId,"DHC"),"^",16)
	.s opaInfo=$lg(^DHCANC("OperationCat",+opaInfoId),2)
	
	s ifMatched=ifMatched||$$MatchMultipleValue()
    s opaInfoList(anaopSub)=opaInfoId_"^"_opaInfo
	
	q ifMatched
    
JudgeOEOrderInfo(opaId)
    s oeordId="",ifFind=0,opaInfo=""
    s oeordId=+$o(^OEORDi(0,"Ana",EpisodeID_"||"_anaSub,oeordId))
    i oeordId=0 q ifFind
    i anciiCode="OEOrderBill" d   //医嘱费用
    .k currentOEOrderList
    .m currentOEOrderList=oeoOrdList(lastAnciiSub)
    .i lastAnciiSub=0 d GetOEOrderItem
    .s ifFind=0
    .s opaInfoId=$$GetOEOrderBillStatInfo(1)
    .m ^DHCANInquiry(anciId,"OpaInfo",opaId,anciiSub)=opaInfoList
    .s ifFind=ifFind||$$MatchMinMaxValue()
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfo=opaInfoId
    .k opaInfoList
    .s opaInfoList("total")=opaInfoId_"^"_opaInfo
    e  i anciiCode="OEOrderQty" d   //医嘱数量
    .k currentOEOrderList
    .m currentOEOrderList=oeoOrdList(lastAnciiSub)
    .i lastAnciiSub=0 d GetOEOrderItem
    .s ifFind=0
    .d GetOEOrderBillStatInfo(1)
    .m ^DHCANInquiry(anciId,"OpaInfo",opaId,anciiSub)=opaInfoList
    .s opaInfoId=+$g(oeoOrdStatList("Total","Qty"))
    .s ifFind=ifFind||$$MatchMinMaxValue()
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfo=opaInfoId
    .k opaInfoList
    .s opaInfoList("total")=opaInfoId_"^"_opaInfo
    e  i anciiCode="OEOrderDetail" d   //医嘱明细显示
    .k currentOEOrderList
    .m currentOEOrderList=oeoOrdList(lastAnciiSub)
    .i lastAnciiSub=0 d GetOEOrderItem
    .k opaInfoList
    .s opaInfoId=$$GetOEOrderBillStatInfo(1)
    .//b //after set opaInfoList
    .s ifFind=1
    e  d GetOEOrderItem
    
    q ifFind

GetOEOrderItem
    //根据日期取医嘱
    //f  s oeordId=$o(^OEORD(0,"Adm",+EpisodeID,oeordId)) q:oeordId=""  d
    //.f oeoDate=anciiStartDate:1:anciiEndDate  q:isQuit  d
    //..s oeoriSub=""
    //..f  s oeoriSub=$o(^OEORDi(0,"StDt",oeoDate,oeordId,oeoriSub)) q:((oeoriSub="")||isQuit)  d
    //...s oeoriSttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    //...q:((oeoDate=anciiStartDate)&&(oeoriSttTime<anciiStartTime))||((oeoDate=anciiEndDate)&&(oeoriSttTime<anciiEndTime))
    //
    s oeoriSub=""
    i $d(oeoOrdList(lastAnciiSub,oeordId)) d
    .f  s oeoriSub=$o(oeoOrdList(lastAnciiSub,oeordId,oeoriSub)) q:oeoriSub=""  d
    ..i $$JudgeSingleOEOrderItem() s oeoOrdList(anciiSub,oeordId,oeoriSub)="",ifFind=1
    e  d
    .f  s oeoriSub=$o(^OEORDi(0,"Ana",EpisodeID_"||"_anaSub,oeordId,oeoriSub)) q:oeoriSub=""  d
    ..i $$JudgeSingleOEOrderItem() s oeoOrdList(anciiSub,oeordId,oeoriSub)="",ifFind=1
    s oeoOrdList(anciiSub,oeordId)=""
    k currentOEOrderList
    m currentOEOrderList=oeoOrdList(anciiSub)
    //b //after oeorder select
    s opaInfoId=$$GetOEOrderBillStatInfo(0)
    //b //after set opaInfoList
    q
    
JudgeSingleOEOrderItem()
	s ifMatchOEOrderItem=1,opaInfoId="",opaInfo=""
    s oeoriSttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
    s oeoriSttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    q:('$$MatchNoTimeConditon())&&(anciiStartDate>0)&&((oeoriSttDate+(0.00001*oeoriSttTime))<(anciiStartDate+(0.00001*anciiStartTime))) 0
    q:('$$MatchNoTimeConditon())&&(anciiEndDate>0)&&((oeoriSttDate+(0.00001*oeoriSttTime))>(anciiEndDate+(0.00001*anciiEndTime))) 0
    s itemstatus=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
    q:("^2^12^"[("^"_itemstatus_"^")) 0 //医嘱状态 作废、撤消
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)  //医嘱项Id
    s arcimDesc=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)
    s arcitemcatId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",10) //医嘱子分类
    i (anciiCode="UserAdd") d  //开单人
    .s opaInfoId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    .s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .s ifMatchOEOrderItem=$$MatchMultipleValue()
    e  i (anciiCode="UserDept") d  //开单科室
    .s opaInfoId=$p(^OEORD(oeordId,"I",oeoriSub,7),"^",2)
    .s opaInfo=$p($g(^CTLOC(+opaInfoId)),"^",2)
    .i (ifShowShortLocDesc)&&($l(opaInfo,"-")>1) s opaInfo=$p(opaInfo,"-",2)
    .s ifMatchOEOrderItem=$$MatchMultipleValue()
    e  i (anciiCode="RecDept") d  //接收科室
    .s opaInfoId=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",6)
    .s opaInfo=$p($g(^CTLOC(+opaInfoId)),"^",2)
    .i (ifShowShortLocDesc)&&($l(opaInfo,"-")>1) s opaInfo=$p(opaInfo,"-",2)
    .s ifMatchOEOrderItem=$$MatchMultipleValue()
    e  i (anciiCode="ArcimId") d  //医嘱项Id
    .s opaInfoId=arcimId
    .s opaInfo=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)
    .s ifMatchOEOrderItem=$$MatchMultipleValue()
    e  i (anciiCode="ArcimCat") d  //医嘱子分类
    .s opaInfoId=arcitemcatId
    .s opaInfo=$p($g(^ARC("IC",+opaInfoId)),"^",2)
    .s ifMatchOEOrderItem=$$MatchMultipleValue()
    e  i (anciiCode="OEOrderType") d  //医嘱类型
    .s opaInfoId=$p($g(^ARC("IC",+arcitemcatId)),"^",7)
    .s opaInfo=$S(opaInfoId="R":"药品医嘱",opaInfoId="I":"注射医嘱",opaInfoId="L":"检验医嘱",opaInfoId="N":"普通医嘱",1:opaInfoId)
    .s ifMatchOEOrderItem=$$MatchMultipleValue()
    e  i (anciiCode="OEOrderCat") d  //医嘱分类
    .s opaInfoId=$p($g(^ARC("IC",+arcitemcatId)),"^",8)
    .s opaInfo=$p($g(^OEC("ORCAT",+opaInfoId)),"^",2)
    .s ifMatchOEOrderItem=$$MatchMultipleValue()
    e  i (anciiCode="EMCCat") d   //核算分类
    .s tarItemId=""
    .f  s tarItemId=$o(^DHCOLT(0,"ARTTA",arcimId,tarItemId)) q:tarItemId=""  d
    ..s opaInfoId=$p($g(^DHCTARI(tarItemId)),"^",16)
    ..s opaInfo=$p($g(^DHCTarC("EC",+opaInfoId)),"^",2)
    ..s ifMatchOEOrderItem=ifMatchOEOrderItem || $$MatchMultipleValue()
    ..s opaInfoList(tarItemId)=opaInfoId_"^"_opaInfo
    
    
    i (ifMatchOEOrderItem)&&('$d(opaInfoList)) s opaInfoList(oeoriSub)=opaInfoId_"^"_opaInfo
    
    q ifMatchOEOrderItem
    
GetOEOrderBillStatInfo(ifSetDetail)
    s oeorderBill=0,oeorderQty=0,oeorderDoseQty=0
    s oeordId=+$o(^OEORDi(0,"Ana",EpisodeID_"||"_anaSub,""))
    i oeordId=0 q oeorderBill
    s oeoriSub=""
    //b //in bill stat
    k oeoOrdStatList
    i $o(currentOEOrderList(oeordId,""))'="" d
    .f  s oeoriSub=$o(currentOEOrderList(oeordId,oeoriSub)) q:oeoriSub=""  d
    ..s oeoriId=oeordId_"||"_oeoriSub
    ..s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    ..s doseUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
    ..s doseUom=$p($g(^CT("UOM",+doseUomId)),"^",2)
    ..s qty=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)  //OEORI_QtyPackUOM 药品医嘱数量
    ..s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    ..i qty<=0 s qty=##class(web.DHCANOPCom).CaculatePackQty(arcimId,doseUomId,doseQty)
    ..i qty<=0 s qty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)  //OEORI_PhQtyOrd  其他医嘱数量
    ..s arcimDesc=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)
    ..s baseUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
    ..s baseUom=$p($g(^CT("UOM",+baseUomId)),"^",2)
    ..s prioId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8) //医嘱类型 临时 长期
    ..s oecprcode=$p($g(^OECPR(+prioId)),"^",1)
    ..s oeoreBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",1)),"^",6) //oeore_billed
    ..i oeoreBilled="" s oeoreBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5) //oeori_billed
    ..//b //in order billed quit
    ..q:(oeoreBilled'="P")&&(oeoreBilled'="B") //账单状态 "TB:未账单  B:已账单  P:已收费  R:已退费  I:已停医嘱"
    ..s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25) //医嘱费用
    ..s price=0
    ..i +oeoriPrice>0 s price=+oeoriPrice
    ..//取费用详细，暂时不用，只取账单费用
    ..//s price=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice)
    ..s pbosub=0,pbrowid=0
    ..s pbrowid=+$o(^DHCPBi(0,"OEORI",oeoriId,""))
    ..i pbrowid'="" s pbosub=$o(^DHCPBi(0,"OEORI",oeoriId,pbrowid,""),-1)
    ..i pbosub'="" s price=$p($g(^DHCPB(pbrowid,"O",pbosub)),"^",8)
    ..s oeorderQty=oeorderQty+qty
    ..s oeorderDoseQty=oeorderDoseQty+doseQty
    ..s oeorderBill=oeorderBill+price
    ..//b //calculate bill
    ..s userAdd=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)  //开单人
    ..s userDept=$p(^OEORD(oeordId,"I",oeoriSub,7),"^",2) //开单科室
    ..s recDept=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",6) //接收科室
    ..s arcitemcatId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",10) //医嘱子分类
    ..s ordtype=$p($g(^ARC("IC",arcitemcatId)),"^",7)   //医嘱类型
    ..s oecCatId=$p($g(^ARC("IC",+arcitemcatId)),"^",8) //医嘱分类
    ..i ifSetDetail s opaInfoList(oeoriSub)=oeordId_"||"_oeoriSub_"^"_arcimDesc_" "_doseQty_doseUom_" 总价:"_price_"元"
    ..s oeoOrdStatList("ArcimId",arcimId,"BaseUom")=baseUomId_"^"_baseUom
    ..s oeoOrdStatList("ArcimId",arcimId,"DoseUom")=doseUomId_"^"_doseUom
    ..s oeoOrdStatList("ArcimId",arcimId,"Qty")=+$g(oeoOrdStatList("ArcimId",arcimId,"Qty"))+qty
    ..s oeoOrdStatList("ArcimId",arcimId,"DoseQty")=+$g(oeoOrdStatList("ArcimId",arcimId,"DoseQty"))+doseQty
    ..s oeoOrdStatList("ArcimId",arcimId,"Bill")=+$g(oeoOrdStatList("ArcimId",arcimId,"Bill"))+price
    ..s oeoOrdStatList("UserAdd",+userAdd,"Bill")=+$g(oeoOrdStatList("UserAdd",+userAdd,"Bill"))+price
    ..s oeoOrdStatList("UserDept",+userDept,"Bill")=+$g(oeoOrdStatList("UserDept",+userDept,"Bill"))+price
    ..s oeoOrdStatList("RecDept",+recDept,"Bill")=+$g(oeoOrdStatList("RecDept",+recDept,"Bill"))+price
    ..s oeoOrdStatList("ArcimCat",+arcitemcatId,"Bill")=+$g(oeoOrdStatList("ArcimCat",+arcitemcatId,"Bill"))+price
    ..i ordtype'="" s oeoOrdStatList("OEOrderType",ordtype,"Bill")=+$g(oeoOrdStatList("OEOrderType",ordtype,"Bill"))+price
    ..s oeoOrdStatList("OEOrderCat",+oecCatId,"Bill")=+$g(oeoOrdStatList("OEOrderCat",+oecCatId,"Bill"))+price
    
    //b //after get all oeorder
    s oeoOrdStatList("Total","Qty")=oeorderQty
    s oeoOrdStatList("Total","DoseQty")=oeorderDoseQty
    s oeoOrdStatList("Total","Bill")=oeorderBill
    q oeorderBill
    
JudgeDocInfo(opaId)
    //判断手术麻醉人员信息?
    s ifFind=0,opaInfoId="",opaInfo=""
    k careProvList
    s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
    q:'+anaopSub 0
    i anciiCode="Surgeon"  d   //手术医生
    .s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)      //手术医生
    .i opaInfoId'="" s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .e  s opaInfo=..ReplaceString($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ",""),opaInfoId=opaInfo  //手术医生备注(外来手术医生)
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s careProvList(+opaInfoId)="1"
    .s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AssistI"  d   //一助
    .s as=1
    .i $d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as)) d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(1)=opaInfoId_"^"_opaInfo
    ..s careProvList(+opaInfoId)="1"
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AssistII"  d   //二助
    .s as=2
    .i $d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as)) d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(1)=opaInfoId_"^"_opaInfo
    ..s careProvList(+opaInfoId)="1"
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AssistIII"  d   //三助
    .s as=3
    .i $d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as)) d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(1)=opaInfoId_"^"_opaInfo
    ..s careProvList(+opaInfoId)="1"
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AssistIV"  d   //四助
    .s as=4
    .i $d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as)) d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(1)=opaInfoId_"^"_opaInfo
    ..s careProvList(+opaInfoId)="1"
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AssistV"  d   //五助
    .s as=5
    .i $d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as)) d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(1)=opaInfoId_"^"_opaInfo
    ..s careProvList(+opaInfoId)="1"
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="OperIntern"  d   //手术实习进修 "张三，李四"  "张三 李四"  "张三,李四" "张三、李四" "张三；李四" "张三;李四"
    .s internStr=$p(^DHCANOPArrange(opaId),"^",42)
    .s internStr=..ReplaceString(internStr,"，",",")  //"张三，李四"
    .s internStr=..ReplaceString(internStr," ",",")   //"张三 李四"
    .s internStr=..ReplaceString(internStr,"、",",")  //"张三、李四"
    .s internStr=..ReplaceString(internStr,"；",",")  //"张三；李四"
    .s internStr=..ReplaceString(internStr,";",",")   //"张三;李四"
    .f internNum=1:1:$l(internStr,",") d
    ..s opaInfoId=$p(internStr,",",internNum)
    ..s opaInfo=opaInfoId
    ..s opaInfoList(internNum)=opaInfoId_"^"_opaInfo
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AllOperDoctor"  d   //所有手术医生
    .s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)      //手术医生
    .s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .e  s opaInfo=..ReplaceString($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //手术医生备注(外来手术医生)
    .s opaInfoList("OPDoc"_1)=opaInfoId_"^"_opaInfo
    .s opaInfoList("OPDoc"_1,"Flag","OPDoc")=""
    .s careProvList(+opaInfoId)="OPDoc"_1
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s isExistAssist=0
    .s as=0,opaFlag=""
    .f  s as=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as)) q:as=""  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaFlag=$s(as=1:"AssI",as=2:"AssII",as=3:"AssIII",as=4:"AssIV",as=5:"AssV",1:"AssO")
    ..i opaFlag="" s opaFlag="OPAss"
    ..q:opaInfoId="" //当助手为空时不加入统计
    ..s careProvList(+opaInfoId)="OPAss"_as
    ..s opaInfoList("OPAss"_as)=opaInfoId_"^"_opaInfo
    ..s opaInfoList("OPAss"_as,"Flag",opaFlag)=""
    ..s isExistAssist=1
    ..s ifFind=ifFind||$$MatchMultipleValue()
    .//i ('isExistAssist) s opaInfoList("OPAss0")="^",opaInfoList("OPAss0","Flag","OPAss")=""
    .s internStr=$p(^DHCANOPArrange(opaId),"^",42)
    .s internStr=..ReplaceString(internStr,"，",",")  //"张三，李四"
    .s internStr=..ReplaceString(internStr," ",",")   //"张三 李四"
    .s internStr=..ReplaceString(internStr,"、",",")  //"张三、李四"
    .s internStr=..ReplaceString(internStr,"；",",")  //"张三；李四"
    .s internStr=..ReplaceString(internStr,";",",")   //"张三;李四"
    .f internNum=1:1:$l(internStr,",") d
    ..s opaInfoId=$p(internStr,",",internNum)
    ..q:opaInfoId=""
    ..s opaInfo=opaInfoId_"(实习进修)"
    ..s opaInfoList("OPIntern"_internNum)=opaInfoId_"^"_opaInfo
    ..s opaInfoList("OPIntern"_internNum,"Flag","OPIntern")=""
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AppDoctor"  d   //申请医生
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",6)  //OPA_AppCtcp_Dr 申请医师
    .s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AuditDoctor"  d   //审核医生
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",14)  //审核医生 ss_user表Id
    .s opaInfo=$p($g(^SSU("SSUSR",+opaInfoId)),"^",2)
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="ANDoc"  d   //麻醉医生
    .s opaInfoId=+$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",6)  //ANA_Anaesthetist_Dr   麻醉医师
    .s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s careProvList(+opaInfoId)="1"
    .s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="ANSupervisor"  d   //麻醉指导
    .s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",7)  //ANA_Supervisor_Dr  麻醉辅导医师
    .s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s careProvList(+opaInfoId)="1"
    .s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="ANAssist"  d   //麻醉助手
    .s as=0
    .f  s as=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",as))  q:((as="")||(as>20))  d
    ..s opaInfoId=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",as))
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(as)=opaInfoId_"^"_opaInfo
    ..s careProvList(+opaInfoId)=as
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AnaestIntern"  d   //麻醉实习进修 "张三，李四"  "张三 李四"  "张三,李四" "张三、李四" "张三；李四" "张三;李四"
    .s internStr=$p(^DHCANOPArrange(opaId),"^",43)
    .s internStr=..ReplaceString(internStr,"，",",")  //"张三，李四"
    .s internStr=..ReplaceString(internStr," ",",")   //"张三 李四"
    .s internStr=..ReplaceString(internStr,"、",",")  //"张三、李四"
    .s internStr=..ReplaceString(internStr,"；",",")  //"张三；李四"
    .s internStr=..ReplaceString(internStr,";",",")   //"张三;李四"
    .f internNum=1:1:$l(internStr,",") d
    ..s opaInfoId=$p(internStr,",",internNum)
    ..s opaInfo=opaInfoId
    ..s opaInfoList(internNum)=opaInfoId_"^"_opaInfo
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AllANDoctor"  d   //所有麻醉医生
    .k careProvList
    .s opaInfoId=+$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",6)  //ANA_Anaesthetist_Dr   麻醉医师
    .s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .s opaInfoList("ANDoc"_1)=opaInfoId_"^"_opaInfo
    .s opaInfoList("ANDoc"_1,"Flag","ANDoc")=""
    .//s opaInfoList("ANDoc"_1,"Flag","ANS_A_1")=""
    .s careProvList(+opaInfoId)="ANDoc"_1
    .s ifFind=ifFind||$$MatchMultipleValue()
    .//d SetCareProvShift("A")
    .
    .k careProvList
    .s opaInfoId=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",7)  //ANA_Supervisor_Dr  麻醉辅导医师
    .s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .i (opaInfoId'="") d
    ..s opaInfoList("ANSuper"_1)=opaInfoId_"^"_opaInfo
    ..s opaInfoList("ANSuper"_1,"Flag","ANSuper")=""
    ..//s opaInfoList("ANSuper"_1,"Flag","ANS_SA_1")=""
    ..s careProvList(+opaInfoId)="ANSuper"_1
    .s ifFind=ifFind||$$MatchMultipleValue()
    .//d SetCareProvShift("SA")
    .
    .k careProvList
    .s isExistAssist=0
    .s as=0
    .f  s as=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",as)) q:as=""  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",as),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList("ANAss"_as)=opaInfoId_"^"_opaInfo
    ..s opaInfoList("ANAss"_as,"Flag","ANAss")=""
    ..//s opaInfoList("ANAss"_as,"Flag","ANS_AA_1")=""
    ..s careProvList(+opaInfoId)="ANAss"_as
    ..s isExistAssist=1
    ..s ifFind=ifFind||$$MatchMultipleValue()
    .//d SetCareProvShift("AA")
    .//i ('isExistAssist) s opaInfoList("ANAss0")="^",opaInfoList("ANAss0","Flag","ANAss")=""
    .s internStr=$p(^DHCANOPArrange(opaId),"^",43)
    .s internStr=..ReplaceString(internStr,"，",",")  //"张三，李四"
    .s internStr=..ReplaceString(internStr," ",",")   //"张三 李四"
    .s internStr=..ReplaceString(internStr,"、",",")  //"张三、李四"
    .s internStr=..ReplaceString(internStr,"；",",")  //"张三；李四"
    .s internStr=..ReplaceString(internStr,";",",")   //"张三;李四"
    .f internNum=1:1:$l(internStr,",") d
    ..s opaInfoId=$p(internStr,",",internNum)
    ..q:opaInfoId=""
    ..s opaInfo=opaInfoId_"(实习进修)"
    ..s opaInfoList("ANIntern"_internNum)=opaInfoId_"^"_opaInfo,opaInfoList("ANIntern"_internNum,"Flag","ANIntern")=""
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="ShiftANAssist"  d   //交班麻醉助手
    .s anassSub=20
    .f  s anassSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub))  q:((anassSub=""))  d
    ..s opaInfoId=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub))
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(anassSub)=opaInfoId_"^"_opaInfo
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="ScrubNurse"  d   //器械护士
    .s nurSub=0
    .f  s nurSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub)) q:((nurSub="")||(nurSub>20))  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(nurSub)=opaInfoId_"^"_opaInfo
    ..s opaInfoList(nurSub,"Flag","SCN")=""
    ..//s opaInfoList(nurSub,"Flag","ANS_SN_1")=""
    ..s careProvList(opaInfoId)=nurSub
    ..s ifFind=ifFind||$$MatchMultipleValue()
    .
    .d SetCareProvShift("SN")
    e  i anciiCode="CirculNurse"  d   //巡回护士
    .s nurSub=0
    .f  s nurSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",nurSub)) q:((nurSub="")||(nurSub>20))  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",nurSub),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(nurSub)=opaInfoId_"^"_opaInfo
    ..s opaInfoList(nurSub,"Flag","CIRN")=""
    ..//s opaInfoList(nurSub,"Flag","ANS_CN_1")=""
    ..s careProvList(opaInfoId)=nurSub
    ..s ifFind=ifFind||$$MatchMultipleValue()
    .
    .d SetCareProvShift("CN")
    e  i anciiCode="ShiftScrubNurse"  d   //交班器械护士
    .s nurSub=20
    .f  s nurSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub)) q:((nurSub=""))  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(nurSub)=opaInfoId_"^"_opaInfo
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="ShiftCirculNurse"  d   //交班巡回护士
    .s nurSub=20
    .f  s nurSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",nurSub)) q:((nurSub=""))  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",nurSub),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList(nurSub)=opaInfoId_"^"_opaInfo
    ..s ifFind=ifFind||$$MatchMultipleValue()
    e  i anciiCode="AllOperNurse"  d   //所有手术护士
    .//洗手(器械)护士
    .k careProvList
    .s nurSub=0
    .s ifExistNurse=0
    .f  s nurSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub)) q:((nurSub=""))  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList("SCN"_nurSub)=opaInfoId_"^"_opaInfo
    ..s opaInfoList("SCN"_nurSub,"Flag","SCN")=""
    ..//s opaInfoList("SCN"_nurSub,"Flag","ANS_SN_1")=""
    ..s ifExistNurse=1
    ..s careProvList(opaInfoId)="SCN"_nurSub
    ..s ifFind=ifFind||$$MatchMultipleValue()
    .//i ('ifExistNurse) s opaInfoList("SCN0")="^",opaInfoList("SCN0","Flag","SCN")=""
    .
    .d SetCareProvShift("SN")
    .
    .//巡回护士
    .k careProvList
    .s nurSub=0
    .//s ifExistNurse=0
    .f  s nurSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",nurSub)) q:((nurSub=""))  d
    ..s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",nurSub),"^",1)
    ..s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    ..s opaInfoList("CIRN"_nurSub)=opaInfoId_"^"_opaInfo
    ..s opaInfoList("CIRN"_nurSub,"Flag","CIRN")=""
    ..//s opaInfoList("CIRN"_nurSub,"Flag","ANS_CN_1")=""
    ..s ifExistNurse=1
    ..s careProvList(opaInfoId)="CIRN"_nurSub
    ..s ifFind=ifFind||$$MatchMultipleValue()
    .//i ('ifExistNurse) s opaInfoList("CIRN0")="^",opaInfoList("CIRN0","Flag","CIRN")=""
    .
    .d SetCareProvShift("CN")
    .
    .//交班器械护士
    .//s ifExistNurse=0
    .//s nurSub=20
    .//f  s nurSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub)) q:((nurSub=""))  d
    .//.s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",nurSub),"^",1)
    .//.s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .//.s opaInfoList("ShiftSCN"_nurSub)=opaInfoId_"^"_opaInfo
    .//.s opaInfoList("ShiftSCN"_nurSub,"Flag","ShiftSCN")=""
    .//.s ifExistNurse=1
    .//.s ifFind=ifFind||$$MatchMultipleValue()
    .//i ('ifExistNurse) s opaInfoList("ShiftSCN0")="^",opaInfoList("ShiftSCN0","Flag","ShiftSCN")=""
    .
    .//交班巡回护士
    .//s ifExistNurse=0
    .//s nurSub=20
    .//f  s nurSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",nurSub)) q:((nurSub=""))  d
    .//.s opaInfoId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",nurSub),"^",1)
    .//.s opaInfo=##class(web.DHCANOPCom).GetNameById(opaInfoId)
    .//.s opaInfoList("ShiftCIRN"_nurSub)=opaInfoId_"^"_opaInfo
    .//.s opaInfoList("ShiftCIRN"_nurSub,"Flag","ShiftCIRN")=""
    .//.s ifExistNurse=1
    .//.s ifFind=ifFind||$$MatchMultipleValue()
    .//i ('ifExistNurse) s opaInfoList("ShiftCIRN0")="^",opaInfoList("ShiftCIRN0","Flag","ShiftCIRN")=""
    .
    e  i (anciiCode="PersonColStatFlag")||(anciiCode="PersonShiftColStatFlag") d   //人员统计列标志
    .s ifFind=1
    .i anciiMultipleValue'="" d
    ..f flagSeq=1:1:$l(anciiMultipleValue,"|") d
    ...s flag=$p(anciiMultipleValue,"|",flagSeq)
    ...i flag'="" s colStatFlagList(searchLevel,flag)=""
    
    q ifFind
    
SetCareProvShift(ANSCareProvType)
    s ANSCareProvSeqNo=0
    s Flag="ANS_"_ANSCareProvType_"_1"
    s flagIndexList("ANS_"_ANSCareProvType,Flag)=""
    f  s ANSCareProvSeqNo=$o(ANShiftList(opaId,ANSCareProvType,"Seq",ANSCareProvSeqNo)) q:ANSCareProvSeqNo=""  d
    .s ANSShiftCtcpId=$p(ANShiftList(opaId,ANSCareProvType,"Seq",ANSCareProvSeqNo),"^",2)
    .s ANSReliefCtcpId=$p(ANShiftList(opaId,ANSCareProvType,"Seq",ANSCareProvSeqNo),"^",4)
    .
    .s opaInfoId=ANSShiftCtcpId
    .s nurSub=ANSCareProvType_"_"_ANSCareProvSeqNo_"_"_opaInfoId
    .s Flag="ANS_"_ANSCareProvType_"_"_ANSCareProvSeqNo
    .s flagIndexList("ANS_"_ANSCareProvType,Flag)=""
    .s ifFind=ifFind||$$MatchMultipleValue()
    .i $d(careProvList(opaInfoId)) d
    ..s opaInfoList(careProvList(opaInfoId),"Flag",Flag)=""
    .e  d
    ..s opaInfo=$p(ANShiftList(opaId,ANSCareProvType,"Seq",ANSCareProvSeqNo),"^",3)
    ..s opaInfoList(nurSub)=opaInfoId_"^"_opaInfo
    ..s opaInfoList(nurSub,"Flag",Flag)=""
    .
    .s opaInfoId=ANSReliefCtcpId
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s nurSub=ANSCareProvType_"_"_(ANSCareProvSeqNo+1)_"_"_opaInfoId
    .s Flag="ANS_"_ANSCareProvType_"_"_(ANSCareProvSeqNo+1)
    .s flagIndexList("ANS_"_ANSCareProvType,Flag)=""
    .i $d(careProvList(opaInfoId)) d
    ..s opaInfoList(careProvList(opaInfoId),"Flag",Flag)=""
    .e  d
    ..s opaInfo=$p(ANShiftList(opaId,ANSCareProvType,"Seq",ANSCareProvSeqNo),"^",5)
    ..s opaInfoList(nurSub)=opaInfoId_"^"_opaInfo
    ..s opaInfoList(nurSub,"Flag",Flag)=""
    q
JudgeLabInfo(opaId)
    //判断手术麻醉中设置的检验信息
    s ifFind=0,opaInfoId="",opaInfo=""
    i anciiCode="HBsAg" d   //免疫乙肝表面抗原
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",29)
    .s opaInfo=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    .
    e  i anciiCode="HCVAb" d    //免疫丙型肝炎抗体
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",34)
    .s opaInfo=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    .
    e  i anciiCode="HivAb" d    //免疫艾滋病毒抗体
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",35)
    .s opaInfo=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    .
    e  i anciiCode="TPAb" d    //免疫梅毒
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",36)
    .s opaInfo=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    .
    e  i anciiCode="HBSAB" d    //
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",30)
    .s opaInfo=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    .
    e  i anciiCode="HBCAB" d    //
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",33)
    .s opaInfo=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    .
    e  i anciiCode="HBCAG" d    //
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",31)
    .s opaInfo=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    .
    e  i anciiCode="HBEAB" d    //
    .s opaInfoId=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",32)
    .s opaInfo=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    .
    e  i anciiCode="BLDT" d    //血型
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",11)
    .s opaInfo=$p($g(^PAC("BLDT",+opaInfoId)),"^",2)
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    .
    e  i anciiCode="RHBloodType" d    //RH血型
    .s opaInfoId=$p(^DHCANOPArrange(opaId),"^",25)    //OPA_RHBloodType
    .s opaInfo=opaInfoId
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    .
    e  d   //其他直接通过Lis接口获取检验值
    .s opstdate=$p(^DHCANOPArrange(opaId),"^",14)          //手术开始日期
    .s opsttime=$p(^DHCANOPArrange(opaId),"^",15)          //手术开始时间
    .s labInfo=##class(web.DHCClinicCom).GetTestResult(EpisodeID,"","",anciiCode,anciiStartDate,anciiStartTime,anciiEndDate,anciiEndDate,anciiIsSingle) //取手术开始时间之前最新的检验值
    .s opaInfoId=$p(labInfo,"\",1)
    .s opaInfo=labInfo
    .s opaInfoList(1)=opaInfoId_"^"_opaInfo
    .s ifFind=ifFind||$$MatchMultipleValue()
    q ifFind
JudgeANOrderInfo(opaId)
    //判断病人麻醉监护数据
    s ifFind=0,opaInfoId="",opaInfo="",opaInfoUom=""
    s anoId="",anoValue="",anoValueInd=11
    s PatWeight=+$p(^DHCANOPArrange(opaId),"^",24)
    i PatWeight=0 s PatWeight=1
    s ifOrderQuit=0
    s anoCount=0
    
    i anciiCode="ANOType" d  //根据数据类型显示，未考虑匹配值
    .s anoId=0
    .f  s anoId=$o(^DHCANOrder(0,"OPApp",opaId,anoId)) q:((anoId="")||(ifOrderQuit))  d
    ..s anoEditFlag=$p(^DHCANOrder(anoId),"^",25)
    ..q:("NE"'[anoEditFlag) //非有效数据退出
    ..s opaInfoId=$p(^DHCANOrder(anoId),"^",30)
    ..i $$MatchMultipleValue() d JudgeSingleANOrder(anoId)
    e  i anciiCode="ANCOEventItem" d   //判断事件是否存在，多个事件只要存在其中一个即可
    .s ancoId=""
    .f i=1:1:$l(anciiMultipleValue,"|") q:ifFind  d
    ..s ancoId=$p(anciiMultipleValue,"|",i)
    ..q:ancoId<=0
    ..s anoId=""
    ..f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId)) q:((anoId="")||(ifOrderQuit))  d
    ...s anoEditFlag=$p(^DHCANOrder(anoId),"^",25)
    ...q:("NE"'[anoEditFlag) //非有效数据退出
    ...s ifOrderQuit=1
    ...s ifFind=1
    ...s opaInfo=$p(^DHCANC("ComOrd",ancoId),"^",2)
    .i anciiMultipleValue="" s ifFind=1,opaInfo="无条件通过"
    .s opaInfoId=1
    .s opaInfoList("all")=opaInfoId_"^"_opaInfo
    e  i anciiCode="DrugUsageReason"  d    //用药原因统计
    .s anoId=""
    .f  s anoId=$o(^DHCANOrder(0,"OPApp",opaId,anoId)) q:anoId=""  d
    ..s anoEditFlag=$p(^DHCANOrder(anoId),"^",25)
    ..q:("NE"'[anoEditFlag) //非有效数据退出
    ..s opaInfoId=$p(^DHCANOrder(anoId),"^",24)
    ..s opaInfo=opaInfoId
    ..s ifFind=ifFind||$$MatchMultipleValue()
    ..s:opaInfoId'="" opaInfoList(opaInfoId)=opaInfoId_"^"_opaInfo
    e  d JudgeRecordItemOrder
    
    q ifFind
   
GetCommonOrder(code)
	s ancoId=""
	s ancoType=""
    f  s ancoType=$o(ancoTypeList(ancoType)) q:(ancoType="")||(+ancoId>0)  d
    .s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode",ancoType,code,""))
    
	q ancoId
JudgeRecordItemOrder()
    k ancoIdList
    //通过anciiCode来设置，anciiCode中存为代码字符串，如:szsj001,szsj003
    i anciiCode'="" d
    .f i=1:1:$l(anciiCode,",") d
    ..s ancoId=$$GetCommonOrder($p(anciiCode,",",i))
    ..i +ancoId>0 s ancoIdList(ancoId)=""
    
    //按开始ID到结束ID来设置
    f i=+anciiFromAncoId:1:+anciiToAncoId d
    .s ancoIdList(i)=""
    
    s ancoId=0
    f  s ancoId=$o(ancoIdList(ancoId)) q:((ancoId="")||(ifOrderQuit))  d
    .q:'$d(^DHCANC("ComOrd",ancoId))
    .s ancoDesc=$p($g(^DHCANC("ComOrd",+ancoId)),"^",2)
    .s ancoDataField=$p($g(^DHCANC("ComOrd",+ancoId)),"^",24)
    .s anoValueInd=$s(ancoDataField="Note":10,ancoDataField="Volume":28,1:11)
    .f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId)) q:((anoId="")||(ifOrderQuit))  d
    ..s anoEditFlag=$p(^DHCANOrder(anoId),"^",25)
    ..q:("NE"'[anoEditFlag) //非有效数据退出
    ..s ifFind=$$JudgeSingleANOrder(anoId)||ifFind
    ..s ifOrderQuit=(anciiIsSingle&&ifFind)   //anciiIsSingle是指找到一条满足条件的就退出
    ..s ifOrderQuit=(ifOrderQuit)||(anciiDataField="First")  //anciiDataField为First是指只匹配第一条数据
    
    i 'ifFind d
    .s ifFind=ifFind||$$MatchMinMaxValue()
    .s ifFind=ifFind||$$MatchMultipleValue()
    .s opaInfo=opaInfoId_opaInfoUom
    .s opaInfoList("all")=opaInfoId_"^"_opaInfo
    
    q
    
JudgeSingleANOrder(anoId)
	s ifMatchANOrder=0
	s anorder=^DHCANOrder(anoId)
    s anoStartDate=$p(anorder,"^",5)
    s anoStartTime=$p(anorder,"^",6)
    s anoEndDate=$p(anorder,"^",7)
    s anoEndTime=$p(anorder,"^",8)
    s anoDrugMode=$p(anorder,"^",18)
    s anoAbbreviate=$p(anorder,"^",35)
    s anoType=$p(anorder,"^",30)
    s anoUomId=$p(anorder,"^",12)
    s anoDensity=$p(anorder,"^",13)
    s anoInstrId=$p(anorder,"^",15)
    s anoInstr=$p($g(^PHCIN(+anoInstrId)),"^",2)
    s anoVolume=$p(anorder,"^",28)
    s anoQty=$p(anorder,"^",11)
    s anoSpeed=$p(anorder,"^",19)
    s anoSpeedUnitId=$p(anorder,"^",20)
    s anoSpeedUnit=""
    //时间范围无交集则退出
    q:('$$MatchNoTimeConditon())&&((anciiStartDate+(anciiStartTime*0.00001))>(anoEndDate+(anoEndTime*0.00001))) 0
    q:('$$MatchNoTimeConditon())&&((anciiEndDate+(anciiEndTime*0.00001))<(anoStartDate+(anoStartTime*0.00001))) 0
    s anoValue=0
    //数据值处理,连续用药计算剂量,单位,需要最新DHC_ANC_SpeedUnit表
    i (anoType="D")&&("^C^T^"[("^"_anoDrugMode_"^")) d
    .s ancSpeedUnitStr=$g(^DHCANC("SUnit",+anoSpeedUnitId))
    .s anoSpeedUnit=$p(ancSpeedUnitStr,"^",2)
    .s baseSpeedUnitId=$p(ancSpeedUnitStr,"^",7)
    .s speedUnitFactor=$p(ancSpeedUnitStr,"^",5)
    .s byPatWeight=$p(ancSpeedUnitStr,"^",6)
    .s baseUomId=$p($g(^DHCANC("SUnit",+baseSpeedUnitId)),"^",4)
    .s anoUomId=baseUomId
    .s anoStartEndDuration=((anoEndDate-anoStartDate)*24)+((anoEndTime-anoStartTime)/3600)
    .s anoValue=anoSpeed*speedUnitFactor*anoStartEndDuration
    .i byPatWeight="Y" s anoValue=anoValue*PatWeight
    i (anoValue=0) s anoValue=$p(anorder,"^",anoValueInd)
    i (anoVolume>0) s anoValue=anoVolume
    s anoUom=$p($g(^CT("UOM",+anoUomId)),"^",2)
    //当anciiDataField为空或为First时计算总量值，anciiDataField有值时不计算总量
    i ((anciiDataField="")||(anciiDataField="First")) d
    .s opaInfoId=anoValue
    .i anoType="E" s opaInfo=anoAbbreviate_" "_$zd(anoStartDate,3)_" "_$zt(anoStartTime)
    .e  i anoType="D" d
    ..s opaInfo=anoAbbreviate
    ..s opaInfo=opaInfo_" ("_$s(anoSpeed>0:(anoSpeed_anoSpeedUnit),anoQty>0:(anoQty_anoUom),1:"")
    ..s opaInfo=opaInfo_$s(anoDensity>0:(" "_anoDensity_"%"),1:"")
    ..s opaInfo=opaInfo_") "_$zd(anoStartDate,3)_" "_$zt(anoStartTime)
    ..s opaInfo=opaInfo_"~"_$s(anoEndDate=anoStartDate:"",1:($zd(anoEndDate,3)_" "))_$zt(anoEndTime)
    ..s opaInfo=opaInfo_" "_anoInstr
    .e  s opaInfo=anoAbbreviate_"("_opaInfoId_") "_$zd(anoStartDate,3)_" "_$zt(anoStartTime)
    .i anoUom="" s anoUom="-"
    .s ifMatchANOrder=ifMatchANOrder||$$MatchMinMaxValue()
    .s ifMatchANOrder=ifMatchANOrder||$$MatchMultipleValue()
    .s ifMatchANOrder=ifMatchANOrder||$$MatchNoValueCondition()
    .s anoCount=anoCount+1
    .s opaInfoList(anoCount)=opaInfoId_"^"_opaInfo
    .i ifMatchANOrder d
    ..d ConvertToComUomQty
    ..s anoDataList(opaId,searchLevel,anoUom)=opaInfoId+$g(anoDataList(opaId,searchLevel,anoUom))
    e  i anciiDataField="Min" d
    .s:+opaInfoId>+anoValue opaInfoId=anoValue
    .s opaInfoUom=anoUom
    e  i anciiDataField="Max" d
    .s:+opaInfoId<+anoValue opaInfoId=anoValue
    .s opaInfoUom=anoUom
    e  i anciiDataField="Sum" d
    .s opaInfoId=opaInfoId+anoValue
    .s opaInfoUom=anoUom
    e  i anciiDataField="Times" d
    .s opaInfoId=opaInfoId+1
    .s opaInfoUom="-"
    e  i anciiDataField="StartDT"  d
    .s opaInfoId=anoStartDate_","_anoStartTime
    .s opaInfo=$zd(anoStartDate,3)_" "_$zt(anoStartTime)
    
    //i opaId=161 b //set anorder list
    q ifMatchANOrder
    
ConvertToComUomQty
    s anoUom=$ZCVT(anoUom,"U")
    i anoUom="G" s anoUom="MG",opaInfoId=opaInfoId*1000
    e  i anoUom="UG" s anoUom="MG",opaInfoId=opaInfoId/1000
    e  i anoUom="L" s anoUom="ML",opaInfoId=opaInfoId*1000
    e  i anoUom="KU" s anoUom="U",opaInfoId=opaInfoId*1000
    q
}

/// w ##class(web.DHCANOPStat).ResponseInquiryResult("",10,"2012-01-01","2015-05-01","N","N","",2,50,50,"","","({S-5}>=3)&&({S-6}<=4)")
ClassMethod ResponseInquiryResult(ctlocIdStr, anciId, startDate, endDate, ifInquiry = "Y", dateType = "OP", sumType = "", historySeq = "", start = "", limit = "", sortField = "", direction = "", filter = "") As %String
{
    w "{record:[",!
    k colCodeList,dataList,sortDataList,rowHeaderIndList
    s count=0
    s ifHistoryData=0,historySeq=+historySeq
    i $d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq)) s ifHistoryData=1
    i 'ifHistoryData d
    .i ifInquiry="Y" s ret=..FindANOPInquiry(ctlocIdStr, anciId, startDate, endDate, dateType)
    .s count=+$g(^DHCANInquiry(+anciId,"count"))
    .s colCodeList=^DHCANInquiry(anciId)
    e  d
    .s count=+$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"count"))
    .s colCodeList=^DHCANInquiry("HistoryData",anciId,"Count",historySeq)
    s colCount=$ll(colCodeList)
    //sort start
    s sortFieldPos=0,sortInfo=""
    f i=1:1:colCount d
    .i $lg(colCodeList,i)=sortField s sortFieldPos=i
    .i $lg(colCodeList,i)["D" s rowHeaderIndList(i)=""
    
    s ifSortNum=0
    i sortField["S" s ifSortNum=1
    
    s dir=1
    i direction="DESC" s dir=-1
    
    f i=1:1:count d
    .i 'ifHistoryData d
    ..i (sumType'="")&&($d(^DHCANInquiry(anciId,"Result",i,"SumType",sumType))) s dataList=^DHCANInquiry(anciId,"Result",i,"SumType",sumType)
    ..e  s dataList=^DHCANInquiry(anciId,"Result",i)
    .e  d
    ..i (sumType'="")&&($d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result",i,"SumType",sumType))) s dataList=^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result",i,"SumType",sumType)
    ..e  s dataList=^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result",i)
    .s sortInfo=""
    .i sortFieldPos>0 s sortInfo=$lg(dataList,sortFieldPos)
    .i ifSortNum s sortInfo=+sortInfo
    .i sortInfo="" s sortInfo=i
    .s ifMatchFilter=1
    .i filter'="" d
    ..s ifMatchFilter=0
    ..s ind=""
    ..f  s ind=$o(rowHeaderIndList(ind)) q:ind=""  d
    ...i $lg(dataList,ind)[filter s ifMatchFilter=1
    ...i ifMatchFilter break
    .q:'ifMatchFilter
    .s sortDataList(sortInfo,i)=dataList
    //sort end

    i +limit=0 s limit=count
    s sortInfo="",sortCount=0
    i start>count s start=(count\limit)*limit
    s ifRowFirst=1
    f  s sortInfo=$o(sortDataList(sortInfo),dir) q:sortInfo=""  d
    .s sorSeq=""
    .f  s sorSeq=$o(sortDataList(sortInfo,sorSeq),dir) q:sorSeq=""  d
    ..s ifFirst=1
    ..s sortCount=sortCount+1
    ..q:((sortCount<=start)||(sortCount>(limit+start))) //不显示不在范围内的数据
    ..i 'ifRowFirst w ","
    ..s ifRowFirst=0
    ..w "{"
    ..w "'rowId':'"_sorSeq_"'"
    ..s ifFirst=0
    ..s dataList=sortDataList(sortInfo,sorSeq)
    ..k rowData
    ..f j=1:1:colCount d
    ...s colCode=$lg(colCodeList,j)
    ...s tmpData=$lg(dataList,j)
    ...//i (colCode["S")&&(tmpData="") s tmpData=0 //yy 此行放开则未查询到值的项目会显示0,否则显示空
    ...s rowData(colCode)=tmpData
    ...i (colCode["S") s rowData(colCode)=+rowData(colCode)
    ...s tmpData=..ReplaceString(tmpData,"'","\'")
    ...s tmpData=..ReplaceString(tmpData,$c(13),"\n")
    ...s tmpData=..ReplaceString(tmpData,$c(10),"\r")
    ...s tmpData=..ReplaceString(tmpData,$c(2),"<$C2>")
    ...s tmpData=..ReplaceString(tmpData,$c(5),"<$C5>")
    ...s tmpData=..ReplaceString(tmpData,$c(7),"<$C7>")
    ...s tmpData=..ReplaceString(tmpData,"  ","&emsp;")
    ...i filter'="" d
    ....s tmpData=..ReplaceString(tmpData,filter,"<span class=\'data-filter\'>"_filter_"</span>")
    ...i 'ifFirst w ","
    ...w "'"_colCode_"':'"_tmpData_"'"
    ...s ifFirst=0
    ..w "}",!
    w "],total : "_count_"}"
    q ""
}

/// w ##class(web.DHCANOPStat).ReplaceString("abcdefghijk","c","tc")
ClassMethod ReplaceString(str, OldStr, NewStr) As %String
{
    s i=$find(str,OldStr)
    while(i>0)
    {
        s begin=i-$L(OldStr)-1
        s str=$E(str,1,begin)_NewStr_$E(str,i,$L(str))
        s i=$find(str,OldStr,begin+$L(NewStr)+1)
    }
    q str
}

/// Creator：        yy
/// CreatDate：      2015-05-18
/// Description：    计算表达式的值
/// Input：          表达式,原始值列表
///                 表达式以{n}表示取list第n个位置的值,不用n表示则取其本身
/// Output：        计算结果
/// Return：         计算结果
/// w ##class(web.DHCANOPStat).CalculateExpression("{1}/{2}*{3}*({4}+{5}*{6}+{7}/{8})",.PLIST)
/// w ##class(web.DHCANOPStat).CalculateExpression("({1}>={2})&&({3}>4)",.PLIST)
ClassMethod CalculateExpression(expression As %String, ByRef Arg As %List) As %String [ ProcedureBlock = 0 ]
{
    s $ZT="ERROR"
    s ret=0
    s index=""
    f  s index=$o(Arg(index)) q:index=""  d
    .s expression=..ReplaceString(expression,"{"_index_"}",+Arg(index))
    s expression=$ZSTRIP(expression,"*APC",,"()+-*/\#.<=>&|'")
    s expression="set ret="_expression
    x expression
    q ret
ERROR
    q "<ERROR>"_$ZE
}

ClassMethod ConvertYNToStr(YOrN As %String) As %String
{
    i YOrN="Y" q "是"
    e  i YOrN="N" q "否"
    e  q YOrN
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetANCIResultHeader",10)
Query GetANCIResultHeader(anciId As %String = "") As %Query(ROWSPEC = "code,desc,width")
{
}

ClassMethod GetANCIResultHeaderExecute(ByRef qHandle As %Binary, anciId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i anciId="" s anciId=1
    s anciHeaderJsonStr=""
    k anciHeaderList
    s anciDataType=$lg(^DHCANCInquiry(anciId),10)
    s lastSeqNo=0,anciiSub=""
    s ifQueryNoRelateItemByTree=1
    k searchList,displayList,treeList,resultSearchList
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    .q:((anciDataType'="S")&&('anciiIsDisplay))
    .s anciiCode=$lg(^DHCANCInquiry(anciId,"I",anciiSub),1)
    .s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    .s anciSeqNo=$lg(^DHCANCInquiry(anciId,"I",anciiSub),20)
    .s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    .s anciiNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),10)
    .s anciiRelateAnciiSub=$lg(^DHCANCInquiry(anciId,"I",anciiSub),26)
    .s anciiColumnWidth=+$lg(^DHCANCInquiry(anciId,"I",anciiSub),27)
    .s anciiIsResultSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),28)
    .i +anciSeqNo=0 s anciSeqNo=lastSeqNo+1
    .s lastSeqNo=+anciSeqNo
    .s anciSeqNo=$s($l(anciSeqNo)=1:"0000",$l(anciSeqNo)=2:"000",$l(anciSeqNo)=3:"00",$l(anciSeqNo)=4:"0",1:"")_anciSeqNo
    .s searchSeqNo=anciSeqNo_"-"_searchLevel
    .i (anciDataType="S") d
    ..i anciiIsResultSearch d
    ...i (anciiRelateAnciiSub'="")&&(anciiIsDisplay) s resultSearchList(anciiRelateAnciiSub,anciiSub)=""
    ..e  i (anciiIsSearch)&&(+anciiRelateAnciiSub>0) s treeList("Branch",anciiSub)=anciiRelateAnciiSub
    ..e  i (anciiIsSearch)&&(ifQueryNoRelateItemByTree) s treeList("OriginNode",anciiSub)=""
    ..s treeList("NodeDisplay",anciiSub)=anciiIsDisplay
    ..s treeList("Header",anciiSub,"Desc")=anciiDesc
    ..s treeList("Header",anciiSub,"Width")=anciiColumnWidth
    ..i (anciiIsDisplay)&&('anciiIsResultSearch)&&('anciiIsSearch) d
    ...s displayList(searchLevel,"Code")="D-"_searchLevel
    ...i $d(displayList(searchLevel,"Desc")) s displayList(searchLevel,"Desc")=$g(displayList(searchLevel,"Desc"))_","
    ...s displayList(searchLevel,"Desc")=$g(displayList(searchLevel,"Desc"))_anciiDesc
    ...i anciiNote'="" d
    ....s displayList(searchLevel,"Note")=anciiNote
    ...s displayList(searchLevel,"Width")=anciiColumnWidth
    .e  i anciiIsDisplay d
    ..i anciiNote'="" s anciHeaderList(anciSeqNo)=$lb("D-"_anciiSub,anciiNote,anciiColumnWidth)
    ..e  s anciHeaderList(anciSeqNo)=$lb("D-"_anciiSub,anciiDesc,anciiColumnWidth)
    
    s anciiSub="",ifHaveOriginNode=0
    f  s anciiSub=$o(treeList("Branch",anciiSub)) q:anciiSub=""  d
    .//当某条分支的父节点没有父节点时，认为是根节点
    .i '$d(treeList("Branch",treeList("Branch",anciiSub))) s treeList("OriginNode",treeList("Branch",anciiSub))=""
    .s treeList(treeList("Branch",anciiSub),"ChildNode",anciiSub)=""

    //生成所有关联路径，按照最后端点对应的筛选层设置对应行
    i +$o(treeList("OriginNode",""))>0  d
    .s ifHaveOriginNode=1
    .s treeAnciiSub=""
    .f  s treeAnciiSub=$o(treeList("OriginNode",treeAnciiSub)) q:treeAnciiSub=""  d
    ..//递归遍历所有节点，如果不满足条件，线路的递归将中止，最终结果存入 treeList("PassPath",parentNode)
    ..d InquiryRelateTree(treeAnciiSub,0,"")
    .m treeList("AllPath")=treeList("PassPath")
    .//根据path生成level序列
    .s treeAnciiSub=""
    .f  s treeAnciiSub=$o(treeList("AllPath",treeAnciiSub)) q:treeAnciiSub=""  d
    ..s searchLevel=+$lg(^DHCANCInquiry(anciId,"I",treeAnciiSub),21)
    ..s anciSeqNo=+$lg(^DHCANCInquiry(anciId,"I",treeAnciiSub),20)
    ..s anciSeqNo=$s($l(anciSeqNo)=1:"0000",$l(anciSeqNo)=2:"000",$l(anciSeqNo)=3:"00",$l(anciSeqNo)=4:"0",1:"")_anciSeqNo
    ..s searchSeqNo=anciSeqNo_"-"_searchLevel
    ..s treeList("SearchList",searchSeqNo,"Code")="S-"_searchLevel
    ..f i=1:1:$l(treeList("AllPath",treeAnciiSub),"->") d
    ...//生成类似level形式序列
    ...s anciiSub=$p(treeList("AllPath",treeAnciiSub),"->",i)
    ...s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    ...s anciiColumnWidth=+$lg(^DHCANCInquiry(anciId,"I",anciiSub),27)
    ...s anciiNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),10)
    ...i $g(treeList("SearchList",searchSeqNo,"Desc"))'="" s treeList("SearchList",searchSeqNo,"Desc")=treeList("SearchList",searchSeqNo,"Desc")_","
    ...i anciiIsDisplay s treeList("SearchList",searchSeqNo,"Desc")=$g(treeList("SearchList",searchSeqNo,"Desc"))_treeList("Header",anciiSub,"Desc")
    ...s treeList("SearchList",searchSeqNo,"Width")=anciiColumnWidth
    ...i anciiNote'="" d
    ....s treeList("SearchList",searchSeqNo,"Note")=anciiNote
    ..s resultSearchAnciiSub=""
    ..f  s resultSearchAnciiSub=$o(resultSearchList(treeAnciiSub,resultSearchAnciiSub)) q:resultSearchAnciiSub=""  d
    ...s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",resultSearchAnciiSub),5)
    ...q:'anciiIsDisplay
    ...s anciiNote=$lg(^DHCANCInquiry(anciId,"I",resultSearchAnciiSub),10)
    ...s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",resultSearchAnciiSub),2)
    ...s anciSeqNo=+$lg(^DHCANCInquiry(anciId,"I",resultSearchAnciiSub),20)
    ...s anciSeqNo=$s($l(anciSeqNo)=1:"0000",$l(anciSeqNo)=2:"000",$l(anciSeqNo)=3:"00",$l(anciSeqNo)=4:"0",1:"")_anciSeqNo
    ...s resultSearchLevel=+$lg(^DHCANCInquiry(anciId,"I",resultSearchAnciiSub),21)
    ...s anciiColumnWidth=+$lg(^DHCANCInquiry(anciId,"I",resultSearchAnciiSub),27)
    ...s treeList("SearchList",anciSeqNo_"-"_resultSearchLevel,"Code")="R-"_resultSearchLevel
    ...s treeList("SearchList",anciSeqNo_"-"_resultSearchLevel,"Desc")=anciiDesc
    ...s treeList("SearchList",anciSeqNo_"-"_resultSearchLevel,"Note")=anciiNote
    ...s treeList("SearchList",anciSeqNo_"-"_resultSearchLevel,"Width")=+anciiColumnWidth
    ..k searchList
    ..m searchList=treeList("SearchList")
    
    s searchLevel=0
    s seqno=+$o(anciHeaderList(""),-1)
    f  s searchLevel=$o(displayList(searchLevel)) q:searchLevel=""  d
    .s seqno=seqno+1
    .s anciHeaderList(seqno)=$lb(displayList(searchLevel,"Code"),$S($g(displayList(searchLevel,"Note"))'="":$g(displayList(searchLevel,"Note")),1:$g(displayList(searchLevel,"Desc"))),displayList(searchLevel,"Width"))
    
    s searchLevel=0
    s seqno=+$o(anciHeaderList(""),-1)
    f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    .s seqno=seqno+1
    .s anciHeaderList(seqno)=$lb(searchList(searchLevel,"Code"),$S($g(searchList(searchLevel,"Note"))'="":$g(searchList(searchLevel,"Note")),1:$g(searchList(searchLevel,"Desc"))),+$g(searchList(searchLevel,"Width")))
    
    s seqno=0,count=0
    f  s seqno=$o(anciHeaderList(seqno)) q:seqno=""  d
    .d OutputResultHeader
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
InquiryRelateTree(parentNode,recursionLevel,recursionPath)
    s childNode="",ifChildQuit=0
    i recursionPath="" s recursionPath=parentNode
    e  s recursionPath=recursionPath_"->"_parentNode
    //当不存在子节点时,或者根节点需要展示,将此路径记录至结果序列
    i (+$o(treeList(parentNode,"ChildNode",childNode))=0) || (treeList("NodeDisplay",parentNode)) d
    .s treeList("PassPath",parentNode)=recursionPath
    .i (+$o(treeList(parentNode,"ChildNode",childNode))=0) s ifChildQuit=1
    .//w "in result ",opaId," ",parentNode,"  ",recursionLevel,"  ",recursionPath,!
    q:ifChildQuit
    s recursionLevel=+recursionLevel
    //w parentNode,"  ",recursionLevel,"  ",recursionPath,!
    //b //in recursion
    //将不同递归层级的数据存储在list,避免在递归中改变了参数值导致死循环
    s recursionRecorder(recursionLevel,"parentNode")=parentNode
    s recursionRecorder(recursionLevel,"path")=recursionPath
    f  s childNode=$o(treeList(parentNode,"ChildNode",childNode)) q:childNode=""  d
    .s recursionRecorder(recursionLevel,"childNode")=childNode
    .s recursionPath=recursionRecorder(recursionLevel,"path")
    .s ifChildQuit=0
    .//w "in loop ",opaId," parent:",parentNode,"  level:",recursionLevel,"  path:",recursionPath,"  quit:",ifChildQuit,!
    .d InquiryRelateTree(childNode,recursionLevel+1,recursionPath)
    .s childNode=recursionRecorder(recursionLevel,"childNode")
    .s parentNode=recursionRecorder(recursionLevel,"parentNode")
    q
    
OutputResultHeader
    //set Data=$lb(anciiId,anciiCode,anciiDesc,anciiType,anciiTypeDesc,anciiIsSearch,anciiIsDisplay,anciiDataField,anciiIsSingle,anciiMinQty,anciiMaxQty,anciiNote,anciiMultiple,anciiStartDateTime,anciiDurationHour,anciiOeoriNote,anciiRefValue,anciiRefAncoId,anciiRefAncoDesc,anciiFromTime,anciiToTime,anciiExactTime,anciiSeqNo,anciiLevel,anciiFromAncoId,anciiToAncoId,anciiSummaryType,anciiDurationInterval)
    Set Data=anciHeaderList(seqno)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetANCIResultHeaderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetANCIResultHeaderExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetANCIResultHeaderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetANCIResultHeaderExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetANCISearchItems",4)
Query GetANCISearchItems(anciId As %String = "") As %Query(ROWSPEC = "anciiId,anciiSub,anciiCode,anciiDesc,anciiType,anciiTypeDesc,anciiIsSearch,anciiIsDisplay,anciiDataField,anciiIsSingle,anciiMinQty,anciiMaxQty,anciiNote,anciiMultiple,anciiMultipleDesc,anciiStartDateTime,anciiDurationHour,anciiOeoriNote,anciiRefValue,anciiRefAncoId,anciiRefAncoDesc,anciiFromTime,anciiToTime,anciiExactTime,anciiSeqNo,anciiLevel,anciiFromAncoId,anciiToAncoId,anciiSummaryType,anciiDurationInterval,anciiRelateAnciiSub,anciiColumnWidth,anciiIsResultSearch,anciiFromDate,anciiToDate,anciiIsNegative")
{
}

ClassMethod GetANCISearchItemsExecute(ByRef qHandle As %Binary, anciId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i anciId="" s anciId=1
    k anciitemList
    s anciiSub=""
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s anciiId=anciId_"||"_anciiSub
    .s anciiCode=$lg(^DHCANCInquiry(anciId,"I",anciiSub),1)
    .s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    .s anciiType=$lg(^DHCANCInquiry(anciId,"I",anciiSub),3)
    .s:anciiType="P" anciiTypeDesc="Patient"
    .s:anciiType="B" anciiTypeDesc="Baseline"
    .s:anciiType="I" anciiTypeDesc="ICD"
    .s:anciiType="D" anciiTypeDesc="Docter"
    .s:anciiType="O" anciiTypeDesc="Order"
    .s:anciiType="R" anciiTypeDesc="Record"
    .s:anciiType="L" anciiTypeDesc="Lab"
    .s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    .s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    .i +anciiIsSearch s anciiIsSearch=1
    .e  s anciiIsSearch=""
    .i +anciiIsDisplay s anciiIsDisplay=1
    .e  s anciiIsDisplay=""
    .s anciiDataField=$lg(^DHCANCInquiry(anciId,"I",anciiSub),6)
    .s anciiIsSingle=$lg(^DHCANCInquiry(anciId,"I",anciiSub),7)
    .i +anciiIsSingle s anciiIsSingle=1
    .e  s anciiIsSingle=""
    .s anciiMinQty=$lg(^DHCANCInquiry(anciId,"I",anciiSub),8)
    .s anciiMaxQty=$lg(^DHCANCInquiry(anciId,"I",anciiSub),9)
    .s anciiNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),10)
    .s anciiMultiple=$lg(^DHCANCInquiry(anciId,"I",anciiSub),11)
    .s anciiMultipleDesc=..ReplaceString(anciiMultiple,"|",",")
    .s anciiStartDateTime=$lg(^DHCANCInquiry(anciId,"I",anciiSub),12)
    .s anciiDurationHour=$lg(^DHCANCInquiry(anciId,"I",anciiSub),13)
    .s anciiOeoriNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),14)
    .s anciiFromTime=$lg(^DHCANCInquiry(anciId,"I",anciiSub),15)
    .s:+anciiFromTime>0 anciiFromTime=$zt(anciiFromTime,2)
    .s anciiToTime=$lg(^DHCANCInquiry(anciId,"I",anciiSub),16)
    .s:+anciiToTime>0 anciiToTime=$zt(anciiToTime,2)
    .s anciiExactTime=$lg(^DHCANCInquiry(anciId,"I",anciiSub),17)
    .s anciiRefAncoId=$lg(^DHCANCInquiry(anciId,"I",anciiSub),18)
    .s anciiRefAncoDesc=$p($g(^DHCANC("ComOrd",+anciiRefAncoId)),"^",2)
    .s anciiRefValue=$lg(^DHCANCInquiry(anciId,"I",anciiSub),19)
    .s anciiSeqNo=$lg(^DHCANCInquiry(anciId,"I",anciiSub),20)
    .s anciiLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s anciiFromAncoId=$lg(^DHCANCInquiry(anciId,"I",anciiSub),22)
    .s anciiToAncoId=$lg(^DHCANCInquiry(anciId,"I",anciiSub),23)
    .s anciiSummaryType=$lg(^DHCANCInquiry(anciId,"I",anciiSub),24)
    .s anciiDurationInterval=$lg(^DHCANCInquiry(anciId,"I",anciiSub),25)
    .s anciiRelateAnciiSub=$lg(^DHCANCInquiry(anciId,"I",anciiSub),26)
    .s anciiColumnWidth=+$lg(^DHCANCInquiry(anciId,"I",anciiSub),27)
    .s anciiIsResultSearch=+$lg(^DHCANCInquiry(anciId,"I",anciiSub),28)
    .i +anciiIsResultSearch s anciiIsResultSearch=1
    .e  s anciiIsResultSearch=""
    .s anciiFromDate=$lg(^DHCANCInquiry(anciId,"I",anciiSub),29)
    .s:anciiFromDate>0 anciiFromDate=##class(web.DHCClinicCom).ConvertToDate(anciiFromDate)
    .s anciiToDate=$lg(^DHCANCInquiry(anciId,"I",anciiSub),30)
    .s:anciiToDate>0 anciiToDate=##class(web.DHCClinicCom).ConvertToDate(anciiToDate)
    .s anciiIsNegative=+$lg(^DHCANCInquiry(anciId,"I",anciiSub),31)
    .s anciitemList(+anciiSeqNo,anciiSub)=$lb(anciiId,anciiSub,anciiCode,anciiDesc,anciiType,anciiTypeDesc,anciiIsSearch,anciiIsDisplay,anciiDataField,anciiIsSingle,anciiMinQty,anciiMaxQty,anciiNote,anciiMultiple,anciiMultipleDesc,anciiStartDateTime,anciiDurationHour,anciiOeoriNote,anciiRefValue,anciiRefAncoId,anciiRefAncoDesc,anciiFromTime,anciiToTime,anciiExactTime,anciiSeqNo,anciiLevel,anciiFromAncoId,anciiToAncoId,anciiSummaryType,anciiDurationInterval,anciiRelateAnciiSub,anciiColumnWidth,anciiIsResultSearch,anciiFromDate,anciiToDate,anciiIsNegative)
    .//d OutputSearchItemRow
    s seqno=""
    f  s seqno=$o(anciitemList(seqno)) q:seqno=""  d
    .s sub=""
    .f  s sub=$o(anciitemList(seqno,sub)) q:sub=""  d
    ..d OutputSearchItemRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputSearchItemRow
    Set Data=anciitemList(seqno,sub)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetANCISearchItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetANCISearchItemsExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetANCISearchItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetANCISearchItemsExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetAllANCInquiryItem")
Query GetAllANCInquiryItem() As %Query(ROWSPEC = "code:%String,desc:%String,type:%String,query:%String,displayField:%String,valueField:%String,valueOption:%String,multiDelimiter:%String,canMatchNumber:%String")
{
}

ClassMethod GetAllANCInquiryItemExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s ifExistQueryItem=$d(^DHCANInquiry("QueryItem"))
    s ifAddInRowItem=0
    
    s code="EpisodeID",desc="就诊号",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="RegNo",desc="登记号",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="InPatNo",desc="住院号",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="MedCareNo",desc="病案号",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PersonID",desc="身份证",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PatName",desc="姓名",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="birth",desc="生日",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="age",desc="年龄",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField="[['Year','岁'],['Mouth','月'],['Day','天']]"
    d OutputResultItemRow
    s code="sex",desc="性别",type="P",query="{ClassName:'web.DHCANOPStat',QueryName:'GetSex',Args:[]}",displayField="CTSEXDesc",valueField="CTSEXRowId",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="VisitStatus",desc="就诊状态",type="P",query="",displayField="",valueField="",valueOption="{record:[{value:'A',desc:'在院'},{value:'C',desc:'取消住院'},{value:'D',desc:'出院'},{value:'P',desc:'预约'}],total:4}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AdmDateTime",desc="入院日期时间",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AdmOPDateDuration",desc="手术前住院天数",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="DischgDateTime",desc="出院日期时间",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AdmType",desc="就诊类型",type="P",query="",displayField="",valueField="",valueOption="{record:[{value:'I',desc:'住院'},{value:'O',desc:'门诊'},{value:'E',desc:'急诊'},{value:'N',desc:'新生'},{value:'H',desc:'体检'}],total:5}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="DischargeType",desc="出院状态(安贞)",type="P",query="",displayField="",valueField="",valueOption="{record:[{value:'医嘱离院',desc:'医嘱离院'},{value:'医嘱转院',desc:'医嘱转院'},{value:'医嘱转社区卫生服务机构/乡镇卫生院',desc:'医嘱转社区卫生服务机构/乡镇卫生院'},{value:'非医嘱离院',desc:'非医嘱离院'},{value:'死亡',desc:'死亡'},{value:'其他',desc:'其他'}],total:6}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="DischargeLoc",desc="出院科室",type="P",query="{ClassName:'web.DHCClinicCom',QueryName:'FindLocList',Args:['','']}",displayField="ctlocDesc",valueField="ctlocId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="DoctorInCharge",desc="主管医生",type="P",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="IsDaySurgery",desc="是否日间手术",type="P",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="IsDelayDischarge",desc="是否延迟出院",type="P",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    
    s code="SourceType",desc="急诊择期",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'E',desc:'急诊'},{value:'B',desc:'择期'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="Status",desc="手术状态",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'A',desc:'申请'},{value:'D',desc:'拒绝'},{value:'R',desc:'安排'},{value:'N',desc:'非预约'},{value:'I',desc:'术中'},{value:'P',desc:'恢复室'},{value:'L',desc:'术毕'},{value:'F',desc:'完成'}],total:8}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="AppLoc",desc="申请科室",type="B",query="{ClassName:'web.DHCClinicCom',QueryName:'FindLocList',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT']}",displayField="ctlocDesc",valueField="ctlocId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="SurgonLoc",desc="术者科室",type="B",query="{ClassName:'web.DHCClinicCom',QueryName:'FindLocList',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT']}",displayField="ctlocDesc",valueField="ctlocId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="Hospital",desc="医院",type="B",query="{ClassName:'web.DHCANOPStat',QueryName:'GetHospitalList',Args:[]}",displayField="HOSPDesc",valueField="HOSPRowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="OpName",desc="手术名称",type="B",query="{ClassName:'web.DHCANCOrc',QueryName:'FindOrcOperation',Args:['','this']}",displayField="tOperDesc",valueField="tOperId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="PlanOpName",desc="拟施手术名称",type="B",query="{ClassName:'web.DHCANCOrc',QueryName:'FindOrcOperation',Args:['','this']}",displayField="tOperDesc",valueField="tOperId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="IfOPAccordPlan",desc="是否手术与拟施手术一致",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:1,desc:'是'},{value:0,desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="OpCat",desc="手术分类",type="B",query="{ClassName:'web.DHCANCOrc',QueryName:'FindORCOperationCategory',Args:[]}",displayField="operCategLDesc",valueField="operCategId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="OpLevel",desc="手术级别",type="B",query="{ClassName:'web.UDHCANOPArrange',QueryName:'GetOPLevel',Args:[]}",displayField="ANCPLDesc",valueField="ANCOPLRowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="OperLoc",desc="手术室",type="B",query="{ClassName:'web.DHCClinicCom',QueryName:'FindLocList',Args:['','OP^OUTOP^EMOP']}",displayField="ctlocDesc",valueField="ctlocId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="OpRoom",desc="手术间",type="B",query="{ClassName:'web.DHCANCRoom',QueryName:'FindexeLoc',Args:['']}",displayField="tOprDesc",valueField="tOprId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PACUBed",desc="恢复室床位",type="B",query="{ClassName:'web.DHCANCRoom',QueryName:'FindexeLoc',Args:['']}",displayField="tOprDesc",valueField="tOprId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="ANMethod",desc="麻醉方法",type="B",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindAnaestMethod',Args:['']}",displayField="Des",valueField="ID",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s ifAddInRowItem=1
    s code="AnaestType",desc="麻醉方法类型",type="B",query="{ClassName:'web.DHCANOPStat',QueryName:'GetAnaestTypeList',Args:['']}",displayField="ANTYPEDesc",valueField="ANTYPERowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperPosition",desc="手术体位",type="B",query="{ClassName:'web.UDHCANOPArrange',QueryName:'GetOperPosition',Args:[]}",displayField="OPPOS_Desc",valueField="OPPOS_RowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperBodySite",desc="手术部位",type="B",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindBodySite',Args:[]}",displayField="BODS_Desc",valueField="BODS_RowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="BladeType",desc="手术切口",type="B",query="{ClassName:'web.UDHCANOPArrange',QueryName:'GetBladeType',Args:[]}",displayField="BLDTPDesc",valueField="BLDTPRowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PreopDiag",desc="术前诊断",type="B",query="{ClassName:'web.UDHCANOPArrange',QueryName:'LookUpMrcDiagnosis',Args:['this']}",displayField="DiagDes",valueField="rowid0",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PostopDiag",desc="术后诊断",type="B",query="{ClassName:'web.UDHCANOPArrange',QueryName:'LookUpMrcDiagnosis',Args:['this']}",displayField="DiagDes",valueField="rowid0",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="IfPostDiagAccordPre",desc="是否术前术后诊断一致",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:1,desc:'是'},{value:0,desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="Isolated",desc="是否隔离",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="opaId",desc="opaId",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PrepareBlood",desc="是否备血",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="UseSelfBlood",desc="自体血回输",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ExCirculation",desc="体外循环",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="NeedAnaesthetist",desc="是否麻醉会诊",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="MiniInvasive",desc="是否微创手术",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="NeedNavigation",desc="是否导航",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="UnPlanedOp",desc="是否非计划再次手术",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="majorSurgery",desc="重大手术",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AddInstrument",desc="是否补充器械",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ASA",desc="ASA",type="B",query="{ClassName:'web.DHCANCom',QueryName:'FindASAClass',Args:[]}",displayField="Description",valueField="Id",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OPAppDateTime",desc="手术申请时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OPAuditDateTime",desc="手术审核时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OPStartMouth",desc="手术月份",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OPDate",desc="手术日期",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperStartDateTime",desc="手术开始时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperEndDateTime",desc="手术结束时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperStartEndDuration",desc="手术时长(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1
    d OutputResultItemRow
    s code="ANAStartDateTime",desc="麻醉开始时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ANAEndDateTime",desc="麻醉结束时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ANAStartEndDuration",desc="麻醉时长(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="TheatreInDateTime",desc="入室时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="TheatreOutDateTime",desc="出室时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="TheatreInOutDuration",desc="入离室时长(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="TheatreOutInInterval",desc="手术之间离入室时长(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="InOutDayDuration",desc="当天开始到结束工作时间(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="ANAPrepareDuration",desc="手术前麻醉准备时长(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="BeforeANPrepareDuration",desc="麻醉前准备时长(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="BeforeOPPrepareDuration",desc="手术前准备时长(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="AfterOPOutDuration",desc="手术结束后出室准备时长(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="AfterANOutDuration",desc="麻醉结束后出室准备时长(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="AfterOPANDuration",desc="手术结束后麻醉结束准备时长(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="PACUInDateTime",desc="入PACU时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PACUOutDateTime",desc="出PACU时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PACUInOutDuration",desc="PACU用时(h)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="DeceasedTime",desc="死亡时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="IsDeceased",desc="是否死亡",type="B",query="",displayField="",valueField="",valueOption="{record:[{value:'Y',desc:'是'},{value:'N',desc:'否'}],total:2}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OPCancelAfterAN",desc="麻醉开始后取消手术",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=1,dataField=""
    d OutputResultItemRow
    s code="OperEquip",desc="手术中使用设备",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="StockCat",desc="耗材类型",type="B",query="{ClassName:'web.DHCANOPStatAZ',QueryName:'GetStockCatList',Args:[]}",displayField="ANCSCDesc",valueField="ANCSCRowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="StockItem",desc="使用耗材",type="B",query="{ClassName:'web.DHCANOPStatAZ',QueryName:'GetStockItemList',Args:[]}",displayField="ANCSIDesc",valueField="ANCSIRowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AZOpEquipFee",desc="手术设备费用(安贞)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AZStentQty",desc="支架数量(安贞)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AZBalloonQty",desc="球囊数量(安贞)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="MedicalSafety",desc="麻醉非预期事件",type="B",query="{ClassName:'web.DHCCLCMedicalSafety',QueryName:'MedicalSafety',Args:['this']}",displayField="Desc",valueField="rowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="TotalIn",desc="总入量",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="BalanceLiquid",desc="晶体液",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ColloidLiquid",desc="胶体液",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="RedBloodCell",desc="悬浮红细胞",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AutoBlood",desc="自体血",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="BloodPlasma",desc="血浆",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="BloodPlatelet",desc="血小板",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="BloodCoaplationFactor",desc="凝血因子(冷沉淀)",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OtherLiquid",desc="其它补液",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="TotalOut",desc="总出量",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="BloodLoss",desc="失血量",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="Urine",desc="尿量",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OtherOutput",desc="其它出量",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="CASignUser",desc="CA签名人",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="CASignTime",desc="CA签名时间",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="NightShift",desc="夜班",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="StatisticValue",desc="统计汇总值（仅二次筛选使用）",type="B",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    
    s code="OperICD",desc="手术ICD",type="I",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PreDiagICD",desc="术前诊断ICD",type="I",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PostDiagICD",desc="术后诊断ICD",type="I",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    
    s code="OperName",desc="手术名称(安贞)",type="OL",query="{ClassName:'web.DHCANCOrc',QueryName:'FindOrcOperation',Args:['','this']}",displayField="tOperDesc",valueField="tOperId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperLevel",desc="手术级别(安贞)",type="OL",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperBlade",desc="手术切口(安贞)",type="OL",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="SurgeonLocAZ",desc="术者科室(安贞)",type="OL",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PlanSurgeonAZ",desc="拟施术者(安贞)",type="OL",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperTechAZ",desc="手术技术(安贞)",type="OL",query="",displayField="",valueField="",valueOption="{record:[{value:'1',desc:'直视微创'},{value:'2',desc:'腔镜微创'},{value:'3',desc:'机器人微创'}],total:3}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperType",desc="手术操作类型(安贞)",type="OL",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperCatAZ",desc="手术分类(安贞)",type="OL",query="{ClassName:'web.DHCANCOperationCat',QueryName:'LookUpOperationCat',Args:['','','','','']}",displayField="Desc",valueField="rowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    
    s code="ArcimId",desc="医嘱项ID",type="O",query="{ClassName:'web.DHCANOPStat',QueryName:'FindOrcItmMast',Args:['this','']}",displayField="ARCIMastDesc",valueField="ARCIMastRowID",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ArcimCat",desc="医嘱项子类",type="O",query="{ClassName:'web.DHCANOPStat',QueryName:'FindArcimCat',Args:['this','']}",displayField="ARCICatDesc",valueField="RowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    //,R,D,I,C,N,T,L,X,P,B,S,H,E,A,F,DTF,BM,PROS
    //,Drug,Diet,IV,Consultation,Normal,Dental,LabTrak,RehabMedicine,Price,BloodBank,Diet Supplement,Hardware,Diet Enteral Feed,Day Book,DFT,Diet Thickened Fluid,Bulk Meal,Prosthetics
    s code="OEOrderType",desc="医嘱类型",type="O",query="",displayField="",valueField="",valueOption="{record:[{value:'R',desc:'药品医嘱'},{value:'I',desc:'注射医嘱'},{value:'L',desc:'检验医嘱'},{value:'N',desc:'普通医嘱'}],total:4}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OEOrderCat",desc="医嘱分类",type="O",query="{ClassName:'web.DHCANOPStat',QueryName:'FindOEOrderCat',Args:['this']}",displayField="ORCatDesc",valueField="RowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="UserAdd",desc="医嘱开单人",type="O",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT^OP^OUTOP^EMOP^AN^OUTAN^EMAN','','','','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="UserDept",desc="医嘱开单科室",type="O",query="{ClassName:'web.DHCClinicCom',QueryName:'FindLocList',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT^OP^OUTOP^EMOP^AN^OUTAN^EMAN']}",displayField="ctlocDesc",valueField="ctlocId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="RecDept",desc="医嘱接收科室",type="O",query="{ClassName:'web.DHCClinicCom',QueryName:'FindLocList',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT^OP^OUTOP^EMOP^AN^OUTAN^EMAN']}",displayField="ctlocDesc",valueField="ctlocId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OEOrderBill",desc="医嘱费用",type="O",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OEOrderQty",desc="医嘱数量",type="O",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OEOrderDetail",desc="医嘱明细(显示)",type="O",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="EMCCat",desc="核算分类",type="O",query="{ClassName:'web.DHCANOPStat',QueryName:'GetEMCCatList',Args:['this']}",displayField="Desc",valueField="RowId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    
    
    
    s code="Surgeon",desc="手术医生",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT','','','','Y','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AssistI",desc="一助",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT','','','','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AssistII",desc="二助",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT','','','','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AssistIII",desc="三助",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT','','','','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AssistIV",desc="四助",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT','','','','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AssistV",desc="五助",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT','','','','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AllOperDoctor",desc="所有手术医生(助手)",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT','','','','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="OperIntern",desc="手术实习进修",type="D",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AppDoctor",desc="申请医生",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','INOPDEPT^OUTOPDEPT^EMOPDEPT','','','','Y','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AuditDoctor",desc="审核医生",type="D",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    
    s code="ANDoc",desc="麻醉医生",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','AN^OUTAN^EMAN','','','','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ANSupervisor",desc="麻醉指导",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','AN^OUTAN^EMAN','','','','Y']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ANAssist",desc="麻醉助手",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','AN^OUTAN^EMAN','','','','N']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AnaestIntern",desc="麻醉实习进修",type="D",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AllANDoctor",desc="所有麻醉医生(指导、助手)",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','AN^OUTAN^EMAN','','','','']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    
    s code="ScrubNurse",desc="器械护士",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','OP^OUTOP^EMOP','','','','N']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="CirculNurse",desc="巡回护士",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','OP^OUTOP^EMOP','','','','N']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ShiftANAssist",desc="交班麻醉助手",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','AN^OUTAN^EMAN','','','','N']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ShiftScrubNurse",desc="交班洗手护士",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','OP^OUTOP^EMOP','','','','N']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="ShiftCirculNurse",desc="交班巡回护士",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','OP^OUTOP^EMOP','','','','N']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="AllOperNurse",desc="手术护士",type="D",query="{ClassName:'web.UDHCANOPArrange',QueryName:'FindCtcp',Args:['','OP^OUTOP^EMOP','','','','N']}",displayField="ctcpDesc",valueField="ctcpId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PersonColStatFlag",desc="人员统计列标志",type="D",query="",displayField="",valueField="",valueOption="{record:[{value:'SCN',desc:'器械'},{value:'CIRN',desc:'巡回'},{value:'ShiftSCN',desc:'器械交班'},{value:'ShiftCIRN',desc:'巡回交班'},{value:'ANSuper',desc:'麻醉指导'},{value:'ANDoc',desc:'麻醉医生'},{value:'ANAss',desc:'麻醉助手'},{value:'ANIntern',desc:'麻醉实习进修'},{value:'OPDoc',desc:'手术医生'},{value:'OPAss',desc:'手术助手(不分顺序)'},{value:'AssI',desc:'一助'},{value:'AssII',desc:'二助'},{value:'AssIII',desc:'三助'},{value:'AssIV',desc:'四助'},{value:'AssV',desc:'五助'},{value:'OPIntern',desc:'手术实习进修'}],total:14}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PersonShiftColStatFlag",desc="人员交接班统计列标志",type="D",query="",displayField="",valueField="",valueOption="{record:[{value:'ANS_SA',desc:'麻醉指导'},{value:'ANS_A',desc:'麻醉医生'},{value:'ANS_AA',desc:'麻醉助手'},{value:'ANS_PA',desc:'PACU医生'},{value:'ANS_SN',desc:'器械护士'},{value:'ANS_CN',desc:'巡回护士'},{value:'ANS_PN',desc:'PACU护士'}],total:7}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    
    s code="HBsAg",desc="HBsAg",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="HCVAb",desc="HCVAb",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="TPAb",desc="TPAb",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="HBSAB",desc="HBSAB",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="HBCAB",desc="HBCAB",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="HBCAG",desc="HBCAG",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="HBEAB",desc="HBEAB",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="BLDT",desc="BLDT",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="GLU",desc="GLU",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="PLT",desc="PLT",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="HCT",desc="HCT",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    s code="WBC",desc="WBC",type="L",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
   	
    s code="ANOType",desc="监护数据类型(显示)",type="R",query="",displayField="",valueField="",valueOption="{record:[{value:'V',desc:'生命体征'},{value:'D',desc:'药品'},{value:'E',desc:'事件'},{value:'T',desc:'治疗'},{value:'L',desc:'检验'}],total:5}",multiDelimiter="|",canMatchNumber=0,dataField=""
    d OutputResultItemRow
    
    s code="ANCOEventItem",desc="事件",type="R",query="{ClassName:'web.DHCANOPStat',QueryName:'FindCommonOrd',Args:['E']}",displayField="ancoDesc",valueField="ancoId",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
   	d OutputResultItemRow
   	
   	s code="DrugUsageReason",desc="用药原因",type="R",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
   	d OutputResultItemRow
   	
    
    s code="",desc="",type="R",query="",displayField="",valueField="",valueOption="",multiDelimiter="|",canMatchNumber=0,dataField=""
    s ancoId=0
    f  s ancoId=$o(^DHCANC("ComOrd",ancoId)) q:ancoId=""  d
    .s code=$p($g(^DHCANC("ComOrd",ancoId)),"^",1)
    .s desc=$p($g(^DHCANC("ComOrd",ancoId)),"^",2)
    .q:desc=""
    .q:$p(^DHCANC("ComOrd",ancoId),"^",9)'="Y"
    .d OutputResultItemRow
    
    s code="CalculateItem",desc="计算值项",type="",query="",displayField="",valueField="",valueOption="",multiDelimiter="",canMatchNumber=0,dataField="[['Percentage','百分率'],['Permillage','千分率']]"
    d OutputResultItemRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputResultItemRow
	if ('ifExistQueryItem)&&ifAddInRowItem set ^DHCANInquiry("QueryItem",code)=desc,ifAddInRowItem=0
    set Data=$lb(code,desc,type,query,displayField,valueField,valueOption,multiDelimiter,canMatchNumber)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetAllANCInquiryItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllANCInquiryItemExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetAllANCInquiryItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllANCInquiryItemExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetInquiryItemType() As %Query(ROWSPEC = "code:%String,desc:%String")
{
}

ClassMethod GetInquiryItemTypeExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s code="P",desc="就诊信息"
    d OutputRow2
    s code="B",desc="手麻基础信息"
    d OutputRow2
    s code="I",desc="ICD"
    d OutputRow2
    s code="OL",desc="手术信息"
    d OutputRow2
    s code="D",desc="手术麻醉人员"
    d OutputRow2 
    s code="O",desc="His医嘱"
    d OutputRow2
    s code="R",desc="麻醉监护数据"
    d OutputRow2 
    s code="L",desc="检验数据"
    d OutputRow2
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputRow2
    s Data=$lb(code,desc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetInquiryItemTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInquiryItemTypeExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetInquiryItemTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInquiryItemTypeExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetSummaryType",4)
Query GetSummaryType(anciId As %String = "") As %Query(ROWSPEC = "code:%String,desc:%String")
{
}

ClassMethod GetSummaryTypeExecute(ByRef qHandle As %Binary, anciId As %String = "") As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    k sumTypeList
    i +anciId'=0 d
    .s sumTypeList=""
    .m sumTypeList=^DHCANInquiry(+anciId,"SumType")
    s code="OPACount",desc="手术病人例数"
    d OutputRowSummaryType
    s code="AdmCount",desc="就诊人次"
    d OutputRowSummaryType
    s code="TheatreInOutTime",desc="入离室时间"
    d OutputRowSummaryType
    s code="ZAverageTIOTime",desc="平均入离室时间"
    d OutputRowSummaryType
    s code="OPStartEndTime",desc="手术开始结束时间"
    d OutputRowSummaryType
    s code="ZAverageOPSETime",desc="平均手术开始结束时间"
    d OutputRowSummaryType
    s code="ANAStartEndTime",desc="麻醉开始结束时间"
    d OutputRowSummaryType
    s code="ZAverageANASETime",desc="平均麻醉开始结束时间"
    d OutputRowSummaryType
    s code="PACUInOutTime",desc="恢复室开始结束时间"
    d OutputRowSummaryType
    s code="ZAveragePACUIOTime",desc="平均恢复室开始结束时间"
    d OutputRowSummaryType
    s code="ANAPrepareTime",desc="术前麻醉准备时间"
    d OutputRowSummaryType
    s code="ZAverageANAPTime",desc="平均术前麻醉准备时间"
    d OutputRowSummaryType
    s code="BeforeANPrepareTime",desc="麻醉前准备时间"
    d OutputRowSummaryType
    s code="ZAverageBANPTime",desc="平均麻醉前准备时间"
    d OutputRowSummaryType
    s code="BeforeOPPrepareTime",desc="术前准备时间"
    d OutputRowSummaryType
    s code="ZAverageBOPPTime",desc="平均术前准备时间"
    d OutputRowSummaryType
    s code="OPDate",desc="手术天数"
    d OutputRowSummaryType
    s code="NightShiftCount",desc="夜班工作数"
    d OutputRowSummaryType
    s code="OPStandardCount",desc="手术台次(每1.5小时算一次)"
    d OutputRowSummaryType
    s code="OEOrdQty",desc="医嘱数量"
    d OutputRowSummaryType
    s code="OEOrdBill",desc="医嘱费用"
    d OutputRowSummaryType
    s code="OrderQty",desc="麻醉监护数据总量"
    d OutputRowSummaryType
    s code="ItemQty",desc="项目对应数量"
    d OutputRowSummaryType
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputRowSummaryType
	q:($d(sumTypeList)&&('$d(sumTypeList(code))))
	
    s Data=$lb(code,desc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetSummaryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSummaryTypeExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetSummaryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSummaryTypeExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

Query GetInquiryStartDateTime() As %Query(ROWSPEC = "code:%String,desc:%String")
{
}

ClassMethod GetInquiryStartDateTimeExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s code="OperAppTime",desc="手术申请时间"
    d OutputRowInquiryStartDT
    s code="OperStartDate",desc="手术开始日期"
    d OutputRowInquiryStartDT
    s code="TheatreInTime",desc="手术入室时间"
    d OutputRowInquiryStartDT
    s code="AnaStartTime",desc="麻醉开始时间"
    d OutputRowInquiryStartDT
    s code="AnaEndTime",desc="麻醉结束时间"
    d OutputRowInquiryStartDT
    s code="TheatreOutTime",desc="手术离室时间"
    d OutputRowInquiryStartDT
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputRowInquiryStartDT
    s Data=$lb(code,desc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetInquiryStartDateTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInquiryStartDateTimeExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetInquiryStartDateTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInquiryStartDateTimeExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

Query GetInquiryDataField() As %Query(ROWSPEC = "code:%String,desc:%String")
{
}

ClassMethod GetInquiryDataFieldExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s code="Times",desc="数据次数"
    d OutputRowDataField
    //s code="DurationHour",desc="持续时间"
    //d OutputRowDataField
    s code="First",desc="第一次"
    d OutputRowDataField
    s code="All",desc="所有数据"
    d OutputRowDataField
    s code="Min",desc="最小值"
    d OutputRowDataField
    s code="Max",desc="最大值"
    d OutputRowDataField
    s code="AverageMinTime",desc="平均最小时间"
    d OutputRowDataField
    s code="AverageMaxTime",desc="平均最大时间"
    d OutputRowDataField
    s code="Sum",desc="数量之和"
    d OutputRowDataField
    s code="Percentage",desc="百分率"
    d OutputRowDataField
    s code="Permillage",desc="千分率"
    d OutputRowDataField
    s code="Year",desc="岁"
    d OutputRowDataField
    s code="Mouth",desc="月"
    d OutputRowDataField
    s code="Day",desc="天"
    d OutputRowDataField
    s code="StartDT",desc="事件时间"
    d OutputRowDataField
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputRowDataField
    s Data=$lb(code,desc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetInquiryDataFieldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInquiryDataFieldExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetInquiryDataFieldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInquiryDataFieldExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod GetOpaInfoTitle(anciId, anciiSub) As %String
{
    s result=""
    i $d(^DHCANCInquiry(+anciId,"I",+anciiSub)) s result=$lg(^DHCANCInquiry(+anciId,"I",+anciiSub),10)
    q result
}

/// 获取查询项目信息详细,当项目信息过多时将不在界面直接显示,通过弹出框显示
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","FindOpaInfo",4,2,4,7)
Query FindOpaInfo(anciId, searchLevel, anciiSub, opaId) As %Query(ROWSPEC = "opaInfoId:%String,opaInfo:%String")
{
}

ClassMethod FindOpaInfoExecute(ByRef qHandle As %Binary, anciId, searchLevel, anciiSub, opaId) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s qHandle=$lb(0,repid,0)
    q:'$d(^DHCANInquiry(+anciId,"OpaInfo",+opaId,+anciiSub)) $$$OK
    s opaInfoId=""
    f  s opaInfoId=$o(^DHCANInquiry(anciId,"OpaInfo",opaId,anciiSub,opaInfoId)) q:opaInfoId=""  d
    .s opaInfo=$p(^DHCANInquiry(anciId,"OpaInfo",opaId,anciiSub,opaInfoId),"^",2)
    .d OutputStatOpaInfo
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputStatOpaInfo
    s Data=$lb(opaInfoId,opaInfo)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod FindOpaInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOpaInfoExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod FindOpaInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOpaInfoExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// w ##class(web.DHCANOPStat).GetOpaInfo(4,2,4,7)
ClassMethod GetOpaInfo(anciId, searchLevel, anciiSub, opaId) As %String
{
	s result=""
	s opaInfoId=""
    f  s opaInfoId=$o(^DHCANInquiry(anciId,"OpaInfo",opaId,anciiSub,opaInfoId)) q:opaInfoId=""  d
    .s opaInfo=$p(^DHCANInquiry(anciId,"OpaInfo",opaId,anciiSub,opaInfoId),"^",2)
    .i result'="" s result=result_","
    .s result=result_opaInfo
    
    q result
}

/// w ##class(web.DHCANOPStat).GetInquiryResultCount(4,2)
ClassMethod GetInquiryResultCount(anciId, historySeq = "") As %String
{
    s ifHistoryData=0,historySeq=+historySeq
    i $d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq)) s ifHistoryData=1
    
    s count=$s('ifHistoryData:+$g(^DHCANInquiry(+anciId,"count")),ifHistoryData:+$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"count")))
    
    q count
}

/// w ##class(web.DHCANOPStat).GetSingleInquiryResult(4,1,"OPACount")
ClassMethod GetSingleInquiryResult(anciId, resultInd, sumType = "", historySeq = "") As %String
{
    s ifHistoryData=0,historySeq=+historySeq
    i $d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq)) s ifHistoryData=1
    
    k colCodeList,dataList
    s colCodeList=$s('ifHistoryData:^DHCANInquiry(anciId),ifHistoryData:^DHCANInquiry("HistoryData",anciId,"Count",historySeq))
    s colCount=$ll(colCodeList)
    s result="{"
    i $d(^DHCANInquiry(+anciId,"Result",+resultInd)) d
    .s ifFirst=1
    .i 'ifHistoryData d
    ..i (sumType'="")&&($d(^DHCANInquiry(anciId,"Result",resultInd,"SumType",sumType))) s dataList=^DHCANInquiry(anciId,"Result",resultInd,"SumType",sumType)
    ..e  s dataList=^DHCANInquiry(anciId,"Result",resultInd)
    .e  d
    ..i (sumType'="")&&($d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result",resultInd,"SumType",sumType))) s dataList=^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result",resultInd,"SumType",sumType)
    ..e  s dataList=^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result",resultInd)
    .f j=1:1:colCount d
    ..s colCode=$lg(colCodeList,j)
    ..s tmpData=$lg(dataList,j)
    ..s tmpData=..ReplaceString(tmpData,"'","\'")
    ..s tmpData=..ReplaceString(tmpData,$c(13),"\n")
    ..s tmpData=..ReplaceString(tmpData,$c(10),"\r")
    ..s tmpData=..ReplaceString(tmpData,$c(2),"<$C2>")
    ..s tmpData=..ReplaceString(tmpData,$c(5),"<$C5>")
    ..s tmpData=..ReplaceString(tmpData,$c(7),"<$C7>")
    ..i 'ifFirst s result=result_","
    ..s result=result_"'"_colCode_"':'"_tmpData_"'"
    ..s ifFirst=0
    s result=result_"}"
    q result
}

/// 取性别
Query GetSex() As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTSEXRowId:%Integer,CTSEXDesc:%String")
{
    select CTSEX_RowId,CTSEX_Desc from SQLUser.CT_Sex
}

/// 取医院
Query GetHospitalList() As %SQLQuery(CONTAINID = 1, ROWSPEC = "HOSPRowId:%Integer,HOSPDesc:%String")
{
    select HOSP_RowId,HOSP_Desc from SQLUser.CT_Hospital
}

/// 取麻醉方法类型ORC_AnaestType
Query GetAnaestTypeList() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ANTYPERowId:%Integer,ANTYPEDesc:%String")
{
    select ANTYPE_RowId,ANTYPE_Desc from SQLUser.ORC_AnaestType
}

/// 取核算分类
Query GetEMCCatList() As %SQLQuery(CONTAINID = 1, ROWSPEC = "RowId:%Integer,Desc:%String")
{
    select TAREC_RowId,TAREC_Desc from SQLUser.DHC_TarEMCCate
}

/*
/// 取耗材类型
Query GetStockCatList() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ANCSCRowId:%Integer,ANCSCDesc:%String")
{
    select ID,ANCSC_Desc from SQLUser.DHC_ANC_StockCat
}

/// 取耗材
Query GetStockItemList() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ANCSIRowId:%Integer,ANCSIDesc:%String")
{
    select ANCSI_RowId,ANCSI_Desc from SQLUser.DHC_ANC_StockItem
}
*/
Query FindOEOrderCat(ViewSuperCat As %String) As %Query(ROWSPEC = "ORCatDesc:%String,RowId:%String")
{
}

ClassMethod FindOEOrderCatExecute(ByRef qHandle As %Binary, ViewSuperCat As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RowId=0
    f  s RowId=$o(^OEC("ORCAT",RowId))  q:RowId=""  d
    .s ORCatID=$p(^OEC("ORCAT",RowId),"^",1)    
    .s ORCatDesc=$p(^OEC("ORCAT",RowId),"^",2)
    .i (ViewSuperCat'="")&&((ViewSuperCat=RowId)||(ORCatDesc[ViewSuperCat)) d OutputRow6
    .i (ViewSuperCat="") d OutputRow6
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow6
    set Data=$lb(ORCatDesc,RowId)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindOEOrderCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOEOrderCatExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindOEOrderCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOEOrderCatExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindArcimCat(ViewCat As %String, ViewSuperCat As %String) As %Query(ROWSPEC = "ARCICatDesc:%String,RowId:%String")
{
}

ClassMethod FindArcimCatExecute(ByRef qHandle As %Binary, ViewCat As %String, ViewSuperCat As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RowId=0
    f  s RowId=$o(^ARC("IC",RowId))  q:RowId=""  d
    .s ARCICatID=$p(^ARC("IC",RowId),"^",1)
    .s ARCICatDesc=$p(^ARC("IC",RowId),"^",2)
    .s ARCViewSuperCatID=$p(^ARC("IC",RowId),"^",8)
    .i (ViewCat'="")&&((ViewCat=RowId)||(ARCICatDesc[ViewCat))&&(ViewSuperCat'="")&&(ViewSuperCat=ARCViewSuperCatID) d OutputRowArcimCat
    .i (ViewCat'="")&&((ViewCat=RowId)||(ARCICatDesc[ViewCat))&&(ViewSuperCat="") d OutputRowArcimCat
    .i (ViewCat="")&&(ViewSuperCat'="")&&(ViewSuperCat=ARCViewSuperCatID) d OutputRowArcimCat
    .i (ViewCat="")&&(ViewSuperCat="") d OutputRowArcimCat 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowArcimCat
    set Data=$lb(ARCICatDesc,RowId)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindArcimCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimCatExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindArcimCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimCatExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","FindOrcItmMast","白","")
Query FindOrcItmMast(OrcItmMast As %String, ViewCat As %String) As %Query(ROWSPEC = "ARCIMastDesc:%String,ARCIMastRowID:%String")
{
}

ClassMethod FindOrcItmMastExecute(ByRef qHandle As %Binary, OrcItmMast As %String, ViewCat As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s ARCIMastRowID=""
    s RowId=0,subID=0
    f  s RowId=$o(^ARCIM(RowId)) q:RowId=""  d
    .f  s subID=$o(^ARCIM(RowId,subID)) q:subID=""  d
      ..s ARCIMastDesc=$p(^ARCIM(RowId,subID,1),"^",2)
      ..s ARCViewCatID=$p(^ARCIM(RowId,subID,1),"^",10)   
      ..s ARCIMastRowID=RowId_"||"_subID
      ..i (OrcItmMast'="")&&((OrcItmMast=ARCIMastRowID)||(ARCIMastDesc[OrcItmMast))&&(ViewCat'="")&&(ViewCat=ARCViewCatID) d OutputRowItmMast
      ..i (OrcItmMast'="")&&((OrcItmMast=ARCIMastRowID)||(ARCIMastDesc[OrcItmMast))&&(ViewCat="") d OutputRowItmMast
      ..i (OrcItmMast="")&&(ViewCat'="")&&(ViewCat=ARCViewCatID) d OutputRowItmMast
      ..//i (OrcItmMast="")&&(ViewCat="") d OutputRowItmMast      
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowItmMast
    set Data=$lb(ARCIMastDesc,ARCIMastRowID)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindOrcItmMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrcItmMastExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindOrcItmMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrcItmMastExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCANOPStat).GetStatDetailTitle(4,11,"S-3")
ClassMethod GetStatDetailTitle(anciId, displayId, colName, historySeq = "") As %String
{
    q:'$d(^DHCANCInquiry(+anciId)) "无此查询策略"
    q:$lg(^DHCANCInquiry(anciId),10)'="S" "非统计查询策略,无明细查看"
    
    s ifHistoryData=0,historySeq=+historySeq
    i $d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq)) s ifHistoryData=1
    
    q:('ifHistoryData)&&('$d(^DHCANInquiry(+anciId,"FI","Display",+displayId))) "结果中无此行数据"
    q:(ifHistoryData)&&('$d(^DHCANInquiry("HistoryData",+anciId,"Count",historySeq,"FI","Display",+displayId))) "结果中无此行数据"
    
    k searchList,displayList,treeList
    s anciiSub=""
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    .s anciiCode=$lg(^DHCANCInquiry(anciId,"I",anciiSub),1)
    .s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    .s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    .s anciiNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),10)
    .s anciiMultipleValue=$lg(^DHCANCInquiry(anciId,"I",anciiSub),11)
    .s anciiRelateAnciiSub=$lg(^DHCANCInquiry(anciId,"I",anciiSub),26)
    .s treeList("Header",anciiSub,"Desc")=anciiDesc
    .i anciiNote'="" s treeList("Header",anciiSub,"Desc")= treeList("Header",anciiSub,"Desc")_"("_anciiNote_")"
    .i anciiIsSearch&&anciiIsDisplay  d
    ..s searchList(searchLevel,"Code")="S-"_searchLevel
    ..i $d(searchList(searchLevel,"Desc")) s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_","
    ..s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_anciiDesc
    ..i anciiNote'="" d
    ...i $g(searchList(searchLevel,"Note"))'="" s searchList(searchLevel,"Note")=searchList(searchLevel,"Note")_","
    ...s searchList(searchLevel,"Note")=$g(searchList(searchLevel,"Note"))_anciiNote
    ..s anciiSummaryType=$lg(^DHCANCInquiry(anciId,"I",anciiSub),24)
    ..i anciiSummaryType'="" d
    ...f i=1:1:$l(anciiSummaryType,",") d
    ....s summaryType=$p(anciiSummaryType,",",i)
    ....s searchList(searchLevel,"SumType",summaryType)=""
    .e  i anciiIsDisplay  d
    ..s displayList(searchLevel,"Count")=$g(displayList(searchLevel,"Count"))+1
    
    i +$o(^DHCANInquiry(anciId,"AllPath",""))>0 d
    .s treeAnciiSub=""
    .f  s treeAnciiSub=$o(^DHCANInquiry(anciId,"AllPath",treeAnciiSub)) q:treeAnciiSub=""  d
    ..s searchLevel=+$lg(^DHCANCInquiry(anciId,"I",treeAnciiSub),21)
    ..s anciiMultipleValue=$lg(^DHCANCInquiry(anciId,"I",treeAnciiSub),11)
    ..s treeList("SearchList",searchLevel,"Code")="S-"_searchLevel
    ..s treeList("SearchList",searchLevel,"Desc")=""
    ..s pathStr=^DHCANInquiry(anciId,"AllPath",treeAnciiSub)
    ..f i=1:1:$l(pathStr,"->") d
    ...//生成类似level形式序列
    ...s anciiSub=$p(pathStr,"->",i)
    ...s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    ...i $g(treeList("SearchList",searchLevel,"Desc"))'="" s treeList("SearchList",searchLevel,"Desc")=treeList("SearchList",searchLevel,"Desc")_","
    ...i anciiIsDisplay s treeList("SearchList",searchLevel,"Desc")=$g(treeList("SearchList",searchLevel,"Desc"))_treeList("Header",anciiSub,"Desc")
    ..k searchList
    ..m searchList=treeList("SearchList")
    
    s title=""
    s searchLevel=""
    f  s searchLevel=$o(displayList(searchLevel)) q:searchLevel=""  d
    .s anciiSub="",opaInfo="",opstatRowCode="D-"_searchLevel,lastOpaInfo=""
    .i (('ifHistoryData)&&('$d(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel))))||((ifHistoryData)&&('$d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Item",searchLevel)))) d
    ..s opaInfo="总计"
    .e  d
    ..f  s anciiSub=$s('ifHistoryData:$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel,anciiSub)),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Item",searchLevel,anciiSub))) q:anciiSub=""  d
    ...s anciiCode=$lg(^DHCANCInquiry(anciId,"I",anciiSub),1)
    ...s anciiOpaInfo=$s('ifHistoryData:$g(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",searchLevel,anciiSub)),ifHistoryData:$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Item",searchLevel,anciiSub)))
    ...s lastOpaInfo=$p(anciiOpaInfo,"^",2)
    ...s anciiOpaInfo=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)_":"_$p(anciiOpaInfo,"^",2)
    ...s anciiOpaInfo=..ReplaceString(anciiOpaInfo,$c(34),"'")
    ...i opaInfo'="" s opaInfo=opaInfo_","
    ...s opaInfo=opaInfo_anciiOpaInfo
    .i $g(displayList(searchLevel,"Count"))=1 s opaInfo=lastOpaInfo
    .i title'="" s title=title_","
    .s title=title_opaInfo

    s searchLevel="",displayCountSum=0,curSearchLevel=$p(colName,"-",2),curItemDetailStr=""
    f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    .s sumcount=""
    .i $d(searchList(searchLevel,"SumType")) d
    ..s summaryType=""
    ..f  s summaryType=$o(searchList(searchLevel,"SumType",summaryType)) q:summaryType=""  d
    ...i sumcount'="" s sumcount=sumcount_"//"
    ...s sumUom="",sumUomCount=""
    ...f  s sumUom=$s('ifHistoryData:$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",sumUom)),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",sumUom))) q:sumUom=""  d
    ....i sumUomCount'="" s sumUomCount=sumUomCount_","
    ....s sumUomCount=sumUomCount_$s('ifHistoryData:+$g(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",sumUom)),ifHistoryData:+$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Level",searchLevel,0,"SumType",summaryType,"Uom",sumUom)))
    ....i sumUom'="-" s sumUomCount=sumUomCount_sumUom
    ...s sumcount=sumcount_sumUomCount
    .e  d
    ..s sumcount=$s('ifHistoryData:+$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,""),-1),ifHistoryData:+$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Level",searchLevel,""),-1))
    .i sumcount="" s sumcount=0
    .i curSearchLevel=searchLevel s curItemDetailStr=searchList(searchLevel,"Desc")_":"_sumcount
    .i title'="" s title=title_", ["
    .i $d(searchList(searchLevel,"Note")) s title=title_searchList(searchLevel,"Note")_":"_sumcount_"]"
    .e  s title=title_searchList(searchLevel,"Desc")_":"_sumcount_"]"

    s anciDesc=$lg(^DHCANCInquiry(anciId),2)

    q anciDesc_":{"_title_"  当前查看明细:["_curItemDetailStr_"]}"
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","FindStatDetails",10,0,"S-3")
Query FindStatDetails(anciId As %String, displayId As %String, colName As %String, historySeq As %String = "") As %Query(ROWSPEC = "opaId,status,jzstat,opdatestr,appLocDesc,regno,medCareNo,patName,sex,age,diagStr,opdes,surgeonDesc,ash,opAntibiotic,anmethod,mzdoc,MiniInvasiveStr,HbsAg,HCVAb,HivAb,TPAb,TestOther,oplevel,xsh,xch,opduration,jb,opreq,jbxsh,scNurNote,jbxch,cirNurNote,theatreInOutDuration,anaTheatreDateTimeStr,anaStartEndDuration,anaDateTimeStr,searchOpaInfo,totalStatInfo")
{
}

ClassMethod FindStatDetailsExecute(ByRef qHandle As %Binary, anciId As %String, displayId As %String, colName As %String, historySeq As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    k summaryTypeDescList
    s summaryTypeDescList("OPACount")="手术病人例数"
    s summaryTypeDescList("AdmCount")="就诊人次"
    s summaryTypeDescList("TheatreInOutTime")="入离室时间"
    s summaryTypeDescList("OPStartEndTime")="手术开始结束时间"
    s summaryTypeDescList("ANAStartEndTime")="麻醉开始结束时间"
    s summaryTypeDescList("PACUInOutTime")="恢复室开始结束时间"
    s summaryTypeDescList("OEOrdQty")="医嘱数量"
    s summaryTypeDescList("OEOrdBill")="医嘱费用"
    s summaryTypeDescList("OrderQty")="麻醉监护数据总量"
    s summaryTypeDescList("ZAverageTIOTime")="平均入离室时间"
    s summaryTypeDescList("ZAverageOPSETime")="平均手术开始结束时间"
    s summaryTypeDescList("ZAverageANASETime")="平均麻醉开始结束时间"
    s summaryTypeDescList("ZAveragePACUIOTime")="平均恢复室开始结束时间"
    s summaryTypeDescList("ZAverageANAPTime")="平均术前麻醉准备时间"
    s summaryTypeDescList("ZAverageBANPTime")="平均麻醉前准备时间"
    s summaryTypeDescList("ZAverageBOPPTime")="平均术前准备时间"
    s summaryTypeDescList("OPDate")="手术天数"
    s summaryTypeDescList("OPStandardCount")="手术台次(每1.5小时算一次)"
    s summaryTypeDescList("NightShiftCount")="夜班工作数"
    s summaryTypeDescList("ItemQty")="此项目数量"
    
    s ifHistoryData=0,historySeq=+historySeq
    i $d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq)) s ifHistoryData=1
    
    s decimalDigits=2,timeScale=3600
    s detailSearchLevel=+$p(colName,"-",2)
    s detailAnciiSub=0
    s anciiSub=""
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s summaryType=$lg(^DHCANCInquiry(anciId,"I",anciiSub),24)
    .i searchLevel=detailSearchLevel s detailAnciiSub=anciiSub
    
    s opaSeq=0
    f  s opaSeq=$s('ifHistoryData:$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",detailSearchLevel,opaSeq)),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Level",detailSearchLevel,opaSeq))) q:opaSeq=""  d
    .s opaId=$lg($s('ifHistoryData:^DHCANInquiry(anciId,"FI","Display",displayId,"Level",detailSearchLevel,opaSeq),ifHistoryData:^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Level",detailSearchLevel,opaSeq)),1)
    .s searchOpaInfo=$s('ifHistoryData:$g(^DHCANInquiry(anciId,"FI","SearchOpaInfo",detailSearchLevel,opaId)),ifHistoryData:$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","SearchOpaInfo",detailSearchLevel,opaId)))
    .s totalStatInfo=$$GetDetailStatInfo(detailSearchLevel,opaSeq)
    .d GetANOPData(opaId)
    .d OutputRowOP
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
GetDetailStatInfo(searchLevel,opaSeq)
    s statInfo=""
    s ifStatInfoHasDetail=0
    i $d(^DHCANInquiry(+anciId,"OpaInfo",+opaId,+detailAnciiSub)) s ifStatInfoHasDetail=1
    s opaStatInfo=$s('ifHistoryData:^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,opaSeq),ifHistoryData:^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Level",searchLevel,opaSeq))
    f i=2:1:$ll(opaStatInfo) d
    .s curStatInfo=$lg(opaStatInfo,i)
    .s summaryType=$p(curStatInfo,"^",1)
    .s sumCount=$p(curStatInfo,"^",2)
    .s sumUom=$p(curStatInfo,"^",3)
    .s sumInfo=sumCount_sumUom
    .i ifStatInfoHasDetail s sumInfo="<a id='a_"_anciId_"_"_searchLevel_"_"_detailAnciiSub_"_"_opaId_"' href='javascript:void(0)' onclick='ShowOpaInfo("_anciId_","_searchLevel_","_detailAnciiSub_","_opaId_")' title='更多'>"_sumInfo_"</a>"
    .s statInfo=statInfo_$g(summaryTypeDescList(summaryType))_":"_sumInfo_$c(13)
    q statInfo

GetANOPData(opaId)
    s note=$g(^DHCANARRAGE("note",opaId))                       //注意事项
    s opreq=$g(^DHCANARRAGE("opreq",opaId))                     //备注
    s jb=$g(^DHCANARRAGE("jb",opaId))                           //交班
    
    s HbsAg=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",29)           //OPA_PATestHBsAg   免疫乙肝表面抗原
    s HCVAb=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",34)           //OPA_PATestHCVAb   免疫丙型肝炎抗体
    s HivAb=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",35)           //OPA_PATestHivAb   免疫艾滋病毒抗体
    s TPAb=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",36)            //OPA_PATestTPAb    免疫梅毒
    s TubEx=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",2)                //OPA_PATestOther   检其它阴阳性
    s HBSAB=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",30)
    s HBCAB=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",33)
    s HBCAG=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",31)
    s HBEAB=$p($g(^DHCANOPArrange(opaId,"PALab")),"^",32)
    s bloodTypId=$p(^DHCANOPArrange(opaId),"^",11)     //血型
    i (+bloodTypId'=0)&($d(^PAC("BLDT",+bloodTypId))) s bloodType=$p($g(^PAC("BLDT",bloodTypId)),"^",2)
    e  s bloodType="化验中"
    s RHBloodType=$p(^DHCANOPArrange(opaId),"^",25)                         //OPA_RHBloodType   RH血型
    s Isolated=$p(^DHCANOPArrange(opaId),"^",10)                            //OPA_Isolated      是否隔离
    s PrepareBlood=$p(^DHCANOPArrange(opaId),"^",33)                        //OPA_PrepareBlood  是否备血
    s UseSelfBlood=$p(^DHCANOPArrange(opaId),"^",34)                        //OPA_UseSelfBlood  是否自体血回输
    s ExCirculation=$p(^DHCANOPArrange(opaId),"^",36)                       //OPA_ExCirculation 是否体外循环
    s NeedAnaesthetist=$p(^DHCANOPArrange(opaId),"^",44)                    //OPA_NeedAnaesthetist是否麻醉会诊
    s MiniInvasive=$p(^DHCANOPArrange(opaId),"^",13)                        //OPA_MiniInvasive  是否微创手术
    s MiniInvasiveStr="否"
    i MiniInvasive="Y" s MiniInvasiveStr="是"
    s NeedNavigation=$p(^DHCANOPArrange(opaId),"^",55)                      //OPA_NeedNavigation 是否导航
    s UnPlanedOp=""
    s UnPlanedOp=$p(^DHCANOPArrange(opaId),"^",46)     //OPA_UnPlanedOp 是否非计划再次手术
    s majorSurgery=""
    s majorSurgery=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",30)   //重大手术
    s opmem=$p(^DHCANOPArrange(opaId),"^",19)           //手术备注?
    s opaStatus=$p(^DHCANOPArrange(opaId),"^",27)                 //OPA_Status  手术状态
    s status=""
    s opaPatStatus=$p(^DHCANOPArrange(opaId),"^",23)
    i opaStatus="A" s status="申请"
    i (opaStatus="D")&(opaPatStatus'="I") s status="拒绝"
    i opaStatus="R" s status="安排"
    i opaStatus="N" s status="非预约"
    i opaStatus="I" s status="术中"
    i opaStatus="P" s status="恢复室"
    i opaStatus="L" s status="术毕"
    i opaStatus="F" s status="完成"
    i (opaStatus="D")&(opaPatStatus="I") s status="撤销"
    s opstdate=$p(^DHCANOPArrange(opaId),"^",14)          //手术开始日期
    s opsttime=$p(^DHCANOPArrange(opaId),"^",15)          //手术开始时间
    s oparrdate=$p(^DHCANOPArrange(opaId),"^",7)          //手术安排日期
    s oparrtime=$p(^DHCANOPArrange(opaId),"^",8)          //手术安排时间
    s openddate=$p(^DHCANOPArrange(opaId),"^",16)         //手术结束日期
    s opendtime=$p(^DHCANOPArrange(opaId),"^",17)         //手术结束时间
    s opduration=""
    //s opduration=(openddate-opstdate)*24*3600+opendtime-opsttime
    //i opduration<0 s opduration=0
    //s opduration=opduration/timeScale
    //s opduration=$num(opduration,decimalDigits)
    //s opduration=opduration_"h"
    s opstdatestr="",oparrdatestr="",openddatestr="",opsttimestr="",oparrtimestr="",opendtimestr=""
    //i opstdate'="" s opstdatestr=$zd(opstdate,3)          //YYYY-MM-DD格式
    i oparrdate'="" s oparrdatestr=$zd(oparrdate,3)
    //i openddate'="" s openddatestr=$zd(openddate,3)
    //i opsttime'="" s opsttimestr=$zt(opsttime)
    i oparrtime'="" s oparrtimestr=$zt(oparrtime)
    //i opendtime'="" s opendtimestr=$zt(opendtime)
    
    s preDiscussDate=$p(^DHCANOPArrange(opaId),"^",38)     //术前讨论日期
    s estiOperDuration=$p(^DHCANOPArrange(opaId),"^",37)   //计划手术过程时间
    s opordno=$p(^DHCANOPArrange(opaId),"^",26)             //台次
    s oproomdr=$p(^DHCANOPArrange(opaId),"^",20)           //手术间
    s oproomdes=""
    i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
    s sortOpRoomDesc=oproomdes
    i oproomdes="" s oproomdes="无"
    s sortOpaSeq=opordno
    i opordno="" s opordno="未排"
    s instrumentDr=$p($g(^DHCANOPArrange(opaId)),"^",30) 
    i instrumentDr'="" s instrument=$p($g(^DHCANC("Instrument",instrumentDr)),"^",2)    //DHC_ANC_Instrument    器械
    e  s instrument=""
    s isAddInstrument=$p($g(^DHCANOPArrange(opaId)),"^",31)             //OPA_AddInstrument     是否补充器械
    s NeedAnaesthetist=$p($g(^DHCANOPArrange(opaId)),"^",44)        //是否麻醉
    s scNurNote=$p($g(^DHCANOPArrange(opaId)),"^",51)       //OPA_ScrubNurseNote    器械护士备注  
    s cirNurNote=$p($g(^DHCANOPArrange(opaId)),"^",52)      //OPA_CirculNurseNote   巡回护士备注
    s isAddInstrument=$p($g(^DHCANOPArrange(opaId)),"^",31)  //是否补充器械
    s patWardId=$p($g(^DHCANOPArrange(opaId)),"^",32)   //病人病区Id
    i patWardId'="" s patWard=$p($g(^PAWARD(patWardId)),"^",2)
    e  s patWard=""
    s opDocNote1=$p($g(^DHCANOPArrange(opaId)),"^",42)  //手术医生备注
    s opDocNote=$p(opDocNote1,$C(1),1)
    s anDocNote=$p($g(^DHCANOPArrange(opaId)),"^",43)   //麻醉医生备注
    s opSeqNote=$p($g(^DHCANOPArrange(opaId)),"^",41)   //手术编号
    s retReasonId=$p($g(^DHCANOPArrange(opaId)),"^",35)
    i opaStatus'="D" s retReasonId=""
    i retReasonId'=""  s retReason=$p(^ORC("SUSP",retReasonId),"^",2)  //手术拒绝原因
    e  s retReason=""
    s anaDoctorOrd=$p($g(^DHCANOPArrange(opaId)),"^",48)   //麻醉医生收费状态
    i anaDoctorOrd="Y"  s anaDoctorOrd="Y"
    e  s anaDoctorOrd="N"
    s anaNurseOrd=$p($g(^DHCANOPArrange(opaId)),"^",49)   //麻醉护士收费状态
    i anaNurseOrd="Y"  s anaNurseOrd="Y"
    e  s anaNurseOrd="N"
    s opNurseOrd=$p($g(^DHCANOPArrange(opaId)),"^",50)    //手术护士收费状态
    i opNurseOrd="Y"  s opNurseOrd="Y"
    e  s opNurseOrd="N"
    s tPacuBedId=$p($g(^DHCANOPArrange(opaId)),"^",47)
    i tPacuBedId'="" s tPacuBed=$p(^DHCANC("OPRoom",tPacuBedId),"^",2)
    e  s tPacuBed=""
    s PACUInDate=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",6)
    i PACUInDate'="" s PACUInDate=$zd(PACUInDate,3)
    s PACUInTime=$p($g(^DHCANOPArrange(opaId,"PACU")),"^",7)
    i PACUInTime'="" s PACUInTime=$zt(PACUInTime)
    s PACUInDateTime=PACUInDate_" "_PACUInTime
    s appLocDesc="",patWard=""
    s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)   //OPA_AppLoc_Dr 手术申请科室
	s appLocDesc=$p($g(^CTLOC(+appLocId)),"^",2)
    s patWardId=$p($g(^DHCANOPArrange(opaId)),"^",32)
    i patWardId'="" s patWard=$p($g(^PAWARD(+patWardId)),"^",2)  //病人所在病区
    s tDocArriveTime=$p(^DHCANOPArrange(opaId),"^",58)  //医生入室时间
    i tDocArriveTime'="" s tDocArriveTime=##class(web.DHCClinicCom).ConvertToTime(tDocArriveTime)
    s PatHeight=$p(^DHCANOPArrange(opaId),"^",22)
    s PatWeight=$p(^DHCANOPArrange(opaId),"^",24)
    s OPLevelDR=$p(^DHCANOPArrange(opaId),"^",28)
    i OPLevelDR'="" s oplevel=$p(^DHCANC("OPLevel",OPLevelDR),"^",2)
    e  s oplevel=""
    
    //取病人相关数据
    s EpisodeID=$p(^DHCANOPArrange(opaId),"^",1) //就诊号
    s bedCode="",inPatNo="",admreason=""
    s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
    i curWardId'="" s WardDes=$p(^PAWARD(curWardId),"^",1) //病人所在病区
    i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1) //床位
    s inPatNo=$p($g(^PAADM(EpisodeID)),"^",29) //住院号
    s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
    s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1) //登记号
    //s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //病案号
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)  //姓名
    s PersonID=$p($g(^PAPER(papmiId,"ALL")),"^",9)  //身份证
    s paersonLX=$p($g(^PAPER(papmiId,"PER",2)),"^",13) //联系人
    s paersonLXDH=$p($g(^PAPER(papmiId,"ALL")),"^",4) //联系人电话
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)  //生日
    s age=##class(web.UDHCANOPArrange).CalAge(birth,opstdate) //年龄
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2) //性别
    //取病人麻醉信息表数据
    s anaId=$p($g(^DHCANOPArrange(opaId)),"^",2)
    s anaSub=$p(anaId,"||",2),mzdoc="",mzsupdoc="",mzNurse="",anmethod=""
    s mzdr=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",6)  //ANA_Anaesthetist_Dr 麻醉医师
    i mzdr'="" d
    .s mzdoc=##class(web.DHCANOPCom).GetNameById(mzdr) //麻醉医生
    e  s mzdoc=""
    s mzsupdr=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",7)  //ANA_Supervisor_Dr  麻醉辅导医师
    i mzsupdr'="" d     
    .s mzsupdoc=##class(web.DHCANOPCom).GetNameById(mzsupdr) //麻醉辅导医师
    e  s mzsupdoc=""
    s mzNurseId=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",8)           //ANA_ORAnaNurse_DR     麻醉护士
    i mzNurseId'="" d
    .s mzNurse=##class(web.DHCANOPCom).GetNameById(mzNurseId) //麻醉护士
    e  s mzNurse=""
    
    s anmthdr=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",5)       ;ANA_Method   麻醉方法
    s anmethod=##class(web.DHCANOPCom).GetAnMethodDescById(anmthdr,",")
    //特殊  安徽省立
	//i anmthdr'="" s anmethod=$P($g(^ORC("ANMET",+anmthdr)),"^",2)
	
    s jz=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",32)                         //ANA_SourceType 急诊(E)/择期(B)
    i jz="E" s jzstat="急诊"
    e  s jzstat="择期"
    //出入室时间
    s anaTheatreInDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    s anaTheatreInTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",40)   //入室时间
    s anaTheatreOutDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)  //离室日期
    s anaTheatreOutTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",42)  //离室时间
    //特殊 安徽省立
	s opDate=$p(^DHCANOPArrange(opaId),"^",14)
	s opDate=$zd(opDate,3)
	//s OPNurseShiftTimeStr=##class(web.UDHCANOPArrange).GetOperNurseDT(EpisodeID,opDate)
	//s anaTheatreInDate=$zdh(opDate,3)   //入室日期
	//s anaTheatreInTime=$p(OPNurseShiftTimeStr,"^",1)   //入室时间
	//i anaTheatreInTime'="" s anaTheatreInTime=$zth(anaTheatreInTime,2)
	//e  s anaTheatreInTime=+$p(^DHCANOPArrange(opaId),"^",15)
	//s anaTheatreOutDate=$p(OPNurseShiftTimeStr,"^",2)   //出室日期
	//i anaTheatreOutDate'="" s anaTheatreOutDate=$zdh(anaTheatreOutDate,3)
	//s anaTheatreOutTime=$p(OPNurseShiftTimeStr,"^",3)   //出室时间
	//i anaTheatreOutTime'="" s anaTheatreOutTime=$zth(anaTheatreOutTime,2)
    s theatreInOutDuration=(anaTheatreOutDate-anaTheatreInDate)*24*3600+anaTheatreOutTime-anaTheatreInTime
    i theatreInOutDuration<0 s theatreInOutDuration=0
    s theatreInOutDuration=theatreInOutDuration/timeScale
    s theatreInOutDuration=$num(theatreInOutDuration,decimalDigits)
    s theatreInOutDuration=theatreInOutDuration_"h"
    i anaTheatreInDate'="" s anaTheatreInDate=$zd(anaTheatreInDate,3)
    e  s anaTheatreInDate=opstdate
    i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,2)
    e  s anaTheatreInTime=opsttime
    i anaTheatreOutDate'="" s anaTheatreOutDate=$zd(anaTheatreOutDate,3)
    i anaTheatreOutTime'="" s anaTheatreOutTime=$zt(anaTheatreOutTime,2)
    s anaTheatreDateTimeStr=anaTheatreInDate_" "_anaTheatreInTime_"~"_anaTheatreOutDate_" "_anaTheatreOutTime
    
    s transInfo=##Class(web.DHCClinicCom).GetTransInfoByTime(EpisodeID,anaTheatreInDate,anaTheatreInTime)
	i +transInfo d
	.//s appLocId=+transInfo
	.//s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
	i +$P(transInfo,"^",2) d
	.s curWardId=+$P(transInfo,"^",2)  
	.s WardDes=$P($g(^PAWARD(curWardId)),"^",1)
	
    //s anaStartDateTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"AnaStart",-1,"Y","","")
    //s anaEndDateTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"AnaEnd",-1,"Y","","")
    //s anaDateTimeStr=anaStartDateTime_"~"_anaEndDateTime
    //s anaStartDate=##class(web.DHCANOPCom).ConvertToDateH($p(anaStartDateTime," ",1))   //麻醉开始日期
    //s anaStartTime=##class(web.DHCANOPCom).ConvertanciiToTimeH($p(anaStartDateTime," ",2))   //麻醉开始时间
    //s anaEndDate=##class(web.DHCANOPCom).ConvertToDateH($p(anaEndDateTime," ",1))   //麻醉结束日期
    //s anaEndTime=##class(web.DHCANOPCom).ConvertanciiToTimeH($p(anaEndDateTime," ",2))   //麻醉结束时间
    //新版手麻可通过以下取手术开始结束日期时间
    s anaStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",2)   //麻醉开始日期
    s anaStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",3)   //麻醉开始时间
    s anaEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",29)   //麻醉结束日期
    s anaEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",4)   //麻醉结束时间
    s anaStartEndDuration=(anaEndDate-anaStartDate)*24*3600+anaEndTime-anaStartTime
    i anaStartEndDuration<0 s anaStartEndDuration=0
    s anaStartEndDuration=anaStartEndDuration/timeScale
    s anaStartEndDuration=$num(anaStartEndDuration,decimalDigits)
    s anaStartEndDuration=anaStartEndDuration_"h"
    i anaStartDate'="" s anaStartDate=$zd(anaStartDate,3)
    e  s anaStartDate=opstdate
    i anaStartTime'="" s anaStartTime=$zt(anaStartTime,2)
    e  s anaStartTime=opsttime
    i anaEndDate'="" s anaEndDate=$zd(anaEndDate,3)
    i anaEndTime'="" s anaEndTime=$zt(anaEndTime,2)
    s anaDateTimeStr=anaStartDate_" "_anaStartTime_"~"_anaEndDate_" "_anaEndTime
    
    //s opdatestr=opstdatestr_" "_opsttimestr_"~"_openddatestr_" "_opendtimestr
    //s anopStartDateTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"OperStart",-1,"Y","","")
    //s anopEndDateTime=##class(web.DHCANOrder).GetAnoEventSingle(opaId,"OperEnd",-1,"Y","","")
    //s opdatestr=anopStartDateTime_"~"_anopEndDateTime
    //s anopStartDate=##class(web.DHCANOPCom).ConvertToDateH($p(anopStartDateTime," ",1))   //手术开始日期
    //s anopStartTime=##class(web.DHCANOPCom).ConvertanciiToTimeH($p(anopStartDateTime," ",2))   //手术开始时间
    //s anopEndDate=##class(web.DHCANOPCom).ConvertToDateH($p(anopEndDateTime," ",1))   //手术结束日期
    //s anopEndTime=##class(web.DHCANOPCom).ConvertanciiToTimeH($p(anopEndDateTime," ",2))   //手术结束时间
    //新版手麻可通过以下取手术开始结束日期时间
    s anopStartDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",39)   //入室日期
    s anopStartTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",19)   //手术开始时间
    s anopEndDate=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",41)   //出室日期
    s anopEndTime=$p($g(^OR(EpisodeID,"ANA",anaSub)),"^",20)   //手术结束时间
    i anopStartTime="" d
    .s anopStartDate=$p(^DHCANOPArrange(opaId),"^",14)   //术后登记手术开始日期
    .s anopStartTime=$p(^DHCANOPArrange(opaId),"^",15)   //术后登记手术开始时间
    i anopEndTime="" d
    .s anopEndDate=$p(^DHCANOPArrange(opaId),"^",16)   //术后登记手术结束日期
    .s anopEndTime=$p(^DHCANOPArrange(opaId),"^",17)   //术后登记手术结束时间
    s opdatestr=$zd(anopStartDate,3)_" "_$zt(anopStartTime)_"~"_$zd(anopEndDate,3)_" "_$zt(anopEndTime)
    s opduration=(anopEndDate-anopStartDate)*24*3600+anopEndTime-anopStartTime
    i opduration<0 s opduration=0
    s opduration=opduration/timeScale
    s opduration=$num(opduration,decimalDigits)
    
    
    //取病人手术信息表数据
    s operPositionId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
    i operPositionId'="" s operPosition=$p($g(^ORC("OPPOS",operPositionId)),"^",2)
    e  s operPosition=""
    
    s anaopSub=0,mzdoc1="",jmzdoc="",jmzdoc1="",i=0,opernameSort="",opdes=""
    f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
    .s opdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)
    .i opdr'=""  d
    ..i $p($g(^ORC("OPER",+opdr)),"^",2)'="" d
    ...i opdes'="" s opdes=opdes_";"
    ...s OPCategoryId=$p($g(^ORC("OPER",+opdr)),"^",7)
    ...s opdes=opdes_$p($g(^ORC("OPER",+opdr)),"^",2)   //手术名称
    .e  d
    ..i $g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2))'="" d
    ...i opdes'="" s opdes=opdes_";"
    ...s opdes=opdes_$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)) //自定义手术名称
    .//取麻醉助手、交班麻醉医生
    .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
    .s mzStr=""
    .s anassSub=0
    ..f  s anassSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub))  q:(anassSub="")||(anassSub>20)  d
    ..s mzdr1=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub))
    ..i mzdr1'="" s mzdoc1=##class(web.DHCANOPCom).GetNameById(mzdr1)
    ..i mzStr="" s mzStr=mzdoc1
    ..e  s mzStr=mzStr_" "_mzdoc1
    .s jmzStr=""
    .s anassSub=20
    .f  s anassSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub)) q:(anassSub="")  d
    ..s jmzdr=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub))
    ..i jmzdr'="" s jmzdoc=##class(web.DHCANOPCom).GetNameById(jmzdr)
    ..i jmzStr="" s jmzStr=jmzdoc
    ..e  s jmzStr=jmzStr_" "_jmzdoc
    
    //取合并疾病
    s anCompDesc=""
    s subchl=0 f  s subchl=$o(^OR(EpisodeID,"ANA",anaSub,"COMP",subchl)) q:(subchl="")  d
    .s anCompDr=$p(^OR(EpisodeID,"ANA",anaSub,"COMP",subchl),"^",1)  //合并疾病
    .q:anCompDr=""
    .i anCompDesc="" s anCompDesc=$p(^ORC("COMP",anCompDr),"^",2)
    .e  s anCompDesc=anCompDesc_","_$p(^ORC("COMP",AnCompDr),"^",2)
    
    s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
    s operLocId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",10)  //手术科室Id
    s assDocNum=3 //最多显示的助手人数
    i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)'="" s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
    s p=0
    s list=0,asName=""
    s ash="",ifFind=0
    s as=0 f  s as=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as)) q:(as="")!(p'<assDocNum)  d
    .s asdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",as),"^",1)
    .q:asdr=""
    .s ash=ash_##class(web.DHCANOPCom).GetNameById(asdr)_" "
    
    s xsh="",jbxsh="",ifFind=0    ;洗手
    s xs=0 f  s xs=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",xs)) q:(xs="")!(xs>20)  d
    .s xsdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",xs),"^",1)
    .q:xsdr=""
    .i xsh="" s xsh=##class(web.DHCANOPCom).GetNameById(xsdr)
    .e  s xsh=xsh_" "_##class(web.DHCANOPCom).GetNameById(xsdr)
    
    s xs1=20 f  s xs1=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",xs1)) q:(xs1="")  d
    .s xsdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",xs1),"^",1)
    .q:xsdr=""
    .i jbxsh="" s jbxsh=##class(web.DHCANOPCom).GetNameById(xsdr)
    .e  s jbxsh=jbxsh_" "_##class(web.DHCANOPCom).GetNameById(xsdr)
    
    s xch="",jbxch="",ifFind=0  ;巡床
    s xc=0 f  s xc=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xc)) q:(xc="")!(xc>20)   d
    .s xchdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xc),"^",1)
    .q:xchdr=""
    .i xch=""  s xch=##class(web.DHCANOPCom).GetNameById(xchdr)
    .e  s xch=xch_" "_##class(web.DHCANOPCom).GetNameById(xchdr)
    
    s xc1=20 f  s xc1=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xc1)) q:(xc1="")   d
    .s xchdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xc1),"^",1)
    .q:xchdr=""
    .i jbxch=""  s jbxch=##class(web.DHCANOPCom).GetNameById(xchdr)
    .e  s jbxch=jbxch_" "_##class(web.DHCANOPCom).GetNameById(xchdr)
    
    //特殊  安徽省立
    //s xsh=$p(OPNurseShiftTimeStr,"^",9)
    //s jbxsh=$p(OPNurseShiftTimeStr,"^",4)
    //s xch=$p(OPNurseShiftTimeStr,"^",8)
    //s jbxch=$p(OPNurseShiftTimeStr,"^",6)
    
    s bodsIdList=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",24)    //手术部位
    s bodsList="",bodsDesc=""
    i bodsIdList'="" d
    .s bodsIdNum=$l(bodsIdList,"|")
    .f j=1:1:bodsIdNum d
    ..s bodsId=$p(bodsIdList,"|",j)
    ..q:bodsId=""
    ..s bodsDesc2=$p($g(^OEC("BODS",+bodsId)),"^",2)
    ..i bodsDesc="" s bodsDesc=bodsDesc2
    ..e  s bodsDesc=bodsDesc_"|"_bodsDesc2
    
    s docdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)      //手术医生
    s opd=""
    i docdr'="" s opd=##class(web.DHCANOPCom).GetNameById(docdr)
    e  s opd=..ReplaceString($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //手术医生备注(外来手术医生)
    s surgeonDesc=opd
    
    s predigdrS=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",4)  //ANAOP_PreopDiag_DR 术前诊断字符串
    s prediagStr=""
    s num=$l(predigdrS,"|")
    f pi=1:1:num d
    .s predigdr=$p(predigdrS,"|",pi)
    .i predigdr'=""  d
    ..s prediag=$p(^MRC("ID",predigdr),"^",2)
    ..s $p(prediagStr,",",pi)=$g(prediag)
    .e  d
    ..i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",2))'="" d 
    ...s diamen=$p(^OR(EpisodeID,"ANA",anaSub,"TXT",2),"|",pi)      // 术前诊断备注ANA_Notes
    ...s $p(prediagStr,",",pi)=$g(diamen)
    
    s postdigdrS=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",5)   ;ANAOP_PostDiag_DR 术后诊断
    s postdiagStr="",postdigdr=""
    s num=$l(postdigdrS,"|")
    f pi=1:1:num d
    .s postdigdr=$p(postdigdrS,"|",pi)
    .i postdigdr'=""  d
    ..s postdiag=$p(^MRC("ID",postdigdr),"^",2)
    ..s $p(postdiagStr,",",pi)=$g(postdiag)
    .e  d
    ..i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",3))'="" d 
    ...s diamen=$p(^OR(EpisodeID,"ANA",anaSub,"TXT",3),"|",pi)      // 术前诊断备注ANA_Notes
    ...s $p(postdiagStr,",",pi)=$g(diamen)
    
    i postdiagStr'="" s diagStr=prediagStr_"/"_postdiagStr
    e  s diagStr=prediagStr
    
    s opAntibiotic = ""       //术中追加抗生素
    
    s signId="",findSignId=""
	f  s signId=$o(^DHCCLSignLog(0,"Sign",opaId,signId),-1) q:((signId="")||(findSignId'=""))  d
	.s signDoc=$lg(^DHCCLSignLog(signId),2)
	.s signStatus=$lg(^DHCCLSignLog(signId),3)
	.i (signDoc="麻醉前访视单")&&(signStatus="签名成功") s findSignId=signId
	
	s CASignUser="",CASignDate="",CASignTime=""
	i findSignId>0 d
	.s CASignUser=$lg(^DHCCLSignLog(findSignId),6)   //签名人
	.s CASignDate=$lg(^DHCCLSignLog(findSignId),5)   //签名日期
    .s CASignTime=$lg(^DHCCLSignLog(findSignId),4)   //签名时间
    
    s CASignDateTime=$zd(CASignDate,3)_" "_$zt(CASignTime)
    
    s ^TMPAN("OPList",$j,opaId)=$lb(opaId,status,jzstat,opdatestr,appLocDesc,regno,medCareNo,patName,sex,age,diagStr,opdes,surgeonDesc,ash,opAntibiotic,anmethod,mzdoc,MiniInvasiveStr,HbsAg,HCVAb,HivAb,TPAb,TestOther,oplevel,xsh,xch,opduration,jb,opreq,jbxsh,scNurNote,jbxch,cirNurNote,theatreInOutDuration,anaTheatreDateTimeStr,anaStartEndDuration,anaDateTimeStr,searchOpaInfo,totalStatInfo)
    q
OutputRowOP
    Set ^CacheTemp(repid,ind)=^TMPAN("OPList",$j,opaId)
    Set ind=ind+1
    quit
}

ClassMethod FindStatDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStatDetailsExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindStatDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStatDetailsExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 获取统计图例的数据
/// 入参:anciId,
///     displayParaStr:是图例层级项目:"1#1#30^2#3",表示取筛选层1查询项目1值等于displayId为30时对应值时筛选层2项目3的统计数据
///     searchLevel:查询筛选层的数据,为空表示取所有查询筛选层数据
///     statType:统计类型,根据不同统计类型生成图表,不然图表没有意义
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetInquiryChartData",4,"1#9","3","OPACount","1","0")
Query GetInquiryChartData(anciId As %String, displayParaStr As %String = "", needSearchLevel As %String = "", statType As %String = "", ifArrayData As %String = "0", ifChangeAxis As %String = "0", historySeq As %String = "") As %Query(ROWSPEC = "label:%String,data:%String")
{
}

ClassMethod GetInquiryChartDataExecute(ByRef qHandle As %Binary, anciId As %String, displayParaStr As %String = "", needSearchLevel As %String = "", statType As %String = "", ifArrayData As %String = "0", ifChangeAxis As %String = "0", historySeq As %String = "") As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    
    s ifHistoryData=0,historySeq=+historySeq
    i $d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq)) s ifHistoryData=1
    
    s anciDataType=$lg(^DHCANCInquiry(anciId),10)
    k searchList,displayList,treeList
    s anciiSub=""
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    .s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    .s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    .s anciiNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),10)
    .s anciiRelateAnciiSub=$lg(^DHCANCInquiry(anciId,"I",anciiSub),26)
    .s treeList("Header",anciiSub,"Desc")=anciiDesc
    .i anciiNote'="" s treeList("Header",anciiSub,"Desc")= treeList("Header",anciiSub,"Desc")_"("_anciiNote_")"
    .i (anciiIsSearch&&anciiIsDisplay)  d
    ..i $d(searchList(searchLevel,"Desc")) s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_","
    ..s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_anciiDesc
    ..i anciiNote'="" s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_"("_anciiNote_")"
    .e  i anciiIsDisplay  d
    ..s displayList(searchLevel)=$g(displayList(searchLevel))+1
    ..s displayList(searchLevel,anciiSub)=anciiDesc
    
    i +$o(^DHCANInquiry(anciId,"AllPath",""))>0 d
    .s treeAnciiSub=""
    .f  s treeAnciiSub=$o(^DHCANInquiry(anciId,"AllPath",treeAnciiSub)) q:treeAnciiSub=""  d
    ..s searchLevel=+$lg(^DHCANCInquiry(anciId,"I",treeAnciiSub),21)
    ..s treeList("SearchList",searchLevel,"Code")="S-"_searchLevel
    ..s pathStr=^DHCANInquiry(anciId,"AllPath",treeAnciiSub)
    ..f i=1:1:$l(pathStr,"->") d
    ...//生成类似level形式序列
    ...s anciiSub=$p(pathStr,"->",i)
    ...s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    ...i $g(treeList("SearchList",searchLevel,"Desc"))'="" s treeList("SearchList",searchLevel,"Desc")=treeList("SearchList",searchLevel,"Desc")_","
    ...i anciiIsDisplay s treeList("SearchList",searchLevel,"Desc")=$g(treeList("SearchList",searchLevel,"Desc"))_treeList("Header",anciiSub,"Desc")
    ..k searchList
    ..m searchList=treeList("SearchList")
    
    s firstDisplayLevel=$o(displayList(""))
    
    i displayParaStr="" s displayParaStr=firstDisplayLevel_"#"_$o(displayList(+firstDisplayLevel,""))
    i statType="" s statType="OPACount"
    i needSearchLevel="" s needSearchLevel=$o(searchList(""))
    s opaInfoStr="",descStr="",displayLevel=0,anciiSub=0
    k curDisplayList
    f i=1:1:$l(displayParaStr,"^") d
    .s displayPara=$p(displayParaStr,"^",i)
    .s displayLevel=+$p(displayPara,"#",1)
    .s anciiSub=+$p(displayPara,"#",2)
    .s displayId=$p(displayPara,"#",3)
    .i i=$l(displayParaStr,"^") d
    ..s opaInfo=""
    ..f  s opaInfo=$s('ifHistoryData:$o(^DHCANInquiry(anciId,"FI","Item",+displayLevel,+anciiSub,opaInfo)),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Item",+displayLevel,+anciiSub,opaInfo))) q:opaInfo=""  d
    ...i opaInfoStr'="" s curOpaInfo=opaInfoStr_$c(3)_anciiSub_" "_opaInfo
    ...e  s curOpaInfo=anciiSub_" "_opaInfo
    ...s curDisplayId=$o(^DHCANInquiry(anciId,"FI","OpaInfo",curOpaInfo,""))
    ...s curDisplayId=$s('ifHistoryData:$o(^DHCANInquiry(anciId,"FI","OpaInfo",curOpaInfo,"")),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","OpaInfo",curOpaInfo,"")))
    ...i curDisplayId'="" d
    ....s curDisplayList(curDisplayId)=""
    ....s displayLabel=$p(opaInfo,"^",2)
    ....i (displayLabel="")&&('$lg(^DHCANCInquiry(anciId,"I",anciiSub),7)) s displayLabel="无"
    ....i descStr'="" s curDisplayList(curDisplayId,"Desc")=descStr_","_displayList(displayLevel,anciiSub)_":"_displayLabel
    ....e  s curDisplayList(curDisplayId,"Desc")=displayLabel
    .i +displayId>0 d
    ..s opaInfo=$s('ifHistoryData:$g(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",displayLevel,anciiSub)),ifHistoryData:$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Item",displayLevel,anciiSub)))
    .e  s opaInfo=$s('ifHistoryData:$o(^DHCANInquiry(anciId,"FI","Item",+displayLevel,+anciiSub,"")),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Item",+displayLevel,+anciiSub,"")))
    .i opaInfoStr'="" s opaInfoStr=opaInfoStr_$c(3)
    .s opaInfoStr=opaInfoStr_anciiSub_" "_opaInfo
    .//i descStr'="" s descStr=descStr_","
    .//s descStr=descStr_$p(opaInfo,"^",2)
    
    i '$d(curDisplayList) d
    .s curDisplayList(0)=""
    .s curDisplayList(0,"Desc")=""
    .s ifChangeAxis=1
    s displayId="",count=0
    k ^DHCANInquiry(+anciId,"Chart","Ticks")
    k dataList,ticksList,labelList,tempDataList
    f  s displayId=$o(curDisplayList(displayId)) q:displayId=""  d
    .s searchLevel=0,hasLevelData=0
    .f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    ..q:($d(displayList))&&('ifArrayData)&&(searchLevel'=needSearchLevel) //data不为数组时只取一个筛选层的数据
    ..s value=0
    ..s sumUom=$s('ifHistoryData:$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",statType,"Uom","")),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Level",searchLevel,0,"SumType",statType,"Uom","")))
    ..i sumUom'="" s value=$s('ifHistoryData:+^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,0,"SumType",statType,"Uom",sumUom),ifHistoryData:+^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Level",searchLevel,0,"SumType",statType,"Uom",sumUom))
    ..e  i statType="OPACount" s value=$s('ifHistoryData:+$o(^DHCANInquiry(anciId,"FI","Display",displayId,"Level",searchLevel,""),-1),ifHistoryData:+$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Level",searchLevel,""),-1))
    ..s opaInfo=$s('ifHistoryData:$g(^DHCANInquiry(anciId,"FI","Display",displayId,"Item",displayLevel,anciiSub)),ifHistoryData:$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Display",displayId,"Item",displayLevel,anciiSub)))
    ..s label=$p(opaInfo,"^",2)
    ..i +$g(displayList(displayLevel))>1 s label=$g(displayList(displayLevel,anciiSub))_":"_label
    ..i "-"[sumUom s sumUom=""
    ..s label=label_" "_value_sumUom
    ..i value s hasLevelData=1
    ..i ifChangeAxis d
    ...s tempDataList(searchLevel,displayId)=value
    ...s ticksList(displayId)=curDisplayList(displayId,"Desc")
    ...s labelList(searchLevel)=searchList(searchLevel,"Desc")
    ..e  d
    ...s tempDataList(displayId,searchLevel)=value
    ...s ticksList(searchLevel)=searchList(searchLevel,"Desc")
    ...s labelList(displayId)=curDisplayList(displayId,"Desc")
    ...i ifArrayData s labelList(displayId)=label
    .i hasLevelData m dataList=tempDataList
    .k tempDataList
    
    s firstInd="",ifFirst=1
    f  s firstInd=$o(dataList(firstInd)) q:firstInd=""  d
    .s secondInd="",dataStr="",tickInd=0,value=0
    .f  s secondInd=$o(dataList(firstInd,secondInd)) q:secondInd=""  d
    ..s tickInd=tickInd+1
    ..s value=dataList(firstInd,secondInd)
    ..i dataStr'="" s dataStr=dataStr_","
    ..s dataStr=dataStr_"["_tickInd_","_value_"]"
    ..i ifFirst s ^DHCANInquiry(+anciId,"Chart","Ticks",tickInd)=$lb(tickInd,ticksList(secondInd))
    .s label=labelList(firstInd)
    .i ifArrayData s value="["_dataStr_"]"
    .d OutputRowInquiryData
    .s ifFirst=0
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputRowInquiryData
    s Data=$lb(label,value)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetInquiryChartDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInquiryChartDataExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetInquiryChartDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInquiryChartDataExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// 获取图表显示参数
/// displayParaStr:是图例层级项目:"1#1#30^2#3",表示取筛选层1查询项目1值等于displayId为30时对应值时筛选层2项目3的统计数据
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetChartDisplayPara",4)
Query GetChartDisplayPara(anciId As %String, historySeq As %String = "") As %Query(ROWSPEC = "code:%String,desc:%String")
{
}

ClassMethod GetChartDisplayParaExecute(ByRef qHandle As %Binary, anciId As %String, historySeq As %String = "") As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s qHandle=$lb(0,repid,0)
    
    q:'$d(^DHCANCInquiry(+anciId)) $$$OK
    s anciDataType=$lg(^DHCANCInquiry(anciId),10)
    q:anciDataType $$$OK
    
    s ifHistoryData=0,historySeq=+historySeq
    i $d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq)) s ifHistoryData=1
    
    k searchList,displayList
    s anciiSub=""
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    .s anciiCode=$lg(^DHCANCInquiry(anciId,"I",anciiSub),1)
    .s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    .s anciiSeqNo=$lg(^DHCANCInquiry(anciId,"I",anciiSub),20)
    .s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    .s anciiNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),10)
    .i ('anciiIsSearch)&&(anciiIsDisplay) d
    ..s displayList(searchLevel)=$g(displayList(searchLevel))+1
    ..s displayList(searchLevel,anciiSub)=anciiDesc
    ..i anciiNote'="" s displayList(searchLevel,anciiSub)=anciiNote
        
    s searchLevel="",ifFirstLevel=1
    k lastDisplayParaList,curDisplayParaList
    s lastDisplayParaList(1)=""
    f  s searchLevel=$o(displayList(searchLevel)) q:searchLevel=""  d
    .k curDisplayParaList
    .s lastInd=""
    .s curInd=0
    .f  s lastInd=$o(lastDisplayParaList(lastInd)) q:lastInd=""  d
    ..s anciiSub=""
    ..s lastOpaInfo=""
    ..f  s anciiSub=$s('ifHistoryData:$o(^DHCANInquiry(anciId,"FI","Item",+searchLevel,+anciiSub)),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Item",+searchLevel,+anciiSub))) q:anciiSub=""  d
    ...s code="",desc=""
    ...i 'ifFirstLevel d
    ....s code=lastDisplayParaList(lastInd,"Code")_"^"
    ....s desc=lastDisplayParaList(lastInd,"Desc")_","
    ...s code=code_searchLevel_"#"_anciiSub
    ...s desc=desc_displayList(searchLevel,anciiSub)
    ...d OutputChartDisplayPara
    ...s opaInfo=""
    ...f  s opaInfo=$s('ifHistoryData:$o(^DHCANInquiry(anciId,"FI","Item",+searchLevel,+anciiSub,opaInfo)),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","Item",+searchLevel,+anciiSub,opaInfo))) q:opaInfo=""  d
    ....s code="",desc="",opaInfoStr=""
    ....i 'ifFirstLevel d
    .....s code=lastDisplayParaList(lastInd,"Code")_"^"
    .....s desc=lastDisplayParaList(lastInd,"Desc")_","
    .....s opaInfoStr=lastDisplayParaList(lastInd,"OpaInfo")_$c(3)
    ....s opaInfoStr=opaInfoStr_anciiSub_" "_opaInfo
    ....s displayId=$s('ifHistoryData:$o(^DHCANInquiry(anciId,"FI","OpaInfo",opaInfoStr,"")),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"FI","OpaInfo",opaInfoStr,"")))
    ....q:displayId=""
    ....i displayList(searchLevel)>1 s desc=desc_displayList(searchLevel,anciiSub)_":"
    ....s desc=desc_$p(opaInfo,"^",2)
    ....s code=code_searchLevel_"#"_anciiSub_"#"_displayId
    ....s curInd=curInd+1
    ....s curDisplayParaList(curInd,"Code")=code
    ....s curDisplayParaList(curInd,"Desc")=desc
    ....s curDisplayParaList(curInd,"OpaInfo")=opaInfoStr
    .k lastDisplayParaList
    .m lastDisplayParaList=curDisplayParaList
    .s ifFirstLevel=0
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputChartDisplayPara
    s Data=$lb(code,desc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetChartDisplayParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChartDisplayParaExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetChartDisplayParaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChartDisplayParaExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// 获取图表查询层(统计数据列)
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetChartSearchLevel",4)
Query GetChartSearchLevel(anciId As %String) As %Query(ROWSPEC = "code:%String,desc:%String")
{
}

ClassMethod GetChartSearchLevelExecute(ByRef qHandle As %Binary, anciId As %String) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s qHandle=$lb(0,repid,0)
    
    q:'$d(^DHCANCInquiry(+anciId)) $$$OK
    s anciDataType=$lg(^DHCANCInquiry(anciId),10)
    q:anciDataType $$$OK
    
    s anciiSub=""
    k searchList,treeList
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    .s anciiCode=$lg(^DHCANCInquiry(anciId,"I",anciiSub),1)
    .s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    .s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    .s anciiNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),10)
    .s anciiRelateAnciiSub=$lg(^DHCANCInquiry(anciId,"I",anciiSub),26)
    .s treeList("Header",anciiSub,"Desc")=anciiDesc
    .s treeList("Header",anciiSub,"Note")=anciiNote
    .i anciiIsSearch&&anciiIsDisplay d
    ..i $d(searchList(searchLevel,"Desc")) s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_","
    ..s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_anciiDesc
    ..i anciiNote'="" s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_"("_anciiNote_")"
    
    i +$o(^DHCANInquiry(anciId,"AllPath",""))>0 d
    .s treeAnciiSub=""
    .f  s treeAnciiSub=$o(^DHCANInquiry(anciId,"AllPath",treeAnciiSub)) q:treeAnciiSub=""  d
    ..s searchLevel=+$lg(^DHCANCInquiry(anciId,"I",treeAnciiSub),21)
    ..s treeList("SearchList",searchLevel,"Code")="S-"_searchLevel
    ..s pathStr=^DHCANInquiry(anciId,"AllPath",treeAnciiSub)
    ..f i=1:1:$l(pathStr,"->") d
    ...s anciiSub=$p(pathStr,"->",i)
    ...s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    ...i $g(treeList("SearchList",searchLevel,"Desc"))'="" s treeList("SearchList",searchLevel,"Desc")=treeList("SearchList",searchLevel,"Desc")_","
    ...i anciiIsDisplay s treeList("SearchList",searchLevel,"Desc")=$g(treeList("SearchList",searchLevel,"Desc"))_treeList("Header",anciiSub,"Desc")
    ...i $g(treeList("SearchList",searchLevel,"Note"))'="" s treeList("SearchList",searchLevel,"Note")=treeList("SearchList",searchLevel,"Note")_","
    ...i anciiIsDisplay s treeList("SearchList",searchLevel,"Note")=$g(treeList("SearchList",searchLevel,"Note"))_treeList("Header",anciiSub,"Note")
    ..k searchList
    ..m searchList=treeList("SearchList")
    
    s searchLevel=0
    f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    .s code=searchLevel
    .s desc=searchList(searchLevel,"Desc")
    .i $g(searchList(searchLevel,"Note"))'="" s desc=searchList(searchLevel,"Note")
    .d OutputChartSearchLevel
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputChartSearchLevel
    s Data=$lb(code,desc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetChartSearchLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChartSearchLevelExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetChartSearchLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChartSearchLevelExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// 获取图表显示横坐标
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetChartTicks",4)
Query GetChartTicks(anciId As %String) As %Query(ROWSPEC = "value:%Float,desc:%String")
{
}

ClassMethod GetChartTicksExecute(ByRef qHandle As %Binary, anciId As %String) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s qHandle=$lb(0,repid,0)
    
    q:'$d(^DHCANInquiry(+anciId,"Chart","Ticks")) $$$OK
    
    s tickInd=""
    f  s tickInd=$o(^DHCANInquiry(+anciId,"Chart","Ticks",tickInd)) q:tickInd=""  d
    .s Data=^DHCANInquiry(+anciId,"Chart","Ticks",tickInd)
    .d OutputChartTick
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputChartTick
    //s Data=$lb(code,desc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetChartTicksFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChartTicksExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetChartTicksClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChartTicksExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// 获取时间线图表显示参数
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetTimeLineChartPara",10,"")
Query GetTimeLineChartPara(anciId As %String, displayParaStr As %String = "") As %Query(ROWSPEC = "code:%Float,desc:%String")
{
}

ClassMethod GetTimeLineChartParaExecute(ByRef qHandle As %Binary, anciId As %String, displayParaStr As %String = "") As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s qHandle=$lb(0,repid,0)
    
    q:'$d(^DHCANInquiry("TimeLine",anciId,"Para")) $$$OK
    
    i displayParaStr="" d
    .s para="",opaInfoCount=0
    .f  s para=$o(^DHCANInquiry("TimeLine",anciId,"Para",para)) q:para=""  d
    ..s opaInfoCount=opaInfoCount+1
    ..s code=para
    ..s desc=para
    ..d OutputTimeLinePara
    e  d
    .s para=displayParaStr,opaInfo="",opaInfoCount=0
    .f  s opaInfo=$o(^DHCANInquiry("TimeLine",anciId,"Para",para,opaInfo)) q:opaInfo=""  d
    ..s opaInfoCount=opaInfoCount+1
    ..s code=opaInfoCount
    ..s desc=^DHCANInquiry("TimeLine",anciId,"Para",para,opaInfo)
    ..d OutputTimeLinePara
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputTimeLinePara
    s Data=$lb(code,desc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetTimeLineChartParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTimeLineChartParaExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetTimeLineChartParaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTimeLineChartParaExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// 获取时间线图表显示数据
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetTimeLineChartData",10,"","2012-01-01~2012-12-31^2013-01-01~2013-12-31^2014-01-01~2014-12-31","OPACount")
Query GetTimeLineChartData(anciId As %String, displayParaStr As %String = "", dateListStr As %String = "", statType As %String = "") As %Query(ROWSPEC = "dateIndex:%Float,data:%String")
{
}

ClassMethod GetTimeLineChartDataExecute(ByRef qHandle As %Binary, anciId As %String, displayParaStr As %String = "", dateListStr As %String = "", statType As %String = "") As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s qHandle=$lb(0,repid,0)
    
    q:'$d(^DHCANInquiry("TimeLine",anciId,"Para")) $$$OK
    k CalculateValueList
    s CalculateValueList("ANDoctor")=$g(^DHCANInquiry("CtpcpCount","ANDoctor"))
    s decimalDigits=2
    
    s anciDataType=$lg(^DHCANCInquiry(anciId),10)
    k searchList,displayList,treeList,summaryTypeList
    s anciiSub=""
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    .s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    .s anciiDesc=$lg(^DHCANCInquiry(anciId,"I",anciiSub),2)
    .s anciiNote=$lg(^DHCANCInquiry(anciId,"I",anciiSub),10)
    .s anciiRelateAnciiSub=$lg(^DHCANCInquiry(anciId,"I",anciiSub),26)
    .s treeList("Header",anciiSub,"Desc")=anciiDesc
    .i anciiNote'="" s treeList("Header",anciiSub,"Desc")= treeList("Header",anciiSub,"Desc")_"("_anciiNote_")"
    .i (anciiIsSearch&&anciiIsDisplay)  d
    ..i $d(searchList(searchLevel,"Desc")) s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_","
    ..s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_anciiDesc
    ..i anciiNote'="" s searchList(searchLevel,"Desc")=$g(searchList(searchLevel,"Desc"))_"("_anciiNote_")"
    ..s anciiSummaryType=$lg(^DHCANCInquiry(anciId,"I",anciiSub),24)
    ..s anciiRefValue=$lg(^DHCANCInquiry(anciId,"I",anciiSub),19)
    ..i anciiSummaryType'="" d
    ...f i=1:1:$l(anciiSummaryType,",") d
    ....s summaryType=$p(anciiSummaryType,",",i)
    ....s summaryTypeList(searchLevel,summaryType)=""
    ....i anciiRefValue'="" s summaryTypeList("CalculateExpression",searchLevel,summaryType)=anciiRefValue,summaryTypeList("LevelSub",searchLevel,anciiSub)=""
    .e  i anciiIsDisplay  d
    ..s displayList(searchLevel)=$g(displayList(searchLevel))+1
    ..s displayList(searchLevel,anciiSub)=anciiDesc
    
    i +$o(^DHCANInquiry(anciId,"AllPath",""))>0 d
    .s treeAnciiSub=""
    .f  s treeAnciiSub=$o(^DHCANInquiry(anciId,"AllPath",treeAnciiSub)) q:treeAnciiSub=""  d
    ..s searchLevel=+$lg(^DHCANCInquiry(anciId,"I",treeAnciiSub),21)
    ..s treeList("SearchList",searchLevel,"Code")="S-"_searchLevel
    ..s pathStr=^DHCANInquiry(anciId,"AllPath",treeAnciiSub)
    ..f i=1:1:$l(pathStr,"->") d
    ...//生成类似level形式序列
    ...s anciiSub=$p(pathStr,"->",i)
    ...s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    ...i $g(treeList("SearchList",searchLevel,"Desc"))'="" s treeList("SearchList",searchLevel,"Desc")=treeList("SearchList",searchLevel,"Desc")_","
    ...i anciiIsDisplay s treeList("SearchList",searchLevel,"Desc")=$g(treeList("SearchList",searchLevel,"Desc"))_treeList("Header",anciiSub,"Desc")
    ..k searchList
    ..m searchList=treeList("SearchList")
    
    s firstDisplayLevel=$o(displayList(""))
    
    i displayParaStr="" s displayParaStr=$o(^DHCANInquiry("TimeLine",anciId,"Para",""))
    i statType="" s statType="OPACount"
    k ^DHCANInquiry(+anciId,"Chart","Ticks")
    k chartDataList
    s sumUom=""
    f i=1:1:$l(dateListStr,"^") d
    .s dateStr=$p(dateListStr,"^",i)
    .s startDate=$p(dateStr,"~",1)
    .s endDate=$p(dateStr,"~",2)
    .s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
    .s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
    .s ^DHCANInquiry(+anciId,"Chart","Ticks",i)=$lb(i,dateStr)
    .s opaInfo="",opaInfoCount=0
    .f  s opaInfo=$o(^DHCANInquiry("TimeLine",anciId,"Para",displayParaStr,opaInfo)) q:opaInfo=""  d
    ..s opaInfoCount=opaInfoCount+1
    ..s searchLevel=""
    ..f  s searchLevel=$o(searchList(searchLevel)) q:searchLevel=""  d
    ...f date=startDate:1:endDate d
    ....i sumUom="" s sumUom=$o(^DHCANInquiry("TimeLine",anciId,"Data",date,opaInfo,searchLevel,"SumType",statType,"Uom",""))
    ....s statValue=0
    ....i sumUom'="" s statValue=$g(^DHCANInquiry("TimeLine",anciId,"Data",date,opaInfo,searchLevel,"SumType",statType,"Uom",sumUom))
    ....s chartDataList(i,opaInfoCount,searchLevel)=$g(chartDataList(i,opaInfoCount,searchLevel))+statValue
    ..f  s searchLevel=$o(summaryTypeList("CalculateExpression",searchLevel)) q:searchLevel=""  d
    ...s anciiSub=+$o(summaryTypeList("LevelSub",searchLevel,""))
    ...s anciiDataField=$lg(^DHCANCInquiry(anciId,"I",anciiSub),6)
    ...i $d(summaryTypeList("CalculateExpression",searchLevel,statType)) d
    ....k expArgList
    ....m expArgList=chartDataList(i,opaInfoCount)
    ....s listsearchLevel="" f  s listsearchLevel=$o(searchList(listsearchLevel)) q:listsearchLevel=""  d
    .....i '$d(expArgList(listsearchLevel)) s expArgList(listsearchLevel)=0
    ....m expArgList=CalculateValueList
    ....s singleSumUomCount=..CalculateExpression(summaryTypeList("CalculateExpression",searchLevel,summaryType),.expArgList)
    ....i anciiDataField="Percentage" s singleSumUomCount=singleSumUomCount*100
    ....e  i anciiDataField="Permillage" s singleSumUomCount=singleSumUomCount*1000
    ....s singleSumUomCount=$num(singleSumUomCount,decimalDigits)
    ....s chartDataList(i,opaInfoCount,searchLevel)=singleSumUomCount
    
    s dateIndex=0
    f  s dateIndex=$o(chartDataList(dateIndex)) q:dateIndex=""  d
    .s opaInfoIndex=0
    .s dataStr=""
    .f  s opaInfoIndex=$o(chartDataList(dateIndex,opaInfoIndex)) q:opaInfoIndex=""  d
    ..s searchLevel=""
    ..f  s searchLevel=$o(chartDataList(dateIndex,opaInfoIndex,searchLevel)) q:searchLevel=""  d
    ...i dataStr'="" s dataStr=dataStr_","
    ...s dataStr=dataStr_"["_opaInfoIndex_","_searchLevel_","_(+$g(chartDataList(dateIndex,opaInfoIndex,searchLevel)))_"]"
    .s dataStr="["_dataStr_"]"
    .d OutputRowTimeLineData
    .s ifFirst=0
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputRowTimeLineData
    s Data=$lb(dateIndex,dataStr)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetTimeLineChartDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTimeLineChartDataExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetTimeLineChartDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTimeLineChartDataExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod GetLastInquiryDuration(anciId, historySeq = "") As %String
{
    s ifHistoryData=0,historySeq=+historySeq
    i $d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq)) s ifHistoryData=1
    
    s startDate=$s('ifHistoryData:$g(^DHCANInquiry(anciId,"StartDate")),ifHistoryData:$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"StartDate")))
    s endDate=$s('ifHistoryData:$g(^DHCANInquiry(anciId,"EndDate")),ifHistoryData:$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"EndDate")))
    i +startDate'>0 s startDate=+$h
    i +endDate'>0 s endDate=+$h
    
    s startTime=+$s('ifHistoryData:$g(^DHCANInquiry(anciId,"StartTime")),ifHistoryData:$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"StartTime")))
    s endTime=+$s('ifHistoryData:$g(^DHCANInquiry(anciId,"EndTime")),ifHistoryData:$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"EndTime")))
    
    s AppLoc=$s('ifHistoryData:$g(^DHCANInquiry(anciId,"AppLoc")),ifHistoryData:$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"AppLoc")))
    s AppLocStr=""
    f i=1:1:$l(AppLoc,",") d
    .s appLocId=$p(AppLoc,",",i)
    .s appLocDesc=$p($g(^CTLOC(+appLocId)),"^",2)
    .i $l(appLocDesc,"-")>1 s appLocDesc=$p(appLocDesc,"-",2)
    .i AppLocStr'="" s AppLocStr=AppLocStr_","
    .s AppLocStr=AppLocStr_appLocDesc
    
    s DateType=$s('ifHistoryData:$g(^DHCANInquiry(anciId,"DateType")),ifHistoryData:$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"DateType")))
    
    q $ZD(startDate,3)_$c(3)_$ZD(endDate,3)_$c(3)_AppLocStr_$c(3)_DateType_$c(3)_$zt(startTime)_$c(3)_$zt(endTime)
}

/// w ##class(web.DHCANOPStat).SaveColumnWidth(10,"D-1:196^D-2:80^S-4:80^S-3:218^S-5:80^S-6:80^S-7:80^S-8:80^S-9:80^S-10:80^S-11:80")
ClassMethod SaveColumnWidth(anciId, columnWidthStr) As %String
{
    k columnList
    f i=1:1:$l(columnWidthStr,"^") d
    .s colName=$p(columnWidthStr,"^",i)
    .s colWidth=$p(colName,":",2)
    .s colName=$p(colName,":",1)
    .s columnList(colName)=+colWidth
    s anciDataType=$lg(^DHCANCInquiry(anciId),10)
    s anciiSub=""
    f  s anciiSub=$o(^DHCANCInquiry(anciId,"I",anciiSub)) q:anciiSub=""  d
    .s anciiIsDisplay=$lg(^DHCANCInquiry(anciId,"I",anciiSub),5)
    .q:((anciDataType'="S")&&('anciiIsDisplay))
    .s searchLevel=$lg(^DHCANCInquiry(anciId,"I",anciiSub),21)
    .s anciiIsSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),4)
    .s anciiIsResultSearch=$lg(^DHCANCInquiry(anciId,"I",anciiSub),28)
    .i (anciDataType="S") d
    ..i anciiIsSearch&&anciiIsDisplay d
    ...s anciiObj=##class(User.DHCANCInquiryItem).%OpenId(anciId_"||"_anciiSub)
    ...s anciiObj.ANCIIColumnWidth=$g(columnList("S-"_searchLevel))
    ...d anciiObj.%Save()
    ..e  i anciiIsDisplay d
    ...s anciiObj=##class(User.DHCANCInquiryItem).%OpenId(anciId_"||"_anciiSub)
    ...s anciiObj.ANCIIColumnWidth=$g(columnList("D-"_searchLevel))
    ...d anciiObj.%Save()
    ..i anciiIsDisplay&&anciiIsResultSearch d
    ...s anciiObj=##class(User.DHCANCInquiryItem).%OpenId(anciId_"||"_anciiSub)
    ...s anciiObj.ANCIIColumnWidth=$g(columnList("R-"_searchLevel))
    ...d anciiObj.%Save()
    .e  i anciiIsDisplay d
    ..s anciiObj=##class(User.DHCANCInquiryItem).%OpenId(anciId_"||"_anciiSub)
    ..s anciiObj.ANCIIColumnWidth=$g(columnList("D-"_anciiSub))
    ..d anciiObj.%Save()
    
    q "0"
}

/// w ##class(web.DHCANOPStat).StoreHistoryData(10)
ClassMethod StoreHistoryData(anciId) As %String
{
    s count=$o(^DHCANInquiry("HistoryData",anciId,"Count",""),-1)
    s count=+count+1
    m ^DHCANInquiry("HistoryData",anciId,"Count",count)=^DHCANInquiry(anciId)
    s ^DHCANInquiry("HistoryData",anciId,"Count")=count
    q "0"
}

/// w ##class(web.DHCANOPStat).StoreHistoryData(10)
ClassMethod RemoveHistoryData(anciId, historySeq) As %String
{
	f i=1:1:$l(historySeq,"^") d
    .k ^DHCANInquiry("HistoryData",anciId,"Count",+$p(historySeq,"^",i))
    q "0"
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetHistoryDataList",10)
Query GetHistoryDataList(anciId As %String) As %Query(ROWSPEC = "anciId,anciDesc,historySeq,startDate,endDate,appLoc,dateType,dateTypeDesc,opaCount,rowCount")
{
}

ClassMethod GetHistoryDataListExecute(ByRef qHandle As %Binary, anciId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i anciId="" s anciId=1
    s anciDesc=$lg(^DHCANCInquiry(anciId),2)
    s historySeq=0
    f  s historySeq=$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq)) q:historySeq=""  d
    .s startDate=$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"StartDate"))
    .s endDate=$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"EndDate"))
    .s appLoc=$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"AppLoc"))
    .s dateType=$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"DateType"))
    .s dateTypeDesc=$s(dateType="Adm":"入院",dateType="Discharge":"出院",1:"手术")
    .s opaCount=$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"opaCount"))
    .s count=$g(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"count"))
    .s startDate=$zd(startDate,3)
    .s endDate=$zd(endDate,3)
    .s appLocStr=""
    .f i=1:1:$l(appLoc,",") d
    ..s appLocId=$p(appLoc,",",i)
    ..s appLocDesc=$p($g(^CTLOC(+appLocId)),"^",2)
    ..i $l(appLocDesc,"-")>1 s appLocDesc=$p(appLocDesc,"-",2)
    ..i appLocStr'="" s appLocStr=appLocStr_","
    ..s appLocStr=appLocStr_appLocDesc
    .d OutputHistoryList
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutputHistoryList
    set Data=$lb(anciId,anciDesc,historySeq,startDate,endDate,appLocStr,dateType,dateTypeDesc,opaCount,count)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHistoryDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHistoryDataListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetHistoryDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHistoryDataListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 添加排序项
/// w ##class(web.DHCANOPStat).AddANCIItemSort("AppLoc^申请科室^3^产科^1")
ClassMethod AddANCIItemSort(para As %String) As %String
{
    s itemCode=$p(para,"^",1)
    s itemDesc=$p(para,"^",2)
    s sortValueId=$p(para,"^",3)
    s sortValue=$p(para,"^",4)
    s sortNo=+$p(para,"^",5)
    s sortExtraDesc=$p(para,"^",6)
    
    q:itemCode="" "项目代码不能为空!"
    q:(sortValueId="")&&(sortValue="") "项目参与排序的值不能为空!"
    q:+sortNo<=0 "排序号必须大于0"
    
    s count=$o(^DHCANInquiry("Sort","Data",""),-1)
    s count=count+1
    s sortNo=$s($l(sortNo)=1:"0000",$l(sortNo)=2:"000",$l(sortNo)=3:"00",$l(sortNo)=4:"0",1:"")_sortNo
    s ^DHCANInquiry("Sort","Data",count)=$lb(itemCode,itemDesc,sortValueId,sortValue,sortNo,sortExtraDesc)
    i sortValueId'="" d
    .s ^DHCANInquiry("Sort","ItemCode",itemCode,sortValueId)=sortNo
    .s:sortExtraDesc'="" ^DHCANInquiry("Sort","ItemCode",itemCode,sortValueId,"Extra")=sortExtraDesc
    i sortValue'="" d
    .s ^DHCANInquiry("Sort","ItemCode",itemCode,sortValue)=sortNo
    .s:sortExtraDesc'="" ^DHCANInquiry("Sort","ItemCode",itemCode,sortValue,"Extra")=sortExtraDesc
    
    q "0"
}

/// 修改排序项
/// w ##class(web.DHCANOPStat).UpdateANCIItemSort(1,"AppLoc^申请科室^3^产科^1")
ClassMethod UpdateANCIItemSort(sortId As %String, para As %String) As %String
{
    s itemCode=$p(para,"^",1)
    s itemDesc=$p(para,"^",2)
    s sortValueId=$p(para,"^",3)
    s sortValue=$p(para,"^",4)
    s sortNo=+$p(para,"^",5)
    s sortExtraDesc=$p(para,"^",6)
    
    q:itemCode="" "项目代码不能为空!"
    q:(sortValueId="")&&(sortValue="") "项目参与排序的值不能为空!"
    q:+sortNo<=0 "排序号必须大于0"
    q:+sortId<=0 "数据Id必须大于0"
    
    s sortNo=$s($l(sortNo)=1:"0000",$l(sortNo)=2:"000",$l(sortNo)=3:"00",$l(sortNo)=4:"0",1:"")_sortNo
    d ..DeleteANCIItemSort(sortId)
    s ^DHCANInquiry("Sort","Data",+sortId)=$lb(itemCode,itemDesc,sortValueId,sortValue,sortNo,sortExtraDesc)
    i sortValueId'="" d
    .s ^DHCANInquiry("Sort","ItemCode",itemCode,sortValueId)=sortNo
    .s:sortExtraDesc'="" ^DHCANInquiry("Sort","ItemCode",itemCode,sortValueId,"Extra")=sortExtraDesc
    i sortValue'="" d
    .s ^DHCANInquiry("Sort","ItemCode",itemCode,sortValue)=sortNo
    .s:sortExtraDesc'="" ^DHCANInquiry("Sort","ItemCode",itemCode,sortValue,"Extra")=sortExtraDesc
    
    q "0"
}

/// 删除排序项
/// w ##class(web.DHCANOPStat).DeleteANCIItemSort(1)
ClassMethod DeleteANCIItemSort(sortId As %String) As %String
{
    q:+sortId<=0 "数据Id必须大于0"
    
    s itemCode=$lg(^DHCANInquiry("Sort","Data",+sortId),1)
    s sortValueId=$lg(^DHCANInquiry("Sort","Data",+sortId),3)
    s sortValue=$lg(^DHCANInquiry("Sort","Data",+sortId),4)
    
    i sortValueId'="" k ^DHCANInquiry("Sort","ItemCode",itemCode,sortValueId)
    i sortValue'="" k ^DHCANInquiry("Sort","ItemCode",itemCode,sortValue)
    
    k ^DHCANInquiry("Sort","Data",+sortId)
    
    q "0"
}

/// 获取行排序设置
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","GetANCIItemSortList")
Query GetANCIItemSortList(itemCode As %String = "") As %Query(ROWSPEC = "sortId,anciiCode,anciiDesc,sortValueId,sortValue,sortNo,sortExtraDesc")
{
}

ClassMethod GetANCIItemSortListExecute(ByRef qHandle As %Binary, itemCode As %String = "") As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    s qHandle=$lb(0,repid,0)
    q:'$d(^DHCANInquiry("Sort","Data")) $$$OK
    s sortId=""
    f  s sortId=$o(^DHCANInquiry("Sort","Data",sortId)) q:sortId=""  d
    .s anciiCode=$lg(^DHCANInquiry("Sort","Data",sortId),1)
    .q:(itemCode'="")&&(anciiCode'=itemCode)
    .s anciiDesc=$lg(^DHCANInquiry("Sort","Data",sortId),2)
    .s sortValueId=$lg(^DHCANInquiry("Sort","Data",sortId),3)
    .s sortValue=$lg(^DHCANInquiry("Sort","Data",sortId),4)
    .s sortNo=$lg(^DHCANInquiry("Sort","Data",sortId),5)
    .s sortExtraDesc=$lg(^DHCANInquiry("Sort","Data",sortId),6)
    .d OutputSort
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputSort
    s Data=$lb(sortId,anciiCode,anciiDesc,sortValueId,sortValue,sortNo,sortExtraDesc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetANCIItemSortListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetANCIItemSortListExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetANCIItemSortListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetANCIItemSortListExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// w ##class(web.DHCANOPStat).MoveResultRows(10,"","1^2^3^4","","5")
ClassMethod MoveResultRows(anciId, historySeq, rowIdStr, direction, moveToRowNum) As %String
{
    s ifHistoryData=0,historySeq=+historySeq
    i $d(^DHCANInquiry("HistoryData",anciId,"Count",historySeq)) s ifHistoryData=1
    
    s rowCount=$S(ifHistoryData:^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"count"),1:^DHCANInquiry(anciId,"count"))
    
    k rowIdList,targetRowIdList,targetRowDataList
    s rowIdList=$l(rowIdStr,"^")
    f i=1:1:$l(rowIdStr,"^") d
    .s rowIdList(+$p(rowIdStr,"^",i))=""
    
    q:rowIdList<1 "-1"
    
    s minRowId=$o(rowIdList(""))
    s maxRowId=$o(rowIdList(""),-1)
    
    i direction="" d
    .s direction=moveToRowNum-minRowId
    i direction+minRowId<1 s direction=1-minRowId
    
    s rowId="",remainRowCount=rowIdList
    f  s rowId=$o(rowIdList(rowId)) q:rowId=""  d
    .s remainRowCount=remainRowCount-1
    .s targetRowId=rowId+direction
    .i (targetRowId)>(rowCount-remainRowCount) d
    ..s targetRowId=rowCount-remainRowCount
    .s targetRowIdList(targetRowId)=rowId
    .i 'ifHistoryData d
    ..m targetRowDataList(targetRowId)=^DHCANInquiry(anciId,"Result",rowId)
    ..k ^DHCANInquiry(anciId,"Result",rowId)
    .e  d
    ..m targetRowDataList(targetRowId)=^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result",rowId)
    ..k ^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result",rowId)

    s rowId="",rowCount=0
    f  s rowId=$S('ifHistoryData:$o(^DHCANInquiry(anciId,"Result",rowId)),ifHistoryData:$o(^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result",rowId))) q:rowId=""  d
    .s rowCount=rowCount+1
    .i ($d(targetRowIdList(rowCount))) d
    ..s rowId=rowId-1
    .e  i rowCount'=rowId d
    ..i 'ifHistoryData d
    ...m targetRowDataList(rowCount)=^DHCANInquiry(anciId,"Result",rowId)
    ..e  d
    ...m targetRowDataList(rowCount)=^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result",rowId)
    b //after loop
    i 'ifHistoryData d
    .m ^DHCANInquiry(anciId,"Result")=targetRowDataList
    e  d
    .m ^DHCANInquiry("HistoryData",anciId,"Count",historySeq,"Result")=targetRowDataList
    
    q "0"
}

ClassMethod SetIfStartStoreTimeLine(anciId, ifStart) As %String
{
    s ^DHCANInquiry("StartStoreTimeLine",+anciId)=ifStart
    //设置是否开始在后台按天记录手术麻醉统计信息,只有当查询策略稳定了才开始否则记录的数据可能不对
    q +ifStart
}

ClassMethod GetIfStartStoreTimeLine(anciId) As %String
{
    q +$g(^DHCANInquiry("StartStoreTimeLine",+anciId))
}

/// w ##class(web.DHCANOPStat).ClearInquiryItem(14)
ClassMethod ClearInquiryItem(anciId) As %String
{
	q:'$d(^DHCANCInquiry(anciId)) "不存在对应策略"
	
	k ^DHCANCInquiry(anciId,"I")
	
	q "0"
}

/// w ##class(web.DHCANOPStat).ClearTimeLineData(14)
ClassMethod ClearTimeLineData(anciId) As %String
{
	q:'$d(^DHCANCInquiry(anciId)) "不存在对应策略"
	
	k ^DHCANInquiry("TimeLine",anciId)
	
	q "0"
}

ClassMethod SetOPArrangeIndex() As %String
{
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAddInstrument")="31"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAdmDr")="1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnDocNote")="43"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnSheetEditAudit")="74"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnSheetPrintAudit")="73"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnaDoctorOrdered")="48"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnaEffect")="12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnaNurseOrdered")="49"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnaestDr")="2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnalgesia")="66"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnalgesiaEstimate")="68"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnalgesiaOther")="67"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnalgesiaPlan")="PA^105"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAppCtcpDr")="6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAppDate")="3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAppLocDr")="54"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAppPrior")="4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAppTime")="5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAArrangeDate")="7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAArrangeTime")="8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAArrangeUserDr")="9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPABloodTypeDr")="11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareAsepticPackNo")="Care^4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareDrainageCathOther")="Care^19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareDrainageCatheter")="Care^18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareElectrotome")="Care^10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareElectrotomeMode")="Care^11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareFlush")="Care^31"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareFlushOther")="Care^32"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareFreezingSlice")="Care^20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareGermiculture")="Care^22"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareHemostaticBelt")="Care^5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareHemostaticBeltOther")="Care^6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareImplant")="Care^24"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareImplantItem")="Care^26"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareImplantOther")="Care^28"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareImplantSite")="Care^25"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareImplantSpec")="Care^27"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareNegativePlate")="Care^12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareNegativePlateSkin")="Care^13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareOperRecord")="Care^36"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareOperRecordDispose")="Care^38"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareOperRecordOther")="Care^39"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareOperRecordSpecial")="Care^37"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareOperVitalSign")="Care^35"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACarePathologSection")="Care^21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACarePerfusion")="Care^29"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACarePerfusionOther")="Care^30"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACarePlugger")="Care^33"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACarePluggerSite")="Care^34"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACarePositionSupport")="Care^8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareRestraintBelt")="Care^7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareSkinCrush")="Care^14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareSkinCrushOther")="Care^15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareSpecimen")="Care^23"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareUrineCathCtcpDr")="Care^17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareUrineCatheter")="Care^16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareWarmBlanket")="Care^9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACirculNurseNote")="52"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACollectedStatus")="18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAddCirculDr")="Count^6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAddDate")="Count^7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAddScrubDr")="Count^5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAddTime")="Count^8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAuditCTCPDr")="Count^19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAuditDate")="Count^20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAuditTime")="Count^21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountCorrect")="Count^17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountNote")="Count^18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountPreOperCirculDr")="Count^2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountPreOperDate")="Count^3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountPreOperScrubDr")="Count^1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountPreOperTime")="Count^4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountSewedCirculDr")="Count^14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountSewedDate")="Count^15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountSewedScrubDr")="Count^13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountSewedTime")="Count^16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountUnSewCirculDr")="Count^10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountUnSewDate")="Count^11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountUnSewScrubDr")="Count^9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountUnSewTime")="Count^12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPADocArriveTime")="58"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAEndDate")="16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAEndTime")="17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAEstiOperDuration")="37"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAExCirculation")="36"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAExtubIndicate")="65"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAExtubationDone")="64"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAFetchPatReceiveTime")="59"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAFreezingSlice")="56"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInstrumentDr")="30"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAIsolated")="10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAMedInfect")="53"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAMemo")="19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAMiniInvasive")="13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPANavigation")="55"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPANeedAnaesthetist")="44"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPANeedScrubNurse")="40"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOpDocNote")="42"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOpLevelDr")="28"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOpNurseOrdered")="50"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOpRoomDr")="20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOperSiteSkin")="75"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAldosterone")="PA^14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAllen")="PA^79"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAnaClass")="PA^88"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAnaSpecificApply")="PA^91"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAnaestType")="PA^89"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAngiography")="PA^102"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABPDiastolic")="PA^62"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABPSystolic")="PA^61"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABloodSystem")="PA^38"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABloodSystemOther")="PA^39"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABoneSystem")="PA^36"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABoneSystemOther")="PA^37"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACT")="PA^99"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUConsciousness")="PACU^13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUDischCtcpDR")="PACU^11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUDuration")="PACU^10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUExtremityMove")="PACU^15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUHemodynamics")="PACU^16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUInAdmission")="PACU^1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUInDate")="PACU^6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUInTime")="PACU^7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUNausea")="PACU^20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUNerve")="PACU^19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUNote")="PACU^23"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUNurseDr")="PACU^12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUOther")="PACU^24"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUOutDate")="PACU^8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUOutTime")="PACU^9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUOxygenSaturation")="PACU^17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACURenal")="PACU^18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACURespiration")="PACU^14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUScoreDetail")="PACU^2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUScoreVal")="PACU^3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUTemperature")="PACU^22"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUVasScoreDetail")="PACU^4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUVasScoreVal")="PACU^5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUVomiting")="PACU^21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACardiacCatheter")="PA^96"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACardiacRhythm")="PA^9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACardiovascular")="PA^74"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACirculSystemOther")="PA^11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACirculatorySystem")="PA^8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAConsciousness")="PA^64"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACurCondition")="PA^56"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACurConditionOther")="PA^57"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACurDrug")="PA^50"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACurDrugOther")="PA^51"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPADiffcultPrevent")="PA^93"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPADigestSystemOther")="PA^35"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPADigestiveSystem")="PA^32"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPADyspneaClass")="PA^85"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAEKG")="PA^95"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAEchocardiogram")="PA^97"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAEndoSystemOther")="PA^16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAEndocrineSystem")="PA^12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAExam")="PA^94"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAExamOther")="PA^104"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAFamily")="PA^52"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAFamilyOther")="PA^53"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAGenitalSystem")="PA^40"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAGenitalSystemOther")="PA^41"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAHeadNeck")="PA^70"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAHeartRate")="PA^59"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAHypertension")="PA^10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAHypothyroid")="PA^15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAIllness")="PA^1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAInfect")="PA^108"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAInfectDispose")="PA^109"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAInsulin")="PA^13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAIntubatDiffcult")="PA^86"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAJaw")="PA^19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPALiver")="PA^33"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPALowerLimb")="PA^78"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPALung")="PA^75"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMallampatiClass")="PA^66"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMonitorItem")="PA^90"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMouth")="PA^17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMouthOpen")="PA^65"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMouthOther")="PA^20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMuscularSystem")="PA^30"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMuscularSystemOther")="PA^31"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANYHA")="PA^87"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANeck")="PA^24"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANeckBackFlexAngle")="PA^72"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANeckForwardFlexAngle")="PA^71"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANeckOther")="PA^25"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANervSystemOther")="PA^3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANerve")="PA^76"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANervousSystem")="PA^2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANose")="PA^28"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANoseOther")="PA^29"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAOrganOther")="PA^82"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAOtherSystem")="PA^44"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAOtherSystemOther")="PA^45"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPeripheralVein")="PA^80"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPharynx")="PA^21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPharynxOther")="PA^23"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPhyExam")="PA^58"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPhyExamOther")="PA^83"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPlan")="PA^92"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPreAllergy")="PA^48"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPreAllergyOther")="PA^49"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPreAnop")="PA^46"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPreAnopOther")="PA^47"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPulmonaryFuncTest")="PA^103"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPARespRate")="PA^63"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPARespSystem")="PA^4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPARespSystemOther")="PA^7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPARespTractClass")="PA^84"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPARespiration")="PA^73"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASkin")="PA^26"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASkinOther")="PA^27"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASmokeDuration")="PA^6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASmokeFreq")="PA^5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASocial")="PA^54"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASocialOther")="PA^55"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASpine")="PA^81"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASpleen")="PA^34"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATeeth")="PA^68"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATeethDetail")="PA^69"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATemp")="PA^60"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATest")="PALab^1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestALB")="PALab^11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestALP")="PALab^13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestALT")="PALab^8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestAPTT")="PALab^41"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestAST")="PALab^9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestBE")="PALab^54"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestBUN")="PALab^16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestCHOL")="PALab^18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestCKMB")="PALab^23"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestCREA")="PALab^15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestCa")="PALab^27"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestCl")="PALab^28"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestDDimer")="PALab^43"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestFDP")="PALab^44"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestFIB")="PALab^42"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestGLU")="PALab^14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHB")="PALab^5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHBcAb")="PALab^33"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHBeAb")="PALab^32"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHBeAg")="PALab^31"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHBsAb")="PALab^30"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHBsAg")="PALab^29"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHCO3")="PALab^53"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHCT")="PALab^6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHCVAb")="PALab^34"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHDLC")="PALab^20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHivAb")="PALab^35"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestINR")="PALab^40"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestK")="PALab^25"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestLAC")="PALab^24"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestLDH")="PALab^22"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestLDLC")="PALab^21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestNa")="PALab^26"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestOther")="PALab^2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPCO2")="PALab^51"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPH")="PALab^50"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPLT")="PALab^7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPO2")="PALab^52"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPT")="PALab^37"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPTA")="PALab^38"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPTR")="PALab^39"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestRBC")="PALab^4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestSO2")="PALab^55"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestTBIL")="PALab^12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestTG")="PALab^19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestTP")="PALab^10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestTPAb")="PALab^36"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUA")="PALab^17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUrineERY")="PALab^49"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUrineGLU")="PALab^45"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUrineKET")="PALab^46"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUrineNPRO")="PALab^47"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUrinePH")="PALab^48"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestWBC")="PALab^3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAThyromentalDistance")="PA^67"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATongue")="PA^18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATonsilHyper")="PA^22"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAUltrsonic")="PA^100"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAUpperLimb")="PA^77"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAUrinarySystem")="PA^42"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAUrinarySystemOther")="PA^43"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAVascularUltrasonic")="PA^101"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAXRay")="PA^98"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPacuBedDr")="47"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPatDeptDr")="21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPatHeight")="22"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPatStatus")="23"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPatWeight")="24"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPathologSection")="57"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPostAnaSum")="60"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPostAnaSumOther")="61"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPostAnaVisit")="62"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPostAnaVisitOther")="63"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnDrug")="29"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaDrug")="72"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaVisit")="PA^106"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaVisitCtcpDr")="76"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaVisitDate")="77"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaVisitOther")="PA^107"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaVisitTime")="78"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreDiscussDate")="38"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreOperPatTeaching")="70"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPrepareBlood")="33"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPsychologicRelease")="71"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPsychosis")="45"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPARHBloodType")="25"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAReturnReasonDr")="35"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAScrubNurseNote")="51"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPASelfIntroduce")="69"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPASeq")="26"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPASeqNote")="41"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAStartDate")="14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAStartTime")="15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAStatus")="27"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPATransferMeans")="39"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAUnPlanedOperation")="46"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAUseSelfBlood")="34"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAWardDr")="32"
    q ""
}

ClassMethod SetOPArrangeIndexNew() As %String
{
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAddInstrument")="31"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAdmDr")="1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAllogeneicBlood")="Sum^7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnDocNote")="43"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnSheetEditAudit")="74"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnSheetPrintAudit")="73"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnaDoctorOrdered")="48"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnaEffect")="12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnaNurseOrdered")="49"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnaestDr")="2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnalgesia")="66"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnalgesiaEstimate")="68"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnalgesiaOther")="67"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAnalgesiaPlan")="PA^105"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAppCtcpDr")="6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAppDate")="3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAppLocDr")="54"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAppTime")="5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAArrangeDate")="7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAArrangeTime")="8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAArrangeUserDr")="9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAuditStatus")="4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAAutologousBlood")="Sum^8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPABloodTypeDr")="11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareFlush")="Care^31"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareFlushOther")="Care^32"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareOperRecord")="Care^36"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareOperRecordDispose")="Care^38"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareOperRecordOther")="Care^39"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareOperRecordSpecial")="Care^37"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACareOperVitalSign")="Care^35"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACarePerfusion")="Care^29"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACarePerfusionOther")="Care^30"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACarePlugger")="Care^33"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACarePluggerSite")="Care^34"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACirculNurseNote")="52"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACoagulationFactor")="Sum^13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACollectedStatus")="18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAddCirculDr")="Count^6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAddDate")="Count^7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAddScrubDr")="Count^5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAddTime")="Count^8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAuditCTCPDr")="Count^19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAuditDate")="Count^20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountAuditTime")="Count^21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountCorrect")="Count^17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountNote")="Count^18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountPreOperCirculDr")="Count^2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountPreOperDate")="Count^3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountPreOperScrubDr")="Count^1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountPreOperTime")="Count^4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountSewedCirculDr")="Count^14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountSewedDate")="Count^15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountSewedScrubDr")="Count^13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountSewedTime")="Count^16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountUnSewCirculDr")="Count^10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountUnSewDate")="Count^11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountUnSewScrubDr")="Count^9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPACountUnSewTime")="Count^12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPADocArriveTime")="58"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPADrainage")="Sum^17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAEndDate")="16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAEndTime")="17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAEstiOperDuration")="37"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAExCirculation")="36"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAExtubIndicate")="65"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAExtubationDone")="64"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAFreezingSlice")="56"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInAreaBPDiastolic")="83"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInAreaBPSystolic")="82"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInAreaHeartRate")="84"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInAreaRespRate")="85"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInAreaTemperature")="81"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInfusedBlood")="Sum^6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInfusedElectrolyte")="Sum^2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInfusedNutrition")="Sum^3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInfusedSyntheticColloids")="Sum^4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInfusedTherapy")="Sum^5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAInstrumentDr")="30"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAIsolated")="10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPALossBlood")="Sum^16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAMedInfect")="53"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAMemo")="19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAMiniInvasive")="13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPANavigation")="55"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPANeedAnaesthetist")="44"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPANeedScrubNurse")="40"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOpDocNote")="42"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOpLevelDr")="28"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOpNurseOrdered")="50"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOpNurseOrderedDate")="79"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOpNurseOrderedTime")="80"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOpRoomDr")="20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOperDelayNote")="59"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAOperSiteSkin")="75"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAldosterone")="PA^14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAllen")="PA^79"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAnaClass")="PA^88"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAnaSpecificApply")="PA^91"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAnaestType")="PA^89"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAAngiography")="PA^102"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABPDiastolic")="PA^62"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABPSystolic")="PA^61"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABloodSystem")="PA^38"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABloodSystemOther")="PA^39"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABoneSystem")="PA^36"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPABoneSystemOther")="PA^37"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACT")="PA^99"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUConsciousness")="PACU^13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUDischCtcpDR")="PACU^11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUDuration")="PACU^10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUExtremityMove")="PACU^15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUHemodynamics")="PACU^16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUInAdmission")="PACU^1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUInDate")="PACU^6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUInTime")="PACU^7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUNausea")="PACU^20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUNerve")="PACU^19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUNote")="PACU^23"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUNurseDr")="PACU^12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUOther")="PACU^24"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUOutDate")="PACU^8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUOutTime")="PACU^9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUOxygenSaturation")="PACU^17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACURenal")="PACU^18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACURespiration")="PACU^14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUScoreDetail")="PACU^2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUScoreVal")="PACU^3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUTemperature")="PACU^22"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUVasScoreDetail")="PACU^4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUVasScoreVal")="PACU^5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACUVomiting")="PACU^21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACardiacCatheter")="PA^96"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACardiacRhythm")="PA^9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACardiovascular")="PA^74"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACirculSystemOther")="PA^11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACirculatorySystem")="PA^8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAConsciousness")="PA^64"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACurCondition")="PA^56"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACurConditionOther")="PA^57"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACurDrug")="PA^50"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPACurDrugOther")="PA^51"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPADiffcultPrevent")="PA^93"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPADigestSystemOther")="PA^35"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPADigestiveSystem")="PA^32"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPADyspneaClass")="PA^85"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAEKG")="PA^95"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAEchocardiogram")="PA^97"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAEndoSystemOther")="PA^16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAEndocrineSystem")="PA^12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAExam")="PA^94"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAExamOther")="PA^104"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAFamily")="PA^52"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAFamilyOther")="PA^53"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAGenitalSystem")="PA^40"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAGenitalSystemOther")="PA^41"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAHeadNeck")="PA^70"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAHeartRate")="PA^59"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAHypertension")="PA^10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAHypothyroid")="PA^15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAIllness")="PA^1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAInfect")="PA^108"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAInfectDispose")="PA^109"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAInsulin")="PA^13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAIntubatDiffcult")="PA^86"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAJaw")="PA^19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPALiver")="PA^33"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPALowerLimb")="PA^78"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPALung")="PA^75"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMallampatiClass")="PA^66"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMonitorItem")="PA^90"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMouth")="PA^17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMouthOpen")="PA^65"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMouthOther")="PA^20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMuscularSystem")="PA^30"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAMuscularSystemOther")="PA^31"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANYHA")="PA^87"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANeck")="PA^24"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANeckBackFlexAngle")="PA^72"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANeckForwardFlexAngle")="PA^71"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANeckOther")="PA^25"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANervSystemOther")="PA^3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANerve")="PA^76"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANervousSystem")="PA^2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANose")="PA^28"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPANoseOther")="PA^29"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAOrganOther")="PA^82"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAOtherSystem")="PA^44"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAOtherSystemOther")="PA^45"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPeripheralVein")="PA^80"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPharynx")="PA^21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPharynxOther")="PA^23"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPhyExam")="PA^58"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPhyExamOther")="PA^83"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPlan")="PA^92"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPreAllergy")="PA^48"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPreAllergyOther")="PA^49"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPreAnop")="PA^46"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPreAnopOther")="PA^47"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAPulmonaryFuncTest")="PA^103"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPARespRate")="PA^63"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPARespSystem")="PA^4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPARespSystemOther")="PA^7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPARespTractClass")="PA^84"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPARespiration")="PA^73"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASkin")="PA^26"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASkinOther")="PA^27"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASmokeDuration")="PA^6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASmokeFreq")="PA^5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASocial")="PA^54"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASocialOther")="PA^55"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASpine")="PA^81"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPASpleen")="PA^34"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATeeth")="PA^68"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATeethDetail")="PA^69"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATemp")="PA^60"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATest")="PALab^1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestALB")="PALab^11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestALP")="PALab^13"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestALT")="PALab^8"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestAPTT")="PALab^41"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestAST")="PALab^9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestBE")="PALab^54"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestBUN")="PALab^16"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestCHOL")="PALab^18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestCKMB")="PALab^23"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestCREA")="PALab^15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestCa")="PALab^27"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestCl")="PALab^28"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestDDimer")="PALab^43"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestFDP")="PALab^44"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestFIB")="PALab^42"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestGLU")="PALab^14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHB")="PALab^5"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHBcAb")="PALab^33"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHBeAb")="PALab^32"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHBeAg")="PALab^31"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHBsAb")="PALab^30"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHBsAg")="PALab^29"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHCO3")="PALab^53"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHCT")="PALab^6"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHCVAb")="PALab^34"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHDLC")="PALab^20"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestHivAb")="PALab^35"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestINR")="PALab^40"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestK")="PALab^25"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestLAC")="PALab^24"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestLDH")="PALab^22"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestLDLC")="PALab^21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestNa")="PALab^26"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestOther")="PALab^2"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPCO2")="PALab^51"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPH")="PALab^50"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPLT")="PALab^7"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPO2")="PALab^52"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPT")="PALab^37"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPTA")="PALab^38"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestPTR")="PALab^39"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestRBC")="PALab^4"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestSO2")="PALab^55"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestTBIL")="PALab^12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestTG")="PALab^19"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestTP")="PALab^10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestTPAb")="PALab^36"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUA")="PALab^17"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUrineERY")="PALab^49"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUrineGLU")="PALab^45"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUrineKET")="PALab^46"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUrineNPRO")="PALab^47"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestUrinePH")="PALab^48"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATestWBC")="PALab^3"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAThyromentalDistance")="PA^67"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATongue")="PA^18"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPATonsilHyper")="PA^22"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAUltrsonic")="PA^100"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAUpperLimb")="PA^77"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAUrinarySystem")="PA^42"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAUrinarySystemOther")="PA^43"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAVascularUltrasonic")="PA^101"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPAXRay")="PA^98"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPacuBedDr")="47"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPatDeptDr")="21"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPatHeight")="22"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPatStatus")="23"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPatWeight")="24"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPathologSection")="57"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPlasma")="Sum^11"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPlatelets")="Sum^12"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPostAnaSum")="60"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPostAnaSumOther")="61"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPostAnaVisit")="62"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPostAnaVisitOther")="63"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnDrug")="29"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaDrug")="72"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaVisit")="PA^106"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaVisitCtcpDr")="76"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaVisitDate")="77"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaVisitOther")="PA^107"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreAnaVisitTime")="78"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreDiscussDate")="38"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPreOperPatTeaching")="70"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPrepareBlood")="33"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPsychologicRelease")="71"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAPsychosis")="45"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPARHBloodType")="25"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPARedCells")="Sum^10"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAReturnReasonDr")="35"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPASalvagedBlood")="Sum^9"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAScrubNurseNote")="51"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPASelfIntroduce")="69"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPASeq")="26"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPASeqNote")="41"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAStartDate")="14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAStartTime")="15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAStatus")="27"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPASurgonLocDr")="86"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPATotalIn")="Sum^1"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPATotalOut")="Sum^14"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPATransferMeans")="39"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAUnPlanedOperation")="46"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAUrine")="Sum^15"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAUseSelfBlood")="34"
    s ^DHCCLSet("AnOp","ANCInquiry","OPA","OPAWardDr")="32"
    q ""
}

ClassMethod SetANIIndex() As %String
{
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIAnaSpecificApply")=110
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIAnaSpecificApplyOther")=117
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIAnesthesiaOther")=109
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIArterialPuncOther")=114
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIArterialPuncture")=113
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIBPDiastolic")=119
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIBPSystolic")=118
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIBasalAnesthesia")=102
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANICardiPulmoCerebrResuscit")=116
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANICentralVeinPuncOther")=112
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANICentralVeinPuncture")=111
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIChildSub")=1
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneral")=62
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralInduce")=64
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralInduceEffect")=66
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralInduceOther")=67
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralInduceSucc")=9
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralInduceType")=65
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralInhalType")=69
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralInhalation")=68
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralIntraven")=70
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralIntravenType")=71
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralMark")=8
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralOther")=100
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralRecovDuration")=97
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralRecovLocation")=98
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralRecovTech")=96
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralRecovery")=95
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralRecoveryOther")=99
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIGeneralType")=63
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIHeartRate")=120
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIInducedHypothermia")=115
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathAnaLevelBottom")=43
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathAnaLevelTop")=42
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathDirect")=32
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathExtCtcpDr")=40
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathExtDate")=38
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathExtTime")=39
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathInCtcpDr")=37
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathLen")=31
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathLenSecond")=36
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathOther")=41
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathPuncEffect")=30
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathSpec")=33
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCathSuccess")=5
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCatheter")=29
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCaudal")=50
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCaudalOther")=53
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCaudalPuncEffect")=51
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathCaudalTestAmt")=52
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathEffect")=13
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathEpidlTestAmt")=48
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathEpidural")=47
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathEpiduralOther")=49
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathOther")=54
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPos")=14
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncApproach")=17
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncApproachSecond")=35
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncArachnoid")=27
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncBevelDirect")=25
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncBleedAmt")=23
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncDiffFeel")=22
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncEffect")=18
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncInjectSpeed")=26
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncNegComp")=21
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncOther")=28
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncPos")=19
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncResist")=20
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncSite")=16
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncSiteSecond")=34
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncSpec")=24
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncSuccess")=4
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathPuncture")=15
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathSpinal")=45
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathSpinalOther")=46
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathToxicity")=44
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathType")=12
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathecal")=11
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntrathecalMark")=3
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubatLarymaskSize")=92
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubatLarymaskSpec")=93
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubatLaryngomask")=91
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubation")=72
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationAnestType")=73
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationCuff")=79
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationDepth")=81
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationEffect")=74
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationExtCtcpDr")=89
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationExtDate")=87
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationExtDone")=86
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationExtIndicator")=85
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationExtTech")=90
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationExtTime")=88
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationInCtcpDr")=84
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationInDate")=82
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationInTime")=83
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationInnerDiameter")=77
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationMark")=10
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationOther")=94
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationRoute")=80
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationTerminal")=78
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationVision")=75
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIIntubationVisionType")=76
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIMoniAnCare")=7
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlock")=55
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockBrachia")=106
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockBrachiaOther")=107
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockCervicum")=104
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockCervicumOther")=105
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockEffect")=60
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockMark")=6
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockOther")=61
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockPeripheral")=108
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockPuncEffect")=58
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockSite")=57
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockToxicity")=59
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANINerveBlockType")=56
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIOxygenSaturation")=122
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIPostAnaMark")=2
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIRegionalAnesthesia")=103
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANIRespRate")=121
    s ^DHCCLSet("AnOp","ANCInquiry","ANI","ANITheatreTransferTo")=101
    q ""
}

/// 设置各类医护人员数量
/// w ##class(web.DHCANOPStat).SetInquiryCtpcpCount("ANDoctor","AN^EMAN^OUTAN")
ClassMethod SetInquiryCtpcpCount(ctpcpType, locListCodeStr, ifDoctor = "", ifSurgeon = "") As %String [ ProcedureBlock = 0 ]
{
    s ClassName="web.UDHCANOPArrange"
    s QueryName="FindCtcp"
    q:ctpcpType="" "0"
    i ctpcpType="ANDoctor" s ifDoctor="Y"
    e  i ctpcpType="Surgeon" s ifDoctor="Y",ifSurgeon="Y"
    s rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
    s execute="set %sc=$zobjmethod(rs,""Execute"","""",locListCodeStr,"""","""","""",ifDoctor,ifSurgeon)"
    x execute
    s count=0
    s columns=rs.GetColumnCount()
    f  q:rs.Next()=0  d
    .s count=count+1
    
    s ^DHCANInquiry("CtpcpCount",ctpcpType)=count
    q count
}

/// 获取常用医嘱
/// d ##class(%ResultSet).RunQuery("web.DHCANOPStat","FindCommonOrd","E")
Query FindCommonOrd(type) As %Query(ROWSPEC = "ancoId:%String,ancoDesc:%String")
{
}

ClassMethod FindCommonOrdExecute(ByRef qHandle As %Binary, type) As %Status
{
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    
    s ancoCode=""
    f  s ancoCode=$o(^DHCANC("ComOrd",0,"TypeCode",type,ancoCode)) q:ancoCode=""  d
    .s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode",type,ancoCode,""))
    .i $d(^DHCANC("ComOrd",+ancoId)) d
    ..s ancoDesc=$p(^DHCANC("ComOrd",+ancoId),"^",2)
    ..d OutputCommonOrd
    
    s qHandle=$lb(0,repid,0)
    q $$$OK

OutputCommonOrd
    s Data=$lb(ancoId,ancoDesc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod FindCommonOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCommonOrdExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod FindCommonOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCommonOrdExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

}
