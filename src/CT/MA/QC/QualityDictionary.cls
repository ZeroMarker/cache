/// 名称:	CT.MA.QC.QualityDictionary
/// 描述:	基础字典维护
/// 编写者：hky
/// 编写日期: 2021-05-09
Class CT.MA.QC.QualityDictionary Extends (%Persistent, User.Abstract)
{

Index IdxCode On Code [ Unique ];

Index IdxParentId On ParentId;

/// 代码
Property Code As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 父结点RowId
Property ParentId As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 描述
Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 是否有效
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

/// 备注
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="QualityDictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>ParentId</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualityDictionaryD</DataLocation>
<DefaultData>QualityDictionaryDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualityDictionaryD</IdLocation>
<IndexLocation>^CT.MA.QC.QualityDictionaryI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualityDictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
