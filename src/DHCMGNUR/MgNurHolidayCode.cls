Class DHCMGNUR.MgNurHolidayCode Extends %Persistent
{

/// 休假代码
Property HolidayCode As %String [ SqlColumnNumber = 2, SqlFieldName = Holiday_Code ];

/// 休假名称
Property HolidayDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Holiday_Desc ];

/// 休假备注
Property HolidayRemarks As %String [ SqlColumnNumber = 4, SqlFieldName = Holiday_Remarks ];

/// 日小时数
Property HolidayHours As %String [ SqlColumnNumber = 5, SqlFieldName = Holiday_Hours ];

/// 状态
Property HolidayStatus As %String [ SqlColumnNumber = 6, SqlFieldName = Holiday_Status ];

Index Code On HolidayCode;

ClassMethod Save(parr As %String) As %String
{
	q:parr="" -1
	s temp=""
	d ##class(web.DHCNurRosterComm).setTmp(parr,.temp)
	s id=$g(temp("ID"))
	i id="" d
	.s a=##class(DHCMGNUR.MgNurHolidayCode).%New()
	else  d
	.s a=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(id)
	s a.HolidayCode=$g(temp("HolidayCode"))
	s a.HolidayDesc=$g(temp("HolidayDesc"))
	s a.HolidayHours=$g(temp("HolidayHours"))
	s a.HolidayRemarks=$g(temp("HolidayRemarks"))
	s a.HolidayStatus="Y"
	TStart
	s sc=a.%Save()
	I $$$ISERR(sc)
	{
		TRollback
		q "保存失败！"
	}
	else
	{
		TCommit
		q "保存成功！"
	}
}

ClassMethod GetValue(id As %String) As %String
{
	q:id="" -1
	s a=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^HolidayCode|"_a.HolidayCode
	s ret=ret_"^HolidayDesc|"_a.HolidayDesc
	s ret=ret_"^HolidayHours|"_a.HolidayHours
	s ret=ret_"^HolidayRemarks|"_a.HolidayRemarks
	s ret=ret_"^HolidayStatus|"_a.HolidayStatus
	q ret
}

ClassMethod setStatus(parr As %String) As %String
{
	q:parr="" -1
	s id=$P(parr,"^",1) q:id="" -1
	s status=$P(parr,"^",2)
	s a=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(id)
	s a.HolidayStatus=status
	TStart
	s sc=a.%Save()
	I $$$ISERR(sc)
	{
		TRollback
		q "操作失败！"
	}
	else
	{
		TCommit
		q "操作成功！"
	}
}

/// d ##class(%ResultSet).RunQuery("DHCMGNUR.MgNurHolidayCode","FindHolidayData","N")
Query FindHolidayData(parr As %String) As %Query(ROWSPEC = "ret")
{
}

ClassMethod FindHolidayDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TEMP("20170627")=parr
	i parr="" { Set qHandle=$lb(0,repid,0) Quit $$$OK }
	s status=$P(parr,"^")
	s id="" f  s id=$O(^DHCMGNUR.MgNurHolidayCodeD(id)) q:id=""  d
	.s a=##class(DHCMGNUR.MgNurHolidayCode).%OpenId(id)
	.q:(status="N")&&(a.HolidayStatus="N")
	.q:(status="Y")&&(a.HolidayStatus'="N")
	.s ret=..GetValue(id)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHolidayDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHolidayDataExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindHolidayDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHolidayDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="MgNurHolidayCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HolidayCode</Value>
</Value>
<Value name="3">
<Value>HolidayDesc</Value>
</Value>
<Value name="4">
<Value>HolidayRemarks</Value>
</Value>
<Value name="5">
<Value>HolidayHours</Value>
</Value>
<Value name="6">
<Value>HolidayStatus</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurHolidayCodeD</DataLocation>
<DefaultData>MgNurHolidayCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurHolidayCodeD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurHolidayCodeI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurHolidayCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
