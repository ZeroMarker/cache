Class EMRservice.Ajax.listdisplay Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s parentId = $Get(%request.Data("ParentID",1),"")
	s action = $Get(%request.Data("Action",1),"")
	//某病历展现结构下实例
	if (action = "GetInstanceJson")
	{
		s result = ##class(EMRservice.BL.listdata).GetListData(parentId,episodeId)
		w "["_result_"]"	
	} 
	Quit $$$OK
}

}
