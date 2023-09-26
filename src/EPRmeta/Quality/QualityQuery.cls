/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityQuery
/// * Description:	The model of quality condition
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityQuery Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
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

ClassMethod CheckCodeUnique(ACode As %String) As %Integer
{
	s Result = 0
 	&sql(SELECT COUNT(Code) INTO:Result FROM EPRmeta_Quality.QualityQuery WHERE Code = :ACode)
 	q Result
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1) [ SqlName = SP_QualityQuery_SELECTALL, SqlProc ]
{
	SELECT %Id, Code, Name, QueryEx, IsActive, ResumeText
	FROM EPRmeta_Quality.QualityQuery
	ORDER BY Code
}

Storage Default
{
<Data name="QualityQueryDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>QueryEx</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityQueryD</DataLocation>
<DefaultData>QualityQueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityQueryD</IdLocation>
<IndexLocation>^DHCEPRM.QualityQueryI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
