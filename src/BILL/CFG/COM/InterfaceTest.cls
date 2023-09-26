/// 接口测试
Class BILL.CFG.COM.InterfaceTest Extends %RegisteredObject
{

/// 说明：demo->计费系统管理->计费对外接口测试
/// ExpStr :ProductLine 产品线|Business 业务|HospDr|院区
/// w ##class(BILL.CFG.COM.InterfaceTest).DoSelfPayInterfaceMethod("<Request><TradeCode>4902</TradeCode><HospitalID></HospitalID><CardNo>0000006521</CardNo><CardType></CardType><SecrityNo>0</SecrityNo><PatientID></PatientID><UserCode>cashier</UserCode><TerminalID>ZZJ001</TerminalID><StartDate>2019-03-22</StartDate><EndDate>2019-03-22</EndDate><ExpStr></ExpStr></Request>")
ClassMethod DoSelfPayInterfaceMethod(RequestStr As %String, Class, Method, User, ExpStr)
{
	set ^Tempgqw("DoSelfPayInterfaceMethod")=$lb(RequestStr,Class,Method,User,ExpStr)
	if Class=""  d
	.set Class="DHCBILL.SelfPay.SOAP.SelfPaySoap"
	.set Method="DHCSelfPay"
	
	set RtnObj=""
	
	set RequestStr=$tr(RequestStr," ","")
	set RequestStr=$tr(RequestStr,$c(10),"")
	set RequestStr=$tr(RequestStr,$c(13),"")
	s ProductLine=$p(ExpStr,"|",1)
	s Business=$p(ExpStr,"|",2)
	s HospDr=$p(ExpStr,"|",3)
	//入参保存
	// 保存日志 2021-4-9 tangzf start
	s obj=##class(%ArrayOfDataTypes).%New()
	s UserCode=User //$p($g(^SSU("SSUSR",User)),"^",2)
	d obj.SetAt(UserCode,"INMSGUserCode") ; 收费员工号
    d obj.SetAt("","INMSGIPAdress")	; IP地址
    d obj.SetAt("","MAC")
    d obj.SetAt("","INMSGRegNo")
    d obj.SetAt("","INMSGInsuNo")
    d obj.SetAt("","INMSGAdmDr")
    d obj.SetAt("","INMSGInvPrtDr")
    d obj.SetAt("","INMSGPBDr")
    d obj.SetAt(+$h,"INMSGDate")
    d obj.SetAt($p($h,",",2),"INMSGTime")
    d obj.SetAt(+$h,"INMSGCliDate")
    d obj.SetAt($p($h,",",2),"INMSGC1iTime")
    d obj.SetAt(Business,"INMSGYWLX")
    d obj.SetAt("","INMSGC1iName")
    d obj.SetAt("","INMSGSolveFlag")	
    d obj.SetAt("","INMSGSolveUser")
    d obj.SetAt("","INMSGSolveDate")
    d obj.SetAt("","INMSGSolveTime")
    d obj.SetAt("","INMSGResolvent")
    d obj.SetAt(RequestStr,"INMSGMsg")
    d obj.SetAt(ProductLine,"INMSGProductLine") // 2020-6-19 产品线
    d obj.SetAt(HospDr,"INMSGHospDr") // 2020-6-19 院区
    d obj.SetAt("","INMSGBusinessId") // 2020-6-19 业务ID
    d obj.SetAt("I","INMSGParamType") // 2020-6-19 参数类型
	d ##class(INSU.COM.Tools).Log(obj,"array")
	//end
	s TmpOut=""
	set xstr="##class("_Class_")."_Method_"("	
	set xstr=xstr_""""_RequestStr_""""
	set xstr="s ^||DoSelfPayInterfaceMethod="_xstr
	set xstr=xstr_").Read()"
	XECUTE xstr
	s TmpOut=^||DoSelfPayInterfaceMethod
	b //do RtnObj.XMLExportToStream(.OutputStream,"Response")
	// 保存日志 2021-4-9 tangzf start
	// 出参保存
	s obj=##class(%ArrayOfDataTypes).%New()
	s UserCode=User //$p($g(^SSU("SSUSR",User)),"^",2)
	d obj.SetAt(UserCode,"INMSGUserCode") ; 收费员工号
    d obj.SetAt("","INMSGIPAdress")	; IP地址
    d obj.SetAt("","MAC")
    d obj.SetAt("","INMSGRegNo")
    d obj.SetAt("","INMSGInsuNo")
    d obj.SetAt("","INMSGAdmDr")
    d obj.SetAt("","INMSGInvPrtDr")
    d obj.SetAt("","INMSGPBDr")
    d obj.SetAt(+$h,"INMSGDate")
    d obj.SetAt($p($h,",",2),"INMSGTime")
    d obj.SetAt(+$h,"INMSGCliDate")
    d obj.SetAt($p($h,",",2),"INMSGC1iTime")
    d obj.SetAt(Business,"INMSGYWLX")
    d obj.SetAt("","INMSGC1iName")
    d obj.SetAt("","INMSGSolveFlag")	
    d obj.SetAt("","INMSGSolveUser")
    d obj.SetAt("","INMSGSolveDate")
    d obj.SetAt("","INMSGSolveTime")
    d obj.SetAt("","INMSGResolvent")
    d obj.SetAt(TmpOut,"INMSGMsg")
    d obj.SetAt(ProductLine,"INMSGProductLine") // 2020-6-19 产品线
    d obj.SetAt(HospDr,"INMSGHospDr") // 2020-6-19 院区
    d obj.SetAt("","INMSGBusinessId") // 2020-6-19 业务ID
    d obj.SetAt("O","INMSGParamType") // 2020-6-19 参数类型
	d ##class(INSU.COM.Tools).Log(obj,"array")
	s jsonstr="{"_"""result"""_":"_""""_TmpOut_""""_"}"
	
	Q jsonstr
}

/// 功能:查询自助机接口测试记录
/// 入参:
/// 出参:表DHC_SelfPayTest信息
/// 2019-3-26
/// d ##class(%ResultSet).RunQuery("DHCBILL.SelfPay.BLL.OutsideTest","GetSPayTestInfo","2019-03-26","2019-03-26","","","","","")
Query GetSPayTestInfo(StartDate As %String = "", EndDate As %String = "", TradeCode = "", CardNo = "", UserCode = "", ResultCode = "", AdmDr = "") As websys.Query(ROWSPEC = "SPTRowid:%String, SPTTradeCode:%String, SPTResultCode:%String, SPTCardNo:%String, SPTCardType:%String, SPTOrderNo:%String, SPTInvoiceNoStr:%String, SPTAdmDr:%String, SPTUserCode:%String, SPTTestDate:%String, SPTTestTime:%String, SPTRequest:%String, SPTResponse:%String") [ SqlProc ]
{
}

ClassMethod GetSPayTestInfoExecute(ByRef qHandle As %Binary, StartDate = "", EndDate = "", TradeCode = "", CardNo = "", UserCode = "", ResultCode = "", AdmDr = "") As %Status
{
	set repid=$I(^CacheTemp)
	if $g(ind)="" Set ind=1
	set qHandle=$lb(0,repid,0)
	s ^CacheTempgqw("SPayTestInfo")=$lb(StartDate,EndDate,TradeCode,CardNo,UserCode,ResultCode,AdmDr)
	
	q:(StartDate=""||EndDate="")&&(TradeCode="")&&(AdmDr="") $$$OK
	
	;入参初始化
	d iniInStr 
	;日期多条件查询
	if (StartDate'="")  d
	.for date=StartDate:1:EndDate  d
	..set SPTDr=""
	..for  set SPTDr=$O(^DHCSELFPAYTESTi("0","TESTDATE",date,SPTDr),-1) Quit:SPTDr=""  d
	...set SPayTestInfo=^DHCSELFPAYTEST(SPTDr)
	...Quit:(TradeCode'="")&&($P(SPayTestInfo,"^",1)'=TradeCode)
	...Quit:(ResultCode'="")&&($P(SPayTestInfo,"^",2)'=ResultCode)
	...Quit:(CardNo'="")&&($P(SPayTestInfo,"^",3)'=CardNo)
	...Quit:(AdmDr'="")&&($P(SPayTestInfo,"^",7)'=AdmDr)
	...Quit:(UserCode'="")&&($P(SPayTestInfo,"^",8)'=UserCode)
	...d BuildSPayTest
	;单条件查询
	else  d
	.for  set SPTDr=$O(^DHCSELFPAYTESTi("0",Type,ValPara,SPTDr),-1) Quit:SPTDr=""  d
	..set SPayTestInfo=^DHCSELFPAYTEST(SPTDr)
	..d BuildSPayTest		
	Quit $$$OK	 
BuildSPayTest
	set SPTRowid=SPTDr
	set SPTTradeCode=$P(SPayTestInfo,"^",1)
	set SPTTradeDesc=$case(SPTTradeCode,"4902":"查询就诊记录","4904":"获取待缴费结算单","4905":"HIS预结算","4906":"收费确认完成","4907":"获取已缴费记录","4908":"获取已缴费记录及明细","4909":"扣费结果查证","4910":"撤销预结算","4801":"获取患者基本信息及账户信息","4802":"院内账户预交金充值","5001":"获取有效就诊记录","5002":"住院押金充值","5003":"押金记录查询",:"其他")
	set SPTTradeCode="("_SPTTradeCode_")"_SPTTradeDesc
	
	set SPTResultCode=$P(SPayTestInfo,"^",2)
	set SPTResultDesc=$case(SPTResultCode,"0":"成功","-1":"失败",:"其他")
	set SPTResultCode="("_SPTResultCode_")"_SPTResultDesc
	
	set SPTCardNo=$P(SPayTestInfo,"^",3)
	set SPTCardType=$P(SPayTestInfo,"^",4)
	set SPTOrderNo=$P(SPayTestInfo,"^",5)
	set SPTInvoiceNoStr=$P(SPayTestInfo,"^",6)
	set SPTAdmDr=$P(SPayTestInfo,"^",7)
	set SPTUserCode=$P(SPayTestInfo,"^",8)
	set SPTTestDate=$ZD($P(SPayTestInfo,"^",9),3)
	set SPTTestTime=$Zt($P(SPayTestInfo,"^",10),3)
	set SPTRequest=$P(SPayTestInfo,"^",11)
	set SPTResponse=$P(SPayTestInfo,"^",12)
	s data=$lb(SPTRowid,SPTTradeCode,SPTResultCode,SPTCardNo,SPTCardType,SPTOrderNo,SPTInvoiceNoStr,SPTAdmDr,SPTUserCode,SPTTestDate,SPTTestTime,SPTRequest,SPTResponse)
    s ^CacheTemp(repid,ind)=data
    s ind=ind+1
    quit
iniInStr
	;StartDate_","_EndDate = ","_TradeCode = ","_CardNo_","_UserCode_","_ResultCode_","_AdmDr
	set (SPTDr,Type,ValPara)=""
	set:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	//查询方式
	if UserCode'="" d
	.set ValPara=UserCode,Type="UserCode"
	else  if TradeCode'=""  d
	.set ValPara=TradeCode,Type="TRADE"		;有索引
	else  if CardNo'=""  d
	.set ValPara=CardNo,Type="CardNo"
	else  if ResultCode'=""  d
	.set ValPara=ResultCode,Type="ResultCode"
	else  if AdmDr'=""  d
	.set ValPara=AdmDr,Type="ADM"			;有索引
	Quit
}

/// d ##class(%ResultSet).RunQuery("DHCBILLConfig.DHCBILLOthConfig","FindGroupUser",1,"","2")
Query FindGroupUser(Grp As %String, Usr As %String, HospId As %String) As websys.Query(ROWSPEC = "TUsrRowid:%String,TUsrName:%String,TUsrCode")
{
}

ClassMethod FindGroupUserExecute(ByRef qHandle As %Binary, Grp As %String, Usr As %String, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1

	If (Grp="") Do
	.Set usrrowid="0"
	.For  Set usrrowid=$o(^SSU("SSUSR",usrrowid)) Quit:(usrrowid="")  Do
	..Set usrname=$p($g(^SSU("SSUSR",usrrowid)),"^",2)
	..Quit:((Usr'="")&&(usrname'[Usr))
	..Do OutputGrpUsr
	If (Grp="")  Quit $$$OK
	
	Kill UserArray
	Set usrrowid="0"
	For  Set usrrowid=$o(^SSU("SSUSR",usrrowid)) Quit:(usrrowid="")  Do
	.Set DefaultGrp=$p($g(^SSU("SSUSR",usrrowid)),"^",5)
	.If (DefaultGrp=Grp) Do
	..Set usrname=$p(^SSU("SSUSR",usrrowid),"^",2)
	..Quit:((Usr'="")&&(usrname'[Usr))
	..Quit:$d(UserArray(usrrowid))
	..Set UserArray(usrrowid)=usrrowid
	..Do OutputGrpUsr
	.Else  Do
	..Set Sub="0"
	..For  Set Sub=$o(^SSU("SSUSR",usrrowid,"OTHLL",Sub)) Quit:(Sub="")  Do
	...Set usrgrp=$p(^SSU("SSUSR",usrrowid,"OTHLL",Sub),"^",2)
	...Quit:((Grp'="")&&(Grp'=usrgrp))
	...Set usrname=$p(^SSU("SSUSR",usrrowid),"^",2)
	...Quit:((Usr'="")&&(usrname'[Usr))
	...Quit:$d(UserArray(usrrowid))
	...Set UserArray(usrrowid)=usrrowid
	...Do OutputGrpUsr

	Quit $$$OK
OutputGrpUsr
	Set Data=$lb(usrrowid,usrname,$p(^SSU("SSUSR",usrrowid),"^",1))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	Quit
}

ClassMethod BuildTestInput(PortCode)
{
	s input="SELFPAY^"_"4902"_"^2^1^0^102^1^4409^10590"
	s rtn=##class(INSU.OFFBIZ.BL.BIZ00A).InsuSettlementUL(input,"STR","XML")
	s rtn=$p(rtn,"<input>","2")
	s rtn=$p(rtn,"</input>",1)
	q rtn
}

}
