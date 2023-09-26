/// 名称:	CT.MA.QC.QualityParams
/// 描述:	公共函数维护
/// 编写者：whb
/// 编写日期: 2021-05-24
Class CT.MA.QC.QualityParams Extends (%Persistent, User.Abstract)
{

Index IdxCode On Code [ Unique ];

/// 代码	
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 描述
Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 值
Property BindValue As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 是否有效
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

/// 备注
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="QualityParamsDefaultData">
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
<Value>BindValue</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualityParamsD</DataLocation>
<DefaultData>QualityParamsDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualityParamsD</IdLocation>
<IndexLocation>^CT.MA.QC.QualityParamsI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualityParamsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
