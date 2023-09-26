/// 门诊知识库接口
Class EMRservice.Ajax.opKBTree Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"
	
	s action=$g(%request.Data("action",1),"")

 	if ("GetBindKBNode"=action)
 	{
    	s episodeID =  $Get(%request.Data("EpisodeID",1),"")
    	s nodeBaseID = $Get(%request.Data("nodeBaseID",1),"")
    	s diseaseID = $Get(%request.Data("diseaseID",1),"")
    	s userLocID = $Get(%request.Data("UserLocID",1),"")
    	s titleCode = $Get(%request.Data("titleCode",1),"")	
		s userId = $Get(%request.Data("UserID",1),"")
	 	s ret=..GetBindKBNode(nodeBaseID,userLocID,diseaseID,episodeID,userId,titleCode)
	 	w ret
	}
	else
	{
		w ""
	}
 	
	Quit $$$OK
ErrorHandler
   w "{""Err"":"""_errInfo_"_"_$zerror_"""}"
   Quit $$$OK
}

/// 获取科室以及个人知识库，指定门诊部分
ClassMethod GetBindKBNode(nodeBaseID, userLocID, diseaseID, episodeID, userId, titleCode As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLKBNode).GetBindKBNode(nodeBaseID,userLocID,diseaseID,episodeID,userId,titleCode)    
	s:(result '= "") result = "["_$tr(result,"'","""")_"]"
   	q result
}

}
