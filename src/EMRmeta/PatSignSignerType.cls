/// 名称:EMRmeta.PatSignSignerType
/// 描述: 签名者类型
/// 编写者：yejian
/// 编写日期: 2022-6-23
Class EMRmeta.PatSignSignerType Extends %Persistent
{

Index idxCode On Code;

/// 编码(SELF(默认)/FAMILY)
Property Code As %String(TRUNCATE = 1);

/// 名称(患者本人签署/家属签署)
Property Name As %String(TRUNCATE = 1);

Storage Default
{
<Data name="PatSignSignerTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PatSignSignerTypeD</DataLocation>
<DefaultData>PatSignSignerTypeDefaultData</DefaultData>
<IdLocation>^DHCEMRM.PatSignSignerTypeD</IdLocation>
<IndexLocation>^DHCEMRM.PatSignSignerTypeI</IndexLocation>
<StreamLocation>^DHCEMRM.PatSignSignerTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
