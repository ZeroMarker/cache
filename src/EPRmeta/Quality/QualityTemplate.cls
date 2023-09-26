/// ************************************************************
/// * ClassName:	EPRmeta.Quality.QualityTemplate
/// * Description:	病案质控模板单元维护表，用于保存所有病历模板单元
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityTemplate Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxTemplateId On TemplateId;

Index IdxElementCode On ElementCode [ Unique ];

/// Interface template ID
Property TemplateId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Interface template element code
Property ElementCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Interface template element name
Property NormalName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Interface template element simple name, which is our optimization name 
Property SimpleName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// Allow null or not
Property IsNull As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6 ];

/// Whether is active
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// Last update date time
Property LUDateTime As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// Resume of this interface template element
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

///  *****************************************************
///  功能：根据ID删除质控模板单元
///  入参：AId为质控模板单元表QualityTemplate的ID
///  *****************************************************
ClassMethod DeleteQuaTemplateUnit(AId As %String) As %String
{
	&sql(DELETE FROM EPRmeta_Quality.QualityTemplate WHERE ID= :AId)
    q:SQLCODE SQLCODE
    s ret = 1
	q ret
}

///  *****************************************************
///  功能：根据ID获取质控模板单元对象
///  入参：AId为质控模板单元表QualityTemplate的ID
///  *****************************************************
ClassMethod GetQaulityTemplateByID(AId As %String)
{
	s ret = ""
	q:(AId = "") ret
	s ret = $g(^DHCEPRM.QualityTemplateD(AId))
	q ret
}

Storage Default
{
<Data name="QualityTemplateDefaultData">
<Value name="1">
<Value>TemplateId</Value>
</Value>
<Value name="2">
<Value>ElementCode</Value>
</Value>
<Value name="3">
<Value>NormalName</Value>
</Value>
<Value name="4">
<Value>SimpleName</Value>
</Value>
<Value name="5">
<Value>IsNull</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>LUDateTime</Value>
</Value>
<Value name="8">
<Value>ResumeText</Value>
</Value>
<Value name="9">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityTemplateD</DataLocation>
<DefaultData>QualityTemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityTemplateD</IdLocation>
<IndexLocation>^DHCEPRM.QualityTemplateI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
