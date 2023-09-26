/// 医保对账操作类
/// DingSH 
/// 2020-02-07
Class web.DHCINSUBalanceCom Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 校验是否生成医保结算流水表数据
/// 函数描述：生成医保结算流水表数据
/// DingSH 
/// 2020-02-07
/// 入参：
/// StDate:结算开始日期,EndDate:结算结束日期,HospId
/// 出参
///    成功：0^HIS总人次^HIS总费用^HIS基金支付额^HIS帐户支付额^HIS个人现金支付额
///    失败  -1^错误原因
/// 其他 w ##class(web.DHCINSUBalanceCom).BuildMeidcalDivInfo("2019-07-08","2019-07-08","","")
ClassMethod BuildMeidcalDivInfo(StDate As %String, EndDate As %String, UserDr As %String, HospId As %String) As %String
{
	
	
	
	s:StDate["-" StDate=$zdh(StDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:StDate["/" StDate=$zdh(StDate,4)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	
	s rtnFlag="-1"
	s HisTotCnt=0	//HIS总人次
	s HisTotAmt=0   //HIS总费用
    s Hisjjzfe=0	//HIS基金支付额
    s Hiszhzfe=0	//HIS帐户支付额
    s Hisgrzfe=0	//HIS个人现金支付额
    
    q:StDate=""||EndDate="" "-1^开始日期或结束日期不能为空"
    
	f date=StDate:1:EndDate d
	.s INPAYID=""
	.f  s INPAYID=$o(^DHCINDIV("0","IDate",date,INPAYID)) q:INPAYID=""  d
	..s Divinfo=$g(^DHCINDIV(INPAYID))
	..s InPayFlag=$p(Divinfo,"^",5) 
	..s tUserDr=$p(Divinfo,"^",21) 
	..s AdmDr=$p(Divinfo,"^",1)
	..s tHospId=$P(..GetHospInfoByAdm(AdmDr),"^",1)
	..q:(UserDr'="")&&(UserDr'=tUserDr)
	..q:(InPayFlag'="I")&&(InPayFlag'="B")&&(InPayFlag'="S")
	..q:(HospId'="")&&(HospId'=tHospId)
	..s MeidcalDivStr=..BuildMeidcalDivStr(INPAYID)
	..s rtn=##class(web.DHCINSUMedicalSubCtl).InsertMedicalSubInfo(MeidcalDivStr)
	..i +rtn>0 d
	...s HisTotCnt=HisTotCnt+1
	...s HisTotAmt=HisTotAmt+$P(MeidcalDivStr,"^",13)
	...s Hisjjzfe=Hisjjzfe+$P(MeidcalDivStr,"^",14)
	...s Hiszhzfe=Hiszhzfe+$P(MeidcalDivStr,"^",15)
	...s Hisgrzfe=Hisgrzfe+$P(MeidcalDivStr,"^",16)
	...s rtnFlag=0
	q rtnFlag_"^"_HisTotCnt_"^"_HisTotAmt_"^"_Hisjjzfe_"^"_Hiszhzfe_"^"_Hisgrzfe
}

ClassMethod GetHospInfoByAdm(AdmDr) As %String
{
	 n (AdmDr)
	 s AdmInfo=$g(^PAADM(AdmDr))       //Pa_Adm 信息
	 s LocDr=$P(AdmInfo,"^",4)
     s HospDr=$P($g(^CTLOC(LocDr)),"^",22)
     s HospitalCode=""
     s HospitalName=""
     i HospDr'="" d
     .s HospitalCode=$P($g(^CT("HOSP",HospDr)),"^",1)
     .s HospitalName=$P($g(^CT("HOSP",HospDr)),"^",2)
     q HospDr_"^"_HospitalCode_"^"_HospitalName
}

ClassMethod BuildMeidcalDivStr(InDivDr) As %String
{
	n (InDivDr)
	 s OutStr=""
	// OutStr 格式
	//^医院代码^指针User.INSUDivide^指针User.INSUCenterSub^医保类型^医疗类别^人员类型^结算类型^患者姓名^医保号/个人编号^就诊号^科室名称^HIS总费用^HIS基金支付额^HIS帐户支付额^HIS个人现金支付额^医保总费用^医保基金支付额^医保帐户支付额^医保个人现金支付额^登记流水号^单据/结算流水号^交易流水号^对账状态^对账日期^对账时间^操作员User.SSUser^操作员姓名^收费日期^收费时间^入院日期^出院日期^入院诊断^出院诊断/主要诊断^医保支付1^医保支付2^医保支付3^医保支付4^医保支付5^医保支付6^医保支付7^医保支付8^医保支付9^医保支付10^医保拒付金额^医保拒付原因^扩展参数^扩展参数^扩展参数^扩展参数^扩展参数^扩展参数超长字段500
   	s Divinfo=$g(^DHCINDIV(InDivDr))  //Insu_DivideInfo信息
    s AdmDr=$p(Divinfo,"^",1)
    s AdmInfo=$g(^PAADM(AdmDr))       //Pa_Adm 信息
    s PAPMIDR=$p(AdmInfo,"^",1)
    s InAdmDr=$p(Divinfo,"^",2)
    s InAdmInfo=$g(^DHCINADM(InAdmDr)) //Insu_AdmInfo信息
    s FY=1 
    s JSFlag="I"
     //-01^医院代码-02^指针User.INSUDivide-03^指针User.INSUCenterSub-04^医保类型-05^
     s HospitalCode=$P(..GetHospInfoByAdm(AdmDr),"^",2)
     s OutStr=OutStr_"^"_HospitalCode
     s OutStr=OutStr_"^"_InDivDr
     s OutStr=OutStr_"^"_""
     s OutStr=OutStr_"^"_$P(InAdmInfo,"^",18)
     //医疗类别-06^人员类型-07^结算类型-08^患者姓名-09^医保号/个人编号-10^
     s JSFlag=$Case($P(Divinfo,"^",5),"B":"I","I":"I","S":"R")
     i JSFlag="R" d
     .s FY=-1
     s OutStr=OutStr_"^"_$P(InAdmInfo,"^",14)
     s OutStr=OutStr_"^"_$P(InAdmInfo,"^",4)
     s OutStr=OutStr_"^"_JSFlag      //I正交易/R负交易
     s OutStr=OutStr_"^"_$P(^PAPER(PAPMIDR,"ALL"),"^",1)
     s OutStr=OutStr_"^"_$P(InAdmInfo,"^",2)
   
     //就诊号-11^科室名称-12^HIS总费用-13^HIS基金支付额-14^HIS帐户支付额-15^
     s OutStr=OutStr_"^"_AdmDr
     s OutStr=OutStr_"^"_$P(InAdmInfo,"^",15)
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",7))
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",19))
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",28))
     
     //HIS个人现金支付额-16^医保总费用-17^医保基金支付额-18^医保帐户支付额-19^医保个人现金支付额-20^
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",15))
     s OutStr=OutStr_"^"_0
     s OutStr=OutStr_"^"_0
     s OutStr=OutStr_"^"_0
     s OutStr=OutStr_"^"_0
     
     
     //登记流水号-21^单据/结算流水号-22^交易流水号-23^对账状态-24^对账日期-25^
     s OutStr=OutStr_"^"_$P(InAdmInfo,"^",10)
     s OutStr=OutStr_"^"_$P(Divinfo,"^",8)
     s OutStr=OutStr_"^"_$P(Divinfo,"^",51)
     s OutStr=OutStr_"^"_"0"
     s OutStr=OutStr_"^"_""
     
    
     //对账时间-26^操作员User.SSUser-27^操作员姓名-28^收费日期-29^收费时间-30^
     s UserDr=$P(Divinfo,"^",21)
     s OutStr=OutStr_"^"_""
     s OutStr=OutStr_"^"_UserDr
     s OutStr=OutStr_"^"_""
     s OutStr=OutStr_"^"_$zd($P(Divinfo,"^",16),3)
     s OutStr=OutStr_"^"_$zt($P(Divinfo,"^",17))
     
     //入院日期-31^出院日期-32^入院诊断-33^出院诊断/主要诊断-34^医保支付1-35^
     //s AdmDateS=##class(web.DHCINSUPortUse).GetAdminDateTime(AdmDr)
     s DischDateS=##class(web.DHCINSUPortUse).GetDischargeDateTime(AdmDr)
     s DischDate=$P(DischDateS,"^",1)
     i DischDate'="" d
     .s DischDate=$zd(DischDate,3)
     s OutStr=OutStr_"^"_$zd($P(InAdmInfo,"^",12),3)
     s OutStr=OutStr_"^"_DischDate
     s OutStr=OutStr_"^"_$P(InAdmInfo,"^",26)
     s OutStr=OutStr_"^"_$P(InAdmInfo,"^",28)
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",31))
     
     
     //医保支付2-36^医保支付3-37^医保支付4-38^医保支付5-39^医保支付6-40^
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",32))
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",33))
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",34))
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",35))
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",46))
     //医保支付7-41^医保支付8-42^医保支付9-43^医保支付10-44^医保拒付金额-45^
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",47))
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",48))
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",49))
     s OutStr=OutStr_"^"_(FY * $P(Divinfo,"^",50))
     s OutStr=OutStr_"^"_0
     //医保拒付原因-46^扩展参数-47^扩展参数-48^扩展参数-49^扩展参数-50^
     s OutStr=OutStr_"^"_""
     s OutStr=OutStr_"^"_""
     s OutStr=OutStr_"^"_""
     s OutStr=OutStr_"^"_""
     s OutStr=OutStr_"^"_""
     //扩展参数-51^扩展参数超长字段500-52
     s OutStr=OutStr_"^"_""
     s OutStr=OutStr_"^"_""
     
    
    
    q OutStr
}

/// 生成医保中心结算流水表数据
ClassMethod BuildCenterDivInfo() As %String
{
}

/// 校验是否生医保中心结算流水表数据
/// 生成医保对账差异明细表数据
ClassMethod BuildUnusualDivInfo() As %String
{
}

/// 医保结算流水表和医保中心流水表数据对账

}
