Class web.eprajax.categorytreedata Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//b "s"
	s parentId = $Get(%request.Data("node",1),"-1")
	s episodeID  = $Get(%request.Data("EpisodeID",1),"-1")	
	///w parentId
	q:(parentId = -1) $$$OK
	s parentType = $e(parentId,1,2)
	s parentId = $e(parentId,3,$l(parentId))

	
	s workGroupID = $g(%session.Data("LOGON.GROUPID")) //当前登录医生的安全组
	s userid = $g(%session.Data("LOGON.USERID"))       //当前登录用户ID
	s ctlocid = $g(%session.Data("LOGON.CTLOCID"))     //当前登录位置ID	
	
	d ..GetCateTreeData(parentId, episodeID, parentType, userid, ctlocid, workGroupID)
	
	q $$$OK
}

ClassMethod GetCateTreeData(parentId, episodeID, parentType, userid, ctlocid, workGroupID)
{
	s parentId = " "_parentId
	
	s isPrivActive = ..CheckCatePrivActivity()           //是否启用目录查看权限

	w "["
	s isFirstNode = 1
	
	if ((parentType = "CG") || (parentType = "RT") || (parentType = "CC"))
	{
		//如果要加载Chapter,此时需要进行权限控制，需要取出参数及病人信息
		s priActivity = "N"
		s curPatInfo = ""
		if (parentType = "CG")
		{
			s priActivity = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
			s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(episodeID)
		}
		
		//取出当前节点的下级目录或绑定的打印模板
		s seq = ""
		for {
			s seq = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCateogryIDAndSeq",parentId,seq))
			q:(seq = "")
			
		s curCategoryId = ""
		//s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID",parentId,curCategoryId))
		s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCateogryIDAndSeq",parentId,seq,curCategoryId))
		WHILE (curCategoryId '= "") 
		{
			//判断是否有查看权限（只判断第一层）
			s isCategoryIdValid = 1
			if ((isPrivActive = "Y") && (parentId = " 0"))
			{
				s ssGroupRuleRowID = $o(^DHCEPRM.EPRDOC.EPRSSGroupI("IdxCatalogSSGroup"," "_curCategoryId," "_workGroupID, 0))
				if (ssGroupRuleRowID = "")
				{
					s isCategoryIdValid = 0
				}
			}
			
			if (isCategoryIdValid = 1)
			{
				s curCategoryNote = $g(^DHCEPRM.EPRTemplateCategoryD(curCategoryId))
		
				s curCategoryName = $lg(curCategoryNote,8)
				s curCategoryType = $lg(curCategoryNote,10)
				
				s hasChild = $d(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID"," "_curCategoryId))
				if (hasChild = 0){s hasChild = $d(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_curCategoryId))}
				if (hasChild = 1)
				{
					s curLeaf = "true"
				}
				else
				{
					s curLeaf = "false"	
				}
				
				s curNodeId = ""
				
				if (curCategoryType="CategoryChapter")
				{
					//初始化CategoryChapter节点时，不直接初始化CategoryChapter节点，而是直接初始化其下级中适用的 打印模板 或 挂靠界面模板的节点
					//即文档中说明的隐藏第二层
					s curNodeNote = ..GetDocIDInChapter(episodeID, "", curCategoryId, priActivity, curPatInfo)
					if (curNodeNote = "")
					{
						s curNodeId = ""
					}
					else
					{
						s curNodeId = $p(curNodeNote,"^",1)
					}
				} 
				else
				{
					s curNodeId = ##class(EPRservice.BOEPRTemplateCategory).TransCategoryType(curCategoryType)_curCategoryId 
				}
				
				//add by zhuj on 2009-12-15 begin
				s commit = "0"
				S prtTempDocID = $E(curNodeId, 3, $L(curNodeId))
				s EPRNum = ##class(EPRservice.BOEPRLogs).GetSingleEPRNumByDocType(prtTempDocID)
				
				if (EPRNum = "1")
				{
					s currStatus = ##class(EPRinstance.EPRLogs).GetEPRStatus(episodeID, prtTempDocID, EPRNum)
					//s ^zjtest = currStatus
					if ((currStatus = "unfinished") || (currStatus = "finished"))
					{
						s commit = "0"	
					}
					else
					{
						s commit = "1"	
					}
				}
				//end
				
				if (curNodeId '= "")
				{
					if (isFirstNode = 0){w ","}
					w "{"
				    w "text:'"_curCategoryName_"'" 
				    w ",id:'"_curNodeId_"'"
				    w ",leaf:"_curLeaf
				    
				    //add by zhuj on 2009-12-15
				    if (commit = "1")
					{
						//w ",icon:'../scripts/epr/Pics/saveSingle.gif'"
						
						w ",cls:'tree-commit'"	
					}
				    w "}"
				
					s isFirstNode = 0
				}
			}
			//s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID",parentId,curCategoryId))
			s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCateogryIDAndSeq",parentId,seq,curCategoryId))
		
		} // end of while
		
		} //end of for
	}
	elseif((parentType = "TC") || (parentType = "LF"))
	{
		//取出当前节点下绑定的界面模板
		s curSeq = ""
		for {
			s curSeq = 	$o(^DHCEPRM.EPRTemplateI("IdxEPRTemplateSeq",parentId,curSeq))
			q:(curSeq = "")
						
			s curTemplateId = ""
			for {
				s curTemplateId = $o(^DHCEPRM.EPRTemplateI("IdxEPRTemplateSeq",parentId,curSeq,curTemplateId))
				q:(curTemplateId = "")
				 
				s curTemplateNote = $g(^DHCEPRM.EPRTemplateD(curTemplateId))
				s PrivRuleDR = $lg(curTemplateNote,14)
				if (PrivRuleDR '="") {
					s templateid=$lg(curTemplateNote,12) 
					s categoryid=""
					s EPRNum=""			
					s patientID=$p(^PAADM(episodeID),"^",1)
					s privString = "userid^"_userid_"!admid^"_episodeID_"!patientid^"_patientID_"!userloc^"_ctlocid_"!templateid^"_templateid_"!ssgroupid^"_workGroupID_"!categoryid^"_categoryid_"!docid^"_parentId_"!isnewframework^1!eprnum^"_EPRNum
					s privRule = ##class(EPRservice.Privilege.BOPrivRule).ParsePrivRuleByID(PrivRuleDR,privString)
					//load是规则检查约定返回值变量   guozongtao
					if (privRule.GetAt("load")="0"){
						//s curTemplateId = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID",parentId,curTemplateId))
						continue
					}				
				} 
				s curTemplateName = $lg(curTemplateNote,9)
				s curBindTemplateID = $lg(curTemplateNote,12)
				s curBindTemplateNote = $g(^DHCEPRM.TemplateD(curBindTemplateID))
				if (curBindTemplateNote=""){s curBindTemplateType = ""}else{s curBindTemplateType = $lg(curBindTemplateNote,9)} 
				s curLeaf = "true"
				if (curBindTemplateType="Multiple"){s curNodeId = "TM"_curTemplateId}else{s curNodeId = "TS"_curTemplateId}
				
				//add by zhuj on 2009-12-15
				s templateID = ##class(EPRmeta.EPRTemplate).GetTemplateIDByDocID(curTemplateId)
				s status = ##class(EPRservice.BOInstanceData).IsSaveSingle(episodeID, templateID)

				if (isFirstNode = 0){w ","}
				w "{"
			    w "text:'"_curTemplateName_"'" 
			    w ",id:'"_curNodeId_"'"
			    w ",leaf:"_curLeaf
			    //w ",cls:'folder'"
			    //add by zhuj on 2009-12-15
			    if (status = "1")
				{
					w ",icon:'../scripts/epr/Pics/saveSingle.gif'"
					w ",cls:'tree-save'"	
				}
				else
				{
					w ",icon:'../scripts/epr/Pics/unSaveSingle.gif'"	
					w ",cls:'tree-unsave'"
				}		    
				w "}"
				s isFirstNode = 0
			}
		}
	}elseif (parentType = "PS")
	{
       d ..GetPhotoSanCatagry(parentId,episodeID,isFirstNode)
	}
	
	w "]"
	
	//Quit $$$OK
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
	 q:(resultDocID = "") ""
	 
	 s curCategoryNote = $g(^DHCEPRM.EPRTemplateCategoryD(resultDocID))
	 s curCategoryType = $lg(curCategoryNote,10)
	 s curCategoryName = $lg(curCategoryNote,8)
	 
	 s resultDocID = ##class(EPRservice.BOEPRTemplateCategory).TransCategoryType(curCategoryType)_resultDocID

	 //返回结果
	 q resultDocID_"^"_curCategoryName
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

/// Creator: Candyxu
/// CreatDate: 2012-08-07
/// Description：加载知情同意书节点
/// Table: EPRmeta.EPRTemplate
/// Input: parentId--上级目录ID; episodeID-- 就诊号; isFirstNode--节点类型 
/// Output:
/// Return:
/// Debug: d ##Class(web.eprajax.categorytreedata).GetPhotoSanCatagry(362,201871,1)
ClassMethod GetPhotoSanCatagry(parentId As %String, episodeID As %String, isFirstNode As %String)
{
    s curSeq = ""
	for {
		s curSeq = 	$o(^DHCEPRM.EPRTemplateI("IdxEPRTemplateSeq",parentId,curSeq))
		q:(curSeq = "")
		s curTemplateId = ""
		for {
			s curTemplateId = $o(^DHCEPRM.EPRTemplateI("IdxEPRTemplateSeq",parentId,curSeq,curTemplateId))
			q:(curTemplateId = "")
			s curCatagryID = $li(^DHCEPRM.EPRTemplateD(curTemplateId),11)
			s catagryRowID = "0"
			for {
				s catagryRowID = $o(^DHCEPRI.RecordScanI("IdxParentEpisodeID"," "_curCatagryID," "_episodeID,catagryRowID))
				q:(catagryRowID = "")	
				s PhotoDesc = $li(^DHCEPRI.RecordScanD(catagryRowID),2)
				s PhotoPostion = $li(^DHCEPRI.RecordScanD(catagryRowID),7)
				s curLeaf = "true"			
				if (isFirstNode = 0){w ","}
				w "{"
			    w "text:'"_PhotoDesc_"'" 
			    w ",id:'"_"PS"_catagryRowID_"'"
			    w ",leaf:"_curLeaf
			    w ",Url:'"_PhotoPostion_"'"
                w "}"
                s isFirstNode = 0
			}
		}
	}
}

}
