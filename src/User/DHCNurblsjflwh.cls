Class User.DHCNurblsjflwh Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_Nurblsjflwh ]
{

Property Code As %String(TRUNCATE = 1);

Property Desc1 As %String(TRUNCATE = 1);

Property UserREC As %String(TRUNCATE = 1);

Property RECDate As %Library.Date;

Property RECTime As %Library.Time;

Index CodeIndex On Code;

//d class(User.DHCNurblsjflwh).getdata()

ClassMethod getdata() As %String
{
   s ret="" 
   s id="" f  s id=$O(^User.DHCNurblsjflwhD(id)) q:id=""  d
 	.s a=##class(User.DHCNurblsjflwh).%OpenId(id)
 	.s des=a.Desc1
	.s ret=ret_"^rw|"_id
	q ret
}

Storage Default
{
<Data name="DHCNurblsjflwhDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Desc1</Value>
</Value>
<Value name="4">
<Value>StopFlag</Value>
</Value>
<Value name="5">
<Value>UserREC</Value>
</Value>
<Value name="6">
<Value>RECDate</Value>
</Value>
<Value name="7">
<Value>RECTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurblsjflwhD</DataLocation>
<DefaultData>DHCNurblsjflwhDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNurblsjflwhD</IdLocation>
<IndexLocation>^User.DHCNurblsjflwhI</IndexLocation>
<StreamLocation>^User.DHCNurblsjflwhS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
