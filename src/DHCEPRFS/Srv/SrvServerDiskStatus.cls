Class DHCEPRFS.Srv.SrvServerDiskStatus Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvServerDiskStatus";

ClassMethod AddServerDiskStatus(AServerDiskID As %String, ADiskSize As %String, ADiskFreeSpace As %String, ADiskUsed As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLServerDiskStatus).AddServerDiskStatus(AServerDiskID,ADiskSize,ADiskFreeSpace,ADiskUsed)
	q ret
}

ClassMethod GetMonitorDiskDrive(AIPAddress As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLServerDiskStatus).GetMonitorDiskDrive(AIPAddress)
	q ret
}

ClassMethod GetMonitorDiskList() As DHCEPRFS.DataSet.EServerDiskDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EServerDiskDS).%New()
	d dataset.SetArgs()
	q dataset
}

ClassMethod GetNewestDiskByID(ADiskID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLServerDiskStatus).GetNewestDiskByID(ADiskID)
	q ret
}

ClassMethod GetTrend(ADiskID As %String, AType As %String, ADay As %String) As DHCEPRFS.DataSet.EServerDiskTrendDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EServerDiskTrendDS).%New()
	d dataset.SetArgs(ADiskID,AType,ADay)
	q dataset
}

ClassMethod Estimation(ADiskID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLServerDiskStatus).Estimation(ADiskID)
	q ret
}

}
