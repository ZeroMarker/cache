/// 名称:EPRservice.BLL.BLGlossaryTemplateItemGroup
/// 描述:二版章节组合BO层
/// 编写者：yejian
/// 编写日期: 2016-7-6
Class EPRservice.BLL.BLGlossaryTemplateItemGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRNavigationSchemeItem","SelectAllItemGroup","12||1")
Query SelectAllItemGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,TemplateID:%String,TemplateName:%String,GroupCode:%String,Name:%String,TemValue:%String,TemDesc:%String,Type:%String,Sequence:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_EMRITEMS_SelectALLItemGroup, SqlProc ]
{
    SELECT t.ID,t.TemplateID,t.TemplateName,t.GroupCode,t.Name,t.TemValue,t.TemDesc,t.Type,t.Sequence
    FROM EPRmeta.GlossaryTemplateItemGroup t
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRNavigationSchemeItem","SelectGroupByTemID","2")
Query SelectGroupByTemID(aTemID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "GroupCode:%String,TemplateName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMRITEMS_SelectGroupByTemID, SqlProc ]
{
    SELECT GroupCode,TemplateName FROM EPRmeta.GlossaryTemplateItemGroup
    WHERE TemplateID  =:aTemID 
    GROUP BY GroupCode
}

/// 得到最大code编号
ClassMethod GetMaxSeq(aGroupCode As %String) As %String
{
	&sql(select max(Sequence) into :ISeq from EPRmeta.GlossaryTemplateItemGroup where GroupCode =:aGroupCode)
	s:(ISeq="") ISeq=0
	q ISeq
}

/// 创建一个项目
ClassMethod CreateItemGroup(aOrganItemGroup As EPRservice.entity.EGlossaryTemplateItemGroup) As %String
{
	/// b "s"
	s strReslt = "-1"	
	
	s objItemGroup = ##Class(EPRmeta.GlossaryTemplateItemGroup).%New()
	S objItemGroup.GroupCode = $case(aOrganItemGroup.GroupCode,$c(0):"",:aOrganItemGroup.GroupCode)
	s objItemGroup.TemplateID = $case(aOrganItemGroup.TemplateID,$c(0):"",:aOrganItemGroup.TemplateID)
	s objItemGroup.TemplateName = $case(aOrganItemGroup.TemplateName,$c(0):"",:aOrganItemGroup.TemplateName)
	s objItemGroup.Name = $case(aOrganItemGroup.Name,$c(0):"",:aOrganItemGroup.Name)
	s objItemGroup.TemValue = $case(aOrganItemGroup.TemValue,$c(0):"",:aOrganItemGroup.TemValue)
	s objItemGroup.TemDesc = $case(aOrganItemGroup.TemDesc,$c(0):"",:aOrganItemGroup.TemDesc)
	s objItemGroup.Type = $case(aOrganItemGroup.Type,$c(0):"",:aOrganItemGroup.Type)
	s ^globCreateGroup("12") =aOrganItemGroup.Sequence
	s objItemGroup.Sequence = $case(aOrganItemGroup.Sequence,$c(0):0,:aOrganItemGroup.Sequence)
	s ^globCreateGroup("123") =objItemGroup.Sequence
	s sc = objItemGroup.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objItemGroup.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新一个项目
ClassMethod UpdateItemGroup(aOrganItemGroup As EPRservice.entity.EGlossaryTemplateItemGroup) As %String
{
	/// b "s"	
	s strReslt = "-1"
	set objItemGroup=##class(EPRmeta.GlossaryTemplateItemGroup).%OpenId(aOrganItemGroup.ID)
	q:(objItemGroup="") ""	
	//如果修改了编码，seq修改为该编码最大值+1
	if (objItemGroup.GroupCode '=aOrganItemGroup.GroupCode) 
	{
		s strSeq =##Class(EPRservice.BLL.BLGlossaryTemplateItemGroup).GetMaxSeq(aOrganItemGroup.GroupCode)
		s objItemGroup.Sequence =strSeq + 1
		s ^gloabGroup("123") =objItemGroup.Sequence 
	}
	S objItemGroup.GroupCode = $case(aOrganItemGroup.GroupCode,$c(0):"",:aOrganItemGroup.GroupCode)
	s objItemGroup.TemplateID = $case(aOrganItemGroup.TemplateID,$c(0):"",:aOrganItemGroup.TemplateID)
	s objItemGroup.TemplateName = $case(aOrganItemGroup.TemplateName,$c(0):"",:aOrganItemGroup.TemplateName)
	s objItemGroup.Name = $case(aOrganItemGroup.Name,$c(0):"",:aOrganItemGroup.Name)
	s objItemGroup.TemValue = $case(aOrganItemGroup.TemValue,$c(0):"",:aOrganItemGroup.TemValue)
	s objItemGroup.TemDesc = $case(aOrganItemGroup.TemDesc,$c(0):"",:aOrganItemGroup.TemDesc)
	s objItemGroup.Type = $case(aOrganItemGroup.Type,$c(0):"",:aOrganItemGroup.Type)
	
	s sc = objItemGroup.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objItemGroup.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新一个数据元范畴
/// w ##Class(EPRservice.BLL.BLGlossaryTemplateItemGroup).UpdateSequences("9^10,798^9")
ClassMethod UpdateSequences(argStr As %String) As %String
{
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		S argstrItem= $P(argStr,",",I)
		S argID = $P(argstrItem,"^",1)
		S argSeq = $P(argstrItem,"^",2)
		if ($d(argID)=0)||($d(argSeq)=0)||(argID="")||(argSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objEntity="",result=""
		s objEntity=##class(EPRmeta.GlossaryTemplateItemGroup).%OpenId(argID)
		if (objEntity ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objEntity.Sequence=argSeq
		s result=""
		if '(objEntity.%Save())
		{
			TROLLBACK
			s strMrk = 0
		    quit
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 quit 0
	 }
	TCOMMIT
	Quit 1
}

/// 删除一个项目
ClassMethod DeleteItemGroupByID(aItemGroupId As %String) As %String
{
    q:(aItemGroupId ="") "-1"
    b
    s objItemGroup = ##Class(EPRmeta.GlossaryTemplateItemGroup).%OpenId(aItemGroupId)
	q:(objItemGroup="") "-1"
	s sc = ##class(EPRmeta.GlossaryTemplateItemGroup).%DeleteId(aItemGroupId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

/// 删除一个数据元范畴
/// d ##Class(EMRservice.BL.BLEMROrganItemGroup).test()
ClassMethod test() As %String
{
	
	s OrganScheme = ##Class(EPRservice.entity.EGlossaryTemplateItemGroup).%New()
	s OrganScheme.ItemDr= 32
	s OrganScheme.ItemCode="32"
	S OrganScheme.ItemName = "检验报告"
	s OrganScheme.ItemSeq=32
	d ..CreateItemGroup("12||1",OrganScheme)
}

}
