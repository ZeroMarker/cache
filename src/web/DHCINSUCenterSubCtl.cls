/// 医保中心结算信息
Class web.DHCINSUCenterSubCtl Extends %RegisteredObject [ Not ProcedureBlock ]
{

// w ##class(web.DHCINSUCenterSubCtl).InsertCenterSubInfo("^2^^^^ZZB^21^21^R^令狐冲^L0001^1000^800^100^100^ZY0001^DJ0001^JY001^I^1^Demo^^^2020-02-20^2020-02-26^^^800^0^0^0^0^0^0^0^0^0^0^^^^^^")

/// 保存医保中心结算明细信息
ClassMethod InsertCenterSubInfo(InString As %String) As %String
{
	n (InString)
	q:InString="" -100
	s ^TMP("InsertCenterSubInfo")=InString
    s CenterSubId=+$p(InString,"^",1)
    i CenterSubId=0 d
    .s djlsh=$p(InString,"^",17)
    .s InsuType=$p(InString,"^",6)
    .s zylsh=$p(InString,"^",16)
    .s CenterSubId=..GetCenterSubId(djlsh,zylsh,InsuType)
    .s $p(InString,"^",1)=CenterSubId
    
    i (CenterSubId=0)||(CenterSubId="") d
    .s InsertCenterSubInfo=$$InsertCenterSub^DHCINSUCenterSub(InString)
    e  d
    .i $d(^DHCINSUCenterSub(CenterSubId))=0 d
    ..s InsertCenterSubInfo=$$InsertCenterSub^DHCINSUCenterSub(InString)
    .e  d
    ..s InsertCenterSubInfo=$$UpdateCenterSub^DHCINSUCenterSub(InString)

    q InsertCenterSubInfo
}

// w ##class(web.DHCINSUCenterSubCtl).GetCenterSubId("201909060000048457","QGYD")

/// 获取中心结算信息表rowid
ClassMethod GetCenterSubId(djlsh As %String, zylsh As %String, InsuType As %String) As %String
{
	//d ##class(User.INSUCenterSub).%BuildIndices($ListBuild("IndexofDzqh"))
	n (djlsh,InsuType,zylsh)
	q:(djlsh="")||(InsuType="") ""
	s rtn=""
	s CenterSubId=0
	f  s CenterSubId=$o(^DHCINSUCenterSub(0,"Djlsh",djlsh,CenterSubId)) q:CenterSubId=""  d
    .s CenterSub=$g(^DHCINSUCenterSub(CenterSubId))
    .s tmpInsuType=$p(CenterSub,"^",5)
    .q:tmpInsuType'=InsuType
    .s tmpzylsh=$p(CenterSub,"^",15)
    .q:(zylsh'="")&&(tmpzylsh'=zylsh)
    .s rtn=CenterSubId
    q rtn
}

// w ##class(web.DHCINSUCenterSubCtl).UpdateCenterSubFlag("201909","Y")

ClassMethod UpdateCenterSubFlag(CenterSubId As %String, Flag As %String) As %String
{
	n (CenterSubId,Flag)
	s OutStr="-1"
	q:CenterSubId="" OutStr
	
	s OutStr=$$UpdateCenterSubFlag^DHCINSUCenterSub(CenterSubId,Flag)
	
	q OutStr
}

// w ##class(web.DHCINSUCenterSubCtl).DeleteCenterSubByDate("2019-09-01","2","GDSZ")

ClassMethod DeleteCenterSubByDate(OptDate As %String, HospId As %String, InsuType As %String) As %String
{
	n (OptDate,HospId,InsuType)
	s OutStr="-1"
	q:(OptDate="")||(InsuType="") OutStr
	
	s OutStr=$$DelCenterSubByDate^DHCINSUCenterSub(OptDate,HospId,InsuType)
	
	q OutStr
}

// w ##class(web.DHCINSUCenterSubCtl).GetCenterSum("201909","QGYD")

/// 获取医保中心明细汇总
ClassMethod GetCenterSum(Dzqh As %String, InsuType As %String) As %String
{
	n (Dzqh,InsuType)
	s num=0
	s INBALSDNRowid=0
	f  s INBALSDNRowid=$o(^DHCINSUCenterSub("0","Dzqh",Dzqh,INBALSDNRowid)) q:INBALSDNRowid=""  d
	.s CenterSubInfo=^DHCINSUCenterSub(INBALSDNRowid)
	.s tmpInsuType=$p(CenterSubInfo,"^",5)
	
	.q:tmpInsuType'=InsuType
	.s num=num+1
	q num
}

// d ##class(%ResultSet).RunQuery("web.DHCINSUCenterSubCtl","CenterDivInfo","2020-03-13","2020-03-13","","ZZB")

Query CenterDivInfo(StDate As %String, EnDate As %String, AdmType As %String, InsuType As %String, HospId As %String = "") As %Query(ROWSPEC = "ind:%String,BalanceDayDr:%String,UserBalDr:%String,MedicalSubDr:%String,INSUType:%String,INSUYllb:%String,INSURylb:%String,DivType:%String,patName:%String,INSUNo:%String,INSUTotAmt:%String,INSUjjzfe:%String,INSUzhzfe:%String,INSUgrzfe:%String,zylsh:%String,djlsh:%String,Flag:%String,UserDr:%String,sfrm0:%String,sfrq00:%String,AdmDate:%String,DisDate:%String,inDiagnos:%String,outDiagnos:%String,InsuPay1:%String,InsuPay2:%String,InsuPay3:%String,InsuPay4:%String,InsuPay5:%String,InsuPay6:%String,InsuPay7:%String,InsuPay8:%String,InsuPay9:%String,InsuPay10:%String,InsuDISAmt:%String,InsuDISInfo:%String,Zstr01:%String,Zstr02:%String,Zstr03:%String,Zstr04:%String,Zstr05:%String,INBALSDNRowid:%String")
{
}

ClassMethod CenterDivInfoExecute(ByRef qHandle As %Binary, StDate As %String, EnDate As %String, AdmType As %String, InsuType As %String, HospId As %String) As %Status
{
	
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s ^TMP("CenterDivInfo")=$lb(StDate,EnDate,AdmType,InsuType,HospId)
	q:$g(StDate)="" $$$OK
	//q:$g(EnDate)="" $$$OK
	
	s:StDate["-" StDate=$zdh(StDate,3)
	s:EnDate["-" EnDate=$zdh(EnDate,3)
	s:StDate["/" StDate=$zdh(StDate,4)
	s:EnDate["/" EnDate=$zdh(EnDate,4)
	
	f theDate=StDate:1:EnDate d
	.s INBALSDNRowid=""
	.f  s INBALSDNRowid=$o(^DHCINSUCenterSub("0","OptDate",theDate,INBALSDNRowid)) q:INBALSDNRowid=""  d
	..s CenterSub=$G(^DHCINSUCenterSub(INBALSDNRowid))
	..s INSUType=$p(CenterSub,"^",5)	             // 医保类型
	..q:(InsuType'="")&&(INSUType'=InsuType)
	..s HospitalCode=$p(CenterSub,"^",1)	         // 医院代码
	..q:(HospId'="")&&(HospId'=HospitalCode)
	..s INSUBalanceDayDr=$p(CenterSub,"^",2)	     // 日对账Dr
	..s INUserBalDr=$p(CenterSub,"^",3)              // 操作员日对账Dr
	..s INSUMedicalSubDr=$p(CenterSub,"^",4)         // 结算流水表Dr
	..s INSUYllb=$p(CenterSub,"^",6)	             // 医疗类别
	..s CenterAdmType=""
    ..;q:(AdmType'="")&&(AdmType'=CenterAdmType)
	..s INSURylb=$p(CenterSub,"^",7)	             // 人员类型
	..s DivType=$p(CenterSub,"^",8)	                 // 结算类型
	..s patName=$p(CenterSub,"^",9)	                 // 患者姓名
	..s INSUNo=$p(CenterSub,"^",10)	                 // 医保号/个人编号
	..s INSUTotAmt=+$p(CenterSub,"^",11)	         // 医保总费用
	..q:+INSUTotAmt=0
	..s INSUjjzfe=+$p(CenterSub,"^",12)	             // 医保基金支付额
	..s INSUzhzfe=+$p(CenterSub,"^",13)	             // 医保帐户支付额
	..s INSUgrzfe=+$p(CenterSub,"^",14)	             // 医保个人现金支付额
	..s zylsh=$p(CenterSub,"^",15)	                 // 登记流水号
	..s djlsh=$p(CenterSub,"^",16)	                 // 单据/结算流水号
	..s jylsh=$p(CenterSub,"^",17)	                 // 交易流水号
	..s Flag=$p(CenterSub,"^",18)	                 // 中心对账状态
	..s UserDr=$p(CenterSub,"^",19)	                 // 操作员User.SSUser
	..s sfrm0=$p(CenterSub,"^",20)	                 // 操作员姓名
	..s sfrq00=$zd($p(CenterSub,"^",21),3)
	..s sfsj00=$zt($p(CenterSub,"^",22),1)
	..s AdmDate=$p(CenterSub,"^",23)				 // 入院日期
	..s DisDate=$p(CenterSub,"^",24)				 // 出院日期
	..s inDiagnos=$p(CenterSub,"^",25)				 // 入院诊断
	..s outDiagnos=$p(CenterSub,"^",26)				 // 出院诊断/主要诊断
	..s InsuPay1=+$p(CenterSub,"^",27)			 	 // 医保支付1
	..s InsuPay2=+$p(CenterSub,"^",28)			 	 // 医保支付2
	..s InsuPay3=+$p(CenterSub,"^",29)			 	 // 医保支付3
	..s InsuPay4=+$p(CenterSub,"^",30)			     // 医保支付4
	..s InsuPay5=+$p(CenterSub,"^",31)				 // 医保支付5
	..s InsuPay6=+$p(CenterSub,"^",32)				 // 医保支付6
	..s InsuPay7=+$p(CenterSub,"^",33)				 // 医保支付7
	..s InsuPay8=+$p(CenterSub,"^",34)				 // 医保支付8
	..s InsuPay9=+$p(CenterSub,"^",35)				 // 医保支付9
	..s InsuPay10=+$p(CenterSub,"^",36)				 // 医保支付10
	..s InsuDISAmt=+$p(CenterSub,"^",37)		   	 // 医保拒付金额
	..s InsuDISInfo=$p(CenterSub,"^",38)	         // 医保拒付原因
	..s Zstr01=$p(CenterSub,"^",39)                  // 扩展参数
	..s Zstr02=$p(CenterSub,"^",40)	                 // 扩展参数
	..s Zstr03=$p(CenterSub,"^",41)	                 // 扩展参数
	..s Zstr04=$p(CenterSub,"^",42)	                 // 扩展参数
	..s Zstr05=$p(CenterSub,"^",43)	                 // 扩展参数

	
	..d CenterDivInfoBuild
	
    Quit $$$OK
    
CenterDivInfoBuild
	set Data=$lb(ind,INSUBalanceDayDr,INUserBalDr,INSUMedicalSubDr,INSUType,INSUYllb,INSURylb,DivType,patName,INSUNo,INSUTotAmt,INSUjjzfe,INSUzhzfe,
			INSUgrzfe,zylsh,djlsh,Flag,UserDr,sfrm0,sfrq00,AdmDate,DisDate,inDiagnos,
			outDiagnos,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,InsuPay6,InsuPay7,InsuPay8,InsuPay9,
			InsuPay10,InsuDISAmt,InsuDISInfo,Zstr01,Zstr02,Zstr03,Zstr04,Zstr05,INBALSDNRowid)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CenterDivInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CenterDivInfoExecute ]
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
 	Else {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CenterDivInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CenterDivInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

}
