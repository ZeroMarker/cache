/// 名称:EMRmeta.PatSignOrder
/// 描述:患者签名排序表
/// 编写者：yejian
/// 编写日期: 2021-11-3
Class EMRmeta.PatSignOrder Extends %Persistent
{

Index idxTemID On (TemplateID, VersionNum) [ Unique ];

/// 模板ID
Property TemplateID As %Integer;

/// 模板版本
Property VersionNum As %Integer;

/// 签名数据[{"displayName":"患者","path":"S007_V006_L0011"},{"displayName":"委托人签名","path": "S007_V006_L0012","keyWordType":"同意"}]
Property SignData As %String(MAXLEN = 10000, TRUNCATE = 1);

Storage Default
{
<Data name="PatSignOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>VersionNum</Value>
</Value>
<Value name="4">
<Value>SignData</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PatSignOrderD</DataLocation>
<DefaultData>PatSignOrderDefaultData</DefaultData>
<IdLocation>^DHCEMRM.PatSignOrderD</IdLocation>
<IndexLocation>^DHCEMRM.PatSignOrderI</IndexLocation>
<StreamLocation>^DHCEMRM.PatSignOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
