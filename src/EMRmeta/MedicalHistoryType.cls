/// Desc:病史类型
/// Creator:Donglulu
/// CreateDate:2020-12-9
Class EMRmeta.MedicalHistoryType Extends (%Persistent, User.Abstract)
{

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 术语集代码
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 别名
Property Alias As %String(TRUNCATE = 1);

/// 顺序
Property Seq As %Integer;

Index IdxCode On Code [ Unique ];

Index IdxSeqCode On (Seq, Code);

Storage Default
{
<Data name="MedicalHistoryTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Alias</Value>
</Value>
<Value name="5">
<Value>Seq</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.MedHistoryTypeD</DataLocation>
<DefaultData>MedicalHistoryTypeDefaultData</DefaultData>
<IdLocation>^DHCEMRM.MedHistoryTypeD</IdLocation>
<IndexLocation>^DHCEMRM.MedHistoryTypeI</IndexLocation>
<StreamLocation>^DHCEMRM.MedHistoryTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
