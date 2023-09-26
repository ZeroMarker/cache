Class DHCMGNUR.QuCheckProject Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ChildSub As DHCMGNUR.QuCheckProjectChild [ Cardinality = children, Inverse = QualParref ];

//Property Wards As %String(MAXLEN = 300) [ Collection = list ];

//Property CheckTyp As %String;

Property CheckName As %String(TRUNCATE = 1);

Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property RecUser As %String(TRUNCATE = 1);

Index CheckName On CheckName;

ClassMethod SaveMoud(CheckId As %String = "", CheckName As %String, RecUser As %String) As %String
{
	 q:(CheckId="")&&(CheckName="") ""
	 s flag=""
	 s CheckNameI = $$ALPHAUP^SSUTIL4(CheckName)
	 if CheckId=""
     {
	     s id=$O(^DHCMGNUR.QuCheckProjectI("CheckName"," "_CheckNameI,""))
		 if (id="")
		 {
		 	s a=##class(DHCMGNUR.QuCheckProject).%New()
		 }
		 else
		 {	 s flag=..EditFlag(id)
		 	 q:flag'=0 flag
			 s a=##class(DHCMGNUR.QuCheckProject).%OpenId(id)
		 }
	 }
	 else
	 {		 s flag=..EditFlag(id)
	 
		 	 q:flag'=0 flag
		 s a=##class(DHCMGNUR.QuCheckProject).%OpenId(CheckId)
	 }
	s a.CheckName=CheckName
	s a.RecUser=RecUser
    d a.%Save()
	q a.%Id()
}

ClassMethod GetQualCodeExecute(ByRef qHandle As %Binary, sid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id="" f  s id=$O(^DHCMGNUR.QuCheckProjectD(id)) q:id=""  d
 	.s a=##class(DHCMGNUR.QuCheckProject).%OpenId(id)
	.s ret="QualDesc|"
	.s ret=ret_a.CheckName
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetQualCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualCodeExecute ]
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

Query GetQualCode(sid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetQualCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

//入参

//id：自定义模板rowid

ClassMethod EditFlag(id) As %String
{
		s flag=0
		s checkid="" 	     
	     f  s checkid=$O(^DHCMGNUR.QuCheckWardI("CheckFlag"," 1",checkid)) q:checkid=""  d
	     .s check=##class(DHCMGNUR.QuCheckWard).%OpenId(checkid)
	     .i check.CheckMoudId=id s flag=1
	     q:flag=1 "模板已使用，不能修改，请维护新模板!"
	     q:flag=0 0
}

ClassMethod IsSave(id) As %String
{
		
   s bb=##class(DHCMGNUR.QuCheckWard).%OpenId(id)
   q:bb.CheckMoudId'="" -1
   q ""
}

ClassMethod IsDelete(checkid) As %String
{
   s flag=""
   s flag=$o(^Nur.CheckRoomI("CheckQual"," "_checkid,""))
   q:flag'="" "模板已使用,不能删除!"
   
   s checkItem="" 	     
   f  s checkItem=$O(^DHCMGNUR.QuCheckWardChildI("CheckItem",checkItem)) q:checkItem=""  d
   .s id=""
   .f  s id=$O(^DHCMGNUR.QuCheckWardChildI("CheckItem",checkItem,checkid,id)) q:id=""  d
   ..s rw=checkid_"||"_id
   ..b ;01
   ..s a=##class(DHCMGNUR.QuCheckWardChild).%DeleteId(rw)
   s check=##class(DHCMGNUR.QuCheckWard).%OpenId(checkid)
   s check.CheckFlag=""
   s check.CheckMoudId=""
   d check.%Save()
   q 0
}

Storage Default
{
<Data name="QuCheckProjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckDate</Value>
</Value>
<Value name="3">
<Value>CheckEndTime</Value>
</Value>
<Value name="4">
<Value>CheckSTime</Value>
</Value>
<Value name="5">
<Value>CheckStatus</Value>
</Value>
<Value name="6">
<Value>CheckTyp</Value>
</Value>
<Value name="7">
<Value>CheckUsers</Value>
</Value>
<Value name="8">
<Value>RecDate</Value>
</Value>
<Value name="9">
<Value>RecTime</Value>
</Value>
<Value name="10">
<Value>RecUser</Value>
</Value>
<Value name="11">
<Value>Wards</Value>
</Value>
<Value name="12">
<Value>CheckName</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.QuCheckProjectD</DataLocation>
<DefaultData>QuCheckProjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.QuCheckProjectD</IdLocation>
<IndexLocation>^DHCMGNUR.QuCheckProjectI</IndexLocation>
<StreamLocation>^DHCMGNUR.QuCheckProjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
