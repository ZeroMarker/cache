/// 复测规则配置
Class CT.NUR.NIS.ChartRetest Extends %Persistent [ SqlTableName = Retest ]
{

/// Chart Parent Reference
Relationship RetestParRef As Chart [ Cardinality = parent, Inverse = ChildChartRetest, Required, SqlFieldName = ParRef ];

/// 体征项
Property itemDr As User.MRCObservationItem [ Required, SqlColumnNumber = 3, SqlFieldName = itemDr ];

/// 图标描述 
Property retestDesc As %String [ Required, SqlColumnNumber = 4, SqlFieldName = retestDesc ];

/// 颜色 
Property color As %String [ Required, SqlColumnNumber = 5, SqlFieldName = color ];

/// 最小上升值 
Property upMinValue As %String [ SqlColumnNumber = 6, SqlFieldName = upMinValue ];

/// 最小下降值 
Property downMinValue As %String [ SqlColumnNumber = 7, SqlFieldName = downMinValue ];

/// 图标描述大小
Property retestIconSize As %String [ SqlColumnNumber = 8, SqlFieldName = retestIconSize ];

/// 图标横向偏移量
Property iconOffsetX As %String [ SqlColumnNumber = 9, SqlFieldName = iconOffsetX ];

/// 图标纵向偏移量
Property iconOffsetY As %String [ SqlColumnNumber = 10, SqlFieldName = iconOffsetY ];

/// key 
Property rowKey As %String [ Required, SqlColumnNumber = 11, SqlFieldName = rowKey ];

Index RowID On (RetestParRef, rowKey) [ Unique ];

Storage Default
{
<Data name="ChartRetestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>itemDr</Value>
</Value>
<Value name="3">
<Value>retestDesc</Value>
</Value>
<Value name="4">
<Value>color</Value>
</Value>
<Value name="5">
<Value>upMinValue</Value>
</Value>
<Value name="6">
<Value>downMinValue</Value>
</Value>
<Value name="7">
<Value>retestIconSize</Value>
</Value>
<Value name="8">
<Value>iconOffsetX</Value>
</Value>
<Value name="9">
<Value>iconOffsetY</Value>
</Value>
<Value name="10">
<Value>rowKey</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildChartRetest")</DataLocation>
<DefaultData>ChartRetestDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartC("ChildChartRetest")</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartRetestI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ChartRetestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
