/// 手术麻醉服务接口
Class CIS.AN.SRV.OperService Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2019-12-30
/// Description： 	根据手术申请ID获取手术麻醉信息
/// Table：        	CIS_AN.OperSchedule
/// Input:			opsId - 手术申请ID
/// Return：       	手术麻醉信息对象
/// s obj= ##class(CIS.AN.SRV.OperService).GetOperInfoByID("2")
ClassMethod GetOperInfoByID(opsId As %String) As CIS.AN.DTO.OperInfo
{
	set operSchedule=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.OperScheduleList:FindOperScheduleList","","","",opsId)
	set operInfo=##class(CIS.AN.DTO.OperInfo).%New()
	set properties=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.COM.DataService:FindProperties","CIS.AN.DTO.OperInfo")
	for i=1:1:properties.Size
	{
		set propObj=properties.GetAt(i)
		set propName=propObj.GetValue("Name")
		//b //ccq
		set $property(operInfo,propName)=operSchedule.GetValue(propName)	
	}
	quit operInfo
}

/// Creator：      	陈长青
/// CreatDate：    	2019-12-30
/// Description： 	根据就诊ID获取手术麻醉信息
/// Table：        	CIS_AN.OperSchedule
/// Input:			EpisodeID - 就诊ID
/// 					opaId - 手术申请ID
/// Return：       	手术麻醉信息对象列表
/// s objList= ##class(CIS.AN.SRV.OperService).GetOperInfoByEpisode("31","")
ClassMethod GetOperInfoByEpisode(EpisodeID As %String, opaId As %String) As %ListOfObjects
{
	set operInfoList=##class(%ListOfObjects).%New()
	set opsId=..GetOpsIdByExt(opaId)
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set operInfo=..GetOperInfoByID(opsId)	
		do operInfoList.Insert(operInfo)
	}
	else
	{
		set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(EpisodeID)
		set operIdCount=$l(operIdList,",")
		for i=1:1:operIdCount
		{
			set opsId=$p(operIdList,",",i)
			continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
			set operInfo=..GetOperInfoByID(opsId)
			do operInfoList.Insert(operInfo)	
		}	
	}
	b 
	quit operInfoList
}

/// Creator：      	陈长青
/// CreatDate：    	2019-12-30
/// Description： 	根据登记号获取手术麻醉信息
/// Table：        	CIS_AN.OperSchedule
/// Input:			regNo - 登记号
/// Return：       	手术麻醉信息对象列表
/// w ##class(CIS.AN.SRV.OperService).GetOperInfoByRegNo("24")
ClassMethod GetOperInfoByRegNo(regNo As %String) As %ListOfObjects
{
	set operInfoList=##class(%ListOfObjects).%New()
	set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByRegNo(regNo)
	set operIdCount=$l(operIdList,",")
	for i=1:1:operIdCount
	{
		set opsId=$p(operIdList,",",i)
		set operInfo=..GetOperInfoByID(opsId)
		do operInfoList.Insert(operInfo)	
	}
	quit operInfoList
}

/// Creator：      	陈长青
/// CreatDate：    	2019-12-30
/// Description： 	根据病案号获取手术麻醉信息
/// Table：        	CIS_AN.OperSchedule
/// Input:			medcareNo - 病案号
/// Return：       	手术麻醉信息对象列表
/// w ##class(CIS.AN.SRV.OperService).GetOperInfoByMedcareNo("24")
ClassMethod GetOperInfoByMedcareNo(medcareNo As %String) As %ListOfObjects
{
	set operInfoList=##class(%ListOfObjects).%New()
	set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByMedcareNo(medcareNo)
	set operIdCount=$l(operIdList,",")
	for i=1:1:operIdCount
	{
		set opsId=$p(operIdList,",",i)
		set operInfo=..GetOperInfoByID(opsId)
		do operInfoList.Insert(operInfo)	
	}
	quit operInfoList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-1-3
/// Description： 	获取手术时间轴
/// Table：        	CIS_AN.SurgicalProcedure
/// Input:			opaId - 手术申请ID
/// 				actionTypeCode - 操作代码(APP:手术申请,ADT:手术审核,CCL:手术取消,OPA:手术安排,RA:排班撤回,ANA:麻醉安排,WO:离开病区,AI:入手术室,RI:入手术间,ANS:麻醉开始,OPS:手术开始,OPF:手术结束,RO:离手术间,PI:入PACU,PO:离PACU,FNH:手术完成)
/// Return：       	时间轴信息对象列表
/// s objList=##class(CIS.AN.SRV.OperService).GetAcionInfoList("149","")
/// s obj=objList.GetAt(1)
/// zw obj
ClassMethod GetAcionInfoList(opaId As %String, actionTypeCode As %String = "") As %ListOfObjects
{
	set opsId=..GetOpsIdByExt(opaId)
	set actionInfoList=##class(%ListOfObjects).%New()
	&sql(declare actionCursor cursor for select %external(ProcedureCode),
	     CIS_AN_COM.DateTime_ConvertToDateTime(ActionDate,ActionTime,''),
	     CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',ActionUser) into :actionType,:actionDT,:actionUser
	     from CIS_AN.SurgicalProcedure
	     where OperSchedule=:opsId
	     and (upper(ProcedureCode)=upper(:actionTypeCode) or (:actionTypeCode is null)))
	&sql(open actionCursor)
	for
	{
		&sql(fetch actionCursor)
		quit:(SQLCODE'=0)
		set actionInfo=##class(CIS.AN.DTO.OperActionInfo).%New()
		set actionInfo.ActionDT=actionDT
		set actionInfo.ActionType=actionType
		set actionInfo.ActionUser=actionUser
		do actionInfoList.Insert(actionInfo)
	}
	&sql(close actionCursor)
	quit actionInfoList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-1-3
/// Description： 	获取就诊ID手术时间轴
/// Table：        	CIS_AN.SurgicalProcedure
/// Input:			EpisodeID - 就诊ID
/// 				opaId - 手术申请ID
/// 				actionTypeCode - 操作代码(APP:手术申请,ADT:手术审核,CCL:手术取消,OPA:手术安排,RA:排班撤回,ANA:麻醉安排,WO:离开病区,AI:入手术室,RI:入手术间,ANS:麻醉开始,OPS:手术开始,OPF:手术结束,RO:离手术间,PI:入PACU,PO:离PACU,FNH:手术完成)
/// 					actionTypeCode如果为空则返回所有时间轴信息
/// Return：       	时间轴信息对象列表
/// s objList=##class(CIS.AN.SRV.OperService).GetActionInfoByEpisode("5","220","APP")
ClassMethod GetActionInfoByEpisode(EpisodeID As %String, opaId As %String, actionTypeCode As %String = "") As %ListOfObjects
{
	set opsId=..GetOpsIdByExt(opaId)
	set actionInfoList=""
	// 如果传入存在的手术申请ID，则只返回该手术申请ID关联的时间轴信息
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set actionInfoList=..GetAcionInfoList(opaId,actionTypeCode)	
	}	
	else
	{
		set actionInfoList=##class(%ListOfObjects).%New()
		set opsIdList=##class(CIS.AN.BL.OperScheduleList).GetOpaIdListByAdm(EpisodeID)	
		set operIdCount=$l(opsIdList,",")
		for i=1:1:operIdCount
		{
			set opaId=$p(opsIdList,",",i)
			set curInfoList=..GetAcionInfoList(opaId,actionTypeCode)
			for j=1:1:curInfoList.Size
			{
				set curInfo=curInfoList.GetAt(j)
				do actionInfoList.Insert(curInfo)	
			}	
		}
	}
	quit actionInfoList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-1-3
/// Description： 	获取手术风险评估数据
/// Table：        	CIS_AN.OperData,CIS_AN.Signature
/// Input:			opaId - 手术申请ID
/// Return：       	手术风险评估信息对象(CIS.AN.DTO.OperRiskAssessment)列表
/// s objList=##class(CIS.AN.SRV.OperService).GetRiskAssessmentList("132")
ClassMethod GetRiskAssessmentList(opaId As %String) As %ListOfObjects
{
	set opsId=..GetOpsIdByExt(opaId)
	set rs=##class(%ResultSet).%New("CIS.AN.BL.RecordSheet:FindRecordSheetsByModCode")
	set signSet=##class(%ResultSet).%New("CIS.AN.BL.Signature:FindSignature")
	set assessmentList=##class(%ListOfObjects).%New()
	set sc=rs.Execute(opsId,"AN_OPS_003")
	while(rs.%Next())
	{
		set recordSheetId=rs.Get("RowId")
		set sc=signSet.Execute(recordSheetId)
		set assessment=##class(CIS.AN.DTO.OperRiskAssessment).%New()	
		while(signSet.%Next())
		{
			set signCode=signSet.Get("SignCode")
			set signUser=signSet.Get("SignUser")
			set signUserDesc=signSet.Get("SignUserName")
			set signDT=signSet.Get("SignDT")
			if (signCode="SurgeonSign")
			{
				set assessment.Surgeon=signUserDesc
				set assessment.SurgeonSignDT=signDT
			}
			elseif (signCode="AnesthetistSign")
			{
				set assessment.AnaDoc=signUserDesc
				set assessment.AnaDocSignDT=signDT
			}
			elseif (signCode="OperNurseSign")
			{
				set assessment.OperNurse=signUserDesc
				set assessment.OperNurseSignDT=signDT
			}
		}	
		set assessment.AssessmentScore=##class(CIS.AN.BL.OperData).GetOperDataByCodeNew(recordSheetId,"RiskScore")
		set assessment.NNIS=##class(CIS.AN.BL.OperData).GetOperDataByCodeNew(recordSheetId,"NNISRate")
		do assessmentList.Insert(assessment)
	}	
	quit assessmentList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-1-3
/// Description： 	根据就诊ID获取手术风险评估信息
/// Table：        	CIS_AN.OperData,CIS_AN.Signature
/// Input:			EpisodeID - 就诊ID
/// 					opaId - 手术申请ID
/// Return：       	手术风险评估信息对象(CIS.AN.DTO.OperRiskAssessment)列表
/// w ##class(CIS.AN.SRV.OperService).GetAssessmentListByEpisode("24","")
ClassMethod GetAssessmentListByEpisode(EpisodeID As %String, opaId As %String) As %ListOfObjects
{
	set opsId=..GetOpsIdByExt(opaId)
	set assessmentList=""
	// 如果传入存在的手术申请ID，则只返回该手术申请ID关联的时间轴信息
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set assessmentList=..GetRiskAssessmentList(opsId)	
	}	
	else
	{
		set assessmentList=##class(%ListOfObjects).%New()
		set opsIdList=##class(CIS.AN.BL.OperScheduleList).GetOpaIdListByAdm(EpisodeID)	
		set operIdCount=$l(operIdList,",")
		for i=1:1:operIdCount
		{
			set opaId=$p(operIdList,",",i)
			set curInfoList=..GetRiskAssessmentList(opaId)
			for j=1:1:curInfoList.Size
			{
				set curInfo=curInfoList.GetAt(j)
				do assessmentList.Insert(curInfo)	
			}	
		}
	}
	quit assessmentList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-1-3
/// Description： 	获取手术麻醉表单信息
/// Table：        	CIS_AN.RecordSheet
/// Input:			EpisodeID - 就诊ID
/// 					opaId - 手术申请ID
/// Return：       	ResultSet(MenuDesc-菜单名称,URL-链接路径,CreateUser-创建用户,CreateDT-创建日期时间)
/// d ##class(%ResultSet).RunQuery("CIS.AN.SRV.OperService","FindRecordSheets","19","152")
Query FindRecordSheets(EpisodeID As %String, opaId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT DataModule->Description As MenuDesc,
	   STRING(DataModule->URL,'?opsId=',OperSchedule,'&moduleCode=',DataModule->Code) As URL,
	   DataModule->Code As Code,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',CreateUser) As CreateUser,
	   CIS_AN_COM.DateTime_ConvertToDateTime(CreateDate,CreateTime,'') As CreateDT
	   from CIS_AN.RecordSheet 
	   where OperSchedule->EpisodeID=:EpisodeID
	   and (OperSchedule->ExternalID=:opaId or :opaId is null)
	   and (not DataModule->URL is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2020-2-9
/// Description： 	获取巡回护士/器械护士签名数据
/// Table：        	CIS_AN.Signature
/// Input:			opsId - 手术申请ID
/// Return：       	用户签名数据对象列表(CIS.AN.DTO.UserSignature)
/// w ##class(CIS.AN.SRV.OperService).GetOperNurseSignList("24")
ClassMethod GetOperNurseSignList(opaId As %String) As %ListOfObjects
{
	set opsId=..GetOpsIdByExt(opaId)
	set rs=##class(%ResultSet).%New("CIS.AN.BL.RecordSheet:FindRecordSheetsByModCode")
	set signSet=##class(%ResultSet).%New("CIS.AN.BL.Signature:FindSignature")
	set userSignatureList=##class(%ListOfObjects).%New()
	set sc=rs.Execute(opsId,"AN_OPS_006")
	while(rs.%Next())
	{
		set recordSheetId=rs.Get("RowId")
		set sc=signSet.Execute(recordSheetId)
		set userSignature=##class(CIS.AN.DTO.UserSignature).%New()	
		while(signSet.%Next())
		{
			set signCode=signSet.Get("SignCode")
			set signUser=signSet.Get("SignUser")
			set signUserDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",signUser)
			set signDT=signSet.Get("SignDT")
			set userSignature.SignUserName=signUserDesc
			set userSignature.SignDT=signDT
			if (signCode="ScrubNurseSign")
			{
				set userSignature.SignUserType="器械护士"
			}
			elseif (signCode="CircualNurseSign")
			{
				set userSignature.SignUserType="巡回护士"
			}
			set userSignature.OpaId=opaId
		}	
		
		do userSignatureList.Insert(userSignature)
	}	
	quit userSignatureList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-1-3
/// Description： 	根据就诊ID获取巡回护士、器械护士签名数据
/// Table：        	CIS_AN.Signature
/// Input:			EpisodeID - 就诊ID
/// 				opaId - 手术申请ID
/// Return：       	用户签名数据对象列表(CIS.AN.DTO.UserSignature)
/// s objList= ##class(CIS.AN.SRV.OperService).GetOperNurseSignatureListByEpisode("1","")
ClassMethod GetOperNurseSignatureListByEpisode(EpisodeID As %String, opaId As %String) As %ListOfObjects
{
	set opsId=..GetOpsIdByExt(opaId)
	set userSignatureList=""
	// 如果传入存在的手术申请ID，则只返回该手术申请ID关联的时间轴信息
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set userSignatureList=..GetOperNurseSignList(opsId)	
	}	
	else
	{
		set userSignatureList=##class(%ListOfObjects).%New()
		set opsIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(EpisodeID)	
		set operIdCount=$l(opsIdList,",")
		for i=1:1:operIdCount
		{
			set opsId=$p(opsIdList,",",i)
			set curInfoList=..GetOperNurseSignList(opsId)
			for j=1:1:curInfoList.Size
			{
				set curInfo=curInfoList.GetAt(j)
				do userSignatureList.Insert(curInfo)	
			}	
		}
	}
	quit userSignatureList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-2-27
/// Description： 	根据手术ID获取巡回护士、器械护士签名和消毒包数据
/// Table：        	CIS_AN.Signature
/// Input:			EpisodeID - 就诊ID
/// 				opaId - 手术申请ID
/// Return：       	用户签名数据对象列表(CIS.AN.DTO.OperCount)
/// w ##class(CIS.AN.SRV.OperService).GetOperCountList("24","")
ClassMethod GetOperCountList(opaId As %String) As %ListOfObjects
{
	set opsId=..GetOpsIdByExt(opaId)
	set rs=##class(%ResultSet).%New("CIS.AN.BL.RecordSheet:FindRecordSheetsByModCode")
	set signSet=##class(%ResultSet).%New("CIS.AN.BL.Signature:FindSignature")
	set operCountList=##class(%ListOfObjects).%New()
	set sc=rs.Execute(opsId,"AN_OPS_006")
	while(rs.%Next())
	{
		set recordSheetId=rs.Get("RowId")
		set sc=signSet.Execute(recordSheetId)
		set operCount=##class(CIS.AN.DTO.OperCount).%New()
		set operCount.ScrubNurse=""
		set operCount.ScrubNurseSignDT=""
		set operCount.CircualNurse=""	
		set operCount.CircualNurseSignDT=""
		
		while(signSet.%Next())
		{
			set signCode=signSet.Get("SignCode")
			set signUser=signSet.Get("SignUser")
			set signUserDesc=signSet.Get("SignUserName")
			set signDT=signSet.Get("SignDT")
			
			if (signCode="DCircualNurseSign")
			{
				b //ccq2
				set operCount.ScrubNurse=signUserDesc
				set operCount.ScrubNurseSignDT=signDT
			}
			elseif (signCode="ICircualNurseSign")
			{
				set operCount.CircualNurse=signUserDesc
				set operCount.CircualNurseSignDT=signDT
			}
		}	
		//set userSignature.BarCode=##class(CIS.AN.BL.SterilityPack).GetBarCodeList(recordSheetId)
		do operCountList.Insert(operCount)
	}	
	quit operCountList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-2-27
/// Description： 	根据就诊ID获取巡回护士、器械护士签名和消毒包数据
/// Table：        	CIS_AN.Signature
/// Input:			EpisodeID - 就诊ID
/// 				opaId - 手术申请ID
/// Return：       	用户签名数据对象列表(CIS.AN.DTO.OperCount)
/// s objList=##class(CIS.AN.SRV.OperService).GetOperCountByEpisode("1","")
ClassMethod GetOperCountByEpisode(EpisodeID As %String, opaId As %String) As %ListOfObjects
{
	set opsId=..GetOpsIdByExt(opaId)
	set operCountList=""
	// 如果传入存在的手术申请ID，则只返回该手术申请ID关联的时间轴信息
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set operCountList=..GetOperCountList(opsId)	
	}	
	else
	{
		set operCountList=##class(%ListOfObjects).%New()
		set opaIdList=##class(CIS.AN.BL.OperScheduleList).GetOpaIdListByAdm(EpisodeID)	
		set operIdCount=$l(opaIdList,",")
		for i=1:1:operIdCount
		{
			set opaId=$p(opaIdList,",",i)
			set curInfoList=..GetOperCountList(opaId)
			for j=1:1:curInfoList.Size
			{
				set curInfo=curInfoList.GetAt(j)
				do operCountList.Insert(curInfo)	
			}	
		}
	}
	quit operCountList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-2-9
/// Description： 	获取手术安全核查签名数据
/// Table：        	CIS_AN.Signature
/// Input:			opaId - 手术申请ID
/// Return：       	用户签名数据对象列表(CIS.AN.DTO.UserSignature)
/// s objList= ##class(CIS.AN.SRV.OperService).GetOperSafetyCheckSignList("132")
ClassMethod GetOperSafetyCheckSignList(opaId As %String) As %ListOfObjects
{
	set opsId=..GetOpsIdByExt(opaId)
	set rs=##class(%ResultSet).%New("CIS.AN.BL.RecordSheet:FindRecordSheetsByModCode")
	set signSet=##class(%ResultSet).%New("CIS.AN.BL.Signature:FindSignature")
	set userSignatureList=##class(%ListOfObjects).%New()
	set sc=rs.Execute(opsId,"AN_ANS_007")
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	while(rs.%Next())
	{
		set recordSheetId=rs.Get("RowId")
		set sc=signSet.Execute(recordSheetId)
		set signCount=0
		while(signSet.%Next())
		{
			//set userSignature=##class(CIS.AN.DTO.UserSignature).%New()
			set signCode=signSet.Get("SignCode")
			if (signCode="PreANSurgeonSign")
			{
				set signUserType="麻醉前核查手术医生"
			}
			elseif (signCode="PreANAnaestSign")
			{
				set signUserType="麻醉前核查麻醉医生"
			}
			elseif (signCode="PreANOperNurseSign")
			{
				set signUserType="麻醉前核查手术护士"
			}
			elseif (signCode="PreOPSurgeonSign")
			{
				set signUserType="手术前核查手术医生"
			}
			elseif (signCode="PreOPAnaestSign")
			{
				set signUserType="手术前核查麻醉医生"
			}
			elseif (signCode="PreOPOperNurseSign")
			{
				set signUserType="手术前核查手术护士"
			}
			elseif (signCode="PreOutSurgeonSign")
			{
				set signUserType="离室前核查手术医生"
			}
			elseif (signCode="PreOutAnaestSign")
			{
				set signUserType="离室前核查麻醉医生"
			}
			elseif (signCode="PreOutOperNurseSign")
			{
				set signUserType="离室前核查手术护士"
			}
			set userSignature=##class(CIS.AN.DTO.UserSignature).%New()
			set signUser=signSet.Get("SignUser")
			set signUserDesc=signSet.Get("SignUserName")
			set signDT=signSet.Get("SignDT")
			set userSignature.SignUserName=signUserDesc
			set userSignature.SignUserType=signUserType
			set userSignature.SignDT=signDT
			set userSignature.EpisodeID=operSchedule.EpisodeID
			set userSignature.OpaId=opaId
			do userSignatureList.Insert(userSignature)
		}	
		
		
	}	
	quit userSignatureList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-2-9
/// Description： 	根据就诊ID获取手术安全核查签名数据
/// Table：        	CIS_AN.Signature
/// Input:			EpisodeID - 就诊ID
/// 				opsId - 手术申请ID
/// Return：       	用户签名数据对象列表(CIS.AN.DTO.UserSignature)
/// w ##class(CIS.AN.SRV.OperService).GetSafetyCheckSignByAdm("24","")
ClassMethod GetSafetyCheckSignByAdm(EpisodeID As %String, opaId As %String) As %ListOfObjects
{
	set opsId=..GetOpsIdByExt(opaId)
	set userSignatureList=""
	// 如果传入存在的手术申请ID，则只返回该手术申请ID关联的时间轴信息
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set userSignatureList=..GetOperSafetyCheckSignList(opsId)	
	}	
	else
	{
		set userSignatureList=##class(%ListOfObjects).%New()
		set opsIdList=##class(CIS.AN.BL.OperScheduleList).GetOpaIdListByAdm(EpisodeID)	
		set operIdCount=$l(operIdList)
		for i=1:1:operIdCount
		{
			set opaId=$p(operIdList,",",i)
			set curInfoList=..GetOperSafetyCheckSignList(opaId)
			for j=1:1:curInfoList.Size
			{
				set curInfo=curInfoList.GetAt(j)
				do userSignatureList.Insert(curInfo)	
			}	
		}
	}
	quit userSignatureList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-2-9
/// Description： 	通过手术申请医嘱ID获取手术ID
/// Table：        	CIS_AN.OperSchedule
/// Input:			orderItemId - 手术申请医嘱ID
/// Return：       	手术ID
/// w ##class(CIS.AN.SRV.OperService).GetOpsIdByOrd("100||1")
ClassMethod GetOpsIdByOrd(orderItemId As %String) As %String
{
	set opsId=""
	&sql(select %ID into :opsId from CIS_AN.OperSchedule where AppOrderItem=:orderItemId)
	quit opsId
}

/// Creator：      	陈长青
/// CreatDate：    	2020-2-9
/// Description： 	通过手术申请医嘱ID获取手术ID
/// Table：        	CIS_AN.OperSchedule
/// Input:			orderItemId - 手术申请医嘱ID
/// Return：       	手术ID
/// w ##class(CIS.AN.SRV.OperService).GetOpaIdByOrd("100||1")
ClassMethod GetOpaIdByOrd(orderItemId As %String) As %String
{
	set opaId=""
	&sql(select ExternalID into :opaId from CIS_AN.OperSchedule where AppOrderItem=:orderItemId)
	quit opaId
}

/// Creator：      	陈长青
/// CreatDate：    	2020-2-9
/// Description： 	通过手术申请医嘱ID获取手术ID
/// Table：        	CIS_AN.OperSchedule
/// Input:			orderItemId - 手术申请医嘱ID
/// Return：       	手术ID
/// w ##class(CIS.AN.SRV.OperService).GetOpaIdByOrd("100||1")
ClassMethod GetOpaIdByOpsId(opsId As %String) As %String
{
	set opaId=""
	&sql(select ExternalID into :opaId from CIS_AN.OperSchedule where %ID=:opsId)
	quit opaId
}

ClassMethod GetOpsIdByExt(opaId As %String) As %String
{
	set opsId=""
	&sql(select %ID into :opsId from CIS_AN.OperSchedule where ExternalID=:opaId)
	quit opsId
}

/// Creator：      	陈长青
/// CreatDate：    	2020-2-27
/// Description： 	通过手术ID获取手术信息
/// Table：        	CIS_AN.OperList
/// Input:			opaId - 手术ID
/// Return：       	手术ID
/// s objList=##class(CIS.AN.SRV.OperService).GetSurgeryInfoList("63")
ClassMethod GetSurgeryInfoList(opaId As %String) As %ListOfObjects
{
	set surgeryInfoList=##class(%ListOfObjects).%New()
	set opsId=..GetOpsIdByExt(opaId)
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	set sc=rs.Execute(opsId)
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set count=0
	while(rs.%Next())
	{
		set surgeryInfo=##class(CIS.AN.DTO.SurgeryInfo).%New()
		set surgeryInfo.BladeType=rs.Get("BladeTypeDesc")
		set surgeryInfo.BodySite=rs.Get("BodySiteDesc")
		set surgeryInfo.OperClass=rs.Get("OperClassDesc")
		set surgeryInfo.OperDesc=rs.Get("OperationDesc")
		set surgeryInfo.PostDiagnosis=""
		set:(count=0) surgeryInfo.PostDiagnosis=operSchedule.PostDiagnosis	
		set surgeryInfo.PrevDiagnosis=""
		set:(count=0) surgeryInfo.PrevDiagnosis=operSchedule.PrevDiagnosis
		set surgeryInfo.Surgeon=rs.Get("SurgeonDesc")
		set surgeryInfo.SurgeonDept=rs.Get("SurgeonDeptDesc")
		set assist=rs.Get("AssistantDesc")
		set surgeryInfo.Assist1=$p(assist,",",1)
		set surgeryInfo.Assist2=$p(assist,",",2)
		do surgeryInfoList.Insert(surgeryInfo)
		set count=count+1
	}
	
	quit surgeryInfoList
}

/// Creator：      	陈长青
/// CreatDate：    	2020-2-27
/// Description： 	保存手术麻醉关键事件时间
/// Table：        	CIS_AN.Anaesthesia
/// Input:			opaId - 手术ID
/// 					dateTimeStr - 入手术科室日期^入手术科室时间^离手术科室日期^离手术科室时间^入手术间日期^时间^离手术间日期^时间^麻醉开始日期^时间
///                 ^麻醉结束日期^时间^手术开始日期^时间^手术结束日期^时间^气管插管日期^时间^气管拔管日期^时间
///                 ^入PACU日期^时间^离PACU日期^时间^离手术室去向
/// Return：       	手术ID
/// w ##class(CIS.AN.SRV.OperService).SaveKeyEventTime("63","")
ClassMethod SaveKeyEventTime(opaId As %String, dateTimeStr As %String) As %String
{
	quit:(dateTimeStr="") "时间入参不能为空!"
	set opsId=..GetOpsIdByExt(opaId)
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "无对应的手术申请！"
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	quit:(##class(CIS.AN.Anaesthesia).%ExistsId(anaId)=0) "无对应的麻醉申请！"
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	s anaAreaInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",1),"")
    s anaAreaInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",2),"")
    s anaAreaOutDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",3),"")
    s anaAreaOutTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",4),"")
    set:(anaAreaInDate'="")&(anaAreaInTime'="") anaesthesia.AreaInDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(anaAreaInDate,anaAreaInTime,"")
    set:(anaAreaOutDate'="")&(anaAreaOutTime'="") anaesthesia.AreaOutDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(anaAreaOutDate,anaAreaOutTime,"")
    
    s anaTheatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",5),"")
    s anaTheatreInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",6),"")
    s anaTheatreOutDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",7),"")
    s anaTheatreOutTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",8),"")
    set:(anaTheatreInDate'="")&(anaTheatreInTime'="") anaesthesia.TheatreInDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(anaTheatreInDate,anaTheatreInTime,"")
    set:(anaTheatreOutDate'="")&(anaTheatreOutTime'="") anaesthesia.TheatreOutDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(anaTheatreOutDate,anaTheatreOutTime,"")
    
    s anaStartDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",9),"")
    s anaAnaStartTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",10),"")
    s anaFinishDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",11),"")
    s anaAnaFinishTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",12),"")
    set:(anaStartDate'="")&(anaAnaStartTime'="") anaesthesia.AnaStartDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(anaStartDate,anaAnaStartTime,"")
    set:(anaFinishDate'="")&(anaAnaFinishTime'="") anaesthesia.AnaFinishDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(anaFinishDate,anaAnaFinishTime,"")
    
    s surgStartDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",13),"")
    s anaSurgStartTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",14),"")
    s surgFinishDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",15),"")
    s anaSurgFinishTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",16),"")
    set:(surgStartDate'="")&(anaSurgStartTime'="") anaesthesia.OperStartDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(surgStartDate,anaSurgStartTime,"")
    set:(surgFinishDate'="")&(anaSurgFinishTime'="") anaesthesia.OperFinishDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(surgFinishDate,anaSurgFinishTime,"")
    
    s aniIntubationInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",17),"")
    s aniIntubationInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",18),"")
    s aniIntubationExtDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",19),"")
    s aniIntubationExtTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",20),"")
    set:(aniIntubationInDate'="")&(aniIntubationInTime'="") anaesthesia.TubeInDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(aniIntubationInDate,aniIntubationInTime,"")
    set:(aniIntubationExtDate'="")&(aniIntubationExtTime'="") anaesthesia.TubeOutDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(aniIntubationExtDate,aniIntubationExtTime,"")
    
    s opaPACUInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",21),"")
    s opaPACUInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",22),"")
    s opaPACUOutDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(dateTimeStr,"^",23),"")
    s opaPACUOutTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(dateTimeStr,"^",24),"")
    set:(opaPACUInDate'="")&(opaPACUInTime'="") anaesthesia.PACUInDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(opaPACUInDate,opaPACUInTime,"")
    set:(opaPACUOutDate'="")&(opaPACUOutTime'="") anaesthesia.PACUOutDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(opaPACUOutDate,opaPACUOutTime,"")
    s sc=anaesthesia.%Save()
    q:($System.Status.IsError(sc)) "保存关键事件时间错误，原因："_$System.Status.GetErrorText(sc)
    q 0
}

/// Creator：      	陈长青
/// CreatDate：    	2020-3-10
/// Description： 	获取手术麻醉表单链接
/// Table：        	
/// Input:			EpisodeID - 就诊ID
/// 				opaId - 手术ID
/// Return：       	手术麻醉表单对象列表(CIS.AN.DTO.AnaestSheet)
/// w ##class(CIS.AN.SRV.OperService).GetAnaestSheetsByAdm("63","")
ClassMethod GetAnaestSheetsByAdm(EpisodeID As %String, opaId As %String) As %String
{
	set opsId=..GetOpsIdByExt(opaId)
	set anaestSheets=""
	if (##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		set anaestSheets=..GetAnaestSheets(opsId)	
	}
	else
	{
		set anaestSheets=##class(%ListOfObjects).%New()
		set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(EpisodeID)	
		set operIdCount=$l(operIdList,",")
		for i=1:1:operIdCount
		{
			set opsId=$p(operIdList,",",i)
			set curInfoList=..GetAnaestSheets(opsId)
			for j=1:1:curInfoList.Size
			{
				set curInfo=curInfoList.GetAt(j)
				do anaestSheets.Insert(curInfo)	
			}	
		}
	}
	quit anaestSheets
}

ClassMethod GetAnaestSheets(opsId As %String) As %ListOfObjects
{
	set anaestSheets=##class(%ListOfObjects).%New()
	set anaestSheet=##class(CIS.AN.DTO.AnaestSheet).%New()
	set anaestSheet.LinkUrl="CIS.AN.OperCountDetail.csp?opsId="_opsId
	set anaestSheet.SheetCode="OperCountDetail"
	set anaestSheet.SheetName="手术清点单"
	do anaestSheets.Insert(anaestSheet)
	
	set anaestSheet=##class(CIS.AN.DTO.AnaestSheet).%New()
	set anaestSheet.LinkUrl="CIS.AN.OperCountDetail.csp?opsId="_opsId
	set anaestSheet.SheetCode="OperCountDetail"
	set anaestSheet.SheetName="麻醉记录单"
	do anaestSheets.Insert(anaestSheet)	
	
	quit anaestSheets
}

ClassMethod RegOperSchedule(operInfo As %String) As %String
{
	set operIndex=0
	k operArr
	for
	{
		set operIndex=$o(operInfo(operIndex))
		quit:(operIndex="")
		m operArr=operInfo(operIndex)	
	}
}

/// Creator：      	陈长青
/// CreatDate：    	2020-5-22
/// Description： 	获取手术大屏数据
/// Table：        	
/// Input:			startDate - 开始日期(格式：yyyy-MM-dd)
/// 				endDate - 结束日期(格式: yyyy-MM-dd)
/// 				operStatus - 0:申请，1-安排，2-术中，3-术毕
/// 				operRoomId - 手术间ID(注意必须与手麻系统手术间表的RowId一致)
/// Return：       	参考接口文档
/// w ##class(CIS.AN.SRV.OperService).GetOperScreenInfo("2020-05-10","2020-05-21")
ClassMethod GetOperScreenInfo(startDate As %String, endDate As %String, operStatus As %String = "", operRoomId As %String = "") As %String
{
	set defStatusCode="Application^Audit^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^Finish"
	set statusCodeStr=$case(operStatus,0:"Application^Audit",1:"Arrange",2:"RoomIn",3:"RoomOut^PACUIn^PACUOut^Finish",:defStatusCode)
	set operDeptId=""
	&sql(select top 1 OperDept into :operDeptId from CF_AN.Hospital)
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	set sc=rs.Execute(startDate,endDate,operDeptId,"","","",statusCodeStr,operRoomId)
	set dataCount=1
	k dataArr
	while(rs.%Next())
	{
		set dataArr(dataCount,"code")="0"
		set dataArr(dataCount,"description")="成功"
		set dataArr(dataCount,"operationTime")=rs.Get("OperStartDT")
		set operStatusCode=rs.Get("StatusCode")
		set extOperStatus=""
		set:("Application^Audit" [ operStatusCode) extOperStatus="0"
		set:("Arrange"=operStatusCode) extOperStatus="1"
		set:("RoomIn"=operStatusCode) extOperStatus="2"
		set:("RoomOut^PACUIn^PACUOut^Finish") extOperStatus="3"
		set dataArr(dataCount,"operationStatus")=extOperStatus
		set dataArr(dataCount,"patientName")=rs.Get("PatName")
		set dataArr(dataCount,"admissionNumber")=rs.Get("MedcareNo")	
		set patGender=rs.Get("PatGender")
		set dataArr(dataCount,"patientSex")=$case(patGender,"男":"0","女":"1",:"")
		set dataArr(dataCount,"patientAge")=+rs.Get("PatAge")
		set dataArr(dataCount,"operationName")=rs.Get("OperDesc")
		set dataArr(dataCount,"operationPart")=rs.Get("BodySiteDesc")
		set dataArr(dataCount,"operationPosition")=rs.Get("OperPositionDesc")
		set dataArr(dataCount,"operationDesc")=rs.Get("OperNote")
		set dataArr(dataCount,"operationDoctorName")=rs.Get("SurgeonDesc")
		set dataArr(dataCount,"anesthesiaMethod")=rs.Get("AnaMethodDesc")
		set dataArr(dataCount,"anesthesiaDoctorName")=rs.Get("AnesthesiologistDesc")
		set dataArr(dataCount,"operationCleanNurseName")=rs.Get("ScrubNurseDesc")
		set dataArr(dataCount,"operationTourNurseName")=rs.Get("CircualNurseDesc")
		set dataArr(dataCount,"infection")=rs.Get("InfectionOper")
		set dataArr(dataCount,"operationMachineNumbers")=rs.Get("OperSeq")
		set dataArr(dataCount,"operationNumber")=rs.Get("RoomDesc")
		set dataCount=dataCount+1
	}
	set result=##class(CIS.AN.COM.String).ToJson(.dataArr)
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2021-4-12
/// Description： 	根据就诊RowId获取手术列表
/// Table：        	CIS_AN.OperSchedule,CIS_AN.OperList,ORC_Operation
/// Input:					EpisodeID - 就诊表RowId
/// Return：       	JSON字符串
/// w ##class(CIS.AN.SRV.OperService).GetOperListByAdm("12345")
ClassMethod GetOperListByAdm(EpisodeID As %String) As %String
{
	&sql(declare operListCursor1 cursor for select %ID,OperSchedule,Operation 
			 into :RowId,:OPSID,:OperId
	     from CIS_AN.OperList
	     where OperSchedule->EpisodeID=:EpisodeID)
	&sql(open operListCursor1)
	set operArr=##class(%DynamicArray).%New()
	for
	{
		&sql(fetch operListCursor1)
		quit:(SQLCODE'=0)
		set oper = ##class(%DynamicObject).%New()
		set operSchedule=##class(CIS.AN.BL.OperSchedule).GetOperSchedule(OPSID)
		set oper.PatName = operSchedule.PatName					// 患者姓名
		set oper.PatGender = operSchedule.PatGender			// 患者性别
		set oper.PatAge = operSchedule.PatAge						// 患者年龄
		set oper.RegNo = operSchedule.RegNo							// 患者登记号
		set oper.EpisodeID = EpisodeID									// 就诊表RowId
		set oper.OPSID = OPSID													// 手术申请RowId
		set oper.OperId = OperId												// 手术名称RowId(ORC_Operation)
		set oper.ICDCode = ##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERICD10",OperId)			// 手术名称ICD10编码
		set oper.OperDesc = ##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERDesc",OperId)			// 手术名称描述
		set oper.RowId = RowId				// 手术业务表RowId(CIS_AN.OperList)
		do operArr.%Push(oper)
	}
	&sql(close operListCursor1)
	quit operArr.%ToJSON()
}

/// Creator：      	郑涛
/// CreatDate：    	2021-08-07
/// Description： 	提供护理组接口（在安排床位时同步病人手术排班表中的科室、病区、床位）
/// Table：        	CIS_AN.OperSchedule
/// Input:			EpisodeID - 就诊表RowId
/// Return：       	S^ 成功    E^ 失败
/// w ##class(CIS.AN.SRV.OperService).SynDaySurgeryDeptInfo("1")
ClassMethod SynDaySurgeryDeptInfo(EpisodeID As %String) As %String
{
	set ret="E^"
	quit:EpisodeID="" ret_"就诊号不能为空"
	set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(EpisodeID)
	quit:(operIdList="") ret_"未找到有效的相关手术信息"
	set operIdCount=$l(operIdList,",")
	for i=1:1:operIdCount
	{
		set opsId=$p(operIdList,",",i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set PatDeptID=operSchedule.PatDeptID
		set PatWardID=operSchedule.PatWardID
		set PatBedID=operSchedule.PatBedID
		continue:((PatDeptID'="")&(PatWardID'="")&(PatBedID'=""))
		set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
		set PatDeptIDNow=patInfoObj.GetValue("PatDeptID")
		set PatWardIDNow=patInfoObj.GetValue("PatWardID")
		set PatBedIDNow=patInfoObj.GetValue("PatBedID")
		set:(operSchedule.PatDeptID="") operSchedule.PatDeptID=PatDeptIDNow
		set:(operSchedule.PatWardID="") operSchedule.PatWardID=PatWardIDNow
		set:(operSchedule.PatBedID="") operSchedule.PatBedID=PatBedIDNow
		set sc=operSchedule.%Save()
    	if ($System.Status.IsError(sc))
    	{
        	set ret="E^"_$System.Status.GetErrorText(sc,"zh-cn") 
    	}else
    	{
	    	set ret="S^"_operSchedule.%Id()
	    }	
	}
	quit ret
}

/// Creator：      	元琳
/// CreatDate：    	2021-07-08
/// Description： 	患者手术申请信息接口
/// Table：        	CIS_AN.OperSchedule
/// Input:			opsId
/// Return：       	手术麻醉信息对象
/// w ##class(CIS.AN.SRV.OperService).GetPatOperApplicationInfo(447)
ClassMethod GetPatOperApplicationInfo(opsId As %String) As %String
{
	set oper = ##class(%DynamicObject).%New()
	set patientInfo = ##class(%DynamicObject).%New()
	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)
    set AnaestID=$o(^CIS.AN.AnaesthesiaI("IOPS",opsId,0))	// 麻醉申请ID
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(AnaestID)
	set AnaMethodDesc=""
	if (anaesthesia'=""){
		set AnaMethod=anaesthesia.AnaMethod
		set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)
	}
	Set OperPositionDesc=##class(CIS.AN.BL.OperSchedule).GetOperPosDesc(operSchedule.OperPosition)
	set PrevDiagnosis=$tr(operSchedule.PrevDiagnosis,$c(4),"")
	set PrevDiagnosisDesc=##class(CIS.AN.BL.OperSchedule).GetDiagnosisDesc(PrevDiagnosis)
	
	set orderStopDate="",orderStopTime="",orderStopDT=""
	set paadmtype=$p($g(^PAADM(operSchedule.EpisodeID)),"^",2)
	set paadmtype=$CASE(paadmtype,"I":3,"O":2,"E":1,"":"")
	set oper.IDNO = operSchedule.EpisodeID
	set oper.PatientDR = operSchedule.RegNo
	set oper.VisitID =..GetAdmNumByRegNo(operSchedule.RegNo)
	set oper.VisitType = paadmtype
	set oper.Name = operSchedule.PatName
    set oper.UserID = operListObj.Surgeon
	set oper.UserName = operListObj.SurgeonDesc
	set dept=##class(User.CTLoc).%OpenId(operSchedule.PatDeptID)
    set oper.DeptCode=dept.CTLOCCode
    set oper.DeptName=dept.CTLOCDesc
    set oper.HospCode=dept.CTLOCHospitalDR.HOSPCode
    set oper.HospName=dept.CTLOCHospitalDR.HOSPDesc
	set patientInfo.Gender = operSchedule.PatGender
	set papmiId=$p($g(^PAADM(operSchedule.EpisodeID)),"^",1)
	set birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	if (birth'="") set patientInfo.BirthDate = $zd(birth,3)
	else  set patientInfo.BirthDate = ""
	set patientInfo.PregnancyStatus = ""                                      //妊娠状态
	set oper.PatientInfo=patientInfo
	
	&sql(declare operListCursor2 cursor for select %ID,Operation,Surgeon,SurgeonDeptID,BodySite,OperClass,BladeType into :RowId,:OperId,:DoctorId,:SurgeonDeptID,:BodySite,:OperClass,:BladeType from CIS_AN.OperList where OperSchedule=:opsId)
	&sql(open operListCursor2)
	set orderInfoArr=##class(%DynamicArray).%New()
	for
	{
		&sql(fetch operListCursor2)
		quit:(SQLCODE'=0)
		set orderInfo = ##class(%DynamicObject).%New()
		set orderInfo.OrderID = operSchedule.AppOrderItem
		set orderInfo.OrderClass = $CASE(operSchedule.SourceType,"B":"择期","E":"急诊","":"")
		set orderInfo.OrderCode = ##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERICD10",OperId)
		set orderInfo.OrderContent = ##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERDesc",OperId)
		set orderInfo.OrderFlag = 1                                               //手术操作标识 1 新增/修改（根据是否存在医嘱号判断新增/修改）2 取消 3 删除 4 手术
		set orderInfo.OrderType = 4                                               //手术分类     4 手术
		set orderInfo.CreatTime = $zd(operSchedule.AppDate,3)_" "_$zt(operSchedule.AppTime,1)
		set orderInfo.StopTime = ""                                                           
		set orderInfo.DoctorId = DoctorId
		set orderInfo.DoctorName = ##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",DoctorId)
		set orderInfo.CreateDeptCode = SurgeonDeptID
		set orderInfo.CreatDeptName = ##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",SurgeonDeptID)
		set orderInfo.GroupSequence = ""                                          // 医嘱组顺序
		set orderInfo.Position = ##class(CIS.AN.COM.String).GetDescByID("User.OECBodySite","BODSDesc",BodySite)
		set orderInfo.Level = ##class(CIS.AN.COM.String).GetDescByID("User.ORCOperationCategory","CATEGDesc",OperClass)
		set orderInfo.IncisionType = ##class(CIS.AN.COM.String).GetDescByID("User.ORCBladeType","BLDTPDesc",BladeType)
		set orderInfo.Anesthesia = AnaMethodDesc
		set orderInfo.PreoperativeDiagnose = PrevDiagnosisDesc
		set orderInfo.OperationPosition = OperPositionDesc
		do orderInfoArr.%Push(orderInfo)
	}
	&sql(close operListCursor2)
	set oper.OrderEntry=orderInfoArr
	quit oper.%ToJSON()
}

/// Creator：      	元琳
/// CreatDate：    	2021-07-10
/// Description： 	患者手术执行信息接口
/// Table：        	CIS_AN.OperSchedule
/// Input:			opsId
/// Return：       	手术麻醉信息对象
/// w ##class(CIS.AN.SRV.OperService).GetPatOperExecInfo(456).Read()
ClassMethod GetPatOperExecInfo(opsId As %String) As %GlobalCharacterStream
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operInfo=##class(CIS.AN.BL.OperSchedule).GetOperSchedule(opsId)
    set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)
    set operDuration=0,OperStartDT="",OperStartTime="",OperFinishDT="",OperFinishTime=""
	
	set obj=##class(web.ImportDataEnity.ExecInfo).%New()
	set orderStopDate="",orderStopTime="",orderStopDT=""
	set paadmtype=$p($g(^PAADM(operSchedule.EpisodeID)),"^",2)
	set paadmtype=$CASE(paadmtype,"I":3,"O":2,"E":1,"":"")
	set obj.IDNO = operSchedule.EpisodeID
	set obj.PatientDR = operSchedule.RegNo
	set obj.VisitID =..GetAdmNumByRegNo(operSchedule.RegNo)
	set obj.VisitType = paadmtype
	set obj.OperNum=..GetOperNumByAdm(operSchedule.EpisodeID)         //手术次数
	
	set objDetail=##class(web.ImportDataEnity.ExecInfoDetail).%New()
	set objDetail.OperSequence=""                                //手术顺序号
	set objDetail.MainOperFlag=1                                 //主手术标记
	set objDetail.OperCode=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERCode",operListObj.Operation)
	set objDetail.OperName=operListObj.OperDesc
	set objDetail.OperDesc=operListObj.OperDesc
	set objDetail.OperType=operInfo.BodySiteDesc
	set objDetail.OperPosition=operInfo.OperPositionDesc 
	set objDetail.IntraoperDiagnosis=operInfo.PrevDiagnosisDesc
	set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	if (mainAnaId'=""){
		set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
		set OperStartDT=anaesthesia.OperStartDT
		set:OperStartDT'="" OperStartTime=$zth($p(OperStartDT," ",2),1)	
		set OperFinishDT=anaesthesia.OperFinishDT
		set:OperFinishDT'="" OperFinishTime=$zth($p(OperFinishDT," ",2),1)
		if ((OperStartTime'="")&&(OperFinishTime'="")) set operDuration=(OperFinishTime-OperStartTime)\60
	}
	set objDetail.OperDuration=operDuration
	set objDetail.OperStartTime=OperStartDT
	set objDetail.OperEndTime=OperFinishDT
	
	set obj.OperationResultInfo=objDetail
	set obj.PassFlag=1
	set stream=##class(%GlobalCharacterStream).%New()
	do obj.XMLExportToStream(.stream)
	q stream
}

/// Creator：      	元琳
/// CreatDate：    	2021-07-10
/// Description： 	患者手术麻醉信息接口
/// Table：        	CIS_AN.OperSchedule
/// Input:			opsId
/// Return：       	手术麻醉信息对象
/// w ##class(CIS.AN.SRV.OperService).GetPatOperAnaInfo(461).Read()
ClassMethod GetPatOperAnaInfo(opsId As %String) As %GlobalCharacterStream
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operInfo=##class(CIS.AN.BL.OperSchedule).GetOperSchedule(opsId)
    set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)
	
	set obj=##class(web.ImportDataEnity.AnaInfo).%New()
    set AnaDuration=0,AnaStartDT="",AnaStartTime="",AnaFinishDT="",AnaFinishTime=""
	set paadmtype=$p($g(^PAADM(operSchedule.EpisodeID)),"^",2)
	set paadmtype=$CASE(paadmtype,"I":3,"O":2,"E":1,"":"")
	set obj.IDNO=operSchedule.EpisodeID
	set obj.PatientDR = operSchedule.RegNo
	set obj.VisitID =..GetAdmNumByRegNo(operSchedule.RegNo)
	set obj.VisitType = paadmtype
	
	set objDetail=##class(web.ImportDataEnity.AnaInfoDetail).%New()
	set AnestDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.SRV.OperService:FindDrugSummaryInfo",opsId)
	for i=1:1:(AnestDatas.Size)
	{
		set AnestData = AnestDatas.GetAt(i)
		continue:AnestData=""
		set objDetail.AnestMedication = AnestData.GetValue("DataItem")
		set objDetail.Dose = AnestData.GetValue("sumQty")
		set objDetail.Usage = AnestData.GetValue("Instruction")
		set objDetail.Anesthesia = operInfo.AnaMethodDesc
		set objDetail.AnestSite = AnestData.GetValue("InjectionSite")
		set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
		if (mainAnaId'=""){
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set AnaStartDT=anaesthesia.AnaStartDT
			set:AnaStartDT'="" AnaStartTime=$zth($p(AnaStartDT," ",2),1)
			set AnaFinishDT=anaesthesia.AnaFinishDT
			set:AnaFinishDT'="" AnaFinishTime=$zth($p(AnaFinishDT," ",2),1)
			if ((AnaStartTime'="")&&(AnaFinishTime'="")) set AnaDuration=(AnaFinishTime-AnaStartTime)\60
		}
		set objDetail.AnestDuration=AnaDuration
		set objDetail.AnestStartTime=AnaFinishDT
	    do obj.AnestDrugInfo.Insert(objDetail)
	}
	set obj.PassFlag=1
	set stream=##class(%GlobalCharacterStream).%New()
	do obj.XMLExportToStream(.stream)
	q stream
}

/// Creator：      	元琳
/// CreatDate：    	2021-07-11
/// Description： 	患者手术输血信息接口
/// Table：        	CIS_AN.OperSchedule
/// Input:			opsId
/// Return：       	手术麻醉信息对象
/// w ##class(CIS.AN.SRV.OperService).GetPatOperBloodInfo(467).Read()
ClassMethod GetPatOperBloodInfo(opsId As %String) As %GlobalCharacterStream
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operInfo=##class(CIS.AN.BL.OperSchedule).GetOperSchedule(opsId)
    set Duration=0,TransStartTime="",TransEndTime=""
	
	set obj=##class(web.ImportDataEnity.BloodInfo).%New()
	set paadmtype=$p($g(^PAADM(operSchedule.EpisodeID)),"^",2)
	set paadmtype=$CASE(paadmtype,"I":3,"O":2,"E":1,"":"")
	set obj.IDNO= operSchedule.EpisodeID
	set obj.PatientDR = operSchedule.RegNo
	set obj.VisitID =..GetAdmNumByRegNo(operSchedule.RegNo)
	set obj.VisitType = paadmtype
	
	set objDetail=##class(web.ImportDataEnity.BloodInfoDetail).%New()
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCodeNew(opsId,"AN_OPS_008","")
	set recordId=0
	for
	{
		set recordId=$order(^CIS.AN.BloodTransRecordI("IRecordSheet",recordSheetId,recordId))
		quit:(recordId="")
	    set BloodTransRecord=##class(CIS.AN.BloodTransRecord).%OpenId(recordId)
	    set TransStartDate=BloodTransRecord.TransStartDate
	    set TransStartTime=BloodTransRecord.TransStartTime
	    set TransEndDate=BloodTransRecord.TransEndDate
	    set TransEndTime=BloodTransRecord.TransEndTime
	    
	    set objDetail.BloodTransStartTime = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(TransStartDate,TransStartTime,"")
	    set objDetail.BloodTransEndTime = ##class(CIS.AN.COM.DateTime).ConvertToDateTime(TransEndDate,TransEndTime,"")
	
	    if ((TransStartTime'="")&&(TransEndTime'="")) set Duration=(TransEndTime-TransStartTime)\60
	    set objDetail.BloodTransDuration = Duration
	    set objDetail.BloodTransDurationU = "分钟"
		set objDetail.BloodTransVolume = BloodTransRecord.Volume
	    set objDetail.BloodTransVolumeU = BloodTransRecord.Unit
	    set objDetail.BloodTransSite = ""
	    set objDetail.BloodTransType = BloodTransRecord.ABO
	    set objDetail.BloodTransTypeRh = BloodTransRecord.RH
	    set objDetail.BloodTransClass = BloodTransRecord.BloodCategory
	    set objDetail.BTIndication = ""
	    set objDetail.BTIndicationValue = ""
	    set objDetail.BTIndicationValueUnit = ""
	    do obj.BloodTransRecordInfo.Insert(objDetail)
	}
	set obj.PassFlag=1
	set stream=##class(%GlobalCharacterStream).%New()
	do obj.XMLExportToStream(.stream)
	q stream
}

ClassMethod GetOperNumByAdm(adm As %String) As %String
{
	s Num=0
	&sql(select count(*) into :Num from CIS_AN.Operschedule WHERE EpisodeID =:adm)
	q Num
}

ClassMethod GetAdmNumByRegNo(RegNo As %String) As %String
{
	s Num=0
	s regNo=+RegNo
	&sql(select count(*) into :Num from SQLUser.PA_Adm WHERE PAADM_PAPMI_DR=:regNo AND PAADM_Type="I")
	q Num
}

/// Creator：      	元琳
/// CreatDate：    	2021-07-14
/// Description： 	患者麻醉用药信息
/// Table：        	CIS_AN.DrugData
/// Input:			opsId
/// Return：       	手术麻醉信息对象
/// d ##class(%ResultSet).RunQuery("CIS.AN.SRV.OperService","FindDrugSummaryInfo",461)
Query FindDrugSummaryInfo(opsId As %String) As %Query(ROWSPEC = "DataItem,sumQty,Instruction,InjectionSite") [ SqlProc ]
{
}

ClassMethod FindDrugSummaryInfoExecute(ByRef qHandle As %Binary, opsId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set moduleCode = "AnaestRecord"
	set Instruction = "",InjectionSite = "",sumQty = "",DataItem = ""
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set drugDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindDrugDatas",recordSheetId,"N")
	for i=1:1:(drugDatas.Size)
	{
		set drugData = drugDatas.GetAt(i)
		continue:drugData=""
		set dataItemId = drugData.GetValue("DataItem")
		set rowId = drugData.GetValue("RowId")
		set InstructionId = drugData.GetValue("Instruction")
		set:InstructionId'="" Instruction=##class(CIS.AN.COM.String).GetDescByID("CT.AN.Instruction","Description",InstructionId)
		set InjectionSite = drugData.GetValue("InjectionSite")
		set sumQty=##class(CIS.AN.BL.AnaestRecord).CalcDrugSumQty(rowId)
		set:dataItemId'="" DataItem=##class(CIS.AN.COM.String).GetDescByID("CT.AN.DataItem","Description",dataItemId)
	    do OutputRow
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=$lb(DataItem,sumQty,Instruction,InjectionSite)
	s ind=ind+1
	q
}

ClassMethod FindDrugSummaryInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDrugSummaryInfoExecute ]
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

ClassMethod FindDrugSummaryInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDrugSummaryInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2020-6-18
/// Description： 	判断能否取消手术,医生站调用
/// Table：        	
/// Input:			orderItemID - 手术申请医嘱ID
/// 				userGroupID - 取消手术用户安全组ID
/// 				userId - 取消手术用户ID
/// Return：       	可以取消返回"0"，不能取消返回"-1^原因"
/// w ##class(CIS.AN.SRV.OperService).GetOperScreenInfo("2020-05-10","2020-05-21")
ClassMethod CanCancelOperation(orderItemID As %String, userGroupID As %String, userId As %String)
{
	set opsId=..GetOpsIdByOrd(orderItemID)
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "0"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	// 如果手术已经取消、拒绝，直接返回0
	//quit:("^Cancel^Decline^" [ "^"_operSchedule.Status.Code_"^") "0"
	
	// 根据【申请用户取消手术】配置，判断入参userId能否取消手术
	set cancelByAppUser=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("CancelAppByAppUser")
	quit:(cancelByAppUser="Y")&(operSchedule.AppUserID'=userId) "-1^当前用户不是手术申请用户，不能取消手术。"
	
	// 根据安全组判断用户是否具有直接审核权限
	set auditOperApp=""
	&sql(select AuditOperApp into :auditOperApp from CF_AN.SSGroup where GroupID=:userGroupID)
	set passStatusCode="^Application^Audit^"
	quit:(auditOperApp="Y")&(passStatusCode '[ "^"_operSchedule.Status.Code_"^") "-1^当前安全组用户只能取消【申请】和【审核】状态的手术。"
	set passStatusCode="Application"
	quit:(auditOperApp'="Y")&(passStatusCode'=operSchedule.Status.Code) "-1^当前安全组用户只能取消【申请】状态的手术。"
	quit "0"
}

/// w ##class(CIS.AN.SRV.OperService).GetOperXMLInfoByOpsId(2).Read()
ClassMethod GetOperXMLInfoByOpsId(opsId As %String) As %Stream
{
	set stream=##class(%GlobalCharacterStream).%New()
	set tag="OperInfo"
	set operSchedule=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.OperScheduleList:FindOperScheduleList","","","",opsId)
	set operInfo=##class(CIS.AN.DTO.OperInfo).%New()
	set properties=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.COM.DataService:FindProperties","CIS.AN.DTO.OperInfo")
	do stream.Write("<"_tag_">")
	for i=1:1:properties.Size
	{
		set propObj=properties.GetAt(i)
		set propName=propObj.GetValue("Name")
		set propValue=operSchedule.GetValue(propName)	
		do stream.Write("<"_propName_">"_propValue_"</"_propName_">")
	}
	do stream.Write("</"_tag_">")
	
	quit stream
}

/// w ##class(CIS.AN.SRV.OperService).GetOperXMLInfoByEpisode(5).Read()
ClassMethod GetOperXMLInfoByEpisode(EpisodeID As %String) As %Stream
{
	set stream=##class(%GlobalCharacterStream).%New()
	
	set tag="OperInfoList"
	set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(EpisodeID)
	set operIdCount=$l(operIdList,",")
	do stream.Write("<"_tag_">")
	for i=1:1:operIdCount
	{
		set opsId=$p(operIdList,",",i)
		continue:'##class(CIS.AN.OperSchedule).%ExistsId(opsId)
		set operInfoStream=##class(CIS.AN.SRV.OperService).GetOperXMLInfoByOpsId(opsId)
		while operInfoStream.AtEnd=0
		{
			do stream.Write(operInfoStream.Read())
		}
	}	
	do stream.Write("</"_tag_">")
	quit stream
}

/// w ##class(CIS.AN.SRV.OperService).GetOperXMLInfoByRegNo(24).Read()
ClassMethod GetOperXMLInfoByRegNo(RegNo As %String) As %Stream
{
	set stream=##class(%GlobalCharacterStream).%New()
	
	set tag="OperInfoList"
	set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByRegNo(RegNo)
	set operIdCount=$l(operIdList,",")
	do stream.Write("<"_tag_">")
	for i=1:1:operIdCount
	{
		set opsId=$p(operIdList,",",i)
		continue:'##class(CIS.AN.OperSchedule).%ExistsId(opsId)
		set operInfoStream=##class(CIS.AN.SRV.OperService).GetOperXMLInfoByOpsId(opsId)
		while operInfoStream.AtEnd=0
		{
			do stream.Write(operInfoStream.Read())
		}
	}	
	do stream.Write("</"_tag_">")
	quit stream
}

ClassMethod GetIsOpArrangedByOrderId(orderId)
{
	set operStatus=""
	&sql(SELECT RowId,Status->Code into :rowId,:operStatus FROM CIS_AN.OperSchedule WHERE AppOrderItem=:orderId)
    //w operStatus,!
	if ((operStatus="Application") || (operStatus="Audit" )|| (operStatus="Cancel" )|| (operStatus="Decline" )|| (operStatus="Revoke" ))
	{
		quit 0
	}
	else
	{
		quit 1
	}
}

/// Creator：      	元琳
/// CreatDate：    	2021-12-06
/// Description： 	根据就诊RowId获取最新一次手术信息
/// Table：        	CIS_AN.OperSchedule,CIS_AN.OperList,ORC_Operation
/// Input:			EpisodeID - 就诊表RowId
/// Return：       	JSON字符串
///  6119")
/// w ##class(CIS.AN.SRV.OperService).GetLastOperInfoByAdm(21)
ClassMethod GetLastOperInfoByAdm(EpisodeID As %String) As %String
{
	&sql(select OperSchedule into :OPSID from CIS_AN.OperList where OperSchedule->EpisodeID=:EpisodeID order by %Id Desc)
	quit:(SQLCODE'=0) ""
	&sql(declare operListCursor cursor for select %ID,Operation into :RowId,:OperId from CIS_AN.OperList where OperSchedule=:OPSID)
	&sql(open operListCursor)
	set operArr=##class(%DynamicArray).%New()
	for
	{
		&sql(fetch operListCursor)
		quit:(SQLCODE'=0)
		set oper = ##class(%DynamicObject).%New()
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(OPSID)
		set oper.PatName = operSchedule.PatName
		set oper.PatGender = operSchedule.PatGender
		set oper.PatAge=##class(CIS.AN.COM.DateTime).CalAge(operSchedule.PatDOB,+$h)
		set oper.RegNo = operSchedule.RegNo
		set oper.EpisodeID = EpisodeID
		set oper.OPSID = OPSID
		set oper.OperId = OperId
		set oper.ICDCode = ##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERICD10",OperId)			// 手术名称ICD10编码
		set oper.OperDesc = ##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERDesc",OperId)			// 手术名称描述
		set oper.RowId = RowId
		do operArr.%Push(oper)
	}
	&sql(close operListCursor)
	quit operArr.%ToJSON()
}

/// Creator：      	元琳
/// CreatDate：    	2022-04-20
/// Description： 	根据手术表RowId获取手术申请单Id
/// Table：        	CIS_AN.OperList
/// Input:		    手术表RowId
/// Return：       	手术申请单RowId
/// w ##class(CIS.AN.SRV.OperService).GetOperScheduleByOperId()
ClassMethod GetOperScheduleByOperId(OperId As %String) As %String
{
	set OPSID=""
	&sql(select OperSchedule into :OPSID from CIS_AN.OperList where RowId=:OperId)
	quit OPSID
}

/// w ##class(CIS.AN.SRV.OperService).GetInOutInfoByEpisode(934)
ClassMethod GetInOutInfoByEpisode(admId As %String) As %String
{
	q:admId="" ""
	set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(admId)
	set operIdCount=$l(operIdList,",")
	set allInOutStr=""
	for i=1:1:operIdCount
	{
		set opsId=$p(operIdList,",",i)
		quit:opsId=""
		set anaestInOutObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
		set TotalOut=anaestInOutObj.GetValue("TotalOut")				
		set TotalIn=anaestInOutObj.GetValue("TotalIn")
		if (TotalIn="")
		{
		 	set TotalIn=##class(CIS.AN.SRV.OperService).GetInOutSummaryInface(opsId)
		}	
		set UrineVol=anaestInOutObj.GetValue("UrineVol")								
		set BloodLossVol=anaestInOutObj.GetValue("BloodLossVol")
		set OtherVol=anaestInOutObj.GetValue("OtherVol")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
		set planOperData=##class(CIS.AN.BL.OperScheduleList).GetPlanOperList(opsId,.planOperData)		// 拟施手术
	    set PlanOperDesc=planOperData(1,"OperationDesc")			// 拟施手术名称
		set InoutStr=""	
		set InoutStr=TotalOut_","_TotalIn_","_UrineVol_","_BloodLossVol_","_OtherVol_","_OperDate_","_PlanOperDesc
		if (allInOutStr="")
		{
			set allInOutStr=InoutStr
		}
		else
		{
			set allInOutStr=allInOutStr_"^"_InoutStr
		}	
	}
	quit allInOutStr
}

/// w ##class(CIS.AN.SRV.OperService).GetInOutSummaryInface(9118)
ClassMethod GetInOutSummaryInface(opsId) As %String
{
	kill totalInfoIn
	/// 入量
	kill summaryCodeList,summaryCategory
	/// summaryCategory(分类代码)=汇总代码
	set summaryCategory("Crystalloid")="Crystalloid"
	set summaryCategory("Colloid")="Colloid"
	set summaryCategory("RedCell")="RedCell"
	set summaryCategory("Plasma")="Plasma"
	set summaryCategory("BloodPlate")="BloodPlate"
	set summaryCategory("Infusion")="Infusion"
	set summaryCategory("BloodTransfusion")="BloodTransfusion"
	
	set categoryCode=""
	for
	{
		set categoryCode=$o(summaryCategory(categoryCode))
		quit:categoryCode=""
		
		set summaryCode=summaryCategory(categoryCode)
		set categoryId=$o(^CT.AN.DataCategoryI("ICode"," "_$ZCVT(categoryCode,"U"),""))
		
		continue:categoryId=""
		set categoryItemId=""
		for
		{
			set categoryItemId=$o(^CT.AN.DataCateItemI("IDataCategory",categoryId,categoryItemId))
			quit:categoryItemId=""
			
			set dataItemId=$lg(^CT.AN.DataCateItemD(categoryItemId),2)
			set summaryCodeList(dataItemId,summaryCode)=""
		}
	}
	set moduleCode = "AnaestRecord"
	set totalIn=0
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	quit:recordSheetId="" 0
	set drugDatas=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.AnaestRecord:FindDrugDatas",recordSheetId,"N")
	for i=1:1:(drugDatas.Size)
	{
		set drugData = drugDatas.GetAt(i)
		continue:drugData=""
		set dataItemId = drugData.GetValue("DataItem")
		set rowId = drugData.GetValue("RowId")
		continue:(dataItemId="")||('$d(summaryCodeList(dataItemId)))
		set sumQty=##class(CIS.AN.BL.AnaestRecord).CalcDrugSumQty(rowId)
		set summaryCode=""
		for
		{
			set summaryCode=$o(summaryCodeList(dataItemId,summaryCode))
			quit:summaryCode=""
			set totalInfoIn(summaryCode)=$g(totalInfoIn(summaryCode))+sumQty
		}
	}
	set totalIn=$g(totalInfoIn("Infusion"))+$g(totalInfoIn("BloodTransfusion"))+$g(totalInfoIn("Plasma"))
	q totalIn
}

/// w ##class(CIS.AN.SRV.OperService).GetArchiveFileByAdm("444","AnaestRecord")
ClassMethod GetArchiveFileByAdm(EpisodeID As %String, archiveCode As %String, newVersion As %String = "Y") As %String
{
	quit:EpisodeID="" "就诊号不能为空!"
	quit:archiveCode="" "文档类型不能为空!"
	set ret="",StartDate="",EndDate=""
	if (archiveCode'="DHCICU") {
		if (newVersion="Y") {
			set opsIdStr=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(EpisodeID)
			set opsCount=$l(opsIdStr,","),ret=""
			for i=1:1:opsCount
			{
				set opsId=$p(opsIdStr,",",i)
				set filePath=..GetArchiveFile(opsId,archiveCode)
				;continue:filePath=""
				set:(filePath'="")&(ret'="") ret=ret_"^"
				;set:(filePath'="")&(ret'="") ret=ret_$c(0)
				set ret=ret_filePath	
			}
		}
		else {
		 	set ret=##class(web.DHCANOPPdfBrowser).GetANOPPDFPath(EpisodeID,archiveCode)
		}
	}
	else {
		&sql(select * into :PLIST() from SQLUSER.DHC_ICU_Arrange where ICUA_Adm_Dr=:EpisodeID)
		if SQLCODE=0 d
		.set StartDate=PLIST(7)
		.set EndDate=PLIST(8)
		set:(StartDate="") StartDate=+$h
		set:(EndDate="") EndDate=+$h
		set ret=""
    	for date=StartDate:1:EndDate
    	{
			set fileDate=##class(CIS.AN.COM.DateTime).ConvertToDate(date,"")
	    	set filePath=##class(web.DHCICUPdfBrowser).GetICUPDFPath(EpisodeID,fileDate)
			set:(filePath'="")&(ret'="") ret=ret_"^"
			set ret=ret_filePath	
    	}
	}
	quit ret
}

ClassMethod GetArchiveFile(opsId As %String, archiveCode As %String) As %String
{
	set filePath="",recordSheetId=""
	&sql(select RowId into:recordSheetId from CIS_AN.RecordSheet where OperSchedule=:opsId and DataModule->ArchiveCode=:archiveCode)
	&sql(select FilePath into:filePath  from CIS_AN.ArchiveRecord WHERE RecordSheet=:recordSheetId ORDER BY RowId Desc)
	//s filePath=$tr(filePath," ","")
	quit filePath
}

/// Creator：      	元琳
/// CreatDate：    	2022-12-28
/// Description： 	医务管理接口-根据就诊Id判断患者是否为非计划重返手术患者
/// Table：        	CIS_AN.OperSchedule
/// Input:		    EpisodeID
/// Return：       	患者是非计划重返手术患者,返回1_"^"_第一次非计划重返手术的非计划重返天数
/// Return：       	患者不是非计划重返手术患者,返回0
/// w ##class(CIS.AN.SRV.OperService).CheckReentryOperation()
ClassMethod CheckReentryOperation(EpisodeID As %String, newVersion As %String = "Y") As %String
{
	set flag=0
	if (newVersion="Y") {
		set opsIdStr=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(EpisodeID)
		set opsCount=$l(opsIdStr,",")
		for i=1:1:opsCount
		{
			set opsId=$p(opsIdStr,",",i)
			continue:opsId=""
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			if (i=1) set lastOperDate=operSchedule.OperDate
			else  set lastOperDate=OperDate
			set OperDate=operSchedule.OperDate
			set ReentryOperation=operSchedule.ReentryOperation
			if (ReentryOperation="Y") {
				set duration=OperDate-lastOperDate
				set flag=1_"^"_duration
			}
			quit:ReentryOperation="Y"
		}
	}
	else {
		set opaId=""
		set num=0
        for  set opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
		.set num=num+1
		.set opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		.if (num=1) set lastOperDate=opstdate
		.else  set lastOperDate=OperDate
		.set OperDate=opstdate
		.set opUnPlanedOperation=$P(^DHCANOPArrange(opaId),"^",46)	//非计划重返
		.if (opUnPlanedOperation="Y") d
		..set duration=OperDate-lastOperDate
		..set flag=1_"^"_duration
		.quit:opUnPlanedOperation="Y"
	}
	quit flag
}

}
