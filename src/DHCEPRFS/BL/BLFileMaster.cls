Class DHCEPRFS.BL.BLFileMaster Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod IsFileExistedByName(AFullFileName As %String) As %Boolean
{
}

ClassMethod GetFileMasterID(AFullFileName As %String) As %String
{
	s dirMasterID = ##Class(DHCEPRFS.BL.BLDirMaster).GetDirMasterIDByFile(AFullFileName)
	q:(dirMasterID = "") ""
	
	s length = $Length(AFullFileName, "/")
	s fileName = $P(AFullFileName, "/", length)
	q:(fileName = "") ""
	
	s fileMasterID = ..GetFileMasterIDByDirAndFile(dirMasterID, fileName)
	q fileMasterID
}

ClassMethod GetFileMasterIDByDirAndFile(ADirMasterID As %String, AFileName As %String) As %String
{
	q:(ADirMasterID="")||(AFileName="") ""
	s bigFileName = $zcvt(AFileName, "u")
	s fileMasterID = $O(^DHCEPRFS.INST.FileMasterI("IdxMaster", ADirMasterID, " "_bigFileName, "")) 
	q fileMasterID
}

ClassMethod UpdateMD5Code(AParam) As %String
{
	s flag = "true"
	for i=1:1:$l(AParam,"^")
	{
		s oneParam = $p(AParam,"^",i)
		s fileMasterID = $p(oneParam,"|",1)
		s md5Code = $p(oneParam,"|",2)	
		
		s fileMater = ##Class(DHCEPRFS.INST.FileMaster).%OpenId(fileMasterID)
		s fileMater.MD5Code = md5Code
		s sc = fileMater.%Save()
		if ('$$$ISOK(sc))
		{
			s flag = "false"
			q
		}
	}
	q:(flag = "true") "1"
	q "0"
}

ClassMethod AddFileMasterByDirAndFile(ADirMasterID As %String, AFileName As %String, AMD5Code As %String = "", ANameSpace As %String = "DHCEPRFS") As %String
{
	s now = $h
	s date = $zd($P(now, ",", 1),3)
	s time = $zt($P(now, ",", 2),1)
	s year = $P(date, "-", 1)
	s month = $P(date, "-", 2)
	s day = $P(date, "-", 3)
	
	s dirLocPath = "/"_ANameSpace_year_"/"_month_"/"_day
	s dirLocID = ##Class(DHCEPRFS.BL.BLDirLoc).AddDirLocByFullPath(dirLocPath)
	q:(dirLocID = "") ""
	
	//获取扩展名
	s extension = $p(AFileName,".",$l(AFileName,"."))
	
	//s maxFileMasterID = ..GetMaxFileMasterID()
	//s fileLocName = $tr(time,":","")_"-"_(maxFileMasterID+1)_".pdf"
	
    s randomNumber=$random(100000)_$random(100000)_$random(100000)
    s fileLocName = $tr(time,":","")_"-"_randomNumber_"."_extension
    
	s newFile = ##Class(DHCEPRFS.INST.FileMaster).%New()
	s newFile.DirMasterID = ADirMasterID
	s newFile.FileMasterName = AFileName
	s newFile.DirLocID = dirLocID
	s newFile.FileLocName = fileLocName
	s newFile.MD5Code = AMD5Code
	s sc = newFile.%Save()
	if ($$$ISOK(sc))
	{
		s fileLocName=$tr(time,":","")_"-"_newFile.%Id()_"."_extension
        s newFile.FileLocName=fileLocName
        s sc = newFile.%Save()
		q newFile.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod GetMaxFileMasterID() As %Integer
{
	s maxID = $O(^DHCEPRFS.INST.FileMasterD(""),-1)
	s maxID = (+maxID)
	q maxID
}

/// w ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(69)
ClassMethod GetFullFileLocName(AFileMasterID As %String, ANameSpace As %String = "DHCEPRFS") As %String
{
	q:(AFileMasterID="") ""
	
	s fileMaster = ##Class(DHCEPRFS.INST.FileMaster).%OpenId(AFileMasterID)
	q:(fileMaster = "") ""
	
	s dirLocName = ##Class(DHCEPRFS.BL.BLDirLoc).GetFullDirLocName(fileMaster.DirLocID)
	q:(dirLocName="") ""
	
	///DHCEPRFS2018/01/31
	s fileDate = $p(dirLocName,ANameSpace,2)
	s fileDate = $tr(fileDate,"/","-")
	s fileDate = $zdh(fileDate,3)
	
	s fileStore = ##Class(DHCEPRFS.BL.BLFileStoreConfig).GetFileStoreConfig(fileDate,ANameSpace)
	//fileStore = obj.FTPMethod_"^"_obj.FileServerIP_"^"_obj.FileServerPort_"^"_obj.FileServerUserName_"^"_obj.FileServerPassword_"^"_obj.FileServerTimeOut_"@@@"_obj.FileServerIP_"|"_obj.VirtualDir
	if (fileStore = "")
	{
		q dirLocName_"/"_fileMaster.FileLocName
	}
	else
	{	
		//obj.FTPMethod_"^"_obj.FileServerIP_"^"_obj.FileServerPort_"^"_obj.FileServerUserName_"^"_obj.FileServerPassword_"^"_obj.FileServerTimeOut_"@@@"_obj.FileServerIP_"|"_obj.VirtualDir_"|"_dirLocName_"/"_fileMaster.FileLocName
		//20220925修改为(路径不能以/开头):
		//obj.FTPMethod_"^"_obj.FileServerIP_"^"_obj.FileServerPort_"^"_obj.FileServerUserName_"^"_obj.FileServerPassword_"^"_obj.FileServerTimeOut_"@@@"_obj.VirtualDir_"/"_dirLocName_"/"_fileMaster.FileLocName
		s ftpConfig = $p(fileStore,"@@@",1)
		s virtualDir = $p($p(fileStore,"@@@",2),"|",2)
		//去掉第一个字符/
		s virtualDir = $e(virtualDir,2,$l(virtualDir))
		//拼接ftp路径 virtual默认后面不带 /,dirLocName默认前面带/,后面不带/
		s filePath = virtualDir_dirLocName_"/"_fileMaster.FileLocName
		if $e(filePath,1,1)="/"
		{ 
			s filePath = $e(filePath,2,$l(filePath))
		}
		q ftpConfig_"@@@"_filePath
	}
}

ClassMethod GetFullFileMasterName(AFileMasterID As %String) As %String
{
	q:(AFileMasterID="") ""
	
	s fileMaster = ##Class(DHCEPRFS.INST.FileMaster).%OpenId(AFileMasterID)
	q:(fileMaster = "") ""
	
	s dirMasterName = ##Class(DHCEPRFS.BL.BLDirMaster).GetFullDirMasterName(fileMaster.DirMasterID)
	q:(dirMasterName="") ""
	
	s fullFileMasterName = dirMasterName_"/"_fileMaster.FileMasterName
	q fullFileMasterName
}

}
