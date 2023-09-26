/// Desc:角色科室资源
Class DHCEPRFS.META.ResourceLoc Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 科室ID
Property LocID As %String(TRUNCATE = 1);

/// 科室描述
Property LocDesc As %String(TRUNCATE = 1);

/// 首字母拼音
Property InitialPinYin As %String(TRUNCATE = 1);

/// 全拼
Property AliasPinYin As %String(TRUNCATE = 1);

/// 排序码
Property Sequence As %String(TRUNCATE = 1);

/// 有效标志 0 or 1
Property IsValid As %String(TRUNCATE = 1);

/// 分类编码
Property CatalogueCode As %String(TRUNCATE = 1);

Index IdxLocID On LocID [ Unique ];

Storage Default
{
<Data name="ResourceLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocID</Value>
</Value>
<Value name="3">
<Value>LocDes</Value>
</Value>
<Value name="4">
<Value>InitialPinYin</Value>
</Value>
<Value name="5">
<Value>AliasPinYin</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>IsValid</Value>
</Value>
<Value name="8">
<Value>CatelogueCode</Value>
</Value>
<Value name="9">
<Value>CatalogueCode</Value>
</Value>
<Value name="10">
<Value>LocDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.ResourceLocD</DataLocation>
<DefaultData>ResourceLocDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.ResourceLocD</IdLocation>
<IndexLocation>^DHCEPRFS.META.ResourceLocI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.ResourceLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
