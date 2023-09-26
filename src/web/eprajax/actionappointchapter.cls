Class web.eprajax.actionappointchapter Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	q:(episodeID="") $$$OK
	
	s patientID = $Get(%request.Data("PatientID",1),"")
	q:(patientID="") $$$OK
	
	s parentID = $Get(%request.Data("node",1),"-1")
	
	s workGroupID = $g(%session.Data("LOGON.GROUPID")) 	//当前登录医生的安全组
	s userID = %session.Get("LOGON.USERID")				//当前登录用户ID
	s userLoc = %session.Get("LOGON.CTLOCID")			//当前登录用户科室
	
	d ..GetJason(parentID, episodeID, userID, userLoc, workGroupID)
	
	Quit $$$OK
}

ClassMethod GetJason(parentID, episodeID, userID, userLoc, workGroupID)
{
	//s ^CaheTempDHCEPRDebug("actionappointchapter","input") = parentID_"^"_episodeID_"^"_userID_"^"_userLoc_"^"_workGroupID
	s type = $E(parentID,1,2)
	s id = $E(parentID,3,$l(parentID))
	
	w "["
	if type = "RT"
	{	d ..GetCategoryJason(episodeID, userID, userLoc, workGroupID)}
	elseif type = "CG"
	{	d ..GetCateChapterJason(id,episodeID, userID, userLoc, workGroupID)}
	
	w "]"
}

ClassMethod GetCategoryJason(episodeID, userID, userLoc, workGroupID)
{
	//s parentId = "RT0"
	//s parentType = $e(parentId,1,2)
	//s parentId = $e(parentId, 3, $l(parentId))	
	//s parentId = " "_parentId
	
	s isTplPrivActive = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
	s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(episodeID)
	
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

ClassMethod GetCateChapterJason(parentId, episodeID, userID, userLoc, workGroupID)
{
	
	//s parentType = $e(parentId,1,2)
	//s parentId = $e(parentId, 3, $l(parentId))
	
	s isTplPrivActive = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
	s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(episodeID)
		
	s curCategoryId = parentId
		
		//遍历第二层节点(CategoryChapter)
		s curCategoryChapterId = ""
		s count = 0
		for {
			s curCategoryChapterId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_curCategoryId, curCategoryChapterId))
			q:(curCategoryChapterId="")
			
			//b "s"
			//是否有可用的界面模板
			s validDocID = ##class(EPRservice.DocRestLogic.PrivLogic).GetDocIDForView(episodeID, "", curCategoryChapterId, isTplPrivActive, curPatInfo)
			continue:(validDocID = "")
			
			s hasImage = ..IsHasImage(episodeID, curCategoryId, curCategoryChapterId)
			s desc = $list($g(^DHCEPRM.EPRTemplateCategoryD(curCategoryChapterId)),8)
			
			s count = count + 1
			
			if count > 1 {w ","}
			w "{"
			w "id:'CC"_curCategoryChapterId_"'"
			w ",text:'"_desc_"'"
			w ",leaf:'ture'"
			w ",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
			w ",cls:'folder'"
			w ",checked:false"
			w ",hasImage:true"
			//w ",attributes:true"
				//w "[{hasImage:true}]" 
			w "}"	
		}
}

ClassMethod IsHasImage(episodeID As %String, parentId As %String, curCategoryId As %String) As %String
{
	set now = $Horolog
	set endDate = $ZD(now, 3)
	set endTime = $ZT(now, 2)		
	set docIdList = ##class(EPRmeta.EPRTemplateCategory).GetSubPrtTemplateCategory(parentId, curCategoryId)		//若为第二层目录,传入两个参数
	q:(docIdList = "") "0"
	
	set logIdList = ##class(EPRservice.BOEPRLogs).GetLogIDByDate(episodeID, "1840-12-31", "0:00", endDate, endTime,  docIdList)	
	q:(logIdList = "") "0"

	//返回值格式：totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2
	set imageList = ##class(EPRservice.BOEPImage).GetEPImageCount(episodeID,logIdList)	
	s imageCount = $p(imageList, "$", 1)
	q:(imageCount = 0) "0"

	q "1"
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

/// d ##class(web.eprajax.actionappointchapter).Test()
ClassMethod Test()
{
	s input = $g(^CaheTempDHCEPRDebug("actionappointchapter","input"))
	s episodeID = $p(input,"^",1)
	s userID = $p(input,"^",2)
	s userLoc = $p(input,"^",3)
	s workGroupID = $p(input,"^",4)
	d ..GetJason(episodeID, userID, userLoc, workGroupID)
}

}
