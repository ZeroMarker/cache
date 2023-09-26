/// 名称:	CT.MA.QC.QualityQuery
/// 描述:	检查条件维护
/// 编写者：hky
/// 编写日期: 2021-06-08
Class CT.MA.QC.QualityQuery Extends (%Persistent, User.Abstract)
{

Index IdxCode On Code [ Unique ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 描述
Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 条件表达式
Property QueryEx As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 是否有效
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

/// 备注
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="QualityQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>QueryEx</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualityQueryD</DataLocation>
<DefaultData>QualityQueryDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualityQueryD</IdLocation>
<IndexLocation>^CT.MA.QC.QualityQueryI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualityQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
