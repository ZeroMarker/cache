Class CIS.AN.BL.OperAduitAccredit Extends %RegisteredObject
{

/// Creator: 唐潇
/// CreatDate: 2020-04-13
/// Description: 根据科室查询科主任授权信息
/// Table：
/// Input：deptID
/// Return：ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperAduitAccredit","FindAduitAccreditList","","ys01","","")
Query FindAduitAccreditList(deptID As %String = "") As %Query(ROWSPEC = "RowId,AccreditLocation,AccreditCareProv,AccreditStartDate,AccreditStartTime,AccreditEndDate,AccreditEndTime,CreatedUser,CreatedDate,CreatedTime,AccreditLocationDesc,AccreditCareProvDesc,CreatedUserDesc") [ SqlProc ]
{
}

ClassMethod FindAduitAccreditListExecute(ByRef qHandle As %Binary, deptID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s deptID=$g(deptID)
	if ((deptID'="")&&('##class(User.CTLoc).%ExistsId(deptID)))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	if (deptID="") //空，查所有
	{
		s OperAduitAccreditID=0
		f  s OperAduitAccreditID=$o(^CF.AN.OperAduitAccreditD(OperAduitAccreditID)) q:OperAduitAccreditID=""  d
		.b ;002
		.s OperAduitAccreditData=^CF.AN.OperAduitAccreditD(OperAduitAccreditID)
		.s AccreditLocation=$lg(OperAduitAccreditData,1)
		.s AccreditCareProv=$lg(OperAduitAccreditData,2)
		.s AccreditStartDate=$lg(OperAduitAccreditData,3)
		.s AccreditStartTime=$lg(OperAduitAccreditData,4)
		.s AccreditEndDate=$lg(OperAduitAccreditData,5)
		.s AccreditEndTime=$lg(OperAduitAccreditData,6)
		.s CreatedUser=$lg(OperAduitAccreditData,7)
		.s CreatedDate=$lg(OperAduitAccreditData,8)
		.s CreatedTime=$lg(OperAduitAccreditData,9)
		.q:(AccreditEndDate'="")&&(AccreditEndDate<(+$h+1))
		.s AccreditLocationDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",AccreditLocation)
		.s AccreditCareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",AccreditCareProv)
		.s:AccreditStartDate'="" AccreditStartDate=$zd(AccreditStartDate,3)
		.s:AccreditStartTime'="" AccreditStartTime=$zt(AccreditStartTime)
		.s:AccreditEndDate'="" AccreditEndDate=$zd(AccreditEndDate,3)
		.s:AccreditEndTime'="" AccreditEndTime=$zt(AccreditEndTime)
		.s CreatedUserDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",CreatedUser)
		.s:CreatedDate'="" CreatedDate=$zd(CreatedDate,3)
		.s:CreatedTime'="" CreatedTime=$zt(CreatedTime)
		.s ^CacheTemp(repid,ind)=$lb(OperAduitAccreditID,AccreditLocation,AccreditCareProv,AccreditStartDate,AccreditStartTime,AccreditEndDate,AccreditEndTime,CreatedUser,CreatedDate,CreatedTime,AccreditLocationDesc,AccreditCareProvDesc,CreatedUserDesc)
		.s qHandle=$lb(0,repid,0)
		.s ind=ind+1
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	else
	{	
		;b ;001
		s OperAduitAccreditID=0
		f  s OperAduitAccreditID=$o(^CF.AN.OperAduitAccreditI("IAccreditLoc"," "_deptID,OperAduitAccreditID)) q:OperAduitAccreditID=""  d
		.;b ;002
		.s OperAduitAccreditData=^CF.AN.OperAduitAccreditD(OperAduitAccreditID)
		.s AccreditLocation=$lg(OperAduitAccreditData,1)
		.s AccreditCareProv=$lg(OperAduitAccreditData,2)
		.s AccreditStartDate=$lg(OperAduitAccreditData,3)
		.s AccreditStartTime=$lg(OperAduitAccreditData,4)
		.s AccreditEndDate=$lg(OperAduitAccreditData,5)
		.s AccreditEndTime=$lg(OperAduitAccreditData,6)
		.s CreatedUser=$lg(OperAduitAccreditData,7)
		.s CreatedDate=$lg(OperAduitAccreditData,8)
		.s CreatedTime=$lg(OperAduitAccreditData,9)
		.q:(AccreditEndDate'="")&&(AccreditEndDate<(+$h+1))
		.s AccreditLocationDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",AccreditLocation)
		.s AccreditCareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",AccreditCareProv)
		.s:AccreditStartDate'="" AccreditStartDate=$zd(AccreditStartDate,3)
		.s:AccreditStartTime'="" AccreditStartTime=$zt(AccreditStartTime)
		.s:AccreditEndDate'="" AccreditEndDate=$zd(AccreditEndDate,3)
		.s:AccreditEndTime'="" AccreditEndTime=$zt(AccreditEndTime)
		.s CreatedUserDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",CreatedUser)
		.s:CreatedDate'="" CreatedDate=$zd(CreatedDate,3)
		.s:CreatedTime'="" CreatedTime=$zt(CreatedTime)
		.s ^CacheTemp(repid,ind)=$lb(OperAduitAccreditID,AccreditLocation,AccreditCareProv,AccreditStartDate,AccreditStartTime,AccreditEndDate,AccreditEndTime,CreatedUser,CreatedDate,CreatedTime,AccreditLocationDesc,AccreditCareProvDesc,CreatedUserDesc)
		.s qHandle=$lb(0,repid,0)
		.s ind=ind+1
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
}

ClassMethod FindAduitAccreditListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
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

ClassMethod FindAduitAccreditListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveAduitAccredit(deptID, careProvID, startDate, startTime, endDate As %String = "", endTime As %String = "", userID, rowId As %String = "") As %String
{
	q:deptID="" "E^deptID is null"
	q:careProvID="" "E^careProvID is null"
	q:userID="" "E^userID is null"
	s $zt="Error" 
	;i $d(^CF.AN.OperAduitAccreditI("IAccreditLoc"," "_deptID)) d
	;.s rowId=$o(^CF.AN.OperAduitAccreditI("IAccreditLoc"," "_deptID,0))
	i rowId="" d
	.s obj=##class(CF.AN.OperAduitAccredit).%New()
	e  d
	.s obj=##class(CF.AN.OperAduitAccredit).%OpenId(rowId)
	;q:rowId'="" "S^"
	s obj.AccreditCareProv=careProvID
	s obj.AccreditLocation=deptID
	s obj.AccreditStartDate=$zdh(startDate,3)
	s obj.AccreditStartTime=$zth(startTime)
	s:endDate'="" obj.AccreditEndDate=$zdh(endDate,3)
	s:endTime'="" obj.AccreditEndTime=$zth(endTime)
	s obj.CreatedDate=+$h
	s obj.CreatedTime=$p($h,",",2)
	s obj.CreatedUser=userID
	s sc=obj.%Save()
	q:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	q "S^"_obj.%Id()
Error
	q "E^"_$ze
}

ClassMethod DeleteAduitAccredit(rowId As %String) As %String
{
	q:rowId="" "E^rowId is null"
	q:'##class(CF.AN.OperAduitAccredit).%ExistsId(rowId) "E^rowId is not exist"
	s $zt="Error"
	d ##class(CF.AN.OperAduitAccredit).%DeleteId(rowId)
	q "S^操作成功"
Error
	q "E^"_$ze
}

}
