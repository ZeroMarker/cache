Class User.DHCQtIOItem Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_QtIOItem ]
{

Property Code As %String(TRUNCATE = 1);

Property ItmDesc As %String(TRUNCATE = 1);

Property StopFlag As %String(TRUNCATE = 1);

Index CodeIndex On Code [ Unique ];

ClassMethod Insert(code As %String, desc As %String, flag As %String) As %String
{
	s a=##class(DHCQtIOItem).%New()
	s a.Code=code
	s a.ItmDesc=desc
	s a.StopFlag=flag
	d a.%Save()
	q 0
}

ClassMethod Update(code As %String, desc As %String, flag As %String, id As %String) As %String
{
   s a=##class(DHCQtIOItem).%OpenId(id)
   	s a.Code=code
	s a.ItmDesc=desc
	s a.StopFlag=flag
	d a.%Save()
	q 0
}

ClassMethod CRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CRItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod CRItemExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id="" f  s id=$O(^User.DHCQtIOItemD(id)) q:id=""  d
 	.s a=##class(User.DHCQtIOItem).%OpenId(id)
   	.s code=a.Code
	.s typ=a.ItmDesc
	.s flag=a.StopFlag
	.s rw=id
	.//q:flag="N"
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(code,typ,flag,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CRItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CRItemExecute ]
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

Query CRItem() As %Query(ROWSPEC = "code,desc,flag,rw")
{
}

Storage Default
{
<Data name="DHCQtIOItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>ItmDesc</Value>
</Value>
<Value name="4">
<Value>StopFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCQtIOItemD</DataLocation>
<DefaultData>DHCQtIOItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCQtIOItemD</IdLocation>
<IndexLocation>^User.DHCQtIOItemI</IndexLocation>
<StreamLocation>^User.DHCQtIOItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
