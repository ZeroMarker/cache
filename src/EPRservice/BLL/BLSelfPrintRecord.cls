Class EPRservice.BLL.BLSelfPrintRecord Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod AddPrintRecord(AEpisodeID, APrintReason, APrintItems, APrintUserID) As %String
{
	s obj = ##Class(EPRinstance.SelfPrintRecord).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.PrintReason = APrintReason
	s obj.PrintItems = APrintItems
	s obj.PrintUserID = APrintUserID
	s obj.PrintDate = $p($h,",",1)
	s obj.PrintTime = $p($h,",",2)
	s sc = obj.%Save()
	if $$$ISOK(sc)
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Debug:	w ##Class(EPRservice.BLL.BLSelfPrintRecord).IsPrintRecordExisted("15","")
ClassMethod IsPrintRecordExisted(AEpisodeID, APrintReason) As %String
{
	s id = $O(^DHCEPRI.SelfPrintRecordI("IdxOnPrintReason"," "_AEpisodeID, " "_$zcvt(APrintReason,"u"),""))
	if (id="")
	{
		q "0"
	}
	else
	{
		q "1"
	}
}

/// w ##Class(EPRservice.BLL.BLSelfPrintRecord).GetPrintCount("15","OutPatientSelfPrint")
ClassMethod GetPrintCount(AEpisodeID, APrintReason) As %String
{
	s id = "",count = 0
	for {
		s id = $O(^DHCEPRI.SelfPrintRecordI("IdxOnPrintReason"," "_AEpisodeID, " "_$zcvt(APrintReason,"u"),id))
		q:(id="")
		
		s count = count + 1
	}
	
	q count
}

/// Debug:	w ##Class(EPRservice.BLL.BLSelfPrintRecord).IsDocPrinted("15","OutPatientSelfPrint","29")
ClassMethod IsDocPrinted(AEpisodeID, APrintReason, APrintTemplateDocID) As %String
{
	s isPrinted = "0"
	
	s id = ""
	for {
		s id = $O(^DHCEPRI.SelfPrintRecordI("IdxOnPrintReason"," "_AEpisodeID, " "_$zcvt(APrintReason,"u"),id))
		q:(id="")
		
		s obj = ##Class(EPRinstance.SelfPrintRecord).%OpenId(id)
		continue:(obj="")
		
		continue:($f("^"_obj.PrintItems_"^","^"_APrintTemplateDocID_"^")=0)
		
		s isPrinted = "1"
		quit	
	}
	
	q isPrinted
}

}
