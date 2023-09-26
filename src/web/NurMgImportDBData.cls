/// Creator：gzj
/// Description：Vue版护管后台导入数据 
/// Date：2017-10-21
Class web.NurMgImportDBData Extends %RegisteredObject
{

/// 
/// Creator:gzj
/// Description:导入科室数据
/// Date:2017-10-21
/// Table:HCNMG.DB.MgWard
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod ImportWard() As %String
{
	s rw="" f  s rw=$O(^DHCNMNURSE("DHCNMNURSE","nursers",rw)) q:rw=""  d
	.s list=^DHCNMNURSE("DHCNMNURSE","nursers",rw)
	.q:+list
	.s ward=$p(list,"^",3)
	.s row=$O(^DHCNMG.DB.MgWardI("Code"," "_$zcvt($tr(ward," ",""),"U"),""))
	.q:row'=""
	.s obj=##class(DHCNMG.DB.MgWard).%New()
	.s obj.WardCode=$zcvt($tr(ward," ",""),"U")
	.s obj.WardDesc=$zcvt($tr(ward," ",""),"U")
	.s obj.WardStDate=$zdh("2017-10-01",3)
	.s obj.WardSpell=##class(web.NurMgVueComm).ToChineseSpell($zcvt($tr(ward," ",""),"U"))
	.d obj.%Save()
	q 0
}

ClassMethod ImportSchool() As %String
{
	s rw="" f  s rw=$O(^DHCNMNURSE("DHCNMNURSE","nursers",rw)) q:rw=""  d
	.s list=^DHCNMNURSE("DHCNMNURSE","nursers",rw)
	.q:+list
	.s school=$p(list,"^",41)
	.q:school=""
	.s row=$O(^DHCNMG.DB.MgSetCodeSubI("Code",20," "_$zcvt($tr(school," ",""),"U"),""))
	.q:row'=""
	.s obj=##class(DHCNMG.DB.MgSetCodeSub).%New()
	.s obj.Parref=##class(DHCNMG.DB.MgSetCode).%OpenId("20")
	.s obj.SubCode=$zcvt($tr(school," ",""),"U")
	.s obj.SubDesc=$zcvt($tr(school," ",""),"U")
	.s obj.SubStDate=$zdh("2017-09-01",3)
	.d obj.%Save()
	q 0
}

ClassMethod ImportNurseInfo() As %String
{
	s rw="" f  s rw=$O(^DHCNMNURSE("DHCNMNURSE","nursers",rw)) q:rw=""  d
	.s list=^DHCNMNURSE("DHCNMNURSE","nursers",rw)
	.q:+list
	.s nurseid=$zcvt($tr($p(list,"^",1)," ",""),"U") //工号
	.s ward=$zcvt($tr($p(list,"^",3)," ",""),"U") //病区
	.s name=$zcvt($tr($p(list,"^",4)," ",""),"U") //姓名
	.s sex=$zcvt($tr($p(list,"^",5)," ",""),"U") //性别
	.s birth=$zcvt($tr($p(list,"^",6)," ",""),"U") //出生日期
	.s icard=$zcvt($tr($p(list,"^",8)," ",""),"U") //身份证
	.s nation=$zcvt($tr($p(list,"^",9)," ",""),"U") //民族
	.s political=$zcvt($tr($p(list,"^",10)," ",""),"U") //政治面貌
	.s duty=$zcvt($tr($p(list,"^",12)," ",""),"U") //职称
	.s nativePlace=$zcvt($tr($p(list,"^",14)," ",""),"U") //籍贯
	.s phone=$zcvt($tr($p(list,"^",16)," ",""),"U") //联系电话
	.s source=$zcvt($tr($p(list,"^",17)," ",""),"U") //职工性质
	.s workDate=$zcvt($tr($p(list,"^",18)," ",""),"U") //参加工作日期
	.s comeDate=$zcvt($tr($p(list,"^",20)," ",""),"U") //来院日期
	.s CadreDate=$zcvt($tr($p(list,"^",21)," ",""),"U") //提干日期
	.s row=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_nurseid,""))
	.q:row'=""
	.s obj=##class(DHCNMG.HR.MgPersons).%New()
	.s obj.PerID=nurseid
	.s obj.PerDepDR=..getWardId(ward)
	.s obj.PerName=name
	.s obj.PerSexDR=..getPubCode("性别",sex)
	.i birth'="" s obj.PerBirthday=$zdh(birth,3)
	.e  s obj.PerBirthday=""
	.s obj.PerCardId=icard
	.s obj.PerNation=..getPubCode("民族",nation)
	.s obj.PerPolitical=..getPubCode("政治面貌",political)
	.s obj.PerNativePlace=nativePlace
	.s obj.PerPhone=phone
	.s obj.PerSource=..getPubCode("职工性质",source)
	.i workDate'="" s obj.PerWorkDate=$zdh(workDate,3)
	.e  s obj.PerWorkDate=""
	.i comeDate'="" s obj.PerComeDate=$zdh(comeDate,3)
	.e  s obj.PerComeDate=""
	.i CadreDate'="" s obj.PerCadreDate=$zdh(CadreDate,3)
	.e  s obj.PerCadreDate=""
	.s obj.PerCareType="N"
	.s obj.PerTypeDR="N"
	.s obj.PerStatus="17||1"
	.s obj.PerDepDate=+$H
	.d obj.%Save()
	.s transRowID=$O(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_obj.%Id(),""))
	.i transRowID="" d
	..s TransFlag=##class(web.NurMgPersonComm).SaveTransData("^"_obj.%Id()_"^"_obj.PerDepDR_"^"_$zd(obj.PerDepDate,3)_"^"_$zt($P($H,",",2),1)_"^Y^")	
	.e  d
	..s aa=##class(DHCNMG.HR.MgTransDep).%OpenId(transRowID)
	..s aa.PerDr=obj.%Id()
    ..s aa.PerDepart=obj.PerDepDR
    ..s aa.PerTranStDate=obj.PerDepDate
    ..s aa.PerTranCurrent="Y"
    ..s aa.PerTranStTime=$P($H,",",2)
    ..s aa.PerTransType="L"
    ..d aa.%Save()
}

ClassMethod getWardId(ward) As %String
{
	s ret=""
	s rw=$O(^DHCNMG.DB.MgWardI("Code"," "_ward,""))
	i rw'="" s ret=rw
	q ret
}

ClassMethod getPubCode(pubcode, desc) As %String
{
	s ret=""
	s par=$O(^DHCNMG.DB.MgSetCodeI("Code"," "_pubcode,""))
	q:par="" ""
	s rw=$O(^DHCNMG.DB.MgSetCodeSubI("Code",par," "_desc,""))
	i rw'="" s ret=par_"||"_rw
	q ret
}

ClassMethod UpdatePersonTmp() As %String
{
	s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsD(rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	.q:obj.PerTypeDR'="N"
	.s rw=$O(^DHCNMG.HR.MgPersonsTmpD(""))
	.s rw=$O(^DHCNMG.HR.MgPersonsTmpI("PersonID"," "_rowid,""))
	.i rw="" s object=##class(DHCNMG.HR.MgPersonsTmp).%New()
	.e  s object=##class(DHCNMG.HR.MgPersonsTmp).%OpenId(rw)
	.s object.PerAddress=obj.PerAddress
	.s object.PerAuditDate=obj.PerAuditDate
	.s object.PerAuditFlag=obj.PerAuditFlag
	.s object.PerAuditor=obj.PerAuditor
	.s object.PerBirthday=obj.PerBirthday
	.s object.PerCadreDate=obj.PerCadreDate
	.s object.PerCardId=obj.PerCardId
	.s object.PerCareType=obj.PerCareType
	.s object.PerClothesNo=obj.PerClothesNo
	.s object.PerComeDate=obj.PerComeDate
	.s object.PerContact=obj.PerContact
	.s object.PerDepDate=obj.PerDepDate
	.s object.PerDepDR=obj.PerDepDR
	.s object.PerHeight=obj.PerHeight
	.s object.PerHireDuty=obj.PerHireDuty
	.s object.PerHireDutyDate=obj.PerHireDutyDate
	.s object.PerHomeAddress=obj.PerHomeAddress
	.s object.PerHosShortNo=obj.PerHosShortNo
	.s object.PerHouseAddress=obj.PerHouseAddress
	.s object.PerID=obj.PerID
	.s object.PerLocDR=obj.PerLocDR
	.s object.PerMarriage=obj.PerMarriage
	.s object.PerName=obj.PerName
	.s object.PerNation=obj.PerNation
	.s object.PerNativePlace=obj.PerNativePlace
	.s object.PerNo=obj.PerNo
	.s object.PerNurType=obj.PerNurType
	.s object.PerPhone=obj.PerPhone
	.s object.PerPolitDate=obj.PerPolitDate
	.s object.PerPolitical=obj.PerPolitical
	.s object.PerPostDuty=obj.PerPostDuty
	.s object.PerPostDutyDate=obj.PerPostDutyDate
	.s object.PerRegNo=obj.PerRegNo
	.s object.PerResignDate=obj.PerResignDate
	.s object.PerRetireDate=obj.PerRetireDate
	.s object.PerSexDR=obj.PerSexDR
	.s object.PerShoesNo=obj.PerShoesNo
	.s object.PersonID=rowid
	.s object.PerSource=obj.PerSource
	.s object.PerStateDate=obj.PerStateDate
	.s object.PerStatus=obj.PerStatus
	.s object.PerTransFlag=obj.PerTransFlag
	.s object.PerTrouserNo=obj.PerTrouserNo
	.s object.PerTypeDR=obj.PerTypeDR
	.s object.PerUserDR=obj.PerUserDR
	.s object.PerWordType=obj.PerWordType
	.s object.PerWorkDate=obj.PerWorkDate
	.d object.%Save()
	q 0
}

/// 清楚未使用global,删除的表
/// d ##class(web.NurMgImportDBData).ClearIsDeleteGlobal()
ClassMethod ClearIsDeleteGlobal() As %String
{
	k ^DHCNMG.DB.MgAgHolidayD
	k ^DHCNMG.DB.MgAgHolidayI
	k ^DHCNMG.DB.MgInternScoreC
	k ^DHCNMG.Intern.MgQuantifySubD
	k ^DHCNMG.Intern.MgQuantifySubI
	k ^DHCNMG.Set.MgRolesC
	k ^DHCNMG.Set.MgSetCodeD
	k ^DHCNMG.Set.MgSetCodeI
	k ^DHCNMG.Set.MgSetCodeSubD
	q 0
}

/// 清业务数据
/// d ##class(web.NurMgImportDBData).ClearVueData()
ClassMethod ClearVueData() As %String
{
	k ^DHCNMG.Arg.MgArgDayWorkI
	k ^DHCNMG.Arg.MgArgDayWorkD
	k ^DHCNMG.Arg.MgArgModelI
	k ^DHCNMG.Arg.MgArgModelD
	k ^DHCNMG.Arg.MgArgModelSubI
	k ^DHCNMG.Arg.MgArgModelSubD
	k ^DHCNMG.Arg.MgArgMonthWorkI
	k ^DHCNMG.Arg.MgArgMonthWorkD
	k ^DHCNMG.Arg.MgArgMonthWorkSubI
	k ^DHCNMG.Arg.MgArgMonthWorkSubD
	k ^DHCNMG.Arg.MgArrangeI
	k ^DHCNMG.Arg.MgArrangeD
	k ^DHCNMG.Arg.MgArrangeGroupI
	k ^DHCNMG.Arg.MgArrangeGroupD
	k ^DHCNMG.Arg.MgArrangeLogI
	k ^DHCNMG.Arg.MgArrangeLogD
	k ^DHCNMG.Arg.MgArrangeRowI
	k ^DHCNMG.Arg.MgArrangeRowD
	k ^DHCNMG.Arg.MgArrangeSubI
	k ^DHCNMG.Arg.MgArrangeSubD
	k ^DHCNMG.Arg.MgAskLeaveI
	k ^DHCNMG.Arg.MgAskLeaveD
	k ^DHCNMG.Arg.MgAskLeaveLogI
	k ^DHCNMG.Arg.MgAskLeaveLogD
	k ^DHCNMG.Arg.MgAttendanceI
	k ^DHCNMG.Arg.MgAttendanceD
	k ^DHCNMG.Arg.MgAttendanceSubI
	k ^DHCNMG.Arg.MgAttendanceSubD
	k ^DHCNMG.Arg.MgCheckContentI
	k ^DHCNMG.Arg.MgCheckContentD
	k ^DHCNMG.Arg.MgClinicDayWorkI
	k ^DHCNMG.Arg.MgClinicDayWorkD
	k ^DHCNMG.Arg.MgDNCheckSubI
	k ^DHCNMG.Arg.MgDNCheckSubD
	k ^DHCNMG.Arg.MgDutyNurCheckI
	k ^DHCNMG.Arg.MgDutyNurCheckD
	k ^DHCNMG.Arg.MgNHCheckSubI
	k ^DHCNMG.Arg.MgNHCheckSubD
	k ^DHCNMG.Arg.MgNHTrackPatI
	k ^DHCNMG.Arg.MgNHTrackPatD
	k ^DHCNMG.Arg.MgNHTrackReviewSubI //南方
	k ^DHCNMG.Arg.MgNHTrackReviewSubD //南方
	k ^DHCNMG.Arg.MgNHTrackSubI
	k ^DHCNMG.Arg.MgNHTrackSubD	
	k ^DHCNMG.Arg.MgNurGroupI
	k ^DHCNMG.Arg.MgNurGroupD
	k ^DHCNMG.Arg.MgNurHeadCheckI
	k ^DHCNMG.Arg.MgNurHeadCheckD
	k ^DHCNMG.Arg.MgNurHeadTrackI
	k ^DHCNMG.Arg.MgNurHeadTrackD
	k ^DHCNMG.Arg.MgNurLeaveAppI
	k ^DHCNMG.Arg.MgNurLeaveAppD
	k ^DHCNMG.Arg.MgNurNurHeadAppI
	k ^DHCNMG.Arg.MgNurNurHeadAppD
	k ^DHCNMG.Arg.MgNurTrainI
	k ^DHCNMG.Arg.MgNurTrainD
	k ^DHCNMG.Arg.MgNurTrainSubI
	k ^DHCNMG.Arg.MgNurTrainSubD
	k ^DHCNMG.Arg.MgWishArrangeI
	k ^DHCNMG.Arg.MgWishArrangeD
	k ^DHCNMG.CHK.MgCheckQuesI
	k ^DHCNMG.CHK.MgCheckQuesD
	k ^DHCNMG.CHK.MgCheckQuesSubI
	k ^DHCNMG.CHK.MgCheckQuesSubD
	k ^DHCNMG.CHK.MgCheckRoomI
	k ^DHCNMG.CHK.MgCheckRoomD
	k ^DHCNMG.CHK.MgCheckRoomSubI
	k ^DHCNMG.CHK.MgCheckRoomSubD
	k ^DHCNMG.CHK.MgKpiCheckI
	k ^DHCNMG.CHK.MgKpiCheckD
	k ^DHCNMG.CHK.MgKpiCheckSubI
	k ^DHCNMG.CHK.MgKpiCheckSubD
	k ^DHCNMG.CHK.MgKpiQustionI
	k ^DHCNMG.CHK.MgKpiQustionD
	k ^DHCNMG.CHK.MgNurCheckGroupI
	k ^DHCNMG.CHK.MgNurCheckGroupD
	k ^DHCNMG.CHK.MgNurCheckPlanI
	k ^DHCNMG.CHK.MgNurCheckPlanD
	k ^DHCNMG.CHK.MgNurCheckPlanSubI
 	k ^DHCNMG.CHK.MgNurCheckPlanSubD
 	k ^DHCNMG.CHK.MgNurCheckShiftI
 	k ^DHCNMG.CHK.MgNurCheckShiftD
	k ^DHCNMG.CHK.MgNurHeadSchduleI
	k ^DHCNMG.CHK.MgNurHeadSchduleD
	k ^DHCNMG.CHK.MgNurNightBasicI
	k ^DHCNMG.CHK.MgNurNightBasicD
 	k ^DHCNMG.CHK.MgNurNightCheckI	
 	k ^DHCNMG.CHK.MgNurNightCheckD
 	k ^DHCNMG.CHK.MgNurNightCheckSubI
 	k ^DHCNMG.CHK.MgNurNightCheckSubD
 	k ^DHCNMG.CHK.MgNurNightTaskI
 	k ^DHCNMG.CHK.MgNurNightTaskD
 	k ^DHCNMG.CHK.MgNurTaskGroupI
 	k ^DHCNMG.CHK.MgNurTaskGroupD
 	k ^DHCNMG.CHK.MgNurTaskReleaseI
 	k ^DHCNMG.CHK.MgNurTaskReleaseD
 	k ^DHCNMG.CHK.MgWardImproveI
 	k ^DHCNMG.CHK.MgWardImproveD
	k ^DHCNMG.DB.MgDataLimitI
	k ^DHCNMG.DB.MgDataLimitD
	k ^DHCNMG.DB.MgDataLimitSubI
	k ^DHCNMG.DB.MgDataLimitSubD 
	k ^DHCNMG.DB.MgMergeHisInfoI 
	k ^DHCNMG.DB.MgMergeHisInfoD
	k ^DHCNMG.Event.MgExcellentI
	k ^DHCNMG.Event.MgExcellentD
	k ^DHCNMG.Handbook.AnnualYearI
	k ^DHCNMG.Handbook.AnnualYearD
	k ^DHCNMG.Handbook.HiddenDNotesI
	k ^DHCNMG.Handbook.HiddenDNotesD
	k ^DHCNMG.Handbook.IllDiscussI
	k ^DHCNMG.Handbook.IllDiscussD
	k ^DHCNMG.Handbook.MgHNHDPWorkI
	k ^DHCNMG.Handbook.MgHNHDPWorkD
	k ^DHCNMG.Handbook.MgHNHMemoI
	k ^DHCNMG.Handbook.MgHNHMemoD
	k ^DHCNMG.Handbook.MgHNHPerInfoI
	k ^DHCNMG.Handbook.MgHNHPerInfoD
	k ^DHCNMG.Handbook.MgHNHWorkSumI
	k ^DHCNMG.Handbook.MgHNHWorkSumD
	k ^DHCNMG.Handbook.MgWardRoundI
	k ^DHCNMG.Handbook.MgWardRoundD
	k ^DHCNMG.Handbook.MonthPlanI
	k ^DHCNMG.Handbook.MonthPlanD
	k ^DHCNMG.Handbook.NurConsultaI
	k ^DHCNMG.Handbook.NurConsultaD
	k ^DHCNMG.Handbook.WardRoundI
	k ^DHCNMG.Handbook.WardRoundD
	k ^DHCNMG.Handbook.WorkPlanI
	k ^DHCNMG.Handbook.WorkPlanD
	k ^DHCNMG.HR.MgAcadMeetingI
	k ^DHCNMG.HR.MgAcadMeetingD
	k ^DHCNMG.HR.MgAcaposI
	k ^DHCNMG.HR.MgAcaposD
	k ^DHCNMG.HR.MgAwardI
	k ^DHCNMG.HR.MgAwardD
	k ^DHCNMG.HR.MgEducateI
	k ^DHCNMG.HR.MgEducateD
	k ^DHCNMG.HR.MgGuideI
	k ^DHCNMG.HR.MgGuideD
	k ^DHCNMG.HR.MgHireDutyI
	k ^DHCNMG.HR.MgHireDutyD
	k ^DHCNMG.HR.MgInternI
	k ^DHCNMG.HR.MgInternD
	k ^DHCNMG.HR.MgLevelI
	k ^DHCNMG.HR.MgLevelD
	k ^DHCNMG.HR.MgNewNurEducateI
	k ^DHCNMG.HR.MgNewNurEducateD
	k ^DHCNMG.HR.MgNurNewNursesI
	k ^DHCNMG.HR.MgNurNewNursesD
	k ^DHCNMG.HR.MgNurNormalTransI
	k ^DHCNMG.HR.MgNurNormalTransD
	k ^DHCNMG.HR.MgNurNormalTransSubI
	k ^DHCNMG.HR.MgNurNormalTransSubD
	k ^DHCNMG.HR.MgNurNormativeI
	k ^DHCNMG.HR.MgNurNormativeD
	k ^DHCNMG.HR.MgNurNormativeDateI
	k ^DHCNMG.HR.MgNurNormativeDateD
	k ^DHCNMG.HR.MgNurNormativeGroupI
	k ^DHCNMG.HR.MgNurNormativeGroupD
	k ^DHCNMG.HR.MgNurNormativeSubI
	k ^DHCNMG.HR.MgNurNormativeSubD
	k ^DHCNMG.HR.MgNurRewardI
	k ^DHCNMG.HR.MgNurRewardD
	k ^DHCNMG.HR.MgNurRoleI
	k ^DHCNMG.HR.MgNurRoleD
	k ^DHCNMG.HR.MgNurseResignI
	k ^DHCNMG.HR.MgNurseResignD
	k ^DHCNMG.HR.MgNurTrainInfoI
	k ^DHCNMG.HR.MgNurTrainInfoD
	k ^DHCNMG.HR.MgNurTrainingI
	k ^DHCNMG.HR.MgNurTrainingD
	k ^DHCNMG.HR.MgNurTrainingSubI
	k ^DHCNMG.HR.MgNurTrainingSubD
	k ^DHCNMG.HR.MgPersonDataI
	k ^DHCNMG.HR.MgPersonDataD
	k ^DHCNMG.HR.MgPersonsI
	k ^DHCNMG.HR.MgPersonsD
	k ^DHCNMG.HR.MgPersonUpdateI
	k ^DHCNMG.HR.MgPersonUpdateD
	k ^DHCNMG.HR.MgPostDutyI
	k ^DHCNMG.HR.MgPostDutyD
	k ^DHCNMG.HR.MgPromoteI
	k ^DHCNMG.HR.MgPromoteD
	k ^DHCNMG.HR.MgResearchI
	k ^DHCNMG.HR.MgResearchD
	k ^DHCNMG.HR.MgSepcialDevelopI
	k ^DHCNMG.HR.MgSepcialDevelopD
	k ^DHCNMG.HR.MgSupportI
	k ^DHCNMG.HR.MgSupportD
	k ^DHCNMG.HR.MgTeachI
	k ^DHCNMG.HR.MgTeachD
	k ^DHCNMG.HR.MgTechServiceI
	k ^DHCNMG.HR.MgTechServiceD
	k ^DHCNMG.HR.MgTransAppI
	k ^DHCNMG.HR.MgTransAppD
	k ^DHCNMG.HR.MgTransDepI
	k ^DHCNMG.HR.MgTransDepD
	k ^DHCNMG.HR.MgWorkI
	k ^DHCNMG.HR.MgWorkD
	k ^DHCNMG.HR.NurAssessmentI
	k ^DHCNMG.HR.NurAssessmentD
	k ^DHCNMG.Intern.MgScoreI
	k ^DHCNMG.Intern.MgScoreD
	k ^DHCNMG.Intern.MgScoreStaI
	k ^DHCNMG.Intern.MgScoreStaD
	k ^DHCNMG.Intern.MgScoreSubI
	k ^DHCNMG.Intern.MgScoreSubD
	k ^DHCNMG.Intern.MgStudentI
	k ^DHCNMG.Intern.MgStudentD
	k ^DHCNMG.Intern.MgTeacherI
	k ^DHCNMG.Intern.MgTeacherD
	k ^DHCNMG.Intern.MgTransPlanI
	k ^DHCNMG.Intern.MgTransPlanD
	k ^DHCNMG.Intern.MgTransPlanGroupI
	k ^DHCNMG.Intern.MgTransPlanGroupD
	k ^DHCNMG.Intern.MgTransPlanSubI
	k ^DHCNMG.Intern.MgTransPlanSubD
	k ^DHCNMG.Intern.MgTransPlanTimeI
	k ^DHCNMG.Intern.MgTransPlanTimeD
	k ^DHCNMG.Log.MgOperateLogI
	k ^DHCNMG.Log.MgOperateLogD
	k ^DHCNMG.Sens.MgBedPRI
	k ^DHCNMG.Sens.MgBedPRD
	k ^DHCNMG.Sens.MgNurPRI
	k ^DHCNMG.Sens.MgNurPRD
	k ^DHCNMG.Survey.MgNurHeadI
	k ^DHCNMG.Survey.MgNurHeadD
	k ^DHCNMG.Survey.MgNurPatSatisI
	k ^DHCNMG.Survey.MgNurPatSatisD 
	k ^DHCNMG.Survey.MgNurSurveyI
	k ^DHCNMG.Survey.MgNurSurveyD
	k ^DHCNMG.Survey.MgNurSurveyListI
	k ^DHCNMG.Survey.MgNurSurveyListD
	k ^DHCNMG.Survey.MgNurSurveySubI
	k ^DHCNMG.Survey.MgNurSurveySubD
	k ^DHCNMG.Survey.MgPatSurveyI
	k ^DHCNMG.Survey.MgPatSurveyD
	k ^DHCNMG.Survey.MgPatSurveySubI
	k ^DHCNMG.Survey.MgPatSurveySubD
	k ^DHCNMG.Survey.SetWardI
	k ^DHCNMG.Survey.SetWardD
	k ^DHCNMG.Train.MgNurTransPlanI
	k ^DHCNMG.Train.MgNurTransPlanD
	k ^DHCNMG.Train.MgNurTransPlanSubI
	k ^DHCNMG.Train.MgNurTransPlanSubD
	k ^DHCNMG.Visit.MgVisitFlowSubI
	k ^DHCNMG.Visit.MgVisitFlowSubD
	k ^DHCNMG.Visit.MgVisitInterflowI
	k ^DHCNMG.Visit.MgVisitInterflowD
	k ^DHCNMG.Work.MgAwardsManageI
	k ^DHCNMG.Work.MgAwardsManageD
	k ^DHCNMG.Work.MgNurSatisfyI
	k ^DHCNMG.Work.MgNurSatisfyD
	k ^DHCNMG.Work.MgNurTechItemI
	k ^DHCNMG.Work.MgNurTechItemD
	k ^DHCNMG.Work.MgNurTechItemSubI
	k ^DHCNMG.Work.MgNurTechItemSubD
	k ^DHCNMG.Work.MgNurWardMonRpI
	k ^DHCNMG.Work.MgNurWardMonRpD
	k ^DHCNMG.Work.MgNurWardMonSubI
	k ^DHCNMG.Work.MgNurWardMonSubD
	k ^DHCNMG.Work.MgNurWardMonSubItmI
	k ^DHCNMG.Work.MgNurWardMonSubItmD
	k ^DHCNMG.Work.MgNurWardMonSubPerI
	k ^DHCNMG.Work.MgNurWardMonSubPerD
	k ^DHCNMG.Work.MgNurWorkReportI
	k ^DHCNMG.Work.MgNurWorkReportD
	k ^DHCNMG.Work.MgNurWorkRpI
	k ^DHCNMG.Work.MgNurWorkRpD
	k ^DHCNMG.Work.MgNurWorkRpSubI
	k ^DHCNMG.Work.MgNurWorkRpSubD
	k ^DHCNMG.Work.MgNurWRpSDataI
	k ^DHCNMG.Work.MgNurWRpSDataD
	k ^DHCNMG.Work.MgNurWorkRpWardI
	k ^DHCNMG.Work.MgNurWorkRpWardD
	k ^DHCNMG.Work.MgPerformanceTestI
	k ^DHCNMG.Work.MgPerformanceTestD
	k ^DHCNMG.Work.MgProjectManageI
	k ^DHCNMG.Work.MgProjectManageD
	k ^DHCNMG.Work.MgQuarterExamI
	k ^DHCNMG.Work.MgQuarterExamD
	k ^DHCNMG.Set.MgNHChkArrangeI ;0
	k ^DHCNMG.Set.MgNHChkArrangeD ;0
	k ^DHCNMG.Set.MgNightFeeFactorI
	k ^DHCNMG.Set.MgNightFeeFactorD
	k ^DHCNMG.Set.MgRoleNurseI ;0
	k ^DHCNMG.Set.MgRoleNurseD ;0
	k ^DHCNMG.Set.MgSecurityGroupI ;0
	k ^DHCNMG.Set.MgSecurityGroupD ;0
	k ^DHCNMG.Set.MgSecurityGroupSubI ;0
	k ^DHCNMG.Set.MgSecurityGroupSubD ;0
	s Par="" f  s Par=$o(^DHCNMG.Set.MgRolesD(Par)) q:Par=""  d
	.q:+Par=0
	.s ID="" f  s ID=$o(^DHCNMG.Set.MgRolesD(Par,"NurseChildSub",ID)) q:ID=""  d
	..k ^DHCNMG.Set.MgRolesD(Par,"NurseChildSub",ID)
	q 0
}

/// 清除配置数据
/// d ##class(web.NurMgImportDBData).ClearDBData()
ClassMethod ClearDBData() As %String
{
	k ^DHCNMG.DB.MgArgHolidayI 
	k ^DHCNMG.DB.MgArgHolidayD
	k ^DHCNMG.DB.MgArgHolidaySubI
	k ^DHCNMG.DB.MgArgHolidaySubD
	k ^DHCNMG.DB.MgArgPostI ;1
	k ^DHCNMG.DB.MgArgPostD ;1
	k ^DHCNMG.DB.MgArgWardPostI ;1
	k ^DHCNMG.DB.MgArgWardPostD ;1
	k ^DHCNMG.DB.MgAssessItemI
	k ^DHCNMG.DB.MgAssessItemD
	k ^DHCNMG.DB.MgAssessItemSubI
	k ^DHCNMG.DB.MgAssessItemSubD
	k ^DHCNMG.DB.MgAssessModelI
	k ^DHCNMG.DB.MgAssessModelD
	k ^DHCNMG.DB.MgAssessModelSubI
	k ^DHCNMG.DB.MgAssessModelSubD
	k ^DHCNMG.DB.MgClinicalLinkI
	k ^DHCNMG.DB.MgClinicalLinkD
	k ^DHCNMG.DB.MgClinicalTypeI ;1
	k ^DHCNMG.DB.MgClinicalTypeD ;1
	k ^DHCNMG.DB.MgClinicalTypeSubI ;1
	k ^DHCNMG.DB.MgClinicalTypeSubD ;1
	k ^DHCNMG.DB.MgClinicItemsI
	k ^DHCNMG.DB.MgClinicItemsD
	k ^DHCNMG.DB.MgFloorI ;1
	k ^DHCNMG.DB.MgFloorD ;1
	k ^DHCNMG.DB.MgHolidaySetI ;1
	k ^DHCNMG.DB.MgHolidaySetD ;1
	k ^DHCNMG.DB.MgKpiGroupI
	k ^DHCNMG.DB.MgKpiGroupD
	k ^DHCNMG.DB.MgKpiItemI
	k ^DHCNMG.DB.MgKpiItemD
	k ^DHCNMG.DB.MgKpiItemSubI
	k ^DHCNMG.DB.MgKpiItemSubD
	k ^DHCNMG.DB.MgNurCheckWardI ;1
	k ^DHCNMG.DB.MgNurCheckWardD ;1
	k ^DHCNMG.DB.MgNurWorkLoadItmI
	k ^DHCNMG.DB.MgNurWorkLoadItmD
	k ^DHCNMG.DB.MgNurWorkLoadItmSubI
	k ^DHCNMG.DB.MgNurWorkLoadItmSubD
	k ^DHCNMG.DB.MgNurWorkLoadDepSetI
	k ^DHCNMG.DB.MgNurWorkLoadDepSetD
	k ^DHCNMG.DB.MgQualGroupI ;1
 	k ^DHCNMG.DB.MgQualGroupD ;1
	k ^DHCNMG.DB.MgQualItemI ;1
	k ^DHCNMG.DB.MgQualItemD ;1
	k ^DHCNMG.DB.MgQualItemSubI ;1
	k ^DHCNMG.DB.MgQualItemSubD ;1
	k ^DHCNMG.DB.MgQualModelI ;1
	k ^DHCNMG.DB.MgQualModelD ;1
	k ^DHCNMG.DB.MgQualModelSubI ;1
	k ^DHCNMG.DB.MgQualModelSubD ;1
	k ^DHCNMG.DB.MgReportItemI ;1
	k ^DHCNMG.DB.MgReportItemD ;1
	k ^DHCNMG.DB.MgReportItemSubI ;1
	k ^DHCNMG.DB.MgReportItemSubD ;1
	k ^DHCNMG.DB.MgSurveyItemI ;1
	k ^DHCNMG.DB.MgSurveyItemD ;1
	k ^DHCNMG.DB.MgSurveyItemSubI ;1
	k ^DHCNMG.DB.MgSurveyItemSubD ;1
	k ^DHCNMG.DB.MgSurveySetI ;1
	k ^DHCNMG.DB.MgSurveySetD ;1
	k ^DHCNMG.DB.MgSurveyStandardI ;1
	k ^DHCNMG.DB.MgSurveyStandardD ;1
	k ^DHCNMG.DB.MgWardI ;1
	k ^DHCNMG.DB.MgWardD ;1
	k ^DHCNMG.DB.MgWardAreaI ;1
	k ^DHCNMG.DB.MgWardAreaD ;1
	k ^DHCNMG.DB.MgWardLocI ;1
	k ^DHCNMG.DB.MgWardLocD ;1
	k ^DHCNMG.DB.MgWardLocUnitI ;1
	k ^DHCNMG.DB.MgWardLocUnitD ;1
	k ^DHCNMG.DB.MgWardPostGroupI ;1
	k ^DHCNMG.DB.MgWardPostGroupD ;1
	k ^DHCNMG.Set.MgNurSecLinkRoleI
	k ^DHCNMG.Set.MgNurSecLinkRoleD
	k ^DHCNMG.Set.MgRoleGroupI
	k ^DHCNMG.Set.MgRoleGroupD
	q 0
}

/// 清系统数据
/// d ##class(web.NurMgImportDBData).ClearVueNurseManage()
ClassMethod ClearVueNurseManage() As %String
{
	k ^DHCNMG.DB.MgInternScoreI ;2
	k ^DHCNMG.DB.MgInternScoreD ;2
	k ^DHCNMG.DB.MgInternScoreSubI ;2
	k ^DHCNMG.DB.MgInternScoreSubD ;2
	k ^DHCNMG.DB.MgSetCodeI ;2
	k ^DHCNMG.DB.MgSetCodeD ;2
	k ^DHCNMG.DB.MgSetCodeSubI ;2
	k ^DHCNMG.DB.MgSetCodeSubD ;2	
	k ^DHCNMG.Set.MgArgParamSetI
	k ^DHCNMG.Set.MgArgParamSetD
	k ^DHCNMG.Set.MgColumnsI
	k ^DHCNMG.Set.MgColumnsD
	k ^DHCNMG.Set.MgFieldSetI
	k ^DHCNMG.Set.MgFieldSetD
	k ^DHCNMG.Set.MgLimitSetI
	k ^DHCNMG.Set.MgLimitSetD
	k ^DHCNMG.Set.MgLimitSetSubI
	k ^DHCNMG.Set.MgLimitSetSubD
	k ^DHCNMG.Set.MgMenuI
	k ^DHCNMG.Set.MgMenuD
	k ^DHCNMG.Set.MgMenuElementI
	k ^DHCNMG.Set.MgMenuElementD
	k ^DHCNMG.Set.MgModuleI
	k ^DHCNMG.Set.MgModuleD
	k ^DHCNMG.Set.MgRoleMenuI
	k ^DHCNMG.Set.MgRoleMenuD
	k ^DHCNMG.Set.MgRolesI
	k ^DHCNMG.Set.MgRolesD
	k ^DHCNMG.Set.MgSysParamI
	k ^DHCNMG.Set.MgSysParamD
	k ^DHCNMG.Set.MgSysParamSubI
	k ^DHCNMG.Set.MgSysParamSubD
	k ^DHCNMG.Set.MgTableI
	k ^DHCNMG.Set.MgTableD
	q 0
}

ClassMethod SplitStr1(parr As %String, s1 As %String, s2 As %String, tmp As %String) As %String
{
	q:parr="" 0
	k tmp
	s len=$L(parr,s1)
	f i=1:1:len
	{
		s item=$P(parr,s1,i)
		continue:item=""
		s key=$P(item,s2,1)
		continue:key=""
		s val=$P(item,s2,2,$L(item,s2))
 		s tmp(key)=$tr(val," ","")
	}
	q $d(tmp)
}

ClassMethod ImportNurseData(parr As %String) As %String
{
	s tmp=""
	s aa=..SplitStr1(parr,"^","|",.tmp)
	;s nurseid=$g(tmp("PerID")) //取得护士工号
	
	s kk="" f  s kk=$o(tmp(kk)) q:kk=""  d
	.i ((tmp(kk)["/")&&($l(tmp(kk),"/")=3)) s tmp(kk)=$replace(tmp(kk),"/","-")
	s index=tmp("index")
	s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	q:PerCardId="" 0
	s rowid=$O(^DHCNMG.HR.MgPersonsI("card"," "_PerCardId,""))
	;s rowid=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(nurseid," ",""),"U"),""))
	i rowid="" s obj=##class(DHCNMG.HR.MgPersons).%New()
	e  s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	i $g(tmp("HISNO"))'="" s obj.HISNO=$zcvt($tr($g(tmp("HISNO"))," ",""),"U") //HISNO
	;e  s obj.HISNO=""
	i $g(tmp("PerID"))'="" s obj.PerID=$zcvt($tr($g(tmp("PerID"))," ",""),"U") //工号
	;e  s obj.PerID=""
	i (($g(tmp("PerPolitDate"))'="")&&($l($g(tmp("PerPolitDate")),"-")=3)) s obj.PerPolitDate=$zdh($g(tmp("PerPolitDate")),3)
	;e  s obj.PerPolitDate="" //政治面貌日期
	i (($g(tmp("PerWorkDate"))'="")&&($l($g(tmp("PerWorkDate")),"-")=3)) s obj.PerWorkDate=$zdh($g(tmp("PerWorkDate")),3)
	;e  s obj.PerWorkDate=""
	i $g(tmp("PerName"))'="" s obj.PerName=$tr($g(tmp("PerName"))," ","") //姓名
	;e  s obj.PerName=""
	i $g(tmp("PostTitle"))'="" d
	.s posttitledr=..GetSetCode("岗位名称",$zcvt($tr($g(tmp("PostTitle"))," ",""),"U")) //岗位名称
	.i posttitledr'="" s obj.PostTitle=posttitledr
	.;e  s obj.PostTitle=""
	;e  s obj.PostTitle=""
	s obj.PerHouseAddress=$g(tmp("PerHouseAddress")) //户口所在地
	i (($g(tmp("PerCadreDate"))'="")&&($l($g(tmp("PerCadreDate")),"-")=3)) s obj.PerCadreDate=$zdh($g(tmp("PerCadreDate")),3)
	;e  s obj.PerCadreDate="" //提干日期
	i $g(tmp("PerPolitical"))'="" d
	.s politicaldr=..GetSetCode("政治面貌",$zcvt($tr($g(tmp("PerPolitical"))," ",""),"U")) //政治面貌
	.i politicaldr'="" s obj.PerPolitical=politicaldr
	.;e  s obj.PerPolitical=""
	;e  s obj.PerPolitical=""
	i (($g(tmp("PerComeDate"))'="")&&($l($g(tmp("PerComeDate")),"-")=3)) s obj.PerComeDate=$zdh($g(tmp("PerComeDate")),3)
	;e  s obj.PerComeDate="" //来院日期
	i $g(tmp("PerNation"))'="" d
	.s nationdr=..GetSetCode("民族",$zcvt($tr($g(tmp("PerNation"))," ",""),"U")) //民族
	.i nationdr'="" s obj.PerNation=nationdr
	.;e  s obj.PerNation=""
	;e  s obj.PerNation=""
	i $g(tmp("PerDepDR"))'="" d
	.s warddr=..GetDBWard($zcvt($tr($g(tmp("PerDepDR"))," ",""),"U")) //病区
	.i warddr'="" s obj.PerDepDR=warddr
	.;e  s obj.PerDepDR=""
	;e  s obj.PerDepDR=""
	q:obj.PerDepDR="" 0
	i $g(tmp("PerLocDR"))'="" d
	.s locdr=..GetDBLoc($zcvt($tr($g(tmp("PerLocDR"))," ",""),"U")) //科室
	.i locdr'="" s obj.PerLocDR=locdr
	.;e  s obj.PerLocDR=""
	;e  s obj.PerLocDR=""
	i $g(tmp("PerNativePlace"))'="" s obj.PerNativePlace=$tr($g(tmp("PerNativePlace"))," ","") //籍贯
	;e  s obj.PerNativePlace=""
	i (($g(tmp("PrepareDate"))'="")&&($l($g(tmp("PrepareDate")),"-")=3)) s obj.PrepareDate=$zdh($g(tmp("PrepareDate")),3)
	;e  s obj.PrepareDate=""
	i obj.PerPassword="" s obj.PerPassword="UUUUUU&&&&&&"
#;	i $g(tmp("PerPostDuty"))'="" d
#;	.s postdr=..GetSetCode("职务",$zcvt($tr($g(tmp("PerPostDuty"))," ",""),"U")) //职务
#;	.i postdr'="" s obj.PerPostDuty=postdr
#;	.e  s obj.PerPostDuty=""
#;	e  s obj.PerPostDuty=""
#;	i (($g(tmp("PerPostDutyDate"))'="")&&($l($g(tmp("PerPostDutyDate")),"-")=3)) s obj.PerPostDutyDate=$zdh($g(tmp("PerPostDutyDate")),3)
#;	e  s obj.PerPostDutyDate=""
	i $g(tmp("PerSource"))'="" d
	.s sourcedr=..GetSetCode("职工性质",$zcvt($tr($g(tmp("PerSource"))," ",""),"U")) //职工性质
	.i sourcedr'="" s obj.PerSource=sourcedr
	.;e  s obj.PerSource=""
	;e  s obj.PerSource=""
#;	i $g(tmp("PerHireDuty"))'="" d
#;	.s hiredutydr=..GetSetCode("聘任职称",$zcvt($tr($g(tmp("PerHireDuty"))," ",""),"U")) //聘任职称
#;	.i hiredutydr'="" s obj.PerHireDuty=hiredutydr
#;	.e  s obj.PerHireDuty=""
#;	e  s obj.PerHireDuty=""
#;	i (($g(tmp("PerHireDutyDate"))'="")&&($l($g(tmp("PerHireDutyDate")),"-")=3)) s obj.PerHireDutyDate=$zdh($g(tmp("PerHireDutyDate")),3)
#;	e  s obj.PerHireDutyDate="" //聘任职称日期
	i $g(tmp("PerPhone"))'="" s obj.PerPhone=$tr($g(tmp("PerPhone"))," ","") //联系方式（手机）
	;e  s obj.PerPhone=""
	i $g(tmp("PerCardId"))'="" d
	.s obj.PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //身份证号码
	.s cardlen=$L($tr($g(tmp("PerCardId"))," ",""))
	.i cardlen=18 d
	..s birthnum=$E($tr($g(tmp("PerCardId"))," ",""),7,14)
	..i birthnum'="" s obj.PerBirthday=$zdh(birthnum,8)
	..;e  s obj.PerBirthday=""
	..s sexnum=$E($tr($g(tmp("PerCardId"))," ",""),17)
	..i +sexnum>=0 d
	...i (+sexnum#2)=0 s obj.PerSexDR=..GetSetCode("性别","女")
	...e  s obj.PerSexDR=..GetSetCode("性别","男")
	;e  s obj.PerCardId=""
	i $g(tmp("PerMarriage"))'="" d
	.s marriagedr=..GetSetCode("婚姻",$zcvt($tr($g(tmp("PerMarriage"))," ",""),"U")) //婚姻
	.i marriagedr'="" s obj.PerMarriage=marriagedr
	.;e  s obj.PerMarriage=""
	;e  s obj.PerMarriage=""
	i $g(tmp("PerContact"))'="" s obj.PerContact=$tr($g(tmp("PerContact"))," ","")
	;e  s obj.PerContact=""
	i $g(tmp("PerHomeAddress"))'="" s obj.PerHomeAddress=$tr($g(tmp("PerHomeAddress"))," ","")
	;e  s obj.PerHomeAddress=""
	i $g(tmp("PerAddress"))'="" s obj.PerAddress=$tr($g(tmp("PerAddress"))," ","")
	;e  s obj.PerAddress=""
	i $g(tmp("PerShoesNo"))'="" s obj.PerShoesNo=..GetSetCode("鞋号",$zcvt($tr($g(tmp("PerShoesNo"))," ",""),"U"))
	;e  s obj.PerShoesNo=""
	i $g(tmp("PerForeignLevel"))'="" s obj.PerForeignLevel=..GetSetCode("英语级别",$zcvt($tr($g(tmp("PerForeignLevel"))," ",""),"U"))
	;e  s obj.PerForeignLevel="" 
	i $g(tmp("PerIsEspecially"))'="" d
	.i $zcvt($tr($g(tmp("PerIsEspecially"))," ",""),"U")="Y"  s obj.PerIsEspecially=1 ;是否特长
	.e  s obj.PerIsEspecially=0
	;e  s obj.PerIsEspecially=""
	i $g(tmp("PerEspecially"))'=""  s obj.PerEspecially=$tr($g(tmp("PerEspecially"))," ","") ;特长
	;e  s obj.PerEspecially=""
	i $g(tmp("PerIsRegiste"))'="" d
	.i $zcvt($tr($g(tmp("PerIsRegiste"))," ",""),"U")="Y"  s obj.PerIsRegiste=1 ;有无执业证书
	.e  s obj.PerIsRegiste=0
	e  s obj.PerIsRegiste=""
	i $g(tmp("PerRegNo"))'=""  s obj.PerRegNo=$tr($g(tmp("PerRegNo"))," ","") ;执业证书
	;e  s obj.PerRegNo=""
	i (($g(tmp("PerRegRegiDate"))'="")&&($l($g(tmp("PerRegRegiDate")),"-")=3)) s obj.PerRegRegiDate=$zdh($tr($g(tmp("PerRegRegiDate"))," ",""),3) ;证书注册日期
	;e  s obj.PerRegRegiDate=""
	i (($g(tmp("PerRegValidDate"))'="")&&($l($g(tmp("PerRegValidDate")),"-")=3))  s obj.PerRegValidDate=$zdh($tr($g(tmp("PerRegValidDate"))," ",""),3) ;证书有效期
	;e  s obj.PerRegValidDate=""
	i $g(tmp("PerQualCerifite"))'=""  s obj.PerQualCerifite=$tr($g(tmp("PerQualCerifite"))," ","") ;资格证书
	;e  s obj.PerQualCerifite=""
	i $g(tmp("PerSpeciNurse"))'=""  s obj.PerSpeciNurse=..GetSetCode("专科护士",$zcvt($tr($g(tmp("PerSpeciNurse"))," ",""),"U")) ;专科护士
	;e  s obj.PerSpeciNurse=""
	i (($g(tmp("PerSeciNurseDate"))'="")&&($l($g(tmp("PerSeciNurseDate")),"-")=3))    s obj.PerSeciNurseDate=$zdh($tr($g(tmp("PerSeciNurseDate"))," ",""),3) ;取得专科日期
	;e  s obj.PerSeciNurseDate=""
	i $g(tmp("PerSocietyPart"))'=""  s obj.PerSocietyPart=$tr($g(tmp("PerSocietyPart"))," ","") ;社会兼职
	;e  s obj.PerSocietyPart=""
    i $g(tmp("PerInNursePost"))'=""  s obj.PerInNursePost=$case($tr($g(tmp("PerInNursePost"))," ",""),"在岗":"1","转岗":"0","借调":"2",:"") ;在护理岗
	;e  s obj.PerInNursePost=""
	i $g(tmp("PerNurseHire"))'="" d
	.i $zcvt($tr($g(tmp("PerNurseHire"))," ",""),"U")="Y"  s obj.PerNurseHire=1 ;是否特长
	.e  s obj.PerNurseHire=0
	;e  s obj.PerNurseHire="" 
	s obj.ImportDate=+$H
	s obj.PerStatus="17||1"
	s obj.PerTypeDR="N"
	s obj.PerCareType="N"
	s obj.PerAuditFlag="Y"
	s sc=obj.%Save()
	s rw=obj.%Id()
	///层级导入
    i $g(tmp("MgLevel"))'="" d
    .s LevelDate=+$h
    .i (($g(tmp("MgLevelStDate"))'="")&&($l($g(tmp("MgLevelStDate")),"-")=3)) d
    ..s LevelDate=$zdh($tr($g(tmp("MgLevelStDate"))," ",""),3)
    .s levelObj=##class(DHCNMG.HR.MgLevel).%New()
    .s levelObj.LevelPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rw)
    .s levelObj.NurLevel=..GetSetCode("护士层级",$zcvt($tr($g(tmp("MgLevel"))," ",""),"U"))
    .s levelObj.LevelDate=LevelDate
    .s levelObj.LevelStatus="A"
    .d levelObj.%Save()
	///职称导入
	i $g(tmp("PerHireDuty"))'="" d
	.i (($g(tmp("PerHireDutyDate"))'="")&&($l($g(tmp("PerHireDutyDate")),"-")=3)) d
	..s hiredate=$zdh($tr($g(tmp("PerHireDutyDate"))," ",""),3)
	..s hiredutyrw=$O(^DHCNMG.HR.MgHireDutyI("date",hiredate,rw,""))
	..i hiredutyrw="" d
	...s rwtmp=$O(^DHCNMG.HR.MgHireDutyI("ssid",rw,""),-1)
	...i rwtmp'="" d
	....s rwtmpobj=##class(DHCNMG.HR.MgHireDuty).%OpenId(rwtmp)
	....q:'$IsObject(rwtmpobj)
	....s rwtmpobj.HireEndDate=hiredate
	....d rwtmpobj.%Save()
	...s hireobj=##class(DHCNMG.HR.MgHireDuty).%New()
	...s hireobj.HirePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rw)
	...s hireobj.HireDuty=..GetSetCode("聘任职称",$zcvt($tr($g(tmp("PerHireDuty"))," ",""),"U"))
	...s hireobj.HireStDate=hiredate
	...s hireobj.HireStatus="A"
	...d hireobj.%Save()
	///第一学历导入
	i $g(tmp("FirEduAcademic"))'="" d
	.i (($g(tmp("FirEduAcaInDate"))'="")&&($l($tr($g(tmp("FirEduAcaInDate"))," ",""),"-")=3)) d
	..s edustdate=$zdh($tr($g(tmp("FirEduAcaInDate"))," ",""),3)
	..s edurw=$O(^DHCNMG.HR.MgEducateI("date",edustdate,rw,""))
	..i edurw="" d
	...s edurwobj=##class(DHCNMG.HR.MgEducate).%New()
	...s edurwobj.EduPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rw)
	..e  s edurwobj=##class(DHCNMG.HR.MgEducate).%OpenId(edurw)
	..s edurwobj.EduStDate=$zdh($tr($g(tmp("FirEduAcaInDate"))," ",""),3) //第一学历入学日期
	..i (($g(tmp("FirEduAcaOutDate"))'="")&&($l($tr($g(tmp("FirEduAcaOutDate"))," ",""),"-")=3)) s edurwobj.EduEndDate=$zdh($tr($g(tmp("FirEduAcaOutDate"))," ",""),3)
	..e  s edurwobj.EduEndDate="" //第一学历毕业日期
	..s eduAcademicdr=..GetSetCode("学历",$tr($g(tmp("FirEduAcademic"))," ",""))
	..i eduAcademicdr'="" s edurwobj.EduAcademic=eduAcademicdr //第一学历
	..e  s edurwobj.EduAcademic=""
	..i $g(tmp("FirEduDegree"))'="" d //第一学位
	...s eduDegreeDr=..GetSetCode("学位",$tr($g(tmp("FirEduDegree"))," ",""))
	...i eduDegreeDr'="" s edurwobj.EduDegree=eduDegreeDr
	...e  s edurwobj.EduDegree=""
	..e  s edurwobj.EduDegree=""
	..i $tr($g(tmp("FirEduAcaWays"))," ","")'="" d //教育性质（学习形式）
	...s eduAcaWaysDr=..GetSetCode("教育性质",$zcvt($tr($g(tmp("FirEduAcaWays"))," ",""),"U"))
	...i eduAcaWaysDr'="" s edurwobj.EduRadio=eduAcaWaysDr
	...e  s edurwobj.EduRadio=""
	..e  s edurwobj.EduRadio=""
	..i $g(tmp("FirEduAcaPro"))'="" d
	...s eduAcaProDr=..GetSetCode("专业",$zcvt($tr($g(tmp("FirEduAcaPro"))," ",""),"U"))
	...i eduAcaProDr'="" s edurwobj.EduProfession=eduAcaProDr
	...e  s edurwobj.EduProfession=""
	..e  s edurwobj.EduProfession=""
	..i $g(tmp("FirEduAcaSchool"))'="" d
	...s eduAcaSchoolDr=..GetSetCode("毕业院校",$zcvt($tr($g(tmp("FirEduAcaSchool"))," ",""),"U"))
	...i eduAcaSchoolDr'="" s edurwobj.EduSchool=eduAcaSchoolDr
	...e  s edurwobj.EduSchool=""
	..e  s edurwobj.EduSchool=""
	..s edurwobj.EduStatus="A"
	..d edurwobj.%Save()
	///最高学历导入
	i $g(tmp("HighEduAcademic"))'="" d
	.i (($g(tmp("HighEduAcaInDate"))'="")&&($l($tr($g(tmp("HighEduAcaInDate"))," ",""),"-")=3)) d
	..s hedustdate=$zdh($tr($g(tmp("HighEduAcaInDate"))," ",""),3)
	..s hedurw=$O(^DHCNMG.HR.MgEducateI("date",hedustdate,rw,""))
	..i hedurw="" d
	...s hedurwobj=##class(DHCNMG.HR.MgEducate).%New()
	...s hedurwobj.EduPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rw)
	..e  s hedurwobj=##class(DHCNMG.HR.MgEducate).%OpenId(hedurw)
	..s hedurwobj.EduStDate=hedustdate //入学日期
	..i (($g(tmp("HighEduAcaOutDate"))'="")&&($l($tr($g(tmp("HighEduAcaOutDate"))," ",""),"-")=3)) s hedurwobj.EduEndDate=$zdh($tr($g(tmp("HighEduAcaOutDate"))," ",""),3)
	..e  s hedurwobj.EduEndDate="" //毕业日期
	..s HEduAcademicDr=..GetSetCode("学历",$tr($g(tmp("HighEduAcademic"))," ",""))
	..i HEduAcademicDr'="" s hedurwobj.EduAcademic=HEduAcademicDr
	..e  s hedurwobj.EduAcademic="" //学历
	..i $g(tmp("HighEduDegree"))'="" d
	...s hEduDegreeDr=..GetSetCode("学位",$zcvt($tr($g(tmp("HighEduDegree"))," ",""),"U"))
	...i hEduDegreeDr'="" s hedurwobj.EduDegree=hEduDegreeDr
	...e  s hedurwobj.EduDegree=""
	..e  s hedurwobj.EduDegree="" //学位
	..i $g(tmp("HighEduAcaWays"))'="" d //教育性质
	...s hEduAcaWaysDr=..GetSetCode("教育性质",$zcvt($tr($g(tmp("HighEduAcaWays"))," ",""),"U"))
	...i hEduAcaWaysDr'="" s hedurwobj.EduRadio=hEduAcaWaysDr
	...e  s hedurwobj.EduRadio=""
	..e  s hedurwobj.EduRadio=""
	..i $g(tmp("HighEduAcaPro"))'="" d //专业
	...s hEduAcaProDr=..GetSetCode("专业",$zcvt($tr($g(tmp("HighEduAcaPro"))," ",""),"U"))
	...i hEduAcaProDr'="" s hedurwobj.EduProfession=hEduAcaProDr
	...e  s hedurwobj.EduProfession=""
	..e  s hedurwobj.EduProfession=""
	..i $g(tmp("HighEduAcaSchool"))'="" d //毕业院校
	...s hEduAcaSchoolDr=..GetSetCode("毕业院校",$zcvt($tr($g(tmp("HighEduAcaSchool"))," ",""),"U"))
	...i hEduAcaSchoolDr'="" s hedurwobj.EduSchool=hEduAcaSchoolDr
	...e  s hedurwobj.EduSchool=""
	..e  s hedurwobj.EduSchool=""
	..s hedurwobj.EduStatus="A"
	..d hedurwobj.%Save()
	///调科记录导入
	s transRowID=$O(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_rw,""))
	i transRowID="" d
	.s perdepdate=$zd(+$h,3)
	.s TransFlag=##class(web.NurMgPersonComm).SaveTransData("^"_rw_"^"_obj.PerDepDR_"^"_perdepdate_"^"_$zt($P($H,",",2),1)_"^Y^^^L")	
	e  d
	.s aa=##class(DHCNMG.HR.MgTransDep).%OpenId(transRowID)
	.s aa.PerDr=obj.%Id()
    .s aa.PerDepart=obj.PerDepDR
    .s aa.PerTranStDate=+$h
    .s aa.PerTranCurrent="Y"
    .s aa.PerTranStTime=$P($H,",",2)
    .s aa.PerTransType="L"
    .d aa.%Save()
    ///角色导入
    i $g(tmp("Roles"))'="" d
    .s rolelen=$l($tr($g(tmp("Roles"))," ",""),",")
    .//首先清除角色关联中的某人的所有数据信息，然后通过“插入某人的角色记录”进行插入数据
    .i rolelen>0 d
    ..s rolepar="" f  s rolepar=$O(^DHCNMG.Set.MgRoleNurseI("Record"," "_rw,rolepar)) q:rolepar=""  d
    ...s roleraw="" f  s roleraw=$O(^DHCNMG.Set.MgRoleNurseI("Record"," "_rw,rolepar,roleraw)) q:roleraw=""  d
    ....s tmpObj=##class(DHCNMG.Set.MgRoleNurse).%OpenId(rolepar_"||"_roleraw)
    ....d tmpObj.%DeleteId(rolepar_"||"_roleraw)
    .for i=1:1:rolelen d
    ..s roleitm=$p($tr($g(tmp("Roles"))," ",""),",",i)
    ..i roleitm'="" d
    ...s roleid=""
    ...s roleid=..GetRole(roleitm)
    ...i roleid'="" d
    ....i $g(tmp("RoleDate"))="" s tmp("RoleDate")=$zd(+$H,3)
    ....i (($g(tmp("RoleDate"))'="")&&($l($tr($g(tmp("RoleDate"))," ",""),"-")=3)) d
    .....s rolerw=$O(^DHCNMG.HR.MgNurRoleI("date",rw,$zdh($tr($g(tmp("RoleDate"))," ",""),3)," "_roleid,""))
    .....i rolerw="" d
    ......s oldrw=$O(^DHCNMG.HR.MgNurRoleI("role",rw," "_roleid,""))
    ......i oldrw'="" d
    .......s oldRoleObj=##class(DHCNMG.HR.MgNurRole).%OpenId(oldrw)
    .......q:'$IsObject(oldRoleObj)
    .......q:oldRoleObj.RoleEndDate'=""
    .......s oldRoleObj.RoleEndDate=$zdh($tr($g(tmp("RoleDate"))," ",""),3)
    .......d oldRoleObj.%Save()
    .......s newRoleObj=##class(DHCNMG.HR.MgNurRole).%New()
    .......s newRoleObj.RoleStDate=$zdh($tr($g(tmp("RoleDate"))," ",""),3)
    .......s newRoleObj.RoleID=roleid
    .......s newRoleObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rw)
    .......d newRoleObj.%Save()
    ......e  d
    .......s newRoleObj=##class(DHCNMG.HR.MgNurRole).%New()
    .......s newRoleObj.RoleStDate=$zdh($tr($g(tmp("RoleDate"))," ",""),3)
    .......s newRoleObj.RoleID=roleid
    .......s newRoleObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rw)
    .......d newRoleObj.%Save()
    ....//插入某人的角色记录
    ....s setRw=$O(^DHCNMG.Set.MgRoleNurseI("nurse",roleid," "_rw,""))
    ....i setRw="" d
    .....s setObj=##class(DHCNMG.Set.MgRoleNurse).%New()
    .....s setObj.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleid)
    .....s setObj.RoleNurse=rw
    .....i $g(tmp("RoleDate"))'="" s setobjdate=$zdh($tr($g(tmp("RoleDate"))," ",""),3)
    .....e  s setobjdate=+$H
    .....s setObj.RoleStDate=setobjdate
    .....d setObj.%Save()
    
    ///职务导入 有护士长职务的要插入护士长角色
    i (($g(tmp("PerPostDuty"))'="")&&($g(tmp("PerPostDutyDate"))="")) s tmp("PerPostDutyDate")=$zd(+$h,3)
    i $g(tmp("PerPostDuty"))'="" d
    .i (($g(tmp("PerPostDutyDate"))'="")&&($l($tr($g(tmp("PerPostDutyDate"))," ",""),"-")=3)) d
    ..s postdate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
    ..s postRowID=""
    ..s postRowID=..GetSetCode("职务",$zcvt($tr($g(tmp("PerPostDuty"))," ",""),"U")) //获取职务的记录ID
    ..q:postRowID=""
    ..s postrw=$O(^DHCNMG.HR.MgPostDutyI("date",postdate,rw,"")) //判断此日期点是否存在记录
    ..i postrw="" d //如果此日期点不存在记录 就要检查此日期之前的记录
    ...s oldpostrw="" f  s oldpostrw=$O(^DHCNMG.HR.MgPostDutyD(oldpostrw)) q:oldpostrw=""  d
    ....s oldpostobj=##class(DHCNMG.HR.MgPostDuty).%OpenId(oldpostrw)
    ....q:oldpostobj.PostPerDR.%Id()'=rw
    ....q:oldpostobj.PostEndDate'=""
    ....s oldpostobj.PostEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
    ....d oldpostobj.%Save()
    ...s newpostobj=##class(DHCNMG.HR.MgPostDuty).%New()
    ...s newpostobj.PostPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rw)
    ...s newpostobj.PostDuty=postRowID
    ...s newpostobj.PostStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
    ...s newpostobj.PostStatus="A"
    ...d newpostobj.%Save()
    ...i ((newpostobj.%Id()'="")&&($zcvt($tr($g(tmp("PerPostDuty"))," ",""),"U")="护士长")) d //判断如果职务是护士长就要在角色中添加护士长角色
    ....s nurheadrw=..GetRole($zcvt($tr($g(tmp("PerPostDuty"))," ",""),"U"))
    ....i nurheadrw'="" d
    .....s flag=0
    .....s nurheadRowID="" f  s nurheadRowID=$O(^DHCNMG.HR.MgNurRoleI("role",rw," "_nurheadrw,nurheadRowID)) q:nurheadRowID=""  d
    ......s nurheadroleobj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurheadRowID)
    ......q:nurheadroleobj.RoleEndDate'=""
    ......q:nurheadroleobj.RoleStDate>=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
    ......s nurheadroleobj.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
    ......s flag=1
    ......d nurheadroleobj.%Save()
    .....i flag=0 d
    ......s oldrolerw=$O(^DHCNMG.HR.MgNurRoleI("role",rw," "_nurheadrw,""))
    ......i oldrolerw="" d
    .......s newNurHeadRole=##class(DHCNMG.HR.MgNurRole).%New()
    .......s newNurHeadRole.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rw)
    .......s newNurHeadRole.RoleID=nurheadrw
    .......s newNurHeadRole.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
    .......d newNurHeadRole.%Save()
    .....i flag=1 d
    ......s newNurHeadRoleObj=##class(DHCNMG.HR.MgNurRole).%New()
    ......s newNurHeadRoleObj.RoleID=nurheadrw
    ......s newNurHeadRoleObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rw)
    ......s newNurHeadRoleObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
    ......d newNurHeadRoleObj.%Save()  
	q index
}

/// 获取角色ID
ClassMethod GetRole(desc As %String) As %String
{
	q:desc="" ""
	s ret=""
	s rowid=$O(^DHCNMG.Set.MgRolesI("desc"," Y"," "_$zcvt($tr(desc," ",""),"U"),""))
	i rowid'="" s ret=rowid
	q ret
}

/// 获取科室ID
ClassMethod GetDBLoc(locdesc As %String) As %String
{
	s ret=""
	;s spell=##class(web.NurMgVueComm).ToChineseSpell(locdesc)
	s rowid=$O(^DHCNMG.DB.MgWardLocI("Desc"," "_$ZCVT($tr(locdesc," ",""),"U"),""))
	i rowid'="" s ret=rowid
	q ret
}

/// 获取病区ID
ClassMethod GetDBWard(warddesc As %String) As %String
{
	s ret=""
	s rowid=$O(^DHCNMG.DB.MgWardI("Desc"," "_warddesc,""))
	i rowid'="" s ret=rowid
	q ret
}

/// 获取档案公共代码
ClassMethod GetSetCode(pardesc As %String, subdesc As %String) As %String
{
	s ret=""
	s par=$O(^DHCNMG.DB.MgSetCodeI("Code"," "_pardesc,""))
	q:par="" ""
	s obj=##class(DHCNMG.DB.MgSetCode).%OpenId(par)
	s rw="" f  s rw=$O(^DHCNMG.DB.MgSetCodeSubI("Code",par," "_subdesc,rw)) q:rw=""  d
	.s ret=par_"||"_rw
	q ret
}

ClassMethod ImportNurseRole(parr As %String) As %String
{
	s tmp=""
	s flag=1
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s perId=$g(tmp("HISNO")) //护士HIS号
	q:perId="" ""
	;s rowId=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr($g(tmp("PerID"))," ",""),"U"),""))
	s rowId=$o(^DHCNMG.HR.MgPersonsI("hisno"," "_$zcvt($tr($g(tmp("HISNO"))," ",""),"U"),""))
	q:rowId="" "" //人员表ID
	q:$tr($g(tmp("NurseRole"))," ","")="" ""
	s roleId=$O(^DHCNMG.Set.MgRolesI("desc"," Y"," "_$tr($g(tmp("NurseRole"))," ",""),""))
	q:roleId="" "" //获取角色的ID
	TS
	s roleRw=$o(^DHCNMG.Set.MgRoleNurseI("nurse",roleId," "_rowId,""))
	i roleRw=""
	{
		s roleObj=##class(DHCNMG.Set.MgRoleNurse).%New()
		s roleObj.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
		i $g(tmp("RoleStDate"))'="" s roleObj.RoleStDate=$zdh($g(tmp("RoleStDate")),3)
		i $g(tmp("RoleEndDate"))'="" s roleObj.RoleEndDate=$zdh($g(tmp("RoleEndDate")),3)
		s roleObj.RoleNurse=rowId
		s sc=roleObj.%Save()
		s flag=(flag&&$$$ISOK(sc))
		i flag=1
		{
			s nurseRoleRw=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,""))
			i nurseRoleRw=""
			{
				s nurObj=##class(DHCNMG.HR.MgNurRole).%New()
				s nurObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
				s nurObj.RoleID=roleId
				i $g(tmp("RoleStDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
				i $g(tmp("RoleEndDate"))'="" s nurObj.RoleEndDate=$zdh($tr($g(tmp("RoleEndDate"))," ",""),3)
				s nursc=nurObj.%Save()
				s flag=(flag&&$$$ISOK(nursc))
			}
			else
			{
				s isNurFlag=0,nurRw=""
				s nurSub="" f  s nurSub=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
				.s nurObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurSub)
				.q:nurObj.RoleEndDate'=""
				.s isNurFlag=1
				.s nurRw=nurSub
				i isNurFlag=1
				{
					s rowSub=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRw)
					s rowSub.RoleEndDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
					s rowSc=rowSub.%Save()
					s flag=(flag&&$$$ISOK(rowSc))
					i flag=1
					{
						s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
						s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
						s rowSubNew.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
						s rowSubNew.RoleEndDate=$zdh($tr($g(tmp("RoleEndDate"))," ",""),3)
						s rowSubNew.RoleID=roleId
						s rowNewSc=rowSubNew.%Save()
						s flag=(flag&&$$$ISOK(rowNewSc))
					}
				}
				else
				{
					s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
					s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
					s rowSubNew.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
					s rowSubNew.RoleEndDate=$zdh($tr($g(tmp("RoleEndDate"))," ",""),3)
					s rowSubNew.RoleID=roleId
					s rowNewSc=rowSubNew.%Save()
					s flag=(flag&&$$$ISOK(rowNewSc))
				}
			}
		}
		
	}
	else
	{
		s isFlag=0,rw=""
		s roleSub="" f  s roleSub=$o(^DHCNMG.Set.MgRoleNurseI("nurse",roleId," "_rowId,roleSub)) q:roleSub=""  d
		.s roleObj=##class(DHCNMG.Set.MgRoleNurse).%OpenId(roleId_"||"_roleSub)
		.;q:roleObj.RoleEndDate'=""
		.s isFlag=1
		.s rw=roleId_"||"_roleSub
		i isFlag=1
		{
			s object=##class(DHCNMG.Set.MgRoleNurse).%OpenId(rw)
			i $tr($g(tmp("RoleStDate"))," ","")'="" s roleObj.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
			i $tr($g(tmp("RoleEndDate"))," ","")'="" s roleObj.RoleEndDate=$zdh($tr($g(tmp("RoleEndDate"))," ",""),3)
			s sc1=roleObj.%Save()
			s flag=(flag&&$$$ISOK(sc1))
		}
		else 
		{
			s object=##class(DHCNMG.Set.MgRoleNurse).%New()
			s object.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
			i $g(tmp("RoleStDate"))'="" s object.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
			i $g(tmp("RoleEndDate"))'="" s object.RoleEndDate=$zdh($tr($g(tmp("RoleEndDate"))," ",""),3)
			s object.RoleNurse=rowId
			s sc2=object.%Save()
			s flag=(flag&&$$$ISOK(sc2))
		}
		i flag=1
		{
			s nurseRoleRw=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,""))
			i nurseRoleRw=""
			{
				s nurObj=##class(DHCNMG.HR.MgNurRole).%New()
				s nurObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
				s nurObj.RoleID=roleId
				i $g(tmp("RoleStDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
				i $g(tmp("RoleEndDate"))'="" s nurObj.RoleEndDate=$zdh($tr($g(tmp("RoleEndDate"))," ",""),3)
				s nursc=nurObj.%Save()
				s flag=(flag&&$$$ISOK(nursc))
			}
			else
			{
				s isNurFlag=0,nurRw=""
				s nurSub="" f  s nurSub=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
				.s nurObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurSub)
				.q:nurObj.RoleEndDate'=""
				.s isNurFlag=1
				.s nurRw=nurSub
				i isNurFlag=1
				{
					s rowSub=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRw)
					s rowSub.RoleEndDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
					s rowSc=rowSub.%Save()
					s flag=(flag&&$$$ISOK(rowSc))
					i flag=1
					{
						s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
						s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
						s rowSubNew.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
						s rowSubNew.RoleEndDate=$zdh($tr($g(tmp("RoleEndDate"))," ",""),3)
						s rowSubNew.RoleID=roleId
						s rowNewSc=rowSubNew.%Save()
						s flag=(flag&&$$$ISOK(rowNewSc))
					}
				}
				else
				{
					s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
					s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
					s rowSubNew.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
					s rowSubNew.RoleEndDate=$zdh($tr($g(tmp("RoleEndDate"))," ",""),3)
					s rowSubNew.RoleID=roleId
					s rowNewSc=rowSubNew.%Save()
					s flag=(flag&&$$$ISOK(rowNewSc))
				}
			}
		}
	}
	i flag=1
	{
		TC
	}
	else
	{
		Tro
	}	
	q flag
}

/// 导入带教老师角色
ClassMethod ImportTeacherData(parr As %String) As %String
{
	s tmp=""
	s flag=1
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s perHisNo=$g(tmp("HISNO")) //护士HIS号
	q:perHisNo="" ""
	
	s rowId=$o(^DHCNMG.HR.MgPersonsI("hisno"," "_$zcvt($tr($g(tmp("HISNO"))," ",""),"U"),""))
	q:rowId="" "" //人员表ID
	s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
	q:'$IsObject(PerObj) ""
	s NurName=$tr(PerObj.PerName," ","")
	q:$tr($g(tmp("PerName"))," ","")'=NurName ""
	q:$tr($g(tmp("NurseRole"))," ","")="" ""
	s roleId=$O(^DHCNMG.Set.MgRolesI("desc"," Y"," "_$tr($g(tmp("NurseRole"))," ",""),""))
	q:roleId="" "" //获取角色的ID
	
	TS
	s roleRw=$o(^DHCNMG.Set.MgRoleNurseI("nurse",roleId," "_rowId,""))
	
	i roleRw=""
	{
		s roleObj=##class(DHCNMG.Set.MgRoleNurse).%New()
		s roleObj.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
		i $g(tmp("RoleStDate"))'="" s roleObj.RoleStDate=$zdh($g(tmp("RoleStDate")),3)
		s roleObj.RoleNurse=rowId
		s sc=roleObj.%Save()
		s flag=(flag&&$$$ISOK(sc))
		i flag=1
		{
			s nurseRoleRw=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,""))
			i nurseRoleRw=""
			{
				s nurObj=##class(DHCNMG.HR.MgNurRole).%New()
				s nurObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
				s nurObj.RoleID=roleId
				i $g(tmp("RoleStDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
				s nursc=nurObj.%Save()
				s flag=(flag&&$$$ISOK(nursc))
			}
			else
			{
				s isNurFlag=0,nurRw=""
				s nurSub="" f  s nurSub=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
				.s nurObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurSub)
				.q:nurObj.RoleEndDate'=""
				.s isNurFlag=1
				.s nurRw=nurSub
				i isNurFlag=1
				{
					s rowSub=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRw)
					s rowSub.RoleEndDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
					s rowSc=rowSub.%Save()
					s flag=(flag&&$$$ISOK(rowSc))
					i flag=1
					{
						s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
						s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
						s rowSubNew.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
						s rowSubNew.RoleID=roleId
						s rowNewSc=rowSubNew.%Save()
						s flag=(flag&&$$$ISOK(rowNewSc))
					}
				}
				else
				{
					s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
					s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
					s rowSubNew.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
					s rowSubNew.RoleID=roleId
					s rowNewSc=rowSubNew.%Save()
					s flag=(flag&&$$$ISOK(rowNewSc))
				}
			}
		}
	}
	else
	{
		s isFlag=0,rw=""
		s roleSub="" f  s roleSub=$o(^DHCNMG.Set.MgRoleNurseI("nurse",roleId," "_rowId,roleSub)) q:roleSub=""  d
		.s roleObj=##class(DHCNMG.Set.MgRoleNurse).%OpenId(roleId_"||"_roleSub)
		.s isFlag=1
		.s rw=roleId_"||"_roleSub
		i isFlag=1
		{
			s object=##class(DHCNMG.Set.MgRoleNurse).%OpenId(rw)
			i $tr($g(tmp("RoleStDate"))," ","")'="" s roleObj.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
			s sc1=roleObj.%Save()
			s flag=(flag&&$$$ISOK(sc1))
		}
		else 
		{
			s object=##class(DHCNMG.Set.MgRoleNurse).%New()
			s object.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
			i $g(tmp("RoleStDate"))'="" s object.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
			s object.RoleNurse=rowId
			s sc2=object.%Save()
			s flag=(flag&&$$$ISOK(sc2))
		}
		i flag=1
		{
			s nurseRoleRw=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,""))
			i nurseRoleRw=""
			{
				s nurObj=##class(DHCNMG.HR.MgNurRole).%New()
				s nurObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
				s nurObj.RoleID=roleId
				i $g(tmp("RoleStDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
				s nursc=nurObj.%Save()
				s flag=(flag&&$$$ISOK(nursc))
			}
			else
			{
				s isNurFlag=0,nurRw=""
				s nurSub="" f  s nurSub=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
				.s nurObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurSub)
				.q:nurObj.RoleEndDate'=""
				.s isNurFlag=1
				.s nurRw=nurSub
				i isNurFlag=1
				{
					s rowSub=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRw)
					s rowSub.RoleEndDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
					s rowSc=rowSub.%Save()
					s flag=(flag&&$$$ISOK(rowSc))
					i flag=1
					{
						s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
						s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
						s rowSubNew.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
						s rowSubNew.RoleID=roleId
						s rowNewSc=rowSubNew.%Save()
						s flag=(flag&&$$$ISOK(rowNewSc))
					}
				}
				else
				{
					s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
					s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
					s rowSubNew.RoleStDate=$zdh($tr($g(tmp("RoleStDate"))," ",""),3)
					s rowSubNew.RoleID=roleId
					s rowNewSc=rowSubNew.%Save()
					s flag=(flag&&$$$ISOK(rowNewSc))
				}
			}
		}
	}
	i flag=1
	{
		TC
	}
	else
	{
		Tro
	}	
	q flag
}

/// 导入护士注册证书号
ClassMethod ImportNurseCardData(parr As %String) As %String
{
	s tmp=""
	s flag=1
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s perHisNo=$g(tmp("HISNO")) //护士HIS号
	q:perHisNo="" ""
	
	s rowId=$o(^DHCNMG.HR.MgPersonsI("hisno"," "_$zcvt($tr($g(tmp("HISNO"))," ",""),"U"),""))
	q:rowId="" "" //人员表ID
	s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
	q:'$IsObject(PerObj) ""
	q:(($g(tmp("PerName"))'="")&&($g(tmp("PerName"))'=PerObj.PerName))
	i $g(tmp("PerRegNo"))'="" s PerObj.PerRegNo=$g(tmp("PerRegNo"))
	s sc=PerObj.%Save()
	q $$$ISOK(sc)
}

ClassMethod ImportPostAndHireData(parr As %String) As %String
{
	s tmp=""
	s flag=1
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s perHisNo=$g(tmp("HISNO")) //护士HIS号
	q:perHisNo="" ""
	
	s rowId=$o(^DHCNMG.HR.MgPersonsI("hisno"," "_$zcvt($tr($g(tmp("HISNO"))," ",""),"U"),""))
	q:rowId="" "" //人员表ID
	s PerHireDuty=..GetSetCode("聘任职称",$zcvt($tr($g(tmp("PerHireDuty"))," ",""),"U")) //获取职称的记录ID
	///职称
	s RowID=$o(^DHCNMG.HR.MgHireDutyI("ssid",rowId,""))
	s flag=1
	TS
	i RowID=""
	{
		s HireObj=##class(DHCNMG.HR.MgHireDuty).%New()
		s HireObj.HirePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
		s HireObj.HireDuty=PerHireDuty
		i $g(tmp("PerHireDutyDate"))'="" s HireObj.HireStDate=$zdh($tr(tmp("PerHireDutyDate")," ",""),3)
		e  s HireObj.HireStDate=+$h
		s HireObj.HireStatus="A"
		s sc=obj.%Save()
		s flag=($$$ISOK(sc)&&flag)
	}
	else
	{
		s RwFlag=""
		s stDate="" f  s stDate=$o(^DHCNMG.HR.MgHireDutyI("HireDate",rowId,stDate)) q:stDate=""  d
		.s HireRw="" f  s HireRw=$o(^DHCNMG.HR.MgHireDutyI("HireDate",rowId,stDate,HireRw)) q:HireRw=""  d
		..s HireObj=##class(DHCNMG.HR.MgHireDuty).%OpenId(HireRw)
		..q:HireObj.HireEndDate'=""
		..s RwFlag=HireRw
		..i $g(tmp("PerHireDutyDate"))'="" s HireObj.HireEndDate=$zdh($tr(tmp("PerHireDutyDate")," ",""),3)
		..s sc=HireObj.%Save()
		..s flag=($$$ISOK(sc)&&flag)
		s NewHireObj=##class(DHCNMG.HR.MgHireDuty).%New()
		s NewHireObj.HirePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
		s NewHireObj.HireDuty=PerHireDuty
		s NewHireObj.HireStatus="A"
		i $g(tmp("PerHireDutyDate"))'="" s NewHireObj.HireStDate=$zdh($tr(tmp("PerHireDutyDate")," ",""),3)
		s newSc=NewHireObj.%Save()
		s flag=($$$ISOK(newSc)&&flag)
	}
	s PerPostDuty=..GetSetCode("职务",$zcvt($tr($g(tmp("PerPostDuty"))," ",""),"U")) //获取职务的记录ID
	s PostRowID=$o(^DHCNMG.HR.MgPostDutyI("ssid",rowId,""))
	i PostRowID=""
	{
		s PostObj=##class(DHCNMG.HR.MgPostDuty).%New()
		s PostObj.PostPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
		s PostObj.PostDuty=PerPostDuty
		s PostObj.PostStatus="A"
		i $g(tmp("PerPostDutyDate"))'="" s PostObj.PostStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
		s postSc=PostObj.%Save()
		s flag=($$$ISOK(postSc)&&flag)
		i flag=1
		{
			i $tr($g(tmp("PerPostDuty"))," ","")="护士长"
			{
				s roleId=$O(^DHCNMG.Set.MgRolesI("desc"," Y"," "_$tr($g(tmp("PerPostDuty"))," ",""),""))
				q:roleId="" "" //获取角色的ID
				s nurheadrw=$o(^DHCNMG.Set.MgRoleNurseI("nurse",roleId," "_rowId,""))
				i nurheadrw=""
				{
					s roleObj=##class(DHCNMG.Set.MgRoleNurse).%New()
					s roleObj.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
					i $g(tmp("PerPostDutyDate"))'="" s roleObj.RoleStDate=$zdh($g(tmp("PerPostDutyDate")),3)
					s roleObj.RoleNurse=rowId
					s roleSc=roleObj.%Save()
					s flag=(flag&&$$$ISOK(roleSc))
					i flag=1
					{
						s nurseRoleRw=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,""))
						i nurseRoleRw=""
						{
							s nurObj=##class(DHCNMG.HR.MgNurRole).%New()
							s nurObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
							s nurObj.RoleID=roleId
							i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
							s nursc=nurObj.%Save()
							s flag=(flag&&$$$ISOK(nursc))
						}
						else
						{
							s isNurFlag=0,nurRw=""
							s nurSub="" f  s nurSub=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
							.s nurObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurSub)
							.q:nurObj.RoleEndDate'=""
							.s isNurFlag=1
							.s nurRw=nurSub
							i isNurFlag=1
							{
								s rowSub=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRw)
								i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s rowSc=rowSub.%Save()
								s flag=(flag&&$$$ISOK(rowSc))
								i flag=1
								{
									s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
									s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
									s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s rowSubNew.RoleID=roleId
									s rowNewSc=rowSubNew.%Save()
									s flag=(flag&&$$$ISOK(rowNewSc))
								}
							}
							else
							{
								s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
								s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
								s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s rowSubNew.RoleID=roleId
								s rowNewSc=rowSubNew.%Save()
								s flag=(flag&&$$$ISOK(rowNewSc))
							}
						}
					}
				}
				else
				{
					s isFlag=0,rw=""
					s roleSub="" f  s roleSub=$o(^DHCNMG.Set.MgRoleNurseI("nurse",roleId," "_rowId,roleSub)) q:roleSub=""  d
					.s roleObj=##class(DHCNMG.Set.MgRoleNurse).%OpenId(roleId_"||"_roleSub)
					.s isFlag=1
					.s rw=roleId_"||"_roleSub
					i isFlag=1
					{
						s object=##class(DHCNMG.Set.MgRoleNurse).%OpenId(rw)
						i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s roleObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
						s sc1=roleObj.%Save()
						s flag=(flag&&$$$ISOK(sc1))
					}
					else 
					{
						s object=##class(DHCNMG.Set.MgRoleNurse).%New()
						s object.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
						i $g(tmp("PerPostDutyDate"))'="" s object.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
						s object.RoleNurse=rowId
						s sc2=object.%Save()
						s flag=(flag&&$$$ISOK(sc2))
					}
					i flag=1
					{
						s nurseRoleRw=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,""))
						i nurseRoleRw=""
						{
							s nurObj=##class(DHCNMG.HR.MgNurRole).%New()
							s nurObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
							s nurObj.RoleID=roleId
							i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
							s nursc=nurObj.%Save()
							s flag=(flag&&$$$ISOK(nursc))
						}
						else
						{
							s isNurFlag=0,nurRw=""
							s nurSub="" f  s nurSub=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
							.s nurObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurSub)
							.q:nurObj.RoleEndDate'=""
							.s isNurFlag=1
							.s nurRw=nurSub
							i isNurFlag=1
							{
								s rowSub=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRw)
								i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s rowSc=rowSub.%Save()
								s flag=(flag&&$$$ISOK(rowSc))
								i flag=1
								{
									s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
									s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
									i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s rowSubNew.RoleID=roleId
									s rowNewSc=rowSubNew.%Save()
									s flag=(flag&&$$$ISOK(rowNewSc))
								}
							}
							else
							{
								s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
								s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
								s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s rowSubNew.RoleID=roleId
								s rowNewSc=rowSubNew.%Save()
								s flag=(flag&&$$$ISOK(rowNewSc))
							}
						}
					}
				}
			}
		}
	}
	else
	{
		s PostFlag=0,postRw=""
		s PostDR="" f  s PostDR=$o(^DHCNMG.HR.MgPostDutyI("ssid",rowId,PostDR)) q:PostDR=""  d
		.s PostObjOld=##class(DHCNMG.HR.MgPostDuty).%OpenId(PostDR)
		.q:PostObjOld.PostEndDate'=""
		.s PostFlag=1
		.s postRw=PostDR
		i PostFlag=1
		{
			s rowPost=##class(DHCNMG.HR.MgPostDuty).%OpenId(postRw)
			i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowPost.PostEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
			s rowPostSc=rowPost.%Save()
			s flag=($$$ISOK(rowPostSc)&&flag)
			i flag=1
			{
				s RowPostObj=##class(DHCNMG.HR.MgPostDuty).%New()
				s RowPostObj.PostPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
				s RowPostObj.PostDuty=PerPostDuty
				s RowPostObj.PostStatus="A"
				i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s RowPostObj.PostStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
				s RowSc=RowPostObj.%Save()
				s flag=($$$ISOK(RowSc)&&flag)
				i flag=1
				{
					i $tr($g(tmp("PerPostDuty"))," ","")="护士长"
					{
						s roleId=$O(^DHCNMG.Set.MgRolesI("desc"," Y"," "_$tr($g(tmp("PerPostDuty"))," ",""),""))
						q:roleId="" "" //获取角色的ID
						s nurheadrw=$o(^DHCNMG.Set.MgRoleNurseI("nurse",roleId," "_rowId,""))
						i nurheadrw=""
						{
							s roleObj=##class(DHCNMG.Set.MgRoleNurse).%New()
							s roleObj.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
							i $g(tmp("PerPostDutyDate"))'="" s roleObj.RoleStDate=$zdh($g(tmp("PerPostDutyDate")),3)
							s roleObj.RoleNurse=rowId
							s roleSc=roleObj.%Save()
							s flag=(flag&&$$$ISOK(roleSc))
							i flag=1
							{
								s nurseRoleRw=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,""))
								i nurseRoleRw=""
								{
									s nurObj=##class(DHCNMG.HR.MgNurRole).%New()
									s nurObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
									s nurObj.RoleID=roleId
									i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s nursc=nurObj.%Save()
									s flag=(flag&&$$$ISOK(nursc))
								}
								else
								{
									s isNurFlag=0,nurRw=""
									s nurSub="" f  s nurSub=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
									.s nurObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurSub)
									.q:nurObj.RoleEndDate'=""
									.s isNurFlag=1
									.s nurRw=nurSub
									i isNurFlag=1
									{
										s rowSub=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRw)
										i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s rowSc=rowSub.%Save()
										s flag=(flag&&$$$ISOK(rowSc))
										i flag=1
										{
											s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
											s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
											s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
											s rowSubNew.RoleID=roleId
											s rowNewSc=rowSubNew.%Save()
											s flag=(flag&&$$$ISOK(rowNewSc))
										}
									}
									else
									{
										s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
										s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
										s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s rowSubNew.RoleID=roleId
										s rowNewSc=rowSubNew.%Save()
										s flag=(flag&&$$$ISOK(rowNewSc))
									}
								}
							}
						}
						else
						{
							s isFlag=0,rw=""
							s roleSub="" f  s roleSub=$o(^DHCNMG.Set.MgRoleNurseI("nurse",roleId," "_rowId,roleSub)) q:roleSub=""  d
							.s roleObj=##class(DHCNMG.Set.MgRoleNurse).%OpenId(roleId_"||"_roleSub)
							.s isFlag=1
							.s rw=roleId_"||"_roleSub
							i isFlag=1
							{
								s object=##class(DHCNMG.Set.MgRoleNurse).%OpenId(rw)
								i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s roleObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s sc1=roleObj.%Save()
								s flag=(flag&&$$$ISOK(sc1))
							}
							else 
							{
								s object=##class(DHCNMG.Set.MgRoleNurse).%New()
								s object.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
								i $g(tmp("PerPostDutyDate"))'="" s object.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s object.RoleNurse=rowId
								s sc2=object.%Save()
								s flag=(flag&&$$$ISOK(sc2))
							}
							i flag=1
							{
								s nurseRoleRw=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,""))
								i nurseRoleRw=""
								{
									s nurObj=##class(DHCNMG.HR.MgNurRole).%New()
									s nurObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
									s nurObj.RoleID=roleId
									i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s nursc=nurObj.%Save()
									s flag=(flag&&$$$ISOK(nursc))
								}
								else
								{
									s isNurFlag=0,nurRw=""
									s nurSub="" f  s nurSub=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
									.s nurObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurSub)
									.q:nurObj.RoleEndDate'=""
									.s isNurFlag=1
									.s nurRw=nurSub
									i isNurFlag=1
									{
										s rowSub=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRw)
										i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s rowSc=rowSub.%Save()
										s flag=(flag&&$$$ISOK(rowSc))
										i flag=1
										{
											s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
											s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
											i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
											s rowSubNew.RoleID=roleId
											s rowNewSc=rowSubNew.%Save()
											s flag=(flag&&$$$ISOK(rowNewSc))
										}
									}
									else
									{
										s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
										s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
										s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s rowSubNew.RoleID=roleId
										s rowNewSc=rowSubNew.%Save()
										s flag=(flag&&$$$ISOK(rowNewSc))
									}
								}
							}
						}
					}
				}
			}
		}
		else
		{
			s RowPostObj=##class(DHCNMG.HR.MgPostDuty).%New()
			s RowPostObj.PostPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
			s RowPostObj.PostDuty=PerPostDuty
			s RowPostObj.PostStatus="A"
			i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s RowPostObj.PostStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
			s RowSc=RowPostObj.%Save()
			s flag=($$$ISOK(RowSc)&&flag)
			i flag=1
			{
				i $tr($g(tmp("PerPostDuty"))," ","")="护士长"
				{
					s roleId=$O(^DHCNMG.Set.MgRolesI("desc"," Y"," "_$tr($g(tmp("PerPostDuty"))," ",""),""))
					q:roleId="" "" //获取角色的ID
					s nurheadrw=$o(^DHCNMG.Set.MgRoleNurseI("nurse",roleId," "_rowId,""))
					i nurheadrw=""
					{
						s roleObj=##class(DHCNMG.Set.MgRoleNurse).%New()
						s roleObj.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
						i $g(tmp("PerPostDutyDate"))'="" s roleObj.RoleStDate=$zdh($g(tmp("PerPostDutyDate")),3)
						s roleObj.RoleNurse=rowId
						s roleSc=roleObj.%Save()
						s flag=(flag&&$$$ISOK(roleSc))
						i flag=1
						{
							s nurseRoleRw=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,""))
							i nurseRoleRw=""
							{
								s nurObj=##class(DHCNMG.HR.MgNurRole).%New()
								s nurObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
								s nurObj.RoleID=roleId
								i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s nursc=nurObj.%Save()
								s flag=(flag&&$$$ISOK(nursc))
							}
							else
							{
								s isNurFlag=0,nurRw=""
								s nurSub="" f  s nurSub=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
								.s nurObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurSub)
								.q:nurObj.RoleEndDate'=""
								.s isNurFlag=1
								.s nurRw=nurSub
								i isNurFlag=1
								{
									s rowSub=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRw)
									i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s rowSc=rowSub.%Save()
									s flag=(flag&&$$$ISOK(rowSc))
									i flag=1
									{
										s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
										s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
										s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s rowSubNew.RoleID=roleId
										s rowNewSc=rowSubNew.%Save()
										s flag=(flag&&$$$ISOK(rowNewSc))
									}
								}
								else
								{
									s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
									s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
									s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s rowSubNew.RoleID=roleId
									s rowNewSc=rowSubNew.%Save()
									s flag=(flag&&$$$ISOK(rowNewSc))
								}
							}
						}
					}
					else
					{
						s isFlag=0,rw=""
						s roleSub="" f  s roleSub=$o(^DHCNMG.Set.MgRoleNurseI("nurse",roleId," "_rowId,roleSub)) q:roleSub=""  d
						.s roleObj=##class(DHCNMG.Set.MgRoleNurse).%OpenId(roleId_"||"_roleSub)
						.s isFlag=1
						.s rw=roleId_"||"_roleSub
						i isFlag=1
						{
							s object=##class(DHCNMG.Set.MgRoleNurse).%OpenId(rw)
							i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s roleObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
							s sc1=roleObj.%Save()
							s flag=(flag&&$$$ISOK(sc1))
						}
						else 
						{
							s object=##class(DHCNMG.Set.MgRoleNurse).%New()
							s object.Parref=##class(DHCNMG.Set.MgRoles).%OpenId(roleId)
							i $g(tmp("PerPostDutyDate"))'="" s object.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
							s object.RoleNurse=rowId
							s sc2=object.%Save()
							s flag=(flag&&$$$ISOK(sc2))
						}
						i flag=1
						{
							s nurseRoleRw=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,""))
							i nurseRoleRw=""
							{
								s nurObj=##class(DHCNMG.HR.MgNurRole).%New()
								s nurObj.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
								s nurObj.RoleID=roleId
								i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s nursc=nurObj.%Save()
								s flag=(flag&&$$$ISOK(nursc))
							}
							else
							{
								s isNurFlag=0,nurRw=""
								s nurSub="" f  s nurSub=$o(^DHCNMG.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
								.s nurObj=##class(DHCNMG.HR.MgNurRole).%OpenId(nurSub)
								.q:nurObj.RoleEndDate'=""
								.s isNurFlag=1
								.s nurRw=nurSub
								i isNurFlag=1
								{
									s rowSub=##class(DHCNMG.HR.MgNurRole).%OpenId(nurRw)
									i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s rowSc=rowSub.%Save()
									s flag=(flag&&$$$ISOK(rowSc))
									i flag=1
									{
										s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
										s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
										i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s rowSubNew.RoleID=roleId
										s rowNewSc=rowSubNew.%Save()
										s flag=(flag&&$$$ISOK(rowNewSc))
									}
								}
								else
								{
									s rowSubNew=##class(DHCNMG.HR.MgNurRole).%New()
									s rowSubNew.RolePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
									s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s rowSubNew.RoleID=roleId
									s rowNewSc=rowSubNew.%Save()
									s flag=(flag&&$$$ISOK(rowNewSc))
								}
							}
						}
					}
				}
			}	
		}
	}
	i flag=1
	{
		Tc
	}
	else
	{
		tro
	}
	q flag
}

ClassMethod ImportNurseLevel(parr As %String) As %String
{
	s tmp=""
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s perHisNo=$g(tmp("HISNO")) //护士HIS号
	q:perHisNo="" ""
	s PerLevel=..GetSetCode("护士层级",$zcvt($tr($g(tmp("PerLevel"))," ",""),"U")) //获取职务的记录ID
	s rowId=$o(^DHCNMG.HR.MgPersonsI("hisno"," "_$zcvt($tr($g(tmp("HISNO"))," ",""),"U"),""))
	q:rowId="" "" //人员表ID
	s flag=0,OldRow=""
	s RowID="" f  s RowID=$o(^DHCNMG.HR.MgLevelI("ssid",rowId,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.HR.MgLevel).%OpenId(RowID)
	.q:'$IsObject(obj)
	.s nurseLevel=##class(web.NurMgPersonComm).GetCommCode(obj.NurLevel)
	.q:nurseLevel=""
	.i $g(tmp("PerLevel"))=nurseLevel d
	..s flag=1
	..s OldRow=RowID
	
	i flag=1 d
	.s LevelObj=##class(DHCNMG.HR.MgLevel).%OpenId(OldRow)
	.i $g(tmp("LevelDate"))'="" s LevelObj.LevelDate=$zdh($tr($g(tmp("LevelDate"))," ",""),3)
	.s sc=LevelObj.%Save()
	e  d
	.s LevelObj=##class(DHCNMG.HR.MgLevel).%New()
	.s LevelObj.LevelPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(rowId)
	.s LevelObj.LevelStatus="A"
	.i $g(tmp("LevelDate"))'="" s LevelObj.LevelDate=$zdh($tr($g(tmp("LevelDate"))," ",""),3)
	.s LevelObj.NurLevel=PerLevel
	.s sc=LevelObj.%Save()
	
	q 0
}

/// 暂停使用该方法
ClassMethod UpDataMgMergeInfo() As %String
{
	s ssid="" f  s ssid=$o(^DHCNMG.DB.MgMergeHisInfoI("ssid",ssid)) q:ssid=""  d
	.s rowid="" f  s rowid=$o(^DHCNMG.DB.MgMergeHisInfoI("ssid",ssid,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgMergeHisInfo).%OpenId(rowid)
	..s perobj=##class(DHCNMG.HR.MgPersons).%OpenId($tr(ssid," ",""))
	..s hisno=perobj.HISNO
	..s obj.MergeHISNo=$zcvt($tr(hisno," ",""),"U")
	..d obj.%Save()
	q 0
}

/// 
/// 
/// 更新护士科室信息
ClassMethod UpdateNurseLoc() As %String
{
	s row=0 f  s row=$o(^DHCNMNURSES("DHCNMNURSE","nursers",row)) q:row=""  d
	.s loc=$p(^DHCNMNURSES("DHCNMNURSE","nursers",row),"^",3)
	.s nurseID=$p(^DHCNMNURSES("DHCNMNURSE","nursers",row),"^",2)
	.s NurseRow=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_$zcvt($tr(nurseID," ",""),"U"),""))
	.i NurseRow'="" d
	..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(NurseRow)
	..q:'$IsObject(obj)
	..s obj.PerLocDR=loc
	..d obj.%Save()
	q 0
}

}
