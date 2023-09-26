/// insert into EnsSouLookUpTData(sourceCode,sourceDesc,sourceTableDr) values('M','男','1')
Class User.EnsSouLookUpTData Extends (%Persistent, %XML.Adaptor)
{

/// 代码
Property sourceCode As %String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 2 ];

/// 描述
Property sourceDesc As %String(COLLATION = "EXACT", MAXLEN = 300) [ SqlColumnNumber = 3 ];

/// 表名称
Property sourceTableDr As User.EnsLookUpTable [ SqlColumnNumber = 4 ];

Index sourceCode On (sourceTableDr, sourceCode) [ Unique ];

Index sourceDesc On (sourceTableDr, sourceDesc);

Storage Default
{
<Data name="EnsSouLookUpTDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>sourceCode</Value>
</Value>
<Value name="3">
<Value>sourceDesc</Value>
</Value>
<Value name="4">
<Value>sourceTableDr</Value>
</Value>
</Data>
<DataLocation>^User.EnsSouLookUpTDataD</DataLocation>
<DefaultData>EnsSouLookUpTDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.EnsSouLookUpTDataD</IdLocation>
<IndexLocation>^User.EnsSouLookUpTDataI</IndexLocation>
<StreamLocation>^User.EnsSouLookUpTDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
