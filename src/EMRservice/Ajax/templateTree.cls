Class EMRservice.Ajax.templateTree Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s $zt = "ErrorHandler"
	
	s action = $Get(%request.Data("ACTION",1),"")
	s parentId = $Get(%request.Data("ParentID",1),"")
	s episodeID  = $Get(%request.Data("EpisodeID",1),"")	
  	s ssgroupID = %session.Get("LOGON.GROUPID")
    if (action = "GetCategory")
    {
	    s result = ##Class(EMRservice.BL.BLCateTreeData).GetCategory(parentId,episodeID,ssgroupID)
	    w "["_result_"]"
	}
	elseif(action = "GetTempCate")
	{
		s result = ##Class(EMRservice.BL.BLCateTreeData).GetTempCate(parentId,episodeID)
		w "["_result_"]"
	}
	elseif(action = "GetInstance")
	{
		s result = ##Class(EMRservice.BL.BLCateTreeData).GetInstance(parentId,episodeID)
		w "["_result_"]"	
	}
	elseif(action = "GetSummery")
	{
		s result = ##Class(EMRservice.BL.BLCateTreeData).GetSummeryByCategory("0",episodeID)
		w "["_result_"]"
	}
	elseif(action = "IsExitInstance")
	{
		s docId  = $Get(%request.Data("emrDocId",1),"")
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
		if (objTemplate = "")
		{
			w "0"
			q
		}
		w ##class(EMRservice.BL.BLInstanceData).IsHasInstance(episodeID, objTemplate.ID,docId)
	}
	elseif(action = "GetRecordTree")
	{
		s instanceId  = $Get(%request.Data("InstanceID",1),"")
		s result = ##Class(EMRservice.BL.BLCateTreeData).GetRecordTree(parentId,episodeID,instanceId)
		w "[{'id':'root','text':'病历目录','state':'open','children':["_result_"]}]"
	}
	Quit $$$OK
	
ErrorHandler
   s errInfo=$ze
   w ""
   Quit $$$OK
}

}
