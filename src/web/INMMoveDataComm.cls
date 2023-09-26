Class web.INMMoveDataComm Extends %RegisteredObject
{

/// Creator: lcy
/// CreateDate: 20200911
/// Description: 迁移病区数据
/// Table: DHCNMG.DB.MgWard,CF.DHCINM.DB.MgWard
/// Input:
/// Output:
/// Return:
/// Other: w ##class(web.INMMoveDataComm).MigrationWard()
ClassMethod MigrationWard()
{
	s id=""
	w "开始迁移病区数据",!
	s oldId="" f  s oldId=$O(^DHCNMG.DB.MgWardD(oldId)) q:oldId=""  d
	.s oldObj=##class(DHCNMG.DB.MgWard).%OpenId(oldId)
	.q:'$IsObject(oldObj)
	.s newObj=##class(CF.DHCINM.DB.MgWard).%New()
	.i oldObj.CTLocDR'="" s newObj.CTLocDR=##class(User.CTLoc).%OpenId(oldObj.CTLocDR.%Id())
	.s newObj.WardCode=oldObj.WardCode
	.s newObj.WardDesc=oldObj.WardDesc
	.i oldObj.WardTypeDR'="" s newObj.WardTypeDR=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(oldObj.WardTypeDR.%Id())
	.i oldObj.CTHospitalDR'="" s newObj.CTHospitalDR=##class(User.CTHospital).%OpenId(oldObj.CTHospitalDR.%Id())
	.s newObj.WardSpell=oldObj.WardSpell
	.s newObj.WardShort=oldObj.WardShort
	.i oldObj.WardAreaDR'="" s newObj.WardAreaDR=##class(CF.DHCINM.DB.MgWardArea).%OpenId(oldObj.WardAreaDR.%Id())
	.d newObj.WardLimits.Clear()
	.f i=1:1:oldObj.WardLimits.Count() d
	..s lim=oldObj.WardLimits.GetAt(i)
	..d newObj.WardLimits.Insert(lim)
	.s newObj.WardStDate=oldObj.WardStDate
	.s newObj.WardEndDate=oldObj.WardEndDate
	.s newObj.WardFire=oldObj.WardFire
	.s newObj.WardBedNum=oldObj.WardBedNum
	.s newObj.WardSort=oldObj.WardSort
	.s newObj.WardRemark=oldObj.WardRemark
	.s sc=newObj.%Save()
	.s sc=..AddMoveData("WARD",newObj.%Id(),oldId)
	.i $$$ISERR(sc)  d
	..w oldId_" 失败失败失败失败失败失败失败失败",!
	..s id=0
	.;e  w oldId_" "_newObj.%Id(),!
	w "迁移病区数据完成",!
	q id
}

/// Creator: lcy
/// CreateDate: 20200911
/// Description: 迁移科室数据
/// Table: DHCNMG.DB.MgWardLoc,CF.DHCINM.DB.MgWardLoc
/// Input:
/// Output:
/// Return:
/// Other:
ClassMethod MigrationLoc()
{
	s id=""
	w "开始迁移科室数据",!
	s oldId="" f  s oldId=$O(^DHCNMG.DB.MgWardLocD(oldId)) q:oldId=""  d
	.s oldObj=##class(DHCNMG.DB.MgWardLoc).%OpenId(oldId)
	.q:'$IsObject(oldObj)
	.s newObj=##class(CF.DHCINM.DB.MgWardLoc).%New()
	.s newObj.LocCode=oldObj.LocCode
	.s newObj.LocDesc=oldObj.LocDesc
	.i oldObj.CTLocDR'="" s newObj.CTLocDR=##class(User.CTLoc).%OpenId(oldObj.CTLocDR.%Id())
	.i oldObj.LocNurHeadDR'="" s newObj.LocNurHeadDR=##class(CF.DHCINM.HR.Persons).%OpenId(oldObj.LocNurHeadDR.%Id())
	.s newObj.LocStDate=oldObj.LocStDate
	.s newObj.LocEndDate=oldObj.LocEndDate
	.i oldObj.LocAreaDR'="" s newObj.LocAreaDR=##class(CF.DHCINM.DB.MgWardArea).%OpenId(oldObj.LocAreaDR.%Id())
	.s sc=newObj.%Save()
	.s sc=..AddMoveData("LOC",newObj.%Id(),oldId)
	.i $$$ISERR(sc)  d
	..w oldId_" 失败失败失败失败失败失败失败失败",!
	..s id=0
	.;e  w oldId_" "_newObj.%Id(),!
	w "迁移科室数据完成",!
	q id
}

/// Creator: lcy
/// CreateDate: 20200911
/// Description: 迁移科室病区关联数据
/// Table: DHCNMG.DB.MgWardLocUnit,CF.DHCINM.DB.MgWardLocUnit
/// Input:
/// Output:
/// Return:
/// Other:w ##class(web.INMMoveDataComm).MigrationWardLoc()
ClassMethod MigrationWardLoc()
{
	s id=""
	w "开始迁移病区关联科室数据",!
	s oldId="" f  s oldId=$O(^DHCNMG.DB.MgWardLocUnitD(oldId)) q:oldId=""  d
	.s oldObj=##class(DHCNMG.DB.MgWardLocUnit).%OpenId(oldId)
	.q:'$IsObject(oldObj)
	.s newObj=##class(CF.DHCINM.DB.MgWardLocUnit).%New()
	.s newObj.UnitLocDR=..GetMoveData("LOC",oldObj.UnitLocDR)
	.s oldLocID=oldObj.UnitLocDR
	.s newLocID=..GetMoveData("LOC",oldObj.UnitLocDR)
	.s oldWardID=oldObj.UnitWardDR
	.s newWardID=..GetMoveData("WARD",oldObj.UnitWardDR)
	.s newObj.UnitDesc=oldObj.UnitDesc
	.s newObj.UnitWardDR=..GetMoveData("WARD",oldObj.UnitWardDR)
	.s sc=newObj.%Save()
	.i $$$ISERR(sc)  d
	..w oldId_" 失败失败失败失败失败失败失败",!
	..s id=0
	.;e  w oldId_" "_newObj.%Id(),!
	w "迁移病区关联科室数据完成",!
	q id
}

/// Creator: liwenzhen
/// CreateDate: 20201104
/// Description: 迁移公共代码
/// Other:w ##class(web.INMMoveDataComm).MoveSetCode()
ClassMethod MoveSetCode()
{
	s id=""
	w "开始迁移公共代码数据",!
	s code="" f  s code=$o(^DHCNMG.DB.MgSetCodeI("Code",code)) q:code=""  d
	.s newID=$O(^CT.DHCINM.DB.MgSetCodeI("Code",code,""))
	.s oldID="" f  s oldID=$o(^DHCNMG.DB.MgSetCodeI("Code",code,oldID)) q:oldID=""  d
	..i newID'="" d
	...s newObj=##class(CT.DHCINM.DB.MgSetCode).%OpenId(newID)
	..e  d
	...s newObj=##class(CT.DHCINM.DB.MgSetCode).%New()
	...s oldObj=##class(DHCNMG.DB.MgSetCode).%OpenId(oldID)
	...s newObj.SetCode=oldObj.SetCode
	...s newObj.SetDesc=oldObj.SetDesc
	...s newObj.SetRemark=oldObj.SetRemark
	...s newObj.SetStatus=newObj.SetStatus
	...d newObj.%Save()
	...s newID=newObj.%Id()
	..s oldSubID="" f  s oldSubID=$O(^DHCNMG.DB.MgSetCodeSubD(oldID,oldSubID)) q:oldSubID=""  d
	...s oldSubObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(oldID_"||"_oldSubID)
	...s newSubID=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",newID," "_oldSubObj.SubCode,""))
	...i newSubID="" d
	....s newSubObj=##class(CT.DHCINM.DB.MgSetCodeSub).%New()
	....s newSubObj.Parref=##class(CT.DHCINM.DB.MgSetCode).%OpenId(newID)  
	...e  d
	....s newSubObj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(newID_"||"_newSubID)
	...s newSubObj.SubCode=oldSubObj.SubCode
	...s newSubObj.SubDesc=oldSubObj.SubDesc
	...s newSubObj.SubEndDate=oldSubObj.SubEndDate
	...s newSubObj.SubRemark=oldSubObj.SubRemark
	...s newSubObj.SubSort=oldSubObj.SubSort
	...s newSubObj.SubStDate=oldSubObj.SubStDate
	...s newSubObj.SubSymbol=oldSubObj.SubSymbol
	...s sc=newSubObj.%Save()
	...s sc=..AddMoveData("CODE",newSubObj.%Id(),oldID_"||"_oldSubID)
	...i $$$ISERR(sc)  d
	....w oldID_"||"_oldSubID_" 失败失败失败失败失败失败失败",!
	....s id=0
	...;e  w oldID_"||"_oldSubID_" "_newSubObj.%Id(),!
	w "迁移公共代码数据完成",!
	q id
}

ClassMethod InsertNullPerAndUser(tmpNullPer) As %String
{
	s new=##class(CF.DHCINM.HR.Persons).%New()
	d new.%Save()
	s newUser=##class(CF.DHCINM.DB.MgUser).%New()
	d newUser.%Save()
	s tmpNullPer(new.%Id())=new.%Id()
}

ClassMethod KillNullPerAndUser(tmpNullPer) As %String
{
	s perId="" f  s perId=$O(tmpNullPer(perId)) q:perId=""  d
	.d ##class(CF.DHCINM.HR.Persons).%DeleteId(perId)
	.d ##class(CF.DHCINM.DB.MgUser).%DeleteId(perId)
}

/// 迁移人员信息
/// w ##class(web.INMMoveDataComm).TransOldPer()
ClassMethod TransOldPer() As %String
{
	w "开始人员数据",!
	k tmpNullPer
	s tmpNullPer="" ;针对跳user表信息进行处理,仅限第一次
	s beforId=0
	s id="" f  s id=$o(^DHCNMG.HR.MgPersonsD(id)) q:id=""  d
	.i ((id-beforId)>1) d
	..s insertNum=id-beforId-1
	..f i=1:1:(insertNum) d
	...d ..InsertNullPerAndUser(.tmpNullPer)
	...s beforId=beforId+1
	.q:((id-beforId)>1)
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	.q:'$IsObject(obj)
	.s new=##class(CF.DHCINM.HR.Persons).%New()
	.s new.PerName=obj.PerName
	.s new.PerID=obj.PerID
	.s new.PerNo=obj.PerNo
	.s:obj.HISNO'="" new.PerUserDR=##class(web.INMHISComm).GetUserIdByCode(obj.HISNO)
	.s new.PerBirthday=obj.PerBirthday
	.s new.PerCardId=obj.PerCardId
	.s new.PerCareType=obj.PerCareType
	.s new.PerSexDR=..GetMoveData("CODE",obj.PerSexDR)
	.s new.PerDepDR=..GetMoveData("WARD",obj.PerDepDR)
	.s new.PerDepDate=obj.PerDepDate
	.s new.PerComeDate=obj.PerComeDate
	.s new.PerYear=obj.PerYear
	.s new.PerWorkDate=obj.PerWorkDate
	.s new.PerRegNo=obj.PerRegNo
	.s new.PerMarriage=..GetMoveData("CODE",obj.PerMarriage)
	.s new.PerNativePlace=obj.PerNativePlace
	.s new.NativeAddress=obj.PerNativePlace ///籍贯详细地址
	.s new.PerSource=..GetMoveData("CODE",obj.PerSource) //受聘形式
	.s new.PerAddress=obj.PerAddress
	.s new.CurrentAddress=obj.PerAddress ///现住址详细地址
	.s new.PerPolitical=..GetMoveData("CODE",obj.PerPolitical)
	.s new.PerNation=..GetMoveData("CODE",obj.PerNation)
	.s new.PerClothesNo=..GetMoveData("CODE",obj.PerClothesNo)
	.s new.PerShoesNo=..GetMoveData("CODE",obj.PerShoesNo)
	.s new.PerTrouserNo=..GetMoveData("CODE",obj.PerTrouserNo)
	.s new.PerTypeDR=obj.PerTypeDR
	.s new.PerTransFlag=obj.PerTransFlag
	.s new.PerWordType=obj.PerWordType
	.s new.PerNurType=obj.PerNurType
	.s new.PerContact=obj.PerContact
	.s new.PerPhone=obj.PerPhone
	.s new.PerHeight=obj.PerHeight
	.s new.PerRetireDate=obj.PerRetireDate
	.s new.PerResignDate=obj.PerResignDate
	.s new.PerPic=obj.PerPic
	.s new.PerAuditFlag=obj.PerAuditFlag
	.;s new.PerAuditor="" //审核人
	.;s new.PerAuditDate="" //审核日期
	.;s new.RecUser="" //添加人
	.;s new.RecDate="" //更新日期
	.;s new.RecTime="" //更新时间
	.;s new.PerAuditDate="" //审核日期
	.s new.PerHosShortNo=obj.PerHosShortNo //院内短号
	.s new.PerStatus=..GetMoveData("CODE",obj.PerStatus)
	.s new.PerStateDate=obj.PerStateDate
	.s new.PerStatuReason=obj.PerStatuReason
	.s new.PerCadreDate=obj.PerCadreDate
	.s new.PerHomeAddress=obj.PerHomeAddress
	.s new.HomeAddress=obj.PerHomeAddress //家庭地址详细地址
	.s new.PerHouseAddress=obj.PerHouseAddress
	.s new.RegistedAddress=obj.PerHouseAddress //户口所在地详细地址
	.s new.PerLocDR=..GetMoveData("LOC",obj.PerLocDR)
	.s new.PerPassword=obj.PerPassword
	.s new.HISNO=obj.HISNO
	.s new.ImportDate=obj.ImportDate
	.;s new.ImportUser=obj.ImportUser //导入人
	.s new.PrepareDate=obj.PrepareDate //纳编日期
	.s new.PerTrialWork=obj.PerTrialWork //试工
	.s new.PerTrialDate=obj.PerTrialDate //试工期至
	.s new.PerTrialQual=obj.PerTrialQual //试工合格
	.s new.PerForeignLevel=..GetMoveData("CODE",obj.PerForeignLevel)
	.s new.PerIsEspecially=obj.PerIsEspecially
	.s new.PerEspecially=obj.PerEspecially
	.s new.PerIsRegiste=obj.PerIsRegiste //有无执业证书
	.s new.PerSocietyPart=obj.PerSocietyPart
	.s new.PerInNursePost=..GetSetCodeSub("定科") //在岗状态
	.s new.PerPostName=..GetMoveData("CODE",obj.PerPostName) //岗位名称
	.s new.PerAttriDepart=..GetMoveData("CODE",obj.PerAttriDepart) //归属部门
	.;s new.PerLeaveMode=obj.PerLeaveMode
	.;s new.PerLeaveReason=obj.PerLeaveReason
	.;s new.PerLeaveDate=obj.PerLeaveDate
	.s new.PerCategroy=..GetMoveData("CODE",obj.PerCategroy) //应往届
	.s new.AuditReason=obj.AuditReason
	.s new.AuditTime=obj.AuditTime
	.s new.PerInternSchool=..GetMoveData("CODE",obj.PerInternSchool) //实习生院校
	.s new.PerWeight=obj.PerWeight
	.s new.PerHobby=obj.PerHobby
	.s new.PerType=..GetMoveData("CODE",obj.PerType) //实习生学历
	.//来院进修(
	.s new.PerTrainFlag=obj.PerTrainFlag
	.s new.PerUnit=obj.PerUnit
	.s new.PerHireJob=..GetMoveData("CODE",obj.PerHireJob)
	.s new.PerTrainStDate=obj.PerTrainStDate
	.s new.PerTrainEndDate=obj.PerTrainEndDate
	.s new.PerTrainFee=obj.PerTrainFee
	.//)来院进修
	.s new.PerRemark=obj.PerRemark
	.s new.PerPostCompete=obj.PerPostCompete
	.s new.PerContactPhone=obj.PerContactPhone
	.s new.PerInternDate=obj.PerInternDate
	.s new.PerStuToAss=obj.PerStuToAss
	.s new.PerStuToNurse=obj.PerStuToNurse
	.s new.PerAssToNurse=obj.PerAssToNurse
	.s new.PerAssToStu=obj.PerAssToStu
	.s new.PerInternToStu=obj.PerInternToStu
	.s new.PerInternDate=obj.PerInternDate
	.s new.PerSJHireDuty=..GetMoveData("CODE",obj.PerSJHireDuty)
	.s new.PerSJHireDutyDate=obj.PerSJHireDutyDate
	.s sc=new.%Save()
	.s sc=..AddMoveData("PERSON",new.%Id(),id)
	.q:$$$ISERR(sc)
	.s beforId=new.%Id()
	.;w obj.%Id(),"--->",new.%Id(),!
	.s userObj=##class(CF.DHCINM.DB.MgUser).%New()
	.s userObj.UserName=new.PerName
	.s userObj.UserID=new.PerID 
	.s userObj.UserDR=new.PerUserDR
	.s userObj.PerDR=new.%Id()
	.s userObj.PerDepDR=new.PerDepDR
	.s userObj.Password=new.PerPassword
	.s userObj.StartDate=+$h
	.s sc=userObj.%Save()
	.q:$$$ISERR(sc)
	.;w "Add User ",userObj.%Id(),!
	.s oldRoleId="" f  s oldRoleId=$o(^DHCNMG.HR.MgNurRoleI("ssid",obj.%Id(),oldRoleId)) q:oldRoleId=""  d
	..s oldRoleObj=##class(DHCNMG.HR.MgNurRole).%OpenId(oldRoleId)
	..q:'$IsObject(oldRoleObj)
	..s userRoleObj=##class(CF.DHCINM.DB.MgUserRole).%New()
	..s userRoleObj.Parref=userObj
	..s userRoleObj.RoleID=$case(oldRoleObj.RoleID,2:3,3:2,:oldRoleObj.RoleID)
	..s userRoleObj.RoleStDate=oldRoleObj.RoleStDate
	..s userRoleObj.RoleEndDate=oldRoleObj.RoleEndDate
	..s sc=userRoleObj.%Save()
	..i '$$$ISOK(sc)  w "添加用户角色失败",!
	..q:$$$ISERR(sc)
	..s oldLimitParId="" f  s oldLimitParId=$o(^DHCNMG.DB.MgDataLimitI("Role"," "_oldRoleObj.RoleID," "_obj.%Id(),oldLimitParId)) q:oldLimitParId=""  d
	...s oldLimitParObj=##class(DHCNMG.DB.MgDataLimit).%OpenId(oldLimitParId)
	...q:'$IsObject(oldLimitParObj)
	...s newLimitParObj=##class(CF.DHCINM.Set.MgDataLimit).%New()
	...s newLimitParObj.LimitNurse=new.%Id()
	...s newLimitParObj.LimitRole=$case(oldLimitParObj.LimitRole,2:3,3:2,:oldLimitParObj.LimitRole)
	...s newLimitParObj.LimitRemark=oldLimitParObj.LimitRemark
	...s sc=newLimitParObj.%Save()
	...i '$$$ISOK(sc) w "添加用户角色病区父表失败",!
	...q:$$$ISERR(sc)
	...s oldLimitSubId="" f  s oldLimitSubId=$o(^DHCNMG.DB.MgDataLimitSubD(oldLimitParId,oldLimitSubId)) q:oldLimitSubId=""  d
	....s oldLimitSubObj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(oldLimitParId_"||"_oldLimitSubId)
	....q:'$IsObject(oldLimitSubObj)
	....s newWardId=..GetMoveData("WARD",oldLimitSubObj.SubWard)
	....q:newWardId=""
	....s newLimitSubObj=##class(CF.DHCINM.Set.MgDataLimitSub).%New()
	....s newLimitSubObj.Parref=newLimitParObj
	....s newLimitSubObj.SubWard=newWardId
	....s sc=newLimitSubObj.%Save()
	....i '$$$ISOK(sc)  w "添加用户角色病区子表失败",!
	.s transFlag=##class(web.INMPersonComm).SaveTransData("^"_new.%Id()_"^"_new.PerDepDR_"^2020-09-01^"_$zt($P($H,",",2),1)_"^Y")
	.q:$$$ISERR(sc)
	.s oldHireId="" f  s oldHireId=$o(^DHCNMG.HR.MgHireDutyI("ssid",obj.%Id(),oldHireId)) q:oldHireId=""  d
	..s oldHireObj=##class(DHCNMG.HR.MgHireDuty).%OpenId(oldHireId)
	..q:'$IsObject(oldHireObj)
	..s newHireId=..GetMoveData("CODE",oldHireObj.HireDuty)
	..q:newHireId=""
	..s newHireObj=##class(CF.DHCINM.HR.HireDuty).%New()
	..s newHireObj.HirePerDR=new
	..s newHireObj.HireDuty=newHireId
	..s newHireObj.HireStDate=oldHireObj.HireStDate
	..s newHireObj.HireEndDate=oldHireObj.HireEndDate
	..s newHireObj.HireRemark=oldHireObj.HireRemark
	..s newHireObj.HireStatus=oldHireObj.HireStatus
	..s sc=newHireObj.%Save()
	..i '$$$ISOK(sc) w "添加用户职称失败",!
	.s oldPostId="" f  s oldPostId=$o(^DHCNMG.HR.MgPostDutyI("ssid",obj.%Id(),oldPostId)) q:oldPostId=""  d
	..s oldPostObj=##class(DHCNMG.HR.MgPostDuty).%OpenId(oldPostId)
	..q:'$IsObject(oldPostObj)
	..s newPostId=..GetMoveData("CODE",oldPostObj.PostDuty)
	..q:newPostId=""
	..s newPostObj=##class(CF.DHCINM.HR.PostDuty).%New()
	..s newPostObj.PostPerDR=new
	..s newPostObj.PostDuty=newPostId
	..s newPostObj.PostStDate=oldPostObj.PostStDate
	..s newPostObj.PostEndDate=oldPostObj.PostEndDate
	..s newPostObj.PostRemark=oldPostObj.PostRemark
	..s newPostObj.PostStatus=oldPostObj.PostStatus
	..s sc=newPostObj.%Save()
	..i '$$$ISOK(sc) w "添加用户职务失败",!
	.s oldLevelId="" f  s oldLevelId=$o(^DHCNMG.HR.MgLevelI("ssid",obj.%Id(),oldLevelId)) q:oldLevelId=""  d
	..s oldLevelObj=##class(DHCNMG.HR.MgLevel).%OpenId(oldLevelId)
	..q:'$IsObject(oldLevelObj)
	..s newLevelId=..GetMoveData("CODE",oldLevelObj.NurLevel)
	..q:newLevelId=""
	..s newLevelObj=##class(CF.DHCINM.HR.MgLevel).%New()
	..s newLevelObj.LevelPerDR=new
	..s newLevelObj.NurLevel=newLevelId
	..s newLevelObj.LevelDate=oldLevelObj.LevelDate
	..s newLevelObj.LevelRemark=oldLevelObj.LevelRemark
	..s newLevelObj.LevelStatus=oldLevelObj.LevelStatus
	..s newLevelObj.LevelFactor=oldLevelObj.LevelFactor
	..s sc=newLevelObj.%Save()
	..i '$$$ISOK(sc) w "添加用户层级失败",!
	.s oldEduId="" f  s oldEduId=$o(^DHCNMG.HR.MgEducateI("ssid",obj.%Id(),oldEduId)) q:oldEduId=""  d
	..s oldEduObj=##class(DHCNMG.HR.MgEducate).%OpenId(oldEduId)
	..q:'$IsObject(oldEduObj)
	..s newSchoolId=..GetMoveData("CODE",oldEduObj.EduSchool)
	..;q:newSchoolId=""
	..s newAcademicId=..GetMoveData("CODE",oldEduObj.EduAcademic)
	..;q:newAcademicId=""
	..s newDegreeId=..GetMoveData("CODE",oldEduObj.EduDegree)
	..;q:newDegreeId=""
	..s newRadioId=..GetMoveData("CODE",oldEduObj.EduRadio)
	..;q:newRadioId=""
	..s newProfessionId=..GetMoveData("CODE",oldEduObj.EduProfession)
	..;q:newProfessionId=""
	..s newEduObj=##class(CF.DHCINM.HR.Educate).%New()
	..s newEduObj.EduPerDR=new
	..s newEduObj.EduStDate=oldEduObj.EduStDate
	..s newEduObj.EduEndDate=oldEduObj.EduEndDate
	..s newEduObj.EduSchool=newSchoolId
	..s newEduObj.EduAcademic=newAcademicId
	..s newEduObj.EduDegree=newDegreeId
	..s newEduObj.EduRadio=newRadioId
	..s newEduObj.EduProfession=newProfessionId
	..s newEduObj.EduDegreeDate=oldEduObj.EduDegreeDate
	..s newEduObj.EduStatus=oldEduObj.EduStatus
	..s sc=newEduObj.%Save()
	..i '$$$ISOK(sc) w "添加用户教育经历失败",!
	.i new.PerRegNo'="" d
	..s regObj=##class(DHCINM.HR.MgQualRegisted).%New()
	..s regObj.RegistedPerson=new.%Id()
	..s regObj.RegistedDate=obj.PerRegRegiDate
	..s regObj.RegistedStatus="A"
	..s sc=regObj.%Save()
	..i '$$$ISOK(sc) w "插入注册证书失败",!
	.i obj.PerSpeciNurse'="" d
	..s specObj=##class(DHCINM.Special.SpecialNurse).%New()
	..s specObj.SpecialPer=new
	..s specObj.SpecialAuthDate=obj.PerSeciNurseDate 
	..s newSpecId=..GetMoveData("CODE",obj.PerSpeciNurse.GetAt(1))
	..s specObj.SpecialNurType=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(newSpecId)
	..s specObj.SpecialStatus="A"
	..s sc=specObj.%Save()
	..i '$$$ISOK(sc) w "插入专科护士失败",!
	d ..KillNullPerAndUser(.tmpNullPer)
	w "迁移人员数据完成",!
	q ""
}

/// Creator: liwenzhen
/// CreateDate: 20201104
/// Description: 获取在岗状态子表ID
/// Other:w ##class(web.INMMoveDataComm).GetSetCodeSub("定科")
ClassMethod GetSetCodeSub(code As %String)
{
	s id=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," 在岗状态",""))
	q:id="" ""
	s subId=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",id," "_code,""))
	q id_"||"_subId
}

/// Creator: liwenzhen
/// CreateDate: 20201104
/// Description: 记录新旧表ID
/// Other:w ##class(web.INMMoveDataComm).AddMoveData()
ClassMethod AddMoveData(type As %String, newID As %String, oldID As %String)
{
	s moveObj=##class(DHCINM.DB.MgMoveData).%New()
	s moveObj.Type=type
	s moveObj.NewID=newID
	s moveObj.OldID=oldID
	s sc=moveObj.%Save()
	q sc
}

/// Creator: liwenzhen
/// CreateDate: 20201104
/// Description: 根据旧表id获取新表ID
/// Other:w ##class(web.INMMoveDataComm).GetMoveData("LOC","34")
ClassMethod GetMoveData(type As %String, oldID As %String)
{
	q:oldID="" ""
	s newID=$o(^DHCINM.DB.MgMoveDataI("type"," "_type," "_oldID,""))
	q $replace(newID," ","")
}

/// Creator: liwenzhen
/// CreateDate: 20201104
/// Description: 新表初始化
/// Other:w ##class(web.INMMoveDataComm).KillMoveData()
ClassMethod KillMoveData()
{
	k ^DHCINM.DB.MgMoveDataD
	k ^DHCINM.DB.MgMoveDataI
	k ^CF.DHCINM.DB.MgWardD
	k ^CF.DHCINM.DB.MgWardI
	k ^CF.DHCINM.DB.MgWardLocD
	k ^CF.DHCINM.DB.MgWardLocI
	k ^CF.DHCINM.DB.MgWardLocUnitD
	k ^CF.DHCINM.DB.MgWardLocUnitI
	k ^CF.DHCINM.Trans.TransDepD
	k ^CF.DHCINM.Trans.TransDepI
	
	q 1
}

/// d ##class(web.INMMoveDataComm).MoveAllData()
ClassMethod MoveAllData()
{
	

	s id=..MigrationWard()
	q:id=0 "病区迁移失败"
	s id=..MigrationLoc()
	q:id=0 "科室迁移失败"
	s id=..MigrationWardLoc()
	q:id=0 "病区关联科室迁移失败"
	s id=..MoveSetCode()
	q:id=0 "公共代码迁移失败"
	s id=..TransOldPer()
	d ..MoveResignData()
	w !,"迁移转科记录开始"
	d ##class(web.INMMoveDataComm).MoveFirstDep()
	w !,"迁移转科记录结束"
	w !,"迁移调科信息开始"
	d ##class(web.INMMoveDataComm).MoveTransDepData()
	w !,"迁移调科信息结束"
	w !,"执行转科记录开始"
	d ##class(web.INMSysTaskComm).ExcuteTransDep()
	w !,"执行转科记录结束"
	w !,"迁移排班记录开始"
	d ##class(web.INMMoveDataComm).MoveData("DHCNMG.DB.MgArgPost","CF.DHCINM.DB.MgArgPost")
	d ##class(web.INMMoveDataComm).MoveData("DHCNMG.DB.MgArgWardPost","CF.DHCINM.DB.MgArgWardPost")
	d ##class(web.INMMoveDataComm).MoveData("DHCNMG.Arg.MgNurGroup","DHCINM.Arg.MgNurGroup")
	d ##class(web.INMMoveDataComm).MoveData("DHCNMG.Arg.MgArrange","DHCINM.Arg.MgArrange")
	d ##class(web.INMMoveDataComm).MoveData("DHCNMG.Arg.MgArrangeGroup","DHCINM.Arg.MgArrangeGroup")
	d ##class(web.INMMoveDataComm).MoveData("DHCNMG.Arg.MgArrangeRow","DHCINM.Arg.MgArrangeRow")
	d ##class(web.INMMoveDataComm).MoveData("DHCNMG.Arg.MgArrangeSub","DHCINM.Arg.MgArrangeSub")
	d ##class(web.INMMoveDataComm).MoveData("DHCNMG.Arg.MgArrangeLog","DHCINM.Arg.MgArrangeLog")
	w !,"迁移排班记录结束"
}

/// Creator: lcy
/// CreateDate: 20200914
/// Description: 转移班次分类种类-系统参数设置
/// Table: DHCNMG.Set.MgSysParam,DHCNMG.Set.MgSysParamSub,CT.DHCINM.Set.MgSysParam,CT.DHCINM.Set.MgSysParamSub
/// Input:
/// Output:
/// Other:d ##class(web.INMMoveDataComm).TransPostType()
ClassMethod TransPostType()
{
	s oldId=""
	s oldId=$O(^DHCNMG.Set.MgSysParamI("Code"," POSTTYPE",oldId))
	s newId=""
	s newId=$O(^CT.DHCINM.Set.MgSysParamI("Code"," POSTTYPE",newId))
	s newObj=##class(CT.DHCINM.Set.MgSysParam).%OpenId(newId)
	s nnum=^DHCNMG.Set.MgSysParamD(12,"ChildSub"),n=1
	s oldSubId="" f  s oldSubId=$O(^DHCNMG.Set.MgSysParamSubD(oldId,oldSubId)) q:oldSubId=""  d
	.s oldSubObj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(oldId_"||"_oldSubId)
	.i n>nnum d
	..s newSubObj=##class(CT.DHCINM.Set.MgSysParamSub).%New()
	..s newSubObj.Parref=newObj
	.e  d
	..s newSubObj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(newId_"||"_n)
	.s newSubObj.SubCode=oldSubObj.SubCode
	.s newSubObj.SubColor=oldSubObj.SubColor
	.s newSubObj.SubDesc=oldSubObj.SubDesc
	.s newSubObj.SubEndDate=oldSubObj.SubEndDate
	.s newSubObj.SubRemark=oldSubObj.SubRemark
	.s newSubObj.SubSort=oldSubObj.SubSort
	.s newSubObj.SubStDate=oldSubObj.SubStDate
	.s newSubObj.SubSymbol=oldSubObj.SubSymbol
	.s newSubObj.SubValue=oldSubObj.SubValue
	.s sc=newSubObj.%Save()
	.s n=n+1
	.d $System.Status.DisplayError(sc)
}

/// Creator: lcy
/// CreateDate: 20200914
/// Description: 迁移全局班次数据
/// Table: 
/// Input:
/// Output:
/// Other:d ##class(web.INMMoveDataComm).TransPost()
ClassMethod TransPost()
{
	s oldId="" f  s oldId=$O(^DHCNMG.DB.MgArgPostD(oldId)) q:oldId=""  d
	.s oldObj=##class(DHCNMG.DB.MgArgPost).%OpenId(oldId)
	.q:'$IsObject(oldObj)
	.s newObj=##class(CF.DHCINM.DB.MgArgPost).%New()
	.s newObj.PostCode=oldObj.PostCode
	.s newObj.PostDesc=oldObj.PostDesc
	.s newObj.PostType=oldObj.PostType
	.s newObj.HolidayTime=oldObj.HolidayTime
	.s newObj.PostStTime1=oldObj.PostStTime1
	.s newObj.PostEndTime1=oldObj.PostEndTime1
	.s newObj.PostStTime2=oldObj.PostStTime2
	.s newObj.PostEndTime2=oldObj.PostEndTime2
	.s newObj.PostMinutes=oldObj.PostMinutes
	.s newObj.PostDayMinutes=oldObj.PostDayMinutes
	.s newObj.PostNextMinutes=oldObj.PostNextMinutes
	.s newObj.PostUseType=oldObj.PostUseType
	.s newObj.PostUseLimit=oldObj.PostUseLimit
	.s newObj.PostFontColor=oldObj.PostFontColor
	.s newObj.PostBgColor=oldObj.PostBgColor
	.s newObj.PostRemark=oldObj.PostRemark
	.s newObj.PostStatus=oldObj.PostStatus
	.s newObj.PostCrtDate=oldObj.PostCrtDate
	.s newObj.PostCrtTime=oldObj.PostCrtTime
	.s newObj.PostCrtUser=oldObj.PostCrtUser
	.s newObj.PostStTime3=oldObj.PostStTime3
	.s newObj.PostEndTime3=oldObj.PostEndTime3
	.s newObj.PostCategory=oldObj.PostCategory
	.s newObj.PostLevel=oldObj.PostLevel
	.s newObj.PostSort=oldObj.PostSort
	.s sc=newObj.%Save()
	.d $System.Status.DisplayError(sc)
}

/// creator: liwenzhen	
/// createdate: 2020-11-19
/// description: 迁移数据
/// table: 
/// input: 旧表表名：oldClassName 新表表名：newClassName
/// output:
/// other: w ##class(web.INMMoveDataComm).MoveData("DHCNMG.DB.MgArgPost","CF.DHCINM.DB.MgArgPost")
ClassMethod MoveData(oldClassName As %String, newClassName As %String) As %String
{
	s flag=1
	w "迁移"_oldClassName_"数据开始",!
	x ("(dataGlobal) m dataGlobal = ^"_oldClassName_"D",.dataGlobal)
	s oldId="" f  s oldId=$O(dataGlobal(oldId)) q:oldId=""  d
	.x ("(oldObj) s oldObj = ##class("_oldClassName_").%OpenId("""_oldId_""")",.oldObj)
	.q:'$IsObject(oldObj)
	.x ("(newObj) s newObj = ##class("_newClassName_").%New()",.newObj)
	.s p="" f  s p=$O(^oddCOM(oldClassName,"a",p)) q:p=""  d
	..q:p["%"
	..q:p="ChildSub"
	..q:$O(^oddCOM(newClassName,"a",p,""))=""
	..i oldClassName="DHCNMG.DB.MgArgWardPost" d
	...i p="PostDR" d
	....s oldPostDesc=$ZOBJPROPERTY(oldObj,p).PostCode
	....s newPost=$o(^CF.DHCINM.DB.MgArgPostI("Code"," "_oldPostDesc,""))
	....s $ZOBJPROPERTY(newObj,p)=##class(CF.DHCINM.DB.MgArgPost).%OpenId(newPost)
	...e  s $ZOBJPROPERTY(newObj,p)=$ZOBJPROPERTY(oldObj,p)
	..e  i ((oldClassName="DHCNMG.Arg.MgArrangeGroup")||(oldClassName="DHCNMG.Arg.MgArrangeLog")) d
	...i p="ArrangeDR" d
	....s oldArgListNo=$ZOBJPROPERTY(oldObj,p).ArgListNo
	....s newArrange=$o(^DHCINM.Arg.MgArrangeI("ListNo"," "_oldArgListNo,""))
	....s $ZOBJPROPERTY(newObj,p)=##class(DHCINM.Arg.MgArrange).%OpenId(newArrange)
	...e  s $ZOBJPROPERTY(newObj,p)=$ZOBJPROPERTY(oldObj,p)
	..e  i oldClassName="DHCNMG.Arg.MgArrangeRow" d
	...i p="ArrangeDR" d
	....s oldArgListNo=$ZOBJPROPERTY(oldObj,p).ArgListNo
	....s newArrange=$o(^DHCINM.Arg.MgArrangeI("ListNo"," "_oldArgListNo,""))
	....s $ZOBJPROPERTY(newObj,p)=##class(DHCINM.Arg.MgArrange).%OpenId(newArrange)
	...e  i p="ArgGroupDR" d
	....i $ZOBJPROPERTY(oldObj,p)'="" d
	.....s oldGrpCode=$ZOBJPROPERTY(oldObj,p).GroupCode
	.....s oldArgListNo=$ZOBJPROPERTY(oldObj,"ArrangeDR").ArgListNo
	.....s newArrange=$o(^DHCINM.Arg.MgArrangeI("ListNo"," "_oldArgListNo,""))
	.....s newGrp=$o(^DHCINM.Arg.MgArrangeGroupI("ArgCode",newArrange," "_oldGrpCode,""))
	.....s $ZOBJPROPERTY(newObj,p)=##class(DHCINM.Arg.MgArrangeGroup).%OpenId(newGrp)
	...e  s $ZOBJPROPERTY(newObj,p)=$ZOBJPROPERTY(oldObj,p)
	..e  i oldClassName="DHCNMG.Arg.MgArrangeSub" d
	...i p="ArrangeDR" d
	....s oldArgListNo=$ZOBJPROPERTY(oldObj,p).ArgListNo
	....s newArrange=$o(^DHCINM.Arg.MgArrangeI("ListNo"," "_oldArgListNo,""))
	....s $ZOBJPROPERTY(newObj,p)=##class(DHCINM.Arg.MgArrange).%OpenId(newArrange)
	...e  i p="ArgRowDR" d
	....i $ZOBJPROPERTY(oldObj,p)'="" d
	.....s oldArgListNo=$ZOBJPROPERTY(oldObj,p).ArrangeDR.ArgListNo
	.....s newArrange=$o(^DHCINM.Arg.MgArrangeI("ListNo"," "_oldArgListNo,""))
	.....s oldPer=$ZOBJPROPERTY(oldObj,p).ArgPerDR.%Id()
	.....s newRow=$o(^DHCINM.Arg.MgArrangeRowI("ArgPerson",newArrange,oldPer,""))
	.....s $ZOBJPROPERTY(newObj,p)=##class(DHCINM.Arg.MgArrangeRow).%OpenId(newRow)
	...e  i p="ArgPostDR" d
	....i $ZOBJPROPERTY(oldObj,p)'="" d
	.....s ward=$ZOBJPROPERTY(oldObj,p).WardDR.%Id()
	.....s oldPostDesc=$ZOBJPROPERTY(oldObj,p).PostDR.PostCode
	.....s newPost=$o(^CF.DHCINM.DB.MgArgPostI("Code"," "_oldPostDesc,""))
	.....s wardPost=$o(^CF.DHCINM.DB.MgArgWardPostI("WardPost",ward,newPost,""))
	.....s $ZOBJPROPERTY(newObj,p)=##class(CF.DHCINM.DB.MgArgWardPost).%OpenId(wardPost)
	...e  i p="ArgEditUser" d
	....s:$ZOBJPROPERTY(oldObj,p)'="" $ZOBJPROPERTY(newObj,p)=$ZOBJPROPERTY(oldObj,p).%Id()
	...e  s $ZOBJPROPERTY(newObj,p)=$ZOBJPROPERTY(oldObj,p)
	..e  s $ZOBJPROPERTY(newObj,p)=$ZOBJPROPERTY(oldObj,p)
	.s sc=newObj.%Save()
	.s index=$zcvt($p(newClassName,".",$L(newClassName,".")),"U") // MoveData表索引
	.s sc=..AddMoveData(index,newObj.%Id(),oldId)
	.i $$$ISERR(sc)  d
	..w oldClassName_" "_oldId_" 失败失败失败失败失败失败失败失败",!
	..s flag=0
	.;e  w oldId_" "_newObj.%Id(),!
	w "迁移"_oldClassName_"数据完成",!
	q flag
}

/// Creator: wangcc
/// CreateDate: 20200914
/// Description: 迁移调科数据
/// Table: 
/// Input:
/// Output:
/// Other:w ##class(web.INMMoveDataComm).MoveTransDepData()
ClassMethod MoveTransDepData()
{
	s sc=1
	s oldAppId="" f  s oldAppId=$O(^DHCNMG.HR.MgTransAppD(oldAppId)) q:oldAppId=""  d
	.s oldAppObj=##class(DHCNMG.HR.MgTransApp).%OpenId(oldAppId)
	.q:'$IsObject(oldAppObj)
	.q:oldAppObj.TransStatus="B"
	.s nurseid=oldAppObj.CreateUser
	.s date=oldAppObj.CreateDate
	.s status=$case(oldAppObj.TransStatus,"N":"N","Y":"N","A":"Y")
	.s Days="",enddate=""
	.s:oldAppObj.TransEndDate'="" Days=oldAppObj.TransEndDate-oldAppObj.TransDate,enddate=$zd(oldAppObj.TransEndDate,3)
	.s stdate=$zd(oldAppObj.TransDate,3)
	.f i=1:1:oldAppObj.TransNurse.Count() d
	..s item=oldAppObj.TransNurse.GetAt(i)
	..s ward=$p(item,"|")
	..s per=$p(item,"|",2)
	..s parr="@"_"NurseId|"_per_"^WardId|"_ward_"^TransStDate|"_stdate_"^TransEndDate|"_enddate_"^InWard|"_oldAppObj.TransInDep_"^TransDays|"_Days_"^TransType|Random"_"^TransNur|^TransReason|"_oldAppObj.TransReason
	..s sc=sc&&(..SaveTransNurse(parr,status,"",nurseid,date))
	q sc
}

/// Creator: wangcc
/// CreateDate: 20200914
/// Description: 迁移调科数据
/// Table: 
/// Input:
/// Output:
/// Other:d ##class(web.INMMoveDataComm).MoveFirstDep()
ClassMethod MoveFirstDep()
{
	s perdr="" f  s perdr=$O(^DHCNMG.HR.MgTransDepI("ssdr",perdr)) q:perdr=""  d
	.s oldId=$O(^DHCNMG.HR.MgTransDepI("ssdr",perdr,""))
	.s oldObj=##class(DHCNMG.HR.MgTransDep).%OpenId(oldId)
	.q:'$IsObject(oldObj)
	.s newObj=##class(CF.DHCINM.Trans.TransDep).%New()
	.s newObj.PerDepart=oldObj.PerDepart
	.s newObj.PerDr=oldObj.PerDr
	.s newObj.PerTranCurrent=oldObj.PerTranCurrent
	.s newObj.PerTranStDate=oldObj.PerTranStDate
	.s newObj.PerTranEndDate=oldObj.PerTranEndDate
	.d newObj.%Save()
}

/// creater:wangcc
/// date:2020-07-22
/// desc:保存或提交调配审核信息
/// w ##class(web.INMPersonComm).SaveTransNurse("「^NurseId|3^WardId|2^TransStDate|2021-01-27^TransEndDate|^InWard|3^TransDays|^TransType|Random^TransNur|^TransReason|","N","",0)
ClassMethod SaveTransNurse(parr, flag, app, nurseid, date)
{
	ts
	i app'=""  d
	.s transnurse="" f  s transnurse=$o(^DHCINM.Trans.MgTransNurseI("app"," "_app,transnurse))  q:transnurse=""  d
	..d ##class(DHCINM.Trans.MgTransNurse).%DeleteId(transnurse)
	s tmp1=""
	d ##class(web.INMVueComm).SplitStr($p(parr,"「",1),"^","|",.tmp1)
	s flag1=0
	if (flag="Y")&&(app'="")
	{
		s appObj=##class(DHCINM.Trans.MgTransApp).%OpenId(app)
		q:'$IsObject(appObj)
		s appObj.TransStatus=tmp1("Status")
		s sc=appObj.%Save()
		i '$$$ISOK(sc){
			tro
			q 0	
		}
		s checkId=$o(^DHCINM.Trans.MgTransCheckI("app"," "_app," "_tmp1("Status"),""))
		i checkId=""  s checkObj=##class(DHCINM.Trans.MgTransCheck).%New()
		e  s checkObj=##class(DHCINM.Trans.MgTransCheck).%OpenId(checkId)
		s checkObj.ActionId=nurseid
		s checkObj.AppId=app
		s checkObj.Date=+$h
		s checkObj.Time=$p($h,",",2)
		s checkObj.Status=tmp1("Status")
		s checkObj.Suggestion=tmp1("CheckSuggestion")
		s checkObj.IsCheck=flag
		s sc1=checkObj.%Save()
		if '$$$ISOK(sc1){
			tro
			q 0
		}
	}
	f i=2:1:$l(parr,"「") q:flag1=-1  d
	.k tmp
	.s tmp=""
	.d ##class(web.INMVueComm).SplitStr($p(parr,"「",i),"^","|",.tmp)
	.s detatilId=""
	.f  s detatilId=$o(^DHCINM.Trans.MgRotationDetailI("ssid"," "_tmp("NurseId"),detatilId)) q:(detatilId="")||(flag1=-1)  d
	..q:'$d(^DHCINM.Trans.MgRotationDetailD(detatilId))
	..s planId=$lg(^DHCINM.Trans.MgRotationDetailD(detatilId),2)
	..q:'$d(^DHCINM.Trans.MgRotationPlanD(planId))
	..s planStatus=$lg(^DHCINM.Trans.MgRotationPlanD(planId),5)
	..q:planStatus'="P"
	..s depId="" f  s depId=$o(^DHCINM.Trans.MgRotationDepI("detail",detatilId,depId)) q:(depId="")||(flag1=-1)  d
	...s depObj=##class(DHCINM.Trans.MgRotationDep).%OpenId(depId)
	...q:'$isObject(depObj)
	...q:depObj.Status["E"
	...q:(depObj.CycleDR.EndDate<$zdh(tmp("TransStDate"),3))
	...s depObj.Status="TR"
	...s depsc=depObj.%Save()
	...s:'$$$ISOK(depsc) flag1=-1
	...q:flag1=-1
	...s rotationHisObj=##class(DHCINM.Trans.MgRotationHistory).%New()
	...s rotationHisObj.DepDR=depObj
	...s rotationHisObj.Operate="TR"
	...s rotationHisObj.StopDate=+$h
	...s rotHisSc=rotationHisObj.%Save()
	...i '$$$ISOK(rotHisSc) s flag1=-1,i=$l(parr,"「")+1
	.q:flag1=-1
	.s:app'="" indep=$lg(^DHCINM.Trans.MgTransAppD(app),4)
	.s:app="" indep=tmp("InWard")
	.s type=##class(web.INMPersonComm).GetCommCode($lg(^CF.DHCINM.HR.PersonsD(tmp("NurseId")),76))
	.s:tmp("TransEndDate")'="" currentward=##class(web.INMHRComm).GetCurrentWard(tmp("NurseId"),$zdh(tmp("TransEndDate"),3))
	.s:tmp("TransEndDate")="" currentward=tmp("WardId")
	.s nurObj=##class(DHCINM.Trans.MgTransNurse).%New()
	.i (tmp("TransNur")'="")&&(app="")  s nurObj=##class(DHCINM.Trans.MgTransNurse).%OpenId(tmp("TransNur"))
	.s nurObj.ActionPer=nurseid
	.s nurObj.AppId=app
	.s nurObj.InWard=indep
	.s nurObj.NurseId=tmp("NurseId")
	.s nurObj.NurseStatus=flag
	.s nurObj.OutWard=currentward
	.s nurObj.TransDays=tmp("TransDays")
	.s nurObj.TransStDate=$zdh(tmp("TransStDate"),3)
	.s nurObj.CreateDate=date
	.s:(tmp("TransEndDate"))'="" nurObj.TransEndDate=$zdh(tmp("TransEndDate"),3)
	.s nurObj.TransReason=$g(tmp("TransReason"))
	.s nurObj.TransType=tmp("TransType")
	.s sc2=nurObj.%Save()
	.s:'$$$ISOK(sc2) flag1=-1
	.q:flag1=-1
	.if ((($g(tmp1("Status"))="A")||($p(parr,"「",1)=""))&&(flag="Y"))  d
	..s sc4=0
	..i type="轮转" d
	...s sc4=##class(web.INMPersonComm).SaveRotationDepInTrans($zdh(tmp("TransStDate"),3),$zdh(tmp("TransEndDate"),3),tmp("NurseId"))
	...s:sc4=0 flag1=-1
	..i flag1'=-1 d
	...s sc3=##class(web.INMPersonComm).SaveTransDep($p(parr,"「",i),nurObj.%Id(),app,"","")
	...s:sc3=0 flag1=-1
	.q:flag1=-1
	i flag1=-1 tro
	q:flag1=-1 0
	tc
	q 1
}

/// Creator: wangcc
/// CreateDate: 20200914
/// Description: 迁移调科数据
/// Table: 
/// Input:
/// Output:
/// Other:w ##class(web.INMMoveDataComm).MoveResignData()
ClassMethod MoveResignData()
{
	w !,"迁移离职数据开始"
	s id="" f  s id=$O(^DHCNMG.HR.MgNurseResignD(id)) q:id=""  d
	.s oldObj=##class(DHCNMG.HR.MgNurseResign).%OpenId(id)
	.q:'$IsObject(oldObj)
	.q:'$IsObject(oldObj.ResignName)
	.s newObj=##class(DHCINM.HR.MgNurseResign).%New()
	.d newObj.ResignNameSetObjectId(..GetMoveData("PERSON",oldObj.ResignName.%Id()))
	.s newObj.ResignType=oldObj.ResignType
	.s newObj.ResignDate=oldObj.ResignDate
	.s reasonFlag="~"
	.s:oldObj.ResignReason["," reasonFlag=","
	.s newReason=""
	.f i=1:1:$L(oldObj.ResignReason,reasonFlag) d
	..s reason=$P(oldObj.ResignReason,reasonFlag,i)
	..q:reason=""
	..s reasonNew=..GetMoveData("CODE",reason)
	..i newReason="" s newReason=reasonNew
	..e  s newReason=newReason_reasonFlag_reasonNew
	.s newObj.ResignReason=newReason
	.s ResignCreater=""
	.i oldObj.ResignCreater=0 s ResignCreater=0
	.e  s ResignCreater=..GetMoveData("PERSON",oldObj.ResignCreater)
	.s newObj.ResignCreater=ResignCreater
	.s newObj.CreateDate=oldObj.CreateDate
	.s UpdateUser=""
	.s UpdateUser=""
	.i oldObj.UpdateUser=0 s UpdateUser=0
	.e  s UpdateUser=..GetMoveData("PERSON",oldObj.UpdateUser)
	.s newObj.UpdateUser=UpdateUser
	.s newObj.ResignUpdate=oldObj.ResignUpdate
	.s newObj.ResignStatus=oldObj.ResignStatus
	.s newObj.ResignWard=..GetMoveData("WARD",oldObj.ResignWard)
	.s newObj.ResignOpinion=oldObj.ResignOpinion
	.s ResignOther=oldObj.ResignOther
	.s:ResignOther="undefined" ResignOther=""
	.s newObj.ResignOther=ResignOther
	.s newObj.ResignDuty=..GetMoveData("CODE",oldObj.ResignDuty)
	.s newObj.ResignAcademic=..GetMoveData("CODE",oldObj.ResignAcademic)
	.s newObj.ResignReStatus=oldObj.ResignReStatus
	.s sc=$$$ISOK(newObj.%Save())
	.w:'sc "离职"_oldObj.%Id()_"失败"
	w !,"迁移离职数据完成"
	q ""
}

}
