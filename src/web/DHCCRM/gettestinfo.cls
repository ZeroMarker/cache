Import SQLUser

Class web.DHCCRM.gettestinfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod gettestinfo(start, limit)
{

	s start=$G(start)
	s limit=$G(limit)
	s rs=##class(%ResultSet).%New("web.DHCCRM.gettestinfo:SearchTopData") 
	d rs.Execute()
 	s count=0
 	s mess=""
 	s topnum=start+limit
	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	
	 	s RowId=rs.Get("RowId")
	 	s Code=rs.Get("Code")
	 	s Desc=rs.Get("Desc")
	 	
		i (mess'="") s mess=mess_","
		s mess=mess_"{""SDSRowId"":"_""""_RowId_""""
		s mess=mess_","_"""SDCode"":"_""""_Code_""""
		s mess=mess_","_"""SDName"":"_""""_Desc_""""
		s mess=mess_"}"
	}	 	 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

Query SearchTopData() As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod SearchTopDataExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s StationID=0
	F  S StationID=$O(^DHCPEST(StationID))  q:StationID=""  d
	.s StationCode=$p(^DHCPEST(StationID),"^",1)
	.s StaionName=$p(^DHCPEST(StationID),"^",2)
    .d OutputRow

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(StationID,StationCode,StaionName)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchTopDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchTopDataExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }

 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchTopDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchTopDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UpdateStationInfo(staionrowid, SDCode, SDName)
{
  
  s ^zl("actiontype ",2)=staionrowid_"^"_ SDCode_"^"_ SDName
   &sql(update DHC_PE_Station
	
	     set ST_Code =:SDCode,
	     	 ST_Desc =:SDName
	     where ST_RowId=:staionrowid
	     )
	 q SQLCODE
}

Storage Default
{
<Data name="gettestinfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCRM.gettestinfoD</DataLocation>
<DefaultData>gettestinfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCCRM.gettestinfoD</IdLocation>
<IndexLocation>^web.DHCCRM.gettestinfoI</IndexLocation>
<StreamLocation>^web.DHCCRM.gettestinfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
