/// 名称:EMRservice.Tools.EMRTemplateDelTool
/// 描述:模板清除工具类
/// 编写者：yejian
/// 编写日期: 2020-8-17
Class EMRservice.Tools.EMRTemplateDelTool Extends (%RegisteredObject, %XML.Adaptor)
{

/*
相关表的sql查询
SELECT * FROM EMRmeta.TemplateCategory WHERE ID = '248'
SELECT t.ID,t.Name,t.* FROM  EMRmeta.Template t WHERE t.TemplateCategoryID ='248'
SELECT * FROM EMRmeta.Templateversion WHERE TemplateID = '153'
SELECT e.CategoryID,* FROM EMRmeta.EMRTemplate e WHERE BindTemplateID = 153
SELECT * FROM EMRmeta.EMRTemplateCategory WHERE ID IN (270,263,7)
SELECT * FROM EMRmeta_EMRDocRestriction.DocsInGroup WHERE DocID = '270'
SELECT Code,* FROM EMRmeta.UserTemplate WHERE TemplateID = '153'
SELECT * FROM EMRmeta.UserTemplateCTLoc WHERE Code = '115'
SELECT * FROM EMRmeta.UserTemplateDisease WHERE Code = '115'
SELECT * FROM EMRmeta.UserTemplateSectionRelation WHERE  Code = '115'
SELECT * FROM EMRmeta.UserTemplateSection WHERE  Code = '115'
SELECT * FROM EMRmeta.UserTemplateGroupItem WHERE Code = '115'
*/
/// 根据模板目录ID，清除模板、版本、科室模板、病历展现结构相关数据
/// 入参：aTemCategoryID 模板目录ID。 
/// 编写日期：2020-8-18
/// 编写者:yejian	
/// 注： 模板目录数据重建索引 d ##Class(EMRmeta.TemplateCategory).%BuildIndices()
/// d ##class(EMRservice.Tools.EMRTemplateDelTool).EMRCleanTemplateByCategoryID("248")	
ClassMethod EMRCleanTemplateByCategoryID(aTemCategoryID As %String)
{
	
	TSTART
	s ret = 1
	q:(aTemCategoryID="")
	s strTemCateID = ""
	s arrCateTemIDs = ##class(%ListOfDataTypes).%New()
	s arrTemIDs = ##class(%ListOfDataTypes).%New()
	d ..GetTempalteIDs(aTemCategoryID,.arrTemIDs,.arrCateTemIDs)
	s TemCount = arrTemIDs.Count()
	//与用户交互，确认是否修改InstanceLog
	s strMessage = "该目录下有"_TemCount_"个模板，是否删除？，删除是请输入y, 否请输入n或直接回车    "
	s choice = ""
	w strMessage
	Read choice
	q:(($zcvt(choice,"U")'="Y"))
	
	for i = 1:1:TemCount 
	{
		s strTemID = arrTemIDs.GetAt(i)
		//删除该模板下所有科室模板
		s strUserTemCode = ""
		for {
			s strUserTemCode=$o(^DHCEMRM.UserTemplateI("IdxTemplateCode"," "_strTemID,strUserTemCode))
			q:(strUserTemCode="")
			
			//删除科室模板关联数据
			d ..DelUserTemplateAll(strUserTemCode)
			
		}
		//删除病例展现关联数据
		s strEmrTemRowID = ""
		for {
			s strEmrTemRowID=$o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_strTemID,strEmrTemRowID))
			q:(strEmrTemRowID="")
			s objEmrTemplate = ##class(EMRmeta.EMRTemplate).%OpenId(strEmrTemRowID)
			q:(objEmrTemplate="")
			//TempCate:挂靠界面模板的目录
			s objEmrTempCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(objEmrTemplate.CategoryID)
			q:(objEmrTempCate="")
			//TempCate:挂靠界面模板的目录
			s objEmrCategoryChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(objEmrTempCate.ParentCategoryID)
			q:(objEmrCategoryChapter="")
			//删除模板组下相关docID
			s docID = objEmrTemplate.CategoryID
			s strGroupID = ""
			for {
				s strGroupID=$o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_docID,strGroupID))
				q:(strGroupID="")
				s strDocInGroupRID=$o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_docID,strGroupID,""))
				q:(strDocInGroupRID="")
				s objDocInGroup=##class(EMRmeta.EMRDocRestriction.DocsInGroup).%OpenId(strDocInGroupRID)
				q:(objDocInGroup="")
				if '(objDocInGroup.%DeleteId(strDocInGroupRID))
				{
					TROLLBACK
					s ret = 0
					q
				}
			}
			if '(objEmrCategoryChapter.%DeleteId(objEmrTempCate.ParentCategoryID))
			{
				TROLLBACK
				s ret = 0
				q
			}
			if '(objEmrTempCate.%DeleteId(objEmrTemplate.CategoryID))
			{
				TROLLBACK
				s ret = 0
				q
			}
			if '(objEmrTemplate.%DeleteId(strEmrTemRowID))
			{
				TROLLBACK
				s ret = 0
				q
			}
			
		}
		
		//删除模板和版本数据
		s objTemplate = ##class(EMRmeta.Template).%OpenId(strTemID)
		q:(objTemplate="")
		s strTemNumb = ""
		for {
			s strTemNumb=$o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_strTemID,strTemNumb))
			q:(strTemNumb="")
			s strTemVersionRID = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_strTemID,strTemNumb,""))
			q:(strTemVersionRID="")
			s objTemVersion = ##class(EMRmeta.TemplateVersion).%OpenId(strTemVersionRID)
			q:(objTemVersion="")
			if '(objTemVersion.%DeleteId(strTemVersionRID))
			{
				TROLLBACK
				s ret = 0
				q
			}
		}
		if '(objTemplate.%DeleteId(strTemID))
		{
			TROLLBACK
			s ret = 0
			q
		}
	}
	
	s CateTemCount = arrCateTemIDs.Count()
	for i = 1:1:CateTemCount 
	{
		s strCateTemID = arrCateTemIDs.GetAt(i)
		q:(strCateTemID="")
		s objTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(strCateTemID)
		q:(objTemplateCategory="")
		s objTemplateCategory.ResChildCount = 0
		if '(objTemplateCategory.%Save())
		{
			TROLLBACK
			s ret = 0
			q
		}
	}
	if (ret =1)
	{
		TCommit
	}	
	w !,"Finish"
}

/// 获取模板id集合
/// d ##class(EMRservice.Tools.EMRTemplateDelTool).GetTempalteIDs("Y","N")
ClassMethod GetTempalteIDs(aTemCategoryID As %String, ByRef aTemIDs As %ListOfDataTypes, ByRef aCateTemIDs As %ListOfDataTypes)
{
	s temCatRowID = ""
	s strCateTemID = aCateTemIDs.Find(aTemCategoryID)
	d:(strCateTemID="") aCateTemIDs.Insert(aTemCategoryID)
	for {
		s temCatRowID=$o(^DHCEMRM.TemplateCategoryI("IdxParentId"," "_aTemCategoryID,temCatRowID))
		if (temCatRowID'="") //不为空，递归调查询子目录
		{
			s strCateTemID = aCateTemIDs.Find(temCatRowID)
			d:(strCateTemID="") aCateTemIDs.Insert(temCatRowID)
			d ..GetTempalteIDs(temCatRowID,.aTemIDs,.aCateTemIDs)
		}
		else //为空，根据目录ID获取模板数据
		{
			s temRowID = ""
			for {
				s temRowID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_aTemCategoryID,temRowID))
				q:(temRowID="")
				s strTemID = aTemIDs.Find(temRowID)
				d:(strTemID="") aTemIDs.Insert(temRowID)
				
			}
			q
		}
	}
}

/// 删除用户模板
/// do ##class(EMRservice.Tools.EMRTemplateDelTool).DelUserTemplate("BINZ004")
ClassMethod DelUserTemplateAll(ACode As %String) As %Boolean
{
	s ret = 0
	q:($g(ACode) = "") ret
	s ACode = $tr(ACode," ","")
	s flag = 1
	s UserTemplateID = $g(ACode)
	
	TSTART
	s UserTemplateID = $o(^DHCEMRM.UserTemplateI("IdxCode"," "_$zcvt(ACode,"U"),""))
	q:($g(UserTemplateID) = "") ret
	
	///删除所有用户模板科室关联
	s UserTemplateCTRowID = ""
	for {
		s UserTemplateCTRowID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCode"," "_$zcvt(ACode,"U"),UserTemplateCTRowID))
		q:(UserTemplateCTRowID = "")
	
		s objUserTemplateCT = ##Class(EMRmeta.UserTemplateCTLoc).%OpenId(UserTemplateCTRowID)
		if '(objUserTemplateCT.%DeleteId(UserTemplateCTRowID))
		{
			TROLLBACK
			s ret = 0
			q
		}
	}
	
	///删除所有用户模板诊断关联
	s UserTemplateDisRowID = ""
	for {
		s UserTemplateDisRowID = $o(^DHCEMRM.UserTemplateDiseaseI("IdxCode"," "_$zcvt(ACode,"U"),UserTemplateDisRowID))
		q:(UserTemplateDisRowID = "")
		
		s objUserTemplateDis = ##Class(EMRmeta.UserTemplateDisease).%OpenId(UserTemplateDisRowID)
		if '(objUserTemplateDis.%DeleteId(UserTemplateDisRowID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	///删除章节关联
	s UserTemplateSecReRowID = ""
	for {
		s UserTemplateSecReRowID = $o(^DHCEMRM.UserTemplateRelationI("IdxCode"," "_$zcvt(ACode,"U"),UserTemplateSecReRowID))
		q:(UserTemplateSecReRowID = "")
		
		s objUserTemplateSecRe = ##Class(EMRmeta.UserTemplateSectionRelation).%OpenId(UserTemplateSecReRowID)
		if '(objUserTemplateSecRe.%DeleteId(UserTemplateSecReRowID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	///删除章节打散数据
	s UserTemplateSecRowID = ""
	for {
		s UserTemplateSecRowID = $o(^DHCEMRM.UserTemplateSectionI("IdxCode"," "_$zcvt(ACode,"U"),UserTemplateSecRowID))
		q:(UserTemplateSecRowID = "")
		
		s objUserTemplateSec = ##Class(EMRmeta.UserTemplateSection).%OpenId(UserTemplateSecRowID)
		if '(objUserTemplateSec.%DeleteId(UserTemplateSecRowID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	///删除分组科室关联数据
	s UserTemplateGroupItemRowID = ""
	for {
		s UserTemplateGroupItemRowID = $o(^DHCEMRM.UserTemplateGroupItemI("IdxUserCode"," "_$zcvt(ACode,"U"),UserTemplateGroupItemRowID))
		q:(UserTemplateGroupItemRowID = "")
		
		s objUserTemplateGroupItem = ##Class(EMRmeta.UserTemplateGroupItem).%OpenId(UserTemplateGroupItemRowID)
		if '(objUserTemplateGroupItem.%DeleteId(UserTemplateGroupItemRowID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(UserTemplateID)
	if '(objUserTemplate.%DeleteId(UserTemplateID))
	{
		TROLLBACK
		s flag = 0
	}
	else
	{
		 TCommit
		 s flag = 1
	}
	
	s ret = flag
	q ret
}

}
