Class web.PMP.FileDownload Extends %Persistent
{

/// Creat  zzp  
/// date:2015-05-02
/// description: 获取附件配置
/// input:  
/// output: String (ftp地址ip#ftp登录密码#ftp登录帐号#ftp文件路径)
/// others: w ##class(web.PMP.FileDownload).FtpConfig()
ClassMethod FtpConfig() As %String
{
	s ret=""
	s rowid=$o(^PMPSysConfigure("Type","AdjunctIP",""))
	i rowid'="" s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	q ret
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 获取允许上传的最大存储量 空默认20M
/// input:  
/// output: String 
/// others: w ##class(web.PMP.FileDownload).FileSize()
ClassMethod FileSize() As %String
{
	s ret=""
	s rowid=$o(^PMPSysConfigure("Type","FileSize",""))
	i rowid'="" s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	i ret="" s ret="20"
	q ret
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 转换文件名，文件存到ftp服务器上名称
/// input: FileName：原文件名
/// output: ret 新的文件名称
/// others: w ##class(web.PMP.FileDownload).NewFileName("","")
ClassMethod NewFileName(FileName As %String, SerialNumber As %String) As %String
{
	s ret=""
	s UserId=%session.Data("LOGON.USERID")
	q:(FileName="")||(SerialNumber="") ret
	s FileType=$p(FileName,".",$L(FileName,"."))
	s ret=+$h_$p($h,",",2)_UserId_SerialNumber_"."_FileType
	q ret
}

/// Creat  zzp  
/// date:2015-05-02
/// description: 获取配置中随机值位数
/// input:
/// output: 随机值个数
/// others: w ##class(web.PMP.FileDownload).Randomness()
ClassMethod Randomness(FileName As %String, SerialNumber As %String) As %String
{
	s ret=""
	s rowid=$o(^PMPSysConfigure("Type","Randomness",""))
	i rowid'="" s ret=$p(^PMPSysConfigure(0,rowid),"^",2)
	i ret="" s ret="6"
	q ret
}

Storage Default
{
<Data name="FileDownloadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.FileDownloadD</DataLocation>
<DefaultData>FileDownloadDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.PMP.FileDownloadD</IdLocation>
<IndexLocation>^web.PMP.FileDownloadI</IndexLocation>
<StreamLocation>^web.PMP.FileDownloadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
