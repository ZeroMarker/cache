Class DHCEPRFS.Srv.SrvImportHisPDF Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvImportHisPDF";

ClassMethod CheckInfo(AMedRecordNo As %String, APatientName As %String, ASex As %String, AAdmDate As %String, AAdmLocDesc As %String, ADisDate As %String, ADisLocDesc As %String, AItemDescs As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLImportHisPDF).CheckInfo(AMedRecordNo,APatientName,ASex,AAdmDate,AAdmLocDesc,ADisDate,ADisLocDesc,AItemDescs)
}

ClassMethod ImportEpisode(AUserID As %String, AMedRecordNo As %String, AAdmDate As %String, AAdmLocDesc As %String, ADisDate As %String, ADisLocDesc As %String, ADirName As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLImportHisPDF).ImportEpisode(AUserID,AMedRecordNo,AAdmDate,AAdmLocDesc,ADisDate,ADisLocDesc,ADirName)
}

ClassMethod InsertImportLog(AUserID As %String, AMedRecordNo As %String, AMREpisodeID As %String, APatientName As %String, ADirName As %String, AInfoType As %String, AInfo As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLImportHisPDF).InsertImportLog(AUserID,AMedRecordNo,AMREpisodeID,APatientName,ADirName,AInfoType,AInfo)
}

ClassMethod GetFilePathByMREpisode(AMREpisodeID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLImportHisPDF).GetFilePathByMREpisode(AMREpisodeID)
}

}
