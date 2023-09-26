Import SQLUser

/// 20200217+dyl+日间手术业务类
Class CIS.AN.BL.DaySurgery Extends %RegisteredObject
{

/// Creator：        陈长青
/// CreatDate：      2017-03-13
/// Description：    保存手术申请信息
/// Table：          DHCAN.OperSchedule,DHCAN.AnaestOperation
/// Input:          data:数据字符串
/// Return：         保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.DaySurgery).SaveOperApplication("")
/// w ##class(CIS.AN.BL.DaySurgery).SaveOperApplication(^TMPOPAPPD("Para"),"","")
ClassMethod SaveOperApplication(data As %String, ConfirmFlag As %String = "", tmpOPSID As %String = "", userId As %String = "") As %String
{
	set ^TMPOPAPPD("Para")=data
	set $zt="Error"
	set opsId=""
    tstart
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    // 第一个对象为手术明细信息
    kill operSchedule
    m operSchedule=array(1)
    // 第二个对象为麻醉过程
    //m anaesthesia=array(2)
    // 没有手术状态时，一般认为是新建手术申请，需要对手术状态赋值
    if ($get(operSchedule("Status"))="")&($get(operSchedule("StatusCode"))'="")
    {
        set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
    }
    elseif ($get(operSchedule("DaySurgery"))="Y")&($get(operSchedule("StatusCode"))'="")
    {
	    //202002+dyl+日间确认
        set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
    }
    if (($get(operSchedule("DaySurgery"))="OOP")&($get(operSchedule("SourceType"))="E"))
    {
	    s newComDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(operSchedule("DaySurgery"))
    }
   s tmpEpisodeID=operSchedule("EpisodeID")
    //set PatDeptID=$get(operSchedule("PatDeptID"))
    //i (PatDeptID="")&(tmpEpisodeID'="") s PatDeptID=$P($g(^PAADM(tmpEpisodeID)),"^",4)
    //set operSchedule("PatDeptID")=##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Department",PatDeptID)
    
   // set PatWardID=$get(operSchedule("PatWardID"))
    //i (PatWardID="")&(tmpEpisodeID'="") s PatWardID=$p($g(^PAADM(tmpEpisodeID)),"^",70)
   // set operSchedule("PatWardID")=##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Ward",PatWardID)
    
    //set PatBedID=$get(operSchedule("PatBedID"))
    //i (PatBedID="")&(tmpEpisodeID'="") s PatBedID=$p($p($g(^PAADM(tmpEpisodeID)),"^",73),"||",2)
    //set operSchedule("PatBedID")=##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Bed",PatBedID)
    
    set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)
    // 保存到麻醉表OR_Anaesthesia，因为his需要引用OR_Anaesthesia的数据。
    set opsId=$piece(saveResult,"^",2),ansId=0
    if ($piece(saveResult,"^",1)="S")
    {
        //set opsId=$piece(saveResult,"^",2)
        set schedule("RowId")=opsId
        set schedule("ClassName")="CIS.AN.OperSchedule"
        set anaesthesia("RowId")=$get(operSchedule("ExtAnaestID"))
        set anaesthesia("ParentRowId")=operSchedule("EpisodeID")
        set saveResult=..SaveORAnaesthesia(.anaesthesia)
    }

    // 将OR_Anaesthesia表的RowId保存到CIS_AN.OperSchedule表中，方便直接调用
    if ($piece(saveResult,"^",1)="S")
    {
        set anaId=$piece(saveResult,"^",2)
        set schedule("ExtAnaestID")=anaId
        set saveResult=##class(CIS.AN.COM.DataService).SaveData(.schedule)
    }

    // 将麻醉方法保存到新版的麻醉表CIS_AN.Anaesthesia
    if ($piece(saveResult,"^",1)="S")
    {
        //set opsId=$piece(saveResult,"^",2)
        set anaId=""
        &sql(select RowId into :anaId from cis_an.anaesthesia where operschedule=:opsId)
        set anaesthesia("AnaID")=anaId
        set anaesthesia("OpsID")=opsId
        if $d(operSchedule("PrevAnaMethod")) set anaesthesia("AnaMethod")=operSchedule("PrevAnaMethod")
        set saveResult=..SaveAnaesthesia(.anaesthesia)
        b	;??将麻醉方法保存到新版的麻醉表CIS_AN.Anaesthesia
    }
   	if ($piece(saveResult,"^",1)="S")
    {
	    // 删除拟施手术表
	    &sql(delete from CIS_AN.PlanOperList where OperSchedule=:opsId)
	    set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
    }
    if ($piece(saveResult,"^",1)="S")
    {
	    // 删除实施手术表
	    &sql(delete from CIS_AN.OperList where OperSchedule=:opsId)
	    set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
    }
    if ($piece(saveResult,"^",1)="S")
    {   
	    // 巡回遍历保存手术名称
        set objIndex=1
        for
        {
            set objIndex=$order(array(objIndex))
            quit:(objIndex="")
            kill operation
            merge operation=array(objIndex)
            //quit:'$d(operation("OperSchedule"))
            set operation("RowId")=""
            set operation("OperSchedule")=opsId
            set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operation)
            quit:($piece(saveResult,"^",1)'="S")
        }   
    }

    set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    ;b	;日间手术确认时才会正式插入手术申请医嘱
    if (($piece(saveResult,"^",1)="S")&&($get(operSchedule("DaySurgery"))="Y"))
    {
	    //20211021+dyl
	   
	s retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,userId,"1")
	    // 插入手术申请医嘱
        set saveResult=##class(CIS.AN.BL.OperOrder).SaveAppOrderItem(opsId) 
        if ($piece(saveResult,"^",1)="S")
        {
	        // 如果插入手术申请医嘱成功，那么将医嘱ID保存到CIS_AN.OperSchedule表，方便直接调用。
	    	set orderItemID=$p(saveResult,"^",2)
	    	set operScheduleObj.AppOrderItem=orderItemID
	    	set sc=operScheduleObj.%Save()
	    	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)    
	    }  
	    set retDaySurStatus=..ChangeOpStatus(opsId,"DaySurgery")
    }
    else
    {
	    s retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,userId,"1")
    }

   	if (($piece(saveResult,"^",1)="S")&($get(operSchedule("DaySurgery"))'="Y"))
   	{
        set saveResult=##class(CIS.AN.BL.OperOrder).SaveAppOrderItem(opsId) 
        if ($piece(saveResult,"^",1)="S")
        {
	        // 如果插入手术申请医嘱成功，那么将医嘱ID保存到CIS_AN.OperSchedule表，方便直接调用。
	    	set orderItemID=$p(saveResult,"^",2)
	    	set operScheduleObj.AppOrderItem=orderItemID
	    	set sc=operScheduleObj.%Save()
	    	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)    
	    }  
   	}
	if ($piece(saveResult,"^",1)="S")
	{
		set saveResult=##class(CIS.AN.SRV.OperAppService).SendOperAppInfo(opsId)
	}
	set opaId=""
	if ($piece(saveResult,"^",1)="S")
	{
		;b	// 写手术申请消息
		set opaId=$p(saveResult,"^",2)
		//set retEMR=##class(EMRservice.BIEMRService).SetOperation(operScheduleObj.EpisodeID,opaId)
		//set:(+retEMR'=1) saveResult="E^写入手术申请消息失败" 
	}
	if ($piece(saveResult,"^",1)="S")&(opaId'="")
    {
	   ;b // 写关联电子病历文书
		set linkEMRecords=$get(operSchedule("LinkEMRecords"))
		//set:(linkEMRecords'="") saveResult=..LinkEMRecords(opaId,linkEMRecords)  
	}

	if ($piece(saveResult,"^",1)="S")
    {
	    set actionUserId=operScheduleObj.AppUserID
	    set procedureCode=""
	    set:(operScheduleObj.Status.Code="Application") procedureCode="APP"
	    set:(operScheduleObj.Status.Code="DaySurgery") procedureCode="APP"
	    set:(operScheduleObj.DaySurgery="Y")&(operScheduleObj.Status.Code="Application") procedureCode="DAT"	;202002+dyl
	    ;set:(operScheduleObj.Status.Code="DaySurgery") procedureCode="APP"
	    set:(operScheduleObj.Status.Code="Cancel") procedureCode="CCL"
        set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,procedureCode,actionUserId,+$h,$p($h,",",2))   
    }
    if ($piece(saveResult,"^",1)'="S")
    {
        trollback
        quit saveResult     
    }
    tcommit
    
    if opsId'="" do ..AfterSaveOperApplication(opsId)
    
    quit "S^"_opsId
Error
	trollback
	quit "E^"_$ze
}

ClassMethod AfterSaveOperApplication(opsId) As %Status
{
	set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	try
	{
		//20211214
		set opaId=operScheduleObj.ExternalID
		// 调用消息平台接口	
		s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
		set:(+OAret'=0) saveResult="E^发送手术申请失败，原因："_$p(OAret,"^",2)
		//if (+OAret'=0) write "DTS:调用消息平台接口错误:",$p(OAret,"^",2),!
	}
	catch(e)
	{
		//write "DTS:调用消息平台接口错误:",e.DisplayString(),!
	}
    
    quit $$$OK
}

/// w ##class(CIS.AN.BL.DaySurgery).SavePatientInfo(^TMPOPReg("Para"))
/// 术后登记用
ClassMethod SavePatientInfo(data As %String) As %String
{
	set ^TMPOPReg("Para")=data
	set $zt="Error"
    tstart
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    // 第一个对象为手术明细信息
    kill operSchedule
    m operSchedule=array(1)
    // 第二个对象为麻醉过程
    //m anaesthesia=array(2)   
	set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
       s tmpEpisodeID=operSchedule("EpisodeID")
    set PatDeptID=$get(operSchedule("PatDeptID"))
    i (PatDeptID="")&(tmpEpisodeID'="") s PatDeptID=$P($g(^PAADM(tmpEpisodeID)),"^",4)
    set operSchedule("PatDeptID")=##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Department",PatDeptID)
    set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)
    b	;saveResult
    // 保存到麻醉表OR_Anaesthesia，因为his需要引用OR_Anaesthesia的数据。
    set opsId=$piece(saveResult,"^",2),ansId=0
    if ($piece(saveResult,"^",1)="S")
    {
        //set opsId=$piece(saveResult,"^",2)
        set schedule("RowId")=opsId
        set schedule("ClassName")="CIS.AN.OperSchedule"
        set anaesthesia("RowId")=$get(operSchedule("ExtAnaestID"))
        set anaesthesia("ParentRowId")=operSchedule("EpisodeID")
        set saveResult=..SaveORAnaesthesia(.anaesthesia)
        b	;??
    }
    // 将OR_Anaesthesia表的RowId保存到CIS_AN.OperSchedule表中，方便直接调用
    if ($piece(saveResult,"^",1)="S")
    {
        set anaId=$piece(saveResult,"^",2)
        set schedule("ExtAnaestID")=anaId
        set saveResult=##class(CIS.AN.COM.DataService).SaveData(.schedule)
    }

    // 将麻醉方法保存到新版的麻醉表CIS_AN.Anaesthesia
    if ($piece(saveResult,"^",1)="S")
    {
        //set opsId=$piece(saveResult,"^",2)
        set anaId=""
        &sql(select RowId into :anaId from cis_an.anaesthesia where operschedule=:opsId)
        set anaesthesia("AnaID")=anaId
        set anaesthesia("OpsID")=opsId
        set anaesthesia("AnaMethod")=operSchedule("AnaMethod")
        b	;?1
        set saveResult=..SaveAnaesthesia(.anaesthesia)
        b	;?2
    }
    
    if ($piece(saveResult,"^",1)="S")
    {
	    // 删除实施手术表
	    &sql(delete from CIS_AN.OperList where OperSchedule=:opsId)
	    set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
    }

    if ($piece(saveResult,"^",1)="S")
    {
	    // 巡回遍历保存手术名称
        set objIndex=1
        for
        {
            set objIndex=$order(array(objIndex))
            quit:(objIndex="")
            kill operation
            merge operation=array(objIndex)
            //quit:'$d(operation("OperSchedule"))
            set operation("OperSchedule")=opsId
            set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operation)
            quit:($piece(saveResult,"^",1)'="S")
        }   
    }
    
    set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	if ($piece(saveResult,"^",1)="S")
	{
		// 回写旧表
		set saveResult=##class(CIS.AN.SRV.OperAppService).SendOperAppInfo(opsId)
		set saveResult=..ChangeOpStatus(opsId,"Reg")
	}
	set opaId=""
	if ($piece(saveResult,"^",1)="S")
	{
		;b	// 写手术申请消息
		set opaId=$p(saveResult,"^",2)
	}
	if ($piece(saveResult,"^",1)="S")&(opaId'="")
    {
	   ;b // 写关联电子病历文书
		set linkEMRecords=$get(operSchedule("LinkEMRecords"))
	}
	
	if ($piece(saveResult,"^",1)="S")
    {
	    b	// 写手术操作过程
	    set actionUserId=operScheduleObj.AppUserID
	    set procedureCode=""
	    set:(operScheduleObj.Status.Code="Cancel") procedureCode="CCL"
	    set:(operScheduleObj.Status.Code="Finish") procedureCode="FNH"
        set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,procedureCode,actionUserId,+$h,$p($h,",",2))   
    }
    if ($piece(saveResult,"^",1)'="S")
    {
        trollback
        quit saveResult     
    }
    tcommit
    quit "S^"_opsId
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.DaySurgery).CheckValidDayOper(9581)
/// 入参：就诊号，
/// 返回Y^A^数字，存在正式日间申请
/// 返回Y^W^数字，存在拟日间申请
/// 返回N^N^数字，不存在日间手术
/// 返回N^C^数字，存在撤销的拟日间申请
/// 只适合日间
ClassMethod CheckValidDayOperNew(AdmId) As %String
{
	s ret1="",ret2="",ret=""
	s opaId=$o(^CIS.AN.OperScheduleI("Adm"," "_AdmId,""),-1)
	i opaId="" s ret1="N",ret2="N"
	e  d
		.set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opaId)
		.s operStatId=operSchedule.Status
		.i operStatId'="" s operStat=operSchedule.Status.Code
		.s dayOperFlag=operSchedule.DaySurgery
		.i dayOperFlag'="Y" d
			..s ret1="N",ret2="N"	;不存在日间手术
		.e  d
			..i operStat="Revoke" s ret1="N",ret2="C"
			..e  i operStat="Stop" s ret1="N",ret2="C"
			..e  i operStat="Decline" s ret1="N",ret2="C"
			..e  i operStat="Cancel" s ret1="N",ret2="C"
			..e  i operStat="DaySurgery" s ret1="Y",ret2="W"	;存在拟日间申请
			..e  s ret1="Y",ret2="A"	;存在正式申请
	s ret=ret1_"^"_ret2_"^"_opaId
	q ret
}

ClassMethod SavePersonalInfo(userId, userLocId, personalInfo)
{
	kill plist
	if ($d(^CIS.AN.PersonalDeptTempI("User",userId,userLocId))) d
	.s plist(2)=userLocId
	.s plist(3)=userId
	.s plist(4)=personalInfo
	.&SQL(update SQLUSER.CIS_AN.PersonalDeptTemp Values :plist() where UserLocID=:userLocId and UserID=:userId)

	e  d
	.s plist(2)=userLocId
	.s plist(3)=userId
	.s plist(4)=personalInfo
	.&SQL(insert into SQLUSER.CIS_AN.PersonalDeptTemp Values :plist())
	q SQLCODE
}

/// w ##class(CIS.AN.BL.DaySurgery).GetPersonalInfo(600,49)
ClassMethod GetPersonalInfo(UserId, userLocId) As %String
{
	s ret=""
	if ($d(^CIS.AN.PersonalDeptTempI("User",UserId,userLocId))) d
	.s templateId=$o(^CIS.AN.PersonalDeptTempI("User",UserId,userLocId,""))
	.s ret=$li(^CIS.AN.PersonalDeptTempD(templateId),3)
	q ret
}

/// / w ##class(CIS.AN.BL.DaySurgery).CheckIsNeedAuditAudit()
ClassMethod CheckIsNeedAuditAudit() As %String
{
	s ret=$li(^CF.AN.DataConfigD(24),2)	
	q ret
}

ClassMethod LinkEMRecords(opsId As %String, linkInsID As %String) As %String
{
	set count=$l(linkInsID,",")
	set saveResult=1
	for i=1:1:count
	{
		set linkStr=$p(linkInsID,",",i)
		set insID=$p(linkStr,"#",1)
		set flag=$p(linkStr,"#",2)
		set saveResult=##class(EMRservice.InterfaceService.Operation).setLinkByFlag(opsId,insID,flag)
		quit:(+saveResult=0)	
	}	
	
	if (+saveResult=0)
	{
		quit "E^"_saveResult	
	}
	
	quit "S^"
}

ClassMethod SaveORAnaesthesia(data As %String) As %String
{
    set rowId=$get(data("RowId")),EpisodeID=$get(data("ParentRowId"))
    set anaesthesia="",result=""
    if (##class(User.ORAnaesthesia).%ExistsId(rowId))
    {
        set anaesthesia=##class(User.ORAnaesthesia).%OpenId(rowId)  
    }   
    else
    {
        set anaesthesia=##class(User.ORAnaesthesia).%New(EpisodeID) 
    }
    set anaesthesia.ANAPAADMParRef=##class(User.PAAdm).%OpenId(EpisodeID)
    set sc=anaesthesia.%Save()
    if ($System.Status.IsError(sc))
    {
        set result="E^"_$System.Status.GetErrorText(sc,"zh-cn") 
    }
    else
    {
        set result="S^"_anaesthesia.%Id()   
    }
    quit result
}

ClassMethod SaveAnaesthesia(data As %String) As %String
{
	set anaID=$get(data("AnaID"))
	set opsId=$get(data("OpsID"))
	set result="S^"_anaID
	if (##class(CIS.AN.Anaesthesia).%ExistsId(anaID)=0)
	{
		set anaest=##class(CIS.AN.Anaesthesia).%New()
		set anaest.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set anaMethodID=$get(data("AnaMethod"))
		b	;anaest
		//set:(##class(CT.AN.AnaMethod).%ExistsId(anaMethodID)) anaest.AnaMethod=##class(CT.AN.AnaMethod).%OpenId(anaMethodID)
		set anaest.AnaMethod=anaMethodID
		set sc=anaest.%Save()
		if ($System.Status.IsError(sc))
	    {
	        set result="E^"_$System.Status.GetErrorText(sc,"zh-cn") 
	    }
	    else
	    {
	        set result="S^"_anaest.%Id()   
	    }
	}	
	else
	{
		set anaest=##class(CIS.AN.Anaesthesia).%OpenId(anaID)
		set anaest.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set anaMethodID=$get(data("AnaMethod"))
		set anaest.AnaMethod=anaMethodID
		set sc=anaest.%Save()
		if ($System.Status.IsError(sc))
	    {
	        set result="E^"_$System.Status.GetErrorText(sc,"zh-cn") 
	    }
	    else
	    {
	        set result="S^"_anaest.%Id()   
	    }
	}
	quit result
}

/// Creator：        陈长青
/// CreatDate：      2017-02-22
/// Description：    获取下一个工作日的日期
/// Table：          DHCAN.Holiday
/// Input：          baseDate:基准日期
/// Return：         下一个工作日期字符串
/// Debug:          w ##class(CIS.AN.BL.DaySurgery).GetNextWorkDay("2017-02-23")
ClassMethod GetNextWorkDay(baseDate As %String) As %String
{
    if (baseDate="")
    {
        set baseDate=+$h    
    }
    else
    {
        set baseDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(baseDate)   
    }
    
    set nextDate=baseDate+1,result=##class(CIS.AN.COM.DateTime).ConvertToDate(nextDate)
    set isHoliday=0
    set holidayId=$order(^DHCANCI("Holiday","Date",nextDate,0))
    if (##class(CT.AN.Holiday).%ExistsId(holidayId))
    {
        set holiday=##class(CT.AN.Holiday).%OpenId(holidayId)
        if (holiday.DayType'="GZR")&(holiday.DayType'="")
        {
            set isHoliday=1
        }
    }   
    else
    {
        set weekDay=$zd(nextDate,10)
        if (weekDay=0)!(weekDay=6)
        {
            set isHoliday=1 
        }   
    }
    if (isHoliday)
    {
        set result=..GetNextWorkDay(nextDate)   
    }
    
    quit result
}

/// Creator：        陈长青
/// CreatDate：      2017-02-22
/// Description：    获取默认手术室
/// Table：          DHCAN.DefaultOperDept
/// Input：          deptID:科室ID
/// Return：         默认手术科室ID
/// Debug:          w ##class(CIS.AN.BL.DaySurgery).GetDefaultOperDept("5")
ClassMethod GetDefaultOperDept(deptID As %String) As %String
{
    set result=""
    set query=##class(%ResultSet).%New("CIS.AN.BL.DataQuery:FindDefaultOperDept")
    set sc=query.Execute(deptID)
    while(query.%Next())
    {
        set result=query.Get("DeptID")  
    }
    if (+result<=0)
    {
        set query=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindDeptAdmType")
        set sc=query.Execute(deptID)
        set admType="",configCode=""
        while(query.%Next())
        {
            set admType=query.Get("AdmType")
            quit:(admType'="")
        }   
        set configCode=$case(admType,"I":"IPOperDept","O":"OPOperDept","E":"EMOperDept")
        //b //ccq
        set query=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindDataConfigurations")
        set sc=query.Execute(configCode)
        while(query.%Next())
        {
            set result=query.Get("DataValue")
            set deptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",result)
            set result=result_"^"_deptDesc  
        }
    }
    
    quit result
}

/// Creator：        陈长青
/// CreatDate：      2017-02-22
/// Description：    判断择期手术申请的是否截止
/// Table：          DHCAN.DataConfiguration
/// Input：          
/// Return：         返回"Y"表示已经截止，返回"N"表示还未截止
/// Debug:          w ##class(CIS.AN.BL.DaySurgery).JudgeAppDeadline()
ClassMethod JudgeAppDeadline() As %String
{
    set query=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindDataConfigurations")
    set sc=query.Execute("AppDeadLine")
    set deadlineH=0,deadline="",result="N"
    while(query.%Next())
    {
        set deadline=query.Get("DataValue")
        set deadlineH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(deadline,"0")  
    }
    if (deadlineH>0)&($piece($h,",",2)>deadlineH)
    {
        set result="Y"  
    }   
    quit result_"^"_deadline
}

/// Creator：        陈长青
/// CreatDate：      2017-07-28
/// Description：    判断同一个病人是否存在未完成的手术申请
/// Table：          DHCAN.OperSchedule
/// Input：          EpisodeID:就诊ID
/// Return：         如果存在返回Y，不存在返回N，错误返回"E^错误原因"
/// Debug:          w ##class(CIS.AN.BL.DaySurgery).ExistsOperApplication("24")
ClassMethod ExistsOperApplication(EpisodeID As %String) As %String
{
    set $zt="Error"
    set opsId=0,exists="N",existsDetail="",today=+$horolog
    for
    {
        set opsId=$order(^CIS.AN.OperScheduleI("Adm"," "_EpisodeID,opsId))
        quit:(opsId="")
        set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
        set statusStr=$System.SQL.UPPER("^Application^Audit^Arrange^RoomIn^")
        set operStatus=$System.SQL.UPPER("^"_operSchedule.Status.Code_"^")
        if (statusStr[operStatus)&(operSchedule.OperDate>=today)    
        {
            set exists="Y"
            set existsDetail="该病人已经申请了"_##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate)_"的手术！" 
        }
        quit:(exists="Y")
    }
    
    set result=exists
    set:(exists="Y") result=result_"^"_existsDetail
    
    quit result
Error
    set $zt=""
    quit "E^"_$ze
}

/// Creator：        陈长青
/// CreatDate：      2017-07-28
/// Description：    获取当前时间是否超过手术申请的截止时间
/// Table：          CF.AN.DataConfig
/// Input：          
/// Return：         超过截止时间返回Y，未超过返回N
/// Debug:          w ##class(CIS.AN.BL.DaySurgery).GetOperAppDeadLine()
ClassMethod GetOperAppDeadLine() As %String
{
    set now=$p($h,",",2)
    set timeDeadLine=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("AppDeadLine")
    set timeDeadLineH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(timeDeadLine,"")
    set deadLine="N"
    if (timeDeadLineH>0)
    {
        set:(now>timeDeadLineH) deadLine="Y"
    }   
    quit deadLine
}

/// Creator：        陈长青
/// CreatDate：      2017-07-28
/// Description：    根据手术类型获取默认手术日期
/// Table：          
/// Input：          
/// Return：         手术日期字符串，格式为：YYYY-MM-dd
/// Debug:          w ##class(CIS.AN.BL.DaySurgery).GetOperAppDeadLine()
ClassMethod GetOperDate(sourceType As %String) As %String
{
    set operDate=""
    if (sourceType="B")
    {
        //set operDate=..GetNextWorkDay("") 
        set operDate=##class(CIS.AN.COM.DateTime).ConvertToDate((+$h)+1)
    }   
    else
    {
        set operDate=##class(CIS.AN.COM.DateTime).ConvertToDate(+$h) 
    }
    quit operDate
}

/// Creator：        陈长青
/// CreatDate：      2017-07-28
/// Description：    获取手术申请科室默认的手术室
/// Table：          
/// Input：          
/// Return：         默认手术室的科室ID
/// Debug:          w ##class(CIS.AN.BL.DaySurgery).GetDefOperDept("49")
ClassMethod GetDefOperDept(appDeptID As %String) As %String
{
    set configCode=""
    set admType=##class(CIS.AN.BL.Admission).GetDeptAdmType(appDeptID)
    set OperDept="",OutOperDept="",EMOperDept=""
    set hospId=##class(CIS.AN.BL.Admission).GetHospIDByDept(appDeptID)
    &sql(select OperDept,OutOperDept,EMOperDept into :OperDept,:OutOperDept,:EMOperDept from CF_AN.Hospital where HospID=:hospId)
    set result=$case(admType,"I":OperDept,"O":OutOperDept,"E":EMOperDept)
    set:(result="") result=OperDept
    quit result
        
    set configCode=$case(admType,"I":"IPDefOPDept","O":"OPDefOPDept","E":"EPDefOPDept") 
    // 如果无法根据科室类型找到配置代码，那么默认为住院手术室
    set:(configCode="") configCode="IPDefOPDept"
    set configValue=##class(CIS.AN.BL.DataConfiguration).GetValueByKey(configCode)
    b //ccq
    quit configValue
}

/// Creator：        陈长青
/// CreatDate：      2017-07-28
/// Description：    获取手术申请科室默认的手术室
/// Table：          
/// Input：          
/// Return：         默认手术室的科室ID
/// Debug:          w ##class(CIS.AN.BL.DaySurgery).AuditOperation("36;37;38;39","6463")
ClassMethod AuditOperation(opsIdStr As %String, auditUser As %String) As %String
{
	set $zt="Error"
	tstart
	set splitChar=";",saveResult="E^未审核任何手术"
	set operCount=$l(opsIdStr,splitChar)
	for i=1:1:operCount
	{
		set opsId=$p(opsIdStr,splitChar,i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set auditStatusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Audit")
		set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(auditStatusID)
		set sc=operSchedule.%Save()
		if ($System.Status.IsError(sc))
		{
			set saveResult="E^"_$System.Status.GetErrorText(sc)	
		}
		else
		{
			set saveResult="S^"	
		}
		quit:($p(saveResult,"^",1)="E")
		set operArrange=##class(CIS.AN.OperArrange).%New()
		set operArrange.OperSchedule=operSchedule
		set operArrange.OperStatus=operSchedule.Status
		set operArrange.ReleaseUser=##class(CF.AN.SSUser).%OpenId(auditUser)
		set operArrange.Note="审核手术"
		set sc=operArrange.%Save()
		if ($System.Status.IsError(sc))
		{
			set saveResult="E^"_$System.Status.GetErrorText(sc)	
		}
		else
		{
			set saveResult="S^"	
		}
		quit:($p(saveResult,"^",1)="E")	
		
		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"ADT",auditUser,+$h,$p($h,",",2))
		quit:($p(saveResult,"^",1)="E")
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

// w ##class(CIS.AN.BL.DaySurgery).BatchAddApplication(100)

ClassMethod BatchAddApplication(times As %Integer) As %String
{
	set ret=""
	for i=1:1:times
	{
		set data=^TMPOPAPP("Para")
		set ret=..SaveOperApplication(data)
	}
	quit ret
}

/// w ##class(CIS.AN.BL.DaySurgery).CheckOperValid("4","5746","10209^95^30")
/// w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C","4!5746!!Oper","10209^95^30")
ClassMethod CheckOperValid(EpisodeID As %String, operId As %String, userInfo As %String) As %String
{
	s libLabel="C"
	// 4!5746!!Oper
	s input=EpisodeID_"!"_operId_"!!Oper"
	s ret=##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,libLabel,input,userInfo)
	quit RetStr
}

/// w ##class(CIS.AN.BL.DaySurgery).GetAdmInfoFromOld(830)
ClassMethod GetAdmInfoFromOld(AdmId) As %String
{
	s deathFlag=""
    s papmiId=$p($g(^PAADM(AdmId)),"^",1)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s phoneId=""
    s phoneId=$p($g(^PAPER(papmiId,"ALL")),"^",4)
    i phoneId="" s phoneId=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //手机
    //PAPER_Deceased
    s deathFlag=$p($g(^PAPER(papmiId,"ALL")),"^",12)
    s workAdd="" ;工作地址
    s workAdd=$p(^PAPER(papmiId,"PER",4),"^",18)
    s homAddress=""
    s homAddress=$g(^PAPER(papmiId,"PER","ADD",1))
    s A=##class(web.DHCANOPPREDIAG).GetAllMDiagnos(AdmId)	
	q phoneId_"^"_workAdd_"^"_homAddress_"^"_deathFlag_"^"_A
}

/// Creator：        元琳
/// CreatDate：      2020-02-20
/// Description：    保存术后登记交接班信息
/// Table：          CIS_AN.OperShift
/// Input:           data:数据字符串
/// Return：         保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.DaySurgery).SaveOperRegister(127,^TEMPReg("Reg"))
ClassMethod SaveOperRegister(opsId As %String, data As %String) As %String
{
	set ^TEMPReg("Reg")=data
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    set objIndex=0
    set shiftId=""
	set result="S^"
	b
    for
    {
	    set objIndex=$order(array(objIndex))
	    quit:(objIndex="")
	    kill operRegister
	    merge operRegister=array(objIndex)
	    &sql(select RowId into :shiftId from CIS_AN.OperShift where OperSchedule=:opsId)
	    if (##class(CIS.AN.OperShift).%ExistsId(shiftId))
	    {
		    set shift=##class(CIS.AN.OperShift).%OpenId(shiftId)
		}
		else
		{
			set shift=##class(CIS.AN.OperShift).%New()
			set shift.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		}
		set ShiftCareProvID=$get(operRegister("ShiftCareProvID"))
	    set shift.ShiftCareProvID=##class(CF.AN.SSUser).%OpenId(ShiftCareProvID)
	    
		set ReliefCareProvID=$get(operRegister("ReliefCareProvID"))
	    set shift.ReliefCareProvID=##class(CF.AN.SSUser).%OpenId(ReliefCareProvID)
	    
		set shift.ShiftDate=$p($get(operRegister("ShiftDT"))," ",1)
		set shift.ShiftTime=$p($get(operRegister("ShiftDT"))," ",2)
		
		set CareProvDept=$get(operRegister("DeptID"))
	    set shift.CareProvDept=##class(CF.AN.Department).%OpenId(CareProvDept)
	    
		set sc=shift.%Save()
		if ($System.Status.IsError(sc))
		{
			set result="E^"_$System.Status.GetErrorText(sc,"zh-cn")
		}
		else
		{
			set result="S^"_shift.%Id()
		}
		quit:($piece(result,"^",1)'="S")
	    
    }
	q result
}

/// Creator：        元琳
/// CreatDate：      2020-02-20
/// Description：    术后登记会更新部分关键时间字段(入室/离室/入区/离区)
/// Table：          CIS.AN.Anaesthesia
/// Input:           data:数据字符串
/// Return：         保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.DaySurgery).SaveOperEventDT(123,"2020-06-02 11:00:00","2020-06-02 12:00:00","","")
ClassMethod SaveOperEventDT(opsId As %String, TheatreInDT As %String, TheatreOutDT As %String, AreaInDT As %String, AreaOutDT As %String, userId As %String) As %String
{
	set ANRowId=""
	set result="S^"
	&sql(select RowId into :ANRowId from CIS_AN.Anaesthesia where OperSchedule=:opsId)
	if (##class(CIS.AN.Anaesthesia).%ExistsId(ANRowId))
	{
		set AnaRegister=##class(CIS.AN.Anaesthesia).%OpenId(ANRowId)
	}
	else
	{
		set AnaRegister=##class(CIS.AN.Anaesthesia).%New()
		set AnaRegister.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	}
	if (TheatreInDT'="") set AnaRegister.OperStartDT=TheatreInDT
	if (TheatreOutDT'="") set AnaRegister.OperFinishDT=TheatreOutDT
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPS",userId,##class(CIS.AN.COM.DateTime).ConvertToDateH($p(TheatreInDT," ",1),""),##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(TheatreInDT," ",2),""))
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPF",userId,##class(CIS.AN.COM.DateTime).ConvertToDateH($p(TheatreOutDT," ",1),""),##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(TheatreOutDT," ",2),""))
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"FNH",userId,+$h,$p($h,",",2))

	if (AreaInDT'="") set AnaRegister.AreaInDT=AreaInDT
	if (AreaOutDT'="") set AnaRegister.AreaOutDT=AreaOutDT
	
	set sc=AnaRegister.%Save()
	if ($System.Status.IsError(sc))
	{
		set result="E^"_$System.Status.GetErrorText(sc,"zh-cn")
	}
	else
	{
		s retCircle1=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,userId,"11")
		s retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,userId,"12")

		set result="S^"_AnaRegister.%Id()
		//---直接改表中数据
	set operScheduleD=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set opaId=operScheduleD.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operOldArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operOldArrange.OPAEndDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(AnaRegister.OperFinishDT," ",1),"")
	set operOldArrange.OPAEndTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(AnaRegister.OperFinishDT," ",2),"")

		//
	}	
	q result
}

/// w ##class(CIS.AN.BL.DaySurgery).GetIfOutOperLoc(49)
ClassMethod GetIfOutOperLoc(ctlocId As %String = "") As %String
{
	q:ctlocId="" ""	

	s function="",ctlocDesc=""
	if ctlocId'=""
	{
	  s ctlocDesc=$P(^CTLOC(ctlocId),"^",2)
	  s function=$P(^CTLOC(ctlocId),"^",13)
	}
	//q:function'="OP" ""
	s ctlocIdList=""
	s type="OUTOP"
	i function'="OP" s type="OUTOPDEPT"
	s locListId=$o(^CT("LL",0,"Code",type,""))
	q:locListId=""
	s locListLocId=0
	f  s locListLocId=$o(^CT("LL",locListId,"LOC",locListLocId)) q:locListLocId=""  d
		.s octlocId=$p(^CT("LL",locListId,"LOC",locListLocId),"^")
		.q:octlocId=""
		.q:'$d(^CTLOC(octlocId))
		.i ctlocIdList'="" s ctlocIdList=ctlocIdList_"^"
		.s ctlocIdList=ctlocIdList_octlocId
	;b
	s ret=""
	i ("^"_ctlocIdList_"^")[("^"_ctlocId_"^") s ret="OUT"
	q ret
}

// w ##class(CIS.AN.BL.DaySurgery).GetUserType()

ClassMethod GetUserType(userId As %String) As %String
{
	//取用户的类别:医生还是护士
	q:userId="" "用户有误!"
	set userObj=##class(User.SSUser).%OpenId(userId)
	s ctpcpId=userObj.SSUSRCareProvDR.%Id()
	q:ctpcpId="" "该用户未关联医护人员!"
	set ctcpObj=##class(User.CTCareProv).%OpenId(ctpcpId)
	s ctcptId=ctcpObj.CTPCPCarPrvTpDR.%Id()  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptTypeObj=##class(User.CTCarPrvTp).%OpenId(ctcptId)  ;CT_CarPrvTp:CTCPT_InternalType
	s ctcptTypeId=ctcptTypeObj.CTCPTCode
	q:ctcptTypeId="" "医护人员类型定义有误!"
	s ctcptType=ctcptTypeObj.CTCPTInternalType
	q ctcptType
}

/// w ##class(CIS.AN.BL.DaySurgery).UpdateOpRoomAndOrdNo(80,7)
/// 更新手术申请的手术间和台次
/// w ##class(CIS.AN.BL.DaySurgery).GetOpRoomOrder(65456,8,80,30)
ClassMethod UpdateOpRoomAndOrdNo(opsId As %String = "", roomId As %String = "", userId As %String = "") As %String
{
	tstart
	s opsId=+opsId
	s maxNo=30
	q:(opsId=0)!(opsId="") "手术申请不存在!"
	q:roomId="" "未安排手术间!"
	set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    s ordNo=..GetOpRoomOrder(operScheduleObj.OperDate,roomId,opsId,maxNo)
    s ordNo=+ordNo
    q:ordNo=0 "自动计算台次错误"
	s retStr=""
	s status="Arrange"
	;s userId=%session.Data("LOGON.USERID")
	s operScheduleObj.OperRoom=##class(CF.AN.Location).%OpenId(roomId)
	s operScheduleObj.OperSeq=ordNo
	set operStatus=	##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
	set operScheduleObj.Status=##class(CT.AN.OperStatus).%OpenId(operStatus)
	set sc=operScheduleObj.%Save()
	set retResult=..ChangeOpStatus(opsId,"Arr")
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPA",userId,+$h,$p($h,",",2))
	quit:($p(saveResult,"^",1)="E") "状态更新出错"
	//20211214
	s retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,userId,"5")

	//改变医嘱状态(核实->执行) YL 20200612
		set opaId=operScheduleObj.ExternalID
		set oeordId=operScheduleObj.AppOrderItem
		if (operScheduleObj.AppOrderItem)
		{
		//set anaId=$p(^DHCANOPArrange(opaId),"^",2)
		//set ordId=$o(^OEORDi(0,"Ana",anaId,""))
		//set ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
		
		//set orderret=##class(appcom.OEOrdItem).Verify(ordId_"||"_ordSubId,userId)
		//set orderret=##class(appcom.OEOrdItem).Execute(ordId_"||"_ordSubId,userId)
		set orderret=##class(appcom.OEOrdItem).Execute(oeordId,userId)
		}
	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)    

	tcommit
	q ordNo
}

ClassMethod ChangeOpStatus(opsId, type) As %String
{
	set opaId="",oldRoomId=""
	&sql(select ExternalID into :opaId from CIS_AN.OperSchedule where  RowId=:opsId)
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	if (operSchedule.OperRoom) set oldRoomId=operSchedule.OperRoom.ExternalID
	i opaId'="" d
		.i type="Arr" d
		..s $P(^DHCANOPArrange(opaId),"^",27)="R"
		..s $P(^DHCANOPArrange(opaId),"^",20)=oldRoomId
		..s $P(^DHCANOPArrange(opaId),"^",26)=operSchedule.OperSeq
		.i type="Reg" d
		..s $P(^DHCANOPArrange(opaId),"^",27)="F"
		..s $P(^DHCANOPArrange(opaId),"^",20)=oldRoomId
		..s $P(^DHCANOPArrange(opaId),"^",26)=operSchedule.OperSeq
		.i type="Del" d
		..s $P(^DHCANOPArrange(opaId),"^",27)="A"
		..s $P(^DHCANOPArrange(opaId),"^",20)=""
		..s $P(^DHCANOPArrange(opaId),"^",26)=""
		.i type="DaySurgery" d
		..s $P(^DHCANOPArrange(opaId),"^",27)="A"
	q "S^0"
}

/// 得到手术间按次序应安排的台次
ClassMethod GetOpRoomOrder(opDate As %String = "", roomId As %String = "", opaId As %String = "", maxNo As %String = "")
{
      //s ^TMPzt("testStr")=opDate_"/"_roomId_"/"_opaId_"/"_maxNo
      q:roomId="" ""
      q:opaId="" ""
      k ^TMPOPArr
      k ^TMPOPSort
      ;i opDate'="" s nowDate=$ZDH(opDate,3)
      i opDate'="" s nowDate=##Class(web.DHCANOPCom).ConvertToDateH(opDate)
	  e  s nowDate=+$H
	  set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opaId)
	  
	  s cacheOpDate=operSchedule.OperDate
	  q:nowDate'=cacheOpDate "前台时间和后台时间不一致"
	  f i=1:1:maxNo d
	  .s ^TMPOPArr(i)=i
      s rowId=""
	  f  s rowId=$O(^CIS.AN.OperScheduleI("OPDate",nowDate,rowId))  q:(rowId="")  d
	    .q:rowId=opaId
	    .set tmpSchedule=##class(CIS.AN.OperSchedule).%OpenId(rowId)
		.s opRoomId=tmpSchedule.OperRoom
	    .i (opRoomId'="") s opRoomId=tmpSchedule.OperRoom.%Id()
        .q:(opRoomId="")!(opRoomId'=roomId)
        .s status=tmpSchedule.Status
        .q:(status="Cancel")!(status="Decline")
        .b
        .s ordNo=tmpSchedule.OperSeq
        .q:ordNo=""
        .s ^TMPOPArr(ordNo)=0
      s n=""
      f  s n=$o(^TMPOPArr(n)) q:n=""  d
      .s r=+$g(^TMPOPArr(n))
      .q:r=0
      .s ^TMPOPSort(r)=r
      s min=$o(^TMPOPSort(""))
      q min
}

/// 门诊申请默认手术室，以后考虑改造
/// w ##class(CIS.AN.BL.DaySurgery).GetOperDeptID(107)
ClassMethod GetOutOperDeptID(OPSID) As %String
{
	s operValue=""
	if (OPSID="")
	{
	set DataKey="OPDefOPDept"
	&sql(select DataValue into :operValue from CF_AN.DataConfig where DataKey=:DataKey)	
	}
	else
	{
	&sql(select OperDeptID into :operValue from CIS_AN.OperSchedule where RowId=:OPSID)	

	}
	q operValue
}

/// 日间默认手术室
ClassMethod GetDefOperDeptID(deptId) As %String
{
	set DataKey="IPDefOPDept"
	s operValue=""
	&sql(select DataValue into :operValue from CF_AN.DataConfig where DataKey=:DataKey)	
	q operValue
}

ClassMethod GetPlanSurLocId(OPSID) As %String
{
	set operList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",OPSID)
	set operObj=operList.GetAt(1)
	s surLocId=operObj.GetValue("SurgeonDeptID")
	q surLocId
}

/// 手术安排
/// w ##class(CIS.AN.BL.DaySurgery).SaveOutArrInfo(133,"CircleNurse^486")
ClassMethod SaveOutArrInfo(OPSID, valStr) As %String
{
	set saveResult=OPSID
	s operExtendId=""
	set planOperListId="",count=0

	set planOperListId=$o(^CIS.AN.PlanOperListI("IOPS",OPSID,""))
	quit:(planOperListId="")
	set planOperList=##class(CIS.AN.PlanOperList).%OpenId(planOperListId)
	set operExtendId=planOperList.ExternalID
	s item=$p(valStr,"^",1)
	s value=$p(valStr,"^",2)
	if (item="PlanSurgeonDesc")
	{
	&sql(update CIS_AN.PlanOperList set Surgeon=:value where OperSchedule=:OPSID and ExternalID=:operExtendId)
	set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
	&sql(update CIS_AN.OperList set Surgeon=:value where OperSchedule=:OPSID and ExternalID=:operExtendId)
	set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
	}
	elseif (item="CircleNurse") 
	{
	&sql(update CIS_AN.operschedule set CircualNurse=:value where RowId=:OPSID)
	set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(OPSID)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(OPSID)	

		set anaestOperId=""
	&sql(select top 1 %ID into :anaestOperId from SQLUser.OR_Anaest_Operation where ANAOP_Par_Ref=:operSchedule.ExtAnaestID)
	quit:(##class(User.ORAnaestOperation).%ExistsId(anaestOperId)=0) "E^主手术不存在！"
	b	;
		&sql(delete from SQLUser.OR_An_Oper_Circul_Nurse where CIRN_ParRef=:anaestOperationId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)

	&sql(insert into SQLUser.OR_An_Oper_Circul_Nurse (CIRN_ParRef,CIRN_CTCP_DR)
			  values (:anaestOperId,:value))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)

	}
	q saveResult
}

/// w ##class(CIS.AN.BL.DaySurgery).ChangeOperSeq(81,2)
ClassMethod ChangeOperSeq(opsId As %String, moveDirection As %String = "") As %String
{
	quit:(moveDirection="") "E^移动方向不能为空。"
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术申请记录不存在。"	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	quit:(operSchedule.OperRoom="") "E^患者"_operSchedule.PatName_"的手术还未安排手术间。"
	;set roomOperList=##class(CIS.AN.BL.OperArrange).GetRoomOperList(operSchedule.OperDate,operSchedule.OperDeptID,operSchedule.OperRoom.%Id())

	set $zt="Error"
	tstart
	set saveResult="S^"
	set operSchedule.OperSeq=moveDirection
	set sc=operSchedule.%Save()
	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
	quit:($System.Status.IsError(sc))
	
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit moveDirection
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.DaySurgery).RevokeArrange(81,69)
ClassMethod RevokeArrange(opsIdPara As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	set opsIdCount=$length(opsIdPara,"^")
	set saveResult="S^"
	for i=1:1:opsIdCount
	{
		set opsId=$piece(opsIdPara,"^",i)
		&sql(update CIS_AN.operschedule set status=1,operSeq=null,operroom=null,ScrubNurse=null,CircualNurse=null where RowId=:opsId)
		set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^撤回失败。"
		//set saveResult=##class(CIS.AN.BL.Interface).RevokeArrange(opsId)
		set saveResult=..ChangeOpStatus(opsId,"Del")
		quit:($piece(saveResult,"^",1)="E")
		set arrangeLog=##class(CIS.AN.BL.OperArrange).CreateArrangeLog(opsId,"",userId)
		set arrangeLog.Note="撤回排班"
		set status=arrangeLog.%Save()
		if ($System.Status.IsError(status))
		{
			set saveResult="E^"_$System.Status.GetErrorText(status)	
		}
		quit:($piece(saveResult,"^",1)="E")
		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"RA",userId,+$h,$p($h,",",2))
		quit:($p(saveResult,"^",1)="E")

	}
	if ($piece(saveResult,"^",1)="S")
	{
		// 调用接口回写旧表
		set statusCode="A"
		set saveResult=##class(CIS.AN.SRV.OperAppService).RevokeArrange(opsId,statusCode)
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

/// w ##class(CIS.AN.BL.DaySurgery).GetOutInLinkID(59)
ClassMethod GetOutInLinkID(deptID) As %String
{
	q:(deptID="") -3
	s linkin="",linkRowId="",DayLocId="",linkLocId=""
	f  s linkRowId=$o(^CF.AN.DepartmentD(linkRowId)) q:linkRowId=""  d
	.;b
	.q:$d(^CF.AN.DepartmentD(linkRowId))<1
	.s DayLocId=$lg(^CF.AN.DepartmentD(linkRowId),4)
	.s sourceLocId=$lg(^CF.AN.DepartmentD(linkRowId),1)
	.q:(sourceLocId'=deptID)&(DayLocId'=deptID)
	.i (sourceLocId=deptID) s linkLocId=DayLocId
	.e  s linkLocId=sourceLocId
	q linkLocId
}

// w ##class(CIS.AN.BL.DaySurgery).GetOutLinkInLocId(16)

ClassMethod GetOutLinkInLocId(deptID)
{
	q:deptID="" -3
	s linkin="",linkLocId=deptID,linkRowId=""
	f  s linkRowId=$o(^CF.AN.DepartmentD(linkRowId)) q:linkRowId=""  d
		.q:$d(^CF.AN.DepartmentD(linkRowId))<1
		.s sourceLocId=$lg(^CF.AN.DepartmentD(linkRowId),1)
		.q:sourceLocId'=deptID
		.s linkLocId=$lg(^CF.AN.DepartmentD(linkRowId),4)

	q linkLocId
}

/// w ##class(CIS.AN.BL.DaySurgery).CheckDayOperAnAudit(827)
/// 入参：就诊号
/// 返回值：是否已做麻醉评估^日间手术是否需要麻醉评估
/// 返回Y：已做麻醉评估，N：未做麻醉评估
/// 只适合日间
ClassMethod CheckDayOperAnAudit(AdmId) As %String
{
	s ret="",canvalue=""
	s isNeedAnAudit=..GetIfNeedAnAudit("DaySurgeryANAssessment")
	//$g(^DHCCLSet("AnOp","DayOperNeedAN"))
	s opaId=$o(^DHCANOPArrange(0,"Adm",AdmId,""),-1)
	i opaId="" s ret="N"
	e  d
		.b	;这块加是否进行了麻醉评估
		.s canvalue=..GetOperAnAuditData(opaId,"IsCanDayOper")
		.s ret="Y"
	q ret_"^"_isNeedAnAudit_"^"_canvalue
}

/// w ##class(CIS.AN.BL.DaySurgery).GetOperAnAuditData(265,"IsCanDayOper")
ClassMethod GetOperAnAuditData(opaId As %String, dataItem As %String) As %String
{
	set operDataID="",operSheetId="",dataValue="",stat=""
	&sql(select RowId into :operDataID  from CIS_AN.OperSchedule where  ExternalID=:opaId)
	//&sql(select RowId into :operSheetId from CIS_AN.RecordSheet where  OperSchedule=:operDataID)
	s operSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(operDataID,"AN_ANS_018","")

	&sql(select DataValue into :dataValue from CIS_AN.OperData where RecordSheet=:operSheetId and DataItem=:dataItem)
	quit dataValue
}

ClassMethod GetIfNeedAnAudit(key)
{
	set DataKey=""
	&sql(select DataValue into :DataKey from CF_AN.DataConfig where DataKey=:key)

	q DataKey
}

/// w ##class(CIS.AN.BL.DaySurgery).CheckValidDayOper(1775)
/// 入参：就诊号，
/// 返回Y^A^数字，存在正式日间申请
/// 返回Y^W^数字，存在拟日间申请
/// 返回N^N^数字，不存在日间手术
/// 返回N^C^数字，存在撤销的拟日间申请
/// 只适合日间
ClassMethod CheckValidDayOper(AdmId) As %String
{
	s ret1="",ret2="",ret=""
	s opaId=$o(^DHCANOPArrange(0,"Adm",AdmId,""),-1)
	i opaId="" s ret1="N",ret2="N"
	e  d
		.s operStat=$P($g(^DHCANOPArrange(opaId)),"^",27)
		.s anaId=$P($g(^DHCANOPArrange(opaId)),"^",2)
		.s anasub=$p(anaId,"||",2)
		.s adm=AdmId
		.s chl=anasub
		.s anaOpSubTmp2="",inum=0,anaOpSubTmp=""
		.f  s anaOpSubTmp2=$o(^OR(adm,"ANA",chl,"OP",anaOpSubTmp2)) q:(anaOpSubTmp2="")!(inum>0)  d
		..s inum=anaOpSubTmp2
		..i inum>0 s anaOpSubTmp=inum
		.s dayOperFlag=$P(^OR(AdmId,"ANA",anasub,"OP",anaOpSubTmp),"^",22)
		.i dayOperFlag'="Y" d
			..s ret1="N",ret2="N"	;不存在日间手术
		.e  d
			..i operStat="C" s ret1="N",ret2="C"
			..e  i operStat="D" s ret1="N",ret2="C"
			..e  i operStat="S" s ret1="Y",ret2="W"	;存在拟日间申请
			..e  s ret1="Y",ret2="A"	;存在正式申请
	s newOPSID=..GetNewOpaIDByOld(opaId)
	s ret=ret1_"^"_ret2_"^"_newOPSID
	q ret
}

/// /// w ##class(CIS.AN.BL.DaySurgery).GetNewOpaIDByOld(253)
ClassMethod GetNewOpaIDByOld(opaId)
{
		set operDataID=""
	&sql(select RowId into :operDataID from CIS_AN.OperSchedule where  ExternalID=:opaId)

	q operDataID
}

/// w ##class(CIS.AN.BL.DaySurgery).CancelOutOperation(107,"手术条件不具备",32)
ClassMethod CancelOutOperation(opsId As %String, reason As %String, cancelUserId As %String) As %String
{
	set $zt="Error"
	tstart
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set cancelStatusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Cancel")	
	set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(cancelStatusID)
	set oldOeordId=operSchedule.AppOrderItem
	set sc=operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	set operArrange=##class(CIS.AN.OperArrange).%New()
	set operArrange.OperSchedule=operSchedule
	set operArrange.ReleaseUser=##class(CF.AN.SSUser).%OpenId(cancelUserId)
	set operArrange.OperStatus=operSchedule.Status
	set operArrange.Note=reason
	set sc=operArrange.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	&SQL(Select ExternalID into :UserId from CF_AN.SSUser where RowId=:cancelUserId)
	//set saveResult=##class(CIS.AN.SRV.OperAppService).CancelApplication(opsId,UserId)	// 取消手术回写旧表
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operOldArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operOldArrange.OPAStatus="C"
	set sc=operOldArrange.%Save()
	i oldOeordId'="" set cancelret= ##class(web.UDHCStopOrderLook).StopOrder("","",oldOeordId,cancelUserId,"","N")
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"CCL",cancelUserId,+$h,$p($h,",",2)) 
	if ($p(saveResult,"^",1)'="S")
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

/// w ##class(CIS.AN.BL.DaySurgery).GetOutDiagnosis(830)
ClassMethod GetOutDiagnosis(EpisodeID As %String) As %String
{
		s rset=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindAdmDiagnosis")
	s ret=""
	do rset.Execute(EpisodeID,"OP")
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(9)
		e  s ret=ret_","_rset.GetData(9)
	}	
	d rset.Close()
	q ret
}

ClassMethod CheckRoomData()
{
	//w ##class(CIS.AN.BL.DaySurgery).CheckRoomData()
	s oprId=0
	f  s oprId=$o(^DHCANC("OPRoom",oprId)) q:oprId=""  d
		.q:$p(^DHCANC("OPRoom",oprId),"^",7)="N"  //停用的手术间不起用
		.s opercode=$P(^DHCANC("OPRoom",oprId),"^",1)
		.s newrowid=""
		.&sql(select rowid into :newrowid from CF_AN.Location where code=:opercode)
		.i newrowid="" d
		..q:($p(^DHCANC("OPRoom",oprId),"^",7)="N")
		..s $p(^DHCANC("OPRoom",oprId),"^",7)="N"
		..w oprId_"@"
		.e  d
		..s newrowid2=""
		..&sql(select rowid into :newrowid2 from CF_AN.Location where code=:opercode and ExternalID=:oprId)
		..i newrowid2="" d
		...;扩展表不存在
		...q:($p(^DHCANC("OPRoom",oprId),"^",7)="N")
		...s $p(^DHCANC("OPRoom",oprId),"^",7)="N"
		...w oprId_"!"
		

	q "ok"
}

/// w ##class(CIS.AN.BL.DaySurgery).CheckAdmValid(就诊号,安全组id,2)
ClassMethod CheckAdmValid(Adm, groupId, hospId)
{
	i hospId="" s hospId=2
	s retStr="",LimitType="",timeNum=0
	s today=+$h
	s time=$p($h,",",2)
	s PAADMDate=$p(^PAADM(Adm),"^",6)     /// 就诊日期
	s PAADMTime=$p(^PAADM(Adm),"^",7)
	s admType=$p(^PAADM(Adm),"^",2)
	s VisitStatus=$p(^PAADM(Adm),"^",20)
	s CurrentWard=$p(^PAADM(Adm),"^",70)  ///急诊抢救、留观患者申请手术不限制挂号时间，只要未出院均可申请
	i VisitStatus="D" q "患者已出院不能申请手术"
	i CurrentWard'="" q retStr
	s IfPilotAdm=##Class(web.PilotProject.DHCDocPilotProCommon).CheckPilotAdm(Adm)
	i admType="O" d
		.s OPAdmDayLimit=##Class(web.DHCDocConfig).GetConfigNode("OPAdmDayLimit",hospId)
		.b ;2
		.s LimitType1=##Class(web.DHCDocConfig).GetConfigNode("OPLimitType",hospId)
		.i LimitType1="Hour" s LimitType="小时",timeNum=OPAdmDayLimit*$zth("01:00",2)
		.;timeNum=$zth(OPAdmDayLimit,2)
		.i LimitType1="Day" s LimitType="天"
		.i OPAdmDayLimit="" s OPAdmDayLimit=1
		.i LimitType1="Day" d
			..i (today-PAADMDate>(OPAdmDayLimit-1))&&(IfPilotAdm'=1)  s retStr="此就诊记录的挂号在"_OPAdmDayLimit_LimitType_"以前,不允许再开申请."
		.i LimitType1="Hour" d
			..i (((today-PAADMDate)*86400+(time-PAADMTime))>timeNum)&&(IfPilotAdm'=1)  s retStr="此就诊记录的挂号在"_OPAdmDayLimit_LimitType_"以前,不允许再开申请."
	i admType="E" d
	.s EPAdmDayLimit=##Class(web.DHCDocConfig).GetConfigNode("EPAdmDayLimit",hospId)
	.s LimitTypeE=##Class(web.DHCDocConfig).GetConfigNode("EPLimitType",hospId)
	.i LimitTypeE="Hour" d
		..s LimitTypeE="小时",timeNume=EPAdmDayLimit*$zth("01:00",2)
		..;timeNume=$zth(EPAdmDayLimit,2)
		..i (((today-PAADMDate)*86400+(time-PAADMTime))>timeNume)&&(IfPilotAdm'=1)  s retStr="此就诊记录的挂号在"_EPAdmDayLimit_LimitTypeE_"以前,不允许再开申请."
	.i LimitTypeE="Day" d
		..s LimitType="天"
		..i (today-PAADMDate>(EPAdmDayLimit-1))&&(IfPilotAdm'=1)  s retStr="此就诊记录的挂号在"_EPAdmDayLimit_LimitType_"以前,不允许再开申请."
	s NoAdmValidDaysLimit=##Class(web.DHCDocConfig).GetConfigNode1("NoAdmValidDaysLimit",groupId)
	i NoAdmValidDaysLimit=1 s retStr=""

	q retStr
}

/// 20201020 20201022 批量确认日间手术
/// w ##class(CIS.AN.BL.DaySurgery).batchConfirmDayOper("8,9")
ClassMethod batchConfirmDayOper(opsIdList As %String) As %String
{
	    quit:(opsIdList="") "E^手术ID不能为空!"
		set $zt="Error"
	    tstart
	    set saveResult="S^"
	    for i=1:1:$l(opsIdList,",")
	    {
		    set opsId=$p(opsIdList,",",i)
		    set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) saveResult="E^不存在ID为"_opsId_"的手术！"
	        set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		    if ((operScheduleObj.DaySurgery="Y")&&(operScheduleObj.Status.Code="DaySurgery"))   
		    {
			    // 插入手术申请医嘱
                set saveResult=##class(CIS.AN.BL.OperOrder).SaveAppOrderItem(opsId) 
                quit:($p(saveResult,"^")="E")
			    if ($piece(saveResult,"^",1)="S")
                 {
	               // 如果插入手术申请医嘱成功，那么将医嘱ID保存到CIS_AN.OperSchedule表，方便直接调用。
	    	         set orderItemID=$p(saveResult,"^",2)
	    	         set operScheduleObj.AppOrderItem=orderItemID
	    	         set applicationStatusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Application")	
	                 set operScheduleObj.Status=##class(CT.AN.OperStatus).%OpenId(applicationStatusID)
	    	         set sc=operScheduleObj.%Save()
	    	         set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)    
	    	         set resultStatus=..ChangeOpStatus(opsId,"DaySurgery")
	              }  
			   
		    }
	   }
	   if ($piece(saveResult,"^",1)'="S")
	   {
		   trollback
		   quit saveResult	
	   }
	tcommit
	quit saveResult
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.DaySurgery).GetDSSurgeonDept("73")
ClassMethod GetDSSurgeonDept(deptId As %String) As %String
{
	quit:(deptId="")!(+deptId<=0) ""
	quit:('$d(^CTLOC(+deptId))) ""
	set deptConfigId=$o(^CF.AN.DepartmentI("IDept"," "_deptId,0))
	quit:(##class(CF.AN.Department).%ExistsId(deptConfigId)=0) ""
	set deptConfig=##class(CF.AN.Department).%OpenId(deptConfigId)
	set rowData=##class(%DynamicObject).%New()
	set rowData.DSSurgeonDept=deptConfig.DSSurgeonDept
	set rowData.DSAdmDept=deptConfig.DSAdmDept
	set deptConfig=""
	quit rowData.%ToJSON()
}

/// w ##class(CIS.AN.BL.DaySurgery).GetDSSurgeonDept("73")
ClassMethod GetDSSurgeonDeptObj(deptId As %String) As %String
{
	quit:(deptId="")!(+deptId<=0) ""
	quit:('$d(^CTLOC(+deptId))) ""
	set deptConfigId=$o(^CF.AN.DepartmentI("IDept"," "_deptId,0))
	quit:(##class(CF.AN.Department).%ExistsId(deptConfigId)=0) ""
	set deptConfig=##class(CF.AN.Department).%OpenId(deptConfigId)
	set rowData=##class(%DynamicObject).%New()
	set rowData.DSSurgeonDept=deptConfig.DSSurgeonDept
	set rowData.DSAdmDept=deptConfig.DSAdmDept
	set deptConfig=""
	quit rowData
}

/// w ##class(CIS.AN.BL.DaySurgery).GetDaySurgeryQty("2021-08-01","2021-12-30","DaySurgery^Application^Audit^Receive^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish","")
ClassMethod GetDaySurgeryQty(startDate As %String, endDate As %String, status As %String, surgeonId As %String = "") As %String
{
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	k ^TMPAN("DSQty",$j)
	&sql(declare OPSListCursor cursor for select %ID
		into :RowId from CIS_AN.OperSchedule 
		where OperDate>=:startDateH 
		and OperDate<=:endDateH
		and DaySurgery='Y')
	&sql(open OPSListCursor)
	for
	{
		&sql(fetch OPSListCursor)
		quit:(SQLCODE'=0)
		set opsInfo=^CIS.AN.OperScheduleD(RowId)
		set operDate=$li(opsInfo,14)
		set statusID=$li(opsInfo,9),statusCode=$lg($g(^CT.AN.OperStatusD(+statusID)),1)
		continue:(("^"_status_"^") '[ ("^"_statusCode_"^"))
		set surgeon=$$GetSurgeon()
		continue:(surgeonId'="")&((","_surgeon_",")'[ (","_surgeonId_","))
		set ^TMPAN("DSQty",$j,operDate,RowId)=""
	}
	&sql(close OPSListCursor)
	/*for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$o(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:(operSchedule.DaySurgery'="Y")
			continue:(("^"_status_"^") '[ ("^"_operSchedule.Status.Code_"^"))
			set operScheduleObj=##class(CIS.AN.BL.OperScheduleList).GetOperScheduleObject(opsId)
			b:(opsId=4620) //ccq
			continue:(surgeonId'="")&((","_operScheduleObj.Surgeon_",")'[ (","_surgeonId_","))
			set ^TMPAN("DSQty",$j,operSchedule.OperDate,opsId)=""	
		}
	}*/
	
	set operDateH=0,rowDataArr=##class(%DynamicArray).%New()
	for
	{
		set operDateH=$o(^TMPAN("DSQty",$j,operDateH))
		quit:(operDateH="")
		set opsId=0,rowData=##class(%DynamicObject).%New()
		set rowData.OperDate=$zd(operDateH,3)
		//##class(CIS.AN.COM.DateTime).ConvertToDate(operDateH,"")
		set rowData.OperQty=0
		for
		{
			set opsId=$o(^TMPAN("DSQty",$j,operDateH,opsId))
			quit:(opsId="")
			set rowData.OperQty=rowData.OperQty+1	
		}
		
		do rowDataArr.%Push(rowData)
	}
	quit rowDataArr.%ToJSON()
GetSurgeon()
	set operDescId=0,curSurgeonID=""
	for
	{
		set operDescId=$o(^CIS.AN.OperListI("IOPS",RowId,operDescId))
		quit:(operDescId="")
		set curSurgeonID=curSurgeonID_$lb($li(^CIS.AN.OperListD(operDescId),7))_$lb($li(^CIS.AN.OperListD(operDescId),8))	
	}
	quit $lts(curSurgeonID,",")
}

ClassMethod GetFollowupList(startDate As %String) As %String
{
}

ClassMethod SaveDSNote(opsId As %String, DSNote As %String) As %String
{
	set $zt="Error"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	quit:(operSchedule="") "E^手术申请不存在"
	set operSchedule.DaySurgeryNote=DSNote
	set sc=operSchedule.%Save()
	set ret="S^"
	set:($System.Status.IsError(sc)) ret="E^"_$System.Status.GetErrorText(sc)
	quit ret
Error
	quit "E^"_$ze
}

ClassMethod CanConfirmDaySurgery(opsIdStr As %String) As %String
{
	quit:(opsIdStr="") "E^手术ID为空"
	set opsCount=$l(opsIdStr,",")
	set confirmMsg=""
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,",",i)
		continue:('##class(CIS.AN.OperSchedule).%ExistsId(opsId))
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set patInfo=##class(CIS.AN.BL.OperSchedule).GetPatInfo(operSchedule.EpisodeID)
		set:(operSchedule.Status.Code'="DaySurgery") confirmMsg=confirmMsg_$lb("患者"_patInfo.PatName_"的手术状态为【"_operSchedule.Status.Description_"】不能确认手术") 	
	}
	if (confirmMsg'="")
	{
		quit "E^"_$lts(confirmMsg,";")	
	}	
	quit "S^"
}

/// 退出日间
ClassMethod BowOutDaySurgery(opsId As %String, reason As %String, userId As %String) As %String
{
	quit:('##class(CIS.AN.OperSchedule).%ExistsId(opsId)) "E^不存在手术ID为"_opsId_"的手术申请"
	set $zt="BowOutError"
	tstart
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	if ("^DaySurgery^Application^Decline^" [ ("^"_operSchedule.Status.Code_"^"))
	{
		set statusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("BODaySurgery")
		set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(statusID)
	}
	set operSchedule.DaySurgery="D"
	
	set sc=operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set operArrange=##class(CIS.AN.OperArrange).%New()
	set operArrange.OperSchedule=operSchedule
	set operArrange.ReleaseUser=userId //##class(CF.AN.SSUser).%OpenId(cancelUserId)
	set operArrange.OperStatus=operSchedule.Status
	set operArrange.Note="退出日间;"_reason
	set sc=operArrange.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"BOD",userId,+$h,$p($h,",",2))
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	tcommit
	quit "S^"
BowOutError
	trollback
	quit "E^"_$ze
}

/// 完成日间手术
ClassMethod FinishDaySurgery(opsIdStr As %String, userId As %String) As %String
{
	set $zt="FinishDSError"
	tstart
	set opsCount=$l(opsIdStr,","),saveRet="S^"
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,",",i)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set patInfo=##class(CIS.AN.BL.OperSchedule).GetPatInfo(operSchedule.EpisodeID)
		set:("^DaySurgery^" '[ ("^"_operSchedule.Status.Code_"^")) saveRet="E^患者"_patInfo.PatName_"的日间手术状态为【"_operSchedule.Status.Description_"】，不能完成手术。"
		quit:($p(saveRet,"^",1)'="S")
		set finishStatusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Finish")
		set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(finishStatusID)
		set sc=operSchedule.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($p(saveRet,"^",1)'="S")	
	}
	
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"FNH",userId,+$h,$p($h,",",2))
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	tcommit
	quit "S^"
FinishDSError
	trollback
	quit "E^"_$ze
}

/// w ##class("CIS.AN.BL.DaySurgery").GetENSDaySurgeryId(4,2)
ClassMethod GetENSDaySurgeryId(operId, hospId) As %String
{
	s retRowId=""
	&sql(select daybpdtable.BDPMPH_DataReference into :retRowId from BDP_MappingHosp as daybpdtable,
	orc_daysurgery as daytable 
	where daybpdtable.BDPMPH_TableName='ORC_DaySurgery' 
	and daybpdtable.BDPMPH_Hospital= :hospId 
	and daytable.DS_DaySurgeryDR= :operId 
	and daybpdtable.BDPMPH_DataReference = daytable.DS_RowId )
	q retRowId
}

/// Creator：      	陈长青
/// CreatDate：    	2017-03-13
/// Description： 	查询手术名称字典
/// Table：        	DHCAN.Operation
/// Input:			filterDesc:手术名称筛选字符串,surgeonId:手术医生医护人员ID,surDeptId:手术医生科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DaySurgery","FindOperation","","1","191","",2,"2022-10-24")
Query FindOperation(filterDesc As %String, surgeonId As %String, surDeptId As %String, operId As %String = "", hospId As %String = "", operDate As %String = "") As %Query(ROWSPEC = "RowId,Description,OperClass,OperClassDesc,BladeType,BladeTypeDesc,BodySite,BodySiteDesc,OperPos,OperPosDesc,ICDCode,ICDDesc,ExternalID") [ SqlProc ]
{
}

ClassMethod FindOperationExecute(ByRef qHandle As %Binary, filterDesc As %String, surgeonId As %String, surDeptId As %String, operId As %String = "", hospId As %String = "", operDate As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s operationId="",operDesc="",operClass="",operClassDesc=""="",bladeType="",bladeTypeDesc=""
	s bodySite="",bodySiteDesc="",operPos="",operPosDesc="",ICDCode="",ICDDesc="",externalID=""
	if (##class(User.ORCOperation).%ExistsId(operId))
	{
		set operationId=operId,operDesc="",operClass="",operClassDesc="",bladeType="",bladeTypeDesc="",bodySite="",bodySiteDesc="",operPos="",operPosDesc="",ICDCode="",ICDDesc="",externalID=""
		&sql(select OPER_Desc,OPER_ICD10,OPER_Desc into :operDesc,:ICDCode,:ICDDesc from SQLUser.ORC_Operation where %ID=:operId)
		&sql(select OPER_Class_Dr,OPER_Class_Dr->CATEG_Desc,OPER_Blade_Dr,OPER_Blade_Dr->BLDTP_Desc,OPER_BodySite_Dr,OPER_BodySite_Dr->BODS_Desc,OPER_OperPosition_Dr,OPER_OperPosition_Dr->OPPOS_Desc into 
		:operClass,:operClassDesc,:bladeType,:bladeTypeDesc,:bodySite,:bodySiteDesc,:operPos,:operPosDesc from SQLUser.ORC_OperationExtend where %ID=:operId)
		do OutputRow1
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	if (filterDesc="")&(surgeonId="")&(surDeptId="")
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set filterDesc=$System.SQL.ALPHAUP(filterDesc)
	set careProv="",careProvTpId="",aliasSplitChar=";"
	// 获取手术资质管理配置
	set OperQualificationManager=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("OperQualificationManager")
	//b	;OperQualificationManager
	
	//日间手术走索引，否则速度过慢
	s operationId=""
	f  s operationId=$o(^User.ORCDaySurgeryI("DaySurgeryIndex",operationId)) q:operationId=""  d
		.s newEnsFlag=""
		.set extendEnsOperId=..GetENSDaySurgeryId(operationId,hospId)
		.if extendEnsOperId>0 set newEnsFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ORC_DaySurgery",extendEnsOperId,hospId,operDate)
		.;w newEnsFlag_operationId
		.q:newEnsFlag'="Y"
		.set operDesc=$p(^ORC("OPER",operationId),"^",2)
		.set operAlis=##class(web.DHCClinicCom).GetChinaChar(operDesc)
		.q:(filterDesc'="")&($$ALPHAUP^SSUTIL4(operDesc)'[filterDesc)&($$ALPHAUP^SSUTIL4(operAlis)'[filterDesc)
		.s OperDateTo=$p(^ORC("OPER",operationId),"^",6)
		.q:(OperDateTo'="")&(OperDateTo<$h)
		.i (surgeonId'="")&(OperQualificationManager="Y") d
			..q:$d(^CF.AN.SurgeonOperationI("ISurgeonOperation"," "_surgeonId," "_operationId))<1
			..do OutputRow(operationId)
		.e  d
			..;w "?"
			..do OutputRow(operationId)
	


	
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow(operationId)
    set operationInfo=##class(User.ORCOperation).%OpenId(operationId)

    set ICDCode=operationInfo.OPERICD10
    set ICDDesc=operDesc
    set:(ICDCode'="") ICDDesc="["_ICDCode_"]"_ICDDesc
    set externalID=""
    set bodySite="",bodySiteDesc="",bladeType="",bladeTypeDesc=""
    set operPos="",operPosDesc=""
	s operClass=$p($g(^ORC("OPER",operationId)),"^",7)
	i operClass'=""  s operClassDesc=$p($g(^ORC("CATEG",operClass)),"^",2)
	e  s operClassDesc="" 
    set operExtend=##class(User.ORCOperationExtend).%OpenId(operationId)
    if (operExtend'="")
    {

	    if (operExtend.OPERBodySiteDr'="")
	    {
		    set bodySite=operExtend.OPERBodySiteDr.%Id()
		    set bodySiteDesc=$p($g(^OEC("BODS",+bodySite)),"^",2)
		}
		if (operExtend.OPERBladeDr'="")
		{
			set bladeType=operExtend.OPERBladeDr.%Id()
			set bladeTypeDesc=$p($g(^ORC("BLDTP",+bladeType)),"^",2)
		}
		if (operExtend.OPEROperPositionDr'="")
		{
			set operPos=operExtend.OPEROperPositionDr.%Id()
			set operPosDesc=$p($g(^ORC("OPPOS",+operPos)),"^",2)
		}
	}
	s ^CacheTemp(repid,ind)=$lb(operationId,operDesc,operClass,operClassDesc,bladeType,bladeTypeDesc,bodySite,bodySiteDesc,operPos,operPosDesc,ICDCode,ICDDesc,externalID)
	s ind=ind+1
	q
OutputRow1
    s ^CacheTemp(repid,ind)=$lb(operationId,operDesc,operClass,operClassDesc,bladeType,bladeTypeDesc,bodySite,bodySiteDesc,operPos,operPosDesc,ICDCode,ICDDesc,externalID)
	s ind=ind+1
	q
}

ClassMethod FindOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationExecute ]
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

ClassMethod FindOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// w ##class(CIS.AN.BL.DaySurgery).GetOpsIdByAdmId(238)
ClassMethod GetOpsIdByAdmId(AdmId As %String, opsId As %String = "") As %String
{
	q:opsId'="" opsId
	s tmpOpsId=0,ret=""
	f  s tmpOpsId=$O(^CIS.AN.OperScheduleI("Adm"," "_AdmId,tmpOpsId)) q:tmpOpsId=""  d
		.set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(tmpOpsId)
		.i operSchedule.Status'="" d
			..set StatusID=operSchedule.Status.%Id()
			..set StatusCode=operSchedule.Status.Code
		.q:(StatusCode="Cancel")!(StatusCode="Decline")
		.q:operSchedule.DaySurgery'="Y"
		.;w tmpOpsId
		.s ret=tmpOpsId
	//s retStr=..CheckValidDayOperNew(AdmId)
	//s ret=$p(retStr,"^",3)
	q ret
}

/// w ##class(CIS.AN.BL.DaySurgery).GetOpStatusCode(25)
ClassMethod GetOpStatusCode(OpsId As %String) As %String
{
	s StatusCode=""
	q:OpsId="" ""
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(OpsId)
	//w operSchedule.Status
	i operSchedule.Status'="" d
		.set StatusID=operSchedule.Status.%Id()
		.set StatusCode=operSchedule.Status.Code
	q StatusCode
}

/// Creator：      	元琳
/// CreatDate：    	2020-03-18
/// Description： 	查询科室医护人员资源,并根据医生关联手术配置进行进一步筛选
/// Table：        	CF_AN.Resource,CF_AN.SurgeonOperation
/// Input:			filterDesc:筛选字符串,deptId:科室ID,needActive:是否判断激活失效日期,operId:手术Id
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindSurgeonByOper","1","191","Y",2,"")
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindSurgeonByOper","","93","Y",2,"7")
Query FindSurgeonByOper(filterDesc As %String = "", deptId As %String = "", needActive As %String = "N", hospId As %String = "", operId As %String = "", CPType As %String = "") As %Query(ROWSPEC = "resourceId,RowId,Description,ActiveDate,ExpireDate,Dept,DeptDesc,CareProvider,CareProvDesc") [ SqlProc ]
{
}

ClassMethod FindSurgeonByOperExecute(ByRef qHandle As %Binary, filterDesc As %String = "", deptId As %String = "", needActive As %String = "N", hospId As %String = "", operId As %String = "", CPType As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set filterDesc=$System.SQL.ALPHAUP(filterDesc)
	set resourceId=0
	set Code="",Description="",ActiveDate="",ExpireDate="",Dept="",DeptDesc="",CareProvider="",CareProvDesc=""
    set rowId=0
    set CareTypeStr="",CareTypeArr=""
    set CareTypeArr=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("OperQualificationCareType")
    set:CareTypeArr'="" CareTypeStr="^"_$tr(CareTypeArr,",","^")_"^"
    // 获取手术资质管理配置
	s OperQualificationManager=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("OperQualificationManager")
    if ((operId="")||(OperQualificationManager="N"))
	{
		d FindSurgeon("Y")
	}
	else
	{
		if $d(^CF.AN.SurgeonOperationI("IOperation"," "_operId))
	    {
		    for
		    {
			    set rowId=$order(^CF.AN.SurgeonOperationI("IOperation"," "_operId,rowId))
			    quit:(rowId="")
			    set CareProviderId=$list(^CF.AN.SurgeonOperationD(rowId),1)
			    quit:(CareProviderId="")
				set doclist(CareProviderId)=""  //医生去重
		    }
		    set docId=0
		    for 
		    {
			    set docId=$o(doclist(docId))
			    quit:(docId="")
			    for
			    {
				    set resourceId=$order(^RB("RES",0,"CTPCP",docId,deptId,resourceId))
				    quit:(resourceId="")
				    set ResourceInfo=^RB("RES",resourceId)
				    continue:(ResourceInfo="")
				    set Dept=$p(ResourceInfo,"^",1)
				    continue:(Dept'="")&(deptId'="")&(deptId'=Dept)
				    set Code=$p(ResourceInfo,"^",2)
				    continue:(Code="")
				    set Description=$p(ResourceInfo,"^",17)
				    continue:(Description="")
				    set ResExpireDate=$p(ResourceInfo,"^",23)
				    continue:(ResExpireDate'="")&(ResExpireDate<+$h)
				    set DeptDesc=$p(^CTLOC(Dept),"^",2)
				    set CareProvider=$p(^CTPCP(Code,1),"^",1)
				    quit:(CareProvider="")
				    set CareProvDesc=$p(^CTPCP(Code,1),"^",2)
				    quit:(CareProvDesc="")
				    set Alias=$p(^CTPCP(Code,3),"^",28)
				    set ActiveDate=$p(^CTPCP(Code,2),"^",14)
				    set ExpireDate=$p(^CTPCP(Code,2),"^",15)
				    set CareType=$p(^CTPCP(Code,1),"^",4)
				    continue:CareTypeStr'[CareType
				    set active=$p(^CTPCP(Code,1),"^",9)
				    continue:(active'="")&&(active'="Y")
				    continue:(needActive'="Y")
				    continue:(filterDesc'="")&($System.SQL.ALPHAUP(CareProvDesc)'[filterDesc)
				    continue:(ActiveDate>+$h)
				    continue:(ExpireDate'="")&(ExpireDate<+$h)
				    do OutputRow
				}
			}
	    }
	    else
	    {
		    b
		    d FindSurgeon("N")
	    }
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK
FindSurgeon(ifAll)
    for
    {
	    set resourceId=$order(^RB("RES",resourceId))
	    quit:(resourceId="")
	    set ResourceInfo=^RB("RES",resourceId)
	    continue:(ResourceInfo="")
	    set Dept=$p(ResourceInfo,"^",1)
	    continue:(Dept'="")&(deptId'="")&(deptId'=Dept)
	    set Code=$p(ResourceInfo,"^",2)
	    continue:(Code="")
	    set Description=$p(ResourceInfo,"^",17)
	    continue:(Description="")
	    set ResExpireDate=$p(ResourceInfo,"^",23)
	    continue:(ResExpireDate'="")&(ResExpireDate<+$h)
	    set DeptDesc=$p(^CTLOC(Dept),"^",2)
	    set CareProvider=$p(^CTPCP(Code,1),"^",1)
	    quit:(CareProvider="")
	    set CareProvDesc=$p(^CTPCP(Code,1),"^",2)
	    quit:(CareProvDesc="")
	    set Alias=$p(^CTPCP(Code,3),"^",28)
	    set ActiveDate=$p(^CTPCP(Code,2),"^",14)
	    set ExpireDate=$p(^CTPCP(Code,2),"^",15)
		set CareType=$p(^CTPCP(Code,1),"^",4)
		continue:CareTypeStr'[CareType
	    set active=$p(^CTPCP(Code,1),"^",9)
	    continue:(active'="Y")
	    continue:(needActive'="Y")
	    continue:(ifAll'="Y")&($d(^CF.AN.SurgeonOperationI("ISurgeon"," "_Code)))
	    continue:(filterDesc'="")&($System.SQL.ALPHAUP(CareProvDesc)'[filterDesc)&($System.SQL.ALPHAUP(Alias)'[filterDesc)
	    continue:(ActiveDate>+$h)
	    continue:(ExpireDate'="")&(ExpireDate<+$h)
	    do OutputRow
	}
	q
OutputRow
	s ^CacheTemp(repid,ind)=$lb(resourceId,Code,Description,ActiveDate,ExpireDate,Dept,DeptDesc,CareProvider,CareProvDesc)
	s ind=ind+1
	q
}

ClassMethod FindSurgeonByOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurgeonByOperExecute ]
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

ClassMethod FindSurgeonByOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurgeonByOperExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

}
