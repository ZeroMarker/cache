Class CT.NUR.NIS.ChartCurve Extends %Persistent [ SqlTableName = ChartCurve, StorageStrategy = CacheStorage ]
{

// Index RowIDBasedIDKeyIndex On CurveChildsub [ IdKey, PrimaryKey, Unique ];

// Index ItemUnique On (CurveParRef, itemDr) [ Unique ];

/// Chart Parent Reference
Relationship CurveParRef As Chart [ Cardinality = parent, Inverse = ChildChartCurve, Required, SqlFieldName = ParRef ];

// Property CurveChildsub As %Integer [ InitialExpression = {$i(^CT.NUR.NIS.Chart($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CURVE",0))}, SqlColumnNumber = 2, SqlFieldName = Childsub ];

/// Childsub
/// Item
Property itemDr As User.MRCObservationItem [ Required, SqlColumnNumber = 3, SqlFieldName = itemDr ];

/// xAxis 
Property xAxis As %String [ Required, SqlColumnNumber = 4, SqlFieldName = xAxis ];

/// yAxis 
Property yAxis As %String [ Required, SqlColumnNumber = 5, SqlFieldName = yAxis ];

/// cHeight 
Property cHeight As %String [ Required, SqlColumnNumber = 6, SqlFieldName = cHeight ];

/// cWidth 
Property cWidth As %String [ Required, SqlColumnNumber = 7, SqlFieldName = cWidth ];

/// minScaleValue 
Property minScaleValue As %String [ Required, SqlColumnNumber = 8, SqlFieldName = minScaleValue ];

/// maxValue 
Property maxValue As %String [ Required, SqlColumnNumber = 9, SqlFieldName = maxValue ];

/// color 
Property color As %String [ SqlColumnNumber = 10, SqlFieldName = color ];

/// color 
Property icon As %String [ SqlColumnNumber = 11, SqlFieldName = icon ];

/// iconSize 
Property iconSize As %String [ SqlColumnNumber = 12, SqlFieldName = iconSize ];

/// teamCode 多个体征项作成一条线(腋温,口温等) 
Property teamCode As %String [ SqlColumnNumber = 13, SqlFieldName = teamCode ];

/// minValue 
Property minValue As %String [ SqlColumnNumber = 14, SqlFieldName = minValue ];

/// rowKey
Property rowKey As %String [ SqlColumnNumber = 15, SqlFieldName = rowKey ];

/// 数值转换
Property valueTransform As ChartDict [ SqlColumnNumber = 16, SqlFieldName = valueTransform ];

/// 重叠图标
Property overIcon As %String [ SqlColumnNumber = 17, SqlFieldName = overIcon ];

/// 重叠图标大小
Property overIconSize As %String [ SqlColumnNumber = 18, SqlFieldName = overIconSize ];

/// 图标字体样式
Property iconFontStyle As %String [ SqlColumnNumber = 19, SqlFieldName = iconFontStyle ];

/// 线宽
Property lineWidth As %String [ SqlColumnNumber = 20, SqlFieldName = lineWidth ];

Index Item On (itemDr, CurveParRef);

Index RowKey On (CurveParRef, rowKey) [ Unique ];

Index TeamCode On (CurveParRef, teamCode);

Storage CacheStorage
{
<Data name="ChartCurveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>itemDr</Value>
</Value>
<Value name="3">
<Value>xAxis</Value>
</Value>
<Value name="4">
<Value>yAxis</Value>
</Value>
<Value name="5">
<Value>cHeight</Value>
</Value>
<Value name="6">
<Value>cWidth</Value>
</Value>
<Value name="7">
<Value>minScaleValue</Value>
</Value>
<Value name="8">
<Value>maxValue</Value>
</Value>
<Value name="9">
<Value>color</Value>
</Value>
<Value name="10">
<Value>icon</Value>
</Value>
<Value name="11">
<Value>iconSize</Value>
</Value>
<Value name="12">
<Value>teamCode</Value>
</Value>
<Value name="13">
<Value>minValue</Value>
</Value>
<Value name="14">
<Value>rowKey</Value>
</Value>
<Value name="15">
<Value>valueTransform</Value>
</Value>
<Value name="16">
<Value>overIcon</Value>
</Value>
<Value name="17">
<Value>overIconSize</Value>
</Value>
<Value name="18">
<Value>iconFontStyle</Value>
</Value>
<Value name="19">
<Value>lineWidth</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildChartCurve")</DataLocation>
<DefaultData>ChartCurveDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ChartC("ChildChartCurve")</IdLocation>
<IndexLocation>^CT.NUR.NIS.ChartCurveI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ChartCurveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
