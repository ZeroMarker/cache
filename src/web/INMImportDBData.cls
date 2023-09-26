Class web.INMImportDBData Extends %RegisteredObject
{

/// Creator：guozj
/// Description：Vue版护管后台导入数据 
/// Date：2017-10-21
/// 
/// Creator:guozj
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
	.;b ;01
	.s ward=$p(list,"^",3)
	.s row=$O(^CF.DHCINM.DB.MgWardI("Code"," "_$zcvt($tr(ward," ",""),"U"),""))
	.q:row'=""
	.s obj=##class(CF.DHCINM.DB.MgWard).%New()
	.s obj.WardCode=$zcvt($tr(ward," ",""),"U")
	.s obj.WardDesc=$zcvt($tr(ward," ",""),"U")
	.s obj.WardStDate=$zdh("2017-10-01",3)
	.s obj.WardSpell=##class(web.INMVueComm).ToChineseSpell($zcvt($tr(ward," ",""),"U"))
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
	.s row=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",20," "_$zcvt($tr(school," ",""),"U"),""))
	.q:row'=""
	.s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%New()
	.s obj.Parref=##class(CT.DHCINM.DB.MgSetCode).%OpenId("20")
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
	.s row=$O(^CF.DHCINM.HR.PersonsI("PerID"," "_nurseid,""))
	.q:row'=""
	.s obj=##class(CF.DHCINM.HR.Persons).%New()
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
	.s obj.PerStatus=..GetSetCode("在职状态","在职")
	.s obj.PerDepDate=+$H
	.d obj.%Save()
	.s transRowID=$O(^CF.DHCINM.Trans.TransDepI("Current"," Y"," "_obj.%Id(),""))
	.i transRowID="" d
	..s TransFlag=##class(web.INMPersonComm).SaveTransData("^"_obj.%Id()_"^"_obj.PerDepDR_"^"_$zd(obj.PerDepDate,3)_"^"_$zt($P($H,",",2),1)_"^Y^")	
	.e  d
	..s aa=##class(CF.DHCINM.Trans.TransDep).%OpenId(transRowID)
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
	s rw=$O(^CF.DHCINM.DB.MgWardI("Code"," "_ward,""))
	i rw'="" s ret=rw
	q ret
}

ClassMethod getPubCode(pubcode, desc) As %String
{
	s ret=""
	s par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_pubcode,""))
	q:par="" ""
	s rw=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",par," "_desc,""))
	i rw'="" s ret=par_"||"_rw
	q ret
}

ClassMethod UpdatePersonTmp() As %String
{
	s rowid="" f  s rowid=$O(^CF.DHCINM.HR.PersonsD(rowid)) q:rowid=""  d
	.s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowid)
	.q:obj.PerTypeDR'="N"
	.s rw=$O(^CF.DHCINM.HR.PersonsTmpD(""))
	.s rw=$O(^CF.DHCINM.HR.PersonsTmpI("PersonID"," "_rowid,""))
	.i rw="" s object=##class(CF.DHCINM.HR.PersonsTmp).%New()
	.e  s object=##class(CF.DHCINM.HR.PersonsTmp).%OpenId(rw)
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
/// d ##class(web.INMImportDBData).ClearIsDeleteGlobal()
ClassMethod ClearIsDeleteGlobal() As %String
{
	k ^DHCINM.DB.MgAgHolidayD
	k ^DHCINM.DB.MgAgHolidayI
	k ^DHCINM.DB.MgInternScoreC
	k ^DHCINM.Intern.MgQuantifySubD
	k ^DHCINM.Intern.MgQuantifySubI
	k ^DHCINM.Set.MgRolesC
	k ^DHCINM.Set.MgSetCodeD
	k ^DHCINM.Set.MgSetCodeI
	k ^DHCINM.Set.MgSetCodeSubD
	q 0
}

/// 清业务数据
/// d ##class(web.INMImportDBData).ClearNurMgBizData()
ClassMethod ClearNurMgBizData() As %String
{
	k tmp
	s tmp=""
	s num=0
	s claName="" f  s claName=$O(^oddPROJECT("DHCINM","Items",claName)) q:claName=""  d
	.s claNameLB=$LFS(claName,".")
	.q:$LF(claNameLB,"DHCINM")'=1
	.q:$LF(claNameLB,"WebService")=2
	.s tmp(claName)=claName
	.s num=num+1
	s claName="" f  s claName=$O(tmp(claName)) q:claName=""  d
	.s x="k ^"_claName_"D"
	.d ##class(web.INMVueComm).CalXMethod(x)
	.s x="k ^"_claName_"I"
	.d ##class(web.INMVueComm).CalXMethod(x)
	q "完成"
}

/// 清除配置数据
/// d ##class(web.INMImportDBData).ClearNurMgCFData()
ClassMethod ClearNurMgCFData() As %String
{
	k ^CF.DHCINM.CHK.CheckGroupI ;护士长夜查房分组
	k ^CF.DHCINM.CHK.CheckGroupD	
	k ^CF.DHCINM.CHK.CheckPlanI ;护士长夜查房计划
	k ^CF.DHCINM.CHK.CheckPlanD
	k ^CF.DHCINM.CHK.CheckPlanSubI
	k ^CF.DHCINM.CHK.CheckPlanSubD
	k ^CF.DHCINM.CHK.CheckWardD ;检查病区
	k ^CF.DHCINM.CHK.CheckWardI
	k ^CF.DHCINM.Set.MgDataLimitD ;数据权限-人
	k ^CF.DHCINM.Set.MgDataLimitI
	k ^CF.DHCINM.Set.MgDataLimitSubD
	k ^CF.DHCINM.Set.MgDataLimitSubI
	k ^CF.DHCINM.Set.MgVersionD ;移动查房pad版本
	k ^CF.DHCINM.Set.MgVersionI
	k ^CF.DHCINM.Set.NightFeeFactorD ;夜班系数及夜班单价
	k ^CF.DHCINM.Set.NightFeeFactorI
	k ^CF.DHCINM.DB.MgArgPostD ;全局排班类型
	k ^CF.DHCINM.DB.MgArgPostI
	k ^CF.DHCINM.DB.MgArgWardPostD ;病区排班类型
	k ^CF.DHCINM.DB.MgArgWardPostI
	k ^CF.DHCINM.DB.MgFloorD ;楼层信息
	k ^CF.DHCINM.DB.MgFloorI
	k ^CF.DHCINM.DB.MgHolidaySetD ;节假日
	k ^CF.DHCINM.DB.MgHolidaySetI
	k ^CF.DHCINM.DB.MgHospitalSetD ;院区
	k ^CF.DHCINM.DB.MgHospitalSetI 
	k ^CF.DHCINM.DB.MgUserD ;用户-人
	k ^CF.DHCINM.DB.MgUserI
	k ^CF.DHCINM.DB.MgUserRoleD ;用户角色-人
	k ^CF.DHCINM.DB.MgUserRoleI
	k ^CF.DHCINM.DB.MgWardD ;病区
	k ^CF.DHCINM.DB.MgWardI
	k ^CF.DHCINM.DB.MgWardAreaD ;片区
	k ^CF.DHCINM.DB.MgWardAreaI
	k ^CF.DHCINM.DB.MgWardLocD ;科室
	k ^CF.DHCINM.DB.MgWardLocI
	k ^CF.DHCINM.DB.MgWardLocUnitD ;科室病区关联
	k ^CF.DHCINM.DB.MgWardLocUnitI
	k ^CF.DHCINM.DB.MgWardPostGroupD ;病区排班组合
	k ^CF.DHCINM.DB.MgWardPostGroupI
	k ^CF.DHCINM.DB.SurveyFormD ;调查配置
	k ^CF.DHCINM.DB.SurveyFormI
	k ^CF.DHCINM.DB.SurveyFormSubD
	k ^CF.DHCINM.DB.SurveyFormSubI
	k ^CF.DHCINM.DB.TeaOperaD ;教学技操维护
	k ^CF.DHCINM.DB.TeaOperaI
	k ^CF.DHCINM.DB.TeaTheoryD ;教学理论维护
	k ^CF.DHCINM.DB.TeaTheoryI
	k ^CF.DHCINM.DB.TeaTheorySubD
	k ^CF.DHCINM.DB.TeaTheorySubI
	k ^CF.DHCINM.DB.WorkLoadDepSetD ;工作量病区维护
	k ^CF.DHCINM.DB.WorkLoadDepSetI
	k ^CF.DHCINM.HR.PersonsD ;人员档案
	k ^CF.DHCINM.HR.PersonsI
	k ^CF.DHCINM.HR.EducateD ;教育
	k ^CF.DHCINM.HR.EducateI
	k ^CF.DHCINM.HR.HireDutyD ;职称
	k ^CF.DHCINM.HR.HireDutyI
	k ^CF.DHCINM.HR.MgLevelI ;层级
	k ^CF.DHCINM.HR.MgLevelD
	k ^CF.DHCINM.HR.PostDutyD ;职务
	k ^CF.DHCINM.HR.PostDutyI
	k ^CF.DHCINM.Trans.TransDepD ;转科记录
	k ^CF.DHCINM.Trans.TransDepI
	
	
	q 0
}

/// 清系统数据---谨慎适用，删除后护管会一片空白
/// d ##class(web.INMImportDBData).ClearNurMgCTData()
ClassMethod ClearNurMgCTData() As %String
{
	k ^CT.DHCINM.Set.ApprovalSetD ;待办配置
	k ^CT.DHCINM.Set.ApprovalSetI
	k ^CT.DHCINM.Set.ApprovalSetKeyD
	k ^CT.DHCINM.Set.ApprovalSetKeyI
	k ^CT.DHCINM.Set.ApprovalSetShowD
	k ^CT.DHCINM.Set.ApprovalSetShowI
	k ^CT.DHCINM.Set.MgArgParamSetD ;综合参数
	k ^CT.DHCINM.Set.MgArgParamSetI
	k ^CT.DHCINM.Set.MgFieldSetD ;列表配置
	k ^CT.DHCINM.Set.MgFieldSetI
	k ^CT.DHCINM.Set.MgLangI ;多语言设置
	k ^CT.DHCINM.Set.MgLangD
	k ^CT.DHCINM.Set.MgLimitSetI ;菜单权限配置
	k ^CT.DHCINM.Set.MgLimitSetD
	k ^CT.DHCINM.Set.MgLimitSetSubI
	k ^CT.DHCINM.Set.MgLimitSetSubD
	k ^CT.DHCINM.Set.MgMenuI ;菜单
	k ^CT.DHCINM.Set.MgMenuD
	k ^CT.DHCINM.Set.MgMenuElementI ;菜单元素
	k ^CT.DHCINM.Set.MgMenuElementD
	k ^CT.DHCINM.Set.MgModuleI ;模块
	k ^CT.DHCINM.Set.MgModuleD
	k ^CT.DHCINM.Set.MgPerItemSetI ;档案页签配置
	k ^CT.DHCINM.Set.MgPerItemSetD
	k ^CT.DHCINM.Set.MgRolesI ;角色
	k ^CT.DHCINM.Set.MgRolesD
	k ^CT.DHCINM.Set.MgSysParamI ;系统参数
	k ^CT.DHCINM.Set.MgSysParamD
	k ^CT.DHCINM.Set.MgSysParamSubI
	k ^CT.DHCINM.Set.MgSysParamSubD
	k ^CT.DHCINM.DB.MgMOrderD ;医嘱配置
	k ^CT.DHCINM.DB.MgMOrderI
	k ^CT.DHCINM.DB.MgMOrderSubD
	k ^CT.DHCINM.DB.MgMOrderSubI
	
	k ^CT.DHCINM.DB.MgQualItemD ;质控表单配置
	k ^CT.DHCINM.DB.MgQualItemI
	k ^CT.DHCINM.DB.MgQualItemSubD
	k ^CT.DHCINM.DB.MgQualItemSubI
	k ^CT.DHCINM.DB.MgReAdmItemD ;护士再认证
	k ^CT.DHCINM.DB.MgReAdmItemI
	
	k ^CT.DHCINM.DB.MgSetCodeI ;公共代码
	k ^CT.DHCINM.DB.MgSetCodeD 
	k ^CT.DHCINM.DB.MgSetCodeSubI 
	k ^CT.DHCINM.DB.MgSetCodeSubD 
	k ^CF.DHCINM.HB.HbDirectionsD ;护士长手册维护
	k ^CF.DHCINM.HB.HbDirectionsI
	k ^CF.DHCINM.DB.WorkLoadItmD ;工作量配置
	k ^CF.DHCINM.DB.WorkLoadItmI
	k ^CF.DHCINM.DB.WorkLoadItmSubD
	k ^CF.DHCINM.DB.WorkLoadItmSubI 
	
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

// w ##class(web.INMImportDBData).ImportNurseData("PerID|2020152^PerLocDR|呼吸^PerDepDR|呼吸1^PerName|大152^PerCardId|445201199503230081^PerInNursePost|定科^PerAttriDepart|职能部门^PerComeDate|2019-06-16^PerWorkDate|2019-08-17^PerDepDate|2019-06-16^PerNation|汉族^PerPolitical|共青团员^PerSource|合同员工^PerPostDuty|护士^PerPostDutyDate|2020-01-13^PerHireDuty|副教授^PerHireDutyDate|2019-01-02^HighEduAcademic|中专^HighEduDegree|专科^HighEduAcaSchool|海南医学院^HighEduAcaInDate|2000-02-03^HighEduAcaWays|全日制^PostTitle|行政管理干部^Roles|护士^PerMarriage|已婚^PerNativePlace1|北京市^PerNativePlace2|北京城区^PerNativePlace3|顺义区^PerShoesNo|36^PerRegNo|111112370^PerRegRegiDate|2020-02-02^SelfAssessLevel|N1^AffirmLevel|N1^MgLevel|N2^MgLevelStDate|2018-12-03^index|41")

ClassMethod ImportNurseData(parr As %String) As %String
{
	s ^TMP("importnursedata")=parr
	//HISNO|N1473^PerID|N1473^PerLocDR|惠侨科^PerDepDR|惠侨科1单元^PerName|陈英^PerCardId|431222199302280820^PerNation|^PerPolitical|党员
	//^PerPolitDate|^PerHireDuty|护士^PerNativePlace|怀化^PerHouseAddress|^PerPhone|18674561686^PerSource|^PerWorkDate|2016-09-12
	//^PerComeDate|2016-09-12^PerCadreDate|^FirHireDuty|^FirHireDutyDate|^FirHireDutyQual|^FirHireQualDate|^PrepareDate|^HighEduAcademic|大专
	//^HighEduAcaSchool|常德职业技术学院^HighEduAcaPro|护理学^HighEduAcaInDate|2012-09-01^HighEduAcaOutDate|2017-05-31^HighEduAcaWays|全日制
	//^FirEduAcademic|大专^FirEduAcaSchool|常德职业技术学院^FirEduAcaPro|护理学^FirEduAcaInDate|2012-09-01^FirEduAcaOutDate|2017-05-31
	//^FirEduAcaWays|全日制^PerPostDuty|护士^PostTitle|^Roles|护士^RoleDate|2018-01-01
	s tmp="",flag=1
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s kk="" f  s kk=$o(tmp(kk)) q:kk=""  d
	.i ((tmp(kk)["/")&&($l(tmp(kk),"/")=3)) s tmp(kk)=$replace(tmp(kk),"/","-")
	s index=tmp("index")
	s PerCardId=$zcvt($tr($g(tmp("PerCardId"))," ",""),"U") //取得身份证号码
	i PerCardId="" s ^TMP("INMImportDBData","身份证号不能为空",$g(tmp("PerName")))=$g(tmp("PerName")),flag=0
	q:flag=0 "-1^0^"_$g(tmp("PerName"))
	s ^TMP("INMImportDBData")=""
	ts
	s rowid=$O(^CF.DHCINM.HR.PersonsI("card"," "_PerCardId,""))
	i rowid="" s obj=##class(CF.DHCINM.HR.Persons).%New()
	e  s obj=##class(CF.DHCINM.HR.Persons).%OpenId(rowid)
	s HISNO=""
	i $g(tmp("HISNO"))'="" s HISNO=$zcvt($tr($g(tmp("HISNO"))," ",""),"U") //HISNO
	s obj.HISNO=HISNO
	i $g(tmp("PerID"))'="" s PerID=$zcvt($tr($g(tmp("PerID"))," ",""),"U") //工号
	else  s flag=0
	i flag=0{
		tro
		q "-1^1^"_$g(tmp("PerName"))	
	}
	i (rowid="")&&($o(^DHCINM.HR.MgPersonI("PerID"," "_PerID,""))'="") {
		s ^TMP("INMImportDBData","工号已存在",$g(tmp("PerName")))=$g(tmp("PerName"))
		tro
		q "-1^2^"_$g(tmp("PerName"))	
	}
	s obj.PerID=PerID
	i (($g(tmp("PerPolitDate"))'="")&&($l($g(tmp("PerPolitDate")),"-")=3)) s obj.PerPolitDate=$zdh($g(tmp("PerPolitDate")),3)
	i (($g(tmp("PerWorkDate"))'="")&&($l($g(tmp("PerWorkDate")),"-")=3)) s obj.PerWorkDate=$zdh($g(tmp("PerWorkDate")),3)
	e  s flag=0
	i flag=0{
		tro
		q "-1^3^"_$g(tmp("PerName"))	
	}
	i $g(tmp("PerName"))'="" s obj.PerName=$tr($g(tmp("PerName"))," ","") //姓名
	e  s flag=0
	i flag=0{
		tro
		q "-1^4^"_$g(tmp("PerName"))	
	}
	i $g(tmp("PostTitle"))'="" d
	.s posttitledr=..GetSetCode("岗位名称",$zcvt($tr($g(tmp("PostTitle"))," ",""),"U")) //岗位名称
	.i posttitledr'="" s obj.PerPostName=posttitledr,obj.PerPostCompete=1
	i $g(tmp("PerAttriDepart"))'="" s obj.PerAttriDepart=..GetSetCode("部门归属",$zcvt($tr($g(tmp("PerAttriDepart"))," ",""),"U")) //归属部门
	s obj.NativeProvince=$tr($g(tmp("PerNativePlace1"))," ","") //籍贯
	s obj.NativeCity=$tr($tr($g(tmp("PerNativePlace2"))," ",""),"城区","市") //籍贯
	s obj.NativeArea=$tr($g(tmp("PerNativePlace3"))," ","") //籍贯
	s obj.NativeAddress=$tr($g(tmp("PerNativePlace4"))," ","") //籍贯
	s obj.RegistedProvince=$tr($g(tmp("PerHouseAddress1"))," ","") //户口所在省  
	s obj.RegistedCity=$tr($tr($g(tmp("PerHouseAddress2"))," ",""),"城区","市") //户口所在市  
	s obj.RegistedArea=$tr($g(tmp("PerHouseAddress3"))," ","") //户口所在区(县)  
	s obj.RegistedAddress=$tr($g(tmp("PerHouseAddress4"))," ","") //户口详细信息
	s obj.CurrentProvince=$tr($g(tmp("PerAddress1"))," ","") //现住址所在省  
	s obj.CurrentCity=$tr($tr($g(tmp("PerAddress2"))," ",""),"城区","市") //现住址所在市  
	s obj.CurrentArea=$tr($g(tmp("PerAddress3"))," ","") //现住址所在区(县)  
	s obj.CurrentAddress=$tr($g(tmp("PerAddress4"))," ","") //现住址详细信息
	s obj.HomeProvince=$tr($g(tmp("PerHomeAddress1"))," ","") //家庭住址所在省  
	s obj.HomeCity=$tr($tr($g(tmp("PerHomeAddress2"))," ",""),"城区","市") //家庭住址所在市  
	s obj.HomeArea=$tr($g(tmp("PerHomeAddress3"))," ","") //家庭住址所在区(县)  
	s obj.HomeAddress=$tr($g(tmp("PerHomeAddress4"))," ","") //家庭住址详细信息
	i (($g(tmp("PerCadreDate"))'="")&&($l($g(tmp("PerCadreDate")),"-")=3)) s obj.PerCadreDate=$zdh($g(tmp("PerCadreDate")),3)
	i $g(tmp("PerPolitical"))'="" d
	.s politicaldr=..GetSetCode("政治面貌",$zcvt($tr($g(tmp("PerPolitical"))," ",""),"U")) //政治面貌
	.i politicaldr'="" s obj.PerPolitical=politicaldr
	i (($g(tmp("PerComeDate"))'="")&&($l($g(tmp("PerComeDate")),"-")=3)) s obj.PerComeDate=$zdh($g(tmp("PerComeDate")),3)
	e  s flag=0
	i flag=0{
		tro
		q "-1^5^"_$g(tmp("PerName"))	
	}
	i (($g(tmp("PerDepDate"))'="")&&($l($g(tmp("PerDepDate")),"-")=3)) s obj.PerDepDate=$zdh($g(tmp("PerDepDate")),3)  //进科日期
	e  s obj.PerDepDate=+$H
	i $g(tmp("PerNation"))'="" d
	.s nationdr=..GetSetCode("民族",$zcvt($tr($g(tmp("PerNation"))," ",""),"U")) //民族
	.i nationdr'="" s obj.PerNation=nationdr
	s warddr=""
	i $g(tmp("PerDepDR"))'="" d
	.s warddr=..GetDBWard($zcvt($tr($g(tmp("PerDepDR"))," ",""),"U")) //病区
	.i warddr'="" s obj.PerDepDR=warddr
	e  s flag=0
	i flag=0{

		tro
		q "-1^6^"_$g(tmp("PerName"))	
	}
	i warddr=""
	{
		tro
		q "-1^7^"_$g(tmp("PerName"))
	}
	s locdr=""
	i $g(tmp("PerLocDR"))'="" d
	.s locdr=..GetDBLoc($zcvt($tr($g(tmp("PerLocDR"))," ",""),"U")) //科室
	.i locdr'="" s obj.PerLocDR=locdr
	i ($g(tmp("PerLocDR"))'="")&&(locdr="") {
		tro
		q "-1^8^"_$g(tmp("PerName"))	
	}
	i (($g(tmp("PrepareDate"))'="")&&($l($g(tmp("PrepareDate")),"-")=3)) s obj.PrepareDate=$zdh($g(tmp("PrepareDate")),3)
	i obj.PerPassword="" s obj.PerPassword="UUUUUU&&&&&&"
	i $g(tmp("PerSource"))'="" d
	.s sourcedr=..GetSetCode("职工性质",$zcvt($tr($g(tmp("PerSource"))," ",""),"U")) //受聘形式
	.i sourcedr'="" s obj.PerSource=sourcedr
	i $g(tmp("PerPhone"))'="" s obj.PerPhone=$tr($g(tmp("PerPhone"))," ","") //联系方式（手机）
	i $g(tmp("PerCardId"))'="" d
	.s obj.PerCardId=PerCardId //身份证号码
	.s cardlen=$L($tr($g(tmp("PerCardId"))," ",""))
	.i cardlen=18 d
	..s birthnum=$E($tr($g(tmp("PerCardId"))," ",""),7,14)
	..i birthnum'="" s obj.PerBirthday=$zdh(birthnum,8)
	..s sexnum=$E($tr($g(tmp("PerCardId"))," ",""),17)
	..i +sexnum>=0 d
	...i (+sexnum#2)=0 s obj.PerSexDR=..GetSetCode("性别","女")
	...e  s obj.PerSexDR=..GetSetCode("性别","男")
	i $g(tmp("PerMarriage"))'="" d
	.s marriagedr=..GetSetCode("婚姻",$zcvt($tr($g(tmp("PerMarriage"))," ",""),"U")) //婚姻
	.i marriagedr'="" s obj.PerMarriage=marriagedr
	i $g(tmp("PerContact"))'="" s obj.PerContact=$tr($g(tmp("PerContact"))," ","")
	i $g(tmp("PerHomeAddress"))'="" s obj.PerHomeAddress=$tr($g(tmp("PerHomeAddress"))," ","")
	i $g(tmp("PerAddress"))'="" s obj.PerAddress=$tr($g(tmp("PerAddress"))," ","")
	i $g(tmp("PerShoesNo"))'="" s obj.PerShoesNo=..GetSetCode("鞋号",$zcvt($tr($g(tmp("PerShoesNo"))," ",""),"U"))
	i $g(tmp("PerForeignLevel"))'="" s obj.PerForeignLevel=..GetSetCode("英语级别",$zcvt($tr($g(tmp("PerForeignLevel"))," ",""),"U")) 
	i $g(tmp("PerIsEspecially"))'="" d
	.i $zcvt($tr($g(tmp("PerIsEspecially"))," ",""),"U")="Y"  s obj.PerIsEspecially=1 ;是否特长
	.e  s obj.PerIsEspecially=0
	i $g(tmp("PerEspecially"))'=""  s obj.PerEspecially=$tr($g(tmp("PerEspecially"))," ",""),obj.PerIsEspecially=1 ;特长
	i $g(tmp("PerRegNo"))'=""  s obj.PerRegNo=$tr($g(tmp("PerRegNo"))," ",""),obj.PerIsRegiste=1  ;执业证书
#;	i (($g(tmp("PerRegRegiDate"))'="")&&($l($g(tmp("PerRegRegiDate")),"-")=3)) d
#;	.s rw=$o(^DHCINM.HR.MgQualRegistedI("ssid"," "_obj.%Id(),""))
#;	.s regObj=##class(DHCINM.HR.MgQualRegisted).%New()
#;	.s:rw'="" regObj=##class(DHCINM.HR.MgQualRegisted).%OpenId(rw)
#;	.s regObj.RegistedPerson=obj.%Id()
#;	.s regObj.RegistedStatus="A"
#;	.s regObj.RegistedDate=$zdh($tr($g(tmp("PerRegRegiDate"))," ",""),3) ;证书注册日期
#;	.d regObj.%Save()
    i $g(tmp("PerInNursePost"))'=""  s obj.PerInNursePost=..GetSetCode("在岗状态",$tr($g(tmp("PerInNursePost"))," ","")) ;在岗状态
	e  s flag=0
	i flag=0{
		tro
		q "-1^9^"_$g(tmp("PerName"))	
	}
	i $g(tmp("SelfAssessLevel"))'="" s obj.SelfAssessLevel=..GetSetCode("护士层级",$g(tmp("SelfAssessLevel")))  ;入职自评层级
	i $g(tmp("AffirmLevel"))'="" s obj.AffirmLevel=..GetSetCode("护士层级",$g(tmp("AffirmLevel")))  ;入职认定层级
	s obj.ImportDate=+$H
	s obj.PerStatus=..GetSetCode("在职状态","在职")
	s obj.PerTypeDR="N"
	s obj.PerCareType="N"
	s obj.PerAuditFlag="Y"
	s sc= obj.%Save()
	i '$$$ISOK(sc)
	{
		tro
		q "-1^20^"_$g(tmp("PerName"))
	}
	i (($g(tmp("PerRegRegiDate"))'="")&&($l($g(tmp("PerRegRegiDate")),"-")=3)) d
 	.s RegistedId=$o(^DHCINM.HR.MgQualRegistedI("ssid"," "_obj.%Id(),""))
 	.s regObj=##class(DHCINM.HR.MgQualRegisted).%New()
 	.s:RegistedId'="" regObj=##class(DHCINM.HR.MgQualRegisted).%OpenId(RegistedId)
 	.s regObj.RegistedPerson=obj.%Id()
 	.s regObj.RegistedStatus="A"
 	.s regObj.RegistedDate=$zdh($tr($g(tmp("PerRegRegiDate"))," ",""),3) ;证书注册日期
 	.i (($g(tmp("PerRegValidDate"))'="")&&($l($g(tmp("PerRegValidDate")),"-")=3)) d
 	..s regObj.RegistedValidDate=$zdh($tr($g(tmp("PerRegValidDate"))," ",""),3)
 	.d regObj.%Save()

	s rw=obj.%Id()
	///层级导入
    i $tr($g(tmp("MgLevel"))," ","")'="" d
    .s LevelDate=+$h
    .i (($g(tmp("MgLevelStDate"))'="")&&($l($g(tmp("MgLevelStDate")),"-")=3)) d
    ..s LevelDate=$zdh($tr($g(tmp("MgLevelStDate"))," ",""),3)
    .s levelObj=##class(CF.DHCINM.HR.MgLevel).%New()
    .s levelObj.LevelPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rw)
    .s levelObj.NurLevel=..GetSetCode("护士层级",$zcvt($tr($g(tmp("MgLevel"))," ",""),"U"))
    .s levelObj.LevelDate=LevelDate
    .s levelObj.LevelStatus="A"
    .s sc=levelObj.%Save()
	
	i '$$$ISOK(sc)
	{
		tro
		q "-1^10^"_$g(tmp("PerName"))
	}
	///职称导入
	i $g(tmp("PerHireDuty"))'="" d
	.i (($g(tmp("PerHireDutyDate"))'="")&&($l($g(tmp("PerHireDutyDate")),"-")=3)) d
	..s hiredate=$zdh($tr($g(tmp("PerHireDutyDate"))," ",""),3)
	..s hiredutyrw=$O(^CF.DHCINM.HR.HireDutyI("date",hiredate,rw,""))
	..i hiredutyrw="" d
	...s rwtmp=$O(^CF.DHCINM.HR.HireDutyI("ssid",rw,""),-1)
	...i rwtmp'="" d
	....s rwtmpobj=##class(CF.DHCINM.HR.HireDuty).%OpenId(rwtmp)
	....q:'$IsObject(rwtmpobj)
	....s rwtmpobj.HireEndDate=hiredate
	....d rwtmpobj.%Save()
	...s hireobj=##class(CF.DHCINM.HR.HireDuty).%New()
	...s hireobj.HirePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rw)
	...s hireobj.HireDuty=..GetSetCode("聘任职称",$zcvt($tr($g(tmp("PerHireDuty"))," ",""),"U"))
	...s hireobj.HireStDate=hiredate
	...s hireobj.HireStatus="A"
	...s sc=hireobj.%Save()
	i '$$$ISOK(sc)
	{
		tro
		q "-1^11^"_$g(tmp("PerName"))
	}
	///第一学历导入
	i $g(tmp("FirEduAcademic"))'="" d
	.i (($g(tmp("FirEduAcaInDate"))'="")&&($l($tr($g(tmp("FirEduAcaInDate"))," ",""),"-")=3)) d
	..s edustdate=$zdh($tr($g(tmp("FirEduAcaInDate"))," ",""),3)
	..s edurw=$O(^CF.DHCINM.HR.EducateI("date",edustdate,rw,""))
	..i edurw="" d
	...s edurwobj=##class(CF.DHCINM.HR.Educate).%New()
	...s edurwobj.EduPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rw)
	..e  s edurwobj=##class(CF.DHCINM.HR.Educate).%OpenId(edurw)
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
	..s sc=edurwobj.%Save()
	i '$$$ISOK(sc)
	{
		tro
		q "-1^12^"_$g(tmp("PerName"))
	}
	///最高学历导入
	i $g(tmp("HighEduAcademic"))'="" d
	.i (($g(tmp("HighEduAcaInDate"))'="")&&($l($tr($g(tmp("HighEduAcaInDate"))," ",""),"-")=3)) d
	..s hedustdate=$zdh($tr($g(tmp("HighEduAcaInDate"))," ",""),3)
	..s hedurw=$O(^CF.DHCINM.HR.EducateI("date",hedustdate,rw,""))
	..i hedurw="" d
	...s hedurwobj=##class(CF.DHCINM.HR.Educate).%New()
	...s hedurwobj.EduPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rw)
	..e  s hedurwobj=##class(CF.DHCINM.HR.Educate).%OpenId(hedurw)
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
	..s sc=hedurwobj.%Save()
	i '$$$ISOK(sc)
	{
		tro
		q "-1^13^"_$g(tmp("PerName"))
	}
	///调科记录导入
	s transRowID=$O(^CF.DHCINM.Trans.TransDepI("Current"," Y"," "_rw,""))
	i transRowID="" d
	.s perdepdate=$zd(obj.PerDepDate,3)
	.s TransFlag=##class(web.INMPersonComm).SaveTransData("^"_rw_"^"_obj.PerDepDR_"^"_perdepdate_"^"_$zt($P($H,",",2),1)_"^Y")	
#;	e  d
#;	.s aa=##class(CF.DHCINM.Trans.TransDep).%OpenId(transRowID)
#;	.s aa.PerDr=obj.%Id()
#;    .s aa.PerDepart=obj.PerDepDR
#;    .i obj.PerDepDate'="" s aa.PerTranStDate=obj.PerDepDate
#;    .e  s aa.PerTranStDate=+$h
#;    .s aa.PerTranCurrent="Y"
#;    .s aa.PerTranStTime=$P($H,",",2)
#;    .s sc=aa.%Save()
    i '$$$ISOK(sc)
	{
		tro
		q "-1^14^"_$g(tmp("PerName"))
	}
    ///获取角色ID串
    s roles=""
    i $g(tmp("Roles"))'="" d
    .s rolelen=$l($tr($g(tmp("Roles"))," ",""),",")
    .i rolelen>0 d
    .for i=1:1:rolelen d
    ..s roleitm=$p($tr($g(tmp("Roles"))," ",""),",",i)
    ..i roleitm'="" d
    ...s roleid=""
    ...s roleid=..GetRole(roleitm)
    ...i roles="" s roles=roleid
    ...e  s roles=roles_","_roleid
    /// 生成/更新 User信息
    s userId=$o(^CF.DHCINM.DB.MgUserI("UserID"," "_PerID,""))
    s userSc=##class(web.INMDBComm).SaveUser("UserID|"_PerID_"^PerDepDR|"_obj.PerDepDR_"^PerDR|"_obj.%Id()_"^UserName|"_tmp("PerName")_"^SSUserCode|"_HISNO_"^UserRole|"_roles_"^StartDate|"_$zd(+$h-1,3)_"^EndDate|^rw|"_userId)
    i (userSc'=1)
	{
		tro
		q:userSc="无此HIS用户" "-1^15^"_$g(tmp("PerName"))
		q:userSc="此用户HIS工号已存在" "-1^16^"_$g(tmp("PerName"))
		q:userSc="保存用户信息失败" "-1^17^"_$g(tmp("PerName"))
		q:userSc="保存角色信息失败" "-1^18^"_$g(tmp("PerName"))
	}
    ///职务导入 有护士长职务的要插入护士长角色
    i (($g(tmp("PerPostDuty"))'="")&&($g(tmp("PerPostDutyDate"))="")) s tmp("PerPostDutyDate")=$zd(+$h,3)
    i $g(tmp("PerPostDuty"))'="" d
    .i (($g(tmp("PerPostDutyDate"))'="")&&($l($tr($g(tmp("PerPostDutyDate"))," ",""),"-")=3)) d
    ..s postdate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
    ..s postRowID=""
    ..s postRowID=..GetSetCode("职务",$zcvt($tr($g(tmp("PerPostDuty"))," ",""),"U")) //获取职务的记录ID
    ..q:postRowID=""
    ..s postrw=$O(^CF.DHCINM.HR.PostDutyI("date",postdate,rw,"")) //判断此日期点是否存在记录
    ..i postrw="" d //如果此日期点不存在记录 就要检查此日期之前的记录
    ...s oldpostrw="" f  s oldpostrw=$O(^CF.DHCINM.HR.PostDutyI("ssid",rw,oldpostrw)) q:oldpostrw=""  d
    ....s oldpostobj=##class(CF.DHCINM.HR.PostDuty).%OpenId(oldpostrw)
    ....q:oldpostobj.PostEndDate'=""
    ....s oldpostobj.PostEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
    ....s sc=sc&&(oldpostobj.%Save())
    ...s newpostobj=##class(CF.DHCINM.HR.PostDuty).%New()
    ...s newpostobj.PostPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rw)
    ...s newpostobj.PostDuty=postRowID
    ...s newpostobj.PostStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
    ...s newpostobj.PostStatus="A"
    ...s sc=sc&&(newpostobj.%Save())
    ...i ((newpostobj.%Id()'="")&&($zcvt($tr($g(tmp("PerPostDuty"))," ",""),"U")="护士长")) d //判断如果职务是护士长就要在角色中添加护士长角色
	....s userid=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_rw,""))
	....i userid'="" d
	.....s sc=sc&&(##class(web.INMDBComm).SaveUserRole(6,userid))
	i '$$$ISOK(sc)
	{
		tro
		q "-1^19^"_$g(tmp("PerName"))
	}
	tc
	q index
}

/// 获取角色ID
ClassMethod GetRole(desc As %String) As %String
{
	q:desc="" ""
	s ret=""
	s rowid=$O(^CT.DHCINM.Set.MgRolesI("desc"," Y"," "_$zcvt($tr(desc," ",""),"U"),""))
	i rowid'="" s ret=rowid
	q ret
}

/// 获取科室ID
ClassMethod GetDBLoc(locdesc As %String) As %String
{
	s ret=""
	;s spell=##class(web.INMVueComm).ToChineseSpell(locdesc)
	s rowid=$O(^CF.DHCINM.DB.MgWardLocI("Desc"," "_$ZCVT($tr(locdesc," ",""),"U"),""))
	i rowid'="" s ret=rowid
	q ret
}

/// 获取病区ID
ClassMethod GetDBWard(warddesc As %String) As %String
{
	s ret=""
	s rowid=$O(^CF.DHCINM.DB.MgWardI("Desc"," "_warddesc,""))
	i rowid'="" s ret=rowid
	q ret
}

/// 获取档案公共代码
ClassMethod GetSetCode(pardesc As %String, subdesc As %String) As %String
{
	s ret=""
	s par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_pardesc,""))
	q:par="" ""
	s obj=##class(CT.DHCINM.DB.MgSetCode).%OpenId(par)
	s rw="" f  s rw=$O(^CT.DHCINM.DB.MgSetCodeSubI("Code",par," "_subdesc,rw)) q:rw=""  d
	.s ret=par_"||"_rw
	q ret
}

ClassMethod ImportNurseRole(parr As %String) As %String
{
	s ^TMP("ImportNurseRole")=parr
	s tmp=""
	s flag=1
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s SSUserErrorRet=""
	s SSUserCode=$g(tmp("HISNO"))
	q:SSUserCode="" "HIS号不能为空" 
	s SSUserId=""
	i SSUserCode'="" 
	{
		s SSUserId=##class(web.INMHISComm).GetUserIdByCode(SSUserCode)
		s:SSUserId="" SSUserErrorRet="无此HIS用户"
		i SSUserId'=""
		{
			s userid=$o(^CF.DHCINM.DB.MgUserI("SSUser"," "_SSUserId,""))
			q:userid="" "护管无此用户"
			s roleId=$O(^CT.DHCINM.Set.MgRolesI("desc"," Y"," "_$tr($g(tmp("NurseRole"))," ",""),""))
			q:roleId="" "该角色不存在" //获取角色的ID
			s roleFlag=##class(web.INMDBComm).SaveUserRole(roleId,userid)
			q:'roleFlag "导入失败"
			q "导入成功"
		}
	}
}

/// 导入带教老师角色
/// w ##class(web.INMImportDBData).ImportTeacherData("PerName|中1127^PerNO|2020347^NurseRole|带教老师^RoleStDate|2020-02-03^index|0")
ClassMethod ImportTeacherData(parr As %String) As %String
{
	s ^TMP("ImportTeacherData")=parr
	//PerName|滕中华^HISNO|tzh^NurseRole|带教老师^RoleStDate|2018-01-01
	s tmp=""
	s flag=1
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s perNo=$g(tmp("PerNO")) //护士工号
	q:perNo="" ""
	q:$g(tmp("RoleStDate"))="" ""
	s date=+$h
	s:$g(tmp("RoleStDate"))["-" date=$zdh($g(tmp("RoleStDate")),3)
	s rowId=$o(^CF.DHCINM.HR.PersonsI("PerID"," "_$zcvt($tr($g(perNo)," ",""),"U"),""))
	q:rowId="" "" //人员表ID
	s PerObj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	q:'$IsObject(PerObj) ""
	s NurName=$tr(PerObj.PerName," ","")
	q:$tr($g(tmp("PerName"))," ","")'=NurName ""
	q:$tr($g(tmp("NurseRole"))," ","")="" ""
	s roleId=$O(^CT.DHCINM.Set.MgRolesI("desc"," Y"," "_$tr($g(tmp("NurseRole"))," ",""),""))
	q:roleId="" "" //获取角色的ID
	s userid=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_rowId,""))
	q:userid="" ""  //获取用户的ID
	TS
	s roleRw=$o(^CF.DHCINM.DB.MgUserRoleI("RoleUser"," "_roleId,userid,""))
	i roleRw=""
	{
		s newObj=##class(CF.DHCINM.DB.MgUserRole).%New()
		s newObj.Parref=##class(CF.DHCINM.DB.MgUser).%OpenId(rowId)
		s newObj.RoleID=roleId
		s newObj.RoleStDate=date
		s sc=newObj.%Save()
		i '$$$ISOK(sc) s flag=0
	}
	i flag=1
	{
		TC
	}
	else
	{
		Tro
	}	
	q:flag=0 "-1"
	q tmp("index")
}

/// 导入护士注册证书号
ClassMethod ImportNurseCardData(parr As %String) As %String
{
	s ^TMP("ImportNurseCardData")=parr
	//PerName|测试^HISNO|测试^PerRegNo|测试
	s tmp=""
	s flag=1
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s perHisNo=$g(tmp("HISNO")) //护士HIS号
	q:perHisNo="" ""
	
	s rowId=$o(^CF.DHCINM.HR.PersonsI("hisno"," "_$zcvt($tr($g(tmp("HISNO"))," ",""),"U"),""))
	q:rowId="" "" //人员表ID
	s PerObj=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	q:'$IsObject(PerObj) ""
	q:(($g(tmp("PerName"))'="")&&($g(tmp("PerName"))'=PerObj.PerName))
	i $g(tmp("PerRegNo"))'="" s PerObj.PerRegNo=$g(tmp("PerRegNo"))
	s sc=PerObj.%Save()
	q $$$ISOK(sc)
}

ClassMethod ImportPostAndHireData(parr As %String) As %String
{
	s ^TMP("ImportPostAndHireData")=parr
	//PerName|测试^HISNO|测试^PerPostDuty|护士长^PerPostDutyDate|2018-08-13^PerHireDuty|主管护师^PerHireDutyDate|2018-08-13
	s tmp=""
	s flag=1
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s perHisNo=$g(tmp("HISNO")) //护士HIS号
	q:perHisNo="" ""
	
	s rowId=$o(^CF.DHCINM.HR.PersonsI("hisno"," "_$zcvt($tr($g(tmp("HISNO"))," ",""),"U"),""))
	q:rowId="" "" //人员表ID
	s PerHireDuty=..GetSetCode("聘任职称",$zcvt($tr($g(tmp("PerHireDuty"))," ",""),"U")) //获取职称的记录ID
	s MajorDuty=..GetSetCode("聘任职称",$zcvt($tr($g(tmp("MajorDuty"))," ",""),"U")) 
	///职称
	s RowID=$o(^CF.DHCINM.HR.HireDutyI("ssid",rowId,""))
	s flag=1
	TS
	i MajorDuty'="" {
		i RowID=""
		{
			s HireObj=##class(CF.DHCINM.HR.HireDuty).%New()
			s HireObj.HirePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
			s HireObj.HireDuty=PerHireDuty
			i $g(tmp("HireStDate"))'="" s HireObj.HireStDate=$zdh($tr(tmp("HireStDate")," ",""),3)
			e  s HireObj.HireStDate=+$h
			i $g(tmp("HireEndDate"))'="" s HireObj.HireEndDate=$zdh($tr(tmp("HireEndDate")," ",""),3)
			e  s HireObj.HireEndDate=""
			s HireObj.MajorDuty=..GetSetCode("聘任职称",$zcvt($tr($g(tmp("MajorDuty"))," ",""),"U")) 
			s HireObj.MajorDutyDate=$zdh($tr(tmp("MajorDutyDate")," ",""),3)
			e  s HireObj.MajorDutyDate=+$h
			s HireObj.HireStatus="A"
			s sc=HireObj.%Save()
			s flag=($$$ISOK(sc)&&flag)
		}
		else
		{
			s RwFlag=""
			s stDate="" f  s stDate=$o(^CF.DHCINM.HR.HireDutyI("HireDate",rowId,stDate)) q:stDate=""  d
			.s HireRw="" f  s HireRw=$o(^CF.DHCINM.HR.HireDutyI("HireDate",rowId,stDate,HireRw)) q:HireRw=""  d
			..s HireObj=##class(CF.DHCINM.HR.HireDuty).%OpenId(HireRw)
			..q:HireObj.HireEndDate'=""
			..s RwFlag=HireRw
			..i $g(tmp("HireStDate"))'="" s HireObj.HireEndDate=$zdh($tr(tmp("HireStDate")," ",""),3)
			..s sc=HireObj.%Save()
			..s flag=($$$ISOK(sc)&&flag)
			s NewHireObj=##class(CF.DHCINM.HR.HireDuty).%New()
			s NewHireObj.HirePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
			s NewHireObj.HireDuty=PerHireDuty
			s NewHireObj.HireStatus="A"
			i $g(tmp("HireStDate"))'="" s NewHireObj.HireStDate=$zdh($tr(tmp("HireStDate")," ",""),3)
			e  s NewHireObj.HireStDate=+$H
			i $g(tmp("HireEndDate"))'="" s NewHireObj.HireEndDate=$zdh($tr(tmp("HireEndDate")," ",""),3)
			e  s NewHireObj.HireEndDate=""
			s NewHireObj.MajorDuty=..GetSetCode("聘任职称",$zcvt($tr($g(tmp("MajorDuty"))," ",""),"U")) 
			s NewHireObj.MajorDutyDate=$zdh($tr(tmp("MajorDutyDate")," ",""),3)
			e  s NewHireObj.MajorDutyDate=+$h
			s newSc=NewHireObj.%Save()
			s flag=($$$ISOK(newSc)&&flag)
		}
	}
	s PerPostDuty=..GetSetCode("职务",$zcvt($tr($g(tmp("PerPostDuty"))," ",""),"U")) //获取职务的记录ID
	i (PerPostDuty=""){
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
	s PostRowID=$o(^CF.DHCINM.HR.PostDutyI("ssid",rowId,""))
	if PerPostDuty'="" {
		i PostRowID=""
		{
			s PostObj=##class(CF.DHCINM.HR.PostDuty).%New()
			s PostObj.PostPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
			s PostObj.PostDuty=PerPostDuty
			s PostObj.PostStatus="A"
			i $g(tmp("PerPostDutyDate"))'="" s PostObj.PostStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
			s postSc=PostObj.%Save()
			s flag=($$$ISOK(postSc)&&flag)
			i flag=1
			{
				i $tr($g(tmp("PerPostDuty"))," ","")="护士长"
				{
					s roleId=$O(^CT.DHCINM.Set.MgRolesI("desc"," Y"," "_$tr($g(tmp("PerPostDuty"))," ",""),""))
					q:roleId="" "" //获取角色的ID
					s nurheadrw=$o(^DHCINM.Set.MgRoleNurseI("nurse",roleId," "_rowId,""))
					i nurheadrw=""
					{
						s roleObj=##class(DHCINM.Set.MgRoleNurse).%New()
						s roleObj.Parref=##class(CT.DHCINM.Set.MgRoles).%OpenId(roleId)
						i $g(tmp("PerPostDutyDate"))'="" s roleObj.RoleStDate=$zdh($g(tmp("PerPostDutyDate")),3)
						s roleObj.RoleNurse=rowId
						s roleSc=roleObj.%Save()
						s flag=(flag&&$$$ISOK(roleSc))
						i flag=1
						{
							s nurseRoleRw=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,""))
							i nurseRoleRw=""
							{
								s nurObj=##class(DHCINM.HR.MgNurRole).%New()
								s nurObj.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
								s nurObj.RoleID=roleId
								i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s nursc=nurObj.%Save()
								s flag=(flag&&$$$ISOK(nursc))
							}
							else
							{
								s isNurFlag=0,nurRw=""
								s nurSub="" f  s nurSub=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
								.s nurObj=##class(DHCINM.HR.MgNurRole).%OpenId(nurSub)
								.q:nurObj.RoleEndDate'=""
								.s isNurFlag=1
								.s nurRw=nurSub
								i isNurFlag=1
								{
									s rowSub=##class(DHCINM.HR.MgNurRole).%OpenId(nurRw)
									i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s rowSc=rowSub.%Save()
									s flag=(flag&&$$$ISOK(rowSc))
									i flag=1
									{
										s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
										s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
										s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s rowSubNew.RoleID=roleId
										s rowNewSc=rowSubNew.%Save()
										s flag=(flag&&$$$ISOK(rowNewSc))
									}
								}
								else
								{
									s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
									s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
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
						s roleSub="" f  s roleSub=$o(^DHCINM.Set.MgRoleNurseI("nurse",roleId," "_rowId,roleSub)) q:roleSub=""  d
						.s roleObj=##class(DHCINM.Set.MgRoleNurse).%OpenId(roleId_"||"_roleSub)
						.s isFlag=1
						.s rw=roleId_"||"_roleSub
						i isFlag=1
						{
							s object=##class(DHCINM.Set.MgRoleNurse).%OpenId(rw)
							i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s roleObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
							s sc1=roleObj.%Save()
							s flag=(flag&&$$$ISOK(sc1))
						}
						else 
						{
							s object=##class(DHCINM.Set.MgRoleNurse).%New()
							s object.Parref=##class(CT.DHCINM.Set.MgRoles).%OpenId(roleId)
							i $g(tmp("PerPostDutyDate"))'="" s object.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
							s object.RoleNurse=rowId
							s sc2=object.%Save()
							s flag=(flag&&$$$ISOK(sc2))
						}
						i flag=1
						{
							s nurseRoleRw=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,""))
							i nurseRoleRw=""
							{
								s nurObj=##class(DHCINM.HR.MgNurRole).%New()
								s nurObj.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
								s nurObj.RoleID=roleId
								i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s nursc=nurObj.%Save()
								s flag=(flag&&$$$ISOK(nursc))
							}
							else
							{
								s isNurFlag=0,nurRw=""
								s nurSub="" f  s nurSub=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
								.s nurObj=##class(DHCINM.HR.MgNurRole).%OpenId(nurSub)
								.q:nurObj.RoleEndDate'=""
								.s isNurFlag=1
								.s nurRw=nurSub
								i isNurFlag=1
								{
									s rowSub=##class(DHCINM.HR.MgNurRole).%OpenId(nurRw)
									i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s rowSc=rowSub.%Save()
									s flag=(flag&&$$$ISOK(rowSc))
									i flag=1
									{
										s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
										s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
										i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s rowSubNew.RoleID=roleId
										s rowNewSc=rowSubNew.%Save()
										s flag=(flag&&$$$ISOK(rowNewSc))
									}
								}
								else
								{
									s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
									s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
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
			s PostDR="" f  s PostDR=$o(^CF.DHCINM.HR.PostDutyI("ssid",rowId,PostDR)) q:PostDR=""  d
			.s PostObjOld=##class(CF.DHCINM.HR.PostDuty).%OpenId(PostDR)
			.q:PostObjOld.PostEndDate'=""
			.s PostFlag=1
			.s postRw=PostDR
			i PostFlag=1
			{
				s rowPost=##class(CF.DHCINM.HR.PostDuty).%OpenId(postRw)
				i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowPost.PostEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
				s rowPostSc=rowPost.%Save()
				s flag=($$$ISOK(rowPostSc)&&flag)
				i flag=1
				{
					s RowPostObj=##class(CF.DHCINM.HR.PostDuty).%New()
					s RowPostObj.PostPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
					s RowPostObj.PostDuty=PerPostDuty
					s RowPostObj.PostStatus="A"
					i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s RowPostObj.PostStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
					s RowSc=RowPostObj.%Save()
					s flag=($$$ISOK(RowSc)&&flag)
					i flag=1
					{
						i $tr($g(tmp("PerPostDuty"))," ","")="护士长"
						{
							s roleId=$O(^CT.DHCINM.Set.MgRolesI("desc"," Y"," "_$tr($g(tmp("PerPostDuty"))," ",""),""))
							q:roleId="" "" //获取角色的ID
							s nurheadrw=$o(^DHCINM.Set.MgRoleNurseI("nurse",roleId," "_rowId,""))
							i nurheadrw=""
							{
								s roleObj=##class(DHCINM.Set.MgRoleNurse).%New()
								s roleObj.Parref=##class(DHCINM.Set.MgRoles).%OpenId(roleId)
								i $g(tmp("PerPostDutyDate"))'="" s roleObj.RoleStDate=$zdh($g(tmp("PerPostDutyDate")),3)
								s roleObj.RoleNurse=rowId
								s roleSc=roleObj.%Save()
								s flag=(flag&&$$$ISOK(roleSc))
								i flag=1
								{
									s nurseRoleRw=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,""))
									i nurseRoleRw=""
									{
										s nurObj=##class(DHCINM.HR.MgNurRole).%New()
										s nurObj.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
										s nurObj.RoleID=roleId
										i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s nursc=nurObj.%Save()
										s flag=(flag&&$$$ISOK(nursc))
									}
									else
									{
										s isNurFlag=0,nurRw=""
										s nurSub="" f  s nurSub=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
										.s nurObj=##class(DHCINM.HR.MgNurRole).%OpenId(nurSub)
										.q:nurObj.RoleEndDate'=""
										.s isNurFlag=1
										.s nurRw=nurSub
										i isNurFlag=1
										{
											s rowSub=##class(DHCINM.HR.MgNurRole).%OpenId(nurRw)
											i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
											s rowSc=rowSub.%Save()
											s flag=(flag&&$$$ISOK(rowSc))
											i flag=1
											{
												s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
												s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
												s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
												s rowSubNew.RoleID=roleId
												s rowNewSc=rowSubNew.%Save()
												s flag=(flag&&$$$ISOK(rowNewSc))
											}
										}
										else
										{
											s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
											s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
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
								s roleSub="" f  s roleSub=$o(^DHCINM.Set.MgRoleNurseI("nurse",roleId," "_rowId,roleSub)) q:roleSub=""  d
								.s roleObj=##class(DHCINM.Set.MgRoleNurse).%OpenId(roleId_"||"_roleSub)
								.s isFlag=1
								.s rw=roleId_"||"_roleSub
								i isFlag=1
								{
									s object=##class(DHCINM.Set.MgRoleNurse).%OpenId(rw)
									i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s roleObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s sc1=roleObj.%Save()
									s flag=(flag&&$$$ISOK(sc1))
								}
								else 
								{
									s object=##class(DHCINM.Set.MgRoleNurse).%New()
									s object.Parref=##class(DHCINM.Set.MgRoles).%OpenId(roleId)
									i $g(tmp("PerPostDutyDate"))'="" s object.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s object.RoleNurse=rowId
									s sc2=object.%Save()
									s flag=(flag&&$$$ISOK(sc2))
								}
								i flag=1
								{
									s nurseRoleRw=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,""))
									i nurseRoleRw=""
									{
										s nurObj=##class(DHCINM.HR.MgNurRole).%New()
										s nurObj.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
										s nurObj.RoleID=roleId
										i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s nursc=nurObj.%Save()
										s flag=(flag&&$$$ISOK(nursc))
									}
									else
									{
										s isNurFlag=0,nurRw=""
										s nurSub="" f  s nurSub=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
										.s nurObj=##class(DHCINM.HR.MgNurRole).%OpenId(nurSub)
										.q:nurObj.RoleEndDate'=""
										.s isNurFlag=1
										.s nurRw=nurSub
										i isNurFlag=1
										{
											s rowSub=##class(DHCINM.HR.MgNurRole).%OpenId(nurRw)
											i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
											s rowSc=rowSub.%Save()
											s flag=(flag&&$$$ISOK(rowSc))
											i flag=1
											{
												s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
												s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
												i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
												s rowSubNew.RoleID=roleId
												s rowNewSc=rowSubNew.%Save()
												s flag=(flag&&$$$ISOK(rowNewSc))
											}
										}
										else
										{
											s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
											s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
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
				s RowPostObj=##class(CF.DHCINM.HR.PostDuty).%New()
				s RowPostObj.PostPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
				s RowPostObj.PostDuty=PerPostDuty
				s RowPostObj.PostStatus="A"
				i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s RowPostObj.PostStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
				s RowSc=RowPostObj.%Save()
				s flag=($$$ISOK(RowSc)&&flag)
				i flag=1
				{
					i $tr($g(tmp("PerPostDuty"))," ","")="护士长"
					{
						s roleId=$O(^DHCINM.Set.MgRolesI("desc"," Y"," "_$tr($g(tmp("PerPostDuty"))," ",""),""))
						q:roleId="" "" //获取角色的ID
						s nurheadrw=$o(^DHCINM.Set.MgRoleNurseI("nurse",roleId," "_rowId,""))
						i nurheadrw=""
						{
							s roleObj=##class(DHCINM.Set.MgRoleNurse).%New()
							s roleObj.Parref=##class(DHCINM.Set.MgRoles).%OpenId(roleId)
							i $g(tmp("PerPostDutyDate"))'="" s roleObj.RoleStDate=$zdh($g(tmp("PerPostDutyDate")),3)
							s roleObj.RoleNurse=rowId
							s roleSc=roleObj.%Save()
							s flag=(flag&&$$$ISOK(roleSc))
							i flag=1
							{
								s nurseRoleRw=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,""))
								i nurseRoleRw=""
								{
									s nurObj=##class(DHCINM.HR.MgNurRole).%New()
									s nurObj.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
									s nurObj.RoleID=roleId
									i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s nursc=nurObj.%Save()
									s flag=(flag&&$$$ISOK(nursc))
								}
								else
								{
									s isNurFlag=0,nurRw=""
									s nurSub="" f  s nurSub=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
									.s nurObj=##class(DHCINM.HR.MgNurRole).%OpenId(nurSub)
									.q:nurObj.RoleEndDate'=""
									.s isNurFlag=1
									.s nurRw=nurSub
									i isNurFlag=1
									{
										s rowSub=##class(DHCINM.HR.MgNurRole).%OpenId(nurRw)
										i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s rowSc=rowSub.%Save()
										s flag=(flag&&$$$ISOK(rowSc))
										i flag=1
										{
											s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
											s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
											s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
											s rowSubNew.RoleID=roleId
											s rowNewSc=rowSubNew.%Save()
											s flag=(flag&&$$$ISOK(rowNewSc))
										}
									}
									else
									{
										s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
										s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
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
							s roleSub="" f  s roleSub=$o(^DHCINM.Set.MgRoleNurseI("nurse",roleId," "_rowId,roleSub)) q:roleSub=""  d
							.s roleObj=##class(DHCINM.Set.MgRoleNurse).%OpenId(roleId_"||"_roleSub)
							.s isFlag=1
							.s rw=roleId_"||"_roleSub
							i isFlag=1
							{
								s object=##class(DHCINM.Set.MgRoleNurse).%OpenId(rw)
								i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s roleObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s sc1=roleObj.%Save()
								s flag=(flag&&$$$ISOK(sc1))
							}
							else 
							{
								s object=##class(DHCINM.Set.MgRoleNurse).%New()
								s object.Parref=##class(DHCINM.Set.MgRoles).%OpenId(roleId)
								i $g(tmp("PerPostDutyDate"))'="" s object.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
								s object.RoleNurse=rowId
								s sc2=object.%Save()
								s flag=(flag&&$$$ISOK(sc2))
							}
							i flag=1
							{
								s nurseRoleRw=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,""))
								i nurseRoleRw=""
								{
									s nurObj=##class(DHCINM.HR.MgNurRole).%New()
									s nurObj.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
									s nurObj.RoleID=roleId
									i $g(tmp("PerPostDutyDate"))'="" s nurObj.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
									s nursc=nurObj.%Save()
									s flag=(flag&&$$$ISOK(nursc))
								}
								else
								{
									s isNurFlag=0,nurRw=""
									s nurSub="" f  s nurSub=$o(^DHCINM.HR.MgNurRoleI("role",rowId," "_roleId,nurSub)) q:nurSub=""  d
									.s nurObj=##class(DHCINM.HR.MgNurRole).%OpenId(nurSub)
									.q:nurObj.RoleEndDate'=""
									.s isNurFlag=1
									.s nurRw=nurSub
									i isNurFlag=1
									{
										s rowSub=##class(DHCINM.HR.MgNurRole).%OpenId(nurRw)
										i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSub.RoleEndDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
										s rowSc=rowSub.%Save()
										s flag=(flag&&$$$ISOK(rowSc))
										i flag=1
										{
											s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
											s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
											i $tr($g(tmp("PerPostDutyDate"))," ","")'="" s rowSubNew.RoleStDate=$zdh($tr($g(tmp("PerPostDutyDate"))," ",""),3)
											s rowSubNew.RoleID=roleId
											s rowNewSc=rowSubNew.%Save()
											s flag=(flag&&$$$ISOK(rowNewSc))
										}
									}
									else
									{
										s rowSubNew=##class(DHCINM.HR.MgNurRole).%New()
										s rowSubNew.RolePerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
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

/// Creator:ChenPeng
/// Createdate:2023-05-16
/// Description:导入职称和职务信息
/// Input: {parr:拼接的字符串}
/// Output: 返回处理结果
/// Table: {CF.DHCINM.HR.HireDuty,CF.DHCINM.HR.PostDuty}
/// Debug: w ##class(web.INMImportDBData).ImportPostAndHireDataNew(parr)
ClassMethod ImportPostAndHireDataNew(parr As %String) As %String
{
    s ^TMP("ImportPostAndHireData")=parr
    s tmp="",flag=1
    s nFlag=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
    
    ; 参数准备阶段------------------------------------------------------------------------>
    s PerName=$zcvt($tr($g(tmp("PerName"))," ",""),"U")
    s HISNO=$zcvt($tr($g(tmp("HISNO"))," ",""),"U")
    ; 职称相关字段
    s HireDuty=$zcvt($tr($g(tmp("PerHireDuty"))," ",""),"U")
    s MajorDuty=$zcvt($tr($g(tmp("MajorDuty"))," ",""),"U")
    s HireDutyDR=..GetSetCode("聘任职称",HireDuty)
    s MajorDutyDR=..GetSetCode("聘任职称",MajorDuty) 
    s HireStDate=##class(web.INMHISComm).DateHtmlToLogical($g(tmp("HireStDate")))
    s HireEndDate=##class(web.INMHISComm).DateHtmlToLogical($g(tmp("HireEndDate")))
    s MajorDutyDate=##class(web.INMHISComm).DateHtmlToLogical($g(tmp("MajorDutyDate")))
    ; 职务相关字段
    s PostDuty=$zcvt($tr($g(tmp("PerPostDuty"))," ",""),"U")
    s PostDutyDR=..GetSetCode("职务",PostDuty)
    s PostDutyDate=$tr($g(tmp("PerPostDutyDate"))," ","")
    s PostDutyDate=##class(web.INMHISComm).DateHtmlToLogical(PostDutyDate)
    
    ; 导入数据非空校验------------------------------------------------------------------------>
    q:HISNO="" "-1^0^"_PerName ;"HIS号不能为空"
    q:HireDutyDR="" "-1^1^"_PerName ;"聘任职称不能为空"
    q:MajorDutyDR="" "-1^2^"_PerName ;"专业技术职称不能为空"
    ;q:HireStDate="" "-1^3^"_PerName "聘任开始日期不能为空"
    ;q:MajorDutyDate="" "-1^4^"_PerName ;"专业职称获取日期不能为空"
    q:PostDutyDR="" "-1^3^"_PerName ;"职务不能为空"
    q:PostDutyDate="" "-1^4^"_PerName ;"职务任命日期不能为空"
    s PerDR=$o(^CF.DHCINM.HR.PersonsI("hisno"," "_HISNO,""))
    q:PerDR="" "-1^5^"_PerName ;"HIS号对应的护士不存在"
    s oPerson=##class(CF.DHCINM.HR.Persons).%OpenId(PerDR)
    ; 处理职称保存逻辑------------------------------------------------------------------------>
    s sc=$$$OK
    ts
    s PostRowID=$O(^CF.DHCINM.HR.HireDutyI("date",HireStDate,PerDR,""))
    i PostRowID=""  d
    .s LastPostRw=$o(^CF.DHCINM.HR.HireDutyI("ssid",PerDR,""),-1)
    .i LastPostRw'=""  d
    ..s iHireObj=##class(CF.DHCINM.HR.HireDuty).%OpenId(LastPostRw)
    ..q:'$IsObject(iHireObj)
    ..q:iHireObj.HireEndDate'=""
    ..s iHireObj.HireEndDate=HireEndDate
    ..s sc=sc&&(iHireObj.%Save())
    .; 保存职称信息
    .s hireObj=##class(CF.DHCINM.HR.HireDuty).%New()
    .s hireObj.HirePerDR=oPerson
    .s hireObj.HireStDate=+$h
    .s:HireStDate'="" hireObj.HireStDate=HireStDate
    .s hireObj.HireEndDate=HireEndDate
    .s hireObj.HireDuty=HireDutyDR
    .s hireObj.MajorDuty=MajorDutyDR
    .s hireObj.MajorDutyDate=+$h
    .s:MajorDutyDate'="" hireObj.MajorDutyDate=MajorDutyDate
    .s hireObj.HireStatus="A"
    .s sc=sc&&(hireObj.%Save())
    
    ; 处理职务保存逻辑------------------------------------------------------------------------>
    ; 判断此日期点是否存在记录
    s PostRowID=$O(^CF.DHCINM.HR.PostDutyI("date",PostDutyDate,PerDR,""))
    i PostRowID=""  d
    .s iPostRw="" f  s iPostRw=$o(^CF.DHCINM.HR.PostDutyI("ssid",PerDR,iPostRw)) q:iPostRw=""  d
    ..s iPostObj=##class(CF.DHCINM.HR.PostDuty).%OpenId(iPostRw)
    ..q:iPostObj.PostEndDate'=""
    ..s:iPostObj.PostEndDate="" iPostObj.PostEndDate=PostDutyDate
    ..s sc=sc&&(iPostObj.%Save())
    
    .s PostObj=##class(CF.DHCINM.HR.PostDuty).%New()
    .s PostObj.PostPerDR=oPerson
    .s PostObj.PostDuty=PostDutyDR
    .s PostObj.PostStDate=PostDutyDate
    .s PostObj.PostStatus="A"
    .s sc=sc&&(PostObj.%Save())
    .; 将职务描述作为角色描述, 看是否有对应的角色
    .s UserID=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_PerDR,""))
    .s RoleID=$o(^CT.DHCINM.Set.MgRolesI("desc"," Y"," "_PostDuty,""))
    .i RoleID'="" d
    ..s sc=sc&&(##class(web.INMDBComm).SaveUserRole(RoleID,UserID))
        
    tc:$$$ISOK(sc)
    tro:$$$ISERR(sc)
    
    q:$$$ISOK(sc) tmp("index")
    q:$$$ISERR(sc) "-1^6^"_PerName ;"保存失败"
}

ClassMethod ImportNurseLevel(parr As %String) As %String
{
	s ^TMP("ImportNurseLevel")=parr
	//PerName|ces^HISNO|ces^PerLevel|N0^LevelDate|2018-01-01
	//
	s tmp=""
	s aa=..SplitStr1(parr,"^","|",.tmp)
	s perHisNo=$g(tmp("HISNO")) //护士HIS号
	b ;01
	q:perHisNo="" ""
	s PerLevel=..GetSetCode("护士层级",$zcvt($tr($g(tmp("PerLevel"))," ",""),"U")) //获取职务的记录ID
	s rowId=$o(^CF.DHCINM.HR.PersonsI("hisno"," "_$zcvt($tr($g(tmp("HISNO"))," ",""),"U"),""))
	q:rowId="" "" //人员表ID
	s flag=0,OldRow=""
	s RowID="" f  s RowID=$o(^CF.DHCINM.HR.MgLevelI("ssid",rowId,RowID)) q:RowID=""  d
	.s obj=##class(CF.DHCINM.HR.MgLevel).%OpenId(RowID)
	.q:'$IsObject(obj)
	.s nurseLevel=##class(web.INMPersonComm).GetCommCode(obj.NurLevel)
	.q:nurseLevel=""
	.i $g(tmp("PerLevel"))=nurseLevel d
	..s flag=1
	..s OldRow=RowID
	
	i flag=1 d
	.s LevelObj=##class(CF.DHCINM.HR.MgLevel).%OpenId(OldRow)
	.i $g(tmp("LevelDate"))'="" s LevelObj.LevelDate=$zdh($tr($g(tmp("LevelDate"))," ",""),3)
	.s sc=LevelObj.%Save()
	e  d
	.s LevelObj=##class(CF.DHCINM.HR.MgLevel).%New()
	.s LevelObj.LevelPerDR=##class(CF.DHCINM.HR.Persons).%OpenId(rowId)
	.s LevelObj.LevelStatus="A"
	.i $g(tmp("LevelDate"))'="" s LevelObj.LevelDate=$zdh($tr($g(tmp("LevelDate"))," ",""),3)
	.s LevelObj.NurLevel=PerLevel
	.s sc=LevelObj.%Save()
	
	q 0
}

/// 暂停使用该方法
ClassMethod UpDataMgMergeInfo() As %String
{
	s ssid="" f  s ssid=$o(^DHCINM.DB.MgMergeHisInfoI("ssid",ssid)) q:ssid=""  d
	.s rowid="" f  s rowid=$o(^DHCINM.DB.MgMergeHisInfoI("ssid",ssid,rowid)) q:rowid=""  d
	..s obj=##class(DHCINM.DB.MgMergeHisInfo).%OpenId(rowid)
	..s perobj=##class(CF.DHCINM.HR.Persons).%OpenId($tr(ssid," ",""))
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
	.s NurseRow=$O(^CF.DHCINM.HR.PersonsI("PerID"," "_$zcvt($tr(nurseID," ",""),"U"),""))
	.i NurseRow'="" d
	..s obj=##class(CF.DHCINM.HR.Persons).%OpenId(NurseRow)
	..q:'$IsObject(obj)
	..s obj.PerLocDR=loc
	..d obj.%Save()
	q 0
}

ClassMethod KillTmpError()
{
	k ^TMP("INMImportDBData")
	q 1
}

ClassMethod GetErrorInfor()
{
	q:'$d(^TMP("INMImportDBData")) 1
	s error=""
	s desc=""  f  s desc=$o(^TMP("INMImportDBData",desc)) q:desc=""  d
	.s name=""  f  s name=$o(^TMP("INMImportDBData",desc,name)) q:(name="")  d
	..s:error'="" error=error_","_name
	..s:error="" error=name
	.s error=error_"【"_desc_"】"	
	q error
}

}
