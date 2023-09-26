/// insert into  EnsLookUpTable(lookUpTableCode,lookUpTableDesc) values('CT_Nation',"民族字典信息")
Class User.EnsLookUpTable Extends (%Persistent, %XML.Adaptor)
{

/// 代码
Property lookUpTableCode As %String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 2 ];

/// 名称
Property lookUpTableDesc As %String(COLLATION = "EXACT", MAXLEN = 300) [ Required, SqlColumnNumber = 3 ];

/// 备注
Property lookUpTableRemarks As %String(COLLATION = "EXACT", MAXLEN = 300) [ SqlColumnNumber = 4 ];

Index lookUpTableCode On lookUpTableCode [ Unique ];

Storage Default
{
<Data name="EnsLookUpTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>lookUpTableCode</Value>
</Value>
<Value name="3">
<Value>lookUpTableDesc</Value>
</Value>
<Value name="4">
<Value>lookUpTableRemarks</Value>
</Value>
</Data>
<DataLocation>^User.EnsLookUpTableD</DataLocation>
<DefaultData>EnsLookUpTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.EnsLookUpTableD</IdLocation>
<IndexLocation>^User.EnsLookUpTableI</IndexLocation>
<StreamLocation>^User.EnsLookUpTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
