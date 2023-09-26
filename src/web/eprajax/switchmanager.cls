/// 名称: 切换模板后的操作
/// 描述: 切换模板后将删除原有的Instance数据，同时修改日志
/// 编写者：chenwenjun
/// 编写日期: 09/08/10
Class web.eprajax.switchmanager Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	set userID = %session.Get("LOGON.USERID")
	if (userID = "")
	{
		w "sessionTimedOut"
		Quit $$$OK
	}
	s oldPrtDocID = $Get(%request.Data("DocID",1),"-1")			//原打印模板DocID
	s newPrtDocID = $Get(%request.Data("newDocID",1),"-1")		//新打印模板DocID
	s episodeID  = $Get(%request.Data("EpisodeID",1),"-1")
	q:(oldPrtDocID = -1) $$$OK
	q:(episodeID = -1) $$$OK
	
	//如果是可重复模板，那么切换模板时不删除Instance,也不修改Log
	s chartItemType = ##class(EPRservice.EPRDoc.DocCategoryFunSet).GetPrtDocType(oldPrtDocID)
	if (chartItemType = "Multiple") 
	{
		w "success"
		q $$$OK	
	}
	
	//清空打印记录
	d ..ClearSinglePrintRecord(episodeID, oldPrtDocID)
	
	//清空数据
	d ..ClearData(episodeID, oldPrtDocID)
	
	//更新日志
	s status = ..UpdateEPRLogs(episodeID, oldPrtDocID, newPrtDocID, userID)
	w status
	
	Quit $$$OK
}

/// 	Desc: 	清空打印记录
ClassMethod ClearSinglePrintRecord(AEpisodeID As %String, APrintDocID As %String) As %Boolean
{
	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintDocID)
	q:(objEPRTemplateCategory = "") "0"								//对象不存在，应该是基础数据异常
	
	s printTemplateID = objEPRTemplateCategory.BindPrnTemplateID
	q:(printTemplateID = "")||(printTemplateID = $C(0)) "1"			//没有绑定打印模板，则没有打印记录
	
	q ##Class(EPRservice.BOPrintRecord).ClearSingleInstancePrintRecord(AEpisodeID, printTemplateID)
}

/// 	Desc:	清空数据
ClassMethod ClearData(episodeID As %String, oldPrtDocID As %String)
{
	//遍历该打印模板下所有界面模板，删除其对应的Instance
	s curoldPrtDocID = " "_oldPrtDocID
	s curDocId = 0
	//s curDocId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", curoldPrtDocID, curDocId))
	s curDocId = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID", curoldPrtDocID, curDocId))
	WHILE (curDocId '= "") 
	{
		s curObjDoc = ##class(EPRmeta.EPRTemplate).%OpenId(curDocId)
		if (curObjDoc '= "")
		{
			s curBindTemplate = curObjDoc.BindTemplateID
			d curObjDoc.%Close()
			s curObjDoc = ""
			
			s curTemplateCount = 0
			&SQL(select count(*) into :curTemplateCount from EPRmeta.EPRTemplate where BindTemplateID=:curBindTemplate)
			if ((+curTemplateCount) < 2)
			{
				//只有在一个界面模板只挂靠在一个打印模板之下的情况下才删除其Instance数据
				s chartItemID = "CG"_curBindTemplate
				if ($d(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_episodeID," "_chartItemID)) '= 0)
				{	
					s ecrecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_episodeID," "_chartItemID, ""))
					if (ecrecordID '= "")
					{
						s deleteStatus = ##class(EPRinstance.ECRecord).%DeleteId(ecrecordID)
						if $$$ISOK(deleteStatus)
						{ 	do ##class(EPRservice.BOInstanceData).ClearScatterDataByInstanceID(ecrecordID_"||1")}
					}
				}
			}
		}
		
		//s curDocId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", curoldPrtDocID, curDocId))
		s curDocId = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID", curoldPrtDocID, curDocId))
	}
}

/// 	Desc:	更新日志
ClassMethod UpdateEPRLogs(episodeID As %String, oldPrtDocID As %String, newPrtDocID As %String, userID As %String) As %String
{
	//修改日志
	&SQL(update EPRinstance.EPRLogs set EPRDocID = :newPrtDocID where EpisodeID = :episodeID and EPRDocID = :oldPrtDocID)
	
	s status = ##class(web.eprajax.logs.switch).SwithcLog(episodeID, newPrtDocID, "1", userID)
	q status
}

}
