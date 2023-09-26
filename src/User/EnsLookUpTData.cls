/// insert into EnsLookUpTData(sourceTableDr,targetTableDr,lookUpTableDr) values('1','1','1')
Class User.EnsLookUpTData Extends (%Persistent, %XML.Adaptor)
{

/// 源数据
Property sourceTableDr As User.EnsSouLookUpTData [ Required, SqlColumnNumber = 2 ];

/// 目标数据
Property targetTableDr As User.EnsTarLookUpTData [ Required, SqlColumnNumber = 3 ];

/// 表名称
Property lookUpTableDr As User.EnsLookUpTable [ Required, SqlColumnNumber = 4 ];

Index lookUpTableDr On lookUpTableDr;

Index sourceTableDr On (lookUpTableDr, sourceTableDr) [ Unique ];

Index targetTableDr On (lookUpTableDr, targetTableDr);

Storage Default
{
<Data name="EnsLookUpTDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>sourceTable</Value>
</Value>
<Value name="3">
<Value>targetTable</Value>
</Value>
<Value name="4">
<Value>targetTableDr</Value>
</Value>
<Value name="5">
<Value>sourceTableDr</Value>
</Value>
<Value name="6">
<Value>lookUpTableDr</Value>
</Value>
</Data>
<DataLocation>^User.EnsLookUpTDataD</DataLocation>
<DefaultData>EnsLookUpTDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.EnsLookUpTDataD</IdLocation>
<IndexLocation>^User.EnsLookUpTDataI</IndexLocation>
<StreamLocation>^User.EnsLookUpTDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
