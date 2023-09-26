/// 名称: 切换模板时的待选模板列表
/// 描述: 用于返回前台页面进行切换模板操作时的待选模板列表
/// 编写者：chenwenjun
/// 编写日期: 09/08/10
Class web.eprajax.doclistforswitch Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s docID = $Get(%request.Data("DocID",1),"-1")	//打印模板ID
	s episodeID  = $Get(%request.Data("EpisodeID",1),"-1")
	q:(docID = -1) $$$OK
	q:(episodeID = -1) $$$OK

	//取出该打印模板的父节点，即chapterDocID
	s objCurDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(docID)
	q:(objCurDoc = "") $$$OK
	s chapterDocID = objCurDoc.ParentCategoryID
	d objCurDoc.%Close()
	s objCurDoc = ""
	q:(chapterDocID = "") $$$OK
	
	//取出相关的信息
	s chapterDocID = " "_chapterDocID
	s priActivity = "N", curPatInfo = ""
	s priActivity = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
	if (priActivity = "Y")
	{
		s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(episodeID)
	}
	
	//生成doc列表的json串
	w "{root:["
	s isFirstNode = 1
	s curDocId = 0
	s curDocId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", chapterDocID, curDocId))
	WHILE (curDocId '= "") 
	{
		if (priActivity = "N")
		{
			s curResult = 1
		}
		else
		{
			s curResult = ##Class(EPRservice.DocRestLogic.TempActLogic).CanTempAct(curDocId, "READ", curPatInfo)
		}
		
		if (curResult = 1)
		{
			if (isFirstNode = 0){w ","}
			
			s curCategoryNote = $g(^DHCEPRM.EPRTemplateCategoryD(curDocId))
			s curCategoryName = $lg(curCategoryNote,8)
			s curCategoryType = $lg(curCategoryNote,10)
			s curBindPrintTplID = $lg(curCategoryNote,16)
			s curDocFullID = ##class(EPRservice.BOEPRTemplateCategory).TransCategoryType(curCategoryType)_curDocId
			w "{ID:'"_curDocFullID_"', templateName: '"_curCategoryName_"', BindPrintTplID: '"_curBindPrintTplID_"'}"
			
			s isFirstNode = 0
		}
		
		s curDocId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", chapterDocID, curDocId))
	}
	
	w "]}"
	Quit $$$OK
}

}
