/// 医保月对账
Class web.DHCINSUBalanceMonCtl Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.DHCINSUBalanceMonCtl).InsertBalanceMonInfo("^^GDSZ^^^^0^0^0^0^0^0^0^0^0^0^^^I^his总金额与医保总金额不符^2019-10-01^2019-10-01^2019-11-15^10:11:11^1^demo^20191001^^^^^^^^^^^^^^^^")
ClassMethod InsertBalanceMonInfo(InString As %String) As %String
{
	n (InString)
	q:InString="" -100
	s ^TMP("InsertBalanceMonInfo")=InString
    s BalanceMonId=+$p(InString,"^",1)
    
    i (BalanceMonId=0)||(BalanceMonId="") d
    .s InsertBalanceMonInfo=$$InsertBalanceMon^DHCINSUBalanceMon(InString)
    e  d
    .i $d(^DHCINSUBalanceMon(BalanceDayId))=0 d
    ..s InsertBalanceMonInfo=$$InsertBalanceMon^DHCINSUBalanceMon(InString)
    .e  d
    ..s InsertBalanceMonInfo=$$UpdateBalanceMon^DHCINSUBalanceMon(InString)

    q InsertBalanceMonInfo
}

/// w ##class(web.DHCINSUBalanceMonCtl).UpdateBalFlag(1,"N")
ClassMethod UpdateBalFlag(INBALSRowid As %String, Flag As %String) As %String
{
	n (INBALSRowid,Flag)
	q:(INBALSRowid="") "-1"
	
	s UpdateBalFlag=$$UpdateFlag^DHCINSUBalanceMon(INBALSRowid,Flag)
	q UpdateBalFlag
}

/// w ##class(web.DHCINSUBalanceDayCtl).GetBalanceMonInfo("1")
ClassMethod GetBalanceMonInfo(INBALSRowid As %String) As %String
{
	n (INBALSRowid)
	q:INBALSRowid="" -100
	q:$d(^DHCINSUBalanceMon(INBALSRowid))=0 "-100"
	s INBALSInfo=$g(^DHCINSUBalanceMon(INBALSRowid))
	s StDate=$p(INBALSInfo,"^",20)	// 开始日期
	s $p(INBALSInfo,"^",20)=$zd(StDate,3)
	s EndDate=$p(INBALSInfo,"^",21)	// 结束日期
	s $p(INBALSInfo,"^",21)=$zd(EndDate,3)
	s iDate=$p(INBALSInfo,"^",22)	// 对账日期
	s $p(INBALSInfo,"^",22)=$zd(iDate,3)
	s iTime=$p(INBALSInfo,"^",23)	// 对账时间
	s $p(INBALSInfo,"^",23)=$zt(iTime,1)
	q INBALSRowid_"^"_INBALSInfo
}

/// d ##class(%ResultSet).RunQuery("web.DHCINSUBalanceMonCtl","BalanceMonInfo","2019-10-01","2019-10-01","","ZZB")
Query BalanceMonInfo(StDate As %String, EnDate As %String, AdmType As %String, InsuType As %String, HospId As %String = "") As %Query(ROWSPEC = "ind,INBALSRowid,INSUType,INSUCenter,INSUYllb,INSURylb,HisTotAmt,HisTotCnt,Hisjjzfe,Hiszhzfe,Hisgrzfe,INSUTotAmt,INSUTotCnt,INSUjjzfe,INSUzhzfe,INSUgrzfe,dzlsh,jylsh,Flag,Info,StDate,EndDate,iDate,iTime,sUserDr,sfrm0,dzqh,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,InsuPay6,InsuPay7,InsuPay8,InsuPay9,InsuPay10,Zstr01,Zstr02,Zstr03,Zstr04,Zstr05,HospitalCode")
{
}

ClassMethod BalanceMonInfoExecute(ByRef qHandle As %Binary, StDate As %String, EnDate As %String, AdmType As %String, InsuType As %String, HospId As %String) As %Status
{
	
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s ^TMP("BalanceMonInfo")=$lb(StDate,EnDate,AdmType,InsuType,HospId)
	q:$g(StDate)="" $$$OK
	s:StDate["-" StDate=$zdh(StDate,3)
	s:EnDate["-" EnDate=$zdh(EnDate,3)
	s:StDate["/" StDate=$zdh(StDate,4)
	s:EnDate["/" EnDate=$zdh(EnDate,4)
	f theDate=StDate:1:EnDate d
	.s INBALSRowid=""
	.f  s INBALSRowid=$o(^DHCINSUBalanceMon("0","BeginDate",theDate,INBALSRowid)) q:INBALSRowid=""  d
	..s INBALInfo=$g(^DHCINSUBalanceMon(INBALSRowid))
	..s INSUType=$p(INBALInfo,"^",2)	          // 医保类型
	..q:(InsuType'="")&&(INSUType'=InsuType)
	..s HospitalCode=$p(INBALInfo,"^",1)	      // 医院代码
	..s INSUCenter=$p(INBALInfo,"^",3)	          // 社保经办机构(分中心)
	..s INSUYllb=$p(INBALInfo,"^",4)	          // 医疗类别
	..s INSURylb=$p(INBALInfo,"^",5)	          // 人员类型
	..s HisTotAmt=+$p(INBALInfo,"^",6)	          // HIS总费用
	..s HisTotCnt=$p(INBALInfo,"^",7)	          // HIS总人次
	..s Hisjjzfe=+$p(INBALInfo,"^",8)	          // HIS基金支付额
	..s Hiszhzfe=+$p(INBALInfo,"^",9)	          // HIS帐户支付额
	..s Hisgrzfe=+$p(INBALInfo,"^",10)	          // HIS个人现金支付额
	..s INSUTotAmt=+$p(INBALInfo,"^",11)	      // 医保总费用
	..s INSUTotCnt=+$p(INBALInfo,"^",12)	      // 医保总人次
	..s INSUjjzfe=+$p(INBALInfo,"^",13)	          // 医保基金支付额
	..s INSUzhzfe=+$p(INBALInfo,"^",14)           // 医保帐户支付额
	..s INSUgrzfe=+$p(INBALInfo,"^",15)	          // 医保个人现金支付额
	..s dzlsh=$p(INBALInfo,"^",16)		          // 对账流水号
	..s jylsh=$p(INBALInfo,"^",17)		          // 交易流水号/业务周期号
	..s Flag=$p(INBALInfo,"^",18)		          // 对账状态
	..s Flag=$case(Flag,"N":"未对账","Y":"已对账","E":"对账失败","S":"作废",:Flag)
	..s Info=$p(INBALInfo,"^",19)		          // 对账说明(失败原因)
	..s StDate=$zd($p(INBALInfo,"^",20),3)	      // 开始日期
	..s EndDate=$zd($p(INBALInfo,"^",21),3)       // 结束日期
	..s iDate=$zd($p(INBALInfo,"^",22),3)	      // 对账日期
	..s iTime=$zt($p(INBALInfo,"^",23),1)	      // 对账时间
	..s sUserDr=$p(INBALInfo,"^",24)	          // 操作员User.SSUser
	..s sfrm0=$p(INBALInfo,"^",25)	              // 操作员姓名
	..s dzqh=$p(INBALInfo,"^",26)	              // 对账周期
	..s InsuPay1=+$p(INBALInfo,"^",27)	          // 医保支付1
	..s InsuPay2=+$p(INBALInfo,"^",28)	          // 医保支付2
	..s InsuPay3=+$p(INBALInfo,"^",29)	          // 医保支付3
	..s InsuPay4=+$p(INBALInfo,"^",30)	          // 医保支付4
	..s InsuPay5=+$p(INBALInfo,"^",31)	          // 医保支付5
	..s InsuPay6=+$p(INBALInfo,"^",32)	          // 医保支付6
	..s InsuPay7=+$p(INBALInfo,"^",33)	          // 医保支付7
	..s InsuPay8=+$p(INBALInfo,"^",34)	          // 医保支付8
	..s InsuPay9=+$p(INBALInfo,"^",35)	          // 医保支付9
	..s InsuPay10=+$p(INBALInfo,"^",36)	          // 医保支付10
	..s Zstr01=$p(INBALInfo,"^",37)	              // 扩展参数01
	..s Zstr02=$p(INBALInfo,"^",38)	              // 扩展参数02
	..s Zstr03=$p(INBALInfo,"^",39)	              // 扩展参数03
	..s Zstr04=$p(INBALInfo,"^",40)	              // 扩展参数04
	..s Zstr05=$p(INBALInfo,"^",41)	              // 扩展参数08
	..d BalanceMInfo
	
    Quit $$$OK
BalanceMInfo
	set Data=$lb(ind,INBALSRowid,INSUType,INSUCenter,INSUYllb,INSURylb,HisTotAmt,HisTotCnt,Hisjjzfe,Hiszhzfe,
			Hisgrzfe,INSUTotAmt,INSUTotCnt,INSUjjzfe,INSUzhzfe,INSUgrzfe,dzlsh,jylsh,Flag,Info,
			StDate,EndDate,iDate,iTime,sUserDr,sfrm0,dzqh,InsuPay1,InsuPay2,InsuPay3,
			InsuPay4,InsuPay5,InsuPay6,InsuPay7,InsuPay8,InsuPay9,InsuPay10,Zstr01,Zstr02,Zstr03,
			Zstr04,Zstr05,HospitalCode)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod BalanceMonInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BalanceMonInfoExecute ]
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

ClassMethod BalanceMonInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BalanceMonInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

}
