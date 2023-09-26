Class User.DHCAntOperaTime Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = AOT_Rowid, SqlTableName = DHC_Ant_OperaTime ]
{

Property AOTCode As %String [ SqlColumnNumber = 2, SqlFieldName = AOT_Code ];

Property AOTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = AOT_Desc ];

Property AOTActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AOT_Active ];

Property AOTNote As %String [ SqlColumnNumber = 5, SqlFieldName = AOT_Note ];

ClassMethod Save(str)
{
	s ID=$p(str,"^",1)
	s AOTCode=$p(str,"^",2)
	s AOTDesc=$p(str,"^",3)
	s AOTActive=$p(str,"^",4)
	s AOTNote=$p(str,"^",5)
	i ID="" s a=##class(User.DHCAntOperaTime).%New()
	e  s a=##class(User.DHCAntOperaTime).%OpenId(ID)
	s a.AOTCode=AOTCode
	s a.AOTDesc=AOTDesc
	s a.AOTActive=AOTActive
	s a.AOTNote=AOTNote
	d a.%Save()
	q 0
}

ClassMethod FindAllAOTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllAOTExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("User.DHCAntOperaTime","FindAllAOT")
ClassMethod FindAllAOTExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	s ID=""
	f  s ID=$o(^User.DHCAntOperaTimeD(ID)) q:ID=""  d
	.s a=##class(User.DHCAntOperaTime).%OpenId(ID)
	.s AOTCode=a.AOTCode
	.s AOTDesc=a.AOTDesc
	.s AOTActive=a.AOTActive
	.s AOTNote=a.AOTNote
	.Do OutputRow
	Quit $$$OK
OutputRow
	set Data=$lb(ID,AOTCode,AOTDesc,AOTActive,AOTNote)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1	
	quit
}

ClassMethod FindAllAOTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllAOTExecute ]
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

Query FindAllAOT() As %Query(ROWSPEC = "TID:%String,TAOTCode:%String,TAOTDesc:%String,TAOTActive:%String,TAOTNote:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCAntOperaTimeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AOTCode</Value>
</Value>
<Value name="3">
<Value>AOTDesc</Value>
</Value>
<Value name="4">
<Value>AOTActive</Value>
</Value>
<Value name="5">
<Value>AOTNote</Value>
</Value>
</Data>
<DataLocation>^User.DHCAntOperaTimeD</DataLocation>
<DefaultData>DHCAntOperaTimeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCAntOperaTimeD</IdLocation>
<IndexLocation>^User.DHCAntOperaTimeI</IndexLocation>
<StreamLocation>^User.DHCAntOperaTimeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
