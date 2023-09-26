Class web.DHCEMNurMessageInterface Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// patType: ""/obs/em (所有/留抢/流水)
/// page,rows,model: 不为空输出列表;消息调用会都是空
/// w ##class(web.DHCEMNurMessageInterface).ordTypeNumber("kfd")
ClassMethod ordTypeNumber(inOrdType, patType = "", page = 1, rows = 20, model = "", params = "")
{
	s ^qqa("ordTypeNumber")=$lb(inOrdType, patType, page, rows, model, params)
	s ordType=$p(params,"^",8)
	s:ordType'="" inOrdType=ordType
	
	s StartDate=$p(params,"^",1)
	s EndDate=$p(params,"^",2)
	s:StartDate'="" StartDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	s:EndDate'="" EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:StartDate="" StartDate=+$h-2
	s:EndDate="" EndDate=+$h
	
	s code=200,data="",msg=""
	s date=+$h,ord=0
	;s StartDate=+$h-2, EndDate=+$h
	F dd=StartDate:1:EndDate  D
	.s ord=""
	.F  s ord=$o(^OEORDi(0,"StDt",dd,ord)) Q:ord=""  D
	..q:ord=""
	..s admId = +^OEORD(ord)	
	..s admType=$p(^PAADM(admId),"^",2)
	..Q:admType'="E"
	..s admWardId=$p(^PAADM(admId),"^",70)
	..Q:(patType="obs")&&(+admWardId=0)
	..Q:(patType="em")&&(+admWardId'=0)
	..s PatientID=$p(^PAADM(admId),"^",1)
	..s objpat=##class(User.PAPatMas).%OpenId(PatientID,0)
	..i $ISOBject(objpat) d
	...s h=objpat.ChildPAAllergy.Count()
	...i +h>0 d $i(TMPData("ordTypeNumber","gmjl")) // 过敏记录
	..s itm=0
	..f  s itm = $o(^OEORDi(0,"StDt",dd,ord,itm)) q:itm=""  D
	...s phcinDesc = ##class(web.DHCEMOrdInfoVO).getPhcinDesc(ord,itm)
	...s ordType=##class(web.DHCEMShowOrdNum).GetOECCatByOEORDItmDr(ord_"||"_itm)
    ...s arciName = ##class(web.DHCEMOrdInfoVO).getArcimDesc(ord,itm)
	...s arciCatDesc = ##class(web.DHCEMShowOrdNum).GetARCICatByOEORDItmDr(ord_"||"_itm)
	...s labNo=$p($g(^OEORD(ord,"I",itm,3)),"^",20)
	...s isPs = ##class(web.DHCEMSkinTest).IsSkinOrder(ord,itm)	
   	...i labNo'="" D
	....d $i(TMPData("ordTypeNumber","jyd"))
	....s TPMData("ordTypeNumber","jyd",ord_"||"_itm)=""	
	...i isPs=1  D
	....d $i(TMPData("ordTypeNumber","psd"))	
	....s TPMData("ordTypeNumber","psd",ord_"||"_itm)=""
    ...
	...i phcinDesc["静脉滴注" D
	....d $i(TMPData("ordTypeNumber","syd"))
	....s TPMData("ordTypeNumber","syd",ord_"||"_itm)=""
	...
	...i ordType["处置治疗" D
	....d $i(TMPData("ordTypeNumber","zld"))
	....s TPMData("ordTypeNumber","zld",ord_"||"_itm)=""
	...
	...i phcinDesc["口服" D
	....d $i(TMPData("ordTypeNumber","kfd"))
	....s TPMData("ordTypeNumber","kfd",ord_"||"_itm)=""
	...
	...i (phcinDesc["检查")!(ordType["检查") D
	....d $i(TMPData("ordTypeNumber","jcd"))
	....s TPMData("ordTypeNumber","jcd",ord_"||"_itm)=""
	...
	...i phcinDesc["注射" D
	....d $i(TMPData("ordTypeNumber","zsd"))
	....s TPMData("ordTypeNumber","zsd",ord_"||"_itm)=""
	...
	...i (arciName["采血")!(arciName["红细胞") D
	....d $i(TMPData("ordTypeNumber","sxd"))
	....s TPMData("ordTypeNumber","sxd",ord_"||"_itm)=""	
	...
	...// 需关注 bianshuai 2022-11-08
	...i 1 D
	....d $i(TMPData("ordTypeNumber","xgz"))
	...
	// 测试数据 后期删除  bianshuai 2022-11-08
#;	s TMPData("ordTypeNumber","jyd")=1
#;	s TMPData("ordTypeNumber","psd")=2
#;	s TMPData("ordTypeNumber","syd")=3
#;	s TMPData("ordTypeNumber","zld")=4
#;	s TMPData("ordTypeNumber","kfd")=5
#;	s TMPData("ordTypeNumber","jcd")=6
#;	s TMPData("ordTypeNumber","zsd")=7
#;	s TMPData("ordTypeNumber","sxd")=8
#;	s TMPData("ordTypeNumber","xgz")=9
#;  s TMPData("ordTypeNumber","gmjl")=23
	s:inOrdType'="" data = +$g(TMPData("ordTypeNumber",inOrdType))

    q:model="" ##class(web.DHCEMDocMessageInterface).hosMessageResponse(code,data,msg)

    s st=page-1*rows+1
	s end=page*rows
	s inChkLev=$p(params,"^",3)
  	s inPatNo=$p(params,"^",4)
  	s inCardNo=$p(params,"^",5)
  	s inAdmLoc=$p(params,"^",6)
  	s inEmWardId=$p(params,"^",7)
	s ordType=$p(params,"^",8)
	
	b ;>>>
    s count=0
	w "{""rows"":["
	s title="admId^patientId^patNo^patName^patSex^patBDay^patAge^admDate^admTime^deposit^admLoc^admDoc^admPriority^emNurLev^emPCLvArea^admWard^admBed^diagnosis"
	s title=title_"^walkStatus^regDoctor^billType^emPatGreFlag^emPCLvNurse"
	s title=title_"^arciName^sttDate^sttTime^ctcpDesc"
    s ordItem=""
    f {
		s ordItem = $o(TPMData("ordTypeNumber",inOrdType,ordItem))
		q:ordItem=""
		b ;1
		s ord=+ordItem,itm=$p(ordItem,"||",2)
		
		s admId=+^OEORD(+ordItem)
		s patientId = $p(^PAADM(admId),"^",1)
		s patName=$p(^PAPER(patientId,"ALL"),"^",1)
		s patNo=$p(^PAPER(patientId,"PAT",1),"^",1)       //登记号
		continue:(inPatNo'="")&&(patNo'[inPatNo)
		s patSex=""
		s sexId=$p(^PAPER(patientId,"ALL"),"^",7)         //姓别
		i sexId'="" s patSex=$p(^CT("SEX",sexId),"^",2)
		s patBDay=$p(^PAPER(patientId,"ALL"),"^",6)       //出生日期
		i patBDay'="" s patBDay=$zd(patBDay,3)
		s patAge=##Class(web.DHCSTKUTIL).GetAge(patientId)  //年龄
		s admCacheDate=$P($g(^PAADM(admId)),"^",6)
		s admCacheTime=$P($g(^PAADM(admId)),"^",7)
		s admDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(admCacheDate)  //就诊日期
		s admTime=$ZT(admCacheTime,2)  //就诊时间
		s deposit=##class(web.UDHCJFBaseCommon).deposit(admId) // 患者未结算押金总额
		s admNo=$P($g(^PAADM(admId)),"^",81)          
		s admLocId=$P($g(^PAADM(admId)),"^",4)
		continue:(inAdmLoc'="")&&(admLocId'=inAdmLoc)
		s admLoc=$P($g(^CTLOC(admLocId)),"^",2)
		i admLoc["-" s admLoc=$p(admLoc,"-",2)
		s admDocId=$P($g(^PAADM(admId)),"^",9)
		s admDoc=$P($g(^CTPCP(+admDocId,1)),"^",2)
		s billType=$p(^PAPER(patientId,"PER",1),"^",10)                        /// 费别
		s:billType'="" billType=$p(^CT("SS",billType),"^",2)
		s admPriority=""                        /// 优先级、优先级代码、背景色
		s priority=$P($g(^PAADM(admId)),"^",33)
		s priorityColor=""
		i priority'="" s admPriority=$p($g(^CT("ACU",priority)),"^",1)
		s:priority="" priority=5                                             /// 排序字段为空设置为5
		continue:(inChkLev'="")&&(+admPriority'=inChkLev)
		s emPCLvArea=$s(admPriority="1级":"红区",admPriority="2级":"橙区",admPriority="3级":"黄区",admPriority="4级":"绿区",admPriority="5级":"绿区",1:"")
		s emNurLev=##Class(web.DHCEMDocMainOutPat).GetEmPatCheckLev(admId)
		
		s wardDr=$P($g(^PAADM(admId)),"^",70)                                    /// 
		continue:(inEmWardId'="")&&(wardDr'=inEmWardId)
		s admWard=$P($g(^PAWARD(+wardDr)),"^",2)                       /// 病区
		s:admWard["-" admWard=$p(admWard,"-",2)
		s bedId=$P($g(^PAADM(admId)),"^",73)
		s admBed=""
		I bedId'="" s admBed=$P($g(^PAWARD(+bedId,"BED",$P(bedId,"||",2))),"^",1)  /// 床号
		s diagnosis=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(admId,"","")
		s walkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(admId)       /// 当前状态
		i walkStatus'="" Set walkStatus=$P(walkStatus,"^",2)
		s queRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",admId,""))
		s queObj=##Class(User.DHCQueue).%OpenId(queRowId,0)
		s regDocCode="", regDoctor=""
		s regDocDr=queObj.QueMarkDr.%Id()
		i regDocDr'="" D
		.Set regDoctor=$P($g(^CTPCP(regDocDr,1)),"^",2)
		.Set regDocCode=$P($g(^CTPCP(regDocDr,1)),"^",1)
		s emPatGreFlag=##Class(web.DHCEMDocMainOutPat).GetEmPatGreenFlag(admId) /// 绿色通道标示
		s emPCLvNurse=##Class(web.DHCEMDocMainOutPat).GetEmPCLvNurse(admId)     /// 分级护士
		
		s admType=$p(^PAADM(admId),"^",2)                     //就诊类型
		s arciName = ##class(web.DHCEMOrdInfoVO).getArcimDesc(ord,itm)   //  医嘱名称
		s sttDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9) 
    	s sttTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)	
    	s sttDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(sttDate)
    	s sttTime=$zt(sttTime,2)
    	s ctcpDesc=##class(web.DHCEMOrdInfoVO).getCtcpDesc(ord,itm)
    	
    	s count=count+1
		continue:count<st
		continue:count>end
		s itm = admId_"^"_patientId_"^"_patNo_"^"_patName_"^"_patSex_"^"_patBDay_"^"_patAge_"^"_admDate_"^"_admTime_"^"_deposit_"^"_admLoc_"^"_admDoc_"^"_admPriority_"^"_emNurLev_"^"_emPCLvArea
		s itm = itm_"^"_admWard_"^"_admBed_"^"_diagnosis_"^"_walkStatus_"^"_regDoctor_"^"_billType_"^"_emPatGreFlag_"^"_emPCLvNurse
		s itm = itm_"^"_arciName_"^"_sttDate_"^"_sttTime_"^"_ctcpDesc
		w $case(count,st:"",:",")
		w ##class(web.DHCAPPJsonCommon).getJsonData(title,itm)
	}
    w "],""total"":"_count
	w "}"
	q ""
}

/// Others：w ##class(web.DHCEMNurMessageInterface).GetAnalysessData()
ClassMethod GetAnalysessData(HospID = "")
{
	n (HospID,%session)
	s StDate="" //"2019-11-01"
	s EndDate=""
	s HospID =%session.Get("LOGON.HOSPID")
	s:StDate'="" StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s:EndDate'="" EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:StDate="" StDate=+$h
	s:EndDate="" EndDate=+$h
	s GetCheckPatNum=..GetCheckPatNum(StDate, EndDate,HospID)
	s ThreeNoPatNum=..GetThreeNoPatNum(StDate, EndDate,HospID)
	s GreenPatNum=..GetGreenPatNum(StDate, EndDate,HospID)
	s PatGetSource=..PatGetSource(StDate, EndDate,HospID)
	s PatAgeAnalysess=..PatAgeAnalysess(StDate, EndDate,HospID)
	s PatCheckLocNum=..PatCheckLocNum(StDate, EndDate,HospID)
	/*s tmpObj={}
	s tmpObj.GetCheckPatNum=GetCheckPatNum
	s tmpObj.ThreeNoPatNum=ThreeNoPatNum
	s tmpObj.GreenPatNum=GreenPatNum
	s tmpObj.PatGetSource=PatGetSource
	s tmpObj.PatAgeAnalysess=PatAgeAnalysess
	s tmpObj.PatCheckLocNum=PatCheckLocNum
	b ;c12*/
	
	s Obj=##class(web.DHCAPPJsonObject).%New()
	d Obj.Put("GetCheckPatNum",GetCheckPatNum)
	d Obj.Put("ThreeNoPatNum",ThreeNoPatNum)
	d Obj.Put("GreenPatNum",GreenPatNum)
	d Obj.Put("PatGetSource",PatGetSource)
	d Obj.Put("PatAgeAnalysess",PatAgeAnalysess)
	d Obj.Put("PatCheckLocNum",PatCheckLocNum)

	b ;c12
	w Obj.Json()

	q ""
	;q tmpObj
}

/// Others：w ##class(web.DHCEMNurMessageInterface).GetCheckPatNum("2022-01-01","","2")
ClassMethod GetCheckPatNum(StDate, EndDate, HospID)
{
	n (StDate,EndDate,HospID)
	s AllCheckNum=0,RedCheckNum=0,YellowCheckNum=0,GreenCheckNum=0,OrangeCheckNum=0 //hxy 2020-02-21
	
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	..s NurCheckLev = $p(^DHCEMPCL(PCLRowID),"^",7)    //护士分级
 	..s AllCheckNum =AllCheckNum+1
 	..s:NurCheckLev=1 RedCheckNum=RedCheckNum+1
 	..s:NurCheckLev=2 OrangeCheckNum=OrangeCheckNum+1 //hxy 2020-02-21 原：RedCheckNum=RedCheckNum+1
 	..s:NurCheckLev=3 YellowCheckNum=YellowCheckNum+1
 	..s:NurCheckLev=4 GreenCheckNum=GreenCheckNum+1
 	..s:NurCheckLev=5 GreenCheckNum=GreenCheckNum+1 //hxy 2020-02-21 add
 	
 	s List= ##class(web.DHCEMJsonCommon).getJsonDataEcharts("AllCheckNum^RedCheckNum^YellowCheckNum^GreenCheckNum^OrangeCheckNum",AllCheckNum_"^"_RedCheckNum_"^"_YellowCheckNum_"^"_GreenCheckNum_"^"_OrangeCheckNum)	
 	b ;c1
 	q List
}

/// 
/// Return:分诊科室所属医院id
ClassMethod GetPCLHosp(PCLRowID)
{
	n (PCLRowID)
	q:+PCLRowID=0 ""
	s PCCRowID=$o(^DHCEMPCC(0,"PatCheckLev",PCLRowID,""))
 	s LocInHosp=""
 	i +PCCRowID'=0 d
 	.s CheckLoc = $p(^DHCEMPCC(PCCRowID),"^",3)
 	.q:+CheckLoc=0
 	.s LocInHosp = $p(^CTLOC(CheckLoc),"^",22)
 	q LocInHosp
}

/// 年龄统计数据
/// w ##class(web.DHCEMNurMessageInterface).PatAgeAnalysess("2018-01-19","2022-11-30")
ClassMethod PatAgeAnalysess(StDate, EndDate, HospID)
{
	n (StDate,EndDate ,HospID)
	q:(StDate="")!(EndDate="") "[]"
	s Age1=0,Age2=0,Age3=0,Age4=0,Age5=0,Age6=0,Age7=0,Age8=0,Age9=0,Age10=0,Age11=0,Age12=0
	;s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	;s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	..s PatDr = $p(^DHCEMPCL(PCLRowID),"^",1)
 	..q:+PatDr=0                                  //病人ID为空未错误数据
 	..s PatAge = ##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID(PCLRowID)
 	..i PatAge'["岁"  d
 	...s PatAge=0
 	..i PatAge["岁"  d
 	...s PatAge = $p(PatAge,"岁",1)
 	..s:PatAge=0 Age1=Age1+1
 	..s:(0<PatAge)&&(PatAge<=15) Age2=Age2+1
 	..s:(15<PatAge)&&(PatAge<=30) Age3=Age3+1
 	..s:(30<PatAge)&&(PatAge<=40) Age5=Age5+1
 	..s:(40<PatAge)&&(PatAge<=50) Age6=Age6+1
 	..s:(50<PatAge)&&(PatAge<=60) Age7=Age7+1
 	..s:(60<PatAge)&&(PatAge<=70) Age8=Age8+1
 	..s:(70<PatAge)&&(PatAge<=80) Age9=Age9+1
 	..s:(80<PatAge)&&(PatAge<=90) Age10=Age10+1
 	..s:(90<PatAge)&&(PatAge<=100) Age11=Age11+1
 	..s:(100<PatAge) Age12=Age12+1
#; 	s:Age1=0 Age1=30
#; 	s:Age2=0 Age2=117
#; 	s:Age3=0 Age3=129
#; 	s:Age5=0 Age5=219
#; 	s:Age6=0 Age6=321
#; 	s:Age7=0 Age7=201
#; 	s:Age8=0 Age8=161
#; 	s:Age9=0 Age9=220
#; 	s:Age10=0 Age10=281
#; 	s:Age11=0 Age11=23
#; 	s:Age12=0 Age12=3
 	
 	s list= "["_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","<1^"_Age1_"^年龄")
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","1-15^"_Age2_"^年龄")
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","15-30^"_Age3_"^年龄")
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","30-40^"_Age5_"^年龄")
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","40-50^"_Age6_"^年龄")
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","50-60^"_Age7_"^年龄")
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","60-70^"_Age8_"^年龄")
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","70-80^"_Age9_"^年龄")
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","80-90^"_Age10_"^年龄")
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group","90-100^"_Age11_"^年龄")
	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",">100^"_Age12_"^年龄")
 	s list= list_"]"
	q list
}

/// 三无人员统计数据
/// w ##class(web.DHCEMNurMessageInterface).GetThreeNoPatNum("2018-01-19","2022-11-30","2")
ClassMethod GetThreeNoPatNum(StDate, EndDate, HospID)
{
	n (StDate,EndDate,HospID)
	q:(StDate="")!(EndDate="") "[]"
	s RedAreaNum=0,YellowAreaNum=0,GreenAreaNum=0,OrangeAreaNum=0 //hxy 2020-02-21
	;s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	;s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	..s PatTypeDesc=""
 	..s PatTypeDr= $p(^DHCEMPCL(PCLRowID),"^",40)
 	..s:+PatTypeDr'=0 PatTypeDesc = $p($g(^DHCEMPT(PatTypeDr)),"^",2)
 	..s NurCheckLev = $p(^DHCEMPCL(PCLRowID),"^",7)    //护士分级
 	..i PatTypeDesc["三无人员" d
 	...;s:(NurCheckLev=1)!(NurCheckLev=2) RedAreaNum=RedAreaNum+1 //hxy 2020-02-21 st
 	...;s:(NurCheckLev=3) YellowAreaNum=YellowAreaNum+1
 	...;s:(NurCheckLev=4) GreenAreaNum=GreenAreaNum+1
 	...s:(NurCheckLev=1) RedAreaNum=RedAreaNum+1
 	...s:(NurCheckLev=2) OrangeAreaNum=OrangeAreaNum+1
 	...s:(NurCheckLev=3) YellowAreaNum=YellowAreaNum+1
 	...s:(NurCheckLev=4)!(NurCheckLev=5) GreenAreaNum=GreenAreaNum+1 //ed
 	
 	s Del=""""
 	s ItmRedColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#F16E57"_Del_"}}"
 	s ItmYellowColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#FFB746"_Del_"}}"
 	s ItmGreenColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#2AB66A"_Del_"}}"
 	s ItmOrangeColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"orange"_Del_"}}" //hxy 2020-02-21
#; 	s:RedAreaNum=0 RedAreaNum=36
#; 	s:OrangeAreaNum=0 OrangeAreaNum=55
#; 	s:YellowAreaNum=0 YellowAreaNum=28
#; 	s:GreenAreaNum=0 GreenAreaNum=34
 	s list= "["_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","红区^"_RedAreaNum)
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","橙区^"_OrangeAreaNum) //hxy 2020-02-21 st
 	s list= list_","_ ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","黄区^"_YellowAreaNum)
 	s list= list_","_ ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","绿区^"_GreenAreaNum)
 	s list= list_"]"
	q list
}

/// 绿色通道人员统计数据
/// w ##class(web.DHCEMNurMessageInterface).GetGreenPatNum("2018-08-01","2018-08-31","")
ClassMethod GetGreenPatNum(StDate, EndDate, HospID)
{
	n (StDate,EndDate ,HospID)
	q:(StDate="")!(EndDate="") "[]"
	s RedAreaNum=0,YellowAreaNum=0,GreenAreaNum=0,OrangeAreaNum=0 //hxy 2020-02-21
	;s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	;s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(HospID'="")&&(LocInHosp'=HospID)
 	..s ChkAdmID = $o(^DHCEMPCA(0,"PatCheckLev",PCLRowID,""),-1)
 	..q:ChkAdmID=""
 	..s Adm= $p(^DHCEMPCA(ChkAdmID),"^",2)
 	..q:Adm=""
 	..;s EmPatGreFlag=$p($g(^PAADM(Adm)),"^",5)
 	..s EmPatGreFlag=##Class(web.DHCEMPatCheckLev).GetEmPatGreenFlag(PCLRowID,"")
 	..s NurCheckLev = $p(^DHCEMPCL(PCLRowID),"^",7)    //护士分级
 	..i EmPatGreFlag=1 d
 	...;s:(NurCheckLev=1)!(NurCheckLev=2) RedAreaNum=RedAreaNum+1 //hxy 2020-02-21 st
 	...;s:(NurCheckLev=3) YellowAreaNum=YellowAreaNum+1
 	...;s:(NurCheckLev=4) GreenAreaNum=GreenAreaNum+1
 	...s:(NurCheckLev=1) RedAreaNum=RedAreaNum+1
 	...s:(NurCheckLev=2) OrangeAreaNum=OrangeAreaNum+1
 	...s:(NurCheckLev=3) YellowAreaNum=YellowAreaNum+1
 	...s:(NurCheckLev=4)!(NurCheckLev=5) GreenAreaNum=GreenAreaNum+1 //ed
 	
 	s Del=""""
 	s ItmRedColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#F16E57"_Del_"}}"
 	s ItmYellowColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#FFB746"_Del_"}}"
 	s ItmGreenColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"#2AB66A"_Del_"}}"
 	s ItmOrangeColor = "{"_Del_"normal"_Del_":{"_Del_"color"_Del_":"_Del_"orange"_Del_"}}" //hxy 2020-02-21
#; 	s:RedAreaNum=0 RedAreaNum=58
#; 	s:OrangeAreaNum=0 OrangeAreaNum=35
#; 	s:YellowAreaNum=0 YellowAreaNum=20
#; 	s:GreenAreaNum=0 GreenAreaNum=28
 	
 	s list= "["_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","红区^"_RedAreaNum)
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","橙区^"_OrangeAreaNum) //hxy 2020-02-21
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","黄区^"_YellowAreaNum)
 	s list= list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","绿区^"_GreenAreaNum)
 	s list= list_"]"
	q list
}

/// 病人来源统计数据
/// w ##class(web.DHCEMNurMessageInterface).PatGetSource("2018-01-19","2018-01-19")
ClassMethod PatGetSource(StDate, EndDate, HospID)
{
	n (StDate,EndDate ,HospID)
	q:(StDate="")!(EndDate="") "[]"
	s Pid = $i(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource")
	;s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	;s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	
	s DHCEMPsoDr="0"
	f  s DHCEMPsoDr =$o(^DHCEMPSO(DHCEMPsoDr)) q:DHCEMPsoDr=""  d
	.s DHCEMPsoDesc= $p(^DHCEMPSO(DHCEMPsoDr),"^",2)
	.s DHCEMPsoStatus= $p(^DHCEMPSO(DHCEMPsoDr),"^",3)
	.s DHCEMPsoHospID= $p(^DHCEMPSO(DHCEMPsoDr),"^",4)
	.q:DHCEMPsoStatus'="Y"
	.;q:(HospID'="")&&(DHCEMPsoHospID'=HospID) //hxy 2020-06-09 注释
	.q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatSource",DHCEMPsoDr,HospID)'="Y" //hxy 2020-06-09 
	.s ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,DHCEMPsoDesc)=0
	
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s LocInHosp = ..GetPCLHosp(PCLRowID)
 	..q:(LocInHosp'="")&&(LocInHosp'=HospID)
 	..s EmPatSourceDesc=""
 	..s EmPatSource=$p(^DHCEMPCL(PCLRowID),"^",15)
 	..s:EmPatSource'="" EmPatSourceDesc =$p($g(^DHCEMPSO(EmPatSource)),"^",2)
 	..q:EmPatSourceDesc=""
	..q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("DHC_EmPatSource",EmPatSource,HospID)'="Y" //hxy 2020-06-09
	..s ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,EmPatSourceDesc)=^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,EmPatSourceDesc)+1
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"110")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"110")=48
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"120")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"120")=75
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"外院")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"外院")=58
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"护送来院")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"护送来院")=84
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"救助站")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"救助站")=44
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"自行来院")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"自行来院")=25
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"未知")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,"未知")=49
	
	s Count=0
	s list= "["
	s EmPatSourceDesc="" 
	f  s EmPatSourceDesc = $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,EmPatSourceDesc)) q:EmPatSourceDesc=""  d
	.s Num = ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid,EmPatSourceDesc)
	.s Name = EmPatSourceDesc
	.s Data = Name_"^"_Num_"^"_"病人来源"
 	.;w $case(Count,0:"",Count:",")
 	.s:Count=0 list=list_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",Data)
 	.s:Count'=0 list=list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",Data)
 	.s Count =Count+1
 	.;W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",Data)
 	s list=list_ "]"
 	k ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatGetSource",Pid)
	q list
}

/// 分诊科室统计数据
/// w ##class(web.DHCEMNurMessageInterface).PatCheckLocNum("66605","66605",2)
ClassMethod PatCheckLocNum(StDate, EndDate, HospID)
{
	n (StDate,EndDate,HospID)
	
	q:(StDate="")!(EndDate="") "[]"
	s Pid = $i(^CacheTemp)
	k ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc")
	;s StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	;s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s ChkAdmID = $o(^DHCEMPCA(0,"PatCheckLev",PCLRowID,""),-1)
 	..s Adm=$p($g(^DHCEMPCA(+ChkAdmID)),"^",2)
 	..s CheckLoc = $p($g(^PAADM(+Adm)),"^",4)
 	..i CheckLoc="" d
 	...s PCCRowID=$o(^DHCEMPCC(0,"PatCheckLev",PCLRowID,""))
 	...s CheckLoc = $p($g(^DHCEMPCC(+PCCRowID)),"^",3)
 	..q:CheckLoc="" 
 	..s LocInHosp = $p(^CTLOC(CheckLoc),"^",22)
 	..q:(HospID'="")&&(LocInHosp'=HospID)
 	..s CheckLocDesc = $p(^CTLOC(CheckLoc),"^",2)
 	..q:CheckLocDesc=""
	..i $d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,CheckLocDesc))=0 d
	...s ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,CheckLocDesc)=1
	..e  d
	...s ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,CheckLocDesc)=^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,CheckLocDesc)+1
	
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊内科门诊")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊内科门诊")=108
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊外科门诊")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊外科门诊")=115
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊儿科门诊")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊儿科门诊")=80
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊妇科门诊")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊妇科门诊")=34
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊产科门诊")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊产科门诊")=14
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊耳鼻喉科门诊")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,"急诊耳鼻喉科门诊")=32
	
	s Count=0
	s list= "["
	s CheckLocDesc="" 
	f  s CheckLocDesc = $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,CheckLocDesc)) q:CheckLocDesc=""  d
	.s Num = ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid,CheckLocDesc)
	.s Name = CheckLocDesc
	.s Data = Name_"^"_Num_"^"_"分诊科室"
 	.;w $case(Count,0:"",Count:",")
 	.s:Count=0 list=list_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",Data)
 	.s:Count'=0 list=list_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",Data)
 	
 	.s Count =Count+1
 	.;W ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value^group",Data)
 	s list=list_ "]"
 	k ^TMP("DHCEM","web.DHCEMNurMessageInterface","PatCheckLoc",Pid)
	q list
}

/// w ##class(web.DHCEMNurMessageInterface).GetObsAreaAnaData()
ClassMethod GetObsAreaAnaData()
{
	
	n (%session)
	s StDate=""
	s EndDate=""
	s HospID =%session.Get("LOGON.HOSPID") 
	s:StDate'="" StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s:EndDate'="" EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:StDate="" StDate=+$h
	s:EndDate="" EndDate=+$h

	s Pid = ##Class(web.DHCEMInterfaceCom).NewPid() //hxy 2020-04-03
	k ^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid)
	f Date=StDate:1:EndDate  d 
  	.s Time=""
 	.f  s Time=$o(^PAADMi("TransDateTime",Date,Time))   Q:Time=""  D
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TransDateTime",Date,Time,EpisodeID))   Q:EpisodeID=""  D    //按照就诊改变状态插入记录:这个是在安排床位的时候插入的表格
 	...q:$p(^PAADM(EpisodeID),"^",2)'="E"
 	...s PatWarDr=$p(^PAADM(EpisodeID),"^",70)              //用来判断病人是否留观
 	...q:+PatWarDr=0                            			//为空代表没有留观
 	...s PatWarDesc = $p(^PAWARD(PatWarDr),"^",2)
 	...s:PatWarDesc["-" PatWarDesc = $p(PatWarDesc,"-",2)
	...s LocID = $p(^PAWARD(PatWarDr),"^",5)				//病区所所属的科室
	...s LocHospID = $p(^CTLOC(LocID),"^",22)
	...q:(HospID'="")&&(HospID'=LocHospID)                  //
	...Q:$p(^CTLOC(LocID),"^",13)'="EM"
    ...Q:'$o(^PAWARD(PatWarDr,"ROOM",0))
	...s ^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)=""    //获取时间段内办理留观的就诊
	...;以上是用来获取历史进入留观室的人
	
	s WardID=0
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s PatWarDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .Q:LocID=""
    .Q:$p(^CTLOC(LocID),"^",13)'="EM"
    .Q:'$o(^PAWARD(WardID,"ROOM",0))
    .Q:$p(^CTLOC(LocID),"^",22)'=HospID
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.Q:((+$h<StDate)&&(StDate'=""))!((+$h>EndDate)&&(EndDate'=""))
	.s:PatWarDesc["-" PatWarDesc=$p(PatWarDesc,"-",2)
	.S HasPatNum=0   //用来记录当前床位使用情况
	.s BedSub=0
	.f  s BedSub = $o(^PAWARD(WardID,"BED",BedSub)) q:BedSub=""  d
	..s BedAdmSub = $o(^PAWARDA(WardID,"BED",BedSub,"ADM",0))
	..i BedAdmSub'="" d
	...s HasPatNum=HasPatNum+1
	...s EpisodeID = $p(^PAWARDA(WardID,"BED",BedSub,"ADM",BedAdmSub),"^",1)
	...q:'$d(^PAADM(EpisodeID))
	...s ^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)=""  
	...;当前在留观室的病人
	.s ^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc) = HasPatNum
	b ;data
	;s QsPatNum=..PatCheckLevNum(Pid)
	;s ParseInPatNum=..ParseInPatNum(Pid)
	;s KeyDiseasePatNum=..KeyDiseasePatNum(Pid)
	;s InLocPatNum=..InLocPatNum(Pid)
	;s Obj=##class(web.DHCAPPJsonObject).%New()
	;d Obj.Put("QsPatNum",QsPatNum)
	;d Obj.Put("ParseInPatNum",ParseInPatNum)
	;d Obj.Put("KeyDiseasePatNum",KeyDiseasePatNum)
	;d Obj.Put("InLocPatNum",InLocPatNum)
	;w Obj.Json()
	s Del=""""
	w "{"
	w Del_"QsPatNum"_Del_":" //分级人数
	d ..PatCheckLevNum(Pid)
	w ","
	s ParseInPatStr=..ParseInPatNum(Pid)
	w Del_"ParseInPat"_Del_":"_$p(ParseInPatStr,"^",1) //转入院科室
	w ","
	w Del_"ParseInPatNum"_Del_":"_$p(ParseInPatStr,"^",2) //转入院科室统计
	w ","
	w Del_"KeyDiseasePatNum"_Del_":" //重点病种分布
	d ..KeyDiseasePatNum(Pid)
	w ","
	s InLocPatStr=..InLocPatNum(Pid)
	w Del_"InLocPat"_Del_":"_$p(InLocPatStr,"^",1) //在科状态
	w ","
	w Del_"InLocPatNum"_Del_":"_$p(InLocPatStr,"^",2) //在科状态统计
	w ","
	s StaPatNumStr=..ListObservationPatient()
	w Del_"StaPat"_Del_":"_$p(StaPatNumStr,"^",1) //留观患者
	w ","
	w Del_"StaPatNum"_Del_":"_$p(StaPatNumStr,"^",2) //留观患者统计
	w ","
	w Del_"NurWorLoadNum"_Del_":" //本周工作量
	d ..NurWorLoad()
	
	w "}"
	k ^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid)
	q ""
}

/// 获取留观室人数
ClassMethod ObsPatNum(Pid)
{
	n (Pid)
	s Ret=""
	s PatWarDesc="" 
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s AllNum=0
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
	..s AllNum = AllNum+1
	.s Data = PatWarDesc_"^"_AllNum
	.s:Ret'="" Ret=Ret_":"_Data
	.s:Ret="" Ret=Data
	q Ret
}

ClassMethod PatCheckLevNum(Pid)
{
	n (Pid)
	s NoCheckPatNum=0,RedAreaPatNum=0,YellowAreaPatNum=0,GreenAreaPatNum=0,OrangeAreaPatNum=0 //hxy 2020-02-21
	s PatWarDesc="" 
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
	..s PatCheckLevInfo = ##Class(web.DHCEMECheck).GetEmPatCheckLevGrade(EpisodeID)
	..s NurCheckLev = $p(PatCheckLevInfo,"^",2)
	..s:+NurCheckLev=0 NoCheckPatNum=NoCheckPatNum+1
	..i +NurCheckLev'=0 d
 	...;s:(NurCheckLev=1)!(NurCheckLev=2) RedAreaPatNum=RedAreaPatNum+1 //hxy 2020-02-21 st
 	...;s:(NurCheckLev=3) YellowAreaPatNum=YellowAreaPatNum+1
 	...;s:(NurCheckLev=4) GreenAreaPatNum=GreenAreaPatNum+1
 	...s NurCheckLev=+NurCheckLev
 	...s:(NurCheckLev=1) RedAreaPatNum=RedAreaPatNum+1
 	...s:(NurCheckLev=2) OrangeAreaPatNum=OrangeAreaPatNum+1
 	...s:(NurCheckLev=3) YellowAreaPatNum=YellowAreaPatNum+1
 	...s:(NurCheckLev=4)!(NurCheckLev=5) GreenAreaPatNum=GreenAreaPatNum+1 //ed
 	
#; 	s:RedAreaPatNum=0 RedAreaPatNum=1048
#; 	s:OrangeAreaPatNum=0 OrangeAreaPatNum=735
#; 	s:YellowAreaPatNum=0 YellowAreaPatNum=580
#; 	s:GreenAreaPatNum=0 GreenAreaPatNum=484
 	
 	w "["
 	;W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","未分级^"_NoCheckPatNum)
 	;w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","红区^"_RedAreaPatNum)
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","橙区^"_OrangeAreaPatNum) //hxy 2020-02-21
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","黄区^"_YellowAreaPatNum)
 	w ","
 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","绿区^"_GreenAreaPatNum)
 	w "]"
	q ""
}

/// Descript:获取PAADM状态改变中包含转入院状态的PAADM
/// d ##class(web.DHCEMNurMessageInterface).ParseInPatNum("139390")
ClassMethod ParseInPatNum(Pid)
{
	n (Pid)
	s NewPid = ##Class(web.DHCEMInterfaceCom).NewPid()
	k ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable")
	s PatWarDesc="" 
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
	..s InWardDesc=""
	..s NextAdm = ##class(web.DHCEMPatCheckLevStat).GetNextAdm(EpisodeID)
	..s AdmType=""
	..s:NextAdm'="" AdmType= $p(^PAADM(NextAdm),"^",2)
	..s:AdmType'="I" InWardDesc="未入院"
	..;s PatCurStatusDr=""
	..;f  s PatCurStatusDr=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,PatCurStatusDr),-1) q:(PatCurStatusDr="")||(InWardDesc'="")  d
	...;s StatusDr = $p(^DHCADMVisitStatus(PatCurStatusDr),"^",2)
	...;s StatusDesc = $p(^DHCPACVisitStatus(StatusDr),"^",2)
	...;q:StatusDesc'["入院" 
	...;s InWardID = $p(^DHCADMVisitStatus(StatusDr),"^",10)
	...;Q:InWardID=""
	...;s InWardDesc = $p(^PAWARD(InWardID),"^",2)   // 这个就是入院病区
	..i AdmType="I" d
	...s InWardID = $p(^PAADM(NextAdm),"^",70)
	...s InWardDesc = $p(^PAWARD(InWardID),"^",2)   // 这个就是入院病区
	..s:InWardDesc="" InWardDesc="未入院"
	..s:$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,InWardDesc)) ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,InWardDesc)=^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,InWardDesc)+1
	..s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,InWardDesc)) ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,InWardDesc)=1
	
	s InPat="",InPatData="",Del=""""
	s InWardDesc=""
	f  s InWardDesc = $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,InWardDesc)) q:InWardDesc=""  d
	.s Num = ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,InWardDesc)
	.s:InPat'="" InPat=InPat_","_Del_InWardDesc_Del
	.s:InPat="" InPat=Del_InWardDesc_Del
	.s:InPatData'="" InPatData=InPatData_","_Num
	.s:InPatData="" InPatData=Num
	k ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid)
	Q "["_InPat_"]^"_"["_InPatData_"]"

#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"骨科")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"骨科")=66
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"心内科")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"心内科")=59
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"产科")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"产科")=10
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"儿科")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"儿科")=20
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"胸外科")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"胸外科")=12
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"普外科")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"普外科")=54
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"神经内科")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,"神经内科")=32
	b ;data
#;	w "["
#;	s InWardDesc="",Count=0
#;	f  s InWardDesc = $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,InWardDesc)) q:InWardDesc=""  d
#;	.s Num = ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid,InWardDesc)
#;	.s Data  = InWardDesc_"^"_Num_"^"_"入院病区"
#;	.w $case(Count,0:"",Count:",")
#;	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",Data)
#;	.s Count =Count+1
#;	w "]"
#;	k ^TMP("DHCEM","web.DHCEMNurMessageInterface","JsonBedTable",NewPid)
#;	q ""
}

ClassMethod KeyDiseasePatNum(Pid)
{
	n (Pid)
	
	s NPid = ##Class(web.DHCEMInterfaceCom).NewPid()
	
	s PatWarDesc=""
	f  s PatWarDesc =  $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s EpisodeID=""
	.f  s EpisodeID =  $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc,EpisodeID)) q:EpisodeID=""  d
	..s PatCheckLevID = $O(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))    //分级ID
	..q:PatCheckLevID=""
	..s PCSPId=""
	..f  s PCSPId=$o(^DHCEMPCSP(0,"PatCheckLev",PatCheckLevID,PCSPId)) q:PCSPId=""  d
	...s SPDId = $p(^DHCEMPCSP(PCSPId),"^",2)
	...s SPDDesc = $p($g(^DHCEMSPD(SPDId)),"^",2)
	...q:SPDDesc="" 
	...s TMPData(NPid,SPDDesc) = +$g(TMPData(NPid,SPDDesc))+1
	
#;	s:'$d(TMPData(NPid,"急性心力衰竭")) TMPData(NPid,"急性心力衰竭") =8
#;	s:'$d(TMPData(NPid,"急性脑卒死")) TMPData(NPid,"急性脑卒死") =2
#;	s:'$d(TMPData(NPid,"急性呼吸衰竭")) TMPData(NPid,"急性呼吸衰竭") =3
#;	s:'$d(TMPData(NPid,"急性创伤")) TMPData(NPid,"急性创伤") =1
#;	s:'$d(TMPData(NPid,"急性颅脑外伤")) TMPData(NPid,"急性颅脑外伤") =13
#;	s:'$d(TMPData(NPid,"急诊多发伤")) TMPData(NPid,"急诊多发伤") =34
	
	s Count=0
	w "["
	s SPDDesc=""
	f  s SPDDesc = $o(TMPData(NPid,SPDDesc)) q:SPDDesc=""  d
	.s Tmp = SPDDesc_"^"_TMPData(NPid,SPDDesc)
	.w $case(Count,0:"",Count:",")
	.s Count =Count+1
	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",Tmp)
	w "]"
}

ClassMethod InLocPatNum(Pid)
{
	n (Pid)
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,"急诊抢救室")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,"急诊抢救室")=11
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,"急诊留观室一")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,"急诊留观室一")=32
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,"急诊留观室二")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,"急诊留观室二")=25
	
	s InLocPat="",InLocPatNum="",Del=""""
	s PatWarDesc =""
	f  s PatWarDesc = $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
	.s WarDescNum = $g(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc)) 
	.q:+WarDescNum=0
	.s:InLocPat'="" InLocPat=InLocPat_","_Del_PatWarDesc_Del
	.s:InLocPat="" InLocPat=Del_PatWarDesc_Del
	.s:InLocPatNum'="" InLocPatNum=InLocPatNum_","_WarDescNum
	.s:InLocPatNum="" InLocPatNum=WarDescNum
	Q "["_InLocPat_"]^"_"["_InLocPatNum_"]"
	
#;	w "["
#;	s Count=0
#;	s PatWarDesc =""
#;	f  s PatWarDesc = $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc)) q:PatWarDesc=""  d
#;	.s WarDescNum = $g(^TMP("DHCEM","web.DHCEMNurMessageInterface","GetObsAreaAnaData",Pid,PatWarDesc)) 
#;	.q:+WarDescNum=0
#;	.s Count =Count+1
#;	.w $case(Count,1:"",:",")
#;	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value^group",PatWarDesc_"^"_WarDescNum_"^")
#;	w "]"
#;	q ""
}

/// w ##class(web.DHCEMNurMessageInterface).ListObservationPatient()
ClassMethod ListObservationPatient()
{
    
	s startDate=""
	s endDate=""
	s:startDate'="" startDate = $zdh(startDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(startDate)
	s:endDate'="" endDate =  $zdh(endDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(endDate)
	s st=$zd(+$h-99,3) //查询四个月数据
	s:startDate="" startDate=$zdh($p(st,"-",1)_"-"_$p(st,"-",2)_"-01",3)
	s:endDate="" endDate=+$h
	s WARDId =""
	s LocID=$o(^CTLOC(0,"Desc","急诊留观室","")) /// 科室id
	s WARDId=$o(^PAWARD(0,"WARD_LocationDR",LocID,""),-1)
    s pid=$I(^DHCST("web.DHCEMNurMessageInterface"))
    K ^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient")
 	s Num=0
 	f stDate=startDate:1:endDate  d 
  	.s stTime=""
 	.f  s stTime=$o(^PAADMi("TransDateTime",stDate,stTime))   Q:stTime=""  D
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TransDateTime",stDate,stTime,EpisodeID))   Q:EpisodeID=""  D    //按照就诊改变状态插入记录
 	...q:$p(^PAADM(EpisodeID),"^",2)'="E"
 	...q:($p(^PAADM(EpisodeID),"^",20)'="A")&($p(^PAADM(EpisodeID),"^",20)'="D")
 	...s PatWarDr=$p(^PAADM(EpisodeID),"^",70)                  //用来判断病人是否留观
 	...Q:(WARDId'=PatWarDr)||(WARDId="")
 	...s year=$p($zd(stDate,3),"-",1,2)
 	...q:$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,EpisodeID))
 	...s ^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,EpisodeID)="" 
	...i $d(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,year))=0 d
	....s ^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,year)=1_"^"_$p($zd(stDate,16),"月",1)_"月"
	...e  d
	....s ^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,year)=$p(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,year),"^",1)+1_"^"_$p($zd(stDate,16),"月",1)_"月"
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,"2022-08")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,"2022-08")=220_"^"_"22年8月"
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,"2022-09")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,"2022-09")=281_"^"_"22年9月"
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,"2022-10")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,"2022-10")=391_"^"_"22年10月"
#;	s:'$d(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,"2022-11")) ^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,"2022-11")=171_"^"_"22年11月"
#;	w "["
#;	s Count=0
#;	s index =""
#;	f  s index = $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,index)) q:index=""  d
#;	.s Data = $g(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,index)) 
#;	.s Count =Count+1
#;	.w $case(Count,1:"",:",")
#;	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("value^name^group",Data_"^")
#;	w "]"
#;
#;  K ^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient")
#;	Q ""
	
	s Obs="",ObsNum="",Del=""""
	s index =""
	f  s index = $o(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,index)) q:index=""  d
	.q:index'["-"
	.s Data = $g(^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient",pid,index))
	.s DataNum=$p(Data,"^",1)
	.s DataDesc=$p(Data,"^",2)
	.s:Obs'="" Obs=Obs_","_Del_DataDesc_Del
	.s:Obs="" Obs=Del_DataDesc_Del
	.s:ObsNum'="" ObsNum=ObsNum_","_DataNum
	.s:ObsNum="" ObsNum=DataNum
	K ^TMP("DHCEM","web.DHCEMNurMessageInterface","ListObservationPatient")
	Q "["_Obs_"]^"_"["_ObsNum_"]"
}

/// w ##class(web.DHCEMNurMessageInterface).NurWorLoad()
ClassMethod NurWorLoad()
{
    
	s today=+$h
	s todayweek=$zd(today,10)
	i todayweek=0 d
	.s startDate=today-6
	.s endDate=today
	e  d
	.s startDate=today-(todayweek-1)
	.s endDate=today+(7-todayweek)
	s WARDId =""
	s LocID=$o(^CTLOC(0,"Desc","急诊留观室","")) /// 科室id
	s WARDId=$o(^PAWARD(0,"WARD_LocationDR",LocID,""),-1)

 	s Num=0,week1=0,week2=0,week3=0,week4=0,week5=0,week6=0,week7=0
 	f stDate=startDate:1:endDate  d 
  	.s stTime=""
 	.f  s stTime=$o(^PAADMi("TransDateTime",stDate,stTime))   Q:stTime=""  D
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TransDateTime",stDate,stTime,EpisodeID))   Q:EpisodeID=""  D    //按照就诊改变状态插入记录
 	...q:$p(^PAADM(EpisodeID),"^",2)'="E"
 	...q:($p(^PAADM(EpisodeID),"^",20)'="A")&($p(^PAADM(EpisodeID),"^",20)'="D")
 	...s PatWarDr=$p(^PAADM(EpisodeID),"^",70)                  //用来判断病人是否留观
 	...Q:(WARDId'=PatWarDr)||(WARDId="")
 	...s weekdr=$zd(stDate,10)
 	...s:(weekdr=1) week1=week1+1
 	...s:(weekdr=2) week2=week2+1
 	...s:(weekdr=3) week3=week3+1
 	...s:(weekdr=4) week4=week4+1
 	...s:(weekdr=5) week5=week5+1
 	...s:(weekdr=6) week6=week6+1
 	...s:(weekdr=0) week7=week7+1
	
	w "["_week1_","_week2_","_week3_","_week4_","_week5_","_week6_","_week7_"]"
	Q ""
#;	s:(week1=0)&&(todayweek>=1) week1=120
#;	s:(week2=0)&&(todayweek>=2) week2=200
#;	s:(week3=0)&&(todayweek>=3) week3=150
#;	s:(week4=0)&&(todayweek>=4) week4=80
#;	s:(week5=0)&&(todayweek>=5) week5=70
#;	s:(week6=0)&&(todayweek>=6) week6=110
#;	s:(week7=0)&&(todayweek>=7) week7=130
#; 	w "["
#; 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","周一^"_week1)
#; 	w ","
#; 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","周二^"_week2) //hxy 2020-02-21
#; 	w ","
#; 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","周三^"_week3)
#; 	w ","
#; 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","周四^"_week4)
#; 	w ","
#; 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","周五^"_week5)
#; 	w ","
#; 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","周六^"_week6)
#; 	w ","
#; 	W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","周日^"_week7)
#; 	
#; 	w "]"
#;	Q ""
}

/// Others：w ##class(web.DHCEMNurMessageInterface).GetMainStaData()
ClassMethod GetMainStaData(HospID = "")
{
	n (HospID,%session)
	k TMPMainData
	s StDate=""
	s EndDate=""
	s HospID =%session.Get("LOGON.HOSPID")
	s:StDate'="" StDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s:EndDate'="" EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:StDate="" StDate=+$h
	s:EndDate="" EndDate=+$h
	
	s LevOne=0,LevTwo=0,LevThr=0,LevFou=0,LevFiv=0
	s GLevOne=0,GLevTwo=0,GLevThr=0,GLevFou=0,GLevFiv=0
	f Date=StDate:1:EndDate  d
 	.s PCLRowID="0" 
 	.f  s PCLRowID=$o(^DHCEMPCL(0,"CreateDate",Date,PCLRowID)) q:PCLRowID=""  d
 	..q:+PCLRowID=0
 	..s ChkAdmID = $o(^DHCEMPCA(0,"PatCheckLev",PCLRowID,""),-1)
 	..s Adm= $p($g(^DHCEMPCA(+ChkAdmID)),"^",2)
 	..s PCCRowID=$o(^DHCEMPCC(0,"PatCheckLev",PCLRowID,""))
 	..q:(+PCCRowID=0)&(Adm="")
 	..s CheckLoc = $p($g(^DHCEMPCC(+PCCRowID)),"^",3)
 	..s:CheckLoc="" CheckLoc = $p($g(^PAADM(+Adm)),"^",4)
 	..s LocInHosp = $p(^CTLOC(CheckLoc),"^",22)
 	..q:(HospID'="")&&(LocInHosp'=HospID)
 	..s CheckLocDesc = $p(^CTLOC(CheckLoc),"^",2)
 	..s TMPMainData(CheckLocDesc)=+$g(TMPMainData(CheckLocDesc))+1
 	..s EmPatGreFlag=$p($g(^PAADM(Adm)),"^",5)    ;##Class(web.DHCEMPatCheckLev).GetEmPatGreenFlag(PCLRowID,"")
 	..s NurCheckLev = $p(^DHCEMPCL(PCLRowID),"^",7)    //护士分级
 	..s:(NurCheckLev=1) LevOne=LevOne+1
 	..s:(NurCheckLev=2) LevTwo=LevTwo+1
 	..s:(NurCheckLev=3) LevThr=LevThr+1
 	..s:(NurCheckLev=4) LevFou=LevFou+1
 	..s:(NurCheckLev=5) LevFiv=LevFiv+1
 	..i EmPatGreFlag=1 d
 	...s:(NurCheckLev=1) GLevOne=GLevOne+1
 	...s:(NurCheckLev=2) GLevTwo=GLevTwo+1
 	...s:(NurCheckLev=3) GLevThr=GLevThr+1
 	...s:(NurCheckLev=4) GLevFou=GLevFou+1
 	...s:(NurCheckLev=5) GLevFiv=GLevFiv+1
	
	s LevSta="["_LevOne_","_LevTwo_","_LevThr_","_LevFou_","_LevFiv_"]"
	;s GreLevSta="["_GLevOne_","_GLevTwo_","_GLevThr_","_GLevFou_","_GLevFiv_"]"
	s GreLevSta= "["_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","Ⅰ^"_GLevOne)
 	s GreLevSta= GreLevSta_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","Ⅱ^"_GLevTwo)
 	s GreLevSta= GreLevSta_","_ ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","Ⅲ^"_GLevThr)
 	s GreLevSta= GreLevSta_","_ ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","Ⅳa^"_GLevFou)
 	s GreLevSta= GreLevSta_","_ ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","Ⅳb^"_GLevFiv)
 	s GreLevSta= GreLevSta_"]"

	s LocSta="["
	s Desc="",Count=0
	f  s Desc = $o(TMPMainData(Desc)) q:Desc=""  d
	.s Tmp = ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",Desc_"^"_TMPMainData(Desc))
	.s:LocSta'="[" LocSta=LocSta_","_Tmp
	.s:LocSta="[" LocSta=LocSta_Tmp
	s LocSta=LocSta_"]"
	s Obj=##class(web.DHCAPPJsonObject).%New()
	d Obj.Put("LevSta",LevSta)
	d Obj.Put("GreLevSta",GreLevSta)
	d Obj.Put("LocSta",LocSta)
	w Obj.Json()
	k TMPMainData
	q ""
}

/// Creator: 	hxy
/// CreateDate: 2023-04-24
/// Descript: 	当天转入转出情况 ['入观', '离观', '转入院']
/// Others：w ##class(web.DHCEMNurMessageInterface).GetInOut(2)
ClassMethod GetInOut(HospID = "")
{
	n (HospID,%session)
	s HospID=%session.Get("LOGON.HOSPID")
	s Date=+$h
	s Stay=0,Dis=0,In=0 //留抢，离院，入院
	s EpisodeID=""
    f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    .s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    .q:(HospID'="")&&(AdmHospID'=HospID)
    .s His=..GetInOutHis(EpisodeID)
    .s:(His["Stay")!(His["Salvage") Stay=Stay+1
    .s:His["^Discharge^" Dis=Dis+1
    .s:His["^DisplaceOrInHospital^" In=In+1
    
   	q "["_Stay_","_Dis_","_In_"]"
}

/// Creator: 	hxy
/// CreateDate: 2023-04-24
/// Descript: 	获取历史状态改变
/// Others：w ##class(web.DHCEMNurMessageInterface).GetInOutHis(7354)
ClassMethod GetInOutHis(EpisodeID)
{
	n (EpisodeID)
	s ret="^"
	s AvsID=""
	f  s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,AvsID)) q:(AvsID="")  d
	.s PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
   	.s WalkStatus=$p(^DHCPACVisitStatus(PvsID),"^",1)
   	.s ret=ret_WalkStatus_"^"
   	q ret
}

/// Creator: 	hxy
/// CreateDate: 2023-04-24
/// Descript: 	床位占用率、床位周转率
/// Others：w ##class(web.DHCEMNurMessageInterface).GetBedSta(2)
ClassMethod GetBedSta(HospID = "")
{
	n (HospID,%session)
	s HospID=%session.Get("LOGON.HOSPID")
	s Occupy=0,Turn=0
	s Str=..GetBedInfo(HospID)
	s Occupy=$FN($p(Str,"^",2)/$p(Str,"^",1),"",2)
	s Turn=..GetBedRate(HospID,$p(Str,"^",1))
	s ListTitle="Occupy^Turn"
	s ListData=Occupy_"^"_Turn
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Others:	W ##class(web.DHCEMNurMessageInterface).GetBedInfo("2")
ClassMethod GetBedInfo(HospID)
{
	n (HospID)
	s totalBedNum=0,availBedNum=0
	s WardID=0 
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .q:LocID=""
    .q:$p(^CTLOC(LocID),"^",13)'="EM"
	.q:$p(^CTLOC(LocID),"^",14)'="Y"
    .q:'$o(^PAWARD(WardID,"ROOM",0))
    .q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocID,HospID)'="Y"
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
 	.s HasBed=$o(^PAWARD(WardID,"BED",0))		///是否有床位
 	.q:'+HasBed
	.s HasRoom=$o(^PAWARD(WardID,"ROOM",0))		///是否有房间
 	.q:'+HasRoom
 	.s ret=##class(web.DHCEMInterfaceCom).GetBedStr(WardID)
 	.s totalBedNum=totalBedNum+$p(ret,"^",1)
 	.s availBedNum=availBedNum+$p(ret,"^",2)
	
	q totalBedNum_"^"_availBedNum
}

/// Descript:     床位使用率统计
/// InPut:        医院ID,总床数
/// OutPut:       床位使用率((一段时间内留观病人总数/天数)/固定床位数)
/// D ##Class(web.DHCEMNurMessageInterface).GetBedRate()
ClassMethod GetBedRate(HospID, BedNums) As %String
{
	n (HospID,BedNums)
	s UsRate=0
	s EndDate=+$h //s EndDate=66557
	s StartDate=EndDate-2
	s PatNums=0
	F dd=StartDate:1:EndDate D
	.s VsID=""
	.F  s VsID=$o(^DHCADMVisitStatus(0,"DateStatus",dd,VsID)) Q:VsID=""  D
	..s VsCode=$p(^DHCPACVisitStatus(VsID),"^",1)
	..Q:(VsCode'="Stay")&(VsCode'="Salvage")
	..s ID=$o(^DHCADMVisitStatus(0,"DateStatus",dd,VsID,""))
	..s EpisodeID=$p(^DHCADMVisitStatus(ID),"^",1)     /// 就诊ID
	..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HospID'="")&&(AdmHospID'=HospID)
	..s PatNums=PatNums+1
	s UsRate=$FN(((PatNums/(EndDate-StartDate+1))/BedNums),"",2)
	Q UsRate
}

/// Descript:     获取护理级别，病情级别
/// InPut:        医院ID
/// OutPut:       护理级别，病情级别
/// w ##Class(web.DHCEMNurMessageInterface).GetNurLev(2)
ClassMethod GetNurLev(HospID = "") As %String
{
	n (HospID,%session)
	s HospID=%session.Get("LOGON.HOSPID")
	s AlNurL=0,AlNurLOne=0,AlNurLTwo=0,AlNurLThr=0,AlLevO=0,AlLevT=0,AlLevTh=0,AlLevFA=0,AlLevFB=0
	s WardID=0 
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .q:LocID=""
    .q:$p(^CTLOC(LocID),"^",13)'="EM"
	.q:$p(^CTLOC(LocID),"^",14)'="Y"
    .q:'$o(^PAWARD(WardID,"ROOM",0))
    .q:##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_Loc",LocID,HospID)'="Y"
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
 	.s HasBed=$o(^PAWARD(WardID,"BED",0))		///是否有床位
 	.q:'+HasBed
	.s HasRoom=$o(^PAWARD(WardID,"ROOM",0))		///是否有房间
 	.q:'+HasRoom
 	.s ret=..GetBedStr(WardID)
 	.s AlNurL=AlNurL+$p(ret,"^",3)
 	.s AlNurLOne=AlNurLOne+$p(ret,"^",4)
 	.s AlNurLTwo=AlNurLTwo+$p(ret,"^",5)
 	.s AlNurLThr=AlNurLThr+$p(ret,"^",6)
 	.s AlLevO=AlLevO+$p(ret,"^",7)
 	.s AlLevT=AlLevT+$p(ret,"^",8)
 	.s AlLevTh=AlLevTh+$p(ret,"^",9)
 	.s AlLevFA=AlLevFA+$p(ret,"^",10)
 	.s AlLevFB=AlLevFB+$p(ret,"^",11)
 	
 	s Nurse= "["_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","特级^"_AlNurL)
 	s Nurse= Nurse_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","一级^"_AlNurLOne)
 	s Nurse= Nurse_","_ ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","二级^"_AlNurLTwo)
 	s Nurse= Nurse_","_ ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","三级^"_AlNurLThr)
 	s Nurse= Nurse_"]"
 	s State= "["_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","Ⅰ^"_AlLevO)
 	s State= State_","_##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","Ⅱ^"_AlLevT)
 	s State= State_","_ ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","Ⅲ^"_AlLevTh)
 	s State= State_","_ ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","Ⅳa^"_AlLevFA)
 	s State= State_","_ ##class(web.DHCEMJsonCommon).getJsonDataEcharts("name^value","Ⅳb^"_AlLevFB)
 	s State= State_"]"

	s Obj=##class(web.DHCAPPJsonObject).%New()
	d Obj.Put("Nurse",Nurse) //护理级别
	d Obj.Put("State",State) //病情级别
	w Obj.Json()
	q ""
}

/// Descript:     根据WardID获取总床位数、使用床位数、特级护理数、一级护理数、二级护理数、三级护理数、1级数、2级数、3级数、4a级数、4b级数
/// InPut:        WardID
/// W ##class(web.DHCEMInterfaceCom).GetBedStr("34")
ClassMethod GetBedStr(WardID)
{
	n (WardID)
	s BedSub=0,Total=0,Used=0,NurL=0,NurLOne=0,NurLTwo=0,NurLThr=0,LevO=0,LevT=0,LevTh=0,LevFA=0,LevFB=0
	f  s BedSub = $o(^PAWARD(WardID,"BED",BedSub)) q:BedSub=""  d
	.s ActiveFlag=$p(^PAWARD(WardID,"BED",BedSub),"^",4)
	.q:(ActiveFlag'="Y")
	.s BedStDate = $p(^PAWARD(WardID,"BED",BedSub),"^",21)
	.s BedEndDate = $p(^PAWARD(WardID,"BED",BedSub),"^",22)
	.s ADMChildsub ="",PaAdm=""
	.s ADMChildsub = $o(^PAWARDA(WardID,"BED",BedSub,"ADM",0))
	.s:+ADMChildsub'=0 PaAdm=$p(^PAWARDA(WardID,"BED",BedSub,"ADM",ADMChildsub),"^",1)
	.q:(PaAdm="")&&(BedStDate'="")&&(BedStDate>+$h)
	.q:(PaAdm="")&&(BedEndDate'="")&&(BedEndDate<+$H)
	.q:($p($g(^PAWARD(WardID,"BED",BedSub)),"^",18)="") //没维护宽度
	.s Total=Total+1
	.q:PaAdm=""
	.s Used=Used+1
	.s NurseLevel=""
	.s Priority=+$P($g(^PAADM(PaAdm)),"^",33)   /// 就诊表级别
	.i Priority'=0 s NurseLevel=+$p($g(^CT("ACU",Priority)),"^",1)
	.s:NurseLevel=1 LevO=LevO+1
	.s:NurseLevel=2 LevT=LevT+1
	.s:NurseLevel=3 LevTh=LevTh+1
	.s:NurseLevel=4 LevFA=LevFA+1
	.s:NurseLevel=5 LevFB=LevFB+1
	.s:##class(web.DHCSETIMAGE).IfCareLevelN($g(PaAdm),"特级护理")=1 NurL=NurL+1
	.s:##class(web.DHCSETIMAGE).IfCareLevelN($g(PaAdm),"一级护理")=1 NurLOne=NurLOne+1
	.s:##class(web.DHCSETIMAGE).IfCareLevelN($g(PaAdm),"二级护理")=1 NurLTwo=NurLTwo+1
	.s:##class(web.DHCSETIMAGE).IfCareLevelN($g(PaAdm),"三级护理")=1 NurLThr=NurLThr+1
	q Total_"^"_Used_"^"_NurL_"^"_NurLOne_"^"_NurLTwo_"^"_NurLThr_"^"_LevO_"^"_LevT_"^"_LevTh_"^"_LevFA_"^"_LevFB
}

Storage Default
{
<Data name="DHCEMNurMessageInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMNurMessageInterfaceD</DataLocation>
<DefaultData>DHCEMNurMessageInterfaceDefaultData</DefaultData>
<IdLocation>^web.DHCEMNurMessageInterfaceD</IdLocation>
<IndexLocation>^web.DHCEMNurMessageInterfaceI</IndexLocation>
<StreamLocation>^web.DHCEMNurMessageInterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
