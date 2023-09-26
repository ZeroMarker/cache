Class DHCEPRFS.Prison.BL.HISInfo.BLHCInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: w ##class(DHCEPRFS.Prison.BL.HISInfo.BLHCInfo).HasHCPDFPath(406,"I")
ClassMethod HasHCPDFPath(AEpisodeID As %String, ATypeParam As %String) As %String
{
	q:(AEpisodeID ="") ""
	s pdfPath =""
	s pdfPath = ##class(web.DHCPE.ReportExportPDF).GetInfoNew(AEpisodeID)
	q:(pdfPath = "") ""
	s typeParam = $p(pdfPath,"^",1)
	if (typeParam = ATypeParam)
	{
		q "1"
	}
	else
	{
		q ""
	}
}

/// debug w ##class(DHCEPRFS.Prison.BL.HISInfo.BLHCInfo).GetHCPDFPath(406)
/// OutPut: I^/REPeport/Report1/5/406.pdf
ClassMethod GetHCPDFPath(AEpisodeID As %String) As %String
{
	q:(AEpisodeID ="") ""
	s pdfPath =""
	s pdfPath = ##class(web.DHCPE.ReportExportPDF).GetInfoNew(AEpisodeID)
	q:(pdfPath = "") ""
	q pdfPath
}

}
