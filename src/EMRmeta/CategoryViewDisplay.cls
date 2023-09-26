/// 病历目录视图显示
/// Desc:存储前端页面病历目录视图显示方式数据
/// Creator:	Lina
/// CreateDate:	2016-12-26
Class EMRmeta.CategoryViewDisplay Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxViewDisplayId On ViewDisplayId [ Unique ];

Index IdxViewDisplayDesc On ViewDisplayDesc;

Index IdxViewDisplayType On ViewDisplayType;

/// 病历目录视图显示配置Id
Property ViewDisplayId As %String(TRUNCATE = 1);

/// 病历目录视图显示配置描述
Property ViewDisplayDesc As %String(TRUNCATE = 1);

/// 病历目录视图显示类型
Property ViewDisplayType As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CategoryViewDisplayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ViewDisplayId</Value>
</Value>
<Value name="3">
<Value>ViewDisplayDesc</Value>
</Value>
<Value name="4">
<Value>ViewDisplayType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CategoryViewDisplayD</DataLocation>
<DefaultData>CategoryViewDisplayDefaultData</DefaultData>
<IdLocation>^DHCEMRM.CategoryViewDisplayD</IdLocation>
<IndexLocation>^DHCEMRM.CategoryViewDisplayI</IndexLocation>
<StreamLocation>^DHCEMRM.CategoryViewDisplayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
