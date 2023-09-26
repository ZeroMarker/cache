Class DHCEPRFS.Srv.SrvTest Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvTest";

ClassMethod TestGetMediaFileList(AParam1 As %String, AParam2 As %String) As %String [ WebMethod ]
{
	//FTP服务器IP^端口^虚拟目录名称^用户名^密码#标签描述^类型^地址!标签描述^类型^地址
	s ret = "10.10.141.113^21^^anonymous^#声音病历^S^mhc/vo141/1947747/20180112161955.mp3!标签描述2^S^mhc/vo141/1947747/20180112154636.mp3"
	q ret
}

}
