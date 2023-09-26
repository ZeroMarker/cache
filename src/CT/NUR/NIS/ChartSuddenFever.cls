/// 突然发热配置
Class CT.NUR.NIS.ChartSuddenFever Extends %Persistent [ SqlTableName = SuddenFever ]
{

// Index RowIDBasedIDKeyIndex On CurveChildsub [ IdKey, PrimaryKey, Unique ];

/// Chart Parent Reference
Relationship FeverParRef As Chart [ Cardinality = parent, Inverse = ChildChartFever, Required, SqlFieldName = ParRef ];

/// 体征项
Property itemDr As User.MRCObservationItem [ Required, SqlColumnNumber = 3, SqlFieldName = itemDr ];

/// 图标描述 
Property feverDesc As %String [ Required, SqlColumnNumber = 4, SqlFieldName = feverDesc ];

/// 颜色 
Property color As %String [ Required, SqlColumnNumber = 5, SqlFieldName = color ];

/// 关联体征项 
Property linkItemDr As User.MRCObservationItem [ SqlColumnNumber = 6, SqlFieldName = linkItemDr ];

/// 连线样式 
Property lineStyle As %String [ SqlColumnNumber = 7, SqlFieldName = lineStyle ];

/// 显示方式 
Property showWay As %String [ SqlColumnNumber = 8, SqlFieldName = showWay ];

/// 条件 
Property condition As %String [ SqlColumnNumber = 9, SqlFieldName = condition ];

/// key 
Property rowKey As %String [ Required, SqlColumnNumber = 10, SqlFieldName = rowKey ];

/// 图标描述大小
Property feverIconSize As %String [ SqlColumnNumber = 11, SqlFieldName = feverIconSize ];

/// 图标上下偏移量
Property iconOffset As %String [ SqlColumnNumber = 12, SqlFieldName = iconOffset ];

/// 线宽
Property lineWidth As %String [ SqlColumnNumber = 13, SqlFieldName = lineWidth ];

Index RowID On (FeverParRef, rowKey) [ Unique ];

Storage Default
{
<Data name="ChartSuddenFeverDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>itemDr</Value>
</Value>
<Value name="3">
<Value>feverDesc</Value>
</Value>
<Value name="4">
<Value>color</Value>
</Value>
<Value name="5">
<Value>linkItemDr</Value>
</Value>
<Value name="6">
<Value>lineStyle</Value>
</Value>
<Value name="7">
<Value>showWay</Value>
</Value>
<Value name="8">
<Value>condition</Value>
</Value>
<Value name="9">
<Value>rowKey</Value>
</Value>
<Value name="10">
<Value>feverIconSize</Value>
</Value>
<Value name="11">
<Value>iconOffset</Value>
</Value>
<Value name="12">
<Value>lineWidth</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildChartFever")</DataLocation>
<DefaultData>ChartSuddenFeverDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartC("ChildChartFever")</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartSuddenFeverI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ChartSuddenFeverS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
