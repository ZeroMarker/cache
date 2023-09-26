Class DHCEPRFS.BL.BLFileRegister Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod UpdateMD5Code(AParam As %String) As %String
{
	s ret = ##class(DHCEPRFS.BL.BLFileMaster).UpdateMD5Code(AParam)
	q ret
}

/// Desc:	注册文件
ClassMethod RegisterFile(AEFileReg As DHCEPRFS.Entity.EFileRegister) As DHCEPRFS.Entity.EFileRegister
{
	//b "s"
	s AFullFileName = AEFileReg.FullFileMasterName
	s AMD5Code = AEFileReg.MD5Code
	s ANameSpace = AEFileReg.NameSpace
	
	s dirMasterID = ##Class(DHCEPRFS.BL.BLDirMaster).GetDirMasterIDByFile(AFullFileName)
	if (dirMasterID = "")
	{
		s dirMasterID = ##Class(DHCEPRFS.BL.BLDirMaster).AddDirMasterByFile(AFullFileName)
	}
	q:(dirMasterID = "") ""
	
	
	s count = $Length(AFullFileName, "/")
	s fileName = $P(AFullFileName, "/", count)
	q:(fileName = "") ""
	
	s fileMasterID = ##Class(DHCEPRFS.BL.BLFileMaster).GetFileMasterIDByDirAndFile(dirMasterID, fileName)
	if (fileMasterID = "")
	{
		s fileMasterID = ##Class(DHCEPRFS.BL.BLFileMaster).AddFileMasterByDirAndFile(dirMasterID, fileName, AMD5Code, ANameSpace)
	}
	q:(fileMasterID = "") ""
	
	s retEFileReg = ##Class(DHCEPRFS.Entity.EFileRegister).%New()
	s retEFileReg.FileMasterID = fileMasterID
	s retEFileReg.FullFileMasterName = AFullFileName
	s retEFileReg.MD5Code = AMD5Code
	s retEFileReg.FullFileLocName = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(fileMasterID)
	
	q retEFileReg
}

/// Desc:	获取指定MRVersionID的病历项目
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLFileRegister","GetFileRegisterInfo","/93/97/epr/CG71_Single_93_97_52_52_0-0_3.pdf^/93/97/epr/CG71_Single_93_97_58_58_0-0_3.pdf","","DHCEPRFS^DHCEPRFS")
Query GetFileRegisterInfo(AFileMasterNameList As %String, AMD5CodeList As %String = "", ANameSpaceList As %String = "") As %Query(ROWSPEC = "ArrayIndex:%String,FTPConfig:%String,FileMasterID:%String,FileMasterName:%String,FullFileLocName:%String")
{
}

ClassMethod GetFileRegisterInfoExecute(ByRef qHandle As %Binary, AFileMasterNameList As %String, AMD5CodeList As %String = "", ANameSpaceList As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	k ^CacheTemp(repid,"dhceprfs","GetFileRegisterInfo")
	
	s dirMasterID = ""
	s ftpCount = 0
	s ftpConfig = ""
	s count = $L(AFileMasterNameList,"^")
	for i = 1:1:count
	{
		s oneFileMasterName = $P(AFileMasterNameList,"^",i)
		s oneMD5Code =  $P(AMD5CodeList,"^",i)
		s nameSpace = $P(ANameSpaceList,"^",i)
		s fileName = $P(oneFileMasterName,"/",$L(oneFileMasterName,"/"))
		
		if (dirMasterID = "")
		{
			s dirMasterID = ##Class(DHCEPRFS.BL.BLDirMaster).GetDirMasterIDByFile(oneFileMasterName)
			if (dirMasterID = "")
			{
				s dirMasterID = ##Class(DHCEPRFS.BL.BLDirMaster).AddDirMasterByFile(oneFileMasterName)
			}
			q:(dirMasterID = "")
		}
		if (dirMasterID="")
		{
			s retRegFileMasterInfo = ""
			q
		}
		
		s fileMasterID = ##Class(DHCEPRFS.BL.BLFileMaster).GetFileMasterIDByDirAndFile(dirMasterID, fileName)
		if (fileMasterID = "")
		{
			s fileMasterID = ##Class(DHCEPRFS.BL.BLFileMaster).AddFileMasterByDirAndFile(dirMasterID, fileName, oneMD5Code, nameSpace)
		}
		if (fileMasterID = "")
		{
			s retRegFileMasterInfo = ""
			q
		}
	
		s fullFileLocName = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(fileMasterID,nameSpace)
		//fullFileLocName = obj.FTPMethod_"^"_obj.FileServerIP_"^"_obj.FileServerPort_"^"_obj.FileServerUserName_"^"_obj.FileServerPassword_"^"_obj.FileServerTimeOut_"@@@"_obj.FileServerIP_"|"_obj.VirtualDir_"|"_dirLocName_"/"_fileMaster.FileLocName

		//按照ip排序
		s FTPConfigOne = $p(fullFileLocName,"@@@",1)	
		s FileLocPath = $p(fullFileLocName,"@@@",2)
		
		if (FTPConfigOne '= ftpConfig)
		{
			s ftpConfig = FTPConfigOne
			s ftpCount = (+ftpCount) + 1	
		}
		s ^CacheTemp(repid,"dhceprfs","GetFileRegisterInfo",ftpCount,fileMasterID)= $lb((+i-1),FTPConfigOne,fileMasterID,oneFileMasterName,FileLocPath)		
	}

	s ftpCount = ""
	for {
		s ftpCount = $o(^CacheTemp(repid,"dhceprfs","GetFileRegisterInfo",ftpCount))
		q:(ftpCount = "")
		s fileMasterID = ""
		for {
			s fileMasterID = $o(^CacheTemp(repid,"dhceprfs","GetFileRegisterInfo",ftpCount,fileMasterID))
			q:(fileMasterID = "")
			
			s ^CacheTemp(repid,ind) = ^CacheTemp(repid,"dhceprfs","GetFileRegisterInfo",ftpCount,fileMasterID)
			s ind=ind+1 	
		}
	}

	k ^CacheTemp(repid,"dhceprfs","GetFileRegisterInfo")
	
	Quit $$$OK
}

ClassMethod GetFileRegisterInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFileRegisterInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetFileRegisterInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFileRegisterInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// debug: w ##class(DHCEPRFS.BL.BLFileRegister).RegFileList("/93/97/epr/CG71_Single_93_97_52_52_0-0_3.pdf^/93/97/epr/CG71_Single_93_97_58_58_0-0_3.pdf","","DHCEPRFS^DHCEPRFS")
ClassMethod RegFileList(AFileMasterNameList As %String, AMD5CodeList As %String = "", ANameSpaceList As %String = "") As %String
{
	q:(AFileMasterNameList="")||(AFileMasterNameList=$C(0)) ""
	
	s retRegFileMasterInfo = ""
	
	s result = ##class(%ResultSet).%New("DHCEPRFS.BL.BLFileRegister:GetFileRegisterInfo")
	d result.Execute(AFileMasterNameList,AMD5CodeList,ANameSpaceList)
	while(result.Next())
	{
		s ArrayIndex = $g(result.Data("ArrayIndex"))
		s FTPConfig = $g(result.Data("FTPConfig"))
		s FileMasterID = $g(result.Data("FileMasterID"))
		s FileMasterName = $g(result.Data("FileMasterName"))
		s FullFileLocName = $g(result.Data("FullFileLocName"))

		if (retRegFileMasterInfo = "")
		{
			//retRegFileMasterInfo = fileMasterID_"#"_obj.FileServerIP_"|"_obj.VirtualDir_"|"_dirLocName_"/"_fileMaster.FileLocName_"#"_FileMasterName_"#"_FTPConfig
			s retRegFileMasterInfo = FileMasterID_"#"_FullFileLocName_"#"_FileMasterName_"#"_FTPConfig_"#"_ArrayIndex
		}
		else
		{
			s retRegFileMasterInfo = retRegFileMasterInfo_"$$$"_FileMasterID_"#"_FullFileLocName_"#"_FileMasterName_"#"_FTPConfig_"#"_ArrayIndex
		}		
	}
	
	q retRegFileMasterInfo
}

ClassMethod GetRegisterFile(AFileMasterID As %String) As DHCEPRFS.Entity.EFileRegister
{
	s masterName = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileMasterName(AFileMasterID)
	q:(masterName = "") ""
	
	s locName = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(AFileMasterID)
	q:(locName = "") ""
	
	s retEFileReg = ##Class(DHCEPRFS.Entity.EFileRegister).%New()
	s retEFileReg.FileMasterID = AFileMasterID
	s retEFileReg.FullFileMasterName = masterName
	s retEFileReg.FullFileLocName = locName
	
	q retEFileReg
}

ClassMethod GetRegisterFileByName(AFileMasterName As %String) As DHCEPRFS.Entity.EFileRegister
{
	s fileMasterID = ##Class(DHCEPRFS.BL.BLFileMaster).GetFileMasterID(AFileMasterName)
	q:(fileMasterID = "") ""
	
	s retEFileReg = ..GetRegisterFile(fileMasterID)
	q retEFileReg
}

/// d ##Class(DHCEPRFS.BL.BLFileRegister).Test()
ClassMethod Test()
{
	//b "s"
	s eFileReg = ##Class(DHCEPRFS.Entity.EFileRegister).%New()
	s eFileReg.FullFileMasterName = "/pat1/epi1/epr/hdsd00.11/5.pdf"
	
	s retEFileReg = ..RegisterFile(eFileReg)
	
	s retEFileReg2 = ..GetRegisterFile(retEFileReg.FileMasterID)
	b
}

/// w ##Class(DHCEPRFS.BL.BLFileRegister).Test2()
ClassMethod Test2() As %String
{
	s fileMaster = "/2/2/epr/CG07_Single_2_2_2_507_0-0_0.pdf"
	s fileMaster = fileMaster_"^/2/2/epr/CG07_Multiple_2_2_4_627_0-0_0.pdf"
	s ret = ..RegFileList(fileMaster)
	q ret
}

/// Desc:	注册扫描文件
/// debug: w ##class(DHCEPRFS.BL.BLFileRegister).RegisterFileAlone("test1.tiff","md51","DHCEPRFS")
ClassMethod RegisterFileScan(AFileName As %String, AMD5Code As %String, ANameSpace As %String) As %String
{
	s dirMasterID = 0
	
	s fileMasterID = ##Class(DHCEPRFS.BL.BLFileMaster).AddFileMasterByDirAndFile(dirMasterID, AFileName, AMD5Code, ANameSpace)
	q:(fileMasterID = "") ""
	
	s fileLocName= ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(fileMasterID)
	
	q fileMasterID _"#"_fileLocName
}

}
