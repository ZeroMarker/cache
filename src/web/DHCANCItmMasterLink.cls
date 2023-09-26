/// 创 建 者：陈长青
/// 描    述：常用医嘱关联HIS医嘱项，麻醉方法关联HIS医嘱项，事件关联HIS医嘱项web类
/// 创建日期：2015年3月16日
Class web.DHCANCItmMasterLink Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      	陈长青
/// CreatDate：    	2015-03-16
/// Description： 	获取常用医嘱关联HIS医嘱项，麻醉方法关联HIS医嘱项，事件关联HIS医嘱项
/// Table：        	DHC_ANC_ItmMasterLink
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANCItmMasterLink","FindItemMasterLink")
Query FindItemMasterLink() As %Query(ROWSPEC = "Id,ArcimId,ArcimDesc,ArcosId,ArcosDesc,CommonOrdId,CommonOrdDesc,AnaestMethodId,AnaestMethodDesc,EventDetailCode,EventDetailValue,Available,DateFrom,DateTo") [ SqlProc ]
{
}

ClassMethod FindItemMasterLinkExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set itmMasterLinkId=0 f  set itmMasterLinkId=$order(^DHCANC("IMLink",itmMasterLinkId)) quit:(itmMasterLinkId="")  d
		.set itmMasterLinkInfo=^DHCANC("IMLink",itmMasterLinkId)
		.// 医嘱项ID
		.set arcimId=$list(itmMasterLinkInfo,1)
		.set arcimDesc=""
		.if (arcimId'="") d
			..set arcimSub=+arcimId,arcimVer=$piece(arcimId,"||",2)
			..q:arcimVer=""
			..set arcimDesc=$piece($g(^ARCIM(arcimSub,arcimVer,1)),"^",2)	
		.// 医嘱套ID
		.set arcosId=$list(itmMasterLinkInfo,2)
		.set arcosDesc=""
		.if (+arcosId>0) d
			..set arcosDesc=$piece($get(^ARCOS(arcosId)),"^",2)	
		.// 常用医嘱ID
		.set commonOrdId=$list(itmMasterLinkInfo,3)
		.set commonOrdDesc=""
		.if (+commonOrdId>0) d
			..set commonOrdDesc=$piece($get(^DHCANC("ComOrd",commonOrdId)),"^",2)			
		.// 麻醉方法ID
		.set anaestMethodId=$list(itmMasterLinkInfo,4)
		.set anaestMethodDesc=""
		.if (+anaestMethodId>0) d
			..set anaestMethodDesc=$piece($get(^ORC("ANMET",anaestMethodId)),"^",2)	
		.// 事件明细项代码
		.set eventDetailCode=$list(itmMasterLinkInfo,5)
		.// 事件明细项值
		.set eventDetailValue=$list(itmMasterLinkInfo,6)
		.// 是否可用
		.set available=$list(itmMasterLinkInfo,7)
		.;q:(available'="Y")
		.set today=+$horolog
		.// 开始日期
		.set dateFrom=$list(itmMasterLinkInfo,8)
		.;q:(today<dateFrom)
		.set dateFrom=##class(web.DHCClinicCom).ConvertToDate(dateFrom)
		.// 结束日期
		.set dateTo=$list(itmMasterLinkInfo,9)
		.;q:(dateTo'="")&(today>+dateTo)
		.if (+dateTo>0) set dateTo=##class(web.DHCClinicCom).ConvertToDate(dateTo)
		.else  set dateTo=""	
		.do OutputRow
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
 	Set Data=$lb(itmMasterLinkId,arcimId,arcimDesc,arcosId,arcosDesc,commonOrdId,commonOrdDesc,anaestMethodId,anaestMethodDesc,eventDetailCode,eventDetailValue,available,dateFrom,dateTo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindItemMasterLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemMasterLinkExecute ]
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

ClassMethod FindItemMasterLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemMasterLinkExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2015-03-16
/// Description： 	保存麻醉关联HIS医嘱项(套)
/// Table：        	DHC_ANC_ItmMasterLink
/// Input:			
/// Return：       	保存成功与否
/// w ##class(web.DHCANCItmMasterLink).SaveItmMasterLink()
ClassMethod SaveItmMasterLink(linkId, arcimId, arcosId, commonOrdId, anaMethodId, eventDetailCode, eventDetailValue, available, dateFrom, dateTo) As %String [ SqlProc ]
{
	set itmMasterLink=""
	if (+linkId>0)
	{
		set itmMasterLink=##class(User.DHCANCItmMaterLink).%OpenId(linkId)	
	}
	else
	{
		set itmMasterLink=##class(User.DHCANCItmMaterLink).%New()	
	}
	
	set itmMasterLink.ANCIMARCIMDr=arcimId
	set itmMasterLink.ANCIMARCOSDr=arcosId
	if (##class(User.DHCANCCommonOrd).%ExistsId(commonOrdId))
	{
		set itmMasterLink.ANCIMComOrdDr=##class(User.DHCANCCommonOrd).%OpenId(commonOrdId)	
	}
	set itmMasterLink.ANCIMAnaMethodDr=anaMethodId
	set itmMasterLink.ANCIMEventDetailCode=eventDetailCode
	set itmMasterLink.ANCIMEventDetailValue=eventDetailValue
	set itmMasterLink.ANCIMAvailable=available
	set itmMasterLink.ANCIMDateFrom=##class(web.DHCANOPCom).ConvertToDateH(dateFrom)
	if (+dateTo>0)
	{
		set itmMasterLink.ANCIMDateTo=##class(web.DHCANOPCom).ConvertToDateH(dateTo)	
	}
	set status=itmMasterLink.%Save()
	set result="0"
	if ($System.Status.IsError(status))
	{
		set result=$SYSTEM.Status.GetErrorText(status)	
	}
	quit result
}

}
