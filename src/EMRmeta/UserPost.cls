/// 用户职务
Class EMRmeta.UserPost Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index NameIndex On Name [ Unique ];

/// 英文代码
Property Name As %String(TRUNCATE = 1);

/// 中文描述
Property Description As %String(TRUNCATE = 1);

/// 操作代码
Property OperAction As %String(TRUNCATE = 1);

/// 1 or 0
Property IsValid As %String(TRUNCATE = 1);

Storage Default
{
<Data name="UserPostDefaultData">
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
<Value name="5">
<Value>OperAction</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserPostD</DataLocation>
<DefaultData>UserPostDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.UserPostD</IdLocation>
<IndexLocation>^DHCEMRM.UserPostI</IndexLocation>
<StreamLocation>^DHCEMRM.UserPostS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
