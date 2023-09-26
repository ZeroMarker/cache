/// Excel导入人员信息配置
Class dhc.bonus.data.ImpEmpConfig Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ImpEmpConfigID ]
{

Property OnloadFileTypeID As dhc.bonus.data.OnloadFileType [ SqlColumnNumber = 2 ];

Property CalculateGroupID As dhc.bonus.data.BonusCalculateTypeGroup [ SqlColumnNumber = 3 ];

Property ColNum As %Library.Integer [ SqlColumnNumber = 4 ];

Property CreateDate As %Library.TimeStamp [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="ImpEmpConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OnloadFileTypeID</Value>
</Value>
<Value name="3">
<Value>CalculateGroupID</Value>
</Value>
<Value name="4">
<Value>ColNum</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
</Data>
<DataLocation>^dhcbsImpEmpConfigD</DataLocation>
<DefaultData>ImpEmpConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsImpEmpConfigD</IdLocation>
<IndexLocation>^dhcbsImpEmpConfigI</IndexLocation>
<StreamLocation>^dhcbsImpEmpConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
