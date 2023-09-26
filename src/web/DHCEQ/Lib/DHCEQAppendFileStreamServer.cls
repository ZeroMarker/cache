Include %cspBuild

/// GR0046 extjs文件上传 参照%CSP.StreamServer.cls而来
/// 作用，将ftp目录下文件以文件流形式回传到客户端
/// 参数APPENDFILEROWID：加密后的文件表RowID
Class web.DHCEQ.Lib.DHCEQAppendFileStreamServer Extends %CSP.Page [ ProcedureBlock ]
{

// 客户端多调试器将导致前台连图片字符串都无法获取

// Property stream As %GlobalBinaryStream;

/// The <method>OnPostHTTP()</method> is called by the CSP dispatcher before the HTTP
/// headers have been sent.  Here, we check that the incoming STREAMOID value is valid,
/// then we set the appropriate content type and content length values into the %response
/// object (see <class>%CSP.Request</class>), in preparation for sending the image data
/// in the <method>OnPage()</method>.
ClassMethod OnPreHTTP() As %Boolean
{
	Set %stream="",%response.Status="404 Stream Not Found" 
	Set file=$get(%request.Data("FILE",1))
	If file'="" {
		$$$SysLog(3,"CSPStream","Serving file",file)
		If $zconvert($piece(file,".",$length(file,".")),"l")="csp" {
			$$$SysLog(2,"CSPStream","Not allowed to server up a csp file","")
			Quit 0
		}
		Set app=$$getapp^%SYS.cspServer(file,.path)
		#; If we can not serve files from this application leave the stream blank
		If '$$$GetSecurityApplicationsServeFiles(app) {
			$$$SysLog(2,"CSPStream","CSP application will not allow files to be served","")
			Quit 0
		}
		#; Use standard application mapping to find the file.
		Set file=$$ConvertFilenameToAbsolute^%apiCSP($extract(file,$length(path)+1,*),$$$GetSecurityApplicationsPath(app))
		If ##class(%File).Exists(file)=0,$piece(file,"/",1,3)'="/csp/broker" {
			Set tmpfile=%request.Data("FILE",1),len=$length(tmpfile,"/")
			For i=0,1 {
				Set commonfile=$$GetFilename^%apiCSP("/csp/broker/"_$piece(tmpfile,"/",len-i,len))
				If commonfile'="",##class(%File).Exists(commonfile) Set file=commonfile,commonfile=-1 Quit
				If len<3 Quit
			}
			If commonfile'=-1 {
				$$$SysLog(2,"CSPStream","CSP file not found",file)
				Quit 0
			}
		}
		#; Can not service up directories
		If ##class(%File).DirectoryExists(file) Quit 0
		Set clientts=$piece($get(%request.CgiEnvs("HTTP_IF_MODIFIED_SINCE")),";")
		Set streamts=##class(%File).GetFileDateModified(file,1)
		If streamts'="" Do %response.SetHeader("Last-Modified",..ToHTTPDate(streamts))
		Set expires=$$$GetSecurityApplicationsServeFilesTimeout(app) If expires="" Set expires=3600
		Set %response.Expires=expires
		#; If we let CSP gateway cache the file then always send full file over as sending '304 Not Modified' will not give it anything to cache
		If expires>0,$$$GetSecurityApplicationsServeFiles(app)=2 {
			Set %response.VaryByParam="FILE"
		} ElseIf clientts'="" {
			Set clientts=..FromHTTPDate(clientts)
			If $select(+streamts<+clientts:1,+streamts>+clientts:0,$piece(streamts,",",2)'>$piece(clientts,",",2):1,1:0) {
				$$$SysLog(3,"CSPStream","File not modified","")
				Set %response.Status="304 Not Modified"
				Quit 0
			}
		}
		
		#; If FileClassify() fails, it classifies the file as application/octet-stream
		Do ..FileClassify($piece(file,".",$length(file,".")),.type,.bin,.charset)
		Set %stream=##class(%FileBinaryStream).%New()
		Set sc=%stream.LinkToFile(file) If $$$ISERR(sc) Quit 0
		If type'="" Set %response.ContentType=type
		Set tmp=$translate(%request.Data("FILE",1),"\","/"),tmp=$piece(tmp,"/",$length(tmp,"/"))
		If tmp'="" Do %response.SetHeader("Content-Disposition","inline; filename="_tmp)
		Set %response.NoCharSetConvert=1
		If $get(charset)'="" Set %response.CharSet=charset
	} Else {
		//GR0046 文件流回传核心代码
		s APPENDFILEROWID=$get(%request.Data("APPENDFILEROWID",1))
		// Modify by zx 2021-01-10 增加视频,音频处理
		s TYPE=$get(%request.Data("TYPE",1)) //1,移动端;其它,PC端
		s MEDIATYPE=$get(%request.Data("MEDIATYPE",1)) //媒体类型,Video,视频;Audio,音频;其它,文件
		if TYPE'=1 s APPENDFILEROWID=##Class(websys.Page).Decrypt(APPENDFILEROWID)    //Modefied by zc0107 2021-11-14 将%CSP.Page改成websys.Page
		s (DocName,OldFileName,FileType)=""
		&SQL(select AF_DocName,AF_FileName,AF_FileType into :DocName,:OldFileName,:FileType  from SQLUSer.DHC_EQAppendFile where AF_RowID=:APPENDFILEROWID)
		i $get(%request.Data("FileType",1))'="" s FileType=$get(%request.Data("FileType",1))
		s FileName=APPENDFILEROWID_"."_FileType
		i DocName'="" s DocName=##Class(%CSP.Page).EscapeURL(DocName)_"."_FileType
		else  s DocName=##Class(%CSP.Page).EscapeURL(OldFileName)_"."_FileType
		d %response.SetHeader("Content-Disposition","attachment;filename="_DocName)
		Do ..FileClassify(FileType,.type,.bin,.charset)
		If type'="" Set %response.ContentType=type
		If $get(charset)'="" Set %response.CharSet=charset
		
		Set ftp=##class(%Net.FtpSession).%New()
		///modified by ZY0278 20210826
		i (##class(web.DHCEQCommon).GetSysInfo("990086")=1) Set ftp.SSLConfiguration="FTPS"  ////Modefied by zc0107 2021-11-22  将系统参数990026改成990086
		set server=##class(web.DHCEQCommon).GetSysInfo("990018")
		set name=$p(server,"&",2)
		//Moidefied by zc0069  密码解密 begin
		//set password=$p(server,"&",3)
		set password=##Class(web.Util.Encryption).SimpleDecrypt($p(server,"&",3),"DHCEQ")
		//Moidefied by zc0069  密码解密 end
		set port=21
		i $p(server,"&",4)'="" set port=$p(server,"&",4)
		set server=$p(server,"&",1)
		If 'ftp.Connect(server,name,password,port) Write "fail"
		If 'ftp.Binary() Write "fail"
		//set path="/hello/168.bmp"
		//set path=##class(web.DHCEQCommon).GetSysInfo("990004")_FileName
		//set path="/TestFtp/DHCEQAppendFile/"_FileName
		//Modify by zx 2021-01-10 增加视频,音频处理
		s PathSysCode="990005"
		i MEDIATYPE'="" s PathSysCode=$CASE(MEDIATYPE,"file":"990005","audio":"990081","video":"990080",:"")
		set path=##class(web.DHCEQCommon).GetSysInfo(PathSysCode)_FileName
		
		Set %stream=##class(%Library.GlobalBinaryStream).%New()
		d ftp.Retrieve(path,%stream)
		If 'ftp.Logout() Write "Failed to logout"
		s oid=""
		//s Status =%stream.SaveStream()
		
		If %stream=$$$NULLOREF {
			$$$SysLog(3,"CSPStream","Unable to open stream oid",oid)
			Quit 0
		}
		Set %response.ContentType=""
		If $data(%request.Data("EXPIRES",1,"encrypt")) {
			Set expires=$get(%request.Data("EXPIRES",1))
		} Else {
			Set app=$$getapp^%SYS.cspServer(%request.URL)
			Set expires=$$$GetSecurityApplicationsServeFilesTimeout(app)
			#; IE does not handle files it receives that are not cacheable correctly
			If expires="",%request.UserAgent["MSIE" Set expires=60
		}
		If %stream.%Extends("%Library.AbstractStream") {
			Set %response.ContentType=%stream.GetAttribute("ContentType")	//""
			Set %response.CharSet=%stream.GetAttribute("CharSet")
			If %stream.GetAttribute("ContentDisposition")'="" Do %response.SetHeader("Content-Disposition",%stream.GetAttribute("ContentDisposition"))
			If %stream.IsDefinedAttribute("Expires") Set expires=%stream.GetAttribute("Expires")
		}
		If expires'="" Set %response.Expires=expires
		If %response.ContentType="" {
			If $get(%request.Data("CONTENTTYPE",1))'="" {
				Set %response.ContentType=$get(%request.Data("CONTENTTYPE",1))
			} ElseIf %stream.IsCharacter() {
				Set %response.ContentType="text/plain"
			} Else {
				Set %response.ContentType="application/octet-stream"			//流程路线
			}
		}
		If type'="" Set %response.ContentType=type	//GR0033
		
		//s:ACTION="download" %response.CharSet="utf-8" //设置这个属性后将使图片无法正常预览
		//Set %response.NoCharSetConvert=1
	}
	If %stream.IsCharacter() {
		Do %response.ContentInfo(,.table)
		If table="RAW"||($extract(table,1,$length("Latin"))="Latin")||($extract(table,1,$length("CP"))="CP") {
			Set %response.ContentLength=%stream.Size
		} ElseIf table="UnicodeLittle"||(table="UnicodeBig") {
			Set %response.ContentLength=%stream.Size*2
		} Else {
			#; Gateway will fill in the length for us
			Set %response.ContentLength=""
		}
	} Else {
		Set %response.ContentLength=%stream.Size
	}
	Set %response.Status="200 OK"
	
	#; Now, the OnPage() method will serve up the actual stream data
	
	Quit 1
}

/// The <method>OnPage()</method> is called by the CSP dispatcher to generate the
/// page content.  For %CSP.StreamServer, since the content type is actually a stream, not HTML
/// we simply write out the stream data.
ClassMethod OnPage() As %Status
{
	If %stream'=$$$NULLOREF Quit %stream.OutputToDevice()
	Quit $$$OK
}

/// Get oid for file
ClassMethod GetOidForFile(file As %String) As %ObjectIdentity [ Internal ]
{
	Do ..FileClassify($P(file,".",$L(file,".")),.type,.bin,.charset)
	If bin Set oid=##class(%FileBinaryStream).GetStreamIdForFile(file,type,charset)
	If 'bin Set oid=##class(%FileCharacterStream).GetStreamIdForFile(file,type,charset)
	Quit oid
}

/// Classify a file type
ClassMethod FileClassify(ext As %String, ByRef type As %String, ByRef bin As %Boolean, ByRef charset As %String) As %Boolean
{
	b
	Set charset="",bin=1
	If ext="" Set type="application/octet-stream" Quit 0
	Set bin=0,ext="/"_$zconvert(ext,"u")_"/"
	If $data(^%SYS("CSP","MimeFileClassify",$extract(ext,2,*-1)),data) {
		Set type=$list(data),bin=$list(data,2),charset=$listget(data,3)
		Quit 1
	}
	
	If "/CSS/"=ext Set type="text/css" Goto charset
	If "/HTML/HTM/"[ext Set type="text/html" Goto charset
	If "/JS/"=ext Set type="text/javascript" Goto charset
	If "/TXT/"[ext Set type="text/text" Goto charset
	If "/XML/"[ext Set type="text/xml" Goto charset
	Set bin=1,charset=""
	If "/CLASS/"=ext Set type="" Quit 1
	If "/JPG/JPEG/"[ext Set type="image/jpeg" Quit 1
	If "/GIF/"=ext Set type="image/gif" Quit 1
	If "/BMP/"=ext Set type="image/bmp" Quit 1
	If "/ZIP/"=ext Set type="application/zip" Quit 1
	If "/TAR/"=ext Set type="application/x-tar" Quit 1
	If "/GZ/"=ext Set type="application/x-gzip" Quit 1
	If "/Z/"=ext Set type="application/x-compress" Quit 1
	If "/AI/EPS/PS/"[ext Set type="application/postscript" Quit 1
	If "/PDF/"=ext Set type="application/pdf" Quit 1
	If "/AVI/"=ext Set type="video/x-msvideo" Quit 1
	If "/QT/MOV/"[ext Set type="video/quicktime" Quit 1
	If "/MPEG/MPG/MPE/"[ext Set type="video/mpeg" Quit 1
	If "/WAV/"=ext Set type="audio/wav" Quit 1
	If "/PNG/"=ext Set type="image/png" Quit 1
	If "/SVG/"=ext Set type="image/svg+xml" Quit 1
	If "/ICO/"=ext Set type="image/x-icon" Quit 1
	If "/MP3/"=ext Set type="audio/mpeg" Quit 1   //Modify by zx 2021-01-10
 
	; Default to application/octet-stream
	Set type="application/octet-stream"
	;
	Quit 0
charset		Set charset=$get(^%SYS("CSP","DefaultFileCharset"))
	If charset="" {
		If $$$IsUnicode {
			#; On a unicode Cache when editing the file in Studio we will use the default file translate table
			#; So this tells us the charset to report when sending the file out
			Set charset=$$MapExtCharset^%SYS.NLS($$GetPDefIO^%SYS.NLS(3))
		} Else {
			#; On an 8bit Cache the file will be read/written in RAW mode so we should default to
			#; using the system default translate table
			Set charset=$$MapExtCharset^%SYS.NLS($$GetCharset^%SYS.NLS())
		}
	}
	Quit 1
}

/// Convert a $H value into an HTTP date format. It assumes that $H is local
/// time and converts it to GMT
ClassMethod ToHTTPDate(h As %String) As %String
{
	If h'?1.n1","1.n Set h=$ZDTH(h,3,,,,,,,,,1)  ; Convert from YYYY-MM-DD HH:MM:SS format
	Set h=h-$horolog+$ztimestamp*86400+$piece(h,",",2)-$piece($horolog,",",2)+($piece($ztimestamp,",",2)\1)
	Set h=h\86400_","_(h#86400)
	Quit $piece($ZDT(h,11,,,,,,,,,,1)," ")_", "_$ZDT(h,2,,,,4,,,,,,1)_" GMT"
}

/// Convert an HTTP date to a $HOROLOG format date, converts from GMT time
/// to the local time.
ClassMethod FromHTTPDate(hd As %String) As %String
{
	If (hd?1.e1" "3a)!(hd?1.e1" +"1.n) Set hd=$piece(hd," ",1,$length(hd," ")-1)
	Set h=$ZDTH($ZSTRIP($piece(hd,",",2),"<>W"),2,,,,,,,,,1)
	Set h=h+$horolog-$ztimestamp*86400+$piece(h,",",2)+$piece($horolog,",",2)-($piece($ztimestamp,",",2)\1)
	Quit h\86400_","_(h#86400)
}

}
