/// 指标属性
Class DHCHAI.RME.DocProperty Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 属性类型
Property DPTypeDr As DHCHAI.RME.PropertyType;

/// 属性名称
Property DPName As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 属性值
Property DPValue As %String(MAXLEN = 100, TRUNCATE = 1);

/// 属性值单位
Property DPUnit As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="DocPropertyState">
<Value name="1">
<Value>DPTypeDr</Value>
</Value>
<Value name="2">
<Value>DPName</Value>
</Value>
<Value name="3">
<Value>DPValue</Value>
</Value>
<Value name="4">
<Value>DPUnit</Value>
</Value>
</Data>
<State>DocPropertyState</State>
<StreamLocation>^DHCHAI.RME.DocPropertyS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
