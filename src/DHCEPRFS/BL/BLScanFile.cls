Class DHCEPRFS.BL.BLScanFile Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod AddOneScanFile(AType As %String, AEpisodeID As %String, AFileName As %String, AFileMasterID As %String, AUserID As %String) As %String
{
	s objScanFile= ##class(DHCEPRFS.INST.ScanFile).%New()
	
	s objScanFile.Type=AType
	S objScanFile.EpisodeID= AEpisodeID
	s objScanFile.FileName=AFileName
	s objScanFile.FileMasterID= AFileMasterID
	s objScanFile.ActUserID= AUserID
	s objScanFile.ActDate=$p($h,",",1)
	s objScanFile.ActTime=$p($h,",",2)
	s objScanFile.OCRArrangeFlag="0"
	s objScanFile.ArrangeFlag="0"
	s sc =  objScanFile.%Save()
	
	if ($$$ISOK(sc))
	{
		q objScanFile.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod AddOneScanFileOP(AType As %String, AEpisodeID As %String, AFileName As %String, AFileMasterID As %String, AUserID As %String, AMRItemID As %String, AMRItemName As %String) As %String
{
	s objScanFile= ##class(DHCEPRFS.INST.ScanFile).%New()
	
	s objScanFile.Type=AType
	S objScanFile.EpisodeID= AEpisodeID
	s objScanFile.FileName=AFileName
	s objScanFile.FileMasterID= AFileMasterID
	s objScanFile.ActUserID= AUserID
	s objScanFile.ActDate=$p($h,",",1)
	s objScanFile.ActTime=$p($h,",",2)
	s objScanFile.OCRArrangeFlag="1"
	s objScanFile.ArrangeFlag = "0"
	s objScanFile.OCRMRItemID = AMRItemID
	s objScanFile.OCRMRItemName = AMRItemName
	s sc =  objScanFile.%Save()
	
	if ($$$ISOK(sc))
	{
		q objScanFile.%Id()
	}
	else
	{
		q ""
	}
}

/// debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLScanFile","GetScanList","TEMP^1",$zdh("2021-11-01",3))
Query GetScanList(AUserID As %String, AActDate As %Date) As %SQLQuery
{
SELECT a.EpisodeID,b.MedRecordNo,to_char(b.AdmDate,'yyyy-mm-dd') AdmDate,
to_char(b.DisDate,'yyyy-mm-dd') DisDate,Count(*) PageNums,max(A.acttime) MaxActTime FROM 
DHCEPRFS_INST.ScanFile A INNER JOIN DHCEPRFS_INST.MREpisode B ON A.EpisodeID=B.EpisodeID
WHERE A.ActUserID=:AUserID AND A.ActDate=:AActDate
GROUP BY a.EpisodeID,b.MedRecordNo,b.AdmDate,b.DisDate
ORDER BY MaxActTime DESC
}

/// Desc:	通过日志汇总每个操作者的打印工作量
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLScanFile","GetTopUnCategoryItem")
Query GetTopUnCategoryItem() As %Query(ROWSPEC = "ScanFileID:%String,EpisodeID:%String,MREpisodeID:%String,MRItemID:%String,TypeParams:%String,FileMasterID:%String,FTPPath:%String")
{
}

ClassMethod GetTopUnCategoryItemExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	s AEpisodeID =""
	s AOCRMRItemID = ""
	//获取最早的已识别，未分类的项目
	
	
	&sql(SELECT TOP 1 EpisodeID ,OCRMRItemID into :AEpisodeID,AOCRMRItemID FROM dhceprfs_inst.scanfile 
	WHERE ArrangeFlag='0' AND OCRArrangeFlag='1' AND OCRMRItemID IS NOT NULL AND OCRMRItemID<>'')
	
	q:(AEpisodeID ="") $$$OK
	
	//判断该就诊是否有未ocr识别的文件，如有，不进行分类操作。
	&sql(SELECT count(*) into :AUnOCRCount  FROM dhceprfs_inst.scanfile 
	WHERE EpisodeID =:AEpisodeID AND (OCRMRItemID IS  NULL OR  OCRMRItemID=''))
	q:(AUnOCRCount >0) $$$OK
	
	s MREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(AOCRMRItemID)
	s TypeParams=objMRItem.TypeParams
	
	//如果有扫描文件，直接取扫描文件和已识别未分类的文件，合并后分类上传；
	//没有扫描文件,取已识别未分类的文件，合并后分类上传；
	s MRVerItemID = ""
	s MRVerItemID = ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID(AEpisodeID,AOCRMRItemID)
	if (MRVerItemID '="")
	{
		s detailNum = ""
        s detailNum = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", MRVerItemID, detailNum),-1)
        if (detailNum '= "")
        {
            s subID = $O(^DHCEPRFS.INST.MRVerItemDetailI("IdxMain", MRVerItemID, detailNum, ""))    
            if (subID '= "")
            {
	            s MRVerItemDetailID = MRVerItemID_"||"_subID
            	s objMRVerItemDetail = ##Class(DHCEPRFS.INST.MRVerItemDetail).%OpenId(MRVerItemDetailID)
            	s FileMasterID = objMRVerItemDetail.FileMasterID
            	s FileLocPath = ##Class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID) 
            	s ^CacheTemp(repid,ind) = $lb("SCAN",AEpisodeID,MREpisodeID,AOCRMRItemID,TypeParams,FileMasterID,FileLocPath)
				s ind = ind + 1
            }
        }
	}
		
	s ScanFileID=""
	for
	{
		s ScanFileID = $o(^DHCEPRFS.INST.ScanFileI("IdxEpisodeMRItem"," "_AEpisodeID," "_AOCRMRItemID,ScanFileID))
		q:(ScanFileID = "")
		s objScanFile = ##class(DHCEPRFS.INST.ScanFile).%OpenId(ScanFileID)
		continue:(objScanFile.ArrangeFlag = "1" )	//只取回未分类的
		s FileMasterID = objScanFile.FileMasterID
		s FTPPath = ##class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterID)
		
		s ^CacheTemp(repid,ind) = $lb(ScanFileID,AEpisodeID,MREpisodeID,AOCRMRItemID,TypeParams,FileMasterID,FTPPath)
		s ind = ind + 1
	}
	
	Quit $$$OK
}

ClassMethod GetTopUnCategoryItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTopUnCategoryItemExecute ]
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

ClassMethod GetTopUnCategoryItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTopUnCategoryItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SetScanFileArranged(AScanFileIDs As %String, AIP As %String) As %String
{
	q:((AScanFileIDs= "") ||(AScanFileIDs= $c(0))) "0"
	s nowDate= $p($h,",",1)
	s nowTime= $p($h,",",2)
	
	s $zt = "OnSetScanFileArrangedErrHandler"
	
	s Flag="true"
	TSTART
	for i=1:1:$l(AScanFileIDs,"^")
	{
		s ScanFileID = $p(AScanFileIDs,"^",i)
		s objScanFile = ##class(DHCEPRFS.INST.ScanFile).%OpenId(ScanFileID)
		s objScanFile.ArrangeFlag = "1"
		s objScanFile.ArrangeDate = nowDate
		s objScanFile.ArrangeTime = nowTime
		s sc = objScanFile.%Save()
		if ('$$$ISOK(sc))
		{
			TROLLBACK
			s Flag="false"
			q
		}
	}
	
	if (Flag="false")
	{
		q "0"
	}
	else
	{
		TCOMMIT
		q "1"
	}
OnSetScanFileArrangedErrHandler
	TROLLBACK
	q "0"
}

/// Desc:	检查并且插入门诊病案号虚拟就诊
/// Debug：	w ##class(DHCEPRFS.BL.BLScanFile).CheckAndAddOPRecord("H1734886")
ClassMethod CheckAndAddOPRecord(AMedRecordNo As %String) As %String
{
	s AMedRecordNo = $zcvt(AMedRecordNo,"U")
	s PatientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPatientIDByMedRecord(AMedRecordNo)
	q:(PatientID="") "0"	//没有患者信息返回0
	
	s EpisodeID="VEM" _ AMedRecordNo
	
	s MREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(EpisodeID,"DHC")
	if (MREpisodeID = "")	//需要新建临时就诊
	{
		s MRPatientID = ##class(DHCEPRFS.BL.BLMRPatient).RegMRPatByMedRecord(PatientID,AMedRecordNo,"DHC")
		q:(MRPatientID="") "0"
		s MRMedRecordID	= ##class(DHCEPRFS.BL.BLMRMedRecord).RegMRMedRecord(MRPatientID, AMedRecordNo,"DHC")	
		q:(MRMedRecordID="") "0"
		s MREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).AssignFSMREpisodeOP(MRPatientID,MRMedRecordID,"","","","","","","",EpisodeID)
		if (MREpisodeID="") 
		{ q "0"}
		else
		{ q EpisodeID}
	}
	else
	{
		q EpisodeID
	}
}

/// Desc:	通过病案号获取患者姓名
/// Debug：	w ##class(DHCEPRFS.BL.BLScanFile).GetNameByMedrecordNo("H1734886")
ClassMethod GetNameByMedrecordNo(AMedRecordNo As %String)
{
	s AMedRecordNo = $zcvt(AMedRecordNo,"U")
	s PatientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPatientIDByMedRecord(AMedRecordNo)
	q:(PatientID="") ""
	
	s PatientName =##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetName(PatientID)
	q PatientName
}

}
