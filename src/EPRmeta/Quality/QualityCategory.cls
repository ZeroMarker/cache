/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityCategory
/// * Description:	The model of quality category
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-08-23
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxParentId On ParentId;

Property ParentId As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property Score As %String(TRUNCATE = 1);

Property IsActive As %String(TRUNCATE = 1);

Property ResumeText As %String(TRUNCATE = 1);

Query SELECTALL() As %SQLQuery(CONTAINID = 1) [ SqlName = SP_QualityCategory_SELECTALL, SqlProc ]
{
	SELECT %Id, ParentId, Name, Score, IsActive, ResumeText 
	FROM EPRmeta_Quality.QualityCategory
}

/// 删除结点及其子结点
ClassMethod DeleteQualityCategory(ACategoryId As %String) As %String
{
	if (##Class(EPRmeta.Quality.QualityCategory).%ExistsId(ACategoryId))	
	{
		&SQL(DELETE FROM EPRmeta_Quality.QualityCategory WHERE ID IN (
			 SELECT ID FROM EPRmeta_Quality.QualityCategory WHERE ParentId= :ACategoryId))
		
		d ##Class(EPRmeta.Quality.QualityCategory).%DeleteId(ACategoryId)
		
		q "1"
	}
	else
	{
		q "0"
	}
}

Storage Default
{
<Data name="QualityCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParentId</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Score</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityCategoryD</DataLocation>
<DefaultData>QualityCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityCategoryD</IdLocation>
<IndexLocation>^DHCEPRM.QualityCategoryI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
