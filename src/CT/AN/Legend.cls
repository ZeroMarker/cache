/// 图例
Class CT.AN.Legend Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Legend ]
{

/// 图例代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 图例名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 基准点X坐标
Property BasePosX As %Float [ SqlColumnNumber = 4 ];

/// 基准点Y坐标
Property BasePosY As %Float [ SqlColumnNumber = 5 ];

/// 线段宽度
Property LineWeight As %Float [ SqlColumnNumber = 6 ];

/// 图例宽度
Property Width As %Float [ SqlColumnNumber = 7 ];

/// 图例高度
Property Height As %Float [ SqlColumnNumber = 8 ];

/// 图例图片URL
Property ImageUrl As %String [ SqlColumnNumber = 9 ];

/// 是否填充图形
Property FillShape As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 10 ];

/// 图例代码唯一索引
Index ICode On Code [ Unique ];

Storage Default
{
<Data name="LegendDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>BasePosX</Value>
</Value>
<Value name="4">
<Value>BasePosY</Value>
</Value>
<Value name="5">
<Value>LineWeight</Value>
</Value>
<Value name="6">
<Value>Width</Value>
</Value>
<Value name="7">
<Value>Height</Value>
</Value>
<Value name="8">
<Value>ImageUrl</Value>
</Value>
<Value name="9">
<Value>FillShape</Value>
</Value>
</Data>
<DataLocation>^CT.AN.LegendD</DataLocation>
<DefaultData>LegendDefaultData</DefaultData>
<IdLocation>^CT.AN.LegendD</IdLocation>
<IndexLocation>^CT.AN.LegendI</IndexLocation>
<StreamLocation>^CT.AN.LegendS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
