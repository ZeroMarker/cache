/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityStruct
/// * Description:	质控病历目录结构（集成以前的病历内容，病历目录和质控大类）
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityStruct Extends %Library.Persistent [ ClassType = persistent, ProcedureBlock ]
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

Query SELECTALL() As %SQLQuery(CONTAINID = 1) [ SqlName = SP_QualityStruct_SELECTALL, SqlProc ]
{
 	SELECT ID, StandardName, ParentID, Layer, BindEPRName, BindCategoryId, BindCategoryParentId, ChkConditionDR, CategoryDR, IsActive, ResumeText, BindDocID
 	FROM EPRmeta_Quality.QualityStruct
 	ORDER BY ID
}

Query SELECTBYLAYER(ALayer As %String) As %SQLQuery(CONTAINID = 1) [ SqlName = SP_QualityStruct_SELECTBYLAYER, SqlProc ]
{
	SELECT ID, StandardName, ParentID, Layer, BindEPRName, BindCategoryId, BindCategoryParentId, ChkConditionDR, CategoryDR, IsActive, ResumeText, BindDocID
 	FROM EPRmeta_Quality.QualityStruct
 	WHERE Layer<=:ALayer
 	ORDER BY ID
}

/// 删除结点及其子结点
ClassMethod DeleteQualityStruct(AStructId As %String) As %String
{
	if (##class(EPRmeta.Quality.QualityStruct).%ExistsId(AStructId))	
	{
		&SQL(DELETE FROM EPRmeta_Quality.QualityStruct WHERE ID IN (
			 SELECT ID FROM EPRmeta_Quality.QualityStruct WHERE ParentId= :AStructId))
		
		d ##class(EPRmeta.Quality.QualityStruct).%DeleteId(AStructId)
		
		q "1"
	}
	else
	{
		q "2"
	}
}

/// 按BindCategoryId排序
/// Add by Candyxu 前台排序用
Query SELECTALLORDERBYCATEGORYID() As %SQLQuery(CONTAINID = 1) [ SqlName = SP_QualityStruct_SELECTALLORDERBYCATEGORYID, SqlProc ]
{
 	SELECT ID, StandardName, ParentID, Layer, BindEPRName, BindCategoryId, BindCategoryParentId, ChkConditionDR, CategoryDR, IsActive, ResumeText, BindDocID
 	FROM EPRmeta_Quality.QualityStruct
 	ORDER BY ID, convert(int,BindCategoryId)
}

Storage Default
{
<Data name="QualityStructDefaultData">
<Value name="1">
<Value>StandardName</Value>
</Value>
<Value name="2">
<Value>ParentId</Value>
</Value>
<Value name="3">
<Value>Layer</Value>
</Value>
<Value name="4">
<Value>BindEPRName</Value>
</Value>
<Value name="5">
<Value>BindCategoryId</Value>
</Value>
<Value name="6">
<Value>BindCategoryParentId</Value>
</Value>
<Value name="7">
<Value>ChkConditionDR</Value>
</Value>
<Value name="8">
<Value>IsActive</Value>
</Value>
<Value name="9">
<Value>ResumeText</Value>
</Value>
<Value name="10">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="11">
<Value>CategoryDR</Value>
</Value>
<Value name="12">
<Value>Type</Value>
</Value>
<Value name="13">
<Value>BindDocID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityStructD</DataLocation>
<DefaultData>QualityStructDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityStructD</IdLocation>
<IndexLocation>^DHCEPRM.QualityStructI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityStructS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
