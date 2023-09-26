Class EPRservice.BOPreviewService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "PreviewServiceInfo";

/// Desc:	根据传入的PrintDocID和EPRNum列表，得到与其对应的一些参数，用以病历预览图片生成
/// Debug:	w ##Class(EPRservice.BOPreviewService).GetMultiPreviewParams("201764","24^1#24^2")
ClassMethod GetMultiPreviewParams(AEpisodeID As %String, AEPRPrintDocIDAndEPRNumList As %String) As %String [ WebMethod ]
{
	q:(AEpisodeID="")||(AEPRPrintDocIDAndEPRNumList = "") ""
	
	s ret = ""
	s count = $L(AEPRPrintDocIDAndEPRNumList, "#")
	for i=1:1:count
	{
		//b "s"
		s eprPrintDocIDAndEPRNum = $P(AEPRPrintDocIDAndEPRNumList, "#", i)
		s eprPrintDocID = $p(eprPrintDocIDAndEPRNum, "^", 1)
		s eprNum = $p(eprPrintDocIDAndEPRNum, "^", 2)
		
		s eprLogsID = ##Class(EPRservice.BOEPRLogs).GetEPRLogsID(AEpisodeID, eprPrintDocID, eprNum)
		s instanceID =  ##Class(EPRservice.BLL.BLECRecord).GetInstanceID(AEpisodeID,"ML"_eprPrintDocID,eprNum)
		s bindPrintTplID = ##class(EPRservice.BOEPRTemplateCategory).GetBindPrtTemplateID(eprPrintDocID)
		s printType = ##class(EPRservice.BOPrintTemplate).GetPrintType(bindPrintTplID)
		continue:(bindPrintTplID = "")||(bindPrintTplID = $c(0))
		
		if (ret = "")
		{	s ret = eprPrintDocID_"^"_bindPrintTplID_"^"_printType_"^"_eprLogsID_"^"_instanceID}
		else
		{	s ret =  ret_"#"_eprPrintDocID_"^"_bindPrintTplID_"^"_printType_"^"_eprLogsID_"^"_instanceID}
	}
	
	q ret
}

}
