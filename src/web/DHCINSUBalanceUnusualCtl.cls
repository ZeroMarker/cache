/// 医保对账差异明细表操作类
Class web.DHCINSUBalanceUnusualCtl Extends %RegisteredObject [ Not ProcedureBlock ]
{

// w ##class(web.DHCINSUBalanceUnusualCtl).InsertBalanceUnusualInfo("^2^43460306^^^^GDSZ^21^C31001^I^黄小卫^3047229^29422568^^14688.31^13123.69^0^1564.62^^^^^H4110201909018767704^A4403001909011900161^^0^^^^^2019-09-01^18:07:37^^^^^13123.69^0^0^0^0^0^0^0^0^0^0^^^^^^^^1")

ClassMethod InsertBalanceUnusualInfo(InString As %String) As %String
{
	n (InString)
	q:InString="" -100
	
	s ^TMP("InsertBalanceUnusualInfo")=InString
    s BalanceUnusualId=+$p(InString,"^",1)
    
    i (BalanceUnusualId=0)||(BalanceUnusualId="") d
    .s InsertBalanceUnusualInfo=$$InsertBalanceUnusual^DHCINSUBalanceUnusual(InString)
    e  d
    .i $d(^DHCINSUBalanceUnusual(BalanceDayId))=0 d
    ..s InsertBalanceUnusualInfo=$$InsertBalanceUnusual^DHCINSUBalanceUnusual(InString)
    .e  d
    ..s InsertBalanceUnusualInfo=$$UpdateBalanceUnusual^DHCINSUBalanceUnusual(InString)

    q InsertBalanceUnusualInfo
}

// d ##class(%ResultSet).RunQuery("web.DHCINSUBalanceUnusualCtl","BalanceUnusualInfo","1","1")

Query BalanceUnusualInfo(BalanceDayDr As %String, UnFlag As %String) As %Query(ROWSPEC = "ind,INBALURowid,HospitalCode,DivideDr，INSUBalanceDayDr,INSUBalanceMonDr,INSUCenterSubDr,INSUType,INSUYllb,INSURylb,DivType,Name,INSUNo,ADMDr,LocName,HisTotAmt,Hisjjzfe,Hiszhzfe,Hisgrzfe,INSUTotAmt,INSUjjzfe,INSUzhzfe,INSUgrzfe,zylsh,djlsh,jylsh,Flag,OptDate,OptTime,sUserDr,OptName,DivDate,DivTime,AdmDate,DisDate,PreDiagnosis,MainDiagnosis,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,InsuPay6,InsuPay7,InsuPay8,InsuPay9,InsuPay10,InsuDISAmt,InsuDISInfo,Zstr01,Zstr02,Zstr03,Zstr04,Zstr05")
{
}

ClassMethod BalanceUnusualInfoExecute(ByRef qHandle As %Binary, BalanceDayDr As %String, UnFlag As %String) As %Status
{
	
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s ^TMP("BalanceUnusualInfo")=$lb(BalanceDayDr,UnFlag)
	q:$g(BalanceDayDr)="" $$$OK
	//q:$g(EnDate)="" $$$OK
	
	s INBALURowid=""
	f  s INBALURowid=$o(^DHCINSUBalanceUnusual("0","INSUBalanceDayDr",BalanceDayDr,INBALURowid)) q:INBALURowid=""  d
	.s INSUType=$p(^DHCINSUBalanceUnusual(INBALURowid),"^",4)	// 医保类型
	.;q:(InsuType'="")&&(INSUType'=InsuType)
	.s UnErrInfo=$G(^DHCINSUBalanceUnusual(INBALURowid))
	.s HospitalCode=$p(UnErrInfo,"^",1)	// 医院代码
	.s DivideDr=$p(UnErrInfo,"^",2)
	.s InsuBalanceDayDr=$p(UnErrInfo,"^",3)	;日对账记录
    .s InsuBalanceMonDr=$p(UnErrInfo,"^",4)	;月对账记录
	.s INSUCenterSubDr=$p(UnErrInfo,"^",5)
	.s INSUYllb=$p(UnErrInfo,"^",7)	// 医疗类别
	.s INSURylb=$p(UnErrInfo,"^",8)	// 人员类型
	.s DivType=$p(UnErrInfo,"^",9)	// 结算类型
	.s Name=$p(UnErrInfo,"^",10)	// 姓名
	.s INSUNo=$p(UnErrInfo,"^",11)	// 医保号
	.s ADMDr=$p(UnErrInfo,"^",12)	// 姓名
	.s LocName=$p(UnErrInfo,"^",13)	// 科室名称
	
	.s HisTotAmt=+$p(UnErrInfo,"^",14)	// HIS总费用
	.q:(UnFlag="0")&&(+HisTotAmt=0)
	.s Hisjjzfe=+$p(UnErrInfo,"^",15)	// HIS基金支付额
	.s Hiszhzfe=+$p(UnErrInfo,"^",16)	// HIS帐户支付额
	.s Hisgrzfe=+$p(UnErrInfo,"^",17)	// HIS个人现金支付额
	.s INSUTotAmt=+$p(UnErrInfo,"^",18)	// 医保总费用
	.q:(UnFlag="1")&&(+INSUTotAmt=0)
	.s INSUjjzfe=+$p(UnErrInfo,"^",19)	// 医保基金支付额
	.s INSUzhzfe=+$p(UnErrInfo,"^",20)	// 医保帐户支付额
	.s INSUgrzfe=+$p(UnErrInfo,"^",21)	// 医保个人现金支付额
	.s zylsh=$p(UnErrInfo,"^",22)		// 登记流水号
	.s djlsh=$p(UnErrInfo,"^",23)		// 单据/结算流水号
	.s jylsh=$p(UnErrInfo,"^",24)		// 交易流水号
	.s Flag=$p(UnErrInfo,"^",25)		// 对账状态
	.q:(UnFlag'="")&&(UnFlag'=Flag)
	.s OptDate=$zd($p(UnErrInfo,"^",26),3)	// 开始日期
	.s OptTime=$zd($p(UnErrInfo,"^",27),3)	// 结束日期
	.s sUserDr=$p(UnErrInfo,"^",28)	// 操作员User.SSUser
	.s OptName=$p(UnErrInfo,"^",29)	// 操作员姓名
	.s DivDate=$p(UnErrInfo,"^",30)	// 收费日期
	.s DivTime=$p(UnErrInfo,"^",31)	// 收费时间
	.s AdmDate=$p(UnErrInfo,"^",32)	// 入院日期
	.s DisDate=$p(UnErrInfo,"^",32)	// 出院日期
	.s PreDiagnosis=$p(UnErrInfo,"^",34)	// 入院诊断
	.s MainDiagnosis=$p(UnErrInfo,"^",35)	// 出院诊断/主要诊断
	
	.s InsuPay1=+$p(UnErrInfo,"^",36)	// 医保支付1
	.s InsuPay2=+$p(UnErrInfo,"^",37)	// 医保支付2
	.s InsuPay3=+$p(UnErrInfo,"^",38)	// 医保支付3
	.s InsuPay4=+$p(UnErrInfo,"^",39)	// 医保支付4
	.s InsuPay5=+$p(UnErrInfo,"^",40)	// 医保支付5
	.s InsuPay6=+$p(UnErrInfo,"^",41)	// 医保支付6
	.s InsuPay7=+$p(UnErrInfo,"^",42)	// 医保支付7
	.s InsuPay8=+$p(UnErrInfo,"^",43)	// 医保支付8
	.s InsuPay9=+$p(UnErrInfo,"^",44)	// 医保支付9
	.s InsuPay10=+$p(UnErrInfo,"^",45)	// 医保支付10
	.s InsuDISAmt=$p(UnErrInfo,"^",46)	// 医保拒付金额
	.s InsuDISInfo=$p(UnErrInfo,"^",47)	// 医保拒付原因
	.s Zstr01=$p(UnErrInfo,"^",48)	// 扩展参数
	.s Zstr02=$p(UnErrInfo,"^",49)	// 扩展参数
	.s Zstr03=$p(UnErrInfo,"^",50)	// 扩展参数
	.s Zstr04=$p(UnErrInfo,"^",51)	// 扩展参数
	.s Zstr05=$p(UnErrInfo,"^",52)	// 扩展参数
	

	.d CenterDivInfoBuild
	
    Quit $$$OK
    
CenterDivInfoBuild
	set Data=$lb(ind,INBALURowid,HospitalCode,DivideDr,InsuBalanceDayDr,InsuBalanceMonDr,INSUCenterSubDr,INSUType,INSUYllb,INSURylb,DivType,Name,INSUNo,
			ADMDr,LocName,HisTotAmt,Hisjjzfe,Hiszhzfe,Hisgrzfe,INSUTotAmt,INSUjjzfe,INSUzhzfe,INSUgrzfe,
			zylsh,djlsh,jylsh,Flag,OptDate,OptTime,sUserDr,OptName,DivDate,DivTime,
			AdmDate,DisDate,PreDiagnosis,MainDiagnosis,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,InsuPay6,
			InsuPay7,InsuPay8,InsuPay9,InsuPay10,InsuDISAmt,InsuDISInfo,Zstr01,Zstr02,Zstr03,Zstr04,
			Zstr05,INSUBalanceDayDr)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod BalanceUnusualInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BalanceUnusualInfoExecute ]
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

ClassMethod BalanceUnusualInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BalanceUnusualInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

}
