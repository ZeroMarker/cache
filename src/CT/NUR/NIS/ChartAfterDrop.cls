/// 复测降温配置
Class CT.NUR.NIS.ChartAfterDrop Extends %Persistent [ SqlTableName = AfterDrop, StorageStrategy = CacheStorage ]
{

// Index RowIDBasedIDKeyIndex On CurveChildsub [ IdKey, PrimaryKey, Unique ];

/// Chart Parent Reference
Relationship DropParRef As Chart [ Cardinality = parent, Inverse = ChildChartDrop, Required, SqlFieldName = ParRef ];

/// 体征项
Property itemDr As User.MRCObservationItem [ Required, SqlColumnNumber = 3, SqlFieldName = itemDr ];

/// 图标描述 
Property dropDesc As %String [ Required, SqlColumnNumber = 4, SqlFieldName = dropDesc ];

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
Property dropIconSize As %String [ SqlColumnNumber = 11, SqlFieldName = dropIconSize ];

/// 图标上下偏移量
Property iconOffset As %String [ SqlColumnNumber = 12, SqlFieldName = iconOffset ];

/// 线宽
Property lineWidth As %String [ SqlColumnNumber = 13, SqlFieldName = lineWidth ];

/// xAxis 
Property xAxis As %String [ SqlColumnNumber = 14, SqlFieldName = xAxis ];

/// yAxis 
Property yAxis As %String [ SqlColumnNumber = 15, SqlFieldName = yAxis ];

/// cHeight 
Property cHeight As %String [ SqlColumnNumber = 16, SqlFieldName = cHeight ];

/// cWidth 
Property cWidth As %String [ SqlColumnNumber = 17, SqlFieldName = cWidth ];

/// minScaleValue 
Property minScaleValue As %String [ SqlColumnNumber = 18, SqlFieldName = minScaleValue ];

/// maxValue 
Property maxValue As %String [ SqlColumnNumber = 19, SqlFieldName = maxValue ];

/// minValue 
Property minValue As %String [ SqlColumnNumber = 20, SqlFieldName = minValue ];

Index RowID On (DropParRef, rowKey) [ Unique ];

Storage CacheStorage
{
<Data name="ChartAfterDropDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>itemDr</Value>
</Value>
<Value name="3">
<Value>dropDesc</Value>
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
<Value>dropIconSize</Value>
</Value>
<Value name="11">
<Value>iconOffSet</Value>
</Value>
<Value name="12">
<Value>iconOffset</Value>
</Value>
<Value name="13">
<Value>lineWidth</Value>
</Value>
<Value name="14">
<Value>xAxis</Value>
</Value>
<Value name="15">
<Value>yAxis</Value>
</Value>
<Value name="16">
<Value>cHeight</Value>
</Value>
<Value name="17">
<Value>cWidth</Value>
</Value>
<Value name="18">
<Value>minScaleValue</Value>
</Value>
<Value name="19">
<Value>maxValue</Value>
</Value>
<Value name="20">
<Value>minValue</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildChartDrop")</DataLocation>
<DefaultData>ChartAfterDropDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartC("ChildChartDrop")</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartAfterDropI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ChartAfterDropS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
