/// Desc:      病历引用
/// Creator:   Candy
/// CreateDate:2015-1-14
Class EMRservice.Ajax.quotation Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	if (action = "GetRecordList")
	{
		s episodeId = $Get(%request.Data("EpisodeID",1),"")
		s ctLocId = $Get(%request.Data("CTLocID",1),"")	
		s docId = $Get(%request.Data("DocID",1),"")
		s result = ##Class(EMRservice.BL.BLQuotation).GetRecordList(episodeId,ctLocId,docId)
		
		w "["_result_"]"		
	}
	Quit $$$OK
}

}
