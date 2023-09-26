/// 名称:EMRservice.BL.BLTitleLoc
/// 描述:标题科室配置服务
/// 编写者：yejian
/// 编写日期: 2015-12-17
Class EMRservice.BL.BLTitleLoc Extends (%RegisteredObject, %XML.Adaptor)
{

Query SelectAllLocRowId() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Des:%String")
{
SELECT c.CTLOC_RowId,c.CTLOC_Desc
FROM SQLUser.CT_Loc c
where  c.CTLOC_Type IN ('E','W','OP','EM','O')
Order By c.CTLOC_Desc,c.CTLOC_RowId
}

Query SelectAllConLoc(aTitleID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,TitleID:%String,TitleName:%String,CTLocID:%String,CTLocDesc:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_TITLElOC_SelectAllConLoc, SqlProc ]
{
SELECT ID,TitleID,TitleName,CTLocID,CTLocDesc 
FROM EMRmeta.TitleLoc 
WHERE TitleID =:aTitleID
}

/// 创建标题关联科室
ClassMethod CreateTitleLoc(aTitleLoc As EMRservice.entity.ETitleLoc) As %String
{
	/// b "s"
	s strReslt = "-1"	
	s objTitleLoc = ##Class(EMRmeta.TitleLoc).%New()
	s objTitleLoc.TitleID = $case(aTitleLoc.TitleID,$c(0):"",:aTitleLoc.TitleID)
	s objTitleLoc.TitleName = $case(aTitleLoc.TitleName,$c(0):"",:aTitleLoc.TitleName)
	s objTitleLoc.CTLocID = $case(aTitleLoc.CTLocID,$c(0):"",:aTitleLoc.CTLocID)
	s objTitleLoc.CTLocDesc = $case(aTitleLoc.CTLocDesc,$c(0):"",:aTitleLoc.CTLocDesc)
	s sc = objTitleLoc.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objTitleLoc.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新标题关联科室
ClassMethod UpdateTitleLoc(aTitleLoc As EMRservice.entity.ETitleLoc) As %String
{
	/// b "s"	
	s strReslt = "-1"
	set objTitleLoc=##class(EMRmeta.TitleLoc).%OpenId(aTitleLoc.ID)
	q:(objTitleLoc="") ""	
	s objTitleLoc.TitleID = $case(aTitleLoc.TitleID,$c(0):"",:aTitleLoc.TitleID)
	s objTitleLoc.TitleName = $case(aTitleLoc.TitleName,$c(0):"",:aTitleLoc.TitleName)
	s objTitleLoc.CTLocID = $case(aTitleLoc.CTLocID,$c(0):"",:aTitleLoc.CTLocID)
	s objTitleLoc.CTLocDesc = $case(aTitleLoc.CTLocDesc,$c(0):"",:aTitleLoc.CTLocDesc)
	
	s sc = objTitleLoc.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objTitleLoc.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 删除一个标题关联科室
ClassMethod DeleteTitleLocByID(aTitleLocId As %String) As %String
{
    q:(aTitleLocId ="") "-1"
    b
    s objTitleLoc = ##Class(EMRmeta.TitleLoc).%OpenId(aTitleLocId)
	q:(objTitleLoc="") "-1"
	s sc = ##class(EMRmeta.TitleLoc).%DeleteId(aTitleLocId)
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
/// d ##Class(EMRservice.BL.BLTitleLoc).test()
ClassMethod test() As %String
{
	
	s OrganTitle = ##Class(EMRservice.entity.ETitleLoc).%New()
	s OrganTitle.TitleID= "32"
	s OrganTitle.TitleName="在院"
	S OrganTitle.CTLocID ="32"
	s OrganTitle.CTLocDesc="检验报告"
	d ..CreateTitleLoc(OrganTitle)
}

}
