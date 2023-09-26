/// 名称: 新框架病历结构的控制函数集
/// 描述: 存放新框架病历结构的控制方法
/// 编写者：guozongtao
/// 编写日期: 2014-1-7
Class EMRservice.EMRDoc.DocCategoryFunSet Extends %RegisteredObject
{

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：判断指定分类(Chapter)Doc下的界面模板为唯一模板还是可重复模板
/// Table:
/// Input: chapterDocID--分类(Chapter)DocID
/// Output:
/// Return: Single--唯一 Multiple--可重复
ClassMethod GetChapterDocType(chapterDocID As %String) As %String
{
	q:(($d(chapterDocID) = 0) || (chapterDocID = "")) ""
	s result = ""
	
	//根据分类(Chapter)Doc取出其下的第一个打印模板Doc，并取出其类型
	s ret="Single"
	
	s curPrtDocID = ""
	for {
		s curPrtDocID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_chapterDocID, curPrtDocID))
		q:(curPrtDocID = "")
		
		//全部为Single--唯一 		返回 Single
		//存在 Multiple--可重复  	返回 Multiple
		
		s tmpType =..GetPrtDocType(curPrtDocID)
		s:(tmpType="Multiple") ret="Multiple"
	}
	
	q ret
}

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：判断指定打印模板Doc下的界面模板为唯一模板还是可重复模板
/// Table:
/// Input: prtDocID--绑定打印模板的DocID
/// Output:
/// Return: Single--唯一 Multiple--可重复
ClassMethod GetPrtDocType(prtDocID As %String) As %String
{
	q:(($d(prtDocID) = 0) || (prtDocID = "")) ""
	s result = ""
	
	//根据打印模板Doc取出其下的第一个绑定界面模板，并取出其类型
	s curTemplateDocID = $o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_prtDocID,""))
	q:(curTemplateDocID = "") ""
	
	s objTemplateDoc = ##class(EMRmeta.EMRTemplate).%OpenId(curTemplateDocID)
	q:(objTemplateDoc = "") ""
	s bindTemplateID = objTemplateDoc.BindTemplateID
	d objTemplateDoc.%Close()
	k objTemplateDoc
	
	s objTemplate = ##class(EMRmeta.Template).%OpenId(bindTemplateID)
	q:(objTemplate = "") ""
	s chartItemType = objTemplate.ChartItemType
	d objTemplate.%Close()
	k objTemplate
	
	q chartItemType
}

}
