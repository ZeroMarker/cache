Class DHCEPRFS.BL.BLFileTemporary Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: w ##class(DHCEPRFS.BL.BLFileTemporary).RegisterOneTempFile("49","159","1^/TemporaryFile/TSF_49_d035bdd73b3b7cf4_201712121607334182_1.pdf")
ClassMethod RegisterOneTempFile(AMREpisodeID As %String, AUserID As %String, AFileInfo As %String) As %String
{
	s:(AFileInfo = $c(0)) AFileInfo = ""
	//取当前时间
	s nowDate = $p($h,",",1)
	s nowTime = $p($h,",",2)
	
	s orderNum=$p(AFileInfo,"^",1)
	s filePath=$p(AFileInfo,"^",2)
	s fileName=$p(filePath,"/",$l(filePath,"/"))
	
	s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%New()
	s objFileTemporary.MREpisodeID=AMREpisodeID
	s objFileTemporary.OrderNum=orderNum
	s objFileTemporary.FileName=fileName
	s objFileTemporary.FilePath =filePath
	s objFileTemporary.CreateDate=nowDate
	s objFileTemporary.CreateTime=nowTime
	s objFileTemporary.UserID=AUserID
	s objFileTemporary.Status="0"
	s sc=objFileTemporary.%Save()
	if $$$ISERR(sc)
	{	
		q "-1"
	}
	else
	{
		q "1"	
	}
}

/// Creator:yangpeng
/// CreateDate:2016-09-22
/// Desc:保存某次就诊的未分类文件，根据传入的FileInfo，增加新加入的，删除FileInfo里面没有的，并返回删除文件列表给客户端
/// Debug:w ##class(DHCEPRFS.BL.BLFileTemporary).RegisterTempFiles("29","159","")
ClassMethod RegisterTempFiles(AMREpisodeID As %String, AUserID As %String, AFileInfo As %String) As %String
{
	//s ^CacheTemp("yangpengTest","AFileInfo")=AFileInfo
	s:(AFileInfo = $c(0)) AFileInfo = ""
	s ret=""
	//取当前时间
	s nowDate = $p($h,",",1)
	s nowTime = $p($h,",",2)
	
	//将当前的FileList加入Array
	s arrFiles=##class(%ArrayOfDataTypes).%New()
	s FileTemporaryID=""
	for {
		s FileTemporaryID = $o(^DHCEPRFS.INST.FileTemporaryI("IdxMREpisodeID"," "_AMREpisodeID,FileTemporaryID))
		q:(FileTemporaryID="")
		s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
		continue:(objFileTemporary.Status '= "0" )
		d arrFiles.SetAt(objFileTemporary.%Id(),objFileTemporary.FileName)
	}
	
	TSTART
	s $zt = "OnRegisterTempFilesHandler"
	s flag="true"
	//处理传入的FileInfo
	if (AFileInfo'="")
	{
		for i=1:1:$l(AFileInfo,"|")
		{
			//Order^FileName
			s oneFile=$p(AFileInfo,"|",i)
			s orderNum=$p(oneFile,"^",1)
			s filePath=$p(oneFile,"^",2)
			s fileName=$p(filePath,"/",$l(filePath,"/"))
			
			if (arrFiles.IsDefined(fileName)="0")	//未在列表中则新增
			{
				s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%New()
				s objFileTemporary.MREpisodeID=AMREpisodeID
				s objFileTemporary.OrderNum=orderNum
				s objFileTemporary.FileName=fileName
				s objFileTemporary.FilePath =filePath
				s objFileTemporary.CreateDate=nowDate
				s objFileTemporary.CreateTime=nowTime
				s objFileTemporary.UserID=AUserID
				s objFileTemporary.Status="0"
				s sc=objFileTemporary.%Save()
				if $$$ISERR(sc)
				{	
					s flag="false"
					q
				}
			}
			else
			{
				//在列表中需要判断OrderNum，如发生改变更新之；并在列表中删除该File
				s FileTemporaryID=arrFiles.GetAt(fileName)
				s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
				if (objFileTemporary.OrderNum'=orderNum)
				{
					s objFileTemporary.OrderNum=orderNum
					s sc=objFileTemporary.%Save()
					if $$$ISERR(sc)
					{	
						s flag="false"
						q
					}
				}
				d arrFiles.RemoveAt(fileName)
			}
		}
	}
	if (flag="false")
	{
		TROLLBACK
		q "-1"
	}
	
	//返回需要删除的FileName
	s key=""
	for {
		s key=arrFiles.Next(key)
	 	q:(key="")
	 	s FileTemporaryID=arrFiles.GetAt(key)
	 	s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
	 	s objFileTemporary.Status="1"
	 	s sc=objFileTemporary.%Save()
	 	if $$$ISERR(sc)
		{	
			s flag="false"
			q
		}
	 	if (ret="")
	 	{	s ret=key	}
	 	else
	 	{	s ret=ret_"^"_key	}
	}
	
	if (flag="false")
	{
		TROLLBACK
		q "-1"
	}
	else
	{
		TCOMMIT
		q ret
	}

OnRegisterTempFilesHandler
	TROLLBACK
	q "-1"
}

/// Creator:yangpeng
/// CreateDate:2017-01-07 2021-8-12
/// Desc:保存某次就诊的未分类文件，根据传入的FileInfo，增加新加入的，删除FileInfo里面没有的，并返回删除文件列表给客户端
/// Return: 返回FileName#IP|VirtualDir|FtpPath#FTPConfig
/// Debug:w ##class(DHCEPRFS.BL.BLFileTemporary).RegisterTempFiles("29","159","")
ClassMethod RegisterTempFilesByList(AMREpisodeID As %String, AUserID As %String, AFileInfo As DHCEPRFS.ExtDS.CustomList) As %ListOfDataTypes
{
	s listRet=##class(%ListOfDataTypes).%New()	//需要返回的List

	s ret=""
	//取当前时间
	s nowDate = $p($h,",",1)
	s nowTime = $p($h,",",2)
	
	//将当前的FileList加入Array
	s arrFiles=##class(%ArrayOfDataTypes).%New()
	s FileTemporaryID=""
	for {
		s FileTemporaryID = $o(^DHCEPRFS.INST.FileTemporaryI("IdxMREpisodeID"," "_AMREpisodeID,FileTemporaryID))
		q:(FileTemporaryID="")
		s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
		continue:(objFileTemporary.Status '= "0" )
		d arrFiles.SetAt(objFileTemporary.%Id(),objFileTemporary.FileName)
	}
	
	TSTART
	s $zt = "OnRegisterTempFilesHandler"
	s flag="true"
	//处理传入的FileInfo
	for i=1:1:AFileInfo.Count()
	{
		//Order^FileName
		s oneFileG=AFileInfo.GetAt(i)
		s oneFile = oneFileG.Read()
		s orderNum=$p(oneFile,"^",1)
		s filePath=$p(oneFile,"^",2)
		s fileName=$p(filePath,"/",$l(filePath,"/"))
			
		if (arrFiles.IsDefined(fileName)="0")	//未在列表中则新增
		{
			s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%New()
			s objFileTemporary.MREpisodeID=AMREpisodeID
			s objFileTemporary.OrderNum=orderNum
			s objFileTemporary.FileName=fileName
			s objFileTemporary.FilePath =filePath
			s objFileTemporary.CreateDate=nowDate
			s objFileTemporary.CreateTime=nowTime
			s objFileTemporary.UserID=AUserID
			s objFileTemporary.Status="0"
			s sc=objFileTemporary.%Save()
			if $$$ISERR(sc)
			{	
				s flag="false"
				q
			}
		}
		else
		{
			//在列表中需要判断OrderNum，如发生改变更新之；并在列表中删除该File
			s FileTemporaryID=arrFiles.GetAt(fileName)
			s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
			if (objFileTemporary.OrderNum'=orderNum)
			{
				s objFileTemporary.OrderNum=orderNum
				s sc=objFileTemporary.%Save()
				if $$$ISERR(sc)
				{	
					s flag="false"
					q
				}
			}
			d arrFiles.RemoveAt(fileName)
		}
	}
		
	if (flag="false")
	{
		TROLLBACK
		q ""
	}
	
	//返回需要删除的FileName
	s key=""
	for {
		s key=arrFiles.Next(key)
	 	q:(key="")
	 	s FileTemporaryID=arrFiles.GetAt(key)
	 	s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
	 	s objFileTemporary.Status="1"
	 	s fileStoreConfig = ##class(DHCEPRFS.BL.BLFileStoreConfig).GetFileStoreConfig(objFileTemporary.CreateDate,"DHCEPRFS")
		s ftpConfig =$p(fileStoreConfig,"@@@",1)
		//filePath修改为带虚拟路径的全路径，首个字符不能是/ 20220925
		s virtualDir = $p($p(fileStoreConfig,"@@@",2),"|",2)
		//去掉第一个字符"/"
		s virtualDir = $e(virtualDir,2,$l(virtualDir))
		//拼接ftp路径 virtual默认后面不带/,FileLocName前面带/
		s filePath = virtualDir_objFileTemporary.FilePath
		if $e(filePath,1,1)="/"
		{ 
			s filePath = $e(filePath,2,$l(filePath))
		}
		s oneFileRet = objFileTemporary.FileName_"#"_filePath_"#"_ftpConfig
	 	s sc=objFileTemporary.%Save()
	 	if $$$ISERR(sc)
		{	
			s flag="false"
			q
		}
		d listRet.Insert(oneFileRet)	//将需要删除的FileName加入List中
	}
	
	if (flag="false")
	{
		TROLLBACK
		q ""
	}
	else
	{
		TCOMMIT
		if (listRet.Count()=0)	//如果ListRet为空，增加一行“OK”，客户端识别为成功
		{
			d listRet.Insert("OK")
		}
		q listRet
	}

OnRegisterTempFilesHandler
	TROLLBACK
	q ""
}

/// Creator:yangpeng
/// CreateDate:2016-09-21
/// Desc:获取某MREpisodeID存储在临时空间的文件列表
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLFileTemporary","GetTempFiles","1")
Query GetTempFiles(AMREpisodeID As %String) As %Query(ROWSPEC = "OrderNum:%Integer,FilePath:%String") [ SqlProc ]
{
}

ClassMethod GetTempFilesExecute(ByRef qHandle As %Binary, AMREpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s FileTemporaryID = ""
 	for { 
	 	s FileTemporaryID = $o(^DHCEPRFS.INST.FileTemporaryI("IdxMREpisodeID"," "_AMREpisodeID,FileTemporaryID))
	 	q:(FileTemporaryID = "")
	 	s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
	 	continue:(objFileTemporary.Status '= "0" )
		
		//通过创建日期获取当时的fileStore参数 格式:edtftp^127.0.0.1^21^Anonymous^^5@@@127.0.0.1|/
		s fileStoreConfig = ##class(DHCEPRFS.BL.BLFileStoreConfig).GetFileStoreConfig(objFileTemporary.CreateDate,"DHCEPRFS")
		s ftpConfig =$p(fileStoreConfig,"@@@",1)
		//filePath修改为带虚拟路径的全路径，首个字符不能是/ 20220925 ftpconfig@@@ftpPath
		s virtualDir = $p($p(fileStoreConfig,"@@@",2),"|",2)
		//去掉第一个字符"/"
		s virtualDir = $e(virtualDir,2,$l(virtualDir))
		//拼接ftp路径 virtual默认后面不带/,FileLocName前面带/
		s filePath = virtualDir_objFileTemporary.FilePath
		if $e(filePath,1,1)="/"
		{ 
			s filePath = $e(filePath,2,$l(filePath))
		}
		//s filePath = fileStoreConfig_"|"_objFileTemporary.FilePath
		s filePath = ftpConfig_"@@@"_filePath
		s data = $lb(objFileTemporary.OrderNum,filePath)
	    s ^CacheTemp(repid,ind)=data
	    s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetTempFilesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempFilesExecute ]
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

ClassMethod GetTempFilesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempFilesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:yangpeng
/// CreateDate:2016-10-18
/// Desc:设置文件为已删除状态
/// Debug:w ##class(DHCEPRFS.BL.BLFileTemporary).SetTempFileDelete("29","TSF_29_F4F2C9271ED313BC_201610141658396562_1.PDF")
ClassMethod SetTempFileDelete(AMREpisodeID As %String, AFileName As %String) As %String
{
	s FileTemporaryID = ""
	s FileTemporaryID = $o(^DHCEPRFS.INST.FileTemporaryI("IdxFileName"," "_$ZCVT(AFileName,"U"),FileTemporaryID))
	
	q:(FileTemporaryID="") "-1"
	s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
	s objFileTemporary.Status="2"
	s sc=objFileTemporary.%Save()
	if $$$ISERR(sc)
	{	q "-1"	}
	else
	{	q "1"	}
}

/// Creator:yangpeng
/// CreateDate:2016-10-18
/// Desc:获取MREpisode是否有扫描未分类文件
/// Debug:w ##class(DHCEPRFS.BL.BLFileTemporary).HasScanFile()
ClassMethod HasScanFile(AMREpisodeID As %String) As %String
{
	s ret="0"
	s FileTemporaryID=""
	for {
		s FileTemporaryID=$o(^DHCEPRFS.INST.FileTemporaryI("IdxMREpisodeID"," "_AMREpisodeID,FileTemporaryID))
		q:(FileTemporaryID="")
		s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
		if (objFileTemporary.Status="0")
		{
			s ret="1"
			q
		}
	}
	q ret
}

ClassMethod DeleteTempFilesByList(AFileInfo As DHCEPRFS.ExtDS.CustomList) As %String
{
	for i=1:1:AFileInfo.Count()
	{
		//Order^FileName
		s oneFileStream=AFileInfo.GetAt(i)
		s oneFile = oneFileStream.Read()
		s FileTemporaryID = ""
		s FileTemporaryID = $o(^DHCEPRFS.INST.FileTemporaryI("IdxFileName"," "_$ZCVT(oneFile,"U"),FileTemporaryID))
	
		if (FileTemporaryID '= "")
		{
			s objFileTemporary=##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
			s objFileTemporary.Status="2"
			s sc=objFileTemporary.%Save()
		}
	}
	q "1"
}

/// Creator:	yangpeng
/// Date:		2021-8-12
/// Input:		AFileInfo 临时文件名集合 单文件格式:/TemporaryFile/TSF_1_93a0e7a065385787_202108110057438179_1.pdf
/// Output:		ftp存储路径和ftp参数
/// Desc:		根据文件名返回临时文件的存储路径和ftp参数 是否保存(Y/N)#IP|VirtualDir|FtpPath#FTPConfig
/// Debug:		w ##class(DHCEPRFS.BL.BLFileTemporary).GetTempFilePathByList()
ClassMethod GetTempFilePathByList(AFileInfo As DHCEPRFS.ExtDS.CustomList) As DHCEPRFS.ExtDS.CustomList
{
	s retList =##class(DHCEPRFS.ExtDS.CustomList).%New()
	for i=1:1:AFileInfo.Count()
	{
		s oneFilePathG=AFileInfo.GetAt(i)
		s oneFilePath = oneFilePathG.Read()
		s oneRealFile=$p(oneFilePath,"/",3)
		s FileTemporaryID = ""
		s FileTemporaryID = $o(^DHCEPRFS.INST.FileTemporaryI("IdxFileName"," "_$zcvt(oneRealFile,"U"),""))
		s SavedFlag =""
		if (FileTemporaryID = "")
		{
			//未存储，则用当日的配置
			s StoreDate = $p($h,",",1)
			s SavedFlag ="N"
		}
		else
		{
			//已存储，取存储当日的配置
			s objFileTemporary = ##class(DHCEPRFS.INST.FileTemporary).%OpenId(FileTemporaryID)
			s StoreDate = objFileTemporary.CreateDate
			s SavedFlag ="Y"
		}
		
		s fileStoreConfig = ##class(DHCEPRFS.BL.BLFileStoreConfig).GetFileStoreConfig(StoreDate,"DHCEPRFS")
		s ftpConfig =$p(fileStoreConfig,"@@@",1)
		//filePath修改为带虚拟路径的全路径，首个字符不能是/ 20220925 ftpconfig@@@ftpPath
		s virtualDir = $p($p(fileStoreConfig,"@@@",2),"|",2)
		//去掉第一个字符"/"
		s virtualDir = $e(virtualDir,2,$l(virtualDir))
		//拼接ftp路径 virtual默认后面不带/,FileLocName前面带/
		s filePath = virtualDir_oneFilePath
		if $e(filePath,1,1)="/"
		{ 
			s filePath = $e(filePath,2,$l(filePath))
		}
		s ftpParam =SavedFlag_"#"_filePath_"#"_ftpConfig
		s ftpParamStream = ##class(%GlobalCharacterStream).%New()
		d ftpParamStream.Write(ftpParam)
		d retList.Insert(ftpParamStream)
	}
	q retList
}

}
