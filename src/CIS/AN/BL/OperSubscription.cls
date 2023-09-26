/// 手术申请
Class CIS.AN.BL.OperSubscription Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.OperSubscription).SaveOperCatalogue(^TMPOPAPP("TMPPara"))
ClassMethod SaveOperCatalogue(data As %String) As %String
{
	set ^TMPOPAPP("TMPPara")=data
	set $zt="Error"
    tstart
    set status=##class(CIS.AN.COM.String).ToArray(data,.array)
    // 第一个对象为手术明细信息
    kill operCatalogue
    m operCatalogue=array(1)
    set isEditStatus=##class(CIS.AN.OperCatalogue).%ExistsId($g(operCatalogue("RowId")))
    
    // 没有手术状态时，一般认为是新建手术申请，需要对手术状态赋值
    if ($get(operCatalogue("Status"))="")&($get(operCatalogue("StatusCode"))'="")
    {
        set operCatalogue("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operCatalogue("StatusCode"))
    }
    elseif ($get(operCatalogue("Status"))="16")&($get(operCatalogue("StatusCode"))="Application")
    {
	    //暂存转正式
        set operCatalogue("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operCatalogue("StatusCode"))
    }
    elseif ($get(operCatalogue("DaySurgery"))="Y")&($get(operCatalogue("StatusCode"))'="")
    {
	    //日间确认
        set operCatalogue("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operCatalogue("StatusCode"))
    }
    
    // 配置为可以直接审核的安全组(系统配置->系统配置->安全组配置)，申请手术后手术状态直接为审核
    set groupId=$g(operCatalogue("GroupID")),sourceType=$g(operCatalogue("SourceType"))
    set auditOperApp=..AuditOperApp(groupId,sourceType)
    set:(auditOperApp="Y") operCatalogue("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Audit")
    set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operCatalogue)
    
    // 保存到麻醉表OR_Anaesthesia
    set opsId=$piece(saveResult,"^",2),ansId=0
    set OperCatalogueObj=##class(CIS.AN.OperCatalogue).%OpenId(opsId)
	set ORAnaestID=OperCatalogueObj.ExtAnaestID	
    if ($piece(saveResult,"^",1)="S")
    {
        set schedule("RowId")=opsId
        set schedule("ClassName")="CIS.AN.OperCatalogue"
        set anaesthesia("RowId")=ORAnaestID
        set anaesthesia("ParentRowId")=operCatalogue("EpisodeID")
        set anaesthesia("OperDate")=operCatalogue("OperDate")
        set anaesthesia("SourceType")=operCatalogue("SourceType")
        set anaesthesia("PrevAnaMethod")=operCatalogue("PrevAnaMethod")
        set anaesthesia("PrevDiagnosis")=operCatalogue("PrevDiagnosis")
        set saveResult=..SaveORAnaesthesia(.anaesthesia)
    }

    // 将OR_Anaesthesia表的RowId保存到CIS_AN.OperCatalogue表
    if ($piece(saveResult,"^",1)="S")
    {
        set anaId=$piece(saveResult,"^",2)
        set schedule("ExtAnaestID")=anaId
        set saveResult=##class(CIS.AN.COM.DataService).SaveData(.schedule)
    }
	set ORAnaestID=OperCatalogueObj.ExtAnaestID	
    
    if ($piece(saveResult,"^",1)="S")
    {
	    // 删除拟施手术表
	    &sql(delete from CIS_AN.PlanOperationList where OperCatalogue=:opsId)
	    set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^"_$System.SQL.SQLCODE(SQLCODE)
    }
    
    if ($piece(saveResult,"^",1)="S")
    {
	    // 删除实施手术表
	    &sql(delete from CIS_AN.OperationList where OperCatalogue=:opsId)
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
            set operation("RowId")=""
            set operation("OperCatalogue")=opsId
            set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operation)
            quit:($piece(saveResult,"^",1)'="S")
        }
    }
    
    if ($piece(saveResult,"^",1)="S")&(OperCatalogueObj.DaySurgery'="Y")
    {
	    set NeedAuditOper="N" //##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditOperation")
	    set NeedAuditEMOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditEMOperation")
		if (((OperCatalogueObj.SourceType="E")&&(NeedAuditEMOperation="N"))||((OperCatalogueObj.SourceType="B")&&(NeedAuditOper="N")))
	    {
		    // 配置为不需审核时直接插入手术申请医嘱,配置为需要审核时需要先审核
		    set saveResult=##class(CIS.AN.BL.OEOrdItem).SaveAppOrderItem(opsId)
		    if ($piece(saveResult,"^",1)="S")
		    {
			    // 如果插入手术申请医嘱成功，那么将医嘱ID保存到CIS_AN.OperCatalogue表
			    set orderItemID=$p(saveResult,"^",2)
			    set OperCatalogueObj.AppOrderItem=orderItemID
			    set sc=OperCatalogueObj.%Save()
			    set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
			}
	    }
    }
	if ($piece(saveResult,"^",1)="S")&(isEditStatus=0)
    {
	    // 写手术操作过程
	    set actionUserId=OperCatalogueObj.AppUserID
	    set procedureCode="APP"
        set saveResult=..SaveProcedure(opsId,procedureCode,actionUserId,+$h,$p($h,",",2))   
    }
    if ($piece(saveResult,"^",1)="S")&(isEditStatus=0)&(auditOperApp="Y")
    {
	    // 写手术操作过程
	    set actionUserId=OperCatalogueObj.AppUserID
	    set procedureCode="ADT"
        set saveResult=..SaveProcedure(opsId,procedureCode,actionUserId,+$h,$p($h,",",2)) 
    }
	// 删除结构化手术
	set useSKDOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("UseSKDOperation")
	if (useSKDOperation="Y")
	{
		set saveRet=##class(CIS.AN.BL.ExtInterface).RemoveSKDOperation(ORAnaestID)
		quit:($p(saveRet,"^",1)="E") saveRet
	}
	// 删除旧手术表相关数据（修改手术有可能删除某条手术）0-表示删除成功，100-表示无需要删除的数据
	&sql(delete from SQLUser.OR_Anaest_Operation where ANAOP_Par_Ref=:ORAnaestID)
	set admId=$p(ORAnaestID,"||",1)
	set anId=$p(ORAnaestID,"||",2)
	set ^OR(admId,"ANA",anId,"OP",0)=0
	set:(SQLCODE'=0)&(SQLCODE'=100) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
	quit:(SQLCODE'=0)&(SQLCODE'=100) saveRet
	
	// 重新写入手术数据
	set planOperListId="",saveRet="S^",count=0
	for
	{
		set planOperListId=$o(^CIS.AN.PlanOperationListI("IOPS",opsId,planOperListId))
		quit:(planOperListId="")
		set count=count+1
		set planOperList=##class(CIS.AN.PlanOperationList).%OpenId(planOperListId)
		set operationId=planOperList.Operation
		set operNote=planOperList.OperNote
		set surgeon=planOperList.Surgeon
		set bladeType=planOperList.BladeType
		set bodySite=planOperList.BodySite
		set operDept=OperCatalogueObj.OperDeptID
		set operDate=OperCatalogueObj.OperDate
		set daySurgery=OperCatalogueObj.DaySurgery
		set operType="M"
		set:(count>1) operType="S"
		&sql(insert into SQLUser.OR_Anaest_Operation 
			(ANAOP_Type_DR,ANAOP_Surgeon_DR,ANAOP_Blade_DR,ANAOP_CTLOC_DR,ANAOP_OpStartDate,ANAOP_DaySurgery,ANAOP_BodySite_DR,ANAOP_Par_Ref,ANAOP_OperType)
			values (:operationId,:surgeon,:bladeType,:operDept,:operDate,:daySurgery,:bodySite,:ORAnaestID,:operType))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
		set anaestOperId=%ROWID
		
		set OperSub=$p(anaestOperId,"||",3)
		set ^OR(admId,"ANA",anId,"OP",OperSub,"REM",1)=planOperList.OperNote				// 手术备注
		set $p(^OR(admId,"ANA",anId,"OP",OperSub,"DHC"),"^",1)=planOperList.OperClass		// 手术级别
		set $p(^OR(admId,"ANA",anId,"OP",OperSub,"DHC"),"^",7)=planOperList.SurgeonDeptID	// 术者科室

		set planOperList.ExternalID=anaestOperId
		set operation=planOperList.Operation
		set sc=planOperList.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		
		&sql(update CIS_AN.OperationList set ExternalID=:anaestOperId where OperCatalogue=:opsId and Operation=:operation)
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
		
		// 插入手术助手
		set:(##class(User.ORAnaestOperation).%ExistsId(anaestOperId)=0) saveRet="E^主手术不存在！"
		quit:(##class(User.ORAnaestOperation).%ExistsId(anaestOperId)=0)
		&sql(delete from SQLUser.OR_An_Oper_Assistant where OPAS_ParRef=:anaestOperId)
		set:(SQLCODE'=0)&(SQLCODE'=100) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)&(SQLCODE'=100)
		set assisCount=$l(planOperList.Assistant,",")
		for i=1:1:assisCount
		{
			set assisId=$p(planOperList.Assistant,",",i)
			set careProvId=assisId
			quit:(##class(User.CTCareProv).%ExistsId(careProvId)=0)
			&sql(insert into SQLUser.OR_An_Oper_Assistant (OPAS_ParRef,OPAS_Assist_DR)
				  values (:anaestOperId,:careProvId))
			set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
			quit:(SQLCODE'=0)
			
		}
		quit:($p(saveRet,"^",1)="E")
		
		// 保存结构化手术
		if (useSKDOperation="Y")
		{
			set saveRet=##class(CIS.AN.BL.ExtInterface).SendSKDOperation(OperCatalogueObj.EpisodeID,planOperList.SKDOperID,anaestOperId) 	
			quit:($p(saveRet,"^",1)="E")
		}
		
	}
    ////
	/*
	set opaId=""
	if ($piece(saveResult,"^",1)="S")
	{
		// 调用电子病历接口
		set opaId=$p(saveResult,"^",2)
		set retEMR=##class(EMRservice.BIEMRService).SetOperation(OperCatalogueObj.EpisodeID,opaId)
		
		set:(+retEMR'=1) saveResult="E^写入电子病历表失败" 
	}
	if ($piece(saveResult,"^",1)="S")
	{
		// 调用消息平台接口	
		s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
		set:(+OAret'=0) saveResult="E^发送手术申请失败，原因："_$p(OAret,"^",2)
	}
	if ($piece(saveResult,"^",1)="S")
	{
		// 发送手术申请消息
		set appUserId=""
		set actionUserId=OperCatalogueObj.AppUserID
	    set SendOperMessage=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("SendOperMessage")
		if (SendOperMessage="Y") Set rtnMes =##class(websys.DHCMessageInterface).Send("申请手术", "1053", actionUserId, OperCatalogueObj.EpisodeID ,"","", "opaId为"_opaId ,OperCatalogueObj.OperDeptID)	
	}
	if ($piece(saveResult,"^",1)="S")&(opaId'="")
    {
	    // 写关联电子病历文书
		set linkEMRecords=$get(OperCatalogue("LinkEMRecords"))
		set:(linkEMRecords'="") saveResult=..LinkEMRecords(opaId,linkEMRecords)  
	}
	*/
	
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

ClassMethod AuditOperApp(groupId As %String, sourceType As %String) As %String
{
	set ret="N"
	set NeedAuditOper=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditOper")
	quit:(sourceType'="E")&(NeedAuditOper'="Y") "N"
	set NeedAuditEMOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditEMOperation")
	quit:(sourceType="E")&(NeedAuditEMOperation'="Y") "N"
	&sql(select AuditOperApp into :ret from CF_AN.SSGroup where GroupID=:groupId)
	quit ret
}

ClassMethod SaveORAnaesthesia(data As %String) As %String
{
    set rowId=$get(data("RowId")),EpisodeID=$get(data("ParentRowId"))
    set anaesthesia="",result="",ORAnaestID=""
    if (##class(User.ORAnaesthesia).%ExistsId(rowId))
    {
        set anaesthesiaObj=##class(User.ORAnaesthesia).%OpenId(rowId)  
    }   
    else
    {
        set anaesthesiaObj=##class(User.ORAnaesthesia).%New(EpisodeID) 
    }
    set anaesthesiaObj.ANAPAADMParRef=##class(User.PAAdm).%OpenId(EpisodeID)
	set anaesthesiaObj.ANADate=##class(CIS.AN.COM.DateTime).ConvertToDateH(data("OperDate"),"")
	set anaesthesiaObj.ANASourceType=$case(data("SourceType"),"B":"B","E":"E","D":"B",:"")
	set anaesthesiaObj.ANAMethod=$tr(data("PrevAnaMethod"),",","|")
    set sc=anaesthesiaObj.%Save()
    if ($System.Status.IsError(sc))
    {
        set result="E^"_$System.Status.GetErrorText(sc,"zh-cn") 
    }
    else
    {
        set result="S^"_anaesthesiaObj.%Id()
		set ORAnaestID=anaesthesiaObj.%Id()
		// 保存术前诊断
		set AnaSub=$p(ORAnaestID,"||",2)
		set ^OR(EpisodeID,"ANA",AnaSub,"TXT",2)=data("PrevDiagnosis")
    }
    quit result
}

ClassMethod SaveProcedure(opsId As %String, procedureCode As %String, userId As %String, actionDate As %Date, actionTime As %Time, way As %String = "SI") As %String
{
	set procedureId=""
	&sql(select RowId into :procedureId from CIS_AN.SurgicalProcedure where OperSchedule=:opsId and ProcedureCode=:procedureCode)
	set procedure=""
	if (##class(CIS.AN.SurgicalProcedure).%ExistsId(procedureId))
	{
		set procedure=##class(CIS.AN.SurgicalProcedure).%OpenId(procedureId)	
	}	
	else
	{
		set procedure=##class(CIS.AN.SurgicalProcedure).%New() 	
		set procedure.OperSchedule=##class(CIS.AN.OperCatalogue).%OpenId(opsId)
		set procedure.ProcedureCode=procedureCode
	}
	set procedure.ActionUser=userId
	set procedure.ActionDate=actionDate
	set procedure.ActionTime=actionTime
	set procedure.UpdateDate=+$h
	set procedure.UpdateTime=$p($h,",",2)
	set procedure.ActionWay=way
	set sc=procedure.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"_procedure.%Id()
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

}
