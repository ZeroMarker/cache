/// 名称:web.eprajax.commontemplate
/// 描述:根据系统参数中的常用模板配置,取出对应的cgID,ccID,priDocID等信息
/// 编写者:loo
/// 编写日期:2010-08-11
Class web.eprajax.commontemplate Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//b "s"
	s cgId = $Get(%request.Data("cgID",1),"-1")
	s ccId = $Get(%request.Data("ccID",1),"-1")
	s episodeID  = $Get(%request.Data("EpisodeID",1),"-1")
	s TmpDocIdStr  = $Get(%request.Data("TmpDocIdStr",1),"-1")
	
	q:(cgId = -1) $$$OK
	
	s workGroupID = $g(%session.Data("LOGON.GROUPID")) //当前登录医生的安全组
	s userid = $g(%session.Data("LOGON.USERID"))       //当前登录用户ID
	s ctlocid = $g(%session.Data("LOGON.CTLOCID"))     //当前登录位置ID	
	w ..getCommonTemplate(cgId,ccId,episodeID,TmpDocIdStr,workGroupID,userid,ctlocid)
	Quit $$$OK
}

/// Debug:w ##class(web.eprajax.commontemplate).getCommonTemplate("7","33","49","85","207","83","989")
ClassMethod getCommonTemplate(cgId, ccId, episodeID, TmpDocIdStr, workGroupID, userid, ctlocid) As %String
{
	//b "s"
	s TmpDocIdStr = "*"_TmpDocIdStr_"*"
	s isPrivActive = ..CheckCatePrivActivity()           //是否启用目录查看权限
	s priActivity = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()  //是否启用模板规则
	
	s categoryInfo = ""
	
	//如果要加载Chapter,此时需要进行权限控制
	//获取病人信息
	s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(episodeID)
	
	//判断是否有目录查看权限（判断第一层）
	if (isPrivActive = "Y")
	{
		s ssGroupRuleRowID = $o(^DHCEPRM.EPRDOC.EPRSSGroupI("IdxCatalogSSGroup"," "_cgId," "_workGroupID, 0))
		if (ssGroupRuleRowID = "")
		{
			q categoryInfo
		}
	}	
		
	//取出当前节点的Chapter目录
	s curCCId=""
	for {	
		s curCCId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID"," "_cgId, curCCId))
		q:(curCCId="") 
		
		//判断当前CategoryChapterID是否指定的ID
		if curCCId '= ccId continue
		
		//获取可用的打印模板DocID
		s prtDocId= ..GetDocIDInChapter(episodeID, "", ccId, priActivity, curPatInfo)
		if (prtDocId = "") q
		
		//判断可用的打印模板DocID是否在指定的PrintDocID列表之中
		//if $find(TmpDocIdStr,"*"_prtDocId_"@")<1 q
		
		//获取打印模板DocID下的可用界面模板
		s curTempDocId = ""
		for	{
			//b "s"
			s curTempDocId = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_prtDocId,curTempDocId))
			q:(curTempDocId="")
			
			s curTemplateNote = $g(^DHCEPRM.EPRTemplateD(curTempDocId))
			s PrivRuleDR = $lg(curTemplateNote,14)
			if (PrivRuleDR '="")
			{
				s templateid="" 
				s categoryid=""
				s EPRNum=""
				s patientID=$p(^PAADM(episodeID),"^",1)
				s privString = "userid^"_userid_"!admid^"_episodeID_"!patientid^"_patientID_"!userloc^"_ctlocid_"!templateid^"_templateid_"!ssgroupid^"_workGroupID_"!categoryid^"_categoryid_"!docid^"_prtDocId_"!isnewframework^1!eprnum^"_EPRNum
				s privRule = ##class(EPRservice.Privilege.BOPrivRule).ParsePrivRuleByID(PrivRuleDR,privString)
				//load是规则检查约定返回值变量   guozongtao
				if (privRule.GetAt("load")="0") continue				
			}
			if TmpDocIdStr = "**"
			{
				s categoryInfo = cgId_"^"_ccId_"^"_prtDocId_"^"_curTempDocId
				q
			}
			
			if $find(TmpDocIdStr, "*"_curTempDocId_"*")<1 continue
			
			s categoryInfo = cgId_"^"_ccId_"^"_prtDocId_"^"_curTempDocId
			q	
		}
		
		q 
	}
	
	q categoryInfo
}

/// Creator: 陈文俊
/// CreatDate: 2009-08-07
/// Description：取出ChapterDoc节点下可用的DocID（即可用的TempCate或PrtTemplate类型的Doc）
/// 			 在构造病历结构树形时，处理ChapterDoc类型的节点，该类型的节点将被隐藏，其位置由TempCate或PrtTemplate类型的节点代替
/// Table:
/// Input: EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parCategoryID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return: DocID(打印模板 或 挂靠界面模板的目录)
ClassMethod GetDocIDInChapter(EpisodeID As %String, parOthers As %String, parCategoryID As %String, parPriActivity As %String, parPatInfo As %Library.List) As %String
{
	 s resultDocID = ""
	 
	 s resultDocID = ##class(EPRservice.DocRestLogic.PrivLogic).GetDocIDForView(EpisodeID, parOthers, parCategoryID, parPriActivity, parPatInfo)
	 
	 q resultDocID
}

/// Creator: 陈文俊
/// CreatDate: 2009-09-01
/// Description：系统参数是否设置为开启目录查看权限
/// Table:
/// Input:
/// Output:
/// Return:是否开启  Y--是  N--否
ClassMethod CheckCatePrivActivity() As %String
{
	 s catePrivActivityStr = "N"
	 s catePrivActivityRowId = ""
	 
     s catePrivActivityRowId = $o(^DHCEPRM.SysOptionI("NameIndex"," CPRIVACTIVITY",""))
	 if catePrivActivityRowId'=""
	 {
		s catePrivActivityStr=$li(^DHCEPRM.SysOptionD(catePrivActivityRowId),4)	
	 }
	 
	 if catePrivActivityStr '= "Y"
	 {
		s catePrivActivityStr = "N"
	 }
	 
	 q catePrivActivityStr
}

/// Creator:	wangwentao
/// CreatDate:	20131018
/// Desc:		通过循环PAC_AdmTypeLocation获取科室类型	
/// Input:		ALocID:CT_Loc表的RowId
/// Output:		{O:门诊,E:急诊,I:住院,"":NULL}
/// Debug:		##Class(web.eprajax.commontemplate).GetDeptTypeByLoc(ALocID)
ClassMethod GetDeptTypeByLoc(ALocID As %String) As %String
{
	q:($d(ALocID)=0)||(ALocID="") ""
	
	s RetValue = ""
	
	//循环取表 PAC_AdmTypeLocation
	//^PAC("ADMLOC",1)=O^112
	//^PAC("ADMLOC",70)=I^69
	//^PAC("ADMLOC",28)=E^103
	s ADMLOCRowId = ""
	for {
		s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId))
		q:(ADMLOCRowId="")||(RetValue'="")
		
		s (ADMLOCAdmType,ADMLOCCTLocDR) = ""
		s ADMLOCAdmType = $p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",1)
		s ADMLOCCTLocDR = $p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2)
		
		continue:(ADMLOCCTLocDR'=ALocID)
		
		s RetValue = ADMLOCAdmType
		
	}
	
	q RetValue
}

}
