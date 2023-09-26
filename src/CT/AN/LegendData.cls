/// 图例数据
Class CT.AN.LegendData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = LegendData ]
{

/// 形状类型
Property ShapeType As %String(DISPLAYLIST = ",线段,空心圆,圆弧,实心圆", VALUELIST = ",L,C,A,R") [ Required, SqlColumnNumber = 2 ];

/// 起点X坐标(线段)，圆心X坐标(圆)，圆弧起点X坐标(圆弧)
Property StartPosX As %Float [ SqlColumnNumber = 3 ];

/// 起点Y坐标(线段)，圆心Y坐标(圆)，圆弧起点Y坐标(圆弧)
Property StartPosY As %Float [ SqlColumnNumber = 4 ];

/// 终点X坐标(线段)，圆弧终点X坐标(圆弧)
Property EndPosX As %Float [ SqlColumnNumber = 5 ];

/// 终点Y坐标(线段)，圆弧终点Y坐标(圆弧)
Property EndPosY As %Float [ SqlColumnNumber = 6 ];

/// 半径(圆，圆弧)
Property Radius As %Float [ SqlColumnNumber = 7 ];

/// 弧度倍数(基本弧度为Math.PI=180°)
Property RadianMultiple As %Float [ SqlColumnNumber = 8 ];

/// 图例
Property Legend As CT.AN.Legend [ SqlColumnNumber = 9 ];

/// 图例索引
Index ILegend On Legend;

/// 图例外键约束
ForeignKey FKLegend(Legend) References CT.AN.Legend() [ OnDelete = cascade ];

Storage Default
{
<Data name="LegendDataDefaultData">
<Value name="1">
<Value>ShapeType</Value>
</Value>
<Value name="2">
<Value>StartPosX</Value>
</Value>
<Value name="3">
<Value>StartPosY</Value>
</Value>
<Value name="4">
<Value>EndPosX</Value>
</Value>
<Value name="5">
<Value>EndPosY</Value>
</Value>
<Value name="6">
<Value>Radius</Value>
</Value>
<Value name="7">
<Value>RadianMultiple</Value>
</Value>
<Value name="8">
<Value>Legend</Value>
</Value>
</Data>
<DataLocation>^CT.AN.LegendDataD</DataLocation>
<DefaultData>LegendDataDefaultData</DefaultData>
<IdLocation>^CT.AN.LegendDataD</IdLocation>
<IndexLocation>^CT.AN.LegendDataI</IndexLocation>
<StreamLocation>^CT.AN.LegendDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
