/// 名称: DHCHAI.MAP.BaseMapping
/// 描述: 基础字典映射
/// 编写者：zhufei
/// 编写日期: 2021-04-09
Class DHCHAI.MAP.BaseMapping Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 分类编码（与值域分类编码对应）
Property BMType As %String(TRUNCATE = 1) [ Required ];

/// 唯一健值
Property BMKeyVal As %String(TRUNCATE = 1) [ Required ];

/// 健值描述
Property BMKeyText As %String(TRUNCATE = 1);

/// 值域映射
Property BMRangeDr As DHCHAI.MAP.BaseRange;

/// 有效标志
Property BMIsActive As %Boolean;

/// 更新日期
Property BMActDate As %Date;

/// 更新时间
Property BMActTime As %Time;

/// 操作人
Property BMActUserDr As DHCHAI.BT.SysUser;

Storage Default
{
<Data name="BaseMappingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMType</Value>
</Value>
<Value name="3">
<Value>BMKeyVal</Value>
</Value>
<Value name="4">
<Value>BMKeyText</Value>
</Value>
<Value name="5">
<Value>BMRangeDr</Value>
</Value>
<Value name="6">
<Value>BMIsActive</Value>
</Value>
<Value name="7">
<Value>BMActDate</Value>
</Value>
<Value name="8">
<Value>BMActTime</Value>
</Value>
<Value name="9">
<Value>BMActUserDr</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.MAP.BaseMappingD</DataLocation>
<DefaultData>BaseMappingDefaultData</DefaultData>
<IdLocation>^MA.HAI.MAP.BaseMappingD</IdLocation>
<IndexLocation>^MA.HAI.MAP.BaseMappingI</IndexLocation>
<StreamLocation>^MA.HAI.MAP.BaseMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
