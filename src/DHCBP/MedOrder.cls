Class DHCBP.MedOrder Extends web.DHCClinicCom
{

/// Creator：      	唐潇
/// CreatDate：    	2019-05-29
/// Description： 	保存/增加医嘱
/// Table：        	User.DHCBPOrderItem
/// Input:			saveParam 
/// Return：       操作成功与否
/// w ##class(DHCBP.MedOrder).SaveBPOrderItem(saveParam)
ClassMethod SaveBPOrderItem(saveParam As %String)
{
	s $zt="Error"
	
	//s saveObj={}.%FromJSON(saveParam)
	s saveObj=..ToJsonObj(saveParam)
	s RowId=saveObj.GetAt("RowId")
	s OrderType=saveObj.GetAt("BPOIOrderType")
	//q:saveObj.GetAt("BPOIBPArrangeDr")="" "E^bpaId为空"
	//if (OrderType="S") s bpaId=""
	s bpaId=saveObj.GetAt("BPOIBPArrangeDr")
	s registerId=saveObj.GetAt("BPOIBPRegisterDr")
	if (registerId="")&&(bpaId'="") s registerId=$lg(^DHCBPArrange(bpaId),1)
	//s registerId=$lg(^DHCBPArrange(bpaId),1)
	q:((RowId'="")&&('##class(User.DHCBPOrderItem).%ExistsId(RowId))) "E^医嘱ID不存在"
	i RowId="" d
	.s BPOrderItem=##class(User.DHCBPOrderItem).%New()
	e  d
	.s BPOrderItem=##class(User.DHCBPOrderItem).%OpenId(RowId)
	d BPOrderItem.BPOIBPPatRegisterDrSetObjectId(registerId)
	d BPOrderItem.BPOIBPArrangeDrSetObjectId(bpaId)
	s:saveObj.GetAt("BPOIOrderType")'="" BPOrderItem.BPOIOrderType=saveObj.GetAt("BPOIOrderType")
	s:saveObj.GetAt("BPOIArcimDr")'="" BPOrderItem.BPOIArcimDr=saveObj.GetAt("BPOIArcimDr")
	s:saveObj.GetAt("BPOIDose")'="" BPOrderItem.BPOIDose=saveObj.GetAt("BPOIDose")
	s:saveObj.GetAt("BPOIStatus")'="" BPOrderItem.BPOIStatus=saveObj.GetAt("BPOIStatus")
	s:saveObj.GetAt("BPOIDoseUnitDr")'="" BPOrderItem.BPOIDoseUnitDr=saveObj.GetAt("BPOIDoseUnitDr")
	s:saveObj.GetAt("BPOIPackQty")'="" BPOrderItem.BPOIPackQty=saveObj.GetAt("BPOIPackQty")
	s:saveObj.GetAt("BPOIPackUnitDr")'="" BPOrderItem.BPOIPackUnitDr=saveObj.GetAt("BPOIPackUnitDr")
	s:saveObj.GetAt("BPOIFreqDr")'="" BPOrderItem.BPOIFreqDr=saveObj.GetAt("BPOIFreqDr")
	s:saveObj.GetAt("BPOIInstructDr")'="" BPOrderItem.BPOIInstructDr=saveObj.GetAt("BPOIInstructDr")
	s:saveObj.GetAt("BPOIStartDate")'="" BPOrderItem.BPOIStartDate=##class(web.DHCANOPCom).ConvertToDateH(saveObj.GetAt("BPOIStartDate"))  
	s:saveObj.GetAt("BPOIStartTime")'="" BPOrderItem.BPOIStartTime=##class(web.DHCANOPCom).ConvertToTimeH(saveObj.GetAt("BPOIStartTime")) 
	s:saveObj.GetAt("BPOISBPOIStatustartDate")'="" BPOrderItem.BPOIStatus=saveObj.GetAt("BPOISBPOIStatustartDate")
	s BPOrderItem.BPOINote=saveObj.GetAt("BPOINote")
	s:saveObj.GetAt("BPOIMasterSeqNo")'="" BPOrderItem.BPOIMasterSeqNo=saveObj.GetAt("BPOIMasterSeqNo")
	s:saveObj.GetAt("BPOISeqNo")'="" BPOrderItem.BPOISeqNo=saveObj.GetAt("BPOISeqNo")
	s:saveObj.GetAt("BPOIRecLocDr")'="" BPOrderItem.BPOIRecLocDr=saveObj.GetAt("BPOIRecLocDr")
	s:saveObj.GetAt("BPOIDurationDr")'="" BPOrderItem.BPOIDurationDr=saveObj.GetAt("BPOIDurationDr")
	s:saveObj.GetAt("BPOIOrderItemDr")'="" BPOrderItem.BPOIOrderItemDr=saveObj.GetAt("BPOIOrderItemDr")
	s:RowId="" BPOrderItem.BPOICreateCtcpDr=saveObj.GetAt("BPOICreateCtcpDr")
	s:RowId="" BPOrderItem.BPOICreateDate=+$H //##class(web.DHCANOPCom).ConvertToDateH(saveObj.BPOICreateDate) 
	s:RowId="" BPOrderItem.BPOICreateTime=$p($H,",",2) //##class(web.DHCANOPCom).ConvertToTimeH(saveObj.BPOICreateTime) 
	;s:saveObj.BPOIXCtcpDr'="" BPOrderItem.BPOIXCtcpDr=saveObj.BPOIXCtcpDr
	;s:saveObj.BPOIXDate'="" BPOrderItem.BPOIXDate=##class(web.DHCANOPCom).ConvertToDateH(saveObj.BPOIXDate) 
	;s:saveObj.BPOIXTime'="" BPOrderItem.BPOIXTime=##class(web.DHCANOPCom).ConvertToTimeH(saveObj.BPOIXTime) 
	;s:saveObj.BPOIExecCtcpDr'="" BPOrderItem.BPOIExecCtcpDr=saveObj.BPOIExecCtcpDr
	;s:saveObj.BPOIExecDate'="" BPOrderItem.BPOIExecDate=##class(web.DHCANOPCom).ConvertToDateH(saveObj.BPOIExecDate) 
	;s:saveObj.BPOIExecTime'="" BPOrderItem.BPOIExecTime=##class(web.DHCANOPCom).ConvertToTimeH(saveObj.BPOIExecTime) 
	;s:saveObj.BPOICancelExecCtcpDr'="" BPOrderItem.BPOICancelExecCtcpDr=saveObj.BPOICancelExecCtcpDr
	;s:saveObj.BPOICancelExecDate'="" BPOrderItem.BPOICancelExecDate=##class(web.DHCANOPCom).ConvertToDateH(saveObj.BPOICancelExecDate) 
	;s:saveObj.BPOICancelExecTime'="" BPOrderItem.BPOICancelExecTime=##class(web.DHCANOPCom).ConvertToTimeH(saveObj.BPOICancelExecTime) 
	s ^tmptxtxtxaaa="abc"
	d BPOrderItem.%Save()
	q "S^保存成功"
Error
	s ^tmptxtxtxaaa="123"_$ze
	q "E^"+$ze
}

/// 执行医嘱 BPOICancelExecCtcpDr
ClassMethod ExecuteOEOrderItem(saveParam As %String)
{
	s ^tempby("ExecuteOEOrderItem",+$h,$p($h,",",2))=saveParam
	s $zt="Error"
	s orderObj=..ToJsonObj(saveParam)
	s count=orderObj.Count()
	For i=1:1:count {
		s saveObj=orderObj.GetAt(i)
		s RowId=saveObj.GetAt("RowId")
		s BPOrderItem=##class(User.DHCBPOrderItem).%OpenId(RowId)
		s BPOrderItem.BPOIExecCtcpDr=saveObj.GetAt("BPOIExecCtcpDr")
		s BPOrderItem.BPOIExecDate=..ConvertToDateH(saveObj.GetAt("BPOIExecDate"))
		s BPOrderItem.BPOIExecTime=..ConvertToTimeH(saveObj.GetAt("BPOIExecTime"))
		s BPOrderItem.BPOIStatus="E"
		s patRegisterId=BPOrderItem.BPOIBPPatRegisterDr.%Id()
		s arcimId=BPOrderItem.BPOIArcimDr
		d BPOrderItem.%Save()
		d BPOrderItem.%Close()
	}
	q "S^操作成功"
Error
	q "E^"+$ze
}

ClassMethod CancelExcuteOrderItems(saveParam As %String) As %String
{
	s $zt="Error"
	s orderObj=..ToJsonObj(saveParam)
	s count=orderObj.Count()
	For i=1:1:count 
	{
     s saveObj=orderObj.GetAt(i)
	 s rowId=saveObj.GetAt("RowId")
	 q:rowId="" 
     s BPOrderItemObj=##class(User.DHCBPOrderItem).%OpenId(rowId) 	
	 s BPOrderItemObj.BPOIStatus=saveObj.GetAt("BPOIStatus")
	 s BPOrderItemObj.BPOICancelExecCtcpDr=saveObj.GetAt("BPOICancelExecCtcpDr")
	 s BPOrderItemObj.BPOICancelExecDate=+$h
	 s BPOrderItemObj.BPOICancelExecTime=$p($h,",",2)
	 d BPOrderItemObj.%Save()
	}
	q "S^操作成功"
Error
	q "E^"+$ze
}

ClassMethod CancelOEOrderItem(saveParam As %String)
{
	//s ^tempby("CancelOEOrderItem")=saveParam
	s $zt="Error"
	s orderObj=..ToJsonObj(saveParam)
	s count=orderObj.Count()
	For i=1:1:count {
		s saveObj=orderObj.GetAt(i)
		s RowId=saveObj.GetAt("RowId")
		s BPOrderItem=##class(User.DHCBPOrderItem).%OpenId(RowId)
		s BPOrderItem.BPOIXCtcpDr=saveObj.GetAt("BPOIXCtcpDr")
		s BPOrderItem.BPOIXDate=+$h
		s BPOrderItem.BPOIXTime=$p($h,",",2)
		s BPOrderItem.BPOIStatus="D"
		d BPOrderItem.%Save()
	}

	q "S^操作成功"
Error
	q "E^"+$ze
}

/// 
/// D ##class(%ResultSet).RunQuery("DHCBP.MedOrder","Find","2019/11/26","","27415","")
Query Find(fromDate As %String, toDate As %String, bpaId As %String, registerId As %String) As %Query(ROWSPEC = "oeordItemId,register,bpaId,orderType,arcimDr,arcimCode,arcimDesc,arcimAbbrev,Dose,DoseUnitDr,DoseUnitDesc,packQty,packUnitDr,packUnitDesc,freqDr,freqDesc,instructDr,instructDesc,startDate,startTime,status,note,masterSeqNo,seqNo,recLocDr,recLocDesc,durationDr,durationDesc,orderItemDr,createCtcpDr,createCtcpDesc,createDate,createTime,XCtcpDr,XCtcpDesc,XDate,XTime,execCtcpDr,execCtcpDesc,execDate,execTime,cancelCtcpDr,cancelCtcpDesc,cancelDate,cancelTime,price")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, bpaId As %String, registerId As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate) 
	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)
	;b ;003
	if (fromDate>toDate)
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	 
	}
	s bpaId=$g(bpaId)
	s registerId=$g(registerId)
	s schNode="DateRegister"
	s:bpaId'="" schNode="Arrange"
	s adm=""
	s:bpaId'="" adm=$lg(^DHCBPArrange(bpaId),2)
	if (schNode="Arrange")
	{
		s oeordItemId=0
		f  s oeordItemId=$o(^DHCBPOrderItem(0,schNode,bpaId,oeordItemId)) q:oeordItemId=""  d
		.s startDate=$lg(^DHCBPOrderItem(oeordItemId),11)
		.q:((fromDate'="")&&(toDate'=""))&&(startDate'="")&&((startDate<fromDate)||(startDate>toDate))
		.set Data=..GetBPOrderItemById(oeordItemId,adm)
		.Set ^CacheTemp(repid,ind)=Data
 		.Set qHandle=$lb(0,repid,0)
 		.Set ind=ind+1
	}
	else
	{
		f curDate=fromDate:1:toDate d
		.s oeordItemId=0
		.f  s oeordItemId=$o(^DHCBPOrderItem(0,schNode,curDate)) q:oeordItemId=""  d
		..set register=$lg(^DHCBPOrderItem(oeordItemId),1)
		..q:((registerId'="")&&(register'=registerId))
		..set Data=..GetBPOrderItemById(oeordItemId,adm)
 		..Set ^CacheTemp(repid,ind)=Data
 		..Set qHandle=$lb(0,repid,0)
 		..Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
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

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPArrangeSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetBPOrderItemById(oeordItemId As %String, adm As %String = "") As %List
{
	s oeoderItem=^DHCBPOrderItem(oeordItemId)
	s register=$lg(oeoderItem,1)
	s bpaId=$lg(oeoderItem,2)
	s orderType=$lg(oeoderItem,3)
	s arcimDr=$lg(oeoderItem,4)
	s arcimSub=$p(arcimDr,"||",1)
	s arcimVer=$p(arcimDr,"||",2)
	s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
	s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	s arcimAbbrev=$p(^ARCIM(arcimSub,arcimVer,1),"^",3)
	i 1[arcimAbbrev s arcimAbbrev=arcimDesc //缩写
	s Dose=$lg(oeoderItem,5) //剂量
	s DoseUnitDr=$lg(oeoderItem,6)
	s DoseUnitDesc=""
	s:DoseUnitDr'="" DoseUnitDesc=$ZCVT($p($g(^CT("UOM",+DoseUnitDr)),"^",2),"l")
	s packQty=$lg(oeoderItem,7)
	s packUnitDr=$lg(oeoderItem,8)
	s packUnitDesc=""
	s:packUnitDr'="" packUnitDesc=$ZCVT($p($g(^CT("UOM",+packUnitDr)),"^",2),"l")
	s freqDr=$lg(oeoderItem,9)
	s freqDesc=""
	s:freqDr'="" freqDesc=$p($g(^PHCFR(freqDr)),"^",4)
	s instructDr=$lg(oeoderItem,10)
	s instructDesc=""
	s:instructDr'="" instructDesc=$p($g(^PHCIN(instructDr)),"^",2)
	s:$l(instructDesc,"-")>1 instructDesc=$p(instructDesc,"-",2)
	s startDate=$lg(oeoderItem,11)
	s:startDate'="" startDate=$zd(startDate,3)
	s startTime=$lg(oeoderItem,12)
	s:startTime'="" startTime=$zt(startTime,4)
	s status=$lg(oeoderItem,13)
	s note=$lg(oeoderItem,14)
	s masterSeqNo=$lg(oeoderItem,15)
	s seqNo=$lg(oeoderItem,16)
	s recLocDr=$lg(oeoderItem,17)
	s recLocDesc=""
	s:recLocDr'="" recLocDesc=$P($g(^CTLOC(recLocDr)),"^",2)
	s durationDr=$lg(oeoderItem,18)
	s durationDesc="" 
	i durationDr'="" s durationDesc=$p(^PHCDU(durationDr),"^",1)
	s orderItemDr=$lg(oeoderItem,19)  //
	s createCtcpDr=$lg(oeoderItem,20)
	s createCtcpDesc=""
	s:createCtcpDr'="" createCtcpDesc=##class(web.DHCANOPCom).GetNameById(createCtcpDr) 
	s createDate=$lg(oeoderItem,21)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(oeoderItem,22)
	s:createTime'="" createTime=$zt(createTime,4)
	s XCtcpDr=$lg(oeoderItem,23)
	s XCtcpDesc=""
	s:XCtcpDr'="" XCtcpDesc=##class(web.DHCANOPCom).GetNameById(XCtcpDr) 
	s XDate=$lg(oeoderItem,24)
	s:XDate'="" XDate=$zd(XDate,3)
	s XTime=$lg(oeoderItem,25)
	s:XTime'="" XTime=$zt(XTime,4) //
	s execCtcpDr=$lg(oeoderItem,26)
	s execCtcpDesc=""
	s:execCtcpDr'="" execCtcpDesc=##class(web.DHCANOPCom).GetNameById(execCtcpDr)
	s execDate=$lg(oeoderItem,27)
	s:execDate'="" execDate=$zd(execDate,3)
	s execTime=$lg(oeoderItem,28)
	s:execTime'="" execTime=$zt(execTime,4)
	s cancelCtcpDr=$lg(oeoderItem,29)
	s cancelCtcpDesc=""
	s:cancelCtcpDr'="" cancelCtcpDesc=$P($g(^CTLOC(cancelCtcpDr)),"^",2)
	s cancelDate=$lg(oeoderItem,30)
	s cancelTime=$lg(oeoderItem,31)
	s:cancelDate'="" cancelDate=$zd(cancelDate,3)
	s:cancelTime'="" cancelTime=$zt(cancelTime,4)
	s price=""
	//s:adm'="" price=+##class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimDr,+$h,"","","","","","","^^"_adm)
	set Data=$lb(oeordItemId,register,bpaId,orderType,arcimDr,arcimCode,arcimDesc,arcimAbbrev,Dose,DoseUnitDr,DoseUnitDesc,packQty,packUnitDr,packUnitDesc,freqDr,freqDesc,instructDr,instructDesc,startDate,startTime,status,note,masterSeqNo,seqNo,recLocDr,recLocDesc,durationDr,durationDesc,orderItemDr,createCtcpDr,createCtcpDesc,createDate,createTime,XCtcpDr,XCtcpDesc,XDate,XTime,execCtcpDr,execCtcpDesc,execDate,execTime,cancelCtcpDr,cancelCtcpDesc,cancelDate,cancelTime,price)
	q Data
}

Query FindBPOrders(bpaId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select * from SQLUser.DHC_BP_OrderItem where BPOI_BPArrange_Dr=:bpaId
}

ClassMethod ModifyStatus(bpOrderId As %String, status As %String, ctcpId As %String)
{
	s $zt="Error"
	q:bpOrderId="" "E^医嘱ID为空"
	q:'##class(User.DHCBPOrderItem).%ExistsId(bpOrderId) "E^医嘱ID不存在"
	q:status="" "E^状态不能为空"
	q:((status'="V")&&(status'="E")&&(status'="D")) "E^医嘱状态不正确"_status
	s bpOrder=##class(User.DHCBPOrderItem).%OpenId(bpOrderId)
	s curStatus=bpOrder.BPOIStatus
	q:((status="V")&&(curStatus'="E")) "E^非执行状态医嘱不能撤销执行"
	s bpOrder.BPOIStatus=status
	i status="E" d
	.s bpOrder.BPOIExecCtcpDr=ctcpId
	.s bpOrder.BPOIExecDate=+$h
	.s bpOrder.BPOIExecTime=$p($h,",",2)
	i status="D"
	.s bpOrder.BPOIXCtcpDr=ctcpId
	.s bpOrder.BPOIXDate=+$h
	.s bpOrder.BPOIXTime=$p($h,",",2)
	i status="V" d
	.s bpOrder.BPOICancelExecCtcpDr=ctcpId
	.s bpOrder.BPOICancelExecDate=+$h
	.s bpOrder.BPOICancelExecTime=$p($h,",",2)
	d bpOrder.%Save()
	q "S^"
Error
	q "E^"+$ze
}

/// d ##class(%ResultSet).RunQuery("DHCBP.MedOrder","GetArcimList","","chs","","89")
Query GetArcimList(needItemCatId As %String, needArcimDesc As %String, arcimIdStr As %String = "", bpaId As %String = "") As %Query(ROWSPEC = "Desc:%String,Id:%String,Price:%String,UomId:%String,UomDesc:%String,Dose:%String")
{
}

ClassMethod GetArcimListExecute(ByRef qHandle As %Binary, needItemCatId As %String = "", needArcimDesc As %String = "", arcimIdStr As %String = "", bpaId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i (needItemCatId="")&&(needArcimDesc="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    i (needArcimDesc'="")
    {
	 s oriNeedArcimDesc=needArcimDesc
     s needArcimDesc=$$ALPHAUP^SSUTIL4(needArcimDesc)
    }
    s adm=""
    s:bpaId'="" adm=$lg(^DHCBPArrange(bpaId),2)
    
 	s arcimSub=0 
 	f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
	.s arcimVer=0 f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:arcimVer=""  d
	..s arcimId=arcimSub_"||"_arcimVer
	..q:(arcimIdStr'="")&&(arcimId'=arcimIdStr)
	..s aliasId="",aliasDesc=""
	..f  s aliasId=$O(^ARC("ALIAS",0,"ARCIM",arcimId,aliasId)) q:aliasId=""  d
	    ...i aliasDesc'="" s aliasDesc=aliasDesc_"^"
	    ...s aliasDesc=aliasDesc_$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..q:aliasDesc=""
	..//s aliasDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	..q:(needArcimDesc'="")&(("^"_aliasDesc_"^")'[("^"_needArcimDesc))&(arcimDesc'[oriNeedArcimDesc)
	..s itemcatDR=$p(^ARCIM(arcimSub,arcimVer,1),"^",10)
	..s equalUomInfo=##Class(web.DHCBPOrder).GetEqUomQty(arcimId)
	..s equalUomIdInfo=$p(equalUomInfo,"^",1)
	..s UomId=equalUomIdInfo
	..i $l(equalUomIdInfo,"|")>1 d
	...s UomId=$P(equalUomIdInfo,"|",1)
	..s UomDesc=$ZCVT($p($g(^CT("UOM",UomId)),"^",2),"l")
	..s defaultDoseInfo=$p(equalUomInfo,"^",2)
	..s Dose=defaultDoseInfo
	..i $l(defaultDoseInfo,"|")>1 d
	...s Dose=$P(defaultDoseInfo,"|",1)
	..s price=""
	..;b ;001
	..s:adm'="" price=+##class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,+$h,"","","","","","","^^"_adm)
	..i (+needItemCatId=0)!(+needItemCatId=itemcatDR) d OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(arcimDesc,arcimId,price,UomId,UomDesc,Dose)
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

/// d ##class(%ResultSet).RunQuery("DHCBP.MedOrder","FindLocation","")
Query FindLocation(filterDesc As %String, locList As %String = "E^O") As %SQLQuery(CONTAINID = 1)
{
 SELECT %Id As RowId,
 	CTLOC_COde As Code,
 	CTLOC_Desc As Description,
 	CTLOC_ActiveFlag As Active,
 	CTLOC_Type As Type
 	FROM SQLUser.CT_LOC
	WHERE ((UPPER(CTLOC_Desc) like UPPER('%'_:filterDesc_'%')) or (:filterDesc is null))
 	and (UPPER('^'_:locList) [ UPPER('^'||CTLOC_Type||'^'))
}

/// 疗程
/// d ##class(%ResultSet).RunQuery("DHCBP.MedOrder","FindPHCDuration")
Query FindPHCDuration() As %SQLQuery(CONTAINID = 1)
{
 SELECT PHCDU_RowId As RowId,
 	PHCDU_Code As Code,
 	PHCDU_Factor As Factor,
 	PHCDU_Desc1 As Description
 	FROM SQLUser.PHC_Duration
	WHERE (PHCDU_DateFrom<=+$H)
 	and (PHCDU_DateTo is null or PHCDU_DateTo>=+$H)
}

/// 单位
/// d ##class(%ResultSet).RunQuery("DHCBP.MedOrder","FindCTUom")
Query FindCTUom(filter As %String) As %SQLQuery(CONTAINID = 1)
{
 SELECT CTUOM_RowId As RowId,
 	CTUOM_Code As Code,
 	CTUOM_Desc As Description,
 	CTUOM_ForeignDesc As ForeignDesc
 	FROM SQLUser.CT_UOM
	WHERE ((UPPER(CTUOM_Desc)) like UPPER('%'_:filter_'%') or :filter is null)
}

/// 频次
/// d ##class(%ResultSet).RunQuery("DHCBP.MedOrder","FindPHCFreq")
Query FindPHCFreq(filter As %String) As %SQLQuery(CONTAINID = 1)
{
 SELECT PHCFR_RowId As RowId,
 	PHCFR_Code As Code,
 	PHCFR_Desc1 As Description,
 	PHCFR_Factor As Factor
 	FROM SQLUser.PHC_Freq
	WHERE ((UPPER(PHCFR_Desc1)) like UPPER('%'_:filter_'%') or :filter is null) and (PHCFR_ActiveFlag="Y")
}

/// 用法
/// d ##class(%ResultSet).RunQuery("DHCBP.MedOrder","FindPHCInstruc")
Query FindPHCInstruc(filter As %String) As %SQLQuery(CONTAINID = 1)
{
 SELECT PHCIN_RowId As RowId,
 	PHCIN_Code As Code,
 	PHCIN_Desc1 As Description
 	FROM SQLUser.PHC_Instruc
	WHERE ((UPPER(PHCIN_Desc1)) like UPPER('%'_:filter_'%') or :filter is null)
}

/*Query FindPHCInstruc(filter As %String) As %SQLQuery(CONTAINID = 1)
{
 SELECT PHCIN_RowId As RowId,
 	PHCIN_Code As Code,
 	PHCIN_Desc1 As Description
 	FROM SQLUser.PHC_Instruc
	WHERE ((UPPER(PHCIN_Desc1)) like UPPER('%'_:filter_'%') or :filter is null) and (PHCIN_ActiveFlag="Y")
}*/
/// 频次
/// d ##class(%ResultSet).RunQuery("DHCBP.MedOrder","GetFrequencyList","","")
Query GetFrequencyList(desc As %Library.String, admType As %Library.String = "") As %Library.Query(CONTAINID = 3, ROWSPEC = "ID,Code,Desc")
{
}

ClassMethod GetFrequencyListExecute(ByRef qHandle As %Library.Binary, desc As %Library.String, admType As %Library.String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i (desc="")&(admType="O") d
	.s desc="O"
	s resultSet=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpFrequency")
	d resultSet.Execute(desc,admType)
	;B ;001
	while(resultSet.Next())
	{
		s id=resultSet.GetData(5)
		s code=resultSet.GetData(2)
		s desc=resultSet.GetData(1)
		q:id=""
		d OutputFreq
	}
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

/// 用法
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

/// 2020-09-25^2020-12-25^0000000390^V^100152^147yh^S^119
/// d ##class(%ResultSet).RunQuery("DHCBP.MedOrder","FindBPOrder","2020-09-28","2021-1-8","0000000390","V","100152","147yh","S",119)
Query FindBPOrder(fromDate As %String, toDate As %String, regNo As %String = "", needBpoiStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", BPOrderType As %String, ctLoc As %String = "") As %Query(ROWSPEC = "Id,RegNo,PatName,Medicare,RegisterId,ArrangeId,BPOrderType,ArcimId,ArcimCode,ArcimDesc,ArcimAbbrev,Dose,DoseUnitId,DoseUnitDesc,PackQty,PackUnitId,PackUnitDesc,FreqId,FreqDesc,InstructId,InstructDesc,StartDate,StartTime,StartDateTime,Status,Note,MasterSeqNo,SeqNo,RecLocId,RecLocDesc,OrderItemDr,CreateCtcpId,CreateCtcpDesc,CreateDate,CreateTime,CreateDateTime,XCtcpId,XCtcpDesc,XDate,XTime,ExecCtcpDr,ExecCtcpDesc,ExecDate,ExecTime,CancelExecCtcpId,CancelExecCtcpDesc,CancelExecDate,CancelExecTime,DurationId,DurationDesc")
{
}

ClassMethod FindBPOrderExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", needBpoiStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", BPOrderType As %String, ctLoc As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
	//S ^TEMPBY("FindBPOrder")=fromDate_"^"_toDate_"^"_regNo_"^"_needBpoiStatus_"^"_papmiMedicare_"^"_papmiName_"^"_BPOrderType_"^"_ctLoc
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
			...q:bpprId=""
			...s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
			...q:(bpprPatLocationDr'="")&&(wardIdStr'="")&&(("^"_wardIdStr_"^")'[("^"_bpprPatLocationDr_"^"))
			...d GetBPOrder()

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetBPOrder()
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	k ^TMPBP("ORDER",$i)
	i BPOrderType="N" d
	.s bpoiId=""
	.f curDate=fromDate:1:toDate d
	..f  s bpoiId=$o(^DHCBPOrderItem(0,"DateRegister",curDate,bpprId,bpoiId)) q:bpoiId=""  d
	...s ^TMPBP("ORDER",$i,bpoiId)=""
	e  d
	.;b ;''
	.s bpoiId=""
	.f  s bpoiId=$o(^DHCBPOrderItem(0,"RegisterType",bpprId," "_BPOrderType,bpoiId)) q:bpoiId=""  d
	..;b ;id2
	..s ^TMPBP("ORDER",$i,bpoiId)=""
	
	s bpoiId=""
	f  s bpoiId=$o(^TMPBP("ORDER",$i,bpoiId)) q:bpoiId=""  d
	    
	    .s bpopBPPatRegisterDr=$li(^DHCBPOrderItem(bpoiId),1)
	    .s bpoiBPArrangeDr=$li(^DHCBPOrderItem(bpoiId),2)
	    .s bpoiOrderTypeCode=$li(^DHCBPOrderItem(bpoiId),3)
	    .q:bpoiOrderTypeCode'=BPOrderType
	    .s bpoiArcimDr=$li(^DHCBPOrderItem(bpoiId),4)
	    .q:bpoiArcimDr=""
	    .s arcimSub=$p(bpoiArcimDr,"||",1)
	    .s arcimVer=$p(bpoiArcimDr,"||",2)
	    .s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
	    .s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	    .s arcimAbbrev=$p(^ARCIM(arcimSub,arcimVer,1),"^",3)
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
	    .;b ;bpoiStartTime
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
	    .d OutputRow
	    k ^TMPBP("ORDER",$i)	    	
	q 0
OutputRow
	set Data=$lb(bpoiId,regNo,patName,papmiMedicare,bpopBPPatRegisterDr,bpoiBPArrangeDr,bpoiOrderTypeCode,bpoiArcimDr,arcimCode,arcimDesc,arcimAbbrev,bpoiDose,bpoiDoseUnitDr,bpoiDoseUnitDesc,bpoiPackQty,bpoiPackUnitDr,bpoiPackUnitDesc,bpoiFreqDr,bpoiFreqDesc,bpoiInstructDr,bpoiInstructDesc,bpoiStartDate,bpoiStartTime,bpoiStartDateTime,bpoiStatus,bpoiNote,bpoiMasterSeqNo,bpoiSeqNo,bpoiRecLocDr,bpoiRecLocDesc,bpoiOrderItemDr,bpoiCreateCtcpDr,bpoiCreateCtcpDesc,bpoiCreateDate,bpoiCreateTime,bpoiCreateDateTime,bpoiXCtcpDr,bpoiXCtcpDesc,bpoiXDate,bpoiXTime,bpoiExecCtcpDr,bpoiExecCtcpDesc,bpoiExecDate,bpoiExecTime,bpoiCancelExecCtcpDr,bpoiCancelExecCtcpDesc,bpoiCancelExecDate,bpoiCancelExecTime,bpoiDurationDr,bpoiDurationDesc)
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

ClassMethod StopBPOrderItems(rowId As %String, Status As %String, XCtcpDr As %String) As %String
{
	q:rowId="" "未选中医嘱"
	s BPOrderItemObj=""
    s BPOrderItemObj=##class(User.DHCBPOrderItem).%OpenId(rowId) 	
	s BPOrderItemObj.BPOIStatus=Status
	s BPOrderItemObj.BPOIXCtcpDr=XCtcpDr
	s BPOrderItemObj.BPOIXDate=+$h
	s BPOrderItemObj.BPOIXTime=$p($h,",",2)
	d BPOrderItemObj.%Save()
	s result=BPOrderItemObj.%Id()
	d BPOrderItemObj.%Close()
	q 0
}

/// d ##class(%ResultSet).RunQuery("DHCBP.MedOrder","FindBPOrderTemplet")
Query FindBPOrderTemplet() As %Query(ROWSPEC = "Id,RegNo,PatName,Medicare,RegisterId,ArrangeId,BPOrderType,ArcimId,ArcimCode,ArcimDesc,ArcimAbbrev,Dose,DoseUnitId,DoseUnitDesc,PackQty,PackUnitId,PackUnitDesc,FreqId,FreqDesc,InstructId,InstructDesc,StartDate,StartTime,StartDateTime,Status,Note,MasterSeqNo,SeqNo,RecLocId,RecLocDesc,OrderItemDr,CreateCtcpId,CreateCtcpDesc,CreateDate,CreateTime,CreateDateTime,XCtcpId,XCtcpDesc,XDate,XTime,ExecCtcpDr,ExecCtcpDesc,ExecDate,ExecTime,CancelExecCtcpId,CancelExecCtcpDesc,CancelExecDate,CancelExecTime,DurationId,DurationDesc,Price,OrderNum,GroupOrderNum,OrderGroup,ComposeOrderId,contactNameGroup,contactName")
{
}

ClassMethod FindBPOrderTempletExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPBPNUM("ORDER",$i)	
	k ^tempBP("FindBPOrderTemplet",$j)
	s tempbpoiId=""
	f  s tempbpoiId=$o(^DHCBPOrderItemTemplet(tempbpoiId)) q:tempbpoiId=""  d
	.q:tempbpoiId=0
	.s bpoiOrderTypeCode=$li(^DHCBPOrderItemTemplet(tempbpoiId),3)
	.s bpoiStatus=$lg($g(^DHCBPOrderItemTemplet(tempbpoiId)),13)
	.q:bpoiStatus="D"
	.s mainOrderId=$lg(^DHCBPOrderItemTemplet(tempbpoiId),32)
	.i mainOrderId'="" d
	..i $d(^TMPBPNUM("ORDER",$i,mainOrderId))<1 d
	...s ^TMPBPNUM("ORDER",$i,mainOrderId,0)=""
	...s ^TMPBPNUM("ORDER",$i,mainOrderId,tempbpoiId)=""
	..e  d
	...s ^TMPBPNUM("ORDER",$i,mainOrderId,tempbpoiId)=""
	.e  s ^TMPBPNUM("ORDER",$i,tempbpoiId,0)=""
	
	s OrderNum=0
	s mbpoiId=""
	f  s mbpoiId=$o(^TMPBPNUM("ORDER",$i,mbpoiId)) q:mbpoiId=""  d
	.q:mbpoiId=0
	.s tbpoiId="",GroupOrderNum=0,bpoiId="",tGroupOrderNum=""
	.f  s tbpoiId=$o(^TMPBPNUM("ORDER",$i,mbpoiId,tbpoiId)) q:tbpoiId=""  d
		..s bpoiId=tbpoiId
		..i tbpoiId=0 s bpoiId=mbpoiId
		..s OrderGroup=""
		..s regNo="",papmiMedicare="",patName="",ComposeOrderId=""
	    ..s bpopBPPatRegisterDr=$lg(^DHCBPOrderItemTemplet(bpoiId),1)
	    ..s bpoiBPArrangeDr=$lg(^DHCBPOrderItemTemplet(bpoiId),2)
	    ..s bpoiOrderTypeCode=$lg(^DHCBPOrderItemTemplet(bpoiId),3)
	    ..;q:bpoiOrderTypeCode'=BPOrderType
	    ..s bpoiArcimDr=$lg(^DHCBPOrderItemTemplet(bpoiId),4)
	    ..s arcimSub=$p(bpoiArcimDr,"||",1)
	    ..s arcimVer=$p(bpoiArcimDr,"||",2)
	    ..s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
	    ..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	    ..s arcimAbbrev=$p(^ARCIM(arcimSub,arcimVer,1),"^",3)
	    ..i 1[arcimAbbrev s arcimAbbrev=arcimDesc
	    ..s bpoiDose=$lg(^DHCBPOrderItemTemplet(bpoiId),5)
	    ..s bpoiDoseUnitDr=$lg(^DHCBPOrderItemTemplet(bpoiId),6)
	    ..s bpoiDoseUnitDesc=""
	    ..i bpoiDoseUnitDr'="" d
	    ...s bpoiDoseUnitDesc=$ZCVT($p($g(^CT("UOM",+bpoiDoseUnitDr)),"^",2),"l")
	    ..s bpoiPackQty=$lg(^DHCBPOrderItemTemplet(bpoiId),7)
	    ..s bpoiPackUnitDr=$lg(^DHCBPOrderItemTemplet(bpoiId),8)
	    ..s bpoiPackUnitDesc=""
	    ..i bpoiPackUnitDr'="" d
	    ..s bpoiPackUnitDesc=$ZCVT($p($g(^CT("UOM",+bpoiPackUnitDr)),"^",2),"l")
	    ..s bpoiFreqDr=$lg(^DHCBPOrderItemTemplet(bpoiId),9)
	    ..s bpoiFreqDesc=""
	    ..i bpoiFreqDr'="" d
	    ...s bpoiFreqDesc=$p($g(^PHCFR(bpoiFreqDr)),"^",4)
	    ..s bpoiInstructDr=$lg(^DHCBPOrderItemTemplet(bpoiId),10)
	    ..s bpoiInstructDesc=""
	    ..i bpoiInstructDr'="" d
	    ...s bpoiInstructDesc=$p($g(^PHCIN(bpoiInstructDr)),"^",2)
	    ..i $l(bpoiInstructDesc,"-")>1 d
	    ...s bpoiInstructDesc=$p(bpoiInstructDesc,"-",2)
	    ..s bpoiStartDate=$lg(^DHCBPOrderItemTemplet(bpoiId),11)
	    ..i bpoiStartDate'="" d
	    ...s bpoiStartDate=$zd(bpoiStartDate,3)
	    ..s bpoiStartTime=$lg(^DHCBPOrderItemTemplet(bpoiId),12)
	    ..i bpoiStartTime'="" d
	    ...s bpoiStartTime=$zt(bpoiStartTime,4)
	    ..;b ;bpoiStartTime
	    ..s bpoiStartDateTime=""
	    ..i bpoiStartDate'="" s bpoiStartDateTime=bpoiStartDate
	    ..i bpoiStartTime'="" s bpoiStartDateTime=bpoiStartDate_" "_bpoiStartTime
	    ..s bpoiStatus=$lg($g(^DHCBPOrderItemTemplet(bpoiId)),13)
	    ..s bpoiNote=$lg(^DHCBPOrderItemTemplet(bpoiId),14)
	    ..s bpoiMasterSeqNo=$lg(^DHCBPOrderItemTemplet(bpoiId),15)
	    ..s bpoiSeqNo=$lg(^DHCBPOrderItemTemplet(bpoiId),16)
	    ..s bpoiRecLocDr=$lg(^DHCBPOrderItemTemplet(bpoiId),17)
	    ..s bpoiRecLocDesc=""
	    ..i bpoiRecLocDr'="" d
	    ...s bpoiRecLocDesc=$P($g(^CTLOC(bpoiRecLocDr)),"^",2) 
	    ..s bpoiDurationDr=$lg(^DHCBPOrderItemTemplet(bpoiId),18)
	    ..s bpoiDurationDesc="" 
	    ..i bpoiDurationDr'="" s bpoiDurationDesc=$p(^PHCDU(bpoiDurationDr),"^",1)
	    ..s bpoiOrderItemDr=$lg(^DHCBPOrderItemTemplet(bpoiId),19)
	    ..s bpoiCreateCtcpDr=$lg(^DHCBPOrderItemTemplet(bpoiId),20)
	    ..s bpoiCreateCtcpDesc=""
	    ..i bpoiCreateCtcpDr'="" s bpoiCreateCtcpDesc=##class(web.DHCANOPCom).GetNameById(bpoiCreateCtcpDr) 
	    ..s bpoiCreateDate=$lg(^DHCBPOrderItemTemplet(bpoiId),21)
	    ..i bpoiCreateDate'="" d
	    ...s bpoiCreateDate=$zd(bpoiCreateDate,3)
	    ..s bpoiCreateTime=$lg(^DHCBPOrderItemTemplet(bpoiId),22)
	    ..i bpoiCreateTime'="" d
	    ...s bpoiCreateTime=$zt(bpoiCreateTime,4)
	    ..s bpoiCreateDateTime=""
	    ..i bpoiCreateDate'="" s bpoiCreateDateTime=bpoiCreateDate
	    ..i bpoiCreateTime'="" s bpoiCreateDateTime=bpoiCreateDate_" "_bpoiCreateTime
	    ..s bpoiXCtcpDr=$lg(^DHCBPOrderItemTemplet(bpoiId),23)
	    ..s bpoiXCtcpDesc=""
	    ..i bpoiXCtcpDr'="" d
	    ...s bpoiXCtcpDesc=##class(web.DHCBPCom).GetNameById(bpoiXCtcpDr) 
	    ..s bpoiXDate=$lg(^DHCBPOrderItemTemplet(bpoiId),24)
	    ..i bpoiXDate'="" d
	    ...s bpoiXDate=$zd(bpoiXDate,3)
	    ..s bpoiXTime=$lg(^DHCBPOrderItemTemplet(bpoiId),25)
	    ..i bpoiXTime'="" d
	    ...s bpoiXTime=$zt(bpoiXTime,4)
	    ..s bpoiExecCtcpDr=$lg(^DHCBPOrderItemTemplet(bpoiId),26)
	    ..s bpoiExecCtcpDesc=##class(web.DHCBPCom).GetNameById(bpoiExecCtcpDr)
	    ..s bpoiExecDate=$lg(^DHCBPOrderItemTemplet(bpoiId),27)
	    ..i bpoiExecDate'="" d
	    ...s bpoiExecDate=$zd(^DHCBPOrderItemTemplet,3)
	    ..s bpoiExecTime=$lg(^DHCBPOrderItemTemplet(bpoiId),28)
	    ..i bpoiExecTime'="" d
	    ...s bpoiExecTime=$zt(bpoiExecTime,4)
	    ..s bpoiCancelExecCtcpDr=$lg(^DHCBPOrderItemTemplet(bpoiId),29)
	    ..s bpoiCancelExecCtcpDesc=##class(web.DHCBPCom).GetNameById(bpoiCancelExecCtcpDr)
	    ..s bpoiCancelExecDate=$lg(^DHCBPOrderItemTemplet(bpoiId),30)
	    ..i bpoiCancelExecDate'="" d
	    ...s bpoiCancelExecDate=$zd(bpoiCancelExecDate,3)
	    ..s bpoiCancelExecTime=$lg(^DHCBPOrderItemTemplet(bpoiId),31)
	    ..i bpoiCancelExecTime'="" d
	    ...s bpoiCancelExecTime=$zt(bpoiCancelExecTime,4)
	    ..q:bpoiStatus="D"
	    ..s bpoiPrice=##Class(web.DHCDocOrderEntry).GetOrderPrice("","",bpoiArcimDr,$zdh(bpoiStartDate,3),"","","","")
	    ..s ComposeOrderId=$lg(^DHCBPOrderItemTemplet(bpoiId),32)
	    ..i $lg(^DHCBPOrderItemTemplet(bpoiId),32)'="" d
	    ...i tGroupOrderNum="" s GroupOrderNum=OrderNum,tGroupOrderNum=OrderNum
	    ...e  s GroupOrderNum=tGroupOrderNum
	    ..s OrderNum=OrderNum+1
	    ..s aliasRowId="",contactNameGroup="",contactName=""
	    ..f  s aliasRowId=$o(^ARC("ALIAS",0,"ARCIM",bpoiArcimDr,aliasRowId)) q:aliasRowId=""  d
	    ...s contactNameGroup=$e($p(^ARC("ALIAS",aliasRowId),"^",6),1)
	    ...q:+contactNameGroup'=0
	    ...s contactName=$p(^ARC("ALIAS",aliasRowId),"^",6)
	    ...q:$d(^tempBP("FindBPOrderTemplet",$j,contactNameGroup,bpoiId))>0
	    ...s ^tempBP("FindBPOrderTemplet",$j,contactNameGroup,bpoiId)=$lb(bpoiId,regNo,patName,papmiMedicare,bpopBPPatRegisterDr,bpoiBPArrangeDr,bpoiOrderTypeCode,bpoiArcimDr,arcimCode,arcimDesc,arcimAbbrev,bpoiDose,bpoiDoseUnitDr,bpoiDoseUnitDesc,bpoiPackQty,bpoiPackUnitDr,bpoiPackUnitDesc,bpoiFreqDr,bpoiFreqDesc,bpoiInstructDr,bpoiInstructDesc,bpoiStartDate,bpoiStartTime,bpoiStartDateTime,bpoiStatus,bpoiNote,bpoiMasterSeqNo,bpoiSeqNo,bpoiRecLocDr,bpoiRecLocDesc,bpoiOrderItemDr,bpoiCreateCtcpDr,bpoiCreateCtcpDesc,bpoiCreateDate,bpoiCreateTime,bpoiCreateDateTime,bpoiXCtcpDr,bpoiXCtcpDesc,bpoiXDate,bpoiXTime,bpoiExecCtcpDr,bpoiExecCtcpDesc,bpoiExecDate,bpoiExecTime,bpoiCancelExecCtcpDr,bpoiCancelExecCtcpDesc,bpoiCancelExecDate,bpoiCancelExecTime,bpoiDurationDr,bpoiDurationDesc,bpoiPrice,OrderNum,GroupOrderNum,OrderGroup,ComposeOrderId,contactNameGroup,contactName)
	    
	    s contactNameGroup=""
	    f  s contactNameGroup=$o(^tempBP("FindBPOrderTemplet",$j,contactNameGroup)) q:contactNameGroup=""  d
	    .s bpoiId=""
	    .f  s bpoiId=$o(^tempBP("FindBPOrderTemplet",$j,contactNameGroup,bpoiId)) q:bpoiId=""  d
	    ..d OutputRow7

	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
	
OutputRow7
	set Data=^tempBP("FindBPOrderTemplet",$j,contactNameGroup,bpoiId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindBPOrderTempletFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPOrderExecute ]
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

ClassMethod FindBPOrderTempletClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(DHCBP.MedOrder).SaveBPOrderItemTemplet(^tempby("SaveBPOrderItemTemplet"))
ClassMethod SaveBPOrderItemTemplet(saveParam As %String)
{
	//s ^tempby("SaveBPOrderItemTemplet")=saveParam
	s $zt="Error"
	s saveObj=..ToJsonObj(saveParam)
	s count=saveObj.Count()
	For i=1:1:count {
		s order=saveObj.GetAt(i)
		s RowId=order.GetAt("RowId")
		s registerId=order.GetAt("BPOIregisterId")
		s createCtcpDr=order.GetAt("BPOICreateCtcpDr")
		s BPOrderItemTemplet=##class(User.DHCBPOrderItemTemplet).%OpenId($e(RowId,2))
		s BPOrderItem=##class(User.DHCBPOrderItem).%New()
		d BPOrderItem.BPOIBPPatRegisterDrSetObjectId(registerId)
		s BPOrderItem.BPOIOrderType="S"
		s BPOrderItem.BPOIArcimDr=BPOrderItemTemplet.BPOITArcimDr
		s BPOrderItem.BPOIDose=BPOrderItemTemplet.BPOITDose
		s BPOrderItem.BPOIStatus=BPOrderItemTemplet.BPOITStatus
		s BPOrderItem.BPOIDoseUnitDr=BPOrderItemTemplet.BPOITDoseUnitDr
		s BPOrderItem.BPOIPackQty=BPOrderItemTemplet.BPOITPackQty
		s BPOrderItem.BPOIPackUnitDr=BPOrderItemTemplet.BPOITPackUnitDr
		s BPOrderItem.BPOIFreqDr=BPOrderItemTemplet.BPOITFreqDr
		s BPOrderItem.BPOIInstructDr=BPOrderItemTemplet.BPOITInstructDr
		s BPOrderItem.BPOIStartDate=##class(web.DHCANOPCom).ConvertToDateH(+$h)  
		s BPOrderItem.BPOIStartTime=##class(web.DHCANOPCom).ConvertToTimeH($p($h,",","2")) 
		s BPOrderItem.BPOIStatus=BPOrderItemTemplet.BPOITStatus
		s BPOrderItem.BPOINote=BPOrderItemTemplet.BPOITNote
		s BPOrderItem.BPOIMasterSeqNo=BPOrderItemTemplet.BPOITMasterSeqNo
		s BPOrderItem.BPOISeqNo=BPOrderItemTemplet.BPOITSeqNo
		s BPOrderItem.BPOIRecLocDr=BPOrderItemTemplet.BPOITRecLocDr
		s BPOrderItem.BPOIDurationDr=BPOrderItemTemplet.BPOITDurationDr
		s BPOrderItem.BPOIOrderItemDr=BPOrderItemTemplet.BPOITOrderItemDr
		s BPOrderItem.BPOICreateCtcpDr=createCtcpDr
		s BPOrderItem.BPOICreateDate=+$H //##class(web.DHCANOPCom).ConvertToDateH(saveObj.BPOICreateDate) 
		s BPOrderItem.BPOICreateTime=$p($H,",",2) //##class(web.DHCANOPCom).ConvertToTimeH(saveObj.BPOICreateTime) 
		
		d BPOrderItem.%Save()
	}
	q "S^保存成功"
Error
	s ^tmptxtxtxaaa="123"_$ze
	q "E^"+$ze
}

}
