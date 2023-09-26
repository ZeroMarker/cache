/// 名称:EMRmeta.BindParameter
/// 描述:数据引用表
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRmeta.BindParameter Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxParameterName On ParameterName;

Property Description As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property ParameterName As %String(TRUNCATE = 1);

Property ParameterType As %String(TRUNCATE = 1);

Property QueryID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="BindParameterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ParameterName</Value>
</Value>
<Value name="5">
<Value>ParameterType</Value>
</Value>
<Value name="6">
<Value>QueryID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.BindParameterD</DataLocation>
<DefaultData>BindParameterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.BindParameterD</IdLocation>
<IndexLocation>^DHCEMRM.BindParameterI</IndexLocation>
<StreamLocation>^DHCEMRM.BindParameterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
