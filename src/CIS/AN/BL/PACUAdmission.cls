/// PACU准入管理业务逻辑类
Class CIS.AN.BL.PACUAdmission Extends %RegisteredObject
{

/// 获取当前PACU床位状态
/// w ##class(CIS.AN.BL.PACUAdmission).GetPACUBedStatus()
ClassMethod GetPACUBedStatus() As %String
{
	
	kill pacuBedList
	
	set rs=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindPACUBed")
	set sc=rs.Execute()
	set result=""
	while(rs.Next())
	{
		set RowId=rs.Get("RowId")
		set Description=rs.Get("Description")
		set pacuBedList(RowId,"RowId")=RowId
		set pacuBedList(RowId,"Description")=Description
		set pacuBedList(RowId,"Available")="true"
		set pacuBedList(RowId,"Available","Type")="JSON"
	}	
	
	set startDateH=+$h-1
	set endDateH=+$h
	
	set indexNode="OPDate"
	
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
			continue:(anaesthesia.TheatreOutTransLoc'="PACU") //仅此处判断，手术结束后转到位置为恢复室的手术
			
			set PACUInDT = anaesthesia.PACUInDT
			continue:(PACUInDT="") //未开始
			
			set PACUOutDT = anaesthesia.PACUOutDT
			set:PACUOutDT'="" duration = ##class(CIS.AN.COM.DateTime).CalculateDurationS(PACUOutDT,$zd(+$h,3)_" "_$zt($p($h,",",2)))
			set:PACUOutDT="" duration=0
			continue:(duration>60) //已结束  1分钟？
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set PACUBed = operSchedule.PACUBed
			continue:'$IsObject(PACUBed) //无PACU床位
	
			set PACUBedId = PACUBed.%Id()
			set PACUBedDesc = PACUBed.Description
	
			set EpisodeID=operSchedule.EpisodeID
		
			set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
			set PatName=patInfoObj.GetValue("PatName")
			set pacuBedList(PACUBedId,"CurrentPat")=PatName
			set pacuBedList(PACUBedId,"StartDT")=PACUInDT
			set pacuBedList(PACUBedId,"Available")="false"
		}	
	}
	
	//set pacuBedList(13,"CurrentPat")="测试用户"
	//set pacuBedList(13,"StartDT")="2020-12-31 15:00:00"
	//set pacuBedList(13,"Available")="false"
			
	//set pacuBedList(14,"CurrentPat")="测试用户"
	//set pacuBedList(14,"StartDT")="2020-12-31 15:20:00"
	//set pacuBedList(14,"Available")="false"
	
	//set pacuBedList(16,"CurrentPat")="测试用户"
	//set pacuBedList(16,"StartDT")="2020-12-31 15:30:00"
	//set pacuBedList(16,"Available")="false"
	
	//set pacuBedList(18,"CurrentPat")="测试用户"
	//set pacuBedList(18,"StartDT")="2020-12-31 14:50:00"
	//set pacuBedList(18,"Available")="false"
	
	set jsonStr=##class(CIS.AN.COM.String).ToJson(.pacuBedList)
	
	quit jsonStr
}

/// 当前准入管理数据
/// w ##class(CIS.AN.BL.PACUAdmission).GetCurrentAdmission(660)
ClassMethod GetCurrentAdmission(opsId) As %String
{
	kill info
	set rowId=$o(^CIS.AN.PACUAdmissionI("OPS",opsId,""),-1)
	if ##class(CIS.AN.PACUAdmission).%ExistsId(rowId)
	{
		set admission=##class(CIS.AN.PACUAdmission).%OpenId(rowId)
		set requestDate=admission.RequestDate
		set requestTime=admission.RequestTime
		set info(1,"RowId")=rowId
		set info(1,"RequestDT")=$zd(requestDate,3)_" "_$zt(requestTime)
		set userInfo=##class(CIS.AN.BL.Admission).GetUserTypeName(admission.RequestUser)
		set info(1,"RequestUser")=$p(userInfo,"^",2)
		if (admission.Reader'="")
		{
			set userInfo=##class(CIS.AN.BL.Admission).GetUserTypeName(admission.Reader)
			set info(1,"ReadUser")=$p(userInfo,"^",2)
			set info(1,"ReadDT")=admission.ReadDT
		}
		if (admission.RespondUser'="")
		{
			set userInfo=##class(CIS.AN.BL.Admission).GetUserTypeName(admission.RespondUser)
			set info(1,"RespondUser")=$p(userInfo,"^",2)
			set info(1,"RespondDT")=$zd(admission.RespondDate,3)_" "_$zt(admission.RespondTime)
		}
		set info(1,"Note")=admission.Note
		set status=admission.Status
		b ;status
		set info(1,"StatusComment")=$s(status="Confirmed":"允许转入PACU",status="Responded":"允许转入PACU",1:"请等待")
		set info(1,"CanTransToPACU")=$s(status="Confirmed":"Y",status="Responded":"Y",1:"N")
		set info(1,"CurrentState")=$s(status="Confirmed":"已确认",
									status="Responded":"PACU准入申请已提交，"_$g(info(1,"RespondUser"))_"已确认可转入PACU，时间："_$g(info(1,"RespondDT")),
									status="Read":"PACU准入申请已提交，"_$g(info(1,"ReadUser"))_"已读，时间："_$g(info(1,"ReadDT")),
									status="Sent":"PACU准入申请已提交，管理员未读",
									1:"N")
	}
	
	set info(1,"WaitingSeq")=..GetCurrentSeq(opsId)
	
	//set info(1,"RowId")="12"
	//set info(1,"RequestDT")="2020-12-31 17:50:10"
	//set info(1,"RequestUser")="医生01"
	//set info(1,"ReadUser")="麻醉护士"
	//set info(1,"ReadDT")="2020-12-31 17:53:23"
	//set info(1,"StatusComment")="请等待"
	
	set jsonStr=##class(CIS.AN.COM.String).ToJson(.info)
	quit jsonStr
}

/// 当前排号
/// w ##class(CIS.AN.BL.PACUAdmission).GetCurrentSeq()
ClassMethod GetCurrentSeq(opsId) As %String
{
	do ..GetWaitingList(.waitingList)
	
	set total=+$g(waitingList("total"))
	set count=0
	set date="",found=0
	for
	{
		set date=$o(waitingList("ops",date))
		quit:(date="")||found
		
		set time=""
		for
		{
			set time=$o(waitingList("ops",date,time))
			quit:(time="")||found
			
			set rowId=""
			for
			{
				set rowId=$o(waitingList("ops",date,time,rowId))
				quit:(rowId="")||found
				
				if (opsId=rowId) set found=1
				set count=count+1
			}
		}
	}
	
	quit count_"("_total_")"
}

/// 获取等待列表
ClassMethod GetWaitingList(ByRef waitingList) As %String
{
	
	kill waitingList
	set startDateH=+$h-1
	set endDateH=+$h
	
	set statusList("Sent")=""
	set statusList("Read")=""
	set statusList("Responded")=""
	set statusList("Confirmed")=""
	
	for date=startDateH:1:endDateH
	{
		set status=""
		for
		{
			set status=$o(statusList(status))
			quit:status=""
			
			set rowId=0
			for
			{
				set rowId=$order(^CIS.AN.PACUAdmissionI("DateStatus",date," "_$ZCVT(status,"U"),rowId))
				quit:(rowId="")
			
				set admission=##class(CIS.AN.PACUAdmission).%OpenId(rowId)
				set waitingList("total")=$g(waitingList("total"))+1
				set waitingList("ops",admission.RequestDate,admission.RequestTime,admission.OperSchedule.%Id())=""
			}
		}
	}
	
	quit ""
}

/// 申请准入
ClassMethod AddApplication(opsId As %String, data As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	quit:(data="") "E^保存的数据不能为空！"
	
	kill savingData
	set savingData("ClassName")="CIS.AN.PACUAdmission"
	
	tstart
	
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set saveResult="S^"
	merge savingData=array(1)
	
	set savingData("OperSchedule")=opsId
	set savingData("RequestUser")=userId
	set savingData("RequestDate")=+$h
	set savingData("RequestTime")=$p($h,",",2)
	set savingData("Status")="Sent"
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.savingData)
		
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
}

/// 阅读准入
ClassMethod ReadMessage(admissionId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.PACUAdmission).%ExistsId(admissionId)=0) "E^准入申请不存在！"
	
	kill savingData
	set savingData("ClassName")="CIS.AN.PACUAdmission"
	
	tstart
	
	set saveResult="S^"
	
	set savingData("RowId")=admissionId
	set savingData("Reader")=userId
	set savingData("ReadDT")=##class(CIS.AN.COM.DateTime).ConvertToDateTime(+$h,$p($h,",",2))
	set savingData("Status")="Read"
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.savingData)
		
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
}

/// 允许准入
ClassMethod Respond(admissionId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.PACUAdmission).%ExistsId(admissionId)=0) "E^准入申请不存在！"
	
	kill savingData
	set savingData("ClassName")="CIS.AN.PACUAdmission"
	
	tstart
	
	set saveResult="S^"
	
	set savingData("RowId")=admissionId
	set savingData("RespondUser")=userId
	set savingData("RespondDate")=+$h
	set savingData("RespondTime")=$p($h,",",2)
	set savingData("Status")="Responded"
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.savingData)
		
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
}

/// 确认准入
ClassMethod Confirm(admissionId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.PACUAdmission).%ExistsId(admissionId)=0) "E^准入申请不存在！"
	
	kill savingData
	set savingData("ClassName")="CIS.AN.PACUAdmission"
	
	tstart
	
	set saveResult="S^"
	
	set savingData("RowId")=admissionId
	set savingData("ConfirmUser")=userId
	set savingData("ConfirmDT")=##class(CIS.AN.COM.DateTime).ConvertToDateTime(+$h,$p($h,",",2))
	set savingData("Status")="Confirmed"
	
	set saveResult=##class(CIS.AN.COM.DataService).SaveData(.savingData)
		
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2021-01-03
/// Description： 	查询当前准备进入恢复室的病人列表
/// Table：        	CIS.AN.OperSchedule
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.PACUAdmission","FindPACUList",10209,265,298,"","","")
Query FindPACUList(userId As %String, userGroup As %String, userDept As %String, filterStartDate As %String = "", filterEndDate As %String = "", filterStatus As %String = "") As %Query(ROWSPEC = "RowId,Status,IconCls,StatusDesc,Info,RequestUser,RequestDate,RequestTime,RequestDT,Reader,ReadDT,RespondUser,RespondDT,Note,CanRespond,CanConfirm,OPSID,EpisodeID,PatName,PatGender,PatAge,RegNo,MedcareNo,OperRoom,RoomDesc,OperDesc,SurgeonDesc,AnaMethodDesc,AnesthesiologistDesc,TheatreInDT,AnaStartDT,OperStartDT,OperFinishDT,AnaFinishDT,TheatreOutDT") [ SqlProc ]
{
}

ClassMethod FindPACUListExecute(ByRef qHandle As %Binary, userId As %String, userGroup As %String, userDept As %String, filterStartDate As %String = "", filterEndDate As %String = "", filterStatus As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+$h-1
	set endDateH=+$h
	
	if filterStartDate'="" set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(filterStartDate)
	if filterEndDate'="" set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(filterEndDate)
	
	set UnconfirmedStatusList=$lb("Read","Responded")
	set ConfirmedStatusList=$lb("Confirmed","Sent")
	
	set isAdmin="N"
	set groupConfigId=$o(^CF.AN.SSGroupI("IGroupID"," "_userGroup,""))
	if ##class(CF.AN.SSGroup).%ExistsId(groupConfigId)
	{
		set groupConfig=##class(CF.AN.SSGroup).%OpenId(groupConfigId)
		set isAdmin=groupConfig.PACUAdministrator
		if isAdmin="Y"
		{
			set UnconfirmedStatusList=$lb("Sent","Read")
			set ConfirmedStatusList=$lb("Confirmed","Responded")
		}
	}
	
	set canRespond=isAdmin,canConfirm="N"
	
	for date=startDateH:1:endDateH
	{
		set rowId=""
		for
		{
			set rowId=$o(^CIS.AN.PACUAdmissionI("Date",date,rowId))
			quit:rowId=""
			
			set admission=##class(CIS.AN.PACUAdmission).%OpenId(rowId)
			set status=admission.Status
			set requestUser=admission.RequestUser
			continue:(isAdmin="N")&&(userId'=requestUser)
			continue:(filterStatus="Unconfirmed")&&('$ListFind(UnconfirmedStatusList,status))
			continue:(filterStatus="Confirmed")&&('$ListFind(ConfirmedStatusList,status))
			set canConfirm="N",canRespond="N"
			if (userId=requestUser)&&(status="Responded") set canConfirm="Y"
			if (isAdmin="Y")&&($ListFind(UnconfirmedStatusList,status)) set canRespond="Y"
			
			set userInfo=##class(CIS.AN.BL.Admission).GetUserTypeName(admission.RequestUser)
			set requestUser=$p(userInfo,"^",2)
			set userInfo=##class(CIS.AN.BL.Admission).GetUserTypeName(admission.Reader)
			set reader=$p(userInfo,"^",2)
			set userInfo=##class(CIS.AN.BL.Admission).GetUserTypeName(admission.RespondUser)
			set respondUser=$p(userInfo,"^",2)
			
			if status="Sent" set iconCls="icon-unread",statusDesc="未读"
			if status="Read" set iconCls="icon-read",statusDesc="已读未处理"
			if status="Responded" set iconCls="icon-complete",statusDesc="已处理"
			if status="Confirmed" set iconCls="icon-complete",statusDesc="已处理"
			
			;set requestDate=$zd(admission.RequestDate,3)
			;set requestTime=$zt(admission.RequestTime)
			set requestDate=##class(web.DHCClinicCom).ConvertToDate(admission.RequestDate)
			set requestTime=##class(web.DHCClinicCom).ConvertToTime(admission.RequestTime) 
			set requestDT=requestDate_" "_requestTime
			
			set readDT=admission.ReadDT
			set readDT=##class(CIS.AN.BL.RealTimeMonitor).modifyDateTime(readDT)
			
			set respondDate=admission.RespondDate
			set respondTime=admission.RespondTime
			set:respondDate'="" respondDate=##class(web.DHCClinicCom).ConvertToDate(respondDate)  ;$zd(respondDate,3)
			set:respondTime'="" respondTime=##class(web.DHCClinicCom).ConvertToTime(respondTime)   ;$zt(respondTime)
			set respondDT=respondDate_" "_respondTime
			
			set note=admission.Note
			
			set operSchedule=admission.OperSchedule
			set opsId=operSchedule.%Id()
			set EpisodeID=operSchedule.EpisodeID
			set PatName=operSchedule.PatName
			set PatGender=operSchedule.PatGender
			set OperDate=operSchedule.OperDate
			set PatAge=##class(CIS.AN.COM.DateTime).CalAge(operSchedule.PatDOB,OperDate)
			set RegNo=operSchedule.RegNo
			set MedcareNo=operSchedule.MedicareNo
			
			set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)
			set OperDesc=operListObj.OperDesc					// 实施手术名称
			set OperNote=operListObj.OperNote						// 实施手术名称备注
			set:(OperDesc="") OperDesc=OperNote
			set SurgeonDesc=operListObj.SurgeonDesc					// 实施手术医生姓名
			
			set OperRoom="",RoomDesc=""					// 手术间
			if (operSchedule.OperRoom'="")
			{
				set OperRoom=operSchedule.OperRoom.%Id()				// 手术间ID
				set RoomDesc=operSchedule.OperRoom.Description			// 手术间名称
			}
			
			set info=RoomDesc_" "_PatName_" "_PatGender_" "_PatAge_" "_RegNo
			
			set AnesthesiologistDesc="",AnaMethodDesc=""
			set TheatreInDT="",AnaStartDT="",OperStartDT="",OperFinishDT="",AnaFinishDT="",TheatreOutDT=""
			
			set AnaestID=$o(^CIS.AN.AnaesthesiaI("IOPS",opsId,0))	// 麻醉申请ID
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(AnaestID)
			if (anaesthesia'=""){
				set AnaMethod=anaesthesia.AnaMethod	// 麻醉方法ID
				set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)	// 麻醉方法名称
				set Anesthesiologist=anaesthesia.Anesthesiologist	// 麻醉医生
				set AnesthesiologistDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",Anesthesiologist)	// 麻醉医生姓名
				
				set TheatreInDT=anaesthesia.TheatreInDT
				set AnaStartDT=anaesthesia.AnaStartDT
				set OperStartDT=anaesthesia.OperStartDT
				set OperFinishDT=anaesthesia.OperFinishDT
				set AnaFinishDT=anaesthesia.AnaFinishDT
				set TheatreOutDT=anaesthesia.TheatreOutDT
			}
			
			set operStatusCode=""
			set:operSchedule.Status'="" operStatusCode=operSchedule.Status.Code
			if (operStatusCode="RoomIn")
			{
				kill keyTimeList
				do ##class(CIS.AN.BL.OperScheduleList).GetKeyTimeFromAnaData(opsId,.keyTimeList)
				set TheatreInDT=$g(keyTimeList("TheatreInTime"))
				set AnaStartDT=$g(keyTimeList("AnestStartTime"))
				set OperStartDT=$g(keyTimeList("OperStartTime"))
				set OperFinishDT=$g(keyTimeList("OperEndTime"))
				set AnaFinishDT=$g(keyTimeList("AnestEndTime"))
				set TheatreOutDT=$g(keyTimeList("TheatreOutTime"))
			}
			
			do OutputRow
		}
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=$lb(rowId,status,iconCls,statusDesc,info,requestUser,requestDate,requestTime,requestDT,reader,readDT,respondUser,respondDT,note,canRespond,canConfirm,opsId,EpisodeID,PatName,PatGender,PatAge,RegNo,MedcareNo,OperRoom,RoomDesc,OperDesc,SurgeonDesc,AnaMethodDesc,AnesthesiologistDesc,TheatreInDT,AnaStartDT,OperStartDT,OperFinishDT,AnaFinishDT,TheatreOutDT)
	s ind=ind+1
	q
}

ClassMethod FindPACUListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPACUListExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindPACUListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPACUListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

}
