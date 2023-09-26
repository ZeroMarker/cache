Class CT.NUR.NIS.ChartCycleVal Extends %Persistent [ SqlTableName = ChartCycleVal, StorageStrategy = CacheStorage ]
{

/// Chart Parent Reference
Relationship CycleValParRef As Chart [ Cardinality = parent, Inverse = ChildCycleVal, Required, SqlFieldName = ParRef ];

/// desc
Property desc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = itemDesc ];

/// 取值函数
Property expression As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 4, SqlFieldName = expression ];

/// 取值函数循环次数
Property loopTimes As %Integer [ SqlColumnNumber = 17, SqlFieldName = loopTimes ];

/// 横坐标 
Property xAxis As %String [ Required, SqlColumnNumber = 5, SqlFieldName = xAxis ];

/// 纵坐标 
Property yAxis As %String [ Required, SqlColumnNumber = 6, SqlFieldName = yAxis ];

/// 类型 
Property type As %String [ Required, SqlColumnNumber = 7, SqlFieldName = type ];

/// 标题宽度 
Property width As %String [ Required, SqlColumnNumber = 8, SqlFieldName = width ];

/// 文字对齐方式 
Property alignment As %String [ InitialExpression = "Center", Required, SqlColumnNumber = 9, SqlFieldName = alignment ];

/// 字体
Property fontFamily As %String [ Required, SqlColumnNumber = 10, SqlFieldName = fontFamily ];

/// 字体大小
Property fontSize As %Integer [ Required, SqlColumnNumber = 11, SqlFieldName = fontSize ];

/// 字体样式
Property fontStyle As %String [ Required, SqlColumnNumber = 12, SqlFieldName = fontStyle ];

/// 字体颜色
Property color As %String [ Required, SqlColumnNumber = 13, SqlFieldName = color ];

/// 元素宽度
Property itemWidth As %String [ Required, SqlColumnNumber = 14, SqlFieldName = itemWidth ];

/// 绑定元素字体大小
Property itemFontSize As %String [ Required, SqlColumnNumber = 15, SqlFieldName = itemFontSize ];

/// 绑定元素对齐方式
Property itemAlign As %String [ Required, SqlColumnNumber = 16, SqlFieldName = itemAlign ];

/// 绑定元素字体样式
Property itemFontStyle As %String [ SqlColumnNumber = 18, SqlFieldName = itemFontStyle ];

/// key 
Property rowKey As %String [ Required, SqlColumnNumber = 19, SqlFieldName = rowKey ];

/// 绑定元素字体颜色
Property itemColor As %String [ SqlColumnNumber = 20, SqlFieldName = itemColor ];

/// 绑定元素下划线
Property itemUnderline As %String [ SqlColumnNumber = 21, SqlFieldName = itemUnderline ];

Index rowKey On (CycleValParRef, rowKey) [ Unique ];

Storage CacheStorage
{
<Data name="ChartCycleValDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>desc</Value>
</Value>
<Value name="3">
<Value>expression</Value>
</Value>
<Value name="4">
<Value>xAxis</Value>
</Value>
<Value name="5">
<Value>yAxis</Value>
</Value>
<Value name="6">
<Value>type</Value>
</Value>
<Value name="7">
<Value>width</Value>
</Value>
<Value name="8">
<Value>alignment</Value>
</Value>
<Value name="9">
<Value>fontFamily</Value>
</Value>
<Value name="10">
<Value>fontSize</Value>
</Value>
<Value name="11">
<Value>fontStyle</Value>
</Value>
<Value name="12">
<Value>color</Value>
</Value>
<Value name="13">
<Value>itemWidth</Value>
</Value>
<Value name="14">
<Value>itemFontSize</Value>
</Value>
<Value name="15">
<Value>itemAlign</Value>
</Value>
<Value name="16">
<Value>loopTimes</Value>
</Value>
<Value name="17">
<Value>itemFontStyle</Value>
</Value>
<Value name="18">
<Value>rowKey</Value>
</Value>
<Value name="19">
<Value>itemColor</Value>
</Value>
<Value name="20">
<Value>itemUnderline</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildCycleVal")</DataLocation>
<DefaultData>ChartCycleValDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartC("ChildCycleVal")</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartCycleValI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ChartCycleValS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
