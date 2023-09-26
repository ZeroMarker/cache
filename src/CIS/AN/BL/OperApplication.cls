/// 手术申请
Class CIS.AN.BL.OperApplication Extends %RegisteredObject
{

/// Creator：        陈长青
/// CreatDate：      2017-03-13
/// Description：    保存手术申请信息
/// Table：          DHCAN.OperSchedule,DHCAN.AnaestOperation
/// Input:          data:数据字符串
/// Return：         保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperApplication).SaveOperApplication("")
/// w ##class(CIS.AN.BL.OperApplication).SaveOperApplication(^TMPOPAPP("Para"))
ClassMethod SaveOperApplicationOld(data As %String) As %String
{
	set ^TMPOPAPP("Para")=data
	set $zt="Error"
    tstart
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    // 第一个对象为手术明细信息
    kill operSchedule
    m operSchedule=array(1)
    set isEditStatus=##class(CIS.AN.OperSchedule).%ExistsId($g(operSchedule("RowId")))
    // 第二个对象为麻醉过程
    //m anaesthesia=array(2)
    
    // 没有手术状态时，一般认为是新建手术申请，需要对手术状态赋值
    set isNewApp=0
    if ($get(operSchedule("Status"))="")&($get(operSchedule("StatusCode"))'="")
    {
        set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
        set isNewApp=1
    }
    elseif ($get(operSchedule("Status"))="16")&($get(operSchedule("StatusCode"))="Application")
    {
	    //暂存转正式
        set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
        set isNewApp=0
    }
    elseif ($get(operSchedule("DaySurgery"))="Y")&($get(operSchedule("StatusCode"))'="")
    {
	    //202002+dyl+日间确认
        set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
        set isNewApp=0
    }
    
    /// 申请手术时，可以直接审核的安全组(系统配置->系统配置->安全组配置)，申请后手术状态直接为审核 by ccq 20200512
    set groupId=$g(operSchedule("GroupID")),sourceType=$g(operSchedule("SourceType"))
    set auditOperApp=..AuditOperApp(groupId,sourceType)
    set:(auditOperApp="Y") operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Audit")
    
    //set PatDeptID=$get(operSchedule("PatDeptID"))
    //set operSchedule("PatDeptID")=##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Department",PatDeptID)
    
    //set PatWardID=$get(operSchedule("PatWardID"))
    //set operSchedule("PatWardID")=##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Ward",PatWardID)
    
    //set PatBedID=$get(operSchedule("PatBedID"))
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
    
    if ($piece(saveResult,"^",1)="S")&(operScheduleObj.DaySurgery'="Y")
    {
	    set NeedAuditOper=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditOperation")
	    set NeedAuditEMOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditEMOperation")
	    set isAddMedOrder=0
		if ((operScheduleObj.SourceType="E")&&(NeedAuditEMOperation="N"))
		{
			// 急诊手术不需要审核时，申请时插入手术申请医嘱
			set isAddMedOrder=1
		}
		elseif (((operScheduleObj.SourceType="B")&&(NeedAuditOper="N")))
		{
			// 择期手术不需要审核时，申请时插入手术申请医嘱
			set isAddMedOrder=1
		}
		elseif ((auditOperApp="Y")&&(isNewApp))
		{
			// 科主任申请时，申请时插入手术申请医嘱
			set isAddMedOrder=1
		}
		set ^tempDebug("SaveApp")=auditOperApp_isNewApp
		if (isAddMedOrder)
	    {
		    // 配置为不需审核时直接插入手术申请医嘱,配置为需要审核时需要先审核 YL 20200609
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
    }
	if ($piece(saveResult,"^",1)="S")
	{
		// 回写旧表
		set saveResult=##class(CIS.AN.SRV.OperAppService).SendOperAppInfo(opsId)
		write "send to old table:",saveResult,!
	}
	set opaId=""
	if ($piece(saveResult,"^",1)="S")
	{
		// 调用电子病历接口
		set opaId=$p(saveResult,"^",2)
		set retEMR=##class(EMRservice.BIEMRService).SetOperation(operScheduleObj.EpisodeID,opaId)
		
		set:(+retEMR'=1) saveResult="E^写入电子病历表失败" 
		//write "send to EMR:",saveResult,!
	}
	if ($piece(saveResult,"^",1)="S")
	{
		//20211214
		s retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,operScheduleObj.AppUserID,"1")
		// 调用消息平台接口	
		s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
		set:(+OAret'=0) saveResult="E^发送手术申请失败，原因："_$p(OAret,"^",2)
		write "send to ENS:",saveResult,!
	}
	if ($piece(saveResult,"^",1)="S")
	{
		// 发送手术申请消息
		set appUserId=""
		set actionUserId=operScheduleObj.AppUserID
	    set SendOperMessage=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("SendOperMessage")
		if (SendOperMessage="Y") Set rtnMes =##class(websys.DHCMessageInterface).Send("申请手术", "1053", actionUserId, operScheduleObj.EpisodeID ,"","", "opaId为"_opaId ,operScheduleObj.OperDeptID)
		write "send to MS:",rtnMes,!	
	}
	if ($piece(saveResult,"^",1)="S")&(opaId'="")
    {
	    // 写关联电子病历文书
		set linkEMRecords=$get(operSchedule("LinkEMRecords"))
		set:(linkEMRecords'="") saveResult=..LinkEMRecords(opaId,linkEMRecords) 
		write "relate to EMR:",saveResult,! 
	}
	if ($piece(saveResult,"^",1)="S")&(isEditStatus=0)
    {
	    // 写手术操作过程
	    set actionUserId=operScheduleObj.AppUserID
	    set procedureCode="APP"
        set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,procedureCode,actionUserId,+$h,$p($h,",",2)) 
        write "log procedure APP:",saveResult,!   
    }
    
    if ($piece(saveResult,"^",1)="S")&(isEditStatus=0)&(auditOperApp="Y")
    {
	    // 写手术操作过程
	    set actionUserId=operScheduleObj.AppUserID
	    set procedureCode="ADT"
        set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,procedureCode,actionUserId,+$h,$p($h,",",2)) 
        write "log procedure ADT:",saveResult,!
    }
	
    if ($piece(saveResult,"^",1)'="S")
    {
	    write "before rollback",!
        trollback
        quit saveResult     
    }
    write "before commit transaction",!
    tcommit
    quit "S^"_opsId
Error
	write "before rollback error",!
	trollback
	quit "E^"_$ze
}

/// Creator：        陈长青
/// CreatDate：      2017-03-13
/// Description：    保存手术申请信息
/// Table：          DHCAN.OperSchedule,DHCAN.AnaestOperation
/// Input:          data:数据字符串
/// Return：         保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperApplication).SaveOperApplication("")
/// w ##class(CIS.AN.BL.OperApplication).SaveOperApplication(^TMPOPAPP("Para"))
ClassMethod SaveOperApplication(data As %String) As %String
{
	set ^TMPOPAPP("Para")=data
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    // 第一个对象为手术明细信息
    kill operSchedule
    m operSchedule=array(1)
    set saveResult=""
    set opsId="",isNewApp=0
    set isEditStatus=##class(CIS.AN.OperSchedule).%ExistsId($g(operSchedule("RowId")))
    
    // 第二个对象为麻醉过程
    //m anaesthesia=array(2)
	
    tstart
    try
    {
    
	    // 没有手术状态时，一般认为是新建手术申请，需要对手术状态赋值
	    if ($get(operSchedule("Status"))="")&($get(operSchedule("StatusCode"))'="")
	    {
	        set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
	        set isNewApp=1
	    }
	    elseif ($get(operSchedule("Status"))="16")&($get(operSchedule("StatusCode"))="Application")
	    {
		    //暂存转正式
	        set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
	        set isNewApp=0
	    }
	    elseif ($get(operSchedule("DaySurgery"))="Y")&($get(operSchedule("StatusCode"))'="")
	    {
		    //202002+dyl+日间确认
	        set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operSchedule("StatusCode"))
	        set isNewApp=0
	    }
	    
	    /// 申请手术时，可以直接审核的安全组(系统配置->系统配置->安全组配置)，申请后手术状态直接为审核 by ccq 20200512
	    set groupId=$g(operSchedule("GroupID")),sourceType=$g(operSchedule("SourceType"))
	    set auditOperApp=..AuditOperApp(groupId,sourceType)
	    set:(auditOperApp="Y") operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Audit")
	    
	    //set PatDeptID=$get(operSchedule("PatDeptID"))
	    //set operSchedule("PatDeptID")=##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Department",PatDeptID)
    
	    //set PatWardID=$get(operSchedule("PatWardID"))
	    //set operSchedule("PatWardID")=##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Ward",PatWardID)
	    
	    //set PatBedID=$get(operSchedule("PatBedID"))
	    //set operSchedule("PatBedID")=##class(CIS.AN.COM.String).GetRowIdByExt("CF_AN.Bed",PatBedID)
	    
	    set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)
		b ;0023
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
	    
		if ($piece(saveResult,"^",1)="S")
		{
			// 回写旧表
			set saveResult=##class(CIS.AN.SRV.OperAppService).SendOperAppInfo(opsId)
			//write "send to old table:",saveResult,!
		}
		
		if ($piece(saveResult,"^",1)'="S")
    	{
	    	//write "before rollback",!
        	trollback
    	}
    	else
    	{
    		//write "before commit transaction",!
    		tcommit
    		set saveResult="S^"_opsId
    	}
    }
    catch(e)
    {
	    //write "before rollback error",!
		trollback
		set saveResult="E^"_e.DisplayString()
    }
    
    if ($piece(saveResult,"^",1)="S")
    {
	    do ..AfterSaveOperApplication(opsId,isEditStatus,isNewApp, .operSchedule)
    }

    quit saveResult
}

ClassMethod AfterSaveOperApplication(opsId, isEditStatus, isNewApp, ByRef operSchedule) As %Status
{
	set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	/// 申请手术时，可以直接审核的安全组(系统配置->系统配置->安全组配置)，申请后手术状态直接为审核 by ccq 20200512
	set groupId=$g(operSchedule("GroupID")),sourceType=$g(operSchedule("SourceType"))
	set auditOperApp=..AuditOperApp(groupId,sourceType)
	
	try
	{
		if (operScheduleObj.DaySurgery'="Y")
	    {
		    set NeedAuditOper=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditOperation")
		    set NeedAuditEMOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditEMOperation")
		    set isAddMedOrder=0
			if ((operScheduleObj.SourceType="E")&&(NeedAuditEMOperation="N"))
			{
				// 急诊手术不需要审核时，申请时插入手术申请医嘱
				set isAddMedOrder=1
			}
			elseif (((operScheduleObj.SourceType="B")&&(NeedAuditOper="N")))
			{
				// 择期手术不需要审核时，申请时插入手术申请医嘱
				set isAddMedOrder=1
			}
			elseif ((auditOperApp="Y")&&(isNewApp))
			{
				// 科主任申请时，申请时插入手术申请医嘱
				set isAddMedOrder=1
			}
			set ^tempDebug("SaveApp")=auditOperApp_isNewApp
			if (isAddMedOrder)
		    {
			    // 配置为不需审核时直接插入手术申请医嘱,配置为需要审核时需要先审核 YL 20200609
			    set saveResult=##class(CIS.AN.BL.OperOrder).SaveAppOrderItem(opsId)
			    if ($piece(saveResult,"^",1)="S")
			    {
				    // 如果插入手术申请医嘱成功，那么将医嘱ID保存到CIS_AN.OperSchedule表，方便直接调用。
				    set orderItemID=$p(saveResult,"^",2)
				    set operScheduleObj.AppOrderItem=orderItemID
				    set sc=operScheduleObj.%Save()
				    if ($System.Status.IsError(sc)) write "DTS:生成手术申请医嘱失败:",$System.Status.GetErrorText(sc),!
				}
		    }
	    }
	}
	catch(e)
	{
		write "DTS:生成手术申请医嘱错误:",e.DisplayString(),!
	}
	
	set opaId=""
	try
	{
		// 调用电子病历接口
		set opaId=operScheduleObj.ExternalID
		set retEMR=##class(EMRservice.BIEMRService).SetOperation(operScheduleObj.EpisodeID,opaId)
		
		set:(+retEMR'=1) saveResult="E^写入电子病历表失败" 
		//write "send to EMR:",saveResult,!
	}
	catch(e)
	{
		write "DTS:调用电子病历接口错误:",e.DisplayString(),!
	}
	
	try
	{
		//20211214
		set opaId=operScheduleObj.ExternalID
		s retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,operScheduleObj.AppUserID,"1")
		// 调用消息平台接口	
		s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
		set:(+OAret'=0) saveResult="E^发送手术申请失败，原因："_$p(OAret,"^",2)
		if (+OAret'=0) write "DTS:调用消息平台接口错误:",$p(OAret,"^",2),!
	}
	catch(e)
	{
		write "DTS:调用消息平台接口错误:",e.DisplayString(),!
	}
	
	try
	{
		// 发送手术申请消息
		set appUserId=""
		set actionUserId=operScheduleObj.AppUserID
	    set SendOperMessage=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("SendOperMessage")
		if (SendOperMessage="Y") Set rtnMes =##class(websys.DHCMessageInterface).Send("申请手术", "1053", actionUserId, operScheduleObj.EpisodeID ,"","", "opaId为"_opaId ,operScheduleObj.OperDeptID)
		//write "send to MS:",rtnMes,!	
	}
	catch(e)
	{
		write "DTS:发送手术申请消息错误:",e.DisplayString(),!
	}
	
	try
	{
		set opaId=operScheduleObj.ExternalID
		if (opaId'="")
	    {
		    // 写关联电子病历文书
		    if ($get(operSchedule("saveLinkEMRecords"))="true"){
				set linkEMRecords=$get(operSchedule("LinkEMRecords"))
				if (linkEMRecords'="") {
					b ;21
					set saveResult=..LinkEMRecords(opaId,linkEMRecords)
					s ^Temp(+$h)=opsId_"&&"_saveResult_"&&"_linkEMRecords
					if ($piece(saveResult,"^",1)="S") {
						set json=..GetEMRecordsInfoJson(opsId,linkEMRecords)
						q:json=""
						set stream=##class(%GlobalCharacterStream).%New()
						do stream.Write(json)
						set ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",stream)
					    s ^Temp(+$h,1)=opsId_"&&"_ret_"&&"_linkEMRecords_"&&"_json_"&&"_stream
					}
				}
		    }
		}
	}
	catch(e)
	{
		write "DTS:关联电子病历文书错误:",e.DisplayString(),!
	}
	
	try
	{
		if (isEditStatus=0)
	    {
		    // 写手术操作过程
		    set actionUserId=operScheduleObj.AppUserID
		    set procedureCode="APP"
	        set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,procedureCode,actionUserId,+$h,$p($h,",",2)) 
	        //write "log procedure APP:",saveResult,!   
	    }
	}
	catch(e)
	{
		write "DTS:写手术操作过程错误:",e.DisplayString(),!
	}
    
    try
    {
	    if (isEditStatus=0)&(auditOperApp="Y")
	    {
		    // 写手术操作过程
		    set actionUserId=operScheduleObj.AppUserID
		    set procedureCode="ADT"
	        set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,procedureCode,actionUserId,+$h,$p($h,",",2)) 
	        //write "log procedure ADT:",saveResult,!
	    }
    }
    catch(e)
    {
	    write "DTS:写手术操作过程错误:",e.DisplayString(),!
	}
    
    quit $$$OK
}

/// 暂存手术
ClassMethod SaveOperAppTemp(data As %String) As %String
{
	set ^TMPOPAPP("Para")=data
	set $zt="Error"
    tstart
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    // 第一个对象为手术明细信息
    kill operSchedule
    m operSchedule=array(1)
    
    // 暂存的手术为未激活状态
    set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("NotActive")
    set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)
    set opsId=$p(saveResult,"^",2)
    
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
    
	
	if ($piece(saveResult,"^",1)="S")
    {
	    // 写手术操作过程
	    set actionUserId=$g(operSchedule("AppUserID"))
	    set procedureCode="TMPS"
        set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,procedureCode,actionUserId,+$h,$p($h,",",2))   
    }
	
    if ($piece(saveResult,"^",1)'="S")
    {
	    //write "before rollback",
        trollback
        quit saveResult     
    }
    //write "before commit transaction",!
    tcommit
    quit "S^"_opsId
Error
	//write "before rollback error",
	trollback
	quit "E^"_$ze
}

ClassMethod GetTempAppID(EpisodeID As %String) As %String
{
	set opsId=""
	&sql(select RowId into :opsId from CIS_AN.OperSchedule where EpisodeID=:EpisodeID and Status->Code='NotActive')
	quit opsId
}

/// / w ##class(CIS.AN.BL.OperApplication).CheckIsNeedAuditAudit()
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
    //write "saving old ana table:",result,!
    quit result
}

ClassMethod SaveAnaesthesia(data As %String) As %String
{
	set anaID=$get(data("AnaID"))
	set opsId=$get(data("OpsID"))
	set result="S^"_anaID
	set anaMethodID=$get(data("AnaMethod"))
	if (##class(CIS.AN.Anaesthesia).%ExistsId(anaID)=0)
	{
		set anaest=##class(CIS.AN.Anaesthesia).%New()
		set anaest.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		//set anaest.AnaMethod=anaMethodID
		set sc=anaest.%Save()
		if ($System.Status.IsError(sc))
	    {
	        set result="E^"_$System.Status.GetErrorText(sc,"zh-cn") 
	        quit result
	    }
	    else
	    {
	        set result="S^"_anaest.%Id()   
	    }
	}
	set saveRet=##class(CIS.AN.BL.AnaArrange).UpdateAnaMethod(opsId,anaMethodID)
	quit:($p(saveRet,"^",1)'="S") saveRet
	quit result
}

/// Creator：        陈长青
/// CreatDate：      2017-02-22
/// Description：    获取下一个工作日的日期
/// Table：          DHCAN.Holiday
/// Input：          baseDate:基准日期
/// Return：         下一个工作日期字符串
/// Debug:          w ##class(CIS.AN.BL.OperApplication).GetNextWorkDay("2017-02-23")
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
/// Debug:          w ##class(CIS.AN.BL.OperApplication).GetDefaultOperDept("96")
ClassMethod GetDefaultOperDept(deptID As %String) As %String
{
    set result=""
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
        set OperDept="",OutOperDept="",EMOperDept=""
        set hospId=##class(CIS.AN.BL.Admission).GetHospIDByDept(deptID)
        &sql(select OperDept,OutOperDept,EMOperDept into :OperDept,:OutOperDept,:EMOperDept from CF_AN.Hospital where HospID=:hospId)
        set result=$case(admType,"I":OperDept,"O":OutOperDept,"E":EMOperDept)
        set deptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",result)
        set result=result_"^"_deptDesc
    }
    
    quit result
}

/// Creator：        陈长青
/// CreatDate：      2017-02-22
/// Description：    判断择期手术申请的是否截止
/// Table：          DHCAN.DataConfiguration
/// Input：          
/// Return：         返回"Y"表示已经截止，返回"N"表示还未截止
/// Debug:          w ##class(CIS.AN.BL.OperApplication).JudgeAppDeadline()
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
/// Debug:          w ##class(CIS.AN.BL.OperApplication).ExistsOperApplication("24")
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
/// Debug:          w ##class(CIS.AN.BL.OperApplication).GetOperAppDeadLine()
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
/// Debug:          w ##class(CIS.AN.BL.OperApplication).GetOperAppDeadLine()
ClassMethod GetOperDate(sourceType As %String) As %String
{
    set operDate="",rowId=""
    if (sourceType="B")
    {
	    //自动跳过周末节假日 YL 20200323
        //set operDate=..GetNextWorkDay("")
        set date=+$h
        set curDate=date
        for i=1:1:14 d
        .quit:date'=curDate
        .set curDay=$zd(date+i,10)
        .if ($d(^CF.AN.HolidayI("IDate",curDate+i))>0) d
        ..set rowId=$o(^CF.AN.HolidayI("IDate",curDate+i,rowId))
	    ..set dayType=$li(^CF.AN.HolidayD(rowId),2)
	    ..if dayType="GZR" set date=curDate+i
	    .else  if ("12345"[curDay) set date=curDate+i
        set operDate=##class(CIS.AN.COM.DateTime).ConvertToDate(date)
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
/// Debug:          w ##class(CIS.AN.BL.OperApplication).GetDefOperDept("95")
ClassMethod GetDefOperDept(appDeptID As %String) As %String
{
    set configCode="",result="",OperDeptID=""
    set admType=##class(CIS.AN.BL.Admission).GetDeptAdmType(appDeptID)
    &sql(select OperDept into :OperDeptID from CF_AN.Department where DeptID=:appDeptID)
    if OperDeptID'="" quit OperDeptID
    set OperDept="",OutOperDept="",EMOperDept=""
    set hospId=##class(CIS.AN.BL.Admission).GetHospIDByDept(appDeptID)
    &sql(select OperDept,OutOperDept,EMOperDept into :OperDept,:OutOperDept,:EMOperDept from CF_AN.Hospital where HospID=:hospId)
    if (admType'="") set result=$case(admType,"I":OperDept,"O":OutOperDept,"E":EMOperDept)
    set:(result="") result=OperDept
    quit result  //院区配置
        
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
/// Return：         默认麻醉科的科室ID
/// Debug:          w ##class(CIS.AN.BL.OperApplication).GetDefANDept("96")
ClassMethod GetDefANDept(appDeptID As %String) As %String
{
	set ANDeptID=""
    set admType=##class(CIS.AN.BL.Admission).GetDeptAdmType(appDeptID)
    &sql(select ANDept into :ANDeptID from CF_AN.Department where DeptID=:appDeptID)
    if ANDeptID'="" quit ANDeptID
    set OperDept="",OutOperDept="",EMOperDept=""
    set hospId=##class(CIS.AN.BL.Admission).GetHospIDByDept(appDeptID)
    &sql(select ANDept,OutANDept,EMANDept into :OperDept,:OutOperDept,:EMOperDept from CF_AN.Hospital where HospID=:hospId)
    set result=$case(admType,"I":OperDept,"O":OutOperDept,"E":EMOperDept)
    set:(result="") result=OperDept
    quit result
}

ClassMethod GetDefANDeptInfo(appDeptID As %String) As %String
{
	set defANDeptID=..GetDefANDept(appDeptID)
	set defANDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",defANDeptID)
	quit defANDeptID_"^"_defANDeptDesc
}

ClassMethod CanAuditOperation(opsIdStr As %String) As %String
{
	set count=$l(opsIdStr,","),message="",canAudit="Y"
	for i=1:1:count
	{
		set opsId=$p(opsIdStr,";",i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		if (operSchedule.Status.Code'="Application")
		{
			set canAudit="N"
			set:message'="" message=message_"<br>"
			set message=message_"患者"_operSchedule.PatName_"的手术状态为【"_operSchedule.Status.Description_"】，不能审核。"	
		}
	}		
	quit canAudit_"^"_message
}

/// Creator：        陈长青
/// CreatDate：      2017-07-28
/// Description：    获取手术申请科室默认的手术室
/// Table：          
/// Input：          
/// Return：         默认手术室的科室ID
/// Debug:          w ##class(CIS.AN.BL.OperApplication).AuditOperation("14","10209")
ClassMethod AuditOperation(opsIdStr As %String, auditUser As %String) As %String
{
	set $zt="Error"
	tstart
	set splitChar=";",saveResult="E^未审核任何手术"
	set operCount=$l(opsIdStr,splitChar)
	set NeedAuditOper=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditOperation")
	set NeedAuditEMOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditEMOperation")
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
		set operArrange.ReleaseUser=auditUser //##class(CF.AN.SSUser).%OpenId(auditUser)
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
		set saveResult=##class(CIS.AN.SRV.OperAppService).AuditApplication(opsId,auditUser)		// 回写旧表
		quit:($p(saveResult,"^",1)="E")	
		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"ADT",auditUser,+$h,$p($h,",",2))
		quit:($p(saveResult,"^",1)="E")
		if (((operSchedule.SourceType="E")&&(NeedAuditEMOperation="Y"))||((operSchedule.SourceType="B")&&(NeedAuditOper="Y")))
	    {
		    // 配置为需要审核时审核通过后再插入手术申请医嘱 YL 20200609
		    set saveResult=##class(CIS.AN.BL.OperOrder).SaveAppOrderItem(opsId)
		    if ($piece(saveResult,"^",1)="S")
		    {
			    // 如果插入手术申请医嘱成功，那么将医嘱ID保存到CIS_AN.OperSchedule表，方便直接调用。
			    set orderItemID=$p(saveResult,"^",2)
			    set operSchedule.AppOrderItem=orderItemID
			    set sc=operSchedule.%Save()
			    set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
			}
	    }
		quit:($p(saveResult,"^",1)="E")
		Set rtnMes =##class(websys.DHCMessageInterface).Send("审核手术", "1053", operArrange.ReleaseUser, operSchedule.EpisodeID ,"","", "opaId为"_operSchedule.ExternalID ,operSchedule.OperDeptID)
		
		do ..AfterAuditOper(opsId)
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

ClassMethod AfterAuditOper(opsId) As %Status
{
	set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	try
	{
		//20211214
		set opaId=operScheduleObj.ExternalID
		// 调用消息平台接口	
		s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
		set:(+OAret'=0) saveResult="E^发送手术申请失败，原因："_$p(OAret,"^",2)
		if (+OAret'=0) write "DTS:调用消息平台接口错误:",$p(OAret,"^",2),!
	}
	catch(e)
	{
		write "DTS:调用消息平台接口错误:",e.DisplayString(),!
	}
	
	quit $$$OK
}

// w ##class(CIS.AN.BL.OperApplication).BatchAddApplication(100)

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

/// w ##class(CIS.AN.BL.OperApplication).CheckOperValid("4","5746","10209^95^30")
/// w ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C","4!5746!!Oper","10209^95^30")
ClassMethod CheckOperValid(EpisodeID As %String, operId As %String, userInfo As %String) As %String
{
	s libLabel="C"
	// 4!5746!!Oper
	s input=EpisodeID_"!"_operId_"!!Oper"
	s ret=##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,libLabel,input,userInfo)
	quit RetStr
}

/// Creator：        元琳
/// CreatDate：      2020-02-20
/// Description：    保存术后登记交接班信息
/// Table：          CIS_AN.OperShift
/// Input:           data:数据字符串
/// Return：         保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperApplication).SaveOperRegister(127,^TEMPReg("Reg"))
ClassMethod SaveOperRegister(opsId As %String, data As %String) As %String
{
	set ^TEMPReg("Reg")=data
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    set objIndex=0
    set shiftId=""
	set result="S^"
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
		quit:ShiftCareProvID=""
	    set shift.ShiftCareProvID=##class(CF.AN.SSUser).%OpenId(ShiftCareProvID)
	    
		set ReliefCareProvID=$get(operRegister("ReliefCareProvID"))
		quit:ReliefCareProvID=""
	    set shift.ReliefCareProvID=##class(CF.AN.SSUser).%OpenId(ReliefCareProvID)
	    
		set shift.ShiftDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p($get(operRegister("ShiftDT"))," ",1))
		set shift.ShiftTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p($get(operRegister("ShiftDT"))," ",2))
		
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
/// w ##class(CIS.AN.BL.OperApplication).SaveOperEventDT(115,"2020-03-02 18:45:07","2020-03-02 18:45:07")
ClassMethod SaveOperEventDT(opsId As %String, TheatreInDT As %String, TheatreOutDT As %String, AreaInDT As %String = "", AreaOutDT As %String = "") As %String
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
	if (TheatreInDT'="") set AnaRegister.TheatreInDT=TheatreInDT
	if (TheatreOutDT'="") set AnaRegister.TheatreOutDT=TheatreOutDT
	if (AreaInDT'="") set AnaRegister.AreaInDT=AreaInDT
	if (AreaOutDT'="") set AnaRegister.AreaOutDT=AreaOutDT
	set sc=AnaRegister.%Save()
	if ($System.Status.IsError(sc))
	{
		set result="E^"_$System.Status.GetErrorText(sc,"zh-cn")
	}
	else
	{
		set result="S^"_AnaRegister.%Id()
	}	
	q result
}

/// w ##class(CIS.AN.BL.OperApplication).GetAnaDepts("95","1")
ClassMethod GetAnaDepts(appDeptId As %String = "", hospId As %String) As %String
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindLocationOld")
	set sc=rs.Execute("","AN^EMAN^OUTAN",hospId)
	k deptArr
	set count=0
	while(rs.%Next())
	{
		set count=count+1
		set deptArr(count,"RowId")=rs.Get("RowId")
		set deptArr(count,"Description")=rs.Get("Description")	
	}
	set count=count+1
	set deptArr(count,"RowId")=appDeptId
	set deptArr(count,"Description")=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",appDeptId)
	b ;3
	set json=##class(CIS.AN.COM.String).ToJson(.deptArr)
	quit json
}

/// w ##class(CIS.AN.BL.OperApplication).GetAnaDoctors(34)
ClassMethod GetAnaDoctors(opsId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	;set rs=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindResource")
	set rs=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindResourceByHIS")
	;set sc=rs.Execute("",operSchedule.AnaDept.%Id(),"Y",operSchedule.AnaDept.Hospital.%Id(),"DOCTOR")
	set ctLoc=##class(User.CTLoc).%OpenId(operSchedule.AnaDept)
	set Hospital=ctLoc.CTLOCHospitalDR.%Id()
	set sc=rs.Execute("",operSchedule.AnaDept,"Y",Hospital,"DOCTOR")
	k docArr
	set count=0
	while (rs.%Next())
	{
		set count=count+1
		set docArr(count,"RowId")=rs.Get("CareProvider")
		set docArr(count,"Description")=rs.Get("CareProvDesc")	
	}
	set json=##class(CIS.AN.COM.String).ToJson(.docArr)
	quit json
}

/// w ##class(CIS.AN.BL.OperApplication).SaveRegister(^TMPOPREG("Para"),^TMPOPREG("User"))
ClassMethod SaveRegister(dataPara As %String, userId As %String = "") As %String
{
	set ^TMPOPREG("Para")=dataPara,^TMPOPREG("User")=userId
	set $zt="RegisterError"
    tstart
    set status=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
    k operSchedule
    m operSchedule=array(1)
    set opsId=$get(operSchedule("RowId"))
    m anaesthesia=array(2)
    set className=$g(anaesthesia("ClassName"))
    b //zw array
    set saveResult="S^"
    if (className="CIS.AN.Anaesthesia")
    {
	    // 删除实施手术表
		//&sql(delete from CIS_AN.OperList where OperSchedule=:opsId)
		//set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
	}
	// 删除交接班重新保存
	set opsObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operDeptID=opsObj.OperDeptID
	&sql(delete from CIS_AN.OperShift where OperSchedule=:opsId and CareProvDept=:operDeptID)
	set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
		
    if ($piece(saveResult,"^",1)="S")
    {   
        set objIndex=0
        for
        {
            set objIndex=$order(array(objIndex))
            quit:(objIndex="")
            kill operation
            merge operation=array(objIndex)
            set:($g(operation("ShiftDT"))'="") operation("ShiftTime")=$p(operation("ShiftDT")," ",2)
            b //zw operation
            set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operation)
            quit:($piece(saveResult,"^",1)'="S")
        }   
    }
	
    if ($piece(saveResult,"^",1)'="S")
    {
        trollback
        quit saveResult     
    }
    tcommit
    
    do ..AfterSaveRegister(opsId,userId)
    do ..TriggerEventOnOperRegister(opsId)
    
    quit "S^"_opsId
RegisterError
	trollback
	quit "E^"_$ze
}

ClassMethod AfterSaveRegister(opsId, userId) As %String
{
	try
	{
		set saveResult=##class(CIS.AN.SRV.OperAppService).SendOperRegister(opsId)
	}
	catch(e)
	{
		//write "回写旧表错误:",e.DisplayString(),!
	}
	
	try
	{
		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedureArea(opsId,userId)
	}
	catch(e)
	{
		//write "写手术过程错误:",e.DisplayString(),!
	}
	
	try
	{
		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPR",userId,+$h,$p($h,",",2))
	}
	catch(e)
	{
		//write "写手术登记操作错误:",e.DisplayString(),!
	}
	
	try
	{
		for rnum=8:1:17
		{
			s retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,userId,rnum)
		}
	}
	catch(e)
	{
		//write "更新手术闭环信息错误:",e.DisplayString(),!
	}
	
	quit ""
}

ClassMethod TriggerEventOnOperRegister(opsId) As %String
{
	try
	{
		set args=##class(CIS.AN.DTO.Event.Args.OnOperRegister).%New()
		set args.RowId=opsId
		
		set sc=##class(CIS.AN.SRV.Event.OnOperRegister).Trigger(args)
	}
	catch(e)
	{
		write e.DisplayString(),!
	}
	
	quit ""
}

ClassMethod OperEditPermission(opsId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set permission="N"
	if ($isobject(operSchedule.AnaDept))
	{
		set anaDeptId=operSchedule.AnaDept.%Id()
		set patDeptId=operSchedule.PatDeptID.%Id()
		set appDeptId=operSchedule.AppDeptID.%Id()
		set:(anaDeptId=patDeptId)!(anaDeptId=appDeptId) permission="Y"	
	}
	quit permission
}

/// d ##class(CIS.AN.BL.OperApplication).AddTestApplication()
ClassMethod AddTestApplication() As %String
{
	for i=1:1:200
	{
		d ##class(CIS.AN.BL.OperApplication).SaveOperApplication(^TMPOPAPP("Para"))	
	}
	quit "S^"
}

ClassMethod FinishOperation(opsId As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	set saveResult="S^"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set statusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Finish")
	set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(statusId)
	set sc=operSchedule.%Save()
	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	
	set arrangeLog=##class(CIS.AN.BL.OperArrange).CreateArrangeLog(opsId,"",userId)
	set arrangeLog.ReleaseDate=+$h
	set arrangeLog.ReleaseTime=$p($h,",",2)
	set arrangeLog.Note="停止手术"
	set sc=arrangeLog.%Save()
	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"FNH",userId,+$h,$p($h,",",1))
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}

	tcommit
	
	do ..AfterFinishOperation(opsId, userId)
	
	quit saveResult
Error
	trollback
	quit "E^"_$ze
}

ClassMethod AfterFinishOperation(opsId, userId) As %Status
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	try
	{
		set saveResult=##class(CIS.AN.SRV.OperAppService).FinishOperation(opsId,userId)
	}
	catch(e)
	{
		//write "旧版兼容-回写旧表错误:",e.DisplayString(),!
	}
	
	quit $$$OK
}

/// w ##class(CIS.AN.BL.OperApplication).CanFinishOperation(4)
ClassMethod CanFinishOperation(opsId As %String) As %String
{
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	b ;1
	set enableFinishForReg=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("EnableFinishForReg")
	b ;2
	set enableFinishForLocalAna=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("EnableFinishForLocalAna")
	b ;3
	set isLocalAnaMethod=##class(CIS.AN.BL.Anaesthesia).IsLocalAnaMethod(opsId)
	b //ccq
	quit:(enableFinishForReg="Y")&(enableFinishForLocalAna="Y") "Y"	
	quit:(enableFinishForReg="N")&(enableFinishForLocalAna="Y")&(isLocalAnaMethod="Y") "Y"
	quit:(enableFinishForReg="Y")&(enableFinishForLocalAna="N")&(isLocalAnaMethod="N") "Y"
	quit "N"
}

/// w ##class(CIS.AN.BL.OperApplication).CanEditOperation("440","33","29","btnEditOperation")
ClassMethod CanEditOperation(opsId As %String, userId As %String, groupId As %String, elementId As %String) As %String
{
	set editAppByAppUser=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("EditAppByAppUser")
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	if (editAppByAppUser="Y")&(operSchedule.AppUserID'=userId)
	{
		quit "E^当前用户不是手术申请用户，不能修改手术！"	
	}
	set permissionStatus=""
	&sql(select OperStatus into :permissionStatus from CF_AN.ActionPermission where GroupID=:groupId and OperAction->ElementID=:elementId and Active='Y')
	set curStatusId=operSchedule.Status.%Id()
	set curStatusDesc=operSchedule.Status.Description
	if (permissionStatus="")
	{
		quit "E^当前用户安全组修改手术权限配置不完整，请联系系统管理员！"
	}
	if (permissionStatus'="")&((","_permissionStatus_",") '[ (","_curStatusId_","))
	{
		quit "E^当前用户安全组不能修改["_curStatusDesc_"]状态的手术！"	
	}
	quit "S^"
}

ClassMethod CanCancelOperation(opsId As %String, userId As %String, groupId As %String, elementId As %String) As %String
{
	set CancelAppByAppUser=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("CancelAppByAppUser")
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	if (CancelAppByAppUser="Y")&(operSchedule.AppUserID'=userId)
	{
		quit "E^当前用户不是手术申请用户，不能取消手术！"	
	}
	set permissionStatus=""
	&sql(select OperStatus into :permissionStatus from CF_AN.ActionPermission where GroupID=:groupId and OperAction->ElementID=:elementId and Active='Y')
	set curStatusId=operSchedule.Status.%Id()
	set curStatusDesc=operSchedule.Status.Description
	if (permissionStatus="")
	{
		quit "E^当前用户安全组取消手术权限配置不完整，请联系系统管理员！"
	}
	if (permissionStatus'="")&((","_permissionStatus_",") '[ (","_curStatusId_","))
	{
		quit "E^当前用户安全组不能取消["_curStatusDesc_"]状态的手术！"	
	}
	quit "S^"
}

/// w ##class(CIS.AN.BL.OperApplication).CancelOperation("905","10211","52","btnCancelOperation")
ClassMethod DeclineOperation(opsId As %String, reason As %String, cancelUserId As %String, groupId As %String) As %String
{
    set $zt="Error"
    tstart
    
    set CancelAppByAppUser=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("CancelAppByAppUser")
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set permissionStatus=""
	&sql(select OperStatus into :permissionStatus from CF_AN.ActionPermission 
	where GroupID=:groupId and OperAction->ElementID=:elementId and Active='Y')
	set curStatusId=operSchedule.Status.%Id()
	set curStatusDesc=operSchedule.Status.Description
	if (permissionStatus="")
	{
		quit "E^当前用户安全组取消手术权限配置不完整，请联系系统管理员！"
	}
	if (permissionStatus'="")&((","_permissionStatus_",") '[ (","_curStatusId_","))
	{
		quit "E^当前用户安全组不能取消["_curStatusDesc_"]状态的手术！"	
	}
	
	
    set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    set cancelStatusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Decline")    
    set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(cancelStatusID)
    set operSchedule.CancelReason=reason
    set sc=operSchedule.%Save()
    if ($System.Status.IsError(sc))
    {
        trollback
        quit "E^"_$System.Status.GetErrorText(sc)   
    }
    set operArrange=##class(CIS.AN.OperArrange).%New()
    set operArrange.OperSchedule=operSchedule
    set operArrange.ReleaseUser=cancelUserId //##class(CF.AN.SSUser).%OpenId(cancelUserId)
    set operArrange.OperStatus=operSchedule.Status
    set operArrange.Note=reason
    set sc=operArrange.%Save()
    if ($System.Status.IsError(sc))
    {
        trollback
        quit "E^"_$System.Status.GetErrorText(sc)   
    }
    //&SQL(Select ExternalID into :UserId from CF_AN.SSUser where RowId=:cancelUserId)
    if (operSchedule.AppOrderItem)
    {
    set saveResult=##class(CIS.AN.BL.OEOrder).CancelOEOrder(operSchedule.AppOrderItem,cancelUserId)
    if ($p(saveResult,"^",1)'="S")
    {
        trollback
        quit saveResult     
    }
    }
    set saveResult=##class(CIS.AN.SRV.OperAppService).CancelApplication(opsId,cancelUserId) // 取消手术回写旧表
    if ($p(saveResult,"^",1)'="S")
    {
        trollback
        quit saveResult     
    }
    set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"CCL",cancelUserId,+$h,$p($h,",",2))
    if ($p(saveResult,"^",1)'="S")
    {
        trollback
        quit saveResult     
    }
    tcommit
    
    do ..AfterCancelOper(opsId)
    quit "S^"
Error
    trollback
    quit "E^"_$ze
}

ClassMethod AfterCancelOper(opsId) As %Status
{
	set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	try
	{
		//20211214
		set opaId=operScheduleObj.ExternalID
		// 调用消息平台接口	
		s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
		set:(+OAret'=0) saveResult="E^发送手术申请失败，原因："_$p(OAret,"^",2)
		if (+OAret'=0) write "DTS:调用消息平台接口错误:",$p(OAret,"^",2),!
	}
	catch(e)
	{
		write "DTS:调用消息平台接口错误:",e.DisplayString(),!
	}
	
	quit $$$OK
}

ClassMethod CancelAudit(opsIdStr As %String, auditUser As %String) As %String
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
		set auditStatusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Application")	// 取消审核后，手术状态变为“申请”
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
		set operArrange.Note="取消审核手术"
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
		set saveResult=##class(CIS.AN.SRV.OperAppService).CancelAudit(opsId,auditUser)		// 回写旧表
		quit:($p(saveResult,"^",1)="E")	
		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"CADT",auditUser,+$h,$p($h,",",2))
		quit:($p(saveResult,"^",1)="E")
		
		//Set rtnMes =##class(websys.DHCMessageInterface).Send("审核手术", "1053", operArrange.ReleaseUser.ExternalID, operSchedule.EpisodeID ,"","", "opaId为"_operSchedule.ExternalID ,operSchedule.OperDeptID.ExternalID)
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

/// w ##class(CIS.AN.BL.OperApplication).GetOperIdByICD("01.1401")
ClassMethod GetOperIdByICD(operICD As %String) As %String
{
	set operId="",operDesc="",operInfo=""
	&sql(select RowId,Description into:operId,:operDesc from CT_AN.Operation where ICD10=:operICD)
	set operInfo=operId_"^"_operDesc
	quit operInfo
}

/// w ##class(CIS.AN.BL.OperApplication).AuditOperApp("30")
ClassMethod AuditOperApp(groupId As %String, sourceType As %String) As %String
{
	set ret="N"
	set NeedAuditOper=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditOperation")
	quit:(sourceType'="E")&(NeedAuditOper'="Y") "N"
	set NeedAuditEMOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditEMOperation")
	quit:(sourceType="E")&(NeedAuditEMOperation'="Y") "N"
	&sql(select AuditOperApp into :ret from CF_AN.SSGroup where GroupID=:groupId)
	quit ret
}

/// w ##class(CIS.AN.BL.OperApplication).GetAppConfig(95,33,"",2)
ClassMethod GetAppConfig(deptID As %String, EpisodeID As %String, opsId As %String, hospId As %String) As %String
{
	// 默认手术室、麻醉科
    set retArr(1,"defOperDept")=##class(CIS.AN.BL.OperApplication).GetDefOperDept(deptID)
    set retArr(1,"defANDept")=##class(CIS.AN.BL.OperApplication).GetDefANDept(deptID)
    set retArr(1,"defANDeptDesc")=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",retArr(1,"defANDept"))
    // 择期手术申请截止时间
    set retArr(1,"appDeadLine")=##class(CIS.AN.BL.OperApplication).GetOperAppDeadLine()
    // 默认手术类型
    set appDeadLine=retArr(1,"appDeadLine")
    set sourceType="B"
    set:(appDeadLine="Y") sourceType="E"
    set retArr(1,"sourceType")=sourceType
    // 默认手术日期
    set retArr(1,"operDate")=##class(CIS.AN.BL.OperApplication).GetOperDate(sourceType)
    
    // 暂存的手术
    set tempAppID="" //..GetTempAppID(EpisodeID)
    set retArr(1,"tempAppID")=tempAppID
    set retArr(1,"tempApp")="N"
    //set:(##class(CIS.AN.OperSchedule).%ExistsId(tempAppID)) retArr(1,"tempApp")="Y"
    
    // 新增申请
    set retArr(1,"newApp")="N"
    set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) retArr(1,"newApp")="Y"
    
    // 获取患者最近的检验结果
    set retArr(1,"testResult")=..GetTestDataJSON(EpisodeID,retArr(1,"operDate"))
    set retArr(1,"testResult","Type")="JSON"
    
    // 麻醉科室列表
    set retArr(1,"anaDepts")=..GetAnaDepts(deptID,hospId)
    set retArr(1,"anaDepts","Type")="JSON"
    
    // 获取患者的主诊断作为术前诊断的默认值。
    if (##class(User.PAAdm).%ExistsId(EpisodeID))
    {
	    set admDiag=##class(CIS.AN.COM.Query).ToString(.admDiagArr,"CIS.AN.BL.Admission:FindAdmDiagnosis",EpisodeID,"C008")
    	set retArr(1,"admDiagnosis")=##class(CIS.AN.COM.String).ToJson(.admDiagArr)
    	set retArr(1,"admDiagnosis","Type")="JSON"
	}
	else
	{
		set retArr(1,"admDiagnosis")=""
	}
    
    
    // 临床知识库验证手术名称配置
    set retArr(1,"validOperation")=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("JudgeClinicKnowledge")
    
    // 关联电子病历
    set retArr(1,"linkEMR")=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("LinkEMR")
    
    // 默认在本科做的麻醉
    set retArr(1,"AnaesthesiaByLocal")=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("AnaesthesiaByLocal")
    
    set result=##class(CIS.AN.COM.String).ToJson(.retArr)
    quit result
}

/// w ##class(CIS.AN.BL.OperApplication).GetTestDataJSON(87,"2022-07-18")
ClassMethod GetTestDataJSON(EpisodeID As %String, operDate As %String) As %String
{
	set operDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(operDate)
	set startDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operDateH-27)
	set endDate=operDate
	set startTime="00:00",endTime="00:00"
	set standardItemStr="BloodType^RHBloodType^HbsAg^HcvAb^HivAb^Syphilis^MDROS"
	set standardCodeStr="ABO^RH^HbsAg^HCV-Ab^HIV-Ab^TPAb^MDROS"
	set codeCount=$l(standardCodeStr,"^")
	set dataObj=##class(CIS.AN.COM.DataObject).%New()
	set dataObj.KeyValuePairs=##class(%ListOfObjects).%New()
	set result="{"
	for i=1:1:codeCount
	{
		;set standardCode=$p(standardCodeStr,"^",i)
		;set standardItem=$p(standardItemStr,"^",i)
		set standardCode=""
		set standardItem=$p(standardItemStr,"^",i)
		//检验代码取码表维护 YuanLin 20210105 
		&sql(select Code into :standardCode from CT_AN.Dictionary where Description=:standardItem)
		if (standardCode="") set standardCode=$p(standardCodeStr,"^",i)
		
		set testResult=##class(web.DHCClinicCom).GetTestResult(EpisodeID,"","",standardCode,startDate,startTime,endDate,endTime)
		set testValue=$p(testResult,$c(2),1),valueRange=$p(testResult,$c(2),3),rangeMin=$p(valueRange,"-",1),rangeMax=$p(valueRange,"-",2)
		set defaultValue=testValue
		b ;1212
		if ($isvalidnum(defaultValue))&($isvalidnum(rangeMin))&($isvalidnum(rangeMax))
		{
			if (defaultValue>=rangeMin)&(defaultValue<=rangeMax)
			{
				set defaultValue="-"	
			}	
			else
			{
				set defaultValue="+"	
			}
		}
		else
		{
			set defaultValue="N"	
		}
		set testValue=$case(testValue,"A型":"A","B型":"B","AB型":"AB","O型":"O","阴性(-)":"-","阳性(+)":"+",:defaultValue)	
		if standardCode="MDROS"
		{
			set testResult=""
			 //set testResult=##class(web.DHCClinicCom).GetMDROSResult(EpisodeID,operDate,operDate)
			 if testResult'=""  set testValue="+"   //多重耐药菌有结果即认定为阳性 YuanLin 20210902
			 else  set testValue="-"
		}
		set result=result_""""_standardItem_""":"""_testValue_""""
		set:(i'=codeCount) result=result_","
	}	
	set result=result_"}"
	quit result
}

/// 判断手术是否需要审核
ClassMethod NeedAuditOperation(opsId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set NeedAuditOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditOperation")
	if (operSchedule.SourceType="E")
	{
		set NeedAuditOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditEMOperation")
	}
	quit NeedAuditOperation
}

/// w ##class(CIS.AN.BL.OperApplication).SYNCHRONIZEOPERINFO("10")
ClassMethod SYNCHRONIZEOPERINFO(opsId As %String) As %String
{
	k dataArr
	set SurgeonIdStr="",SurgeonDescStr="",OperClassDescStr="",BladeTypeDescStr=""
	set OperCodeStr="",SurgeonDesc="",OPAdmType="",AppUserName=""
	set operScheduleObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.OperScheduleList:FindOperScheduleList","","","",opsId)	
	set PatientID=operScheduleObj.GetValue("PatientID")
	set EpisodeID=operScheduleObj.GetValue("EpisodeID")
	set PatName=operScheduleObj.GetValue("PatName")
	set AppDeptID=operScheduleObj.GetValue("AppDeptID")
	set AppDeptCode=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCCode",AppDeptID)
	set AppDeptDesc=operScheduleObj.GetValue("AppDeptDesc")
	set PatGender=operScheduleObj.GetValue("PatGender")
	set PatGender=$case(PatGender,"女":0,"男":1,"其他":2,"":"")
	set OperPositionDesc=operScheduleObj.GetValue("OperPositionDesc")
	set PrevDiagnosis=operScheduleObj.GetValue("PrevDiagnosis")
	set SurgeonDesc=operScheduleObj.GetValue("SurgeonDesc")
	
	set AppUserID=operScheduleObj.GetValue("AppUserID")
	set AppUserName=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",AppUserID)
	&sql(select CTPCP_Desc into :AppUserName from sqluser.CT_CareProv where CTPCP_Code=:AppUserID)
	set AppDeptID=operScheduleObj.GetValue("AppDeptID")
	set AppDeptCode=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCCode",AppDeptID)
	set AppDeptDesc=operScheduleObj.GetValue("AppDeptDesc")
	
	&sql(select PAADM_Type into :OPAdmType from sqluser.PA_Adm where PAADM_PAPMI_DR=:PatientID)
	set OPAdmType=$case(OPAdmType,"E":1,"O":2,"I":3,"":"")
	set operData=##class(CIS.AN.BL.OperScheduleList).GetOperList(opsId,.operData)
	set OperDesc=operData(1,"OperationDesc")
	set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	set AnaMethodDesc=anaestObj.GetValue("AnaMethodDesc")
	set BirthDate=##class(CIS.AN.COM.String).GetDescByID("User.PAPatMas","PAPMIDOB",PatientID)
	set:(BirthDate'="") BirthDate=$zd(BirthDate,3)
	
	set operList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindPlanOperationList",opsId)
	for i=1:1:operList.Size
	{
		set operObj=operList.GetAt(i)
		set SurgeonId=operObj.GetValue("Surgeon")
		set:(SurgeonIdStr'="") SurgeonIdStr=SurgeonIdStr_splitChar
		set SurgeonIdStr=SurgeonIdStr_SurgeonId
	    &sql(select CTPCP_Desc into :SurgeonDesc from sqluser.CT_CareProv where CTPCP_Code=:SurgeonId)
		set:(SurgeonDescStr'="") SurgeonDescStr=SurgeonDescStr_splitChar
		set SurgeonDescStr=SurgeonDescStr_SurgeonDesc
		
		set operId=operObj.GetValue("Operation")
	    set OperCode=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERCode",operId)
		set:(OperCodeStr'="") OperCodeStr=OperCodeStr_splitChar
		set OperCodeStr=OperCodeStr_OperCode
		
		set OperClass=operObj.GetValue("OperClass")
	    set OperClassDesc=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperationCategory","CATEGDesc",OperClass)
		set:(OperClassDescStr'="") OperClassDescStr=OperClassDescStr_splitChar
		set OperClassDescStr=OperClassDescStr_OperClassDesc
		
		set BladeType=operObj.GetValue("BladeType")
	    set BladeTypeDesc=##class(CIS.AN.COM.String).GetDescByID("User.ORCBladeType","BLDTPDesc",BladeType)
		set:(BladeTypeDescStr'="") BladeTypeDescStr=BladeTypeDescStr_splitChar
		set BladeTypeDescStr=BladeTypeDescStr_BladeTypeDesc
	}
	set dataArr(1,"IDNO")=opsId
	set dataArr(1,"PatientDR")=PatientID
	set dataArr(1,"VisitID")=EpisodeID
	set dataArr(1,"VisitType")=OPAdmType
	set dataArr(1,"Name")=PatName
	set dataArr(1,"UserID")=SurgeonIdStr
	set dataArr(1,"UserName")=SurgeonDescStr
	set dataArr(1,"DeptCode")=AppDeptCode
	set dataArr(1,"DeptName")=AppDeptDesc
	set dataArr(1,"HospCode")=""
	set dataArr(1,"HospName")=""
	
	set DataArr(1,"Gender")=PatGender
	set DataArr(1,"BirthDate")=BirthDate
	set DataArr(1,"PregnancyStatus")=""
	set PatientInfo=##class(CIS.AN.COM.String).ToJson(.DataArr)
	set dataArr(1,"PatientInfo")=PatientInfo
	
	set dataArrNew(1,"OrderID")=""     //?医嘱唯一标识
	set dataArrNew(1,"OrderClass")=1   //医嘱类型
	set dataArrNew(1,"OrderFlag")=1    //?医嘱操作标识
	set dataArrNew(1,"OrderType")=4    //医嘱分类
	set dataArrNew(1,"CreatTime")=""   //?医嘱创建时间
	set dataArrNew(1,"StopTime")=""    //?医嘱作废时间
	set dataArrNew(1,"DoctorId")=AppUserID
	set dataArrNew(1,"DoctorName")=AppUserName
	set dataArrNew(1,"CreateDeptCode")=AppDeptCode
	set dataArrNew(1,"CreatDeptName")=AppDeptDesc
	set dataArrNew(1,"GroupSequence")=0
	set dataArrNew(1,"OrderCode")=OperCodeStr
	set dataArrNew(1,"OrderContent")=OperDesc
	set dataArrNew(1,"Position")=OperPositionDesc
	set dataArrNew(1,"Level")=OperClassDescStr
	set dataArrNew(1,"IncisionType")=BladeTypeDescStr
	set dataArrNew(1,"Anesthesia")=AnaMethodDesc
	set dataArrNew(1,"PreoperativeDiagnose")=PrevDiagnosis
	set OrderEntry=##class(CIS.AN.COM.String).ToJson(.dataArrNew)
	set dataArr(1,"OrderEntry")=OrderEntry
	set ret=##class(CIS.AN.COM.String).ToJson(.dataArr)
	quit ret
}

ClassMethod SaveAnaApplication(dataPara As %String) As %String
{
	set ^TMPANAPP("dataPara")=dataPara
	set $zt="Error"
    tstart
    set status=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
    // 第一个对象为手术明细信息
    kill operSchedule
    m operSchedule=array(1)
    set isEditStatus=##class(CIS.AN.OperSchedule).%ExistsId($g(operSchedule("RowId")))
    // 第二个对象为麻醉过程
    //m anaesthesia=array(2)
    set opsId=$g(operSchedule("RowId"))
    set EpisodeID=$g(operSchedule("EpisodeID"))
    set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
	set operSchedule("PatName")=patInfoObj.GetValue("PatName")
	set operSchedule("PatGender")=patInfoObj.GetValue("PatGender")
	set operSchedule("PatDOB")=patInfoObj.GetValue("PatDOB")
	set operSchedule("AdmDate")=patInfoObj.GetValue("AdmDateH")
	set operSchedule("MedicareNo")=patInfoObj.GetValue("MedicareNo")
	set operSchedule("RegNo")=patInfoObj.GetValue("RegNo")
	set operSchedule("CardID")=patInfoObj.GetValue("CardID")
	set operSchedule("AdmReason")=patInfoObj.GetValue("AdmReason")
	set operSchedule("EpisodeID")=EpisodeID
	set operSchedule("ClassName")="CIS.AN.OperSchedule"
	set operSchedule("AppType")="AN"
	set operSchedule("OPAdmType")=$case(patInfoObj.GetValue("AdmType"),"O":"OOP",:"IOP")
	set operSchedule("PatDeptID")=patInfoObj.GetValue("PatDeptID")
	set operSchedule("PatWardID")=patInfoObj.GetValue("PatWardID")
	set operSchedule("PatBedID")=patInfoObj.GetValue("PatBedID")
	set operDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(operSchedule("OperDate"))
	set today=+$h
	set:(operDateH=today) operSchedule("SourceType")="E"
	set:(operDateH>today) operSchedule("SourceType")="B"
	set operSchedule("Anaesthesia")="Y"
    
    // 没有手术状态时，一般认为是新建手术申请，需要对手术状态赋值
    if (##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
    {
        set operSchedule("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Application")
    }
    
    set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)

    // 保存到麻醉表OR_Anaesthesia，因为his需要引用OR_Anaesthesia的数据。
    set opsId=$piece(saveResult,"^",2),ansId=0
    if ($piece(saveResult,"^",1)="S")
    {
        //set opsId=$piece(saveResult,"^",2)
        set operSchedule("RowId")=opsId
        set anaesthesia("RowId")=$get(operSchedule("ExtAnaestID"))
        set anaesthesia("ParentRowId")=EpisodeID
        set saveResult=..SaveORAnaesthesia(.anaesthesia)
    }

    // 将OR_Anaesthesia表的RowId保存到CIS_AN.OperSchedule表中，方便直接调用
    if ($piece(saveResult,"^",1)="S")
    {
        set anaId=$piece(saveResult,"^",2)
        set operSchedule("ExtAnaestID")=anaId
        set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operSchedule)
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
    	set operation=$g(operSchedule("Operation")),operNote=$g(operSchedule("OperNote"))
    	&sql(insert into CIS_AN.PlanOperList (OperSchedule,Operation,OperNote) values (:opsId,:operation,:operNote))
	    set:(SQLCODE'=0) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
	    
    }
    if ($piece(saveResult,"^",1)="S")
    {   
    	set operation=$g(operSchedule("Operation")),operNote=$g(operSchedule("OperNote"))
    	&sql(insert into CIS_AN.OperList (OperSchedule,Operation,OperNote) values (:opsId,:operation,:operNote))
	    set:(SQLCODE'=0) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
	    
    }
	if ($piece(saveResult,"^",1)="S")&(isEditStatus=0)
    {
	    // 写手术操作过程
	    set actionUserId=$g(operSchedule("AppUserID"))
	    set procedureCode="APP"
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

/// 批量完成手术
ClassMethod BatchFinishOperation(opsIdStr As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	set opsCount=$l(opsIdStr,"^"),saveRet="S^"
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,"^",i)
		set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) saveRet="E^不存在ID为"_opsId_"的手术申请。"
		quit:($p(saveRet,"^",1)'="S")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set:("^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^" '[ operSchedule.Status.Code) saveRet="E^患者"_operSchedule.PatName_"的手术状态是【"_operSchedule.Status.Description_"】，不能完成手术。"
		quit:($p(saveRet,"^",1)'="S")
		set finishStatus=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Finish")
		set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(finishStatus)
		set sc=operSchedule.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($p(saveRet,"^",1)'="S")
		set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"FNH",userId,+$h,$p($h,",",2))
		quit:($p(saveRet,"^",1)'="S")
	}
	
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// Creator：        元琳
/// CreatDate：      2020-11-20
/// Description：    检查是否满足手术申请条件(是否录入诊断/是否做医疗结算/是否分配床位)
/// Input:           data:数据字符串
/// Return：         验证通过返回"Y"，验证失败返回"N"
/// w ##class(CIS.AN.BL.OperApplication).VerifyConditions(2020)
ClassMethod VerifyConditions(EpisodeID As %String) As %String
{
	s ret="Y"
	s paadmStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	s mradm=$P(^PAADM(EpisodeID),"^",61)
	i paadmStatus="C" s ret="该就诊记录已经取消"
	i paadmStatus="D"  s ret="患者已出院,不能申请手术"
	q:(ret'="Y") ret
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70) 
	i bedSub="" s ret="患者尚未安排床位,不能申请手术"
	q:(ret'="Y") ret
	s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradm)
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
	.q:ret'="Y"
	.s curDiagStr=$p(diagInfoStr,"^",dnum)
	.s curDigDesc=$p(curDiagStr,"&&",1)
	.s curDigId=$p(curDiagStr,"&&",2)
	.s curDigNote=$p(curDiagStr,"&&",3)
	.s curPreFix=$p(curDiagStr,"&&",4)
	.s curDigType=$p(curDiagStr,"&&",5)
	.i curDigType="出院诊断" s ret="患者已有出院诊断,不能申请手术"
	.i curDigType="" s ret="患者未录入院诊断,不能申请手术"
	q:(ret'="Y") ret
	q ret
}

/// Creator：        元琳
/// CreatDate：      2020-12-10
/// Description：    验证同一个病人同一天内所开择期手术是否重复
/// Input:           data:数据字符串
/// Return：         重复返回"Y"，否则返回"N"
/// w ##class(CIS.AN.BL.OperApplication).VerifyOperRepeated(98,"2021-10-09","")
ClassMethod VerifyOperRepeated(EpisodeID As %String, OpDate As %String, operIdStr As %String, OPSID As %String) As %String
{
	s ret="N"
	set opsId=0
    set dateformatnum=##class(websys.Conversions).DateFormat()
	set OpDate=$zdh(OpDate,dateformatnum)
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("Adm"," "_EpisodeID,opsId))
		quit:(OPSID=opsId)
		quit:ret="Y"
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(operSchedule.OperDate,"")
		set operStatusCode=operSchedule.Status.Code
		set operInfo=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
		set operData=##class(CIS.AN.BL.OperScheduleList).GetOperList(opsId,.operData)					// 实施手术
		set OperId=operData(1,"Operation")
		continue:((operStatusCode="Decline")||(operStatusCode="Cancel")||(operStatusCode="Revoke")||(operStatusCode="Stop"))
		continue:(OperDate'=OpDate)
		set:(","_operIdStr_",")[(","_OperId_",") ret="Y"
		set:(","_OperId_",")[(","_operIdStr_",") ret="Y"
	}
	q ret
}

/// Creator：    元琳
/// CreatDate：  2020-12-15
/// Description：文书管控,判断是否已按要求填写相关文书并输出文书记录
/// Input:       EpisodeID   就诊号
///              OpsId       手术ID
///              FileId      文档Id
///              ItemType    文档类型(检验LIS/检查PACS/病理PIS/病历EMR/手麻AN)
/// Return：     happenDate   病历完成日期(YY-MM-DD)
///              happenTime   病历完成时间(HH-MM-SS)
///              title        病历名称
///              creator      创建病历者
///              isLink       是否关联,"0"：未关联；"1"：已关联
///              insID        病历ID
/// d ##Class(%ResultSet).RunQuery("CIS.AN.BL.OperApplication","GetOperativeRecord",91,"",88)
Query GetOperativeRecord(EpisodeID As %String = "", OpsId As %String = "", FileId As %String = "", ItemType As %String = "") As %Query(ROWSPEC = "happenDate:%String,happenTime:%String,title:%String,creator:%String,isLink:%String,insID:%String")
{
}

ClassMethod GetOperativeRecordExecute(ByRef qHandle As %Binary, EpisodeID As %String, OpsId As %String, FileId As %String, ItemType As %String) As %Status
{
	set repid = $i(^CacheTemp)
    set ind = 1
    set happenDate="",happenTime="",title="",creator="",creatorId="",isLink="",rowId="",opaId=""
    if OpsId'="" {
	    set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(OpsId)
		set opaId=operScheduleObj.ExternalID
    }
	if ItemType="EMR"
	{
		set RecordInfo=##class(CIS.AN.COM.Query).ToObjects("EMRservice.InterfaceService.Operation:GetOperativeRecord",EpisodeID,opaId,FileId)
		for i=1:1:RecordInfo.Size
		{
			set RecordObj=RecordInfo.GetAt(i)
			set happenDate=RecordObj.GetValue("happenDate")
			set happenTime=RecordObj.GetValue("happenTime")
			set title=RecordObj.GetValue("title")
			set creator=RecordObj.GetValue("creator")
			set isLink=RecordObj.GetValue("isLink")
			set rowId=RecordObj.GetValue("insID")
		}
	}
	if ItemType="AN"
	{
		if (OpsId="")
		{
			do OutputRow
			s qHandle=$lb(0,repid,0)
			q $$$OK
		}
		else
		{
			&SQL(Select CreateDate,CreateTime,CreateUser into :happenDate,:happenTime,:creatorId from CIS_AN.RecordSheet where OperSchedule=:OpsId and DataModule=:FileId)
			&SQL(Select Description into :title from CT_AN.DataModule where RowId=:FileId)
			&SQL(Select SSUSR_Name into :creator from SQLUser.SS_User where SSUSR_RowId=:creatorId)
			if happenDate'="" set happenDate = $zd(happenDate,3)
            if happenTime'="" set happenTime = $zt(happenTime)
		}
	}
	do OutputRow
	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow
	set ^CacheTemp(repid,ind)=$lb(happenDate,happenTime,title,creator,isLink,rowId)
	set ind=ind+1
	quit
}

ClassMethod GetOperativeRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperativeRecordExecute ]
{
    s repid=$list(qHandle,2)
    k ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOperativeRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperativeRecordExecute ]
{
    s AtEnd=$list(qHandle,1)
    s repid=$list(qHandle,2)
    s ind=$list(qHandle,3)
    s ind=$o(^CacheTemp(repid,ind))
    if ind="" { 
        s AtEnd=1
        s Row=""
        k ^CacheTemp(repid)
    } else {
        s Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：    元琳
/// CreatDate：  2020-12-15
/// Description：文书完整性验证
/// Input:       EpisodeID       就诊号
///              OpsId           手术ID
///              RecordSheetID   文档Id
/// Return：     完整返回1,不完整：提示返回0,禁止返回-1
/// w ##class(CIS.AN.BL.OperApplication).CheckOperRecordValid("52",652,2053)
ClassMethod CheckOperRecordValid(EpisodeID As %String, OpsID As %String, RecordSheetID As %String) As %String
{
	set ret=1,dataModule="",contorlType="",DataModuleId=""
	&SQL(Select DataModule into :dataModule from CIS_AN.RecordSheet where RowId=:RecordSheetID)
	quit:dataModule="" ret
	
	set rowId=0
	for
	{
		set rowId=$order(^CT.AN.OperRiskControlI("ITriggerTiming",dataModule,rowId))
		quit:(rowId="")
		set DataModuleId=$lg(^CT.AN.OperRiskControlD(rowId),2)
		set Description=$lg(^CT.AN.OperRiskControlD(rowId),3)
		set ControlType=$lg(^CT.AN.OperRiskControlD(rowId),7)
		&SQL(Select * From CIS_AN.RecordSheet where Operschedule=:OpsID and DataModule=:DataModuleId)
		if (SQLCODE=100)
		{
			set:(ControlType="MSG") ret="0^"_Description_"未填写"
			set:(ControlType="FORBID") ret="-1^"_Description_"未填写"
			quit:ret'=1
		}

	}
	quit ret
}

ClassMethod IsLocalAnaMethodById(anaMethodId As %String) As %String
{
	&sql(select ANMET_Type_DR into :anaTypeDr from SqlUser.ORC_AnaestMethod where ANMET_RowId=:anaMethodId)
	if anaTypeDr'="" &sql(select ANTYPE_Code into :anaType from SqlUser.ORC_AnaestType where ANTYPE_RowId=:anaTypeDr)
	set anaTypeCode=","_anaType_","
	set localAnaType=","_##class(CIS.AN.BL.DataConfiguration).GetValueByKey("LocalAnaType")_","
	quit:(localAnaType [ anaTypeCode) "Y"
	quit "N"
}

// w ##class(CIS.AN.BL.OperApplication).GetCDSSOperInfo(20)

ClassMethod GetCDSSOperInfo(opsId)
{
	set opInfo={}
	set operSchedule=##class(CIS.AN.COM.Query).ToDynamicObject("CIS.AN.BL.OperScheduleList:FindOperScheduleList","","","",opsId)
	
	set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set opInfo.IDNO=operSchedule.EpisodeID //患者主索引
	set opInfo.PatientDR=operSchedule.PatientID // 病人标识
	set opInfo.VisitID=..GetEpisodeIDNum(operSchedule.EpisodeID) // 就诊次
	set opInfo.VisitType=operSchedule.SourceType //就诊类型
	set opInfo.Name=operSchedule.PatName // 患者姓名
	set opInfo.UserID=operSchedule.AppUserID  //医生ID
	set appUser=##class(User.SSUser).%OpenId(operSchedule.AppUserID)
	set opInfo.UserName=appUser.SSUSRName //医生姓名
	set dept=##class(User.CTLoc).%OpenId(operSchedule.PatDeptID)
	set opInfo.DeptCode=dept.CTLOCCode  // 科室编码
	set opInfo.DeptName=dept.CTLOCDesc //科室名称
	set opInfo.HospCode=dept.CTLOCHospitalDR.HOSPCode //医院编码
	set opInfo.HospName=dept.CTLOCHospitalDR.HOSPDesc //医院名称
	set opInfo.PatientInfo={}
	set patientInfo={}
	set patientInfo.Gender=operSchedule.PatGender
	set patientInfo.BirthDate=operSchedule.PatDOB
	set patientInfo.PregnancyStatus="" // 妊娠状态???
	set opInfo.PatientInfo=patientInfo
	
	set orderEntry={} 
	set orderEntry.OrderID=operScheduleObj.AppOrderItem   // 医嘱唯一标识
	
	set appMedOrder=##class(User.OEOrdItem).%OpenId(operScheduleObj.AppOrderItem)
	
	set orderEntry.OrderClass=appMedOrder.OEORIPriorityDR.OECPRDesc  b // 医嘱类型
	set orderEntry.OrderFlag=""   // 医嘱操作标识
	set orderEntry.OrderType=appMedOrder.OEORICategDR.ORCATDesc   // 医嘱分类 OEORIItmMastDR
	set orderEntry.CreatTime=##class(web.DHCClinicCom).ConvertToDate(appMedOrder.OEORISttDat)_" "_##class(web.DHCClinicCom).ConvertToDate(appMedOrder.OEORISttTim)   // 医嘱创建时间
	set orderEntry.StopTime=""   // 医嘱作废时间
	set orderEntry.DoctorId=operSchedule.AppUserID   // 医生唯一标识
	set orderEntry.DoctorName=operSchedule.SurgeonDesc   // 医生姓名
	b 
	set appDept=##class(User.CTLoc).%OpenId(operSchedule.AppDeptID)
	set orderEntry.CreateDeptCode=appDept.CTLOCCode   // 开立科室代码
	set orderEntry.CreatDeptName=appDept.CTLOCDesc  // 开立科室名称
	set orderEntry.GroupSequence=""   // 医嘱组顺序
	set orderEntry.OrderCode=appMedOrder.OEORIItmMastDR.ARCIMCode   // 医嘱代码
	set orderEntry.OrderContent=appMedOrder.OEORIComment3   // 医嘱内容
	set orderEntry.Position=operSchedule.OperPosition   // 部位
	
	set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)
	set orderEntry.Level=operListObj.OperClassDesc    // 手术等级 一次申请可能会有多个???
	set orderEntry.IncisionType=operListObj.BladeType   // 切口类型 一次申请可能会有多个???
	set orderEntry.Anesthesia=operSchedule.AnaMethodDesc   // 麻醉方式
	set orderEntry.PreoperativeDiagnose=operSchedule.PrevDiagnosisDesc   // 术前诊断
	set orderEntry.OperationPosition=operSchedule.BodySite   // 手术体位
	set opInfo.OrderEntry=orderEntry
	quit opInfo.%ToJSON()
}

ClassMethod GetEpisodeIDNum(AEpisodeID As %String)
{
    s count=0
    s flag = "住院"
    q:AEpisodeID="" count
    s episodeType = ##class(EMRservice.BL.BLCDSSService).GetEpisodeType(AEpisodeID)
    s:episodeType="O" flag = "门诊"
    s:episodeType="E" flag = "急诊" 
    s ApatientId = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
    s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetEpisodeListByPID")
    d ds.Execute(ApatientId,"","")
    While (ds.Next()) {
        continue:(flag'=ds.Data("EpisodeType"))
        s count=count+1 
    }
    q count
}

// w ##class(CIS.AN.BL.OperApplication).GetLinkRecordByOpaID(5839,453)

ClassMethod GetLinkRecordByOpaID(EpisodeID As %String = "", opsId As %String = "")
{
	quit:EpisodeID="" ""
	quit:opsId="" ""
	set instanceId=""
	set docID=""
	set title=""
    set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set opaId=operScheduleObj.ExternalID
    set ds = ##Class(%Library.ResultSet).%New("EMRservice.InterfaceService.Operation:GetLinkRecordByOpaID")
    d ds.Execute(EpisodeID,opaId)
    While (ds.Next()) {
        set instanceId=ds.Data("insID")
        set docID=ds.Data("docID")
        set title=ds.Data("title")
    }
    quit instanceId_"^"_docID_"^"_title
}

/// Creator：    元琳
/// CreatDate：  2022-12-28
/// Description：CDSS功能：添加拟施手术时判断手术的限制性别、限制年龄。
/// Input:       operId
/// Return：     符合条件返回1,否则返回0
/// w ##class(CIS.AN.BL.OperApplication).CheckOperConditions("5839",1)
ClassMethod CheckOperConditions(EpisodeID As %String, operId As %String) As %String
{
	set OPERSex="",OPERAgeFrom="",OPERAgeTo=""
    set targetQuery="CIS.AN.BL.Admission:FindPatient"
    if ##class(CIS.AN.BL.Admission).ExistsInstance(EpisodeID) set targetQuery="CIS.AN.BL.Admission:FindPatientNew"
    set patInfoObj=##class(CIS.AN.COM.Query).ToObject(targetQuery,EpisodeID)
    set PatGender=patInfoObj.GetValue("PatGender")
    set PatAge=patInfoObj.GetValue("PatAge")
	set OPERAgeFrom=$p($g(^ORC("OPER",operId)),"^",24)
	set OPERAgeTo=$p($g(^ORC("OPER",operId)),"^",25)
	set OPERSexDr=$p($g(^ORC("OPER",operId)),"^",12)
	set:(OPERSexDr'="") OPERSex=$p($g(^CT("SEX",OPERSexDr)),"^",2)
	quit:((OPERSex'="")&(OPERSex'=PatGender)) 0
	quit:((OPERAgeFrom'="")&&(PatAge'="")&&(OPERAgeFrom>PatAge)) 0
	quit:((OPERAgeTo'="")&&(PatAge'="")&&(OPERAgeTo<PatAge)) 0
	quit 1
}

/// Creator：    元琳
/// CreatDate：  2022-01-09
/// Description：手术闭环需求-手术申请关联文书将术前讨论节点信息调用平台状态统一存储接口存储状态。
/// Input:       operId
/// Return：     符合条件返回1,否则返回其他
/// w ##class(CIS.AN.BL.OperApplication).GetEMRecordsInfoJson(466,"2073||1#1#通用手术知情同意书,2074||1#1#术前小结")
ClassMethod GetEMRecordsInfoJson(opsId As %String, linkEMRecords As %String) As %String
{
	set operArr=##class(%DynamicArray).%New()
	set count=$l(linkEMRecords,",")
	for i=1:1:count
	{
		set linkStr=$p(linkEMRecords,",",i)
		set insID=$p(linkStr,"#",1)
		set title=$p(linkStr,"#",3)
        set objInstance = ##Class(EMRinstance.InstanceData).%OpenId(insID)
        set happenDate = $zd(objInstance.HappenDate,3)
        set happenTime = $zt(objInstance.HappenTime)
		set Status=""
		set opInfo = ##class(%DynamicObject).%New()
		set operSchedule=##class(CIS.AN.COM.Query).ToDynamicObject("CIS.AN.BL.OperScheduleList:FindOperScheduleList","","","",opsId)
		set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		if (operScheduleObj.AppOrderItem'="") set opInfo.OEOrdItemID=operScheduleObj.AppOrderItem //医嘱号
		else  set opInfo.OEOrdItemID=operSchedule.OPSID //检查号
		set OperPosition=operSchedule.OperPosition
		set opInfo.Position=..GetOperPosDesc(OperPosition) //检查部位
		set opInfo.ExamID=operSchedule.OPSID //检查号
		set:(title["知情同意书") Status="OPAGREE"
		set:(title["术前讨论") Status="OPPREDIS"
		set:(title["术前小结") Status="OPPRESUM"
		set opInfo.Status=Status //状态
		set opInfo.UserID=operScheduleObj.AppUserID  //操作人工号
		set appUser=##class(User.SSUser).%OpenId(operScheduleObj.AppUserID)
		set opInfo.UserName=appUser.SSUSRName //操作人姓名
		set opInfo.UpDateTime=happenDate_" "_happenTime //操作时间日期
		set opInfo.SourceSystem="AN" //来源系统
		set opInfo.Notes=operSchedule.OperNote //备注
		set dept=##class(User.CTLoc).%OpenId(operScheduleObj.PatDeptID)
		set opInfo.OperateDeptCode=dept.CTLOCCode  // 操作科室代码
		set opInfo.OperateDept=dept.CTLOCDesc //操作科室名称
		do operArr.%Push(opInfo)
	}
	quit operArr.%ToJSON()
}

ClassMethod GetOperPosDesc(operPosStr As %String) As %String
{
    set operPosDesc=""
    set count=$l(operPosStr,",")
    for i=1:1:count
    {
        set operPosID=$p(operPosStr,",",i)
        continue:(##class(User.ORCOperPosition).%ExistsId(operPosID)=0)
        set operPosObj=##class(User.ORCOperPosition).%OpenId(operPosID)
        set:(operPosDesc'="")&(operPosObj.OPPOSDesc'="") operPosDesc=operPosDesc_"@"
        set operPosDesc=operPosDesc_operPosObj.OPPOSDesc
    }   
    quit operPosDesc
}

}
