/// Creator:Xuwenhu
/// CreatDate:2020-07-16
/// Description：单位转换字典表
/// Table：CT.WDT.CDSS.UnitConversion
Class CT.WDT.CDSS.UnitConversion Extends (%Persistent, User.Abstract)
{

/// 从单位
Property FromUnitDR As CT.WDT.CDSS.UnitDict [ Required ];

/// 到单位
Property ToUnitDR As CT.WDT.CDSS.UnitDict [ Required ];

/// 转换系数
Property ConversionFactor As %Float [ Required ];

/// 状态（0编辑中，1已弃用，2已审核）
Property UseFlag As %String;

/// 操作人员
Property UpdateUser As %String;

/// 操作时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index FromUnitIndex On FromUnitDR;

Index FromToUnitIndex On (FromUnitDR, ToUnitDR);

Index UpdateDateIndex On UpdateDate As Exact;

Storage Default
{
<Data name="UnitConversionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FromUnitDR</Value>
</Value>
<Value name="3">
<Value>ToUnitDR</Value>
</Value>
<Value name="4">
<Value>ConversionFactor</Value>
</Value>
<Value name="5">
<Value>UseFlag</Value>
</Value>
<Value name="6">
<Value>UpdateUser</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.UnitConversionD</DataLocation>
<DefaultData>UnitConversionDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.UnitConversionD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.UnitConversionI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.UnitConversionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
