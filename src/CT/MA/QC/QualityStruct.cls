/// 名称:	CT.MA.QC.QualityStruct
/// 描述:	质控结构维护
/// 编写者：hky
/// 编写日期: 2021-06-17
Class CT.MA.QC.QualityStruct Extends (%Persistent, User.Abstract)
{

Index IdxParentId On ParentId;

Index IdxCategoryId On BindCategoryId;

Index IdxCategoryIdType On (BindCategoryId, Type);

/// Our optimization struct name, for import template element using
Property StandardName As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// Parent struct ID
Property ParentId As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// The layer of current struct
Property Layer As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// The full path of our EPR interface template category name
Property BindEPRName As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// Template category ID
Property BindCategoryId As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// The parent template category ID
Property BindCategoryParentId As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// Binding condition of this struct
Property ChkConditionDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// Whether is active
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9 ];

/// Resume of this struct
Property ResumeText As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 10 ];

Property CategoryDR As %String(TRUNCATE = 1);

Property BindDocID As %String(TRUNCATE = 1);

/// 结构类型
Property Type As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QualityStructDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StandardName</Value>
</Value>
<Value name="3">
<Value>ParentId</Value>
</Value>
<Value name="4">
<Value>Layer</Value>
</Value>
<Value name="5">
<Value>BindEPRName</Value>
</Value>
<Value name="6">
<Value>BindCategoryId</Value>
</Value>
<Value name="7">
<Value>BindCategoryParentId</Value>
</Value>
<Value name="8">
<Value>ChkConditionDR</Value>
</Value>
<Value name="9">
<Value>IsActive</Value>
</Value>
<Value name="10">
<Value>ResumeText</Value>
</Value>
<Value name="11">
<Value>CategoryDR</Value>
</Value>
<Value name="12">
<Value>BindDocID</Value>
</Value>
<Value name="13">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualityStructD</DataLocation>
<DefaultData>QualityStructDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualityStructD</IdLocation>
<IndexLocation>^CT.MA.QC.QualityStructI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualityStructS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
