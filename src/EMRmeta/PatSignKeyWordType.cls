/// 名称:EMRmeta.PatSignKeyWordType
/// 描述:患者签名类型
/// 编写者：yejian
/// 编写日期: 2022-3-7
Class EMRmeta.PatSignKeyWordType Extends %Persistent
{

Index idxCode On Code;

/// 编码(ISNULL(默认)/AGREE/REFUSE)
Property Code As %String(TRUNCATE = 1);

/// 名称(空值/同意/拒绝)
Property Name As %String(TRUNCATE = 1);

Storage Default
{
<Data name="PatSignKeyWordTypeDefaultData">
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
<DataLocation>^DHCEMRM.PatSignKeyWordTypeD</DataLocation>
<DefaultData>PatSignKeyWordTypeDefaultData</DefaultData>
<IdLocation>^DHCEMRM.PatSignKeyWordTypeD</IdLocation>
<IndexLocation>^DHCEMRM.PatSignKeyWordTypeI</IndexLocation>
<StreamLocation>^DHCEMRM.PatSignKeyWordTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
