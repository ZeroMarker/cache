/// 体检FTP管理
Class web.DHCPE.FTPManager Extends (%RegisteredObject, %XML.Adaptor)
{

/// 1:连接上  2：未连接上
ClassMethod Connect(ByRef ftp As %Net.FtpSession, ServerIP, User, PassWord, Port As %String = 21) As %ObjectHandle
{
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(ServerIP,User,PassWord,Port)  q 0
	q 1
}

/// 1:登出  2：未登出
ClassMethod Logout(ftp As %Net.FtpSession)
{
	If 'ftp.Logout() q 0
	q 1
}

// w ##class(web.DHCPE.FTPManager).Retrieve("192.168.1.100","renzwang","wrz","2121","photo.jpg")

ClassMethod Retrieve(ServerIP, User, PassWord, Port, FileName) As %GlobalBinaryStream
{
	
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(ServerIP,User,PassWord,Port)  q 0
	d ftp.Binary()
	s XMLStream=##class(%GlobalBinaryStream).%New()
	s ret=ftp.Retrieve(FileName,.XMLStream)
	q XMLStream
	
	;w XMLStream.SizeGet(),!
	;w XMLStream.Size,!
	;w XMLStream.Read()
	;q ret
	s f=##class(%File).%New("D:\\Test.txt")
	d f.Open("WSN")
	d f.WriteLine(str)
	d f.Close()
	q 
	;d XMLStream.InputFromDevice(FileName)
	s ret=ftp.Store("aa.txt",XMLStream)
	q ret
}

/// 创建ftp目录
ClassMethod CreateDirectory(ServerIP, User, PassWord, Port, Directory)
{
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(ServerIP,User,PassWord,Port)  q "NoConnect"
	If 'ftp.MakeDirectory(Directory) q "NoCreate"
	q 1
}

/// 得到ftp目录
ClassMethod GetDirectory(ServerIP, User, PassWord, Port, Directory)
{
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(ServerIP,User,PassWord,Port)  q 0
	b ;con
	q ftp.GetDirectory(Directory)
	
	;If 'ftp.MakeDirectory(Directory) q "NoCreate"
	;q 1
}

// w ##class(web.DHCPE.FTPManager).FTPFileExit("172.26.201.13","root","rootcmu","21","D://test.txt")

/// 判断ftp文件是否存在Exist 0:不存在  1：存在
ClassMethod FTPFileExit(ServerIP, User, PassWord, Port, FileName)
{
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(ServerIP,User,PassWord,Port)  q 0
	s sc=ftp.Rename(FileName,FileName)
	d ftp.Logout()
	q sc
}

/// 修改文件名 0:不成功  1：成功
ClassMethod FTPFileRename(ServerIP, User, PassWord, Port, FileName, NewFileName)
{
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(ServerIP,User,PassWord,Port)  q 0
	s sc=ftp.Rename(FileName,NewFileName)
	d ftp.Logout()
	q sc
}

/// 删除ftp文件是否存在 0:未删除  1：删除
ClassMethod DeleteFile(ServerIP, User, PassWord, Port, FileName)
{
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(ServerIP,User,PassWord,Port)  q 0
	s sc=ftp.Delete(FileName)
	d ftp.Logout()
	q sc
}

/// w ##class(web.DHCPE.FTPManager).GetAllFileName("10.160.16.90","root","Rootdb01",21,"tem")
ClassMethod GetAllFileName(ServerIP, User, PassWord, Port, Directory)
{
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(ServerIP,User,PassWord,Port)  q ""
	s NameArray=##class(%ArrayOfDataTypes).%New()
	i 'ftp.NameList(Directory,NameArray) q ""
	s ArrayLength=NameArray.Count()
	s ret=""
	f i=1:1:ArrayLength
	{
		s OneName=NameArray.GetAt(i)
		i ret="" d
		.s ret=OneName
		e  d
		.s ret=ret_"^"_OneName
	}
	q ret
}

ClassMethod Test(Arg1 As %String = "", ByRef Arg2 As %String = "") As %Library.String
{
	s a=0
}

}
