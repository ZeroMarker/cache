/// 名称:EMRmeta.TemplateUserAccess
/// 描述:模板用户模板权限控制
/// 编写者：yejian
/// 编写日期: 2018-12-13
Class EMRmeta.TemplateUserAccess Extends %Persistent
{

/// 用户编号（关联EMRmeta.SuperUser表的SupUserID）
Property SupUserID As %String(TRUNCATE = 1);

/// 用户名
Property SupUserName As %String(TRUNCATE = 1);

/// 模板ID或模板目录ID（temType区分）
Property TemCID As %String(TRUNCATE = 1);

/// 模板名称
Property TempCName As %String(TRUNCATE = 1);

/// 模板类型：CATEGORY:模板目录,TEMPLATE:模板
Property TemType As %String(TRUNCATE = 1);

Index IdxSupUserID On SupUserID;

Index IdxSupUserTypeTemID On (SupUserID, TemType, TemCID);

Storage Default
{
<Data name="TemplateUserAccessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SupUserID</Value>
</Value>
<Value name="3">
<Value>SupUserName</Value>
</Value>
<Value name="4">
<Value>TemplateID</Value>
</Value>
<Value name="5">
<Value>TemplateName</Value>
</Value>
<Value name="6">
<Value>TemplateCategoryID</Value>
</Value>
<Value name="7">
<Value>TemplatecategoryName</Value>
</Value>
<Value name="8">
<Value>TemOrCID</Value>
</Value>
<Value name="9">
<Value>TempOrCName</Value>
</Value>
<Value name="10">
<Value>TemType</Value>
</Value>
<Value name="11">
<Value>TemCID</Value>
</Value>
<Value name="12">
<Value>TempCName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.TemplateUserAccessD</DataLocation>
<DefaultData>TemplateUserAccessDefaultData</DefaultData>
<IdLocation>^DHCEMRM.TemplateUserAccessD</IdLocation>
<IndexLocation>^DHCEMRM.TemplateUserAccessI</IndexLocation>
<StreamLocation>^DHCEMRM.TemplateUserAccessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
