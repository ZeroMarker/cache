/// FTP操作FTP服务器文件供外部调用
/// Creater:    wfg
/// CreateDate: 2019-8-1
/// Table:
Class web.CSSDHUI.Common.FtpFile Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "CSSDFTPFILEM";

/// w ##class(web.CSSDHUI.Common.FtpFile).GetFtpConfig("2")
ClassMethod GetFtpConfig(Params As %String) As %String
{
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 ""
	s gHospId = PJObj.%Get("HospId")
	s gLocId = PJObj.%Get("LocId")
	s gUserId=PJObj.%Get("UserId")
	s gGroupId=PJObj.%Get("GroupId")
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_gHospId
	s AppName=##class(web.CSSDHUI.Common.FtpFile).%GetParameter("AppName")
	s ftpip=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpIp",Param)
	s ftpuser=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpUser",Param)
	s ftppass=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpPassword",Param)
	s ftppass=##class(web.CSSDHUI.Common.UtilCommon).DecryptPW(ftppass)
	s ftpsrc=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpPicSrc",Param)
	s ftphttpsrc=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpHttpSrc",Param)
	s ftpport=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpPort",Param)
	s ftpssl=##class(web.CSSDHUI.Common.AppCommon).GetParamValue(AppName,"FtpSSL",Param)
	s:ftpport="" ftpport=21
	s:ftpssl'="FTPS" ftpssl=""
	s ftpconf=ftpip_"^"_ftpuser_"^"_ftppass_"^"_ftpsrc_"^"_ftpport_"^"_ftphttpsrc_"^"_ftpssl
	q ftpconf
}

ClassMethod UpFile(File As %CSP.BinaryStream, FileName As %String, Params As %String) As %String
{
	n (File,FileName,Params)
	s ftpconfig=..GetFtpConfig(Params)
	s ftpip=$p(ftpconfig,"^",1)
	s ftpuser=$p(ftpconfig,"^",2)
	s ftppass=$p(ftpconfig,"^",3)
	s ftpsrc=$p(ftpconfig,"^",4)
	s ftpport=$p(ftpconfig,"^",5)
	s ftpssl=$p(ftpconfig,"^",7)
	s ftp=##class(%Net.FtpSession).%New()
	s ftp.SSLConfiguration=ftpssl
	i 'ftp.Connect(ftpip,ftpuser,ftppass,ftpport) q -1
	i 'ftp.Binary() q -1
	s FileName=ftpsrc_FileName
	i 'ftp.Store(FileName,File) q -3
	i 'ftp.Logout() q -4
	q 0
}

ClassMethod DeleFile(FileName As %String, Params As %String) As %String
{
	n (FileName,Params)
	s ftpconfig=..GetFtpConfig(Params)
	s ftpip=$p(ftpconfig,"^",1)
	s ftpuser=$p(ftpconfig,"^",2)
	s ftppass=$p(ftpconfig,"^",3)
	s ftpsrc=$p(ftpconfig,"^",4)
	s ftpport=$p(ftpconfig,"^",5)
	s ftpssl=$p(ftpconfig,"^",7)
	s ftp=##class(%Net.FtpSession).%New()
	s ftp.SSLConfiguration=ftpssl
	i 'ftp.Connect(ftpip,ftpuser,ftppass,ftpport) q -1
	s FileName=ftpsrc_FileName
	s ExistFlag=$$IsFtpFileExist()
	i ExistFlag=0 d ftp.Logout() q 0		;不存在图片的,不再进行ftp删除
	i 'ftp.Delete(FileName) q -3
	i 'ftp.Logout() q -4
	q 0
IsFtpFileExist()
	;确认目录下是否存在该文件: 1存在,0不存在
	New fileArray,key,isExists
	If 'ftp.NameList(ftpsrc,.fileArray) q 1
	Set key="",isExists=0
	s count=0
	For  s tmpFileName=fileArray.GetNext(.key) Quit:(key="")||(isExists=1)  d
	.i (FileName=tmpFileName) s isExists=1
	q isExists
}

}
