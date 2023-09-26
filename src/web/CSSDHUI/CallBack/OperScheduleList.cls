Import sqluser

/// Creator:ban
/// CreatDate:2020-03-23
/// Description:手术排班（此类只提供排班查询功能）
/// Table:CSSD_ExtDevBind
Class web.CSSDHUI.CallBack.OperScheduleList Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.OperScheduleList","FindOperScheduleList",^tmpbin(17))
Query FindOperScheduleList(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId,PatName,PatGender,PatAge,RegNo,MedcareNo,PatientID,SourceTypeDesc,StatusDesc,StatusColor,OperDate,RoomDesc,RoomCode,OperDeptID,OperDeptDesc,OperDesc,HivStatus,HbsStatus,HcvStatus,SypStatus,PatDeptID,PatDeptDesc,SourceType,BedNo") [ SqlProc ]
{
}

ClassMethod FindOperScheduleListExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Params="" $$$OK
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$OK
	s startDate=PJObj.%Get("FStartDate")
	s endDate=PJObj.%Get("FEndDate")
	s POperLocId=PJObj.%Get("OperLocId")
	s regNo=PJObj.%Get("regNo")
	s medcareNo=PJObj.%Get("medcareNo")
	s opsId=PJObj.%Get("opsId")
	s PHospId=PJObj.%Get("gHospId")
	
	i (##class(CIS.AN.OperSchedule).%ExistsId(opsId)=1)
	{
		do OutputRow
		q $$$OK
	}
	/// 登记号查询，不受日期影响
	i (regNo'="")
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
			q $$$OK
		}
	}
	
	s startDateH=..DH2L(startDate)
	s endDateH=..DH2L(endDate)
	q:startDateH>endDateH $$$OK
	
	s Pid=..NewPid()
	k ^TMPCSSD(Pid)
	for date=startDateH:1:endDateH {
		s opsId=0
		for {
			s opsId=$o(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			q:(opsId="")
			s operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			s sourceType=operSchedule.SourceType
			s operAppDeptId=operSchedule.AppDeptID			;手术申请科室id
			s operDeptId=operSchedule.OperDeptID			;手术科室id
			s anaDeptId=operSchedule.AnaDept
			s OperExecDeptID=operSchedule.OperExecDeptID	;手术执行科室
			s tmpDaySurgery=operSchedule.DaySurgery			;日间手术标志
			s tmpOutOper=operSchedule.OPAdmType
			s EpisodeID=operSchedule.EpisodeID				;就诊记录id
			s operSeqNode=+operSchedule.OperSeq
			s:(operSeqNode=0) operSeqNode=99
			
			continue:(POperLocId'="")&&(operDeptId'=POperLocId)
			s hospId1=$p(^CTLOC(operAppDeptId),"^",22)
			s hospId2=$p(^CTLOC(operDeptId),"^",22)
			continue:(hospId1'=hospId2)						//申请科室所在院区要与手术室院区保持一致
			continue:(PHospId'="")&&(hospId2'=PHospId)
			
			set thisRegNo=..GetRegNobyEpisodeID(EpisodeID)
			continue:(+regNo'=0)&&(+thisRegNo'=+regNo)
			s thisMedCareNo=..GetMedicareNo("",EpisodeID)
			continue:(medcareNo'="")&(medcareNo'=thisMedCareNo)
			
			s (curOperRoomDesc)=""
			s:operSchedule.OperRoom'="" curOperRoomDesc=operSchedule.OperRoom.Description
			s roomNode=curOperRoomDesc
			s:roomNode="" roomNode="*"
			
			s SubStr=operSchedule.OperDate_"^"_roomNode_"^"_operSeqNode
			s ^TMPCSSD(Pid,SubStr,opsId)=""
		}
	}
	
	// 排序：按手术日期、手术间、手术台次升序排序
	s SubStr=""
	f  s SubStr=$o(^TMPCSSD(Pid,SubStr)) q:SubStr=""  d
	.s opsId=0
	.f  s opsId=$o(^TMPCSSD(Pid,SubStr,opsId)) q:opsId=""  d
	..d OutputRow
	
	k ^TMPCSSD(Pid)
	q $$$OK
OutputRow
	s ^CacheTemp(repid,ind)=..GetOperSchedule(opsId)
	s ind=ind+1
	q
}

ClassMethod GetOperSchedule(opsId As %String) As %List
{
	n (opsId)
	s operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	s EpisodeID=operSchedule.EpisodeID
	s OperDeptID=operSchedule.OperDeptID
	s PatDeptID=operSchedule.PatDeptID
	s SourceType=operSchedule.SourceType
	s StatusDesc=operSchedule.Status.Description	//状态
	s StatusColor=operSchedule.Status.BGColor	//状态
	s OperDate=operSchedule.OperDate				;手术日期(计划)
	s OperRoomObj=operSchedule.OperRoom
	
	s HivStatus=##class(web.CSSDHUI.Common.PackageInfoCommon).GetSpecialDisease(operSchedule.HivAb)		;艾滋
	s HbsStatus=##class(web.CSSDHUI.Common.PackageInfoCommon).GetSpecialDisease(operSchedule.HbsAg)		;乙肝
	s HcvStatus=##class(web.CSSDHUI.Common.PackageInfoCommon).GetSpecialDisease(operSchedule.HcvAb)		;丙肝
	s SypStatus=##class(web.CSSDHUI.Common.PackageInfoCommon).GetSpecialDisease(operSchedule.Syphilis)	;梅毒
	s OperDeptDesc=""
	i OperDeptID'="" s OperDeptDesc=$p(^CTLOC(OperDeptID),"^",2)
	// 手术申请科室
	s PatDeptDesc=""
	i PatDeptID'="" s PatDeptDesc=$p(^CTLOC(PatDeptID),"^",2)
	s SourceTypeDesc=##class(CIS.AN.OperSchedule).SourceTypeLogicalToDisplay(SourceType) //手术类型	
	s OperDate=..DL2H(OperDate)
	
	// 获取患者信息
	s patInfoObj=##class(User.PAAdm).%OpenId(EpisodeID)
	d patInfoObj.%Reload()
	s PatName=patInfoObj.PAADMPAPMIDR.PAPMIName		//患者姓名
	s PatGender=patInfoObj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc	//患者性别
	s BedNo=patInfoObj.PAADMCurrentBedDR.BEDCode	//床号
	s PatAge=..CalAge(patInfoObj.PAADMPAPMIDR.PAPMIDOB,+$h)	//患者年龄
	s RegNo=patInfoObj.PAADMPAPMIDR.PAPMIIPNo		//登记号
	s MedcareNo=..GetMedicareNo("",EpisodeID)		//住院号
	s PatientID=patInfoObj.PAADMPAPMIDR.%Id()		//患者ID		

	//手术间ID  手术间名称  手术间代码
	s (OperRoom,RoomDesc,RoomCode)=""
	i ($IsObject(OperRoomObj)) d
	.s OperRoom=OperRoomObj.%Id()
	.s RoomDesc=OperRoomObj.Description
	.s RoomCode=OperRoomObj.Code
	s OperDesc=..GetOperDesc(opsId)					;手术名称
	s result=$lb(opsId,PatName,PatGender,PatAge,RegNo,MedcareNo,PatientID,SourceTypeDesc,StatusDesc,StatusColor,OperDate,
		RoomDesc,RoomCode,OperDeptID,OperDeptDesc,OperDesc,HivStatus,HbsStatus,HcvStatus,SypStatus,PatDeptID,
		PatDeptDesc,SourceType,BedNo)
	q result
}

/// Description：	根据登记号获取手术申请ID
/// Table：			CIS_AN.OperSchedule
/// Input:			regNo - 登记号
/// Return：		手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByRegNo("0000000001")
ClassMethod GetOpsIdListByRegNo(regNo As %String) As %String
{
	n (regNo)
	q:regNo="" ""
	
	s PatientID=$o(^PAPERi("PAPMI_PatNo",regNo,""))
	q:PatientID="" ""
	
	s AdmIdStr=""
	s admType=""
	f  s admType=$o(^PAPERdr(PatientID,"ADM",admType)) q:admType=""  d
	.s AdmId=0
	.f  s AdmId=$o(^PAPERdr(PatientID,"ADM",admType,AdmId)) q:AdmId=""  d
	..i AdmIdStr="" s AdmIdStr=AdmId
	..e  s AdmIdStr=AdmIdStr_","_AdmId
	
	s result=..GetOpsIdListByAdm(AdmIdStr)
	q result
}

/// Description：	根据就诊ID获取手术申请ID
/// Table：			CIS_AN.OperSchedule
/// Input:			EpisodeList - 就诊ID字符串，多个就诊ID以","拼接
/// 				allStatusFlag - 全部手术状态标志，默认为N
/// Return：		手术申请ID，多个手术申请ID以","拼接
/// w ##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm("24")
ClassMethod GetOpsIdListByAdm(EpisodeList As %String, allStatusFlag As %String = "N") As %String
{
	n (EpisodeList,allStatusFlag)
	// 设定手术状态代码过滤条件
	// 正常情况查询状态有：申请、审核、接收、安排、入手术室(准备中)、入手术间(术中)、离手术间(术毕)、入恢复室(苏醒中)、离恢复室、离手术室、完成。
	// 如果allStatusFlag为Y，表示查询所有状态的手术申请ID
	s operStatusStr=",Application,Audit,Accept,Receive,Arrange,AreaIn,RoomIn,RoomOut,PACUIn,PACUOut,AreaOut,Finish,"
	&sql(DECLARE OPCursor CURSOR FOR select %ID into :RowId
		from CIS_AN.OperSchedule where (','_:EpisodeList_',') [ (STRING(',',EpisodeID,','))
		and (:operStatusStr [ (STRING(',',Status->Code,',')) or :allStatusFlag="Y")
	)
	&sql(OPEN OPCursor)
	s result=""
	f  &sql(fetch OPCursor) q:SQLCODE  d
	.s:(result'="") result=result_","
	.s result=result_RowId
	&sql(CLOSE OPCursor)
	
	q result
}

ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
	n (EpisodeID)
	q:EpisodeID="" ""
	q:'$d(^PAADM(EpisodeID)) ""
	s PaitentID=$p(^PAADM(EpisodeID),"^",1)
	s admType=$p(^PAADM(EpisodeID),"^",2)
	q:PaitentID="" ""
	q:'$D(^PAPER(PaitentID,"PAT",1)) ""
	q:admType="I" $p(^PAPER(PaitentID,"PAT",1),"^",1)
	q $p(^PAPER(PaitentID,"PAT",1),"^",2)
}

ClassMethod GetMedicareNo(papmiId, EpisodeID) As %String
{
	n (papmiId,EpisodeID)
	q:(papmiId="")&(EpisodeID="") ""
	i papmiId="" s papmiId=+$g(^PAADM(+EpisodeID))
	q:papmiId="" ""
	s medicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s MedType=$P(^PAADM(EpisodeID),"^",2)
	s tmpMedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
	s:(+tmpMedicareNo>0) medicareNo=tmpMedicareNo

	q medicareNo
}

/// 获取手术名称
/// w ##class(web.CSSDHUI.CallBack.OperScheduleList).GetOperDesc(4)
ClassMethod GetOperDesc(opsId As %String) As %String
{
	n (opsId)
	q:opsId="" ""
	
	s OperDescStr=""
	;CIS.AN.PlanOperList	拟施手术表
	;User.ORCOperation		手术名称表-手术名称字典^ORC
	s OperPlanId=""
	f  s OperPlanId=$o(^CIS.AN.PlanOperListI("IOPS",opsId,OperPlanId)) q:OperPlanId=""  d
	.s OperId=$lg(^CIS.AN.PlanOperListD(OperPlanId),2)
	.q:OperId=""
	.s OperDesc=$p($g(^ORC("OPER",OperId)),"^",2)
	.i OperDescStr="" s OperDescStr=OperDesc
	.e  s OperDescStr=OperDescStr_","_OperDesc
	
	q OperDescStr
}

/// 根据出生日期算年龄
ClassMethod CalAge(iBirth As %String, iDate As %String, ifExact = 0, retAgeType = "") As %String [ SqlProc ]
{
	n (iBirth,iDate,ifExact,retAgeType)
	i iBirth>2980000 s iBirth=""
	i iBirth<0 s iBirth=""
	q:iBirth="" ""
	s dayDiff=iDate-iBirth
	q:dayDiff<0 ""
	q:retAgeType="D" dayDiff_"日"
	s XBirth=$ZD(iBirth)
	s XToday=$ZD(iDate)
	s ageMonth=XToday-XBirth
	s ageDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
	s currYear=$p(XToday,"/",3) s:currYear<100 currYear=currYear+1900
	s birthYear=$p(XBirth,"/",3) s:birthYear<100 birthYear=birthYear+1900
	s ageYear=currYear-birthYear
	i ageDay<0 d
	.s ageMonth=ageMonth-1
	.s ageDay=ageDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	.q:XToday'=2
	.s:((currYear#4)=0)&(((currYear#100)'=0)!((currYear#400)=0)) ageDay=ageDay+1
	i ageMonth<0 s ageMonth=ageMonth+12,ageYear=ageYear-1
	q:retAgeType="M" (ageYear*12+ageMonth)_"月"
	q:retAgeType="Y" ageYear_"岁"
	q:ifExact ageYear_"岁"_ageMonth_"月"_ageDay_"天"
	s retAge=""
	i (ageYear>0) d
	.s retAge=ageYear_"岁"
	.i ageYear<3 s retAge=retAge_ageMonth_"月"
	e  d
	.i (ageMonth>0) d 
	..s retAge=ageMonth_"月"
	..i ageMonth<3 s retAge=retAge_ageDay_"日"
	.e  d
	..s retAge=ageDay_"日"
	
	q retAge
}

/// 老版本临床程序, 没有"手术列表"相应类时, 使用该Query
/// 手术排班取值Query
/// Input:		StartDate(YYYY-mm-dd或$h类型), EndDate
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.CallBack.OperScheduleList","ANOPArrData","2020-08-06","2020-08-06")
/// Call web_CSSDHUI_CallBack.OperScheduleList_ANOPArrData("2020-08-06","2020-08-06")
Query ANOPArrData(StartDate As %String, EndDate As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId,PatName,PatGender,PatAge,RegNo,MedcareNo,PatientID,SourceTypeDesc,StatusDesc,OperDate,RoomDesc,RoomCode,OperDeptID,OperDeptDesc,Diagnosis,AdmId,AppLocId,AppLocDesc,OPDoctorId,OPDoctorName,OperDesc,AppDateTime,AppUserId,AppUserName,ExeLocId,ExeLocDesc,LabResult") [ SqlProc ]
{
}

ClassMethod ANOPArrDataExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
	;备用参数
	s PAAdmId=""
	s PLocId=""			;申请科室
	s POPStatus=""		;状态
	s POperLocId=""		;手术科室
	s PRowId=""			;某条
	
	i (PRowId'="") d
	.s opaId=PRowId
	.d OutputANARow
	e  i (PAAdmId'="") d
	.s opaId=""
	.f  s opaId=$O(^DHCANOPArrange(0,"Adm",PAAdmId,opaId)) q:opaId=""  d
	..d OutputANARow
	e  d
	.f Date=StartDate:1:EndDate d
	..s opaId=""
	..f  s opaId=$O(^DHCANOPArrange(0,"SDate",Date,opaId)) q:opaId=""  d
	...d OutputANARow  
	
	Quit $$$OK

OutputANARow
	s Data=$$GetANOperationSingle(opaId)
	q:Data=""
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
GetANOperationSingle(opaId)
	s AdmId=$p(^DHCANOPArrange(opaId),"^",1)
	s anaId=$p(^DHCANOPArrange(opaId),"^",2)			;手术麻醉Id
	s opaAppDate=$p(^DHCANOPArrange(opaId),"^",3)		;申请日期
	s opaAppTime=$p(^DHCANOPArrange(opaId),"^",5)		;申请时间
	s arrDate=$p(^DHCANOPArrange(opaId),"^",7)
	s arrTime=$p(^DHCANOPArrange(opaId),"^",8)
	s arrUserDr=$p(^DHCANOPArrange(opaId),"^",9)
	s opaPlanStartDate=$p(^DHCANOPArrange(opaId),"^",14)
	s opaPlanStartTime=$p(^DHCANOPArrange(opaId),"^",15)
	s OPAEndDate=$p(^DHCANOPArrange(opaId),"^",16)
	s OPAEndTime=$p(^DHCANOPArrange(opaId),"^",17)
	s oproomdr=$p(^DHCANOPArrange(opaId),"^",20)
	s stat=$p(^DHCANOPArrange(opaId),"^",27)
	s appLocId=$p(^DHCANOPArrange(opaId),"^",54)  ;申请科室
	
	s anaSub=$p(anaId,"||",2)
	q:anaSub="" ""
	q:AdmId="" ""
	q:(PAAdmId'="")&(PAAdmId'=AdmId) ""
	q:(POPStatus'="")&((POPStatus'[stat)!(stat="")) ""
	i appLocId="" s appLocId=$p(^PAADM(AdmId),"^",4)
	q:(PLocId'="")&(PLocId'=appLocId) ""
	
	s opaStatus=""		;手术状态
	i stat="A" s opaStatus="申请"
	e  i stat="S" s opaStatus="拟日间"
	e  i stat="D" s opaStatus="拒绝"
	e  i stat="C" s opaStatus="撤销"
	e  i stat="R" s opaStatus="安排"
	e  i stat="N" s opaStatus="非预约"
	e  i stat="I" s opaStatus="术中"
	e  i stat="P" s opaStatus="恢复室"
	e  i stat="L" s opaStatus="术毕"
	e  i stat="F" s opaStatus="完成"
	e  i stat="" s opaStatus="未审核"
	
	s opaAppDate=$zd(opaAppDate,3),opaAppTime=$zt(opaAppTime,1)
	s AppDateTime=opaAppDate_" "_opaAppTime
	
	s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)			//OPA_PATestHBsAg  	免疫乙肝表面抗原
	s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)			//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)			//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)			//OPA_PATestTPAb 	免疫梅毒
	s qt=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)			//OPA_PATestOther	检其它阴阳性
	s LabResult=""
	i yg="阳性" s LabResult=LabResult_"乙肝阳性"_" "
	i bg="阳性" s LabResult=LabResult_"丙肝阳性"_" "
	i az="阳性" s LabResult=LabResult_"艾滋病阳性"_" "
	i md="阳性" s LabResult=LabResult_"梅毒阳性"_" "
	i qt="阳性" s LabResult=LabResult_"其他阳性"_" "
	
	
	s anaSourceType=$p(^OR(AdmId,"ANA",anaSub),"^",32)			;ANA_SourceType 急诊(E)/择期(B)
	s opStartDate=$p(^OR(AdmId,"ANA",anaSub),"^",39)
	s opsttime=$p(^OR(AdmId,"ANA",anaSub),"^",40)
	s openddate=$p(^OR(AdmId,"ANA",anaSub),"^",41)
	s opendtime=$p(^OR(AdmId,"ANA",anaSub),"^",42)
	i opStartDate="" s opStartDate=opaPlanStartDate,opsttime=opaPlanStartTime
	i opStartDate'="" s opStartDate=$ZD(opStartDate,3)
	i opsttime'="" s opsttime=$ZT(opsttime,1)
	i openddate="" s openddate=OPAEndDate,opendtime=OPAEndTime
	i openddate'="" s openddate=$zd(openddate,3)
	i opendtime'="" s opendtime=$zt(opendtime,1)
	
	i openddate<opStartDate s openddate="",opendtime=""
	s opTime=opStartDate_" "_opsttime_"~"_openddate_" "_opendtime
	
	s opaAppLoc=$p(^CTLOC(appLocId),"^",2)
	s (opaOpRoom,arrUser)=""
	i oproomdr'="" s opaOpRoom=$p(^DHCANC("OPRoom",oproomdr),"^",2)
	i arrUserDr'="" s arrUser=$p(^SSU("SSUSR",arrUserDr),"^",2)

	i anaSourceType="E" s anaSourceTypeDesc="急诊"
	e  s anaSourceTypeDesc="择期"
	
	s (anaOPSurgeonDR,anaOPSurgeonDR)=""
	s anaopSub=$o(^OR(AdmId,"ANA",anaSub,"OP",0))
	i anaopSub'="" d
	.;OR_Anaest_Operation
	.s anaOPSurgeonDR=$p(^OR(AdmId,"ANA",anaSub,"OP",anaopSub),"^",8)			;ANAOP_Surgeon_DR  ；手术医师
	.s anaOpSurgeon=##class(web.DHCClinicCom).GetNameById(anaOPSurgeonDR)
	
	s diag=""
	s anaopSub=0
	f  s anaopSub=$O(^OR(AdmId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	.s predigdrS=$p(^OR(AdmId,"ANA",anaSub,"OP",anaopSub),"^",4)				;ANAOP_PreopDiag_DR 术前诊断字符串  zhangtao add
	.s num=$l(predigdrS,"|")
	.f pi=1:1:num d
	..s predigdr=$p(predigdrS,"|",pi)
	..i predigdr'="" d
	...s anaOPPreopDiagDR=$p(^MRC("ID",predigdr),"^",2)
	...s $p(diag,",",pi)=anaOPPreopDiagDR
	..e  d
	...i $g(^OR(AdmId,"ANA",anaSub,"TXT",2))'="" d
	....s diamen=$p(^OR(AdmId,"ANA",anaSub,"TXT",2),"|",pi)
	....s $p(diag,",",pi)=diamen
	
	s operLocId=""
	s anaopSub=0
	f  s anaopSub=$o(^OR(AdmId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	.q:$p(^OR(AdmId,"ANA",anaSub,"OP",anaopSub),"^",12)'="M"					;ANAOP_OperType
	.s operLocId=$p(^OR(AdmId,"ANA",anaSub,"OP",anaopSub),"^",10)				;ANAOP_CTLOC_DR
	q:(POperLocId'=operLocId)&&(POperLocId'="") ""
	
	s (opName,operId)=""
	s anaopSub=0
	f  s anaopSub=$O(^OR(AdmId,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	.s curOperId=$p(^OR(AdmId,"ANA",anaSub,"OP",anaopSub),"^",6)				;ANAOP_Type_DR；手术名称
	.i curOperId="" s opName=opName_$G(^OR(AdmId,"ANA",anaSub,"OP",anaopSub,"REM",2)) 
	.q:curOperId=""
	.i $d(^ORC("OPER",curOperId)) d
	..i opName="" s opName=$p(^ORC("OPER",curOperId),"^",2),operId=curOperId
	..e  s opName=opName_","_$p(^ORC("OPER",curOperId),"^",2),operId=operId_"|"_curOperId
	
	;执行科室: 没有单独的字段,8.3之前都是按照申请科室判断
	s ExeLocId=appLocId,ExeLocDesc=opaAppLoc
	s operDeptDesc=$s(operLocId'="":$p(^CTLOC(operLocId),"^",2),1:"")
	
	s PapmiId=$p(^PAADM(AdmId),"^",1)
	s RegNo=$p(^PAPER(PapmiId,"PAT",1),"^",1)
	s PatName=$p(^PAPER(PapmiId,"ALL"),"^",1)
	s Birth=$p(^PAPER(PapmiId,"ALL"),"^",6)
	s Sex=$p(^PAPER(PapmiId,"ALL"),"^",7)
	s medCareNo=$p(^PAPER(PapmiId,"PAT",1),"^",22)
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PapmiId,AdmId)
	s Sex=$s(Sex'="":$p(^CT("SEX",Sex),"^",2),1:"")
	
	/*
	opsId,PatName,PatGender,PatAge,RegNo,
	排班id,患者姓名,性别,年龄,登记号,

	MedcareNo,PatientID,SourceTypeDesc,StatusDesc,OperDate,
	住院号,患者ID(Papmi),手术类型(急诊或择期),排班状态,手术日期,

	RoomDesc,RoomCode,OperDeptID,OPDoctorId,Diagnosis
	手术间名称,手术间代码,手术室Id,手术室名称,诊断,
	
	AdmId,AppLocId,AppLocDesc,anaOPSurgeonDR,anaOpSurgeon,
	就诊Id,申请科室ID,申请科室,手术医生编码(需确认是否ss_user),手术医生姓名,
	
	OperName,AppDateTime,AppUserId,AppUserName,ExeLocId,ExeLocDesc,
	手术名称,申请日期,申请人Id,申请人姓名,执行科室id,执行科室名称,

	LabResult,
	检查结果(乙肝等),
	*/
	
	s Data=$lb(opaId,PatName,Sex,Age,RegNo,
		medCareNo,PapmiId,anaSourceTypeDesc,opaStatus,opStartDate,
		opaOpRoom,oproomdr,operLocId,operDeptDesc,diag,
		AdmId,appLocId,opaAppLoc,anaOPSurgeonDR,anaOpSurgeon,
		opName,AppDateTime,arrUserDr,arrUser,ExeLocId,ExeLocDesc,
		LabResult
	)
	q Data
}

}
