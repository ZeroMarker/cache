/// 名称: EMRmeta.ToothRepresentation
/// 描述: 牙位表示法表
/// 编写者：yejian
/// 编写日期: 2020-7-22
Class EMRmeta.ToothRepresentation Extends %Persistent
{

Index IdxCode On ToothCode;

Index IdxStatusCode On (Status, ToothCode);

Index IdxCodeStatus On (ToothCode, Status);

/// 代码
Property ToothCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property ToothName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 状态(0:未使用，1：正在使用)
Property Status As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="ToothRepresentationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ToothCode</Value>
</Value>
<Value name="3">
<Value>ToothName</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ToothRepresentationD</DataLocation>
<DefaultData>ToothRepresentationDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ToothRepresentationD</IdLocation>
<IndexLocation>^DHCEMRM.ToothRepresentationI</IndexLocation>
<StreamLocation>^DHCEMRM.ToothRepresentationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
