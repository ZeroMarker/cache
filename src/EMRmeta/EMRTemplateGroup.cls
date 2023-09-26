/// 名称：		EMRmeta.EMRTemplateGroup
/// 描述：		病历分组表
/// 编写者：	yejian
/// 编写时间：	2017-5-6
Class EMRmeta.EMRTemplateGroup Extends (%Persistent, User.Abstract)
{

Index IdxTemplateGroupCode On TemplateGroupCode [ Unique ];

Index IdxTemplateGroupName On TemplateGroupName;

/// 模板组合ID
Property TemplateGroupCode As %String(TRUNCATE = 1);

/// 模板组合名称
Property TemplateGroupName As %String(TRUNCATE = 1);

/// 创建者
Property CreateUserID As %String;

/// 创建时间
Property CreateDate As %Date;

/// 创建日期
Property CreateTime As %Time;

/// 修改者
Property ModifyUser As %String;

/// 修改时间
Property ModifyDate As %Date;

/// 修改日期
Property ModifyTime As %Time;

/// 模板顺序
Property TemplateSeq As %Integer;

Storage Default
{
<Data name="EMRTemplateGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateGroupCode</Value>
</Value>
<Value name="3">
<Value>TemplateGroupName</Value>
</Value>
<Value name="4">
<Value>TemplateSeq</Value>
</Value>
<Value name="5">
<Value>CreateUserID</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>modifyUser</Value>
</Value>
<Value name="9">
<Value>ModifyDate</Value>
</Value>
<Value name="10">
<Value>ModifyTime</Value>
</Value>
<Value name="11">
<Value>ModifyUser</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRTemplateGroupD</DataLocation>
<DefaultData>EMRTemplateGroupDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRTemplateGroupD</IdLocation>
<IndexLocation>^DHCEMRM.EMRTemplateGroupI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRTemplateGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
