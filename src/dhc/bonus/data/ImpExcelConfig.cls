/// Excel配置信息
Class dhc.bonus.data.ImpExcelConfig Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ImpExcelConfigID ]
{

Property OnloadFileID As dhc.bonus.data.OnloadFileType [ SqlColumnNumber = 2 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 3 ];

Property ColNum As %Library.Integer [ SqlColumnNumber = 4 ];

Property CreateDate As %Library.TimeStamp [ SqlColumnNumber = 5 ];

Property ItemCode As %Library.String [ SqlColumnNumber = 6 ];

Property ItemName As %Library.String [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="ImpExcelConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OnloadFileID</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
<Value name="4">
<Value>ColNum</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>ItemCode</Value>
</Value>
<Value name="7">
<Value>ItemName</Value>
</Value>
</Data>
<DataLocation>^dhcbsImpExcelConfigD</DataLocation>
<DefaultData>ImpExcelConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsImpExcelConfigD</IdLocation>
<IndexLocation>^dhcbsImpExcelConfigI</IndexLocation>
<StreamLocation>^dhcbsImpExcelConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
