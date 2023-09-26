Class DHCEPRFS.Srv.SrvScanFile Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvScanFile";

/// Desc:	
ClassMethod AddOneScanFile(AType As %String, AEpisodeID As %String, AFileName As %String, AFileMasterID As %String, AUserID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLScanFile).AddOneScanFile(AType,AEpisodeID,AFileName,AFileMasterID,AUserID)
}

ClassMethod AddOneScanFileOP(AType As %String, AEpisodeID As %String, AFileName As %String, AFileMasterID As %String, AUserID As %String, AMRItemID As %String, AMRItemName As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLScanFile).AddOneScanFileOP(AType, AEpisodeID, AFileName, AFileMasterID, AUserID, AMRItemID, AMRItemName)
}

ClassMethod GetScanList(AUserID As %String, AActDate As %String) As %XML.DataSet [ WebMethod ]
{
	s obj= ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLScanFile:GetScanList")
	s ActDate=$zdh(AActDate,3)
	d obj.SetArgs(AUserID,ActDate)
	q obj
}

ClassMethod GetTopUnCategoryItem() As %XML.DataSet [ WebMethod ]
{
	s obj= ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLScanFile:GetTopUnCategoryItem")
	d obj.SetArgs()
	q obj
}

ClassMethod SetScanFileArranged(AScanFileIDs As %String, AIP As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLScanFile).SetScanFileArranged(AScanFileIDs,AIP)
}

ClassMethod CheckAndAddOPRecord(AMedRecordNo As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLScanFile).CheckAndAddOPRecord(AMedRecordNo)
}

ClassMethod GetNameByMedrecordNo(AMedRecordNo As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLScanFile).GetNameByMedrecordNo(AMedRecordNo)
}

}
