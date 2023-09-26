/// 名称:EMRservice.BL.BLEMROrganSchemeLoc
/// 描述:患者完整病历内容的组织方案科室服务
/// 编写者：yejian
/// 编写日期: 2014-9-3
Class EMRservice.BL.BLEMROrganSchemeLoc Extends (%RegisteredObject, %XML.Adaptor)
{

Query SelectAllLocRowId() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Des:%String")
{
SELECT c.CTLOC_RowId,c.CTLOC_Desc
FROM SQLUser.CT_Loc c
where  c.CTLOC_Type IN ('E','W','OP','EM','O')
Order By c.CTLOC_Desc,c.CTLOC_RowId
}

Query SelectLocRowIdInE() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Des:%String")
{
SELECT c.CTLOC_RowId,c.CTLOC_Desc
FROM SQLUser.CT_Loc c
where  c.CTLOC_Type IN ('E')
Order By c.CTLOC_Desc,c.CTLOC_RowId
}

/// do ##class(%ResultSet).RunQuery("EMRservice.BL.BLEMROrganSchemeLoc","SelectContainLocRowIdInE","Z")
Query SelectContainLocRowIdInE(aContain As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Des:%String")
{
SELECT c.CTLOC_RowId,c.CTLOC_Desc
FROM SQLUser.CT_Loc c
where c.CTLOC_Type IN ('E') 
and (c.CTLOC_ContactName like '%'_:aContain_'%' or c.CTLOC_Desc like '%'_:aContain_'%')
Order By c.CTLOC_Desc,c.CTLOC_RowId
}

Query SelectAllConLoc(aSchemeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,SchemeID:%String,SchemeName:%String,CTLocID:%String,CTLocDesc:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMRSCHEMElOC_SelectAllConLoc, SqlProc ]
{
SELECT ID,SchemeID,SchemeName,CTLocID,CTLocDesc 
FROM EMRmeta.EMROrganizationSchemeLoc 
WHERE SchemeID =:aSchemeID
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String
{
	&sql(select max(id) into :IdexCode from EMRmeta.EMROrganizationSchemeLoc)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 创建方案关联科室
ClassMethod CreateSchemeLoc(aOrganSchemeLoc As EMRservice.entity.EEMROrganizationSchemeLoc) As %String
{
	/// b "s"
	s strReslt = "-1"	
	s objSchemeLoc = ##Class(EMRmeta.EMROrganizationSchemeLoc).%New()
	s objSchemeLoc.SchemeID = $case(aOrganSchemeLoc.SchemeID,$c(0):"",:aOrganSchemeLoc.SchemeID)
	s objSchemeLoc.SchemeName = $case(aOrganSchemeLoc.SchemeName,$c(0):"",:aOrganSchemeLoc.SchemeName)
	s objSchemeLoc.CTLocID = $case(aOrganSchemeLoc.CTLocID,$c(0):"",:aOrganSchemeLoc.CTLocID)
	s objSchemeLoc.CTLocDesc = $case(aOrganSchemeLoc.CTLocDesc,$c(0):"",:aOrganSchemeLoc.CTLocDesc)
	s sc = objSchemeLoc.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objSchemeLoc.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新方案关联科室
ClassMethod UpdateSchemeLoc(aOrganSchemeLoc As EMRservice.entity.EEMROrganizationSchemeLoc) As %String
{
	/// b "s"	
	s strReslt = "-1"
	set objSchemeLoc=##class(EMRmeta.EMROrganizationSchemeLoc).%OpenId(aOrganSchemeLoc.ID)
	q:(objSchemeLoc="") ""	
	s objSchemeLoc.SchemeID = $case(aOrganSchemeLoc.SchemeID,$c(0):"",:aOrganSchemeLoc.SchemeID)
	s objSchemeLoc.SchemeName = $case(aOrganSchemeLoc.SchemeName,$c(0):"",:aOrganSchemeLoc.SchemeName)
	s objSchemeLoc.CTLocID = $case(aOrganSchemeLoc.CTLocID,$c(0):"",:aOrganSchemeLoc.CTLocID)
	s objSchemeLoc.CTLocDesc = $case(aOrganSchemeLoc.CTLocDesc,$c(0):"",:aOrganSchemeLoc.CTLocDesc)
	
	s sc = objSchemeLoc.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objSchemeLoc.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 删除一个方案关联科室
ClassMethod DeleteSchemeLocByID(aSchemeLocId As %String) As %String
{
    q:(aSchemeLocId ="") "-1"
    b
    s objSchemeLoc = ##Class(EMRmeta.EMROrganizationSchemeLoc).%OpenId(aSchemeLocId)
	q:(objSchemeLoc="") "-1"
	s sc = ##class(EMRmeta.EMROrganizationSchemeLoc).%DeleteId(aSchemeLocId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

/// 测试
/// d ##Class(EMRservice.BL.BLEMROrganSchemeDetails).test()
ClassMethod test() As %String
{
	
	s OrganScheme = ##Class(EMRservice.entity.EEMROrganizationSchemeLoc).%New()
	s OrganScheme.SchemeID= "32"
	s OrganScheme.SchemeName="在院"
	S OrganScheme.CTLocID ="32"
	s OrganScheme.CTLocDesc="检验报告"
	d ..CreateSchemeLoc(OrganScheme)
}

}
