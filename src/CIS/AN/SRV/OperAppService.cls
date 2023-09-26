Class CIS.AN.SRV.OperAppService Extends %RegisteredObject
{

/// 手术申请回写旧表
ClassMethod SendOperAppInfo(opsId As %String, retStr As %String) As %String
{
	// 申请表
	set operSchedule=""
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set ORAnaestID=operSchedule.ExtAnaestID	
	set opaId=operSchedule.ExternalID
	set operArrange=""
	if (##class(User.DHCANOPArrange).%ExistsId(opaId))
	{
		set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
		
	}
	else
	{
		set operArrange=##class(User.DHCANOPArrange).%New()	
	}
	set operArrange.OPAAdmDr=operSchedule.EpisodeID
	set operArrange.OPAAnaestDr=ORAnaestID
	set operArrange.OPAAppLocDr=operSchedule.AppDeptID
	set operArrange.OPAAppDate=operSchedule.AppDate
	set operArrange.OPAAppTime=operSchedule.AppTime
	set operArrange.OPAAppCtcpDr=operSchedule.AppCareProvID
	set operArrange.OPABloodTypeDr=operSchedule.BloodType
	set operArrange.OPAIsolated=operSchedule.IsoOperation
	set operArrange.OPAStartDate=operSchedule.OperDate
	set operArrange.OPAStartTime=operSchedule.OperTime
	set needAudit=##class(CIS.AN.BL.DataConfiguration).GetValueByKey(##class(CIS.AN.BL.Constant).#NeedAuditOperation)
	set:(needAudit'="Y")!(operSchedule.SourceType="E")!(operSchedule.Status.Code="Audit") operArrange.OPAStatus="A"		// 无需审核或急诊手术
	set:(operSchedule.Status.Code="DaySurgery") operArrange.OPAStatus="S"	// 日间手术判断
	set:(operSchedule.OPAdmType="OOP") operArrange.OPAStatus="A"			// 门诊手术无需审核
	set operArrange.OPAWardDr=operSchedule.PatWardID
	set operArrange.OPAPatDeptDr=operSchedule.PatDeptID
	set operArrange.OPANeedAnaesthetist=operSchedule.Anaesthesia
	set operArrange.OPAUseSelfBlood=operSchedule.TransAutoblood
	set operArrange.OPAEstiOperDuration=operSchedule.OperDuration
	set operArrange.OPAIsolated=operSchedule.IsoOperation
	set operArrange.OPAExCirculation=operSchedule.ECC
	set operArrange.OPAPrepareBlood=operSchedule.PrepareBlood
	set operArrange.OPAMemo=operSchedule.OperRequirement
	set operArrange.OPAUnPlanedOperation=operSchedule.ReentryOperation
	set operArrange.OPACollectedStatus="N"
	
	///2021-01-29  ygb 手术申请检查检验结果
	set operArrange.OPAPATestHBsAg=$Case(operSchedule.HbsAg,"N":"未知","-":"阴性","+":"阳性","UR":"已查未归","":"")
	set operArrange.OPAPATestHCVAb=$Case(operSchedule.HcvAb,"N":"未知","-":"阴性","+":"阳性","UR":"已查未归","":"")
	set operArrange.OPAPATestHivAb=$Case(operSchedule.HivAb,"N":"未知","-":"阴性","+":"阳性","UR":"已查未归","":"")
	set operArrange.OPAPATestTPAb=$Case(operSchedule.Syphilis,"N":"未知","-":"阴性","+":"阳性","UR":"已查未归","":"")
	
	set sc=operArrange.%Save()	
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	set operSchedule.ExternalID=operArrange.%Id()
	set sc=operSchedule.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	
	set:(operSchedule.OPAdmType="OOP") ^DHCANOPArrange("OUTOP",operSchedule.ExternalID)="O"		// 旧表门诊手术标志
	
	
	// 麻醉表
	set anaesthesia=##class(User.ORAnaesthesia).%OpenId(ORAnaestID)
	set anaesthesia.ANADate=operSchedule.OperDate
	//set anaesthesia.ANAMethod=$tr(operSchedule.PrevAnaMethod,",","|")
	
	set anaesthesia.ANASourceType=$case(operSchedule.SourceType,"B":"B","E":"E","D":"B",:"")
	set sc=anaesthesia.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)	
	set EpisodeID=$p(ORAnaestID,"||",1),AnaSub=$p(ORAnaestID,"||",2)
	// 保存麻醉方法
	set $p(^OR(EpisodeID,"ANA",AnaSub),"^",5)=$tr(operSchedule.PrevAnaMethod,",","|")
	// 保存术前诊断
	set ^OR(EpisodeID,"ANA",AnaSub,"TXT",2)=operSchedule.PrevDiagnosis
	
	
	// 手术表
	// 删除结构化手术
	set useSKDOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("UseSKDOperation")
	if (useSKDOperation="Y")
	{
		set saveRet=..RemoveSKDOperation(ORAnaestID)
		quit:($p(saveRet,"^",1)="E") saveRet
	}
	// 删除旧手术表相关数据（修改手术有可能删除某条手术）0-表示删除成功，100-表示无需要删除的数据
	&sql(delete from SQLUser.OR_Anaest_Operation where ANAOP_Par_Ref=:ORAnaestID)
	s admId=$p(ORAnaestID,"||",1)
	s anId=$p(ORAnaestID,"||",2)
	s ^OR(admId,"ANA",anId,"OP",0)=0
	set:(SQLCODE'=0)&(SQLCODE'=100) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
	quit:(SQLCODE'=0)&(SQLCODE'=100) saveRet
	
	
	// 重新写入手术数据
	set planOperListId="",saveRet="S^",count=0
	for
	{
		set planOperListId=$o(^CIS.AN.PlanOperListI("IOPS",opsId,planOperListId))
		quit:(planOperListId="")
		set count=count+1
		set planOperList=##class(CIS.AN.PlanOperList).%OpenId(planOperListId)
		set operationId=planOperList.Operation
		set operNote=planOperList.OperNote
		set surgeon=planOperList.Surgeon
		set bladeType=planOperList.BladeType
		set bodySite=planOperList.BodySite
		set operDept=operSchedule.OperDeptID
		set operDate=operSchedule.OperDate
		set daySurgery=operSchedule.DaySurgery
		set operType="M"
		set:(count>1) operType="S"
		&sql(insert into SQLUser.OR_Anaest_Operation 
			(ANAOP_Type_DR,ANAOP_Surgeon_DR,ANAOP_Blade_DR,ANAOP_CTLOC_DR,ANAOP_OpStartDate,ANAOP_DaySurgery,ANAOP_BodySite_DR,ANAOP_Par_Ref,ANAOP_OperType)
			values (:operationId,:surgeon,:bladeType,:operDept,:operDate,:daySurgery,:bodySite,:ORAnaestID,:operType))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
		
		
		set anaestOperId=%ROWID
		
		set OperSub=$p(anaestOperId,"||",3)
		set ^OR(EpisodeID,"ANA",AnaSub,"OP",OperSub,"REM",1)=planOperList.OperNote				// 手术备注
		set $p(^OR(EpisodeID,"ANA",AnaSub,"OP",OperSub,"DHC"),"^",1)=planOperList.OperClass		// 手术级别
		set $p(^OR(EpisodeID,"ANA",AnaSub,"OP",OperSub,"DHC"),"^",7)=planOperList.SurgeonDeptID	// 术者科室
		set operPositionId=planOperList.OperPos
		if (operPositionId'="") set operPositionId=$tr(operPositionId,",","|")
    	set ^OR(EpisodeID,"ANA",AnaSub,"OP",OperSub,"POS",1)=operPositionId      		    	// 手术体位

		set planOperList.ExternalID=anaestOperId
		set operation=planOperList.Operation
		set sc=planOperList.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		
		&sql(update CIS_AN.OperList set ExternalID=:anaestOperId where OperSchedule=:opsId and Operation=:operation)
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
			set saveRet=..SendSKDOperation(operSchedule.EpisodeID,planOperList.SKDOperID,anaestOperId) 	
			quit:($p(saveRet,"^",1)="E")
		}
		
	}
	
	
	quit:($p(saveRet,"^",1)="E") saveRet
	quit "S^"_operArrange.%Id()
}

/// 手术排班回写旧表
ClassMethod SendOperArrange(opsId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set:("RILPF" '[ operArrange.OPAStatus) operArrange.OPAStatus="R"
	set oldRoomId=operSchedule.OperRoom.ExternalID
	set operArrange.OPAOpRoomDr=##class(User.DHCANCOperRoom).%OpenId(oldRoomId)
	set operArrange.OPASeq=operSchedule.OperSeq
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	
	set saveRet="S^"
	// 保存器械护士，关联到主手术
	set anaestOperId=""
	&sql(select top 1 %ID into :anaestOperId from SQLUser.OR_Anaest_Operation where ANAOP_Par_Ref=:operSchedule.ExtAnaestID)
	quit:(##class(User.ORAnaestOperation).%ExistsId(anaestOperId)=0) "E^主手术不存在！"
	&sql(delete from SQLUser.OR_An_Oper_Scrub_Nurse where OPSCN_ParRef=:anaestOperId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)
	set assisCount=$l(operSchedule.ScrubNurse,",")
	for i=1:1:assisCount
	{
		set assisId=$p(operSchedule.ScrubNurse,",",i)
		continue:(##class(User.CTCareProv).%ExistsId(assisId)=0)
		&sql(insert into SQLUser.OR_An_Oper_Scrub_Nurse (OPSCN_ParRef,OPSCN_Scrub_Nurse_DR)
			  values (:anaestOperId,:assisId))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
	}
	quit:($p(saveRet,"^",1)="E") saveRet
	
	// 保存巡回护士，关联到主手术
	&sql(delete from SQLUser.OR_An_Oper_Circul_Nurse where CIRN_ParRef=:anaestOperId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)
	set assisCount=$l(operSchedule.CircualNurse,",")
	for i=1:1:assisCount
	{
		set assisId=$p(operSchedule.CircualNurse,",",i)
		continue:(##class(User.CTCareProv).%ExistsId(assisId)=0)
		&sql(insert into SQLUser.OR_An_Oper_Circul_Nurse (CIRN_ParRef,CIRN_CTCP_DR)
			  values (:anaestOperId,:assisId))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
	}
	
	quit saveRet
}

/// 麻醉排班回写旧表
ClassMethod SendAnaArrange(opsId As %String) As %String
{
	set saveRet="S^"
	set anaestId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)	
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaestId)
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	// 保存麻醉方法、麻醉医生、麻醉指导
	set ORAnaesthesia=##class(User.ORAnaesthesia).%OpenId(operSchedule.ExtAnaestID)
	//set ORAnaesthesia.ANAMethod=$tr(anaesthesia.AnaMethod,",","|")
	set EpisodeID=$p(operSchedule.ExtAnaestID,"||",1),AnaSub=$p(operSchedule.ExtAnaestID,"||",2)
	// 保存麻醉方法
	set $p(^OR(EpisodeID,"ANA",AnaSub),"^",5)=$tr(anaesthesia.AnaMethod,",","|")
	if (anaesthesia.AnaExpert'="")
	{
		set anaExpert=##class(User.CTCareProv).%OpenId(anaesthesia.AnaExpert)
		set ORAnaesthesia.ANASupervisorDR=anaExpert	
	}
	if (anaesthesia.Anesthesiologist'="")
	{
		set anaDoc=##class(User.CTCareProv).%OpenId(anaesthesia.Anesthesiologist)
		set ORAnaesthesia.ANAAnaesthetistDR=anaDoc
	}
	set sc=ORAnaesthesia.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	
	// 保存麻醉助手，关联到主手术
	set anaestOperId=""
	&sql(select top 1 %ID into :anaestOperId from SQLUser.OR_Anaest_Operation where ANAOP_Par_Ref=:operSchedule.ExtAnaestID)
	&sql(delete from SQLUser.OR_An_Oper_Anaest_Assistant where ANASS_ParRef=:anaestOperId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)
	set assisCount=$l(anaesthesia.AnaAssistant,",")
	for i=1:1:assisCount
	{
		set assisId=$p(anaesthesia.AnaAssistant,",",i)
		continue:(##class(User.CTCareProv).%ExistsId(assisId)=0)
		&sql(insert into SQLUser.OR_An_Oper_Anaest_Assistant (ANASS_ParRef,ANASS_CTCP_DR)
			  values (:anaestOperId,:assisId))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
	}
	
	quit saveRet
}

/// 回写手术登记信息
ClassMethod SendOperRegister(opsId As %String, operStatus As %String = "") As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set ExtAnaestID=operSchedule.ExtAnaestID
	set anaestId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaestId)
	set saveRet=..SendOperSchedule(opsId,operStatus)
	quit:($p(saveRet,"^",1)="E") saveRet
	set saveRet=..SendAnaesthesia(opsId)
	quit:($p(saveRet,"^",1)="E") saveRet
	
	&sql(declare operListCursor cursor for select %ID into :RowId from CIS_AN.OperList where OperSchedule=:opsId)
	&sql(open operListCursor)
	for
	{
		&sql(fetch operListCursor)
		quit:(SQLCODE'=0)
		set operList=##class(CIS.AN.OperList).%OpenId(RowId)
		b ;321
		set saveRet=..SendAnaestOperation(ExtAnaestID,RowId)
		quit:($p(saveRet,"^",1)="E")
		set saveRet=..SendOperAssistant(operList.ExternalID,operList.Assistant)	
		quit:($p(saveRet,"^",1)="E")
	}
	&sql(close operListCursor)
	quit:($p(saveRet,"^",1)="E") saveRet
	
	set saveRet=..SendAnaAssistant(ExtAnaestID,anaesthesia.AnaAssistant)
	quit:($p(saveRet,"^",1)="E") saveRet
	set saveRet=..SendScrubNurse(ExtAnaestID,operSchedule.ScrubNurse)
	quit:($p(saveRet,"^",1)="E") saveRet
	set saveRet=..SendCircualNurse(ExtAnaestID,operSchedule.CircualNurse)
	quit:($p(saveRet,"^",1)="E") saveRet
	quit saveRet
}

/// 保存手术申请排班信息
ClassMethod SendOperSchedule(opsId As %String, operStatus As %String = "") As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set opaId=operSchedule.ExternalID
	set anaestId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaestId)
	
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStartDate=operSchedule.OperDate
	set operArrange.OPAStartTime=operSchedule.OperTime
	set:(operStatus'="") operArrange.OPAStatus=operStatus
	set:(operSchedule.OperRoom'="") operArrange.OPAOpRoomDr=##class(User.DHCANCOperRoom).%OpenId(operSchedule.OperRoom.ExternalID)
	set operArrange.OPASeq=operSchedule.OperSeq
	set operArrange.OPAEndDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(anaesthesia.OperFinishDT," ",1),"")
	set operArrange.OPAEndTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(anaesthesia.OperFinishDT," ",2),"")
	set sc=operArrange.%Save()		
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 保存麻醉信息
ClassMethod SendAnaesthesia(opsId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set anaestId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaestId)
	set ORAnaesthesia=##class(User.ORAnaesthesia).%OpenId(operSchedule.ExtAnaestID)
	if (anaesthesia.AnaStartDT'="")
	{
		set ORAnaesthesia.ANADate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(anaesthesia.AnaStartDT," ",1),"")
		set ORAnaesthesia.ANAAnaStartTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(anaesthesia.AnaStartDT," ",2),"")
	}
	if (anaesthesia.TheatreInDT'="")
	{
		set ORAnaesthesia.ANATheatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(anaesthesia.TheatreInDT," ",1),"")
		set ORAnaesthesia.ANATheatreInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(anaesthesia.TheatreInDT," ",2),"")
	}
	if (anaesthesia.TheatreOutDT'="")
	{
		set ORAnaesthesia.ANATheatreOutDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(anaesthesia.TheatreOutDT," ",1),"")
		set ORAnaesthesia.ANATheatreOutTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(anaesthesia.TheatreOutDT," ",2),"")
	}
	if (anaesthesia.AnaFinishDT'="")
	{
		set ORAnaesthesia.ANAFinishDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(anaesthesia.AnaFinishDT," ",1),"")
		set ORAnaesthesia.ANAAnaFinishTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(anaesthesia.AnaFinishDT," ",2),"")	
	}
	if (anaesthesia.PACUInDT'="")
	{
		set ORAnaesthesia.ANAPACUStartDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(anaesthesia.PACUInDT," ",1),"")
		set ORAnaesthesia.ANAPACUStartTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(anaesthesia.PACUInDT," ",2),"")
	}
	if (anaesthesia.PACUOutDT'="")
	{
		set ORAnaesthesia.ANAPACUFinishDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(anaesthesia.PACUOutDT," ",1),"")
		set ORAnaesthesia.ANAPACUFinishTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(anaesthesia.PACUOutDT," ",2),"")	
	}
	if (anaesthesia.OperStartDT'="")
	{
		set ORAnaesthesia.ANASurgStartTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(anaesthesia.OperStartDT," ",2),"")
	}
	if (anaesthesia.OperFinishDT'="")
	{
		set ORAnaesthesia.ANASurgFinishTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(anaesthesia.OperFinishDT," ",2),"")
	}

	set ORAnaesthesia.ANASourceType=$case(operSchedule.SourceType,"B":"B","E":"E","D":"B",:"")
	//set ORAnaesthesia.ANAMethod=$tr(anaesthesia.AnaMethod,",","|") 
	set EpisodeID=$p(operSchedule.ExtAnaestID,"||",1),AnaSub=$p(operSchedule.ExtAnaestID,"||",2)
	// 保存麻醉方法
	set $p(^OR(EpisodeID,"ANA",AnaSub),"^",5)=$tr(anaesthesia.AnaMethod,",","|")
	
	if (anaesthesia.AnaExpert'="")
	{
		set anaExpert=##class(User.CTCareProv).%OpenId(anaesthesia.AnaExpert)
		set ORAnaesthesia.ANASupervisorDR=anaExpert	
	}
	if (anaesthesia.Anesthesiologist'="")
	{
		set anaDoc=##class(User.CTCareProv).%OpenId(anaesthesia.Anesthesiologist)
		set ORAnaesthesia.ANAAnaesthetistDR=anaDoc
	}
	set sc=ORAnaesthesia.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	set EpisodeID=$p(operSchedule.ExtAnaestID,"||",1),AnaSub=$p(operSchedule.ExtAnaestID,"||",2)
	set ^OR(EpisodeID,"ANA",AnaSub,"TXT",2)=operSchedule.PrevDiagnosis		// 保存术前诊断
	quit "S^"
}

/// 保存手术信息
/// w ##class(CIS.AN.SRV.OperAppService).SendAnaestOperation("5||1",13)
ClassMethod SendAnaestOperation(ExtAnaestID As %String, operListId As %String) As %String
{
	set saveRet="S^"
	set operList=##class(CIS.AN.OperList).%OpenId(operListId)
	set operSchedule=operList.OperSchedule.%Id()
	set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(operSchedule)
	set operationId=operList.Operation
	set operNote=operList.OperNote
	set surgeon=operList.Surgeon
	set bladeType=operList.BladeType
	set bodySite=operList.BodySite
	set surgeonDept=operList.SurgeonDeptID	;术者科室id
	set operDept=operScheduleObj.OperDeptID	;手术室Id
	set operDate=operScheduleObj.OperDate
	set daySurgery=operScheduleObj.DaySurgery
	set anaestOperId=operList.ExternalID
	b ;3
	if (##class(User.ORAnaestOperation).%ExistsId(anaestOperId))
	{
		&sql(update SQLUser.OR_Anaest_Operation set 
					ANAOP_Type_DR=:operationId,
					ANAOP_Surgeon_DR=:surgeon,
					ANAOP_Blade_DR=:bladeType,
					ANAOP_CTLOC_DR=:operDept,
					ANAOP_OpStartDate=:operDate,
					ANAOP_DaySurgery=:daySurgery,
					ANAOP_BodySite_DR=:bodySite
					where %ID=:anaestOperId)
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
	}
	else
	{
		b //xx
		&sql(insert into SQLUser.OR_Anaest_Operation 
			(ANAOP_Type_DR,ANAOP_Surgeon_DR,ANAOP_Blade_DR,ANAOP_CTLOC_DR,ANAOP_OpStartDate,ANAOP_BodySite_DR,ANAOP_Par_Ref,ANAOP_DaySurgery)
			values (:operationId,:surgeon,:bladeType,:operDept,:operDate,:bodySite,:ExtAnaestID,:daySurgery))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0) saveRet
		set anaestOperId=%ROWID
		set operList.ExternalID=%ROWID
		set sc=operList.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		// 保存结构化手术
		set useSKDOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("UseSKDOperation")
		if (useSKDOperation="Y")&(operList.SKDOperID'="")
		{
			set saveRet=..SendSKDOperation(operSchedule.EpisodeID,operList.SKDOperID,anaestOperId) 	
		}
	}
	set EpisodeID=$p(ExtAnaestID,"||",1),AnaSub=$p(ExtAnaestID,"||",2),OperSub=$p(anaestOperId,"||",3)
	set ^OR(EpisodeID,"ANA",AnaSub,"OP",OperSub,"REM",1)=operList.OperNote		// 保存手术备注
	set:($isobject(operList.OperClass)) $p(^OR(EpisodeID,"ANA",AnaSub,"OP",OperSub,"DHC"),"^",1)=operList.OperClass.ExternalID		// 保存手术级别
	quit saveRet
}

/// 保存手术助手
ClassMethod SendOperAssistant(anaestOperId As %String, assisStr As %String) As %String
{
	quit:(##class(User.ORAnaestOperation).%ExistsId(anaestOperId)=0) "E^主手术不存在！"
	&sql(delete from SQLUser.OR_An_Oper_Assistant where OPAS_ParRef=:anaestOperId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)
	set assisCount=$l(assisStr,","),saveRet="S^"
	for i=1:1:assisCount
	{
		set assisId=$p(assisStr,",",i)
		quit:(##class(User.CTCareProv).%ExistsId(assisId)=0)
		&sql(insert into SQLUser.OR_An_Oper_Assistant (OPAS_ParRef,OPAS_Assist_DR)
			  values (:anaestOperId,:assisId))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
	}
	quit saveRet
}

/// 保存麻醉助手，关联到主手术
ClassMethod SendAnaAssistant(ExtAnaestID As %String, assisStr As %String) As %String
{
	set anaestOperId="",saveRet="S^"
	&sql(select top 1 %ID into :anaestOperId from SQLUser.OR_Anaest_Operation where ANAOP_Par_Ref=:ExtAnaestID)
	&sql(delete from SQLUser.OR_An_Oper_Anaest_Assistant where ANASS_ParRef=:anaestOperId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)
	set assisCount=$l(assisStr,",")
	for i=1:1:assisCount
	{
		set assisId=$p(assisStr,",",i)
		quit:(##class(User.CTCareProv).%ExistsId(assisId)=0)
		&sql(insert into SQLUser.OR_An_Oper_Anaest_Assistant (ANASS_ParRef,ANASS_CTCP_DR)
			  values (:anaestOperId,:assisId))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
	}	
	quit saveRet
}

/// 保存器械护士，关联到主手术
ClassMethod SendScrubNurse(ExtAnaestID As %String, scrubNurse As %String) As %String
{
	set anaestOperId="",saveRet="S^"
	&sql(select top 1 %ID into :anaestOperId from SQLUser.OR_Anaest_Operation where ANAOP_Par_Ref=:ExtAnaestID)
	quit:(##class(User.ORAnaestOperation).%ExistsId(anaestOperId)=0) "E^主手术不存在！"
	&sql(delete from SQLUser.OR_An_Oper_Scrub_Nurse where OPSCN_ParRef=:anaestOperId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)
	set assisCount=$l(scrubNurse,",")
	for i=1:1:assisCount
	{
		set assisId=$p(scrubNurse,",",i)
		continue:(##class(User.CTCareProv).%ExistsId(assisId)=0)
		&sql(insert into SQLUser.OR_An_Oper_Scrub_Nurse (OPSCN_ParRef,OPSCN_Scrub_Nurse_DR)
			  values (:anaestOperId,:assisId))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
	}
	quit saveRet
}

/// 保存巡回护士，关联到主手术
ClassMethod SendCircualNurse(ExtAnaestID As %String, circualNurse As %String) As %String
{
	set anaestOperId="",saveRet="S^"
	&sql(select top 1 %ID into :anaestOperId from SQLUser.OR_Anaest_Operation where ANAOP_Par_Ref=:ExtAnaestID)
	&sql(delete from SQLUser.OR_An_Oper_Circul_Nurse where CIRN_ParRef=:anaestOperId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)
	set assisCount=$l(circualNurse,",")
	for i=1:1:assisCount
	{
		set assisId=$p(circualNurse,",",i)
		continue:(##class(User.CTCareProv).%ExistsId(assisId)=0)
		&sql(insert into SQLUser.OR_An_Oper_Circul_Nurse (CIRN_ParRef,CIRN_CTCP_DR)
			  values (:anaestOperId,:assisId))
		set:(SQLCODE'=0) saveRet="E^"_$System.SQL.SQLCODE(SQLCODE)
		quit:(SQLCODE'=0)
	}
	
	quit saveRet
}

/// 撤回排班回写旧表
ClassMethod RevokeArrange(opsId As %String, statusCode As %String = "R") As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:opaId="" "S^未同步至旧表数据！"
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus=statusCode
	set operArrange.OPAOpRoomDr=""
	set operArrange.OPASeq=""
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	
	// 删除巡回护士
	set anaestOperId="",ExtAnaestID=operSchedule.ExtAnaestID
	&sql(select top 1 %ID into :anaestOperId from SQLUser.OR_Anaest_Operation where ANAOP_Par_Ref=:ExtAnaestID)
	&sql(delete from SQLUser.OR_An_Oper_Circul_Nurse where CIRN_ParRef=:anaestOperId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)
	
	// 删除器械护士
	&sql(delete from SQLUser.OR_An_Oper_Scrub_Nurse where OPSCN_ParRef=:anaestOperId)
	quit:(SQLCODE'=0)&(SQLCODE'=100) "E^"_$System.SQL.SQLCODE(SQLCODE)
	
	quit "S^"
}

/// 审核手术申请回写旧表
ClassMethod AuditApplication(opsId As %String, auditUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="V"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 取消审核手术
ClassMethod CancelAudit(opsId As %String, auditUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus=""
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 取消手术申请回写旧表
ClassMethod CancelApplication(opsId As %String, cancelUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="C"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 拒绝手术申请回写旧表
ClassMethod DeclineApplication(opsId As %String, cancelUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="D"
	set operArrange.OPAOpRoomDr=""
	set operArrange.OPASeq=""
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 取消拒绝手术申请回写旧表
ClassMethod CancelDecline(opsId As %String, cancelUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set NeedAuditOperation=##class(CIS.AN.BL.OperApplication).NeedAuditOperation(opsId)
	set:(operSchedule.Status.Code="Application")&(NeedAuditOperation="Y") operArrange.OPAStatus=""
	set:(operSchedule.Status.Code="Application")&(NeedAuditOperation'="Y") operArrange.OPAStatus="A"
	set:(operSchedule.Status.Code="Audit") operArrange.OPAStatus="A"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 旧版取消手术申请回写新表
ClassMethod CancelApplicationNew(opsId As %String, reason As %String, cancelUserId As %String) As %String
{
	set $zt="Error"
	tstart
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set cancelStatusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Cancel")	
	set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(cancelStatusID)
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

/// 停止手术申请回写旧表
ClassMethod StopOperation(opsId As %String, stopUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="D"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 完成手术申请回写旧表
ClassMethod FinishOperation(opsId As %String, finishUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="F"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 麻醉记录开始监护回写旧表
ClassMethod StartANRecord(opsId As %String, startUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="I"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 麻醉记录结束监护回写旧表
ClassMethod StopANRecord(opsId As %String, startUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operStatusCode=operSchedule.Status.Code
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="L"
	set:(operStatusCode="Finish") operArrange.OPAStatus="F"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 麻醉恢复记录开始监护回写旧表
ClassMethod StartPACURecord(opsId As %String, startUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="P"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 麻醉恢复记录结束监护回写旧表
ClassMethod StopPACURecord(opsId As %String, startUser As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operStatusCode=operSchedule.Status.Code
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="F"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 手术费用审核回写旧表
ClassMethod AuditOPFee(opsId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAOpNurseOrdered="Y"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 麻醉费用审核回写旧表
ClassMethod AuditANFee(opsId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAAnaDoctorOrdered="Y"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// 导入手术申请
/// w ##class(CIS.AN.SRV.OperAppService).ImportOperApplication("220")
ClassMethod ImportOperApplication(opaId As %String) As %String
{
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set opsId=##class(CIS.AN.SRV.OperService).GetOpsIdByExt(opaId)
	set operSchedule=""
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId)){
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	}
	Else {
		set operSchedule=##class(CIS.AN.OperSchedule).%New()
	}
	set operSchedule.EpisodeID=operArrange.OPAAdmDr
	set operSchedule.ExtAnaestID=operArrange.OPAAnaestDr
	set operSchedule.AppDeptID=operArrange.OPAAppLocDr
	set operSchedule.AppDate=operArrange.OPAAppDate
	set operSchedule.AppTime=operArrange.OPAAppTime
	set operSchedule.AppCareProvID=operArrange.OPAAppCtcpDr
	set appUserId="",careProvId=operSchedule.AppCareProvID
	&sql(select %ID into :appUserId from SQLUser.SS_User where SSUSR_CareProv_DR=:careProvId)
	set operSchedule.AppUserID=appUserId
	set operSchedule.BloodType=##class(CIS.AN.COM.String).GetRowIdByExt("PAC_BloodType",operArrange.OPABloodTypeDr)
	set operSchedule.IsoOperation=operArrange.OPAIsolated
	set operSchedule.OperDate=operArrange.OPAStartDate
	set operSchedule.OperTime=operArrange.OPAStartTime
	
	set appStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Application")
	set auditStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Audit")
	set arrangeId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
	set roomInId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("RoomIn")
	set roomOutId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("RoomOut")
	set PACUInId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("PACUIn")
	set finishId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Finish")
	set declineId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Decline")
	set cancelId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Cancel")
	set:(operArrange.OPAStatus="") operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(appStatusId)
	set:(operArrange.OPAStatus="A") operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(appStatusId)
	set DSStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("DaySurgery")	// 日间手术状态
	set:(operArrange.OPAStatus="S") operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(DSStatusId)
	set:(operArrange.OPAStatus="R") operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(arrangeId)
	set:(operArrange.OPAStatus="I") operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(roomInId)
	set:(operArrange.OPAStatus="L") operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(roomOutId)
	set:(operArrange.OPAStatus="P") operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(PACUInId)
	set:(operArrange.OPAStatus="F") operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(finishId)
	set:(operArrange.OPAStatus="D") operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(declineId)
	set:(operArrange.OPAStatus="C") operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(cancelId)
	
	set operSchedule.PatWardID=operArrange.OPAWardDr
	set operSchedule.PatDeptID=operArrange.OPAPatDeptDr
	set operSchedule.Anaesthesia=operArrange.OPANeedAnaesthetist
	// set operSchedule.TransAutoBlood=operArrange.OPAUseSelfBlood 新表没有该字段
	set operSchedule.OperDuration=operArrange.OPAEstiOperDuration
	set operSchedule.IsoOperation=operArrange.OPAIsolated
	set operSchedule.ECC=operArrange.OPAExCirculation
	set operSchedule.PrepareBlood=operArrange.OPAPrepareBlood
	set operSchedule.OperRequirement=operArrange.OPAMemo
	set operSchedule.ReentryOperation=operArrange.OPAUnPlanedOperation
	set operSchedule.ExternalID=opaId
	
	set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",operSchedule.EpisodeID)
	set operSchedule.PatName=patInfoObj.GetValue("PatName")
	set operSchedule.PatGender=patInfoObj.GetValue("PatGender")
	set operSchedule.PatDOB=patInfoObj.GetValue("PatDOBH")
	set operSchedule.RegNo=patInfoObj.GetValue("RegNo")
	set operSchedule.MedicareNo=patInfoObj.GetValue("MedcareNo")
	set operSchedule.AdmReason=patInfoObj.GetValue("AdmReason")
	set operSchedule.AdmDate=patInfoObj.GetValue("AdmDateH")
	
	set OPAdmType=$g(^DHCANOPArrange("OUTOP",opaId))
	set operSchedule.OPAdmType=$case(OPAdmType,"O":"OOP","I":"IOP",:"IOP")

	set ORAnaesthesia=##class(User.ORAnaesthesia).%OpenId(operArrange.OPAAnaestDr)
	set operSchedule.SourceType=ORAnaesthesia.ANASourceType
	set ORAnaSub=$p(operArrange.OPAAnaestDr,"||",2)
	set prevAnaMethod=$p($g(^OR(operArrange.OPAAdmDr,"ANA",ORAnaSub)),"^",5)
	b ////
	set operSchedule.PrevAnaMethod=$tr(prevAnaMethod,"|",",") // ##class(CIS.AN.COM.String).GetRowIdStrByExt(prevAnaMethod) ??????是否需要处理
	set operSchedule.PrevDiagnosis=$g(^OR(operArrange.OPAAdmDr,"ANA",ORAnaSub,"TXT",2))
	set sc=operSchedule.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	set opsId=operSchedule.%Id()
	
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	if (##class(CIS.AN.Anaesthesia).%ExistsId(anaId))
	{
		set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)	
	}
	else
	{
		set anaesthesia=##class(CIS.AN.Anaesthesia).%New()	
	}
	set anaesthesia.OperSchedule=operSchedule
	//set anaesthesia.AnaMethod=operSchedule.PrevAnaMethod
	set sc=anaesthesia.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	set saveRet=##class(CIS.AN.BL.AnaArrange).UpdateAnaMethod(opsId,operSchedule.PrevAnaMethod)
	quit:($p(saveRet,"^",1)'="S") saveRet
	
	// 删除拟施手术表
	&sql(delete from CIS_AN.PlanOperList where OperSchedule=:opsId)
	&sql(delete from CIS_AN.OperList where OperSchedule=:opsId)
	set OROPSub=0,EpisodeID=operArrange.OPAAdmDr,operDeptId="",saveRet="S^",daySurgery=""
	for
	{
		set OROPSub=$o(^OR(EpisodeID,"ANA",ORAnaSub,"OP",OROPSub))
		quit:(OROPSub="")
		set ORAnaOperation=##class(User.ORAnaestOperation).%OpenId(EpisodeID_"||"_ORAnaSub_"||"_OROPSub)
		set planOperList=##class(CIS.AN.PlanOperList).%New()
		set operList=##class(CIS.AN.OperList).%New()
		set operId=""

		set:($isobject(ORAnaOperation.ANAOPTypeDR)) operId=ORAnaOperation.ANAOPTypeDR.%Id()
		set:(operId="") operId=$g(^OR(EpisodeID,"ANA",ORAnaSub,"OP",OROPSub,"REM"))
		//set operation=##class(CT.AN.Operation).%OpenId(operId)
		set planOperList.Operation=operId,operList.Operation=operId
		set planOperList.OperSchedule=operSchedule,operList.OperSchedule=operSchedule
		set planOperList.ExternalID=ORAnaOperation.%Id(),operList.ExternalID=ORAnaOperation.%Id()
		set planOperList.OperNote=^OR(EpisodeID,"ANA",ORAnaSub,"OP",OROPSub,"REM"),operList.OperNote=planOperList.OperNote
		
		set OROperClassId=$p(^OR(EpisodeID,"ANA",ORAnaSub,"OP",OROPSub,"DHC"),"^",1)
		set planOperList.OperClass=OROperClassId,operList.OperClass=OROperClassId
		
		set bodySiteId=""
		set:($isobject(ORAnaOperation.ANAOPBodySiteDR)) bodySiteId=ORAnaOperation.ANAOPBodySiteDR.%Id()
		set planOperList.BodySite=bodySiteId,operList.BodySite=bodySiteId
		
		set bladeTypeId=""
		set:($isobject(ORAnaOperation.ANAOPBladeDR)) bladeTypeId=ORAnaOperation.ANAOPBladeDR.%Id()
		set planOperList.BladeType=bladeTypeId,operList.BladeType=bladeTypeId
		
		set surgeonId=""
		set:($isobject(ORAnaOperation.ANAOPSurgeonDR)) surgeonId=ORAnaOperation.ANAOPSurgeonDR.%Id()
		set planOperList.Surgeon=surgeonId,operList.Surgeon=surgeonId
		
		set ORSurgeonDeptId=$p(^OR(EpisodeID,"ANA",ORAnaSub,"OP",OROPSub,"DHC"),"^",7)
		set surgeonDept=ORSurgeonDeptId
		set planOperList.SurgeonDeptID=surgeonDept,operList.SurgeonDeptID=surgeonDept
		
		set:($isobject(ORAnaOperation.ANAOPCTLOCDR)) operDeptId=ORAnaOperation.ANAOPCTLOCDR.%Id()
		
		set AssSub=0,AssList=""
		for
		{
			set AssSub=$o(^OR(EpisodeID,"ANA",ORAnaSub,"OP",AssSub))
			quit:(AssSub="")
			set AssList=AssList_$lb($p(^OR(EpisodeID,"ANA",ORAnaSub,"OP",AssSub),"^",1))	
		}
		set planOperList.Assistant=$lts(AssList,","),operList.Assistant=planOperList.Assistant
		set sc=planOperList.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		
		set sc=operList.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		
		set daySurgery=ORAnaOperation.ANAOPDaySurgery
	}
	quit:($p(saveRet,"^")'="S") saveRet
	set operSchedule.OperDeptID=operDeptId
	set:(daySurgery'="") operSchedule.DaySurgery=daySurgery
	set sc=operSchedule.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	
	b // 写手术操作过程
    set actionUserId=operSchedule.AppUserID
    set procedureCode="",operStatus=operSchedule.Status.Code
    set procedureCode=$CASE(operStatus,"Application":"APP","Audit":"ADT","Arrange":"OPA","RoomIn":"RI","RoomOut":"RO","PACUIn":"PI","Finish":"FNH","Cancel":"CCL","AreaIn":"AI",:"")
    set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(operSchedule.%Id(),procedureCode,actionUserId,+$h,$p($h,",",2)) 
    quit:($p(saveRet,"^")'="S") saveRet
	
	quit "S^"
}

/// 调用接口将手术业务表RowId写入结构化手术
ClassMethod SendSKDOperation(EpisodeID As %String, SKDOperID As %String, OROperID As %String) As %String
{
	s ret=##class(web.DHCBL.MKB.SDSOperationInterface).SaveStructOperation(EpisodeID, SKDOperID, OROperID)
	s flag=$p(ret,"^",1),msg=$p(ret,"^",2)
	s ret=$case(flag,"true":"S","false":"E")_"^"_msg
	q ret
}

/// 调用接口将手术业务表RowId从结构化手术清除
ClassMethod RemoveSKDOperation(ORAnaID As %String) As %String
{
	set EpisodeID=$p(ORAnaID,"||",1),anaSub=$p(ORAnaID,"||",2),operSub=0,saveRet="S^"
	for
	{
		set operSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",operSub))
		quit:(operSub="")
		s ret=##class(web.DHCBL.MKB.SDSOperationInterface).DeleteStructOperation(OROperID)
		s flag=$p(ret,"^",1),msg=$p(ret,"^",2)
		s:(flag="false") saveRet=$case(flag,"true":"S","false":"E")_"^"_msg
		quit:(flag="false")	
	}
	
	q saveRet
}

/// w ##class(CIS.AN.SRV.OperAppService).SendOperRoom("N")
ClassMethod SendOperRoom(clearData As %String = "N") As %String
{
	set $zt="Error"
	tstart
	&sql(declare RoomCursor cursor for select RowId,Code,Description,OperDeptID,ExternalID,LocType 
		 into :RowId,:Code,:Description,:OperDeptID,:ExternalID,:LocType
		 from CF_AN.Location where Active<>'N')
	if (clearData="Y")
	{
		&sql(delete from SQLUser.DHC_ANC_OperRoom)
		if (SQLCODE'=0)&(SQLCODE'=100)
		{
			trollback
			quit "E^"_$System.SQL.SQLCODE(SQLCODE)	
		}	
	}
	set saveRet="S^"
	&sql(open RoomCursor)
	for
	{
		&sql(fetch RoomCursor)
		quit:(SQLCODE'=0)
		set operRoom=""
		if (##class(User.DHCANCOperRoom).%ExistsId(ExternalID))
		{
			set operRoom=##class(User.DHCANCOperRoom).%OpenId(ExternalID)	
		}	
		else
		{
			set operRoom=##class(User.DHCANCOperRoom).%New()	
		}
		set operRoom.OPRCode=Code
		set operRoom.OPRCtlocDr=OperDeptID
		set operRoom.OPRDesc=Description
		set:(LocType'="") bedType=$case(LocType,"R":"T","P":"P","O":"I",:"I")
		set operRoom.OPRBedType=bedType
		set operRoom.OPRAvailable="Y"
		set sc=operRoom.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		
		set newOperRoom=##class(CF.AN.Location).%OpenId(RowId)
		set newOperRoom.ExternalID=operRoom.%Id()
		set sc=newOperRoom.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		//w "RowId: "_RowId_", BedType: "_bedType_", OperDept: "_OperDeptID,!
	}
	&sql(close RoomCursor)
	if ($p(saveRet,"^",1)="E")
	{
		trollback
		quit saveRet
	}
	tcommit
	quit saveRet
Error
	trollback
	&sql(close RoomCursor)
	quit "E^"_$ze
}

/// 判断手术/麻醉费用审核标志
/// 费用已全部审核，返回"Y^"
/// 费用未全部审核，返回"N^未审核的手术信息1;未审核的手术信息2..."
ClassMethod GetFeeAuditFlag(EpisodeID As %String) As %String
{
	set operStatusStr=",Arrange,AreaIn,RoomIn,RoomOut,PACUIn,PACUOut,AreaOut,Finish,"
	&sql(DECLARE OPCursor CURSOR FOR select %ID,OPFeeFlag,ANFeeFlag into :RowId,:OPFeeFlag,:ANFeeFlag
	 from CIS_AN.OperSchedule where EpisodeID=:EpisodeID
	 and (:operStatusStr [ (STRING(',',Status->Code,','))))
	&sql(OPEN OPCursor)
	// 默认没有手术
	set opmsg="",anmsg="",msg="",retMsg="",feeFlag="Y"
	For
	{
		&sql(FETCH OPCursor)
		quit:(SQLCODE'=0)
		set msg="",anmsg="",opmsg=""
		set opsQuery=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.OperScheduleList:FindOperScheduleList","","","",RowId)
		
		set msg="手术日期："_opsQuery.GetValue("OperDate")_" 手术名称："_opsQuery.GetValue("OperDesc")
		set opmsg=msg,anmsg=msg
		set:(OPFeeFlag'="Y") opmsg="有手术费用未审核，手术信息为："_msg
		set:(ANFeeFlag'="Y") anmsg="有麻醉费用未审核，手术信息为："_msg
		
		set:(retMsg'="")&(OPFeeFlag'="Y") retMsg=retMsg_";"
		set:(OPFeeFlag'="Y") retMsg=retMsg_opmsg
		
		set:(retMsg'="")&(ANFeeFlag'="Y") retMsg=retMsg_";"
		set:(ANFeeFlag'="Y") retMsg=retMsg_anmsg
		
		set:(ANFeeFlag'="Y")!(OPFeeFlag'="Y") feeFlag="N"
	}
	&sql(CLOSE OPCursor)
	quit feeFlag_"^"_retMsg
}

/// w ##class(CIS.AN.SRV.OperAppService).SyncData("2020-06-01","2020-06-30")
ClassMethod SyncData(startDate As %String, endDate As %String) As %String
{
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate)
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$o(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:("^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish^" '[ "^"_operSchedule.Status.Code_"^")
			set userId=""
			&sql(select ActionUser into :userId from CIS_AN.SurgicalProcedure where OperSchedule=:opsId and ProcedureCode='OPA')
			set saveRet=##class(CIS.AN.SRV.OperAppService).SendOperArrange(opsId,userId)
			w !,"同步"_operSchedule.PatName_##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate)_"的手术数据结果："_saveRet	
			set operSchedule=""
		}	
	}
	
	quit ""
}

/// w ##class(CIS.AN.SRV.OperAppService).SyncDeclineData("2020-06-01","2020-06-30")
ClassMethod SyncDeclineData(startDate As %String, endDate As %String) As %String
{
	set startDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set endDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate)
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$o(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:("Decline"'=operSchedule.Status.Code)
			set saveRet=##class(CIS.AN.SRV.OperAppService).DeclineApplication(opsId,userId)
			w !,"同步"_operSchedule.PatName_##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate)_"的拒绝手术数据结果："_saveRet	
			set operSchedule=""
		}	
	}
	
	quit ""
}

/// w ##class(CIS.AN.SRV.OperAppService).GetOrdItms("367")
ClassMethod GetOrdItms(opsId As %String) As %String
{
	set orderItemID=""
    set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set orderItemID=operScheduleObj.AppOrderItem
	quit orderItemID
}

}
