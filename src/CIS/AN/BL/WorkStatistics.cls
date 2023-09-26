/// 工作量统计类
Class CIS.AN.BL.WorkStatistics Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-11-25
/// Description： 	查询手术
/// Table：        	DHCAN.Model.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期，3.andocID:麻醉医生ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.WorkStatistics","FindOperScheduleList","2021-10-01","2021-10-31","","")
Query FindOperScheduleList(startDate As %String, endDate As %String, filterPatDept As %String = "", filterSurgeon As %String = "", operName As %String = "", bladeType As %String = "", sourceType = "", usedDevice = "", filterOperClass = "", filterSpecialistOper = "") As %Query(ROWSPEC = "RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDescset,AssistantDesc,AreaInOutTime,AnaTime") [ SqlProc ]
{
}

ClassMethod FindOperScheduleListExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, filterPatDept As %String = "", filterSurgeon As %String = "", operName As %String = "", bladeType As %String = "", sourceType = "", usedDevice = "", filterOperClass = "", filterSpecialistOper = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set operName=$ZCVT(operName,"U")
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set indexNode="OPDate"
	
	set operListSet=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			s surgeonIdStr=""
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:operSchedule.PatDeptID=""
			
			set statusCode=operSchedule.Status.Code
			continue:(statusCode'="RoomOut")&&(statusCode'="PACUIn")&&(statusCode'="Finish")
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anesthesiologist=anaesthesia.Anesthesiologist
			
			set theatreInDateTime=anaesthesia.TheatreInDT
			set theatreOutDateTime=anaesthesia.TheatreOutDT
			//continue:(theatreInDateTime="")&&(theatreOutDateTime="")
			
			// 病人科室(申请手术时)
			set patDeptID=operSchedule.PatDeptID
			continue:(filterPatDept'="")&&(+filterPatDept'=+patDeptID)
			
			set patDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
			
			set operationNameStr="",surgeonNameList="",operClassList=""
			set sc=operListSet.Execute(opsId)
			while(operListSet.%Next())
			{
				set surgeon=operListSet.Get("Surgeon")
				set assistant=operListSet.Get("Assistant")
				set surgeonDept=operListSet.Get("SurgeonDeptID")
				set surgeonDesc=operListSet.Get("SurgeonDesc")
				set assistantDesc=operListSet.Get("AssistantDesc")
				set surgeonDeptDesc=operListSet.Get("SurgeonDeptDesc")
				set operDesc=operListSet.Get("OperationDesc")
				set:operDesc="" operDesc=operListSet.Get("OperNote")
				set operClass=operListSet.Get("OperClass")
				set riskBladeType=operListSet.Get("BladeType")
				
				//set:(surgeon="") surgeon=surgeonDesc
				set:(surgeonIdStr'="") surgeonIdStr=surgeonIdStr_","
				set surgeonIdStr=surgeonIdStr_surgeon
				set:(surgeonDesc="") surgeonDesc=surgeon
				set surgeonDesc=$TR(surgeonDesc," ")
				
				set operationNameStr=operationNameStr_"+"_operDesc
				set surgeonNameList=surgeonNameList_$lb(surgeonDesc)
				set operClassList=operClassList_$lb(operClass)
			}
			continue:(operName'="")&&((operationNameStr="")||(operationNameStr'[operName)) //手术名称匹配
			continue:(filterSurgeon'="")&&(surgeonIdStr'[filterSurgeon) //手术医生匹配
			//continue:(filterSurgeon'="")&&('$LISTFIND(surgeonNameList,filterSurgeon)) //手术医生匹配
			continue:(filterOperClass'="")&&('$LISTFIND(operClassList,filterOperClass)) //手术分级匹配
			continue:(bladeType'="")&&(riskBladeType'="")&&(bladeType'=riskBladeType) //手术分级匹配
			
			if sourceType'=""
			{
				set riskSourceType=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperRiskAssessment","EmergencyOper")
				continue:((sourceType="E")&&(riskSourceType'="急诊"))  //急诊筛选
				continue:((sourceType'="E")&&(riskSourceType="急诊"))  //择期筛选
			}
			
			if usedDevice'=""
			{
				set hasUsedDevice=##class(CIS.AN.BL.EquipRecord).HasUsedDevice(opsId,usedDevice)
				continue:hasUsedDevice="N"  //未使用过此设备
			}
			
			if filterSpecialistOper'=""
			{
				set specialistOper=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","SpecialistOper")
				set isSpecialistOper=$s(specialistOper="专家手术":"Y",1:"N")
				continue:filterSpecialistOper'=isSpecialistOper  //专家手术
			}
			
			do OutputRow
		}	
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=..GetOperSchedule(opsId)
	s ind=ind+1
	q
}

ClassMethod FindOperScheduleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperScheduleListExecute ]
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

ClassMethod FindOperScheduleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperScheduleListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod GetOperSchedule(opsId As %String) As %List
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	// 获取患者信息
	set EpisodeID=operSchedule.EpisodeID
	set ExtAnaestID=operSchedule.ExtAnaestID
	set patInfoObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Admission:FindPatient",EpisodeID)
	set PatName=patInfoObj.GetValue("PatName")
	set PatGender=patInfoObj.GetValue("PatGender")
	set PatAge=patInfoObj.GetValue("PatAge")
	set PatDOB=patInfoObj.GetValue("PatDOB")
	set RegNo=patInfoObj.GetValue("RegNo")
	set MedcareNo=patInfoObj.GetValue("MedcareNo")	
	set PatientID=patInfoObj.GetValue("PatientID")
	set MRAdmID=patInfoObj.GetValue("MRAdmID")
	set AdmReason=patInfoObj.GetValue("AdmReason")
	set PatCardID=patInfoObj.GetValue("CardID")
	set AdmDateH=patInfoObj.GetValue("AdmDateH")
	set Patient=PatName_(PatGender_" "_PatAge)			// 患者基本信息，格式为：张三(男 30岁)
	set PreopAdmDays=operSchedule.OperDate-AdmDateH		// 术前住院日
	
	// 手术申请信息
	set AppCareProvID=operSchedule.AppCareProvID		// 手术申请医护人员ID
	set AppCareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",operSchedule.AppCareProvID)
	set PatDeptID=operSchedule.PatDeptID
	set PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
	set PatWardID=operSchedule.PatWardID
	set PatWardDesc=##class(CIS.AN.COM.String).GetDescByID("User.PACWard","WARDDesc",operSchedule.PatWardID)
	
	set PatBedID=operSchedule.PatBedID	
	set PatBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",operSchedule.PatBedID)
	set:(PatBedCode="") PatBedCode=operSchedule.PatBedID				// 一般HIS为第三方系统时，将床位代码直接存入PatBedID字段
	
	set WardBed=PatWardDesc_" "_PatBedCode
	
	set AppDeptID=operSchedule.AppDeptID				// 手术申请科室
	set AppDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AppDeptID)
	
	set OperDeptID=operSchedule.OperDeptID				// 手术室
	set OperDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperDeptID)
	
	set AppUserID=operSchedule.AppUserID
	
	// 麻醉科
	set AnaDept=operSchedule.AnaDept
	set AnaDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
	
	set SourceType=operSchedule.SourceType				// 手术类型
	set SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
	
	set Status=operSchedule.Status.%Id()				// 手术状态ID
	set StatusDesc=operSchedule.Status.Description		// 手术状态名称
	set StatusColor=operSchedule.Status.BGColor			// 手术状态背景颜色
	set StatusCode=operSchedule.Status.Code				// 手术状态代码
	
	set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")			// 手术日期(计划)
	set DateFormat=$lg(^websys.ConfigurationD(1),10)
	if ((DateFormat="DMY")&&(OperDate'="")) set OperDate=$zd($zdh(OperDate,3),4)
	set OperTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.OperTime,"")			// 手术开始时间(计划)
	
	set OperDuration=operSchedule.OperDuration			// 手术持续时长(计划)
	set ReentryOperation=operSchedule.ReentryOperation  // 非计划重返手术
	set ReentryOperationDesc=##class(CIS.AN.OperSchedule).ReentryOperationLogicalToDisplay(operSchedule.ReentryOperation)
	set DaySurgery=operSchedule.DaySurgery  // 202002+dyl+日间手术
	set OPAdmType=operSchedule.OPAdmType	//202003+dyl+门诊手术
	set ComeHosTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.ComeHosTime,"")
	set PatPhoneNumber=operSchedule.PatPhoneNumber	//202003+dyl+门诊手术
	set PatNeedNotice=operSchedule.PatNeedNotice	//202003+dyl+门诊手术
	
	set Anaesthesia=operSchedule.Anaesthesia			// 是否麻醉科参与麻醉
	set AnaesthesiaDesc=##class(CIS.AN.OperSchedule).AnaesthesiaLogicalToDisplay(operSchedule.Anaesthesia)
	set PrevAnaMethod=operSchedule.PrevAnaMethod		// 拟施麻醉方法
	set PrevAnaMethodDesc=##class(CIS.AN.COM.String).GetDescByID("CT.AN.AnaMethod","Description",operSchedule.PrevAnaMethod)
	
	set PlanSeq=operSchedule.PlanSeq					// 计划台次
	set SeqType=operSchedule.SeqType					// 台次类型(正常台，连台)
	set SeqTypeDesc=##class(CIS.AN.OperSchedule).SeqTypeLogicalToDisplay(operSchedule.SeqType)
	
	set PrevDiagnosis=operSchedule.PrevDiagnosis		// 术前诊断
	set PostDiagnosis=operSchedule.PostDiagnosis		// 术后诊断
	set planOperData=..GetPlanOperList(opsId,.planOperData)		// 拟施手术
	set PlanOperDesc=planOperData(1,"OperationDesc")			// 拟施手术名称
	set PlanOperNote=planOperData(1,"OperNote")					// 拟施手术名称备注
	set PlanSurgeonDesc=planOperData(1,"SurgeonDesc")			// 拟施手术医生姓名
	set PlanAsstDesc=planOperData(1,"AssistantDesc")			// 拟施手术助手姓名
	Set PlanFirstAsstDesc=$p(PlanAsstDesc,",",1)				// 拟施手术一助姓名
	set PlanSurgeonExpert=planOperData(1,"SurgeonExpert")		// 拟施手术专家主刀
	set BodySite=operSchedule.BodySite							// 手术部位
	set BodySiteDesc=..GetBodySiteDesc(BodySite)				// 手术部位名称
	set OperPosition=operSchedule.OperPosition					// 手术体位
	Set OperPositionDesc=..GetOperPosDesc(OperPosition)			// 手术体位名称
	set BladeType=operSchedule.BladeType
	set BladeTypeDesc=""
	set:(BladeType'="") BladeTypeDesc=operSchedule.BladeType.Description
	set SurIntership=operSchedule.SurIntership					// 实习进修人员
	set SurVisitors=operSchedule.SurVisitors					// 手术参观人员
	set operData=..GetOperList(opsId,.operData)					// 实施手术
	set OperDesc=operData(1,"OperationDesc")					// 实施手术名称
	set OperNote=operData(1,"OperNote")							// 实施手术名称备注
	set SurgeonDesc=operData(1,"SurgeonDesc")					// 实施手术医生姓名
	set AsstDesc=operData(1,"AssistantDesc")					// 实施手术助手姓名
	Set FirstAsstDesc=$p(AsstDesc,",",1)						// 实施手术一助姓名
	set SurgeonExpert=operData(1,"SurgeonExpert")				// 实施手术专家主刀
	set SurCareProv=SurgeonDesc
	set:AsstDesc'="" SurCareProv=SurgeonDesc_","_AsstDesc
	
	set SurgicalMaterials=operSchedule.SurgicalMaterials		// 手术要求  仪器器械
	set SpecialCondition=operSchedule.SpecialConditions			// 特殊情况
	set HighConsume=operSchedule.HighConsume					// 高值耗材
	set IsoOperation=operSchedule.IsoOperation					// 隔离手术
	set IsoOperationDesc=##class(CIS.AN.OperSchedule).IsoOperationLogicalToDisplay(operSchedule.IsoOperation)
	set ECC=operSchedule.ECC									// 体外循环
	set ECCDesc=##class(CIS.AN.OperSchedule).ECCLogicalToDisplay(operSchedule.ECC)
	set TransAutoBlood=operSchedule.TransAutoblood				// 自体血回输
	set TransAutoBloodDesc=##class(CIS.AN.OperSchedule).TransAutobloodLogicalToDisplay(operSchedule.TransAutoblood)
	set PrepareBlood=operSchedule.PrepareBlood					// 是否备血
	set PrepareBloodDesc=##class(CIS.AN.OperSchedule).PrepareBloodLogicalToDisplay(operSchedule.PrepareBlood)
	set InfectionOper=operSchedule.InfectionOper				// 感染手术
	set InfectionOperDesc=##class(CIS.AN.OperSchedule).InfectionOperLogicalToDisplay(operSchedule.InfectionOper)
	set MIS=operSchedule.MIS									// 微创手术
	set MISDesc=$CASE(MIS,"Y":"是","N":"否",:"")
	set Antibiosis=operSchedule.Antibiosis						// 使用抗生素
	set AntibiosisDesc=##class(CIS.AN.OperSchedule).AntibiosisLogicalToDisplay(operSchedule.Antibiosis)
	set OperRequirement=..GetOperRequirement(opsId)				// 手术要求信息
	
	set BloodType=operSchedule.BloodType						// 检验信息 ABO血型
	set BloodTypeDesc=##class(CIS.AN.OperSchedule).BloodTypeLogicalToDisplay(operSchedule.BloodType)
	set RHType=operSchedule.RHBloodType							// RH血型
	set RHBloodTypeDesc=##class(CIS.AN.OperSchedule).RHBloodTypeLogicalToDisplay(operSchedule.RHBloodType)
	set HbsAg=operSchedule.HbsAg								// 乙肝表面抗原
	set HbsAgDesc=##class(CIS.AN.OperSchedule).HbsAgLogicalToDisplay(operSchedule.HbsAg)
	set HcvAb=operSchedule.HcvAb								// 丙肝抗体
	set HcvAbDesc=##class(CIS.AN.OperSchedule).HcvAbLogicalToDisplay(operSchedule.HcvAb)
	set HivAb=operSchedule.HivAb								// 艾滋病抗体
	set HivAbDesc=##class(CIS.AN.OperSchedule).HivAbLogicalToDisplay(operSchedule.HivAb)
	set Syphilis=operSchedule.Syphilis							// 梅毒
	set SyphilisDesc=##class(CIS.AN.OperSchedule).SyphilisLogicalToDisplay(operSchedule.Syphilis)
	
	// 手术排班信息
	set OperRoom="",RoomDesc="",RoomCode=""						// 手术间
	if (operSchedule.OperRoom'="")
	{
		set OperRoom=operSchedule.OperRoom.%Id()				// 手术间ID
		set RoomDesc=operSchedule.OperRoom.Description			// 手术间名称
		set RoomCode=operSchedule.OperRoom.Code					// 手术间代码
	}
	set OperSeq=operSchedule.OperSeq							// 手术台次
	set ScrubNurse=operSchedule.ScrubNurse						// 器械护士，多个护士以","拼接
	set ScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ScrubNurse)		// 器械护士姓名
	set FirstScrubNurse=$p(ScrubNurse,",",1),FirstScrubNurseDesc=$p(ScrubNurseDesc,",",1)
	set SecScrubNurse=$p(ScrubNurse,",",2),SecScrubNurseDesc=$p(ScrubNurseDesc,",",2)
	set CircualNurse=operSchedule.CircualNurse					// 巡回护士，多个护士以","拼接
	set CircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(CircualNurse)	// 巡回护士姓名
	set FirstCircualNurse=$p(CircualNurse,",",1),FirstCircualNurseDesc=$p(CircualNurseDesc,",",1)
	set SecCircualNurse=$p(CircualNurse,",",2),SecCircualNurseDesc=$p(CircualNurseDesc,",",2)
	set InternshipNurse=""  //operSchedule.InternshipNurse			// 实习护士
	
	// 麻醉信息
	set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	set TheatreInDT=anaestObj.GetValue("TheatreInDT")			// 入手术间时间
	set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")			// 离手术间时间
	if TheatreInDT'="" set AreaInOutTime=TheatreInDT_"~"_TheatreOutDT
	else  set AreaInOutTime=""
	
	set OperStartDT=anaestObj.GetValue("OperStartDT")			// 手术开始时间
	set OperFinishDT=anaestObj.GetValue("OperFinishDT")			// 手术结束时间
	set AnaStartDT=anaestObj.GetValue("AnaStartDT")				// 麻醉开始时间
	set AnaTime=AnaStartDT
	set AnaFinishDT=anaestObj.GetValue("AnaFinishDT")			// 麻醉结束时间
	set TubeInDT=anaestObj.GetValue("TubeInDT")					// 插管时间
	set TubeOutDT=anaestObj.GetValue("TubeOutDT")				// 拔管时间
	set AreaInDT=anaestObj.GetValue("AreaInDT")					// 入手术室时间
	set AreaOutDT=anaestObj.GetValue("AreaOutDT")				// 离手术室时间
	
	set PACUInDT=anaestObj.GetValue("PACUInDT")					// 入PACU时间
	set PACUOutDT=anaestObj.GetValue("PACUOutDT")				// 离PACU时间
	set OperDateTime=OperStartDT								// 手术开始时间
	set:(OperDateTime="") OperDateTime=OperDate_" "_OperTime
	set PACUDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(PACUInDT,PACUOutDT,"H")
	set ROperDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(OperStartDT,OperFinishDT,"H")
	set WaitDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(TheatreInDT,AnaStartDT,"M")	
	set AnaestID=anaestObj.GetValue("RowId")					// 麻醉申请ID
	set AnaMethod=anaestObj.GetValue("AnaMethod")				// 麻醉方法ID
	set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByID("CT.AN.AnaMethod","Description",AnaMethod)	// 麻醉方法名称
	set ArrAnaMethod=anaestObj.GetValue("ArrAnaMethod")				// 排班麻醉方法ID
	set ArrAnaMethodDesc=##class(CIS.AN.COM.String).GetDescByID("CT.AN.AnaMethod","Description",ArrAnaMethod)	// 麻醉方法名称
	set AnaExpert=anaestObj.GetValue("AnaExpert")				// 麻醉指导
	set AnaExpertDesc=anaestObj.GetValue("AnaExpertDesc")		// 麻醉指导姓名
	set ArrAnaExpert=anaestObj.GetValue("ArrAnaExpert")				// 排班麻醉指导
	set ArrAnaExpertDesc=anaestObj.GetValue("ArrAnaExpertDesc")		// 排班麻醉指导姓名
	
	set Anesthesiologist=anaestObj.GetValue("Anesthesiologist")	// 麻醉医生
	set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")		// 麻醉医生姓名
	set ArrAnesthesiologist=anaestObj.GetValue("ArrAnesthesiologist")	// 排班麻醉医生
	set ArrAnesthesiologistDesc=anaestObj.GetValue("ArrAnesthesiologistDesc")		// 排班麻醉医生姓名
	set AnaAssistant=anaestObj.GetValue("AnaAssistant")			// 麻醉助手
	set AnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnaAssistant)		// 麻醉助手姓名
	set ArrAnaAssistant=anaestObj.GetValue("ArrAnaAssistant")			// 排班麻醉助手
	set ArrAnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrAnaAssistant)		// 排班麻醉助手姓名
	set AnaStaff=anaestObj.GetValue("AnaStaff")					// 实习进修
	set ArrAnaStaff=anaestObj.GetValue("ArrAnaStaff")					// 排班实习进修
	set ASAClass=anaestObj.GetValue("ASAClass")					// ASA分级
	set ASAClassDesc=anaestObj.GetValue("ASAClassDesc")			// ASA分级描述
	set PreOperNote=anaestObj.GetValue("PreOperNote")			// 术前特殊情况
	set PreMedication=anaestObj.GetValue("PreMedication")		// 术前用药
	set PreFasting=anaestObj.GetValue("PreFasting")				// 术前禁食
	set PreFastingDesc=anaestObj.GetValue("PreFastingDesc")		// 术前禁食
	set TheatreOutTransLoc=anaestObj.GetValue("TheatreOutTransLoc")		// 离手术间去向代码
	set TheatreOutTransLocDesc=anaestObj.GetValue("TheatreOutTransLocDesc")		// 离手术间去向名称
	
	set careprovlist=""
	set:AnesthesiologistDesc'="" careprovlist=careprovlist_$lb(AnesthesiologistDesc)
	set:AnaExpertDesc'="" careprovlist=careprovlist_$lb(AnaExpertDesc)
	set:AnaAssistantDesc'="" careprovlist=careprovlist_$lb(AnaAssistantDesc)
	set:AnaStaff'="" careprovlist=careprovlist_$lb(AnaStaff)
	set AnaCareProv=$ListToString(careprovlist,",")
	
	set MainAnaesthesia=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set AppDateTime=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime)	// 手术申请日期时间
	
	set PatHeight=operSchedule.PatHeight
	set PatWeight=operSchedule.PatWeight
	set AnaestMethod=..GetAnaestMethod(opsId)
	
	set opaId=operSchedule.ExternalID
	
	// 获取排班信息
	set ArrOperRoom="",ArrRoomCode="",ArrRoomDesc="",ArrOperSeq="",ArrScrubNurse="",ArrScrubNurseDesc="",ArrCircualNurse="",ArrCircualNurseDesc=""
	set:($IsObject(operSchedule.ArrOperRoom)) ArrOperRoom=operSchedule.ArrOperRoom.%Id(),ArrRoomDesc=operSchedule.ArrOperRoom.Description,ArrRoomCode=operSchedule.ArrOperRoom.Code
	set ArrOperSeq=operSchedule.ArrOperSeq
	set ArrScrubNurse=operSchedule.ArrScrubNurse
	set ArrScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrScrubNurse)
	set ArrCircualNurse=operSchedule.ArrCircualNurse
	set ArrCircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrCircualNurse)
	set ArrFirstScrubNurse=$p(ArrScrubNurse,",",1),ArrFirstScrubNurseDesc=$p(ArrScrubNurseDesc,",",1)
	set ArrSecScrubNurse=$p(ArrScrubNurse,",",2),ArrSecScrubNurseDesc=$p(ArrScrubNurseDesc,",",2)
	set ArrFirstCircualNurse=$p(ArrCircualNurse,",",1),ArrFirstCircualNurseDesc=$p(ArrCircualNurseDesc,",",1)
	set ArrSecCircualNurse=$p(ArrCircualNurse,",",2),ArrSecCircualNurseDesc=$p(ArrCircualNurseDesc,",",2)

	set MDROS=operSchedule.MDROS		// 多重耐药菌
	set MDROSDesc=$CASE(MDROS,"N":"未知","-":"阴性","+":"阳性",:"")
	set PACUBed="",PACUBedDesc=""
	set:operSchedule.PACUBed'="" PACUBed=operSchedule.PACUBed.%Id(),PACUBedDesc=operSchedule.PACUBed.Description
	
	
	set result=$lb(opsId,opsId,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,
				   PatientID, MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,
				   PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,
				   StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,
				   PrevAnaMethodDesc,PlanSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,
				   OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialCondition,HighConsume,
				   IsoOperation,ECC,TransAutoBlood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHType,
				   HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,
				   CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCircualNurse,FirstCircualNurseDesc,SecCircualNurse,
				   SecCircualNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,
				   AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,
				   Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,
				   InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,
				   PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,
				   ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,
				   opaId,
				   ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,
				   ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCircualNurse,ArrFirstCircualNurseDesc,ArrSecCircualNurse,ArrSecCircualNurseDesc,
				   MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,
				   ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,AsstDesc,AreaInOutTime,AnaTime)
	quit result
}

ClassMethod GetOperRequirement(opsId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operReq="",splitChar=","
	set:(operSchedule.IsoOperation="Y") operReq="隔离手术"
	if (operSchedule.ECC="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"体外循环手术"	
	}
	if (operSchedule.TransAutoblood="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"自体血回输"	
	}
	if (operSchedule.PrepareBlood="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"术前备血"	
	}
	if (operSchedule.InfectionOper="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"感染手术"	
	}
	if (operSchedule.MIS="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"微创手术"	
	}
	if (operSchedule.Antibiosis="Y")
	{
		set:(operReq'="") operReq=operReq_splitChar
		set operReq=operReq_"使用抗生素"	
	}
	quit operReq
}

/// Creator：      	ccq
/// CreatDate：    	2019年7月4日
/// Description： 	根据手术申请ID获取拟施手术名称
/// Table：        	CIS_AN.OperSchedule,CIS_AN.PlanOperList
/// Input:			opsId:手术申请ID
/// Return：        拟施手术信息json字符串
/// w ##class(CIS.AN.BL.OperScheduleList).GetPlanOperList("7")
ClassMethod GetPlanOperList(opsId As %String, planOperData As %String) As %String
{
	set operList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindPlanOperationList",opsId)
	set operIdStr="",operDescStr="",operNoteStr="",surgeonStr="",surgeonDescStr="",assistantStr="",assistantDescStr="",splitChar=",",mainSplitChar="&&&"
	set surgeonExpertStr="",surgeonList="",surgeonDescList="",assistantList="",assistantDescList=""
	
	for i=1:1:operList.Size
	{
		set operObj=operList.GetAt(i)
		set operId=operObj.GetValue("Operation")
		set:(operIdStr'="") operIdStr=operIdStr_splitChar
		set operIdStr=operIdStr_operId
		
		set operDesc=operObj.GetValue("OperationDesc")
		set:(operDescStr'="") operDescStr=operDescStr_splitChar
		set operDescStr=operDescStr_operDesc
		
		set operNote=operObj.GetValue("OperNote")
		set:(operNoteStr'="") operNoteStr=operNoteStr_splitChar
		set operNoteStr=operNoteStr_operNote
		
		set surgeon=operObj.GetValue("Surgeon")
		if (surgeonList="") 
		{
			set surgeonList=$lfs(surgeon,splitChar)	
		}
		else
		{
			set:($lf(surgeonList,surgeon)=0) $li(surgeonList,$ll(surgeonList)+1)=surgeon	
		}
		
		//set:(surgeonStr'="") surgeonStr=surgeonStr_splitChar
		//set surgeonStr=surgeonStr_surgeon
		
		set surgeonDesc=operObj.GetValue("SurgeonDesc") 	
		set:(surgeonDesc="") surgeonDesc=surgeon
		if (surgeonDescList="") 
		{
			set surgeonDescList=$lfs(surgeonDesc,splitChar)	
		}
		else
		{
			set:($lf(surgeonDescList,surgeonDesc)=0) $li(surgeonDescList,$ll(surgeonDescList)+1)=surgeonDesc	
		}
		//set:(surgeonDescStr'="") surgeonDescStr=surgeonDescStr_splitChar
		//set surgeonDescStr=surgeonDescStr_surgeonDesc
		
		set assistant=operObj.GetValue("Assistant")
		if (assistantList="") 
		{
			set assistantList=$lfs(assistant,splitChar)	
		}
		else
		{
			for j=1:1:$l(assistant,splitChar)
			{
				set curAssist=$p(assistant,splitChar,j)
				set:($lf(assistantList,curAssist)=0) $li(assistantList,$ll(assistantList)+1)=curAssist	
			}
				
		}
		//set:(assistantStr'="") assistantStr=assistantStr_splitChar
		//set assistantStr=assistantStr_assistant
		
		set assistantDesc=operObj.GetValue("AssistantDesc")
		if (assistantDescList="") 
		{
			set assistantDescList=$lfs(assistantDesc,splitChar)	
		}
		else
		{
			for k=1:1:$l(assistantDesc,splitChar)
			{
				set curAssistDesc=$p(assistantDesc,splitChar,k)
				set:($lf(assistantDescList,curAssistDesc)=0) $li(assistantDescList,$ll(assistantDescList)+1)=curAssistDesc	
			}
			
		}
		//set:(assistantDescStr'="") assistantDescStr=assistantDescStr_splitChar
		//set assistantDescStr=assistantDescStr_assistantDesc

		set surgeonExpert=operObj.GetValue("SurgeonExpert")
		set:(surgeonExpertStr'="") surgeonExpertStr=surgeonExpertStr_splitChar
		set surgeonExpertStr=surgeonExpertStr_surgeonExpert
	}
	
	k planOperData
	set planOperData(1,"OperSchedule")=opsId
	set planOperData(1,"Operation")=operIdStr
	set planOperData(1,"OperationDesc")=operDescStr
	set planOperData(1,"OperNote")=operNoteStr
	set planOperData(1,"Surgeon")=$lts(surgeonList,splitChar)				//surgeonStr
	set planOperData(1,"SurgeonDesc")=$lts(surgeonDescList,splitChar)								//surgeonDescStr
	set planOperData(1,"Assistant")=$lts(assistantList,splitChar) //assistantStr
	set planOperData(1,"AssistantDesc")=$lts(assistantDescList,splitChar) //assistantDescStr
	set planOperData(1,"SurgeonExpert")=surgeonExpertStr
	
	set result=##class(CIS.AN.COM.String).ToJson(.planOperData)
	quit result
}

/// Creator：      	ccq
/// CreatDate：    	2019年7月4日
/// Description： 	根据手术申请ID获取拟施手术名称
/// Table：        	CIS_AN.OperSchedule,CIS_AN.PlanOperList
/// Input:			opsId:手术申请ID
/// Return：        拟施手术信息json字符串
/// w ##class(CIS.AN.BL.OperScheduleList).GetPlanOperList("7")
ClassMethod GetOperList(opsId As %String, planOperData As %String) As %String
{
	set operList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
	set operIdStr="",operDescStr="",operNoteStr="",surgeonStr="",surgeonDescStr="",assistantStr="",assistantDescStr="",splitChar=",",mainSplitChar="&&&"
	set surgeonExpertStr="",surgeonList="",surgeonDescList="",assistantList="",assistantDescList=""
	for i=1:1:operList.Size
	{
		set operObj=operList.GetAt(i)
		set operId=operObj.GetValue("Operation")
		set:(operIdStr'="") operIdStr=operIdStr_splitChar
		set operIdStr=operIdStr_operId
		
		set operDesc=operObj.GetValue("OperationDesc")
		set:(operDescStr'="") operDescStr=operDescStr_splitChar
		set operDescStr=operDescStr_operDesc
		
		set operNote=operObj.GetValue("OperNote")
		set:(operNoteStr'="") operNoteStr=operNoteStr_splitChar
		set operNoteStr=operNoteStr_operNote
		
		set surgeon=operObj.GetValue("Surgeon")
		if (surgeonList="") 
		{
			set surgeonList=$lfs(surgeon,splitChar)	
		}
		else
		{
			set:($lf(surgeonList,surgeon)=0) $li(surgeonList,$ll(surgeonList)+1)=surgeon	
		}
		
		//set:(surgeonStr'="") surgeonStr=surgeonStr_splitChar
		//set surgeonStr=surgeonStr_surgeon
		
		set surgeonDesc=operObj.GetValue("SurgeonDesc") 	
		set:(surgeonDesc="") surgeonDesc=surgeon
		if (surgeonDescList="") 
		{
			set surgeonDescList=$lfs(surgeonDesc,splitChar)	
		}
		else
		{
			set:($lf(surgeonDescList,surgeonDesc)=0) $li(surgeonDescList,$ll(surgeonDescList)+1)=surgeonDesc	
		}
		//set:(surgeonDescStr'="") surgeonDescStr=surgeonDescStr_splitChar
		//set surgeonDescStr=surgeonDescStr_surgeonDesc
		
		set assistant=operObj.GetValue("Assistant")
		if (assistantList="") 
		{
			set assistantList=$lfs(assistant,splitChar)	
		}
		else
		{
			for j=1:1:$l(assistant,splitChar)
			{
				set curAssist=$p(assistant,splitChar,j)
				set:($lf(assistantList,curAssist)=0) $li(assistantList,$ll(assistantList)+1)=curAssist	
			}
				
		}
		//set:(assistantStr'="") assistantStr=assistantStr_splitChar
		//set assistantStr=assistantStr_assistant
		
		set assistantDesc=operObj.GetValue("AssistantDesc")
		if (assistantDescList="") 
		{
			set assistantDescList=$lfs(assistantDesc,splitChar)	
		}
		else
		{
			for k=1:1:$l(assistantDesc,splitChar)
			{
				set curAssistDesc=$p(assistantDesc,splitChar,k)
				set:($lf(assistantDescList,curAssistDesc)=0) $li(assistantDescList,$ll(assistantDescList)+1)=curAssistDesc	
			}
			
		}
		//set:(assistantDescStr'="") assistantDescStr=assistantDescStr_splitChar
		//set assistantDescStr=assistantDescStr_assistantDesc

		set surgeonExpert=operObj.GetValue("SurgeonExpert")
		set:(surgeonExpertStr'="") surgeonExpertStr=surgeonExpertStr_splitChar
		set surgeonExpertStr=surgeonExpertStr_surgeonExpert
	}
	
	k planOperData
	set planOperData(1,"OperSchedule")=opsId
	set planOperData(1,"Operation")=operIdStr
	set planOperData(1,"OperationDesc")=operDescStr
	set planOperData(1,"OperNote")=operNoteStr
	set planOperData(1,"Surgeon")=$lts(surgeonList,splitChar)				//surgeonStr
	set planOperData(1,"SurgeonDesc")=$lts(surgeonDescList,splitChar)								//surgeonDescStr
	set planOperData(1,"Assistant")=$lts(assistantList,splitChar) //assistantStr
	set planOperData(1,"AssistantDesc")=$lts(assistantDescList,splitChar) //assistantDescStr
	set planOperData(1,"SurgeonExpert")=surgeonExpertStr
	
	set result=##class(CIS.AN.COM.String).ToJson(.planOperData)
	quit result
}

/// Creator：      	yongyang
/// CreatDate：    	2020年2月6日
/// Description： 	根据手术申请ID获取麻醉方法名称（带有导管信息）
/// Table：        	CIS_AN.OperSchedule,CIS_AN.AnaestCatheter
/// Input:			opsId:手术申请ID
/// Return：        麻醉方法名称（带有导管信息）
/// w ##class(CIS.AN.BL.OperScheduleList).GetAnaestMethod("6")
ClassMethod GetAnaestMethod(opsId As %String) As %String
{
	set dataList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindAnaestCatheter",opsId)
	set result="",catheterInfo=""
	for i=1:1:dataList.Size
	{
		set dataObj=dataList.GetAt(i)
		set AnaMethodDesc=dataObj.GetValue("AnaMethodDesc")
		set CatheterDesc=dataObj.GetValue("CatheterDesc")
		set CatheterTypeDesc=dataObj.GetValue("CatheterTypeDesc")
		set CatheterDepthDesc=dataObj.GetValue("CatheterDepthDesc")
		set CatheterPathDesc=dataObj.GetValue("CatheterPathDesc")
		set CatheterToolDesc=dataObj.GetValue("CatheterToolDesc")
		set CatheterDirectionDesc=dataObj.GetValue("CatheterDirectionDesc")
		set PunctureSpaceDesc=dataObj.GetValue("PunctureSpaceDesc")
		set PositionMethodDesc=dataObj.GetValue("PositionMethodDesc")
		
		set catheterInfo=""
		set:CatheterDesc'="" catheterInfo=catheterInfo_$lb(CatheterDesc)
		set:CatheterTypeDesc'="" catheterInfo=catheterInfo_$lb(CatheterTypeDesc)
		set:CatheterDepthDesc'="" catheterInfo=catheterInfo_$lb(CatheterDepthDesc)
		set:CatheterPathDesc'="" catheterInfo=catheterInfo_$lb(CatheterPathDesc)
		set:CatheterToolDesc'="" catheterInfo=catheterInfo_$lb(CatheterToolDesc)
		set:CatheterDirectionDesc'="" catheterInfo=catheterInfo_$lb(CatheterDirectionDesc)
		set:PunctureSpaceDesc'="" catheterInfo=catheterInfo_$lb(PunctureSpaceDesc)
		set:PositionMethodDesc'="" catheterInfo=catheterInfo_$lb(PositionMethodDesc)
		
		if catheterInfo="" set result=result_$lb(AnaMethodDesc)
		else  set result=result_$lb(AnaMethodDesc_"("_$ListToString(catheterInfo,",")_")")
	}
	
	quit $ListToString(result,"+")
}

ClassMethod GetORAnaestID(opsId As %String) As %String
{
	set anaestID=""
	&sql(select ExtAnaestID into :anaestID from CIS_AN.OperSchedule where RowId=:opsId)
	quit anaestID
}

ClassMethod GetBodySiteDesc(bodySiteStr As %String) As %String
{
	set bodySiteDesc=""
	set count=$l(bodySiteStr,",")
	for i=1:1:count
	{
		set bodySiteID=$p(bodySiteStr,",",i)
		continue:(##class(CT.AN.BodySite).%ExistsId(bodySiteID)=0)
		set bodySiteObj=##class(CT.AN.BodySite).%OpenId(bodySiteID)
		set:(bodySiteDesc'="")&(bodySiteObj.Description'="") bodySiteDesc=bodySiteDesc_","
		set bodySiteDesc=bodySiteDesc_bodySiteObj.Description
	}	
	quit bodySiteDesc
}

ClassMethod GetOperPosDesc(operPosStr As %String) As %String
{
	set operPosDesc=""
	set count=$l(operPosStr,",")
	for i=1:1:count
	{
		set operPosID=$p(operPosStr,",",i)
		continue:(##class(CT.AN.OperPosition).%ExistsId(operPosID)=0)
		set operPosObj=##class(CT.AN.OperPosition).%OpenId(operPosID)
		set:(operPosDesc'="")&(operPosObj.Description'="") operPosDesc=operPosDesc_","
		set operPosDesc=operPosDesc_operPosObj.Description
	}	
	quit operPosDesc
}

/// Creator：      	陈长青
/// CreatDate：    	2018-12-14
/// Description： 	手术医生工作量统计
/// Table：        	
/// Input:			EpisodeID:就诊ID，locId:当前科室,surgeonDeptId:筛选手术室，filterSurgeonDept：筛选术者科室，filterSurgeon：筛选手术医生
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.WorkStatistics","FindOperNursekStatNew","2020-09-01","2020-09-30")
Query FindOperNursekStatNew(startDate As %String, endDate As %String) As %Query(ROWSPEC = "Nurse,NurseName,Count1,Count1Note,Count2,Count2Note,Count3,Count3Note,Count4,Count4Note,Count5,Count5Note")
{
}

ClassMethod FindOperNursekStatNewExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set indexNode="OPDate"
	kill operStatList
	
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			
			set theatreInTime=anaesthesia.TheatreInDT
			set theatreOutTime=anaesthesia.TheatreOutDT
			continue:(theatreInTime="")!(theatreOutTime="")
			
			set operDate=operSchedule.OperDate
			set medcareNo=##class(CIS.AN.BL.Admission).GetMedicareNo("",operSchedule.EpisodeID)
			set patName=operSchedule.PatName
			
			set scrubNurse=operSchedule.ScrubNurse
			set scrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(scrubNurse)		// 器械护士姓名
	
			set circualNurse=operSchedule.CircualNurse
			set circualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(circualNurse)		// 巡回护士姓名
			
			for ind=1:1:$l(scrubNurse,",")
			{
				set userId=$p(scrubNurse,",",ind)
				set userName=$p(scrubNurseDesc,",",ind)
				do AddIntoCache(userId,userName,"器械")
			}
			for ind=1:1:$l(scrubNurse,",")
			{
				set userId=$p(circualNurse,",",ind)
				set userName=$p(circualNurseDesc,",",ind)
				do AddIntoCache(userId,userName,"巡回")
			}
		}
	}
	
	set totalCount1=0,totalCount2=0,totalCount3=0,totalCount4=0,totalCount5=0
	set count1Note="",count2Note="",count3Note="",count4Note="",count5Note=""
	set nurse=""
	for
	{
		set nurse=$order(operStatList(nurse))
		quit:(nurse="")
	
		set nurseName=operStatList(nurse)
		set count1=0,count2=0,count3=0,count4=0,count5=0
		set count1Note="",count2Note="",count3Note="",count4Note="",count5Note=""
		set operDate=0
		for
		{
			set operDate=$order(operStatList(nurse,operDate))
			quit:(operDate="")
				
			set count=0,opsId=0,note=$zd(operDate,3)_":["
			for
			{
				set opsId=$order(operStatList(nurse,operDate,opsId))
				quit:(opsId="")
				set count=count+1
				set medcareNo=$lg(operStatList(nurse,operDate,opsId),1)
				set patName=$lg(operStatList(nurse,operDate,opsId),2)
				set role=$lg(operStatList(nurse,operDate,opsId),3)
				set note=note_" "_patName_" "_medcareNo_" "_role_";"
			}
			set note=note_"]"
			set:(count=1) count1=count1+1,totalCount1=totalCount1+1,count1Note=count1Note_"<br>"_note
			set:(count=2) count2=count2+1,totalCount2=totalCount2+1,count2Note=count2Note_"<br>"_note
			set:(count=3) count3=count3+1,totalCount3=totalCount3+1,count3Note=count3Note_"<br>"_note
			set:(count=4) count4=count4+1,totalCount4=totalCount4+1,count4Note=count4Note_"<br>"_note
			set:(count>=5) count5=count5+1,totalCount5=totalCount5+1,count5Note=count5Note_"<br>"_note
		}
		do OutputRow
	}
	
	
	do OutputSummary
	
	kill operStatList
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
AddIntoCache(userId,userName,role)
	if (userName'="") {
		set operStatList(userId)=userName
		set operStatList(userId,operDate,opsId)=$lb(medcareNo,patName,role)
	}
	
	quit
 	
OutputSummary
	set nurseName="台数合计"
	set count1=totalCount1
	set count2=totalCount2
	set count3=totalCount3
	set count4=totalCount4
	set count5=totalCount5
	do OutputRow
	
	quit
		
OutputRow
 	Set Data=$lb(nurse,nurseName,count1,count1Note,count2,count2Note,count3,count3Note,count4,count4Note,count5,count5Note)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOperNursekStatNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperNursekStatNewExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOperNursekStatNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperNursekStatNewExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2018-12-14
/// Description： 	获取医嘱项的接收科室
/// Table：        	
/// Input:			EpisodeID:就诊ID，locId:当前科室,arcimId:医嘱项ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.BLL.WorkStatistics","FindNurseWorkDetail","2018-12-01","2018-12-31","","")
Query FindDeptWork(startDate As %String, endDate As %String, filterNurse As %String = "", operDesc As %String = "") As %Query(ROWSPEC = "PatDept,Count,CountNote")
{
}

ClassMethod FindDeptWorkExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, filterNurse As %String = "", operDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		set qHandle=$lb(0,repid,0)
		quit $$$OK	
	}
	set indexNode="OPDate"
	kill operStatList
	
	set operListSet=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	for date=startDateH-1:1:endDateH
	{
		set dateStr=$zd(date,3)
		set Month=$e(dateStr,0,4)_"年"_$e(dateStr,6,7)_"月"
		set Day=$e(dateStr,9,10)
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:operSchedule.PatDeptID=""
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			
			set theatreInDateTime=anaesthesia.TheatreInDT
			set theatreOutDateTime=anaesthesia.TheatreOutDT
			continue:(theatreInDateTime="")!(theatreOutDateTime="")
			
			set theatreOutDate=$p(theatreOutDateTime," ",1)
			set theatreOutDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(theatreOutDate,"")
			continue:(theatreOutDateH<startDateH)||(theatreOutDateH>endDateH)
			
			continue:operSchedule.Status.Code="Stop" //停止的手术不进入统计
			
			set operDate=operSchedule.OperDate
			set medcareNo=##class(CIS.AN.BL.Admission).GetMedicareNo("",operSchedule.EpisodeID)
			set patName=operSchedule.PatName
			
			// 病人科室(申请手术时)
			set patDeptID=operSchedule.PatDeptID
			set patDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
	
			set operationNameStr="",surgeonNameList=""
			set sc=operListSet.Execute(opsId)
			while(operListSet.%Next())
			{
				set surgeon=operListSet.Get("Surgeon")
				set assistant=operListSet.Get("Assistant")
				set surgeonDept=operListSet.Get("SurgeonDeptID")
				set surgeonDesc=operListSet.Get("SurgeonDesc")
				set assistantDesc=operListSet.Get("AssistantDesc")
				set surgeonDeptDesc=operListSet.Get("SurgeonDeptDesc")
				set operNote=operListSet.Get("OperNote")
				set:(surgeon="") surgeon=surgeonDesc
				set:(surgeonDesc="") surgeonDesc=surgeon
				set surgeonDesc=$TR(surgeonDesc," ")
				
				set operationNameStr=operationNameStr_"+"_operNote
				set surgeonNameList=surgeonNameList_$lb(surgeonDesc)
			}
			
			continue:operationNameStr["停手术" //停止的手术不进入统计
			continue:(operDesc'="")&&((operationNameStr="")||(operationNameStr'[operDesc)) //手术名称匹配
			
			set operStatList(patDeptDesc)=patDeptDesc
			set operStatList(patDeptDesc,"Qty")=$g(operStatList(patDeptDesc,"Qty"))+1
		}
	}
	set patDeptId=""
	for
	{
		set patDeptId=$o(operStatList(patDeptId))
		quit:patDeptId=""
			
		set patDeptDesc=$g(operStatList(patDeptId))
		set count=$g(operStatList(patDeptDesc,"Qty")),note=""
			
		do OutputRow
	}
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutputRow
 	Set Data=$lb(patDeptDesc,count,note)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDeptWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDeptWorkExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindDeptWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDeptWorkExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-03-13
/// Description： 	开台时间（8点作为开始时间）
/// Table：        	DHCAN.Model.OperSchedule
/// Input:			1.startDate:开始日期，2.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.WorkStatistics","FirstOperTime","2020-03-01","2020-03-31")
Query FirstOperTime(startDate As %String, endDate As %String) As %Query(ROWSPEC = "WeekdayName,Time,RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,BodySite,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc") [ SqlProc ]
{
}

ClassMethod FirstOperTimeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set indexNode="OPDate"
	kill firstOperList
	
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:operSchedule.PatDeptID=""
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			
			set theatreInDateTime=anaesthesia.TheatreInDT
			set theatreOutDateTime=anaesthesia.TheatreOutDT
			continue:(theatreInDateTime="")&&(theatreOutDateTime="")
			
			set theatreInDate=$e(theatreInDateTime,1,10)
			set theatreInDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(theatreInDate,"")
			set theatreInTime=$e(theatreInDateTime,12,19)
			set theatreInTimeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(theatreInTime,"")

			continue:theatreInTimeH<21600
			continue:(theatreInDateH<startDateH)
			continue:(theatreInDateH=startDateH)&&(theatreInTimeH<21600)
			continue:(theatreInDateH>endDateH)&&(theatreInTimeH>=21600)
			
			set earliestOperTime=86399
			if $g(firstOperList(theatreInDateH,"Time"))'="" set earliestOperTime=firstOperList(theatreInDateH,"Time")
			if earliestOperTime>theatreInTimeH
			{
				set firstOperList(theatreInDateH,"Time")=theatreInTimeH
				set firstOperList(theatreInDateH)=opsId
			}
		}	
	}

	set date=""
	for
	{
		set date=$o(firstOperList(date))
		quit:date=""
		
		set weekday=$zd(date,10)
		continue:(weekday=0)||(weekday=6)  //周六日不算？
		
		set weekdayName=$s(weekday=1:"周一",weekday=2:"周二",weekday=3:"周三",weekday=4:"周四",weekday=5:"周五",weekday=6:"周六",weekday=0:"周日",1:"")
		
		set time=firstOperList(date,"Time")
		set time=$zt(time)
		set opsId=firstOperList(date)
		do OutputRow
	}

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	s ^CacheTemp(repid,ind)=$lb(weekdayName,time)_..GetOperSchedule(opsId)
	s ind=ind+1
	q
}

ClassMethod FirstOperTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FirstOperTimeExecute ]
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

ClassMethod FirstOperTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FirstOperTimeExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	雍阳
/// CreatDate：    	2019-1-8
/// Description： 	查询麻醉病人统计
/// Table：        	DHCAN.Model.Anaesthesia
/// Input:			1.startDate:开始日期，2.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.WorkStatistics","FindSoreAssess","2021-07-04","2021-07-08","")
Query FindSoreAssess(startDate As %String, endDate As %String, filterMedcareNo As %String = "") As %Query(ROWSPEC = "RowId,Date,PatDept,PatName,Gender,Age,MedcareNo,Operation,Surgeon,AnaDoctor,AssessNurseName,OperDuration,TheatreDuration,AnaestMethod,ScattTriggerResult,PreOperAssessmentResult,InOperAssessmentResult,PostOperAssessmentResult,NursingMeasures,VisitNurseName,PressureSore") [ SqlProc ]
{
}

ClassMethod FindSoreAssessExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, filterMedcareNo As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	
	set moduleCode="AN_OPS_011"
	set indexNode="OPDate"
	
	for date=startDateH:1:endDateH
	{
		set dateStr=$zd(date,3)
		set Month=$e(dateStr,0,4)_"年"_$e(dateStr,6,7)_"月"
		set Day=$e(dateStr,9,10)
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:operSchedule.PatDeptID=""
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			
			set theatreInDateTime=anaesthesia.TheatreInDT
			set theatreOutDateTime=anaesthesia.TheatreOutDT
			continue:(theatreInDateTime="")&&(theatreOutDateTime="")
		
			set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCodeNew(opsId,moduleCode,"")
			set signatureId=##class(CIS.AN.BL.Signature).GetSignId(recordSheetId,"AssessNurseSign")
			//continue:signatureId=""
			set assessNurse="",assessNurseName="",assessNurseUser="-"
			if signatureId'=""
			{
				set signature=##class(CIS.AN.Signature).%OpenId(signatureId)
				set assessNurse=signature.SignUser
				set assessNurseUser=assessNurse
				set assessNurseName=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",assessNurse)
			}
			
			set patDeptID=operSchedule.PatDeptID
			set patDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
		
			set PatName="",Gender="",Age="",MedcareNo=""
			set OperScheduleId=opsId
			set MedcareNo=""
			
			set patQuery=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindPatient")
			set sc=patQuery.Execute(operSchedule.EpisodeID)
			while(patQuery.%Next())
			{
				set PatName=patQuery.Get("PatName")
				set Gender=patQuery.Get("PatGender")
				set Age=patQuery.Get("PatAge")	
				set MedcareNo=patQuery.Get("MedcareNo")
			}
			
			continue:(filterMedcareNo'="")&&(MedcareNo'[filterMedcareNo)&&(PatName'[filterMedcareNo)
			
			set Operation=""
			
			set anaOperQuery=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
			set sc=anaOperQuery.Execute(opsId)
	
			set operationList="",surgeonList=""
			while(anaOperQuery.%Next())
			{
				set operationDesc=anaOperQuery.Get("OperationDesc")
				set operNote=anaOperQuery.Get("OperNote")
				set:operationDesc="" operationDesc=operNote
				set:operationDesc'="" operationList=operationList_$lb(operationDesc)
				
				set surgeon=anaOperQuery.Get("SurgeonDesc")
				set:surgeon'="" surgeonList=surgeonList_$lb(surgeon)
			}
			
			set operation=$ListToString(operationList,"+")
			set surgeon=$ListToString(surgeonList,",")
			set anaestMethod=..GetAnaestMethod(opsId)
			
			set anesthesiologist="",anesthesiologistDesc=""
			if (anaesthesia.Anesthesiologist'="")
			{
				set anesthesiologist=anaesthesia.Anesthesiologist
				set anesthesiologistDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anesthesiologist)
			}
			set:(anesthesiologistDesc="") anesthesiologistDesc=anesthesiologist
	
			set theatreDuration=$e(theatreInDateTime,12,19)_"~"_$e(theatreOutDateTime,12,19)
			
			set operStartDT=anaesthesia.OperStartDT
			set operEndDT=anaesthesia.OperFinishDT
			set operDuration=$e(operStartDT,12,19)_"~"_$e(operEndDT,12,19)
			
			set ScattTriggerResult=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,"ScattTriggerResult")
			set PreOperAssessmentResult=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,"PreOperAssessmentResult")
			set InOperAssessmentResult=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,"InOperAssessmentResult")
			set PostOperAssessmentResult=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,"PostOperAssessmentResult")
			
			set nursingMeasures=""
			set RelievePressure=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,"RelievePressure")
			set RelievePressureText=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,"RelievePressureText")
			set BasicNursing=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,"BasicNursing")
			set LocalProcessing=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,"LocalProcessing")
			set LocalProcessingText=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,"LocalProcessingText")
			set nursingMeasures="减轻压力: "_RelievePressure_" "_RelievePressureText_"<br>基础护理: "_BasicNursing_"<br>局部处理: "_LocalProcessing_" "_LocalProcessingText
			
			set signatureId=##class(CIS.AN.BL.Signature).GetSignId(recordSheetId,"VisitNurseSign")
			set visitNurseName=""
			set visitNurse=""
			if signatureId'=""
			{
				set signature=##class(CIS.AN.Signature).%OpenId(signatureId)
				set visitNurse=signature.SignUser
				set visitNurseName=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",visitNurse)
			}
			
			set PressureSore=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,moduleCode,"PressureSore")
			
			do restoreOutput
		}	
	}
	
	set date=""
	for
	{
		set date=$o(outputList(date))
		quit:date=""
		
		set assessNurseUser=""
		for
		{
			set assessNurseUser=$o(outputList(date,assessNurseUser))
			quit:assessNurseUser=""
			
			set opsId=""
			for
			{
				set opsId=$o(outputList(date,assessNurseUser,opsId))
				quit:opsId=""
				
				set data=outputList(date,assessNurseUser,opsId)
				do OutputRow
			}
		}
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK

restoreOutput
	set outputList(date,assessNurseUser,opsId)=$lb(opsId,dateStr,patDeptDesc,PatName,Gender,
								Age,MedcareNo,operation,surgeon,anesthesiologistDesc,
								assessNurseName,operDuration,theatreDuration,anaestMethod,ScattTriggerResult,
								PreOperAssessmentResult,InOperAssessmentResult,PostOperAssessmentResult,nursingMeasures,visitNurseName,
								PressureSore)
	quit

OutputRow
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

ClassMethod FindSoreAssessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSoreAssessExecute ]
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

ClassMethod FindSoreAssessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSoreAssessExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// Creator：      	陈长青
/// CreatDate：    	2018-12-14
/// Description： 	手术医生工作量统计
/// Table：        	
/// Input:			EpisodeID:就诊ID，locId:当前科室,filterOPDept:筛选手术室，filterSurgeonDept：筛选术者科室，filterSurgeon：筛选手术医生
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.WorkStatistics","FindSurgeonWorkStatNew","2021-01-01","2021-08-30","","IOP")
Query FindSurgeonWorkStatNew(startDate As %String, endDate As %String, filterSurgeonDept As %String = "", admType As %String = "", filterSurgeon As %String = "") As %Query(ROWSPEC = "DeptDesc,CareProvDesc,Count1,Count1Note,Count2,Count2Note,Count3,Count3Note,Count4,Count4Note,Count5,Count5Note,TotalCount")
{
}

ClassMethod FindSurgeonWorkStatNewExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, filterSurgeonDept As %String = "", admType As %String = "", filterSurgeon As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set indexNode="OPDate"
	kill operStatList,surgeonList
	
	set indexNode="OPDate"
	
	set operListSet=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			continue:operSchedule.PatDeptID=""
			
			set mainAnaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
			continue:mainAnaId=""
			
			set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(mainAnaId)
			set anesthesiologist=anaesthesia.Anesthesiologist
			
			set theatreInDateTime=anaesthesia.TheatreInDT
			set theatreOutDateTime=anaesthesia.TheatreOutDT
			continue:(theatreInDateTime="")!(theatreOutDateTime="")
			
			set opAdmType=operSchedule.OPAdmType
			
			// 病人科室(申请手术时)
			set patDeptID=operSchedule.PatDeptID
			set patDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
			
			set operationNameStr="",surgeonNameList="",operClassList=""
			set sc=operListSet.Execute(opsId)
			while(operListSet.%Next())
			{
				set surgeon=operListSet.Get("Surgeon")
				set assistant=operListSet.Get("Assistant")
				set surgeonDept=operListSet.Get("SurgeonDeptID")
				set surgeonDeptDesc=operListSet.Get("SurgeonDeptDesc")
				set surgeonDesc=operListSet.Get("SurgeonDesc")
				set assistantDesc=operListSet.Get("AssistantDesc")
				set surgeonDeptDesc=operListSet.Get("SurgeonDeptDesc")
				set operNote=operListSet.Get("OperNote")
				set operClass=operListSet.Get("OperClass")
				set operClassDesc=operListSet.Get("OperClassDesc")
				set:operClassDesc="" operClassDesc="NULL"
				
				set:(surgeon="") surgeon=surgeonDesc
				set:(surgeonDesc="") surgeonDesc=surgeon
				set surgeonDesc=$TR(surgeonDesc," ")
				
				set operationNameStr=operationNameStr_"+"_operNote
				set surgeonNameList=surgeonNameList_$lb(surgeonDesc)
				set operClassList=operClassList_$lb(operClass)
				
				if surgeonDesc'=""
				{
					set operStatList(surgeonDeptDesc)=surgeonDeptDesc
					set operStatList(surgeonDeptDesc,surgeonDesc)=surgeonDesc
					if '$d(operStatList(surgeonDeptDesc,surgeonDesc,operClassDesc,opsId))
					{
						set operStatList(surgeonDeptDesc,surgeonDesc,operClassDesc)=$g(operStatList(surgeonDeptDesc,surgeonDesc,operClassDesc))+1
					}
					set operStatList(surgeonDeptDesc,surgeonDesc,operClassDesc,opsId)=""
					
				}
			}
		}	
	}
	
	set summary1=0,summary2=0,summary3=0,summary4=0,summary5=0,summary=0
	set surgeonDept="",surgeonDeptDesc=""
	for
	{
		set totalCount1=0,totalCount2=0,totalCount3=0,totalCount4=0,totalCount5=0,count=0
		set surgeonDept=$order(operStatList(surgeonDept))
		quit:(surgeonDept="")
	
		set surgeonDeptDesc=surgeonDept	;$g(operStatList(surgeonDept))
		continue:((filterSurgeonDept'="")&&(surgeonDept'=filterSurgeonDept))
	
		set careProv="",careProvDesc=""
		for
		{
			set careProv=$order(operStatList(surgeonDept,careProv))
			quit:(careProv="")
			set careProvDesc=careProv
			continue:((filterSurgeon'="")&&(careProvDesc'=filterSurgeon))
			set count1=0,count2=0,count3=0,count4=0,count5=0
			set count1=+$g(operStatList(surgeonDept,careProv,"一级手术"))
			set count2=+$g(operStatList(surgeonDept,careProv,"二级手术"))
			set count3=+$g(operStatList(surgeonDept,careProv,"三级手术"))
			set count4=+$g(operStatList(surgeonDept,careProv,"四级手术"))
			set count5=+$g(operStatList(surgeonDept,careProv,"NULL"))
			// 单个医生所有级别相加
			set totalCount=count1+count2+count3+count4+count5
			
			// 单个科室单个级别相加
			set totalCount1=totalCount1+count1
			set totalCount2=totalCount2+count2
			set totalCount3=totalCount3+count3
			set totalCount4=totalCount4+count4
			set totalCount5=totalCount5+count5
			// 单个科室所有级别相加
			set count=count+totalCount
			
			// 所有科室单个级别数量相加
			set summary1=summary1+count1
			set summary2=summary2+count2
			set summary3=summary3+count3
			set summary4=summary4+count4
			set summary5=summary5+count5
			// 所有科室所有级别相加
			set summary=summary+totalCount
			do OutputRow
		}
		do OutputCount
	}
	do OutputSummary
	
	kill operStatList
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutputCount
	;set surgeonDeptDesc=""
	set careProvDesc="台数合计"
	set count1=totalCount1
	set count2=totalCount2
	set count3=totalCount3
	set count4=totalCount4
	set count5=totalCount5
	set totalCount=count
	do OutputRow
	quit

OutputSummary
	set surgeonDeptDesc=""
	set careProvDesc="总计"
	set count1=summary1
	set count2=summary2
	set count3=summary3
	set count4=summary4
	set count5=summary5
	set totalCount=summary
	do OutputRow
	quit
		
OutputRow
 	Set Data=$lb(surgeonDeptDesc,careProvDesc,count1,count1Note,count2,count2Note,count3,count3Note,count4,count4Note,count5,count5Note,totalCount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindSurgeonWorkStatNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurgeonWorkStatNewExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSurgeonWorkStatNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurgeonWorkStatNewExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator：      	夏宇
/// CreatDate：    	2023-1-5
/// Description： 	查询设备使用登记
/// Table：        	
/// Input:			1.startDate:开始日期，2.endDate:结束日期
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.WorkStatistics","FindEquipUsage","2022-11-01","2022-11-30","")
Query FindEquipUsage(startDate As %String, endDate As %String, EquipId As %String = "") As %Query(ROWSPEC = "OperDate,PatName,PatAge,PatDeptDesc,MedcareNo,OperDesc,SurCareProv,EquipDescription,RoomDesc,StartDT,EndDT,ScanUserDesc,UserTime") [ SqlProc ]
{
}

ClassMethod FindEquipUsageExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, EquipId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
	set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
	if (startDateH>endDateH)
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	set indexNode="OPDate"
	for date=startDateH:1:endDateH
	{
		set opsId=0
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
			quit:(opsId="")
			set operSchedule = ##class(CIS.AN.OperSchedule).%OpenId(opsId)
			// 获取患者信息
		    set EpisodeID=operSchedule.EpisodeID
		    set targetQuery="CIS.AN.BL.Admission:FindPatient"
		    if ##class(CIS.AN.BL.Admission).ExistsInstance(EpisodeID) set targetQuery="CIS.AN.BL.Admission:FindPatientNew"
		    set patInfoObj=##class(CIS.AN.COM.Query).ToObject(targetQuery,EpisodeID)
			set OperDate = $zd(date,3) //手术日期
			set PatName=patInfoObj.GetValue("PatName") //患者姓名
			set PatAge=patInfoObj.GetValue("PatAge")  
			set MedcareNo=patInfoObj.GetValue("MedcareNo") 
			set PatDeptID=operSchedule.PatDeptID
            set PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
            set operData=##class(CIS.AN.BL.OperScheduleList).GetOperList(opsId,.operData)                 // 实施手术 
            set OperDesc=operData(1,"OperationDesc")                    // 实施手术名称
		    set:(OperDesc="") OperDesc=operData(1,"Operation")
		    set SurgeonDesc=operData(1,"SurgeonDesc")                   // 实施手术医生姓名
		    set Surgeon=operData(1,"Surgeon")							// 实施手术医生Id
		    set AsstDesc=operData(1,"AssistantDesc")                    // 实施手术助手姓名
		    Set FirstAsstDesc=$p(AsstDesc,",",1)                        // 实施手术一助姓名
		    set SecAsstDesc=$p(AsstDesc,",",2)							// 实施手术二助姓名
		    set SurgeonExpert=operData(1,"SurgeonExpert")               // 实施手术专家主刀
		    set SurCareProv=SurgeonDesc
		    set:AsstDesc'="" SurCareProv=SurgeonDesc_","_AsstDesc
		    set RoomDesc = ""
		    if (operSchedule.OperRoom'="")
		    {
		        set RoomDesc=operSchedule.OperRoom.Description          // 手术间名称
		    }
			&sql(DECLARE EquipUsage CURSOR FOR select RowId into :RowId
		     from CIS_AN.EquipRecord 
		     where RecordSheet->OperSchedule->RowId=:opsId)
		    &sql(OPEN EquipUsage)
		    set result=""
		    For
		    {
		        &sql(FETCH EquipUsage)
		        quit:(SQLCODE'=0)
		        set:(result'="") result=result_","
		        set result=result_RowId 
		    }
		    &sql(CLOSE EquipUsage)
		    for EquipStri=1:1:$l(result,",")
		    {
			    set EquipRecordobj = ##class(CIS.AN.EquipRecord).%OpenId($p(result,",",EquipStri))
			    q:$p(result,",",EquipStri)=""
			    continue:(EquipId'="")&&(EquipId'=EquipRecordobj.Equip.%Id())
			    s EquipDescription = ""
			    set:(EquipRecordobj.Equip'="") EquipDescription = EquipRecordobj.Equip.EquipDesc
			    s StartDT = ""
			    s EndDT = ""
			    set:(EquipRecordobj.StartDate'="")&&(EquipRecordobj.StartTime'="") StartDT = $zd(EquipRecordobj.StartDate,3)_" "_$zt(EquipRecordobj.StartTime)
			    set:(EquipRecordobj.EndDate'="")&&(EquipRecordobj.EndTime'="") EndDT = $zd(EquipRecordobj.EndDate,3)_" "_$zt(EquipRecordobj.EndTime)
			    set ScanUser = EquipRecordobj.UpdateUser
			    set ScanUserDesc = ##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",ScanUser)
			    set:(StartDT'="")&&(EndDT'="") UserTime = ##class(CIS.AN.COM.DateTime).CalculateDuration(EquipRecordobj.StartDate,EquipRecordobj.StartTime,EquipRecordobj.EndDate,EquipRecordobj.EndTime,"M")
			  	d OutPutRow
		    }
		}
	}
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutPutRow
	s ^CacheTemp(repid,ind)=$lb(OperDate,PatName,PatAge,PatDeptDesc,MedcareNo,OperDesc,SurCareProv,EquipDescription,RoomDesc,StartDT,EndDT,ScanUserDesc,UserTime)
	s ind=ind+1
	q
}

ClassMethod FindEquipUsageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEquipUsageExecute ]
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

ClassMethod FindEquipUsageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSoreAssessExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

}
