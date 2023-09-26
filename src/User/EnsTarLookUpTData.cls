/// insert into EnsTarLookUpTData(targetCode,targetDesc,targetTableDr) values('1','男','1')
Class User.EnsTarLookUpTData Extends (%Persistent, %XML.Adaptor)
{

/// 代码
Property targetCode As %String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 2 ];

/// 描述
Property targetDesc As %String(COLLATION = "EXACT", MAXLEN = 300) [ SqlColumnNumber = 3 ];

/// 表名称
Property targetTableDr As User.EnsLookUpTable [ SqlColumnNumber = 4 ];

Index targetCode On (targetTableDr, targetCode) [ Unique ];

Index targetDesc On (targetTableDr, targetDesc);

Storage Default
{
<Data name="EnsTarLookUpTDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>targetCode</Value>
</Value>
<Value name="3">
<Value>targetDesc</Value>
</Value>
<Value name="4">
<Value>targetTableDr</Value>
</Value>
</Data>
<DataLocation>^User.EnsTarLookUpTDataD</DataLocation>
<DefaultData>EnsTarLookUpTDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.EnsTarLookUpTDataD</IdLocation>
<IndexLocation>^User.EnsTarLookUpTDataI</IndexLocation>
<StreamLocation>^User.EnsTarLookUpTDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
