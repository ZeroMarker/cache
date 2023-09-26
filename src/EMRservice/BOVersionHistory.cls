Class EMRservice.BOVersionHistory Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "VersionHistoryInfo";

ClassMethod AddVersionHistory(VersionHistoryInfos As %String) As %String [ WebMethod ]
{
	
	Set result=##class(EMRservice.BL.BLVersionHistory).AddVersionHistoryInfos(VersionHistoryInfos)	
	Quit result
}

ClassMethod SelectAllVersionHistory(TemplateDR As %String) As EMRservice.dataset.EVersionHistoryDataset [ WebMethod ]
{
    Set result=##class(EMRservice.dataset.EVersionHistoryDataset).%New()
    do result.SetArgs(TemplateDR)
	Quit result
}

ClassMethod TestDom() As %GlobalBinaryStream [ WebMethod ]
{
	s filename = "d:\1.xml"

    Set reader = ##class(%XML.Reader).%New()
    d reader.OpenFile(filename)
    s xmlDoc = reader.Document
    //w xmlDoc.GetDocumentElement(),!
    //s xmlNode = xmlDoc.GetDocumentNode()
    s xmlNode = xmlDoc.GetNode("MetaData")
    //w "xmlNode:"_xmlNode,!
    //w "xmlNode:"_xmlNode.NodeId,!
    //s metaDataDoc = xmlNode.Document
    //w "metaDataDoc:"_metaDataDoc,!
 
	s writer=##class(%XML.Writer).%New()
    s writer.Charset="UTF-8"
    s streamRecord = ##Class(%GlobalBinaryStream).%New()
    s status = writer.OutputToStream(streamRecord)
    s ret = writer.DocumentNode(xmlNode)
	q streamRecord
}

}
