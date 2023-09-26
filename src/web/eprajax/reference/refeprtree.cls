/// 类名: web.eprajax.reference.refeprtree
/// 描述: 取得患者历次就诊病历引用树
/// 编写者: Kumon Xie
/// 编写日期: 2011-05-19
Class web.eprajax.reference.refeprtree Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//获取从前端传过来的参数
	s nodeID = $g(%request.Data("node",1),"-1")
	s oldEpisodeID = $g(%request.Data("OldEpisodeID",1),"-1")	
	s newEpisodeID = $g(%request.Data("NewEpisodeID",1),"-1")	
	s prtTemplateDocID = $g(%request.Data("PrintTemplateDocID",1),"-1")
	
	//从Session中获取当前登录的用户信息
	s userID = $g(%session.Data("LOGON.USERID"))
	s ctLocID = $g(%session.Data("LOGON.CTLOCID"))
	s ssGroupID = $g(%session.Data("LOGON.GROUPID"))
		
	if (oldEpisodeID = "")
	{
		//s ^CacheTemp("EPRReference","web.eprajax.reference.refeprtree","Parameters","NoOldEpisodeID") = oldEpisodeID_"^"_newEpisodeID_"^"_prtTemplateDocID
		w "[{id:'hintNode',text:'请先从历次就诊列表中选择一次就诊记录!',leaf:true,cls:'hintnode'}]"
	}
	else
	{
		//s ^CacheTemp("EPRReference","web.eprajax.reference.refeprtree","Parameters","WithOldEpisodeID") = nodeID_"^"_oldEpisodeID_"^"_newEpisodeID_"^"_prtTemplateDocID_"^"_userID_"^"_ctLocID_"^"_ssGroupID
		d ..GetReferenceEPRTreeJSON(nodeID, newEpisodeID, oldEpisodeID, prtTemplateDocID, userID, ctLocID, ssGroupID)
	}
	
	q $$$OK
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-06-11
/// Description:获取病历引用树JSON串;
/// Table:		无
/// Input:		ANodeID为前台病历引用树上选中节点ID;
/// Output:		病历引用树JSON串;
/// Return:		无
/// Others:		无
/// Debug:		w ##Class(web.eprajax.reference.refeprtree).GetReferenceEPRTreeJSON("RT0","201764","21","5972","34","576")
ClassMethod GetReferenceEPRTreeJSON(ANodeID As %String, ANewEpisodeID As %String, AOldEpisodeID As %String, APrintTemplateDocID As %String, AUserID As %String, ACTLocID As %String, ASSGroupID As %String)
{
	s type 	 	= $e(ANodeID,1,2)
	s parentID 	= $e(ANodeID,3,$l(ANodeID))
	
	w "["
	
	if (type = "RT")
	{	
		d ..GetCategoryJSON(APrintTemplateDocID, ASSGroupID)
	}
	elseif (type = "CG")
	{	
		d ..GetCategoryChapterJSON(parentID, APrintTemplateDocID, ANewEpisodeID,AOldEpisodeID)
	}
	elseif (type = "CC")
	{
		d ..GetInterfaceTemplateJSON(parentID, APrintTemplateDocID, ANewEpisodeID, AOldEpisodeID, AUserID, ACTLocID, ASSGroupID)	
	}
	
	w "]"
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-06-11
/// Description:根据登录安全组权限获取病历引用树第一层目录结构;
/// Table:		无	
/// Input:		APrintTemplateDocID为当前页面对应的打印模板DocID,用于指定默认的Category,由前台引用按钮传入;
/// 			ASSGroupID为当前登录安全组ID;
/// Output:		病历引用树第一次目录JSON字符串;
/// Return:		无
/// Others:		根据传入的PrintTemplateDocID寻找默认选中的第一层目录节点;
/// Debug:		w ##Class(web.eprajax.reference.refeprtree).GetCategoryJSON("21","576")
ClassMethod GetCategoryJSON(APrintTemplateDocID As %String, ASSGroupID As %String)
{
	//遍历根节点的第一层目录(Category类型)
	s count = 0
	s parCategoryID = " 0"
	s curCategoryID = ""
	for {
		s curCategoryID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", parCategoryID, curCategoryID))
		q:(curCategoryID = "")
		
		//判断是否有查看权限（只判断第一层）	
		s isCategoryActived = ..IsEPRCateogryActived(curCategoryID,ASSGroupID)
		continue:(isCategoryActived = 0)
		
		s isShowCategory = ..IsShowCategory(curCategoryID, APrintTemplateDocID)
		continue:($p(isShowCategory,"#",1) = 0)
		
		s count = count + 1		
		s categoryName = $list($g(^DHCEPRM.EPRTemplateCategoryD(curCategoryID)),8)
		
		if (count > 1) { w "," }
		w "{"
		w "id:'CG"_curCategoryID_"'"
		w ",text:'"_categoryName_"'"
		w ",cls:'folder'"
		w ",checked:"_$p(isShowCategory,"#",2)
		w "}"
	}
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-06-11
/// Description:获取病历引用树第二层,名字为EPRTemplateCategory类型为CategoryChapter,ID为类型为PrtTemplate的RowID;
/// Table:		无
/// Input:		ACategoryID为第一层节点ID(类型为Category);
/// 			APrintTemplateDocID为当前页面对应的打印模板DocID,用于指定默认的Chapter;
/// 			ANewEpisodeID为当前就诊号;
/// 			AOldEpisodeID为选中的历次就诊号;
/// Output:		病历引用树第二层JSON字符串
/// Return:		无
/// Others:		无
/// Debug:		w ##Class(web.eprajax.reference.refeprtree).GetCategoryChapterJSON("4","21","201764","201764")
ClassMethod GetCategoryChapterJSON(ACategoryID As %String, APrintTemplateDocID As %String, ANewEpisodeID As %String, AOldEpisodeID As %String)
{
	s isTplPrivActive = ##Class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
	s curPatientInfo = ##Class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(ANewEpisodeID)
	
	s count = 0
	s curChapterID = ""
	s blankCategoryID = " "_ACategoryID
	for {
		s curChapterID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", blankCategoryID, curChapterID))
		q:(curChapterID = "")
		
		s isShowChapter = ..IsShowChapter(curChapterID,APrintTemplateDocID)
		continue:($p(isShowChapter,"#",1) = 0)

		s validDocID = ##Class(EPRservice.DocRestLogic.PrivLogic).GetDocIDForView(ANewEpisodeID, "", curChapterID, isTplPrivActive, curPatientInfo)
		continue:(validDocID = "")
		
		//判断指定的历次就诊是否保存过,如果历次就诊没写过则不加载
		s logRowID = $o(^DHCEPRI.EPRLogsI("IdxMain"," "_AOldEpisodeID," "_validDocID,1,""))
		continue:(logRowID = "")
		s lastEPRStatus = ##Class(EPRinstance.EPRLogs).GetEPRStatus(AOldEpisodeID,validDocID,1)
		continue:(lastEPRStatus = "unfinished")
		
		s isLeaf = "false"
		s curChapterName = $list($g(^DHCEPRM.EPRTemplateCategoryD(curChapterID)),8)
		
		s count = count + 1
		
		if (count > 1) {w ","}
		w "{"
		w "id:'CC"_validDocID_"'"
		w ",text:'"_curChapterName_"'"
		w ",leaf:"_isLeaf
		w ",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
		w ",cls:'folder'"
		w ",checked:"_$p(isShowChapter,"#",2)
		w ",hasImage:true"
		w "}"	
	}
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-06-12
/// Description:获取病历引用树第三层界面模板,1)规则检查;2)权限检查;3)历次就诊是否有保存过;4)两次界面模板版本是否匹配;
/// Table:		无
/// Input:		ACurPrtTemplateDocID为打印模板DocID;
/// 			APrintTemplateDocID为当前页面对应的打印模板DocID,用于指定默认的Chapter;
/// 			ANewEpisodeID为当前就诊号;
/// 			AOldEpisodeID为选中的历次就诊号;
/// 			AUserID为当前登录账户RowID;
/// 			ACTLocID为当前登录账户所在科室RowID;
/// 			ASSGroupID为当前登录账户所在安全组RowID;
/// Output:		病历引用树第三层JSON字符串;
/// Return:		无
/// Others:		无
/// Debug:		w ##Class(web.eprajax.reference.refeprtree).GetInterfaceTemplateJSON("21","21","201871","201764","3928","34","576")
ClassMethod GetInterfaceTemplateJSON(ACurPrtTemplateDocID As %String, APrintTemplateDocID As %String, ANewEpisodeID As %String, AOldEpisodeID As %String, AUserID As %String, ACTLocID As %String, ASSGroupID As %String)
{
	s EPRNum = "1"		//所有唯一模板EPRNum均为1			
	s isFirstNode = 1	//是否为第一个节点
	s patientID = $p(^PAADM(ANewEpisodeID),"^",1)	
	s prtTemplateID = $list($g(^DHCEPRM.EPRTemplateCategoryD(ACurPrtTemplateDocID)),16)
	s checked = $s(($g(ACurPrtTemplateDocID) = $g(APrintTemplateDocID)):"true", 1:"false")

	s curEPRSequence = ""
	for {
		s curEPRSequence = $o(^DHCEPRM.EPRTemplateI("IdxEPRTemplateSeq"," "_ACurPrtTemplateDocID,curEPRSequence))
		q:(curEPRSequence = "")
					
		s curEPRTemplateID = ""
		for {
			s curEPRTemplateID = $o(^DHCEPRM.EPRTemplateI("IdxEPRTemplateSeq"," "_ACurPrtTemplateDocID,curEPRSequence,curEPRTemplateID))
			q:(curEPRTemplateID = "")

			s objEPRTemplate = $g(^DHCEPRM.EPRTemplateD(curEPRTemplateID))
			s bindCategoryID = $list(objEPRTemplate,11) 
			s bindTemplateID = $list(objEPRTemplate,12) 
			
			//规则检查
			s privRuleDR = $list(objEPRTemplate,14)
			if (privRuleDR '= "") 
			{	
				s privString = "userid^"_AUserID_"!admid^"_ANewEpisodeID_"!patientid^"_patientID_"!userloc^"_ACTLocID_"!templateid^"_bindTemplateID_"!ssgroupid^"_ASSGroupID_"!categoryid^"_bindCategoryID_"!docid^"_ACurPrtTemplateDocID_"!isnewframework^1!eprnum^"_EPRNum
				s privRule = ##Class(EPRservice.Privilege.BOPrivRule).ParsePrivRuleByID(privRuleDR,privString)
				//load是规则检查约定返回值变量
				continue:(privRule.GetAt("load") = "0")
			}
			
			//权限检查
			s arrPower = ##Class(web.eprajax.ajaxGetPower).GetPowerArray(AUserID, ANewEpisodeID, patientID, ACTLocID, bindTemplateID, ASSGroupID, bindCategoryID, ACurPrtTemplateDocID, EPRNum)
			s canSave = arrPower.GetAt("canSave")
			continue:(canSave '= 1)
			
			s chartItemID = "CG"_bindTemplateID
			
			//指定就诊不包含当前模板,则不加载这个模板
			s oldECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AOldEpisodeID," "_chartItemID,""))
			continue:(oldECRecordID = "")
			
			s oldChildSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",oldECRecordID," 1",""))
			s oldInstanceID = oldECRecordID_"||"_oldChildSub
			s objOldInstanceData = ##Class(EPRinstance.InstanceData).%OpenId(oldInstanceID)
			s lastStatus = objOldInstanceData.GetCurrentStatus()
			s lastTemplateVer = objOldInstanceData.TemplateVersion
			continue:(lastStatus = "")||(lastStatus = "UnSave")

			//当前就诊是否保存过
			s newECRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_ANewEpisodeID," "_chartItemID,""))
			if (newECRecordID '= "")
			{
				s newChildSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",newECRecordID," 1",""))
				s newInstanceID = newECRecordID_"||"_newChildSub
				s objNewInstanceData = ##Class(EPRinstance.InstanceData).%OpenId(newInstanceID)
				s curStatus = objNewInstanceData.GetCurrentStatus()
				if ($zcvt(curStatus,"L") '= "unsave")
				{
					s disabled = "true"
					s isChecked = "false"
				}
				else
				{
					//比较模板版本
					s newestTemplateVer = ##Class(EPRmeta.Template).GetVersionBYID(bindTemplateID)
					s disabled = $s(lastTemplateVer = newestTemplateVer:"false", 1:"true")
					s isChecked = $s(disabled = "true" : "false", 1: checked)
				}
			}
			else
			{
				//比较模板版本
				s newestTemplateVer = ##Class(EPRmeta.Template).GetVersionBYID(bindTemplateID)
				s disabled = $s(lastTemplateVer = newestTemplateVer:"false", 1:"true")
				s isChecked = $s(disabled = "true" : "false", 1: checked)	
			}

			s curTemplateName = $list(objEPRTemplate,9)
			s categoryName = $list($g(^DHCEPRM.TemplateCategoryD(bindCategoryID)),3)
			s categoryType = $list($g(^DHCEPRM.TemplateCategoryD(bindCategoryID)),7)
			
			if (isFirstNode = 0){w ","}
			
			w "{"
		    w "id:'"_oldInstanceID_"'"
		    w ",text:'"_curTemplateName_"'" 
		    w ",leaf:'true'"
		    w ",disabled:"_disabled
		    //if (disabled = "true") {w ",cls:'hintnode'"}
		    w ",checked:"_isChecked
		    w ",categoryID:"_bindCategoryID
		    w ",categoryName:'"_categoryName_"'"
		    w ",categoryType:'"_categoryType_"'"
		    w ",templateID:"_bindTemplateID
		    w ",prtTemplateID:"_prtTemplateID
		    w ",templateDocID:"_curEPRTemplateID
		    w ",prtTemplateDocID:"_ACurPrtTemplateDocID
			w "}"
			
			s isFirstNode = 0
		}
	}
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-06-13
/// Description:根据权限规则判断指定的AEPRCategoryID针对当前的安全组ASSGroupID是否为激活状态
/// Table:		EPRmeta.SysOption, EPRmeta_EPRDOC.EPRSSGroup
/// Input:		AEPRCategoryID为EPRTemplateCategory表的RowID;
/// 			ASSGroupID为安全组RowID;
/// Output:		无
/// Return:		1:有效;0:无效
/// Others:		无
/// Debug:		w ##Class(web.eprajax.reference.refeprtree).IsEPRCateogryActived("7","576")
ClassMethod IsEPRCateogryActived(AEPRCategoryID As %String, ASSGroupID As %String) As %String
{
	s ret = 1
	s isPrivActivity = "N"
	s sysOptionRowID = $o(^DHCEPRM.SysOptionI("NameIndex"," CPRIVACTIVITY",""))
	
	if (sysOptionRowID '= "")
	{
		s isPrivActivity = $listget(^DHCEPRM.SysOptionD(sysOptionRowID),4)	
	}
	
	if ($zcvt(isPrivActivity,"U") = "Y")
	{ 
		s ssGroupRuleRowID = $o(^DHCEPRM.EPRDOC.EPRSSGroupI("IdxCatalogSSGroup"," "_AEPRCategoryID," "_ASSGroupID,0))
		s ret = $s(ssGroupRuleRowID = "" : 0, 1 : 1)
	}
	
	q ret
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-06-13
/// Description:判断是否显示Chapter级别,以及是否默认选中
/// Table:		EPRmeta.EPRTemplateCategory
/// Input:		AChapterID为EPRTemplateCategory表中类型为ChapterCategory记录的RowID;
/// 			APrintTemplateDocID为打印模板Doc ID,为EPRTemplateCategory表中类型为PrtTemplate记录的RowID;
/// Output:		无
/// Return:		是否显示(1:显示;0:不显示)^是否选中(true:选中;false:不选中)
/// Others:		无
/// Debug:		w ##Class(web.eprajax.reference.refeprtree).IsShowChapter("20","21")
ClassMethod IsShowChapter(AChapterID As %String, APrintTemplateDocID As %String) As %Integer
{
	s isShow = 1
	s checked = "false"
	s curCategoryID = ""
	s blankChapterID = " "_AChapterID
	
	for {
		s curCategoryID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", blankChapterID, curCategoryID))
		q:(curCategoryID = "")
		
		s objCategory = $g(^DHCEPRM.EPRTemplateCategoryD(curCategoryID))
		s categoryType = $list(objCategory,10)
		continue:(categoryType '= "PrtTemplate")
		
		s:(curCategoryID = $g(APrintTemplateDocID)) checked = "true" 
		s bindPrtTemplateID = $list(objCategory,16)
		s objPrtTemplate = $g(^DHCEPRM.PrintTemplateD(bindPrtTemplateID))
		s chartItemType = $list(objPrtTemplate,9)
		if (chartItemType = "Multiple")
		{
			s isShow = 0
			q	
		} 	
	}
	
	q isShow_"#"_checked
}

/// Creator:	Kumon Xie
/// CreatDate:	2011-06-13
/// Description:判断是否显示Category级别,以及是否默认选中
/// Table:		EPRmeta.EPRTemplateCategory
/// Input:		AParCategoryID为父节点ID, 来自EPRTemplateCategory表的RowID;
/// 			APrintTemplateDocID为打印模板Doc ID,为EPRTemplateCategory表中类型为PrtTemplate记录的RowID;
/// Output:		无
/// Return:		是否显示(1:显示;0:不显示)^是否选中(true:选中;false:不选中)
/// Others:		无
/// Debug:		w ##Class(web.eprajax.reference.refeprtree).IsShowCategory("4","21")
ClassMethod IsShowCategory(AParCategoryID As %String, APrintTemplateDocID As %String) As %String
{
	s checked = "false"
	s curCategoryID = ""
	s (isShow,chapterCount,showCount) = 0
	s blankParCategoryID = " "_AParCategoryID
	
	for {
		s curCategoryID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", blankParCategoryID, curCategoryID))
		q:(curCategoryID = "")
		
		s objCategory = $g(^DHCEPRM.EPRTemplateCategoryD(curCategoryID))
		s categoryType = $list(objCategory,10)
		continue:(categoryType '= "CategoryChapter")
		
		s isShowChapter = ..IsShowChapter(curCategoryID,APrintTemplateDocID)
		if ($p(isShowChapter,"#",1) = 1)
		{
			s chapterCount = chapterCount + 1
			s showCount = $s($p(isShowChapter,"#",2) = "true" : showCount+1, 1:showCount)	
		}
	}
	
	s:(chapterCount > 0) isShow = 1
	s:(showCount > 0) checked = "true"
	
	q isShow_"#"_checked
}

}
