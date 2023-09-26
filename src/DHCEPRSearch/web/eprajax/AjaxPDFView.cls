Class DHCEPRSearch.web.eprajax.AjaxPDFView Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s mrEpisodeID = $Get(%request.Data("MREpisodeID",1),"")
	s roleID = $Get(%request.Data("RoleID",1),"")
	s MRVerItemsIDs = $Get(%request.Data("MRVerItemsIDs",1),"")
	
	if (action = "pdfpath")
	{
		d ..GetPDFPathByEpisodeID(mrEpisodeID,MRVerItemsIDs)
	}

	Quit $$$OK
}

ClassMethod GetPDFPathByEpisodeID(AMREpisodeID As %String, MRVerItemsIDs As %String) As %String
{
	s ret = ##class(DHCEPRSearch.BL.BLPDFView).GetPDFPathByEpisodeID(AMREpisodeID,MRVerItemsIDs)
	w ret
}

}
