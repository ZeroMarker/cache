Class web.DHCBL.CARD.DHCTimeRange Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 删除DHCTimeRange
ClassMethod DHCTimeRangeDelete(DHCTimeRangeInfo As web.DHCEntity.PCA.DHCTimeRange) As %String
{
 TStart
 set sc= ##class(User.DHCTimeRange).%DeleteId(DHCTimeRangeInfo.ID)

 If $$$ISERR(sc) {
 Do $System.Status.DisplayError()
 Trollback
 Quit -100
 }
 TCommit
 quit 0
}

/// 新增DHCTimeRange
ClassMethod DHCTimeRangeInsert(DHCTimeRangeInfo As web.DHCEntity.PCA.DHCTimeRange, HospID = "") As %String
{
 s outcode=DHCTimeRangeInfo.TRCode
 s outName=DHCTimeRangeInfo.TRDesc
 s mycount=0
 s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
 s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_TimeRange",HospID)
 &sql(SELECT count(*) INTO :mycount   
 FROM  sqluser.DHC_TimeRange
 WHERE (sqluser.DHC_TimeRange.TR_Code = :outcode ) OR (sqluser.DHC_TimeRange.TR_Desc=:outName))
 if (mycount'=0)
 {	  
	 Quit 10
 }
 else
 {
	 TStart
	 //s ^yjm("in")=code_"|"_desc
 set object=##class(User.DHCTimeRange).%New()
 //s ^yjm("startdate")=DHCTimeRangeInfo.TRDesc_"|"_DHCTimeRangeInfo.TRCode_"|"_DHCTimeRangeInfo.TRCancelTime_"|"_DHCTimeRangeInfo.TRValidEndDate
 set object.TRCancelTime=$ZTIMEH(DHCTimeRangeInfo.TRCancelTime)

 set object.TRCode=DHCTimeRangeInfo.TRCode

 set object.TRDesc=DHCTimeRangeInfo.TRDesc

 set object.TREndTime=$ZTIMEH(DHCTimeRangeInfo.TREndTime)

 set object.TRReturnTime=$ZTIMEH(DHCTimeRangeInfo.TRReturnTime)

 set object.TRStartTime=$ZTIMEH(DHCTimeRangeInfo.TRStartTime)

 if (DHCTimeRangeInfo.TRValidEndDate'="")
 {
 set object.TRValidEndDate=..%ZDH(DHCTimeRangeInfo.TRValidEndDate) //$zdh(DHCTimeRangeInfo.TRValidEndDate,4)
 }
 else
 {
	    set object.TRValidEndDate=""
 }

 if (DHCTimeRangeInfo.TRValidStartDate'="")
 {
 set object.TRValidStartDate=..%ZDH(DHCTimeRangeInfo.TRValidStartDate) //$zdh(DHCTimeRangeInfo.TRValidStartDate,4)
 }
 
 if ($tr(DHCTimeRangeInfo.TRRegSTTime," ","")'=""){
 	set object.TRRegSTTime=$ZTIMEH(DHCTimeRangeInfo.TRRegSTTime)
 }
 
 if ($tr(DHCTimeRangeInfo.TRRegEndTime," ","")'=""){
 	set object.TRRegEndTime=$ZTIMEH(DHCTimeRangeInfo.TRRegEndTime)
 }
 
 set object.TRAllowSpaceReturnDay=DHCTimeRangeInfo.AllowSpaceReturnDay

 set object.TRCheckin=DHCTimeRangeInfo.TRCheckin
 
 set sc=object.%Save()
 If $$$ISERR(sc) 
 {
	   Do $System.Status.DisplayError()
	   Trollback
	   Quit -100
 } 
 TCommit
 d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHC_TimeRange",object.%Id(),HospID)
 quit object.%Id()
 }
}

/// 更新DHCTimeRange
ClassMethod DHCTimeRangeUpdate(DHCTimeRangeInfo As web.DHCEntity.PCA.DHCTimeRange) As %String
{
 s outcode=DHCTimeRangeInfo.TRCode
 s outName=DHCTimeRangeInfo.TRDesc
 s outid=DHCTimeRangeInfo.ID
 s mycount=0
 &sql(SELECT count(*) INTO :mycount   
 FROM  sqluser.DHC_TimeRange
 WHERE ((sqluser.DHC_TimeRange.TR_Code = :outcode ) OR (sqluser.DHC_TimeRange.TR_Desc=:outName)) and sqluser.DHC_TimeRange.TR_RowId<>:outid) 
 if (mycount'=0)
 {	  
	 Quit 10
 }
 TStart
 set object=##class(User.DHCTimeRange).%OpenId(DHCTimeRangeInfo.ID)

 set object.TRCode=DHCTimeRangeInfo.TRCode

 set object.TRDesc=DHCTimeRangeInfo.TRDesc

 set object.TREndTime=$ZTIMEH(DHCTimeRangeInfo.TREndTime)

 set object.TRReturnTime=$ZTIMEH(DHCTimeRangeInfo.TRReturnTime)

 set object.TRStartTime=$ZTIMEH(DHCTimeRangeInfo.TRStartTime)

 set object.TRCancelTime=$ZTIMEH(DHCTimeRangeInfo.TRCancelTime)


 if (DHCTimeRangeInfo.TRValidEndDate'="")
 {
	  
 	set object.TRValidEndDate=..%ZDH(DHCTimeRangeInfo.TRValidEndDate) //$zdh(DHCTimeRangeInfo.TRValidEndDate,4)

 }
 else
 {
	  set object.TRValidEndDate=""
 }

 if (DHCTimeRangeInfo.TRValidStartDate'="")
 {
 set object.TRValidStartDate=..%ZDH(DHCTimeRangeInfo.TRValidStartDate) //$zdh(DHCTimeRangeInfo.TRValidStartDate,4)
 }
 
 if ($tr(DHCTimeRangeInfo.TRRegSTTime," ","")'=""){
 	set object.TRRegSTTime=$ZTIMEH(DHCTimeRangeInfo.TRRegSTTime)
 }else{
	set object.TRRegSTTime=""
 }
 
 if ($tr(DHCTimeRangeInfo.TRRegEndTime," ","")'=""){
 	set object.TRRegEndTime=$ZTIMEH(DHCTimeRangeInfo.TRRegEndTime)
 }else{
	set object.TRRegEndTime=""
 }
 set object.TRAllowSpaceReturnDay=DHCTimeRangeInfo.AllowSpaceReturnDay

 set object.TRCheckin=DHCTimeRangeInfo.TRCheckin
	
 set sc=object.%Save()
 If $$$ISERR(sc) 
 {
 Do $System.Status.DisplayError()
 Trollback
 Quit -100
 }
 TCommit
 quit object.%Id()
}

Query DHCTimeRangeQuery(TRCode As %String, TRDesc As %String) As %SQLQuery(CONTAINID = 1)
{
	
 select %ID AS TID,{fn CONVERT(sqluser.DHC_TimeRange.TR_CancelTime,SQL_VARCHAR)} AS TTRCancelTime,
 sqluser.DHC_TimeRange.TR_Code AS TTRCode,
 sqluser.DHC_TimeRange.TR_Desc AS TTRDesc,
 {fn CONVERT(sqluser.DHC_TimeRange.TR_EndTime,SQL_VARCHAR)} AS TTREndTime,
 {fn CONVERT(sqluser.DHC_TimeRange.TR_AppReturnTime,SQL_VARCHAR)} AS TTRReturnTime,
 {fn CONVERT(sqluser.DHC_TimeRange.TR_StartTime,SQL_VARCHAR)} AS TTRStartTime,
 {fn CONVERT(sqluser.DHC_TimeRange.TR_ValidEndDate,SQL_Date)} AS TRValidEndDate,
 {fn CONVERT(sqluser.DHC_TimeRange.TR_ValidStartDate,SQL_Date)} AS TTRValidStartDate,
 {fn CONVERT(sqluser.DHC_TimeRange.TR_RegSTTime,SQL_VARCHAR)} AS TTRRegSTTime,
 {fn CONVERT(sqluser.DHC_TimeRange.TR_RegEndTime,SQL_VARCHAR)} AS TTRRegEndTime,
 sqluser.DHC_TimeRange.TR_AllowSpaceReturnDay AS TRAllowSpaceReturnDay,
 sqluser.DHC_TimeRange.TR_Checkin AS TRCheckin
 from sqluser.DHC_TimeRange
 WHERE (sqluser.DHC_TimeRange.TR_Code %STARTSWITH :TRCode) AND (sqluser.DHC_TimeRange.TR_Desc %STARTSWITH :TRDesc) Order by sqluser.DHC_TimeRange.TR_Code
}

Query QueryTimeRange(TRCode As %String, TRDesc As %String, HospID = "") As %Query(ROWSPEC = "TID,TTRCode,TTRDesc,TTRStartTime,TTREndTime,TTRReturnTime,TTRCancelTime,TTRValidStartDate,TRValidEndDate,TTRRegSTTime,TTRRegEndTime,TRAllowSpaceReturnDay,TRCheckin")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCBL.CARD.DHCTimeRange","QueryTimeRange")
ClassMethod QueryTimeRangeExecute(ByRef qHandle As %Binary, TRCode As %String = "", TRDesc As %String = "", HospID = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s TID=0 f  s TID=$O(^DHCTimeRange(TID)) Q:TID=""  d
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_TimeRange",TID,HospID)
	.s str=^DHCTimeRange(TID)
	.s TTRCode=$P(str,"^",1)
	.q:(TRCode'="")&&(TTRCode'[TRCode)
	.s TTRDesc=$P(str,"^",2)
	.q:(TRDesc'="")&&(TTRDesc'[TRDesc)
	.s TTRStartTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",3))
	.s TTREndTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",4))
	.s TTRReturnTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",5))
	.s TTRCancelTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",6))
	.s TTRValidStartDate=..%ZD($P(str,"^",7))
	.s TRValidEndDate=..%ZD($P(str,"^",8))
	.s TTRRegSTTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",9))
	.s TTRRegEndTime=##class(websys.Conversions).TimeLogicalToHtml($P(str,"^",10))
	.s TRAllowSpaceReturnDay=$P(str,"^",11)
	.s TRCheckin=$P(str,"^",12)
	.s qHandle(" "_TTRCode,TID)=$LB(TID,TTRCode,TTRDesc,TTRStartTime,TTREndTime,TTRReturnTime,TTRCancelTime,TTRValidStartDate,TRValidEndDate,TTRRegSTTime,TTRRegEndTime,TRAllowSpaceReturnDay,TRCheckin)
	Quit $$$OK
}

ClassMethod QueryTimeRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTimeRangeExecute ]
{
	s node1=$O(qHandle(""))
	if node1'=""{
		s node2=$O(qHandle(node1,""))
		if node2'=""{
			s Row=qHandle(node1,node2)
			k qHandle(node1,node2)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

}
