/// 上传图片
Class web.DHCADVFormUploadPic Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter ftpip [ Final ] = "114.251.235.32";

Parameter ftpuser [ Final ] = "administrator";

Parameter ftppass [ Final ] = "dhcc123.com";

Parameter ftpport [ Final ] = 22;

/// Descript:   上传图片到ftp
/// Creater:    zhouxin
/// CreateDate: 2017-12-6
/// Table:
/// Input:File图片流
/// Output:     
/// Return：地址
ClassMethod SavePic(File As %CSP.BinaryStream) As %Library.String
{

    s ret=0
 	s date=$zd($h,3)
 	s seq=$i(^DHCADVFORMPIC(+$h))
    s FileName=date_$tr($j(seq,5)," ",0)_".png"
    s ret=..UpFile(File,FileName)
    w ret_"^"_FileName_"^"_##class(web.DHCADVFormUploadPic).GetFtpIp()
    q ret
}

/// 存储图片到ftp
ClassMethod UpFile(File As %CSP.BinaryStream, FileName As %String) As %String
{
    
    s ftp=##class(%Net.FtpSession).%New()
    i 'ftp.Connect(..GetFtpIp(),..GetUser(),..GetFtpPass(),..GetFtpPort()) q -1
    i 'ftp.Binary() q -1
    i 'ftp.Store(FileName,File) q -3
    i 'ftp.Logout() q -4
    q 0
}

/// 存储图片到ftp
/// w ##class(web.DHCADVFormUploadPic).DownloadFile("2017-12-0600032.jpg")
ClassMethod DownloadFile(FileName As %String) As %String
{
    
    s ftp=##class(%Net.FtpSession).%New()
    i 'ftp.Connect(..GetFtpIp(),..GetUser(),..GetFtpPass(),..GetFtpPort()) q -1
    i 'ftp.Binary() q -2
   	Set stream=##class(%GlobalCharacterStream).%New()
	q:'ftp.Retrieve(FileName,stream) -3
	d stream.Rewind()
	while('stream.AtEnd){
		s line=stream.ReadLine()
		w line,!
	}
	d stream.Clear()
	s stream=""
    i 'ftp.Logout() q -4
    q 0
}

/// 获取ftp ip
ClassMethod GetFtpIp()
{
 q ..%GetParameter("ftpip")
}

/// 获取ftp 用户名
ClassMethod GetUser()
{
 q ..%GetParameter("ftpuser")
}

/// 获取ftp 密码
ClassMethod GetFtpPass()
{
 q ..%GetParameter("ftppass")
}

/// 获取ftp 端口
ClassMethod GetFtpPort()
{
 q ..%GetParameter("ftpport")
}

}
