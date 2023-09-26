Class DHCEPRFS.Util.PDFView Extends (%ZEN.Component.page, %CSP.StreamServer)
{

ClassMethod %OnPreHTTP() As %Boolean
{
	set FileID = $Get(%request.Data("FileID",1))
	set FileID = ##class(web.Util.Encryption).SimpleDecrypt(FileID)
	set file = ##class(%GlobalBinaryStream).%New()
	set file = ..GetPDFStream(FileID)
	
	Set %stream=##class(%FileBinaryStream).%New()
	do %stream.CopyFrom(file)
	Do %response.SetHeader("Content-Type","application/pdf")
	Do %stream.SetAttribute("Content-Type","application/pdf")
	Quit 1
}

ClassMethod OnPage() As %Status
{
	If %stream'=$$$NULLOREF Do %stream.OutputToDevice()
	Quit $$$OK
}

ClassMethod GetPDFStream(AFileMasterID As %String) As %GlobalCharacterStream
{
	
	s fileInfo = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(AFileMasterID)
	s ftpConfig = $p(fileInfo,"@@@",1)
	s fileLocPath = $p(fileInfo,"@@@",2)

	s FTPMethod = $p(ftpConfig,"^",1)
	s IP = $p(ftpConfig,"^",2)
	s Port = $p(ftpConfig,"^",3)
	s UserName = $p(ftpConfig,"^",4)
	s Password = $p(ftpConfig,"^",5)
	
	s FileName = $p(fileLocPath,"/",$l(fileLocPath,"/"),$l(fileLocPath,"/"))
	s Directory = $replace(fileLocPath,FileName,"")

	Set ftp=##class(%Net.FtpSession).%New()
	
	//设置FTPS
	if (($zcvt(FTPMethod,"U")) = "FTPS"){ 	
		Set ftp.SSLConfiguration = "FTPS"
	}
	 	
	If 'ftp.Connect(IP,UserName,Password,Port) {
		 d OutStream.Write("FTP连接不上")
		 q 0
	}
	if 'ftp.SetDirectory(Directory) {
		 d OutStream.Write("FTP路径不存在")
		 d ftp.Logout()
		 q 0
	}
	Set stream=##class(%GlobalCharacterStream).%New()
	If 'ftp.Binary() {
		d OutStream.Write("FTP内容不能binary mode")
		d ftp.Logout()
		q 0
	}
	
	s ret=ftp.Retrieve(FileName,stream)
	If 'ftp.Retrieve(FileName,stream) {
		d OutStream.Write("没有找个FTP上指定目录下的文件")
		d ftp.Logout()
		q 0
	}
	
	If 'ftp.Logout() {
		d OutStream.Write("断开FTP失败")
		q 0
	}
	s OutStream=stream
	
	q OutStream
}

}
