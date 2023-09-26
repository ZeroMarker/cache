Class web.DHCBillFinancialstatistics Extends %Library.RegisteredObject
{

/// InsuDataType : 医保数据类型  (1:缺省值  按发票表记录获取  ;2:医保接口获取)
Parameter InsuDataType = 1;

/// Creator: zhl
/// CreatDate: 2021-08-27
/// Description: 住院预交金日汇总表
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
/// Output:REP_NO:报表号,CHARGE_DATE:收费日期,CHARGE_MONEY:金额,CHARGE_CODE:操作员编码,CHARGE_NAME:操作员姓名,STATE:状态,PAY_TYPE_CODE:支付方式,HOS_DISTRICT:院区
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillFinancialstatistics","InpatientDepositReport", "2021-9-1", "2021-9-1","1")
Query InpatientDepositReport(stDate As %String, endDate As %String, caliber As %String = "") As websys.Query(ROWSPEC = "REP_NO:%String,CHARGE_DATE:%String,CHARGE_MONEY:%Float,CHARGE_CODE:%String,CHARGE_NAME:%String,STATE:%String,PAY_TYPE_CODE:%String,HOS_DISTRICT:%String") [ SqlProc ]
{
}

ClassMethod InpatientDepositReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, caliber As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    s ind=1
	k ^||TMP("DHCBill","InpatientDepositAcct",$j)
	if ((stDate="")||(endDate="")) quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	s:stDate["-" stDate=$zdh(stDate,3)
	s:stDate["/" stDate=$zdh(stDate,4)	
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate["/" endDate=$zdh(endDate,4)
	
	i +caliber=0  s caliber=1
	
	i caliber=2  d ..BuildIPDepositByReceiveDate(stDate,endDate,"Collect")
	e  d ..BuildIPDepositByJKDate(stDate,endDate,"Collect")
	
	s jkdr=0
	f  s jkdr=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr))  q:jkdr=""   d
	.s usr=$p(^DHCJFUSERJK(jkdr),"^",5)
	.s usrCode=$p(^SSU("SSUSR",usr),"^",1)
	.s usrName=$p(^SSU("SSUSR",usr),"^",2)
	.;s reportNo=$zd(Date,8)_usrCode
	.s reportNo=jkdr
	.s Date=0
	.f  s Date=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date))   q:Date=""   d
	..s prtDate=$zd(Date,3)
	..s hosp=0
	..f  s hosp=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date,hosp))  q:hosp=""    d
	...;s hoscode=$case(hosp,5:0,2:1,"":1)
	...s stat=0
	...f  s stat=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date,hosp,stat))   q:stat=""   d
	....s paymode=0
	....f  s paymode=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date,hosp,stat,paymode))   q:paymode=""   d
	.....s amt=$fn($g(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date,hosp,stat,paymode)),"",2)
	.....i stat=1  s state=0
	.....i stat=2  s state=3
	.....i stat=3  s state=1
	.....i stat=4  s state=2
	.....d OutputRowQFAll
	
	Quit $$$OK
OutputRowQFAll
	set Data=$lb(reportNo,prtDate,amt,usrCode,usrName,state,paymode,hosp)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: zhl
/// CreatDate: 2021-08-27
/// Description: 住院预交金明细表
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
/// Output:REP_NO:报表号,CHARGE_DATE:收费日期,CHARGE_MONEY:金额,CHARGE_CODE:操作员编码,CHARGE_NAME:操作员姓名,STATE:状态,PAY_TYPE_CODE:支付方式,HOS_DISTRICT:院区,CARD_NO:卡号,PATIENT_NAME:病人姓名,HOSPITAL_NO:登记号,BEGIN_NO:票据号码
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillFinancialstatistics","InpatientDepositDetail", "2021-9-1", "2021-9-1","1")
Query InpatientDepositDetail(stDate As %String, endDate As %String, caliber As %String = "") As websys.Query(ROWSPEC = "REP_NO:%String,CHARGE_DATE:%String,PAY_TYPE_CODE:%String,CHARGE_MONEY:%Float,CARD_NO:%String,PATIENT_NAME:%String,CHARGE_CODE:%String,CHARGE_NAME:%String,BEGIN_NO:%String,STATE:%String,HOSPITAL_NO:%String,HOS_DISTRICT:%String") [ SqlProc ]
{
}

ClassMethod InpatientDepositDetailExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, caliber As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    s ind=1
	k ^||TMP("DHCBill","InpatientDepositAcct",$j)
	if ((stDate="")||(endDate="")) quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	s:stDate["-" stDate=$zdh(stDate,3)
	s:stDate["/" stDate=$zdh(stDate,4)	
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate["/" endDate=$zdh(endDate,4)
	
	i +caliber=0  s caliber=1
	
	i caliber=2  d ..BuildIPDepositByReceiveDate(stDate,endDate,"Detail")
	e  d ..BuildIPDepositByJKDate(stDate,endDate,"Detail")
	
	s jkdr=0
	f  s jkdr=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr))  q:jkdr=""   d
	.s usr=$p(^DHCJFUSERJK(jkdr),"^",5)
	.s usrCode=$p(^SSU("SSUSR",usr),"^",1)
	.s usrName=$p(^SSU("SSUSR",usr),"^",2)
	.s reportNo=jkdr
	.s Date=0
	.f  s Date=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date))   q:Date=""   d
	..s prtDate=$zd(Date,3)
	..s hosp=0
	..f  s hosp=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date,hosp))  q:hosp=""    d
	...;s hoscode=$case(hosp,5:0,2:1,"":1)
	...s stat=0
	...f  s stat=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date,hosp,stat))   q:stat=""   d
	....i stat=1  s state=0
	....i stat=2 s state=3
	....i stat=3  s state=1
	....i stat=4  s state=2
	....s paymode=0
	....f  s paymode=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date,hosp,stat,paymode))   q:paymode=""   d
	.....s tab=0
	.....f  s tab=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date,hosp,stat,paymode,tab))  q:tab=""   d
	......s Data=$g(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,Date,hosp,stat,paymode,tab))
	......s adm=$p(Data,"^",1)
	......s rcptNo=$p(Data,"^",2)
	......s amt=$fn($p(Data,"^",3),"",2)
	......s papmi=$p(^PAADM(adm),"^",1)
	......s patNo=$p(^PAPER(papmi,"PAT",1),"^",1)   ;登记号
	......s Medicare=$p(^PAPER(papmi,"PAT",1),"^",22)   ;病案号
	......s cardNo=""
	......s patName=$p(^PAPER(papmi,"ALL"),"^",1)  
	......d OutputDepositDetail
	
	Quit $$$OK
OutputDepositDetail
	set Data=$lb(reportNo,prtDate,paymode,amt,cardNo,patName,usrCode,usrName,rcptNo,state,patNo,hosp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// 根据结算日期组织住院押金数据
ClassMethod BuildIPDepositByJKDate(stDate, endDate, Type)
{
	f Date=stDate:1:endDate   d
	.s deptdr=0
	.f  s deptdr=$o(^DHCSFPRINTDETAIL(0,"JkDate",Date,deptdr))   q:deptdr=""    d
	..d ..BuildIPDepositByDr(deptdr,Type)
	q 0
}

/// 根据接收日期组织住院押金数据
ClassMethod BuildIPDepositByReceiveDate(stDate, endDate, Type)
{
	;f Date=stDate:1:endDate   d
	;.s jkdr=0
	;.f  s jkdr=$o(^DHCJFUSERJK(0,"inceptdate",Date,jkdr))   q:jkdr=""   d
	;..s deptdr=0
	;..f  s deptdr=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr,deptdr))   q:deptdr=""    d
	;...d ..BuildIPDepositByDr(deptdr,Type)
	
	f Date=stDate:1:endDate   d
	.s recdr=0
	.f  s recdr=$o(^DHCIPBILLRECEIVEi(0,"DATE",Date,recdr))   q:recdr=""   d
	..s jkdr=0
	..f  s jkdr=$o(^DHCJFUSERJK(0,"RECEIVEDR",recdr,jkdr))  q:jkdr=""   d
	...s deptdr=0
	...f  s deptdr=$o(^DHCSFPRINTDETAIL(0,"JKDR",jkdr,deptdr))   q:deptdr=""    d
	....d ..BuildIPDepositByDr(deptdr,Type)
	
	q 0
}

/// 对单笔押金数据进行处理
ClassMethod BuildIPDepositByDr(DeptDr, Type)
{
	i (+DeptDr'=0)&($d(^DHCSFPRINTDETAIL(DeptDr)))   d 
	.s Data=$g(^DHCSFPRINTDETAIL(DeptDr))
	.s usr=$p(Data,"^",14)
	.s amt=$p(Data,"^",6)
	.s paymode=$p(Data,"^",9)
	.s status=$p(Data,"^",8)
	.s adm=$p(Data,"^",4)
	.s jkdr=$p(Data,"^",30)
	.s admloc=$p(^PAADM(+adm),"^",4)
	.s hosp=$p(^CTLOC(+admloc),"^",22)
	.s rcptno=$p(Data,"^",1)
	.s prtdate=$p(Data,"^",2)
	.i status=4  s status=1
	.s ^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,prtdate,hosp,status,paymode)=$g(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,prtdate,hosp,status,paymode))+amt
	.q:Type="Collect"
	.s maxid=$o(^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,prtdate,hosp,status,paymode,""),-1)+1
	.s ^||TMP("DHCBill","InpatientDepositAcct",$j,jkdr,prtdate,hosp,status,paymode,maxid)=adm_"^"_rcptno_"^"_amt
	
	q 0
}

/// Creator: zhl
/// CreatDate: 2021-08-27
/// Description: 住院结算
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
/// Output:REP_NO:报表号,CHARGE_DATE:结算日期,CHARGE_MONEY:金额,CHARGE_CODE:操作员编码,CHARGE_NAME:操作员姓名,IS_BACK:状态,PAY_TYPE_CODE:支付方式,HOS_DISTRICT:院区
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillFinancialstatistics","InpatInvReport", "2021-9-1", "2021-9-1","1")
Query InpatInvReport(stDate As %String, endDate As %String, caliber As %String = "") As websys.Query(ROWSPEC = "REP_NO:%String,CHARGE_DATE:%String,PAY_TYPE_CODE:%String,PATIENT_TYPE_CODE:%String,CHARGE_MONEY:%Float,CHARGE_CODE:%String,CHARGE_NAME:%String,IS_BACK:%String,HOS_DISTRICT_CODE:%String") [ SqlProc ]
{
}

ClassMethod InpatInvReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, caliber As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    s ind=1
	k ^||TMP("DHCBill","InpatientDepositAcct",$j)
	if ((stDate="")||(endDate=""))  quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	s:stDate["-" stDate=$zdh(stDate,3)
	s:stDate["/" stDate=$zdh(stDate,4)	
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate["/" endDate=$zdh(endDate,4)
	k ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j)	
	
	i +caliber=0  s caliber=1
	
	i caliber=2  d ..BuildIPInvFeeByReceiveDate(stDate,endDate,"PayMode")
	e  d ..BuildIPInvFeeByJKDate(stDate,endDate,"PayMode")

	s date=0
	f  s date=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date))  q:date=""   d
	.s jkdr=0
	.s reportDate=$zd(date,3)
	.f  s jkdr=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr))   q:jkdr=""   d
	..s usr=$p(^DHCJFUSERJK(jkdr),"^",5)
	..s usrCode=$p(^SSU("SSUSR",usr),"^",1)
	..s usrName=$p(^SSU("SSUSR",usr),"^",2)
	..;s reportNo=reportDate_usrCode
	..s reportNo=jkdr
	..s instype=0
	..f  s instype=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype))   q:instype=""   d
	...;s instypecode=$p(^PAC("ADMREA",instype),"^",1)
	...s instypecode=instype
	...s paymode=0
	...f  s paymode=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype,paymode))   q:paymode=""  d
	....;s paycode=$p(^CT("CTPM",paymode),"^",1)
	....s paycode=paymode
	....s flag=""
	....f  s flag=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype,paymode,flag))   q:flag=""  d
	.....s hosp=""
	.....f  s hosp=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype,paymode,flag,hosp))   q:hosp=""   d
	......s amt=$fn($g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype,paymode,flag,hosp)),"",2)
	......s state=flag
	......d OutputIPInvRep	
	
	k ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j)	
	Quit $$$OK
OutputIPInvRep
	set Data=$lb(reportNo,reportDate,paycode,instypecode,amt,usrCode,usrName,state,hosp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Creator: zhl
/// CreatDate: 2021-08-27
/// Description: 住院结算明细 分类信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
/// Output:REP_NO:报表号,CHARGE_DATE:结算日期,CHARGE_MONEY:金额,CHARGE_CODE:操作员编码,CHARGE_NAME:操作员姓名,IS_BACK:状态,PAY_TYPE_CODE:支付方式,HOS_DISTRICT:院区,PATIENT_TYPE_CODE:患者类型,DEPT_CODE:病人科室,CHARGE_KIND_CODE:收费类别
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillFinancialstatistics","InpatInvReportCatInfo", "2021-09-01", "2021-09-01","1")
Query InpatInvReportCatInfo(stDate As %String, endDate As %String, caliber As %String = "") As websys.Query(ROWSPEC = "REP_NO:%String,CHARGE_DATE:%String,DEPT_CODE:%String,CHARGE_KIND_CODE:%String,CHARGE_MONEY:%Float,CHARGE_CODE:%String,CHARGE_NAME:%String,IS_BACK:%String,HOS_DISTRICT_CODE:%String,PATIENT_TYPE_CODE:%String") [ SqlProc ]
{
}

ClassMethod InpatInvReportCatInfoExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, caliber As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    s ind=1
	k ^||TMP("DHCBill","InpatientDepositAcct",$j)
	if ((stDate="")||(endDate=""))  quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	s:stDate["-" stDate=$zdh(stDate,3)
	s:stDate["/" stDate=$zdh(stDate,4)	
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate["/" endDate=$zdh(endDate,4)
	k ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j)	
	
	i +caliber=0  s caliber=1
	
	i caliber=2  d ..BuildIPInvFeeByReceiveDate(stDate,endDate,"CatFee")
	e  d ..BuildIPInvFeeByJKDate(stDate,endDate,"CatFee")
	
	s date=0
	f  s date=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date))  q:date=""   d
	.s jkdr=0
	.s reportDate=$zd(date,8)
	.f  s jkdr=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr))   q:jkdr=""   d
	..s usr=$p(^DHCJFUSERJK(jkdr),"^",5)
	..s usrCode=$p(^SSU("SSUSR",usr),"^",1)
	..s usrName=$p(^SSU("SSUSR",usr),"^",2)
	..s reportNo=jkdr
	..s instype=""
	..f  s instype=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype))   q:instype=""   d
	...s loc=0
	...f  s loc=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype,loc))   q:loc=""   d
	....s loccode=$p(^CTLOC(loc),"^",1)
	....s catdr=0
	....f  s catdr=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype,loc,catdr))   q:catdr=""  d
	.....s catcode=$p(^DHCTarC("AC",catdr),"^",1)
	.....s flag=""
	.....f  s flag=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype,loc,catdr,flag))   q:flag=""  d
	......s hosp=""
	......f  s hosp=$o(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype,loc,catdr,flag,hosp))   q:hosp=""   d
	.......s amt=$fn($g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,date,jkdr,instype,loc,catdr,flag,hosp)),"",2)
	.......s state=flag
	.......d OutputIPInvRepcat
	
	k ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j)
	Quit $$$OK
OutputIPInvRepcat
	set Data=$lb(reportNo,reportDate,loc,catdr,amt,usrCode,usrName,state,hosp,instype)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// 按结算日期组织住院收费数据
ClassMethod BuildIPInvFeeByJKDate(stDate, endDate, Type)
{
	f Date=stDate:1:endDate   d
	.s invdr=0
	.f  s invdr=$o(^DHCINVPRTZY(0,"HANDDATE",Date,invdr))  q:invdr=""  d
	..d ..BuildIPInvFee(invdr,Type)
	
	q 0
}

/// 按接收日期组织住院收费数据
ClassMethod BuildIPInvFeeByReceiveDate(stDate, endDate, Type)
{
	;f Date=stDate:1:endDate   d
	;.s jkdr=0
	;.f  s jkdr=$o(^DHCJFUSERJK(0,"inceptdate",Date,jkdr))   q:jkdr=""   d
	;..s invdr=0
	;..f  s invdr=$o(^DHCINVPRTZY(0,"JK",jkdr,invdr))  q:invdr=""  d
	;...d ..BuildIPInvFee(invdr,Type)

	f Date=stDate:1:endDate   d
	.s recdr=0
	.f  s recdr=$o(^DHCIPBILLRECEIVEi(0,"DATE",Date,recdr))   q:recdr=""   d
	..s jkdr=0
	..f  s jkdr=$o(^DHCJFUSERJK(0,"RECEIVEDR",recdr,jkdr))  q:jkdr=""   d
	...s invdr=0
	...f  s invdr=$o(^DHCINVPRTZY(0,"JK",jkdr,invdr))  q:invdr=""  d
	....d ..BuildIPInvFee(invdr,Type)	

	q 0
}

/// 对单笔发票数据进行处理
ClassMethod BuildIPInvFee(InvDr, Type)
{
	i (+InvDr'=0)&($d(^DHCINVPRTZY(InvDr)))   d
	.s Data=$g(^DHCINVPRTZY(InvDr))
	.s usr=$p(Data,"^",7)
	.s flag=$p(Data,"^",8)
	.s Date=$p(Data,"^",2)
	.s initinv=$p(Data,"^",13)
	.s instype=$p(Data,"^",9)
	.s deposit=$p(Data,"^",22)
	.s status=0
	.i (flag="S")&(initinv'="")  s status=1
	.i (flag="A")&(initinv="")   s status=3
	.q:(flag="A")&(initinv'="")
	.s invbill=$p(Data,"^",5)
	.s jkdr=$p(Data,"^",23)
	.s hosp=$p(Data,"^",35)
	.s adm=$p(Data,"^",4)
	.s admloc=$p(^PAADM(+adm),"^",4)
	.s paysub=0
	.f  s paysub=$o(^DHCINVPRTZY(InvDr,"P",paysub))   q:(paysub="")||(Type'="PayMode")   d
	..s paysubData=$g(^DHCINVPRTZY(InvDr,"P",paysub))
	..s paymode=$p(paysubData,"^",1)
	..s payamt=$p(paysubData,"^",3)
	..s paycode=$p(^CT("CTPM",paymode),"^",1)
	..q:(paycode["INSU")&(flag'="A")&(..#InsuDataType=2)
	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,paycode,status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,paycode,status,hosp))+payamt
	.s pbo=0
	.f  s pbo=$o(^DHCPB(+invbill,"O",pbo))   q:(pbo="")||(Type'="CatFee")   d
	..s pbd=0
	..f  s pbd=$o(^DHCPB(+invbill,"O",pbo,"D",pbd))   q:(pbd="")||(Type'="CatFee")   d
	...s tari=$p(^DHCPB(+invbill,"O",pbo,"D",pbd),"^",3)
	...s catsub=$p(^DHCTARI(+tari),"^",5)
	...s itmamt=$p(^DHCPB(+invbill,"O",pbo,"D",pbd),"^",7)
	...s itmpatamt=$p(^DHCPB(+invbill,"O",pbo,"D",pbd),"^",10)
	...s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,admloc,catsub,status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,admloc,catsub,status,hosp))+itmamt
	.;s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"Deposit",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"Deposit",status,hosp))+deposit
	.q:(..#InsuDataType=1)
	.i (flag="S")&&(initinv'="")  d
  	..s OldBillNo=$p(^DHCINVPRTZY(initinv),"^",5)
  	..s ybdata=##class(web.DHCINSUPort).GetDivideByPBDr(OldBillNo,"S")
  	.i (flag="N")||(initinv="")  d
  	..S NewInv=$O(^DHCINVPRTZY(0,"InitInv",InvDr,""))
  	..I NewInv'="" s ybdata=##class(web.DHCINSUPort).GetDivideByPBDr(invbill,"B")
 	..e  d  s ybdata=##class(web.DHCINSUPort).GetDivideByPBDr(invbill,"")
	.i $g(ybdata)'=""     d
	..;总费用1^医保支付金额2^账户支付金额3^现金4^医疗救助5^公务员补助6^军残补助7^民政救助8^非典补助9^民政优抚10^生育补助11^基本医疗12^城乡大病13
  	..s ALLamt=$P(ybdata,"^",1),ybtc=$P(ybdata,"^",2),ybaccount=$P(ybdata,"^",3),ybzf=$P(ybdata,"^",4),dejz=$P(ybdata,"^",5)
  	..s gwybz=$P(ybdata,"^",6),jcbz=$P(ybdata,"^",7),mzbz=$P(ybdata,"^",8),fdbz=$P(ybdata,"^",9),mzyf=$P(ybdata,"^",10),sybz=$P(ybdata,"^",11),jbyl=$P(ybdata,"^",12),cxdb=$P($g(ybdata),"^",13)
  	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"GRZHINSU",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"GRZHINSU",status,hosp))+ybaccount
  	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"GWYBZINSU",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"GWYBZINSU",status,hosp))+gwybz
  	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"MZJZINSU",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"MZJZINSU",status,hosp))+mzbz
  	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"SYBKINSU",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"SYBKINSU",status,hosp))+sybz
  	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"DEJZINSU",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"DEJZINSU",status,hosp))+dejz
  	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"JCBZINSU",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"JCBZINSU",status,hosp))+jcbz
  	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"YFBZINSU",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"YFBZINSU",status,hosp))+mzyf
  	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"CXDBJZ",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"CXDBJZ",status,hosp))+cxdb
  	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"YBJJ",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"YBJJ",status,hosp))+jbyl
  	..s ^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"FDBZ",status,hosp)=$g(^||TMP("DHCBill","OutToERP","IutpatInvReport",$j,Date,jkdr,instype,"FDBZ",status,hosp))+fdbz
	q 0
}

/// Creator: zhl
/// CreatDate: 2021-08-27
/// Description: 门诊预交金日汇总表
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
/// Output:REP_NO:报表号,CHARGE_DATE:收费日期,CHARGE_MONEY:金额,CHARGE_CODE:操作员编码,CHARGE_NAME:操作员姓名,STATE:状态,PAY_TYPE_CODE:支付方式,HOS_DISTRICT:院区
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillFinancialstatistics","OutpatientDepositReport", "2021-9-1", "2021-9-1","1")
Query OutpatientDepositReport(stDate As %String, endDate As %String, caliber As %String = "") As websys.Query(ROWSPEC = "REP_NO:%String,CHARGE_DATE:%String,CHARGE_MONEY:%Float,CHARGE_CODE:%String,CHARGE_NAME:%String,STATE:%String,PAY_TYPE_CODE:%String,HOS_DISTRICT_CODE:%String") [ SqlProc ]
{
}

ClassMethod OutpatientDepositReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, caliber As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0) 
    s ind=1
	k ^||TMP("DHCBill","OutpatientDepositAcct",$j)
	if ((stDate="")||(endDate="")) quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	s:stDate["-" stDate=$zdh(stDate,3)
	s:stDate["/" stDate=$zdh(stDate,4)	
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate["/" endDate=$zdh(endDate,4)
	
	i +caliber=0  s caliber=1
	
	i caliber=2  d ..BuildOPDepositByReceiveDate(stDate,endDate,"Collect")
	e  d ..BuildOPDepositByJKDate(stDate,endDate,"Collect")

	s jkdr=""
	f  s jkdr=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr))   q:jkdr=""   d
	.s reportNo=jkdr
	.s usr=$p(^DHCOPInsFoot(jkdr),"^",8)
	.s usrCode=$p(^SSU("SSUSR",usr),"^",1)
	.s usrName=$p(^SSU("SSUSR",usr),"^",2)
	.s Date=""
	.f  s Date=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date))   q:Date=""   d
	..s reportDate=$zd(Date,3)
	..s stat=""
	..f  s stat=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,stat))   q:stat=""   d
	...s state=stat
	...s paymode=""
	...f  s paymode=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,stat,paymode))   q:paymode=""   d
	....s hosp=""
	....f  s hosp=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,stat,paymode,hosp))   q:hosp=""   d
	.....s amt=$fn($g(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,stat,paymode,hosp)),"",2)
	.....d OutputOPDepositRep
	
	k ^||TMP("DHCBill","OutpatientDepositAcct",$j)

	Quit $$$OK
OutputOPDepositRep
	set Data=$lb(reportNo,reportDate,amt,usrCode,usrName,state,paymode,hosp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Creator: zhl
/// CreatDate: 2021-08-27
/// Description: 门诊预交金明细表
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
/// Output:REP_NO:报表号,CHARGE_DATE:收费日期,CHARGE_MONEY:金额,CHARGE_CODE:操作员编码,CHARGE_NAME:操作员姓名,STATE:状态,PAY_TYPE_CODE:支付方式,HOS_DISTRICT:院区,CARD_NO:卡号,PATIENT_NAME:病人姓名,HOSPITAL_NO:登记号,BEGIN_NO:票据号码
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillFinancialstatistics","OutpatientDepositDetail", "2021-9-1", "2021-9-1","1")
Query OutpatientDepositDetail(stDate As %String, endDate As %String, caliber As %String = "") As websys.Query(ROWSPEC = "REP_NO:%String,CHARGE_DATE:%String,PAY_TYPE_CODE:%String,CHARGE_MONEY:%Float,CARD_NO:%String,PATIENT_NAME:%String,CHARGE_CODE:%String,CHARGE_NAME:%String,BEGIN_NO:%String,STATE:%String,HOSPITAL_NO:%String,HOS_DISTRICT_CODE:%String") [ SqlProc ]
{
}

ClassMethod OutpatientDepositDetailExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, caliber As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0) 
    s ind=1
	k ^||TMP("DHCBill","OutpatientDepositAcct",$j)
	if ((stDate="")||(endDate=""))  quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	s:stDate["-" stDate=$zdh(stDate,3)
	s:stDate["/" stDate=$zdh(stDate,4)	
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate["/" endDate=$zdh(endDate,4)
	
	i +caliber=0  s caliber=1
	
	i caliber=2  d ..BuildOPDepositByReceiveDate(stDate,endDate,"Detail")
	e  d ..BuildOPDepositByJKDate(stDate,endDate,"Detail")
	
	s jkdr=""
	f  s jkdr=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr))   q:jkdr=""   d
	.s reportNo=jkdr
	.s usr=$p(^DHCOPInsFoot(jkdr),"^",8)
	.s usrCode=$p(^SSU("SSUSR",usr),"^",1)
	.s usrName=$p(^SSU("SSUSR",usr),"^",2)
	.s Date=""
	.f  s Date=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date))   q:Date=""   d
	..s reportDate=$zd(Date,3)
	..s stat=""
	..f  s stat=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,stat))   q:stat=""   d
	...s state=stat
	...s paymode=""
	...f  s paymode=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,stat,paymode))   q:paymode=""   d
	....s hosp=""
	....f  s hosp=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,stat,paymode,hosp))   q:hosp=""   d
	.....s tab=""
	.....f  s tab=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,stat,paymode,hosp,tab))  q:tab=""   d
	......s Data=$g(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,stat,paymode,hosp,tab))
	......s papmi=$p(Data,"^",2)
	......s patNo=$p(^PAPER(papmi,"PAT",1),"^",1)   ;登记号
	......s Medicare=$p(^PAPER(papmi,"PAT",1),"^",22)   ;病案号
	......s cardNo=""
	......s patName=$p(^PAPER(papmi,"ALL"),"^",1)  
	......s rcptNo=$p(Data,"^",3)
	......s amt=$fn($p(Data,"^",4),"",2)
	......d OutputOPDepositDetail
	
	Quit $$$OK
OutputOPDepositDetail
	set Data=$lb(reportNo,reportDate,paymode,amt,cardNo,patName,usrCode,usrName,rcptNo,stat,patNo,hosp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// 按日结算日期组织门诊押金数据
ClassMethod BuildOPDepositByJKDate(stDate, endDate, Type)
{
	f Date=stDate:1:endDate   d
	.s EPAcct=0
	.f  s EPAcct=$o(^DHCEPMi("EPM",0,"EPMDFootDate",Date,EPAcct))   q:EPAcct=""    d
	..s EPD=0
	..f  s EPD=$o(^DHCEPMi("EPM",0,"EPMDFootDate",Date,EPAcct,"EPMD",EPD))  q:EPD=""  d
	...d ..BuildEPDeptData(EPAcct_"||"_EPD,Type)
	.s Acct=0
	.f  s Acct=$o(^DHCACDi("AccM",0,"FD",Date,Acct))   q:Acct=""    d
	..s APD=0
	..f  s APD=$o(^DHCACDi("AccM",0,"FD",Date,Acct,"AccPD",APD))  q:APD=""  d
	...d ..BuildAccPDData(Acct_"||"_APD,Type)
	
	q 0
}

/// 按接收结算日期组织门诊押金数据
ClassMethod BuildOPDepositByReceiveDate(stDate, endDate, Type)
{
	f Date=stDate:1:endDate   d
	.s receivedr=""
	.f  s receivedr=$o(^DHCOPBILLRECEIVEi(0,"DATE",Date,receivedr))   q:receivedr=""   d
	..s jkdr=""
	..f  s jkdr=$o(^DHCOPInsFootI(0,"RECEIVEDR",receivedr,jkdr))   q:jkdr=""   d
	...s EPAcct=0
	...f  s EPAcct=$o(^DHCEPMi("EPM",0,"EPMDReport",jkdr,EPAcct))   q:EPAcct=""    d
	....s EPD=0
	....f  s EPD=$o(^DHCEPMi("EPM",0,"EPMDReport",jkdr,EPAcct,"EPMD",EPD))  q:EPD=""  d
	.....d ..BuildEPDeptData(EPAcct_"||"_EPD,Type)
	...s Acct=0
	...f  s Acct=$o(^DHCACDi("AccM",0,"PDFootDR",jkdr,Acct))   q:Acct=""    d
	....s APD=0
	....f  s APD=$o(^DHCACDi("AccM",0,"PDFootDR",jkdr,Acct,"AccPD",APD))  q:APD=""  d
	.....d ..BuildAccPDData(Acct_"||"_APD,Type)
	
	q 0
}

/// 对单笔的院内账户押金数据进行处理
ClassMethod BuildAccPDData(AccPD, Type)
{
	s Acct=+AccPD
	s APD=$p(AccPD,"||",2)
	i (+Acct'=0)&(+APD'=0)&($d(^DHCACD("AccM",Acct,"AccPD",APD)))   d
	.s Data=$g(^DHCACD("AccM",Acct,"AccPD",APD))
	.s usr=$p(Data,"^",5)
	.s jkdr=$p(Data,"^",7)
	.s hosp=$p(Data,"^",15)
	.s Date=$p(Data,"^",3)
	.s amt=$p(Data,"^",2)
	.s psub=$o(^DHCACD("AccM",Acct,"AccPD",APD,"P",0))
	.s paymode=$p(^DHCACD("AccM",Acct,"AccPD",APD,"P",psub),"^",1)
	.s status=$p(Data,"^",1)
	.;i status="P"  s status=0
	.;i status="R"  s status=1
	.i amt>0  s status=0
	.e  s status=1
	.s ^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,status,paymode,hosp)=$g(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,status,paymode,hosp))+amt
	.q:Type'="Detail"
	.s papmi=$p(^DHCACD("AccM",Acct),"^",2)
	.s billnum=$p(Data,"^",6)
	.s maxid=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,status,paymode,hosp,""),-1)+1
	.s ^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,status,paymode,hosp,maxid)="^"_papmi_"^"_billnum_"^"_amt
	q 0
}

/// 对单笔的急诊留观押金数据进行处理
ClassMethod BuildEPDeptData(EPAPD, Type)
{
	s EPAcct=+EPAPD
	s EPD=$p(EPAPD,"||",2)
	i (+EPAcct'=0)&(+EPD'=0)&($d(^DHCEPM("EPM",EPAcct,"EPMD",EPD)))   d
	.s Data=$g(^DHCEPM("EPM",EPAcct,"EPMD",EPD))
	.s usr=$p(Data,"^",5)
	.s amt=$p(Data,"^",2)
	.s jkdr=$p(Data,"^",7)
	.s hosp=$p(Data,"^",13)
	.s Date=$p(Data,"^",3)
	.s psub=$o(^DHCEPM("EPM",EPAcct,"EPMD",EPD,"P",0))
	.s paymode=$p(^DHCEPM("EPM",EPAcct,"EPMD",EPD,"P",psub),"^",1)
	.s status=$p(Data,"^",1)
	.;i status="P"  s status=0
	.;i status="R"  s status=1
	.i amt>0  s status=0
	.e  s status=1
	.s ^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,status,paymode,hosp)=$g(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,status,paymode,hosp))+amt
	.q:Type'="Detail"
	.s adm=$p(^DHCEPM("EPM",EPAcct),"^",2)
	.s papmi=$p(^DHCEPM("EPM",EPAcct),"^",3)
	.s billnum=$p(Data,"^",6)
	.s maxid=$o(^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,status,paymode,hosp,""),-1)+1
	.s ^||TMP("DHCBill","OutpatientDepositAcct",$j,jkdr,Date,status,paymode,hosp,maxid)=adm_"^"_papmi_"^"_billnum_"^"_amt
	
	q 0
}

/// Creator: zhl
/// CreatDate: 2021-08-27
/// Description: 门急诊结算
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
/// Output:REP_NO:报表号,CHARGE_DATE:结算日期,CHARGE_MONEY:金额,CHARGE_CODE:操作员编码,CHARGE_NAME:操作员姓名,IS_BACK:状态,PAY_TYPE_CODE:支付方式,HOS_DISTRICT:院区
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillFinancialstatistics","OutpatInvReport", "2021-9-1", "2021-9-1","1")
Query OutpatInvReport(stDate As %String, endDate As %String, caliber As %String = "") As websys.Query(ROWSPEC = "REP_NO:%String,CHARGE_DATE:%String,PAY_TYPE_CODE:%String,PATIENT_TYPE_CODE:%String,CHARGE_MONEY:%Float,CHARGE_CODE:%String,CHARGE_NAME:%String,IS_BACK:%String,HOS_DISTRICT_CODE:%String") [ SqlProc ]
{
}

ClassMethod OutpatInvReportExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, caliber As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    s ind=1

	if ((stDate="")||(endDate=""))  quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	s:stDate["-" stDate=$zdh(stDate,3)
	s:stDate["/" stDate=$zdh(stDate,4)	
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate["/" endDate=$zdh(endDate,4)
	k ^||TMP("DHCBill","OutToERP","OutpatInvReport",$j)	
	
	i +caliber=0  s caliber=1
	
	i caliber=2  d ..BuildOPInvFeeByReceiveDate(stDate,endDate,"PayMode")
	e  d ..BuildOPInvFeeByJKDate(stDate,endDate,"PayMode")
	
	s jkdr=""
	f  s jkdr=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr))  q:jkdr=""   d
	.s date=""
	.s reportNo=jkdr
	.s usr=$p(^DHCOPInsFoot(jkdr),"^",8)
	.s usrCode=$p(^SSU("SSUSR",usr),"^",1)
	.s usrName=$p(^SSU("SSUSR",usr),"^",2)
	.f  s date=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date))   q:date=""   d
	..s reportDate=$zd(date,3)
	..s instype=""
	..f  s instype=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype))  q:instype=""   d
	...s paymode=""
	...f  s paymode=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype,paymode))  q:paymode=""   d
	....s status=""
	....f  s status=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype,paymode,status))   q:status=""   d
	.....s hosp=""
	.....f  s hosp=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype,paymode,status,hosp))   q:hosp=""  d
	......s amt=$fn($g(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype,paymode,status,hosp)),"",2)
	......d OutputOPInvRep	
	
	k ^||TMP("DHCBill","OutToERP","OutpatInvReport",$j)	

	Quit $$$OK
OutputOPInvRep
	set Data=$lb(reportNo,reportDate,paymode,instype,amt,usrCode,usrName,status,hosp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Creator: zhl
/// CreatDate: 2021-08-27
/// Description: 门急诊收费 分类信息
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
/// Output:REP_NO:报表号,CHARGE_DATE:结算日期,CHARGE_MONEY:金额,CHARGE_CODE:操作员编码,CHARGE_NAME:操作员姓名,IS_BACK:状态,PAY_TYPE_CODE:支付方式,HOS_DISTRICT:院区,PATIENT_TYPE_CODE:患者类型,DEPT_CODE:病人科室,CHARGE_KIND_CODE:收费类别
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillFinancialstatistics","OutpatInvReportCatInfo", "2021-9-1", "2021-9-1","1")
Query OutpatInvReportCatInfo(stDate As %String, endDate As %String, caliber As %String = "") As websys.Query(ROWSPEC = "REP_NO:%String,CHARGE_DATE:%String,DEPT_CODE:%String,CHARGE_KIND_CODE:%String,CHARGE_MONEY:%Float,CHARGE_CODE:%String,CHARGE_NAME:%String,IS_BACK:%String,HOS_DISTRICT_CODE:%String,PATIENT_TYPE_CODE:%String") [ SqlProc ]
{
}

ClassMethod OutpatInvReportCatInfoExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, caliber As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    s ind=1

	if ((stDate="")||(endDate=""))  quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	s:stDate["-" stDate=$zdh(stDate,3)
	s:stDate["/" stDate=$zdh(stDate,4)	
	s:endDate["-" endDate=$zdh(endDate,3)
	s:endDate["/" endDate=$zdh(endDate,4)
	k ^||TMP("DHCBill","OutToERP","OutpatInvReport",$j)	
	
	i +caliber=0  s caliber=1
	
	i caliber=2  d ..BuildOPInvFeeByReceiveDate(stDate,endDate,"CatFee")
	e  d ..BuildOPInvFeeByJKDate(stDate,endDate,"CatFee")
	
	s jkdr=""
	f  s jkdr=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr))  q:jkdr=""   d
	.s reportNo=jkdr
	.s usr=$p(^DHCOPInsFoot(jkdr),"^",8)
	.s usrCode=$p(^SSU("SSUSR",usr),"^",1)
	.s usrName=$p(^SSU("SSUSR",usr),"^",2)
	.s date=""
	.f  s date=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date))   q:date=""   d
	..s reportDate=$zd(date,8)
	..s instype=""
	..f  s instype=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype))   q:instype=""    d
	...s loc=""
	...f  s loc=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype,loc))   q:loc=""   d
	....s loccode=$p(^CTLOC(loc),"^",1)
	....s catdr=""
	....f  s catdr=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype,loc,catdr))   q:catdr=""  d
	.....;s catcode=$p(^DHCTarC("AC",catdr),"^",1)
	.....s flag=""
	.....f  s flag=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype,loc,catdr,flag))   q:flag=""  d
	......s hosp=""
	......f  s hosp=$o(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype,loc,catdr,flag,hosp))  q:hosp=""   d
	.......s amt=$fn($g(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,date,instype,loc,catdr,flag,hosp)),"",2)
	.......s state=flag
	.......d OutputOPInvRepcat	
	
	k ^||TMP("DHCBill","OutToERP","OutpatInvReport",$j)	

	Quit $$$OK
OutputOPInvRepcat
	set Data=$lb(reportNo,reportDate,loc,catdr,amt,usrCode,usrName,state,hosp,instype)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// 按结算日期组织住院收费数据
ClassMethod BuildOPInvFeeByJKDate(stDate, endDate, Type)
{
	f Date=stDate:1:endDate   d
	.s invdr=0
	.f  s invdr=$o(^DHCINVPRT(0,"HandDate",Date,invdr))  q:invdr=""  d
	..d ..BuildOPInvFee(invdr,Type)
	
	q 0
}

/// 按接收日期组织住院收费数据
ClassMethod BuildOPInvFeeByReceiveDate(stDate, endDate, Type)
{
	f Date=stDate:1:endDate   d
	.s receivedr=0
	.f  s receivedr=$o(^DHCOPBILLRECEIVEi(0,"DATE",Date,receivedr))   q:receivedr=""   d
	..s jkdr=0
	..f  s jkdr=$o(^DHCOPInsFootI(0,"RECEIVEDR",receivedr,jkdr))  q:jkdr=""   d
	...s invdr=0
	...f  s invdr=$o(^DHCINVPRT(0,"Report",jkdr,invdr))  q:invdr=""  d
	....d ..BuildOPInvFee(invdr,Type)
	q 0
}

/// 对单笔发票数据进行处理
ClassMethod BuildOPInvFee(InvDr, Type)
{
	i (+InvDr'=0)&($d(^DHCINVPRT(InvDr)))   d
	.s Data=$g(^DHCINVPRT(InvDr))
	.s usr=$p(Data,"^",21)
	.s flag=$p(Data,"^",8)
	.s initinv=$p(Data,"^",13)
	.s instype=$p(Data,"^",9)
	.s status=0
	.i (flag="S")&(initinv'="")  s status=1
	.i (flag="A")&(initinv="")   s status=3
	.q:(flag="A")&(initinv'="")
	.s Date=$p(Data,"^",5)
	.s jkdr=$p(Data,"^",6)
	.s hosp=$p(Data,"^",39)
	.;b ;s adm=$p(Data,"^",4)
	.s cons=$o(^DHCBCI(0,"INV",InvDr,""))
	.s adm=$p(^DHCBCI(cons),"^",3) 
	.s admloc=$p(^PAADM(+adm),"^",4)
	.s paysub=0
	.f  s paysub=$o(^DHCINVPRT(+InvDr,"P",paysub))   q:(paysub="")||(Type'="PayMode")   d
	..s paymode=$p(^DHCINVPRT(+InvDr,"P",paysub),"^",1)
	..s payamt=$p(^DHCINVPRT(+InvDr,"P",paysub),"^",3)
	..s ^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,Date,instype,paymode,status,hosp)=$g(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,Date,instype,paymode,status,hosp))+payamt
	.q:(Type'="CatFee")
	.s cons=0
	.f  s cons=$o(^DHCBCI(0,"INV",InvDr,cons))   q:(cons="")||(Type'="CatFee")  d
	..s invbill=$p(^DHCBCI(cons),"^",2)
	..s pbo=0
	..f  s pbo=$o(^DHCPB(+invbill,"O",pbo))   q:(pbo="")||(Type'="CatFee")   d
	...s pbd=0
	...f  s pbd=$o(^DHCPB(+invbill,"O",pbo,"D",pbd))   q:(pbd="")||(Type'="CatFee")   d
	....s tari=$p(^DHCPB(+invbill,"O",pbo,"D",pbd),"^",3)
	....s catsub=$p(^DHCTARI(+tari),"^",15)
	....s itmamt=$p(^DHCPB(+invbill,"O",pbo,"D",pbd),"^",7)
	....s itmpatamt=$p(^DHCPB(+invbill,"O",pbo,"D",pbd),"^",10)
	....s ^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,Date,instype,admloc,catsub,status,hosp)=$g(^||TMP("DHCBill","OutToERP","OutpatInvReport",$j,jkdr,Date,instype,admloc,catsub,status,hosp))+itmamt

	q 0
}

/// Creator: TianZJ
/// CreatDate: 2022-07-19
/// Description: 查询票据使用情况
/// Input: stDate:开始日期(不能为空)
///        endDate:结束日期(不能为空)
///        type:发票类型（OP:门诊发票、IP：住院发票、DEP:住院预交金票据）
/// Output:INVStartInv:发票号,INVUsrCode：操作员工号,INVUsrName：操作员姓名,INVUsrDate：使用日期,INVMoney：发票金额,HospitalID：院区
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillFinancialstatistics","OutInvNoInfo", "2021-12-30", "2021-12-30","OP")
Query OutInvNoInfo(stDate As %String, endDate As %String, type As %String) As websys.Query(ROWSPEC = "INVStartInv:%String,INVUsrCode:%String,INVUsrName:%String,INVUsrDate:%String,INVMoney:%Float,HospitalID:%String") [ SqlProc ]
{
}

ClassMethod OutInvNoInfoExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    s ind=1

	if ((stDate="")||(endDate=""))  quit $$$OK
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	if (type="DEP"){
		; 押金数据 dhc_sfprintdetail
		for date=stDate:1:endDate  do
		.set INVID=""
		.for  set INVID=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,INVID)) quit:INVID=""  do
		..set INVStartInv=$p(^DHCSFPRINTDETAIL(INVID),"^",1)
		..quit:INVStartInv=""
		..set INVUsrDr=$p(^DHCSFPRINTDETAIL(INVID),"^",14)
		..set INVUsrCode=$p($g(^SSU("SSUSR",INVUsrDr)),"^",1)
		..set INVUsrName=$p($g(^SSU("SSUSR",INVUsrDr)),"^",2)
		..set INVUsrDate=$p(^DHCSFPRINTDETAIL(INVID),"^",2)
		..Set INVUsrDate=##class(websys.Conversions).DateLogicalToHtml(INVUsrDate)
		..set RCPTTitle=""
		..set INVMoney=$p(^DHCSFPRINTDETAIL(INVID),"^",6)
		..set HospitalID=$p(^DHCSFPRINTDETAIL(INVID),"^",44)
		..set:HospitalID="" HospitalID=3
		..d OutInvNoInfo	
		
	}elseif (type="IP"){
		; 手工发票 DHC_INVPRTTJ
		for date=stDate:1:endDate  do
		.set INVID=""
		.for  set INVID=$o(^DHCINVPRTZY(0,"DATE",date,INVID)) quit:INVID=""  do
		..set INVStartInv=$p(^DHCINVPRTZY(INVID),"^",1)
		..quit:INVStartInv=""
		..set INVUsrDr=$p(^DHCINVPRTZY(INVID),"^",7)
		..set INVUsrCode=$p($g(^SSU("SSUSR",INVUsrDr)),"^",1)
		..set INVUsrName=$p($g(^SSU("SSUSR",INVUsrDr)),"^",2)
		..set INVUsrDate=$p(^DHCINVPRTZY(INVID),"^",2)
		..Set INVUsrDate=##class(websys.Conversions).DateLogicalToHtml(INVUsrDate)
		..set RCPTTitle=""
		..set INVMoney=$p(^DHCINVPRTZY(INVID),"^",6)
		..set HospitalID=$p(^DHCINVPRTZY(INVID),"^",35)
		..d OutInvNoInfo
	}elseif (type="OP"){
		; 门诊发票 DHC_INVPRT
		for date=stDate:1:endDate  do
		.set INVID=""
		.for  set INVID=$o(^DHCINVPRT(0,"Date",date,INVID)) quit:INVID=""  do
		..set INVStartInv=$p(^DHCINVPRT(INVID),"^",14)
		..quit:INVStartInv=""
		..set INVUsrDr=$p(^DHCINVPRT(INVID),"^",21)
		..set INVUsrCode=$p($g(^SSU("SSUSR",INVUsrDr)),"^",1)
		..set INVUsrName=$p($g(^SSU("SSUSR",INVUsrDr)),"^",2)
		..set INVUsrDate=$p(^DHCINVPRT(INVID),"^",5)
		..Set INVUsrDate=##class(websys.Conversions).DateLogicalToHtml(INVUsrDate)
		..set RCPTTitle=""
		..set INVMoney=$p(^DHCINVPRT(INVID),"^",1)
		..set HospitalID=$p(^DHCINVPRT(INVID),"^",39)
		..d OutInvNoInfo
	}	
	

	Quit $$$OK
OutInvNoInfo
	set Data=$lb(INVStartInv,INVUsrCode,INVUsrName,INVUsrDate,$fn(INVMoney,"",2),HospitalID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
