/// 用户级别
Class EMRmeta.UserLevel Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock ]
{

Index NameIndex On Name [ Unique ];

Property Name As %String(TRUNCATE = 1);

//英文代码

Property Description As %String(TRUNCATE = 1);

//中文描述

Property IsValid As %String(TRUNCATE = 1);

//1 or 0

Storage Default
{
<Data name="UserLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>IsValid</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserLevelD</DataLocation>
<DefaultData>UserLevelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.UserLevelD</IdLocation>
<IndexLocation>^DHCEMRM.UserLevelI</IndexLocation>
<StreamLocation>^DHCEMRM.UserLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
