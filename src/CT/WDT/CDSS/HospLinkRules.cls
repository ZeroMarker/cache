/// Creator:钟荣枫
/// CreatDate:2020-05-30
/// Description：实施综合管理平台-医院关联规则表
/// Table：CT.WDT.CDSS.HospLinkRules
Class CT.WDT.CDSS.HospLinkRules Extends (%Persistent, User.Abstract)
{

/// 医院指针
Property HospitalDR As CT.WDT.CDSS.CustomerHosp;

/// 对接系统名称
Property SystemName As %String;

/// 记录格式
Property RecordFormat As %String;

/// 记录类型
Property RecordTypeDR As CT.WDT.CDSS.RecordType;

/// 模板名称
Property TempleName As %String;

/// 创建时间
Property CreateTime As %TimeStamp;

/// 修改时间
Property EditTime As %TimeStamp;

/// 使用标志（0在用，1停用）
Property UseFlag As %String;

/// 备注
Property Remarks As %String;

/// 记录内容
Property RecordContent As %String(MAXLEN = "");

Index UniqueIndex On (HospitalDR, SystemName As Exact, RecordFormat As Exact, RecordTypeDR, TempleName As Exact);

Storage Default
{
<Data name="HospLinkRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>SystemName</Value>
</Value>
<Value name="4">
<Value>RecordFormat</Value>
</Value>
<Value name="5">
<Value>RecordTypeDR</Value>
</Value>
<Value name="6">
<Value>TempleName</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>EditTime</Value>
</Value>
<Value name="9">
<Value>UseFlag</Value>
</Value>
<Value name="10">
<Value>Remarks</Value>
</Value>
<Value name="11">
<Value>RecordContent</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.HospLinkRulesD</DataLocation>
<DefaultData>HospLinkRulesDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.HospLinkRulesD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.HospLinkRulesI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.HospLinkRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
