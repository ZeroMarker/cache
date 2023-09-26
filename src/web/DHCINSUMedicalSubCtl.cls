/// 医保结算流水表操作类
Class web.DHCINSUMedicalSubCtl Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 保存医院端医保结算明细信息
/// w ##class(web.DHCINSUMedicalSubCtl).InsertMedicalSubInfo("^2^2^^ZZB^11^21^I^测试^10010^719^猜猜科室^1289^0^1289^0^0^0^0^0^10001^dj10001^jy10001^0^^^1^^2019-07-03^15:21:00^2019-07-03^^^^^^^^^^^^^^^^^^^^^")
ClassMethod InsertMedicalSubInfo(InString As %String) As %String
{
	n (InString)
	q:InString="" -100
	s ^TMP("InsertMedicalSubInfo")=InString
    s CenterSubId=+$p(InString,"^",1)
    i CenterSubId=0 d
    .s djlsh=$p(InString,"^",22)
    .s InsuType=$p(InString,"^",5)
    .s zylsh=$p(InString,"^",21)
    .s DivType=$p(InString,"^",8)
    .s MedicalSubId=..GetMedicalSubId(djlsh,zylsh,InsuType,DivType)
    .s $p(InString,"^",1)=MedicalSubId
    i (MedicalSubId=0)||(MedicalSubId="") d
    .s InsertMedicalSubInfo=$$InsertMedicalSub^DHCINSUMedicalSub(InString)
    e  d
    .i $d(^DHCINSUMedicalSub(MedicalSubId))=0 d
    ..s InsertMedicalSubInfo=$$InsertMedicalSub^DHCINSUMedicalSub(InString)
    .e  d
    ..s InsertMedicalSubInfo=$$UpdateMedicalSub^DHCINSUMedicalSub(InString)

    q InsertMedicalSubInfo
}

/// 获取医保结算流水表rowid
/// w ##class(web.DHCINSUMedicalSubCtl).GetMedicalSubId("dj10001","10001","ZZB")
ClassMethod GetMedicalSubId(djlsh As %String, zylsh As %String, InsuType As %String, DivType) As %String
{
	n (djlsh,zylsh,InsuType,DivType)
	q:(djlsh="")||(InsuType="") ""
	s rtn=""
	s MedicalSubId=""
	f  s MedicalSubId=$o(^DHCINSUMedicalSub(0,"djlsh",djlsh,MedicalSubId)) q:MedicalSubId=""  d
    .s MedicalSub=$g(^DHCINSUMedicalSub(MedicalSubId))
    .s tmpInsuType=$p(MedicalSub,"^",4)
    .s tmpDivType=$p(MedicalSub,"^",7)
    .q:tmpInsuType'=InsuType
    .q:tmpDivType'=DivType
    .s tmpzylsh=$p(MedicalSub,"^",20)
    .q:(zylsh'="")&&(tmpzylsh'=zylsh)
    .s rtn=MedicalSubId
    q rtn
}

// w ##class(web.DHCINSUCenterSubCtl).UpdateCenterSubFlag("201909","Y")

ClassMethod UpdateMedicalSubFlag(CenterSubId As %String, Flag As %String) As %String
{
	n (CenterSubId,Flag)
	s OutStr="-1"
	q:CenterSubId="" OutStr
	
	s OutStr=$$UpdateMedicalSubFlag^DHCINSUMedicalSub(CenterSubId,Flag)
	
	q OutStr
}

// w ##class(web.DHCINSUCenterSubCtl).DeleteCenterSubByDate("2019-09-01","2","GDSZ")

ClassMethod DeleteCenterSubByDate(OptDate As %String, HospId As %String, InsuType As %String) As %String
{
	n (OptDate,HospId,InsuType)
	s OutStr="-1"
	q:(OptDate="")||(InsuType="") OutStr
	
	s OutStr=$$DelMedicalSubByDate^DHCINSUMedicalSub(OptDate,HospId,InsuType)
	
	q OutStr
}

// w ##class(web.DHCINSUCenterSubCtl).GetCenterSum("201909","QGYD")

/// 获取医院端明细汇总
ClassMethod GetMeidalSum(Dzqh As %String, InsuType As %String) As %String
{
	n (Dzqh,InsuType)
	s num=0
	s INBALSDNRowid=0
	f  s INBALSDNRowid=$o(^DHCINSUCenterSub("0","Dzqh",Dzqh,INBALSDNRowid)) q:INBALSDNRowid=""  d
	.s CenterSubInfo=^DHCINSUCenterSub(INBALSDNRowid)
	.s tmpInsuType=$p(CenterSubInfo,"^",1)
	.q:tmpInsuType'=InsuType
	.s num=num+1
	q num
}

/// d ##class(%ResultSet).RunQuery("web.DHCINSUMedicalSubCtl","QryMedicalDivInfo","2019-12-23","2019-12-23","","ZZB")
/// 获取医保结算流水表中数据
Query QryMedicalDivInfo(StDate As %String, EnDate As %String, AdmType As %String, InsuType As %String, HospId As %String = "") As %Query(ROWSPEC = "ind:%String,Rowid:%String,HospitalCode:%String,DivideDr:%String,INSUCenterSub:%String,INSUType:%String,INSUYllb:%String,INSURylb:%String,DivType:%String,Name:%String,INSUNo:%String,ADMDr:%String,LocName:%String,HisTotAmt:%String,Hisjjzfe:%String,Hiszhzfe:%String,Hisgrzfe:%String,INSUTotAmt:%String,INSUjjzfe:%String,INSUzhzfe:%String,INSUgrzfe:%String,zylsh:%String,djlsh:%String,jylsh:%String,Flag:%String,OptDate:%String,OptTime:%String,sUserDr:%String,OptName:%String,DivDate:%String,DivTime:%String,AdmDate:%String,DisDate:%String,PreDiagnosis:%String,MainDiagnosis:%String,InsuPay1:%String,InsuPay2:%String,InsuPay3:%String,InsuPay4:%String,InsuPay5:%String,InsuPay6:%String,InsuPay7:%String,InsuPay8:%String,InsuPay9:%String,InsuPay10:%String,InsuDISAmt:%String,InsuDISInfo:%String,Zstr01:%String,Zstr02:%String,Zstr03:%String,Zstr04:%String,Zstr05:%String")
{
}

ClassMethod QryMedicalDivInfoExecute(ByRef qHandle As %Binary, StDate As %String, EnDate As %String, AdmType As %String, InsuType As %String, HospId As %String = "") As %Status
{
	
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s ^TMP("HISDivInfo")=$lb(StDate,EnDate,AdmType,InsuType,HospId)
	q:$g(StDate)="" $$$OK
	q:$g(EnDate)="" $$$OK
	
	s:StDate["-" StDate=$zdh(StDate,3)
	s:EnDate["-" EnDate=$zdh(EnDate,3)
	s:StDate["/" StDate=$zdh(StDate,4)
	s:EnDate["/" EnDate=$zdh(EnDate,4)

	
	f theDate=StDate:1:EnDate d
	.s Rowid=""
	.f  s Rowid=$o(^DHCINSUMedicalSub("0","OptDate",theDate,Rowid)) q:Rowid=""  d
	..s INSUType=$p(^DHCINSUMedicalSub(Rowid),"^",4)	// 医保类型
	..q:(InsuType'="")&&(INSUType'=InsuType)
	..s HospitalCode=$p(^DHCINSUMedicalSub(Rowid),"^",1)	// 医院代码
	..q:(HospId'="")&&(HospId'=HospitalCode)
	..s MedDivInfo=$G(^DHCINSUMedicalSub(Rowid))
	..s DivideDr=$p(MedDivInfo,"^",2)         // 指针User.INSUDivide
	..s CenterSubDr=$p(MedDivInfo,"^",3)	  // 指针User.INSUCenterSub
	..s INSUYllb=$p(MedDivInfo,"^",5)	      // 医疗类别
	..s INSURylb=$p(MedDivInfo,"^",6)	      // 人员类型
	..s DivType=$p(MedDivInfo,"^",7)	      // 结算类型
	..s patName=$p(MedDivInfo,"^",8)	      // 患者姓名
	..s INSUNo=$p(MedDivInfo,"^",9)	          // 医保号/个人编号
	..s ADMDr=$p(MedDivInfo,"^",10)	          // 就诊号
	..s LocName=$p(MedDivInfo,"^",11)	      // 科室名称
	..s HisTotAmt=+$p(MedDivInfo,"^",12)	  // HIS总费用
	..q:+HisTotAmt=0
	..s Hisjjzfe=+$p(MedDivInfo,"^",13)	      // HIS基金支付额
	..s Hiszhzfe=+$p(MedDivInfo,"^",14)	      // HIS医保帐户支付额
	..s Hisgrzfe=+$p(MedDivInfo,"^",15)	      // HIS个人现金支付额
	..s INSUTotAmt=+$p(MedDivInfo,"^",16)	  // HIS总费用
	..s INSUjjzfe=+$p(MedDivInfo,"^",17)	  // 医保基金支付额
	..s INSUzhzfe=+$p(MedDivInfo,"^",18)	  // 医保帐户支付额
	..s INSUgrzfe=+$p(MedDivInfo,"^",19)	  // 医保个人现金支付额
	..s zylsh=$p(MedDivInfo,"^",20)	          // 登记流水号
	..s djlsh=$p(MedDivInfo,"^",21)	          // 单据/结算流水号
	..s jylsh=$p(MedDivInfo,"^",22)	          // 交易流水号
	..s Flag=$p(MedDivInfo,"^",23)	          // 对账状态 0（未对账）1（已对账清算成功）2(对账失败)
	..s OptDate=$zd($p(MedDivInfo,"^",24),3)  // 对账日期
	..s OptTime=$zt($p(MedDivInfo,"^",25))	  // 对账时间
	..s sUserDr=$p(MedDivInfo,"^",26)	      // 操作员User.SSUser
	..s OptName=$p(MedDivInfo,"^",27)	      // 操作员姓名
	..s DivDate=$zd($p(MedDivInfo,"^",28),3)  // 收费日期
	..s DivTime=$zt($p(MedDivInfo,"^",29),1)  // 收费时间
	..s AdmDate=$p(MedDivInfo,"^",30)	      // 入院日期
	..s DisDate=$p(MedDivInfo,"^",31)	      // 出院日期
	..s PreDiagnosis=$p(MedDivInfo,"^",32)	  // 入院诊断
	..s MainDiagnosis=$p(MedDivInfo,"^",33)   // 出院诊断/主要诊断
	..s InsuPay1=+$p(MedDivInfo,"^",34)	      // 医保支付1
	..s InsuPay2=+$p(MedDivInfo,"^",35)	      // 医保支付2
	..s InsuPay3=+$p(MedDivInfo,"^",36)	      // 医保支付3
	..s InsuPay4=+$p(MedDivInfo,"^",37)	      // 医保支付4
	..s InsuPay5=+$p(MedDivInfo,"^",38)	      // 医保支付5
	..s InsuPay6=+$p(MedDivInfo,"^",39)	      // 医保支付6
	..s InsuPay7=+$p(MedDivInfo,"^",40)	      // 医保支付7
	..s InsuPay8=+$p(MedDivInfo,"^",41)	      // 医保支付8
	..s InsuPay9=+$p(MedDivInfo,"^",42)	      // 医保支付9
	..s InsuPay10=+$p(MedDivInfo,"^",43)	  // 医保支付10
	..s InsuDISAmt=+$p(MedDivInfo,"^",44)	  // 医保拒付金额
	..s InsuDISInfo=$p(MedDivInfo,"^",45)	  // 医保拒付原因
	..s Zstr01=$p(MedDivInfo,"^",46)	      // 扩展参数01
	..s Zstr02=$p(MedDivInfo,"^",47)	      // 扩展参数02
	..s Zstr03=$p(MedDivInfo,"^",48)	      // 扩展参数03
	..s Zstr04=$p(MedDivInfo,"^",49)	      // 扩展参数04
	..s Zstr05=$p(MedDivInfo,"^",50)	      // 扩展参数05
	..s ZstrALL=$p(MedDivInfo,"^",51)	      // 扩展参数超长字段500
	
	..d HISDivInfoBuild
	
    Quit $$$OK
    
HISDivInfoBuild
	set Data=$lb(ind,Rowid,HospitalCode,DivideDr,INSUCenterSub,INSUType,INSUYllb,INSURylb,DivType,Name,INSUNo,ADMDr,LocName,HisTotAmt,Hisjjzfe,Hiszhzfe,Hisgrzfe,INSUTotAmt,INSUjjzfe,INSUzhzfe,INSUgrzfe,zylsh,djlsh,jylsh,Flag,OptDate,OptTime,sUserDr,OptName,DivDate,DivTime,AdmDate,DisDate,PreDiagnosis,MainDiagnosis,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,InsuPay6,InsuPay7,InsuPay8,InsuPay9,InsuPay10,InsuDISAmt,InsuDISInfo,Zstr01,Zstr02,Zstr03,Zstr04,Zstr05)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QryMedicalDivInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMedicalDivInfoExecute ]
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

ClassMethod QryMedicalDivInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMedicalDivInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

}
