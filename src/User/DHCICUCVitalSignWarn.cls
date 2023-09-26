Class User.DHCICUCVitalSignWarn Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = ICUCVI_RowId, SqlTableName = DHC_ICUC_VitalSignWarn ]
{

Property ICUCVIParref As %String(MAXLEN = 500) [ SqlColumnNumber = 2, SqlFieldName = ICUCVI_Parref ];

/// 代码
Property ICUCVICode As %String(MAXLEN = 500) [ SqlColumnNumber = 3, SqlFieldName = ICUCVI_Code ];

/// 描述
Property ICUCVIDesc As %String [ SqlColumnNumber = 4, SqlFieldName = ICUCVI_Desc ];

/// 来源
Property ICUCVIType As %String(DISPLAYLIST = ",生命体征,检验结果,药物,体温单", MAXLEN = 9, SELECTIVITY = "10%", TRUNCATE = 1, VALUELIST = ",V,L,O,N") [ SqlColumnNumber = 5, SqlFieldName = ICUCVI_Type ];

/// 最小值
Property ICUCVIMinQty As %String [ SqlColumnNumber = 6, SqlFieldName = ICUCVI_MinQty ];

/// 最大值
Property ICUCVIMaxQty As %String [ SqlColumnNumber = 7, SqlFieldName = ICUCVI_MaxQty ];

/// 主项描述
Property ICUCVIMainItem As %String [ SqlColumnNumber = 8, SqlFieldName = ICUCVI_MainItem ];

/// 持续小时
Property ICUCVIDuration As %String [ SqlColumnNumber = 9, SqlFieldName = ICUCVI_Duration ];

/// 关联医嘱
Property ICUCVIArcim As %String [ SqlColumnNumber = 10, SqlFieldName = ICUCVI_Arcim ];

/// 常用医嘱
Property ICUCVIIcuriId As %String [ SqlColumnNumber = 11, SqlFieldName = ICUCVI_IcuriId ];

/// 排序号
Property ICUCVISeqNo As %String [ SqlColumnNumber = 12, SqlFieldName = ICUCVI_SeqNo ];

/// 配置类型
Property ICUCVIConfigType As %String(DISPLAYLIST = ",主项,查找项,显示项", MAXLEN = 9, VALUELIST = ",M,S,D") [ SqlColumnNumber = 13, SqlFieldName = ICUCVI_ConfigType ];

/// 关联主项
Property ICUCVIMainItemLink As %String [ SqlColumnNumber = 14, SqlFieldName = ICUCVI_MainItemLink ];

Index Inquiry On ICUCVIParref;

Storage Default
{
<Data name="VitalSignWarnDefaultData">
<Value name="1">
<Value>ICUCVIParref</Value>
</Value>
<Value name="2">
<Value>ICUCVICode</Value>
</Value>
<Value name="3">
<Value>ICUCVIDesc</Value>
</Value>
<Value name="4">
<Value>ICUCVIType</Value>
</Value>
<Value name="5">
<Value>ICUCVIMinQty</Value>
</Value>
<Value name="6">
<Value>ICUCVIMaxQty</Value>
</Value>
<Value name="7">
<Value>ICUCVIMainItem</Value>
</Value>
<Value name="8">
<Value>ICUCVIDuration</Value>
</Value>
<Value name="9">
<Value>ICUCVIArcim</Value>
</Value>
<Value name="10">
<Value>ICUCVIIcuriId</Value>
</Value>
<Value name="11">
<Value>ICUCVISeqNo</Value>
</Value>
<Value name="12">
<Value>ICUCVIConfigType</Value>
</Value>
<Value name="13">
<Value>ICUCVIMainItemLink</Value>
</Value>
</Data>
<DataLocation>^DHCICUCVitalSignWarnD</DataLocation>
<DefaultData>VitalSignWarnDefaultData</DefaultData>
<IdLocation>^DHCICUCVitalSignWarnD</IdLocation>
<IndexLocation>^DHCICUCVitalSignWarnI</IndexLocation>
<StreamLocation>^DHCICUCVitalSignWarnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
