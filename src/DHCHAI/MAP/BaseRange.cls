/// 名称: DHCHAI.MAP.BaseRange
/// 描述: 基础值域字典
/// 编写者：zhufei
/// 编写日期: 2021-04-09
Class DHCHAI.MAP.BaseRange Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类/项目编码（参考省市县乡格式：000000-000000-00）
Property BRType As %String(TRUNCATE = 1) [ Required ];

/// 值域代码
Property BRCode As %String(MAXLEN = 3, TRUNCATE = 1) [ Required ];

/// 值域名称
Property BRDesc As %String(TRUNCATE = 1) [ Required ];

/// 有效标志
Property BRIsActive As %Boolean;

Storage Default
{
<Data name="BaseRangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BRType</Value>
</Value>
<Value name="3">
<Value>BRCode</Value>
</Value>
<Value name="4">
<Value>BRDesc</Value>
</Value>
<Value name="5">
<Value>BRIsActive</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.MAP.BaseRangeD</DataLocation>
<DefaultData>BaseRangeDefaultData</DefaultData>
<IdLocation>^MA.HAI.MAP.BaseRangeD</IdLocation>
<IndexLocation>^MA.HAI.MAP.BaseRangeI</IndexLocation>
<StreamLocation>^MA.HAI.MAP.BaseRangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
