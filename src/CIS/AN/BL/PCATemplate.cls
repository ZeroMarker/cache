Class CIS.AN.BL.PCATemplate Extends %RegisteredObject
{

/// Creator：        陈长青
/// CreatDate：      2020-8-9
/// Description：    查询术后镇痛模板
/// Table：          CF_AN.PCATemplate
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PCATemplate","FindPCATemplate")
Query FindPCATemplate(deptId As %String = "", userId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   Description,
	   CreateUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',CreateUser) As CreateUserDesc,
	   %ODBCOUT(CreateDate)_" "_%ODBCOUT(CreateTime) As CreateDT,
	   UpdateUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc,
	   %ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT,
	   Dept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',Dept) As DeptType,
	   TemplateType,
	   %External(TemplateType) As TemplateTypeDesc
       from CF_AN.PCATemplate
       where ((:userId is null) or (CreateUser=:userId))
       and ((Dept=:deptId) or (:deptId is null))
}

/// Creator：        陈长青
/// CreatDate：      2020-8-9
/// Description：    查询术后镇痛模板
/// Table：          CF_AN.PCATemplate
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PCATemplate","FindPCATemplate")
Query FindPCATemplateData(templateId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   DataTitle,
	   DataValue,
	   DataUom,
	   EventOption,
	   EventOption->Description As EventOptionDesc,
	   ArcimID,
	   PCATemplate,
	   PCATemplate->Description As PCATemplateDesc
       from CF_AN.PCATemplateData where PCATemplate=:templateId
}

ClassMethod SaveTemplateData(dataPara As %String) As %String
{
}

}
