/// 手写签名服务类
Class EPRservice.BOHandWrittenSign Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOHandWrittenSign";

/// d ##Class(EPRservice.BOHandWrittenSign).SaveHandWrittenSign("201869","523","3","127||3","@@")
ClassMethod SaveHandWrittenSign(EpisodeID, PrintDocID, EPRNum, instanceDataID, FilePath As %String) [ WebMethod ]
{
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceDataID)
	if (objInstance = "") { s title = "" }
	else { s title = objInstance.Title }
	d ##Class(EPRservice.BLHandWrittenSign).SaveHandWrittenSign(EpisodeID, PrintDocID, EPRNum, title, FilePath)
}

ClassMethod GetFilePath(EpisodeID, PrintDocID, EPRNum As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLHandWrittenSign).GetFilePath(EpisodeID, PrintDocID, EPRNum)
}

/// ##Class(EPRservice.BLHandWrittenSign).GetHandWrittenPrtDocIDs()
ClassMethod GetHandWrittenPrtDocIDs() As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLHandWrittenSign).GetHandWrittenPrtDocIDs()
}

ClassMethod SetHandWrittenPrtDocIDs(PrintDocIDs As %String) [ WebMethod ]
{
	d ##Class(EPRservice.BLHandWrittenSign).SetHandWrittenPrtDocIDs(PrintDocIDs)
}

//取最后一条有效相关的记录，有则返回ID，无则返回空

ClassMethod GetLastValidSign(EpisodeID, PrintDocID, EPRNum As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLHandWrittenSign).GetLastValidSign(EpisodeID, PrintDocID, EPRNum)
}

ClassMethod SetSignUnvalid(EpisodeID, PrintDocID, EPRNum As %String) [ WebMethod ]
{
	d ##Class(EPRservice.BLHandWrittenSign).SetSignUnvalid(EpisodeID, PrintDocID, EPRNum)
}

}
