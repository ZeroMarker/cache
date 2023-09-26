Class DHCEPRFS.BL.BLOCRService Extends %RegisteredObject
{

/// Debug : w ##class(DHCEPRFS.BL.BLOCRService).GetNeedOcrFileMaster()
ClassMethod GetNeedOcrFileMaster() As %String
{
	s ScanFileId = $O(^DHCEPRFS.INST.ScanFileI("IdxOnNeedOcr"," 0"," I",""))
	q:(ScanFileId="") ""
	s obj = ##class(DHCEPRFS.INST.ScanFile).%OpenId(ScanFileId)
	s FileMasterId = obj.FileMasterID
	s ftpInfo = ##class(DHCEPRFS.BL.BLFileMaster).GetFullFileLocName(FileMasterId)
	q ScanFileId_"@@@"_ftpInfo
}

ClassMethod UpdateOcrScanFile(AID, AScanItem, AScanId, AMedRecordNo) As %String
{
	
	s obj = ##class(DHCEPRFS.INST.ScanFile).%OpenId(AID)
	s obj.OCRArrangeFlag = "1"
	s:(+AScanId=0) obj.OCRArrangeFlag="-1"
	s obj.OCRCompleteDate = $P($H,",",1)
	s obj.OCRCompleteTime = $P($H,",",2)
	s obj.OCRMRItemName = AScanItem
	s obj.OCRMRItemID = AScanId
	s obj.OCRMedRecordNo = AMedRecordNo
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q "1"
	}
	q "0"
}

ClassMethod RecognizeOCRContent(AOCRContent As %String) As %String
{
	s ocrId = ""
	s ocrItem = ""
	s res = ""
	f
	{
		s ocrId = $O(^DHCEPRFS.META.MRItemD(ocrId))
		q:(ocrId="")
		s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(ocrId)
		s ocrTitle = obj.OCRArrangeTitle
		s len = $L(ocrTitle,"^")
		f i=1:1:len
		{
			s ocrTitleTmp = $P(ocrTitle,"^",i)
			i (ocrTitleTmp=AOCRContent)
			{
				s res = ocrId_"^"_obj.Name
				q	
			}
		}
		/**i (obj.OCRArrangeTitle [ AOCRContent)
		{
			s res = ocrId_"^"_obj.Name
			
		}*/
		s obj = ""
		q:(res'="")
	}
	q res
}

/// 查询自动归档结果 2021-12-23 ys
/// Return: 前面都是分类失败的，EpisodeID,FileMasterID;最后两个为成功总页数与失败总页数
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLOCRService","GetOcrResultByDate","2021-11-1","2021-11-16")
Query GetOcrResultByDate(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "EpisodeID:%String,MedEpisodeID:%String,Count:%String")
{
}

ClassMethod GetOcrResultByDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(AStartDate = "") $$$OK
	q:(AEndDate = "") $$$OK
 	s start = $zdh(AStartDate,3)
 	s end = $zdh(AEndDate,3)
 	s episodeid = ""
	s filemasterid = ""
	s ocrmritemid = ""
	s oldEpisode = ""
	s medEpisodeId = ""
	
	
	//归档成功信息
	s successTotalCount = 0
	&sql(SELECT COUNT(*) INTO :successTotalCount FROM dhceprfs_inst.scanfile WHERE ArrangeFlag ='1' AND ArrangeDate BETWEEN :start AND :end)
	//归档失败信息
	s fatalEpisodeIds = ""
	s fatalMrEpisodeIds = ""
	s fatalTotalCount = 0
	&sql(DECLARE FatalCursor CURSOR FOR
 		SELECT DISTINCT EpisodeID INTO :fatalEpisodeIds 
 		FROM dhceprfs_inst.scanfile WHERE 
 		ArrangeFlag='0' AND ArrangeDate BETWEEN :start AND :end)
 	&sql(OPEN FatalCursor)
 	f
 	{
	 	&sql(FETCH FatalCursor)
	 	q:SQLCODE
	 	s mrEpisode = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(fatalEpisodeIds,"DHC")
	 	s tmpFatalCount = ""
	 	&sql(SELECT COUNT(*) INTO :tmpFatalCount FROM dhceprfs_inst.filetemporary WHERE MREpisodeID = :mrEpisode AND Status = '0')
	 	i (+tmpFatalCount'=0)
	 	{
		 	s medEpisodeId = ##class(DHCEPRFS.BL.BLMREpisode).GetMedRecordNoByMrEpisodeID(mrEpisode)
		 	s ^CacheTemp(repid,ind)=$lb(fatalEpisodeIds,medEpisodeId,tmpFatalCount)
	    	s ind=ind+1
	    	s fatalTotalCount = fatalTotalCount+tmpFatalCount
		 }
	 }	
	 &sql(CLOSE FatalCursor)
	
	
   s success = $lb("","",successTotalCount)
   s ^CacheTemp(repid,ind)=success
   s ind=ind+1
   s eror = $lb("","",fatalTotalCount)
   s ^CacheTemp(repid,ind)=eror
   s ind=ind+1
   q $$$OK
}

ClassMethod GetOcrResultByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOcrResultByDateExecute ]
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

ClassMethod GetOcrResultByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOcrResultByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Create: 2021-12-23 ys
/// Desc:获取历史扫描过的MrEpisodeIds^ActDate^ActTime
/// Debug: w ##class(DHCEPRFS.BL.BLOCRService).GetScanEpisodeHisByDate("2021-11-1","00:00:00","2021-11-16","23:59:59")
ClassMethod GetScanEpisodeHisByDate(AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String) As %String
{
	
	s res = ""
	s tmpMrEpisodeId = ""
	s tmpScanDate = ""
	s tmpScanTime = ""
	i (AStartDate'=AEndDate)
	{
		&sql(DECLARE ScanDateCursor CURSOR FOR
		SELECT ActDate,ActTime,MREpisodeID INTO :tmpScanDate,:tmpScanTime,:tmpMrEpisodeId FROM dhceprfs_inst.mrlogdetail WHERE 
		ActDate BETWEEN :AStartDate AND :AEndDate 
		AND MRAction ="Scan"
		GROUP BY MREpisodeID)
		&sql(OPEN ScanDateCursor)
		f
		{
			&sql(FETCH ScanDateCursor)
			q:SQLCODE
			s res = res_tmpMrEpisodeId_"|"_$zd(tmpScanDate,3)_"|"_$zt(tmpScanTime,1)_"^"
		}
		&sql(CLOSE ScanDateCursor)
		s res = $E(res,0,*-1)
		q res
		
	}
	else
	{
		s date = $zd(AStartDate,3)
		&sql(DECLARE ScanTimeCursor CURSOR FOR
		SELECT ActTime,MREpisodeID INTO :tmpScanTime,:tmpMrEpisodeId FROM dhceprfs_inst.mrlogdetail WHERE 
		ActDate = :AStartDate AND
		ActTime BETWEEN :AStartTime AND :AEndTime
		AND MRAction ="Scan"
		GROUP BY MREpisodeID)
		&sql(OPEN ScanTimeCursor)
		f
		{
			&sql(FETCH ScanTimeCursor)
			q:SQLCODE
			s res = res_tmpMrEpisodeId_"|"_date_"|"_$zt(tmpScanTime,1)_"^"
		}
		&sql(CLOSE ScanTimeCursor)
		s res = $E(res,0,*-1)
		q res
	}
}

/// Create: 2021-12-23 ys 查询一段时间内的扫描归档结果
/// debug do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLOCRService","GetArchiveResultByDateTime","2021-11-1","00:00:00","2021-11-16","23:59:59")
Query GetArchiveResultByDateTime(AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AMedRecord As %String) As %Query(ROWSPEC = "Type:%String,EpisodeID:%String,PaadmType:%String,MedEpisodeID:%String,Count:%String,DateTime:%String")
{
}

ClassMethod GetArchiveResultByDateTimeExecute(ByRef qHandle As %Binary, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AMedRecord As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(AStartDate = "") $$$OK
	q:(AEndDate = "") $$$OK
	q:(AStartTime="") $$$OK
	q:(AEndTime="") $$$OK
	s startDate = $zdh(AStartDate,3)
	s startTime = $zth(AStartTime,3)
	s endDate = $zdh(AEndDate,3)
	s endTime = $zth(AEndTime,3)
	s medRecord = $G(AMedRecord)
	s ocrFatalID = $P(..GetDefaultUnOCRType(),"^",1)
	i (medRecord'="")
	{
		i ((+medRecord'=0) || (medRecord["H") || (medRecord["h"))
		{
			s tmpMrEpisodeId = ""
		
			&sql(select ID into :tmpMrEpisodeId from dhceprfs_inst.mrepisode where MedRecordNo = :medRecord order by CreateDate desc)
			q:(tmpMrEpisodeId="") $$$OK
			
			i (startDate'=endDate)
			{
				
				d GetDataByEpisodeDate
			}
			else
			{
			
				d GetDataByEpisodeTime
			
			}
		
			q $$$OK
		}
	}
	
 	s mrEpisodeInfo = ..GetScanEpisodeHisByDate(startDate,startTime,endDate,endTime)
 	
 	q:(mrEpisodeInfo="") $$$OK
 	s mrEpisodeIndex = 1
 	s tmpMrEpisodeId = ""
 	s tmpScanDateTime= ""
 	s episodeId = ""
 	
 	f
 	{
	 	s tmpMrEpisodeInfo = $P(mrEpisodeInfo,"^",mrEpisodeIndex)
	 	s tmpMrEpisodeId = $P(tmpMrEpisodeInfo,"|",1)
	 	s tmpScanDateTime = $P(tmpMrEpisodeInfo,"|",2)_" "_$P(tmpMrEpisodeInfo,"|",3)
	 	
		q:(tmpMrEpisodeId="")
		
		s mrEpisodeIndex = mrEpisodeIndex+1	
		i (startDate'=endDate)
		{
			d GetDataByEpisodeDate
		}
		else
		{
			
			d GetDataByEpisodeTime
		}
	}
   q $$$OK
GetDataByEpisodeDate
	s medEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMedRecordNoByMrEpisodeID(tmpMrEpisodeId)
	q:((medEpisodeID'=medRecord) && (+medRecord'=0))
 	s episodeId = ##class(DHCEPRFS.BL.BLMREpisode).GetEpisodeIDByMrEpisodeID(tmpMrEpisodeId)
 	s paadmType = $p($g(^PAADM(episodeId)),"^",2)
 	s paadmTypeDesc = "住院"
 	s:(paadmType="O") paadmTypeDesc = "门诊"  
	s mrItemId = ""
	s success = ""
	s successCount = 0
	s tmpArchiveCount1=0
	s tmpFatalCount1 = 0
	s tmpFatalCount2 = 0
	&sql(DECLARE ArchiveDateCursor2 Cursor FOR
		SELECT MRItemID,TotCount INTO:mrItemId,:tmpArchiveCount1 FROM dhceprfs_inst.mrveritem WHERE MRVersionID=(SELECT ID FROM dhceprfs_Inst.mrversion WHERE MREpisodeID = :tmpMrEpisodeId)
	)
	&sql(OPEN ArchiveDateCursor2)
	f
	{
		&sql(FETCH ArchiveDateCursor2)
		q:SQLCODE
		i (mrItemId=ocrFatalID)
		{
			s tmpFatalCount1 = tmpArchiveCount1
			continue
		}
		s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(+mrItemId)
		
		s success = success_objMRItem.Name_tmpArchiveCount1_"页^"
			
		s successCount = successCount+1
		s objMRItem = ""
	}
	&sql(CLOSE ArchiveDateCursor2)
	i (+successCount'=0)
	{
		
		s ^CacheTemp(repid,ind)=$lb("1",episodeId,paadmTypeDesc,medEpisodeID,"归档成功:"_successCount_"个,分别为:"_$E(success,0,*-1),tmpScanDateTime)
   		s ind=ind+1
	}
	&sql(SELECT COUNT(*) INTO :tmpFatalCount2 FROM dhceprfs_inst.filetemporary WHERE CreateDate  BETWEEN :startDate AND :endDate  AND MrEpisodeID = :tmpMrEpisodeId AND Status = '0')
	i ((+tmpFatalCount1'=0) || (+tmpFatalCount2'=0))
	{
		s fatalStr = ""
		s:(+tmpFatalCount1'=0) fatalStr = fatalStr_"S未识别"_tmpFatalCount1_"页;"
		s:(+tmpFatalCount2'=0) fatalStr = fatalStr_"S未分类"_tmpFatalCount2_"页"
		i (fatalStr'="")
		{
			s ^CacheTemp(repid,ind)=$lb("0",episodeId,paadmTypeDesc,medEpisodeID,fatalStr,tmpScanDateTime)
   			s ind=ind+1
		}
	}
	
	
GetDataByEpisodeTime
	q:(startDate'=endDate)
 	s medEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMedRecordNoByMrEpisodeID(tmpMrEpisodeId)
 	q:((medEpisodeID'=medRecord) && (+medRecord'=0))
 	s episodeId = ##class(DHCEPRFS.BL.BLMREpisode).GetEpisodeIDByMrEpisodeID(tmpMrEpisodeId)
 	s paadmType = $p($g(^PAADM(episodeId)),"^",2)
 	s paadmTypeDesc = "住院"
 	s:(paadmType="O") paadmTypeDesc = "门诊" 
	s mrItemId = ""
	s success = ""
	s successCount = 0
	s tmpArchiveCount=0
	
	
	
	s tmpFatalCount1 = 0
	s tmpFatalCount2 = 0
	
	
	
	&sql(DECLARE ArchiveTimeCursor2 Cursor FOR
		SELECT MRItemID,TotCount INTO:mrItemId,:tmpArchiveCount FROM dhceprfs_inst.mrveritem WHERE MRVersionID=(SELECT ID FROM dhceprfs_Inst.mrversion WHERE MREpisodeID = :tmpMrEpisodeId)
	)
	&sql(OPEN ArchiveTimeCursor2)
	f
	{
		&sql(FETCH ArchiveTimeCursor2)
		q:SQLCODE
		i (mrItemId=ocrFatalID)
		{
			s tmpFatalCount1 = tmpArchiveCount
			continue
		}
		s objMRItem = ##class(DHCEPRFS.META.MRItem).%OpenId(+mrItemId)
		s success = success_objMRItem.Name_tmpArchiveCount_"页^"
			s successCount = successCount+1
		s objMRItem = ""
	}
	
	&sql(CLOSE ArchiveTimeCursor2)
	i (+successCount'=0)
	{
		
		s ^CacheTemp(repid,ind)=$lb("1",episodeId,paadmTypeDesc,medEpisodeID,"归档成功:"_successCount_"个,分别为:"_$E(success,0,*-1),tmpScanDateTime)
   		s ind=ind+1
	}
	

	
	&sql(SELECT COUNT(*) INTO :tmpFatalCount2 FROM dhceprfs_inst.filetemporary WHERE CreateDate =:startDate AND CreateTime BETWEEN :startTime AND :endTime AND MrEpisodeID = :tmpMrEpisodeId AND Status = '0')
	
	
	
	i ((+tmpFatalCount1'=0) || (+tmpFatalCount2'=0))
	{
		s fatalStr = ""
		s:(+tmpFatalCount1'=0) fatalStr = fatalStr_"S未识别"_tmpFatalCount1_"页;"
		s:(+tmpFatalCount2'=0) fatalStr = fatalStr_"S未分类"_tmpFatalCount2_"页"
		i (fatalStr'="")
		{
			
			s ^CacheTemp(repid,ind)=$lb("0",episodeId,paadmTypeDesc,medEpisodeID,fatalStr,tmpScanDateTime)
   			s ind=ind+1
		}
	}
}

ClassMethod GetArchiveResultByDateTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArchiveResultByDateTimeExecute ]
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

ClassMethod GetArchiveResultByDateTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArchiveResultByDateTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 获取分类为S未识别
ClassMethod GetDefaultUnOCRType() As %String
{
	s id = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("OCREmptyItemID")
	q:(id="") ""
	s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(id)
	q:(obj="") ""
	s Name = obj.Description
	q id_"^"_Name
}

}
