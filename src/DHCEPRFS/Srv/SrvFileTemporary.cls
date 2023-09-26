Class DHCEPRFS.Srv.SrvFileTemporary Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvFileTemporary";

ClassMethod RegisterOneTempFile(AMREpisodeID As %String, AUserID As %String, AFileInfo As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLFileTemporary).RegisterOneTempFile(AMREpisodeID,AUserID,AFileInfo)
}

ClassMethod RegisterTempFiles(AMREpisodeID As %String, AUserID As %String, AFileInfo As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLFileTemporary).RegisterTempFiles(AMREpisodeID,AUserID,AFileInfo)
}

ClassMethod RegisterTempFilesByList(AMREpisodeID As %String, AUserID As %String, AFileInfo As DHCEPRFS.ExtDS.CustomList) As %ListOfDataTypes [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLFileTemporary).RegisterTempFilesByList(AMREpisodeID,AUserID,AFileInfo)
}

ClassMethod GetTempFiles(AMREpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLFileTemporary:GetTempFiles")
	d obj.SetArgs(AMREpisodeID)
	q obj
}

ClassMethod SetTempFileDelete(AMREpisodeID As %String, AFileName As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLFileTemporary).SetTempFileDelete(AMREpisodeID,AFileName)
}

ClassMethod DeleteTempFilesByList(AFileInfo As DHCEPRFS.ExtDS.CustomList) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLFileTemporary).DeleteTempFilesByList(AFileInfo)
}

/// Creator:	yangpeng
/// Date:		2021-8-12
/// Input:		AFileInfo 临时文件名集合 单文件格式:/TemporaryFile/TSF_1_93a0e7a065385787_202108110057438179_1.pdf
/// Output:		ftp存储路径和ftp参数
/// Desc:		根据文件名返回临时文件的存储路径和ftp参数 是否保存(Y/N)#IP|VirtualDir|FtpPath#FTPConfig
/// Debug:		w ##class(DHCEPRFS.Srv.SrvFileTemporary).GetTempFilePathByList()
ClassMethod GetTempFilePathByList(AFileInfo As DHCEPRFS.ExtDS.CustomList) As DHCEPRFS.ExtDS.CustomList [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLFileTemporary).GetTempFilePathByList(AFileInfo)
}

}
