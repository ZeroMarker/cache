/// FTP操作FTP服务器文件供外部调用
/// Creater:    xuchao
/// CreateDate: 2014-03-12
/// Table:
/// Input:Param=GroupId_"^"_LocId_"^"_UserId
/// Output:     
/// Return：
Class web.DHCSTMHUI.Common.FtpFile Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTFTPFILEM";

ClassMethod GetFtpConfig(Param As %String) As %String
{
	n (Param)
	s LocId=$P(Param,"^",2)
	s HospId=""
	s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Param=Param_"^"_HospId
	s AppName=##class(web.DHCSTMHUI.Common.FtpFile).%GetParameter("AppName")
	s ftpip=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"FtpIp",Param)
	s ftpuser=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"FtpUser",Param)
	s ftppass=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"FtpPassword",Param)
	s ftpsrc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"FtpPicSrc",Param)
	s ftphttpsrc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"FtpHttpSrc",Param)
	s ftpport=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"FtpPort",Param)
	s ftpssl=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"FtpSSL",Param)
	s:ftpport="" ftpport=21
	s:ftpssl'="FTPS" ftpssl=""
	s ftpconf=ftpip_"^"_ftpuser_"^"_ftppass_"^"_ftpsrc_"^"_ftpport_"^"_ftphttpsrc_"^"_ftpssl
	q ftpconf
}

ClassMethod UpFile(File As %CSP.BinaryStream, Param As %String, FileName As %String) As %String
{
	n (File,Param,FileName)
	s ftpconfig=..GetFtpConfig(Param)
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

ClassMethod DeleFile(FileName As %String, Param As %String) As %String
{
	n (FileName,Param)
	s ftpconfig=..GetFtpConfig(Param)
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

/// w ##class(web.DHCSTMHUI.Common.FtpFile).CreateFileName("Ven")
ClassMethod CreateFileName(Prefix As %String = "") As %String
{
	n (Prefix,%session)
	s AppName=..%GetParameter("AppName")
	s ret=##class(web.DHCSTMHUI.Common.AppCommon).Lock("FTPFILE")
	i ret'=0 d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("FTPFILE")
	q:ret'=0 ""
	s Param=..sssParamStr()
	s gHospId=$p(Param,"^",4)
	s FileName=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"","",gHospId)
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock("FTPFILE")
	q:FileName="" ""
	s FileName=Prefix_FileName_".jpg"
	q FileName
}

}
