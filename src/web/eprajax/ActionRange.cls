Class web.eprajax.ActionRange Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	

	s parentID = $Get(%request.Data("node",1),"-1")
	d ..GetJson(parentID)
	
	Quit $$$OK
}

ClassMethod GetJson(parentID)
{
	s type = $E(parentID,1,2)
	s id = $E(parentID,3,$l(parentID))
	
	w "["
	if type = "RT"
	{	
		d ..GetCategoryJson()
	}
	elseif type = "CG"
	{	
		d ..GetCateChapterJson(id)
	}
	
	w "]"
}

/// debug: d ##class(web.eprajax.ActionRange).GetCategoryJson()
ClassMethod GetCategoryJson()
{
	
	//遍历根节点的第一层目录(Category类型)
	s parentId = " 0"
	s curCategoryId = ""
	s count = 0
	for {
		s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", parentId, curCategoryId))
		q:(curCategoryId="")
			
		s isEPRCateActive = ..IsEPRCateogryActived(curCategoryId)
		continue:(isEPRCateActive = "0")
		
		s desc = $list($g(^DHCEPRM.EPRTemplateCategoryD(curCategoryId)),8)
		s count = count + 1
		
		if count>1 w ","
		w "{"
		w "id:'CG"_curCategoryId_"'"
		w ",text:'"_desc_"'"
		w ",cls:'folder'"
		w ",checked:false"
		w "}"
	}
}

/// debug: d ##class(web.eprajax.ActionRange).GetCateChapterJson(1)
ClassMethod GetCateChapterJson(parentId)
{
	
	s curCategoryId = parentId
		
	//遍历第二层节点(CategoryChapter)
	s curCategoryChapterId = ""
	s count = 0
	for {
		s curCategoryChapterId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_curCategoryId, curCategoryChapterId))
		q:(curCategoryChapterId="")
			
		//b "s"
		//是否挂有模板
		s hasPrintTemplate = ..HasPrintTemplate(curCategoryChapterId)
		continue:(hasPrintTemplate = 0)	
				
		s desc = $list($g(^DHCEPRM.EPRTemplateCategoryD(curCategoryChapterId)),8)
			
		s count = count + 1
			
		if (count > 1) w "," 
		w "{"
		w "id:'CC"_curCategoryChapterId_"'"
		w ",text:'"_desc_"'"
		w ",leaf:'ture'"
		w ",icon:'../scripts/epr/ExtJS/resources/images/default/tree/leaf.gif'"
		w ",cls:'leaf'"
		w ",checked:false"
		w "}"	
	}
}

/// CreateTime:2010-11-09
/// Creator:houj
/// Description:判断目录是否已经启用，即至少指定了一个安全组可以使用该目录
/// Input：	eprCategoryId：病历结构树第一层的id
/// Output: 无
/// Return: 1:已启用，0：未启用
/// Others:
ClassMethod IsEPRCateogryActived(eprCategoryId As %String) As %String
{
	s ssGroupID = $o(^DHCEPRM.EPRDOC.EPRSSGroupI("IdxCatalogSSGroup"," "_eprCategoryId,0))
	q:(ssGroupID="") "0"
	q "1"
}

ClassMethod HasPrintTemplate(categoryChapterId As %String) As %String
{
	s printTempDocId = "" 
	s printTempDocId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_categoryChapterId, printTempDocId))
	q:(printTempDocId = "") "0"
	q "1"
}

}
