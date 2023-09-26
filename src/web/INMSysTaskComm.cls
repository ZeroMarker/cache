/// Creator：gzj
/// Date：2017-08-30
/// Description：Vue版护管任务
Class web.INMSysTaskComm Extends %RegisteredObject
{

/// Creator: gzj
/// CreatDate: 2017-08-30
/// Description: 护士调科任务
/// Table：CF.DHCINM.Trans.TransDep
/// Input：
/// Return：w ##class(web.INMSysTaskComm).ExcuteTransDep()
ClassMethod ExcuteTransDep()
{
	s per="" f  s per=$O(^CF.DHCINM.Trans.TransDepI("Current"," P",per)) q:per=""  d
	.s rowid="" f  s rowid=$O(^CF.DHCINM.Trans.TransDepI("Current"," P",per,rowid)) q:rowid=""  d
	..s obj=##class(CF.DHCINM.Trans.TransDep).%OpenId(rowid)
	..s CurrDate=+$H
	..q:(obj.PerTranStDate>CurrDate)
	..s CStatusRow=$O(^CF.DHCINM.Trans.TransDepI("Current"," Y",per,""))
	..i CStatusRow'="" d
	...s CObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(CStatusRow)
	...s CObj.PerTranEndDate=obj.PerTranStDate
	...s CObj.PerTranCurrent="N"
	...d CObj.%Save()
	..s obj.PerTranCurrent="Y"
	..d ..ChangePerDepInfo(per,obj.PerDepart,obj.PerTranStDate)
	..d obj.%Save()
	q 0
}

ClassMethod ChangePerDepInfo(per, dep, stdate) As %String
{
	s perobj=##class(CF.DHCINM.HR.Persons).%OpenId($tr(per," ",""))
	s perobj.PerDepDR=dep
	s perobj.PerDepDate=stdate
	i dep'="" d
	.s locDR=$O(^CF.DHCINM.DB.MgWardLocUnitI("Ward",dep,""))
	.s perobj.PerLocDR=locDR
	d perobj.%Save()
	q perobj.%Id()
}

ClassMethod Test() As %String
{
	s TodayDate=+$H+1
	s approw="" f  s approw=$O(^DHCINM.Trans.MgTransAppI("date"," T",TodayDate,approw)) q:approw=""  d
	.s appObj=##class(DHCINM.Trans.MgTransApp).%OpenId(approw)
	.q:appObj.TransStatus'="A"
	.i appObj.TransType'="" d
	..s typeObj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId($tr(appObj.TransType,"__","||"))
	..q:'$IsObject(typeObj)
	..s TransType=typeObj.SubDesc
	.q:TransType'="用人申请"
	.s Nurses=appObj.TransNurse
	.s len=appObj.TransNurse.Count()
	.f k=1:1:len d
	..s itm=appObj.TransNurse.GetAt(k)
	..i itm'="" d
	...s nursedep=$p(itm,"|",1)
	...s nurse=$p(itm,"|",2)
	...b ;01
	...s appenddate=appObj.TransEndDate
	...s parr="^"_nurse_"^"_nursedep_"^"_appenddate_"^^Y^^^L"
	...d ##class(web.INMPersonComm).SaveTransData(parr)
	...d ..ChangePerDepInfo(nurse,nursedep,appenddate)
	q 0
}

/// 每月最后一天保存人员数据 系统任务
/// 系统任务
ClassMethod SavePersonData() As %String
{
	s flag=0
	s row="" f  s row=$O(^CF.DHCINM.HR.PersonsD(row)) q:row=""  d
	.s obj=##class(CF.DHCINM.HR.Persons).%OpenId(row)
	.s RowID=$O(^DHCINM.HR.MgPersonDataI("date",$H,row,""))
	.i RowID="" d
	..s HObj=##class(DHCINM.HR.MgPersonData).%New()
	..s HObj.CreateDate=+$H
	..s HObj.PerName=obj.PerName ///姓名
	..s HObj.PerID=obj.PerID ///工号
	..s HObj.PerNo=obj.PerNo ///编号（实习生编号）
	..s HObj.PerUserDR=obj.PerUserDR
	..s HObj.PerBirthday=obj.PerBirthday ///出生日期
	..s HObj.PerCardId=obj.PerCardId ///身份证号码
	..s HObj.PerCareType=obj.PerCareType ///医护类型(医生(D)、护士(N))
	..s HObj.PerSexDR=obj.PerSexDR  ///性别
	..s HObj.PerDepDR=obj.PerDepDR ///当前病区
  	..s HObj.PerDepDate=obj.PerDepDate ///进入病区日期
  	..s HObj.PerComeDate=obj.PerComeDate ///来院日期
  	..s HObj.PerYear=obj.PerYear ///护士年届
	..s HObj.PerWorkDate=obj.PerWorkDate ///参加工作日期
	..s HObj.PerRegNo=obj.PerRegNo ///注册证书号
	..s HObj.PerMarriage=obj.PerMarriage ///婚姻
	..s HObj.PerNativePlace=obj.PerNativePlace ///籍贯
	..s HObj.PerSource=obj.PerSource ///职工性质
	..s HObj.PerAddress=obj.PerAddress ///现住址
	..s HObj.PerPolitical=obj.PerPolitical ///政治面貌
	..s HObj.PerNation=obj.PerNation ///民族
	..s HObj.PerClothesNo=obj.PerClothesNo ///上衣号
 	..s HObj.PerTrouserNo=obj.PerTrouserNo ///裤号
 	..s HObj.PerShoesNo=obj.PerShoesNo ///鞋号
 	..s HObj.PerTypeDR=obj.PerTypeDR ///人员类型（正式（N）、进修（S）、实习（P）、护理员（W） 管理员（M））
 	..s HObj.PerTransFlag=obj.PerTransFlag ///是否轮转护士
 	..s HObj.PerWordType=obj.PerWordType ///工作科室
 	..s HObj.PerNurType=obj.PerNurType ///护士种类
 	..s HObj.PerContact=obj.PerContact ///家庭联系人
 	..s HObj.PerPhone=obj.PerPhone ///联系方式（手机号）
 	..s HObj.PerHeight=obj.PerHeight ///身高
 	..s HObj.PerRetireDate=obj.PerRetireDate ///扩展字段{日期}
 	..s HObj.PerResignDate=obj.PerResignDate ///扩展字段{日期}
 	..s HObj.PerPic=obj.PerPic ///照片
 	..s HObj.PerAuditFlag=obj.PerAuditFlag ///审核状态（Y、N）
 	..s HObj.PerAuditor=obj.PerAuditor ///审核人
 	..s HObj.PerAuditDate=obj.PerAuditDate ///审核日期
 	..s HObj.RecUser=obj.RecUser ///添加人
 	..s HObj.RecDate=obj.RecDate ///更新日期
 	..s HObj.RecTime=obj.RecTime ///更新时间
 	..s HObj.PerHosShortNo=obj.PerHosShortNo ///院内短号
 	..s HObj.PerStatus=obj.PerStatus ///在院状态 在职 离职 退休
 	..s HObj.PerStateDate=obj.PerStateDate ///状态日期
 	..s HObj.PerStatuReason=obj.PerStatuReason ///状态原因
 	..s HObj.PerCadreDate=obj.PerCadreDate ///提干日期
 	..s HObj.PerPolitDate=obj.PerPolitDate ///党团日期
 	..s HObj.PerHomeAddress=obj.PerHomeAddress ///家庭地址
 	..s HObj.PerHouseAddress=obj.PerHouseAddress ///户口所在地
 	..s HObj.PerLocDR=obj.PerLocDR ///科室
 	..s HObj.PerPassword=obj.PerPassword ///用户密码
 	..s HObj.HISNO=obj.HISNO ///HIS工号
 	..s HObj.ImportDate=obj.ImportDate ///导入日期
 	..s HObj.ImportUser=obj.ImportUser ///导入人
 	..s HObj.PostTitle=obj.PostTitle ///岗位名称
 	..s HObj.PrepareDate=obj.PrepareDate ///纳编日期
 	..s HObj.PerTrialWork=obj.PerTrialWork ///试工
 	..s HObj.PerTrialDate=obj.PerTrialDate ///试工期至
 	..s HObj.PerTrialQual=obj.PerTrialQual ///试工合格
 	..s HObj.PerLRetireDate=obj.PerLRetireDate ///应退休日期
 	..s HObj.PerForeignLevel=obj.PerForeignLevel ///英语级别
 	..s HObj.PerIsEspecially=obj.PerIsEspecially ///有无特长
 	..s HObj.PerEspecially=obj.PerEspecially ///特长
 	..s HObj.PerRegRegiDate=obj.PerRegRegiDate ///执业证书注册日期
 	..s HObj.PerRegValidDate=obj.PerRegValidDate ///执业证书有效期
 	..s HObj.PerNurseLevel=obj.PerNurseLevel ///护士分级
 	..s HObj.PerIsSpeciNurse=obj.PerIsSpeciNurse ///是否专科护士
 	..s HObj.PerSpeciNurse=obj.PerSpeciNurse ///专科护士
 	..s HObj.PerSeciNurseDate=obj.PerSeciNurseDate ///取得专科日期
 	..s HObj.PerIsRegiste=obj.PerIsRegiste ///有无执业证书
 	..s HObj.PerQualCerifite=obj.PerQualCerifite /// 资格证书
 	..s HObj.PerInitialAcade=obj.PerInitialAcade /// 最初学历
 	..s HObj.PerInitialSchool=obj.PerInitialSchool ///最初学历毕业院校
 	..s HObj.PerCurrentAcade=obj.PerCurrentAcade ///当前学历
 	..s HObj.PerCurrentSchool=obj.PerCurrentSchool ///当前学历毕业院校
 	..s HObj.PerSocietyPart=obj.PerSocietyPart /// 社会兼职
 	..s HObj.PerNurseHire=obj.PerNurseHire ///人员聘用
 	..s HObj.PerInNursePost=obj.PerInNursePost /// 在护理岗
 	..s HObj.PerPostName=obj.PerPostName /// 岗位名称
 	..s HObj.PerAttriDepart=obj.PerAttriDepart /// 归属部门
 	..s HObj.PerCategroy=obj.PerCategroy /// 应往届【实习生的应往届】
 	..s HObj.AuditReason=obj.AuditReason /// 审核意见
 	..s HObj.AuditTime=obj.AuditTime /// 审核时间
 	..s edudate=$O(^CF.DHCINM.HR.EducateI("flag",row,""),-1)
 	..i edudate'="" d
 	...s edurow=$o(^CF.DHCINM.HR.EducateI("flag",row,edudate,""))
 	...i edurow'="" d
 	....s eduobj=##class(CF.DHCINM.HR.Educate).%OpenId(edurow)
 	....q:'$IsObject(eduobj)
 	....s HObj.PerAcademic=eduobj.EduAcademic /// 学历
 	....s HObj.PerDegree=eduobj.EduDegree /// 学位
 	..s dutydate=$o(^CF.DHCINM.HR.HireDutyI("HireDate",row,""),-1)
 	..i dutydate'="" d
 	...s dutyrow=$o(^CF.DHCINM.HR.HireDutyI("HireDate",row,dutydate,""))
 	...i dutyrow'="" d
 	....s dutyobj=##class(CF.DHCINM.HR.HireDuty).%OpenId(dutyrow)
 	....q:'$IsObject(dutyobj)
 	....s HObj.PerHireDuty=dutyobj.HireDuty /// 职称
 	..s levelrow=$O(^CF.DHCINM.HR.MgLevelI("ssid",row,""),-1)
 	..i levelrow'="" d
 	...s levelobj=##class(CF.DHCINM.HR.MgLevel).%OpenId(levelrow)
 	...q:'$IsObject(levelobj)
 	...s HObj.PerLevel=levelobj.NurLevel /// 层级
 	..s postdate=$O(^CF.DHCINM.HR.PostDutyI("PostDate",row,""))
 	..i postdate'="" d
 	...s postrow=$O(^CF.DHCINM.HR.PostDutyI("PostDate",row,postdate,""),-1)
 	...i postrow'="" d
 	....s postobj=##class(CF.DHCINM.HR.PostDuty).%OpenId(postrow)
 	....q:'$IsObject(postobj)
 	....s HObj.PerPostDuty=postobj.PostDuty
 	..s HObj.PerRowID=##class(CF.DHCINM.HR.Persons).%OpenId(row)
 	..s sc=HObj.%Save()
 	..s flag=$$$ISOK(sc)
 	q flag
}

/// Creator:lulin
/// Description:任务保存去年质控平均分
/// Date:2018-07-25
/// Table:CT.DHCINM.DB.MgQualItem，DHCINM.CHK.MgCheckRoom
/// Input:
/// Output：
/// Return:
/// Others: d ##class(web.INMSysTaskComm).saveQualAvgLastYear()
ClassMethod saveQualAvgLastYear() As %String
{
	
	s year=$p($zd(+$h,3),"-")
	s last=year-1
	;s last=year
	s sc=1
	i $p($zd(+$h,3),"-",2,3)="01-01"
	{
		s qualid="" f  s qualid=$O(^CT.DHCINM.DB.MgQualItemD(qualid)) q:qualid=""  d
		.s qualObj=##class(CT.DHCINM.DB.MgQualItem).%OpenId(qualid)
		.q:'$IsObject(qualObj)
		.s score=0,num=0
		.f i=1:1:12 d
		..s date=last_"-"_i_"-01"
		..s:i<10 date=last_"-0"_i_"-01"
		..s date=$zdh(date,3)
		..s wardDR="" f  s wardDR=$O(^DHCINM.CHK.MgCheckRoomI("date",1," "_qualid,date,wardDR)) q:wardDR=""  d
		...s monthScore=0,monthNum=0,monthflag=0
		...s id="" f  s id=$O(^DHCINM.CHK.MgCheckRoomI("date",1," "_qualid,date,wardDR,id)) q:id=""  d
		....s obj=##class(DHCINM.CHK.MgCheckRoom).%OpenId(id)
		....q:'$IsObject(obj)
		....q:obj.Status'="S"
		....s monthScore=monthScore+obj.CheckScore,monthNum=monthNum+1,monthflag=1
		...s:monthflag=1 score=score+(monthScore/monthNum),num=num+1
		.s avg=""
		.s:num'=0 avg=score/num
		.q:avg=""
		.s avg=$FNUMBER(avg,"",2)
		.;s:avg'="" qualObj.QualAvg=avg
		.s id=$O(^CT.DHCINM.DB.MgQualItemAvgI("QualItem",qualid,last,""))
		.i id="" d
		..s avgObj=##class(CT.DHCINM.DB.MgQualItemAvg).%New()
		..s avgObj.QualDR=qualObj
		..s avgObj.QualAvgYear=last
		.e  s avgObj=##class(CT.DHCINM.DB.MgQualItemAvg).%OpenId(id)
		.s avgObj.QualAvgScore=avg
		.s sc=avgObj.%Save()
	}
	q sc
}

/// 获取维护的对应医嘱项
ClassMethod GetClinicOrderItems() As %String
{
}

/// 获取维护的对应的用法
ClassMethod GetClinicInstrucs() As %String
{
}

/// 检查护理单元是否存在
ClassMethod HasNurseUnit(ctLocId As %String) As %String
{
}

ClassMethod GetHGWard(ctLocId As %String) As %String
{
	q:ctLocId="" ""
	s locObj=##class(User.CTLoc).%OpenId(ctLocId)
	q:'$IsObject(locObj) ""
	s locCode=locObj.CTLOCCode
	s departId=$o(^CTLOC(0,"Code","H"_locCode,""))
	q:departId="" ""
	s WardID=$O(^CF.DHCINM.DB.MgWardI("CTLoc",departId,""))
	q WardID
}

ClassMethod IsExistWard(ctLocId As %String) As %String
{
	q:ctLocId="" 0
	s flag=0
	;s locObj=##class(User.CTLoc).%OpenId(ctLocId)
	;q:'$IsObject(locObj) 0
	s locCode=$p($g(^CTLOC(ctLocId)),"^",1)
	;s locCode=locObj.CTLOCCode
	q:+locCode=0 0
	s departId=$o(^CTLOC(0,"Code","H"_locCode,""))
	q:departId="" 0
	;b ;013
	s RowID="" f  s RowID=$O(^CF.DHCINM.DB.MgWardD(RowID)) q:((RowID="")||(flag=1))  d
	.s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(RowID)
	.q:'$IsObject(obj.CTLocDR)
	.i (obj.CTLocDR.%Id()=departId) s flag=1
	;b ;012
	q flag
}

/// Creator:gzj
/// Date:2018-08-14
/// Description:按病区按日期生成病区的日报数据
/// 
ClassMethod GenerateClinicDayData() As %String
{
	s day=+$h-1
	;s day=$zdh("2018-08-01",3)
	f date=day:1:day
	{
		s orderParref="" f  s orderParref=$o(^OEORDi(0,"ItemDate",date,orderParref)) q:orderParref=""  d
		.s orderId="" f  s orderId=$o(^OEORDi(0,"ItemDate",date,orderParref,orderId)) q:orderId=""  d
		..s ordState=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",13)
		..s stateCode=$p($g(^OEC("OSTAT",ordState)),"^",1)
		..q:"VED"'[stateCode
		..s ward=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",3) //ctlocid下医嘱科室
		..q:ward=""
		..s itmMastDr=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",2) //获取医嘱项
		..s instrDr=$p($g(^OEORD(orderParref,"I",orderId,2)),"^",7) //获取用法
		..i $g(tmp(ward,"病危"))="" s tmp(ward,"病危")=0
		..e  d
		...s tmp(ward,"病危")=..GetItmCount(..GetClinicItemMast(1,"病危"),itmMastDr,tmp(ward,"病危"))
		...s tmp(ward,"病危")=..GetItmCount(..GetClinicInstruc(1,"病危"),instrDr,tmp(ward,"病危"))
		..i $g(tmp(ward,"病重"))="" s tmp(ward,"病重")=0
		..e  d
		...s tmp(ward,"病重")=..GetItmCount(..GetClinicItemMast(1,"病重"),itmMastDr,tmp(ward,"病重"))
		...s tmp(ward,"病重")=..GetItmCount(..GetClinicInstruc(1,"病重"),instrDr,tmp(ward,"病重"))
		..i $g(tmp(ward,"一级护理"))="" s tmp(ward,"一级护理")=0
		..e  d
		...s tmp(ward,"一级护理")=..GetItmCount(..GetClinicItemMast(1,"一级护理"),itmMastDr,tmp(ward,"一级护理"))
		...s tmp(ward,"一级护理")=..GetItmCount(..GetClinicInstruc(1,"一级护理"),instrDr,tmp(ward,"一级护理"))
		..i $g(tmp(ward,"二级护理"))="" s tmp(ward,"二级护理")=0
		..e  d
		...s tmp(ward,"二级护理")=..GetItmCount(..GetClinicItemMast(1,"二级护理"),itmMastDr,tmp(ward,"二级护理"))
		...s tmp(ward,"二级护理")=..GetItmCount(..GetClinicInstruc(1,"二级护理"),instrDr,tmp(ward,"二级护理"))
		..i $g(tmp(ward,"手术"))="" s tmp(ward,"手术")=0
		..e  s tmp(ward,"手术")=..GetOprationsCounts($zd(date,3),$zd(date,3),ward)
		..i $g(tmp(ward,"科室手术"))="" s tmp(ward,"科室手术")=0
		..e  d
		...s tmp(ward,"科室手术")=..GetLocOperateNum(orderParref,orderId,..GetClinicItemMast(1,"科室手术"),itmMastDr,tmp(ward,"科室手术"))
		..i $g(tmp(ward,"压疮护理"))="" s tmp(ward,"压疮护理")=0
		..e  d
		...s tmp(ward,"压疮护理")=..GetItmCount(..GetClinicItemMast(2,"压疮护理"),itmMastDr,tmp(ward,"压疮护理"))
		...s tmp(ward,"压疮护理")=..GetItmCount(..GetClinicInstruc(2,"压疮护理"),instrDr,tmp(ward,"压疮护理"))
		..i $g(tmp(ward,"换药"))="" s tmp(ward,"换药")=0
		..e  d
		...s tmp(ward,"换药")=..GetItmCount(..GetClinicItemMast(2,"换药"),itmMastDr,tmp(ward,"换药"))
		...s tmp(ward,"换药")=..GetItmCount(..GetClinicInstruc(2,"换药"),instrDr,tmp(ward,"换药"))
		..i $g(tmp(ward,"换引流瓶（袋）"))="" s tmp(ward,"换引流瓶（袋）")=0
		..e  d
		...s tmp(ward,"换引流瓶（袋）")=..GetItmCount(..GetClinicItemMast(2,"换引流瓶（袋）"),itmMastDr,tmp(ward,"换引流瓶（袋）"))
		...s tmp(ward,"换引流瓶（袋）")=..GetItmCount(..GetClinicInstruc(2,"换引流瓶（袋）"),instrDr,tmp(ward,"换引流瓶（袋）"))
		..i $g(tmp(ward,"口腔护理"))="" s tmp(ward,"口腔护理")=0
		..e  d
		...s tmp(ward,"口腔护理")=..GetItmCount(..GetClinicItemMast(2,"口腔护理"),itmMastDr,tmp(ward,"口腔护理"))
		...s tmp(ward,"口腔护理")=..GetItmCount(..GetClinicInstruc(2,"口腔护理"),instrDr,tmp(ward,"口腔护理"))
		..i $g(tmp(ward,"雾化吸入"))="" s tmp(ward,"雾化吸入")=0
		..e  d
		...s tmp(ward,"雾化吸入")=..GetItmCount(..GetClinicItemMast(2,"雾化吸入"),itmMastDr,tmp(ward,"雾化吸入"))
		...s tmp(ward,"雾化吸入")=..GetItmCount(..GetClinicInstruc(2,"雾化吸入"),instrDr,tmp(ward,"雾化吸入"))
		..i $g(tmp(ward,"床边洗头"))="" s tmp(ward,"床边洗头")=0
		..e  d
		...s tmp(ward,"床边洗头")=..GetItmCount(..GetClinicItemMast(2,"床边洗头"),itmMastDr,tmp(ward,"床边洗头"))
		...s tmp(ward,"床边洗头")=..GetItmCount(..GetClinicInstruc(2,"床边洗头"),instrDr,tmp(ward,"床边洗头"))
		..i $g(tmp(ward,"床上浴"))="" s tmp(ward,"床上浴")=0
		..e  d
		...s tmp(ward,"床上浴")=..GetItmCount(..GetClinicItemMast(2,"床上浴"),itmMastDr,tmp(ward,"床上浴"))
		...s tmp(ward,"床上浴")=..GetItmCount(..GetClinicInstruc(2,"床上浴"),instrDr,tmp(ward,"床上浴"))
		..i $g(tmp(ward,"剪指（趾）甲"))="" s tmp(ward,"剪指（趾）甲")=0
		..e  d
		...s tmp(ward,"剪指（趾）甲")=..GetItmCount(..GetClinicItemMast(2,"剪指（趾）甲"),itmMastDr,tmp(ward,"剪指（趾）甲"))
		...s tmp(ward,"剪指（趾）甲")=..GetItmCount(..GetClinicInstruc(2,"剪指（趾）甲"),instrDr,tmp(ward,"剪指（趾）甲"))
		..i $g(tmp(ward,"导尿"))="" s tmp(ward,"导尿")=0
		..e  d
		...s tmp(ward,"导尿")=..GetItmCount(..GetClinicItemMast(2,"导尿"),itmMastDr,tmp(ward,"导尿"))
		...s tmp(ward,"导尿")=..GetItmCount(..GetClinicInstruc(2,"导尿"),instrDr,tmp(ward,"导尿"))
		..i $g(tmp(ward,"会阴擦洗（冲洗）"))="" s tmp(ward,"会阴擦洗（冲洗）")=0
		..e  d
		...s tmp(ward,"会阴擦洗（冲洗）")=..GetItmCount(..GetClinicItemMast(2,"会阴擦洗（冲洗）"),itmMastDr,tmp(ward,"会阴擦洗（冲洗）"))
		...s tmp(ward,"会阴擦洗（冲洗）")=..GetItmCount(..GetClinicInstruc(2,"会阴擦洗（冲洗）"),instrDr,tmp(ward,"会阴擦洗（冲洗）"))
		..i $g(tmp(ward,"膀胱冲洗"))="" s tmp(ward,"膀胱冲洗")=0
		..e  d
		...s tmp(ward,"膀胱冲洗")=..GetItmCount(..GetClinicItemMast(2,"膀胱冲洗"),itmMastDr,tmp(ward,"膀胱冲洗"))
		...s tmp(ward,"膀胱冲洗")=..GetItmCount(..GetClinicInstruc(2,"膀胱冲洗"),instrDr,tmp(ward,"膀胱冲洗"))
		..i $g(tmp(ward,"灌肠"))="" s tmp(ward,"灌肠")=0
		..e  d
		...s tmp(ward,"灌肠")=..GetItmCount(..GetClinicItemMast(2,"灌肠"),itmMastDr,tmp(ward,"灌肠"))
		...s tmp(ward,"灌肠")=..GetItmCount(..GetClinicInstruc(2,"灌肠"),instrDr,tmp(ward,"灌肠"))
		..i $g(tmp(ward,"各种注射"))="" s tmp(ward,"各种注射")=0
		..e  d
		...s tmp(ward,"各种注射")=..GetItmCount(..GetClinicItemMast(2,"各种注射"),itmMastDr,tmp(ward,"各种注射"))
		...s tmp(ward,"各种注射")=..GetItmCount(..GetClinicInstruc(2,"各种注射"),instrDr,tmp(ward,"各种注射"))
		..i $g(tmp(ward,"静脉抽血"))="" s tmp(ward,"静脉抽血")=0
		..e  d
		...s tmp(ward,"静脉抽血")=..GetItmCount(..GetClinicItemMast(2,"静脉抽血"),itmMastDr,tmp(ward,"静脉抽血"))
		...s tmp(ward,"静脉抽血")=..GetItmCount(..GetClinicInstruc(2,"静脉抽血"),instrDr,tmp(ward,"静脉抽血"))
		..i $g(tmp(ward,"动脉抽血"))="" s tmp(ward,"动脉抽血")=0
		..e  d
		...s tmp(ward,"动脉抽血")=..GetItmCount(..GetClinicItemMast(2,"动脉抽血"),itmMastDr,tmp(ward,"动脉抽血"))
		...s tmp(ward,"动脉抽血")=..GetItmCount(..GetClinicInstruc(2,"动脉抽血"),instrDr,tmp(ward,"动脉抽血"))
		..i $g(tmp(ward,"测微量血糖"))="" s tmp(ward,"测微量血糖")=0
		..e  d
		...s tmp(ward,"测微量血糖")=..GetItmCount(..GetClinicItemMast(2,"测微量血糖"),itmMastDr,tmp(ward,"测微量血糖"))
		...s tmp(ward,"测微量血糖")=..GetItmCount(..GetClinicInstruc(2,"测微量血糖"),instrDr,tmp(ward,"测微量血糖"))
		..;i (($g(tmp(ward,"二级护理"))'="")&&($g(tmp(ward,"二级护理"))>0)) b ;02
	}
	s wardid="" f  s wardid=$o(tmp(wardid)) q:wardid=""  d
	.s ctLocCode=$p($g(^CTLOC(wardid)),"^",1)
	.q:+ctLocCode=0
	.s locCode="H"_ctLocCode
	.s departId=$o(^CTLOC(0,"Code",locCode,""))
	.q:departId=""
	.s WardID=$O(^CF.DHCINM.DB.MgWardI("CTLoc",departId,""))
	.q:WardID=""
	.s desc="" f  s desc=$o(tmp(wardid,desc)) q:desc=""  d
	..s Rw=$o(^DHCINM.Arg.MgClinicDayWorkI("date",day," "_WardID,""))
	..i Rw="" s WorkObj=##class(DHCINM.Arg.MgClinicDayWork).%New()
	..e  s WorkObj=##class(DHCINM.Arg.MgClinicDayWork).%OpenId(Rw)
	..s WorkObj.ClinicWard=WardID
	..s WorkObj.ClinicDate=day
	..i desc="病危" s WorkObj.ClinicCriticaly=tmp(wardid,desc)
	..i desc="病重" s WorkObj.ClinicSick=tmp(wardid,desc)
	..i desc="一级护理" s WorkObj.ClinicFirstCare=tmp(wardid,desc)
	..i desc="二级护理" s WorkObj.ClinicSecondCare=tmp(wardid,desc)
	..i desc="手术" s WorkObj.ClinicSurgery=tmp(wardid,desc)
	..i desc="科室手术" s WorkObj.ClinicInSurgery=tmp(wardid,desc)
	..i desc="压疮护理" s WorkObj.ClinicPressCare=tmp(wardid,desc)
	..i desc="换药" s WorkObj.ClinicDresse=tmp(wardid,desc)
	..i desc="换引流瓶（袋）" s WorkObj.ClinicDrainage=tmp(wardid,desc)
	..i desc="口腔护理" s WorkObj.ClinicOralCare=tmp(wardid,desc)
	..i desc="雾化吸入" s WorkObj.ClinicInhalation=tmp(wardid,desc)
	..i desc="床边洗头" s WorkObj.ClinicShampoo=tmp(wardid,desc)
	..i desc="床上浴" s WorkObj.ClinicBedBath=tmp(wardid,desc)
	..i desc="剪指（趾）甲" s WorkObj.ClinicCutNail=tmp(wardid,desc)
	..i desc="导尿" s WorkObj.ClinicCatherize=tmp(wardid,desc)
	..i desc="会阴擦洗（冲洗）" s WorkObj.ClinicScrub=tmp(wardid,desc)
	..i desc="膀胱冲洗" s WorkObj.ClinicBladderClean=tmp(wardid,desc)
	..i desc="灌肠" s WorkObj.ClinicClyster=tmp(wardid,desc)
	..i desc="各种注射" s WorkObj.ClinicInjection=tmp(wardid,desc)
	..i desc="静脉抽血" s WorkObj.ClinicVenousBlood=tmp(wardid,desc)
	..i desc="动脉抽血" s WorkObj.ClinicArterialBlood=tmp(wardid,desc)
	..i desc="测微量血糖" s WorkObj.ClinicBloodSugar=tmp(wardid,desc)
	..s sc=WorkObj.%Save()
	q 0
}

/// Creator:gzj
/// Date:2018-08-14
/// Description: 获取关联的医嘱项
ClassMethod GetClinicItemMast(par As %String, desc As %String) As %String
{
	s ret=""
	q:((par="")||(desc))="" ""
	s rw=$o(^DHCINM.DB.MgClinicalTypeSubI("Item",par," "_$zcvt($tr(desc," ",""),"U"),""))
	q:rw="" ""
	s RowID="" f  s RowID=$o(^DHCINM.DB.MgClinicalLinkI("parref"," Y",par_"||"_rw,RowID)) q:RowID=""  d
	.s obj=##class(DHCINM.DB.MgClinicalLink).%OpenId(RowID)
	.s itmMast=obj.LinkItmMask
	.q:itmMast=""
	.i ret="" s ret=itmMast
	.e  s ret=ret_"^"_itmMast
	q ret
}

/// Creator:gzj
/// Date:2018-08-14
/// Description:获取关联的用法
ClassMethod GetClinicInstruc(par As %String, desc As %String) As %String
{
	s ret=""
	q:((par="")||(desc="")) ""
	s rw=$o(^DHCINM.DB.MgClinicalTypeSubI("Item",par," "_$zcvt($tr(desc," ",""),"U"),""))
	q:rw="" ""
	s RowID="" f  s RowID=$o(^DHCINM.DB.MgClinicalLinkI("parref"," Y",par_"||"_rw,RowID)) q:RowID=""  d
	.s obj=##class(DHCINM.DB.MgClinicalLink).%OpenId(RowID)
	.s itmInstruc=obj.LinkInstruc
	.q:itmInstruc=""
	.i ret="" s ret=itmInstruc
	.e  s ret=ret_"^"_itmInstruc
	q ret
}

/// Creator:gzj
/// Date:2018-08-14
/// Description:按照医嘱项或用法获取数量 病危 病重 一级护理 二级护理
ClassMethod GetItmCount(itmList, itmMastDr, sum) As %String
{
	q:((itmList="")||(itmMastDr="")) sum
	f i=1:1:$l(itmList,"^")
	{
		s itm=$p(itmList,"^",i)
		i itm="" continue
		i itm=itmMastDr s sum=sum+1
	}
	q sum
}

/// Creator:gzj
/// Date:2018-08-14
/// Description:按照手术日期进行统计某病区的例数
ClassMethod GetOprationsCounts(stDate As %String, endDate As %String, ctLocId As %String) As %String
{
	s stDate=$zdh(stDate,3)
	s endDate=$zdh(endDate,3)
	;s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(ctLocId)
	;q:'$IsObject(wardObj) ""
	;s locId=wardObj.CTLocDR.%Id()
	;q:locId="" ""
	;s locObj=##class(User.CTLoc).%OpenId(locId)
	;q:'$IsObject(locObj) ""
	;s locCode=locObj.CTLOCCode
	;s departId=$o(^CTLOC(0,"Code",$E(locCode,2,$l(locCode)),""))
	;q:departId="" ""
	;b ;01
	s opcount=0
	f date=stDate:1:endDate
	{
		s opaId="" f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.q:$p(^DHCANOPArrange(opaId),"^",27)="D"
		.s adm=$p(^DHCANOPArrange(opaId),"^",1)
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.s admLocId=$p($g(^PAADM(adm)),"^",4)
		.q:ctLocId'=appLocId
		.s opcount=opcount+1
	}
	q opcount
}

/// 获获取科室手术
ClassMethod GetLocOperateNum(orderPar, orderId, itmList, itmMastDr, sum) As %String
{
	s BillFlag=$p($g(^OEORD(orderPar,"I",orderId,"DHC")),"^",39)
	q:BillFlag="Y" sum
	
	s ArcItmCatDR=$p(^ARCIM($p(itmMastDr,"||",1),$p(itmMastDr,"||",2),1),"^",10) //获取医嘱项的子类
	s ArcItmDesc=$p(^ARC("IC",ArcItmCatDR),"^",2)
	i ArcItmDesc="科室手术" s sum=sum+1
	q sum
}

ClassMethod Test1() As %String
{
	s ^TMP("TEST1ng01")=+$h
	s tmp=""
	s day=+$h-1
	f date=day:1:day
	{
		s orderParref="" f  s orderParref=$o(^OEORDi(0,"ItemDate",date,orderParref)) q:orderParref=""  d
		.s orderId="" f  s orderId=$o(^OEORDi(0,"ItemDate",date,orderParref,orderId)) q:orderId=""  d
		..s ordState=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",13)
		..s stateCode=$p($g(^OEC("OSTAT",ordState)),"^",1)
		..q:"VED"'[stateCode
		..s ordDept=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",3) //ctlocid下医嘱科室
		..q:ordDept=""
		..s flag=..IsExistWard(ordDept)
		..q:flag=0 //与护管病区匹配不上就要过滤掉
		..;s ward=..GetHGWard(ordDept)
		..;q:ward="" //获取到护理管理中的对应的病区ID
		..;s itmMastDr=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",2) //获取医嘱项
		..;s instrDr=$p($g(^OEORD(orderParref,"I",orderId,2)),"^",7) //获取用法
		..;i $g(tmp(ordDept,itmMastDr))="" s tmp(ordDept,itmMastDr)=0
		..;e  s tmp(ordDept,itmMastDr)=tmp(ordDept,itmMastDr)+1
	}
	s ^TMP("TEST1ng02")=+$h
	b ;01
}

/// creator: zhangjz
/// date:2018-10-19
/// description: 生成病房工作量日报数据任务  
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMSysTaskComm).WardDayReport("")
ClassMethod WardDayReport() As %String
{
    s SysDate=+$H-1
    ;s SysDate=$ZDH(parr,3)
    ;s SysDate="64750"
    s SysDate=$zd(SysDate,3)
    s Ab=##class(web.INMStatComm).GenerateWardReport(SysDate,SysDate,"1")
    q 0
}

/// creator: zhangjz
/// date:2018-08-22
/// description: 生成工作量月报
/// table: DHCINM.Work.MgNurWorkReport
/// input:
/// output:
/// other: w ##class(web.INMSysTaskComm).AutoGenerateMonthRp()
ClassMethod AutoGenerateMonthRp() As %String
{
    s SysDate=+$H
    ;s SysDate=$ZDH("2015-07-01",3)
    s TmpDate=$ZD(SysDate,3)
    s Year=$P(TmpDate,"-",1)
    s Month=$P(TmpDate,"-",2)
    s Day=$P(TmpDate,"-",3)
    i Day="01" d
    .s ExcuteDate=$ZD(SysDate-1,3)
    .s ExcuteYear=$P(ExcuteDate,"-",1)
    .s ExcuteMonth=$P(ExcuteDate,"-",2)
    .s Mon=ExcuteYear_"-"_ExcuteMonth
    .s excuteday=$P(ExcuteDate,"-",3)
    .s StDate=ExcuteYear_"-"_ExcuteMonth_"-"_"01"
    .s EndDate=ExcuteDate
    .d ##class(web.INMStatComm).CreatRp(StDate,EndDate,1,Mon,"","WorkLoad")
}

/// Creator:gzj
/// Date:2019-05-08
/// Description:生成护士考勤月报数据 每月1号执行任务生成上一个月的月报数据
/// Table
/// Input:
/// Output:【废弃】
ClassMethod GenerateNurseAttendance() As %String
{
	s date=(+$h-1)
	s month=$E($zd(date,3),1,7)
	;d ##class(web.NurMgArgCount).GenerateAttendance(month,"",0)
}

/// Creator:
/// Date:2021-11-10
/// Description:生成pda执行率任务
/// Table
/// Input:
/// Output:d ##class(web.INMSysTaskComm).GenerateWardPdaReport()
ClassMethod GenerateWardPdaReport() As %String
{
	s date=(+$h-1)
	d ##class(web.INMStatComm).GenerateWardPdaReport(date,date,"")
	q 0
}

}
