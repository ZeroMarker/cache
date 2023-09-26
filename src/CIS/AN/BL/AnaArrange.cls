/// 麻醉排班业务类
Class CIS.AN.BL.AnaArrange Extends %RegisteredObject
{

/// 保存排班时忽略的状态(这些状态的手术，保存排班时不用修改状态)
Parameter ArrIgnoreStatus As %String = "Receive^Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish";

/// 发布排班时忽略的状态(这些状态的手术，发布排班时不用修改状态)
Parameter SubmitIgnoreStatus As %String = "Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish";

/// w ##class(CIS.AN.BL.AnaArrange).GetArrOperList("2020-05-21","2020-05-21","298")
ClassMethod GetArrOperList(startDate As %String, endDate As %String, deptId As %String) As %String
{
	set EMStatusCode=..GetEMStatusCodeList()
	set statusCode=..GetStatusCodeList()
	b //ccq1
	set ret=##class(CIS.AN.COM.String).QueryToJSON("CIS.AN.BL.OperScheduleList","FindOperScheduleList",startDate,endDate,deptId,"","","",statusCode,"","","","N","","",EMStatusCode)
	quit ret
}

/// 获取麻醉排班时，可查询的急诊手术状态代码
ClassMethod GetEMStatusCodeList() As %String
{
	set NeedAuditOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditEMOperation")
	set statusCode="Application^Receive^Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish"
	set:(NeedAuditOperation="Y") statusCode="Audit^Receive^Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish"
	quit statusCode
}

ClassMethod GetStatusCodeList() As %String
{
	set statusCode="Audit^Receive^Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish"
	quit statusCode
}

ClassMethod GetLastArrange(opsId As %String) As CIS.AN.AnaArrange
{
	set rowId=""
	&sql(select LAST_IDENTITY() into :rowId from CIS_AN.AnaArrange where OperSchedule=:opsId)
	if (##class(CIS.AN.AnaArrange).%ExistsId(rowId))
	{
		set arrange=##class(CIS.AN.AnaArrange).%OpenId(rowId)	
	}
	else
	{
		set arrange=##class(CIS.AN.AnaArrange).%New()	
		do arrange.OperScheduleSetObjectId(opsId)
	}	
	quit arrange
}

// 麻醉排班接口

// w ##class(CIS.AN.BL.AnaArrange).SyncAnaArrange("2012^614^485^485^^178,177^10209")

ClassMethod SyncAnaArrange(data)
{
	q:data=""
	set opsId=$p(data,"^",1)			;his手术id
	set ArrAnaExpert=$p(data,"^",2)		;麻醉指导
	set Anesthesiologist=$p(data,"^",3)	;麻醉医生
	set AnaAssistant=$p(data,"^",4)		;麻醉助手
	set AnaStaff=$p(data,"^",5)			;实习进修
	set AnaMethod=$p(data,"^",6)		;麻醉方法多条麻醉用,分隔
	set UserID=$p(data,"^",7)			;安排用户
	set RowId=$o(^CIS.AN.AnaesthesiaI("IOPS",opsId,0))
	q:opsId="" "opsId不能为空"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")           // 手术日期(计划)
	set str=""
	set str="ClassName"_$c(0)_"CIS.AN.Anaesthesia"_$c(1)_"OperSchedule"_$c(0)_opsId_$c(1)_"RowId"_$c(0)_RowId_$c(1)_"ArrAnaExpert"_$c(0)_ArrAnaExpert_$c(1)_"ArrAnesthesiologist"_$c(0)_Anesthesiologist_$c(1)_"ArrAnaAssistant"_$c(0)_AnaAssistant_$c(1)_"ArrAnaStaff"_$c(0)_AnaStaff_$c(1)_"ArrAnaMethod"_$c(0)_AnaMethod_$c(1)_"UserID"_$c(0)_UserID
	s ^tempjdlskf=str
	set ret= ##class(CIS.AN.BL.AnaArrange).SaveAnaArrange(str)
	do ##class(CIS.AN.BL.AnaArrange).SubmitArrange(OperDate,UserID)
	q 0
}

// 手术排班接口

// 手术号，手术间，台次，器械护士，巡回护士，排班用户

ClassMethod SyncOperArrange(opsId, operRoom, operSeq, scrubNurse, circualNurse, userId)
{
	
	q:opsId "手术号不能为空"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	q:operSchedule=""
	set:(##class(CF.AN.Location).%ExistsId(operRoom)) operSchedule.OperRoom=##class(CF.AN.Location).%OpenId(operRoom)
	set:(##class(CF.AN.Location).%ExistsId(operRoom)) operSchedule.ArrOperRoom=##class(CF.AN.Location).%OpenId(operRoom)
	set operSchedule.OperSeq=operSeq
	set operSchedule.ArrOperSeq=operSeq
	set operSchedule.ScrubNurse=scrubNurse
	set operSchedule.ArrScrubNurse=scrubNurse
	set operSchedule.CircualNurse=circualNurse
	set operSchedule.ArrCircualNurse=circualNurse
	set arrangeStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
	set:("Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut" '[ operSchedule.Status.Code) operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(arrangeStatusId) 
	set sc=operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set operArrangeLog=##class(CIS.AN.BL.AnaArrange).CreateArrangeLog(opsId,"手术排班",userId)
	set sc=operArrangeLog.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPA",userId,+$h,$p($h,",",2))
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	quit "S^"
}

/// w ##class(CIS.AN.BL.AnaArrange).SaveAnaArrange(^TMPOPArr("Para"))
ClassMethod SaveAnaArrange(data As %String) As %String
{
	set ^TMPOPArr("Para")=data
	set $zt="Error"
	tstart
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0,saveResult="",opsId="",userId=""
	kill operObj
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		m operObj=array(objIndex)
		set opsId=operObj("OperSchedule"),userId=operObj("UserID")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		;set statusCode=operSchedule.Status.Code
		;quit:("RoomIn^RoomOut^PACUIn^Finish"[statusCode)
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operObj)
		quit:($piece(saveResult,"^",1)="E")
		set saveResult=..CreateArrangeLog(opsId,"保存排班",userId)
		quit:($piece(saveResult,"^",1)="E")
	}	
	
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult		
	}
	tcommit
	
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.AnaArrange).SubmitArrange("2021-09-29","11886")
ClassMethod SubmitArrange(operDate As %String, userId As %String) As %String
{
	set $zt="Error"
	set dateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(operDate,"")
	set opsId=0,saveResult="E^未更新任何记录！"
	set CanSubmitStatusList=##class(CIS.AN.BL.Constant).#CanSubmitStatusList
	set ArrangedStatusList=##class(CIS.AN.BL.Constant).#ArrangedStatusList
	tstart
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("OPDate",dateH,opsId))
		quit:(opsId="")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set statusCode=operSchedule.Status.Code
		continue:(CanSubmitStatusList'[statusCode)
		set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
		continue:'##class(CIS.AN.Anaesthesia).%ExistsId(anaId)	// 无麻醉表数据
		set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
		//set anaesthesia=##class(CIS.AN.BL.Anaesthesia).GetAnaesthesia(opsId)
		set anesthesiologist=anaesthesia.ArrAnesthesiologist
		continue:(anesthesiologist="")	// 无麻醉医生
		set anaesthesia.AnaExpert=anaesthesia.ArrAnaExpert
		set anaesthesia.Anesthesiologist=anaesthesia.ArrAnesthesiologist
		set anaesthesia.AnaAssistant=anaesthesia.ArrAnaAssistant
		set anaesthesia.AnaStaff=anaesthesia.ArrAnaStaff
		//set anaesthesia.AnaMethod=anaesthesia.ArrAnaMethod
		set sc=anaesthesia.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		
		if anaesthesia.ArrAnaMethod'=""
		{
			set saveResult=..UpdateAnaMethod(opsId,anaesthesia.ArrAnaMethod)
			quit:($p(saveResult,"^",1)'="S")
		}
		
		if (ArrangedStatusList '[ statusCode)
		{
			set statusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
			set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(statusID)	
		}
		set sc=operSchedule.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		
		set saveResult=..CreateArrangeLog(opsId,"发布排班",userId)
		quit:($p(saveResult,"^",1)="E")
		//20220126手术闭环
		s retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,userId,"21")

		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"ANA",userId,+$h,$p($h,",",2))
		quit:($p(saveResult,"^",1)="E")
		
		set saveResult="S^"
		
		do ..AfterSubmitArrange(opsId,userId)
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

ClassMethod AfterSubmitArrange(opsId, userId) As %Status
{
	
	try
	{
		// 麻醉排班回写旧表
		set saveResult=##class(CIS.AN.SRV.OperAppService).SendAnaArrange(opsId)
	}
	catch(e)
	{
		//write "麻醉排班回写旧表错误:",e.DisplayString(),!
	}
	
	try
	{
		// 写手术闭环
		set retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,userId,"21")
	}
	catch(e)
	{
		//write "写手术闭环错误:",e.DisplayString(),!
	}
	
	quit $$$OK
}

ClassMethod GetPreSeqCareProv(curOpsId As %String) As %String
{
	set curOperSchedule=##class(CIS.AN.OperSchedule).%OpenId(curOpsId)
	set date=##class(CIS.AN.COM.DateTime).ConvertToDate(curOperSchedule.OperDate,"")
	set curRoomId=curOperSchedule.OperRoom.%Id()
	set curOperSeq=+curOperSchedule.OperSeq,operSeq=curOperSeq
	set lastSeq=##class(CIS.AN.BL.OperArrange).GetLastSequence(date,curRoomId,.seqList)
	set scrubNurse="",cirNurse=""
	for
	{
		set operSeq=$o(seqList(curRoomId,operSeq),-1)
		quit:(operSeq="")!(scrubNurse'="")
		set opsId=seqList(curRoomId,operSeq)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set anaesthesia=##class(CIS.AN.BL.Anaesthesia).GetAnaesthesia(opsId)
		continue:(anaesthesia="")
		set curScrubNurse=$tr(operSchedule.ScrubNurse,",","")
		continue:(curScrubNurse="")
		set scrubNurse=operSchedule.ScrubNurse	
	}
	
	set operSeq=curOperSeq
	for
	{
		set operSeq=$o(seqList(curRoomId,operSeq),-1)
		quit:(operSeq="")!(cirNurse'="")
		set opsId=seqList(curRoomId,operSeq)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set curCirNurse=$tr(operSchedule.CircualNurse,",","")
		continue:(curCirNurse="")
		set cirNurse=operSchedule.CircualNurse	
	}
	
	quit scrubNurse_"#"_cirNurse
}

ClassMethod CreateArrangeLog(opsId As %String, note As %String, userId As %String) As %String
{
	set anaesthesia=##class(CIS.AN.BL.Anaesthesia).GetAnaesthesia(opsId)
	set arrangeLog=##class(CIS.AN.AnaArrange).%New()
	set arrangeLog.OperSchedule=anaesthesia.OperSchedule
	set arrangeLog.AnaMethod=anaesthesia.ArrAnaMethod
	set arrangeLog.ReleaseUser=userId
	set arrangeLog.Anesthesiologist=anaesthesia.ArrAnesthesiologist
	set arrangeLog.AnaExpert=anaesthesia.ArrAnaExpert
	set arrangeLog.AnaAssistant=anaesthesia.ArrAnaAssistant
	set arrangeLog.AnaAddtionalStaff=anaesthesia.ArrAnaStaff
	set arrangeLog.AnaNurse=anaesthesia.ArrAnaNurse
	set arrangeLog.Note=note
	set sc=arrangeLog.%Save()
	if ($System.Status.IsError(sc))
	{
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	quit "S^"
}

ClassMethod UpdateAnaMethod(opsId As %String, anaMethodStr As %String) As %String
{
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.BL.Anaesthesia).GetAnaesthesia(opsId)
	b ;2323
	set anaesthesia.AnaMethod=anaMethodStr
	b ;2334
	set anaesthesia.ArrAnaMethod=anaMethodStr
	set sc=anaesthesia.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	&sql(delete from CIS_AN.AnaestCatheter where Anaesthesia=:anaId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)
	set anaMethodCount=$l(anaMethodStr,","),saveRet="S^"
	for i=1:1:anaMethodCount
	{
		set anaMethodId=$p(anaMethodStr,",",i)
		set anaCatheter=##class(CIS.AN.AnaestCatheter).%New()
		set anaCatheter.Anaesthesia=anaesthesia
		set anaCatheter.AnaMethod=anaMethodId
		set sc=anaCatheter.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($p(saveRet,"^",1)'="S")	
	}
	quit saveRet
}

ClassMethod UpdateAnaExpert(opsId As %String, anaExpertId As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set oldExpertDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anaesthesia.ArrAnaExpert)
	set anaesthesia.ArrAnaExpert=anaExpertId
	set newExpertDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anaExpertId)
	set sc=anaesthesia.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	set arrangeNote="现麻醉指导："_newExpertDesc_"，原麻醉指导："_oldExpertDesc_"。"
	set logRet=..CreateArrangeLog(opsId,arrangeNote,userId)
	if ($p(logRet,"^",1)'="S")
	{
		trollback
		quit logRet
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod UpdateAnesthesiologist(opsId As %String, anesthesiologist As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.BL.Anaesthesia).GetAnaesthesia(opsId)
	set oldExpertDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anaesthesia.ArrAnesthesiologist)
	set anaesthesia.ArrAnesthesiologist=anesthesiologist
	set newExpertDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anesthesiologist)
	set sc=anaesthesia.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	set arrangeNote="现麻醉医生："_newExpertDesc_"，原麻醉医生："_oldExpertDesc_"。"
	set logRet=..CreateArrangeLog(opsId,arrangeNote,userId)
	if ($p(logRet,"^",1)'="S")
	{
		trollback
		quit logRet
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod UpdateAnaAssistant(opsId As %String, anaAssistant As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set oldExpertDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.CTCareProv","CTPCPDesc",anaesthesia.ArrAnaAssistant)
	set anaesthesia.ArrAnaAssistant=anaAssistant
	set newExpertDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.CTCareProv","CTPCPDesc",anaAssistant)
	set sc=anaesthesia.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	set arrangeNote="现麻醉助手："_newExpertDesc_"，原麻醉助手："_oldExpertDesc_"。"
	set logRet=..CreateArrangeLog(opsId,arrangeNote,userId)
	if ($p(logRet,"^",1)'="S")
	{
		trollback
		quit logRet
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod UpdateAnaStaff(opsId As %String, anaStaff As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set oldExpertDesc=anaesthesia.ArrAnaStaff
	set anaesthesia.ArrAnaStaff=anaStaff
	set newExpertDesc=anaStaff
	set sc=anaesthesia.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	set arrangeNote="现实习进修："_newExpertDesc_"，原实习进修："_oldExpertDesc_"。"
	set logRet=..CreateArrangeLog(opsId,arrangeNote,userId)
	if ($p(logRet,"^",1)'="S")
	{
		trollback
		quit logRet
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod UpdateArrAnaMethod(opsId As %String, anaMethod As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set oldMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.CTCareProv","CTPCPDesc",anaesthesia.ArrAnaMethod)
	set anaesthesia.ArrAnaMethod=anaMethod
	set newMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.CTCareProv","CTPCPDesc",anaMethod)
	set sc=anaesthesia.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set arrangeNote="现麻醉方法："_oldMethodDesc_"，原麻醉方法："_newMethodDesc_"。"
	set logRet=..CreateArrangeLog(opsId,arrangeNote,userId)
	if ($p(logRet,"^",1)'="S")
	{
		trollback
		quit logRet
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// 添加安排的麻醉护士
ClassMethod AddAnaNurse(opsId As %String, addingNurseId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set anaesthesiaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	quit:anaesthesiaId="" "E^麻醉记录不存在"
	
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaesthesiaId)
	set origialNurse=anaesthesia.ArrAnaNurse
	set origialNurseList=$ListFromString(origialNurse,",")
	if $ListFind(origialNurseList,addingNurseId) quit "S^already added"
	
	set newNurseList=origialNurseList_$lb(addingNurseId)
	set newNurseStr=$ListToString(newNurseList,",")
	
	set anaesthesia.ArrAnaNurse=newNurseStr
	set status=anaesthesia.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(anaesthesia.ArrAnaNurse)
	set note="现麻醉护士："_currentNurseDesc_"，原麻醉护士："_origialNurseDesc
	set arrangeLog=..CreateArrangeLog(opsId,note,userId)
	
	quit "S^"
}

/// 移除安排的麻醉护士
ClassMethod RemoveAnaNurse(opsId As %String, removingNurseId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set anaesthesiaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	quit:anaesthesiaId="" "E^麻醉记录不存在"
	
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaesthesiaId)
	set origialNurse=anaesthesia.ArrAnaNurse
	set origialNurseList=$ListFromString(origialNurse,",")
	set index=$ListFind(origialNurseList,removingNurseId)
	if 'index quit "S^does not exist"
	
	set newNurseList=$ListUpdate(origialNurseList,index,"")
	set newNurseStr=$ListToString(newNurseList,",")
	set newNurseStr=$Replace(newNurseStr,",,",",")
	set length=$l(newNurseStr)
	if $e(newNurseStr,1)="," set newNurseStr=$e(newNurseStr,2,length)
	if $e(newNurseStr,length)="," set newNurseStr=$e(newNurseStr,1,length-1)
	
	set anaesthesia.ArrAnaNurse=newNurseStr
	set status=anaesthesia.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(anaesthesia.ArrAnaNurse)
	set note="现麻醉护士："_currentNurseDesc_"，原麻醉护士："_origialNurseDesc
	set arrangeLog=..CreateArrangeLog(opsId,note,userId)
	
	quit "S^"_origialNurse_"->"_newNurseStr
}

ClassMethod SyncArrAnaNurse(operDate As %String, userId As %String) As %String
{
	set $zt="Error"
	set dateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(operDate,"")
	set opsId=0,saveResult="S^"
	set CanSubmitStatusList=##class(CIS.AN.BL.Constant).#CanSubmitStatusList
	set ArrangedStatusList=##class(CIS.AN.BL.Constant).#ArrangedStatusList
	tstart
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("OPDate",dateH,opsId))
		quit:(opsId="")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set statusCode=operSchedule.Status.Code
		continue:(CanSubmitStatusList'[statusCode)
		set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
		set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
		set anaesthesia.AnaNurse=anaesthesia.ArrAnaNurse
		set sc=anaesthesia.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

/// 清空安排的麻醉护士，撤销排班时调用
ClassMethod ClearArrAnaNurse(opsId As %String) As %String
{
	set $zt="Error"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set statusCode=operSchedule.Status.Code
	set saveResult="S^"
		
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set anaesthesia.ArrAnaNurse=""
	set anaesthesia.AnaNurse=""
	set sc=anaesthesia.%Save()
	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
	quit saveResult
Error
	trollback
	quit "E^"_$ze
}

/// 添加安排的麻醉助手
ClassMethod AddAnaAssistant(opsId As %String, addingDoctorId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set anaesthesiaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	quit:anaesthesiaId="" "E^麻醉记录不存在"
	
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaesthesiaId)
	set origialNurse=anaesthesia.ArrAnaAssistant
	set origialNurseList=$ListFromString(origialNurse,",")
	if $ListFind(origialNurseList,addingDoctorId) quit "S^already added"
	
	set newNurseList=origialNurseList_$lb(addingDoctorId)
	set newNurseStr=$ListToString(newNurseList,",")
	
	set anaesthesia.ArrAnaAssistant=newNurseStr
	set status=anaesthesia.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(anaesthesia.ArrAnaAssistant)
	set note="现麻醉助手："_currentNurseDesc_"，原麻醉助手："_origialNurseDesc
	set arrangeLog=..CreateArrangeLog(opsId,note,userId)
	
	quit "S^"
}

/// 移除安排的麻醉助手
ClassMethod RemoveAnaAssistant(opsId As %String, removingDoctorId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set anaesthesiaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	quit:anaesthesiaId="" "E^麻醉记录不存在"
	
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaesthesiaId)
	set origialNurse=anaesthesia.ArrAnaAssistant
	set origialNurseList=$ListFromString(origialNurse,",")
	set index=$ListFind(origialNurseList,removingDoctorId)
	if 'index quit "S^does not exist"
	
	set newNurseList=$ListUpdate(origialNurseList,index,"")
	set newNurseStr=$ListToString(newNurseList,",")
	set newNurseStr=$Replace(newNurseStr,",,",",")
	set length=$l(newNurseStr)
	if $e(newNurseStr,1)="," set newNurseStr=$e(newNurseStr,2,length)
	if $e(newNurseStr,length)="," set newNurseStr=$e(newNurseStr,1,length-1)
	
	set anaesthesia.ArrAnaAssistant=newNurseStr
	set status=anaesthesia.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(anaesthesia.ArrAnaAssistant)
	set note="现麻醉助手："_currentNurseDesc_"，原麻醉助手："_origialNurseDesc
	set arrangeLog=..CreateArrangeLog(opsId,note,userId)
	
	quit "S^"_origialNurse_"->"_newNurseStr
}

ClassMethod Test(opsId As %String) As %String
{
	w "test2"
	q "123"
}

}
