/// 名称: 	EPRservice.BLPreviewChecker
/// 描述: 	检查病历预览图片是否正确生成，补充生成病历预览图片
/// 编写者:	houjian
/// 日期:	2011-04-08
Class EPRservice.BLPreviewChecker Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	取指定创建日期的EPRLogs信息
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.BLPreviewChecker","GetLogInfoByCreateDate","2011-2-28")
ClassMethod GetLogInfoByCreateDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogInfoByCreateDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetLogInfoByCreateDateExecute(ByRef qHandle As %Binary, ACreateDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s blankDate = " "_$zdh(ACreateDate, 3)
	s blankTime = ""
	for {
		s blankTime = $O(^DHCEPRI.EPRLogsI("IdxCreateDateTime",blankDate,blankTime))
		q:(blankTime = "")
		
		s blankEpisodeID = ""
		for {
			s blankEpisodeID = $O(^DHCEPRI.EPRLogsI("IdxCreateDateTime",blankDate,blankTime,blankEpisodeID))
			q:(blankEpisodeID = "")
			
			s blankPrintDocID = ""
			for {
				s blankPrintDocID = $O(^DHCEPRI.EPRLogsI("IdxCreateDateTime",blankDate,blankTime,blankEpisodeID,blankPrintDocID))
				q:(blankPrintDocID = "")
			
				s PrintDocID = $e(blankPrintDocID, 2, $L(blankPrintDocID))
				s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(PrintDocID)
				continue:(objEPRTemplateCategory = "")
				s PrintTemplateID = objEPRTemplateCategory.BindPrnTemplateID
				continue:(PrintTemplateID = "")
				s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(PrintTemplateID)
				continue:(objPrintTemplate = "")
				s PrintType = objPrintTemplate.ChartItemType
				continue:(PrintType = "")
				
				s eprNum = 0
				for {
					s eprNum = $O(^DHCEPRI.EPRLogsI("IdxCreateDateTime",blankDate,blankTime,blankEpisodeID,blankPrintDocID,eprNum))
					q:(eprNum = "")
					
					s EPRLogsID = $O(^DHCEPRI.EPRLogsI("IdxCreateDateTime",blankDate,blankTime,blankEpisodeID,blankPrintDocID,eprNum,""))
					continue:(EPRLogsID = "")
					s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(EPRLogsID)
					continue:(objEPRLogs = "")
					
					s UserID = 	objEPRLogs.CreateUserID
					s EpisodeID = $e(blankEpisodeID, 2, $L(blankEpisodeID))
					s PatientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
					s InstanceID = ""
					if (PrintType = "Multiple")
					{
						s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",blankEpisodeID," ML"_PrintDocID,""))
						continue:(ecRecordID = "")
						s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID," "_eprNum,""))
						continue:(childSub = "")
						s InstanceID = ecRecordID_"||"_childSub
					}
					s ^CacheTemp(repid, ind) = $LB(PatientID,EpisodeID,EPRLogsID,PrintType,PrintTemplateID,PrintDocID,InstanceID,UserID)
					s ind = ind + 1	
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod GetLogInfoByCreateDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogInfoByCreateDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetLogInfoByCreateDate(ACreateDate As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,EPRLogsID:%String,PrintType:%String,PrintTemplateID:%String,PrintDocID:%String,InstanceID:%String,UserID:%String")
{
}

/// Desc:	取指定病人 或 指定就诊的EPRLogs信息
ClassMethod GetLogInfoByPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogInfoByPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetLogInfoByPatExecute(ByRef qHandle As %Binary, AEpisodeNo As %String, APatientNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s admList = ""
	if (AEpisodeNo '= "")&&(AEpisodeNo '= $C(0))
	{
		s admList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByAdmNo(AEpisodeNo)
	}
	elseif (APatientNo '= "")&&(APatientNo '= $C(0))
	{
		s admList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByPatNo(APatientNo)
	}
	q:(admList = "") $$$OK
		
	s key = ""
	for {
		s key = admList.Next(key)
		q:(key = "")
		
		s episodeID = admList.GetAt(key)
		
		s blankEpisodeID = " "_episodeID
		
			s blankPrintDocID = ""
			for {
				s blankPrintDocID = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEpisodeID,blankPrintDocID))
				q:(blankPrintDocID = "")
			
				s PrintDocID = $e(blankPrintDocID, 2, $L(blankPrintDocID))
				s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(PrintDocID)
				continue:(objEPRTemplateCategory = "")
				s PrintTemplateID = objEPRTemplateCategory.BindPrnTemplateID
				continue:(PrintTemplateID = "")
				s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(PrintTemplateID)
				continue:(objPrintTemplate = "")
				s PrintType = objPrintTemplate.ChartItemType
				continue:(PrintType = "")
				
				s eprNum = 0
				for {
					s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEpisodeID,blankPrintDocID,eprNum))
					q:(eprNum = "")
					
					s EPRLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain",blankEpisodeID,blankPrintDocID,eprNum,""))
					continue:(EPRLogsID = "")
					s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(EPRLogsID)
					continue:(objEPRLogs = "")
					
					s UserID = 	objEPRLogs.CreateUserID
					s EpisodeID = $e(blankEpisodeID, 2, $L(blankEpisodeID))
					s PatientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
					s InstanceID = ""
					if (PrintType = "Multiple")
					{
						s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID",blankEpisodeID," ML"_PrintDocID,""))
						continue:(ecRecordID = "")
						s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID," "_eprNum,""))
						continue:(childSub = "")
						s InstanceID = ecRecordID_"||"_childSub
					}
					s ^CacheTemp(repid, ind) = $LB(PatientID,EpisodeID,EPRLogsID,PrintType,PrintTemplateID,PrintDocID,InstanceID,UserID)
					s ind = ind + 1	
				}
			}
	}
		
	Quit $$$OK
}

ClassMethod GetLogInfoByPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogInfoByPatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetLogInfoByPat(ACreateDate As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,EPRLogsID:%String,PrintType:%String,PrintTemplateID:%String,PrintDocID:%String,InstanceID:%String,UserID:%String")
{
}

/// Desc:	取指定错误日志信息中的EPRLogs信息
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.BLPreviewChecker","GetLogInfoByEPImage","100","Manual")
ClassMethod GetLogInfoByEPImageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogInfoByEPImageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetLogInfoByEPImageExecute(ByRef qHandle As %Binary, ATimeSlice As %String, FlagClass As %String = "", AHospitalID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	set ind=1		
	Set qHandle=$lb(0,repid,0)	

	
	if ((+ATimeSlice) > 86400)||((+ATimeSlice)<10)
	{
		s ATimeSlice = 600		
	}
	
	set now = $H
	set endDateTime = $$GetTaskEndTime(now, ATimeSlice)
	set endDate = $p(endDateTime, ",", 1)
	set endTime = $p(endDateTime, ",", 2)
	set exist = 0	
	set isDateTimeValid = 1
	
	if (FlagClass = "Manual")
	{
		if (AHospitalID = "")
		{
			do GetManualTask()
		}
		else
		{
			do GetManualTaskByHospital()
		}
	}
	else
	{
		if (AHospitalID = "")
		{
			do GetSysTask()
		}
		else
		{
			do GetSysTaskByHospital()
		}
	}
	
	Quit $$$OK

GetSysTask()
	set cDate = ""
	for {
		q:(exist=1)
		s cDate = $O(^DHCEPRI.EPImageLogI("IdxOnUpdateDateTime",cDate))
		q:(cDate = "")	
		
		s isDateTimeValid = $$IsDateValid(endDate, cDate)
		q:('isDateTimeValid)	
		
		s cTime = ""
		for {
			q:(exist=1)
			s cTime = $O(^DHCEPRI.EPImageLogI("IdxOnUpdateDateTime",cDate,cTime))
			q:(cTime = "")	
			
			s isDateTimeValid = $$IsDateTimeValid(endDate, endTime, cDate, cTime)
			q:('isDateTimeValid)		
		
			s rowID = ""
			for {
				q:(exist=1)
				s rowID = $O(^DHCEPRI.EPImageLogI("IdxOnUpdateDateTime",cDate,cTime,rowID))
				q:(rowID = "")
										
				s indexDataList = $g(^DHCEPRI.EPImageLogI("IdxOnUpdateDateTime",cDate,cTime,rowID))
				s resultFlag = $lg(indexDataList,2)
				continue:(resultFlag > 2)	//已生成超过3次就不再生成
				
				s objEPImageLog = ##Class(EPRinstance.EPImageLog).%OpenId(rowID)
				continue:(objEPImageLog = "")	
				
				//设置图片日志开始处理状态				
				s objEPImageLog.ResultFlag = (+resultFlag) + 1
				s objEPImageLog.UpdateDate = $p($h,",",1)
				s objEPImageLog.UpdateTime = $p($h,",",2)
				
				s sc = objEPImageLog.%Save()
				continue:('$$$ISOK(sc))					
				
				s PatientID = objEPImageLog.PatientID
				s EpisodeID = objEPImageLog.EpisodeID
				s EPRLogsID = objEPImageLog.EPRLogsID
				s PrintType = objEPImageLog.PrintType
				s PrintTemplateID = objEPImageLog.PrintTemplateID
				s PrintDocID = objEPImageLog.PrintDocID
				s InstanceID = objEPImageLog.InstanceDataID
				s UserID =objEPImageLog.UserID
				s ClientIp = objEPImageLog.ClientIP
				
				s ^CacheTemp(repid, ind) = $LB(rowID,PatientID,EpisodeID,EPRLogsID,PrintType,PrintTemplateID,PrintDocID,InstanceID,UserID,ClientIp)					
				s ind = ind + 1	
				s:(ind>5) exist=1				
			}
		}

		q:('isDateTimeValid)	
	}	

	quit

GetSysTaskByHospital()
	set cDate = ""
	for {
		q:(exist=1)
		s cDate = $O(^DHCEPRI.EPImageLogI("IdxOnHospitalID"," "_AHospitalID, cDate))
		q:(cDate = "")	
		
		s isDateTimeValid = $$IsDateValid(endDate, cDate)
		q:('isDateTimeValid)	
		
		s cTime = ""
		for {
			q:(exist=1)
			s cTime = $O(^DHCEPRI.EPImageLogI("IdxOnHospitalID"," "_AHospitalID,cDate,cTime))
			q:(cTime = "")	
			
			s isDateTimeValid = $$IsDateTimeValid(endDate, endTime, cDate, cTime)
			q:('isDateTimeValid)		
		
			s rowID = ""
			for {
				q:(exist=1)
				s rowID = $O(^DHCEPRI.EPImageLogI("IdxOnHospitalID"," "_AHospitalID,cDate,cTime,rowID))
				q:(rowID = "")
										
				s indexDataList = $g(^DHCEPRI.EPImageLogI("IdxOnHospitalID"," "_AHospitalID,cDate,cTime,rowID))
				s resultFlag = $lg(indexDataList,2)
				continue:(resultFlag > 2)	//已生成超过3次就不再生成
				
				s objEPImageLog = ##Class(EPRinstance.EPImageLog).%OpenId(rowID)
				continue:(objEPImageLog = "")	
				
				//设置图片日志开始处理状态				
				s objEPImageLog.ResultFlag = (+resultFlag) + 1
				s objEPImageLog.UpdateDate = $p($h,",",1)
				s objEPImageLog.UpdateTime = $p($h,",",2)
				
				s sc = objEPImageLog.%Save()
				continue:('$$$ISOK(sc))					
				
				s PatientID = objEPImageLog.PatientID
				s EpisodeID = objEPImageLog.EpisodeID
				s EPRLogsID = objEPImageLog.EPRLogsID
				s PrintType = objEPImageLog.PrintType
				s PrintTemplateID = objEPImageLog.PrintTemplateID
				s PrintDocID = objEPImageLog.PrintDocID
				s InstanceID = objEPImageLog.InstanceDataID
				s UserID =objEPImageLog.UserID
				s ClientIp = objEPImageLog.ClientIP
				
				s ^CacheTemp(repid, ind) = $LB(rowID,PatientID,EpisodeID,EPRLogsID,PrintType,PrintTemplateID,PrintDocID,InstanceID,UserID,ClientIp)					
				s ind = ind + 1	
				s:(ind>5) exist=1				
			}
		}

		q:('isDateTimeValid)	
	}	

	quit
	
GetManualTask()
	set cDate = ""
	for {
		q:(exist=1)
		s cDate = $O(^DHCEPRI.EPImageLogManualI("IdxOnUpdateDateTime",cDate))
		q:(cDate = "")	
		
		s isDateTimeValid = $$IsDateValid(endDate, cDate)
		q:('isDateTimeValid)	
		
		s cTime = ""
		for {
			q:(exist=1)
			s cTime = $O(^DHCEPRI.EPImageLogManualI("IdxOnUpdateDateTime",cDate,cTime))
			q:(cTime = "")	
			
			s isDateTimeValid = $$IsDateTimeValid(endDate, endTime, cDate, cTime)
			q:('isDateTimeValid)		
		
			s rowID = ""
			for {
				q:(exist=1)
				s rowID = $O(^DHCEPRI.EPImageLogManualI("IdxOnUpdateDateTime",cDate,cTime,rowID))
				q:(rowID = "")
										
				s indexDataList = $g(^DHCEPRI.EPImageLogManualI("IdxOnUpdateDateTime",cDate,cTime,rowID))
				s resultFlag = $lg(indexDataList,2)
				continue:(resultFlag > 2)	//已生成超过3次就不再生成
				
				s objEPImageLog = ##Class(EPRinstance.EPImageLogManual).%OpenId(rowID)
				continue:(objEPImageLog = "")
				
				//设置图片日志开始处理状态				
				//s objEPImageLog.ResultFlag = (+resultFlag) + 1
				//s objEPImageLog.UpdateDate = $p($h,",",1)
				//s objEPImageLog.UpdateTime = $p($h,",",2)
				//s sc = objEPImageLog.%Save()
				//continue:('$$$ISOK(sc))					
				
				s PatientID = objEPImageLog.PatientID
				s EpisodeID = objEPImageLog.EpisodeID
				s EPRLogsID = objEPImageLog.EPRLogsID
				s PrintType = objEPImageLog.PrintType
				s PrintTemplateID = objEPImageLog.PrintTemplateID
				s PrintDocID = objEPImageLog.PrintDocID
				s InstanceID = objEPImageLog.InstanceDataID
				s UserID =objEPImageLog.UserID
				s ClientIp = objEPImageLog.ClientIP
				
				//移动手工队列到系统队列
				d ##Class(EPRservice.BLL.BLEPImageLogManual).MoveToSys(rowID)
				
				s ^CacheTemp(repid, ind) = $LB(rowID,PatientID,EpisodeID,EPRLogsID,PrintType,PrintTemplateID,PrintDocID,InstanceID,UserID,ClientIp)					
				s ind = ind + 1	
				s:(ind>5) exist=1				
			}
		}

		q:('isDateTimeValid)	
	}	

	quit

GetManualTaskByHospital()
	set cDate = ""
	for {
		q:(exist=1)
		s cDate = $O(^DHCEPRI.EPImageLogManualI("IdxOnHospitalID"," "_AHospitalID,cDate))
		q:(cDate = "")	
		
		s isDateTimeValid = $$IsDateValid(endDate, cDate)
		q:('isDateTimeValid)	
		
		s cTime = ""
		for {
			q:(exist=1)
			s cTime = $O(^DHCEPRI.EPImageLogManualI("IdxOnHospitalID"," "_AHospitalID,cDate,cTime))
			q:(cTime = "")	
			
			s isDateTimeValid = $$IsDateTimeValid(endDate, endTime, cDate, cTime)
			q:('isDateTimeValid)		
		
			s rowID = ""
			for {
				q:(exist=1)
				s rowID = $O(^DHCEPRI.EPImageLogManualI("IdxOnHospitalID"," "_AHospitalID,cDate,cTime,rowID))
				q:(rowID = "")
										
				s indexDataList = $g(^DHCEPRI.EPImageLogManualI("IdxOnHospitalID"," "_AHospitalID,cDate,cTime,rowID))
				s resultFlag = $lg(indexDataList,2)
				continue:(resultFlag > 2)	//已生成超过3次就不再生成
				
				s objEPImageLog = ##Class(EPRinstance.EPImageLogManual).%OpenId(rowID)
				continue:(objEPImageLog = "")
				
				//设置图片日志开始处理状态				
				//s objEPImageLog.ResultFlag = (+resultFlag) + 1
				//s objEPImageLog.UpdateDate = $p($h,",",1)
				//s objEPImageLog.UpdateTime = $p($h,",",2)
				//s sc = objEPImageLog.%Save()
				//continue:('$$$ISOK(sc))					
				
				s PatientID = objEPImageLog.PatientID
				s EpisodeID = objEPImageLog.EpisodeID
				s EPRLogsID = objEPImageLog.EPRLogsID
				s PrintType = objEPImageLog.PrintType
				s PrintTemplateID = objEPImageLog.PrintTemplateID
				s PrintDocID = objEPImageLog.PrintDocID
				s InstanceID = objEPImageLog.InstanceDataID
				s UserID =objEPImageLog.UserID
				s ClientIp = objEPImageLog.ClientIP
				
				//移动手工队列到系统队列
				d ##Class(EPRservice.BLL.BLEPImageLogManual).MoveToSys(rowID)
				
				s ^CacheTemp(repid, ind) = $LB(rowID,PatientID,EpisodeID,EPRLogsID,PrintType,PrintTemplateID,PrintDocID,InstanceID,UserID,ClientIp)					
				s ind = ind + 1	
				s:(ind>5) exist=1				
			}
		}

		q:('isDateTimeValid)	
	}	

	quit
	
GetTaskEndTime(now, timeSlice)
	s retDate = $p(now, ",", 1)
	s retTime = $p(now, ",", 2)
	s retTime = retTime - timeSlice
	if (retTime < 0)
	{
		s retTime = retTime + 86400
		s retDate = retDat - 1
	}
	q retDate_","_retTime
	
IsDateTimeValid(endDate, endTime, cDate, cTime)
	q:(cDate>endDate) 0
	q:(cDate=endDate)&&(cTime>endTime) 0
	q 1
	
IsDateValid(endDate, cDate)
	q:(cDate>endDate) 0
	q 1
}

ClassMethod GetLogInfoByEPImageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogInfoByEPImageExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetLogInfoByEPImage(ATimeSlice As %String, FlagClass As %String = "", AHospitalID As %String = "") As %Query(ROWSPEC = "rowID:%String,PatientID:%String,EpisodeID:%String,EPRLogsID:%String,PrintType:%String,PrintTemplateID:%String,PrintDocID:%String,InstanceID:%String,UserID:%String,ClientIP:%String")
{
}

/// Desc:	取指定错误日志信息中指定患者的EPRLogs信息
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.BLPreviewChecker","GetLogInfoByLogAndPat","100")
ClassMethod GetLogInfoByLogAndPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogInfoByLogAndPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetLogInfoByLogAndPatExecute(ByRef qHandle As %Binary, AEpisodeNo As %String, APatientNo As %String) As %Status
{
	//b "s"
	Set repid=$I(^CacheTemp)
	set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s admList = ""
	if (AEpisodeNo '= "")&&(AEpisodeNo '= $C(0))
	{
		s admList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByAdmNo(AEpisodeNo)
	}
	elseif (APatientNo '= "")&&(APatientNo '= $C(0))
	{
		s admList = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetAdmListByPatNo(APatientNo)
	}
	q:(admList = "") $$$OK
		
	s key = ""
	for {
		s key = admList.Next(key)
		q:(key = "")
		
		s episodeID = admList.GetAt(key)
		
		s blankEpisodeID = " "_episodeID
		
		s blankPrintDocID = ""
		for {
			s blankPrintDocID = $O(^DHCEPRI.EPImageLogI("IdxEpisodeIDAndDocID",blankEpisodeID,blankPrintDocID))
			q:(blankPrintDocID = "")
					
			s rowID = ""
			for {
				s rowID = $O(^DHCEPRI.EPImageLogI("IdxEpisodeIDAndDocID",blankEpisodeID,blankPrintDocID,rowID))
				q:(rowID = "")
						
				s objEPImageLog = ##Class(EPRinstance.EPImageLog).%OpenId(rowID)
				continue:(objEPImageLog = "")
						
				s PatientID = objEPImageLog.PatientID
				s EpisodeID = objEPImageLog.EpisodeID
				s EPRLogsID = objEPImageLog.EPRLogsID
				s PrintType = objEPImageLog.PrintType
				s PrintTemplateID = objEPImageLog.PrintTemplateID
				s PrintDocID = objEPImageLog.PrintDocID
				s InstanceID = objEPImageLog.InstanceDataID
				s UserID =objEPImageLog.UserID
				s ClientIp = objEPImageLog.ClientIP
						
				s ^CacheTemp(repid, ind) = $LB(PatientID,EpisodeID,EPRLogsID,PrintType,PrintTemplateID,PrintDocID,InstanceID,UserID,ClientIp)
				s ind = ind + 1	
			}
		}
	}
		
	Quit $$$OK
}

ClassMethod GetLogInfoByLogAndPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogInfoByLogAndPatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetLogInfoByLogAndPat(AEpisodeNo As %String, APatientNo As %String) As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,EPRLogsID:%String,PrintType:%String,PrintTemplateID:%String,PrintDocID:%String,InstanceID:%String,UserID:%String,ClientIP:%String")
{
}

/// w ##Class(EPRservice.BLPreviewChecker).Test("100")
ClassMethod Test(ATimeSlice As %String)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.BLPreviewChecker:GetLogInfoByEPImage")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(ATimeSlice)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

}
