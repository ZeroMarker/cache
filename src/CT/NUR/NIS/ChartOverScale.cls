/// 超出标尺的折线值配置
Class CT.NUR.NIS.ChartOverScale Extends %Persistent [ SqlTableName = OverScale, StorageStrategy = CacheStorage ]
{

/// Chart Parent Reference
Relationship OverScaleParRef As Chart [ Cardinality = parent, Inverse = ChildOverScale, Required, SqlFieldName = ParRef ];

/// 体征项
Property itemDr As User.MRCObservationItem [ Required, SqlColumnNumber = 3, SqlFieldName = itemDr ];

/// 条件 
Property condition As %String [ SqlColumnNumber = 4, SqlFieldName = condition ];

/// 数值 
Property number As %String [ Required, SqlColumnNumber = 5, SqlFieldName = number ];

/// 显示方式 
Property showWay As %String [ SqlColumnNumber = 6, SqlFieldName = showWay ];

/// 图标 
Property icon As %String [ Required, SqlColumnNumber = 7, SqlFieldName = icon ];

/// 是否连线 
Property ifLine As %String(DISPLAYLIST = ",是,否", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ifLine ];

/// key 
Property rowKey As %String [ Required, SqlColumnNumber = 9, SqlFieldName = rowKey ];

/// 定位方式
Property locationModeDr As ChartDict [ SqlColumnNumber = 10, SqlFieldName = locationModeDr ];

/// 横坐标 
Property xAxis As %String [ Required, SqlColumnNumber = 11, SqlFieldName = xAxis ];

/// 纵坐标 
Property yAxis As %String [ Required, SqlColumnNumber = 12, SqlFieldName = yAxis ];

/// 字体
Property fontFamily As %String [ SqlColumnNumber = 13, SqlFieldName = fontFamily ];

/// 字体大小
Property fontSize As %Integer [ SqlColumnNumber = 14, SqlFieldName = fontSize ];

/// 字体样式
Property fontStyle As %String [ SqlColumnNumber = 15, SqlFieldName = fontStyle ];

/// 字体颜色
Property color As %String [ SqlColumnNumber = 16, SqlFieldName = color ];

/// 小格宽度
Property cellWidth As %String [ SqlColumnNumber = 17, SqlFieldName = cellWidth ];

/// 小格高度
Property cellHeight As %String [ SqlColumnNumber = 18, SqlFieldName = cellHeight ];

/// 文字对齐方式 
Property alignment As %String [ InitialExpression = "Center", Required, SqlColumnNumber = 19, SqlFieldName = alignment ];

/// 关联体征项
Property linkItem As %String [ SqlColumnNumber = 20, SqlFieldName = linkItem ];

/// 值横向偏移量
Property offsetX As %String [ SqlColumnNumber = 21, SqlFieldName = offsetX ];

/// 值纵向偏移量
Property offsetY As %String [ SqlColumnNumber = 22, SqlFieldName = offsetY ];

/// 值字号大小
Property valueFontSize As %String [ SqlColumnNumber = 23, SqlFieldName = valueFontSize ];

/// 图标横向偏移量
Property iconOffsetX As %String [ SqlColumnNumber = 24, SqlFieldName = iconOffsetX ];

/// 图标纵向偏移量
Property iconOffsetY As %String [ SqlColumnNumber = 25, SqlFieldName = iconOffsetY ];

Index RowID On (OverScaleParRef, rowKey) [ Unique ];

Index IfItemBreak On (OverScaleParRef, itemDr, ifLine);

Storage CacheStorage
{
<Data name="ChartOverScaleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>itemDr</Value>
</Value>
<Value name="3">
<Value>condition</Value>
</Value>
<Value name="4">
<Value>number</Value>
</Value>
<Value name="5">
<Value>showWay</Value>
</Value>
<Value name="6">
<Value>icon</Value>
</Value>
<Value name="7">
<Value>ifLine</Value>
</Value>
<Value name="8">
<Value>rowKey</Value>
</Value>
<Value name="9">
<Value>locationModeDr</Value>
</Value>
<Value name="10">
<Value>xAxis</Value>
</Value>
<Value name="11">
<Value>yAxis</Value>
</Value>
<Value name="12">
<Value>fontFamily</Value>
</Value>
<Value name="13">
<Value>fontSize</Value>
</Value>
<Value name="14">
<Value>fontStyle</Value>
</Value>
<Value name="15">
<Value>color</Value>
</Value>
<Value name="16">
<Value>cellWidth</Value>
</Value>
<Value name="17">
<Value>cellHeight</Value>
</Value>
<Value name="18">
<Value>alignment</Value>
</Value>
<Value name="19">
<Value>linkItem</Value>
</Value>
<Value name="20">
<Value>offsetX</Value>
</Value>
<Value name="21">
<Value>offsetY</Value>
</Value>
<Value name="22">
<Value>valueFontSize</Value>
</Value>
<Value name="23">
<Value>iconOffsetX</Value>
</Value>
<Value name="24">
<Value>iconOffsetY</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildOverScale")</DataLocation>
<DefaultData>ChartOverScaleDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartC("ChildOverScale")</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartOverScaleI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ChartOverScaleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
