Class EPRservice.BOPDFSign Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOPDFSign";

/// d ##Class(EPRservice.BOHandWrittenSign).SaveHandWrittenSign("201869","523","3","127||3","@@")
ClassMethod SaveHandWrittenSign(EpisodeID, PrintDocID, EPRNum, instanceDataID, FilePath As %String) [ WebMethod ]
{
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceDataID)
	if (objInstance = "") { s title = "" }
	else { s title = objInstance.Title }
	d ##Class(EPRservice.BLPDFSign).SaveHandWrittenSign(EpisodeID, PrintDocID, EPRNum, title, FilePath)
}

ClassMethod GetFilePath(EpisodeID, PrintDocID, EPRNum As %String) As %String [ WebMethod ]
{
	//q "/HandWrittenSigned/vol20/201869/201869-523-4-20140417120800.pdf"
	q ##Class(EPRservice.BLPDFSign).GetFilePath(EpisodeID, PrintDocID, EPRNum)
}

/// 取最后一条有效相关的记录，有则返回ID，无则返回空
ClassMethod GetLastValidSign(EpisodeID, PrintDocID, EPRNum As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLPDFSign).GetLastValidSign(EpisodeID, PrintDocID, EPRNum)
}

ClassMethod SetSignUnvalid(EpisodeID, PrintDocID, EPRNum As %String) [ WebMethod ]
{
	d ##Class(EPRservice.BLPDFSign).SetSignUnvalid(EpisodeID, PrintDocID, EPRNum)
}

ClassMethod IsNeedSign(PrintDocID As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLPDFSign).IsNeedSign(PrintDocID)
}

}
