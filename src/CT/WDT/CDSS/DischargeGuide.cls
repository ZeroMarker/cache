/// Creator:谷雪萍
/// CreatDate:2021-11-2
/// Description：出院指导字典表
/// Table：CT.WDT.CDSS.DischargeGuide
Class CT.WDT.CDSS.DischargeGuide Extends (%Persistent, User.Abstract)
{

/// 出院指导名称
Property DGuideName As %String;

/// 来源
Property DGuideSource As %String;

/// 状态：4-待审核、3-已审核、2-已驳回、1-已弃用、0-编辑中
Property DGuideState As %String;

/// 编辑人
Property UpdateUser As %String;

/// 操作时间
Property UpdateDate As %TimeStamp;

/// 审核人
Property AuditUser As %String;

Index NameIndex On DGuideName As Exact;

Index UpdateDateIndex On UpdateDate;

Storage Default
{
<Data name="DischargeGuideDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DGuideName</Value>
</Value>
<Value name="3">
<Value>DGuideSource</Value>
</Value>
<Value name="4">
<Value>DGuideState</Value>
</Value>
<Value name="5">
<Value>UpdateUser</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>AuditUser</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DischargeGuideD</DataLocation>
<DefaultData>DischargeGuideDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DischargeGuideD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DischargeGuideI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DischargeGuideS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
