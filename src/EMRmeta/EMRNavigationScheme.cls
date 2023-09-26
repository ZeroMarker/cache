/// 名称:EMRmeta.EMRNavigationScheme
/// 描述:患者完整病历内容的组织方案定义
/// 编写者：yejian
/// 编写日期: 2016-5-16
Class EMRmeta.EMRNavigationScheme Extends (%Persistent, %XML.Adaptor)
{

/// 病历书写顺序方案(Running)、病历归档顺序方案(Archiving)、门急诊顺序方案(Outpatient)
Property SchemeCode As %String;

/// 方案名称
Property SchemeName As %String;

Property CreateUserID As %String;

Property CreateDate As %Date;

Property CreateTime As %Time;

Property modifyUser As %String;

Property ModifyDate As %Date;

Property ModifyTime As %Time;

/// 显示次序
Property SchemSeq As %Integer;

Index IdxSchemeCode On SchemeCode [ Unique ];

Storage Default
{
<Data name="EMRNavigationSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SchemeCode</Value>
</Value>
<Value name="3">
<Value>SchemeName</Value>
</Value>
<Value name="4">
<Value>CreateUserID</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>ModifyDate</Value>
</Value>
<Value name="8">
<Value>ModifyTime</Value>
</Value>
<Value name="9">
<Value>SchemSeq</Value>
</Value>
<Value name="10">
<Value>modifyUser</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRNavSchemeD</DataLocation>
<DefaultData>EMRNavigationSchemeDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRNavSchemeD</IdLocation>
<IndexLocation>^DHCEMRM.EMRNavSchemeI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRNavSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
