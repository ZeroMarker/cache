/// 名称:web.eprajax.CategoryChapterInfo
/// 描述:根据传入的就诊号列表（EpisodeIDList）取出保存过的病历的相关信息
/// 编写者:loo
/// 编写日期:2010-06-04
Class web.eprajax.CategoryChapterInfo Extends %CSP.Page [ ProcedureBlock ]
{

/// Creator:loo
/// CreatDate:2010-06-04
/// Description:根据传入的就诊号列表（EpisodeIDList）取出保存过的病历的相关信息
/// Table:
/// Input:EpisodeIDList:就诊号的列表,格式为"episodeID1/episodeID2";ActionType:操作类型,0-授权,1-浏览病历
/// Output:
/// Return:categoryID1*cateCharpterName1*cateCharpterID1*imageList1@categoryID2*cateCharpterName2*cateCharpterID2*imageList2!categoryID3*cateCharpterName3*cateCharpterID3*imageList3
/// Others:返回值多条episodeID取得的结果之间用!区分,同一个episodeID取得的多个cateCharpter之间用@区分
ClassMethod OnPage() As %Status
{
	s episodeIDList = $Get(%request.Data("EpisodeIDList",1),"")
	q:(episodeIDList="")
	
	s patientID = $Get(%request.Data("PatientID",1),"")
	q:(patientID="")
	
	//操作类型,0-授权申请,1-浏览病历
	s ActionType = $Get(%request.Data("ActionType",1),"")
	q:(ActionType="")
	
	s workGroupID = $g(%session.Data("LOGON.GROUPID")) 	//当前登录医生的安全组
	s userID = %session.Get("LOGON.USERID")				//当前登录用户ID
	s userLoc = %session.Get("LOGON.CTLOCID")			//当前登录用户科室
	
	s ccInfo = ..GetCategoryChapterInfo(episodeIDList, patientID, ActionType, userID, userLoc, workGroupID)
	w ccInfo
	
	Quit $$$OK
}

/// Creator:loo
/// CreatDate:2010-06-04
/// Description:根据传入的就诊号列表（EpisodeIDList）取出保存过的病历的相关信息
/// Table:
/// Input:EpisodeIDList:就诊号的列表,格式为"episodeID1/episodeID2";ActionType:操作类型,0-授权,1-浏览病历
/// Output:
/// Return:categoryID1*cateCharpterName1*cateCharpterID1*imageList1@categoryID2*cateCharpterName2*cateCharpterID2*imageList2!categoryID3*cateCharpterName3*cateCharpterID3*imageList3
/// Others:返回值多条episodeID取得的结果之间用!区分,同一个episodeID取得的多个cateCharpter之间用@区分
ClassMethod GetCategoryChapterInfo(episodeIDList, patientID, ActionType, userID, userLoc, workGroupID) As %String
{
	s retStr = ""
	
	//取得规则类型为[病历浏览权限]的第一条符合的规则ID
	s argRuleID = ""
	&sql(SELECT top 1 ID into:argRuleID FROM  EPRmeta_Privilege.PrivRule 
		WHERE Valid='1' AND PrivRuleTypeDR in
		(SELECT ID FROM  EPRmeta_Privilege.PrivRuleType WHERE NAME='ViewPrivilege'))
	
	s delim="/"
  	s count=$LENGTH(episodeIDList,delim)
   	for reps=1:1:count
   	{
      	s episodeID=$P(episodeIDList,delim,reps)
      	
      	if (ActionType = "0")
      	{	s ccInfo = ..GetRequestChapterInfo(argRuleID,userID,episodeID,patientID,userLoc, workGroupID,ActionType)}
      	elseif (ActionType = "1")
      	{	s ccInfo = ..GetViewChapterInfo(argRuleID,userID,episodeID,patientID,userLoc, workGroupID,ActionType)}
      	
      	if (reps = "1")
      	{	s retStr = ccInfo}
      	else
      	{	s retStr = retStr_"!"_ccInfo}
   	}

	q retStr
}

/// Creator:houj
/// CreatDate:2010-11-12
/// Description:取出授权申请时所有可用的病历目录信息
/// Table:
/// Input:userID-用户ID, episodeID-就诊号, patientID-病人号,
/// 	  userLoc-用户科室, workGroupID-用户所在安全组
/// Output:
/// Return:categoryID1*cateCharpterName1*cateCharpterID1*imageList1@categoryID2*cateCharpterName2*cateCharpterID2*imageList2!
/// Others:返回值根据episodeID取得的多个cateCharpter之间用@区分,最后加上!
/// Debug:d ##class(web.eprajax.CategoryChapterInfo).GetRequestChapterInfo("3","5972","201764","1","34","576","1")
ClassMethod GetRequestChapterInfo(argRuleID, userID, episodeID, patientID, userLoc, workGroupID, ActionType) As %String
{
	s parentId = "RT0"
	s parentType = $e(parentId,1,2)
	s parentId = $e(parentId, 3, $l(parentId))
		
	s parentId = " "_parentId
	s categoryChapterInfo = ""
	
	s isTplPrivActive = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
	s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(episodeID)
	
	//遍历根节点的第一层目录(Category类型)
	s curCategoryId = ""
	for {
		s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", parentId, curCategoryId))
		q:(curCategoryId="")
			
		s isEPRCateActive = ..IsEPRCateogryActived(curCategoryId)
		continue:(isEPRCateActive = "0")
		
		//遍历第二层节点(CategoryChapter)
		s curCategoryChapterId = ""
		for {
			s curCategoryChapterId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_curCategoryId, curCategoryChapterId))
			q:(curCategoryChapterId="")
			
			s imageList = ""
			s categoryChapter = ##class(EPRmeta.EPRTemplateCategory).%OpenId(curCategoryChapterId)
			
			s validDocID = ##class(EPRservice.DocRestLogic.PrivLogic).GetDocIDForView(episodeID, "", curCategoryChapterId, isTplPrivActive, curPatInfo)
			continue:(validDocID = "")
			
			if (categoryChapterInfo = "")
			{	s categoryChapterInfo = curCategoryId_"*"_categoryChapter.CategoryName_"*"_categoryChapter.%Id()_"*"_imageList}
			else
			{	s categoryChapterInfo = categoryChapterInfo_"@"_curCategoryId_"*"_categoryChapter.CategoryName_"*"_categoryChapter.%Id()_"*"_imageList}
		}
	}
	q categoryChapterInfo
}

/// Creator:houj   modify by Candyxu 2012-8-28
/// CreatDate:2010-11-12
/// Description:取出病历流浪时所有可用的病历信息
/// 			条件：生成了病历图片
/// Table:
/// Input:userID-用户ID, episodeID-就诊号, patientID-病人号,
/// 	  userLoc-用户科室, workGroupID-用户所在安全组
/// Output:
/// Return:categoryID1*cateCharpterName1*cateCharpterID1*imageList1@categoryID2*cateCharpterName2*cateCharpterID2*imageList2!
/// Others:返回值根据episodeID取得的多个cateCharpter之间用@区分,最后加上!
/// Debug:d ##class(web.eprajax.CategoryChapterInfo).GetViewChapterInfo("3","5972","201764","1","34","576","1")
ClassMethod GetViewChapterInfo(argRuleID, userID, episodeID, patientID, userLoc, workGroupID, ActionType) As %String
{
	//s ^CaheTempDHCEPRDebug("CategoryChapterInfo.GetViewChapterInfo","input") = argRuleID_"^"_userID_"^"_episodeID_"^"_patientID_"^"_userLoc_"^"_workGroupID_"^"_ActionType

	s parentId = "RT0"
	s parentType = $e(parentId,1,2)
	s parentId = $e(parentId, 3, $l(parentId))
	s parentId = " "_parentId
	s categoryChapterInfo = ""
	
	//取出根节点的下级目录（即第一层目录，Category）后,循环第一层的节点，取出下层目录（即第二层目录，CategoryChapter）
	s curCategoryId = ""
	for {
		s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", parentId, curCategoryId))
		q:(curCategoryId="")
        s hasPhotoScanImage = ..IsHasPhotoScan(episodeID,curCategoryId,"")
		//病历浏览时Category下应有病历图片生成
		s hasImage = ..IsHasImage(episodeID, curCategoryId, "")
		continue:((hasImage = "0") && (hasPhotoScanImage = "0"))
		//取第二层节点
		s curCategoryChapterId = ""
		for {
			s curCategoryChapterId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_curCategoryId, curCategoryChapterId))
			q:(curCategoryChapterId="")
			s curCategoryChapterNote = $g(^DHCEPRM.EPRTemplateCategoryD(curCategoryChapterId))
			s categoryChapter = ##class(EPRmeta.EPRTemplateCategory).%OpenId(curCategoryChapterId)
			s curTemplateId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_curCategoryChapterId,""))
			continue:(curTemplateId = "")
			s curCategoryType = $li(^DHCEPRM.EPRTemplateCategoryD(curTemplateId),10)
			if (curCategoryType = "PhotoScan")
			{
				s imageList = ..GetPhotoScanImageList(curTemplateId,episodeID)
				continue:(imageList = "") 
			}else
			{
			    s hasImage = ..IsHasImage(episodeID, curCategoryId, curCategoryChapterId)
		        continue:(hasImage = "0")
			
			    set now = $Horolog
			    set endDate = $ZD(now, 3)
			    set endTime = $ZT(now, 2)		
			    set docIdList = ##class(EPRmeta.EPRTemplateCategory).GetSubPrtTemplateCategory(curCategoryId, curCategoryChapterId)		//若为第二层目录,传入两个参数
			    continue:(docIdList = "")
				
			     //浏览病历需要走权限脚本
			    s ruleDocIdList = ..GetRuleDocList(argRuleID,userID,episodeID,patientID,userLoc,docIdList,workGroupID)
			
			    if (ruleDocIdList="")
			    {
			       //没有权限
				   s imageList = "NoPower,"_categoryChapter.CategoryName
				   s categoryChapterInfo = categoryChapterInfo_"@"_curCategoryId_"*"_categoryChapter.CategoryName_"*"_categoryChapter.%Id()_"*"_imageList
				   continue
			    }
				
				//病历生成日志是否存在
				s isImageLogExisted = ##Class(EPRservice.BLL.BLEPImageLog).IsEPImageLogListExisted(episodeID,ruleDocIdList)
				if (isImageLogExisted = "1")
				{
					s imageList = "ImageNotUpdate,"_categoryChapter.CategoryName
					s categoryChapterInfo = categoryChapterInfo_"@"_curCategoryId_"*"_categoryChapter.CategoryName_"*"_categoryChapter.%Id()_"*"_imageList
					continue
				}
			
				//获取按发生日期时间排序后的EPRinstance.EPRLogs的rowid列表
			    //s logIdList = ##class(EPRservice.BOEPRLogs).GetLogIDByDate(episodeID, "1840-12-31", "0:00", endDate, endTime, ruleDocIdList)	
				s logIdList = ##class(EPRservice.BOEPRLogs).GetRankedLogIDByDate(episodeID, ruleDocIdList, "", "", "", "")	
				
				s hasOldImage = ##class(EPRservice.BOEPImage).HasOldEPImage(episodeID, logIdList)
				if (hasOldImage = "1")
				{
					s imageList = "ImageNotUpdate,"_categoryChapter.CategoryName
					s categoryChapterInfo = categoryChapterInfo_"@"_curCategoryId_"*"_categoryChapter.CategoryName_"*"_categoryChapter.%Id()_"*"_imageList
					continue
				}
				
			    //返回值格式：totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2
			    s imageList = ##class(EPRservice.BOEPImage).GetEPImageCount(episodeID,logIdList)
			    s:(logIdList = "") imageList = "logIdListnull,"_categoryChapter.CategoryName
			}
			s categoryChapterInfo = categoryChapterInfo_"@"_curCategoryId_"*"_categoryChapter.CategoryName_"*"_categoryChapter.%Id()_"*"_imageList		
		}
	}
	
	if (categoryChapterInfo '= "")
	{	s categoryChapterInfo = $E(categoryChapterInfo,2,$L(categoryChapterInfo))}
	
	q categoryChapterInfo
}

/// Creator:loo
/// CreatDate:2010-9-13
/// Description:将传入的ADocIDList进行拆分,拼环境变量argEnviromentInfo,然后依次跑权限脚本,返回符合要求的DocID拼成的串
/// Table:
/// Input:AUserID-用户ID,AEpisodeID-就诊号,APatientID-病人ID,
/// 	  AUserLoc-用户科室ID,ADocList-PrintDocID集合,AssGroupID-用户安全组ID
/// Output:
/// Return:RuleDocList,格式:"printDocID1!1^printDocID2!0^printDocID3"
/// Others:
ClassMethod GetRuleDocList(argRuleID As %String, AUserID As %String, AEpisodeID As %String, APatientID As %String, AUserLoc As %String, ADocList As %String, AssGroupID As %String) As %String
{
	q:(argRuleID = "") ADocList
	
	s RuleDocList = ""
	for i = 1:1:$l(ADocList, "^")
	{
		s ADocID = $p(ADocList, "^", i)
		
		//拼环境变量,跑脚本
		s argEnviromentInfo = "userid^"_AUserID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!userloc^"_AUserLoc_"!templateid^"_0_"!ssgroupid^"_AssGroupID_"!categoryid^"_0_"!docid^"_ADocID_"!isnewframework^1!eprnum^1"
		s arr = ##class(EPRservice.Privilege.BOPrivRule).ParsePrivRuleByID(argRuleID,argEnviromentInfo)
		
		continue:(arr.GetAt("browse")=0)
		
		//符合权限脚本
		if (RuleDocList="")
		{
			s RuleDocList = ADocID
		}
		else
		{
			s RuleDocList = RuleDocList_"^"_ADocID
		}
		
	}
	
	q RuleDocList
}

/// CreateTime:2010-1-22
/// Creator:zhuj
/// Description:根据目录取判断是否有图片
/// Input：	aEpisodeID：病人就诊rowid
/// 		parentId：病历结构树第一层的id
/// 		curCategoryId: 病历结构树第二层id,若只选中第1层,传入""即可
/// Output: 1:有图片，0：无图片
/// Return:
/// Others:
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

/// d ##class(web.eprajax.CategoryChapterInfo).TestGetViewChapterInfo()
ClassMethod TestGetViewChapterInfo()
{
	s input = $g(^CaheTempDHCEPRDebug("CategoryChapterInfo.GetViewChapterInfo","input"))
	s argRuleID = $p(input,"^",1)
	s userID = $p(input,"^",2)
	s episodeID = $p(input,"^",3)
	s patientID = $p(input,"^",4)
	s userLoc = $p(input,"^",5)
	s workGroupID = $p(input,"^",6)
	s ActionType = $p(input,"^",7)
	
	w ..GetViewChapterInfo(argRuleID, userID, episodeID, patientID, userLoc, workGroupID, ActionType)
}

/// CreateTime:2012-8-10
/// Creator:Candyxu
/// Description:根据目录取判断是否有知情同意书图片
/// Input：	episodeID：病人就诊rowid
/// 		CategoryId：病历结构树第一层的id
/// 		curCategoryId: 病历结构树第二层id,若只选中第1层,传入""即可
/// Output: 1:有图片，0：无图片
/// Return:
/// Others:
/// Debug w ##Class(web.eprajax.CategoryChapterInfo).IsHasPhotoScan(221,180,"")
ClassMethod IsHasPhotoScan(episodeID As %String, parentId As %String, curCategoryId As %String) As %String
{
	q:((parentId = "") && (curCategoryId = "")) "0"
	if (curCategoryId = "")
	{
		s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID"," "_parentId,""))
		q:(curCategoryId = "") "0"
	}
	s PhotoCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId,""))
	q:(PhotoCategoryId = "") "0"
	s curCategoryType = $li(^DHCEPRM.EPRTemplateCategoryD(PhotoCategoryId),10)
	q:(curCategoryType '= "PhotoScan") "0"
    s curTemplateId = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_PhotoCategoryId,""))
    q:(curTemplateId = "") "0"
    q "1"
}

/// CreateTime:2012-8-10
/// Creator:Candyxu
/// Description:根据目录取知情同意书图片存储信息
/// Input：	episodeID：病人就诊rowid
/// 		CategoryId：病历结构树第一层的id
/// 		curCategoryId: 病历结构树第二层id,若只选中第1层,传入""即可
/// Output: "PhotoScan"_"&"_Count_"$"_Result :类型&总数$存储位置
/// Return: 当目录下没有病历扫描图片时返回空。
/// Others:
/// debug : w ##Class(web.eprajax.CategoryChapterInfo).GetPhotoScanImageList(180,221)
ClassMethod GetPhotoScanImageList(parentId As %String, episodeID As %String) As %String
{
	s Result = ""
	s Count = 0
	q:((parentId = "")||(episodeID = ""))
    s curSeq = ""
	for {
		s curSeq = 	$o(^DHCEPRM.EPRTemplateI("IdxEPRTemplateSeq"," "_parentId,curSeq))
		q:(curSeq = "")
		s curTemplateId = ""
		for {
			s curTemplateId = $o(^DHCEPRM.EPRTemplateI("IdxEPRTemplateSeq"," "_parentId,curSeq,curTemplateId))
			q:(curTemplateId = "")
			s curCatagryID = $li(^DHCEPRM.EPRTemplateD(curTemplateId),11)
			s catagryRowID = "0"
			for {
				s catagryRowID = $o(^DHCEPRI.RecordScanI("IdxParentEpisodeID"," "_curCatagryID," "_episodeID,catagryRowID))
				q:(catagryRowID = "")	
				s PhotoDesc = $li(^DHCEPRI.RecordScanD(catagryRowID),2)
				s PhotoPostion = $li(^DHCEPRI.RecordScanD(catagryRowID),7)
				s Result = Result_PhotoPostion_"^"
				s Count = Count + 1
			}
		}
	}
	if (Count = 0)
	{
		q ""
	}else
	{
	    q "PhotoScan"_"&"_Count_"$"_Result
	}
}

}
