/// 名称:	CT.MA.QC.QualitySetting
/// 描述:	质控启动项维护
/// 编写者：hky
/// 编写日期: 2021-06-16
Class CT.MA.QC.QualitySetting Extends (%Persistent, User.Abstract)
{

Index IdxSSGroup On (SSGroupDR, EventTypeDR, HospitalDR);

Index IdxHospitalStruct On (IsActive, QualityRuleDR, HospitalDR, StructDR);

Index IdxComposite On (HospitalDR, SSGroupDR, EventTypeDR, ControlTypeDR, QualityRuleDR) [ Unique ];

/// Binding hospital reference
Property HospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Binding security group reference
Property SSGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Binding event type reference
Property EventTypeDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// Binding control type reference
Property ControlTypeDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// Binding quality rule reference
Property QualityRuleDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// Whether this quality setting is active or not
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// Resume of this quality setting
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// 病历目录结构
Property StructDR As %Integer [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="QualitySettingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>SSGroupDR</Value>
</Value>
<Value name="4">
<Value>EventTypeDR</Value>
</Value>
<Value name="5">
<Value>ControlTypeDR</Value>
</Value>
<Value name="6">
<Value>QualityRuleDR</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
<Value name="9">
<Value>StructDR</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualitySettingD</DataLocation>
<DefaultData>QualitySettingDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualitySettingD</IdLocation>
<IndexLocation>^CT.MA.QC.QualitySettingI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualitySettingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
