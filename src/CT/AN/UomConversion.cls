/// 单位转换表
Class CT.AN.UomConversion Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = UomConversion ]
{

/// 源单位
Property Source As CT.AN.Uom [ Required, SqlColumnNumber = 2 ];

/// 目标单位
Property Target As CT.AN.Uom [ Required, SqlColumnNumber = 3 ];

/// 转换系数
Property Factor As %Float [ Required, SqlColumnNumber = 4 ];

/// 源单位索引
Index Source On Source;

/// 目标单位索引
Index Target On Target;

/// 源单位外键约束
ForeignKey FKSource(Source) References CT.AN.Uom() [ OnDelete = cascade ];

Storage Default
{
<Data name="UomConversionDefaultData">
<Value name="1">
<Value>Source</Value>
</Value>
<Value name="2">
<Value>Target</Value>
</Value>
<Value name="3">
<Value>Factor</Value>
</Value>
</Data>
<DataLocation>^CT.AN.UomConversionD</DataLocation>
<DefaultData>UomConversionDefaultData</DefaultData>
<IdLocation>^CT.AN.UomConversionD</IdLocation>
<IndexLocation>^CT.AN.UomConversionI</IndexLocation>
<StreamLocation>^CT.AN.UomConversionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
