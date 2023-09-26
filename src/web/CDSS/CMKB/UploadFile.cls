/// Fucntion: 上传文件 
/// CreateDate: 2017-4-12
/// Creator:  gaoshanshan
Class web.CDSS.CMKB.UploadFile Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 根据文件路径去读取文件
/// CreateDate: 2016-3-21
/// Creator:  sunfengchao
/// Debug:    w ##class(web.CDSS.CMKB.UploadFile).WriteStreamByFile("")
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

/// d ##class(web.CDSS.CMKB.UploadFile).UploadFile("4@%CSP.BinaryStream")
ClassMethod UploadFile(FileStream) As %String
{
    s result=0
     New fileStream,bytes,file
    ; w dirname 上传的文件存到哪个物理路径下
    Set componentxml = "/scripts/bdp/CDSS/Doc/" 
    s dirname = ##class(ext.util.String).GetPhysicalPath("",componentxml)
   	
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

/// w ##class(web.CDSS.CMKB.UploadFile).DeleteFile("aaa.txt")
ClassMethod DeleteFile(filePath As %String) As %String
{
    s result=0
	s path= ##class(ext.util.String).GetPhysicalPath("","")
     if (path["\"){
		s dirAll=path_"\"_filePath
	}else{
		s dirAll=path_"/"_filePath
	}
    If (##class(%File).Exists(dirAll)=1)
    {
      s result= ##class(%File).Delete(dirAll)
    }
    q result
}

/// w ##class(web.CDSS.CMKB.UploadFile).IsExistsFile("scripts\bdp\Framework\Doc\22222.docx")
ClassMethod IsExistsFile(filePath As %String) As %String
{
	s flag=0
	s path= ##class(ext.util.String).GetPhysicalPath("","")
    if (path["\"){
		s dirAll=path_"\"_filePath
	}else{
		s dirAll=path_"/"_filePath
	}
    s flag=##class(%File).Exists(dirAll)
    
	q flag
}

}
