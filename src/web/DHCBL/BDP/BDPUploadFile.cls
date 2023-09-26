/// Fucntion: 上传文件 
/// CreateDate: 2017-4-12
/// Creator:  gaoshanshan
Class web.DHCBL.BDP.BDPUploadFile Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 根据文件路径去读取文件
/// CreateDate: 2016-3-21
/// Creator:  sunfengchao
/// Debug:    w ##class(web.DHCBL.BDP.BDPUploadFile).WriteStreamByFile("")
ClassMethod WriteFileByString(fileString As %String = "", pathFileName As %String = "") As %Float
{
    q:pathFileName="" "-1"
    s len = ##class(%File).GetDirectoryLength(pathFileName)
    f i=1:1:len-1 d
    .d ##class(%File).GetDirectoryPiece(pathFileName,i,.dirAll)
    .s dirExists=##class(%File).DirectoryExists(dirAll)
    .i dirExists=0 d ##class(%File).CreateDirectory(dirAll)
    s file = ##class(%File).%New(pathFileName)
    D file.Open("WSN")
    d file.Write(fileString)
    d file.Close()
    q file.SizeGet()
}

/// @author: wanghc 
/// @param: App 虚拟路径, /dthealth/web or  /trakcarelive/trak/web   or trakcare/web
/// @param: [AddPath] 增加路径 如/key , /html/help/
/// @return: 物理路径,  
/// 如 1. AddPath 为空时,    /dthealth/app/dthis/web/  
/// 如 2. AddPath = key       /dthealth/app/dthis/web/key/ 
/// 如 3. AddPath = html/help /dthealth/app/dthis/web/html/help/ 
/// w ##class(web.DHCBL.BDP.BDPUploadFile).GetPhysicalPath("/dtheath/web","key")
ClassMethod GetPhysicalPath(AppPath, AddPath = "")
{
	//q "D:\DTHealth\app\dthis\web\scripts\bdp\Framework\Doc\"
	if AppPath = ""{
		Set Config = $o(^websys.ConfigurationD(""))
		Set App = $lg(^websys.ConfigurationD(Config),2)
	}Else{
		Set App = AppPath
	}
	If App="" Set App="/dthealth/web"
	Set dir=""
	Set CurNS=$namespace
	zn "%sys"
	if $d(^SYS("Security","ApplicationsD",App),g){
		Set dir = $lg(g,17)
	}else{
		Set App1 = $p(App,"/",1,$l(App,"/")-1)
		if $d(^SYS("Security","ApplicationsD",App1),g){
			Set dir = $lg(g,17)_"/"_$p(App,"/",$l(App,"/"))
		}else{
			Set App2 = $p(App,"/",1,$l(App,"/")-2)
			if $d(^SYS("Security","ApplicationsD",App2),g){
				Set dir = $lg(g,17)_"/"_$p(App,"/",$l(App,"/")-1,$l(App,"/"))
			}
		}
	}
	zn CurNS
	Set dir = ##class(%File).NormalizeDirectory(dir_"/"_AddPath)
	Quit dir
}

/// d ##class(web.DHCBL.BDP.BDPUploadFile).UploadFile("4@%CSP.BinaryStream")
ClassMethod UploadFile(FileStream) As %String
{
    s result=0
     New fileStream,bytes,file
    ; w dirname 上传的文件存到哪个物理路径下
    Set componentxml = "\scripts\bdp\Framework\Doc\" 
    s dirname = ##class(web.DHCBL.BDP.BDPUploadFile).GetPhysicalPath("",componentxml)
   	
    Set fileStream = %request.MimeData("FileStream",1)
    ; 获取文件名
    set fileStream.FileName = ##class(%File).GetFilename(fileStream.FileName) 
    Set file = ##class(%FileBinaryStream).%New()
    Set file.Filename=dirname_fileStream.FileName
    Do fileStream.Rewind()
    While('fileStream.AtEnd){
        Set bytes = fileStream.Read(1024)
		w bytes,!
        Do file.Write(bytes)
    }
    Do file.Flush()
    Do file.%Save()
    Do file.%Close()
    Set file=""
    q resut=1
}

/// w ##class(web.DHCBL.BDP.BDPUploadFile).DeleteFile("aaa.txt")
ClassMethod DeleteFile(filePath As %String) As %String
{
    s result=0
    s Config = $o(^websys.ConfigurationD(""))
	s App = $lg(^websys.ConfigurationD(Config),1)
	if (App=""){
		//s path="D:\DTHealth\app\dthis\web"
		s path= ##class(ext.util.String).GetPhysicalPath("","")
	}else{
		s path= $e(App,1,*-12)
	}
    s dirAll=path_"\"_filePath
    If (##class(%File).Exists(dirAll)=1)
    {
      s result= ##class(%File).Delete(dirAll)
    }
    q result
}

/// w ##class(web.DHCBL.BDP.BDPUploadFile).IsExistsFile("scripts\bdp\Framework\Doc\22222.docx")
ClassMethod IsExistsFile(filePath As %String) As %String
{
	s flag=0
	s Config = $o(^websys.ConfigurationD(""))
	s App = $lg(^websys.ConfigurationD(Config),1)
	if (App=""){
		//s path="D:\DTHealth\app\dthis\web"
		s path= ##class(ext.util.String).GetPhysicalPath("","")
	}else{
		s path= $e(App,1,*-12)
	}
    s dirAll=path_"\"_filePath
    s flag=##class(%File).Exists(dirAll)
    
	q flag
}

}
