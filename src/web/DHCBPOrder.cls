Import SQLUser

Class web.DHCBPOrder Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPOrder","GetBPOrderStatistics","2014-02-24","2014-02-24","0000000021","","","菲奥娜","Statistics")
/// d ##class(%ResultSet).RunQuery("web.DHCBPOrder","FindBPOrder","2014-02-26","2014-02-26","00000555","","399597","陈孝周","S")
/// d ##class(%ResultSet).RunQuery("web.DHCBPOrder","FindBPOrder","2021-11-16","2021-11-16","0000001619","","","李德珠","N",194,182)
Query FindBPOrder(fromDate As %String, toDate As %String, regNo As %String = "", needBpoiStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", BPOrderType As %String, ctLoc As %String = "", registerId As %String = "", arrangeId As %String = "") As %Query(ROWSPEC = "Id,RegNo,PatName,Medicare,RegisterId,ArrangeId,BPOrderType,ArcimId,ArcimCode,ArcimDesc,ArcimAbbrev,Dose,DoseUnitId,DoseUnitDesc,PackQty,PackUnitId,PackUnitDesc,FreqId,FreqDesc,InstructId,InstructDesc,StartDate,StartTime,StartDateTime,Status,Note,MasterSeqNo,SeqNo,RecLocId,RecLocDesc,OrderItemDr,CreateCtcpId,CreateCtcpDesc,CreateDate,CreateTime,CreateDateTime,XCtcpId,XCtcpDesc,XDate,XTime,ExecCtcpDr,ExecCtcpDesc,ExecDate,ExecTime,CancelExecCtcpId,CancelExecCtcpDesc,CancelExecDate,CancelExecTime,DurationId,DurationDesc,Price")
{
}

ClassMethod FindBPOrderExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", needBpoiStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", BPOrderType As %String, ctLoc As %String = "", registerId As %String = "", arrangeId As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)	
	s EpisodeIDList=""
	i regNo'="" s EpisodeIDList=##class(web.DHCANOPCom).GetPatientEpisodeID(regNo,"")
	s papmiIdList=""
	s bpprIdList=""
	i regNo'="" s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	i papmiIdList="",papmiMedicare'="" d
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
		.s papmiIdList=$o(^PAPERi("Medicare1",papmiMedicare,""))
	i papmiIdList="",papmiName'="" d
		.s papmiName=$$ALPHAUP^SSUTIL4(papmiName)
		.s papmiId=""
		.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiName,papmiId)) q:papmiId=""  d
			..i papmiIdList'="" s papmiIdList=papmiIdList_"^"
			..s papmiIdList=papmiIdList_papmiId
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") s isLocQuery=0
	e  s isLocQuery=1
	s wardIdStr=##Class(web.DHCBPCom).GetLinkLocByLocId(ctLoc) //科室关联
	i papmiIdList'="" d
		.f i=1:1:$l(papmiIdList,"^") d
			..s papmiId=$p(papmiIdList,"^",i)
			..q:papmiId=""
			..q:'$d(^PAPER(papmiId,"PAT",1))
			..s bpprId=""
			..f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:bpprId=""  d
			...q:(registerId'="")&&(bpprId'=registerId)
			...s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
			...q:(bpprPatLocationDr'="")&&(wardIdStr'="")&&(("^"_wardIdStr_"^")'[("^"_bpprPatLocationDr_"^"))
			...d GetBPOrder()

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetBPOrder()
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)	
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //病案号 20200515统一走病案接口
	s admId=$lg($g(^DHCBPPatRegister(bpprId)),26) //透析登记时病人就诊ID
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	k ^TMPBP("ORDER",$i)
	i BPOrderType="N" d
	.s bpoiId=""
	.f curDate=fromDate:1:toDate d
	..f  s bpoiId=$o(^DHCBPOrderItem(0,"DateRegister",curDate,bpprId,bpoiId)) q:bpoiId=""  d
	...s ^TMPBP("ORDER",$i,bpoiId)=""
	e  d
	.b ;''
	.s bpoiId=""
	.f  s bpoiId=$o(^DHCBPOrderItem(0,"RegisterType",bpprId," "_BPOrderType,bpoiId)) q:bpoiId=""  d
	..;b ;id2
	..s ^TMPBP("ORDER",$i,bpoiId)=""
	b
	s bpoiId=""
	f  s bpoiId=$o(^TMPBP("ORDER",$i,bpoiId)) q:bpoiId=""  d
	    
	    .s bpopBPPatRegisterDr=$li(^DHCBPOrderItem(bpoiId),1)
	    .s bpoiBPArrangeDr=$li(^DHCBPOrderItem(bpoiId),2)
	    .q:(arrangeId'="")&(arrangeId'=bpoiBPArrangeDr) 
	    .s bpoiOrderTypeCode=$li(^DHCBPOrderItem(bpoiId),3)
	    .q:bpoiOrderTypeCode'=BPOrderType
	    .s bpoiArcimDr=$li(^DHCBPOrderItem(bpoiId),4)
	    .s arcimSub=$p(bpoiArcimDr,"||",1)
	    .s arcimVer=$p(bpoiArcimDr,"||",2)
	    .s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
	    .s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	    .s arcimAbbrev=$p(^ARCIM(arcimSub,arcimVer,1),"^",3)
	    .i 1[arcimAbbrev s arcimAbbrev=arcimDesc
	    .s bpoiDose=$li(^DHCBPOrderItem(bpoiId),5)
	    .s bpoiDoseUnitDr=$li(^DHCBPOrderItem(bpoiId),6)
	    .s bpoiDoseUnitDesc=""
	    .i bpoiDoseUnitDr'="" d
	    ..s bpoiDoseUnitDesc=$ZCVT($p($g(^CT("UOM",+bpoiDoseUnitDr)),"^",2),"l")
	    .s bpoiPackQty=$li(^DHCBPOrderItem(bpoiId),7)
	    .s bpoiPackUnitDr=$li(^DHCBPOrderItem(bpoiId),8)
	    .s bpoiPackUnitDesc=""
	    .i bpoiPackUnitDr'="" d
	    .s bpoiPackUnitDesc=$ZCVT($p($g(^CT("UOM",+bpoiPackUnitDr)),"^",2),"l")
	    .s bpoiFreqDr=$li(^DHCBPOrderItem(bpoiId),9)
	    .s bpoiFreqDesc=""
	    .i bpoiFreqDr'="" d
	    ..s bpoiFreqDesc=$p($g(^PHCFR(bpoiFreqDr)),"^",4)
	    .s bpoiInstructDr=$li(^DHCBPOrderItem(bpoiId),10)
	    .s bpoiInstructDesc=""
	    .i bpoiInstructDr'="" d
	    ..s bpoiInstructDesc=$p($g(^PHCIN(bpoiInstructDr)),"^",2)
	    .i $l(bpoiInstructDesc,"-")>1 d
	    ..s bpoiInstructDesc=$p(bpoiInstructDesc,"-",2)
	    .s bpoiStartDate=$li(^DHCBPOrderItem(bpoiId),11)
	    .q:((fromDate'="")&&(toDate'=""))&&(bpoiStartDate'="")&&((bpoiStartDate<fromDate)||(bpoiStartDate>toDate))
	    .i bpoiStartDate'="" d
	    ..s bpoiStartDate=$zd(bpoiStartDate,3)
	    .s bpoiStartTime=$li(^DHCBPOrderItem(bpoiId),12)
	    .i bpoiStartTime'="" d
	    ..s bpoiStartTime=$zt(bpoiStartTime,4)
	    .b ;bpoiStartTime
	    .s bpoiStartDateTime=""
	    .i bpoiStartDate'="" s bpoiStartDateTime=bpoiStartDate
	    .i bpoiStartTime'="" s bpoiStartDateTime=bpoiStartDate_" "_bpoiStartTime
	    .s bpoiStatus=$lg($g(^DHCBPOrderItem(bpoiId)),13)
	    .q:(needBpoiStatus'="")&&(needBpoiStatus'=bpoiStatus)
	    .s bpoiNote=$li(^DHCBPOrderItem(bpoiId),14)
	    .s bpoiMasterSeqNo=$li(^DHCBPOrderItem(bpoiId),15)
	    .s bpoiSeqNo=$li(^DHCBPOrderItem(bpoiId),16)
	    .s bpoiRecLocDr=$li(^DHCBPOrderItem(bpoiId),17)
	    .s bpoiRecLocDesc=""
	    .i bpoiRecLocDr'="" d
	    ..s bpoiRecLocDesc=$P($g(^CTLOC(bpoiRecLocDr)),"^",2) 
	    .s bpoiDurationDr=$li(^DHCBPOrderItem(bpoiId),18)
	    .s bpoiDurationDesc="" 
	    .i bpoiDurationDr'="" s bpoiDurationDesc=$p(^PHCDU(bpoiDurationDr),"^",1)
	    .s bpoiOrderItemDr=$li(^DHCBPOrderItem(bpoiId),19)
	    .s bpoiCreateCtcpDr=$li(^DHCBPOrderItem(bpoiId),20)
	    .s bpoiCreateCtcpDesc=""
	    .i bpoiCreateCtcpDr'="" s bpoiCreateCtcpDesc=##class(web.DHCANOPCom).GetNameById(bpoiCreateCtcpDr) 
	    .s bpoiCreateDate=$li(^DHCBPOrderItem(bpoiId),21)
	    .i bpoiCreateDate'="" d
	    ..s bpoiCreateDate=$zd(bpoiCreateDate,3)
	    .s bpoiCreateTime=$li(^DHCBPOrderItem(bpoiId),22)
	    .i bpoiCreateTime'="" d
	    ..s bpoiCreateTime=$zt(bpoiCreateTime,4)
	    .s bpoiCreateDateTime=""
	    .i bpoiCreateDate'="" s bpoiCreateDateTime=bpoiCreateDate
	    .i bpoiCreateTime'="" s bpoiCreateDateTime=bpoiCreateDate_" "_bpoiCreateTime
	    .s bpoiXCtcpDr=$li(^DHCBPOrderItem(bpoiId),23)
	    .s bpoiXCtcpDesc=""
	    .i bpoiXCtcpDr'="" d
	    ..s bpoiXCtcpDesc=##class(web.DHCBPCom).GetNameById(bpoiXCtcpDr) 
	    .s bpoiXDate=$li(^DHCBPOrderItem(bpoiId),24)
	    .i bpoiXDate'="" d
	    ..s bpoiXDate=$zd(bpoiXDate,3)
	    .s bpoiXTime=$li(^DHCBPOrderItem(bpoiId),25)
	    .i bpoiXTime'="" d
	    ..s bpoiXTime=$zt(bpoiXTime,4)
	    .s bpoiExecCtcpDr=$li(^DHCBPOrderItem(bpoiId),26)
	    .s bpoiExecCtcpDesc=##class(web.DHCBPCom).GetNameById(bpoiExecCtcpDr)
	    .s bpoiExecDate=$li(^DHCBPOrderItem(bpoiId),27)
	    .i bpoiExecDate'="" d
	    ..s bpoiExecDate=$zd(bpoiExecDate,3)
	    .s bpoiExecTime=$li(^DHCBPOrderItem(bpoiId),28)
	    .i bpoiExecTime'="" d
	    ..s bpoiExecTime=$zt(bpoiExecTime,4)
	    .s bpoiCancelExecCtcpDr=$lg(^DHCBPOrderItem(bpoiId),29)
	    .s bpoiCancelExecCtcpDesc=##class(web.DHCBPCom).GetNameById(bpoiCancelExecCtcpDr)
	    .s bpoiCancelExecDate=$lg(^DHCBPOrderItem(bpoiId),30)
	    .i bpoiCancelExecDate'="" d
	    ..s bpoiCancelExecDate=$zd(bpoiCancelExecDate,3)
	    .s bpoiCancelExecTime=$lg(^DHCBPOrderItem(bpoiId),31)
	    .i bpoiCancelExecTime'="" d
	    ..s bpoiCancelExecTime=$zt(bpoiCancelExecTime,4)
	    .s bpoiPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",bpoiArcimDr,$zdh(bpoiStartDate,3),"","","","")
	    .d OutputRow
	    k ^TMPBP("ORDER",$i)	    	
	q 0
OutputRow
	set Data=$lb(bpoiId,regNo,patName,papmiMedicare,bpopBPPatRegisterDr,bpoiBPArrangeDr,bpoiOrderTypeCode,bpoiArcimDr,arcimCode,arcimDesc,arcimAbbrev,bpoiDose,bpoiDoseUnitDr,bpoiDoseUnitDesc,bpoiPackQty,bpoiPackUnitDr,bpoiPackUnitDesc,bpoiFreqDr,bpoiFreqDesc,bpoiInstructDr,bpoiInstructDesc,bpoiStartDate,bpoiStartTime,bpoiStartDateTime,bpoiStatus,bpoiNote,bpoiMasterSeqNo,bpoiSeqNo,bpoiRecLocDr,bpoiRecLocDesc,bpoiOrderItemDr,bpoiCreateCtcpDr,bpoiCreateCtcpDesc,bpoiCreateDate,bpoiCreateTime,bpoiCreateDateTime,bpoiXCtcpDr,bpoiXCtcpDesc,bpoiXDate,bpoiXTime,bpoiExecCtcpDr,bpoiExecCtcpDesc,bpoiExecDate,bpoiExecTime,bpoiCancelExecCtcpDr,bpoiCancelExecCtcpDesc,bpoiCancelExecDate,bpoiCancelExecTime,bpoiDurationDr,bpoiDurationDesc,bpoiPrice)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPOrderExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SaveBPOrderItems(BPOrderItemList As %String) As %String
{
	s result=""
	f i=1:1:$l(BPOrderItemList,"^")  d
	.s BPOrderItem=$p(BPOrderItemList,"^",i)
	.s itemObj=..SaveBPOrderItem(BPOrderItem)
	.d itemObj.%Save()
	.i result'="" s result=result_"^"
	.s result=result_itemObj.%Id()
	.d itemObj.%Close()
	q result
}

ClassMethod SaveBPOrderItem(BPOrderItem As %String) As User.DHCBPOrderItem
{
	s BPOrderItemObj=""
	w BPOrderItem,!
	s BPOrderItemId=$p(BPOrderItem,$c(3),1)	
	i BPOrderItemId="" s BPOrderItemObj=##class(User.DHCBPOrderItem).%New()
	e  s BPOrderItemObj=##class(User.DHCBPOrderItem).%OpenId(BPOrderItemId)		
    s BPOrderItemObj.BPOIBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId($p(BPOrderItem,$c(3),2))
	s BPOrderItemObj.BPOIBPArrangeDr=##class(User.DHCBPArrange).%OpenId($p(BPOrderItem,$c(3),3))
	s BPOrderItemObj.BPOIOrderType=$p(BPOrderItem,$c(3),4)
	s BPOrderItemObj.BPOIArcimDr=$p(BPOrderItem,$c(3),5)
	s BPOrderItemObj.BPOIDose=$p(BPOrderItem,$c(3),6)
	s BPOrderItemObj.BPOIDoseUnitDr=$p(BPOrderItem,$c(3),7)
	s BPOrderItemObj.BPOIPackQty=$p(BPOrderItem,$c(3),8)
	s BPOrderItemObj.BPOIPackUnitDr=$p(BPOrderItem,$c(3),9)
	s BPOrderItemObj.BPOIFreqDr=$p(BPOrderItem,$c(3),10)
	s BPOrderItemObj.BPOIInstructDr=$p(BPOrderItem,$c(3),11)
	s startDate=$p(BPOrderItem,$c(3),12)
	i startDate'="" d
	.s BPOrderItemObj.BPOIStartDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
	s startTime=$p(BPOrderItem,$c(3),13)
	i startTime'="" d
	.s BPOrderItemObj.BPOIStartTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
	s BPOrderItemObj.BPOIStatus=$p(BPOrderItem,$c(3),14)
	s BPOrderItemObj.BPOINote=$p(BPOrderItem,$c(3),15)
	s BPOrderItemObj.BPOIMasterSeqNo=$p(BPOrderItem,$c(3),16)
	s BPOrderItemObj.BPOISeqNo=$p(BPOrderItem,$c(3),17)
	s BPOrderItemObj.BPOIRecLocDr=$p(BPOrderItem,$c(3),18)
	s BPOrderItemObj.BPOIOrderItemDr=$p(BPOrderItem,$c(3),19)
	s BPOrderItemObj.BPOICreateCtcpDr=$p(BPOrderItem,$c(3),20)
	s BPOrderItemObj.BPOICreateDate=+$h
	s BPOrderItemObj.BPOICreateTime=$p($h,",",2)
	s xCtcpDr=$p(BPOrderItem,$c(3),21)
	i xCtcpDr'="" d
	.s BPOrderItemObj.BPOIXCtcpDr=xCtcpDr
	s xDate=$p(BPOrderItem,$c(3),22)
	i xDate'="" d
	.s BPOrderItemObj.BPOIXDate=##class(web.DHCANOPCom).ConvertToDateH(xDate)
	s xTime=$p(BPOrderItem,$c(3),23)
	i xTime'="" d
	.s BPOrderItemObj.BPOIXTime=##class(web.DHCANOPCom).ConvertToTimeH(xTime)
	s execUserDr=$p(BPOrderItem,$c(3),24)
	i execUserDr'="" d
	.s BPOrderItemObj.BPOIExecCtcpDr=execUserDr
	s execDate=$p(BPOrderItem,$c(3),25)
	i execDate'="" d
	.s BPOrderItemObj.BPOIExecDate=##class(web.DHCANOPCom).ConvertToDateH(execDate)
	s execTime=$p(BPOrderItem,$c(3),26)
	i execTime'="" d
	.s BPOrderItemObj.BPOIExecTime=##class(web.DHCANOPCom).ConvertToTimeH(execTime)	
	q BPOrderItemObj
}

ClassMethod AddBPOrderItem(BPOrderItem As %String) As %String
{
	s arrangeId=$p(BPOrderItem,$c(3),2)
	s bpOrderType=$p(BPOrderItem,$c(3),3)
	q:(bpOrderType="N")&&(arrangeId="") "插入临时医嘱不能为未安排状态"
	s BPOrderItemObj=""
    s BPOrderItemObj=##class(User.DHCBPOrderItem).%New()	
    s BPOrderItemObj.BPOIBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId($p(BPOrderItem,$c(3),1))
	s BPOrderItemObj.BPOIBPArrangeDr=##class(User.DHCBPArrange).%OpenId(arrangeId)
	s BPOrderItemObj.BPOIOrderType=bpOrderType
	s BPOrderItemObj.BPOIArcimDr=$p(BPOrderItem,$c(3),4)
	s BPOrderItemObj.BPOIDose=$p(BPOrderItem,$c(3),5)
	s BPOrderItemObj.BPOIDoseUnitDr=$p(BPOrderItem,$c(3),6)
	s BPOrderItemObj.BPOIPackQty=$p(BPOrderItem,$c(3),7)
	s BPOrderItemObj.BPOIPackUnitDr=$p(BPOrderItem,$c(3),8)
	s BPOrderItemObj.BPOIFreqDr=$p(BPOrderItem,$c(3),9)
	s BPOrderItemObj.BPOIInstructDr=$p(BPOrderItem,$c(3),10)
	s BPOrderItemObj.BPOIStartDate=##class(web.DHCANOPCom).ConvertToDateH($p(BPOrderItem,$c(3),11))
	s BPOrderItemObj.BPOIStartTime=##class(web.DHCANOPCom).ConvertToTimeH($p(BPOrderItem,$c(3),12))
	s BPOrderItemObj.BPOIStatus=$p(BPOrderItem,$c(3),13)
	s BPOrderItemObj.BPOINote=$p(BPOrderItem,$c(3),14)
	s BPOrderItemObj.BPOIMasterSeqNo=$p(BPOrderItem,$c(3),15)
	s BPOrderItemObj.BPOISeqNo=$p(BPOrderItem,$c(3),16)
	s BPOrderItemObj.BPOIRecLocDr=$p(BPOrderItem,$c(3),17)
	s BPOrderItemObj.BPOIDurationDr=$p(BPOrderItem,$c(3),18)
	s BPOrderItemObj.BPOICreateCtcpDr=$p(BPOrderItem,$c(3),19)
	s BPOrderItemObj.BPOICreateDate=+$h
	s BPOrderItemObj.BPOICreateTime=$p($h,",",2)
	d BPOrderItemObj.%Save()
	s result=BPOrderItemObj.%Id()
	d BPOrderItemObj.%Close()
	q result
}

// w ##class(web.DHCBPOrder).AlterBPOrderItem("")

ClassMethod AlterBPOrderItem(BPOrderItem As %String) As %String
{
	//s ^TMPzt("BPOrderItem","123")=BPOrderItem
	//s BPOrderItem=^TMPzt("BPOrderItem","123")
	s BPOrderItemObj=""
	s rowId=$p(BPOrderItem,$c(3),1)
	q:rowId="" "未选中修改项"
    s BPOrderItemObj=##class(User.DHCBPOrderItem).%OpenId(rowId) 	
	s BPOrderItemObj.BPOIOrderType=$p(BPOrderItem,$c(3),2)
	s BPOrderItemObj.BPOIArcimDr=$p(BPOrderItem,$c(3),3)
	s BPOrderItemObj.BPOIDose=$p(BPOrderItem,$c(3),4)
	s BPOrderItemObj.BPOIDoseUnitDr=$p(BPOrderItem,$c(3),5)	
	b
	s BPOrderItemObj.BPOIPackQty=$p(BPOrderItem,$c(3),6)
	s BPOrderItemObj.BPOIPackUnitDr=$p(BPOrderItem,$c(3),7)
	s BPOrderItemObj.BPOIFreqDr=$p(BPOrderItem,$c(3),8)
	s BPOrderItemObj.BPOIInstructDr=$p(BPOrderItem,$c(3),9)
	s BPOrderItemObj.BPOIStartDate=##class(web.DHCANOPCom).ConvertToDateH($p(BPOrderItem,$c(3),10))
	s BPOrderItemObj.BPOIStartTime=##class(web.DHCANOPCom).ConvertToTimeH($p(BPOrderItem,$c(3),11))
	;s BPOrderItemObj.BPOIStatus=$p(BPOrderItem,$c(3),12)
	s BPOrderItemObj.BPOINote=$p(BPOrderItem,$c(3),13)
	s BPOrderItemObj.BPOIRecLocDr=$p(BPOrderItem,$c(3),15)
	b
	s BPOrderItemObj.BPOIDurationDr=$p(BPOrderItem,$c(3),16)
	d BPOrderItemObj.%Save()
	s result=BPOrderItemObj.%Id()
	d BPOrderItemObj.%Close()
	q result
}

ClassMethod StopBPOrderItems(BPOrderItems As %String) As %String
{
	q:BPOrderItems="" "未选中医嘱"
	s num=0
	s count=$l(BPOrderItems,"^")
	for i=1:1:count
	{
     s BPOrderItem=$p(BPOrderItems,"^",i)
     q:BPOrderItem=""
	 s rowId=$p(BPOrderItem,$c(3),1)
	 q:rowId="" 
	 s BPOrderItemObj=""
     s BPOrderItemObj=##class(User.DHCBPOrderItem).%OpenId(rowId) 	
	 s BPOrderItemObj.BPOIStatus=$p(BPOrderItem,$c(3),2)
	 s BPOrderItemObj.BPOIXCtcpDr=$p(BPOrderItem,$c(3),3)
	 s BPOrderItemObj.BPOIXDate=+$h
	 s BPOrderItemObj.BPOIXTime=$p($h,",",2)
	 d BPOrderItemObj.%Save()
	 s result=BPOrderItemObj.%Id()
	 d BPOrderItemObj.%Close()
	 s num=num+1
	}
	q num
}

ClassMethod CancelExcuteOrderItems(BPOrderItems As %String) As %String
{
	q:BPOrderItems="" "未选中医嘱"
	s num=0
	s count=$l(BPOrderItems,"^")
	for i=1:1:count
	{
     s BPOrderItem=$p(BPOrderItems,"^",i)
     q:BPOrderItem=""
	 s rowId=$p(BPOrderItem,$c(3),1)
	 q:rowId="" 
	 s BPOrderItemObj=""
     s BPOrderItemObj=##class(User.DHCBPOrderItem).%OpenId(rowId) 	
	 s BPOrderItemObj.BPOIStatus=$p(BPOrderItem,$c(3),2)
	 s BPOrderItemObj.BPOICancelExecCtcpDr=$p(BPOrderItem,$c(3),3)
	 s BPOrderItemObj.BPOICancelExecDate=+$h
	 s BPOrderItemObj.BPOICancelExecTime=$p($h,",",2)
	 d BPOrderItemObj.%Save()
	 s result=BPOrderItemObj.%Id()
	 d BPOrderItemObj.%Close()
	 s num=num+1
	}
	q num
}

/// w ##class(web.DHCBPOrder).ExecuteBPOrderItems("",224)
ClassMethod ExecuteBPOrderItems(BPOrderItems As %String, curLocId As %String) As %String
{
	s ^DHCTmpMfc("BPOrderItems","test")=BPOrderItems_"/"_curLocId
	
	//s BPOrderItems=^TMPzt("BPOrderItems","test")
	q:BPOrderItems="" "未选中医嘱"
	s num=0
	s count=$l(BPOrderItems,"^")
	s ret="",qFlag=0
	K TMPSumItem
	for i=1:1:count
	{
     s BPOrderItem=$p(BPOrderItems,"^",i)
     q:BPOrderItem=""
	 s rowId=$p(BPOrderItem,$c(3),1)
	 q:rowId="" 
	 s BPOrderItemObj=""
	 b
     s BPOrderItemObj=##class(User.DHCBPOrderItem).%OpenId(rowId) 	
	 s BPOrderItemObj.BPOIStatus=$p(BPOrderItem,$c(3),2)
	 s BPOrderItemObj.BPOIExecCtcpDr=$p(BPOrderItem,$c(3),3)
	 s BPOrderItemObj.BPOIExecDate=##class(web.DHCANOPCom).ConvertToDateH($p(BPOrderItem,$c(3),4))
	 s BPOrderItemObj.BPOIExecTime=##class(web.DHCANOPCom).ConvertToTimeH($p(BPOrderItem,$c(3),5))
	 s ctcpId=BPOrderItemObj.BPOIExecCtcpDr
	 s locId=BPOrderItemObj.BPOIRecLocDr //这里不对
	 s EpisodeID="" 
	 w BPOrderItemObj.BPOIStatus,!
	 w BPOrderItemObj.BPOIExecCtcpDr,!
	 w BPOrderItemObj.BPOIExecDate,!
	 w BPOrderItemObj.BPOIExecTime,!
	 w BPOrderItemObj.BPOIRecLocDr,!
	 s arrangeObj=BPOrderItemObj.BPOIBPArrangeDr
	 i arrangeObj'="" d
	 .s EpisodeID=arrangeObj.BPAAdmDr
	 .i EpisodeID="" d 	 
	 ..s registerObj=BPOrderItemObj.BPOIBPPatRegisterDr
	 ..i registerObj'="" d
  	 ...s papmiId=registerObj.BPPRPaPatMasDr
  	 ...s EpisodeIDList=##class(web.DHCBPCom).GetPatientEpisodeID("",papmiId,+$h,+$h,curLocId)
  	 ...s EpisodeID=$p(EpisodeIDList,"^",1)
  	 ..s EpisodeID="278"
  	 ..s arrangeObj.BPAAdmDr=EpisodeID
  	 ..d arrangeObj.%Save()
	 q:qFlag
     i EpisodeID="" s qFlag=1 
	 q:EpisodeID="" 
	 s arcimId=BPOrderItemObj.BPOIArcimDr
	 s startDate=BPOrderItemObj.BPOIStartDate
	 s startTime=BPOrderItemObj.BPOIStartTime
	 s recDepId=BPOrderItemObj.BPOIRecLocDr
	 s doseQty=BPOrderItemObj.BPOIDose
	 s packQty=BPOrderItemObj.BPOIPackQty
	 i packQty'="" s count=+packQty
	 e  s count=0
	 b ;num
	 i $d(TMPSumItem(arcimId,"Count")) s TMPSumItem(arcimId,"Count")=$g(TMPSumItem(arcimId,"Count"))+count
	 e  s TMPSumItem(arcimId,"Count")=count
	 s doseUomId=BPOrderItemObj.BPOIDoseUnitDr
	 s instrId=BPOrderItemObj.BPOIInstructDr
	 s seqNo=BPOrderItemObj.BPOISeqNo
	 i seqNo="" s seqNo=1000
	 s masterSeqNo=BPOrderItemObj.BPOIMasterSeqNo
	 s oeoriPrice=1
	 
	 s depProcNotes=BPOrderItemObj.BPOINote
	 ;s mulOeoriStr=arcimId_$c(3)_startDate_$c(3)_$zt(startTime)_$c(3)_recDepId_$c(3)_doseQty_$c(3)_packQty_$c(3)_doseUomId_$c(3)_instrId_$c(3)_seqNo_$c(3)_masterSeqNo_$c(3)_oeoriPrice_$c(3)_depProcNotes
	 b ;insert
	 s TMPSumItem("MulOeoriStr",arcimId)=arcimId_$c(3)_startDate_$c(3)_$zt(startTime)_$c(3)_recDepId_$c(3)_doseQty_$c(3)_TMPSumItem(arcimId,"Count")_$c(3)_doseUomId_$c(3)_instrId_$c(3)_seqNo_$c(3)_masterSeqNo_$c(3)_oeoriPrice_$c(3)_depProcNotes
	 
	 ;s retStr=..InsertOrderItem(EpisodeID,mulOeoriStr,userId,locId)
	 ;d BPOrderItemObj.%Save()
	 s saveStatus=BPOrderItemObj.%Save()	
	 w saveStatus,!	 
	 s result=BPOrderItemObj.%Id()
	 w result,!
	 d BPOrderItemObj.%Close()
	 s num=num+1
	}
	s ret=num
	/*i qFlag d
	.s ret="当天无就诊记录，请挂号以后执行医嘱录入!"
	e  d
	.s ret=num
	.s id="" f  s id=$O(TMPSumItem("MulOeoriStr",id)) q:id=""  d
	..s mulOeoriStr=TMPSumItem("MulOeoriStr",id)
	..s retStr=..InsertOrderItem(EpisodeID,mulOeoriStr,userId,locId)*/	
	q ret
}

ClassMethod InsertOrderItemP5(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String = "") As %String
{
   //s a=##class(web.DHCNurHdDocOrdItem).InsertOrderItem()
  // s ^TMP("doc")=$LB(Adm,OrdItemStr, User, Loc, Doc)
    //s Adm=$list(^TMP("ord1"),1)
	//s User=$list(^TMP("ord1"),2)
	//s Loc=$list(^TMP("ord1"),3)
	//s Doc=$list(^TMP("ord1"),4)
	//s OrdItemStr="6^"
	if Doc="" s Doc=$p(^SSU("SSUSR",User),"^",14) //SSUSR_CareProv_DR
    q:Doc="" "不是医生!"
    b ;p5 insert
    s ^TMPzt("InsertOrderItemP5")=Adm_"/"_OrdItemStr_"/"_User_"/"_Loc_"/"_Doc
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	s ^TMP("ord")=OrdItemStr
	s ^TMP("ord1")=$LB(Adm,User,Loc,Doc)
	//s ^TMPQSE=MEDDATA_"^"_LABDATA
	ZN MEDDATA	
	b //                              // Adm,OrdItemStr,User,Loc,LABDATA,DocUserId
	Set Ret=$$INSERTMultiple^DHCOrdItem(Adm,OrdItemStr,User,Loc,LABDATA,User)
	ZN CurrentNS
	QUIT Ret
}

ClassMethod InsertOrderItem(EpisodeID, mulOeoriStr, userId, locId) As %String
{
	//EpisodeID就诊号, userId用户Id, locId登录科室Id, 
	//mulOeoriStr由$c(3)分割：arcimId医嘱码Id, startDate开始日期, startTime开始时间,recDepId接收科室,
	//doseQty单次剂量,doseQtySum数量, doseUomId等效剂量单位, instrId用法, seqNo序号, masterSeqNo主医嘱序号,oeoriPrice价格,医嘱备注depProcNotes
	//其中seqNo序号取自然序号，不是插入后的序号。masterSeqNo值取主医嘱的seqNo序号
	//返回以"^"分割的第一部分为0未成功,错误信息为第二部分。成功则返回类于"1576||1*924106||331*V^1402||1*924106||332*V^"的串
	
	//w ##class(web.DHCBPOrder).InsertOrderItem(502,"",646,291)
	//s mulOeoriStr="1576||1"_$c(3)_"2009-7-17"_$c(3)_"18:00"_$c(3)_640_$c(3)_250_$c(3)_250_$c(3)_619_$c(3)_12_$c(3)_1_$c(3)_""
	//s mulOeoriStr=mulOeoriStr_"^1402||1"_$c(3)_"2009-7-17"_$c(3)_"18:00"_$c(3)_640_$c(3)_160_$c(3)_160_$c(3)_619_$c(3)_12_$c(3)_2_$c(3)_"1"
	
	//freqId会不会有变
	b ;insert in
	s ^TMPzt("summuloeoristr")=mulOeoriStr
	q:(EpisodeID="")!(mulOeoriStr="")!(userId="")!(locId="") "0^输入数据有误!"
	b ;0
	s LABDATA="LABDATA"
	s docId=$p($g(^SSU("SSUSR",userId)),"^",14)
	b ;1
	q:docId="" "0^请使用医护人员身份登录!"
	
	s orderType="",packQty="",oeprice=0,drugFormId="",depProcNotes="",phPrescType=""
	s masterSeqNo="",skinTest="N",phSpecInstr="",orderCoverMainIns="Y",actionId="",arcosId=""
	
	s admReasonId=$p(^PAADM(EpisodeID,1),"^",7)
	b ;2
	s defDurId=0
	s phcduId=0
	f  s phcduId=$o(^PHCDU(phcduId)) q:(phcduId="")!(defDurId>0)  d
		.q:$p(^PHCDU(phcduId),"^",2)'=1
		.s defDurId=phcduId
	q:defDurId=0 "没有疗程为1天的数据,请维护!" 
	s defFreqId=0,phcfrId=0,isFind=0
	f  s phcfrId=$o(^PHCFR(phcfrId)) q:(phcfrId="")!(isFind)  d
		.q:$p(^PHCFR(phcfrId),"^",2)'=1		
		.//q:'$d(^PHCFR(phcfrId,"DT",1)) //edit mfc 20201123 频次区分节点了
		.q:$p($g(^PHCFR(phcfrId,"DT",1)),"^",1)=""
		.s defFreqId=phcfrId
		.i $p($g(^PHCFR(phcfrId,"DT",1)),"^",1)=28800 s isFind=1
	//i $o(^PHCFR(0,"Code","QD",""))'="" s defFreqId=$o(^PHCFR(0,"Code","QD",""))
	q:defFreqId=0 "没有频次为1数据,请维护!"
	s priorId=$o(^OECPR(0,"Code","NORM",""))   //优先级
	q:+priorId=0 "没有临时医嘱优先级数据,请维护!"
	
	/*s Config=##Class(websys.Configuration).%OpenId(1)
	s MEDDATA=Config.DataNamespace
	s CurrentNS=$ZNSPACE
	zn MEDDATA     //转换命名空间
	*/
	b ;first
	s retStr=0
	s oeoriStr=""
	f i=1:1:$l(mulOeoriStr,"^") d
		.s singleOeoriStr=$p(mulOeoriStr,"^",i)
		.s arcimId=$p(singleOeoriStr,$c(3),1)
		.i '$d(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)) s retStr="医嘱码"_arcimId_"不对!" q
		.s startDate=$p(singleOeoriStr,$c(3),2)
		.s startTime=$p(singleOeoriStr,$c(3),3)
		.s recLocId=$p(singleOeoriStr,$c(3),4)
		.i '$d(^CTLOC(recLocId)) s recLocId=""
		.i recLocId="" d
			..s recLocStr=..GetRecLoc(EpisodeID,arcimId)
			..s recLocId=$p(recLocStr,$c(3),1)
		.;i recLocId="" s recLocId=locId
		.i locId'="" s recLocId=locId
		.s doseQty=$p(singleOeoriStr,$c(3),5)
		.s doseQtySum=+$p(singleOeoriStr,$c(3),6)
		.s packQty=+$p(singleOeoriStr,$c(3),6)
		.s doseUomId=$p(singleOeoriStr,$c(3),7)
		.s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
		.i phcdfId>0 s doseQtySum=##class(web.DHCDocOrderEntry).CalDose(doseUomId,phcdfId,doseQty)
		.i doseQtySum>$p(doseQtySum,".") s doseQtySum=$p(doseQtySum,".")+1
		.s instrId=$p(singleOeoriStr,$c(3),8)
		.s freqId=defFreqId
		.s durId=defDurId
		.s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
		.i phcdfId=-1 s phcdfId=""
		.i phcdfId="" s freqId="",durId=""
		.s seqNo=$p(singleOeoriStr,$c(3),9)
		.s masterSeqNo=$p(singleOeoriStr,$c(3),10)
		.s oeprice=$p(singleOeoriStr,$c(3),11) //ypz 110316
		.s depProcNotes=$p(singleOeoriStr,$c(3),12)
		.;s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
		.;s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
		.i startDate="" s startDate=+$h
		.i $l(startDate,"-")>2 s startDate=$zdh(startDate,3)
		.s startDate=$zd(startDate,4)
		.
		.i startTime="" s startTime=$p($h,",",2)
		.i oeoriStr'="" s oeoriStr=oeoriStr_$c(1)
		.b ;begain invoke
		.s oeoriStr=oeoriStr_arcimId_"^"_orderType_"^"_priorId_"^"_startDate_"^"_startTime_"^"_packQty_"^"_oeprice_"^"_recLocId_"^"_admReasonId_"^"_drugFormId
		.s oeoriStr=oeoriStr_"^"_depProcNotes_"^"_doseQty_"^"_doseUomId_"^"_doseQtySum_"^"_freqId_"^"_durId_"^"_instrId_"^"_phPrescType_"^"_masterSeqNo_"^"_seqNo
		.s oeoriStr=oeoriStr_"^"_skinTest_"^"_phSpecInstr_"^"_orderCoverMainIns_"^"_actionId_"^"_arcosId_"^^^^^"
		.s oeoriStr=oeoriStr_"^^^^^^^"
	//s ^TMPCLInsertOrd($j)=1
	//s retStr=##class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID, oeoriStr, userId, locId, docId)
	///
	////s retStr=##class(appcom.OEOrdItem).InsertMulti(EpisodeID, oeoriStr, userId, locId, docId)
	b ;
	//s retStr=..InsertOrderItemP5(EpisodeID, oeoriStr, userId, locId, docId)
	b ;final
	i $p(retStr,"^",1)=-1 s $p(retStr,"^",1,2)=$p(retStr,"^",2)
	q retStr
}

ClassMethod GetRecLocId(EpisodeID, arcimId) As %String
{
  s recLocId=""
  s recLocStr=..GetRecLoc(EpisodeID, arcimId)
  s recLocId=$p(recLocStr,$c(3),1)
  q recLocId
}

ClassMethod GetRecLoc(EpisodeID, arcimId) As %String
{
	s retStr=""
	s recLocStrList=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,arcimId)
	//s recLocStrList=1_$c(1)_"A科"_$c(1)_"N"_$c(2)_2_$c(1)_"B科"_$c(1)_"Y"
	f j=1:1:$l(recLocStrList,$c(2)) d
		.s recLocStr=$p(recLocStrList,$c(2),j)
		.q:$p(recLocStr,$c(1),3)'="Y"
		.s retStr=$tr(recLocStr,$c(1),$c(3))
	q retStr
}

// d ##class(%ResultSet).RunQuery("web.DHCBPOrder","GetArcimList","","葡萄糖酸钙片[0.5g*100片]")

Query GetArcimList(needItemCatId As %String, needArcimDesc As %String, arcimIdStr As %String = "") As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod GetArcimListExecute(ByRef qHandle As %Binary, needItemCatId As %String = "", needArcimDesc As %String = "", arcimIdStr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i (needItemCatId="")&&(needArcimDesc="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    i (needArcimDesc'="")
    {
	 s oriNeedArcimDesc=needArcimDesc
     s needArcimDesc=$$ALPHAUP^SSUTIL4(needArcimDesc)
    }
 	s arcimSub=0 
 	f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
	.s arcimVer=0 f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:arcimVer=""  d
	..s arcimId=arcimSub_"||"_arcimVer
	..q:(arcimIdStr'="")&&(arcimId'=arcimIdStr)
	..s effDateTo=$p($g(^ARCIM(arcimSub,arcimVer,7)),"^",1) //add mfc 20201119
	..q:(effDateTo'="")&&(effDateTo<+$h)
	..s aliasId="",aliasDesc=""
	..f  s aliasId=$O(^ARC("ALIAS",0,"ARCIM",arcimId,aliasId)) q:aliasId=""  d
	    ...i aliasDesc'="" s aliasDesc=aliasDesc_"^"
	    ...s aliasDesc=aliasDesc_$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..q:aliasDesc=""
	..//s aliasDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	..q:(needArcimDesc'="")&(("^"_aliasDesc_"^")'[("^"_needArcimDesc))&(arcimDesc'[oriNeedArcimDesc)
	..s itemcatDR=$p(^ARCIM(arcimSub,arcimVer,1),"^",10)
	..i (+needItemCatId=0)!(+needItemCatId=itemcatDR) d OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(arcimDesc,arcimId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetArcimListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcimListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetArcimListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcimListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCBPOrder","GetBPOrderStatistics","2014-07-14","2014-07-20","40000892","","","","Statistics")

Query GetBPOrderStatistics(fromDate As %String, toDate As %String, regNo As %String = "", needBpoiStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", statisticsType As %String) As %Query(ROWSPEC = "Id,RegNo,PatName,Medicare,ArcimDesc,Dose,DoseUnitDesc,PackQty,PackUnitDesc,FreqDesc,InstructDesc,MasterSeqNo,SeqNo,RecLocDesc,StatisticalQuantity,StatisticalAmount,Price,AdSQty,AdsPrice")
{
}

ClassMethod GetBPOrderStatisticsExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", needBpoiStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", statisticsType As %String) As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k TMPDetailItem
	k TMPSumItem
	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)	
	s EpisodeIDList=""
	i regNo'="" s EpisodeIDList=##class(web.DHCBPCom).GetPatientEpisodeID(regNo,"",fromDate,toDate)
	s papmiIdList=""
	s bpprIdList=""
	i regNo'="" s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	i papmiIdList="",papmiMedicare'="" d
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
		.s papmiIdList=$o(^PAPERi("Medicare1",papmiMedicare,""))
	i papmiIdList="",papmiName'="" d
		.s papmiName=$$ALPHAUP^SSUTIL4(papmiName)
		.s papmiId=""
		.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiName,papmiId)) q:papmiId=""  d
			..i papmiIdList'="" s papmiIdList=papmiIdList_"^"
			..s papmiIdList=papmiIdList_papmiId
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") s isLocQuery=0
	e  s isLocQuery=1
	i papmiIdList'="" d
		.f i=1:1:$l(papmiIdList,"^") d
			..s papmiId=$p(papmiIdList,"^",i)
			..q:papmiId=""
			..q:'$d(^PAPER(papmiId,"PAT",1))
			..s bpprId=""
			..f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:bpprId=""  d
			...q:bpprId=""
			...d GetBPOrderStatistics()
    d OutputSummary()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetBPOrderStatistics()
   
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //病案号 20200515统一走病案接口
	s admId=$lg($g(^DHCBPPatRegister(bpprId)),26) //透析登记时病人就诊ID
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	f curDate=fromDate:1:toDate d
	.s bpoiId=""
	.f  s bpoiId=$o(^DHCBPOrderItem(0,"DateRegister",curDate,bpprId,bpoiId)) q:bpoiId=""  d	
	..s bpopBPPatRegisterDr=$li(^DHCBPOrderItem(bpoiId),1)
	..s bpoiBPArrangeDr=$li(^DHCBPOrderItem(bpoiId),2)
	..s bpoiOrderTypeCode=$li(^DHCBPOrderItem(bpoiId),3)
	..q:bpoiOrderTypeCode'="N"
	..s bpoiStatus=$li(^DHCBPOrderItem(bpoiId),13)
    ..;q:bpoiStatus'="E"
	..s bpoiArcimDr=$li(^DHCBPOrderItem(bpoiId),4)
	..s arcimSub=$p(bpoiArcimDr,"||",1)
	..s arcimVer=$p(bpoiArcimDr,"||",2)
	..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	..s bpoiDose=$li(^DHCBPOrderItem(bpoiId),5)
	..s bpoiDoseUnitDr=$li(^DHCBPOrderItem(bpoiId),6)
	..s bpoiDoseUnitDesc=""
	..i bpoiDoseUnitDr'="" d
	...s bpoiDoseUnitDesc=$ZCVT($p($g(^CT("UOM",+bpoiDoseUnitDr)),"^",2),"l")
	..s bpoiPackQty=$li(^DHCBPOrderItem(bpoiId),7)
	..;b ;bpoiPackQty
	..i bpoiPackQty'="" s num=+bpoiPackQty
	..e  s num=0
	..s patType="",insType=""
	..i (bpoiBPArrangeDr'="")&($d(^DHCBPArrange(bpoiBPArrangeDr))) d
	
	...s EpisodeID=$lg(^DHCBPArrange(bpoiBPArrangeDr),1)
	...i EpisodeID'="" d
	....s patType=$p(^PAADM(EpisodeID,1),"^",6)
    ....s insType=$p(^PAADM(EpisodeID,1),"^",7)
    ..s unitPrice=+##class(web.UDHCJFPRICE).GetOrderPrice(patType,insType,bpoiArcimDr,+$h,"","","","")
	..i $d(TMPSumItem(bpoiArcimDr,"Count")) s TMPSumItem(bpoiArcimDr,"Count")=$g(TMPSumItem(bpoiArcimDr,"Count"))+num
	..e  s TMPSumItem(bpoiArcimDr,"Count")=num
	..i $d(TMPSumItem(bpoiArcimDr,"Sum")) s TMPSumItem(bpoiArcimDr,"Sum")=$g(TMPSumItem(bpoiArcimDr,"Sum"))+(num*unitPrice)
	..e  s TMPSumItem(bpoiArcimDr,"Sum")=num*unitPrice
	..s bpoiPackUnitDr=$li(^DHCBPOrderItem(bpoiId),8)
	..s bpoiPackUnitDesc=""
	..i bpoiPackUnitDr'="" d
	...s bpoiPackUnitDesc=$ZCVT($p($g(^CT("UOM",+bpoiPackUnitDr)),"^",2),"l")
	..s bpoiFreqDr=$li(^DHCBPOrderItem(bpoiId),9)
	..s bpoiFreqDesc=""
	..i bpoiFreqDr'="" d
	...s bpoiFreqDesc=$p($g(^PHCFR(bpoiFreqDr)),"^",3)
	..s bpoiInstructDr=$li(^DHCBPOrderItem(bpoiId),10)
	..s bpoiInstructDesc=""
	..i bpoiInstructDr'="" d
	...s bpoiInstructDesc=$p($g(^PHCIN(bpoiInstructDr)),"^",2)
	..s bpoiMasterSeqNo=$li(^DHCBPOrderItem(bpoiId),15)
	..i bpoiMasterSeqNo=""  s bpoiMasterSeqNo=0
	..s bpoiSeqNo=$li(^DHCBPOrderItem(bpoiId),16)
	..i bpoiSeqNo="" s bpoiSeqNo=0
	..s bpoiRecLocDr=$li(^DHCBPOrderItem(bpoiId),17)
	..s bpoiRecLocDesc=""
	..i bpoiRecLocDr'="" d
	...s bpoiRecLocDesc=$P($g(^CTLOC(bpoiRecLocDr)),"^",2) 
	..s bpoiDurationDr=$li(^DHCBPOrderItem(bpoiId),18) 
	..s bpoiOrderItemDr=$li(^DHCBPOrderItem(bpoiId),19)
	..i statisticsType="Detail"  d
	...s TMPDetailItem(bpoiId,bpoiMasterSeqNo,bpoiSeqNo)=$lb(bpoiId,regNo,patName,papmiMedicare,arcimDesc,bpoiDose,bpoiDoseUnitDesc,bpoiPackQty,bpoiPackUnitDesc,bpoiFreqDesc,bpoiInstructDesc,bpoiMasterSeqNo,bpoiSeqNo,bpoiRecLocDesc,bpoiPackQty,num*unitPrice,unitPrice)
	..i statisticsType="Statistics" d
	...s TMPSumItem(bpoiArcimDr)=$lb(bpoiId,regNo,patName,papmiMedicare,arcimDesc,bpoiDose,bpoiDoseUnitDesc,bpoiPackQty,bpoiPackUnitDesc,bpoiFreqDesc,bpoiInstructDesc,bpoiMasterSeqNo,bpoiSeqNo,bpoiRecLocDesc,$g(TMPSumItem(bpoiArcimDr,"Count")),$g(TMPSumItem(bpoiArcimDr,"Sum")),unitPrice)

OutputSummary()
	i statisticsType="Detail"  d
	.b ;"Detail"
	.s id=""  f  s id=$o(TMPDetailItem(id)) q:id=""  d
	..s masterSeqNo=""  f  s masterSeqNo=$o(TMPDetailItem(id,masterSeqNo)) q:masterSeqNo=""  d
	...s seqNo=""  f  s seqNo=$o(TMPDetailItem(id,masterSeqNo,seqNo)) q:seqNo=""  d
	....s item=TMPDetailItem(id,masterSeqNo,seqNo)
	....s item=item_$lb("","")
	....d OutputRow
	i statisticsType="Statistics"  d
	.s id="" f  s id=$O(TMPSumItem(id)) q:id=""  d
	..s adSQty=0,adSPrice=0
	..f n=1:1:$l(EpisodeIDList,"^") d
    ...s adm=$p(EpisodeIDList,"^",n)
    ...q:adm=""
    ...s patType=$p(^PAADM(adm,1),"^",6)
    ...s insType=$p(^PAADM(adm,1),"^",7)
    ...s unitPrice=+##class(web.UDHCJFPRICE).GetOrderPrice(patType,insType,id,+$h,"","","","")
    ...s oeordId=""
    ...s oeordId=$o(^OEORD(0,"Adm",adm,oeordId)) q:oeordId=""  d
    ....s sttDat=""
    ....s sttDat=$o(^OEORDi(0,"ARCIM",oeordId,id,sttDat)) q:sttDat=""  d
    .....b ;"arcim"
    .....s sub=""
    .....s sub=$o(^OEORDi(0,"ARCIM",oeordId,id,sttDat,sub)) q:sub=""  d
    ......s qty=$p(^OEORD(oeordId,"I",sub,1),"^",12)
    ......b ;"qty"
    ......s price=unitPrice*qty
    ......s adSPrice=adSPrice+price
    ......s adSQty=adSQty+qty
   	..s item=TMPSumItem(id)_$lb(adSQty,adSPrice)
	..d OutputRow	    	
	q 0
OutputRow
	set Data=item
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBPOrderStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBPOrderStatisticsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBPOrderStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBPOrderStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// D ##class(%ResultSet).RunQuery("web.DHCBPOrder","GetConsumableStatistics","2014-04-28","2014-04-28")

Query GetConsumableStatistics(fromDate As %String, toDate As %String, regNo As %String = "", isInject As %String = "", arcimDr As %String = "", papmiMedicare As %String = "", papmiName As %String = "") As %Query(ROWSPEC = "StartDate,DayPart,BedDesc,PatName,RegNo,ArcimId,ArcimDesc,StatisticalQuantity:%String")
{
}

ClassMethod GetConsumableStatisticsExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", isInject As %String = "", arcimDr As %String = "", papmiMedicare As %String = "", papmiName As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)	
	
	s EpisodeIDList=""
	i regNo'="" s EpisodeIDList=##class(web.DHCANOPCom).GetPatientEpisodeID(regNo,"")
	s papmiIdList=""
	s bpprIdList=""
	i regNo'="" s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	i papmiIdList="",papmiMedicare'="" d
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
		.s papmiIdList=$o(^PAPERi("Medicare1",papmiMedicare,""))
	i papmiIdList="",papmiName'="" d
		.s papmiName=$$ALPHAUP^SSUTIL4(papmiName)
		.s papmiId=""
		.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiName,papmiId)) q:papmiId=""  d
			..i papmiIdList'="" s papmiIdList=papmiIdList_"^"
			..s papmiIdList=papmiIdList_papmiId
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") s isLocQuery=0
	e  s isLocQuery=1
	//w papmiIdList,!
	i papmiIdList'="" d
		.f i=1:1:$l(papmiIdList,"^") d
			..s papmiId=$p(papmiIdList,"^",i)
			..q:papmiId=""
			..s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,""))
			..q:bpprId=""
			..s bpaId=""
			..f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId)) q:bpaId=""  d
			...q:$$GetStatistics()<0
	s arcimId="" 
	f  s arcimId=$O(TMPBPStastics("Output",arcimId)) q:arcimId=""  d
	.s papmiId=""
	.s item0=TMPBPStastics("Output",arcimId)
	.d OutputRowArcim
	.s sum=TMPBPStastics("Count",arcimId)
	.f  s papmiId=$O(TMPBPStastics("Output",arcimId,papmiId)) q:papmiId=""  d
	..s bpaId=""
	..f  s bpaId=$O(TMPBPStastics("Output",arcimId,papmiId,bpaId)) q:bpaId=""  d
	...s item=TMPBPStastics("Output",arcimId,papmiId,bpaId)
	...d OutputRowPatSum
	.s item1=$lb("","","","","","","汇总",sum)
	.d OutputRowSum	
	
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	
	
	s bpaId=""	
	f curDate=fromDate:1:toDate d
	.s bpaId=""
	.f  s bpaId=$o(^DHCBPArrange(0,"Date",curDate,bpaId)) q:bpaId=""  d
	..q:$$GetStatistics()<0
	
	
	s arcimId="" 
	f  s arcimId=$O(TMPBPStastics("Output",arcimId)) q:arcimId=""  d
	.s papmiId=""
	.s item0=TMPBPStastics("Output",arcimId)
	.d OutputRowArcim
	.s sum=TMPBPStastics("Count",arcimId)
	.f  s papmiId=$O(TMPBPStastics("Output",arcimId,papmiId)) q:papmiId=""  d
	..s bpaId=""
	..f  s bpaId=$O(TMPBPStastics("Output",arcimId,papmiId,bpaId)) q:bpaId=""  d
	...s item=TMPBPStastics("Output",arcimId,papmiId,bpaId)
	...d OutputRowPatSum
	.s item1=$lb("","","","","","","汇总",sum)
	.d OutputRowSum	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetStatistics()
	q:bpaId="" -1
	s admId=$lg(^DHCBPArrange(bpaId),1)	
	s bpprId=$lg(^DHCBPArrange(bpaId),2)
	i admId="" s admId=$lg($g(^DHCBPPatRegister(+bpprId)),26)
	s bpaDaySeqNo="",dayPart=""
	s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)
	i bpaDaySeqNo="A" s dayPart="上午"	
	i bpaDaySeqNo="P" s dayPart="下午"
	i bpaDaySeqNo="E" s dayPart="晚上"
	s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)
	s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)	
    q:bpprId="" -2    
	s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
	s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
	q:papmiId="" -3
	q:'$d(^PAPER(papmiId,"PAT",1)) -4
	s patRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	//s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //20200515统一走病案接口
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s papmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s bpaDate=$lg(^DHCBPArrange(bpaId),4)
	s bpaTime=$lg(^DHCBPArrange(bpaId),5)
	q:(bpaDate'="")&(bpaDate>toDate) -11
	q:(bpaDate'="")&(bpaDate<fromDate) -12
	s bpaDate=##class(web.DHCANOPCom).ConvertToDate(bpaDate)
	s patAge=##class(web.DHCClinicCom).CalAge(patBirth,bpaDate)
	s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
	q:bpaStatus="" -5
	;q:(needBpaStatus'="")&&(needBpaStatus'[bpaStatus) -6
	q:bpaStatus="D" -7
	
	s bpaBPCConsumableDr=$lg(^DHCBPArrange(bpaId),29)
	s bpaBPCConsumableDesc=$lg($g(^DHCBPC("Consumable",+bpaBPCConsumableDr)),2)
	s firstArcimDr=$lg($g(^DHCBPC("Consumable",+bpaBPCConsumableDr)),6)
	s bpaSecondBPCConsumableDr=$lg(^DHCBPArrange(bpaId),30)
	s bpaSecondBPCConsumableDesc=$lg($g(^DHCBPC("Consumable",+bpaSecondBPCConsumableDr)),2)
	s secondArcimDr=$lg($g(^DHCBPC("Consumable",+bpaSecondBPCConsumableDr)),6)
	s bpaThirdBPCConsumableDr=$lg(^DHCBPArrange(bpaId),31)
	s bpaThirdBPCConsumableDesc=$lg($g(^DHCBPC("Consumable",+bpaSecondBPCConsumableDr)),2)
	s thirdArcimDr=$lg($g(^DHCBPC("Consumable",+bpaThirdBPCConsumableDr)),6)
	s bpaOralHematin=$lg(^DHCBPArrange(bpaId),36)
	s bpaInjecHeparin=$lg(^DHCBPArrange(bpaId),37)	
	s bpoiId=""
	f  s bpoiId=$o(^DHCBPOrderItem(0,"Arrange",bpaId,bpoiId)) q:bpoiId=""  d
	.s bpoiArcimDr=$li(^DHCBPOrderItem(bpoiId),4)
	.q:(arcimDr'="")&&(bpoiArcimDr'=arcimDr)
	.s arcimSub=$p(bpoiArcimDr,"||",1)
	.s arcimVer=$p(bpoiArcimDr,"||",2)
	.s bpoiArcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	.i (bpoiArcimDesc=bpaOralHematin)!(bpoiArcimDesc=bpaInjecHeparin) d
	..s bpoiPackQty=$li(^DHCBPOrderItem(bpoiId),7)
	..i bpoiPackQty'="" d
	...i $d(TMPBPStastics("Count",bpoiArcimDr)) s TMPBPStastics("Count",bpoiArcimDr)=TMPBPStastics("Count",bpoiArcimDr)+bpoiPackQty
	...e  s TMPBPStastics("Count",bpoiArcimDr)=bpoiPackQty
	...;i $d(TMPBPStastics("Count",bpoiArcimDr,papmiId)) s TMPBPStastics("Count",bpoiArcimDr,papmiId)=TMPBPStastics("Count",bpoiArcimDr,papmiId)+bpoiPackQty
	...;e  s TMPBPStastics("Count",bpoiArcimDr,papmiId)=bpoiPackQty
	...i $d(TMPBPStastics("Count",bpoiArcimDr,papmiId,bpaId)) s TMPBPStastics("Count",bpoiArcimDr,papmiId,bpaId)=TMPBPStastics("Count",bpoiArcimDr,papmiId,bpaId)+bpoiPackQty
	...e  s TMPBPStastics("Count",bpoiArcimDr,papmiId,bpaId)=bpoiPackQty
	
	...s TMPBPStastics("Output",bpoiArcimDr)=$lb("","","","","",bpoiArcimDr,bpoiArcimDesc,"")
	...s TMPBPStastics("Output",bpoiArcimDr,papmiId,bpaId)=$lb(bpaDate,dayPart,bpaBPCBedDesc,patName,patRegNo,bpoiArcimDr,"",TMPBPStastics("Count",bpoiArcimDr,papmiId,bpaId))     
	.q:isInject="Y" 
	.i (bpoiArcimDr=firstArcimDr)!(bpoiArcimDr=secondArcimDr)!(bpoiArcimDr=thirdArcimDr) d
	..s bpoiPackQty=$li(^DHCBPOrderItem(bpoiId),7)
	..i bpoiPackQty'="" d
	...i $d(TMPBPStastics("Count",bpoiArcimDr)) s TMPBPStastics("Count",bpoiArcimDr)=TMPBPStastics("Count",bpoiArcimDr)+bpoiPackQty
	...e  s TMPBPStastics("Count",bpoiArcimDr)=bpoiPackQty
	...;i $d(TMPBPStastics("Count",bpoiArcimDr,papmiId)) s TMPBPStastics("Count",bpoiArcimDr,papmiId)=TMPBPStastics("Count",bpoiArcimDr,papmiId)+bpoiPackQty
	...;e  s TMPBPStastics("Count",bpoiArcimDr,papmiId)=bpoiPackQty
	...i $d(TMPBPStastics("Count",bpoiArcimDr,papmiId,bpaId)) s TMPBPStastics("Count",bpoiArcimDr,papmiId,bpaId)=TMPBPStastics("Count",bpoiArcimDr,papmiId,bpaId)+bpoiPackQty
	...e  s TMPBPStastics("Count",bpoiArcimDr,papmiId,bpaId)=bpoiPackQty
	...s TMPBPStastics("Output",bpoiArcimDr)=$lb("","","","","",bpoiArcimDr,bpoiArcimDesc,"")
	...s TMPBPStastics("Output",bpoiArcimDr,papmiId,bpaId)=$lb(bpaDate,dayPart,bpaBPCBedDesc,patName,patRegNo,bpoiArcimDr,"",TMPBPStastics("Count",bpoiArcimDr,papmiId,bpaId))  
	q 0
OutputRowArcim
	set Data=item0
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
OutputRowPatSum           
	set Data=item
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
OutputRowSum
	set Data=item1
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetConsumableStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsumableStatisticsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetConsumableStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsumableStatisticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2014-03-12
/// Description： 	根据拼音码或名称字符串查找医嘱项
/// Table：        	
/// Input:			filterDesc：医嘱项名称或别名过滤字符串，groupId：用户安全组ID，ctLocId：用户登录位置ID，bpaId：透析记录ID, userId: 用户ID
/// Return：       	ResultSet
/// Edit:  			20200422 mfc 接口调整，需要入参ctLocId和userId
/// d ##class(%ResultSet).RunQuery("web.DHCBPOrder","FindArcim","amxl","170","","")
Query FindArcim(filterDesc As %String, groupId As %String, ctLocId As %String, bpaId As %String, userId As %String) As %Query(ROWSPEC = "Id,Code,Description,Alias,ItemType,ItemCatId,EqualUomIdInfo,DefaultDoseInfo,BaseUomId,EqualQtyInfo,Volume,DefaultFreqId,DefaultInstrId,Price,DefaultRecvLoc") [ SqlProc ]
{
}

ClassMethod FindArcimExecute(ByRef qHandle As %Binary, filterDesc As %String, groupId As %String, ctLocId As %String, bpaId As %String, userId As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s resultSet=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d resultSet.Execute(filterDesc,groupId,"","","","","","","","",userId,"","",ctLocId,"","")
	while(resultSet.Next())
	{
		s arcimType=resultSet.GetData(4)
		continue:(arcimType'="ARCIM")
		s arcimId=resultSet.GetData(2)
		s arcimCode=resultSet.GetData(29)
		s arcimAlias=resultSet.GetData(5)
		s arcimMainId=+arcimId,arcimVersion=+$p(arcimId,"||",2)
		s arcimDesc=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",2)
		s itemCatId=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",10)
		s equalUomInfo=..GetEqUomQty(arcimId)
		s equalUomIdInfo=$p(equalUomInfo,"^",1)
		s defaultDoseInfo=$p(equalUomInfo,"^",2)
		s baseUomId=$p(equalUomInfo,"^",3)
		s equalQtyInfo=$p(equalUomInfo,"^",4)
		s volume=$p(equalUomInfo,"^",5)
		s defaultInstrId=""
		s instrId=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",12)
		s instrMainId=+instrId,instrSubId=+$p(instrId,"||",2)
		i (instrSubId'="")
		{
			s defaultInstrId=+$p($g(^PHCD(instrMainId,"DF",instrSubId,1)),"^",5)	
		}
		s freqId=$o(^PHCFR(0,"Code","1ONCE",""))
		s itemPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,+$h,"","","","")
		s defaultRecvLoc=""
		s defaultRecvLoc=..GetOrderItemRecloc(bpaId,arcimId,"",ctLocId)
		s defaultRecvLoc=$tr(defaultRecvLoc,"^","#")
		d OutputRow
	}
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(arcimId,arcimCode,arcimDesc,arcimAlias,arcimType,itemCatId,equalUomIdInfo,defaultDoseInfo,baseUomId,equalQtyInfo,volume,freqId,defaultInstrId,itemPrice,defaultRecvLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 返回：第一级^分割的接收科室串，第二级以#c(3)分割为科室Id，科室名
ClassMethod GetOrderItemRecloc(bpaId As %String, arcimId As %String, EpisodeID As %String = "", recLocId = "") As %String
{
	//web.DHCDocOrderCommon.GetLocRecLoc
	q:arcimId="" -3
	i EpisodeID="",bpaId'="" d
	.s bpprId=$lg(^DHCBPArrange(bpaId),1)
	.s EpisodeID=+$lg(^DHCBPPatRegister(bpprId),26)
	//q:(+EpisodeID=0) -2
	s Config=##Class(websys.Configuration).%OpenId(1)
	s MEDDATA=Config.DataNamespace
	s LABDATA=Config.LabDataNamespace
	s CurrentNS=$ZNSPACE
	zn MEDDATA
	s retStr=$$getall^aOET3a(EpisodeID,arcimId,recLocId)
	i retStr'="0" k PLIST //w "kill",!
	s retStr=""
	s inum=0
	f  s inum=$o(PLIST(inum))  q:inum=""  d
		.//w PLIST(inum)," /"_$p(PLIST(inum),$c(2),3),!
		.q:$p(PLIST(inum),$c(2),3)'="Y"
		.s PLIST(inum)=$tr(PLIST(inum),$c(2),$c(3))
		.i retStr'="" s retStr=retStr_"^"
		.s retStr=retStr_PLIST(inum)
	zn CurrentNS
	q retStr
}

/// 返回：eqUomIdStr等效剂量单位_"^"_eqDefDoseStr医嘱缺省量_"^"_baseUomId基本单位_"^"_eqQtyStr转换系数：基本单位数量*eqQty=等效剂量单位数量_"^"_volume单位代码为"ML"的转换系数,无则为""
ClassMethod GetEqUomQty(arcimId) As %String
{
	s eqUomIdStr="",eqDefDoseStr=1,baseUomId="",eqQtyStr=1,volume=1,basePrice=0
	q:arcimId="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
	s basePrice=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,+$h,"","","","")
	s baseUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
	s eqUomIdStr=baseUomId
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	q:phcdfSub="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
	s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
	
	s volume=""
	s volUomId=$o(^CT("UOM",0,"Code","ML",""))
	s eqUomIdStr=baseUomId,eqQtyStr=1,eqDefDoseStr=1
	s eqId=0,haveData=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		.s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
		.s eqDefDose=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",3)
		.i eqQty=0 s eqQty=1
		.i $p(eqQty,".",1)="" s eqQty=0_eqQty
		.i $p(eqDefDose,".",1)="" s eqDefDose=0_eqDefDose
		.//i eqDefDose<1 s eqDefDose=eqQty
		.//i eqDefDose<1 s eqDefDose=1
		.q:(eqUomId="")!(eqQty=0)
		.i +eqDefDose=0 s eqDefDose=eqQty
		.i 'haveData s eqUomIdStr="",eqQtyStr="",eqDefDoseStr=""
		.
		.i eqUomIdStr'="" s eqUomIdStr=eqUomIdStr_"|",eqQtyStr=eqQtyStr_"|",eqDefDoseStr=eqDefDoseStr_"|"
		.s eqUomIdStr=eqUomIdStr_eqUomId,eqQtyStr=eqQtyStr_eqQty,eqDefDoseStr=eqDefDoseStr_eqDefDose
		.i volUomId=eqUomId d
		    ..s volume=eqQty
		    ..i +volume=0 s volume=1
		.s haveData=1
	q eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume_"^"_basePrice
}

/// 获取医嘱频率，根据描述和病人类型 zhangtao
Query GetFrequencyList(desc As %Library.String, admType As %Library.String = "") As %Library.Query(CONTAINID = 3, ROWSPEC = "ID,Code,Desc")
{
}

ClassMethod GetFrequencyListExecute(ByRef qHandle As %Library.Binary, desc As %Library.String, admType As %Library.String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//i (desc="")&(admType="O") d
	//.s desc="O"	
	s resultSet=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpFrequency")
	d resultSet.Execute(desc,admType,"","")
	while(resultSet.Next())
	{
		s days=resultSet.GetData(4)
		s id=resultSet.GetData(5)
		s code=resultSet.GetData(2)
		s desc=resultSet.GetData(1)
		q:id=""
		d OutputFreq
	}
	d resultSet.Close()
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputFreq
	set Data=$lb(id,code,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetFrequencyListFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = GetFrequencyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetFrequencyListClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetFrequencyListFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query GetInstructList(desc As %String, admType As %String) As %Query(ROWSPEC = "Id:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetInstructListExecute(ByRef qHandle As %Binary, desc As %String, admType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;Set qHandle=$lb(0,repid,0)
 	s desc=$$ALPHAUP^SSUTIL4(desc)
 	Set obj=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpInstr")
	d obj.Execute(desc,admType)
	For  Quit:'obj.Next()  Do
	.s rowId=obj.Data("HIDDEN")
	.s desc1=obj.Data("Desc")
	.s code1=obj.Data("Code")
   	.Do OutputInstruct
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputInstruct
	set Data=$lb(rowId,code1,desc1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetInstructListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstructListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInstructListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstructListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCBPOrder","FindHisOrderItem","258","2022-01-01","2022-01-26","","N","92","0")

/// 取医生医嘱OE_OrdItem
/// 入参：ifDrug为"Y"查询药品，ifDrug为"N"查询治疗，治疗医嘱大类的ID定义在^DHCCLSet("ICU","TherapyCatId")中，为空查询全部
/// 	  ifStand"Y"查询长期医嘱，为"N"查询临时医嘱，为""查询全部。
///       ifNurExecuted为"Y"查询护士已执行医嘱，ifNurExecuted为"N"查询护士未执行医嘱，为空查询全部；
/// 临时医嘱: 按医嘱表时间判,不跨天; 当天的第一条返回医嘱时间(直接显示),其它的返回分发时间(提前半小时显示),一次只显示一条
/// 长期医嘱: 按执行表时间判,会跨天(提前半小时显示),一次只显示一条   
Query FindHisOrderItem(registerId, startDate = "", endDate = "", ifDrug = "Y", ifStand = "", ctLocId = "", ifQuit = "1") As %Query(ROWSPEC = "StartDate :%String,StartTime :%String,EndDate :%String,EndTime :%String,ArcimId :%String,ArcimDesc :%String,Dose:%String,UomId :%String,UnitDesc :%String,InstrId :%String,Instruction :%String,Priority :%String,FreqId :%String,FreqDesc :%String,OeoriNote :%String,Abbreviate :%String,OrderItemNote :%String,OrderItemStatus :%String,OrderItemSeqNo :%String,QtyOrd :%String,CreateDate :%String,CreateTime:%String")
{
}

ClassMethod FindHisOrderItemExecute(ByRef qHandle As %Binary, registerId, startDate = "", endDate = "", ifDrug = "Y", ifStand = "", ctLocId = "", ifQuit = "1") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	k ^TMPBP("Oeore",$j)
	i registerId="" s qHandle=$lb(0,repid,0) q $$$OK
	//i ..SetMainSubIcucriList(icuaId,.mainSubIcucriList)<0 s qHandle=$lb(0,repid,0) q $$$OK
    s papmiId=$lg(^DHCBPPatRegister(registerId),1)
 	s ctLocId=##Class(web.DHCBPCom).GetLinkAdmLocByLocId(ctLocId)
	s Config=##Class(websys.Configuration).%OpenId(1)
	s LABDATA=Config.LabDataNamespace
	s CurNamespace=$ZNSPACE

    s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
    s admId="",quit=0
    //s admtype=$lg(^DHCBPPatRegister(registerId),23)   
    f  s admId=$o(^PAPERdr(papmiId,"ADM","O",admId),-1) q:(admId="")!(quit)  d
    .;i papmiId=1744529  s admId=17573309
	.s admDeptId=$p($g(^PAADM(admId)),"^",4)
	.q:(ctLocId'="")&&(ctLocId'=admDeptId)
	.s admDate=$p($g(^PAADM(admId)),"^",6)
	.q:(startDate>admDate)!(endDate<admDate)
	.d GetOrder
	//s admId=2
	//d GetOrder
	s stDate="" 
	f  s stDate=$o(^TMPBP("Oeore",$j,stDate))  q:stDate=""  d
	.s oeoriSub="" 
	.f  s oeoriSub=$o(^TMPBP("Oeore",$j,stDate,oeoriSub))  q:oeoriSub=""  d
	..s Data=^TMPBP("Oeore",$j,stDate,oeoriSub)
	..d OutputRowHisOrder
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
GetOrder
   //查找医生所下医嘱
   s oeordId=$o(^OEORD(0,"Adm",admId,""))
   q:oeordId="" "" //未开过医嘱
   s fDate=startDate-1,tDate=endDate
   ;s fDate=62092
   f sttDate=fDate:1:tDate d
   .s oeoriSub=0
   .f  s oeoriSub=$o(^OEORDi(0,"StDt",sttDate,oeordId,oeoriSub)) q:(oeoriSub="")  d
   ..q:'$d(^OEORD(oeordId,"I",oeoriSub))
   ..s oeoriId=oeordId_"||"_oeoriSub
   ..s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
   ..q:(ordStatCode="U")!(ordStatCode="I")
   ..s oeoriXDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
   ..s oeoriXTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
   ..i oeoriXDate="" s oeoriXDate=99999
   ..s oeoriXDateTime=oeoriXDate+(oeoriXTime/100000)
   ..s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8) //长期医嘱，临时医嘱 etc.
   ..q:oecprId=""
   ..s oecprCode=$p(^OECPR(oecprId),"^",1)
   ..q:oecprCode=""
   ..q:((ordStatCode="D")!(ordStatCode="PD"))&((oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT"))
   ..s orcatId=##Class(web.DHCClinicCom).GetOrdCatId(oeoriId)
   ..q:orcatId=""
   ..s ocgrpId=$p($g(^OEC("ORCAT",orcatId)),"^",15) //OEC_OrderCategoryGroup
   ..s ocgrpCode=$p($g(^OEC("OCGRP",+ocgrpId)),"^",1)
   ..s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId) //医嘱分类类型，药品，饮食，静脉注射 等
   ..s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
   ..s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
   ..;医嘱序号
   ..s orderItemSeqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",4)
   ..;20130830+医嘱状态--
   ..s orderItemStatus=""
   ..s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
   ..s orderItemStatus=$p($g(^OEC("OSTAT",+ordStatId)),"^",2)
   ..s ordLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
   ..;q:(ordLocId'="")&(("^"_locIdStr_"^")'[("^"_ordLocId_"^"))
   ..;s arcsgId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",9)
   ..s phcfrFactor=1,phcfrCode=""
   ..s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
   ..i phcfrId'="" d 
   ...s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)
   ...s phcfrCode=$p(^PHCFR(phcfrId),"^",1)
   ..q:(phcfrCode="Ialways") //暂时写死
   ..q:"ONE^OUT"[oecprCode //取药医嘱和出院带药
   ..s isStandSort=2
   ..i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s isStandSort=1
   ..q:(ifStand="Y")&(oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT")
   ..q:(ifStand="N")&(ifStand'="Y")&((oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT"))
   ..s phcinId=+$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
   ..;q:(icuoType="D")&(phcinId'="")&(("^"_phcinStr_"^")[("^"_phcinId_"^"))
   ..s reportResult=""
   ..i ocgrpCode="EXAM" s reportResult=..GetRisReportResult(oeoriId)  //取检查结果
   ..i arcicOrderType="L" s reportResult=..GetLabReportResult(oeoriId,CurNamespace,LABDATA) //取检验结果
   ..s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
   ..s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
   ..s bpRecLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
   ..s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
   ..s unitUomId="",unitDesc=""
   ..//s oeoriAddUserId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
   ..//s eqUomQty=##class(web.DHCICUCom).GetEqUomQty(arcimId)
   ..i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
   ..i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
   ..s uomId=unitUomId
   ..i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
   ..s curQty=doseQty 
   ..s phcdtTimeList=""
   ..s phcdtId=0
   ..f  s phcdtId=$o(^PHCFR(+phcfrId,"DT",phcdtId)) q:phcdtId=""  d
   ...i phcdtTimeList'="" s phcdtTimeList=phcdtTimeList_"^"
   ...s phcdtTimeList=phcdtTimeList_$p($g(^PHCFR(+phcfrId,"DT",phcdtId)),"^",1) //edit mfc 20201123 频次区分节点了
   ..i phcdtTimeList="" s phcdtTimeList=28800
   ..s isAbbrevArcim=1
   ..s curAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId,isAbbrevArcim)
   ..s oeorditemStr=..GetOeorditemInfo(oeoriId)
   ..i phcinId="" s phcinId=+$p(oeorditemStr,"^",3)
   ..s subOeoriId=$p(oeorditemStr,"^",7) //从医嘱subOeoriId
   ..s oecprDesc=$p(oeorditemStr,"^",13) //优先级
   ..s phcinDesc=$p(oeorditemStr,"^",5) //用法 phcinDesc  40
   ..s prcfrId=$p(oeorditemStr,"^",14)
   ..s prcfrDesc=$p(oeorditemStr,"^",15) //频率 num: 41
   ..s oeoriNote=$p(oeorditemStr,"^",17) //医嘱备注 42
   ..;s icuoPreparedVolume=$p(oeorditemStr,"^",18) //ICUO_PreparedVolume
   ..s originalOeoriId=""
   ..i isStandSort=1 d
   ...s originalOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
   ...i originalOeoriId'="" s originalOeoriId=$p(originalOeoriId,"!!")
   ...i originalOeoriId="" s originalOeoriId=oeoriId
   ..s endTime=""
   ..//s phQtyOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12) //数量 add mfc 20200608
   ..s phQtyOrd=$p(##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(oeordId_"||"_oeoriSub),"^",1)
   ..i phQtyOrd="" s phQtyOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
   ..s createDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
   ..s createTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
   ..s ^TMPBP("Oeore",$j,sttDate,oeoriSub)=$lb(oeoriXDate,oeoriXTime,endDate,endTime,arcimId,arcimDesc,curQty,uomId,unitDesc,phcinId,phcinDesc,oecprDesc,prcfrId,prcfrDesc,oeoriNote,curAbbreviate,oeoriNote,orderItemStatus,orderItemSeqNo,phQtyOrd,createDate,createTime)   
   ..i ifQuit s quit=1
   q
   
OutputRowHisOrder
	//s Data=$lb(inattId,tPhcinId,tArcimId,tQty,tDefault)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindHisOrderItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHisOrderItemExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindHisOrderItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHisOrderItemExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCBPOrder","FindHisOrderItemBySummary","258","2022-01-01","2022-01-26","","N","92","0")

Query FindHisOrderItemBySummary(registerId, startDate = "", endDate = "", ifDrug = "Y", ifStand = "", ctLocId = "", ifQuit = "1") As %Query(ROWSPEC = "StartDate :%String,StartTime :%String,EndDate :%String,EndTime :%String,ArcimId :%String,ArcimDesc :%String,Dose:%String,UomId :%String,UnitDesc :%String,InstrId :%String,Instruction :%String,Priority :%String,FreqId :%String,FreqDesc :%String,OeoriNote :%String,Abbreviate :%String,OrderItemNote :%String,OrderItemStatus :%String,OrderItemSeqNo :%String,QtyOrd :%String,CreateDate :%String,CreateTime:%String")
{
}

ClassMethod FindHisOrderItemBySummaryExecute(ByRef qHandle As %Binary, registerId, startDate = "", endDate = "", ifDrug = "Y", ifStand = "", ctLocId = "", ifQuit = "1") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1

	k ^TMPBP("Oeore",$j)
	i registerId="" s qHandle=$lb(0,repid,0) q $$$OK
	//i ..SetMainSubIcucriList(icuaId,.mainSubIcucriList)<0 s qHandle=$lb(0,repid,0) q $$$OK
    s papmiId=$lg(^DHCBPPatRegister(registerId),1)
 	s ctLocId=##Class(web.DHCBPCom).GetLinkAdmLocByLocId(ctLocId)
	s Config=##Class(websys.Configuration).%OpenId(1)
	s LABDATA=Config.LabDataNamespace
	s CurNamespace=$ZNSPACE

    s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
    s admId="",quit=0
    //s admtype=$lg(^DHCBPPatRegister(registerId),23)   
    f  s admId=$o(^PAPERdr(papmiId,"ADM","O",admId),-1) q:(admId="")!(quit)  d
    .;i papmiId=1744529  s admId=17573309
	.s admDeptId=$p($g(^PAADM(admId)),"^",4)
	.q:(ctLocId'="")&&(ctLocId'=admDeptId)
	.s admDate=$p($g(^PAADM(admId)),"^",6)
	.q:(startDate>admDate)!(endDate<admDate)
	.d GetOrder
	//s admId=2
	//d GetOrder
	s stDate="" 
	f  s stDate=$o(^TMPBP("Oeore",$j,stDate))  q:stDate=""  d
	.s oeoriSub="" 
	.f  s oeoriSub=$o(^TMPBP("Oeore",$j,stDate,oeoriSub))  q:oeoriSub=""  d
	..s Data=^TMPBP("Oeore",$j,stDate,oeoriSub)
	..d OutputRowHisOrder
	s qHandle=$lb(0,repid,0)
	q $$$OK
	
GetOrder
   //查找医生所下医嘱
   s oeordId=$o(^OEORD(0,"Adm",admId,""))
   q:oeordId="" "" //未开过医嘱
   s fDate=startDate-1,tDate=endDate
   ;s fDate=62092
   f sttDate=fDate:1:tDate d
   .s oeoriSub=0
   .f  s oeoriSub=$o(^OEORDi(0,"StDt",sttDate,oeordId,oeoriSub)) q:(oeoriSub="")  d
   ..q:'$d(^OEORD(oeordId,"I",oeoriSub))
   ..s oeoriId=oeordId_"||"_oeoriSub
   ..s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
   ..q:(ordStatCode="U")!(ordStatCode="I")
   ..s oeoriXDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
   ..s oeoriXTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
   ..i oeoriXDate="" s oeoriXDate=99999
   ..s oeoriXDateTime=oeoriXDate+(oeoriXTime/100000)
   ..s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8) //长期医嘱，临时医嘱 etc.
   ..q:oecprId=""
   ..s oecprCode=$p(^OECPR(oecprId),"^",1)
   ..q:oecprCode=""
   ..q:((ordStatCode="D")!(ordStatCode="PD"))&((oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT"))
   ..s orcatId=##Class(web.DHCClinicCom).GetOrdCatId(oeoriId)
   ..q:orcatId=""
   ..s ocgrpId=$p($g(^OEC("ORCAT",orcatId)),"^",15) //OEC_OrderCategoryGroup
   ..s ocgrpCode=$p($g(^OEC("OCGRP",+ocgrpId)),"^",1)
   ..s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId) //医嘱分类类型，药品，饮食，静脉注射 等
   ..s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
   ..s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
   ..;医嘱序号
   ..s orderItemSeqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",4)
   ..;20130830+医嘱状态--
   ..s orderItemStatus=""
   ..s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
   ..s orderItemStatus=$p($g(^OEC("OSTAT",+ordStatId)),"^",2)
   ..s ordLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
   ..;q:(ordLocId'="")&(("^"_locIdStr_"^")'[("^"_ordLocId_"^"))
   ..;s arcsgId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",9)
   ..s phcfrFactor=1,phcfrCode=""
   ..s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
   ..i phcfrId'="" d 
   ...s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)
   ...s phcfrCode=$p(^PHCFR(phcfrId),"^",1)
   ..q:(phcfrCode="Ialways") //暂时写死
   ..q:"ONE^OUT"[oecprCode //取药医嘱和出院带药
   ..s isStandSort=2
   ..i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s isStandSort=1
   ..q:(ifStand="Y")&(oecprCode'="S")&(oecprCode'="OMST")&(oecprCode'="OMCQZT")
   ..q:(ifStand="N")&(ifStand'="Y")&((oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT"))
   ..s phcinId=+$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
   ..;q:(icuoType="D")&(phcinId'="")&(("^"_phcinStr_"^")[("^"_phcinId_"^"))
   ..s reportResult=""
   ..i ocgrpCode="EXAM" s reportResult=..GetRisReportResult(oeoriId)  //取检查结果
   ..i arcicOrderType="L" s reportResult=..GetLabReportResult(oeoriId,CurNamespace,LABDATA) //取检验结果
   ..s oeoriSttDat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
   ..s oeoriSttTim=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
   ..s bpRecLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
   ..s orderStatus=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
   ..s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
   ..s unitUomId="",unitDesc=""
   ..//s oeoriAddUserId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
   ..//s eqUomQty=##class(web.DHCICUCom).GetEqUomQty(arcimId)
   ..i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
   ..i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
   ..s uomId=unitUomId
   ..i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
   ..s curQty=doseQty 
   ..s phcdtTimeList=""
   ..s phcdtId=0
   ..f  s phcdtId=$o(^PHCFR(+phcfrId,"DT",phcdtId)) q:phcdtId=""  d
   ...i phcdtTimeList'="" s phcdtTimeList=phcdtTimeList_"^"
   ...s phcdtTimeList=phcdtTimeList_$p($g(^PHCFR(+phcfrId,"DT",phcdtId)),"^",1) //edit mfc 20201123 频次区分节点了
   ..i phcdtTimeList="" s phcdtTimeList=28800
   ..s isAbbrevArcim=1
   ..s curAbbreviate=##class(web.DHCClinicCom).GetOeoriGroupDesc(oeoriId,isAbbrevArcim)
   ..s oeorditemStr=..GetOeorditemInfo(oeoriId)
   ..i phcinId="" s phcinId=+$p(oeorditemStr,"^",3)
   ..s subOeoriId=$p(oeorditemStr,"^",7) //从医嘱subOeoriId
   ..s oecprDesc=$p(oeorditemStr,"^",13) //优先级
   ..s phcinDesc=$p(oeorditemStr,"^",5) //用法 phcinDesc  40
   ..s prcfrId=$p(oeorditemStr,"^",14)
   ..s prcfrDesc=$p(oeorditemStr,"^",15) //频率 num: 41
   ..s oeoriNote=$p(oeorditemStr,"^",17) //医嘱备注 42
   ..;s icuoPreparedVolume=$p(oeorditemStr,"^",18) //ICUO_PreparedVolume
   ..s originalOeoriId=""
   ..i isStandSort=1 d
   ...s originalOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
   ...i originalOeoriId'="" s originalOeoriId=$p(originalOeoriId,"!!")
   ...i originalOeoriId="" s originalOeoriId=oeoriId
   ..s endTime=""
   ..//s phQtyOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12) //数量 add mfc 20200608
   ..s phQtyOrd=$p(##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(oeordId_"||"_oeoriSub),"^",1)
   ..i phQtyOrd="" s phQtyOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
   ..s createDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
   ..s createTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
   ..s ^TMPBP("Oeore",$j,sttDate,oeoriSub)=$lb(oeoriXDate,oeoriXTime,endDate,endTime,arcimId,arcimDesc,curQty,uomId,unitDesc,phcinId,phcinDesc,oecprDesc,prcfrId,prcfrDesc,oeoriNote,curAbbreviate,oeoriNote,orderStatus,orderItemSeqNo,phQtyOrd,createDate,createTime)   
   ..i ifQuit s quit=1
   q
   
OutputRowHisOrder
	//s Data=$lb(inattId,tPhcinId,tArcimId,tQty,tDefault)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindHisOrderItemBySummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHisOrderItemExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindHisOrderItemBySummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHisOrderItemExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 取医嘱信息：
/// 入参：医嘱表RowId或医嘱执行表RowId
/// 返回值：用"^"分割的几部分：oecprType:Y/N/"",Y长嘱，N临嘱，""不应执行的医嘱(取药、出院带药);oecprCode:医嘱优先级代码;
///         phcinId:用法指针;phcinCode:用法代码;phcinDesc：用法描述,mainOeoriId:主医嘱RowId;subOeoriId:从医嘱RowId,
///         defPhcinId:缺省用法指针;defPhcinCode:缺省用法代码;defPhcinDesc：缺省用法描述;用"!"分割
///         oriQty:医嘱药品为剂量，非药品其它为数量;unitUomId:医嘱单位。
///         注：如果医嘱是从医嘱mainOeoriId有值，如果是主医嘱，从医嘱subOeoriId有值。
ClassMethod GetOeorditemInfo(oeoriId As %String) As %String
{
	//w ##class(web.DHCICUOrder).GetOeorditemInfo("911637||7")
	s oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" ""
	s oeordId=+oeoriId
	s oeoriId=oeordId_"||"_oeoriSub
	s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
    q:("VED"'[ordStatCode)&("TPD"'[ordStatCode) ""
    s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
    s oecprCode=""
    i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1)
    s oecprDesc=$p($g(^OECPR(+oecprId)),"^",2)
    s oecprType=""
    i (oecprCode="S")!(oecprCode="OMST")!(oecprCode="OMCQZT") s oecprType="Y" //长期医嘱
    i ((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="STAT")!(oecprCode="PRN")) s oecprType="N" //临时医嘱
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) //医嘱用法指针
    s phcinCode="",phcinDesc="" 
    i phcinId'="" s phcinCode=$p($g(^PHCIN(phcinId)),"^",1),phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)
	s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	s volume=##Class(web.DHCClinicCom).GetVolume(oeoriId)
	s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId)
	s subOeoriId=""
	i oeoriSub'="" d
	    .s curOriSub=""
	    .f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
			..s curArcimId=$p(^OEORD(oeordId,"I",curOriSub,1),"^",2)
			..s arcimDesc=$p($g(^ARCIM(+curArcimId,+$p(curArcimId,"||",2),1)),"^",2)
			..q:arcimDesc=""
		    ..q:(arcicOrderType="R")&(##Class(web.DHCClinicCom).GetOrdSubCatType(oeordId_"||"_curOriSub)'=arcicOrderType)
		    ..i subOeoriId'="" s subOeoriId=subOeoriId_"!"
		    ..s subOeoriId=subOeoriId_oeordId_"||"_curOriSub
		    ..s volume=volume+##Class(web.DHCClinicCom).GetVolume(oeordId_"||"_curOriSub)
	
	//for 第三方HIS begin
	s EpisodeID=+^OEORD(+oeoriId)
	s lhnOrderNo=$o(^DHCLHN(0,"OEORI",EpisodeID,oeoriId,""))
	i lhnOrderNo'="" d //以此为标志
	    .s mainOeoriId=""
	    .s subOeoriId=""
	    .s mainLhnId=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,1,""))
	    .q:mainLhnId=""
	    .q:'$d(^DHCLHN(mainLhnId))
	    .i oeoriId'=$p(^DHCLHN(mainLhnId),"^",4) s mainOeoriId=$p(^DHCLHN(mainLhnId),"^",4)
	    .q:mainOeoriId'="" //有主医嘱指针，是从医嘱
	    .s lhnOrderSubNo=1
	    .f  s lhnOrderSubNo=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,lhnOrderSubNo)) q:lhnOrderSubNo=""  d
	        ..s lhnId=""
	        ..f  s lhnId=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,lhnOrderSubNo,lhnId)) q:lhnId=""  d
	        	...q:'$d(^DHCLHN(lhnId)) 
	        	...i subOeoriId'="" s subOeoriId=subOeoriId_"!"
	        	...s subOeoriId=subOeoriId_$p(^DHCLHN(lhnId),"^",4)
	//w mainOeoriId_"/"_subOeoriId,!
	//for 第三方HIS end
	
	s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
    s phcdId=+phcdfId,phcdfSub=+$p(phcdfId,"||",2)
    s defPhcinId=+$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",5)
    s defPhcinCode=$p($g(^PHCIN(defPhcinId)),"^",1),defPhcinDesc=$p($g(^PHCIN(defPhcinId)),"^",2)
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	s prcfrDesc=$p($g(^PHCFR(+phcfrId)),"^",3)
	s phcfrFactor=$p(^PHCFR(+phcfrId),"^",2)

    s doseQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",1)
	s unitUomId=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",3)
	s phOrdQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,1)),"^",12)
	i doseQty="",phOrdQty="" s unitUomId=""
	i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
	s oriQty=doseQty
	i oriQty="" s oriQty=phOrdQty
	s oeoriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
    
    q oecprType_"^"_oecprCode_"^"_phcinId_"^"_phcinCode_"^"_phcinDesc_"^"_mainOeoriId_"^"_subOeoriId_"^"_defPhcinId_"^"_defPhcinCode_"^"_defPhcinDesc_"^"_oriQty_"^"_unitUomId_"^"_oecprDesc_"^"_phcfrId_"^"_prcfrDesc_"^"_phcfrFactor_"^"_oeoriNote_"^"_volume
}

ClassMethod GetRisReportResult(oeoriId As %String) As %Library.String
{
	//n (oeoriId)
	q:oeoriId="" ""
	s oeordId=$p(oeoriId,"||",1)
	s oeoriSub=$p(oeoriId,"||",2)
	//w oeoriId,!
	
	s rarId=$o(^DHCPACRegInfoi("OEORI",oeoriId,""))
	q:rarId="" ""
	s rarStudyNo=$p($g(^DHCPACRegInfo(rarId)),"^",2)
	//w "rarId=",rarId_"/"_rarStudyNo,!
	s drptId=$o(^DHCRBStudyi("Report","StudyNo",rarStudyNo,""))
	//s drptId=$o(^DHCRBStudyi("Report-Oeorditm",oeoriId,"")) //new version
	q:drptId="" ""
	q:'$d(^DHCRBStudy("Report",drptId)) ""
	s drsId=$p(^DHCRBStudy("Report",drptId),"^",4)
	q:drsId="" ""
	q:$p($g(^DHCRBCStatus("ReportStatus",drsId)),"^")'="V" ""  //如果没审核则退出
	s risReportResult=$g(^DHCRBStudy("Report",drptId,"ResultDescEx"))
	s num=$l(risReportResult,"_$c(13,10)_")
	s tmpStr=""
	f i=1:1:num d
	    .s tmpStr=tmpStr_$p(risReportResult,"_$c(13,10)_",i)
	//i risReportResult'="" s risReportResult=$p(risReportResult,"_$c(13,10)")
	s risReportResult=tmpStr
	q risReportResult
}

ClassMethod GetLabReportResult(oeoriId As %String, CurNamespace As %String, LABDATA As %String) As %Library.String
{
	;1:项目代码
	;2:项目名称
	;3:缩写
	;4:结果
	;5:单位
	;6:结果标志
	;7:范围
	//n (oeoriId,CurNamespace,LABDATA)
	q:oeoriId="" ""
	s oeordId=$p(oeoriId,"||",1)
	s oeoriSub=$p(oeoriId,"||",2)
	s oeoriLabTestSetRow=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",35)
	q:oeoriLabTestSetRow="" ""
	s labno=+oeoriLabTestSetRow
	s ts=$p(oeoriLabTestSetRow,"||",2)
	s tscnt=$p(oeoriLabTestSetRow,"||",3)
	q:ts="" ""
	q:$p($g(^TEPI(labno,1,ts,tscnt)),"\",31)'="E" "" //如果没审核则退出
	zn LABDATA
	k PLIST
	s ret=$$GetResultbyRowid^CHDhcLabReport(labno,ts,tscnt,"Y")
	q:ret'=0 ""
	s num=0,labReportResult=""
	f  s num=$o(PLIST(num)) q:num=""  d
	    .//q:num>1 //暂时返回一条
	    .i labReportResult'="" s labReportResult=labReportResult_"!"
	    .s labReportResult=labReportResult_$p(PLIST(num),$c(2),3)_":"_$p(PLIST(num),$c(2),4) //_$p(PLIST(num),$c(2),5) //PLIST(num) 
	zn CurNamespace
	q labReportResult
}

Query FindByArcimRowId(arcimId As %String) As %Query(ROWSPEC = "Id,Code,Description,Alias,ItemType,ItemCatId,EqualUomIdInfo,DefaultDoseInfo,BaseUomId,EqualQtyInfo,Volume,DefaultFreqId,DefaultInstrId,Price,DefaultRecvLoc") [ SqlProc ]
{
}

ClassMethod FindByArcimRowIdExecute(ByRef qHandle As %Binary, arcimId As %String) As %Status
{
	s ^tmpdebug("dtj")=arcimId_$h
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s arcimCode="",defaultRecvLoc="",arcimAlias="",arcimType="",defaultRecvLoc=""	
	s arcimMainId=+arcimId,arcimVersion=+$p(arcimId,"||",2)
	s arcimDesc=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",2)
	s itemCatId=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",10)
	s equalUomInfo=..GetEqUomQty(arcimId)
	s equalUomIdInfo=$p(equalUomInfo,"^",1)
	s defaultDoseInfo=$p(equalUomInfo,"^",2)
	s baseUomId=$p(equalUomInfo,"^",3)
	s equalQtyInfo=$p(equalUomInfo,"^",4)
	s volume=$p(equalUomInfo,"^",5)
	s defaultInstrId=""
	s instrId=$p($g(^ARCIM(arcimMainId,arcimVersion,1)),"^",12)
	s instrMainId=+instrId,instrSubId=+$p(instrId,"||",2)
	i (instrSubId'="")
	{
		s defaultInstrId=+$p($g(^PHCD(instrMainId,"DF",instrSubId,1)),"^",5)	
	}
	s freqId=$o(^PHCFR(0,"Code","1ONCE",""))
	s itemPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,+$h,"","","","")
	//s defaultRecvLoc=##class(web.DHCANCall).GetOrderItemRecloc(opaId,arcimId,"")
	//s defaultRecvLoc=$tr(defaultRecvLoc,"^","#")	
	d OutputRow
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(arcimId,arcimCode,arcimDesc,arcimAlias,arcimType,itemCatId,equalUomIdInfo,defaultDoseInfo,baseUomId,equalQtyInfo,volume,freqId,defaultInstrId,itemPrice,defaultRecvLoc)
 	S ^tmpdebug("Para1")=Data
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindByArcimRowIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindByArcimRowIdExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindByArcimRowIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindByArcimRowIdExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// add mfc 20190916
/// 获取透析用药记录，医嘱名称
/// arrangeId:透析记录ID、arcimId医嘱码表ID，orderType医嘱类型（长期、临时）
ClassMethod GetOrderByArrangeId(arrangeId As %String, arcimId As %String = "", orderType As %String = "", orderStatus As %String = "", dataField As %String = "") As %String
{
	q:arrangeId="" "透析记录ID不能为空!"
	s retStr="",orderItemCount=0,sumValue=0
	s bpoiId=""
	f  s bpoiId=$o(^DHCBPOrderItem(0,"Arrange",arrangeId,bpoiId)) q:bpoiId=""  d
		.s bpoiOrderTypeCode=$li(^DHCBPOrderItem(bpoiId),3)
	    .q:(orderType'="")&&(("^"_orderType_"^")'[("^"_bpoiOrderTypeCode_"^"))
	    .s bpoiArcimDr=$li(^DHCBPOrderItem(bpoiId),4)
	    .q:(arcimId'="")&&(("^"_arcimId_"^")'[("^"_bpoiArcimDr_"^"))
	    .s bpoiStatus=$lg(^DHCBPOrderItem(bpoiId),13)
	    .q:(orderStatus'="")&&(("^"_orderStatus_"^")'[("^"_bpoiStatus_"^"))
	    .s bpoiDose=$li(^DHCBPOrderItem(bpoiId),5)
	    .
	    .i dataField="Times" s orderItemCount=orderItemCount+1,retStr=orderItemCount
	    .e  i dataField="Sum" s sumValue=sumValue+bpoiDose,retStr=sumValue
	    .e  s retStr=bpoiDose
	    .;w retStr,!
	q retStr
}

/// mfc 20210630
/// 补医嘱时间索引
/// w ##class(web.DHCBPOrder).SetOrderItemIndex()
ClassMethod SetOrderItemIndex() As %String
{
	s bpoiId=0
	f  s bpoiId=$o(^DHCBPOrderItem(bpoiId)) q:bpoiId=""  d
		.q:('$d(^DHCBPOrderItem(bpoiId)))
		.//q:bpoiId'=81452
		.s bpoiStartDate=$li($g(^DHCBPOrderItem(bpoiId)),11)
		.s ^DHCBPOrderItem(0,"StartDate",bpoiStartDate,bpoiId)=""
	q 0
}

/// 通过日期获取医嘱
/// d ##class(%ResultSet).RunQuery("web.DHCBPOrder","FindBPOrderByDate","2021-06-30","2021-06-30","","","","","N",16)
Query FindBPOrderByDate(fromDate As %String, toDate As %String, regNo As %String = "", needBpoiStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", BPOrderType As %String, ctLoc As %String = "", registerId As %String = "") As %Query(ROWSPEC = "Id,RegNo,PatName,Medicare,RegisterId,ArrangeId,BPOrderType,ArcimId,ArcimCode,ArcimDesc,ArcimAbbrev,Dose,DoseUnitId,DoseUnitDesc,PackQty,PackUnitId,PackUnitDesc,FreqId,FreqDesc,InstructId,InstructDesc,StartDate,StartTime,StartDateTime,Status,Note,MasterSeqNo,SeqNo,RecLocId,RecLocDesc,OrderItemDr,CreateCtcpId,CreateCtcpDesc,CreateDate,CreateTime,CreateDateTime,XCtcpId,XCtcpDesc,XDate,XTime,ExecCtcpDr,ExecCtcpDesc,ExecDate,ExecTime,CancelExecCtcpId,CancelExecCtcpDesc,CancelExecDate,CancelExecTime,DurationId,DurationDesc,Price,BedId,BedDesc,BedGroupId,BedGroupDesc,DaySeqNo,DayPart")
{
}

ClassMethod FindBPOrderByDateExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", needBpoiStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", BPOrderType As %String, ctLoc As %String = "", registerId As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)
	s wardIdStr=##Class(web.DHCBPCom).GetLinkLocByLocId(ctLoc) //科室关联
	w wardIdStr,!	
	s bpoiId=""
	f curDate=fromDate:1:toDate d
		.f  s bpoiId=$o(^DHCBPOrderItem(0,"StartDate",curDate,bpoiId)) q:bpoiId=""  d
			..q:('$d(^DHCBPOrderItem(bpoiId)))
			..s bpprId=$li(^DHCBPOrderItem(bpoiId),1)		
			..q:(registerId'="")&&(bpprId'=registerId)
			..s bpoiOrderTypeCode=$li(^DHCBPOrderItem(bpoiId),3)
			..q:(BPOrderType'="")&&(bpoiOrderTypeCode'=BPOrderType)		
			..s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
			..q:(bpprPatLocationDr'="")&&(wardIdStr'="")&&(("^"_wardIdStr_"^")'[("^"_bpprPatLocationDr_"^"))		
			..s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
			..q:papmiId=""
			..d GetBPOrder()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetBPOrder()
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s bpopBPPatRegisterDr=$li(^DHCBPOrderItem(bpoiId),1)
	s bpoiBPArrangeDr=$li(^DHCBPOrderItem(bpoiId),2)
	i bpoiBPArrangeDr'="" s bpoiBPStatus=$lg(^DHCBPArrange(bpoiBPArrangeDr),9)
	e  s bpoiBPStatus=""
	q:(bpoiBPArrangeDr'="")&&(bpoiOrderTypeCode="N")&&(bpoiBPStatus="D") //临时医嘱所在透析记录取消，不在显示	
	s bpoiArcimDr=$li(^DHCBPOrderItem(bpoiId),4)
	s arcimSub=$p(bpoiArcimDr,"||",1)
	s arcimVer=$p(bpoiArcimDr,"||",2)
	s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
	s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	s arcimAbbrev=$p(^ARCIM(arcimSub,arcimVer,1),"^",3)
	i 1[arcimAbbrev s arcimAbbrev=arcimDesc
	s bpoiDose=$li(^DHCBPOrderItem(bpoiId),5)
	s bpoiDoseUnitDr=$li(^DHCBPOrderItem(bpoiId),6)
	s bpoiDoseUnitDesc=""
	i bpoiDoseUnitDr'="" d
	.s bpoiDoseUnitDesc=$ZCVT($p($g(^CT("UOM",+bpoiDoseUnitDr)),"^",2),"l")
	s bpoiPackQty=$li(^DHCBPOrderItem(bpoiId),7)
	s bpoiPackUnitDr=$li(^DHCBPOrderItem(bpoiId),8)
	s bpoiPackUnitDesc=""
	i bpoiPackUnitDr'="" d
	s bpoiPackUnitDesc=$ZCVT($p($g(^CT("UOM",+bpoiPackUnitDr)),"^",2),"l")
	s bpoiFreqDr=$li(^DHCBPOrderItem(bpoiId),9)
	s bpoiFreqDesc=""
	i bpoiFreqDr'="" d
	.s bpoiFreqDesc=$p($g(^PHCFR(bpoiFreqDr)),"^",4)
	s bpoiInstructDr=$li(^DHCBPOrderItem(bpoiId),10)
	s bpoiInstructDesc=""
	i bpoiInstructDr'="" d
	.s bpoiInstructDesc=$p($g(^PHCIN(bpoiInstructDr)),"^",2)
	i $l(bpoiInstructDesc,"-")>1 d
	.s bpoiInstructDesc=$p(bpoiInstructDesc,"-",2)
	s bpoiStartDate=$li(^DHCBPOrderItem(bpoiId),11)
	q:((fromDate'="")&&(toDate'=""))&&(bpoiStartDate'="")&&((bpoiStartDate<fromDate)||(bpoiStartDate>toDate))
	i bpoiStartDate'="" d
	.s bpoiStartDate=$zd(bpoiStartDate,3)
	s bpoiStartTime=$li(^DHCBPOrderItem(bpoiId),12)
	i bpoiStartTime'="" d
	.s bpoiStartTime=$zt(bpoiStartTime,1)
	s bpoiStartDateTime=""
	i bpoiStartDate'="" s bpoiStartDateTime=bpoiStartDate
	i bpoiStartTime'="" s bpoiStartDateTime=bpoiStartDate_" "_bpoiStartTime
	s bpoiStatus=$lg(^DHCBPOrderItem(bpoiId),13)
	q:(needBpoiStatus'="")&&(needBpoiStatus'=bpoiStatus) 
	s bpoiNote=$li(^DHCBPOrderItem(bpoiId),14)
	s bpoiMasterSeqNo=$li(^DHCBPOrderItem(bpoiId),15)
	s bpoiSeqNo=$li(^DHCBPOrderItem(bpoiId),16)
	s bpoiRecLocDr=$li(^DHCBPOrderItem(bpoiId),17)
	s bpoiRecLocDesc=""
	i bpoiRecLocDr'="" d
	.s bpoiRecLocDesc=$P($g(^CTLOC(bpoiRecLocDr)),"^",2) 
	s bpoiDurationDr=$li(^DHCBPOrderItem(bpoiId),18) 
	s bpoiDurationDesc=""
    i bpoiDurationDr'="" s bpoiDurationDesc=$p($g(^PHCDU(bpoiDurationDr)),"^",1)
	s bpoiOrderItemDr=$li(^DHCBPOrderItem(bpoiId),19)
	s bpoiCreateCtcpDr=$li(^DHCBPOrderItem(bpoiId),20)
	s bpoiCreateCtcpDesc=""
	i bpoiCreateCtcpDr'="" s bpoiCreateCtcpDesc=##class(web.DHCANOPCom).GetNameById(bpoiCreateCtcpDr) 
	s bpoiCreateDate=$li(^DHCBPOrderItem(bpoiId),21)
	i bpoiCreateDate'="" d
	.s bpoiCreateDate=$zd(bpoiCreateDate,3)
	s bpoiCreateTime=$li(^DHCBPOrderItem(bpoiId),22)
	i bpoiCreateTime'="" d
	.s bpoiCreateTime=$zt(bpoiCreateTime,1)
	s bpoiCreateDateTime=""
	i bpoiCreateDate'="" s bpoiCreateDateTime=bpoiCreateDate
	i bpoiCreateTime'="" s bpoiCreateDateTime=bpoiCreateDate_" "_bpoiCreateTime
	s bpoiXCtcpDr=$li(^DHCBPOrderItem(bpoiId),23)
	s bpoiXCtcpDesc=""
	i bpoiXCtcpDr'="" d
	.s bpoiXCtcpDesc=##class(web.DHCBPCom).GetNameById(bpoiXCtcpDr) 
	s bpoiXDate=$li(^DHCBPOrderItem(bpoiId),24)
	i bpoiXDate'="" d
	.s bpoiXDate=$zd(bpoiXDate,3)
	s bpoiXTime=$li(^DHCBPOrderItem(bpoiId),25)
	i bpoiXTime'="" d
	.s bpoiXTime=$zt(bpoiXTime,1)
	s bpoiExecCtcpDr=$li(^DHCBPOrderItem(bpoiId),26)
	s bpoiExecCtcpDesc=##class(web.DHCBPCom).GetNameById(bpoiExecCtcpDr)
	s bpoiExecDate=$li(^DHCBPOrderItem(bpoiId),27)
	i bpoiExecDate'="" d
	.s bpoiExecDate=$zd(bpoiExecDate,3)
	s bpoiExecTime=$li(^DHCBPOrderItem(bpoiId),28)
	i bpoiExecTime'="" d
	.s bpoiExecTime=$zt(bpoiExecTime,1)
	s bpoiCancelExecCtcpDr=$lg(^DHCBPOrderItem(bpoiId),29)
	s bpoiCancelExecCtcpDesc=##class(web.DHCBPCom).GetNameById(bpoiCancelExecCtcpDr)
	s bpoiCancelExecDate=$lg(^DHCBPOrderItem(bpoiId),30)
	i bpoiCancelExecDate'="" d
	.s bpoiCancelExecDate=$zd(bpoiCancelExecDate,3)
	s bpoiCancelExecTime=$lg(^DHCBPOrderItem(bpoiId),31)
	i bpoiCancelExecTime'="" d
	.s bpoiCancelExecTime=$zt(bpoiCancelExecTime,1)
	s bpoiPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",bpoiArcimDr,+$h,"","","","")
	s bpaBPCBedDr="",bpaBPCBedDesc="",bpcBedGroupDr="",bpcBedGroupDesc="",bpaDaySeqNo="",bpaDayPart=""
	i bpoiBPArrangeDr'="" d
	.s bpaBPCBedDr=$lg($g(^DHCBPArrange(bpoiBPArrangeDr)),7)
	.s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
	.s bpcBedGroupDr=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),3)
	.s bpcBedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bpcBedGroupDr)),2)
	.s bpaDaySeqNo=$lg(^DHCBPArrange(bpoiBPArrangeDr),6)
	.i bpaDaySeqNo="A" s bpaDayPart="上午"	
	.i bpaDaySeqNo="P" s bpaDayPart="下午"
	.i bpaDaySeqNo="E" s bpaDayPart="晚上"
	d OutputRow    	
	q 0
OutputRow
	set Data=$lb(bpoiId,regNo,patName,papmiMedicare,bpopBPPatRegisterDr,bpoiBPArrangeDr,bpoiOrderTypeCode,bpoiArcimDr,arcimCode,arcimDesc,arcimAbbrev,bpoiDose,bpoiDoseUnitDr,bpoiDoseUnitDesc,bpoiPackQty,bpoiPackUnitDr,bpoiPackUnitDesc,bpoiFreqDr,bpoiFreqDesc,bpoiInstructDr,bpoiInstructDesc,bpoiStartDate,bpoiStartTime,bpoiStartDateTime,bpoiStatus,bpoiNote,bpoiMasterSeqNo,bpoiSeqNo,bpoiRecLocDr,bpoiRecLocDesc,bpoiOrderItemDr,bpoiCreateCtcpDr,bpoiCreateCtcpDesc,bpoiCreateDate,bpoiCreateTime,bpoiCreateDateTime,bpoiXCtcpDr,bpoiXCtcpDesc,bpoiXDate,bpoiXTime,bpoiExecCtcpDr,bpoiExecCtcpDesc,bpoiExecDate,bpoiExecTime,bpoiCancelExecCtcpDr,bpoiCancelExecCtcpDesc,bpoiCancelExecDate,bpoiCancelExecTime,bpoiDurationDr,bpoiDurationDesc,bpoiPrice,bpaBPCBedDr,bpaBPCBedDesc,bpcBedGroupDr,bpcBedGroupDesc,bpaDaySeqNo,bpaDayPart)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPOrderByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPOrderByDateExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPOrderByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPOrderByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCBPOrder).ChargeBPOrderItems($p(^DHCTmpMfc("BPOrderItems","test"),"/",1),$p(^DHCTmpMfc("BPOrderItems","test"),"/",2))
ClassMethod ChargeBPOrderItems(BPOrderItems As %String, curLocId As %String) As %String
{
	s ^DHCTmpMfc("BPOrderItems","test")=BPOrderItems_"/"_curLocId
	s num=0
	//s BPOrderItems=^TMPzt("BPOrderItems","test")
	q:BPOrderItems="" "未选中医嘱"
	s count=$l(BPOrderItems,"^")
	s ret="",qFlag=0,mulOeoriStr=""
	K TMPSumItem
	for i=1:1:count
	{
     s BPOrderItem=$p(BPOrderItems,"^",i)
     q:BPOrderItem=""
	 s rowId=$p(BPOrderItem,$c(3),1)
	 q:rowId="" 
	 s BPOrderItemObj=""
	 ;b
     s BPOrderItemObj=##class(User.DHCBPOrderItem).%OpenId(rowId) 	
	 s patChargeTypeId=$p(BPOrderItem,$c(3),6)
	 s ctcpId=$p(BPOrderItem,$c(3),3)
	 s locId=curLocId //这里不对
	 s EpisodeID="" 
	 s arrangeObj=BPOrderItemObj.BPOIBPArrangeDr
	 i arrangeObj'="" d
	 .s EpisodeID=arrangeObj.BPAAdmDr
	 .s registerObj=BPOrderItemObj.BPOIBPPatRegisterDr
	 .i registerObj'="" d
  	 ..s papmiId=registerObj.BPPRPaPatMasDr
  	 ..b
  	 ..s EpisodeIDList=##class(web.DHCBPCom).GetPatientEpisodeID("",papmiId,+$h,+$h,curLocId)
  	 ..s EpisodeID=$p(EpisodeIDList,"^",1)
  	 ..;s EpisodeID=1625
  	 .//s arrangeObj.BPAAdmDr=EpisodeID // 20200922 BPAAdmDr 占用
	 q:qFlag
     i EpisodeID="" s qFlag=1 
	 q:EpisodeID="" 
	 s arcimId=BPOrderItemObj.BPOIArcimDr
	 s startDate=BPOrderItemObj.BPOIStartDate
	 s startTime=BPOrderItemObj.BPOIStartTime
	 s recDepId=curLocId
	 s doseQty=BPOrderItemObj.BPOIDose
	 s packQty=BPOrderItemObj.BPOIPackQty
	 i packQty'="" s count=+packQty
	 e  s count=0
	 s doseUomId=BPOrderItemObj.BPOIDoseUnitDr
	 s instrId=BPOrderItemObj.BPOIInstructDr
	 s seqNo=BPOrderItemObj.BPOISeqNo
	 i seqNo="" s seqNo=1000+i
	 s masterSeqNo=BPOrderItemObj.BPOIMasterSeqNo
	 s oeoriPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,+$h,"","","","")
	 s freqDr=BPOrderItemObj.BPOIFreqDr
	 s depProcNotes=BPOrderItemObj.BPOINote
	 i mulOeoriStr="" s mulOeoriStr=arcimId_$c(3)_startDate_$c(3)_$zt(startTime)_$c(3)_recDepId_$c(3)_doseQty_$c(3)_packQty_$c(3)_doseUomId_$c(3)_instrId_$c(3)_seqNo_$c(3)_masterSeqNo_$c(3)_oeoriPrice_$c(3)_depProcNotes _$c(3)_patChargeTypeId_$c(3)_ freqDr
	 e  s mulOeoriStr=mulOeoriStr_"^"_arcimId_$c(3)_startDate_$c(3)_$zt(startTime)_$c(3)_recDepId_$c(3)_doseQty_$c(3)_packQty_$c(3)_doseUomId_$c(3)_instrId_$c(3)_seqNo_$c(3)_masterSeqNo_$c(3)_oeoriPrice_$c(3)_depProcNotes_$c(3)_patChargeTypeId_$c(3)_ freqDr
	 ;b ;insert
	 //s TMPSumItem("MulOeoriStr",arcimId)=arcimId_$c(3)_startDate_$c(3)_$zt(startTime)_$c(3)_recDepId_$c(3)_doseQty_$c(3)_TMPSumItem(arcimId,"Count")_$c(3)_doseUomId_$c(3)_instrId_$c(3)_seqNo_$c(3)_masterSeqNo_$c(3)_oeoriPrice_$c(3)_depProcNotes
	 ;/// 参数：医嘱项ID^科室ID^用户ID^登记号^数量（消耗传负数，撤销传正数)
	 s userId=##Class(web.DHCBPCom).GetCtcpUserId(ctcpId)
	 s patRegisterId=BPOrderItemObj.BPOIBPPatRegisterDr.%Id()
	 s papmiId=$lg(^DHCBPPatRegister(patRegisterId),1)
	 s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	 s num=num+1
	}
	i qFlag d
	.s ret="当天无就诊记录，请挂号以后执行医嘱录入!"
	e  d
	.s ^tempby("InsertOrderItem")=EpisodeID_","_mulOeoriStr_","_userId _","_locId
	.s retStr=..InsertOrderItemNew(EpisodeID,mulOeoriStr,userId,locId)	
	.s ret=num
	q ret
}

ClassMethod InsertOrderItemNew(EpisodeID, mulOeoriStr, userId, locId) As %String
{
	//EpisodeID就诊号, userId用户Id, locId登录科室Id, 
	//mulOeoriStr由$c(3)分割：arcimId医嘱码Id, startDate开始日期, startTime开始时间,recDepId接收科室,
	//doseQty单次剂量,doseQtySum数量, doseUomId等效剂量单位, instrId用法, seqNo序号, masterSeqNo主医嘱序号,oeoriPrice价格,医嘱备注depProcNotes
	//其中seqNo序号取自然序号，不是插入后的序号。masterSeqNo值取主医嘱的seqNo序号
	//返回以"^"分割的第一部分为0未成功,错误信息为第二部分。成功则返回类于"1576||1*924106||331*V^1402||1*924106||332*V^"的串
	
	//w ##class(web.DHCBPOrder).InsertOrderItem(502,"",646,291)
	//s mulOeoriStr="1576||1"_$c(3)_"2009-7-17"_$c(3)_"18:00"_$c(3)_640_$c(3)_250_$c(3)_250_$c(3)_619_$c(3)_12_$c(3)_1_$c(3)_""
	//s mulOeoriStr=mulOeoriStr_"^1402||1"_$c(3)_"2009-7-17"_$c(3)_"18:00"_$c(3)_640_$c(3)_160_$c(3)_160_$c(3)_619_$c(3)_12_$c(3)_2_$c(3)_"1"
	
	//freqId会不会有变
	b ;insert in
	s ^TMPzt("summuloeoristr")=mulOeoriStr
	q:(EpisodeID="")!(mulOeoriStr="")!(userId="")!(locId="") "0^输入数据有误!"
	s LABDATA="LABDATA"
	s docId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:docId="" "0^请使用医护人员身份登录!"
	
	s orderType="",packQty="",oeprice=0,drugFormId="",depProcNotes="",phPrescType=""
	s masterSeqNo="",skinTest="N",phSpecInstr="",orderCoverMainIns="Y",actionId="",arcosId=""
	
	s admReasonId=$p(^PAADM(EpisodeID,1),"^",7)
	s defDurId=0
	s phcduId=0
	f  s phcduId=$o(^PHCDU(phcduId)) q:(phcduId="")!(defDurId>0)  d
		.q:$p(^PHCDU(phcduId),"^",2)'=1
		.s defDurId=phcduId
	q:defDurId=0 "没有疗程为1天的数据,请维护!" 
	s defFreqId=0,phcfrId=0,isFind=0
	f  s phcfrId=$o(^PHCFR(phcfrId)) q:(phcfrId="")!(isFind)  d
		.q:$p(^PHCFR(phcfrId),"^",2)'=1
		.q:'$d(^PHCFR(phcfrId,"DT",1))
		.s defFreqId=phcfrId
		.i ^PHCFR(phcfrId,"DT",1)=28800 s isFind=1
	//i $o(^PHCFR(0,"Code","QD",""))'="" s defFreqId=$o(^PHCFR(0,"Code","QD",""))
	q:defFreqId=0 "没有频次为1数据,请维护!"
	s priorId=$o(^OECPR(0,"Code","NORM",""))   //优先级
	q:+priorId=0 "没有临时医嘱优先级数据,请维护!"
	
	/*s Config=##Class(websys.Configuration).%OpenId(1)
	s MEDDATA=Config.DataNamespace
	s CurrentNS=$ZNSPACE
	zn MEDDATA     //转换命名空间
	*/
	b ;first
	s retStr=0
	s oeoriStr=""
	f i=1:1:$l(mulOeoriStr,"^") d
		.s singleOeoriStr=$p(mulOeoriStr,"^",i)
		.s arcimId=$p(singleOeoriStr,$c(3),1)
		.i '$d(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)) s retStr="医嘱码"_arcimId_"不对!" q
		.//s ItemCatDR=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",10)
		.//s ItemCatDR=$p(^ARC("IC",ItemCatDR),"^",7)
		.s startDate=$p(singleOeoriStr,$c(3),2)
		.s startTime=$p(singleOeoriStr,$c(3),3)
		.s recLocId=$p(singleOeoriStr,$c(3),4)
		.i '$d(^CTLOC(recLocId)) s recLocId=""
		.i recLocId="" d
			..s recLocStr=..GetRecLoc(EpisodeID,arcimId)
			..s recLocId=$p(recLocStr,$c(3),1)
		.;i recLocId="" s recLocId=locId
		.s OrdCateType=##class(web.UDHCJFPRICE).GetOrdCateType(arcimId,0)
		.s orderType=OrdCateType
		.i OrdCateType="R" s recLocId=locId
		.e  s recLocId=locId
		.;i locId'="" s recLocId=143
		.s doseQty=$p(singleOeoriStr,$c(3),5)
		.s doseQtySum=+$p(singleOeoriStr,$c(3),6)
		.s packQty=+$p(singleOeoriStr,$c(3),6)
		.s doseUomId=$p(singleOeoriStr,$c(3),7)
		.s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
		.i phcdfId>0 s doseQtySum=##class(web.DHCDocOrderEntry).CalDose(doseUomId,phcdfId,doseQty)
		.i doseQtySum>$p(doseQtySum,".") s doseQtySum=$p(doseQtySum,".")+1
		.s instrId=$p(singleOeoriStr,$c(3),8)
		.s freqId=defFreqId
		.s durId=defDurId
		.s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
		.i phcdfId=-1 s phcdfId=""
		.i phcdfId="" s freqId="",durId=""
		.s seqNo=$p(singleOeoriStr,$c(3),9)
		.s masterSeqNo=$p(singleOeoriStr,$c(3),10)
		.s oeprice=$p(singleOeoriStr,$c(3),11) //ypz 110316
		
		.s depProcNotes=$p(singleOeoriStr,$c(3),12)
		.s admReasonId=$p(singleOeoriStr,$c(3),13)
		.s freqId=$p(singleOeoriStr,$c(3),14)
		.;s ^tempby("oeprice")=freqId
		.;s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
		.;s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
		.i startDate="" s startDate=+$h
		.i $l(startDate,"-")>2 s startDate=$zdh(startDate,3)
		.s startDate=$zd(startDate,4)
		.
		.i startTime="" s startTime=$p($h,",",2)
		.;b ;begain invoke
		.i oeoriStr'="" s oeoriStr=oeoriStr_$c(1)
		.s oeoriStr=oeoriStr_arcimId_"^"_orderType_"^"_priorId_"^"_startDate_"^"_startTime_"^"_packQty_"^"_oeprice_"^"_recLocId_"^"_admReasonId_"^"_drugFormId
		.s oeoriStr=oeoriStr_"^"_depProcNotes_"^"_doseQty_"^"_doseUomId_"^"_doseQtySum_"^"_freqId_"^"_durId_"^"_instrId_"^"_phPrescType_"^"_masterSeqNo_"^"_seqNo
		.s oeoriStr=oeoriStr_"^"_skinTest_"^"_phSpecInstr_"^"_orderCoverMainIns_"^"_actionId_"^"_arcosId_"^^^^^"
		.s oeoriStr=oeoriStr_"^^^^^^^"
		b ;1
	//s retStr=##class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID, oeoriStr, userId, locId, docId)
	s retStr= ##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(EpisodeID, oeoriStr, userId, locId, docId)
	s ^tempby("oeprice")=retStr
	b ;final
	i $p(retStr,"^",1)=-1 s $p(retStr,"^",1,2)=$p(retStr,"^",2)
	q retStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPOrder","GetPACAdmReasonList")
Query GetPACAdmReasonList() As %SQLQuery(CONTAINID = 1)
{
	SELECT REA_RowId As Id,
	   REA_Code As Code,
	   REA_Desc As Description FROM PAC_AdmReason
}

}
