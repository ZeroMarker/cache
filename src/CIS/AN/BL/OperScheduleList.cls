/// 手术列表业务类
Class CIS.AN.BL.OperScheduleList Extends %RegisteredObject
{

Parameter OPSRowSpec As %String = "RowId";

/// Creator：        陈长青
/// CreatDate：      2019-12-30
/// Description：    根据登记号获取手术申请ID
/// Table：          CIS_AN.OperSchedule
/// Input:          regNo - 登记号
/// Return：         手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByRegNo("0000000162")
ClassMethod GetOpsIdListByRegNo(regNo As %String) As %String
{
    set EpisodeList=##class(CIS.AN.BL.Admission).GetEpisodeListByRegNo(regNo)
    set result=..GetOpsIdListByAdm(EpisodeList)
    quit result
}

/// Creator：        陈长青
/// CreatDate：      2019-12-30
/// Description：    根据病案号获取手术申请ID
/// Table：          CIS_AN.OperSchedule
/// Input:          medcareNo - 病案号
/// Return：         手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByMedcareNo("24")
ClassMethod GetOpsIdListByMedcareNo(medcareNo As %String) As %String
{
    set EpisodeList=##class(CIS.AN.BL.Admission).GetEpisodeListByMedcareNo(medcareNo)
    set result=..GetOpsIdListByAdm(EpisodeList)
    quit result
}

/// Creator：        陈长青
/// CreatDate：      2019-12-30
/// Description：    根据就诊ID获取手术申请ID
/// Table：          CIS_AN.OperSchedule
/// Input:          EpisodeList - 就诊ID字符串，多个就诊ID以","拼接
///                 allStatusFlag - 全部手术状态标志，默认为N
/// Return：         手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm("24")
ClassMethod GetOpsIdListByAdm(EpisodeList As %String, allStatusFlag As %String = "N") As %String
{
    // 设定手术状态代码过滤条件
    // 正常情况查询状态有：申请、审核、接收、安排、入手术室(准备中)、入手术间(术中)、离手术间(术毕)、入恢复室(苏醒中)、离恢复室、离手术室、完成。
    // 如果allStatusFlag为Y，表示查询所有状态的手术申请ID
    set operStatusStr=",Application,Audit,Accept,Receive,Arrange,AreaIn,RoomIn,RoomOut,PACUIn,PACUOut,AreaOut,Finish,"
    &sql(DECLARE OPCursor CURSOR FOR select %ID into :RowId
     from CIS_AN.OperSchedule where (','_:EpisodeList_',') [ (STRING(',',EpisodeID,','))
     and (:operStatusStr [ (STRING(',',Status->Code,',')) or :allStatusFlag="Y"))
    &sql(OPEN OPCursor)
    set result=""
    For
    {
        &sql(FETCH OPCursor)
        quit:(SQLCODE'=0)
        set:(result'="") result=result_","
        set result=result_RowId 
    }
    &sql(CLOSE OPCursor)
    quit result
}

/// Creator：        陈长青
/// CreatDate：      2019-12-30
/// Description：    根据就诊ID获取手术申请ID
/// Table：          CIS_AN.OperSchedule
/// Input:          EpisodeList - 就诊ID字符串，多个就诊ID以","拼接
///                 allStatusFlag - 全部手术状态标志，默认为N
/// Return：         手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm("24")
ClassMethod GetOpaIdListByAdm(EpisodeList As %String, allStatusFlag As %String = "N") As %String
{
    // 设定手术状态代码过滤条件
    // 正常情况查询状态有：申请、审核、接收、安排、入手术室(准备中)、入手术间(术中)、离手术间(术毕)、入恢复室(苏醒中)、离恢复室、离手术室、完成。
    // 如果allStatusFlag为Y，表示查询所有状态的手术申请ID
    set operStatusStr=",Application,Audit,Accept,Arrange,AreaIn,RoomIn,RoomOut,PACUIn,PACUOut,AreaOut,Finish,"
    &sql(DECLARE OPACursor CURSOR FOR select ExternalID into :RowId
     from CIS_AN.OperSchedule where (','_:EpisodeList_',') [ (STRING(',',EpisodeID,','))
     and (:operStatusStr [ (STRING(',',Status->Code,',')) or :allStatusFlag="Y"))
    &sql(OPEN OPACursor)
    set result=""
    For
    {
        &sql(FETCH OPACursor)
        quit:(SQLCODE'=0)
        set:(result'="") result=result_","
        set result=result_RowId 
    }
    &sql(CLOSE OPACursor)
    quit result
}

/// Creator：        陈长青
/// CreatDate：      2017-1-9
/// Description：    查询手术计划列表
/// Table：          DHCAN.OperSchedule, DHCAN.AnaestOperation
/// Input:          1.startDate:开始日期，2.endDate:结束日期，3.userDeptID:用户科室ID，4.opsId:手术ID，5.appDeptID:申请科室ID
///                 6.patWardID:病人科室ID，7.operStatusID:手术状态ID，8.operRoomID:手术间ID，9.regNo:登记号，10.medcareNo:病案号
/// 					11:按申请日期查询，12：是否日间手术，13：是否门诊手术
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperScheduleList","FindOperScheduleList","2022-08-03","2022-08-20","162","","","","Application^Receive^Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish","","","","","","","")
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperScheduleList","FindOperScheduleList","2020-04-01","2020-07-16","93","","","","","","","","","N","N")
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperScheduleList","FindOperScheduleList","2020-07-09","2020-07-09","298","","","","Arrange^RoomIn^RoomOut^PACUIn^Finish^AreaOut^Stop","","0000000162","","N")
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperScheduleList","FindOperScheduleList","2021-10-20","2021-10-20","298","","","","Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish")
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperScheduleList","FindOperScheduleList","2021-06-02","2021-06-02","95","","95")
Query FindOperScheduleList(startDate As %String, endDate As %String, userDeptID As %String, opsId As %String = "", appDeptID As %String = "", patWardID As %String = "", operStatusID As %String = "", operRoomID As %String = "", regNo As %String = "", medcareNo As %String = "", byAppDate = "N", isDaySurgery As %String = "", isOutOper As %String = "", EMStatusID As %String = "", HospDr As %String = "") As %Query(ROWSPEC = "RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PrevDiagnosisDesc,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,PlanSecAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,SecAsstDesc,BodySite,OperClassDesc,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,ECGDoctor,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,PostDiagnosisDesc,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,TheatreInTime,AnestStartTime,OperStartTime,OperEndTime,AnestEndTime,TheatreOutTime,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,OPFeeFlag,OPFeeFlagDesc,ANFeeFlag,ANFeeFlagDesc,OperRiskAssessment,OperSafetyCheck,OperCount,AnaestConsent,PrevANVisit,PostANVisit,AnaestRecord,PACURecord,AnaestConclusion,MainPACURecordID,PACUDoctor,PACUDoctorDesc,PACUShiftDoctor,PACUShiftDoctorDesc,WardReceiveCareProv,CarriedTube,Complication,PostOperNote,PACUInSteward,PACUInStewardScore,PACUOutSteward,PACUOutStewardScore,AnaDept,AnaDeptDesc,PACUInTime,PACUOutTime,OperExecDeptID,OperExecDeptDesc,ArrOperTime,PACUInStewardConscious,PACUInStewardRespiration,PACUInStewardMotion,PACUOutStewardConscious,PACUOutStewardRespiration,PACUOutStewardMotion,LaborStartDT,LaborEndDT,LaborEndTransLoc,LaborEndTransLocDesc,StatCategory,StatCategoryDesc,StatSeq,SiteDepth,Endoscopy,ArrAnaNurse,ArrAnaNurseDesc,AnaNurse,AnaNurseDesc,AdmType,AdmTypeDesc,DrugAllergy,DrugAllergyNote,AppDocPhoneNo,Operation,EstimatedOperTime,ArrPrintFlag,Surgeon,PlanSurgeon,Hydrothorax,ScrubAssistant,CircualAssistant,OeoreID,NationDescLookUpRowID,IsCanDayOper,StandardCode,StandardDesc,VisitStatus,AppOrderItem,PostoperativeToICU,PostoperativeToICUDesc") [ SqlProc ]
{
}

ClassMethod FindOperScheduleListExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, userDeptID As %String, opsId As %String = "", appDeptID As %String = "", patWardID As %String = "", operStatusID As %String = "", operRoomID As %String = "", regNo As %String = "", medcareNo As %String = "", byAppDate = "N", isDaySurgery As %String = "", isOutOper As %String = "", EMStatusID As %String = "", HospDr As %String = "") As %Status
{
    
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
    if (##class(CIS.AN.OperSchedule).%ExistsId(opsId)=1)
    {
        do OutputRow
        s qHandle=$lb(0,repid,0)
        q $$$OK     
    }
    /// 登记号查询，不受日期影响
    if (regNo'="")
    {
        set opsIdStr=..GetOpsIdListByRegNo(regNo)
        if (opsIdStr'="")
        {
            set opsIdCount=$l(opsIdStr,",")
            for i=1:1:opsIdCount
            {
                set opsId=$p(opsIdStr,",",i)
                do:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=1) OutputRow
            }   
            s qHandle=$lb(0,repid,0)
            q $$$OK 
        }
    }
    
    /// 住院号查询，不受日期影响
    if (medcareNo'="")
    {
        set opsIdStr=..GetOpsIdListByMedcareNo(medcareNo)
        if (opsIdStr'="")
        {
        	set opsIdCount=$l(opsIdStr,",")
        	for i=1:1:opsIdCount
        	{
            	set opsId=$p(opsIdStr,",",i)
            	do:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=1) OutputRow
        	}   
        	s qHandle=$lb(0,repid,0)
        	q $$$OK 
        }
    }
    
    set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
    set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
    if (startDateH>endDateH)
    {
        s qHandle=$lb(0,repid,0)
        q $$$OK 
    }
    set indexNode="OPDate"
    set:(byAppDate="Y") indexNode="AppDate"
    set linkDeptStr=##class(CIS.AN.BL.Admission).GetLinkLocId(userDeptID)
    //  set EMStatusID=##class(CIS.AN.BL.AnaArrange).GetEMStatusCodeList()   //启用审核急诊手术配置时,可查询的急诊手术状态代码 YuanLin 20200515
    if (linkDeptStr="")
    {
        set linkDeptStr=userDeptID  
    }
    else
    {
        set linkDeptStr=linkDeptStr_"^"_userDeptID
    }
    
    
    kill operScheduleList
    set job=$j
    kill ^TMPOPS(job)
    for date=startDateH:1:endDateH
    {
        set opsId=0
        for
        {
            set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
            quit:(opsId="")
            set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
            set sourceType=operSchedule.SourceType
            //set operAppDeptId=operSchedule.AppDeptID.ExternalID
            set operAppDeptId=operSchedule.AppDeptID    //operSchedule.AppDeptID.%Id()
            //set operDeptId=operSchedule.OperDeptID.ExternalID
            set operDeptId=operSchedule.OperDeptID //operSchedule.OperDeptID.%Id()
            set anaDeptId=operSchedule.AnaDept
            //set:($isobject(operSchedule.AnaDept)) anaDeptId=operSchedule.AnaDept.%Id()
            set OperExecDeptID=operSchedule.OperExecDeptID  //日间预住院科室
            set hospId2=""
            set hospId1=$p($g(^CTLOC(operAppDeptId)),"^",22)
            set:operDeptId'="" hospId2=$p($g(^CTLOC(operDeptId)),"^",22)
            ;continue:(hospId1'=hospId2) //申请科室所在院区要与手术室院区保持一致
            
            set tmpDaySurgery=operSchedule.DaySurgery   ;202003+dyl
            s dayLocStr="",linkDayStr=""
            ;20200314+dyl日间手术不止登录科室起作用，与之相关联的科室也起作用
            i tmpDaySurgery="Y" s linkDayStr=operSchedule.OperExecDeptID
            //20211208+dyl+日间中心可以看关联科室的手术
      		s centerFlag="N",centerLocStr=""
       		//i userDeptID'="" s centerFlag=##class(web.DHCBL.CT.ORCDaySurgeryLoc).IsDaySurgeryLoc(userDeptID)
       		//s centerLocStr=##class(web.DHCBL.CT.ORCDaySurgeryLocLinkLoc).GetLinkLoc(userDeptID)
            
            if userDeptID'=""
            {
	            set centerFlag=##class(CIS.AN.SRV.DirectConn.Client.HISConn).IsDaySurgeryLoc(userDeptID)
            	set centerLocStr=##class(CIS.AN.SRV.DirectConn.Client.HISConn).GetLinkLoc(userDeptID)
            }
            
            //s linkDayStr=##class(CIS.AN.BL.DaySurgery).GetOutInLinkID(userDeptID)
            s linkDayStr=linkDeptStr_"^"_linkDayStr
            set flagAppLocSee=(("^"_linkDayStr_"^")'[("^"_operAppDeptId_"^"))
            set flagOpLocSee=(("^"_linkDayStr_"^")'[("^"_operDeptId_"^"))
            set flagAnLocSee=(("^"_linkDayStr_"^")'[("^"_anaDeptId_"^"))
            set flagPreLocSee=(("^"_linkDeptStr_"^")'[("^"_OperExecDeptID_"^"))
           
            set hospId3=$p($g(^CTLOC(+userDeptID)),"^",22)
            //20211208+dyl
			set centerLocSee=(("^"_centerLocStr_"^")'[("^"_OperExecDeptID_"^"))&(centerFlag="Y")
            ;continue:(userDeptID'="")&&(hospId2'=hospId3)
            continue:flagAppLocSee&flagPreLocSee&flagOpLocSee&flagAnLocSee&centerLocSee&(userDeptID'="")
            s linkAppStr=""
            i tmpDaySurgery="Y" s linkAppStr=OperExecDeptID
            i centerFlag="Y" s linkAppStr=OperExecDeptID_"^"_centerLocStr
            s linkAppStr=operAppDeptId_"^"_linkAppStr
            ;20200314+dyl日间手术不止申请科室起作用，与之相关联的科室也起作用
            s showOperFlag=(("^"_linkAppStr_"^")'[("^"_appDeptID_"^"))
            continue:(appDeptID'="")&showOperFlag

            continue:(patWardID'="")&(patWardID'=operSchedule.PatWardID)
            
            continue:(isDaySurgery="Y")&(tmpDaySurgery'=isDaySurgery)
            ;continue:(isDaySurgery="")&(tmpDaySurgery="Y")
            ;continue:(isDaySurgery="N")&(tmpDaySurgery="Y")
            set tmpOutOper=operSchedule.OPAdmType   ;202003+dyl
            continue:(isOutOper="Y")&(tmpOutOper'="OOP")
            continue:(isOutOper="")&(tmpOutOper="OOP")
            continue:(isOutOper="N")&(tmpOutOper="OOP")
            if (operSchedule.Status'="")
            {
                set StatusID=operSchedule.Status.%Id()
                set StatusCode=operSchedule.Status.Code
            }
            continue:(##class(CT.AN.OperStatus).%ExistsId(operStatusID))&(operStatusID'=StatusID)
            ;continue:("Decline^Cancel^Revoke^Stop"[StatusCode)&(operStatusID="")
            continue:(StatusCode="Cancel")&((userDeptID=operDeptId)!(userDeptID=anaDeptId))&(userDeptID'=operSchedule.AppDeptID)
            //急诊或者日间手术即使在配置择期手术需要审核后，也允许[申请]状态显示出来 YL 20220125
            if ((tmpDaySurgery="Y")&(operStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(operStatusID)=0)&(operStatusID'="Decline")) {
	            set operStatusID=operStatusID_"^Application"
            }
            if ((operSchedule.SourceType="E")&(operStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(operStatusID)=0)&(operStatusID'="Decline")) {
	            set operStatusID=operStatusID_"^Application"
            }
            continue:((operStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(operStatusID)=0))&(operStatusID'[StatusCode)
            
            set curOperRoomID="",curOperRoomDesc=""
            if (operSchedule.OperRoom'="")
            {
                set curOperRoomID=operSchedule.OperRoom.%Id()   
                set curOperRoomDesc=operSchedule.OperRoom.Description
            }
            continue:(operRoomID'="")&(operRoomID'=curOperRoomID)
            continue:(operSchedule.EpisodeID="")
            set thisRegNo=##class(CIS.AN.BL.Admission).GetRegNobyEpisodeID(operSchedule.EpisodeID)
            continue:(+regNo'=0)&(+thisRegNo'=+regNo)
            set EpisodeID=operSchedule.EpisodeID
            set targetQuery="CIS.AN.BL.Admission:FindPatient"
    		if ##class(CIS.AN.BL.Admission).ExistsInstance(operSchedule.EpisodeID) set targetQuery="CIS.AN.BL.Admission:FindPatientNew"
    		set patInfoObj=##class(CIS.AN.COM.Query).ToObject(targetQuery,operSchedule.EpisodeID)
            set PatName=patInfoObj.GetValue("PatName")
            
            continue:(regNo'="")&(+regNo=0)&(PatName'[regNo)
            set thisMedCareNo=##class(CIS.AN.BL.Admission).GetMedicareNo("",operSchedule.EpisodeID)
            continue:(medcareNo'="")&(medcareNo'=thisMedCareNo)
            set roomNode=curOperRoomDesc
            set:(roomNode="") roomNode="0"
            set operSeqNode=+operSchedule.OperSeq
            set:(operSeqNode=0) operSeqNode=99
            set ^TMPOPS(job,operSchedule.OperDate,roomNode,operSeqNode,+opsId)=""
            //do OutputRow
            
        }   
    }
    // 排序：按手术日期、手术间、手术台次升序排序
    set operDate=0
    for
    {
        set operDate=$o(^TMPOPS(job,operDate))
        quit:(operDate="")
        set operRoom=""
        for
        {
            set operRoom=$o(^TMPOPS(job,operDate,operRoom))
            quit:(operRoom="") 
            set operSeq=0
            for
            {
                set operSeq=$o(^TMPOPS(job,operDate,operRoom,operSeq))
                quit:(operSeq="")
                set opsId=0
                for
                {
                    set opsId=$o(^TMPOPS(job,operDate,operRoom,operSeq,opsId))
                    quit:(opsId="")
                    //w "roomNode="_operRoom,!
                    do OutputRow
                }
            }
        }   
    }
    s qHandle=$lb(0,repid,0)
    q $$$OK
OutputRow
	set dataCache=..GetOperSchedule(opsId,HospDr)
	set ^DHCANOperInfoCache(opsId)=dataCache
	set ^CacheTemp(repid,ind)=dataCache
	//以下不适用于HIS数据修改时重新获取数据
	/*
    if ($d(^DHCANOperInfoCache(opsId))>0)
    {
	    // 存在缓存数据
	    if ($d(^DHCANOPTriggerCache("OperSchedule",opsId))>0)
	    {
		    // 表中的数据发生改变: 获取数据并添加缓存
	    	set dataCache=..GetOperSchedule(opsId,HospDr)
	    	set ^DHCANOperInfoCache(opsId)=dataCache
	    	// 清除触发器记录
	    	kill ^DHCANOPTriggerCache("OperSchedule",opsId)
	    }
	    else
	    {
		    // 表中的数据未发生改变: 从缓存取数据
		    set dataCache=^DHCANOperInfoCache(opsId) 
	    }
	    
	    s ^CacheTemp(repid,ind)=dataCache
    }
    else
    {
	    // 不存在缓存数据:获取数据并添加缓存
	    set dataCache=..GetOperSchedule(opsId,HospDr)
	    set ^DHCANOperInfoCache(opsId)=dataCache
		s ^CacheTemp(repid,ind)=dataCache
    }
    */
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
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
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

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperScheduleList","FindDayOperScheduleList","2021-10-02","2021-11-02","N")
Query FindDayOperScheduleList(startDate As %String, endDate As %String, ifDayoper = "") As %Query(ROWSPEC = "RowId,OPSID,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,PatientID,MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,PrevAnaMethodDesc,PlanOperSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PrevDiagnosisDesc,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,PlanSecAsstDesc,OperDesc,OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,SecAsstDesc,BodySite,OperClassDesc,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialConditions,HighConsume,IsoOperation,ECC,TransAutoblood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHBloodType,HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCirNurse,FirstCirNurseDesc,SecCirNurse,SecCirNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,ECGDoctor,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,PostDiagnosisDesc,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,TheatreInTime,AnestStartTime,OperStartTime,OperEndTime,AnestEndTime,TheatreOutTime,OPAID,ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCirNurse,ArrFirstCirNurseDesc,ArrSecCirNurse,ArrSecCirNurseDesc,MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,OPFeeFlag,OPFeeFlagDesc,ANFeeFlag,ANFeeFlagDesc,OperRiskAssessment,OperSafetyCheck,OperCount,AnaestConsent,PrevANVisit,PostANVisit,AnaestRecord,PACURecord,AnaestConclusion,MainPACURecordID,PACUDoctor,PACUDoctorDesc,PACUShiftDoctor,PACUShiftDoctorDesc,WardReceiveCareProv,CarriedTube,Complication,PostOperNote,PACUInSteward,PACUInStewardScore,PACUOutSteward,PACUOutStewardScore,AnaDept,AnaDeptDesc,PACUInTime,PACUOutTime,OperExecDeptID,OperExecDeptDesc,ArrOperTime,PACUInStewardConscious,PACUInStewardRespiration,PACUInStewardMotion,PACUOutStewardConscious,PACUOutStewardRespiration,PACUOutStewardMotion,LaborStartDT,LaborEndDT,LaborEndTransLoc,LaborEndTransLocDesc,StatCategory,StatCategoryDesc,StatSeq,SiteDepth,Endoscopy,ArrAnaNurse,ArrAnaNurseDesc,AnaNurse,AnaNurseDesc,AdmType,AdmTypeDesc,DrugAllergy,DrugAllergyNote,AppDocPhoneNo,Operation,EstimatedOperTime,ArrPrintFlag,Surgeon,PlanSurgeon,Hydrothorax,ScrubAssistant,CircualAssistant") [ SqlProc ]
{
}

ClassMethod FindDayOperScheduleListExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, ifDayoper As %String) As %Status
{
    
    s repid=$i(^CacheTemp)
    i $g(ind)="" s ind=1
   
    set ifDayoper=ifDayoper
     set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
    set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
    if (startDateH>endDateH)
    {
        s qHandle=$lb(0,repid,0)
        q $$$OK 
    }
    set indexNode="OPDate"
    
    kill operScheduleList
    set job=$j
    kill ^TMPOPS(job)
    for date=startDateH:1:endDateH
    {
        set opsId=0
        for
        {
            set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
            quit:(opsId="")
            
            set planOperDataStr=..GetPlanOperList(opsId,.planOperData)     // 拟施手术
            set Operation=planOperData(1,"Operation") 
            continue:Operation=""     
            set ifdayoper=$p($g(^ORC("OPER",Operation)),"^",9)
            continue:ifdayoper'=ifDayoper
            set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
            set sourceType=operSchedule.SourceType
            //set operAppDeptId=operSchedule.AppDeptID.ExternalID
            set operAppDeptId=operSchedule.AppDeptID    //operSchedule.AppDeptID.%Id()
            //set operDeptId=operSchedule.OperDeptID.ExternalID
            set operDeptId=operSchedule.OperDeptID //operSchedule.OperDeptID.%Id()
            set anaDeptId=operSchedule.AnaDept
            //set:($isobject(operSchedule.AnaDept)) anaDeptId=operSchedule.AnaDept.%Id()
            set OperExecDeptID=operSchedule.OperExecDeptID  //日间预住院科室
            set hospId2=""
            ;set hospId1=$p($g(^CTLOC(operAppDeptId)),"^",22)
            ;set:operDeptId'="" hospId2=$p($g(^CTLOC(operDeptId)),"^",22)
            
            set tmpDaySurgery=operSchedule.DaySurgery   ;202003+dyl
            s dayLocStr="",linkDayStr=""
            ;20200314+dyl日间手术不止登录科室起作用，与之相关联的科室也起作用
            i tmpDaySurgery="Y" s linkDayStr=operSchedule.OperExecDeptID
            //s linkDayStr=##class(CIS.AN.BL.DaySurgery).GetOutInLinkID(userDeptID)
           
            ;set hospId3=$p($g(^CTLOC(+userDeptID)),"^",22)
            
            ;continue:(userDeptID'="")&&(hospId2'=hospId3)
            s linkAppStr=""
            ;i tmpDaySurgery="Y" s linkAppStr=OperExecDeptID
            ;s linkAppStr=appDeptID_"^"_linkAppStr
            ;20200314+dyl日间手术不止申请科室起作用，与之相关联的科室也起作用
            ;s showOperFlag=(("^"_appDeptID_"^")'[("^"_operAppDeptId_"^"))
            ;s showPreOperFlag=(("^"_appDeptID_"^")'[("^"_OperExecDeptID_"^"))
            set tmpOutOper=operSchedule.OPAdmType   ;202003+dyl
            if (operSchedule.Status'="")
            {
                set StatusID=operSchedule.Status.%Id()
                set StatusCode=operSchedule.Status.Code
            }
            ;b
            set curOperRoomID="",curOperRoomDesc=""
            if (operSchedule.OperRoom'="")
            {
                set curOperRoomID=operSchedule.OperRoom.%Id()   
                set curOperRoomDesc=operSchedule.OperRoom.Description
            }
            set thisRegNo=##class(CIS.AN.BL.Admission).GetRegNobyEpisodeID(operSchedule.EpisodeID)
            
            set targetQuery="CIS.AN.BL.Admission:FindPatient"
    		if ##class(CIS.AN.BL.Admission).ExistsInstance(operSchedule.EpisodeID) set targetQuery="CIS.AN.BL.Admission:FindPatientNew"
    		set patInfoObj=##class(CIS.AN.COM.Query).ToObject(targetQuery,operSchedule.EpisodeID)
            set PatName=patInfoObj.GetValue("PatName")
            
            set thisMedCareNo=##class(CIS.AN.BL.Admission).GetMedicareNo("",operSchedule.EpisodeID)
            set roomNode=curOperRoomDesc
            set:(roomNode="") roomNode="第99间"
            set operSeqNode=+operSchedule.OperSeq
            set:(operSeqNode=0) operSeqNode=99
            set ^TMPOPS(job,operSchedule.OperDate,roomNode,operSeqNode,+opsId)=""
            //do OutputRow
            //b //1
        }   
    }
    
    // 排序：按手术日期、手术间、手术台次升序排序
    set operDate=0
    for
    {
		set operDate=$o(^TMPOPS(job,operDate))
        quit:(operDate="")
        set operRoom=""
        for
        {
            set operRoom=$o(^TMPOPS(job,operDate,operRoom))
            quit:(operRoom="")  
            set operSeq=0
            for
            {
                set operSeq=$o(^TMPOPS(job,operDate,operRoom,operSeq))
                quit:(operSeq="")
                set opsId=0
                for
                {
                    set opsId=$o(^TMPOPS(job,operDate,operRoom,operSeq,opsId))
                    quit:(opsId="")
                    do OutDayputRow
                }
            }
        }    	
    }
    s qHandle=$lb(0,repid,0)
    q $$$OK
OutDayputRow
    //s ^CacheTemp(repid,ind)=..GetOperSchedule(opsId)
    s ^CacheTemp(repid,ind)=..GetOperSchedule(opsId)
    s ind=ind+1
    q
}

ClassMethod FindDayOperScheduleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDayOperScheduleListExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod FindDayOperScheduleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDayOperScheduleListExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// w ##class(CIS.AN.BL.OperScheduleList).GetOperSchedule(4)
ClassMethod GetOperSchedule(opsId As %String, HospDr As %String = "") As %List
{
	Set lang="20",sessionLang=""
	Set:($DATA(%session)) sessionLang=$GET(%session.Data("LOGON.LANGID"))
	Set:(sessionLang'="") lang=sessionLang
    set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    // 获取患者信息
    set EpisodeID=operSchedule.EpisodeID
    set ExtAnaestID=operSchedule.ExtAnaestID
    set targetQuery="CIS.AN.BL.Admission:FindPatient"
    if ##class(CIS.AN.BL.Admission).ExistsInstance(EpisodeID) set targetQuery="CIS.AN.BL.Admission:FindPatientNew"
    set patInfoObj=##class(CIS.AN.COM.Query).ToObject(targetQuery,EpisodeID)
    set PatName=patInfoObj.GetValue("PatName")
    set PatGender=patInfoObj.GetValue("PatGender")
	set PatGender=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatGender,lang)
    //set PatAge=patInfoObj.GetValue("PatAge")
    set PatDOB=patInfoObj.GetValue("PatDOB")
    set RegNo=patInfoObj.GetValue("RegNo")
    set MedcareNo=patInfoObj.GetValue("MedcareNo")
    set PatientID=patInfoObj.GetValue("PatientID") 
    set PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)
    set MRAdmID=patInfoObj.GetValue("MRAdmID")
    set AdmReason=patInfoObj.GetValue("AdmReason")
	set AdmReason=##class(User.PACAdmReason).GetTranByDesc("READesc",AdmReason,lang)
    set PatCardID=patInfoObj.GetValue("CardID")
    set AdmDateH=patInfoObj.GetValue("AdmDateH")
    set AdmType=patInfoObj.GetValue("AdmType")
    set NationDescLookUpRowID=patInfoObj.GetValue("NationDescLookUpRowID")
    if (AdmType="I")
    {
		set AdmTypeDesc="住院"    
	}
	if (AdmType="O")
	{
		set AdmTypeDesc="门诊"	
	}
    set Patient=PatName_(PatGender_" "_PatAge)          // 患者基本信息，格式为：张三(男 30岁)
    set PreopAdmDays=operSchedule.OperDate-AdmDateH     // 术前住院日
    
    // 手术申请信息
    set AppCareProvID=operSchedule.AppCareProvID        // 手术申请医护人员ID
    set AppCareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",operSchedule.AppCareProvID)
    set PatDeptID=operSchedule.PatDeptID
    set PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
    set PatDeptDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",PatDeptDesc,lang)
    set PatWardID=operSchedule.PatWardID
    set PatWardDesc=##class(CIS.AN.COM.String).GetDescByID("User.PACWard","WARDDesc",operSchedule.PatWardID)
    set PatWardDesc=##class(User.PACWard).GetTranByDesc("WARDDesc",PatWardDesc,lang)
    
    //set PatBedID=operSchedule.PatBedID
    //i PatBedID d
    	//.s PatBedID=patInfoObj.GetValue("PatBedID")
    //i PatBedCode="" d
    	//.s PatBedCode=patInfoObj.GetValue("PatBed")
    
	//床号从HIS取，患者中途可能会换床号
	set PatBedID="",PatBedCode=""
    set patObj=##class(User.PAAdm).%OpenId(EpisodeID)
    if (patObj.PAADMCurrentBedDR) {
	    set PatBedID=patObj.PAADMCurrentBedDR.%Id()
    	set PatBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",PatBedID)
    }
    set:(PatBedCode="") PatBedCode=operSchedule.PatBedID                // 一般HIS为第三方系统时，将床位代码直接存入PatBedID字段
    
    set WardBed=PatWardDesc_" "_PatBedCode
    
    set AppDeptID=operSchedule.AppDeptID                // 手术申请科室
    set AppDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AppDeptID)
    
    set OperDeptID=operSchedule.OperDeptID              // 手术室
    set OperDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperDeptID)
    
    set AnaDept=operSchedule.AnaDept                    // 麻醉科室
    set AnaDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
    
        //20200628
        set OperExecDeptID=operSchedule.OperExecDeptID              // 日间预住院科室
    set OperExecDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperExecDeptID)

    set AppUserID=operSchedule.AppUserID
    
    // 麻醉科
    set AnaDept=operSchedule.AnaDept
    set AnaDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
    
    set SourceType=operSchedule.SourceType              // 手术类型
    set SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
    
    set Status=operSchedule.Status.%Id()                // 手术状态ID
    set StatusDesc=operSchedule.Status.Description      // 手术状态名称
    set StatusColor=operSchedule.Status.BGColor         // 手术状态背景颜色
    set StatusCode=operSchedule.Status.Code             // 手术状态代码
    set StatusDesc=##class(CIS.AN.COM.String).GetTranslationByBDP("CT.AN.OperStatus","Description",StatusDesc)
    
    set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")           // 手术日期(计划)
    set DateFormat=$lg(^websys.ConfigurationD(1),10)
    if ((DateFormat="DMY")&&(OperDate'="")) set OperDate=$zd($zdh(OperDate,3),4)
    set OperTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.OperTime,"")           // 手术开始时间(计划)
    
    set OperDuration=operSchedule.OperDuration          // 手术持续时长(计划)
    set ReentryOperation=operSchedule.ReentryOperation  // 非计划重返手术
    set ReentryOperationDesc=##class(CIS.AN.OperSchedule).ReentryOperationLogicalToDisplay(operSchedule.ReentryOperation)
    set DaySurgery=operSchedule.DaySurgery  // 202002+dyl+日间手术
    set OPAdmType=operSchedule.OPAdmType    //202003+dyl+门诊手术
    set ComeHosTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.ComeHosTime,"")
    set PatPhoneNumber=operSchedule.PatPhoneNumber  //202003+dyl+门诊手术
    set PatNeedNotice=operSchedule.PatNeedNotice    //202003+dyl+门诊手术
    
    set Anaesthesia=operSchedule.Anaesthesia            // 是否麻醉科参与麻醉
    set AnaesthesiaDesc=##class(CIS.AN.OperSchedule).AnaesthesiaLogicalToDisplay(operSchedule.Anaesthesia)
    set PrevAnaMethod=operSchedule.PrevAnaMethod        // 拟施麻醉方法
    set PrevAnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",operSchedule.PrevAnaMethod,"+","Y")
    
    ;b ;PrevAnaMethod
    set PlanSeq=operSchedule.PlanSeq                    // 计划台次
    set SeqType=operSchedule.SeqType                    // 台次类型(正常台，连台)
    set SeqTypeDesc=##class(CIS.AN.OperSchedule).SeqTypeLogicalToDisplay(operSchedule.SeqType)
    
    set PrevDiagnosis=$tr(operSchedule.PrevDiagnosis,$c(4),"")      // 术前诊断
    //set PrevDiagnosisDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.MRCICDDx","MRCIDDesc",PrevDiagnosis,",","Y")        // 术前诊断描述
    set PrevDiagnosisDesc=..GetDiagnosisDesc(PrevDiagnosis)     // 术前诊断描述
    set:(PrevDiagnosisDesc="") PrevDiagnosisDesc=PrevDiagnosis
    if (PrevDiagnosis="")
    {
        set DiagnosisObj=##class(web.DHCANOPArrange).GetMainDiagnos(EpisodeID)
        set PrevDiagnosis=$p(DiagnosisObj,"!",2)
    }
    set PostDiagnosis=operSchedule.PostDiagnosis        // 术后诊断
    //set PostDiagnosisDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.MRCICDDx","MRCIDDesc",PostDiagnosis,",","Y")
    set PostDiagnosisDesc=..GetDiagnosisDesc(PostDiagnosis)
    set planOperDataStr=..GetPlanOperList(opsId,.planOperData)     // 拟施手术
    set PlanOperDesc=planOperData(1,"OperationDesc")            // 拟施手术名称
    set PlanOperDesc=##class(User.ORCOperation).GetTranByDesc("OPERDesc",PlanOperDesc,lang)
    set:(PlanOperDesc="") PlanOperDesc=planOperData(1,"Operation")
    set PlanOperNote=planOperData(1,"OperNote")                 // 拟施手术名称备注
    set:(PlanOperDesc="") PlanOperDesc=PlanOperNote
    set PlanSurgeonDesc=planOperData(1,"SurgeonDesc")           // 拟施手术医生姓名
    set PlanSurgeonDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",PlanSurgeonDesc,lang)
    set PlanSurgeon=planOperData(1,"Surgeon")					// 拟施手术医生Id
    set PlanAsstDesc=planOperData(1,"AssistantDesc")            // 拟施手术助手姓名
    set PlanAsstDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",PlanAsstDesc,lang)
    Set PlanFirstAsstDesc=$p(PlanAsstDesc,",",1)                // 拟施手术一助姓名
    Set PlanSecAsstDesc=$p(PlanAsstDesc,",",2)                	// 拟施手术二助姓名
    set PlanSurgeonExpert=planOperData(1,"SurgeonExpert")       // 拟施手术专家主刀
    //20220126
    set IsCanDayOper=..GetOperAnAuditData(operSchedule.ExternalID,"IsCanDayOper","AN_ANS_018")
    
    set operInfo=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
    set BodySite="",BodySiteDesc="",OperClassDesc=""
    for i=1:1:operInfo.Size
    {
        set operObj=operInfo.GetAt(i)
        set bodysite=operObj.GetValue("BodySite")
        set:(BodySite'="") BodySite=BodySite_","
        set BodySite=BodySite_bodysite                          // 手术部位
        set bodysitedesc=operObj.GetValue("BodySiteDesc")
        set:(BodySiteDesc'="") BodySiteDesc=BodySiteDesc_","
        set BodySiteDesc=BodySiteDesc_bodysitedesc              // 手术部位名称
        set OperClassDesc=operObj.GetValue("OperClassDesc")
    }
    set OperPosition=operSchedule.OperPosition                  // 手术体位
    Set OperPositionDesc=..GetOperPosDesc(OperPosition)         // 手术体位名称
    //set OperPositionDesc=##class(CIS.AN.COM.String).GetDescByID("User.ORCOperPosition","OPPOSDesc",OperPosition)
    set BladeType=operSchedule.BladeType
    set BladeTypeDesc=##class(CIS.AN.COM.String).GetDescByID("User.ORCBladeType","BLDTPDesc",BladeType)
    set SurIntership=operSchedule.SurIntership                  // 实习进修人员
    set SurVisitors=operSchedule.SurVisitors                    // 手术参观人员
    set operData=..GetOperList(opsId,.operData)                 // 实施手术
    set OperDesc=operData(1,"OperationDesc")                    // 实施手术名称
    set OperDesc=##class(User.ORCOperation).GetTranByDesc("OPERDesc",OperDesc,lang)
    set:(OperDesc="") OperDesc=operData(1,"Operation")
    set Operation=operData(1,"Operation")
    set OperNote=operData(1,"OperNote")                         // 实施手术名称备注
    set:(OperDesc="") OperDesc=OperNote
    set SurgeonDesc=operData(1,"SurgeonDesc")                   // 实施手术医生姓名
    set SurgeonDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",SurgeonDesc,lang)
    set Surgeon=operData(1,"Surgeon")							// 实施手术医生Id
    set AsstDesc=operData(1,"AssistantDesc")                    // 实施手术助手姓名
    Set FirstAsstDesc=$p(AsstDesc,",",1)                        // 实施手术一助姓名
    set SecAsstDesc=$p(AsstDesc,",",2)							// 实施手术二助姓名
    set SurgeonExpert=operData(1,"SurgeonExpert")               // 实施手术专家主刀
    set SurCareProv=SurgeonDesc
    set:AsstDesc'="" SurCareProv=SurgeonDesc_","_AsstDesc
    
    set SurgicalMaterials=operSchedule.SurgicalMaterials        // 手术要求  仪器器械
    set SpecialCondition=operSchedule.SpecialConditions         // 特殊情况
    set HighConsume=operSchedule.HighConsume                    // 高值耗材
    set IsoOperation=operSchedule.IsoOperation                  // 隔离手术
    set IsoOperationDesc=##class(CIS.AN.OperSchedule).IsoOperationLogicalToDisplay(operSchedule.IsoOperation)
    set ECC=operSchedule.ECC                                    // 体外循环
    set ECCDesc=##class(CIS.AN.OperSchedule).ECCLogicalToDisplay(operSchedule.ECC)
    set TransAutoBlood=operSchedule.TransAutoblood              // 自体血回输
    //set TransAutoBloodDesc=""
    set TransAutoBloodDesc=##class(CIS.AN.OperSchedule).TransAutobloodLogicalToDisplay(operSchedule.TransAutoblood)
    set PrepareBlood=operSchedule.PrepareBlood                  // 是否备血
    set PrepareBloodDesc=##class(CIS.AN.OperSchedule).PrepareBloodLogicalToDisplay(operSchedule.PrepareBlood)
    set OperRequirement=operSchedule.OperRequirement
    set InfectionOper=operSchedule.InfectionOper                // 感染手术
    //set InfectionOperDesc=##class(CIS.AN.OperSchedule).InfectionOperLogicalToDisplay(operSchedule.InfectionOper)
	set InfectionOperDesc=$CASE(InfectionOper,"Y":"是","N":"否",:"")
	set Antibiosis=operSchedule.Antibiosis
	set AntibiosisDesc=$CASE(Antibiosis,"Y":"是","N":"否",:"")
	set:((OperRequirement["感染手术")&&(InfectionOperDesc="")) InfectionOperDesc="是"
	set:(InfectionOperDesc="是") InfectionOper="Y" //双向
	set:((OperRequirement["使用抗菌药物")&&(AntibiosisDesc="")) AntibiosisDesc="是"
    set MIS=operSchedule.MIS                                    // 微创手术
    //set MISDesc=##class(CIS.AN.OperSchedule).MISLogicalToDisplay(operSchedule.MIS)
    set MISDesc=$CASE(MIS,"Y":"是","N":"否",:"")
    set OperRequirement=..GetOperRequirement(opsId)             // 手术要求信息
    
    set BloodType=operSchedule.BloodType                        // 检验信息 ABO血型
    set BloodTypeDesc=##class(CIS.AN.OperSchedule).BloodTypeLogicalToDisplay(operSchedule.BloodType)
    set RHType=operSchedule.RHBloodType                         // RH血型
    set RHBloodTypeDesc=##class(CIS.AN.OperSchedule).RHBloodTypeLogicalToDisplay(operSchedule.RHBloodType)
    set HbsAg=operSchedule.HbsAg                                // 乙肝表面抗原
    set HbsAgDesc=##class(CIS.AN.OperSchedule).HbsAgLogicalToDisplay(operSchedule.HbsAg)
    set HcvAb=operSchedule.HcvAb                                // 丙肝抗体
    set HcvAbDesc=##class(CIS.AN.OperSchedule).HcvAbLogicalToDisplay(operSchedule.HcvAb)
    set HivAb=operSchedule.HivAb                                // 艾滋病抗体
    set HivAbDesc=##class(CIS.AN.OperSchedule).HivAbLogicalToDisplay(operSchedule.HivAb)
    set Syphilis=operSchedule.Syphilis                          // 梅毒
    set SyphilisDesc=##class(CIS.AN.OperSchedule).SyphilisLogicalToDisplay(operSchedule.Syphilis)
    set Hydrothorax=operSchedule.Hydrothorax
    
    // 手术排班信息
    set OperRoom="",RoomDesc="",RoomCode=""                     // 手术间
    if (operSchedule.OperRoom'="")
    {
        set OperRoom=operSchedule.OperRoom.%Id()                // 手术间ID
        set RoomDesc=operSchedule.OperRoom.Description          // 手术间名称 
        set RoomCode=operSchedule.OperRoom.Code                 // 手术间代码
    	set RoomDesc=##class(CIS.AN.COM.String).GetTranslationByBDP("CF.AN.Location","Description",RoomDesc)
    }
    set OperSeq=operSchedule.OperSeq                            // 手术台次
    set ScrubNurse=operSchedule.ScrubNurse                      // 器械护士，多个护士以","拼接
    set ScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ScrubNurse)     // 器械护士姓名
    set FirstScrubNurse=$p(ScrubNurse,",",1),FirstScrubNurseDesc=$p(ScrubNurseDesc,",",1)
    set SecScrubNurse=$p(ScrubNurse,",",2),SecScrubNurseDesc=$p(ScrubNurseDesc,",",2)
    set CircualNurse=operSchedule.CircualNurse                  // 巡回护士，多个护士以","拼接
    set CircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(CircualNurse) // 巡回护士姓名
    set FirstCircualNurse=$p(CircualNurse,",",1),FirstCircualNurseDesc=$p(CircualNurseDesc,",",1)
    set SecCircualNurse=$p(CircualNurse,",",2),SecCircualNurseDesc=$p(CircualNurseDesc,",",2)
    set InternshipNurse=""  //operSchedule.InternshipNurse          // 实习护士
    Set ScrubAssistant="",CircualAssistant=""
    Set ScrubAssistantDr=operSchedule.ScrubAssistant
    Set:ScrubAssistantDr'="" ScrubAssistant=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ScrubAssistantDr)
    Set CircualAssistantDr=operSchedule.CircualAssistant
    Set:CircualAssistantDr'="" CircualAssistant=##class(CIS.AN.BL.OperationList).GetCareProvDesc(CircualAssistantDr)

    // 麻醉信息
    set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
    set TheatreInDT=anaestObj.GetValue("TheatreInDT")           // 入手术间时间
    set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")         // 离手术间时间
    
    //if TheatreInDT="" set TheatreInDT=operSchedule.TheatreInDT        // 术后登记中的入手术间时间
    //if TheatreOutDT="" set TheatreOutDT=operSchedule.TheatreOutDT   // 术后登记中的离手术间时间
    
    set OperStartDT=anaestObj.GetValue("OperStartDT")           // 手术开始时间
    set OperFinishDT=anaestObj.GetValue("OperFinishDT")         // 手术结束时间
    set AnaStartDT=anaestObj.GetValue("AnaStartDT")             // 麻醉开始时间
    set AnaFinishDT=anaestObj.GetValue("AnaFinishDT")           // 麻醉结束时间
    set TubeInDT=anaestObj.GetValue("TubeInDT")                 // 插管时间
    set TubeOutDT=anaestObj.GetValue("TubeOutDT")               // 拔管时间
    set AreaInDT=anaestObj.GetValue("AreaInDT")                 // 入手术室时间
    set AreaOutDT=anaestObj.GetValue("AreaOutDT")               // 离手术室时间
    set ECGDoctor=anaestObj.GetValue("ECGDoctor")               // 心电监护医生
    
    set TheatreInTime=""
    set AnestStartTime=""
    set OperStartTime=""
    set OperEndTime=""
    set AnestEndTime=""
    set TheatreOutTime=""
    
    set operStatusCode=""
    set:operSchedule.Status'="" operStatusCode=operSchedule.Status.Code
    if (operStatusCode'="RoomIn")
    {
        set TheatreInTime=$p(TheatreInDT," ",2)
        set AnestStartTime=$p(AnaStartDT," ",2)
        set OperStartTime=$p(OperStartDT," ",2)
        set OperEndTime=$p(OperFinishDT," ",2)
        set AnestEndTime=$p(AnaFinishDT," ",2)
        set TheatreOutTime=$p(TheatreOutDT," ",2)
    }
    else
    {
        kill keyTimeList
        do ..GetKeyTimeFromAnaData(opsId,.keyTimeList)
        set TheatreInTime=$p($g(keyTimeList("TheatreInTime"))," ",2)
        set AnestStartTime=$p($g(keyTimeList("AnestStartTime"))," ",2)
        set OperStartTime=$p($g(keyTimeList("OperStartTime"))," ",2)
        set OperEndTime=$p($g(keyTimeList("OperEndTime"))," ",2)
        set AnestEndTime=$p($g(keyTimeList("AnestEndTime"))," ",2)
        set TheatreOutTime=$p($g(keyTimeList("TheatreOutTime"))," ",2)
    }
    
    //if AreaInDT="" set AreaInDT=operSchedule.AreaInDT         // 术后登记中的入手术室时间
    //if AreaOutDT="" set AreaOutDT=operSchedule.AreaOutDT        // 术后登记中的离手术室时间
    
    set PACUInDT=anaestObj.GetValue("PACUInDT")                 // 入PACU时间
    set PACUOutDT=anaestObj.GetValue("PACUOutDT")               // 离PACU时间
    set PACUInTime=$p(PACUInDT," ",2)
    set PACUOutTime=$p(PACUOutDT," ",2)
    
    set OperDateTime=OperStartDT                                // 手术开始时间
    set:(OperDateTime="") OperDateTime=OperDate_" "_OperTime
    set PACUDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(PACUInDT,PACUOutDT,"H")
    set ROperDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(OperStartDT,OperFinishDT,"H")
    set WaitDuration=##class(CIS.AN.COM.DateTime).CalculateDurationS(TheatreInDT,AnaStartDT,"M")    
    set AnaestID=anaestObj.GetValue("RowId")                    // 麻醉申请ID
    set AnaMethod=anaestObj.GetValue("AnaMethod")               // 麻醉方法ID
    set AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod)
    set AnaMethodDesc=##class(User.ORCAnaestMethod).GetTranByDesc("ANMETDesc",AnaMethodDesc,lang)   // 麻醉方法名称
    set ArrAnaMethod=anaestObj.GetValue("ArrAnaMethod")             // 排班麻醉方法ID
    if (ArrAnaMethod="") set ArrAnaMethod=AnaMethod
    set ArrAnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",ArrAnaMethod) // 麻醉方法名称

    set AnaExpert=anaestObj.GetValue("AnaExpert")               // 麻醉指导
    set AnaExpertDesc=anaestObj.GetValue("AnaExpertDesc")       // 麻醉指导姓名
    set:(AnaExpert'="")&&(AnaExpertDesc="") AnaExpertDesc=AnaExpert
    set AnaExpertDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AnaExpertDesc,lang)
    set ArrAnaExpert=anaestObj.GetValue("ArrAnaExpert")             // 排班麻醉指导
    set ArrAnaExpertDesc=anaestObj.GetValue("ArrAnaExpertDesc")     // 排班麻醉指导姓名
    set:(ArrAnaExpert'="")&&(ArrAnaExpertDesc="") ArrAnaExpertDesc=ArrAnaExpert
    set ArrAnaExpertDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ArrAnaExpertDesc,lang)

    set Anesthesiologist=anaestObj.GetValue("Anesthesiologist") // 麻醉医生
    set AnesthesiologistDesc=anaestObj.GetValue("AnesthesiologistDesc")     // 麻醉医生姓名
    set:(Anesthesiologist'="")&&(AnesthesiologistDesc="") AnesthesiologistDesc=Anesthesiologist
    set AnesthesiologistDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AnesthesiologistDesc,lang)
    set ArrAnesthesiologist=anaestObj.GetValue("ArrAnesthesiologist")   // 排班麻醉医生
    set ArrAnesthesiologistDesc=anaestObj.GetValue("ArrAnesthesiologistDesc")       // 排班麻醉医生姓名
    set:(ArrAnesthesiologist'="")&&(ArrAnesthesiologistDesc="") ArrAnesthesiologistDesc=ArrAnesthesiologist
    set ArrAnesthesiologistDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ArrAnesthesiologistDesc,lang)
    set AnaAssistant=anaestObj.GetValue("AnaAssistant")         // 麻醉助手
    set AnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnaAssistant)     // 麻醉助手姓名
    set ArrAnaAssistant=anaestObj.GetValue("ArrAnaAssistant")           // 排班麻醉助手
    set ArrAnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrAnaAssistant)       // 排班麻醉助手姓名
    set AnaStaff=anaestObj.GetValue("AnaStaff")                 // 实习进修
    set ArrAnaStaff=anaestObj.GetValue("ArrAnaStaff")                   // 排班实习进修
    set ASAClass=anaestObj.GetValue("ASAClass")                 // ASA分级
    set ASAClassDesc=anaestObj.GetValue("ASAClassDesc")         // ASA分级描述
    set PreOperNote=anaestObj.GetValue("PreOperNote")           // 术前特殊情况
    set PreMedication=anaestObj.GetValue("PreMedication")       // 术前用药
    set PreFasting=anaestObj.GetValue("PreFasting")             // 术前禁食
    set PreFastingDesc=anaestObj.GetValue("PreFastingDesc")     // 术前禁食
    set TheatreOutTransLoc=anaestObj.GetValue("TheatreOutTransLoc")     // 离手术间去向代码
    set TheatreOutTransLocDesc=anaestObj.GetValue("TheatreOutTransLocDesc")     // 离手术间去向名称
    set LaborStartDT=anaestObj.GetValue("LaborStartDT")             // 无痛分娩开始监护时间
    set LaborEndDT=anaestObj.GetValue("LaborEndDT")                 // 无痛分娩结束监护时间
    set LaborEndTransLoc=anaestObj.GetValue("LaborEndTransLoc")     // 无痛分娩结束监护去向代码
    set LaborEndTransLocDesc=anaestObj.GetValue("LaborEndTransLocDesc")     // 无痛分娩结束监护去向名称
    
    set careprovlist=""
    set:AnesthesiologistDesc'="" careprovlist=careprovlist_$lb(AnesthesiologistDesc)
    set:AnaExpertDesc'="" careprovlist=careprovlist_$lb(AnaExpertDesc)
    set:AnaAssistantDesc'="" careprovlist=careprovlist_$lb(AnaAssistantDesc)
    set:AnaStaff'="" careprovlist=careprovlist_$lb(AnaStaff)
    set AnaCareProv=$ListToString(careprovlist,",")
    set AnaCareProv=##class(CIS.AN.BL.OperShift).CompleteCareProv(opsId,"A",AnaCareProv)
    
    set MainAnaesthesia=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
    set AppDateTime=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime)   // 手术申请日期时间
    
    set PatHeight=operSchedule.PatHeight
    set PatWeight=operSchedule.PatWeight
    set AnaestMethod=..GetAnaestMethod(opsId)
    
    set opaId=operSchedule.ExternalID

    // 获取排班信息
    set ArrOperRoom="",ArrRoomCode="",ArrRoomDesc="",ArrOperSeq="",ArrScrubNurse="",ArrScrubNurseDesc="",ArrCircualNurse="",ArrCircualNurseDesc="",ArrOperTime=""
    set:($IsObject(operSchedule.ArrOperRoom)) ArrOperRoom=operSchedule.ArrOperRoom.%Id(),ArrRoomDesc=operSchedule.ArrOperRoom.Description,ArrRoomCode=operSchedule.ArrOperRoom.Code
    set ArrOperSeq=operSchedule.ArrOperSeq
    set ArrScrubNurse=operSchedule.ArrScrubNurse
    set ArrOperTime=operSchedule.ArrOperTime
    set:(ArrOperTime'[":")&&(ArrOperTime'="") ArrOperTime=$zt(ArrOperTime,2)
    set ArrScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrScrubNurse)
    set ArrCircualNurse=operSchedule.ArrCircualNurse
    set ArrCircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrCircualNurse)
    set ArrFirstScrubNurse=$p(ArrScrubNurse,",",1),ArrFirstScrubNurseDesc=$p(ArrScrubNurseDesc,",",1)
    set ArrSecScrubNurse=$p(ArrScrubNurse,",",2),ArrSecScrubNurseDesc=$p(ArrScrubNurseDesc,",",2)
    set ArrFirstCircualNurse=$p(ArrCircualNurse,",",1),ArrFirstCircualNurseDesc=$p(ArrCircualNurseDesc,",",1)
    set ArrSecCircualNurse=$p(ArrCircualNurse,",",2),ArrSecCircualNurseDesc=$p(ArrCircualNurseDesc,",",2)
    set ArrAnaNurse=anaestObj.GetValue("ArrAnaNurse")
    set ArrAnaNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ArrAnaNurse)
    set AnaNurse=anaestObj.GetValue("AnaNurse")
    set AnaNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(AnaNurse)
    
    
    set MDROS=operSchedule.MDROS        // 多重耐药菌
    set MDROSDesc=$CASE(MDROS,"N":"未知","-":"阴性","+":"阳性",:"")
    //b ;3
    set PACUBed="",PACUBedDesc=""
    set:operSchedule.PACUBed'="" PACUBed=operSchedule.PACUBed.%Id(),PACUBedDesc=operSchedule.PACUBed.Description
    
    set OPFeeFlag=operSchedule.OPFeeFlag        // 手术费用审核标志
    set OPFeeFlagDesc=$CASE(OPFeeFlag,"N":"否","Y":"是",:"")
    //set OPFeeFlagDesc=##class(CIS.AN.OperSchedule).OPFeeFlagLogicalToDisplay(operSchedule.OPFeeFlag)
    set ANFeeFlag=operSchedule.ANFeeFlag        // 麻醉费用审核标志
    set ANFeeFlagDesc=$CASE(ANFeeFlag,"N":"否","Y":"是",:"")
    //set ANFeeFlagDesc=##class(CIS.AN.OperSchedule).ANFeeFlagLogicalToDisplay(operSchedule.ANFeeFlag)

    kill archiveArr
    do ##class(CIS.AN.BL.RecordSheet).GetArchiveList(opsId,.archiveArr)
    set OperRiskAssessment=$g(archiveArr("OperRiskAssessment"))
    set OperSafetyCheck=$g(archiveArr("OperSafetyCheck"))
    set OperCount=$g(archiveArr("OperCount"))
    set AnaestConsent=$g(archiveArr("AnaestConsent"))
    set PrevANVisit=$g(archiveArr("PrevANVisit"))
    set PostANVisit=$g(archiveArr("PostANVisit"))
    set AnaestRecord=$g(archiveArr("AnaestRecord"))
    set PACURecord=$g(archiveArr("PACURecord"))
    set AnaestConclusion=$g(archiveArr("AnaestConclusion"))
    
    set MainPACURecordID=##class(CIS.AN.BL.PACURecord).GetPACURecordId(opsId)
    
    set PACUDoctor="",PACUDoctorDesc="",PACUShiftDoctor="",PACUShiftDoctorDesc=""
    set WardReceiveCareProv="",CarriedTube="",Complication="",PostOperNote=""
    set PACUInSteward="",PACUOutSteward="",PACUInStewardScore="",PACUOutStewardScore=""
    set PACUInStewardConscious="",PACUInStewardRespiration="",PACUInStewardMotion=""
    set PACUOutStewardConscious="",PACUOutStewardRespiration="",PACUOutStewardMotion=""
    if MainPACURecordID'=""
    {
        set pacuRecordObj=##class(CIS.AN.PACURecord).%OpenId(MainPACURecordID)
        set PACUDoctor=pacuRecordObj.PACUDoctor
        set PACUDoctorDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",pacuRecordObj.PACUDoctor)
        set PACUShiftDoctor=pacuRecordObj.ShiftDoctor
        set PACUShiftDoctorDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",pacuRecordObj.ShiftDoctor)
        set WardReceiveCareProv=pacuRecordObj.WardReceiveCareProv
        set CarriedTube=pacuRecordObj.CarriedTube
        set Complication=pacuRecordObj.Complication
        set PostOperNote=pacuRecordObj.PostOperNote
        if pacuRecordObj.InSteward'=""
        {
            set PACUInSteward=pacuRecordObj.InSteward.%Id()
            set PACUInStewardScore=pacuRecordObj.InSteward.Score
            set PACUInStewardConscious=pacuRecordObj.InSteward.Conscious
            set PACUInStewardRespiration=pacuRecordObj.InSteward.Respiration
            set PACUInStewardMotion=pacuRecordObj.InSteward.Motion
        }
        if pacuRecordObj.OutSteward'=""
        {
            set PACUOutSteward=pacuRecordObj.OutSteward.%Id()
            set PACUOutStewardScore=pacuRecordObj.OutSteward.Score
            set PACUOutStewardConscious=pacuRecordObj.OutSteward.Conscious
            set PACUOutStewardRespiration=pacuRecordObj.OutSteward.Respiration
            set PACUOutStewardMotion=pacuRecordObj.OutSteward.Motion
        }
    }

    set StatCategory = operSchedule.StatCategory
    set StatCategoryDesc = ""
    &sql(select Description into :StatCategoryDesc from CT_AN.DictData where Dictionary->Code='OperStatCategory' and Code=:StatCategory)
    set StatSeq = operSchedule.StatSeq
    
    set SiteDepth = operSchedule.SiteDepth
    set Endoscopy = operSchedule.Endoscopy
    
    set DrugAllergy= operSchedule.DrugAllergy
    set DrugAllergyNote= operSchedule.DrugAllergyNote
    set AppDocPhoneNo= operSchedule.AppDocPhoneNo
    set EstimatedOperTime=operSchedule.EstimatedOperTime
    set:EstimatedOperTime'="" EstimatedOperTime=$zt(EstimatedOperTime,2)
	set ArrPrintFlag=operSchedule.ArrPrintFlag
	set ArrPrintFlag=$CASE(ArrPrintFlag,"Y":"是","N":"否",:"")
	
	Set arcimId="",ARCIMDesc="",orderDesc="",OeoreID=""
	set orderItemID=operSchedule.AppOrderItem
	set arcimId=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("AppArcim")
	set:arcimId'="" ARCIMDesc=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",2)
	set:orderItemID'="" orderDesc=^OEORD(+orderItemID,"I",$p(orderItemID,"||",2),"DEP",1)
	set:orderDesc'="" OeoreID=orderItemID_"，"_ARCIMDesc_""_orderDesc
	//新增国家医保编码及名称
	s StandardCode="",StandardDesc="",StdInfo=""
	i HospDr="" s HospDr=2
	s AdmResonDr=$p($g(^PAAdm(EpisodeID,1)),"^",7)
	//i Operation'="" s StdInfo=##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(Operation,HospDr,AdmResonDr,OperDate,1)
	try{
		i Operation'="" s StdInfo=##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(Operation,HospDr,AdmResonDr,OperDate,1)
	}catch(e){
	}
	s:StdInfo'="" StandardCode=$p(StdInfo,"^",1)
	s:StdInfo'="" StandardDesc=$p(StdInfo,"^",2)
	set PostoperativeToICU=operSchedule.PostoperativeToICU                // 术后入ICU
    set PostoperativeToICUDesc=$CASE(PostoperativeToICU,"Y":"是","N":"否",:"")
	//新增患者状态，判断是否出院
	set VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
    set result=$lb(opsId,opsId,EpisodeID,ExtAnaestID,PatName,PatGender,PatAge,PatDOB,RegNo,MedcareNo,
                   PatientID, MRAdmID,AdmReason,PatCardID,Patient,PatDeptID,PatDeptDesc,PatWardID,PatWardDesc,PatBedID,
                   PatBedCode,AppDeptID,AppDeptDesc,AppCareProvID,AppCareProvDesc,OperDeptID,OperDeptDesc,AnaDept,AnaDeptDesc,SourceType,SourceTypeDesc,Status,
                   StatusDesc,StatusColor,StatusCode,OperDate,OperTime,OperDuration,ReentryOperation,Anaesthesia,AnaesthesiaDesc,PrevAnaMethod,
                   PrevAnaMethodDesc,PlanSeq,PlanSeq,SeqType,SeqTypeDesc,PrevDiagnosis,PrevDiagnosisDesc,PlanOperDesc,PlanOperNote,PlanSurgeonDesc,PlanAsstDesc,PlanFirstAsstDesc,PlanSecAsstDesc,OperDesc,
                   OperNote,SurgeonDesc,AsstDesc,FirstAsstDesc,SecAsstDesc,BodySite,OperClassDesc,OperPosition,SurIntership,SurVisitors,SurgicalMaterials,SpecialCondition,HighConsume,
                   IsoOperation,ECC,TransAutoBlood,PrepareBlood,InfectionOper,MIS,Antibiosis,OperRequirement,BloodType,RHType,
                   HbsAg,HcvAb,HivAb,Syphilis,OperRoom,RoomDesc,RoomCode,OperSeq,ScrubNurse,ScrubNurseDesc,
                   CircualNurse,CircualNurseDesc,InternshipNurse,FirstScrubNurse,FirstScrubNurseDesc,SecScrubNurse,SecScrubNurseDesc,FirstCircualNurse,FirstCircualNurseDesc,SecCircualNurse,
                   SecCircualNurseDesc,WardBed,TheatreInDT,TheatreOutDT,OperStartDT,OperFinishDT,AnaStartDT,AnaFinishDT,TubeInDT,TubeOutDT,
                   AreaInDT,AreaOutDT,PACUInDT,PACUOutDT,ECGDoctor,OperDateTime,AnaestID,AnaMethod,AnaMethodDesc,AnaExpert,AnaExpertDesc,
                   Anesthesiologist,AnesthesiologistDesc,AnaAssistant,AnaAssistantDesc,AnaStaff,BodySiteDesc,OperPositionDesc,PreopAdmDays,PACUDuration,ROperDuration,WaitDuration,
                   InfectionOperDesc,AntibiosisDesc,MainAnaesthesia,AppDateTime,PostDiagnosis,PostDiagnosisDesc,BladeType,BladeTypeDesc,ASAClass,ASAClassDesc,PreOperNote,
                   PreMedication,PreFasting,PreFastingDesc,PatHeight,PatWeight,AnaestMethod,AnaCareProv,SurCareProv,
                   ReentryOperationDesc,IsoOperationDesc,ECCDesc,TransAutoBloodDesc,PrepareBloodDesc,MISDesc,BladeTypeDesc,RHBloodTypeDesc,HbsAgDesc,HcvAbDesc,HivAbDesc,SyphilisDesc,BloodTypeDesc,DaySurgery,
                   TheatreInTime,AnestStartTime,OperStartTime,OperEndTime,AnestEndTime,TheatreOutTime,opaId,
                   ArrOperRoom,ArrRoomCode,ArrRoomDesc,ArrOperSeq,ArrScrubNurse,ArrScrubNurseDesc,ArrCircualNurse,ArrCircualNurseDesc,
                   ArrFirstScrubNurse,ArrFirstScrubNurseDesc,ArrSecScrubNurse,ArrSecScrubNurseDesc,ArrFirstCircualNurse,ArrFirstCircualNurseDesc,ArrSecCircualNurse,ArrSecCircualNurseDesc,
                   MDROS,PlanSurgeonExpert,SurgeonExpert,TheatreOutTransLoc,TheatreOutTransLocDesc,OPAdmType,ComeHosTime,PatPhoneNumber,PatNeedNotice,AppUserID,
                   ArrAnaExpert,ArrAnaExpertDesc,ArrAnesthesiologist,ArrAnesthesiologistDesc,ArrAnaAssistant,ArrAnaAssistantDesc,ArrAnaStaff,ArrAnaMethod,ArrAnaMethodDesc,PACUBed,PACUBedDesc,MDROSDesc,
                   OPFeeFlag,OPFeeFlagDesc,ANFeeFlag,ANFeeFlagDesc,OperRiskAssessment,OperSafetyCheck,OperCount,AnaestConsent,PrevANVisit,PostANVisit,AnaestRecord,PACURecord,AnaestConclusion,
                   MainPACURecordID,PACUDoctor,PACUDoctorDesc,PACUShiftDoctor,PACUShiftDoctorDesc,WardReceiveCareProv,CarriedTube,Complication,PostOperNote,
                   PACUInSteward,PACUInStewardScore,PACUOutSteward,PACUOutStewardScore,
                   AnaDept,AnaDeptDesc,PACUInTime,PACUOutTime,OperExecDeptID,OperExecDeptDesc,ArrOperTime,
                   PACUInStewardConscious,PACUInStewardRespiration,PACUInStewardMotion,PACUOutStewardConscious,PACUOutStewardRespiration,PACUOutStewardMotion,
                   LaborStartDT,LaborEndDT,LaborEndTransLoc,LaborEndTransLocDesc,StatCategory,StatCategoryDesc,StatSeq,SiteDepth,Endoscopy,
                   ArrAnaNurse,ArrAnaNurseDesc,AnaNurse,AnaNurseDesc,AdmType,AdmTypeDesc,DrugAllergy,DrugAllergyNote,AppDocPhoneNo,Operation,
                   EstimatedOperTime,ArrPrintFlag,Surgeon,PlanSurgeon,Hydrothorax,ScrubAssistant,CircualAssistant,OeoreID,NationDescLookUpRowID,IsCanDayOper,StandardCode,StandardDesc,VisitStatus,orderItemID,PostoperativeToICU,PostoperativeToICUDesc)
    quit result
}

ClassMethod GetOperAnAuditData(opaId As %String, dataItem As %String, sheetcode As %String = "AN_ANS_018") As %String
{
	set operDataID="",operSheetId="",dataValue="",moduleId=""
	//获取排班id
	&sql(select RowId into :operDataID from CIS_AN.OperSchedule where  ExternalID=:opaId)
	i sheetcode'="" d //获取表单module
		.&sql(select RowId into :moduleId from CT_AN.DataModule where Code=:sheetcode)
		.;b	;1
		.&sql(select RowId into :operSheetId from CIS_AN.RecordSheet where OperSchedule=:operDataID and DataModule=:moduleId)
		.;b	;2
		.&sql(select DataValue into :dataValue from CIS_AN.OperData where RecordSheet=:operSheetId and DataItem=:dataItem)
	e  d
		.;b	;3
		.&sql(select RowId into :operSheetId from CIS_AN.RecordSheet where  OperSchedule=:operDataID)
		.;b	;4
		.&sql(select DataValue into :dataValue from CIS_AN.OperData where RecordSheet=:operSheetId and DataItem=:dataItem)

	quit dataValue
}

ClassMethod GetOperScheduleList(startDate As %String, endDate As %String, userDeptID As %String, opsId As %String = "", appDeptID As %String = "", patWardID As %String = "", operStatusID As %String = "", operRoomID As %String = "", regNo As %String = "", medcareNo As %String = "", byAppDate = "N", isDaySurgery As %String = "", isOutOper As %String = "", EMStatusID As %String = "") As %String
{
    k scheduleList
    /// 登记号查询，不受日期影响
    set rowCount=0
    if (regNo'="")
    {
	    // 自动补齐
	    set len=$L(regNo)
		for i=1:1:(10-len)
		{
			set regNo="0"_regNo
		}
        set opsIdStr=..GetOpsIdListByRegNo(regNo)
        quit:(opsIdStr="") "[]"
        w "{""rows"":["
        set opsIdCount=$l(opsIdStr,",")
        for i=1:1:opsIdCount
        {
            set opsId=$p(opsIdStr,",",i)
            set ret=..GetOperScheduleNew(opsId)
            w:(i'=opsIdCount) ret_","
            w:(i=opsIdCount) ret
            set rowCount=rowCount+1
        }   
        w "],""total"":"_rowCount_"}"
        q ""
    }
    
    /// 住院号查询，不受日期影响
    if (medcareNo'="")
    {
        set opsIdStr=..GetOpsIdListByMedcareNo(medcareNo)
        quit:(opsIdStr="") "[]"
        set opsIdCount=$l(opsIdStr,",")
        w "{""rows"":["
        for i=1:1:opsIdCount
        {
            set opsId=$p(opsIdStr,",",i)
            set ret=..GetOperScheduleNew(opsId)
            w:(i'=opsIdCount) ret_","
            w:(i=opsIdCount) ret
            set rowCount=rowCount+1
        }   
        w "],""total"":"_rowCount_"}"
        q ""    
    }
    
    set startDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate,"")
    set endDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate,"")
    set indexNode="OPDate"

    set linkDeptStr=##class(CIS.AN.BL.Admission).GetLinkLocId(userDeptID)
    //  set EMStatusID=##class(CIS.AN.BL.AnaArrange).GetEMStatusCodeList()   //启用审核急诊手术配置时,可查询的急诊手术状态代码 YuanLin 20200515
    if (linkDeptStr="")
    {
        set linkDeptStr=userDeptID  
    }
    else
    {
        set linkDeptStr=linkDeptStr_"^"_userDeptID
    }
    
    kill operScheduleList
    set job=$j
    kill ^TMPOPS(job)
    for date=startDateH:1:endDateH
    {
        set opsId=0
        for
        {
            set opsId=$order(^CIS.AN.OperScheduleI(indexNode,date,opsId))
            quit:(opsId="")
            set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
            
            set sourceType=operSchedule.SourceType
            //set operAppDeptId=operSchedule.AppDeptID.ExternalID
            set operAppDeptId=operSchedule.AppDeptID    //operSchedule.AppDeptID.%Id()
            //set operDeptId=operSchedule.OperDeptID.ExternalID
            set operDeptId=operSchedule.OperDeptID //operSchedule.OperDeptID.%Id()
            set anaDeptId=operSchedule.AnaDept
            //set:($isobject(operSchedule.AnaDept)) anaDeptId=operSchedule.AnaDept.%Id()
            set OperExecDeptID=operSchedule.OperExecDeptID  //日间预住院科室
            set hospId1=$p($g(^CTLOC(operAppDeptId)),"^",22)
            set hospId2=$p($g(^CTLOC(operDeptId)),"^",22)
            continue:(hospId1'=hospId2) //申请科室所在院区要与手术室院区保持一致
            
            set tmpDaySurgery=operSchedule.DaySurgery   ;202003+dyl
            s dayLocStr="",linkDayStr=""
            ;20200314+dyl日间手术不止登录科室起作用，与之相关联的科室也起作用
            i tmpDaySurgery="Y" s linkDayStr=operSchedule.OperExecDeptID
            //s linkDayStr=##class(CIS.AN.BL.DaySurgery).GetOutInLinkID(userDeptID)
            s linkDayStr=linkDeptStr_"^"_linkDayStr
            set flagAppLocSee=(("^"_linkDayStr_"^")'[("^"_operAppDeptId_"^"))
            set flagOpLocSee=(("^"_linkDayStr_"^")'[("^"_operDeptId_"^"))
            set flagAnLocSee=(("^"_linkDayStr_"^")'[("^"_anaDeptId_"^"))
            set flagPreLocSee=(("^"_linkDeptStr_"^")'[("^"_OperExecDeptID_"^"))
            set hospId3=$p($g(^CTLOC(+userDeptID)),"^",22)
            continue:(userDeptID'="")&&(hospId2'=hospId3)
            continue:flagAppLocSee&flagPreLocSee&flagOpLocSee&flagAnLocSee&(userDeptID'="")
            
            s linkAppStr=""
            i tmpDaySurgery="Y" s linkAppStr=OperExecDeptID
            s linkAppStr=appDeptID_"^"_linkAppStr
            ;20200314+dyl日间手术不止申请科室起作用，与之相关联的科室也起作用
            s showOperFlag=(("^"_appDeptID_"^")'[("^"_operAppDeptId_"^"))
            s showPreOperFlag=(("^"_appDeptID_"^")'[("^"_OperExecDeptID_"^"))
            continue:(appDeptID'="")&showOperFlag&showPreOperFlag
            ;(("^"_linkAppStr_"^")'[("^"_operSchedule.AppDeptID_"^"))
            
            ;continue:(appDeptID'="")&(appDeptID'=operSchedule.AppDeptID.%Id())
            continue:(patWardID'="")&(patWardID'=operSchedule.PatWardID)
            
            continue:(isDaySurgery="Y")&(tmpDaySurgery'=isDaySurgery)
            ;continue:(isDaySurgery="")&(tmpDaySurgery="Y")
            ;continue:(isDaySurgery="N")&(tmpDaySurgery="Y")
            set tmpOutOper=operSchedule.OPAdmType   ;202003+dyl
            continue:(isOutOper="Y")&(tmpOutOper'="OOP")
            continue:(isOutOper="")&(tmpOutOper="OOP")
            continue:(isOutOper="N")&(tmpOutOper="OOP")
            
            if (operSchedule.Status'="")
            {
                set StatusID=operSchedule.Status.%Id()
                set StatusCode=operSchedule.Status.Code
            }
            continue:(##class(CT.AN.OperStatus).%ExistsId(operStatusID))&(operStatusID'=StatusID)
            ;continue:("Decline^Cancel^Revoke^Stop"[StatusCode)&(operStatusID="")
            continue:(StatusCode="Cancel")&((userDeptID=operDeptId)!(userDeptID=anaDeptId))
            continue:(operSchedule.SourceType'="E")&(operStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(operStatusID)=0)&(operStatusID'[StatusCode)
            continue:(operSchedule.SourceType="E")&(EMStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(EMStatusID)=0)&(EMStatusID'[StatusCode)&(tmpOutOper'="OOP")
            
            //continue:(operSchedule.SourceType="E")&(EMStatusID="")&(operStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(operStatusID)=0)&(operStatusID'[StatusCode)
            //continue:(operStatusID'="")&(##class(CT.AN.OperStatus).%ExistsId(operStatusID)=0)&(operStatusID'[StatusCode)
            set curOperRoomID="",curOperRoomDesc=""
            if (operSchedule.OperRoom'="")
            {
                set curOperRoomID=operSchedule.OperRoom.%Id()   
                set curOperRoomDesc=operSchedule.OperRoom.Description
            }
            continue:(operRoomID'="")&(operRoomID'=curOperRoomID)
            set thisRegNo=##class(CIS.AN.BL.Admission).GetRegNobyEpisodeID(operSchedule.EpisodeID)
            continue:(+regNo'=0)&(+thisRegNo'=+regNo)
            
            set thisMedCareNo=##class(CIS.AN.BL.Admission).GetMedicareNo("",operSchedule.EpisodeID)
            continue:(medcareNo'="")&(medcareNo'=thisMedCareNo)
            set roomNode=curOperRoomDesc
            set:(roomNode="") roomNode="第99间"
            set operSeqNode=+operSchedule.OperSeq
            set:(operSeqNode=0) operSeqNode=99
            set ^TMPOPS(job,operSchedule.OperDate,roomNode,operSeqNode,+opsId)=""
            //do OutputRow
            
        }   
    }
    
    // 排序：按手术日期、手术间、手术台次升序排序
    set operDate=0,operCount=0
    w "{""rows"":["
    for
    {
        set operDate=$o(^TMPOPS(job,operDate))
        quit:(operDate="")
        set operRoom=""
        for
        {
            set operRoom=$o(^TMPOPS(job,operDate,operRoom))
            quit:(operRoom="")  
            set operSeq=0
            for
            {
                set operSeq=$o(^TMPOPS(job,operDate,operRoom,operSeq))
                quit:(operSeq="")
                set opsId=0
                for
                {
                    set opsId=$o(^TMPOPS(job,operDate,operRoom,operSeq,opsId))
                    quit:(opsId="")
                    set ret=..GetOperScheduleNew(opsId)
                    w:(operCount=0) ret
                    w:(operCount>0) ","_ret
                    set operCount=operCount+1   
                }   
            }
        }   
    }
    w "],""total"":"_operCount_"}"

    quit ""
}

/// w ##class(CIS.AN.BL.OperScheduleList).GetOperScheduleNew(4166)
ClassMethod GetOperScheduleNew(opsId As %String) As %String
{
    set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    set ops=##class(%DynamicObject).%New()
    set ops.RowId=opsId
    set ops.OPSID=opsId
    // 获取患者信息
    set ops.EpisodeID=operSchedule.EpisodeID
    set ops.PatName=operSchedule.PatName
    set ops.PatGender=operSchedule.PatGender
    set ops.PatAge=##class(CIS.AN.COM.DateTime).CalAge(operSchedule.PatDOB,+$h)
    set ops.RegNo=operSchedule.RegNo
    set ops.MedcareNo=operSchedule.MedicareNo
    
    // 手术申请信息
    set ops.AppCareProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",operSchedule.AppCareProvID)
    set ops.PatDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.PatDeptID)
    set ops.PatWardDesc=##class(CIS.AN.COM.String).GetDescByID("User.PACWard","WARDDesc",operSchedule.PatWardID)
    set ops.PatBedCode=##class(CIS.AN.COM.String).GetDescByID("User.PACBed","BEDCode",operSchedule.PatBedID)
    set ops.AppDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AppDeptID)
    set ops.OperDeptID=operSchedule.OperDeptID              // 手术室
    set ops.OperDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperDeptID)
    set ops.AnaDept=operSchedule.AnaDept                    // 麻醉科室
    set ops.AnaDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.AnaDept)
    
    //20200628
    set ops.OperExecDeptID=operSchedule.OperExecDeptID              // 日间预住院科室
    set ops.OperExecDeptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",operSchedule.OperExecDeptID)
    set ops.SourceType=operSchedule.SourceType              // 手术类型
    set ops.SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(operSchedule.SourceType)
    set ops.Status=operSchedule.Status.%Id()
    set ops.StatusDesc=operSchedule.Status.Description      // 手术状态名称
    set ops.StatusColor=operSchedule.Status.BGColor         // 手术状态背景颜色
    set ops.StatusCode=operSchedule.Status.Code             // 手术状态代码
    
    set OperDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")           // 手术日期(计划)
    set DateFormat=$lg(^websys.ConfigurationD(1),10)
    if ((DateFormat="DMY")&(OperDate'="")) set OperDate=$zd($zdh(OperDate,3),4)
    set ops.AppDT=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime)
    set ops.AuditDT=""
    set ops.OperDate=OperDate
    set ops.OperTime=##class(CIS.AN.COM.DateTime).ConvertToTime(operSchedule.OperTime,"")           // 手术开始时间(计划)
    set ops.DaySurgery=operSchedule.DaySurgery  // 202002+dyl+日间手术
    set ops.OPAdmType=operSchedule.OPAdmType    //202003+dyl+门诊手术
    set ops.PlanSeq=operSchedule.PlanSeq                    // 计划台次
    set ops.SeqType=operSchedule.SeqType                    // 台次类型(正常台，连台)
    set ops.SeqTypeDesc=##class(CIS.AN.OperSchedule).SeqTypeLogicalToDisplay(operSchedule.SeqType)
    set ops.PrevDiagnosis=$tr(operSchedule.PrevDiagnosis,$c(4),"")      // 术前诊断
    set ops.PrevDiagnosisDesc=..GetDiagnosisDesc(ops.PrevDiagnosis)     // 术前诊断描述
    set ops.PostDiagnosis=operSchedule.PostDiagnosis        // 术后诊断
    set ops.PostDiagnosisDesc=..GetDiagnosisDesc(ops.PostDiagnosis)
    
    k operData
    set operListObj=##class(CIS.AN.BL.OperationList).GetOperListObject(opsId)                   // 实施手术
    set ops.BodySite=operListObj.BodySite
    set ops.BodySiteDesc=operListObj.BodySiteDesc
    set ops.OperPosition=operSchedule.OperPosition                  // 手术体位
    Set ops.OperPositionDesc=..GetOperPosDesc(operSchedule.OperPosition)            // 手术体位名称
    set ops.OperClass=operListObj.OperClass     // 手术分级
    set ops.OperClassDesc=operListObj.OperClassDesc     // 手术分级名称
    set ops.BladeType=operListObj.BladeType     // 切口类型
    set ops.BladeTypeDesc=operListObj.BladeTypeDesc
    set ops.SurIntership=operSchedule.SurIntership                  // 实习进修人员
    set ops.SurVisitors=operSchedule.SurVisitors                    // 手术参观人员
    
    set ops.OperDesc=operListObj.OperDesc                   // 实施手术名称
    set ops.OperNote=operListObj.OperNote                       // 实施手术名称备注
    set:(ops.OperDesc="") ops.OperDesc=ops.OperNote
    set ops.SurgeonDesc=operListObj.SurgeonDesc                 // 实施手术医生姓名
    set ops.AsstDesc=operListObj.AssistantDesc                  // 实施手术助手姓名
    set ops.SurgeonExpert=operListObj.SurgeonExpert             // 实施手术专家主刀
    
    set SurgeonCount=$l(operListObj.Surgeon,",")
    for i=1:1:SurgeonCount
    {
        set Surgeon=$p(operListObj.Surgeon,",",i)
		set SurPhoneNumber=$P($g(^CTPCP(Surgeon,3)),"^",6)
		continue:SurPhoneNumber=""
		if (ops.SurPhoneNumber="") set ops.SurPhoneNumber=SurPhoneNumber
		else  set ops.SurPhoneNumber=ops.SurPhoneNumber_","_SurPhoneNumber
	}
    // 手术排班信息
    set OperRoom="",RoomDesc=""                 // 手术间
    if (operSchedule.OperRoom'="")
    {
        set OperRoom=operSchedule.OperRoom.%Id()                // 手术间ID
        set RoomDesc=operSchedule.OperRoom.Description          // 手术间名称
    }
    set ops.OperRoom=OperRoom
    set ops.RoomDesc=RoomDesc
    set ops.OperSeq=operSchedule.OperSeq                            // 手术台次
    set ops.PlanOperSeq=operSchedule.PlanSeq
    set ops.ScrubNurse=operSchedule.ScrubNurse                      // 器械护士，多个护士以","拼接
    set ops.ScrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ScrubNurse)        // 器械护士姓名
    set ops.CircualNurse=operSchedule.CircualNurse                  // 巡回护士，多个护士以","拼接
    set ops.CircualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.CircualNurse)    // 巡回护士姓名
    set ops.ReentryOperation=##class(CIS.AN.OperSchedule).ReentryOperationLogicalToDisplay(operSchedule.ReentryOperation)  // 非计划重返手术
    
    // 麻醉信息
    set ops.AnaestID=$o(^CIS.AN.AnaesthesiaI("IOPS",opsId,0))   // 麻醉申请ID
    set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(ops.AnaestID)
    if (anaesthesia'=""){
		set ops.AnaMethod=anaesthesia.AnaMethod // 麻醉方法ID
		set ops.AnaMethodDesc=##class(CIS.AN.COM.String).GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",ops.AnaMethod)   // 麻醉方法名称
		set ops.AnaExpert=anaesthesia.AnaExpert // 麻醉指导
		set ops.AnaExpertDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anaesthesia.AnaExpert)   // 麻醉指导姓名
		set ops.Anesthesiologist=anaesthesia.Anesthesiologist   // 麻醉医生
		set ops.AnesthesiologistDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",anaesthesia.Anesthesiologist) // 麻醉医生姓名
		set ops.AnaAssistant=anaesthesia.AnaAssistant   //anaestObj.GetValue("AnaAssistant")            // 麻醉助手
		set ops.AnaAssistantDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(ops.AnaAssistant)     // 麻醉助手姓名
		set ops.AnaStaff=anaesthesia.AnaStaff   // 实习进修
		set ops.ASAClass=anaesthesia.ASAClass // ASA分级
		set ops.ASAClassDesc=##class(CIS.AN.COM.String).GetDescByID("User.ORCASAClassPhActiv","ORASADesc",ops.ASAClass)
		set ops.AfterOperationICUDesc=anaesthesia.TheatreOutTransLoc
    }
    set ops.AppDateTime=##class(CIS.AN.COM.DateTime).ConvertToDateTime(operSchedule.AppDate,operSchedule.AppTime)   // 手术申请日期时间
    set ops.AnaestMethod=..GetAnaestMethod(opsId)
    set ops.OPAID=operSchedule.ExternalID
    set ops.Infection=$$GetInfection()      // 感染四项阳性情况
    set ops.Requirement=$$GetRequirement()  // 手术要求
    set ops.OperRequirement=operSchedule.OperRequirement
    set ops.ArrPrintFlag=operSchedule.ArrPrintFlag
    set ops.OPFeeFlag=operSchedule.OPFeeFlag        // 手术费用审核标志
    set ops.OPFeeFlagDesc=$CASE(ops.OPFeeFlag,"N":"否","Y":"是",:"")
    set ops.ANFeeFlag=operSchedule.ANFeeFlag        // 麻醉费用审核标志
    set ops.ANFeeFlagDesc=$CASE(ops.ANFeeFlag,"N":"否","Y":"是",:"")
    set ops.SurgicalMaterials=operSchedule.SurgicalMaterials        // 手术要求  仪器器械
    set ops.SpecialConditions=operSchedule.SpecialConditions         // 特殊情况
    set ops.HighConsume=operSchedule.HighConsume                    // 高值耗材
    quit ops.%ToJSON()
GetInfection()
    set infectionA="",infectionB=""
    set:(operSchedule.HivAb="+") infectionA=infectionA_$lb("艾滋阳性")
    set:(operSchedule.HivAb="-") infectionB="阴性"
    
    set:(operSchedule.HcvAb="+") infectionA=infectionA_$lb("丙肝阳性")
    set:(operSchedule.HcvAb="-") infectionB="阴性"
    
    set:(operSchedule.HbsAg="+") infectionA=infectionA_$lb("乙肝阳性")
    set:(operSchedule.HbsAg="-") infectionB="阴性"
    
    set:(operSchedule.Syphilis="+") infectionA=infectionA_$lb("梅毒阳性")
    set:(operSchedule.Syphilis="-") infectionB="阴性"
    
    quit:(infectionA="") infectionB
    quit infectionA
GetRequirement()
    set requirement=""
    set:(operSchedule.SurgicalMaterials'="") requirement=requirement_$lb(operSchedule.SurgicalMaterials)
    set:(operSchedule.SpecialConditions'="") requirement=requirement_$lb(operSchedule.SpecialConditions)
    set:(operSchedule.HighConsume'="") requirement=requirement_$lb(operSchedule.HighConsume)
    set requirement=$lts(requirement,";")
    quit requirement
}

/// w ##class(CIS.AN.BL.OperScheduleList).GetDiagnosisDesc("27268###头痛###")
ClassMethod GetDiagnosisDesc(diagnosis As %String) As %String [ SqlProc ]
{
    set langid=20
    if ($d(%session))&&($d(%session.Data)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    set ret=diagnosis,diagStr=""
    set diagnosisCount=$l(diagnosis,"&&&")
    for i=1:1:diagnosisCount
    {
        set curDiagnosis=$p(diagnosis,"&&&",i)
        set diagId=$p(curDiagnosis,"###",1)
        set diagDesc=$p(curDiagnosis,"###",2)
		set diagDesc=##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",diagDesc,langid) //多语言改造翻译后台数据 YL 20221201
        set diagNote=$p(curDiagnosis,"###",3)
        set descNote=diagDesc
        set:(diagDesc'="")&(diagNote'="") descNote=descNote_"("_diagNote_")"
        set:(diagStr'="")&(descNote'="") diagStr=diagStr_"；"
        set diagStr=diagStr_descNote    
    }
    set:(diagStr="") diagStr=##class(CIS.AN.COM.String).GetDescByIDStr("User.MRCICDDx","MRCIDDesc",diagnosis,",","Y")
    set:(diagStr="") diagStr=diagnosis
    quit diagStr
}

ClassMethod GetOperRequirement(opsId As %String) As %String
{
    set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    set operReq=operSchedule.OperRequirement,splitChar=","
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

/// Creator：        ccq
/// CreatDate：      2019年7月4日
/// Description：    根据手术申请ID获取拟施手术名称
/// Table：          CIS_AN.OperSchedule,CIS_AN.PlanOperList
/// Input:          opsId:手术申请ID
/// Return：        拟施手术信息json字符串
/// w ##class(CIS.AN.BL.OperScheduleList).GetPlanOperList("7")
ClassMethod GetPlanOperList(opsId As %String, planOperData As %String) As %String
{
    set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindPlanOperationList")
    set sc=rs.Execute(opsId)
    //set operList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindPlanOperationList",opsId)
    set operIdList="",operDescList="",operNoteList="",surgeonStr="",surgeonDescStr="",assistantStr="",assistantDescStr="",splitChar=",",mainSplitChar="&&&"
    set surgeonExpertStr="",surgeonList="",surgeonDescList="",assistantList="",assistantDescList="",bodySiteList="",bodySiteDescList=""
    
    while(rs.%Next())
    {
        //set operObj=operList.GetAt(i)
        set operId=rs.Get("Operation")
        set operIdList=operIdList_$lb(operId)
        
        set operDesc=rs.Get("OperationDesc")
        
        set operNote=rs.Get("OperNote")
        set:(operDesc="") operDesc=operNote
        set operDescList=operDescList_$lb(operDesc)
        set operNoteList=operNoteList_$lb(operNote)

        set bodySite=rs.Get("BodySite")
        if (bodySiteList="") 
        {
            set bodySiteList=$lfs(bodySite,splitChar)   
        }
        else
        {
            set:($lf(bodySiteList,bodySite)=0) $li(bodySiteList,$ll(bodySiteList)+1)=bodySite   
        }

        set bodySiteDesc=rs.Get("BodySiteDesc")
        if (bodySiteDescList="") 
        {
            set bodyDescSiteList=$lfs(bodySiteDesc,splitChar)   
        }
        else
        {
            set:($lf(bodyDescSiteList,bodySiteDesc)=0) $li(bodyDescSiteList,$ll(bodyDescSiteList)+1)=bodySiteDesc   
        }
        
        set surgeon=rs.Get("Surgeon")
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
        
        set surgeonDesc=rs.Get("SurgeonDesc")   
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
        
        set assistant=rs.Get("Assistant")
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
        
        set assistantDesc=rs.Get("AssistantDesc")
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

        set surgeonExpert=rs.Get("SurgeonExpert")
        set:(surgeonExpertStr'="") surgeonExpertStr=surgeonExpertStr_splitChar
        set surgeonExpertStr=surgeonExpertStr_surgeonExpert
    }
    
    k planOperData
    set planOperData(1,"OperSchedule")=opsId
    set planOperData(1,"Operation")=$lts(operIdList,splitChar)
    set planOperData(1,"OperationDesc")=$lts(operDescList,"+")
    set planOperData(1,"OperNote")=$lts(operNoteList,splitChar)
    set planOperData(1,"BodySite")=$lts(bodySiteList,splitChar)
    set planOperData(1,"BodySiteDesc")=$lts(bodySiteDescList,splitChar)
    set planOperData(1,"Surgeon")=$lts(surgeonList,splitChar)               //surgeonStr
    set planOperData(1,"SurgeonDesc")=$lts(surgeonDescList,splitChar)                               //surgeonDescStr
    set planOperData(1,"Assistant")=$lts(assistantList,splitChar) //assistantStr
    set planOperData(1,"AssistantDesc")=$lts(assistantDescList,splitChar) //assistantDescStr
    set planOperData(1,"SurgeonExpert")=surgeonExpertStr
    set result=##class(CIS.AN.COM.String).ToJson(.planOperData)
    quit result
}

/// Creator：        ccq
/// CreatDate：      2019年7月4日
/// Description：    根据手术申请ID获取拟施手术名称
/// Table：          CIS_AN.OperSchedule,CIS_AN.PlanOperList
/// Input:          opsId:手术申请ID
/// Return：        拟施手术信息json字符串
/// w ##class(CIS.AN.BL.OperScheduleList).GetOperList("897")
ClassMethod GetOperList(opsId As %String, planOperData As %String) As %String
{
    set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
    set sc=rs.Execute(opsId)
    //set operList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.OperationList:FindOperationList",opsId)
    set operIdList="",operDescList="",operNoteList="",surgeonStr="",surgeonDescStr="",assistantStr="",assistantDescStr="",splitChar=",",mainSplitChar="&&&"
    set surgeonExpertStr="",surgeonList="",surgeonDescList="",assistantList="",assistantDescList="",bodySiteList="",bodySiteDescList=""
    while(rs.%Next())
    {
        //set operObj=operList.GetAt(i)
        set operId=rs.Get("Operation")
        set operIdList=operIdList_$lb(operId)
        
        set operDesc=rs.Get("OperationDesc")
        
        set operNote=rs.Get("OperNote")
        set:(operDesc="") operDesc=operNote
        set operDescList=operDescList_$lb(operDesc)
        set operNoteList=operNoteList_$lb(operNote)

        set bodySite=rs.Get("BodySite")
        if (bodySiteList="") 
        {
            set bodySiteList=$lfs(bodySite,splitChar)   
        }
        else
        {
            set:($lf(bodySiteList,bodySite)=0) $li(bodySiteList,$ll(bodySiteList)+1)=bodySite   
        }

        set bodySiteDesc=rs.Get("BodySiteDesc")
        if (bodySiteDescList="") 
        {
            set bodyDescSiteList=$lfs(bodySiteDesc,splitChar)   
        }
        else
        {
            set:($lf(bodyDescSiteList,bodySiteDesc)=0) $li(bodyDescSiteList,$ll(bodyDescSiteList)+1)=bodySiteDesc   
        }
        
        set surgeon=rs.Get("Surgeon")
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
        
        set surgeonDesc=rs.Get("SurgeonDesc")   
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
        
        set assistant=rs.Get("Assistant")
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
        
        set assistantDesc=rs.Get("AssistantDesc")
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

        set surgeonExpert=rs.Get("SurgeonExpert")
        set:(surgeonExpertStr'="") surgeonExpertStr=surgeonExpertStr_splitChar
        set surgeonExpertStr=surgeonExpertStr_surgeonExpert
    }
    
    k planOperData
    set planOperData(1,"OperSchedule")=opsId
    set planOperData(1,"Operation")=$lts(operIdList,splitChar)
    set planOperData(1,"OperationDesc")=$lts(operDescList,"+")
    set planOperData(1,"OperNote")=$lts(operNoteList,splitChar)
    set planOperData(1,"BodySite")=$lts(bodySiteList,splitChar)
    set planOperData(1,"BodySiteDesc")=$lts(bodySiteDescList,splitChar)
    set planOperData(1,"Surgeon")=$lts(surgeonList,splitChar)               //surgeonStr
    set planOperData(1,"SurgeonDesc")=$lts(surgeonDescList,splitChar)                               //surgeonDescStr
    set planOperData(1,"Assistant")=$lts(assistantList,splitChar) //assistantStr
    set planOperData(1,"AssistantDesc")=$lts(assistantDescList,splitChar) //assistantDescStr
    set planOperData(1,"SurgeonExpert")=surgeonExpertStr
    
    set result=##class(CIS.AN.COM.String).ToJson(.planOperData)
    quit result
}

/// Creator：        yongyang
/// CreatDate：      2020年2月6日
/// Description：    根据手术申请ID获取麻醉方法名称（带有导管信息）
/// Table：          CIS_AN.OperSchedule,CIS_AN.AnaestCatheter
/// Input:          opsId:手术申请ID
/// Return：        麻醉方法名称（带有导管信息）
/// w ##class(CIS.AN.BL.OperScheduleList).GetAnaestMethod("6")
ClassMethod GetAnaestMethod(opsId As %String) As %String
{
    set rs=##class(%ResultSet).%New("CIS.AN.BL.DataQueries:FindAnaestCatheter")
    set sc=rs.Execute(opsId)
    //set dataList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindAnaestCatheter",opsId)
    set result="",catheterInfo=""
    while(rs.%Next())
    {
        //set dataObj=dataList.GetAt(i)
        set AnaMethodDesc=rs.Get("AnaMethodDesc")
        set CatheterDesc=rs.Get("CatheterDesc")
        set CatheterTypeDesc=rs.Get("CatheterTypeDesc")
        set CatheterDepthDesc=rs.Get("CatheterDepthDesc")
        set CatheterPathDesc=rs.Get("CatheterPathDesc")
        set CatheterToolDesc=rs.Get("CatheterToolDesc")
        set CatheterDirectionDesc=rs.Get("CatheterDirectionDesc")
        set PunctureSpaceDesc=rs.Get("PunctureSpaceDesc")
        set PositionMethodDesc=rs.Get("PositionMethodDesc")
        set NerveBlockSiteDesc=rs.Get("NerveBlockSiteDesc")
        
        set catheterInfo=""
        set:CatheterDesc'="" catheterInfo=catheterInfo_$lb(CatheterDesc)
        set:CatheterTypeDesc'="" catheterInfo=catheterInfo_$lb(CatheterTypeDesc)
        set:CatheterDepthDesc'="" catheterInfo=catheterInfo_$lb(CatheterDepthDesc)
        set:CatheterPathDesc'="" catheterInfo=catheterInfo_$lb(CatheterPathDesc)
        set:CatheterToolDesc'="" catheterInfo=catheterInfo_$lb(CatheterToolDesc)
        set:CatheterDirectionDesc'="" catheterInfo=catheterInfo_$lb(CatheterDirectionDesc)
        set:PunctureSpaceDesc'="" catheterInfo=catheterInfo_$lb(PunctureSpaceDesc)
        set:PositionMethodDesc'="" catheterInfo=catheterInfo_$lb(PositionMethodDesc)
        set:NerveBlockSiteDesc'="" catheterInfo=catheterInfo_$lb(NerveBlockSiteDesc)
        
        if catheterInfo="" set result=result_$lb(AnaMethodDesc)
        else  set result=result_$lb(AnaMethodDesc_"("_$ListToString(catheterInfo,",")_")")
    }
    
    quit $ListToString(result,"+")
}

/// Creator：        yongyang
/// CreatDate：      2020年2月6日
/// Description：    根据手术申请ID获取麻醉方法名称（带有导管信息）
/// Table：          CIS_AN.OperSchedule,CIS_AN.AnaestCatheter
/// Input:          opsId:手术申请ID
/// Return：        麻醉方法名称（带有导管信息）
/// w ##class(CIS.AN.BL.OperScheduleList).GetAnaestMethod("6")
ClassMethod GetAnaestMethodNew(opsId As %String) As %String
{
    set rs=##class(%ResultSet).%New("CIS.AN.BL.DataQueries:FindAnaestCatheterNew")
    set sc=rs.Execute(opsId)
    //set dataList=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindAnaestCatheter",opsId)
    set result="",catheterInfo=""
    while(rs.%Next())
    {
        //set dataObj=dataList.GetAt(i)
        set AnaMethodDesc=rs.Get("AnaMethodDesc")
        set CatheterDesc=rs.Get("CatheterDesc")
        set CatheterTypeDesc=rs.Get("CatheterTypeDesc")
        set CatheterDepthDesc=rs.Get("CatheterDepthDesc")
        set CatheterPathDesc=rs.Get("CatheterPathDesc")
        set CatheterToolDesc=rs.Get("CatheterToolDesc")
        set CatheterDirectionDesc=rs.Get("CatheterDirectionDesc")
        set PunctureSpaceDesc=rs.Get("PunctureSpaceDesc")
        set PositionMethodDesc=rs.Get("PositionMethodDesc")
        set NerveBlockSiteDesc=rs.Get("NerveBlockSiteDesc")
        
        set catheterInfo=""
        set:CatheterDesc'="" catheterInfo=catheterInfo_$lb(CatheterDesc)
        set:CatheterTypeDesc'="" catheterInfo=catheterInfo_$lb(CatheterTypeDesc)
        set:CatheterDepthDesc'="" catheterInfo=catheterInfo_$lb(CatheterDepthDesc)
        set:CatheterPathDesc'="" catheterInfo=catheterInfo_$lb(CatheterPathDesc)
        set:CatheterToolDesc'="" catheterInfo=catheterInfo_$lb(CatheterToolDesc)
        set:CatheterDirectionDesc'="" catheterInfo=catheterInfo_$lb(CatheterDirectionDesc)
        set:PunctureSpaceDesc'="" catheterInfo=catheterInfo_$lb(PunctureSpaceDesc)
        set:PositionMethodDesc'="" catheterInfo=catheterInfo_$lb(PositionMethodDesc)
        set:NerveBlockSiteDesc'="" catheterInfo=catheterInfo_$lb(NerveBlockSiteDesc)
        
        set CatheterDesc=rs.Get("CatheterDesc_1")
        set CatheterTypeDesc=rs.Get("CatheterTypeDesc_1")
        set CatheterDepthDesc=rs.Get("CatheterDepthDesc_1")
        set CatheterPathDesc=rs.Get("CatheterPathDesc_1")
        set CatheterToolDesc=rs.Get("CatheterToolDesc_1")
        set CatheterDirectionDesc=rs.Get("CatheterDirectionDesc_1")
        set PunctureSpaceDesc=rs.Get("PunctureSpaceDesc_1")
        set PositionMethodDesc=rs.Get("PositionMethodDesc_1")
        set NerveBlockSiteDesc=rs.Get("NerveBlockSiteDesc_1")
        
        set catheterInfo=""
        set:CatheterDesc'="" catheterInfo=catheterInfo_$lb(CatheterDesc)
        set:CatheterTypeDesc'="" catheterInfo=catheterInfo_$lb(CatheterTypeDesc)
        set:CatheterDepthDesc'="" catheterInfo=catheterInfo_$lb(CatheterDepthDesc)
        set:CatheterPathDesc'="" catheterInfo=catheterInfo_$lb(CatheterPathDesc)
        set:CatheterToolDesc'="" catheterInfo=catheterInfo_$lb(CatheterToolDesc)
        set:CatheterDirectionDesc'="" catheterInfo=catheterInfo_$lb(CatheterDirectionDesc)
        set:PunctureSpaceDesc'="" catheterInfo=catheterInfo_$lb(PunctureSpaceDesc)
        set:PositionMethodDesc'="" catheterInfo=catheterInfo_$lb(PositionMethodDesc)
        set:NerveBlockSiteDesc'="" catheterInfo=catheterInfo_$lb(NerveBlockSiteDesc)
        
        if catheterInfo="" set result=result_$lb(AnaMethodDesc)
        else  set result=result_$lb(AnaMethodDesc_"("_$ListToString(catheterInfo,",")_")")
    }
    
    quit $ListToString(result,"+")
}

/// Creator：        陈长青
/// CreatDate：      2017-2-22
/// Description：    获取手术排班信息
/// Table：          DHCAN.DefaultOperDept
/// Input:          deptID:科室ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindDefaultOperDept","53")
Query FindOperArrange(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
       OperSchedule,
       OperRoom,
       OperRoom->Code As OperRoomCode,
       OperRoom->Description As OperRoomDesc,
       OperSeq,
       ScrubNurse,
       CIS_AN_BL.OperationList_GetAssistantDesc(ScrubNurse) As ScrubNurseDesc,
       CircualNurse,
       CIS_AN_BL.OperationList_GetAssistantDesc(CircualNurse) As CircualNurseDesc
       from CIS_AN.OperArrange
       where OperSchedule=:opsId
}

/// Creator：        钟鸣远
/// CreatDate：      2021-05-21
/// Description：    按手术状态获取手术计划表ID
/// Table：          CIS_AN.OperSchedule
/// Input:          startDate:开始日期,endDate:结束日期日期,Status:手术状态
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperScheduleList","FindOperOpsIdList","65764","65821","RoomIn")
Query FindOperOpsIdList(startDate As %String, endDate As %String, Status As %String) As %SQLQuery(CONTAINID = 1)
{
	
  SELECT  RowId,OperDate FROM CIS_AN.OperSchedule WHERE Status->Code=:Status and OperDate>=:startDate and OperDate<=:endDate
}

/// w ##class(CIS.AN.BL.OperScheduleList).CancelOperation("1000","病人放弃手术","10209")
ClassMethod CancelOperation(opsId As %String, reason As %String, cancelUserId As %String) As %String
{
    set $zt="Error"
    tstart
    set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    set cancelStatusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Cancel")    
    set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(cancelStatusID)
    set operSchedule.CancelReason=reason
    set sc=operSchedule.%Save()
    if ($System.Status.IsError(sc))
    {
        trollback
        quit "E^"_$System.Status.GetErrorText(sc)   
    }
    b ///
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
    
    do ##class(CIS.AN.BL.OperArrange).AfterCancelOper(opsId)
    
    quit "S^"
Error
    trollback
    b
    quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.OperScheduleList).GetOperNurseJSON("2020-02-29","","296")
ClassMethod GetOperNurseJSON(operDate As %String, filterDesc As %String, deptId As %String, sortByArrange As %String = "N") As %String
{
    set careProvSet=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindCareProvByLoc")
    set sc=careProvSet.Execute(filterDesc,deptId)
    set statusCode=##class(CIS.AN.BL.OperArrange).GetStatusCodeList()
    set ret=##class(CIS.AN.COM.String).QueryToArray(.scheduleArr,"CIS.AN.BL.OperScheduleList","FindOperScheduleList",operDate,operDate,deptId,"","","",statusCode)
    set arrangeInfo="",arrIndex=1
    kill careProvArr
    while (careProvSet.%Next())
    {
        set rowId=careProvSet.Get("RowId")
        set rowIdStr=","_rowId_","
        set description=careProvSet.Get("Description")
        set arrangeInfo="",count=0,scheduleInd=0,operRoomDesc=""
        set attendanceInfo=##class(CIS.AN.BL.Attendance).GetAttendanceForCareProv(operDate,deptId,rowId)
        set:(attendanceInfo'="") arrangeInfo=$p(attendanceInfo,"^",2)
        for
        {
            set scheduleInd=$o(scheduleArr(scheduleInd))
            quit:(scheduleInd="")
            set scrubNurse=","_scheduleArr(scheduleInd,"ArrScrubNurse")_","
            set circualNurse=","_scheduleArr(scheduleInd,"ArrCircualNurse")_","
            set operRoomDesc=scheduleArr(scheduleInd,"ArrRoomDesc")
            if (scrubNurse [ rowIdStr)!(circualNurse [ rowIdStr)
            {
                set:(arrangeInfo'="")&(arrangeInfo '[ operRoomDesc) arrangeInfo=arrangeInfo_","
                set:(arrangeInfo '[ operRoomDesc) arrangeInfo=arrangeInfo_operRoomDesc
                set count=count+1   
            }   
        }
        set arrangeFlag=arrangeInfo
        //b //ccqtest
        if (attendanceInfo'="")
        {
            
            set arrangeFlag=$p(attendanceInfo,"^",1)_$p(attendanceInfo,"^",2)   
            //b //ccq2
        }
        set:(arrangeFlag="") arrangeFlag="00未排人员"
        set:(sortByArrange="Y") arrangeFlag=1
        
        set arrangeFlag=##class(web.DHCClinicCom).GetChinaChar(description)_"@"_arrangeFlag
        set careProvArr(arrangeFlag,arrIndex,"RowId")=rowId
        set careProvArr(arrangeFlag,arrIndex,"Description")=description
        set careProvArr(arrangeFlag,arrIndex,"ArrangeFlag")=arrangeInfo
        set:(arrangeInfo="") careProvArr(arrangeFlag,arrIndex,"ArrangeFlag")="未排人员"
        set:(count>0) arrangeInfo=arrangeInfo_" 共"_count_"台。"
        set careProvArr(arrangeFlag,arrIndex,"ArrangeInfo")=arrangeInfo
        set careProvArr(arrangeFlag,arrIndex,"AttendanceInfo")=$p(attendanceInfo,"^",2)
        set arrIndex=arrIndex+1
    }
    b //ccq
    set arrangeFlag="",arrIndex=0,retIndex=1
    k retArr
    for
    {
        set arrangeFlag=$o(careProvArr(arrangeFlag))
        quit:(arrangeFlag="")
        for
        {
            set arrIndex=$o(careProvArr(arrangeFlag,arrIndex))
            quit:(arrIndex="")  
            set retArr(retIndex,"RowId")=careProvArr(arrangeFlag,arrIndex,"RowId")
            set retArr(retIndex,"Description")=careProvArr(arrangeFlag,arrIndex,"Description")
            set retArr(retIndex,"ArrangeFlag")=careProvArr(arrangeFlag,arrIndex,"ArrangeFlag")
            set retArr(retIndex,"ArrangeInfo")=careProvArr(arrangeFlag,arrIndex,"ArrangeInfo")
            set retArr(retIndex,"AttendanceInfo")=careProvArr(arrangeFlag,arrIndex,"AttendanceInfo")
            set retIndex=retIndex+1
        }
        
            
    }

    set result=##class(CIS.AN.COM.String).ToJson(.retArr)
    quit result
}

/// w ##class(CIS.AN.BL.OperScheduleList).GetAnaDocJSON("2021-02-03","","298")
ClassMethod GetAnaDocJSON(operDate As %String, filterDesc As %String, deptId As %String, sortByArrange As %String = "N") As %String
{
    set careProvSet=##class(%ResultSet).%New("CIS.AN.BL.Admission:FindCareProvByLoc")
    set sc=careProvSet.Execute(filterDesc,deptId,"Y")
    set statusCode=##class(CIS.AN.BL.OperArrange).GetStatusCodeList()
    set ret=##class(CIS.AN.COM.String).QueryToArray(.scheduleArr,"CIS.AN.BL.OperScheduleList","FindOperScheduleList",operDate,operDate,deptId,"","","",statusCode)
    set arrangeInfo="",arrIndex=1
    kill careProvArr
    while (careProvSet.%Next())
    {
        set rowId=careProvSet.Get("RowId")
        set rowIdStr=","_rowId_","
        set description=careProvSet.Get("Description")
        set arrangeInfo="",count=0,scheduleInd=0,operRoomDesc=""
        set attendanceInfo=##class(CIS.AN.BL.Attendance).GetAttendanceForCareProv(operDate,deptId,rowId)
        set:(attendanceInfo'="") arrangeInfo=$p(attendanceInfo,"^",2)
        for
        {
            set scheduleInd=$o(scheduleArr(scheduleInd))
            quit:(scheduleInd="")
            set scrubNurse=","_scheduleArr(scheduleInd,"ArrAnaExpert")_","
            set circualNurse=","_scheduleArr(scheduleInd,"ArrAnesthesiologist")_","
            set anaAssistant=","_scheduleArr(scheduleInd,"ArrAnaAssistant")_","
            set operRoomDesc=scheduleArr(scheduleInd,"ArrRoomDesc")
            if (scrubNurse [ rowIdStr)!(circualNurse [ rowIdStr)!(anaAssistant [ rowIdStr)
            {
                set:(arrangeInfo'="")&(arrangeInfo '[ operRoomDesc) arrangeInfo=arrangeInfo_","
                set:(arrangeInfo '[ operRoomDesc) arrangeInfo=arrangeInfo_operRoomDesc
                set count=count+1   
            }   
        }
        set arrangeFlag=arrangeInfo
        b //ccqtest
        if (attendanceInfo'="")
        {
            
            set arrangeFlag=$p(attendanceInfo,"^",1)_$p(attendanceInfo,"^",2)   
            b //ccq2
        }
        set:(arrangeFlag="") arrangeFlag="00未排人员"
        set:(sortByArrange="Y") arrangeFlag=1
        set careProvArr(arrangeFlag,arrIndex,"RowId")=rowId
        set careProvArr(arrangeFlag,arrIndex,"Description")=description
        set careProvArr(arrangeFlag,arrIndex,"ArrangeFlag")=arrangeInfo
        set:(arrangeInfo="") careProvArr(arrangeFlag,arrIndex,"ArrangeFlag")="未排人员"
        set:(count>0) arrangeInfo=arrangeInfo_" 共"_count_"台。"
        set careProvArr(arrangeFlag,arrIndex,"ArrangeInfo")=arrangeInfo
        set careProvArr(arrangeFlag,arrIndex,"AttendanceInfo")=$p(attendanceInfo,"^",2)
        set arrIndex=arrIndex+1
    }
    b //ccq
    set arrangeFlag="",arrIndex=0,retIndex=1
    k retArr
    for
    {
        b ;111
        set arrangeFlag=$o(careProvArr(arrangeFlag))
        quit:(arrangeFlag="")
        for
        {
            set arrIndex=$o(careProvArr(arrangeFlag,arrIndex))
            quit:(arrIndex="")  
            set retArr(retIndex,"RowId")=careProvArr(arrangeFlag,arrIndex,"RowId")
            set retArr(retIndex,"Description")=careProvArr(arrangeFlag,arrIndex,"Description")
            set retArr(retIndex,"ArrangeFlag")=careProvArr(arrangeFlag,arrIndex,"ArrangeFlag")
            set retArr(retIndex,"ArrangeInfo")=careProvArr(arrangeFlag,arrIndex,"ArrangeInfo")
            set retArr(retIndex,"AttendanceInfo")=careProvArr(arrangeFlag,arrIndex,"AttendanceInfo")
            set retIndex=retIndex+1
        }
        
            
    }

    set result=##class(CIS.AN.COM.String).ToJson(.retArr)
    quit result
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

/// w ##class(CIS.AN.BL.OperScheduleList).GetOperPosDesc(2)
ClassMethod GetOperPosDesc(operPosStr As %String) As %String
{
	Set lang="20",sessionLang=""
	Set:($DATA(%session)) sessionLang=$GET(%session.Data("LOGON.LANGID"))
	Set:(sessionLang'="") lang=sessionLang
	
    set operPosDesc=""
    set count=$l(operPosStr,",")
    for i=1:1:count
    {
        set operPosID=$p(operPosStr,",",i)
        continue:(##class(User.ORCOperPosition).%ExistsId(operPosID)=0)
        set operPosObj=##class(User.ORCOperPosition).%OpenId(operPosID)
        set:(operPosDesc'="")&(operPosObj.OPPOSDesc'="") operPosDesc=operPosDesc_","
    	set OperDesc=##class(User.ORCOperPosition).GetTranByDesc("OPPOSDesc",operPosObj.OPPOSDesc,lang)
        set operPosDesc=operPosDesc_OperDesc
    }   
    quit operPosDesc
}

/// 获取手术申请配置信息  YGB 20200226
ClassMethod GetOperConfig(DataKey As %String) As %String
{
    quit:DataKey="" ""
    set dataValue=""
    &sql(select DataValue into :dataValue from CF_AN.DataConfig where DataKey=:DataKey)
    quit dataValue
}

ClassMethod GetOpsListByUser(operDate As %String, deptId As %String, roomId As %String, patNameOrRegNo As %String, userId As %String, rows As %String, page As %String) As %String
{
    set SSUser=##class(CF.AN.SSUser).%OpenId(userId)
    set careProvId=""
    set:($isobject(SSUser.CareProvider)) careProvId=SSUser.CareProvider.%Id()
    set status="Arrange^RoomIn^RoomOut^PACUIn^Finish^AreaOut^Stop"
    set rs=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
    set sc=rs.Execute(operDate,operDate,deptId,"","","",status,roomId,patNameOrRegNo,"","N")
    set columnCount=rs.GetColumnCount()
    set startIndex=(+rows)*((+page)-1)+1,endIndex=(+rows)*(+page),curIndex=0,rowCount=0
    while (rs.%Next())
    {
        set curIndex=curIndex+1
        quit:(curIndex<startIndex)!(curIndex>endIndex)
        for colIndex=1:1:columnCount
        {
                
        }   
    }
}

ClassMethod AuditOPFee(opsIdStr As %String, userId As %String) As %String
{
    quit:(opsIdStr="") "E^手术ID不能为空!"
    set $zt="Error"
    tstart
    set saveResult="S^"
    for i=1:1:$l(opsIdStr,",")
    {
        set opsId=$p(opsIdStr,",",i)
        set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) saveResult="E^不存在ID为"_opsId_"的手术！"
        quit:($p(saveResult,"^")="E")
        set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
        set:("RoomOut^Finish^PACUIn^PACUOut" '[ operSchedule.Status.Code) saveResult="E^患者"_operSchedule.PatName_"的手术还未完成，请在手术完成后再审核！"
        quit:($p(saveResult,"^")="E")
        set operSchedule.OPFeeFlag="Y"
        set sc=operSchedule.%Save()
        set:($System.Status.IsError(sc)) saveResult="E^审核患者"_operSchedule.PatName_"的手术费用出错，原因："_$System.Status.GetErrorText(sc)
        quit:($p(saveResult,"^")="E")
        
        // 写入手术过程
        set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPFEE",userId,+$h,$p($h,",",2),"SI")
        quit:($p(saveResult,"^")="E")
    }
    if ($p(saveResult,"^")="E")
    {
        trollback
        quit saveResult 
    }
    tcommit
    
    for i=1:1:$l(opsIdStr,",")
    {
        set opsId=$p(opsIdStr,",",i)
    	do ..AfterAuditOPFee(opsId)
    }
    
    quit saveResult
Error
    trollback
    quit "E^"_$ze
}

ClassMethod AfterAuditOPFee(opsId) As %Status
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	try
	{
		// 回写旧表
        set saveResult=##class(CIS.AN.SRV.OperAppService).AuditOPFee(opsId)
	}
	catch(e)
	{
		//write "旧版兼容-回写旧表错误:",e.DisplayString(),!
	}
	
	quit $$$OK
}

ClassMethod AuditANFee(opsIdStr As %String, userId As %String) As %String
{
    quit:(opsIdStr="") "E^手术ID不能为空!"
    set $zt="Error"
    tstart
    set saveResult="S^"
    for i=1:1:$l(opsIdStr,",")
    {
        set opsId=$p(opsIdStr,",",i)
        set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) saveResult="E^不存在ID为"_opsId_"的手术！"
        quit:($p(saveResult,"^")="E")
        set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
        set:("RoomOut^Finish^PACUIn^PACUOut" '[ operSchedule.Status.Code) saveResult="E^患者"_operSchedule.PatName_"的手术还未完成，请在手术完成后再审核！"
        quit:($p(saveResult,"^")="E")
        set operSchedule.ANFeeFlag="Y"
        set sc=operSchedule.%Save()
        set:($System.Status.IsError(sc)) saveResult="E^审核患者"_operSchedule.PatName_"的手术费用出错，原因："_$System.Status.GetErrorText(sc)
        quit:($p(saveResult,"^")="E")
        
        // 写入手术过程
        set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"ANFEE",userId,+$h,$p($h,",",2),"SI")
        quit:($p(saveResult,"^")="E")
    }
    if ($p(saveResult,"^")="E")
    {
        trollback
        quit saveResult 
    }
    tcommit
    
    for i=1:1:$l(opsIdStr,",")
    {
        set opsId=$p(opsIdStr,",",i)
    	do ..AfterAuditANFee(opsId)
    }
    
    quit saveResult
Error
    trollback
    quit "E^"_$ze
}

ClassMethod AfterAuditANFee(opsId) As %Status
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	try
	{
		// 回写旧表
        set saveResult=##class(CIS.AN.SRV.OperAppService).AuditANFee(opsId)
	}
	catch(e)
	{
		//write "旧版兼容-回写旧表错误:",e.DisplayString(),!
	}
	
	quit $$$OK
}

ClassMethod ExistOperSchedule(EpisodeID, MedcareNo, RegNo) As %String
{
    quit "Y"
}

/// 从麻醉记录单上的数据中获取关键时间
/// w ##class(CIS.AN.BL.OperScheduleList).GetKeyTimeFromAnaData(220,.keyTimeList)
ClassMethod GetKeyTimeFromAnaData(opsId, ByRef keyTimeList) As %String
{
    kill needSyncEventCode
    set needSyncEventCode("OperStart")=""
    set needSyncEventCode("OperEnd")=""
    set needSyncEventCode("TubeIn")=""
    set needSyncEventCode("TubeOut")=""
    set needSyncEventCode("OperRoomIn")=""
    set needSyncEventCode("OperRoomOut")=""
    set needSyncEventCode("AnaStart")=""
    set needSyncEventCode("AnaEnd")=""
    set needSyncEventCode("PACUIn")=""
    set needSyncEventCode("PACUOut")=""
    
    set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCodeNew(opsId,"AnaestRecord","")
    set paraItemRowId="",eventParaItemId=""
    for
    {
        set paraItemRowId=$o(^CIS.AN.ParaItemI("ISheet",+recordSheetId,paraItemRowId))
        quit:paraItemRowId=""
            
        set paraItemCode=$lg(^CIS.AN.ParaItemD(paraItemRowId),3)
        if paraItemCode="OperationEvent" set eventParaItemId=paraItemRowId
            
        quit:eventParaItemId'=""
    }
    
    set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCodeNew(opsId,"PACURecord","")
    set paraItemRowId="",pacuEventParaItemId=""
    for
    {
        set paraItemRowId=$o(^CIS.AN.ParaItemI("ISheet",+recordSheetId,paraItemRowId))
        quit:paraItemRowId=""
            
        set paraItemCode=$lg(^CIS.AN.ParaItemD(paraItemRowId),3)
        if paraItemCode="OperationEvent" set pacuEventParaItemId=paraItemRowId
            
        quit:pacuEventParaItemId'=""
    }
        
    set EventCategoryId=+$O(^CT.AN.DataCategoryI("ICode"," KEYEVENT",""))
        
    set EventItemId="",ifAllFound=0
    for
    {
        set EventItemId=$o(^CT.AN.DataCateItemI("IDataCategory",EventCategoryId,EventItemId))
        quit:EventItemId=""
            
        set eventItem=##class(CT.AN.DataCateItem).%OpenId(EventItemId)
        set EventItemCode=eventItem.DataItem.Code
            
        if $d(needSyncEventCode(EventItemCode))&&(needSyncEventCode(EventItemCode)="")
        {
            set needSyncEventCode(EventItemCode)=eventItem.DataItem.%Id()
        }
            
        set ifAllFound=(needSyncEventCode("OperRoomIn")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("OperRoomOut")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("OperStart")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("OperEnd")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("AnaStart")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("AnaEnd")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("TubeIn")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("TubeOut")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("PACUIn")'="")
        set ifAllFound=ifAllFound&&(needSyncEventCode("PACUOut")'="")
            
        quit:ifAllFound
    }
    
    //break //before get event time
    set TheatreInTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("OperRoomIn"))
    set AnestStartTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("AnaStart"))
    set OperStartTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("OperStart"))
    set OperEndTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("OperEnd"))
    set AnestEndTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("AnaEnd"))
    set TheatreOutTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("OperRoomOut"))
    set TubeInTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("TubeIn"))
    set TubeOutTime=##class(CIS.AN.BL.AnaData).GetEventTime(eventParaItemId,needSyncEventCode("TubeOut"))
    set PACUInTime=##class(CIS.AN.BL.AnaData).GetEventTime(pacuEventParaItemId,needSyncEventCode("PACUIn"))
    set PACUOutTime=##class(CIS.AN.BL.AnaData).GetEventTime(pacuEventParaItemId,needSyncEventCode("PACUOut"))
    
    set keyTimeList("TheatreInTime")=TheatreInTime
    set keyTimeList("AnestStartTime")=AnestStartTime
    set keyTimeList("OperStartTime")=OperStartTime
    set keyTimeList("OperEndTime")=OperEndTime
    set keyTimeList("AnestEndTime")=AnestEndTime
    set keyTimeList("TheatreOutTime")=TheatreOutTime
    set keyTimeList("TubeInTime")=TubeInTime
    set keyTimeList("TubeOutTime")=TubeOutTime
    set keyTimeList("PACUInTime")=PACUInTime
    set keyTimeList("PACUOutTime")=PACUOutTime
    quit "S^"
}

ClassMethod GetDefOperStatus(groupID As %String) As %String
{
    set operStatusStr=""
    &sql(select DefOperStatus into :operStatusStr from CF_AN.SSGroup where GroupID=:groupID)
    set statusCodeStr=##class(CIS.AN.COM.String).GetDescByIDStr("CT.AN.OperStatus","Code",operStatusStr)
    set ret=$tr(statusCodeStr,",","^")
    quit ret
}

/// 根据模块和安全组获取操作功能授权信息
/// w ##class(CIS.AN.BL.OperScheduleList).GetOperActions("59","51","actionList")
ClassMethod GetOperActions(moduleID As %String, groupID As %String, container As %String) As %String
{
    s ^TMP("testss")=moduleID_"^"_groupID_"^"_container
    set relateModule=""
    if (moduleID'="")
    {
        set dataModule=##class(CT.AN.DataModule).%OpenId(moduleID)
        if dataModule.RelateModule'="" set relateModule=dataModule.RelateModule.%Id()
    }
    set rs=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindActionPermission")
    set sc=rs.Execute(groupID,moduleID,"Y",container,relateModule)
    set result=""
    while(rs.Next())
    {
        set actionCode=rs.Get("ElementID")
        set actionDesc=rs.Get("OperActionDesc")
        set icon=rs.Get("Icon")
        set clickHandler=rs.Get("ExecFunc")
        if relateModule="" set result=result_"<a href='#' id='"_actionCode_"' class='hisui-linkbutton' iconCls='"_icon_"' data-options='plain:true,onClick:"_clickHandler_"'>"_actionDesc_"</a>"_$char(10)
        else  set result=result_"<a href='#' id='"_actionCode_"' class='hisui-linkbutton' iconCls='"_icon_"' data-options='onClick:"_clickHandler_"'>"_actionDesc_"</a>"_$char(10)
    }   
    quit result
}

/// 获取手术列表配置
/// w ##class(CIS.AN.BL.OperScheduleList).GetOperListConfig("51")
ClassMethod GetOperListConfig(groupID As %String) As %String
{
    set qryCondition="",operListEditColumns="",canArrangeStatus="",defOperStatusId="",defOperStatus="",StatusCode=""
    &sql(select OPListCondition,OperListEditColumns,CanArrangeStatus,DefOperStatus into :qryCondition,:operListEditColumns,:canArrangeStatus,:defOperStatusId from CF_AN.SSGroup where GroupID=:groupID)
    k operListArr
    set operListArr(1,"QryCondition")=qryCondition
    if qryCondition'="" set operListArr(1,"QryCondition","Type")="JSON"
    set operListArr(1,"OperListEditColumns")=operListEditColumns
    set operListArr(1,"CanArrangeStatus")=canArrangeStatus
    set operListArr(1,"SeqType")="Description"
    set operListArr(1,"PlanSeqType")="Item1"
	set StatusCount=$length(defOperStatusId,",")
    for num=1:1:StatusCount
    {
		set StatusId=$piece(defOperStatusId,",",num)
		&sql(select Code into :StatusCode from CT_AN.OperStatus where RowId=:StatusId)
	    if (defOperStatus="") set defOperStatus=StatusCode
	    else  set defOperStatus=defOperStatus_"^"_StatusCode
    }
    set operListArr(1,"DefOperStatus")=defOperStatus
    set result=##class(CIS.AN.COM.String).ToJson(.operListArr)
    quit result
}

/// 获取手术流程关键时间
/// w ##class(CIS.AN.BL.OperScheduleList).GetProcedureTime("86")
ClassMethod GetProcedureTime(opsId As %String) As %String
{
    quit:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) "E^手术ID错误"
    
    set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
    
    set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
    set TheatreInDT=anaestObj.GetValue("TheatreInDT")           // 入手术间时间
    set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")         // 离手术间时间
    set OperStartDT=anaestObj.GetValue("OperStartDT")           // 手术开始时间
    set OperFinishDT=anaestObj.GetValue("OperFinishDT")         // 手术结束时间
    set AnaStartDT=anaestObj.GetValue("AnaStartDT")             // 麻醉开始时间
    set AnaFinishDT=anaestObj.GetValue("AnaFinishDT")           // 麻醉结束时间
    set TubeInDT=anaestObj.GetValue("TubeInDT")                 // 插管时间
    set TubeOutDT=anaestObj.GetValue("TubeOutDT")               // 拔管时间
    set AreaInDT=anaestObj.GetValue("AreaInDT")                 // 入手术室时间
    set AreaOutDT=anaestObj.GetValue("AreaOutDT")               // 离手术室时间
    set PACUInDT=anaestObj.GetValue("PACUInDT")                 // 入手术室时间
    set PACUOutDT=anaestObj.GetValue("PACUOutDT")               // 离手术室时间
    
    set operStatusCode=""
    set:operSchedule.Status'="" operStatusCode=operSchedule.Status.Code
    if (operStatusCode="RoomIn")
    {
        kill keyTimeList
        do ..GetKeyTimeFromAnaData(opsId,.keyTimeList)
        set TheatreInDT=$g(keyTimeList("TheatreInTime"))
        set AnaStartDT=$g(keyTimeList("AnestStartTime"))
        set OperStartDT=$g(keyTimeList("OperStartTime"))
        set OperFinishDT=$g(keyTimeList("OperEndTime"))
        set AnaFinishDT=$g(keyTimeList("AnestEndTime"))
        set TheatreOutDT=$g(keyTimeList("TheatreOutTime"))
    }
    
    if (operStatusCode="PACUIn")
    {
        set PACUInDT=$g(keyTimeList("PACUInTime"))
        set PACUOutDT=$g(keyTimeList("PACUOutTime"))
    }
    
    set TheatreInDate=$p(TheatreInDT," ",1)
    set AnestStartDate=$p(AnaStartDT," ",1)
    set OperStartDate=$p(OperStartDT," ",1)
    set OperEndDate=$p(OperFinishDT," ",1)
    set AnestEndDate=$p(AnaFinishDT," ",1)
    set TheatreOutDate=$p(TheatreOutDT," ",1)
    set PACUInDate=$p(PACUInDT," ",1)
    set PACUOutDate=$p(PACUOutDT," ",1)
    
    set TheatreInTime=$e($p(TheatreInDT," ",2),1,5)
    set AnestStartTime=$e($p(AnaStartDT," ",2),1,5)
    set OperStartTime=$e($p(OperStartDT," ",2),1,5)
    set OperEndTime=$e($p(OperFinishDT," ",2),1,5)
    set AnestEndTime=$e($p(AnaFinishDT," ",2),1,5)
    set TheatreOutTime=$e($p(TheatreOutDT," ",2),1,5)
    set PACUInTime=$e($p(PACUInDT," ",2),1,5)
    set PACUOutTime=$e($p(PACUOutDT," ",2),1,5)
    
    kill procedureTimeList
    
    set procedureTimeList(1,"title")="入手术间",procedureTimeList(1,"date")=TheatreInDate,procedureTimeList(1,"time")=TheatreInTime
    set procedureTimeList(2,"title")="麻醉开始",procedureTimeList(2,"date")=AnestStartDate,procedureTimeList(2,"time")=AnestStartTime
    set procedureTimeList(3,"title")="手术开始",procedureTimeList(3,"date")=OperStartDate,procedureTimeList(3,"time")=OperStartTime
    set procedureTimeList(4,"title")="手术结束",procedureTimeList(4,"date")=OperEndDate,procedureTimeList(4,"time")=OperEndTime
    set procedureTimeList(5,"title")="麻醉结束",procedureTimeList(5,"date")=AnestEndDate,procedureTimeList(5,"time")=AnestEndTime
    set procedureTimeList(6,"title")="出手术间",procedureTimeList(6,"date")=TheatreOutDate,procedureTimeList(6,"time")=TheatreOutTime
    set procedureTimeList(7,"title")="入恢复室",procedureTimeList(7,"date")=PACUInDate,procedureTimeList(7,"time")=PACUInTime
    set procedureTimeList(8,"title")="出恢复室",procedureTimeList(8,"date")=PACUOutDate,procedureTimeList(8,"time")=PACUOutTime
    
    set result=##class(CIS.AN.COM.String).ToJson(.procedureTimeList)
    quit result
}

/// w ##class(CIS.AN.BL.DaySurgery).GetAdmTime()
ClassMethod GetAdmTime(A) As %String
{
  
   s AdmTime=$p(^PAADM(A),"^",7)
   s B=##class(web.DHCANOPCom).ConvertToTime(AdmTime)
   s C=$tr(B,":","")
   q C
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperScheduleList","FindOpSDTAndFDT","1")
Query FindOpSDTAndFDT(EpisodeID As %String) As %Query(ROWSPEC = "OPSID,OperStartDT,OperFinishDT") [ SqlProc ]
{
}

ClassMethod FindOpSDTAndFDTExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	q:EpisodeID=""
	set opsIdStr =##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(EpisodeID)
	if (opsIdStr'="")
    {
        set opsIdCount=$l(opsIdStr,",")
        for i=1:1:opsIdCount
        {
			set OperStartDT="",OperFinishDT="",StatusID="",StatusCode=""
            set opsId=$p(opsIdStr,",",i)
            if (##class(CIS.AN.OperSchedule).%ExistsId(opsId)=1)
			{
				set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
				if (operSchedule.Status'="")
            	{
                set StatusID=operSchedule.Status.%Id()
                set StatusCode=operSchedule.Status.Code
            	}
            	continue:StatusCode'="Finish"
				// 麻醉信息
				set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
				set OperStartDT=anaestObj.GetValue("OperStartDT")           // 手术开始时间
				set OperFinishDT=anaestObj.GetValue("OperFinishDT")         // 手术结束时间
				Do OutputRow
			}
        }   
        s qHandle=$lb(0,repid,0)
        q $$$OK 
    }

	

	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=$lb(opsId,OperStartDT,OperFinishDT)
	s ind=ind+1
	q
}

ClassMethod FindOpSDTAndFDTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOpSDTAndFDTExecute ]
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

ClassMethod FindOpSDTAndFDTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOpSDTAndFDTExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// add by wcj 20210514 获取手术概览界面入手术间修改时间
ClassMethod GetStartDTByopsId(opsId As %String) As %String
{
	// 麻醉信息
	set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
	set TheatreInDT=anaestObj.GetValue("TheatreInDT")
	q TheatreInDT
}

}
