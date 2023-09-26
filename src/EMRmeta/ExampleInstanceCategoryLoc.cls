/// Description:范例病历目录与科室关联
/// Creator:    DongLulu
/// CreateDate: 2018-12-24
Class EMRmeta.ExampleInstanceCategoryLoc Extends (%Persistent, %XML.Adaptor)
{

/// EMRmeta.ExampleInstanceCategory表ID
Property CategoryID As %Integer;

/// 分享者UserID
Property UserID As %String;

/// 科室ID
Property CTLocID As %String;

Index IdxCategoryIDCTLocID On (CategoryID, CTLocID) [ Unique ];

Storage Default
{
<Data name="ExampleInstanceCategoryLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>CTLocID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ExamInsCategoryLocD</DataLocation>
<DefaultData>ExampleInstanceCategoryLocDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ExamInsCategoryLocD</IdLocation>
<IndexLocation>^DHCEMRM.ExamInsCategoryLocI</IndexLocation>
<StreamLocation>^DHCEMRM.ExamInsCategoryLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
