/// Desc:角色病历项目资源
Class DHCEPRFS.META.ResourceMRItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 病历大类ID
Property MRCategoryID As %String(TRUNCATE = 1);

Property MRCategoryName As %String(TRUNCATE = 1);

/// 病历子分类ID
Property MRSubCategoryID As %String(TRUNCATE = 1);

Property MRSubCategoryName As %String(TRUNCATE = 1);

/// 病历项目ID
Property MRItemID As %String(TRUNCATE = 1);

/// 病历项目名称
Property MRItemName As %String(TRUNCATE = 1);

/// 病历项目首字母拼音
Property InitialPinYin As %String(TRUNCATE = 1);

/// 病历项目全拼
Property AliasPinYin As %String(TRUNCATE = 1);

/// 有效标志
Property IsValid As %String(TRUNCATE = 1);

/// 分类编码
Property CatalogueCode As %String(TRUNCATE = 1);

Index IdxMRItemID On MRItemID [ Unique ];

Storage Default
{
<Data name="ResourceMRItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRCategoryID</Value>
</Value>
<Value name="3">
<Value>MRSubCategoryID</Value>
</Value>
<Value name="4">
<Value>MRItemID</Value>
</Value>
<Value name="5">
<Value>InitialPinYin</Value>
</Value>
<Value name="6">
<Value>AliasPinYin</Value>
</Value>
<Value name="7">
<Value>IsValid</Value>
</Value>
<Value name="8">
<Value>CatelogueCode</Value>
</Value>
<Value name="9">
<Value>MRItemName</Value>
</Value>
<Value name="10">
<Value>CatalogueCode</Value>
</Value>
<Value name="11">
<Value>MRCategoryName</Value>
</Value>
<Value name="12">
<Value>MRSubCategoryName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ResourceMRItemD</DataLocation>
<DefaultData>ResourceMRItemDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.ResourceMRItemD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ResourceMRItemI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ResourceMRItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
