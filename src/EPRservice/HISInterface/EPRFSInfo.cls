Class EPRservice.HISInterface.EPRFSInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##Class(EPRservice.HISInterface.EPRFSInfo).CanCommitPDF("1999808","1861")
ClassMethod CanCommitPDF(AEpisodeID As %String, AUserID As %String) As %Boolean
{
	s activePDFFS=##class(EPRmeta.SysOption).GetOptionValueByName("ActivePDFFS")
	if (activePDFFS = "Y")
	{
		s canCommitPDF = ##Class(DHCEPRFS.BI.BIAdmMRStatus).CanCommitPDF(AEpisodeID,AUserID)
 	}
 	else
 	{
		s canCommitPDF = 0
 	}
	q canCommitPDF
}

}
