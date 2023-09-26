/// CreateDate：2023.4.25
/// CreateUser: qj
/// Desc:医生站业务信息导出类，处理比如上线时旧系统的的排班模板导出
Class DHCDoc.Local.InfoExport Extends %Persistent
{

/// 导出排班模板
Query FindScheduleDetialsExp(LocRowid, UserRowid, DocRowid, ZoneID As %String = "", ScheduleLinesRowId As %String = "", ILocDesc As %String = "", IDocDesc As %String = "", HospId As %String = "") As %Library.Query(ROWSPEC = "LocDesc:%String:科室,ResDesc:%String:医生,Week:%String:星期,TimeRange:%String:时段,SessLoad:%String:正号限额,SessNoApptSlot:%String:预约限额,WINMaxQty:%String:窗口最大预约数,WEBMaxQty:%String:网络最大预约数,SessionType:%String:挂号职称,SttTime:%String:开始时间,EndTime:%String:结束时间,Room:%String:诊室,RowId:%String:排班ID")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCExamPatList","FindScheduleTempExport","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod FindScheduleDetialsExpExecute(ByRef qHandle As %Library.Binary, LocRowid, UserRowid, DocRowid, ZoneID As %String = "", ScheduleLinesRowId As %String = "", ILocDesc As %String = "", IDocDesc As %String = "", HospId As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.ScheduleTemp:FindScheDetialsTemp")
	d rset.Execute(LocRowid, UserRowid, DocRowid, ZoneID, ScheduleLinesRowId, ILocDesc, IDocDesc, HospId)
	While (rset.Next()) {
		s LocDesc=rset.Data("LocDesc")
		s ResDesc=rset.Data("ResDesc")
		s Week=$p(rset.Data("Week"),"^")
		s TimeRange=rset.Data("TimeRange")
		s SessLoad=$p(rset.Data("Week"),"^",9)
		s SessNoApptSlot=$p(rset.Data("Week"),"^",10)
		s WINMaxQty=$p(rset.Data("Week"),"^",4)
		s WEBMaxQty=$p(rset.Data("Week"),"^",5)
		s SessionType=$p(rset.Data("Week"),"^",6)
		s SttTime=$p(rset.Data("Week"),"^",7)
		s EndTime=$p(rset.Data("Week"),"^",8)
		s Room=rset.Data("Room")
		s RowId=$replace(rset.Data("RowId"),"^","||")
		s OutputList=$lb(LocDesc,ResDesc,Week,TimeRange,SessLoad,SessNoApptSlot,WINMaxQty,WEBMaxQty,SessionType,SttTime,EndTime,Room,RowId)
		d OutputRow14
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow14
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindScheduleDetialsExpFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindScheduleDetialsExpExecute ]
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

ClassMethod FindScheduleDetialsExpClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindScheduleDetialsExpFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Storage Default
{
<Data name="InfoExportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.Local.InfoExportD</DataLocation>
<DefaultData>InfoExportDefaultData</DefaultData>
<IdLocation>^DHCDoc.Local.InfoExportD</IdLocation>
<IndexLocation>^DHCDoc.Local.InfoExportI</IndexLocation>
<StreamLocation>^DHCDoc.Local.InfoExportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
