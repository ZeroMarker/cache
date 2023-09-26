Class DHCEPRFS.ThirdParty.Srv.QYFYCommon Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "ThirdPartyCommon";

ClassMethod GetInput(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).GetInput(AEpisodeID)
	q ret
}

ClassMethod GetInputByTypeCode(AEpisodeID As %String, ATypeCode As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.ThirdParty.BL.QYFYCommon).GetInputByTypeCode(AEpisodeID,ATypeCode)
	q ret
}

/// 注册迟归病理报告
/// 入参 AOrdID - 医嘱ID前半部分
/// 返回值 1 - 成功， 0 - 失败
ClassMethod RegLatePISReport(AOrdID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegLatePISReport(AOrdID)
	q ret
}

/// 记录有问题的第三方生成
/// 入参：IP - 服务器地址、FTPPathSXML - 第三方FTP路径、TypeCode - 项目编码、EpisodeID - 就诊号、PatientID - 病人号
/// 返回值 1 - 成功， 0 - 失败
ClassMethod RegErr3rdCreate(AIP As %String, AFTPPathSXML As %String, ATypeCode As %String, AEpisodeID As %String, APatientID As %String, AFTPPath As %String = "", AErrorType As %String = "") As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.ThirdParty.BL.QYFYCommon).RegErr3rdCreate(AIP,AFTPPathSXML,ATypeCode,AEpisodeID,APatientID,AFTPPath,AErrorType)
	q ret
}

/// 查询有问题的第三方生成
/// 入参：IP - 服务器地址、FTPPathSXML - 第三方FTP路径、TypeCode - 项目编码、EpisodeID - 就诊号、PatientID - 病人号
/// 返回值 1 - 成功， 0 - 失败
ClassMethod GetErr3rdCreateLog(AStartDate As %String, AEndDate As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.ThirdParty.BL.QYFYCommon:GetErr3rdCreateLog")
	d obj.SetArgs(AStartDate,AEndDate)
	q obj
}

ClassMethod GetErrFTPPathSXML() As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.ThirdParty.BL.QYFYCommon).GetErrFTPPathSXML()
	q ret
}

}
