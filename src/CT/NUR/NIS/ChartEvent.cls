/// 体温单事件配置
Class CT.NUR.NIS.ChartEvent Extends %Persistent [ SqlTableName = ChartEvent, StorageStrategy = CacheStorage ]
{

/// Chart Parent Reference
Relationship EventParRef As Chart [ Cardinality = parent, Inverse = ChildChartEvent, Required, SqlFieldName = ParRef ];

/// 事件
Property eventDr As User.DHCQTRECTYP [ Required, SqlColumnNumber = 2, SqlFieldName = eventDr ];

/// 是否显示时间
Property ifShowTime As %String(DISPLAYLIST = ",显示,不显示", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 3, SqlFieldName = ifShowTime ];

/// 间隔方式
Property intervalMode As %String [ SqlColumnNumber = 4, SqlFieldName = intervalMode ];

/// 定位方式
Property locationModeDr As ChartDict [ SqlColumnNumber = 5, SqlFieldName = locationModeDr ];

/// 横坐标 
Property xAxis As %String [ Required, SqlColumnNumber = 6, SqlFieldName = xAxis ];

/// 纵坐标 
Property yAxis As %String [ Required, SqlColumnNumber = 7, SqlFieldName = yAxis ];

/// 文字对齐方式 
Property alignment As %String [ InitialExpression = "Center", Required, SqlColumnNumber = 8, SqlFieldName = alignment ];

/// 字体
Property fontFamily As %String [ SqlColumnNumber = 9, SqlFieldName = fontFamily ];

/// 字体大小
Property fontSize As %Integer [ SqlColumnNumber = 10, SqlFieldName = fontSize ];

/// 字体样式
Property fontStyle As %String [ SqlColumnNumber = 11, SqlFieldName = fontStyle ];

/// 字体颜色
Property color As %String [ SqlColumnNumber = 12, SqlFieldName = color ];

/// 文字方向
Property txtDirection As %String [ InitialExpression = "DirectionVertical", SqlColumnNumber = 13, SqlFieldName = txtDirection ];

/// 小格宽度
Property cellWidth As %String [ SqlColumnNumber = 14, SqlFieldName = cellWidth ];

/// 小格高度
Property cellHeight As %String [ SqlColumnNumber = 15, SqlFieldName = cellHeight ];

/// 时间样式
Property timeFormat As %String [ SqlColumnNumber = 16, SqlFieldName = timeFormat ];

/// 显示的事件名
Property eventName As %String [ SqlColumnNumber = 17, SqlFieldName = eventName ];

Index EventUnique On (EventParRef, eventDr) [ Unique ];

Storage CacheStorage
{
<Data name="ChartEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>eventDr</Value>
</Value>
<Value name="3">
<Value>ifShowTime</Value>
</Value>
<Value name="4">
<Value>intervalModeDr</Value>
</Value>
<Value name="5">
<Value>locationModeDr</Value>
</Value>
<Value name="6">
<Value>xAxis</Value>
</Value>
<Value name="7">
<Value>yAxis</Value>
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
<Value>txtDirection</Value>
</Value>
<Value name="14">
<Value>intervalMode</Value>
</Value>
<Value name="15">
<Value>cellWidth</Value>
</Value>
<Value name="16">
<Value>cellHeight</Value>
</Value>
<Value name="17">
<Value>timeFormat</Value>
</Value>
<Value name="18">
<Value>eventName</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildChartEvent")</DataLocation>
<DefaultData>ChartEventDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartC("ChildChartEvent")</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartEventI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ChartEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
