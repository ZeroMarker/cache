/// 名称: 打印模板装订线
/// 描述: 
/// 编写者：HouJian
/// 编写日期: 2011-12-1
Class EPRmeta.PrintTemplateGutter Extends (%SerialObject, %XML.Adaptor) [ ClassType = serial, ProcedureBlock ]
{

/// 装订线边距：大于等于0
Property Margin As %Integer;

/// 装订线位置: 左 或 上
Property Position As %String(TRUNCATE = 1);

/// 装订线起始位置：大于等于0
Property Start As %Integer;

/// 装订线长度：大于0
Property Length As %Integer;

/// 装订线线宽：大于0
Property Width As %Integer;

/// 装订线线型:
/// Solid = 0,
/// Dash = 1,
/// Dot = 2,
/// DashDot = 3,
/// DashDotDot = 4,
Property DashStyle As %String(TRUNCATE = 1);

Storage Default
{
<Data name="PrintTemplateGutterState">
<Subscript>"EPRmeta.PrintTemplateGutter"</Subscript>
<Value name="1">
<Value>DashStyle</Value>
</Value>
<Value name="2">
<Value>Length</Value>
</Value>
<Value name="3">
<Value>Margin</Value>
</Value>
<Value name="4">
<Value>Position</Value>
</Value>
<Value name="5">
<Value>Start</Value>
</Value>
<Value name="6">
<Value>Width</Value>
</Value>
</Data>
<State>PrintTemplateGutterState</State>
<StreamLocation>^EPRmeta.PrintTemplateGutterS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
